Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 494B9441AEF
	for <lists+netdev@lfdr.de>; Mon,  1 Nov 2021 12:55:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232198AbhKAL5g (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Nov 2021 07:57:36 -0400
Received: from lelv0143.ext.ti.com ([198.47.23.248]:37194 "EHLO
        lelv0143.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231749AbhKAL5f (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Nov 2021 07:57:35 -0400
Received: from lelv0265.itg.ti.com ([10.180.67.224])
        by lelv0143.ext.ti.com (8.15.2/8.15.2) with ESMTP id 1A1BseA2060740;
        Mon, 1 Nov 2021 06:54:40 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1635767680;
        bh=2dgNY8wPpf6OE6HI1zV7ejQY5Hf4/jtI8BNRxMVKOyc=;
        h=Subject:To:CC:References:From:Date:In-Reply-To;
        b=v72f+4WARDXc6dw9gcw7IoxovuPSfbUlOAivkvJDHjNrLHhiOgTjgxu9A7JrtiR0X
         pjZ/gh8fvybblfe0Qia1JpR7jNa+KU6JJCDoHOSatyGQWo+IuRELSalVcIwK+hsLVE
         mG9bfDlBAD1c5vkB209Fx5POeyhswjhDPH9dNTwo=
Received: from DLEE114.ent.ti.com (dlee114.ent.ti.com [157.170.170.25])
        by lelv0265.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 1A1Bse0h127590
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Mon, 1 Nov 2021 06:54:40 -0500
Received: from DLEE104.ent.ti.com (157.170.170.34) by DLEE114.ent.ti.com
 (157.170.170.25) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2308.14; Mon, 1
 Nov 2021 06:54:40 -0500
Received: from fllv0040.itg.ti.com (10.64.41.20) by DLEE104.ent.ti.com
 (157.170.170.34) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2308.14 via
 Frontend Transport; Mon, 1 Nov 2021 06:54:40 -0500
Received: from [10.250.100.73] (ileax41-snat.itg.ti.com [10.172.224.153])
        by fllv0040.itg.ti.com (8.15.2/8.15.2) with ESMTP id 1A1Bsa17006715;
        Mon, 1 Nov 2021 06:54:37 -0500
Subject: Re: [PATCH] net: davinci_emac: Fix interrupt pacing disable
To:     Maxim Kiselev <bigunclemax@gmail.com>
CC:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Yang Yingliang <yangyingliang@huawei.com>,
        Colin Ian King <colin.king@canonical.com>,
        Yufeng Mo <moyufeng@huawei.com>,
        Michael Walle <michael@walle.cc>, Sriram <srk@ti.com>,
        <linux-omap@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
References: <20211101092134.3357661-1-bigunclemax@gmail.com>
From:   Grygorii Strashko <grygorii.strashko@ti.com>
Message-ID: <717f9769-aac5-d005-e15a-a6a2ff61bb69@ti.com>
Date:   Mon, 1 Nov 2021 13:54:25 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <20211101092134.3357661-1-bigunclemax@gmail.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 01/11/2021 11:21, Maxim Kiselev wrote:
> This patch allows to use 0 for `coal->rx_coalesce_usecs` param to
> disable rx irq coalescing.
> 
> Previously we could enable rx irq coalescing via ethtool
> (For ex: `ethtool -C eth0 rx-usecs 2000`) but we couldn't disable
> it because this part rejects 0 value:
> 
>         if (!coal->rx_coalesce_usecs)
>                 return -EINVAL;
> 
> Fixes: 84da2658a619 ("TI DaVinci EMAC : Implement interrupt pacing
> functionality.")
> 
> Signed-off-by: Maxim Kiselev <bigunclemax@gmail.com>
> ---
>   drivers/net/ethernet/ti/davinci_emac.c | 77 ++++++++++++++------------
>   1 file changed, 41 insertions(+), 36 deletions(-)
> 
> diff --git a/drivers/net/ethernet/ti/davinci_emac.c b/drivers/net/ethernet/ti/davinci_emac.c
> index e8291d8488391..a3a02c4e5eb68 100644
> --- a/drivers/net/ethernet/ti/davinci_emac.c
> +++ b/drivers/net/ethernet/ti/davinci_emac.c
> @@ -417,46 +417,47 @@ static int emac_set_coalesce(struct net_device *ndev,
>   			     struct netlink_ext_ack *extack)
>   {
>   	struct emac_priv *priv = netdev_priv(ndev);
> -	u32 int_ctrl, num_interrupts = 0;
> +	u32 int_ctrl = 0, num_interrupts = 0;
>   	u32 prescale = 0, addnl_dvdr = 1, coal_intvl = 0;
>   
> -	if (!coal->rx_coalesce_usecs)
> -		return -EINVAL;
> -
>   	coal_intvl = coal->rx_coalesce_usecs;

Wouldn't be more simple if you just handle !coal->rx_coalesce_usecs here and exit?
it seems you can just write 0 t0 INTCTRL.

>   
>   	switch (priv->version) {
>   	case EMAC_VERSION_2:
> -		int_ctrl =  emac_ctrl_read(EMAC_DM646X_CMINTCTRL);
> -		prescale = priv->bus_freq_mhz * 4;
> -
> -		if (coal_intvl < EMAC_DM646X_CMINTMIN_INTVL)
> -			coal_intvl = EMAC_DM646X_CMINTMIN_INTVL;
> -
> -		if (coal_intvl > EMAC_DM646X_CMINTMAX_INTVL) {
> -			/*
> -			 * Interrupt pacer works with 4us Pulse, we can
> -			 * throttle further by dilating the 4us pulse.
> -			 */
> -			addnl_dvdr = EMAC_DM646X_INTPRESCALE_MASK / prescale;
> -
> -			if (addnl_dvdr > 1) {
> -				prescale *= addnl_dvdr;
> -				if (coal_intvl > (EMAC_DM646X_CMINTMAX_INTVL
> -							* addnl_dvdr))
> -					coal_intvl = (EMAC_DM646X_CMINTMAX_INTVL
> -							* addnl_dvdr);
> -			} else {
> -				addnl_dvdr = 1;
> -				coal_intvl = EMAC_DM646X_CMINTMAX_INTVL;
> +		if (coal->rx_coalesce_usecs) {
> +			int_ctrl =  emac_ctrl_read(EMAC_DM646X_CMINTCTRL);
> +			prescale = priv->bus_freq_mhz * 4;
> +
> +			if (coal_intvl < EMAC_DM646X_CMINTMIN_INTVL)
> +				coal_intvl = EMAC_DM646X_CMINTMIN_INTVL;
> +
> +			if (coal_intvl > EMAC_DM646X_CMINTMAX_INTVL) {
> +				/*
> +				 * Interrupt pacer works with 4us Pulse, we can
> +				 * throttle further by dilating the 4us pulse.
> +				 */
> +				addnl_dvdr =
> +					EMAC_DM646X_INTPRESCALE_MASK / prescale;
> +
> +				if (addnl_dvdr > 1) {
> +					prescale *= addnl_dvdr;
> +					if (coal_intvl > (EMAC_DM646X_CMINTMAX_INTVL
> +								* addnl_dvdr))
> +						coal_intvl = (EMAC_DM646X_CMINTMAX_INTVL
> +								* addnl_dvdr);
> +				} else {
> +					addnl_dvdr = 1;
> +					coal_intvl = EMAC_DM646X_CMINTMAX_INTVL;
> +				}
>   			}
> -		}
>   
> -		num_interrupts = (1000 * addnl_dvdr) / coal_intvl;
> +			num_interrupts = (1000 * addnl_dvdr) / coal_intvl;
> +
> +			int_ctrl |= EMAC_DM646X_INTPACEEN;
> +			int_ctrl &= (~EMAC_DM646X_INTPRESCALE_MASK);
> +			int_ctrl |= (prescale & EMAC_DM646X_INTPRESCALE_MASK);
> +		}
>   
> -		int_ctrl |= EMAC_DM646X_INTPACEEN;
> -		int_ctrl &= (~EMAC_DM646X_INTPRESCALE_MASK);
> -		int_ctrl |= (prescale & EMAC_DM646X_INTPRESCALE_MASK);
>   		emac_ctrl_write(EMAC_DM646X_CMINTCTRL, int_ctrl);
>   
>   		emac_ctrl_write(EMAC_DM646X_CMRXINTMAX, num_interrupts);
> @@ -466,17 +467,21 @@ static int emac_set_coalesce(struct net_device *ndev,
>   	default:
>   		int_ctrl = emac_ctrl_read(EMAC_CTRL_EWINTTCNT);
>   		int_ctrl &= (~EMAC_DM644X_EWINTCNT_MASK);
> -		prescale = coal_intvl * priv->bus_freq_mhz;
> -		if (prescale > EMAC_DM644X_EWINTCNT_MASK) {
> -			prescale = EMAC_DM644X_EWINTCNT_MASK;
> -			coal_intvl = prescale / priv->bus_freq_mhz;
> +
> +		if (coal->rx_coalesce_usecs) {
> +			prescale = coal_intvl * priv->bus_freq_mhz;
> +			if (prescale > EMAC_DM644X_EWINTCNT_MASK) {
> +				prescale = EMAC_DM644X_EWINTCNT_MASK;
> +				coal_intvl = prescale / priv->bus_freq_mhz;
> +			}
>   		}
> +
>   		emac_ctrl_write(EMAC_CTRL_EWINTTCNT, (int_ctrl | prescale));
>   
>   		break;
>   	}
>   
> -	printk(KERN_INFO"Set coalesce to %d usecs.\n", coal_intvl);
> +	netdev_info(ndev, "Set coalesce to %d usecs.\n", coal_intvl);
>   	priv->coal_intvl = coal_intvl;
>   
>   	return 0;
> 

-- 
Best regards,
grygorii
