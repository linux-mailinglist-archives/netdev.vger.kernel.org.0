Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B58224FB07
	for <lists+netdev@lfdr.de>; Sun, 23 Jun 2019 12:12:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726461AbfFWKIh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 23 Jun 2019 06:08:37 -0400
Received: from pandora.armlinux.org.uk ([78.32.30.218]:43558 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726350AbfFWKIh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 23 Jun 2019 06:08:37 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=RRJoASm2wuNLycnVQyCO3oYrfaDo4EO1HNKxQfPp1Y4=; b=eMSSnu20h26/9MDMv0N3aNbzq
        a9IiH6pLxSyGInAeuYWZvxDGr++Y5rBeLnwl1/WxAzrniKFNF9uTXZcV3UmpXVtNGx6TmqRyQ4zAN
        EGjd0QuZenqtzQc7IGtSG+Cn4CnwEvXH6cYW4t+tmeP5Hxp5RSZnhb0vdBPxYXwjJ8BLQIgEPJrF3
        2shA5G2UzplIHv3hATuYDLf+mUtXr/xkjvIb0IDJppWLFxjem5lbJ7GwvxHna2zQjrSERmug3f2uH
        kWxdpvVdu6q6rKTh2dTwWEzgn+ByhXDBL9J28ZtwCNA86fatqRPucb81FVNSVB98hxrpRtP4D7FkG
        eioQPrcEg==;
Received: from shell.armlinux.org.uk ([2001:4d48:ad52:3201:5054:ff:fe00:4ec]:58914)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <linux@armlinux.org.uk>)
        id 1hezQC-0000gV-Uo; Sun, 23 Jun 2019 11:08:29 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.89)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1hezQ8-0004ve-PB; Sun, 23 Jun 2019 11:08:24 +0100
Date:   Sun, 23 Jun 2019 11:08:24 +0100
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Parshuram Thombare <pthombar@cadence.com>
Cc:     andrew@lunn.ch, nicolas.ferre@microchip.com, davem@davemloft.net,
        f.fainelli@gmail.com, netdev@vger.kernel.org, hkallweit1@gmail.com,
        linux-kernel@vger.kernel.org, rafalc@cadence.com,
        aniljoy@cadence.com, piotrs@cadence.com
Subject: Re: [PATCH v4 1/5] net: macb: add phylink support
Message-ID: <20190623100824.3xlmkofiqebdf4sa@shell.armlinux.org.uk>
References: <1561281419-6030-1-git-send-email-pthombar@cadence.com>
 <1561281457-6886-1-git-send-email-pthombar@cadence.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1561281457-6886-1-git-send-email-pthombar@cadence.com>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Jun 23, 2019 at 10:17:37AM +0100, Parshuram Thombare wrote:
> +	switch (state->interface) {
> +	case PHY_INTERFACE_MODE_GMII:
> +	case PHY_INTERFACE_MODE_RGMII:
> +		if (bp->caps & MACB_CAPS_GIGABIT_MODE_AVAILABLE) {
> +			phylink_set(mask, 1000baseT_Full);
> +			phylink_set(mask, 1000baseX_Full);
> +			if (!(bp->caps & MACB_CAPS_NO_GIGABIT_HALF)) {
> +				phylink_set(mask, 1000baseT_Half);
> +				phylink_set(mask, 1000baseT_Half);

I think this can be cleaned up.

> +			}
> +		}
> +	/* fallthrough */
> +	case PHY_INTERFACE_MODE_MII:
> +	case PHY_INTERFACE_MODE_RMII:
> +		phylink_set(mask, 10baseT_Half);
> +		phylink_set(mask, 10baseT_Full);
> +		phylink_set(mask, 100baseT_Half);
> +		phylink_set(mask, 100baseT_Full);
> +		break;
> +	default:
> +		break;
> +	}
>  
> -	spin_lock_irqsave(&bp->lock, flags);
> +	linkmode_and(supported, supported, mask);
> +	linkmode_and(state->advertising, state->advertising, mask);
>  

You remove this blank line in the next patch, so given that this is a
new function, you might as well clean that up in this patch.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTC broadband for 0.8mile line in suburbia: sync at 12.1Mbps down 622kbps up
According to speedtest.net: 11.9Mbps down 500kbps up
