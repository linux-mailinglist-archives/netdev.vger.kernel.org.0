Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 433AD3AA4D5
	for <lists+netdev@lfdr.de>; Wed, 16 Jun 2021 21:58:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231490AbhFPUAj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Jun 2021 16:00:39 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:41294 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230146AbhFPUAi (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 16 Jun 2021 16:00:38 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=fcslSM9/6MRiE2SDDYPLby1GlnJ9ZaMIEGgZGgA2bB0=; b=N7JF205bBrf9sTmwL3dJzth2Hp
        vW2mN4gxsQ0WL4L5TQr9SruYoV87O8I9Jk5X7NxTmdQAEq/OzQffsRUim0edC9o35mayxASJBVflf
        2920MNzBmLCXA+Ske0mJbEMzF3ElCU03b8N0xrovwpuRa2sV3Iz28OMp0reU2Ix9PS5I=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1ltbft-009lvo-2z; Wed, 16 Jun 2021 21:58:09 +0200
Date:   Wed, 16 Jun 2021 21:58:09 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Kees Cook <keescook@chromium.org>
Cc:     netdev@vger.kernel.org, Lennert Buytenhek <buytenh@wantstofly.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Romain Perier <romain.perier@gmail.com>,
        Allen Pais <allen.lkml@gmail.com>,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        wengjianfeng <wengjianfeng@yulong.com>,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Lv Yunlong <lyl2019@mail.ustc.edu.cn>,
        linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
        linux-hardening@vger.kernel.org
Subject: Re: [PATCH] mwl8k: Avoid memcpy() over-reading of ETH_SS_STATS
Message-ID: <YMpX0S/Xeis0kKoP@lunn.ch>
References: <20210616195242.1231287-1-keescook@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210616195242.1231287-1-keescook@chromium.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 16, 2021 at 12:52:42PM -0700, Kees Cook wrote:
> In preparation for FORTIFY_SOURCE performing compile-time and run-time
> field bounds checking for memcpy(), memmove(), and memset(), avoid
> intentionally reading across neighboring array fields. Use the
> sub-structure address directly.
> 
> Signed-off-by: Kees Cook <keescook@chromium.org>
> ---
>  drivers/net/wireless/marvell/mwl8k.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/net/wireless/marvell/mwl8k.c b/drivers/net/wireless/marvell/mwl8k.c
> index 84b32a5f01ee..3bf6571f4149 100644
> --- a/drivers/net/wireless/marvell/mwl8k.c
> +++ b/drivers/net/wireless/marvell/mwl8k.c
> @@ -4552,7 +4552,7 @@ static int mwl8k_cmd_update_stadb_add(struct ieee80211_hw *hw,
>  	else
>  		rates = sta->supp_rates[NL80211_BAND_5GHZ] << 5;
>  	legacy_rate_mask_to_array(p->legacy_rates, rates);
> -	memcpy(p->ht_rates, sta->ht_cap.mcs.rx_mask, 16);
> +	memcpy(p->ht_rates, &sta->ht_cap.mcs, 16);
>  	p->interop = 1;
>  	p->amsdu_enabled = 0;
>  
> @@ -5034,7 +5034,7 @@ mwl8k_bss_info_changed_sta(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
>  			ap_legacy_rates =
>  				ap->supp_rates[NL80211_BAND_5GHZ] << 5;
>  		}
> -		memcpy(ap_mcs_rates, ap->ht_cap.mcs.rx_mask, 16);
> +		memcpy(ap_mcs_rates, &ap->ht_cap.mcs, 16);
>  
>  		rcu_read_unlock();

This does not appear to have anything to do with ETH_SS_STATS which is
what the Subject: says.

     Andrew
