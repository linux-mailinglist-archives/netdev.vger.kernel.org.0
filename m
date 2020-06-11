Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F34A81F641D
	for <lists+netdev@lfdr.de>; Thu, 11 Jun 2020 10:59:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727019AbgFKI7C (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Jun 2020 04:59:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36694 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726833AbgFKI67 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Jun 2020 04:58:59 -0400
X-Greylist: delayed 196 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Thu, 11 Jun 2020 01:58:59 PDT
Received: from pandora.armlinux.org.uk (unknown [IPv6:2001:4d48:ad52:32c8:214:fdff:fe10:1be6])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 094F9C03E96F;
        Thu, 11 Jun 2020 01:58:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=g4cB48q84iF2x+YTctvj2vQzPcRRIUPbdwGd8ytPMJs=; b=yPCiYKdwo02fKO/iPRLDsIklK
        vBXP/ZlL6LtWewhRVdjSfq+XXQb0XGO1gloD1ntYOGL9NeGC/tIZFALMOg+g0XY55XlPadWVFj6Br
        9IifcYd2NCANKhBvjffoapNhI7Ksm9QJKWqeAa1Mbiv73vJk1ySr2R0nvPqrirGUDLMkvr99xPD0+
        GoktE8KjB1nCDvVSWCj80Pr6MmeL29Uae1zsraDjW77jWQ2rAUHDG095XlGqlAoJdkDqhVFQUWj/2
        DxcSFZjuDsYRHWc73aPvTdPCHBehcH3VMv+rfMU2gKNIASHeTYFTcxJqoUTf6107r08wr/VOggEQD
        RE0dJ7a0A==;
Received: from shell.armlinux.org.uk ([2001:4d48:ad52:3201:5054:ff:fe00:4ec]:52172)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <linux@armlinux.org.uk>)
        id 1jjJ2x-0008Cw-Fv; Thu, 11 Jun 2020 09:58:51 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1jjJ2w-00052V-Rb; Thu, 11 Jun 2020 09:58:50 +0100
Date:   Thu, 11 Jun 2020 09:58:50 +0100
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Jonathan McDowell <noodles@earth.li>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] net: dsa: qca8k: Improve SGMII interface handling
Message-ID: <20200611085850.GW1551@shell.armlinux.org.uk>
References: <cover.1591816172.git.noodles@earth.li>
 <2150f4c70c754aed179e46e166f3c305254cf85a.1591816172.git.noodles@earth.li>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2150f4c70c754aed179e46e166f3c305254cf85a.1591816172.git.noodles@earth.li>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 10, 2020 at 08:15:13PM +0100, Jonathan McDowell wrote:
> This patch improves the handling of the SGMII interface on the QCA8K
> devices. Previously the driver did no configuration of the port, even if
> it was selected. We now configure it up in the appropriate
> PHY/MAC/Base-X mode depending on what phylink tells us we are connected
> to and ensure it is enabled.
> 
> Tested with a device where the CPU connection is RGMII (i.e. the common
> current use case) + one where the CPU connection is SGMII. I don't have
> any devices where the SGMII interface is brought out to something other
> than the CPU.
> 
> Signed-off-by: Jonathan McDowell <noodles@earth.li>
> ---
>  drivers/net/dsa/qca8k.c | 28 +++++++++++++++++++++++++++-
>  drivers/net/dsa/qca8k.h | 13 +++++++++++++
>  2 files changed, 40 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/net/dsa/qca8k.c b/drivers/net/dsa/qca8k.c
> index dcd9e8fa99b6..33e62598289e 100644
> --- a/drivers/net/dsa/qca8k.c
> +++ b/drivers/net/dsa/qca8k.c
> @@ -681,7 +681,7 @@ qca8k_phylink_mac_config(struct dsa_switch *ds, int port, unsigned int mode,
>  			 const struct phylink_link_state *state)
>  {
>  	struct qca8k_priv *priv = ds->priv;
> -	u32 reg;
> +	u32 reg, val;
>  
>  	switch (port) {
>  	case 0: /* 1st CPU port */
> @@ -740,6 +740,32 @@ qca8k_phylink_mac_config(struct dsa_switch *ds, int port, unsigned int mode,
>  	case PHY_INTERFACE_MODE_1000BASEX:
>  		/* Enable SGMII on the port */
>  		qca8k_write(priv, reg, QCA8K_PORT_PAD_SGMII_EN);
> +
> +		/* Enable/disable SerDes auto-negotiation as necessary */
> +		val = qca8k_read(priv, QCA8K_REG_PWS);
> +		if (phylink_autoneg_inband(mode))
> +			val &= ~QCA8K_PWS_SERDES_AEN_DIS;
> +		else
> +			val |= QCA8K_PWS_SERDES_AEN_DIS;
> +		qca8k_write(priv, QCA8K_REG_PWS, val);
> +
> +		/* Configure the SGMII parameters */
> +		val = qca8k_read(priv, QCA8K_REG_SGMII_CTRL);
> +
> +		val |= QCA8K_SGMII_EN_PLL | QCA8K_SGMII_EN_RX |
> +			QCA8K_SGMII_EN_TX | QCA8K_SGMII_EN_SD;
> +
> +		val &= ~QCA8K_SGMII_MODE_CTRL_MASK;
> +		if (dsa_is_cpu_port(ds, port)) {
> +			/* CPU port, we're talking to the CPU MAC, be a PHY */
> +			val |= QCA8K_SGMII_MODE_CTRL_PHY;
> +		} else if (state->interface == PHY_INTERFACE_MODE_SGMII) {
> +			val |= QCA8K_SGMII_MODE_CTRL_MAC;
> +		} else {
> +			val |= QCA8K_SGMII_MODE_CTRL_BASEX;
> +		}
> +
> +		qca8k_write(priv, QCA8K_REG_SGMII_CTRL, val);

Ah, here it is!  Hmm, I suppose as the two patches will be applied
together, it's fine to split it like this.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTC for 0.8m (est. 1762m) line in suburbia: sync at 13.1Mbps down 503kbps up
