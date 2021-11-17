Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0A96C454436
	for <lists+netdev@lfdr.de>; Wed, 17 Nov 2021 10:52:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235512AbhKQJzN convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Wed, 17 Nov 2021 04:55:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49760 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234710AbhKQJzM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Nov 2021 04:55:12 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B8506C061570
        for <netdev@vger.kernel.org>; Wed, 17 Nov 2021 01:52:13 -0800 (PST)
Received: from lupine.hi.pengutronix.de ([2001:67c:670:100:3ad5:47ff:feaf:1a17] helo=lupine)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <p.zabel@pengutronix.de>)
        id 1mnHbn-0003nK-Fo; Wed, 17 Nov 2021 10:52:03 +0100
Received: from pza by lupine with local (Exim 4.94.2)
        (envelope-from <p.zabel@pengutronix.de>)
        id 1mnHbl-0004T6-Q4; Wed, 17 Nov 2021 10:52:01 +0100
Message-ID: <9ab98fba364f736b267dbd5e1d305d3e8426e877.camel@pengutronix.de>
Subject: Re: [PATCH net-next 2/5] net: lan966x: add the basic lan966x driver
From:   Philipp Zabel <p.zabel@pengutronix.de>
To:     Horatiu Vultur <horatiu.vultur@microchip.com>, davem@davemloft.net,
        kuba@kernel.org, robh+dt@kernel.org, linux@armlinux.org.uk,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date:   Wed, 17 Nov 2021 10:52:01 +0100
In-Reply-To: <20211117091858.1971414-3-horatiu.vultur@microchip.com>
References: <20211117091858.1971414-1-horatiu.vultur@microchip.com>
         <20211117091858.1971414-3-horatiu.vultur@microchip.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
User-Agent: Evolution 3.38.3-1 
MIME-Version: 1.0
X-SA-Exim-Connect-IP: 2001:67c:670:100:3ad5:47ff:feaf:1a17
X-SA-Exim-Mail-From: p.zabel@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Horatio,

On Wed, 2021-11-17 at 10:18 +0100, Horatiu Vultur wrote:
> +static int lan966x_reset_switch(struct lan966x *lan966x)
> +{
> +	struct reset_control *reset;
> +	int val = 0;
> +	int ret;
> +
> +	reset = devm_reset_control_get_shared(lan966x->dev, "switch");
> +	if (IS_ERR(reset))
> +		dev_warn(lan966x->dev, "Could not obtain switch reset: %ld\n",
> +			 PTR_ERR(reset));
> +	else
> +		reset_control_reset(reset);

According to the device tree bindings, both resets are required.
I'd expect this to return on error.
Is there any chance of the device working with out the switch reset
being triggered?

> +
> +	reset = devm_reset_control_get_shared(lan966x->dev, "phy");
> +	if (IS_ERR(reset)) {
> +		dev_warn(lan966x->dev, "Could not obtain phy reset: %ld\n",
> +			 PTR_ERR(reset));
> +	} else {
> +		reset_control_reset(reset);
> +	}

Same as above.
Consider printing errors with %pe or dev_err_probe().

> +	lan_wr(SYS_RESET_CFG_CORE_ENA_SET(0), lan966x, SYS_RESET_CFG);
> +	lan_wr(SYS_RAM_INIT_RAM_INIT_SET(1), lan966x, SYS_RAM_INIT);
> +	ret = readx_poll_timeout(lan966x_ram_init, lan966x,
> +				 val, (val & BIT(1)) == 0, READL_SLEEP_US,
> +				 READL_TIMEOUT_US);
> +	if (ret)
> +		return ret;
> +
> +	lan_wr(SYS_RESET_CFG_CORE_ENA_SET(1), lan966x, SYS_RESET_CFG);
> +
> +	return 0;
> +}
> +
> +static int lan966x_probe(struct platform_device *pdev)
> +{
> +	struct fwnode_handle *ports, *portnp;
> +	struct lan966x *lan966x;
> +	int err, i;
> +
> +	lan966x = devm_kzalloc(&pdev->dev, sizeof(*lan966x), GFP_KERNEL);
> +	if (!lan966x)
> +		return -ENOMEM;
> +
> +	platform_set_drvdata(pdev, lan966x);
> +	lan966x->dev = &pdev->dev;
> +
> +	ports = device_get_named_child_node(&pdev->dev, "ethernet-ports");
> +	if (!ports) {
> +		dev_err(&pdev->dev, "no ethernet-ports child not found\n");
> +		err = -ENODEV;
> +		goto out;

No need to goto as long as there's just a "return err;" after the out:
label.

> +	}
> +
> +	err = lan966x_create_targets(pdev, lan966x);
> +	if (err)
> +		goto out;
> +
> +	if (lan966x_reset_switch(lan966x)) {
> +		err = -EINVAL;

This should propagate the error returned from lan966x_reset_switch()
instead.

> +		goto out;
> +	}
> +
> +	i = 0;
> +	fwnode_for_each_available_child_node(ports, portnp)
> +		++i;
> +
> +	lan966x->num_phys_ports = i;
> +	lan966x->ports = devm_kcalloc(&pdev->dev, lan966x->num_phys_ports,
> +				      sizeof(struct lan966x_port *),
> +				      GFP_KERNEL);

	if (!lan966x->ports)
		return -ENOMEM;

regards
Philipp
