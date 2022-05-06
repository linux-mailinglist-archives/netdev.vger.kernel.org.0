Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 79E4F51DDDA
	for <lists+netdev@lfdr.de>; Fri,  6 May 2022 18:50:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350127AbiEFQxo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 May 2022 12:53:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53908 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243362AbiEFQxi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 May 2022 12:53:38 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7645D6D4F7;
        Fri,  6 May 2022 09:49:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=1OQQcDvkkNEvQjZeojL1nuOEg0Y+VYhEkbCVfA+kmTo=; b=YHhJLGXcJyZqOMkJOE8Dag5i08
        g0dqaKtodBoEnfVxpLJkDLuuY4RQFOKwt1W82mB7Gv+Y9CONq1KLjXKAi7njaRiHYJcsvtmMhaP1I
        kv10Ywx1whOA422jqTC3odMIGw+stJQHilp0F0b4TypEqfxeycAc+vKMKBncKeQrCuSs=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1nn19K-001Y7t-Fm; Fri, 06 May 2022 18:49:50 +0200
Date:   Fri, 6 May 2022 18:49:50 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Puranjay Mohan <p-mohan@ti.com>
Cc:     linux-kernel@vger.kernel.org, davem@davemloft.net,
        edumazet@google.com, krzysztof.kozlowski+dt@linaro.org,
        netdev@vger.kernel.org, devicetree@vger.kernel.org, nm@ti.com,
        ssantosh@kernel.org, s-anna@ti.com,
        linux-arm-kernel@lists.infradead.org, rogerq@kernel.org,
        grygorii.strashko@ti.com, vigneshr@ti.com, kishon@ti.com,
        robh+dt@kernel.org, afd@ti.com
Subject: Re: [PATCH 2/2] net: ti: icssg-prueth: Add ICSSG ethernet driver
Message-ID: <YnVRrk7fjPeme/JU@lunn.ch>
References: <20220506052433.28087-1-p-mohan@ti.com>
 <20220506052433.28087-3-p-mohan@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220506052433.28087-3-p-mohan@ti.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> +static int prueth_config_rgmiidelay(struct prueth *prueth,
> +				    struct device_node *eth_np,
> +				    phy_interface_t phy_if)
> +{
> +	struct device *dev = prueth->dev;
> +	struct regmap *ctrl_mmr;
> +	u32 rgmii_tx_id = 0;
> +	u32 icssgctrl_reg;
> +
> +	if (!phy_interface_mode_is_rgmii(phy_if))
> +		return 0;
> +
> +	ctrl_mmr = syscon_regmap_lookup_by_phandle(eth_np, "ti,syscon-rgmii-delay");
> +	if (IS_ERR(ctrl_mmr)) {
> +		dev_err(dev, "couldn't get ti,syscon-rgmii-delay\n");
> +		return -ENODEV;
> +	}
> +
> +	if (of_property_read_u32_index(eth_np, "ti,syscon-rgmii-delay", 1,
> +				       &icssgctrl_reg)) {
> +		dev_err(dev, "couldn't get ti,rgmii-delay reg. offset\n");
> +		return -ENODEV;
> +	}
> +
> +	if (phy_if == PHY_INTERFACE_MODE_RGMII_ID ||
> +	    phy_if == PHY_INTERFACE_MODE_RGMII_TXID)
> +		rgmii_tx_id |= ICSSG_CTRL_RGMII_ID_MODE;
> +
> +	regmap_update_bits(ctrl_mmr, icssgctrl_reg, ICSSG_CTRL_RGMII_ID_MODE, rgmii_tx_id);

I know we discussed this before. Why are you adding a delay here in
the MAC? If you do add the delay here, you need to mask what you pass
to phy_connect(), otherwise the PHY is also going to add a delay for
"id" and "txid".

In general, it is best to leave all delays to the PHY.

     Andrew
