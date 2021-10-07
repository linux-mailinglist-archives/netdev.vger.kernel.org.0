Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EC46D424B32
	for <lists+netdev@lfdr.de>; Thu,  7 Oct 2021 02:41:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239827AbhJGAnH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Oct 2021 20:43:07 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:53320 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230322AbhJGAnH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 6 Oct 2021 20:43:07 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=5K7qcDlq4RZ6lpfn0SCdrnPNAK/SR3daiPXhg8pdiOU=; b=cR5OIDt+AliyibIBspUJ9hRr3t
        faWcb7fI7ksPUMtyiiqKnX4UH2AyunFctOPjC72uWJlEN8MXGM3LE3ZPsOmq0+hRPlc4kKn7g09Oh
        4uvKRI83xw2z9fh9AkE4Rd4GHKOEoIY89g2KDBYGFqpUM7aX18W/Gp57zeY4+NP4w9UA=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1mYHTC-009tKz-4G; Thu, 07 Oct 2021 02:41:10 +0200
Date:   Thu, 7 Oct 2021 02:41:10 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Ansuel Smith <ansuelsmth@gmail.com>
Cc:     Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [net-next PATCH 12/13] drivers: net: dsa: qca8k: add support for
 pws config reg
Message-ID: <YV5CJvb2k1/61IU2@lunn.ch>
References: <20211006223603.18858-1-ansuelsmth@gmail.com>
 <20211006223603.18858-13-ansuelsmth@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211006223603.18858-13-ansuelsmth@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> +static int
> +qca8k_setup_of_pws_reg(struct qca8k_priv *priv)
> +{
> +	struct device_node *node = priv->dev->of_node;
> +	u32 val = 0;
> +
> +	if (priv->switch_id == QCA8K_ID_QCA8327)
> +		if (of_property_read_bool(node, "qca,package48"))
> +			val |= QCA8327_PWS_PACKAGE48_EN;

What does this actually do? How is PACKAGE48 different to normal mode?

> +
> +	if (of_property_read_bool(node, "qca,power-on-sel"))
> +		val |= QCA8K_PWS_POWER_ON_SEL;

What happens if you unconditionally do this? Why is a DT property
required?

> +
> +	if (of_property_read_bool(node, "qca,led-open-drain"))
> +		/* POWER_ON_SEL needs to be set when configuring led to open drain */
> +		val |= QCA8K_PWS_LED_OPEN_EN_CSR | QCA8K_PWS_POWER_ON_SEL;

This is getting into territory of adding LED support for PHYs, which
we want to do via the LED subsystem.

   Andrew
