Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C868BE6F5E
	for <lists+netdev@lfdr.de>; Mon, 28 Oct 2019 10:52:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388082AbfJ1JwD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Oct 2019 05:52:03 -0400
Received: from s3.sipsolutions.net ([144.76.43.62]:38688 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730038AbfJ1JwC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Oct 2019 05:52:02 -0400
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.92.2)
        (envelope-from <johannes@sipsolutions.net>)
        id 1iP1gm-0008Hv-QM; Mon, 28 Oct 2019 10:51:52 +0100
Message-ID: <2f64367daad256b1f1999797786763fa8091faa1.camel@sipsolutions.net>
Subject: Re: pull-request: mac80211-next 2019-07-31
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Arnd Bergmann <arnd@arndb.de>
Cc:     David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        John Crispin <john@phrozen.org>
Date:   Mon, 28 Oct 2019 10:51:51 +0100
In-Reply-To: <CAK8P3a10Gz_aDaOKBDtoPyaUc-OuCmn2buY4+GHHdWERnU+jrg@mail.gmail.com> (sfid-20191021_214031_055015_91C0B8BC)
References: <20190731155057.23035-1-johannes@sipsolutions.net>
         <CAK8P3a10Gz_aDaOKBDtoPyaUc-OuCmn2buY4+GHHdWERnU+jrg@mail.gmail.com>
         (sfid-20191021_214031_055015_91C0B8BC)
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.30.5 (3.30.5-1.fc29) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Arnd,

> It looks like one of the last additions pushed the stack usage over
> the 1024 byte limit
> for 32-bit architectures:
> 
> net/mac80211/mlme.c:4063:6: error: stack frame size of 1032 bytes in
> function 'ieee80211_sta_rx_queued_mgmt' [-Werror,-Wframe-larger-than=]
> 
> struct ieee802_11_elems is fairly large, and just grew another two pointers.
> When ieee80211_rx_mgmt_assoc_resp() and ieee80211_assoc_success()
> are inlined into ieee80211_sta_rx_queued_mgmt(), there are three copies
> of this structure, which is slightly too much.

Hmm. I guess that means the compiler isn't smart enough to make the
copies from the inlined sub-functions alias each other? I mean, if I
have

fn1(...) { struct ... elems1; ... }
fn2(...) { struct ... elems2; ... }

fn(...)
{
  fn1();
  fn2();
}

then it could reasonably use the same stack memory for elems1 and
elems2, at least theoretically, but you're saying it doesn't do that I
guess?

It could even do that for different BBs, in theory ...

If it does, I'd have suggested to move the code from the outer function
inside the "case IEEE80211_STYPE_ACTION:" block into a new sub-function, 
but that won't work then.

I don't think dynamic allocation would be nice - but we could manually
do this by passing the elems pointer into the
ieee80211_rx_mgmt_assoc_resp() and ieee80211_assoc_success() functions.


Why do you say 32-bit btw, it should be *bigger* on 64-bit, but I didn't
see this ... hmm.

johannes

