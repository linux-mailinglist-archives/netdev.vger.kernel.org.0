Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C51876CFEEC
	for <lists+netdev@lfdr.de>; Thu, 30 Mar 2023 10:48:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229869AbjC3Ir7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Mar 2023 04:47:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44466 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229459AbjC3Ir5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Mar 2023 04:47:57 -0400
Received: from relay10.mail.gandi.net (relay10.mail.gandi.net [217.70.178.230])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 32BA8E7;
        Thu, 30 Mar 2023 01:47:55 -0700 (PDT)
Received: (Authenticated sender: clement.leger@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id E1CC8240006;
        Thu, 30 Mar 2023 08:47:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1680166072;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=iJpF4M8YdL0AOcX5CD7BuvZJXT4j6+GpVvaQkjzGNI8=;
        b=gQAyJhByJLupHTN0T182G/D1PTGEeSLCdL1YMQyz8Y0QBeSoex+udjUP8Wx0I/GJNHmNdf
        gt0Hlq2qXdbnJg/6crCmyEgnlmxsKBNDcM/bH9iweqReESbWlPucR2lOtlGKgEOwRgJbKq
        Poa0fd03CWZfr4D3AtDMf8wVZ+czB46pJpqB+ZTghuSh/HeP5A1FKvj4W1D/MVX2AuPToP
        2oAHAKCRlX8erE3mfQr5VC+3KH09h6Z874D260Qo407yCOzXmEpqfTcmWXfv2CT23qVBub
        GpHqbxXO5ppCwrorgDqcS09L/ec+JhEVQ8sp2aRniWRbCp1UJcOf03OSey/6Jg==
Date:   Thu, 30 Mar 2023 10:48:28 +0200
From:   =?UTF-8?B?Q2zDqW1lbnQgTMOpZ2Vy?= <clement.leger@bootlin.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     linux-renesas-soc@vger.kernel.org, netdev@vger.kernel.org,
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
Message-ID: <20230330104828.6badaaad@fixe.home>
In-Reply-To: <20230330083408.63136-2-clement.leger@bootlin.com>
References: <20230330083408.63136-1-clement.leger@bootlin.com>
 <20230330083408.63136-2-clement.leger@bootlin.com>
Organization: Bootlin
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.36; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-0.9 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H2,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Le Thu, 30 Mar 2023 10:34:07 +0200,
Cl=C3=A9ment L=C3=A9ger <clement.leger@bootlin.com> a =C3=A9crit :

> Current there were actually two problems which made the STP support non
> working. First, the BPDU were disabled on the CPU port which means BDPUs
> were actually dropped internally to the switch. TO fix that, simply enable
> BPDUs at management port level. Then, the a5psw_port_stp_set_state()
> should  have actually received BPDU while in LEARNING mode which was not
> the case. Additionally, the BLOCKEN bit does not actually forbid
> sending forwarded frames from that port. To fix this, add
> a5psw_port_tx_enable() function which allows to disable TX. However, while
> its name suggest that TX is totally disabled, it is not and can still
> allows to send BPDUs even if disabled. This can be done by using forced
> forwarding with the switch tagging mecanism but keeping "filtering"
> disabled (which is already the case). Which these fixes, STP support is n=
ow
> functional.
>=20
> Signed-off-by: Cl=C3=A9ment L=C3=A9ger <clement.leger@bootlin.com>
> ---
>  drivers/net/dsa/rzn1_a5psw.c | 53 +++++++++++++++++++++++++++++-------
>  drivers/net/dsa/rzn1_a5psw.h |  4 ++-
>  2 files changed, 46 insertions(+), 11 deletions(-)
>=20
> diff --git a/drivers/net/dsa/rzn1_a5psw.c b/drivers/net/dsa/rzn1_a5psw.c
> index 919027cf2012..bbc1424ed416 100644
> --- a/drivers/net/dsa/rzn1_a5psw.c
> +++ b/drivers/net/dsa/rzn1_a5psw.c
> @@ -120,6 +120,22 @@ static void a5psw_port_mgmtfwd_set(struct a5psw *a5p=
sw, int port, bool enable)
>  	a5psw_port_pattern_set(a5psw, port, A5PSW_PATTERN_MGMTFWD, enable);
>  }
> =20
> +static void a5psw_port_tx_enable(struct a5psw *a5psw, int port, bool ena=
ble)
> +{
> +	u32 mask =3D A5PSW_PORT_ENA_TX(port);
> +	u32 reg =3D enable ? mask : 0;
> +
> +	/* Even though the port TX is disabled through TXENA bit in the
> +	 * PORT_ENA register it can still send BPDUs. This depends on the tag
> +	 * configuration added when sending packets from the CPU port to the
> +	 * switch port. Indeed, when using forced forwarding without filtering,
> +	 * even disabled port will be able to send packets that are tagged. This
> +	 * allows to implement STP support when ports are in a state were
> +	 * forwarding traffic should be stopped but BPDUs should still be sent.
> +	 */
> +	a5psw_reg_rmw(a5psw, A5PSW_CMD_CFG(port), mask, reg);
> +}
> +
>  static void a5psw_port_enable_set(struct a5psw *a5psw, int port, bool en=
able)
>  {
>  	u32 port_ena =3D 0;
> @@ -292,6 +308,18 @@ static int a5psw_set_ageing_time(struct dsa_switch *=
ds, unsigned int msecs)
>  	return 0;
>  }
> =20
> +static void a5psw_port_learning_set(struct a5psw *a5psw, int port,
> +				    bool learning, bool blocked)
> +{
> +	u32 mask =3D A5PSW_INPUT_LEARN_DIS(port) | A5PSW_INPUT_LEARN_BLOCK(port=
);
> +	u32 reg =3D 0;
> +
> +	reg |=3D !learning ? A5PSW_INPUT_LEARN_DIS(port) : 0;
> +	reg |=3D blocked ? A5PSW_INPUT_LEARN_BLOCK(port) : 0;
> +
> +	a5psw_reg_rmw(a5psw, A5PSW_INPUT_LEARN, mask, reg);
> +}
> +
>  static void a5psw_flooding_set_resolution(struct a5psw *a5psw, int port,
>  					  bool set)
>  {
> @@ -344,28 +372,33 @@ static void a5psw_port_bridge_leave(struct dsa_swit=
ch *ds, int port,
> =20
>  static void a5psw_port_stp_state_set(struct dsa_switch *ds, int port, u8=
 state)
>  {
> -	u32 mask =3D A5PSW_INPUT_LEARN_DIS(port) | A5PSW_INPUT_LEARN_BLOCK(port=
);
>  	struct a5psw *a5psw =3D ds->priv;
> -	u32 reg =3D 0;
> +	bool learn, block;
> =20
>  	switch (state) {
>  	case BR_STATE_DISABLED:
>  	case BR_STATE_BLOCKING:
> -		reg |=3D A5PSW_INPUT_LEARN_DIS(port);
> -		reg |=3D A5PSW_INPUT_LEARN_BLOCK(port);
> -		break;
>  	case BR_STATE_LISTENING:
> -		reg |=3D A5PSW_INPUT_LEARN_DIS(port);
> +		block =3D true;
> +		learn =3D false;
> +		a5psw_port_tx_enable(a5psw, port, false);

Actually, after leaving a bridge, it seems like the DSA core put the
port in STP DISABLED state. Which means it will potentially leave that
port with TX disable... Since this TX enable is applying not only on
bridge port but also on standalone port, it seems like this also needs
to be reenabled in bridge_leave().

>  		break;
>  	case BR_STATE_LEARNING:
> -		reg |=3D A5PSW_INPUT_LEARN_BLOCK(port);
> +		block =3D true;
> +		learn =3D true;
> +		a5psw_port_tx_enable(a5psw, port, false);
>  		break;
>  	case BR_STATE_FORWARDING:
> -	default:
> +		block =3D false;
> +		learn =3D true;
> +		a5psw_port_tx_enable(a5psw, port, true);
>  		break;
> +	default:
> +		dev_err(ds->dev, "invalid STP state: %d\n", state);
> +		return;
>  	}
> =20
> -	a5psw_reg_rmw(a5psw, A5PSW_INPUT_LEARN, mask, reg);
> +	a5psw_port_learning_set(a5psw, port, learn, block);
>  }
> =20
>  static void a5psw_port_fast_age(struct dsa_switch *ds, int port)
> @@ -673,7 +706,7 @@ static int a5psw_setup(struct dsa_switch *ds)
>  	}
> =20
>  	/* Configure management port */
> -	reg =3D A5PSW_CPU_PORT | A5PSW_MGMT_CFG_DISCARD;
> +	reg =3D A5PSW_CPU_PORT | A5PSW_MGMT_CFG_ENABLE;
>  	a5psw_reg_writel(a5psw, A5PSW_MGMT_CFG, reg);
> =20
>  	/* Set pattern 0 to forward all frame to mgmt port */
> diff --git a/drivers/net/dsa/rzn1_a5psw.h b/drivers/net/dsa/rzn1_a5psw.h
> index c67abd49c013..04d9486dbd21 100644
> --- a/drivers/net/dsa/rzn1_a5psw.h
> +++ b/drivers/net/dsa/rzn1_a5psw.h
> @@ -19,6 +19,8 @@
>  #define A5PSW_PORT_OFFSET(port)		(0x400 * (port))
> =20
>  #define A5PSW_PORT_ENA			0x8
> +#define A5PSW_PORT_ENA_TX_SHIFT		0
> +#define A5PSW_PORT_ENA_TX(port)		BIT(port)
>  #define A5PSW_PORT_ENA_RX_SHIFT		16
>  #define A5PSW_PORT_ENA_TX_RX(port)	(BIT((port) + A5PSW_PORT_ENA_RX_SHIFT=
) | \
>  					 BIT(port))
> @@ -36,7 +38,7 @@
>  #define A5PSW_INPUT_LEARN_BLOCK(p)	BIT(p)
> =20
>  #define A5PSW_MGMT_CFG			0x20
> -#define A5PSW_MGMT_CFG_DISCARD		BIT(7)
> +#define A5PSW_MGMT_CFG_ENABLE		BIT(6)
> =20
>  #define A5PSW_MODE_CFG			0x24
>  #define A5PSW_MODE_STATS_RESET		BIT(31)



--=20
Cl=C3=A9ment L=C3=A9ger,
Embedded Linux and Kernel engineer at Bootlin
https://bootlin.com
