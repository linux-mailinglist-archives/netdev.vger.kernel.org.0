Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A7F7351B55E
	for <lists+netdev@lfdr.de>; Thu,  5 May 2022 03:46:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236218AbiEEBuA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 May 2022 21:50:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59338 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235887AbiEEBt7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 May 2022 21:49:59 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1FEB71037;
        Wed,  4 May 2022 18:46:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=wP+yhgO9708LV/mXAnbEvaVQwS2jYiUd7rRm1lrxg8Y=; b=c3i7JN4a/FesuLyUv7OQZKmrhQ
        S0LkNjERj2/FAuFAk0mTXrwwoFgFVvi+45TGstGLZjzQkqrhMsrcNDIQmMbEAtfeH1VjKeFyLnj+f
        5z58Xkt+oEABagxvSmNjEA/n8+6zsDb89oBFE51d8rEAqi1WYZlyXzqgJm6RwUrkigmQ=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1nmQZJ-001Hz6-Bw; Thu, 05 May 2022 03:46:13 +0200
Date:   Thu, 5 May 2022 03:46:13 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Ansuel Smith <ansuelsmth@gmail.com>
Cc:     Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzk+dt@kernel.org>,
        Jonathan Corbet <corbet@lwn.net>, Pavel Machek <pavel@ucw.cz>,
        John Crispin <john@phrozen.org>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-leds@vger.kernel.org
Subject: Re: [RFC PATCH v6 10/11] net: dsa: qca8k: add LEDs support
Message-ID: <YnMsZc6kJ/YEOGWF@lunn.ch>
References: <20220503151633.18760-1-ansuelsmth@gmail.com>
 <20220503151633.18760-11-ansuelsmth@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220503151633.18760-11-ansuelsmth@gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> +config NET_DSA_QCA8K_LEDS_SUPPORT
> +	tristate "Qualcomm Atheros QCA8K Ethernet switch family LEDs support"
> +	select NET_DSA_QCA8K

The should be a depends, not a select. It will then become visible
when the NET_DSA_QCA8K directly above it is enabled.

> +	select LEDS_OFFLOAD_TRIGGERS

and this should also be a depends. If the LED core does not have
support, the QCA8K driver should not enable its support.

> +static int
> +qca8k_parse_netdev(unsigned long rules, u32 *offload_trigger, u32 *mask)
> +{
> +	/* Parsing specific to netdev trigger */
> +	if (test_bit(TRIGGER_NETDEV_LINK, &rules))
> +		*offload_trigger = QCA8K_LED_LINK_10M_EN_MASK |
> +				   QCA8K_LED_LINK_100M_EN_MASK |
> +				   QCA8K_LED_LINK_1000M_EN_MASK;
> +	if (test_bit(TRIGGER_NETDEV_LINK_10, &rules))
> +		*offload_trigger = QCA8K_LED_LINK_10M_EN_MASK;
> +	if (test_bit(TRIGGER_NETDEV_LINK_100, &rules))
> +		*offload_trigger = QCA8K_LED_LINK_100M_EN_MASK;
> +	if (test_bit(TRIGGER_NETDEV_LINK_1000, &rules))
> +		*offload_trigger = QCA8K_LED_LINK_1000M_EN_MASK;
> +	if (test_bit(TRIGGER_NETDEV_HALF_DUPLEX, &rules))
> +		*offload_trigger = QCA8K_LED_HALF_DUPLEX_MASK;
> +	if (test_bit(TRIGGER_NETDEV_FULL_DUPLEX, &rules))
> +		*offload_trigger = QCA8K_LED_FULL_DUPLEX_MASK;
> +	if (test_bit(TRIGGER_NETDEV_TX, &rules))
> +		*offload_trigger = QCA8K_LED_TX_BLINK_MASK;
> +	if (test_bit(TRIGGER_NETDEV_RX, &rules))
> +		*offload_trigger = QCA8K_LED_RX_BLINK_MASK;
> +	if (test_bit(TRIGGER_NETDEV_BLINK_2HZ, &rules))
> +		*offload_trigger = QCA8K_LED_BLINK_2HZ;
> +	if (test_bit(TRIGGER_NETDEV_BLINK_4HZ, &rules))
> +		*offload_trigger = QCA8K_LED_BLINK_4HZ;
> +	if (test_bit(TRIGGER_NETDEV_BLINK_8HZ, &rules))
> +		*offload_trigger = QCA8K_LED_BLINK_8HZ;
> +
> +	pr_info("OFFLOAD TRIGGER %x\n", *offload_trigger);

leftover debug print.

	 Andrew
