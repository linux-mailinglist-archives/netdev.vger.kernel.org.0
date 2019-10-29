Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9B3ACE883F
	for <lists+netdev@lfdr.de>; Tue, 29 Oct 2019 13:32:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729095AbfJ2Mcn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Oct 2019 08:32:43 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:40182 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726048AbfJ2Mcn (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 29 Oct 2019 08:32:43 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=W2oXZhabkVcZy9Se0lF9CY8ZtGTSqam1VXB+wNuXojE=; b=uEH8dw0S7x9Rjq3PAn4pEarQU3
        iNtNXtSwVVh8QwyMqo2OmHtOioMbE4vAdkC+xXTGfV+uoeh2cJ1iD9nCtHcIzAf4Jt4/DK5AZIT1i
        PJ0HicgwlOpKcFFomgfwEGbxYFrMeVgWqjstx0NPAtKYRVyOlX1YZj1ft7UIFenE5iGU=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.92.2)
        (envelope-from <andrew@lunn.ch>)
        id 1iPQfm-00048T-Ci; Tue, 29 Oct 2019 13:32:30 +0100
Date:   Tue, 29 Oct 2019 13:32:30 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Grygorii Strashko <grygorii.strashko@ti.com>
Cc:     netdev@vger.kernel.org,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        "David S . Miller" <davem@davemloft.net>,
        Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>,
        Jiri Pirko <jiri@resnulli.us>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Sekhar Nori <nsekhar@ti.com>, linux-kernel@vger.kernel.org,
        linux-omap@vger.kernel.org, Murali Karicheri <m-karicheri2@ti.com>,
        Ivan Vecera <ivecera@redhat.com>,
        Rob Herring <robh+dt@kernel.org>, devicetree@vger.kernel.org
Subject: Re: [PATCH v5 net-next 06/12] net: ethernet: ti: introduce cpsw
  switchdev based driver part 1 - dual-emac
Message-ID: <20191029123230.GM15259@lunn.ch>
References: <20191024100914.16840-1-grygorii.strashko@ti.com>
 <20191024100914.16840-7-grygorii.strashko@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191024100914.16840-7-grygorii.strashko@ti.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> +static int cpsw_probe(struct platform_device *pdev)
> +{
> +	const struct soc_device_attribute *soc;
> +	struct device *dev = &pdev->dev;
> +	struct resource *ss_res;
> +	struct cpsw_common *cpsw;
> +	struct gpio_descs *mode;
> +	void __iomem *ss_regs;
> +	int ret = 0, ch;
> +	struct clk *clk;
> +	int irq;
> +

...

> +
> +	/* setup netdevs */
> +	ret = cpsw_create_ports(cpsw);
> +	if (ret)
> +		goto clean_unregister_netdev;

At this point, the slave ports go live. If the kernel is configured
with NFS root etc, it will start using the interfaces.

+
> +	/* Grab RX and TX IRQs. Note that we also have RX_THRESHOLD and
> +	 * MISC IRQs which are always kept disabled with this driver so
> +	 * we will not request them.
> +	 *
> +	 * If anyone wants to implement support for those, make sure to
> +	 * first request and append them to irqs_table array.
> +	 */
> +
> +	ret = devm_request_irq(dev, cpsw->irqs_table[0], cpsw_rx_interrupt,
> +			       0, dev_name(dev), cpsw);
> +	if (ret < 0) {
> +		dev_err(dev, "error attaching irq (%d)\n", ret);
> +		goto clean_unregister_netdev;
> +	}
> +
> +	ret = devm_request_irq(dev, cpsw->irqs_table[1], cpsw_tx_interrupt,
> +			       0, dev_name(dev), cpsw);
> +	if (ret < 0) {
> +		dev_err(dev, "error attaching irq (%d)\n", ret);
> +		goto clean_unregister_netdev;
> +	}

Are there any race conditions if the network starts using the devices
before interrupts are requested? To be safe, maybe this should be done
before the slaves are created?

       Andrew
