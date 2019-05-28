Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EDE0D2CA7E
	for <lists+netdev@lfdr.de>; Tue, 28 May 2019 17:42:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727055AbfE1Pmr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 May 2019 11:42:47 -0400
Received: from pandora.armlinux.org.uk ([78.32.30.218]:40248 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727053AbfE1Pmr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 May 2019 11:42:47 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=mLZmLmeaESATBH7RYOZR+jWsGl2i7XE+as5Dj+dtOus=; b=0i8dMs+VG2a/Ou30kFxDm9xfa
        j98T/2dyvUOClrmfv0RSkppNLN3vRqMOc3JMpUiyk5n0+gBg/0vDDLq4/DVqdS1tRb5TDQcWvU6NK
        o5GXgr84GmW/z1o9MJwcLPvunH6Yb/y2vUNDqzS7xIYylzD6XZ85bpnRuHv8y8cGh8y2Tr81BggvO
        ACN6hwjRVhjLFHMj7HkAFl+BS4HkNBR0Flv4919FRyBjsso+N5YAlly1J9AhZYrsmm5G3mxSNlYuG
        JXtGDijreCxMFldlnaW+JdsNlsdaDUf5/e7qAifPdGNLrZ2H/viaQNMZqaARLSZoYam3mlTm1giPd
        060kXR3/g==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:52686)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <linux@armlinux.org.uk>)
        id 1hVeFN-0006iN-9W; Tue, 28 May 2019 16:42:41 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.89)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1hVeFK-0003kN-Pf; Tue, 28 May 2019 16:42:38 +0100
Date:   Tue, 28 May 2019 16:42:38 +0100
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Maxime Chevallier <maxime.chevallier@bootlin.com>
Cc:     "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Subject: Re: [PATCH] net: phy: marvell10g: report if the PHY fails to boot
 firmware
Message-ID: <20190528154238.ifudfslyofk22xoe@shell.armlinux.org.uk>
References: <E1hVYVG-0005D8-8w@rmk-PC.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1hVYVG-0005D8-8w@rmk-PC.armlinux.org.uk>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, May 28, 2019 at 10:34:42AM +0100, Russell King wrote:
> Some boards do not have the PHY firmware programmed in the 3310's flash,
> which leads to the PHY not working as expected.  Warn the user when the
> PHY fails to boot the firmware and refuse to initialise.
> 
> Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
> ---
> I think this patch needs testing with the Marvell 88x2110 PHY before
> this can be merged into mainline, but I think it should go into -rc
> and be back-ported to stable trees to avoid user frustration. I spent
> some time last night debugging one such instance, and the user
> afterwards indicated that they'd had the problem for a long time, and
> had thought of throwing the hardware out the window!  Clearly not a
> good user experience.
> 
>  drivers/net/phy/marvell10g.c | 13 +++++++++++++
>  1 file changed, 13 insertions(+)
> 
> diff --git a/drivers/net/phy/marvell10g.c b/drivers/net/phy/marvell10g.c
> index 100b401b1f4a..754cde873dde 100644
> --- a/drivers/net/phy/marvell10g.c
> +++ b/drivers/net/phy/marvell10g.c
> @@ -31,6 +31,9 @@
>  #define MV_PHY_ALASKA_NBT_QUIRK_REV	(MARVELL_PHY_ID_88X3310 | 0xa)
>  
>  enum {
> +	MV_PMA_BOOT		= 0xc050,
> +	MV_PMA_BOOT_FATAL	= BIT(0),
> +
>  	MV_PCS_BASE_T		= 0x0000,
>  	MV_PCS_BASE_R		= 0x1000,
>  	MV_PCS_1000BASEX	= 0x2000,
> @@ -211,6 +214,16 @@ static int mv3310_probe(struct phy_device *phydev)
>  	    (phydev->c45_ids.devices_in_package & mmd_mask) != mmd_mask)
>  		return -ENODEV;
>  
> +	ret = phy_read_mmd(phydev, MDIO_MMD_PMAPMD, MV_PMA_BOOT);
> +	if (ret < 0)
> +		return ret;
> +
> +	if (ret & MV_PMA_BOOT_FATAL) {
> +		dev_warn(&phydev->mdio.dev,
> +			 "PHY failed to boot firmware, status=%04x\n", ret);
> +		return -ENODEV;

One question: are we happy with failing the probe like this, or would it
be better to allow the probe to suceed?

As has been pointed out in the C45 MII access patch, we need the PHY
to bind to the network driver for the MII bus to be accessible to
userspace, so if we're going to have userspace tools to upload the
firmware, rather than using u-boot, we need the PHY to be present and
bound to the network interface.

> +	}
> +
>  	priv = devm_kzalloc(&phydev->mdio.dev, sizeof(*priv), GFP_KERNEL);
>  	if (!priv)
>  		return -ENOMEM;
> -- 
> 2.7.4
> 
> 

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTC broadband for 0.8mile line in suburbia: sync at 12.1Mbps down 622kbps up
According to speedtest.net: 11.9Mbps down 500kbps up
