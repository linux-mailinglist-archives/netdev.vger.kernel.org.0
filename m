Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5380C3B082B
	for <lists+netdev@lfdr.de>; Tue, 22 Jun 2021 17:03:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231860AbhFVPFs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Jun 2021 11:05:48 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:49952 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230047AbhFVPFr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 22 Jun 2021 11:05:47 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=eJl2DpthFeSECf07oU/ZgYT4jZMCgcwbcfgPLgzd48Q=; b=5smetocEA9sYP3b4Tbxgff4g1y
        Kgu7xXc9GpaSr2WSDYGScbpRqvK2NIXDxlUsTF8Tq1l+MjJYfTYKqv0jn+qBeC/VsWGhjUuT107+Z
        /8ZuFv82L3srN7z2dvxskPjsscZKwSJc+HDt4xuWByLXPPt1C/QawgHWGZf9XvoV2jms=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1lvhvx-00AiXJ-TS; Tue, 22 Jun 2021 17:03:25 +0200
Date:   Tue, 22 Jun 2021 17:03:25 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Lukasz Majewski <lukma@denx.de>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Madalin Bucur <madalin.bucur@oss.nxp.com>,
        Nicolas Ferre <nicolas.ferre@microchip.com>,
        Joakim Zhang <qiangqing.zhang@nxp.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>, netdev@vger.kernel.org,
        Arnd Bergmann <arnd@arndb.de>,
        Mark Einon <mark.einon@gmail.com>,
        NXP Linux Team <linux-imx@nxp.com>,
        linux-kernel@lists.infradead.org
Subject: Re: [RFC 2/3] net: Provide switchdev driver for NXP's More Than IP
 L2 switch
Message-ID: <YNH7vS9FgvEhz2fZ@lunn.ch>
References: <20210622144111.19647-1-lukma@denx.de>
 <20210622144111.19647-3-lukma@denx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210622144111.19647-3-lukma@denx.de>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> +static void write_atable(struct mtipl2sw_priv *priv, int index,
> +	unsigned long write_lo, unsigned long write_hi)
> +{
> +	unsigned long atable_base = (unsigned long)priv->hwentry;
> +
> +	writel(write_lo, (volatile void *)atable_base + (index << 3));
> +	writel(write_hi, (volatile void *)atable_base + (index << 3) + 4);

Using volatile is generally wrong. Why do you need it?

 > +}
> +
> +/*
> + * Clear complete MAC Look Up Table
> + */
> +static void esw_clear_atable(struct mtipl2sw_priv *priv)
> +{
> +	int index;
> +	for (index = 0; index < 2048; index++)
> +		write_atable(priv, index, 0, 0);
> +}
> +
> +static int mtipl2_sw_enable(struct mtipl2sw_priv *priv)
> +{
> +	/*
> +	 * L2 switch - reset
> +	 */
> +	writel(MCF_ESW_MODE_SW_RST, &priv->fecp->ESW_MODE);
> +	udelay(10);
> +
> +	/* Configure switch*/
> +	writel(MCF_ESW_MODE_STATRST, &priv->fecp->ESW_MODE);
> +	writel(MCF_ESW_MODE_SW_EN, &priv->fecp->ESW_MODE);
> +
> +	/* Management port configuration, make port 0 as management port */
> +	writel(0, &priv->fecp->ESW_BMPC);
> +
> +	/*
> +	 * Set backpressure threshold to minimize discarded frames
> +	 * during due to congestion.
> +	 */
> +	writel(P0BC_THRESHOLD, &priv->fecp->ESW_P0BCT);
> +
> +	/* Set the max rx buffer size */
> +	writel(L2SW_PKT_MAXBLR_SIZE, priv->hwpsw + MCF_ESW_R_BUFF_SIZE);
> +	/* Enable broadcast on all ports */
> +	writel(0x7, &priv->fecp->ESW_DBCR);
> +
> +	/* Enable multicast on all ports */
> +	writel(0x7, &priv->fecp->ESW_DMCR);
> +
> +	esw_clear_atable(priv);
> +
> +	/* Clear all pending interrupts */
> +	writel(0xffffffff, priv->hwpsw + FEC_IEVENT);
> +
> +	/* Enable interrupts we wish to service */
> +	writel(FEC_MTIP_DEFAULT_IMASK, priv->hwpsw + FEC_IMASK);
> +	priv->l2sw_on = true;
> +
> +	return 0;
> +}
> +
> +static void mtipl2_sw_disable(struct mtipl2sw_priv *priv)
> +{
> +	writel(0, &priv->fecp->ESW_MODE);
> +}
> +
> +static int mtipl2_port_enable (struct mtipl2sw_priv *priv, int port)
> +{
> +	u32 l2_ports_en;
> +
> +	pr_err("%s: PORT ENABLE %d\n", __func__, port);
> +
> +	/* Enable tx/rx on L2 switch ports */
> +	l2_ports_en = readl(&priv->fecp->ESW_PER);
> +	if (!(l2_ports_en & MCF_ESW_ENA_PORT_0))
> +		l2_ports_en = MCF_ESW_ENA_PORT_0;
> +
> +	if (port == 0 && !(l2_ports_en & MCF_ESW_ENA_PORT_1))
> +		l2_ports_en |= MCF_ESW_ENA_PORT_1;
> +
> +	if (port == 1 && !(l2_ports_en & MCF_ESW_ENA_PORT_2))
> +		l2_ports_en |= MCF_ESW_ENA_PORT_2;
> +
> +	writel(l2_ports_en, &priv->fecp->ESW_PER);
> +
> +	/*
> +	 * Check if MAC IP block is already enabled (after switch initializtion)
> +	 * or if we need to enable it after mtipl2_port_disable was called.
> +	 */
> +
> +	return 0;
> +}
> +
> +static void mtipl2_port_disable (struct mtipl2sw_priv *priv, int port)
> +{
> +	u32 l2_ports_en;
> +
> +	pr_err(" %s: PORT DISABLE %d\n", __func__, port);

Please clean up debug code this this.

> +
> +	l2_ports_en = readl(&priv->fecp->ESW_PER);
> +	if (port == 0)
> +		l2_ports_en &= ~MCF_ESW_ENA_PORT_1;
> +
> +	if (port == 1)
> +		l2_ports_en &= ~MCF_ESW_ENA_PORT_2;
> +
> +	/* Finally disable tx/rx on port 0 */
> +	if (!(l2_ports_en & MCF_ESW_ENA_PORT_1) &&
> +	    !(l2_ports_en & MCF_ESW_ENA_PORT_2))
> +		l2_ports_en &= ~MCF_ESW_ENA_PORT_0;
> +
> +	writel(l2_ports_en, &priv->fecp->ESW_PER);
> +}
> +
> +irqreturn_t
> +mtip_l2sw_interrupt_handler(int irq, void *dev_id)
> +{
> +	struct mtipl2sw_priv *priv = dev_id;
> +	struct fec_enet_private *fep = priv->fep[0];
> +	irqreturn_t ret = IRQ_NONE;
> +	u32 int_events, int_imask;

Reverse christmas tree.

> +
> +	int_events = readl(fec_hwp(fep) + FEC_IEVENT);
> +	writel(int_events, fec_hwp(fep) + FEC_IEVENT);
> +
> +	if ((int_events & FEC_MTIP_DEFAULT_IMASK) && fep->link) {
> +		ret = IRQ_HANDLED;
> +
> +		if (napi_schedule_prep(&fep->napi)) {
> +			/* Disable RX interrupts */
> +			int_imask = readl(fec_hwp(fep) + FEC_IMASK);
> +			int_imask &= ~FEC_MTIP_ENET_RXF;
> +			writel(int_imask, fec_hwp(fep) + FEC_IMASK);
> +			__napi_schedule(&fep->napi);
> +		}
> +	}
> +
> +	return ret;
> +}
> +
> +static int mtipl2_parse_of(struct mtipl2sw_priv *priv, struct device_node *np)
> +{
> +	struct device_node *port, *p, *fep_np;
> +	struct platform_device *pdev;
> +	struct net_device *ndev;
> +	unsigned int port_num;
> +
> +	p = of_find_node_by_name(np, "ports");
> +
> +	for_each_available_child_of_node(p, port) {
> +		if (of_property_read_u32(port, "reg", &port_num))
> +			continue;
> +
> +		priv->n_ports = port_num;
> +
> +		fep_np = of_parse_phandle(port, "phy-handle", 0);

As i said, phy-handle points to a phy. It minimum, you need to call
this mac-handle. But that then makes this switch driver very different
to every other switch driver.

> +		pdev = of_find_device_by_node(fep_np);
> +		ndev = platform_get_drvdata(pdev);
> +		priv->fep[port_num - 1] = netdev_priv(ndev);

What happens when somebody puts reg=<42>; in DT?

I would say, your basic structure needs to change, to make it more
like other switchdev drivers. You need to replace the two FEC device
instances with one switchdev driver. The switchdev driver will then
instantiate the two netdevs for the two external MACs. You can
hopefully reuse some of the FEC code for that, but i expect you are
going to have to refactor the FEC driver and turn part of it into a
library, which the switchdev driver can then use.

	 Andrew
