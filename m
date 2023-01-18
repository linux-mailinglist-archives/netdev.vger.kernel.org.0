Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A474367116E
	for <lists+netdev@lfdr.de>; Wed, 18 Jan 2023 04:02:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229717AbjARDCu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Jan 2023 22:02:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37434 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229453AbjARDCt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Jan 2023 22:02:49 -0500
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D6C714FC3F;
        Tue, 17 Jan 2023 19:02:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=YpFIqPtiW9OaArCWKSRp3L+DqFNQiRH+JQ1OhEOlGjI=; b=rxrXmtzX8EDhlqVUNG11/gu1vH
        shFj+DiZINeRAGuhzhZj7Z2VUE5toQKxh0HgQcmt+heR4x5DTEyzFKc6lh71kxN6eGIEI8+yRV3IT
        0AlvXJeiM81lkLXQZ0jFMd9iA2i7kJ+imPcrq1MpLFWrGxrPOFK9H2F29MwKxWx5wuIE=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1pHyip-002OEV-MM; Wed, 18 Jan 2023 04:02:43 +0100
Date:   Wed, 18 Jan 2023 04:02:43 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Jerome Brunet <jbrunet@baylibre.com>
Cc:     netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        linux-amlogic@lists.infradead.org,
        Kevin Hilman <khilman@baylibre.com>,
        Neil Armstrong <neil.armstrong@linaro.org>,
        Da Xue <da@lessconfused.com>, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next 2/2] net: mdio: add amlogic gxl mdio mux support
Message-ID: <Y8dhUwIMb4tTeqWN@lunn.ch>
References: <20230116091637.272923-1-jbrunet@baylibre.com>
 <20230116091637.272923-3-jbrunet@baylibre.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230116091637.272923-3-jbrunet@baylibre.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> +static int gxl_enable_internal_mdio(struct gxl_mdio_mux *priv)
> +{
> +	u32 val;
> +
> + 	/* Setup the internal phy */
> +	val = (REG3_ENH |
> +	       FIELD_PREP(REG3_CFGMODE, 0x7) |
> +	       REG3_AUTOMDIX |
> +	       FIELD_PREP(REG3_PHYADDR, 8) |
> +	       REG3_LEDPOL |
> +	       REG3_PHYMDI |
> +	       REG3_CLKINEN |
> +	       REG3_PHYIP);
> +
> +	writel_relaxed(REG4_PWRUPRSTSIG, priv->regs + ETH_REG4);
> +	writel_relaxed(val, priv->regs + ETH_REG3);
> +	mdelay(10);

Probably the second _relaxed() should not be. You want it guaranteed
to be written out before you do the mdelay().

> +
> +	/* Set the internal phy id */
> +	writel_relaxed(FIELD_PREP(REG2_PHYID, 0x110181),
> +		       priv->regs + ETH_REG2);

So how does this play with what Heiner has been reporting recently?
What is the reset default? Who determined this value?

> +	/* Enable the internal phy */
> +	val |= REG3_PHYEN;
> +	writel_relaxed(val, priv->regs + ETH_REG3);
> +	writel_relaxed(0, priv->regs + ETH_REG4);
> +
> +	/* The phy needs a bit of time to come up */
> +	mdelay(10);

What do you mean by 'come up'? Not link up i assume. But maybe it will
not respond to MDIO requests?

    Andrew
