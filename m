Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9AB501FEF28
	for <lists+netdev@lfdr.de>; Thu, 18 Jun 2020 12:02:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728348AbgFRKCH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Jun 2020 06:02:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42082 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727037AbgFRKCG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Jun 2020 06:02:06 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0882AC06174E
        for <netdev@vger.kernel.org>; Thu, 18 Jun 2020 03:02:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=+NcDSGbZ/yzgHU3zIkrxV//B3YANrC/s0HYkt4qOtfc=; b=YR3l3PDEHUN1sRHw3KXnYmRqW
        dUz3JYkOYyr+RFlg1wEFfmI5CjD2wG6AgOel+LYh15QR+lrBRcD6t/O/vJXDQv4bmZky4MImXTxon
        WxFuxBKMjOXaUwvX2cmiFYA1itk1m2R5P+iISjSbElNZOynsBfy3NKjEz3XiIMQxg31BqMMrg7ex/
        MwXUeD6EFec1uz3uYu6MiTbmLs2wm2CTcPuGECDAzCBsAsoVKAbHhXW2tqYAvmi88SEvFtmx+KuOR
        VkVWHpVcSSifRlAG+qTF4zt63LMsN8x/JNxs4qSYYPypR/KnuZwipZvttXe2PcZ+Crjj3iAYUnVAH
        xvRV3+8WA==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:58774)
        by pandora.armlinux.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <linux@armlinux.org.uk>)
        id 1jlrMg-0004p1-Do; Thu, 18 Jun 2020 11:01:46 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1jlrMd-0004cm-CB; Thu, 18 Jun 2020 11:01:43 +0100
Date:   Thu, 18 Jun 2020 11:01:43 +0100
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Helmut Grohne <helmut.grohne@intenta.de>
Cc:     Nicolas Ferre <nicolas.ferre@microchip.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>
Subject: Re: [PATCH] net: macb: reject unsupported rgmii delays
Message-ID: <20200618100143.GZ1551@shell.armlinux.org.uk>
References: <20200616074955.GA9092@laureti-dev>
 <20200617105518.GO1551@shell.armlinux.org.uk>
 <20200617112153.GB28783@laureti-dev>
 <20200617114025.GQ1551@shell.armlinux.org.uk>
 <20200617115201.GA30172@laureti-dev>
 <20200617120809.GS1551@shell.armlinux.org.uk>
 <20200618081433.GA22636@laureti-dev>
 <20200618084554.GY1551@shell.armlinux.org.uk>
 <20200618090526.GA10165@laureti-dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200618090526.GA10165@laureti-dev>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jun 18, 2020 at 11:05:26AM +0200, Helmut Grohne wrote:
> On Thu, Jun 18, 2020 at 10:45:54AM +0200, Russell King - ARM Linux admin wrote:
> > Why do we need that complexity?  If we decide that we can allow
> > phy-mode = "rgmii" and introduce new properties to control the
> > delay, then we just need:
> > 
> >   rgmii-tx-delay-ps = <nnn>;
> >   rgmii-rx-delay-ps = <nnn>;
> > 
> > specified in the MAC node (to be applied only at the MAC end) or
> > specified in the PHY node (to be applied only at the PHY end.)
> > In the normal case, this would be the standard delay value, but
> > in exceptional cases where supported, the delays can be arbitary.
> > We know there are PHYs out there which allow other delays.
> > 
> > This means each end is responsible for parsing these properties in
> > its own node and applying them - or raising an error if they can't
> > be supported.
> 
> Thank you. That makes a lot more sense while keeping the (imo) important
> properties of my proposal:
>  * It is backwards compatible. These properties override delays
>    specified inside phy-mode. Otherwise the vague phy-mode meaning is
>    retained.
>  * The ambiguity is resolved. It is always clear where delays should be
>    configure and the properties properly account for possible PCB
>    traces.
> 
> It also resolves my original problem. If support for these properties is
> added to macb_main.c, it would simply check that both delays are 0 as
> internal delays are not supported by the hardware.  When I would have
> attempted to configure an rx delay, it would have nicely errored out.

I think we'd want a helper or two to do the parsing and return the
delays, something like:

#define PHY_RGMII_DELAY_PS_NONE	0
#define PHY_RGMII_DELAY_PS_STD	1500

/* @np here should be the MAC node */
int of_mac_get_delays(struct device_node *np,
		      phy_interface_mode interface,
		      u32 *tx_delay_ps, u32 *rx_delay_ps)
{
	*tx_delay_ps = PHY_RGMII_DELAY_PS_NONE;
	*rx_delay_ps = PHY_RGMII_DELAY_PS_NONE;

	if (!np)
		return 0;

	if (interface == PHY_INTERFACE_MODE_RGMII) {
		of_property_read_u32(np, "rgmii-tx-delay-ps", tx_delay_ps);
		of_property_read_u32(np, "rgmii-rx-delay-ps", rx_delay_ps);
	}

	return 0;
}

/* @np here should be the PHY node */
int of_phy_get_delays(struct device_node *np,
		      phy_interface_mode interface,
		      u32 *tx_delay_ps, u32 *rx_delay_ps)
{
	switch (interface) {
	case PHY_INTERFACE_MODE_RGMII_ID:
		*tx_delay_ps = PHY_RGMII_DELAY_PS_STD;
		*rx_delay_ps = PHY_RGMII_DELAY_PS_STD;
		return 0;

	case PHY_INTERFACE_MODE_RGMII_RXID:
		*tx_delay_ps = PHY_RGMII_DELAY_PS_NONE;
		*rx_delay_ps = PHY_RGMII_DELAY_PS_STD;
		return 0;

	case PHY_INTERFACE_MODE_RGMII_TXID:
		*tx_delay_ps = PHY_RGMII_DELAY_PS_STD;
		*rx_delay_ps = PHY_RGMII_DELAY_PS_NONE;
		return 0;

	default:
		return of_mac_get_delays(np, interface,
					 tx_delay_ps, rx_delay_ps);
	}
}

as a first cut - validation left up to the user of these.  At least
we then have an easy interface for PHY drivers to use, for example:

static int m88e1121_config_aneg_rgmii_delays(struct phy_device *phydev)
{
	u32 tx_delay_ps, rx_delay_ps;
	int err;

	err = of_phy_get_delays(phydev->mdio.dev.of_node,
				phydev->interface, &tx_delay_ps,
				&rx_delay_ps);
	if (err)
		return err;

	mscr = 0;
	if (tx_delay_ps == PHY_RGMII_DELAY_PS_STD)
		mscr |= MII_88E1121_PHY_MSCR_TX_DELAY;
	else if (tx_delay_ps != PHY_RGMII_DELAY_PS_NONE)
		/* ... log an error to kernel log */
		return -EINVAL;

	if (rx_delay_ps == PHY_RGMII_DELAY_PS_STD)
		mscr |= MII_88E1121_PHY_MSCR_RX_DELAY;
	else if (rx_delay_ps != PHY_RGMII_DELAY_PS_NONE)
		/* ... log an error to kernel log */
		return -EINVAL;

	return phy_modify_paged(phydev, MII_MARVELL_MSCR_PAGE,
				MII_88E1121_PHY_MSCR_REG,
				MII_88E1121_PHY_MSCR_DELAY_MASK, mscr);
}

> How can we achieve wider consensus on this and put it into the dt
> specification? Should there be drivers supporting these first?

Provide an illustration of the idea in code form for consideration? ;)

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
