Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DB1D858CEED
	for <lists+netdev@lfdr.de>; Mon,  8 Aug 2022 22:13:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238096AbiHHUNp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Aug 2022 16:13:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38448 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231527AbiHHUNo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Aug 2022 16:13:44 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 822B1109B;
        Mon,  8 Aug 2022 13:13:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=ThFI7Ax7C1Cn3jLUZILW1k1+Pp+HEQIbEwmrqGliX8k=; b=M9nDUPUC6SVJ6oheLfui7IYTHl
        JaHUbXCA1X6X6Wumd2iB4PteYn6Dai5IcAjw6CoRKTa4wu2H9lwvOfaTyqr8C+8FU27Yh8HqXv3W+
        AdhboDBGx0kzcGe52KwnFJGcWcG58DyXNotlTx8c21ofCwnTnOSBmVKDmOKho8sLYnCI=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1oL981-00CkxX-1u; Mon, 08 Aug 2022 22:13:33 +0200
Date:   Mon, 8 Aug 2022 22:13:33 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Ravi Gunasekaran <r-gunasekaran@ti.com>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, linux-omap@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, kishon@ti.com,
        vigneshr@ti.com
Subject: Re: [RESEND PATCH] net: ethernet: ti: davinci_mdio: Add workaround
 for errata i2329
Message-ID: <YvFubdCiU7J8Ufi4@lunn.ch>
References: <20220808111229.11951-1-r-gunasekaran@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220808111229.11951-1-r-gunasekaran@ti.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> +static int davinci_mdio_sw_read(struct mii_bus *bus, int phy_id, int phy_reg)
> +{
> +	struct davinci_mdio_data *data = bus->priv;
> +	u32 reg, i;
> +	int ret;
> +	u8 ack;
> +
> +	if (phy_reg & ~PHY_REG_MASK || phy_id & ~PHY_ID_MASK)
> +		return -EINVAL;
> +
> +	ret = pm_runtime_get_sync(data->dev);
> +	if (ret < 0) {
> +		pm_runtime_put_noidle(data->dev);
> +		return ret;
> +	}
> +
> +	davinci_mdio_disable(data);
> +	davinci_mdio_enable_manual_mode(data);
> +	davinci_mdio_sw_preamble(data);
> +
> +	davinci_mdio_sw_clr_bit(data, MDIO_MDCLK);
> +	davinci_mdio_sw_set_bit(data, MDIO_OE);
> +
> +	 /* Issue clause 22 MII read function {0,1,1,0} */
> +	davinci_mdio_man_send_pattern(data, C22_BITRANGE, C22_READ_PATTERN);
> +
> +	/* Send the device number MSB first */
> +	davinci_mdio_man_send_pattern(data, PHY_BITRANGE, phy_id);
> +
> +	/* Send the register number MSB first */
> +	davinci_mdio_man_send_pattern(data, PHY_BITRANGE, phy_reg);
> +
> +	/* Send turn around cycles */
> +	davinci_mdio_sw_clr_bit(data, MDIO_OE);
> +
> +	davinci_mdio_toggle_man_bit(data, MDIO_MDCLK);
> +
> +	ack = davinci_mdio_test_man_bit(data, MDIO_PIN);
> +	davinci_mdio_toggle_man_bit(data, MDIO_MDCLK);
> +
> +	reg = 0;
> +	if (ack == 0) {
> +		for (i = MDIO_BITRANGE; i; i = i >> 1) {
> +			if (davinci_mdio_test_man_bit(data, MDIO_PIN))
> +				reg |= i;
> +
> +			davinci_mdio_toggle_man_bit(data, MDIO_MDCLK);
> +		}
> +	} else {
> +		for (i = MDIO_BITRANGE; i; i = i >> 1)
> +			davinci_mdio_toggle_man_bit(data, MDIO_MDCLK);
> +
> +		reg = 0xFFFF;
> +	}
> +
> +	davinci_mdio_sw_clr_bit(data, MDIO_MDCLK);
> +	davinci_mdio_sw_set_bit(data, MDIO_MDCLK);
> +	davinci_mdio_sw_set_bit(data, MDIO_MDCLK);
> +	davinci_mdio_toggle_man_bit(data, MDIO_MDCLK);

You appear to of re-invented drivers/net/mdio/mdio-bitbang.c

If there is a reason this cannot be used, please at least state it in
the commit message.

    Andrew
