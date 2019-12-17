Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 47A1C123063
	for <lists+netdev@lfdr.de>; Tue, 17 Dec 2019 16:33:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728483AbfLQPdw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Dec 2019 10:33:52 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:57616 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727466AbfLQPdw (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 17 Dec 2019 10:33:52 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=eNSZ2YlqsQ+8/4kfMXq2jNeud44WmFuO1gpjKs3kWTY=; b=3I/JsA+RDT/54VL2OCnzMtu8f9
        m/pCPfaRCxl/KjwmxFvnz4thYlragEXlo04p7+1woJUrGRYnHB++fB4TOiPK36cGVUA+SNF/SfOPW
        2QCfKnMROGn+S2MG89amCN4TSF6MdQHw8OkOIctd5Uxvc50rxph+u6yzDsP3ufreOFlk=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.92.2)
        (envelope-from <andrew@lunn.ch>)
        id 1ihEr3-0002Xn-QY; Tue, 17 Dec 2019 16:33:45 +0100
Date:   Tue, 17 Dec 2019 16:33:45 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Richard Cochran <richardcochran@gmail.com>
Cc:     netdev@vger.kernel.org, David Miller <davem@davemloft.net>,
        devicetree@vger.kernel.org,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Jacob Keller <jacob.e.keller@intel.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Miroslav Lichvar <mlichvar@redhat.com>,
        Murali Karicheri <m-karicheri2@ti.com>,
        Rob Herring <robh+dt@kernel.org>,
        Willem de Bruijn <willemb@google.com>,
        Wingman Kwok <w-kwok2@ti.com>
Subject: Re: [PATCH V6 net-next 11/11] ptp: Add a driver for InES time
 stamping IP core.
Message-ID: <20191217153345.GH17965@lunn.ch>
References: <cover.1576511937.git.richardcochran@gmail.com>
 <33afc113fa0b301d289522971c83dbbf0d36c8ba.1576511937.git.richardcochran@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <33afc113fa0b301d289522971c83dbbf0d36c8ba.1576511937.git.richardcochran@gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> +static int ines_clock_init(struct ines_clock *clock, struct device_node *node,
> +			   void __iomem *addr)
> +{
> +	unsigned long port_addr;
> +	struct ines_port *port;
> +	int i, j;
> +
> +	INIT_LIST_HEAD(&clock->list);
> +	clock->node = node;
> +	clock->base = addr;
> +	clock->regs = clock->base;
> +
> +	for (i = 0; i < INES_N_PORTS; i++) {
> +		port = &clock->port[i];
> +		port_addr = (unsigned long) clock->base +
> +			INES_PORT_OFFSET + i * INES_PORT_SIZE;
> +		port->regs = (struct ines_port_registers *) port_addr;
> +		port->clock = clock;
> +		port->index = i;
> +		INIT_DELAYED_WORK(&port->ts_work, ines_txtstamp_work);
> +		spin_lock_init(&port->lock);
> +		INIT_LIST_HEAD(&port->events);
> +		INIT_LIST_HEAD(&port->pool);
> +		for (j = 0; j < INES_MAX_EVENTS; j++)
> +			list_add(&port->pool_data[j].list, &port->pool);
> +	}
> +
> +	ines_write32(clock, 0xBEEF, test);
> +	ines_write32(clock, 0xBEEF, test2);
> +
> +	pr_debug("ID      0x%x\n", ines_read32(clock, id));
> +	pr_debug("TEST    0x%x\n", ines_read32(clock, test));
> +	pr_debug("VERSION 0x%x\n", ines_read32(clock, version));
> +	pr_debug("TEST2   0x%x\n", ines_read32(clock, test2));
> +

Hi Richard

Using pr_ functions is frowned upon. You have a device, since this is
a platform driver, please use dev_debug() etc.

> +	for (i = 0; i < INES_N_PORTS; i++) {
> +		port = &clock->port[i];
> +		ines_write32(port, PORT_CONF, port_conf);
> +	}
> +
> +	return 0;
> +}
> +
> +static void ines_dump_ts(char *label, struct ines_timestamp *ts)
> +{
> +#ifdef DEBUG
> +	pr_err("%s timestamp, tag=0x%04hx t=%llu.%9llu c=0x%llx p=%hu s=%hu\n",
> +	       label, ts->tag, ts->sec, ts->nsec,
> +	       ts->clkid, ts->portnum, ts->seqid);
> +#endif

DEBUG using pr_err() is a bit unusual. dev_dbg() would be normal.

> +static int ines_ptp_ctrl_probe(struct platform_device *pld)
> +{
> +	struct ines_clock *clock;
> +	struct resource *res;
> +	void __iomem *addr;
> +	int err = 0;
> +
> +	res = platform_get_resource(pld, IORESOURCE_MEM, 0);
> +	if (!res) {
> +		dev_err(&pld->dev, "missing memory resource\n");
> +		return -EINVAL;
> +	}
> +	addr = devm_ioremap_resource(&pld->dev, res);
> +	if (IS_ERR(addr)) {
> +		err = PTR_ERR(addr);
> +		goto out;
> +	}
> +	clock = kzalloc(sizeof(*clock), GFP_KERNEL);

Do the different memory life cycles allow devm_ to be used here?

