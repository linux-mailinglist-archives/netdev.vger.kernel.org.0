Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 13D9C4A9EBF
	for <lists+netdev@lfdr.de>; Fri,  4 Feb 2022 19:15:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377422AbiBDSPB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Feb 2022 13:15:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42964 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239558AbiBDSPB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Feb 2022 13:15:01 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5CC79C061714;
        Fri,  4 Feb 2022 10:15:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=EoClmycGC2pyssAFQ3Yd/jSMUhwQjb+AViIrm00DoVU=; b=SQdS0bxn/g56/JVHYSjn4rLkwu
        EwJCCvdwJZI/CKQ+QDAkn+D3r/3FJKUE9z4E+/gXqKT9o+uke0EYvQEBn0kKQUKdp3rHmSMZ+bM1j
        2r9+oacfSB5vuQ2h/EQZXTggH7uLED+ZmGr2EHyc8hfVcfepn5cQS4HyuXPI0XqnBNNGJxSwg7Qrm
        7Mp+KVpl8FZlYufRBC7S34jdvI6uqTfZbYdH/sDRNZIG2KlF/1FMwYiEw1ENqUOVatntsPm+p5QU1
        VFu0OiF3EPa89sr4vV6nEK1zHQaKP447pKrfWQxK7s6ijb+8X5TsAvi8aq26BCObERgPeo1HzqxBJ
        Jo/NZq1Q==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:57044)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1nG36l-000580-1g; Fri, 04 Feb 2022 18:14:55 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1nG36j-0005C0-4M; Fri, 04 Feb 2022 18:14:53 +0000
Date:   Fri, 4 Feb 2022 18:14:53 +0000
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Prasanna Vengateshan <prasanna.vengateshan@microchip.com>
Cc:     andrew@lunn.ch, netdev@vger.kernel.org, olteanv@gmail.com,
        robh+dt@kernel.org, UNGLinuxDriver@microchip.com,
        Woojung.Huh@microchip.com, hkallweit1@gmail.com,
        davem@davemloft.net, kuba@kernel.org, linux-kernel@vger.kernel.org,
        vivien.didelot@gmail.com, f.fainelli@gmail.com,
        devicetree@vger.kernel.org
Subject: Re: [PATCH v7 net-next 06/10] net: dsa: microchip: add support for
 phylink management
Message-ID: <Yf1tHUaecq2DLgcE@shell.armlinux.org.uk>
References: <20220204174500.72814-1-prasanna.vengateshan@microchip.com>
 <20220204174500.72814-7-prasanna.vengateshan@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220204174500.72814-7-prasanna.vengateshan@microchip.com>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On Fri, Feb 04, 2022 at 11:14:56PM +0530, Prasanna Vengateshan wrote:
> +static void lan937x_phylink_mac_link_up(struct dsa_switch *ds, int port,
> +					unsigned int mode,
> +					phy_interface_t interface,
> +					struct phy_device *phydev,
> +					int speed, int duplex,
> +					bool tx_pause, bool rx_pause)
> +{
> +	struct ksz_device *dev = ds->priv;
> +
> +	/* Internal PHYs */
> +	if (lan937x_is_internal_phy_port(dev, port))
> +		return;
> +
> +	if (phylink_autoneg_inband(mode)) {
> +		dev_err(ds->dev, "In-band AN not supported!\n");
> +		return;
> +	}

No need to check this in the link_up() method - if this were true,
you've already printed an error in the mac_config() method and this
one doesn't provide any additional useful information.

> +
> +	lan937x_config_interface(dev, port, speed, duplex,
> +				 tx_pause, rx_pause);
> +}
> +
> +static void lan937x_phylink_get_caps(struct dsa_switch *ds, int port,
> +				     struct phylink_config *config)
> +{
> +	struct ksz_device *dev = ds->priv;
> +
> +	config->mac_capabilities = MAC_100FD;
> +
> +	/* internal T1 PHY */
> +	if (lan937x_is_internal_base_t1_phy_port(dev, port)) {
> +		__set_bit(PHY_INTERFACE_MODE_INTERNAL,
> +			  config->supported_interfaces);
> +	} else {
> +		/* MII/RMII/RGMII ports */
> +		if (!lan937x_is_internal_base_tx_phy_port(dev, port)) {

Please consider:

	} else if (!lan937x_is_internal_base_tx_phy_port(dev, port)) {
		/* MII/RMII/RGMII ports */
		...
	}

to avoid needing two tabs to indent, which probably makes:

> +			config->mac_capabilities |= MAC_100HD | MAC_SYM_PAUSE |
> +						    MAC_ASYM_PAUSE | MAC_10 |
> +						    MAC_1000FD;

able to be laid out with the two pause modes first followed by the
speeds.

> +			phy_interface_set_rgmii(config->supported_interfaces);
> +
> +			__set_bit(PHY_INTERFACE_MODE_MII,
> +				  config->supported_interfaces);
> +			__set_bit(PHY_INTERFACE_MODE_RMII,
> +				  config->supported_interfaces);
> +		}
> +	}

You seem to be a non-legacy driver in this patch (good!) so please also
add:

	config->legacy_pre_march2020 = false;

while DSA is transitioned over. Thanks.

> +}
> +
>  const struct dsa_switch_ops lan937x_switch_ops = {
>  	.get_tag_protocol = lan937x_get_tag_protocol,
>  	.setup = lan937x_setup,

Thanks.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
