Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EF4496DD80A
	for <lists+netdev@lfdr.de>; Tue, 11 Apr 2023 12:36:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229826AbjDKKgP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Apr 2023 06:36:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58704 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229451AbjDKKgO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Apr 2023 06:36:14 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 25211E54;
        Tue, 11 Apr 2023 03:36:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=fds3zanNbJi2ddOhpzEhs3eUw9m+0uIWPzFNMVcijHA=; b=TGUwRQySA2i6e4wh1+0ANby90j
        MMUOaPRheareiXlOtjYpNFZTT82wfvfDPys5EntoqXHgnDiFmgHIPOoOYncdcEx+ucHvf8hIcIH4N
        nUBBnwKbKyr+2VZ9XliHqHKTV9MhaMszOdZa+NiDu1tPtIBgZzGyoezzVeYxh10Zn+kedhm6q0bYd
        AML9lfhvXskYgUyUXIzsHGZ9cRy43C0rrVghyvM24CPcYtruw+nTVZ6OLi8uOkUBpR8NBYTz7HW2I
        OkOFvxkQIHKRKSM5mi/MgUCqVcD9GngR5G/6LdFM1w90sRi+1FaOKtt2i2zFg67CwkpUcDVo6/tkO
        Ld3tNL7Q==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:35792)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1pmBM7-0005nD-Oz; Tue, 11 Apr 2023 11:36:07 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1pmBM5-00041g-QI; Tue, 11 Apr 2023 11:36:05 +0100
Date:   Tue, 11 Apr 2023 11:36:05 +0100
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Jiawen Wu <jiawenwu@trustnetic.com>
Cc:     netdev@vger.kernel.org, linux-i2c@vger.kernel.org,
        linux-gpio@vger.kernel.org, mengyuanlou@net-swift.com
Subject: Re: [PATCH net-next v2 5/6] net: txgbe: Implement phylink pcs
Message-ID: <ZDU4Fe6XVw+I0iGx@shell.armlinux.org.uk>
References: <20230411092725.104992-1-jiawenwu@trustnetic.com>
 <20230411092725.104992-6-jiawenwu@trustnetic.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230411092725.104992-6-jiawenwu@trustnetic.com>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 11, 2023 at 05:27:24PM +0800, Jiawen Wu wrote:
> +static void txgbe_set_an37_ability(struct txgbe *txgbe)
> +{
> +     u16 val;
> +
> +     pcs_write(txgbe, MDIO_MMD_PCS, TXGBE_PCS_DIG_CTRL1,
> +               TXGBE_PCS_DIG_CTRL1_EN_VSMMD1 |
> +               TXGBE_PCS_DIG_CTRL1_CLS7_BP |
> +               TXGBE_PCS_DIG_CTRL1_BYP_PWRUP);
> +     pcs_write(txgbe, MDIO_MMD_VEND2, TXGBE_MII_AN_CTRL,
> +               TXGBE_MII_AN_CTRL_MII |
> +               TXGBE_MII_AN_CTRL_TXCFG |
> +               TXGBE_MII_AN_CTRL_PCS_MODE(0) |
> +               TXGBE_MII_AN_CTRL_INTR_EN);
> +     pcs_write(txgbe, MDIO_MMD_VEND2, TXGBE_MII_DIG_CTRL1,
> +               TXGBE_MII_DIG_CTRL1_MAC_AUTOSW);
> +     val = pcs_read(txgbe, MDIO_MMD_VEND2, MDIO_CTRL1);
> +     val |= BMCR_ANRESTART | BMCR_ANENABLE;

	val |= BMCR_ANENABLE;

> +     pcs_write(txgbe, MDIO_MMD_VEND2, MDIO_CTRL1, val);
> +}

> +static void txgbe_setup_adv(struct txgbe *txgbe, phy_interface_t interface,
> +			    const unsigned long *advertising)

Please return an int.

> +{
> +	int adv;
> +
> +	adv = phylink_mii_c22_pcs_encode_advertisement(interface,
> +						       advertising);

	if (adv < 0)
		return adv;

> +	if (adv > 0)
> +		mdiodev_c45_modify(txgbe->mdiodev, MDIO_MMD_VEND2, MII_ADVERTISE,
> +				   0xffff, adv);

	return mdiodev_c45_modify_changed(txgbe->mdiodev, MDIO_MMD_VEND2,
					  MII_ADVERTISE, 0xffff, adv);

> +}
> +
> +static int txgbe_pcs_config(struct phylink_pcs *pcs, unsigned int mode,
> +			    phy_interface_t interface,
> +			    const unsigned long *advertising,
> +			    bool permit_pause_to_mac)
> +{
> +	struct txgbe *txgbe = container_of(pcs, struct txgbe, pcs);
> +	struct wx *wx = txgbe->wx;
> +	int ret, val;
> +
> +	if (interface == txgbe->interface)
> +		goto out;
> +
> +	/* Wait xpcs power-up good */
> +	ret = read_poll_timeout(pcs_read, val,
> +				(val & TXGBE_PCS_DIG_STS_PSEQ_ST) ==
> +				TXGBE_PCS_DIG_STS_PSEQ_ST_GOOD,
> +				10000, 1000000, false,
> +				txgbe, MDIO_MMD_PCS, TXGBE_PCS_DIG_STS);
> +	if (ret < 0) {
> +		wx_err(wx, "xpcs power-up timeout.\n");
> +		return ret;
> +	}
> +
> +	/* Disable xpcs AN-73 */
> +	pcs_write(txgbe, MDIO_MMD_AN, MDIO_CTRL1, 0);
> +
> +	/* Disable PHY MPLLA for eth mode change(after ECO) */
> +	txgbe_ephy_write(txgbe, TXGBE_SUP_DIG_MPLLA_OVRD_IN_0, 0x243A);
> +	WX_WRITE_FLUSH(wx);
> +	usleep_range(1000, 2000);
> +
> +	/* Set the eth change_mode bit first in mis_rst register
> +	 * for corresponding LAN port
> +	 */
> +	wr32(wx, TXGBE_MIS_RST, TXGBE_MIS_RST_LAN_ETH_MODE(wx->bus.func));
> +
> +	switch (interface) {
> +	case PHY_INTERFACE_MODE_10GBASER:
> +		txgbe_pma_config_10gbaser(txgbe);
> +		break;
> +	case PHY_INTERFACE_MODE_1000BASEX:
> +		txgbe_pma_config_1000basex(txgbe);
> +		break;
> +	default:
> +		break;
> +	}
> +
> +	pcs_write(txgbe, MDIO_MMD_PCS, TXGBE_PCS_DIG_CTRL1,
> +		  TXGBE_PCS_DIG_CTRL1_VR_RST | TXGBE_PCS_DIG_CTRL1_EN_VSMMD1);
> +	/* wait phy initialization done */
> +	ret = read_poll_timeout(pcs_read, val,
> +				!(val & TXGBE_PCS_DIG_CTRL1_VR_RST),
> +				100000, 10000000, false,
> +				txgbe, MDIO_MMD_PCS, TXGBE_PCS_DIG_CTRL1);
> +	if (ret < 0)
> +		wx_err(wx, "PHY initialization timeout.\n");
> +
> +	txgbe->interface = interface;
> +
> +out:
> +	if (interface == PHY_INTERFACE_MODE_1000BASEX) {
> +		txgbe_setup_adv(txgbe, interface, advertising);

		ret = txgbe_setup_adv(txgbe, interface, advertising);
		if (ret < 0)
			return ret;

> +		txgbe_set_an37_ability(txgbe);
> +	}
> +
> +	return ret;

... and then this will propagate whether the advertisement has changed,
which will then cause...

> +static void txgbe_pcs_an_restart(struct phylink_pcs *pcs)
> +{
> +	struct txgbe *txgbe = container_of(pcs, struct txgbe, pcs);
> +
> +	mdiodev_c45_modify(txgbe->mdiodev, MDIO_MMD_VEND2, MDIO_CTRL1,
> +			   BMCR_ANRESTART, BMCR_ANRESTART);
> +}

to be called whenever the advertisement changes (which is why you
then don't need to do it in txgbe_set_an37_ability().)

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 80Mbps down 10Mbps up. Decent connectivity at last!
