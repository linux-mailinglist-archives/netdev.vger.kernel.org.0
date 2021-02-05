Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ABC2D310F8B
	for <lists+netdev@lfdr.de>; Fri,  5 Feb 2021 19:10:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233673AbhBEQ0U (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Feb 2021 11:26:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40486 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233678AbhBEQX5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 5 Feb 2021 11:23:57 -0500
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 48C1DC06178B;
        Fri,  5 Feb 2021 10:05:37 -0800 (PST)
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.94)
        (envelope-from <johannes@sipsolutions.net>)
        id 1l85U1-00GNbQ-8w; Fri, 05 Feb 2021 19:05:29 +0100
Message-ID: <15f435a791b0c4b853c8c6b284042c7057d6efaf.camel@sipsolutions.net>
Subject: Re: Potential invalid ~ operator in net/mac80211/cfg.c
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Colin Ian King <colin.king@canonical.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Date:   Fri, 05 Feb 2021 19:05:13 +0100
In-Reply-To: <4bb65f2f-48f9-7d9c-ab2e-15596f15a4d8@canonical.com>
References: <4bb65f2f-48f9-7d9c-ab2e-15596f15a4d8@canonical.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-malware-bazaar: not-scanned
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Colin,

> while working through a backlog of older static analysis reports from
> Coverity

So ... yeah. Every time I look at Coverity (not frequently, I must
admit) I see the same thing, and get confused.

> I found an interesting use of the ~ operator that looks
> incorrect to me in function ieee80211_set_bitrate_mask():
> 
>                 for (j = 0; j < IEEE80211_HT_MCS_MASK_LEN; j++) {
>                         if (~sdata->rc_rateidx_mcs_mask[i][j]) {
>                                 sdata->rc_has_mcs_mask[i] = true;
>                                 break;
>                         }
>                 }
> 
>                 for (j = 0; j < NL80211_VHT_NSS_MAX; j++) {
>                         if (~sdata->rc_rateidx_vht_mcs_mask[i][j]) {
>                                 sdata->rc_has_vht_mcs_mask[i] = true;
>                                 break;
>                         }
>                 }
> 
> For the ~ operator in both if stanzas, Coverity reports:
> 
> Logical vs. bitwise operator (CONSTANT_EXPRESSION_RESULT)
> logical_vs_bitwise:
> 
> ~sdata->rc_rateidx_mcs_mask[i][j] is always 1/true regardless of the
> values of its operand. This occurs as the logical operand of if.
>     Did you intend to use ! rather than ~?
> 
> I've checked the results of this and it does seem that ~ is incorrect
> and always returns true for the if expression. So it probably should be
> !, but I'm not sure if I'm missing something deeper here and wondering
> why this has always worked.

But is it really always true?

I _think_ it was intended to check that it's not 0xffffffff or
something?

https://lore.kernel.org/linux-wireless/516C0C7F.3000204@openwrt.org/

But maybe that isn't actually quite right due to integer promotion?
OTOH, that's a u8, so it should do the ~ in u8 space, and then compare
to 0 also?

johannes

