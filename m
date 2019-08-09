Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A277987456
	for <lists+netdev@lfdr.de>; Fri,  9 Aug 2019 10:37:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405931AbfHIIhe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Aug 2019 04:37:34 -0400
Received: from relay8-d.mail.gandi.net ([217.70.183.201]:36457 "EHLO
        relay8-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726071AbfHIIhe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Aug 2019 04:37:34 -0400
X-Originating-IP: 86.250.200.211
Received: from localhost (lfbn-1-17395-211.w86-250.abo.wanadoo.fr [86.250.200.211])
        (Authenticated sender: antoine.tenart@bootlin.com)
        by relay8-d.mail.gandi.net (Postfix) with ESMTPSA id CFFB31BF204;
        Fri,  9 Aug 2019 08:37:32 +0000 (UTC)
Date:   Fri, 9 Aug 2019 10:06:38 +0200
From:   Antoine Tenart <antoine.tenart@bootlin.com>
To:     Matt Pelland <mpelland@starry.com>
Cc:     netdev@vger.kernel.org, maxime.chevallier@bootlin.com,
        antoine.tenart@bootlin.com
Subject: Re: [PATCH v2 net-next 1/2] net: mvpp2: implement RXAUI support
Message-ID: <20190809080638.GA3516@kwain>
References: <20190808230606.7900-1-mpelland@starry.com>
 <20190808230606.7900-2-mpelland@starry.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20190808230606.7900-2-mpelland@starry.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello Matt,

On Thu, Aug 08, 2019 at 07:06:05PM -0400, Matt Pelland wrote:
>  
> +static void mvpp22_gop_init_rxaui(struct mvpp2_port *port)
> +{
> +	struct mvpp2 *priv = port->priv;
> +	void __iomem *xpcs;
> +	u32 val;
> +
> +	xpcs = priv->iface_base + MVPP22_XPCS_BASE(port->gop_id);
> +
> +	val = readl(xpcs + MVPP22_XPCS_CFG0);
> +	val &= ~MVPP22_XPCS_CFG0_RESET_DIS;
> +	writel(val, xpcs + MVPP22_XPCS_CFG0);

The reset logic of the various blocks in PPv2 is handled outside of the
GoP init functions. You should only modify the XPCS configuration here,
without taking care of the reset. See mvpp22_pcs_reset_assert() and
mvpp22_pcs_reset_deassert().

Note that gop_init() is always called with the XPCS reset asserted.

>  static void mvpp22_gop_init_10gkr(struct mvpp2_port *port)
>  {
>  	struct mvpp2 *priv = port->priv;
> @@ -1065,6 +1089,9 @@ static int mvpp22_gop_init(struct mvpp2_port *port)
>  	case PHY_INTERFACE_MODE_2500BASEX:
>  		mvpp22_gop_init_sgmii(port);
>  		break;
> +	case PHY_INTERFACE_MODE_RXAUI:
> +		mvpp22_gop_init_rxaui(port);
> +		break;

Isn't RXAUI only supported on port #0? (Such as the 10GKR mode below).

>  	case PHY_INTERFACE_MODE_10GKR:
>  		if (port->gop_id != 0)
>  			goto invalid_conf;


>  		   MVPP22_XLG_CTRL4_EN_IDLE_CHECK);
>  	ctrl4 |= MVPP22_XLG_CTRL4_FWD_FC | MVPP22_XLG_CTRL4_FWD_PFC;
>  
> +	if (state->interface == PHY_INTERFACE_MODE_RXAUI)
> +		ctrl4 |= MVPP22_XLG_CTRL4_USE_XPCS;

You should probably mask MVPP22_XLG_CTRL4_USE_XPCS when the interface
isn't RXAUI (just to be consistent with what's done in the configuration
functions). You can do this a few lines before, some bits of ctrl4 get
masked.

Thanks!
Antoine

-- 
Antoine Ténart, Bootlin
Embedded Linux and Kernel engineering
https://bootlin.com
