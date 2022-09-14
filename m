Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8A1F75B8C17
	for <lists+netdev@lfdr.de>; Wed, 14 Sep 2022 17:41:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229744AbiINPln (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Sep 2022 11:41:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57662 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230205AbiINPl1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Sep 2022 11:41:27 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DEFCA31DD9;
        Wed, 14 Sep 2022 08:41:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=+/Tlbli6dmKOW4NjYwLwzvti9ZsiTxMiylOYMJbYirE=; b=xUmBi4TeHDhoq0VWrwV6lv8xN7
        vbU2AJwVxEe//asqujXEXPLAOtceiFrdlXFvXlDjON9Dwqm7ku3QI0xKLY9zESr0+Tu9tbAVqVIwD
        EszKmJzkpuo8poZ1uWdPNjVR+1qV9o2aIsRbkCMEMQ3CjnizPQY1QlL7+SXSsyiXA/Asi0gHtyHoe
        zwq/GNHQVV/yIRUZzT8/g9RNz/JWDJXB4QZrk+X/nSCV3XYTJ8ErqCVXC7RGD4kWmCQ9rEuazV21t
        csryCrrmKiOzwFCifRIWv/Fm8O7zinTIoDd4hUks/lU8zLJFInckCz5RO24mDPWF5T+vgFtZMTPuV
        7eEymAqg==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:34322)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1oYUVm-0004YW-H6; Wed, 14 Sep 2022 16:41:14 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1oYUVl-0001lu-Pu; Wed, 14 Sep 2022 16:41:13 +0100
Date:   Wed, 14 Sep 2022 16:41:13 +0100
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Siddharth Vadapalli <s-vadapalli@ti.com>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, robh+dt@kernel.org,
        krzysztof.kozlowski@linaro.org, krzysztof.kozlowski+dt@linaro.org,
        vladimir.oltean@nxp.com, grygorii.strashko@ti.com, vigneshr@ti.com,
        nsekhar@ti.com, netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        kishon@ti.com
Subject: Re: [PATCH 5/8] net: ethernet: ti: am65-cpsw: Add support for
 fixed-link configuration
Message-ID: <YyH2GcLCAN+9GAn8@shell.armlinux.org.uk>
References: <20220914095053.189851-1-s-vadapalli@ti.com>
 <20220914095053.189851-6-s-vadapalli@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220914095053.189851-6-s-vadapalli@ti.com>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Sep 14, 2022 at 03:20:50PM +0530, Siddharth Vadapalli wrote:
> diff --git a/drivers/net/ethernet/ti/am65-cpsw-nuss.c b/drivers/net/ethernet/ti/am65-cpsw-nuss.c
> index 72b1df12f320..1739c389af20 100644
> --- a/drivers/net/ethernet/ti/am65-cpsw-nuss.c
> +++ b/drivers/net/ethernet/ti/am65-cpsw-nuss.c
> @@ -1494,10 +1494,50 @@ static void am65_cpsw_nuss_mac_config(struct phylink_config *config, unsigned in
>  							  phylink_config);
>  	struct am65_cpsw_port *port = container_of(slave, struct am65_cpsw_port, slave);
>  	struct am65_cpsw_common *common = port->common;
> +	struct fwnode_handle *fwnode;
> +	bool fixed_link = false;
>  
>  	if (common->pdata.extra_modes & BIT(state->interface))
>  		writel(AM65_CPSW_SGMII_CONTROL_MR_AN_ENABLE,
>  		       port->sgmii_base + AM65_CPSW_SGMII_CONTROL_REG);
> +
> +	/* Detecting fixed-link */
> +	fwnode = of_node_to_fwnode(port->slave.phy_node);
> +	if (fwnode)
> +		fixed_link = !!fwnode_get_named_child_node(fwnode, "fixed-link");
> +
> +	if (fixed_link) {
> +		/* In fixed-link mode, mac_link_up is not invoked.
> +		 * Therefore, the relevant mac_link_up operations
> +		 * have to be moved to mac_config.
> +		 */

This seems very wrong. Why is mac_link_up() not invoked? Have you
debugged this? It works for other people.

Please debug rather than adding hacks to drivers when you find
things that don't seem to work.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
