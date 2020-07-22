Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F141A2298C1
	for <lists+netdev@lfdr.de>; Wed, 22 Jul 2020 14:57:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732398AbgGVM4a (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Jul 2020 08:56:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37134 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726161AbgGVM43 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Jul 2020 08:56:29 -0400
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C8FFC0619DC;
        Wed, 22 Jul 2020 05:56:29 -0700 (PDT)
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.93)
        (envelope-from <johannes@sipsolutions.net>)
        id 1jyEID-0094yK-6w; Wed, 22 Jul 2020 14:56:17 +0200
Message-ID: <0dbdef912f9d61521011f638200fd451a3530568.camel@sipsolutions.net>
Subject: Re: [RFC 1/7] mac80211: Add check for napi handle before WARN_ON
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Rakesh Pillai <pillair@codeaurora.org>, ath10k@lists.infradead.org
Cc:     linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvalo@codeaurora.org, davem@davemloft.net, kuba@kernel.org,
        netdev@vger.kernel.org, dianders@chromium.org, evgreen@chromium.org
Date:   Wed, 22 Jul 2020 14:56:00 +0200
In-Reply-To: <1595351666-28193-2-git-send-email-pillair@codeaurora.org>
References: <1595351666-28193-1-git-send-email-pillair@codeaurora.org>
         <1595351666-28193-2-git-send-email-pillair@codeaurora.org>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.3 (3.36.3-1.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 2020-07-21 at 22:44 +0530, Rakesh Pillai wrote:
> The function ieee80211_rx_napi can be now called
> from a thread context as well, with napi context
> being NULL.
> 
> Hence add the napi context check before giving out
> a warning for softirq count being 0.
> 
> Tested-on: WCN3990 hw1.0 SNOC WLAN.HL.3.1-01040-QCAHLSWMTPLZ-1
> 
> Signed-off-by: Rakesh Pillai <pillair@codeaurora.org>
> ---
>  net/mac80211/rx.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
> index a88ab6f..1e703f1 100644
> --- a/net/mac80211/rx.c
> +++ b/net/mac80211/rx.c
> @@ -4652,7 +4652,7 @@ void ieee80211_rx_napi(struct ieee80211_hw *hw, struct ieee80211_sta *pubsta,
>  	struct ieee80211_supported_band *sband;
>  	struct ieee80211_rx_status *status = IEEE80211_SKB_RXCB(skb);
>  
> -	WARN_ON_ONCE(softirq_count() == 0);
> +	WARN_ON_ONCE(napi && softirq_count() == 0);

FWIW, I'm pretty sure this is incorrect - we make assumptions on
softirqs being disabled in mac80211 for serialization and in place of
some locking, I believe.

johannes

