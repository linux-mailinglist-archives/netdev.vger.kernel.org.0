Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EA42B59FE15
	for <lists+netdev@lfdr.de>; Wed, 24 Aug 2022 17:17:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239099AbiHXPRk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Aug 2022 11:17:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44950 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237364AbiHXPRj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Aug 2022 11:17:39 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 579BD9751A;
        Wed, 24 Aug 2022 08:17:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=/DMqll070o37agD4hsR3LykeohYCZM/DzML8AAPUSfc=; b=tBUcZ/ifE4bkciSs79+f9iLzeP
        WojU4oFOqOdyCzMkrzzLtGQpH7LHlksMfsaPhAYRqLX9H1+KlQjZToDI0I63CaOLZW6+QaZFCfF4z
        jICERoj4yl9fQ4FAql0gXN7ig63gl7b1IRvz2dW+7YKU6wItW8iAx8dMQ9ngZksgBu9A=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1oQs83-00ESQC-Hb; Wed, 24 Aug 2022 17:17:15 +0200
Date:   Wed, 24 Aug 2022 17:17:15 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     "xiaowu.ding" <xiaowu.ding@jaguarmicro.com>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, linux@armlinux.org.uk,
        nicolas.ferre@microchip.com, claudiu.beznea@microchip.com,
        palmer@dabbelt.com, paul.walmsley@sifive.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-riscv@lists.infradead.org
Subject: Re: [PATCH net-next] driver: cadence macb driver support acpi mode
Message-ID: <YwZA+1z7BDCXZn/3@lunn.ch>
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

> +/* On ACPI platforms, clocks are controlled by firmware and/or
> + * ACPI, not by drivers.Need to store the clock value.
> + */
> +struct macb_acpi_config {
> +	u32 hclk_rate;          /* amba clock rate*/
> +	u32 pclk_rate;          /* amba apb clock rate*/
> +	u32 txclk_rate;         /* tx clock rate*/
> +	u32 rxclk_rate;         /* rx clock rate*/
> +	u32 tsuclk_rate;        /* tx clock rate*/
> +	bool acpi_enable;       /* is acpi or not */
> +};

> +static int macb_acpi_support(struct macb *bp)
> +{
> +	struct device *dev = &bp->pdev->dev;
> +	struct macb_acpi_config *config = &bp->acpicfg;
> +	int ret;
> +	u32 property;
> +
> +	/*acpi must be report the pclk*/
> +	property = 0;
> +	ret = device_property_read_u32(dev, MACB_SYSPCLOCK, &property);
> +	if (ret) {
> +		dev_err(dev, "unable to obtain %s property\n", MACB_SYSPCLOCK);
> +		return ret;
> +	}
> +
> +	config->pclk_rate = property;

It seems like you could make this simpler by just calling

clk_hw_register_fixed_rate(dev, "pclk", NULL, 0, property);

You then don't need to modify any other code with respect to clocks.
The clock does exist, so model it in the common clock framework.

    Andrew
