Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 611AA6D0A39
	for <lists+netdev@lfdr.de>; Thu, 30 Mar 2023 17:44:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233296AbjC3Pot (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Mar 2023 11:44:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56402 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233297AbjC3Poq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Mar 2023 11:44:46 -0400
Received: from relay5-d.mail.gandi.net (relay5-d.mail.gandi.net [IPv6:2001:4b98:dc4:8::225])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 582E972A2;
        Thu, 30 Mar 2023 08:44:00 -0700 (PDT)
Received: (Authenticated sender: clement.leger@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id 475B91C000B;
        Thu, 30 Mar 2023 15:43:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1680191033;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=mxSLpWEbD6iCaY1bClhTliWZNcDCwnBI24U2WjZF5sI=;
        b=BzQ3N/OLMPmzsI4qIXqE68Tp/ZOV22sikVJXpzurDHD/IJsCnESN0R4Mdtsk0k4KkwgoX4
        3ZMGD6GT5ou3v3qVdGM5yTtIJznmG2YnpO4UcnvWdAc/e0Elf3+KdRJZ+1xUTk/DOsNKX3
        b277DsSZP8XwE/kZYADmFXjlzc47nTqbzMV4+FVvd94Whqtirx7MS1RqsFCs02xfMfe3vv
        TZ2wk33qBpsAdQpFYAddMb8UlxcNU265/WGyLSfi2v3wSLIJLPVf9ae+1wGSGAxjonZOZ+
        4qIEXKgECx8EkBQtyImPgfgWGSH2Qf+Za5FPyrlR/2BGRM7SB3vf1UNMevUAQg==
Date:   Thu, 30 Mar 2023 17:44:27 +0200
From:   =?UTF-8?B?Q2zDqW1lbnQgTMOpZ2Vy?= <clement.leger@bootlin.com>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        linux-renesas-soc@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Herve Codina <herve.codina@bootlin.com>,
        =?UTF-8?B?TWlxdcOobA==?= Raynal <miquel.raynal@bootlin.com>,
        Milan Stevanovic <milan.stevanovic@se.com>,
        Jimmy Lalande <jimmy.lalande@se.com>,
        Pascal Eberhard <pascal.eberhard@se.com>,
        Alexis =?UTF-8?B?TG90aG9yw6k=?= <alexis.lothore@bootlin.com>
Subject: Re: [PATCH net-next 1/2] net: dsa: rzn1-a5psw: enable DPBU for CPU
 port and fix STP states
Message-ID: <20230330174427.0310276a@fixe.home>
In-Reply-To: <20230330151653.atzd5ptacral6syx@skbuf>
References: <20230330083408.63136-1-clement.leger@bootlin.com>
        <20230330083408.63136-1-clement.leger@bootlin.com>
        <20230330083408.63136-2-clement.leger@bootlin.com>
        <20230330083408.63136-2-clement.leger@bootlin.com>
        <20230330151653.atzd5ptacral6syx@skbuf>
Organization: Bootlin
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.36; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-0.9 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Le Thu, 30 Mar 2023 18:16:53 +0300,
Vladimir Oltean <olteanv@gmail.com> a =C3=A9crit :

> Have you considered adding some Fixes: tags and sending to the "net" tree?

I wasn't sure if due to the refactoring that should go directly to the
net tree but I'll do that. But since they are fixes, that's the way to
go.

>=20
> >  drivers/net/dsa/rzn1_a5psw.c | 53 +++++++++++++++++++++++++++++-------
> >  drivers/net/dsa/rzn1_a5psw.h |  4 ++-
> >  2 files changed, 46 insertions(+), 11 deletions(-)
> >=20
> > diff --git a/drivers/net/dsa/rzn1_a5psw.c b/drivers/net/dsa/rzn1_a5psw.c
> > index 919027cf2012..bbc1424ed416 100644
> > --- a/drivers/net/dsa/rzn1_a5psw.c
> > +++ b/drivers/net/dsa/rzn1_a5psw.c
> > @@ -120,6 +120,22 @@ static void a5psw_port_mgmtfwd_set(struct a5psw *a=
5psw, int port, bool enable)
> >  	a5psw_port_pattern_set(a5psw, port, A5PSW_PATTERN_MGMTFWD, enable);
> >  }
> > =20
> > +static void a5psw_port_tx_enable(struct a5psw *a5psw, int port, bool e=
nable)
> > +{
> > +	u32 mask =3D A5PSW_PORT_ENA_TX(port);
> > +	u32 reg =3D enable ? mask : 0;
> > +
> > +	/* Even though the port TX is disabled through TXENA bit in the
> > +	 * PORT_ENA register it can still send BPDUs. This depends on the tag=
 =20
>=20
> s/register/register,/
>=20
> > +	 * configuration added when sending packets from the CPU port to the
> > +	 * switch port. Indeed, when using forced forwarding without filterin=
g,
> > +	 * even disabled port will be able to send packets that are tagged. T=
his =20
>=20
> s/port/ports/
>=20
> > +	 * allows to implement STP support when ports are in a state were =20
>=20
> s/were/where/
>=20
> > +	 * forwarding traffic should be stopped but BPDUs should still be sen=
t. =20
>=20
> To be absolutely clear, when talking about BPDUs, is it applicable
> effectively only to STP protocol frames, or to any management traffic
> sent by tag_rzn1_a5psw.c which has A5PSW_CTRL_DATA_FORCE_FORWARD set?

The documentation uses BPDUs but this is to be understood as in a
broader sense for "management frames" since it matches all the MAC with
"01-80-c2-00-00-XX".=20

>=20
> > +	 */
> > +	a5psw_reg_rmw(a5psw, A5PSW_CMD_CFG(port), mask, reg);
> > +}
> > +
> >  static void a5psw_port_enable_set(struct a5psw *a5psw, int port, bool =
enable)
> >  {
> >  	u32 port_ena =3D 0;
> > @@ -292,6 +308,18 @@ static int a5psw_set_ageing_time(struct dsa_switch=
 *ds, unsigned int msecs)
> >  	return 0;
> >  }
> > =20
> > +static void a5psw_port_learning_set(struct a5psw *a5psw, int port,
> > +				    bool learning, bool blocked)
> > +{
> > +	u32 mask =3D A5PSW_INPUT_LEARN_DIS(port) | A5PSW_INPUT_LEARN_BLOCK(po=
rt);
> > +	u32 reg =3D 0;
> > +
> > +	reg |=3D !learning ? A5PSW_INPUT_LEARN_DIS(port) : 0;
> > +	reg |=3D blocked ? A5PSW_INPUT_LEARN_BLOCK(port) : 0;
> > +
> > +	a5psw_reg_rmw(a5psw, A5PSW_INPUT_LEARN, mask, reg);
> > +} =20
>=20
> Would it be useful to have independent functions for "learning" and
> "blocked", for when learning will be made configurable?

You are right, If we allow configuring it through bridge_flags(), this
clearly needs to be split up from blocking support.

>=20
> > +
> >  static void a5psw_flooding_set_resolution(struct a5psw *a5psw, int por=
t,
> >  					  bool set)
> >  {
> > @@ -344,28 +372,33 @@ static void a5psw_port_bridge_leave(struct dsa_sw=
itch *ds, int port,
> > =20
> >  static void a5psw_port_stp_state_set(struct dsa_switch *ds, int port, =
u8 state)
> >  {
> > -	u32 mask =3D A5PSW_INPUT_LEARN_DIS(port) | A5PSW_INPUT_LEARN_BLOCK(po=
rt);
> >  	struct a5psw *a5psw =3D ds->priv;
> > -	u32 reg =3D 0;
> > +	bool learn, block;
> > =20
> >  	switch (state) {
> >  	case BR_STATE_DISABLED:
> >  	case BR_STATE_BLOCKING:
> > -		reg |=3D A5PSW_INPUT_LEARN_DIS(port);
> > -		reg |=3D A5PSW_INPUT_LEARN_BLOCK(port);
> > -		break;
> >  	case BR_STATE_LISTENING:
> > -		reg |=3D A5PSW_INPUT_LEARN_DIS(port);
> > +		block =3D true;
> > +		learn =3D false;
> > +		a5psw_port_tx_enable(a5psw, port, false);
> >  		break;
> >  	case BR_STATE_LEARNING:
> > -		reg |=3D A5PSW_INPUT_LEARN_BLOCK(port);
> > +		block =3D true;
> > +		learn =3D true;
> > +		a5psw_port_tx_enable(a5psw, port, false);
> >  		break;
> >  	case BR_STATE_FORWARDING:
> > -	default:
> > +		block =3D false;
> > +		learn =3D true;
> > +		a5psw_port_tx_enable(a5psw, port, true);
> >  		break;
> > +	default:
> > +		dev_err(ds->dev, "invalid STP state: %d\n", state);
> > +		return;
> >  	}
> > =20
> > -	a5psw_reg_rmw(a5psw, A5PSW_INPUT_LEARN, mask, reg);
> > +	a5psw_port_learning_set(a5psw, port, learn, block); =20
>=20
> To be consistent, could you add a "bool tx_enabled" and a single call to
> a5psw_port_tx_enable() at the end? "block" could also be named "!rx_enabl=
ed"
> for some similarity and clarity regarding what it does.

That seems reasonnable even though they do not act on the same
registers but have the same corresponding effect (stopping
ingress/egress traffic but with an exception for BPDU).

>=20
> >  }
> > =20
> >  static void a5psw_port_fast_age(struct dsa_switch *ds, int port)
> > @@ -673,7 +706,7 @@ static int a5psw_setup(struct dsa_switch *ds)
> >  	}
> > =20
> >  	/* Configure management port */
> > -	reg =3D A5PSW_CPU_PORT | A5PSW_MGMT_CFG_DISCARD;
> > +	reg =3D A5PSW_CPU_PORT | A5PSW_MGMT_CFG_ENABLE;
> >  	a5psw_reg_writel(a5psw, A5PSW_MGMT_CFG, reg);
> > =20
> >  	/* Set pattern 0 to forward all frame to mgmt port */
> > diff --git a/drivers/net/dsa/rzn1_a5psw.h b/drivers/net/dsa/rzn1_a5psw.h
> > index c67abd49c013..04d9486dbd21 100644
> > --- a/drivers/net/dsa/rzn1_a5psw.h
> > +++ b/drivers/net/dsa/rzn1_a5psw.h
> > @@ -19,6 +19,8 @@
> >  #define A5PSW_PORT_OFFSET(port)		(0x400 * (port))
> > =20
> >  #define A5PSW_PORT_ENA			0x8
> > +#define A5PSW_PORT_ENA_TX_SHIFT		0 =20
>=20
> either use it in the A5PSW_PORT_ENA_TX() definition, or remove it.
>=20
> > +#define A5PSW_PORT_ENA_TX(port)		BIT(port)
> >  #define A5PSW_PORT_ENA_RX_SHIFT		16
> >  #define A5PSW_PORT_ENA_TX_RX(port)	(BIT((port) + A5PSW_PORT_ENA_RX_SHI=
FT) | \
> >  					 BIT(port))
> > @@ -36,7 +38,7 @@
> >  #define A5PSW_INPUT_LEARN_BLOCK(p)	BIT(p)
> > =20
> >  #define A5PSW_MGMT_CFG			0x20
> > -#define A5PSW_MGMT_CFG_DISCARD		BIT(7)
> > +#define A5PSW_MGMT_CFG_ENABLE		BIT(6)
> > =20
> >  #define A5PSW_MODE_CFG			0x24
> >  #define A5PSW_MODE_STATS_RESET		BIT(31)
> > --=20
> > 2.39.2
> >  =20
>=20



--=20
Cl=C3=A9ment L=C3=A9ger,
Embedded Linux and Kernel engineer at Bootlin
https://bootlin.com
