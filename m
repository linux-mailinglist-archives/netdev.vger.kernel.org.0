Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8DE536BCEBC
	for <lists+netdev@lfdr.de>; Thu, 16 Mar 2023 12:50:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230208AbjCPLuv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Mar 2023 07:50:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52622 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229733AbjCPLuu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Mar 2023 07:50:50 -0400
Received: from relay5-d.mail.gandi.net (relay5-d.mail.gandi.net [217.70.183.197])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ACAAF49F3;
        Thu, 16 Mar 2023 04:50:47 -0700 (PDT)
Received: (Authenticated sender: clement.leger@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id F373E1C0005;
        Thu, 16 Mar 2023 11:50:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1678967445;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=E1afFIzDsJ40IP7Ith3L/4SRKNCsYKLONEXOEtzaXbs=;
        b=Nn5HyeapmUkGllvyxQEGYP/X+cMnXXK0lX4ufrC/EhLRdqJ/pWmEogmdcrKat+hZDlPgHF
        Qh0udtx4m7bVmBSI5xVu5/1+ExG6C3dVUATriG8FHR3jpPogKGuTu36jRk4grXhkkBd1XW
        eYZ9oAFJeBj+HUr5uSK4h56fru4jJiItlr7gv75qSCzCWbgR0Mvu8OnxCHjtQ+XyP+1t/Z
        WqJIT9K6dFM2oFLQd6MG3o6n0KIiywhy/GD6eGjTux3/JL5D0IVp9FkPbJmkKAl0WAmh6q
        h2ZGY0Hjw+ZQwQ9Q8KL4vy1io85bRpYykrxllDuV0VPHWbk32KxL0D59t2YyGA==
Date:   Thu, 16 Mar 2023 12:53:29 +0100
From:   =?UTF-8?B?Q2zDqW1lbnQgTMOpZ2Vy?= <clement.leger@bootlin.com>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Herve Codina <herve.codina@bootlin.com>,
        =?UTF-8?B?TWlxdcOobA==?= Raynal <miquel.raynal@bootlin.com>,
        Milan Stevanovic <milan.stevanovic@se.com>,
        Jimmy Lalande <jimmy.lalande@se.com>,
        Pascal Eberhard <pascal.eberhard@se.com>,
        Arun Ramadoss <Arun.Ramadoss@microchip.com>,
        linux-renesas-soc@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Alexis =?UTF-8?B?TG90aG9yw6k=?= <alexis.lothore@bootlin.com>
Subject: Re: [PATCH RESEND net-next v4 2/3] net: dsa: rzn1-a5psw: add
 support for .port_bridge_flags
Message-ID: <20230316125329.75b290d4@fixe.home>
In-Reply-To: <20230314230821.kjiyseiqhat4apqb@skbuf>
References: <20230314163651.242259-1-clement.leger@bootlin.com>
        <20230314163651.242259-3-clement.leger@bootlin.com>
        <20230314230821.kjiyseiqhat4apqb@skbuf>
Organization: Bootlin
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.36; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Le Wed, 15 Mar 2023 01:08:21 +0200,
Vladimir Oltean <olteanv@gmail.com> a =C3=A9crit :

> On Tue, Mar 14, 2023 at 05:36:50PM +0100, Cl=C3=A9ment L=C3=A9ger wrote:
> > +static int a5psw_port_pre_bridge_flags(struct dsa_switch *ds, int port,
> > +				       struct switchdev_brport_flags flags,
> > +				       struct netlink_ext_ack *extack)
> > +{
> > +	if (flags.mask & ~(BR_LEARNING | BR_FLOOD | BR_MCAST_FLOOD |
> > +			   BR_BCAST_FLOOD))
> > +		return -EINVAL;
> > +
> > +	return 0;
> > +}
> > +
> > +static int
> > +a5psw_port_bridge_flags(struct dsa_switch *ds, int port,
> > +			struct switchdev_brport_flags flags,
> > +			struct netlink_ext_ack *extack)
> > +{
> > +	struct a5psw *a5psw =3D ds->priv;
> > +	u32 val;
> > +
> > +	if (flags.mask & BR_LEARNING) {
> > +		val =3D flags.val & BR_LEARNING ? 0 : A5PSW_INPUT_LEARN_DIS(port);
> > +		a5psw_reg_rmw(a5psw, A5PSW_INPUT_LEARN,
> > +			      A5PSW_INPUT_LEARN_DIS(port), val);
> > +	} =20
>=20
> 2 issues.
>=20
> 1: does this not get overwritten by a5psw_port_stp_state_set()?

Hum indeed. How is this kind of thing supposed to be handled ? Should I
remove the handling of BR_LEARNING to forbid modifying it ? Ot should I
allow it only if STP isn't enabled (which I'm not sure how to do it) ?

> 2: What is the hardware default value for A5PSW_INPUT_LEARN? Please make
>    sure that standalone ports have learning disabled by default, when
>    the driver probes.
>=20
> > +
> > +	if (flags.mask & BR_FLOOD) {
> > +		val =3D flags.val & BR_FLOOD ? BIT(port) : 0;
> > +		a5psw_reg_rmw(a5psw, A5PSW_UCAST_DEF_MASK, BIT(port), val);
> > +	}
> > +
> > +	if (flags.mask & BR_MCAST_FLOOD) {
> > +		val =3D flags.val & BR_MCAST_FLOOD ? BIT(port) : 0;
> > +		a5psw_reg_rmw(a5psw, A5PSW_MCAST_DEF_MASK, BIT(port), val);
> > +	}
> > +
> > +	if (flags.mask & BR_BCAST_FLOOD) {
> > +		val =3D flags.val & BR_BCAST_FLOOD ? BIT(port) : 0;
> > +		a5psw_reg_rmw(a5psw, A5PSW_BCAST_DEF_MASK, BIT(port), val);
> > +	} =20
>=20
> Humm, there's a (huge) problem with this flooding mask.
>=20
> a5psw_flooding_set_resolution() - called from a5psw_port_bridge_join()
> and a5psw_port_bridge_leave() - touches the same registers as
> a5psw_port_bridge_flags(). Which means that your bridge forwarding
> domain controls are the same as your flooding controls.
>=20
> Which is bad news, because
> dsa_port_bridge_leave()
> -> dsa_port_switchdev_unsync_attrs()
>    -> dsa_port_clear_brport_flags()
>       -> dsa_port_bridge_flags()
>          -> a5psw_port_bridge_flags() =20
>=20
> enables flooding on the port after calling a5psw_port_bridge_leave().
> So the port which has left a bridge is standalone, but it still forwards
> packets to the other bridged ports!

Actually not this way because the port is configured in a specific mode
which only forward packet to the CPU ports. Indeed, we set a specific
rule using the PATTERN_CTRL register with the MGMTFWD bit set:
When set, the frame is forwarded to the management port only
(suppressing destination address lookup).

However, the port will received packets *from* the other ports (which is
wrong... I can handle that by not setting the flooding attributes if
the port is not in bridge. Doing so would definitely fix the various
problems that could happen.

BTW, the same goes with the learning bit that would be reenabled after
leaving the bridge and you mentionned it should be disabled for a
standalone port.

>=20
> You should be able to see that this is the case, if you put the ports
> under a dummy bridge, then run tools/testing/selftests/drivers/net/dsa/no=
_forwarding.sh.

Yes, makes sense.

Thanks,

--=20
Cl=C3=A9ment L=C3=A9ger,
Embedded Linux and Kernel engineer at Bootlin
https://bootlin.com
