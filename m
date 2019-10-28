Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 91699E7011
	for <lists+netdev@lfdr.de>; Mon, 28 Oct 2019 11:59:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388427AbfJ1K7U (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Oct 2019 06:59:20 -0400
Received: from s3.sipsolutions.net ([144.76.43.62]:39554 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728554AbfJ1K7T (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Oct 2019 06:59:19 -0400
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.92.2)
        (envelope-from <johannes@sipsolutions.net>)
        id 1iP2jv-0001RV-NJ; Mon, 28 Oct 2019 11:59:11 +0100
Message-ID: <b950c974d921fe3b2b7b05eb416d313858b3ed11.camel@sipsolutions.net>
Subject: Re: pull-request: mac80211-next 2019-07-31
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Arnd Bergmann <arnd@arndb.de>
Cc:     David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        John Crispin <john@phrozen.org>
Date:   Mon, 28 Oct 2019 11:59:10 +0100
In-Reply-To: <CAK8P3a2BiDYXR-x_RyAOLZL_dL6m49JMy13U5VQ_gp9MbLfGGA@mail.gmail.com>
References: <20190731155057.23035-1-johannes@sipsolutions.net>
         <CAK8P3a10Gz_aDaOKBDtoPyaUc-OuCmn2buY4+GHHdWERnU+jrg@mail.gmail.com>
         <2f64367daad256b1f1999797786763fa8091faa1.camel@sipsolutions.net>
         <CAK8P3a2BiDYXR-x_RyAOLZL_dL6m49JMy13U5VQ_gp9MbLfGGA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.30.5 (3.30.5-1.fc29) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 2019-10-28 at 11:53 +0100, Arnd Bergmann wrote:
> On Mon, Oct 28, 2019 at 10:52 AM Johannes Berg
> <johannes@sipsolutions.net> wrote:
> > > It looks like one of the last additions pushed the stack usage over
> > > the 1024 byte limit
> > > for 32-bit architectures:
> > > 
> > > net/mac80211/mlme.c:4063:6: error: stack frame size of 1032 bytes in
> > > function 'ieee80211_sta_rx_queued_mgmt' [-Werror,-Wframe-larger-than=]
> > > 
> > > struct ieee802_11_elems is fairly large, and just grew another two pointers.
> > > When ieee80211_rx_mgmt_assoc_resp() and ieee80211_assoc_success()
> > > are inlined into ieee80211_sta_rx_queued_mgmt(), there are three copies
> > > of this structure, which is slightly too much.
> > 
> > Hmm. I guess that means the compiler isn't smart enough to make the
> > copies from the inlined sub-functions alias each other? I mean, if I
> > have
> > 
> > fn1(...) { struct ... elems1; ... }
> > fn2(...) { struct ... elems2; ... }
> > 
> > fn(...)
> > {
> >   fn1();
> >   fn2();
> > }
> > 
> > then it could reasonably use the same stack memory for elems1 and
> > elems2, at least theoretically, but you're saying it doesn't do that I
> > guess?
> 
> No, that's not the problem here (it can happen if the compiler is
> unable to prove the object lifetimes are non-overlapping).
> 
> What we have here are multiple functions that are in the same call chain:
> 
> fn1()
> {
>      struct ieee802_11_elems e ;
> }
> 
> fn2()
> {
>    struct ieee802_11_elems e;
>   ...
>    fn1();
> }
> 
> fn3()
> {
>    struct ieee802_11_elems e;
>   ...
>    fn2();
> }
> 
> Here, the object lifetimes actually do overlap, so the compiler cannot easily
> optimize that away.

Ah, yes, you're right. I didn't look closely enough, sorry.

> > I don't think dynamic allocation would be nice - but we could manually
> > do this by passing the elems pointer into the
> > ieee80211_rx_mgmt_assoc_resp() and ieee80211_assoc_success() functions.
> 
> Ah, so you mean we can reuse the objects manually? I think that would
> be great. I could not tell if that's possible when reading the source, but
> if you can show that this works, that would be an easy solution.

Now that I look more closely, I'm not even sure why we parse it again in
ieee80211_assoc_success() after already having done it in
_rx_mgmt_assoc_resp(), they're doing exactly the same thing:

        ieee802_11_parse_elems(pos, len - (pos - (u8 *)mgmt), false, &elems,
                               mgmt->bssid, assoc_data->bss->bssid);

(need to track the variables a bit more closely, but ...)

So I think we can even just avoid duplicate work.

And for the third copy - it's in a different switch case. Do you think
we could rely on the compiler being able to prove non-overlapping
lifetime? Or better to just pass a pointer down to
_rx_mgmt_assoc_resp()?

> > Why do you say 32-bit btw, it should be *bigger* on 64-bit, but I didn't
> > see this ... hmm.
> 
> That is correct. For historic reasons, both the total amount of stack space
> per thread and the warning limit on 64 bit are twice the amount that we
> have on 32-bit kernels, so even though the problem is more serious on
> 64-bit architectures, we do not see a warning about it because we remain
> well under the warning limit.

Ah, ok, thanks.

johannes


