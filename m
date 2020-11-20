Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DE61F2BB5A0
	for <lists+netdev@lfdr.de>; Fri, 20 Nov 2020 20:40:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728454AbgKTTdY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Nov 2020 14:33:24 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:42228 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727862AbgKTTdY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 20 Nov 2020 14:33:24 -0500
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kgC9p-008A1v-6U; Fri, 20 Nov 2020 20:33:21 +0100
Date:   Fri, 20 Nov 2020 20:33:21 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     George McCollister <george.mccollister@gmail.com>
Cc:     Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S . Miller " <davem@davemloft.net>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org
Subject: Re: [PATCH net-next 2/3] net: dsa: add Arrow SpeedChips XRS700x
 driver
Message-ID: <20201120193321.GP1853236@lunn.ch>
References: <20201120181627.21382-1-george.mccollister@gmail.com>
 <20201120181627.21382-3-george.mccollister@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201120181627.21382-3-george.mccollister@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> +static const struct xrs700x_mib xrs700x_mibs[] = {
> +	{XRS_RX_GOOD_OCTETS_L(0), "rx_good_octets"},
> +	{XRS_RX_BAD_OCTETS_L(0), "rx_bad_octets"},
> +	{XRS_RX_UNICAST_L(0), "rx_unicast"},
> +	{XRS_RX_BROADCAST_L(0), "rx_broadcast"},
> +	{XRS_RX_MULTICAST_L(0), "rx_multicast"},
> +	{XRS_RX_UNDERSIZE_L(0), "rx_undersize"},
> +	{XRS_RX_FRAGMENTS_L(0), "rx_fragments"},
> +	{XRS_RX_OVERSIZE_L(0), "rx_oversize"},
> +	{XRS_RX_JABBER_L(0), "rx_jabber"},
> +	{XRS_RX_ERR_L(0), "rx_err"},
> +	{XRS_RX_CRC_L(0), "rx_crc"},
> +	{XRS_RX_64_L(0), "rx_64"},
> +	{XRS_RX_65_127_L(0), "rx_65_127"},
> +	{XRS_RX_128_255_L(0), "rx_128_255"},
> +	{XRS_RX_256_511_L(0), "rx_256_511"},
> +	{XRS_RX_512_1023_L(0), "rx_512_1023"},
> +	{XRS_RX_1024_1536_L(0), "rx_1024_1536"},
> +	{XRS_RX_HSR_PRP_L(0), "rx_hsr_prp"},
> +	{XRS_RX_WRONGLAN_L(0), "rx_wronglan"},
> +	{XRS_RX_DUPLICATE_L(0), "rx_duplicate"},
> +	{XRS_TX_OCTETS_L(0), "tx_octets"},
> +	{XRS_TX_UNICAST_L(0), "tx_unicast"},
> +	{XRS_TX_BROADCAST_L(0), "tx_broadcast"},
> +	{XRS_TX_MULTICAST_L(0), "tx_multicast"},
> +	{XRS_TX_HSR_PRP_L(0), "tx_hsr_prp"},
> +	{XRS_PRIQ_DROP_L(0), "priq_drop"},
> +	{XRS_EARLY_DROP_L(0), "early_drop"},

Can we drop the (0). It does not seem to have any purpose, always
being 0.

> +};
> +


> +static void xrs700x_read_port_counters(struct xrs700x *priv, int port)
> +{
> +	int i;
> +	struct xrs700x_port *p = &priv->ports[port];

Reverse christmas tree. Please check and fix everywhere.

> +static void xrs700x_port_stp_state_set(struct dsa_switch *ds, int port,
> +				       u8 state)
> +{
> +	struct xrs700x *priv = ds->priv;
> +	unsigned int val;
> +
> +	switch (state) {
> +	case BR_STATE_DISABLED:
> +		val = XRS_PORT_DISABLED;
> +		break;
> +	case BR_STATE_LISTENING:
> +		val = XRS_PORT_DISABLED;
> +		break;

No listening state?

> +	case BR_STATE_LEARNING:
> +		val = XRS_PORT_LEARNING;
> +		break;
> +	case BR_STATE_FORWARDING:
> +		val = XRS_PORT_FORWARDING;
> +		break;
> +	case BR_STATE_BLOCKING:
> +		val = XRS_PORT_DISABLED;
> +		break;

Hum. What exactly does XRS_PORT_DISABLED mean? When blocking, it is
expected you can still send/receive BPDUs.

> +struct xrs700x *xrs700x_switch_alloc(struct device *base, void *priv)
> +{
> +	struct dsa_switch *ds;
> +	struct xrs700x *dev;
> +
> +	ds = devm_kzalloc(base, sizeof(*ds), GFP_KERNEL);
> +	if (!ds)
> +		return NULL;
> +
> +	ds->dev = base;
> +	ds->num_ports = DSA_MAX_PORTS;

Is this needed? detect should fill it in.

> +int xrs700x_switch_register(struct xrs700x *dev)
> +{
> +	int ret;
> +	int i;
> +
> +	ret = xrs700x_detect(dev);
> +	if (ret)
> +		return ret;
> +
> +	ret = xrs700x_setup_regmap_range(dev);
> +	if (ret)
> +		return ret;
> +
> +	dev->ports = devm_kzalloc(dev->dev,
> +				  sizeof(*dev->ports) * dev->ds->num_ports,
> +				  GFP_KERNEL);
> +	if (!dev->ports)
> +		return -ENOMEM;
> +
> +	for (i = 0; i < dev->ds->num_ports; i++) {
> +		ret = xrs700x_alloc_port_mib(dev, i);
> +		if (ret)
> +			return ret;
> +	}
> +
> +	ret = dsa_register_switch(dev->ds);
> +
> +	if (ret)
> +		cancel_delayed_work_sync(&dev->mib_work);

It would be nice to have to symmetry here. It is not obvious what is
starting this? It happens in the setup op? So can this be moved
into the teardown op?

> +static int xrs700x_i2c_reg_read(void *context, unsigned int reg,
> +				unsigned int *val)
> +{
> +	int ret;
> +	unsigned char buf[4];
> +	struct device *dev = context;
> +	struct i2c_client *i2c = to_i2c_client(dev);
> +
> +	buf[0] = reg >> 23 & 0xff;
> +	buf[1] = reg >> 15 & 0xff;
> +	buf[2] = reg >> 7 & 0xff;
> +	buf[3] = (reg & 0x7f) << 1;
> +
> +	ret = i2c_master_send(i2c, buf, sizeof(buf));

Are you allowed to perform transfers on stack buffers? I think any I2C
bus driver using DMA is going to be unhappy.

> +static const struct of_device_id xrs700x_i2c_dt_ids[] = {
> +	{ .compatible = "arrow,xrs7003" },
> +	{ .compatible = "arrow,xrs7004" },
> +	{},

Please validate that the compatible string actually matches the switch
found. Otherwise we can get into all sorts of horrible backward
compatibility issues.

> +static const struct of_device_id xrs700x_mdio_dt_ids[] = {
> +	{ .compatible = "arrow,xrs7003" },
> +	{ .compatible = "arrow,xrs7004" },
> +	{},

Same here.

     Andrew
