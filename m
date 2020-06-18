Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6EE621FF42D
	for <lists+netdev@lfdr.de>; Thu, 18 Jun 2020 16:07:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730449AbgFROGb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Jun 2020 10:06:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51568 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730245AbgFROGa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Jun 2020 10:06:30 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A4E7CC06174E
        for <netdev@vger.kernel.org>; Thu, 18 Jun 2020 07:06:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=ysiuSQB52LxFG+3KuT7fbkMTNWCDsvxeYv17s7leMw4=; b=oCV9+edbgRR12zrzdpGeb2mjQ
        lTzsaYhgK9dJEYW3yow4kBOdEj7MPlWFgZMgUlN9FzdCioeOA5qmWl+0iibe4Jy+3K3YFzCMcn7h+
        RUQyPW3f0fkB2ZDqZ6Gj7icpP9iDpm2zLE9xRJ9jGMRaY85CSKBlB4xE2niCT08kB0F0ax8lhwI/9
        M1SY9V57BAyhWTNkPQVP/s7yyPCf/lfehg6+pRUcmDt70Vp+R4KcgkYv5zQuzbS8O8fqihgwjyltv
        Jxxx57kgSy0tCT9OJyLNX16sIqDwtupfT5Xbc2BSQOWaisnQAZNEyD0y1yxxsPO76wFfbDGOvvUPf
        J987yi8iw==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:58784)
        by pandora.armlinux.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <linux@armlinux.org.uk>)
        id 1jlvBS-0005Cn-EL; Thu, 18 Jun 2020 15:06:26 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1jlvBP-0004lL-Qp; Thu, 18 Jun 2020 15:06:23 +0100
Date:   Thu, 18 Jun 2020 15:06:23 +0100
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Ioana Ciornei <ioana.ciornei@nxp.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net,
        vladimir.oltean@nxp.com, claudiu.manoil@nxp.com,
        alexandru.marginean@nxp.com, michael@walle.cc, andrew@lunn.ch,
        f.fainelli@gmail.com
Subject: Re: [PATCH net-next 4/5] net: phy: add Lynx PCS MDIO module
Message-ID: <20200618140623.GC1551@shell.armlinux.org.uk>
References: <20200618120837.27089-1-ioana.ciornei@nxp.com>
 <20200618120837.27089-5-ioana.ciornei@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200618120837.27089-5-ioana.ciornei@nxp.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jun 18, 2020 at 03:08:36PM +0300, Ioana Ciornei wrote:
> Add a Lynx PCS MDIO module which exposes the necessary operations to
> drive the PCS using PHYLINK.
> 
> The majority of the code is extracted from the Felix DSA driver, which
> will be also modified in a later patch, and exposed as a separate module
> for code reusability purposes.
> 
> At the moment, USXGMII (only with in-band AN and speeds up to 2500),
> SGMII, QSGMII and 2500Base-X (only w/o in-band AN) are supported by the
> Lynx PCS MDIO module since these were also supported by Felix.
> 
> The module can only be enabled by the drivers in need and not user
> selectable.

Is this the same PCS found in the LX2160A?  It looks very similar.

> +/* 2500Base-X is SerDes protocol 7 on Felix and 6 on ENETC. It is a SerDes lane
> + * clocked at 3.125 GHz which encodes symbols with 8b/10b and does not have
> + * auto-negotiation of any link parameters. Electrically it is compatible with
> + * a single lane of XAUI.
> + * The hardware reference manual wants to call this mode SGMII, but it isn't
> + * really, since the fundamental features of SGMII:
> + * - Downgrading the link speed by duplicating symbols
> + * - Auto-negotiation
> + * are not there.

I welcome that others are waking up to the industry wide obfuscation of
terminology surrounding "SGMII" and "1000base-X", and calling it out
where it is blatently incorrectly described in documentation.

> + * The speed is configured at 1000 in the IF_MODE because the clock frequency
> + * is actually given by a PLL configured in the Reset Configuration Word (RCW).
> + * Since there is no difference between fixed speed SGMII w/o AN and 802.3z w/o
> + * AN, we call this PHY interface type 2500Base-X. In case a PHY negotiates a
> + * lower link speed on line side, the system-side interface remains fixed at
> + * 2500 Mbps and we do rate adaptation through pause frames.

We have systems that do have AN with 2500base-X however - which is what
you want when you couple two potentially remote systems over a fibre
cable.  The AN in 802.3z (1000base-X) is used to negotiate:

- duplex
- pause mode

although in practice, half-duplex is not supported by lots of hardware,
which leaves just pause mode.  It is useful to have pause mode
negotiation remain present, whether it's 1000base-X or 2500base-X, but
obviously within the hardware boundaries.

I suspect the hardware is capable of supporting 802.3z AN when operating
at 2500base-X, but not the SGMII symbol duplication for slower speeds.

> +struct mdio_lynx_pcs *mdio_lynx_pcs_create(struct mdio_device *mdio_dev)
> +{
> +	struct mdio_lynx_pcs *pcs;
> +
> +	if (WARN_ON(!mdio_dev))
> +		return NULL;
> +
> +	pcs = kzalloc(sizeof(*pcs), GFP_KERNEL);
> +	if (!pcs)
> +		return NULL;
> +
> +	pcs->dev = mdio_dev;
> +	pcs->an_restart = lynx_pcs_an_restart;
> +	pcs->get_state = lynx_pcs_get_state;
> +	pcs->link_up = lynx_pcs_link_up;
> +	pcs->config = lynx_pcs_config;

We really should not have these private structure interfaces.  Private
structure-based driver specific interfaces really don't constitute a
sane approach to interface design.

Would it work if there was a "struct mdio_device" add to the
phylink_config structure, and then you could have the phylink_pcs_ops
embedded into this driver?

If not, then we need some kind of mdio_pcs_device that offers this
kind of functionality.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
