Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3AA002CA218
	for <lists+netdev@lfdr.de>; Tue,  1 Dec 2020 13:07:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388028AbgLAMHF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Dec 2020 07:07:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51998 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726862AbgLAMHF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Dec 2020 07:07:05 -0500
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CEAE9C0613D2;
        Tue,  1 Dec 2020 04:06:24 -0800 (PST)
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.94)
        (envelope-from <johannes@sipsolutions.net>)
        id 1kk4QB-000UkK-Gu; Tue, 01 Dec 2020 13:06:15 +0100
Message-ID: <a6eb69000eb33ca8f59cbaff2afee205e0877eb8.camel@sipsolutions.net>
Subject: Re: [PATCH] net: mac80211: cfg: enforce sanity checks for key_index
 in ieee80211_del_key()
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Anant Thazhemadam <anant.thazhemadam@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        syzbot+49d4cab497c2142ee170@syzkaller.appspotmail.com
Date:   Tue, 01 Dec 2020 13:06:01 +0100
In-Reply-To: <1e5e4471-5cf4-6d23-6186-97f764f4d25f@gmail.com> (sfid-20201201_125644_293555_F8FBDA46)
References: <20201201095639.63936-1-anant.thazhemadam@gmail.com>
         <3025db173074d4dfbc323e91d3586f0e36426cf0.camel@sipsolutions.net>
         <1e5e4471-5cf4-6d23-6186-97f764f4d25f@gmail.com>
         (sfid-20201201_125644_293555_F8FBDA46)
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-1.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-malware-bazaar: not-scanned
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 2020-12-01 at 17:26 +0530, Anant Thazhemadam wrote:
> On 01/12/20 3:30 pm, Johannes Berg wrote:
> > On Tue, 2020-12-01 at 15:26 +0530, Anant Thazhemadam wrote:
> > > Currently, it is assumed that key_idx values that are passed to
> > > ieee80211_del_key() are all valid indexes as is, and no sanity checks
> > > are performed for it.
> > > However, syzbot was able to trigger an array-index-out-of-bounds bug
> > > by passing a key_idx value of 5, when the maximum permissible index
> > > value is (NUM_DEFAULT_KEYS - 1).
> > > Enforcing sanity checks helps in preventing this bug, or a similar
> > > instance in the context of ieee80211_del_key() from occurring.
> > I think we should do this more generally in cfg80211, like in
> > nl80211_new_key() we do it via cfg80211_validate_key_settings().
> > 
> > I suppose we cannot use the same function, but still, would be good to
> > address this generally in nl80211 for all drivers.
> 
> Hello,
> 
> This gave me the idea of trying to use cfg80211_validate_key_settings()
> directly in ieee80211_del_key(). I did try that out, tested it, and this bug
> doesn't seem to be getting triggered anymore.
> If this is okay, then I can send in a v2 soon. :)
> 
> If there is any reason that I'm missing as to why cfg80211_validate_key_settings()
> cannot be used in this context, please let me know.

If it works then I guess that's OK. I thought we didn't have all the
right information, e.g. whether a key is pairwise or not?

johannes

