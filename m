Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AC5A445EF3A
	for <lists+netdev@lfdr.de>; Fri, 26 Nov 2021 14:36:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351067AbhKZNji (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Nov 2021 08:39:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51408 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235745AbhKZNhi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Nov 2021 08:37:38 -0500
Received: from nbd.name (nbd.name [IPv6:2a01:4f8:221:3d45::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0092FC061D60;
        Fri, 26 Nov 2021 04:47:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nbd.name;
         s=20160729; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:Subject:
        From:References:Cc:To:MIME-Version:Date:Message-ID:Sender:Reply-To:Content-ID
        :Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:
        Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe
        :List-Post:List-Owner:List-Archive;
        bh=yPU8L7bF8Dbr+OQK4JN8D/7w1vO9Hg+sl5nwkjTHnSI=; b=R4A997KMAT/PtNn+VO3qhUIEgc
        2vA7QhsWK0ayenrF3vt6tR39lw3fJcvWlCn18DG7AOJxbNFd7xsn2Ho+E2lzJkVIevWdQ6WVV2o6H
        ySAm4rygQ9bC3nif7/ECCGyxZMSZmc0mH27XBmIsVDYbVoRT3oBxKfJ9AjQ+pfXNs4nE=;
Received: from p54ae9f3f.dip0.t-ipconnect.de ([84.174.159.63] helo=nf.local)
        by ds12 with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.89)
        (envelope-from <nbd@nbd.name>)
        id 1mqadA-0005h2-JT; Fri, 26 Nov 2021 13:47:08 +0100
Message-ID: <e098a58a-8ec0-f90d-dbc9-7b621e31d051@nbd.name>
Date:   Fri, 26 Nov 2021 13:47:07 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.3.2
Content-Language: en-US
To:     Peter Seiderer <ps.report@gmx.net>, linux-wireless@vger.kernel.org
Cc:     Johannes Berg <johannes@sipsolutions.net>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
References: <20211116212828.27613-1-ps.report@gmx.net>
From:   Felix Fietkau <nbd@nbd.name>
Subject: Re: [RFC v2] mac80211: minstrel_ht: do not set RTS/CTS flag for
 fallback rates
In-Reply-To: <20211116212828.27613-1-ps.report@gmx.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2021-11-16 22:28, Peter Seiderer wrote:
> Despite the 'RTS thr:off' setting a wireshark trace of IBSS
> traffic with HT40 mode enabled between two ath9k cards revealed
> some RTS/CTS traffic.
> 
> Debug and code analysis showed that most places setting
> IEEE80211_TX_RC_USE_RTS_CTS respect the RTS strategy by
> evaluating rts_threshold, e.g. net/mac80211/tx.c:
> 
>   698         /* set up RTS protection if desired */
>   699         if (len > tx->local->hw.wiphy->rts_threshold) {
>   700                 txrc.rts = true;
>   701         }
>   702
>   703         info->control.use_rts = txrc.rts;
> 
> or drivers/net/wireless/ath/ath9k/xmit.c
> 
> 1238                 /*
> 1239                  * Handle RTS threshold for unaggregated HT frames.
> 1240                  */
> 1241                 if (bf_isampdu(bf) && !bf_isaggr(bf) &&
> 1242                     (rates[i].flags & IEEE80211_TX_RC_MCS) &&
> 1243                     unlikely(rts_thresh != (u32) -1)) {
> 1244                         if (!rts_thresh || (len > rts_thresh))
> 1245                                 rts = true;
> 1246                 }
> 
> The only place setting IEEE80211_TX_RC_USE_RTS_CTS unconditionally
> was found in net/mac80211/rc80211_minstrel_ht.c.
> 
> As the use_rts value is only calculated after hitting the minstrel_ht code
> preferre to not set IEEE80211_TX_RC_USE_RTS_CTS (and overruling the
> RTS threshold setting) for the fallback rates case.
The idea behind the this part of minstrel_ht code is to avoid the 
overhead of RTS/CTS for transmissions using the primary rate and to 
increase the reliability of retransmissions by adding it for fallback 
rates. This is completely unrelated to the RTS threshold.

If you don't want this behavior, I'm fine with adding a way to 
explicitly disable it. However, I do think leaving it on by default 
makes sense.

- Felix
