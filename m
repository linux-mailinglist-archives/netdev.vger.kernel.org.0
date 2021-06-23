Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 24A5F3B1910
	for <lists+netdev@lfdr.de>; Wed, 23 Jun 2021 13:37:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230123AbhFWLjc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Jun 2021 07:39:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48444 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230031AbhFWLjb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Jun 2021 07:39:31 -0400
Received: from phobos.denx.de (phobos.denx.de [IPv6:2a01:238:438b:c500:173d:9f52:ddab:ee01])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D696C061574
        for <netdev@vger.kernel.org>; Wed, 23 Jun 2021 04:37:14 -0700 (PDT)
Received: from ktm (85-222-111-42.dynamic.chello.pl [85.222.111.42])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: lukma@denx.de)
        by phobos.denx.de (Postfix) with ESMTPSA id 22F5280050;
        Wed, 23 Jun 2021 13:37:10 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=denx.de;
        s=phobos-20191101; t=1624448230;
        bh=pKHSqXHSqcJptoB96ACC83KzfSoh0g5MljQsmN9+xlc=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=vBUh6UQaEtVqQVbPNSs0rpAgpAnqyk7oMoNBJ73S/ECwkneXkmCp9q7aVJaMLchhP
         wNLaiLkk0P4x7DjQxkoxYykLf0Mmgawjjfj3tgt6DG57FyPAltnXQe3yst10aRzVLt
         GUZWzPy3F8HH9XuWnjfewiOFKe14Lm7k+LjeLtqL2Deyl3gdVhz52+chGF7vROr44O
         BhAqDkh9gweq9t7PV1NOSapUrXNP5H+83ifKaaZ7a95rmaWS4b2KKkj1sQ0Sv/QKjg
         6cjQUHYTcsQAUbcqhQJDJ9SJsw57YmOLjRFTQJBapJBd5ohTMFe9sZY7w7+yuhbfXh
         KyoHvW+gzOmeQ==
Date:   Wed, 23 Jun 2021 13:37:04 +0200
From:   Lukasz Majewski <lukma@denx.de>
To:     Andrew Lunn <andrew@lunn.ch>
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
Message-ID: <20210623133704.334a84df@ktm>
In-Reply-To: <YNH7vS9FgvEhz2fZ@lunn.ch>
References: <20210622144111.19647-1-lukma@denx.de>
        <20210622144111.19647-3-lukma@denx.de>
        <YNH7vS9FgvEhz2fZ@lunn.ch>
Organization: denx.de
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
 boundary="Sig_/PlJN2z9vs/ks/6=T=lKv9SG"; protocol="application/pgp-signature"
X-Virus-Scanned: clamav-milter 0.103.2 at phobos.denx.de
X-Virus-Status: Clean
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/PlJN2z9vs/ks/6=T=lKv9SG
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Andrew,

> > +static void write_atable(struct mtipl2sw_priv *priv, int index,
> > +	unsigned long write_lo, unsigned long write_hi)
> > +{
> > +	unsigned long atable_base =3D (unsigned long)priv->hwentry;
> > +
> > +	writel(write_lo, (volatile void *)atable_base + (index <<
> > 3));
> > +	writel(write_hi, (volatile void *)atable_base + (index <<
> > 3) + 4); =20
>=20
> Using volatile is generally wrong. Why do you need it?

This was the code, which I took from the legacy driver. I will adjust
it.

>=20
>  > +}
> > +
> > +/*
> > + * Clear complete MAC Look Up Table
> > + */
> > +static void esw_clear_atable(struct mtipl2sw_priv *priv)
> > +{
> > +	int index;
> > +	for (index =3D 0; index < 2048; index++)
> > +		write_atable(priv, index, 0, 0);
> > +}
> > +
> > +static int mtipl2_sw_enable(struct mtipl2sw_priv *priv)
> > +{
> > +	/*
> > +	 * L2 switch - reset
> > +	 */
> > +	writel(MCF_ESW_MODE_SW_RST, &priv->fecp->ESW_MODE);
> > +	udelay(10);
> > +
> > +	/* Configure switch*/
> > +	writel(MCF_ESW_MODE_STATRST, &priv->fecp->ESW_MODE);
> > +	writel(MCF_ESW_MODE_SW_EN, &priv->fecp->ESW_MODE);
> > +
> > +	/* Management port configuration, make port 0 as
> > management port */
> > +	writel(0, &priv->fecp->ESW_BMPC);
> > +
> > +	/*
> > +	 * Set backpressure threshold to minimize discarded frames
> > +	 * during due to congestion.
> > +	 */
> > +	writel(P0BC_THRESHOLD, &priv->fecp->ESW_P0BCT);
> > +
> > +	/* Set the max rx buffer size */
> > +	writel(L2SW_PKT_MAXBLR_SIZE, priv->hwpsw +
> > MCF_ESW_R_BUFF_SIZE);
> > +	/* Enable broadcast on all ports */
> > +	writel(0x7, &priv->fecp->ESW_DBCR);
> > +
> > +	/* Enable multicast on all ports */
> > +	writel(0x7, &priv->fecp->ESW_DMCR);
> > +
> > +	esw_clear_atable(priv);
> > +
> > +	/* Clear all pending interrupts */
> > +	writel(0xffffffff, priv->hwpsw + FEC_IEVENT);
> > +
> > +	/* Enable interrupts we wish to service */
> > +	writel(FEC_MTIP_DEFAULT_IMASK, priv->hwpsw + FEC_IMASK);
> > +	priv->l2sw_on =3D true;
> > +
> > +	return 0;
> > +}
> > +
> > +static void mtipl2_sw_disable(struct mtipl2sw_priv *priv)
> > +{
> > +	writel(0, &priv->fecp->ESW_MODE);
> > +}
> > +
> > +static int mtipl2_port_enable (struct mtipl2sw_priv *priv, int
> > port) +{
> > +	u32 l2_ports_en;
> > +
> > +	pr_err("%s: PORT ENABLE %d\n", __func__, port);
> > +
> > +	/* Enable tx/rx on L2 switch ports */
> > +	l2_ports_en =3D readl(&priv->fecp->ESW_PER);
> > +	if (!(l2_ports_en & MCF_ESW_ENA_PORT_0))
> > +		l2_ports_en =3D MCF_ESW_ENA_PORT_0;
> > +
> > +	if (port =3D=3D 0 && !(l2_ports_en & MCF_ESW_ENA_PORT_1))
> > +		l2_ports_en |=3D MCF_ESW_ENA_PORT_1;
> > +
> > +	if (port =3D=3D 1 && !(l2_ports_en & MCF_ESW_ENA_PORT_2))
> > +		l2_ports_en |=3D MCF_ESW_ENA_PORT_2;
> > +
> > +	writel(l2_ports_en, &priv->fecp->ESW_PER);
> > +
> > +	/*
> > +	 * Check if MAC IP block is already enabled (after switch
> > initializtion)
> > +	 * or if we need to enable it after mtipl2_port_disable
> > was called.
> > +	 */
> > +
> > +	return 0;
> > +}
> > +
> > +static void mtipl2_port_disable (struct mtipl2sw_priv *priv, int
> > port) +{
> > +	u32 l2_ports_en;
> > +
> > +	pr_err(" %s: PORT DISABLE %d\n", __func__, port); =20
>=20
> Please clean up debug code this this.
>=20

Ok.

> > +
> > +	l2_ports_en =3D readl(&priv->fecp->ESW_PER);
> > +	if (port =3D=3D 0)
> > +		l2_ports_en &=3D ~MCF_ESW_ENA_PORT_1;
> > +
> > +	if (port =3D=3D 1)
> > +		l2_ports_en &=3D ~MCF_ESW_ENA_PORT_2;
> > +
> > +	/* Finally disable tx/rx on port 0 */
> > +	if (!(l2_ports_en & MCF_ESW_ENA_PORT_1) &&
> > +	    !(l2_ports_en & MCF_ESW_ENA_PORT_2))
> > +		l2_ports_en &=3D ~MCF_ESW_ENA_PORT_0;
> > +
> > +	writel(l2_ports_en, &priv->fecp->ESW_PER);
> > +}
> > +
> > +irqreturn_t
> > +mtip_l2sw_interrupt_handler(int irq, void *dev_id)
> > +{
> > +	struct mtipl2sw_priv *priv =3D dev_id;
> > +	struct fec_enet_private *fep =3D priv->fep[0];
> > +	irqreturn_t ret =3D IRQ_NONE;
> > +	u32 int_events, int_imask; =20
>=20
> Reverse christmas tree.

Ok.

>=20
> > +
> > +	int_events =3D readl(fec_hwp(fep) + FEC_IEVENT);
> > +	writel(int_events, fec_hwp(fep) + FEC_IEVENT);
> > +
> > +	if ((int_events & FEC_MTIP_DEFAULT_IMASK) && fep->link) {
> > +		ret =3D IRQ_HANDLED;
> > +
> > +		if (napi_schedule_prep(&fep->napi)) {
> > +			/* Disable RX interrupts */
> > +			int_imask =3D readl(fec_hwp(fep) +
> > FEC_IMASK);
> > +			int_imask &=3D ~FEC_MTIP_ENET_RXF;
> > +			writel(int_imask, fec_hwp(fep) +
> > FEC_IMASK);
> > +			__napi_schedule(&fep->napi);
> > +		}
> > +	}
> > +
> > +	return ret;
> > +}
> > +
> > +static int mtipl2_parse_of(struct mtipl2sw_priv *priv, struct
> > device_node *np) +{
> > +	struct device_node *port, *p, *fep_np;
> > +	struct platform_device *pdev;
> > +	struct net_device *ndev;
> > +	unsigned int port_num;
> > +
> > +	p =3D of_find_node_by_name(np, "ports");
> > +
> > +	for_each_available_child_of_node(p, port) {
> > +		if (of_property_read_u32(port, "reg", &port_num))
> > +			continue;
> > +
> > +		priv->n_ports =3D port_num;
> > +
> > +		fep_np =3D of_parse_phandle(port, "phy-handle", 0); =20
>=20
> As i said, phy-handle points to a phy. It minimum, you need to call
> this mac-handle. But that then makes this switch driver very different
> to every other switch driver.

Other drivers (DSA for example) use "ethernet" or "link" properties.
Maybe those can be reused?

>=20
> > +		pdev =3D of_find_device_by_node(fep_np);
> > +		ndev =3D platform_get_drvdata(pdev);
> > +		priv->fep[port_num - 1] =3D netdev_priv(ndev); =20
>=20
> What happens when somebody puts reg=3D<42>; in DT?

I do guess that this will break the code.

However, DSA DT descriptions also rely on the exact numbering [1] (via
e.g. reg property) of the ports. I've followed this paradigm.

>=20
> I would say, your basic structure needs to change, to make it more
> like other switchdev drivers. You need to replace the two FEC device
> instances with one switchdev driver.

I've used the cpsw_new.c as the example.

> The switchdev driver will then
> instantiate the two netdevs for the two external MACs.

Then there is a question - what about eth[01], which already exists?

Shall I close them and then reuse (create as a new one?) eth0 to be
connected to switch port0 (via DMA0)?

Then, I do need two net_device ports, which would only control PHY
device and setup ENET-MAC for rmii, as the L2 switch will provide data
for transmission. Those two ports are connected to switch's port[12]
and look very similar to ports created by DSA driver (but shall not
transmit and receive data).

Maybe I've overlooked something, but the rocker switchdev driver
(rocker_main.c) sets netdev_ops (with .ndo_start_xmit) for ports which
it creates. The prestera's prestera_sdma_xmit() (in prestera_rxtx.c)
also setups the SDMA for those.

In i.MX L2 switch case - one just needs to setup DMA0 to send data to
engress ports. IMHO, those ports just need to handle PHY link (up/down
10/100 change) and statistics.

> You can
> hopefully reuse some of the FEC code for that, but i expect you are
> going to have to refactor the FEC driver and turn part of it into a
> library, which the switchdev driver can then use.

To be honest - such driver for L2 switch already has been forward
ported by me [2] to v4.19.

It has the L2 switch enabled after the boot and there is no way to
disable it.

When you look on the code - it is a copy-paste of the FEC driver, with
some necessary adjustments.=20

The FEC driver itself is large and used by almost _ALL_ i.MX SoCs.
Turning it into library will move the already working code around. I
wanted to avoid it.

The idea behind this patch series is as follows (to offload bridging to
MTIP L2 switch IP block):
-------------------------
1. When bridge is created disable eth0 and eth1 (fec_close)

2. Set a flag for fec driver, so DMA descriptors registers and ones to
initiate transfer are adjusted for DMA0 (eth0) device. Also L2 switch
IP block has different bits positions for interrupts.

3. DMA1 - which with normal setup corresponds to eth1 - is not used.

4. FEC driver also monitors PHY changes (link up/down speed change
10/100) (for both eth0, eth1).

5. When br0 is deleted - the mtip support flag is cleared and FEC
network interfaces (eth[01]) are opened again (via fec_open).

With above approach many operations are already performed - like
ENET-MAC setup, buffers allocation, etc.
To make L2 switch working with this setup we need to re-map 4 registers
and two interrupt bits in fec_main driver.

I'm just wondering if is it worth to refactor already working driver to
library, instantiate new interfaces and re-init all the already
initialized stuff ?


>=20
> 	 Andrew


Links:

[1] -
https://elixir.bootlin.com/linux/latest/source/arch/arm/boot/dts/armada-388=
-clearfog.dts#L93

[2] - https://github.com/lmajewski/linux-imx28-l2switch/commits/master

Best regards,

Lukasz Majewski

--

DENX Software Engineering GmbH,      Managing Director: Wolfgang Denk
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany
Phone: (+49)-8142-66989-59 Fax: (+49)-8142-66989-80 Email: lukma@denx.de

--Sig_/PlJN2z9vs/ks/6=T=lKv9SG
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCgAdFiEEgAyFJ+N6uu6+XupJAR8vZIA0zr0FAmDTHOAACgkQAR8vZIA0
zr2qdAgA432VPTX8S8gLTIK2Y+d3E8p6iq5zK2VplriRx0bhoILU5bQoCPE5C4Ww
vJ5CLv9ixqO/LHwvxzPtqpYBFiApkwPCQFxVzFS4WYSI0mjCWp4A+p52WvPDGJoZ
mn4zxq3vS/5Y+KvlEpTFLG544UpidZP/bsDpBSXFObR+enL/Bw6wB8I95CXwjyx/
lTg9xa0aoCt2QI/Tt7ZwiQijWCMsfhvxIqtUXjHtTa2zBeNDQStzw3T/nzsv4mmg
gIE4IXIY7C7JBS+rXx6tTLPkbyPDP2pCxM5AFzeUKQz9pubePv+w276pFJ7F83CD
RmNLzt8nq6N+hW5dyM6I08q/iUit0w==
=zz1z
-----END PGP SIGNATURE-----

--Sig_/PlJN2z9vs/ks/6=T=lKv9SG--
