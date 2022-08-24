Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 54E6359FE43
	for <lists+netdev@lfdr.de>; Wed, 24 Aug 2022 17:26:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239485AbiHXP0O (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Aug 2022 11:26:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53378 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236041AbiHXP0M (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Aug 2022 11:26:12 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D53CC98D24;
        Wed, 24 Aug 2022 08:26:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=U0I4VNyd6UEPv89YnVrPz+VloLo8M8ZsDyOs3TAfHhs=; b=MToQ2tSQN2DWtO2/j/lt0ak4bw
        x4XIRacCpnosU/jr3X3xc5n8JExVkuyWq3+tDjWw4NnG4PYSrt8x6+R22THzK/xwWdKq1O2l4EpcD
        NuUJ9cQIEr82HATZpEqTmaOr34RMkeQHwvTxHnCkv5zlJtvAigvzONztMJC+wzlDTt70=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1oQsGR-00ESUS-80; Wed, 24 Aug 2022 17:25:55 +0200
Date:   Wed, 24 Aug 2022 17:25:55 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     "xiaowu.ding" <xiaowu.ding@jaguarmicro.com>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, linux@armlinux.org.uk,
        nicolas.ferre@microchip.com, claudiu.beznea@microchip.com,
        palmer@dabbelt.com, paul.walmsley@sifive.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-riscv@lists.infradead.org
Subject: Re: [PATCH net-next] driver: cadence macb driver support acpi mode
Message-ID: <YwZDA0CuYwPE6DM2@lunn.ch>
References: <20220824121351.578-1-xiaowu.ding@jaguarmicro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220824121351.578-1-xiaowu.ding@jaguarmicro.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> +static int macb_acpi_phylink_connect(struct macb *bp)
> +{
> +	struct fwnode_handle *fwnd = bp->pdev->dev.fwnode;
> +	struct net_device *dev = bp->dev;
> +	struct phy_device *phydev;
> +	int ret;
> +
> +	if (fwnd)
> +		ret = phylink_fwnode_phy_connect(bp->phylink, fwnd, 0);
> +
> +	if (!fwnd || (ret && !macb_acpi_phy_handle_exists(fwnd))) {
> +		phydev = phy_find_first(bp->mii_bus);

Please don't use phy_find_first. That is somewhat historical. Since
this is a new binding, simply error out if
phylink_fwnode_phy_connect() fails.

> +static int macb_acpi_mdiobus_register(struct macb *bp)
> +{
> +	struct platform_device *pdev =	bp->pdev;
> +	struct fwnode_handle *fwnode = pdev->dev.fwnode;
> +	struct fwnode_handle *child;
> +	u32 addr;
> +	int ret;
> +
> +	if (!IS_ERR_OR_NULL(fwnode_find_reference(pdev->dev.fwnode, "fixed-link", 0)))
> +		return mdiobus_register(bp->mii_bus);
> +
> +	fwnode_for_each_child_node(fwnode, child) {
> +		ret = acpi_get_local_address(ACPI_HANDLE_FWNODE(child), &addr);
> +		if (ret || addr >= PHY_MAX_ADDR)
> +			continue;
> +		ret = acpi_mdiobus_register(bp->mii_bus, fwnode);
> +		if (!ret)
> +			return ret;
> +		break;

Why loop looking for a node with a register value < 32?

Please make sure you are conformant with Documentation/firmware-guide/acpi/dsd/phy.rst

       Andrew
