Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EF8E1621DC4
	for <lists+netdev@lfdr.de>; Tue,  8 Nov 2022 21:38:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229933AbiKHUip (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Nov 2022 15:38:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48088 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229584AbiKHUip (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Nov 2022 15:38:45 -0500
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0653F65851;
        Tue,  8 Nov 2022 12:38:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=eVpzR4I1v98CjFgiXEZ/ol4z5GsZ1Uq/3APPoQgyHpE=; b=xVTrObcxo3lClVtWrlMTYedbjM
        rf+NU7dedwe4D5DrSOUQ/UNvPdzaBLTz/eUcYtRwIPFDlkT6lMQeqAUBD1ynxBWK/pybYYILgnQi5
        Jl5Ko4X9EMqrNuT0+xo4RyWtj2CggqXR9FJbBwEBLDykK8RMXJPT5hZA+UQNlAhyXA70=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1osVMk-001r5l-ML; Tue, 08 Nov 2022 21:38:38 +0100
Date:   Tue, 8 Nov 2022 21:38:38 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Dominique Martinet <dominique.martinet@atmark-techno.com>
Cc:     Marcel Holtmann <marcel@holtmann.org>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Luiz Augusto von Dentz <luiz.dentz@gmail.com>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, linux-bluetooth@vger.kernel.org,
        Paolo Abeni <pabeni@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        "David S . Miller" <davem@davemloft.net>, mizo@atmark-techno.com
Subject: Re: [RFC PATCH 2/2] bluetooth/hci_h4: add serdev support
Message-ID: <Y2q+TkZJOfXFYlBO@lunn.ch>
References: <20221108055531.2176793-1-dominique.martinet@atmark-techno.com>
 <20221108055531.2176793-3-dominique.martinet@atmark-techno.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221108055531.2176793-3-dominique.martinet@atmark-techno.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> +static int h4_probe(struct serdev_device *serdev)
> +{
> +	struct h4_device *h4dev;
> +	struct hci_uart *hu;
> +	int ret;
> +	u32 speed;
> +
> +	h4dev = devm_kzalloc(&serdev->dev, sizeof(*h4dev), GFP_KERNEL);
> +	if (!h4dev)
> +		return -ENOMEM;
> +
> +	hu = &h4dev->hu;
> +
> +	hu->serdev = serdev;
> +	ret = device_property_read_u32(&serdev->dev, "max-speed", &speed);
> +	if (!ret) {
> +		/* h4 does not have any baudrate handling:
> +		 * user oper speed from the start
> +		 */
> +		hu->init_speed = speed;
> +		hu->oper_speed = speed;
> +	}
> +
> +	serdev_device_set_drvdata(serdev, h4dev);
> +	dev_info(&serdev->dev, "h4 device registered.\n");

It is considered bad practice to spam the logs like this. dev_dbg().

> +
> +	return hci_uart_register_device(hu, &h4p);
> +}
> +
> +static void h4_remove(struct serdev_device *serdev)
> +{
> +	struct h4_device *h4dev = serdev_device_get_drvdata(serdev);
> +
> +	dev_info(&serdev->dev, "h4 device unregistered.\n");

dev_dbg().

	Andrew
