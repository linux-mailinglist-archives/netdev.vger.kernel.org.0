Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 444CC619B85
	for <lists+netdev@lfdr.de>; Fri,  4 Nov 2022 16:26:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232594AbiKDP02 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Nov 2022 11:26:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35880 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232597AbiKDP0J (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Nov 2022 11:26:09 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6ED85F25;
        Fri,  4 Nov 2022 08:25:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=du3wTT7gZIcCx7MAzovG5KucdTPH1Tr3pydnZK/Rz0I=; b=46kNXdi9RR7s+GQLUwE/lyN5uE
        QNAC+e9tLj7U5tRxlATNLGezHv0SjgZPlhIU19uT5SK2VHL+JVpC1xJlQ2ZcvKpW1kTHaOjrzNp5j
        kNrSxT0EnKQEkUSbPLjBu0gTxdkdHzsa5J/eWp6yzsE9OHp4S0U58k0K/cRvHQp2mbeI=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1oqyZD-001RGc-Rq; Fri, 04 Nov 2022 16:25:11 +0100
Date:   Fri, 4 Nov 2022 16:25:11 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Sriranjani P <sriranjani.p@samsung.com>
Cc:     peppe.cavallaro@st.com, alexandre.torgue@foss.st.com,
        joabreu@synopsys.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, mcoquelin.stm32@gmail.com,
        richardcochran@gmail.com, netdev@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Chandrasekar R <rcsekar@samsung.com>,
        Suresh Siddha <ssiddha@tesla.com>
Subject: Re: [PATCH 2/4] net: stmmac: dwc-qos: Add FSD EQoS support
Message-ID: <Y2Uu16RSF9Py5AdC@lunn.ch>
References: <20221104120517.77980-1-sriranjani.p@samsung.com>
 <CGME20221104115854epcas5p4ca280f9c4cc4d1fa564d80016e9f0061@epcas5p4.samsung.com>
 <20221104120517.77980-3-sriranjani.p@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221104120517.77980-3-sriranjani.p@samsung.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> +static int dwc_eqos_setup_rxclock(struct platform_device *pdev)
> +{
> +	struct device_node *np = pdev->dev.of_node;
> +
> +	if (np && of_property_read_bool(np, "rx-clock-mux")) {
> +		unsigned int reg, val;
> +		struct regmap *syscon = syscon_regmap_lookup_by_phandle(np,
> +			"rx-clock-mux");
> +
> +		if (IS_ERR(syscon)) {
> +			dev_err(&pdev->dev, "couldn't get the rx-clock-mux syscon!\n");
> +			return PTR_ERR(syscon);
> +		}
> +
> +		if (of_property_read_u32_index(np, "rx-clock-mux", 1, &reg)) {
> +			dev_err(&pdev->dev, "couldn't get the rx-clock-mux reg. offset!\n");
> +			return -EINVAL;
> +		}
> +
> +		if (of_property_read_u32_index(np, "rx-clock-mux", 2, &val)) {
> +			dev_err(&pdev->dev, "couldn't get the rx-clock-mux reg. val!\n");
> +			return -EINVAL;
> +		}
> +
> +		regmap_write(syscon, reg, val);

This appears to be one of those binds which allows any magic value to
be placed into any register. That is not how DT should be used.

   Andrew
