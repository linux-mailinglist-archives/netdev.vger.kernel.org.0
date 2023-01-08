Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 60664661664
	for <lists+netdev@lfdr.de>; Sun,  8 Jan 2023 17:00:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231269AbjAHQAu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 8 Jan 2023 11:00:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56606 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230052AbjAHQAt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 8 Jan 2023 11:00:49 -0500
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 79448BCB5
        for <netdev@vger.kernel.org>; Sun,  8 Jan 2023 08:00:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=ixaXoc4btN4wULFpTi1mw7bNa1htvRkZKDe/aTwZi5U=; b=MQ+5p5JKjbTOTPOhZDoJQIOLmJ
        YQ2sRrX6MNadD+Svn+e7w09Xm1Kev7T6yigN3b9T8N81e3aBQov3OEes3cpE8ApXwzSPryxRtAiSo
        +DWR4iMXFBWBwL5VoHyvUoOmoXG7BA6u+FLNE4/CEhIq2Dj5i7KoIIei5xaUQoVTdc2U=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1pEY6E-001UeH-7K; Sun, 08 Jan 2023 17:00:42 +0100
Date:   Sun, 8 Jan 2023 17:00:42 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Mengyuan Lou <mengyuanlou@net-swift.com>
Cc:     netdev@vger.kernel.org, jiawenwu@net-swift.com
Subject: Re: [PATCH net-next v6] net: ngbe: Add ngbe mdio bus driver.
Message-ID: <Y7roqgyjDN91hSIH@lunn.ch>
References: <20230108093903.27054-1-mengyuanlou@net-swift.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230108093903.27054-1-mengyuanlou@net-swift.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> +static int ngbe_phy_read_reg_internal(struct mii_bus *bus, int phy_addr, int regnum)
> +{
> +	struct wx *wx = bus->priv;
> +
> +	if (regnum & MII_ADDR_C45)
> +		return -EOPNOTSUPP;
> +	return (u16)rd32(wx, NGBE_PHY_CONFIG(regnum));

You ignore phy_addr. Which suggests you only allow one internal
PHY. Best practice here is to put the internal PHY on phy_addr 0, and
return 0xffff for all other phy_addr values. If phylib probes the full
range, or userspace tries to access the full range, it will look like
there is no PHY at these other addresses.

> +}
> +
> +static int ngbe_phy_write_reg_internal(struct mii_bus *bus, int phy_addr, int regnum, u16 value)
> +{
> +	struct wx *wx = bus->priv;
> +
> +	if (regnum & MII_ADDR_C45)
> +		return -EOPNOTSUPP;
> +	wr32(wx, NGBE_PHY_CONFIG(regnum), value);
> +	return 0;

Here, silently ignore writes to phy_addr != 0.

> +	/* wait to complete */
> +	ret = read_poll_timeout(rd32, val, !(val & NGBE_MSCC_BUSY), 1000,
> +				100000, false, wx, NGBE_MSCC);
> +	if (ret) {
> +		wx_err(wx, "PHY address command did not complete.\n");
> +		return ret;
> +	}
> +
> +	return (u16)rd32(wx, NGBE_MSCC);
> +}
> +
> +	/* wait to complete */
> +	ret = read_poll_timeout(rd32, val, !(val & NGBE_MSCC_BUSY), 1000,
> +				100000, false, wx, NGBE_MSCC);
> +	if (ret)
> +		wx_err(wx, "PHY address command did not complete.\n");

You have the exact same error message. When you see such an error in
the log, it can sometimes be useful to know was it a read or a write
which failed. So i would suggest you put read/write into the message.

> +static void ngbe_phy_fixup(struct wx *wx)
> +{
> +	struct phy_device *phydev = wx->phydev;
> +	struct ethtool_eee eee;
> +
> +	if (wx->mac_type != em_mac_type_mdi)
> +		return;

Does this mean that if using the internal PHY the MAC does support EEE
and half duplex?

> +	/* disable EEE, EEE not supported by mac */
> +	memset(&eee, 0, sizeof(eee));
> +	phy_ethtool_set_eee(phydev, &eee);
> +
> +	phy_remove_link_mode(phydev, ETHTOOL_LINK_MODE_10baseT_Half_BIT);
> +	phy_remove_link_mode(phydev, ETHTOOL_LINK_MODE_100baseT_Half_BIT);
> +	phy_remove_link_mode(phydev, ETHTOOL_LINK_MODE_1000baseT_Half_BIT);
> +}
> +
> +int ngbe_mdio_init(struct wx *wx)
> +{
> +	struct pci_dev *pdev = wx->pdev;
> +	struct mii_bus *mii_bus;
> +	int ret;
> +
> +	mii_bus = devm_mdiobus_alloc(&pdev->dev);
> +	if (!mii_bus)
> +		return -ENOMEM;
> +
> +	mii_bus->name = "ngbe_mii_bus";
> +	mii_bus->read = ngbe_phy_read_reg;
> +	mii_bus->write = ngbe_phy_write_reg;
> +	mii_bus->phy_mask = GENMASK(31, 4);
> +	mii_bus->probe_capabilities = MDIOBUS_C22_C45;

That is not strictly true. The internal MDIO bus does not suport
C45. In practice, it probably does not matter.

     Andrew
