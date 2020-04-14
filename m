Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E24321A89FA
	for <lists+netdev@lfdr.de>; Tue, 14 Apr 2020 20:44:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2504256AbgDNSoC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Apr 2020 14:44:02 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:37374 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729658AbgDNSn4 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 14 Apr 2020 14:43:56 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=/TPZArQkhShtB5ieni8kCIGplQcFUqW8Ye4PfsxgJyI=; b=p1MBv7OCUWAJRl3FJ41+ai4tSW
        9g4Uc4/uF7LPeOej+g4Ln6soOyb8O48n1gjCWLI0ASKqxJNlKzxmOO2P//xrzEespKM+2DKIuEJrM
        2nR996wV6B60AciyaOBi6jrUezcqahMKCI62Kh8YMOWBb1UvK1tTJzftmDZ6+57s/5Ck=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1jOQXC-002i09-IY; Tue, 14 Apr 2020 20:43:46 +0200
Date:   Tue, 14 Apr 2020 20:43:46 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Robert Marko <robert.marko@sartura.hr>
Cc:     f.fainelli@gmail.com, hkallweit1@gmail.com, linux@armlinux.org.uk,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        agross@kernel.org, bjorn.andersson@linaro.org, robh+dt@kernel.org,
        mark.rutland@arm.com, linux-arm-msm@vger.kernel.org,
        devicetree@vger.kernel.org,
        Christian Lamparter <chunkeey@gmail.com>,
        Luka Perkov <luka.perkov@sartura.hr>
Subject: Re: [PATCH v2 1/3] net: phy: mdio: add IPQ40xx MDIO driver
Message-ID: <20200414184346.GC637127@lunn.ch>
References: <20200414181012.114905-1-robert.marko@sartura.hr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200414181012.114905-1-robert.marko@sartura.hr>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Robert

This is looking better

> +#include <linux/delay.h>
> +#include <linux/kernel.h>
> +#include <linux/module.h>
> +#include <linux/mutex.h>

I don't think you need this header. There are no mutexes here.

> +#include <linux/io.h>
> +#include <linux/of_address.h>
> +#include <linux/of_mdio.h>
> +#include <linux/phy.h>
> +#include <linux/platform_device.h>
> +
> +#define MDIO_CTRL_0_REG		0x40
> +#define MDIO_CTRL_1_REG		0x44
> +#define MDIO_CTRL_2_REG		0x48
> +#define MDIO_CTRL_3_REG		0x4c
> +#define MDIO_CTRL_4_REG		0x50

So your next version will hopefully have better names.

> +static int ipq40xx_mdio_wait_busy(struct mii_bus *bus)
> +{
> +	struct ipq40xx_mdio_data *priv = bus->priv;
> +	int i;
> +
> +	for (i = 0; i < IPQ40XX_MDIO_RETRY; i++) {
> +		unsigned int busy;
> +
> +		busy = readl(priv->membase + MDIO_CTRL_4_REG) &
> +			MDIO_CTRL_4_ACCESS_BUSY;
> +		if (!busy)
> +			return 0;
> +
> +		/* BUSY might take to be cleard by 15~20 times of loop */
> +		udelay(IPQ40XX_MDIO_DELAY);
> +	}
> +
> +	dev_err(bus->parent, "MDIO operation timed out\n");
> +
> +	return -ETIMEDOUT;
> +}

You can probably make use of include/linux/iopoll.h 

    Andrew
