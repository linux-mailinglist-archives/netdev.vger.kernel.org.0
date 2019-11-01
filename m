Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 25E46ECA03
	for <lists+netdev@lfdr.de>; Fri,  1 Nov 2019 21:57:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727751AbfKAU5l (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Nov 2019 16:57:41 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:46004 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726396AbfKAU5k (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 1 Nov 2019 16:57:40 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=n5rRT0a1iTfLvFxrf02dbZh2qtFNVDbMMIEOedlKQOY=; b=1qxvtNWXGZsqvIRCmMwL+v+dJ2
        LKqEzTc7yUs5IBgejnC0WfxUbKEDRdFgp3zBCivnKiNoXbzATeRwkDtGPEoJunrrOh6NoE9md7IGH
        ikFVWEhVGs/IZrpQ4qTuBm+kuZX9vh2nLcNP2JqYtg3mXGofbiiEonc4sPT9HbF+4Kq8=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.92.2)
        (envelope-from <andrew@lunn.ch>)
        id 1iQdz7-0000M4-Od; Fri, 01 Nov 2019 21:57:29 +0100
Date:   Fri, 1 Nov 2019 21:57:29 +0100
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
Message-ID: <20191101205729.GE31534@lunn.ch>
References: <20191024100914.16840-1-grygorii.strashko@ti.com>
 <20191024100914.16840-7-grygorii.strashko@ti.com>
 <20191029123230.GM15259@lunn.ch>
 <24b1623d-48df-328a-eda7-4195e9df2b22@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <24b1623d-48df-328a-eda7-4195e9df2b22@ti.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Nov 01, 2019 at 10:34:57PM +0200, Grygorii Strashko wrote:
> 
> 
> On 29/10/2019 14:32, Andrew Lunn wrote:
> > > +static int cpsw_probe(struct platform_device *pdev)
> > > +{
> > > +	const struct soc_device_attribute *soc;
> > > +	struct device *dev = &pdev->dev;
> > > +	struct resource *ss_res;
> > > +	struct cpsw_common *cpsw;
> > > +	struct gpio_descs *mode;
> > > +	void __iomem *ss_regs;
> > > +	int ret = 0, ch;
> > > +	struct clk *clk;
> > > +	int irq;
> > > +
> > 
> > ...
> > 
> > > +
> > > +	/* setup netdevs */
> > > +	ret = cpsw_create_ports(cpsw);
> > > +	if (ret)
> > > +		goto clean_unregister_netdev;
> > 
> > At this point, the slave ports go live. If the kernel is configured
> > with NFS root etc, it will start using the interfaces.
> > 
> > +
> > > +	/* Grab RX and TX IRQs. Note that we also have RX_THRESHOLD and
> > > +	 * MISC IRQs which are always kept disabled with this driver so
> > > +	 * we will not request them.
> > > +	 *
> > > +	 * If anyone wants to implement support for those, make sure to
> > > +	 * first request and append them to irqs_table array.
> > > +	 */
> > > +
> > > +	ret = devm_request_irq(dev, cpsw->irqs_table[0], cpsw_rx_interrupt,
> > > +			       0, dev_name(dev), cpsw);
> > > +	if (ret < 0) {
> > > +		dev_err(dev, "error attaching irq (%d)\n", ret);
> > > +		goto clean_unregister_netdev;
> > > +	}
> > > +
> > > +	ret = devm_request_irq(dev, cpsw->irqs_table[1], cpsw_tx_interrupt,
> > > +			       0, dev_name(dev), cpsw);
> > > +	if (ret < 0) {
> > > +		dev_err(dev, "error attaching irq (%d)\n", ret);
> > > +		goto clean_unregister_netdev;
> > > +	}
> > 
> > Are there any race conditions if the network starts using the devices
> > before interrupts are requested? To be safe, maybe this should be done
> > before the slaves are created?
> 
> Usually during boot - there is no parallel probing (as opposite to modules loading by
> udev, for example). Also, there is barrier init call deferred_probe_initcall() to ensure all
> drivers probed before going to mount rootfs.
> 
> So, i do not think this could cause any issue - max few packets will be delayed
> until kernel will switch back here, but the chances that ndo_open will be finished before probe ->0.

I helped track down a crash recently, along these lines. ndo_open()
was getting called before the probe function finished, when kernel ip
address auto config was in action. This is not to do with parallel
probing, i think there is something in register_netdev() which is
triggered each time an interface is added to do the ip
configuration. And the first thing that does is open the interface.

	  Andrew
