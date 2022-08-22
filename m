Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 078BB59C96B
	for <lists+netdev@lfdr.de>; Mon, 22 Aug 2022 21:59:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232622AbiHVT7B (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Aug 2022 15:59:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47710 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238182AbiHVT6t (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Aug 2022 15:58:49 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1025BEE34
        for <netdev@vger.kernel.org>; Mon, 22 Aug 2022 12:58:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=4Bw8UV1Kzy1iXxj58t7hUGSPdBxjQE26X/mlK7UivdE=; b=yt17uGT88tFPvyhTpzech9TQ+T
        ruj+0F9gES0yHsZXwU5hSQj8ooQXAzxdqy6whVCt6MVi3u2t07WrwuMNNKGAYX6HAUNf4vyazAZzN
        Qt5QnVsPfcuPyJJ6s2ly1vX0Bs7SkFd0OEwyQvyjYZOoGr7i2lDodTgmmgEprnzqr3vE=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1oQDZL-00EG7F-UH; Mon, 22 Aug 2022 21:58:43 +0200
Date:   Mon, 22 Aug 2022 21:58:43 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Chunhao Lin <hau@realtek.com>
Cc:     hkallweit1@gmail.com, netdev@vger.kernel.org, nic_swsd@realtek.com,
        kuba@kernel.org, davem@davemloft.net
Subject: Re: [PATCH v3 net-next] r8169: add support for rtl8168h(revid 0x2a)
 + rtl8211fs fiber application
Message-ID: <YwPf8yXud3mYFvnW@lunn.ch>
References: <20220822160714.2904-1-hau@realtek.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220822160714.2904-1-hau@realtek.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> @@ -914,8 +952,12 @@ static void r8168g_mdio_write(struct rtl8169_private *tp, int reg, int value)
>  	if (tp->ocp_base != OCP_STD_PHY_BASE)
>  		reg -= 0x10;
>  
> -	if (tp->ocp_base == OCP_STD_PHY_BASE && reg == MII_BMCR)
> +	if (tp->ocp_base == OCP_STD_PHY_BASE && reg == MII_BMCR) {
> +		if (tp->sfp_if_type != RTL_SFP_IF_NONE && value & BMCR_PDOWN)
> +			return;
> +

Please could you explain this change.

> +/* Data I/O pin control */
> +static void rtl_mdio_dir(struct mdiobb_ctrl *ctrl, int output)
> +{
> +	struct bb_info *bitbang = container_of(ctrl, struct bb_info, ctrl);
> +	struct rtl8169_private *tp = bitbang->tp;
> +	const u16 reg = PINOE;
> +	const u16 mask = bitbang->sfp_mask.mdio_oe_mask;
> +	u16 value;

Reverse christmas tree please. Please sort this, longest first.

> +/* MDIO bus init function */
> +static int rtl_mdio_bitbang_init(struct rtl8169_private *tp)
> +{
> +	struct bb_info *bitbang;
> +	struct device *d = tp_to_dev(tp);
> +	struct mii_bus *new_bus;
> +
> +	/* create bit control struct for PHY */
> +	bitbang = devm_kzalloc(d, sizeof(struct bb_info), GFP_KERNEL);
> +	if (!bitbang)
> +		return -ENOMEM;
> +
> +	/* bitbang init */
> +	bitbang->tp = tp;
> +	bitbang->ctrl.ops = &bb_ops;
> +	bitbang->ctrl.op_c22_read = MDIO_READ;
> +	bitbang->ctrl.op_c22_write = MDIO_WRITE;
> +
> +	/* MII controller setting */
> +	new_bus = devm_mdiobus_alloc(d);
> +	if (!new_bus)
> +		return -ENOMEM;
> +
> +	new_bus->read = mdiobb_read;
> +	new_bus->write = mdiobb_write;
> +	new_bus->priv = &bitbang->ctrl;

Please use alloc_mdio_bitbang().

> +static u16 rtl_sfp_mdio_read(struct rtl8169_private *tp,
> +				  u8 reg)
> +{
> +	struct mii_bus *bus = tp->mii_bus;
> +	struct bb_info *bitbang;
> +
> +	if (!bus)
> +		return ~0;
> +
> +	bitbang = container_of(bus->priv, struct bb_info, ctrl);
> +
> +	return bus->read(bus, bitbang->sfp_mask.phy_addr, reg);

By doing this, you are bypassing all the locking. You don't normally
need operations like this. When you register the MDIO bus to the core,
it will go find any PHYs on the bus. You can then use phylib to access
the PHY. A MAC accessing the PHY is generally wrong.

    Andrew
