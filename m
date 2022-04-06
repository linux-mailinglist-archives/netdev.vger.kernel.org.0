Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8EE1F4F69FD
	for <lists+netdev@lfdr.de>; Wed,  6 Apr 2022 21:31:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231827AbiDFTdH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Apr 2022 15:33:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52650 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232038AbiDFTct (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Apr 2022 15:32:49 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B5AD43441B2;
        Wed,  6 Apr 2022 11:37:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=YGjX529UM3G1Sm5ZEV/Cp3ZmPunyP2OAVWthxaOm0TE=; b=tFJFatXB6xPNnIMbja6SvXD6Cu
        bXU3vUUO2xXCQztEU1jTleEdty4GRLL6fyovwu4ho7/XnxRC1YoSxvItgGIztyc6J2Yjr4HUEetQZ
        rNCnT4wt2/HAhtlf+zClghovZH7e4bhX8oK2ntrborSlj/r0U+pQu3ADTxv2fYmtBfz0=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1ncAXN-00EVLu-E7; Wed, 06 Apr 2022 20:37:49 +0200
Date:   Wed, 6 Apr 2022 20:37:49 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Puranjay Mohan <p-mohan@ti.com>
Cc:     linux-kernel@vger.kernel.org, bjorn.andersson@linaro.org,
        mathieu.poirier@linaro.org, krzysztof.kozlowski+dt@linaro.org,
        linux-remoteproc@vger.kernel.org, devicetree@vger.kernel.org,
        nm@ti.com, ssantosh@kernel.org, s-anna@ti.com,
        linux-arm-kernel@lists.infradead.org, davem@davemloft.net,
        kuba@kernel.org, netdev@vger.kernel.org, vigneshr@ti.com,
        kishon@ti.com
Subject: Re: [RFC 13/13] net: ti: icssg-prueth: Add ICSSG ethernet driver
Message-ID: <Yk3d/cC36fhNmfY2@lunn.ch>
References: <20220406094358.7895-1-p-mohan@ti.com>
 <20220406094358.7895-14-p-mohan@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220406094358.7895-14-p-mohan@ti.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> +static int emac_phy_connect(struct prueth_emac *emac)
> +{
> +	struct prueth *prueth = emac->prueth;
> +
> +	/* connect PHY */
> +	emac->phydev = of_phy_connect(emac->ndev, emac->phy_node,
> +				      &emac_adjust_link, 0, emac->phy_if);

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
> +
> +	return 0;
> +}
>

O.K, so this does not do what i initially thought it was doing. I was
thinking it was to fine tune the delay, ti,syscon-rgmii-delay would be
a small pico second value to allow the 2ns delay to be tuned to the
board.

But now i think this is actually inserting the full 2ns delay?

The problem is, you also pass phy_if to of_phy_connect() so the PHY
will also insert the delay if requested. So you end up with double
delays for rgmii_id and rgmii_txid.

The general recommendation is that the PHY inserts the delay, based on
phy-mode. The MAC does not add a delay, so i suggest you always write
0 here, just to ensure the system is in a deterministic state, and the
bootloader and not being messing around with things.

	   Andrew
