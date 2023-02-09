Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3C549690242
	for <lists+netdev@lfdr.de>; Thu,  9 Feb 2023 09:38:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229751AbjBIIiD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Feb 2023 03:38:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51976 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229569AbjBIIh6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Feb 2023 03:37:58 -0500
Received: from relay11.mail.gandi.net (relay11.mail.gandi.net [217.70.178.231])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A7A3518D3;
        Thu,  9 Feb 2023 00:37:46 -0800 (PST)
Received: (Authenticated sender: clement.leger@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id 30095100004;
        Thu,  9 Feb 2023 08:37:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1675931865;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=z/E4jLCbMGwWDkGl/b6D6gDfcru5J7/41TQ0OJTd3bw=;
        b=eA19dv1Vh9kq+EWGy1aBxcb8E6dEv11+UTZmUbY7ZLiHexxq6g9F08BJVzMtCLsTn9kZ7H
        LfyOpaZqaGRe4rVuhMp+PkYFpRZjPpGuZ+tu24q2U1ig2g7b3QqQUH67tB4ULePJPsTIWT
        3cZIikv86LaaP2d1VJP5ToeRBRF3C/Dr6Jb8wt1iYAqsEQROt3TJuI/jw7ikXOYzZKgts2
        hAVr9pZfS3egQjeVaC31wofKCl1ll1bXSJfWEmvgfd+M8NwGKk6UBYEWdEGD3WFgGvYQ0j
        bwKyJSYdkIDj57QFzsF4lJZQYwJstdwwTiTTUnwmeZ8ewvIUNWt1MTpzxAeCsQ==
Date:   Thu, 9 Feb 2023 09:40:06 +0100
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
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next v3 1/3] net: dsa: rzn1-a5psw: use
 a5psw_reg_rmw() to modify flooding resolution
Message-ID: <20230209094006.66ce1409@fixe.home>
In-Reply-To: <20230208213757.iyofbkmvww6r4luy@skbuf>
References: <20230208161749.331965-1-clement.leger@bootlin.com>
        <20230208161749.331965-2-clement.leger@bootlin.com>
        <20230208213757.iyofbkmvww6r4luy@skbuf>
Organization: Bootlin
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.36; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Le Wed, 8 Feb 2023 23:37:57 +0200,
Vladimir Oltean <olteanv@gmail.com> a =C3=A9crit :

> On Wed, Feb 08, 2023 at 05:17:47PM +0100, Cl=C3=A9ment L=C3=A9ger wrote:
> > .port_bridge_flags will be added and allows to modify the flood mask
> > independently for each port. Keeping the existing bridged_ports write
> > in a5psw_flooding_set_resolution() would potentially messed up this.
> > Use a read-modify-write to set that value and move bridged_ports
> > handling in bridge_port_join/leave.
> >=20
> > Signed-off-by: Cl=C3=A9ment L=C3=A9ger <clement.leger@bootlin.com>
> > ---
> >  drivers/net/dsa/rzn1_a5psw.c | 12 ++++++------
> >  1 file changed, 6 insertions(+), 6 deletions(-)
> >=20
> > diff --git a/drivers/net/dsa/rzn1_a5psw.c b/drivers/net/dsa/rzn1_a5psw.c
> > index 919027cf2012..8b7d4a371f8b 100644
> > --- a/drivers/net/dsa/rzn1_a5psw.c
> > +++ b/drivers/net/dsa/rzn1_a5psw.c
> > @@ -299,13 +299,9 @@ static void a5psw_flooding_set_resolution(struct a=
5psw *a5psw, int port,
> >  			A5PSW_MCAST_DEF_MASK};
> >  	int i;
> > =20
> > -	if (set)
> > -		a5psw->bridged_ports |=3D BIT(port);
> > -	else
> > -		a5psw->bridged_ports &=3D ~BIT(port);
> > -
> >  	for (i =3D 0; i < ARRAY_SIZE(offsets); i++)
> > -		a5psw_reg_writel(a5psw, offsets[i], a5psw->bridged_ports);
> > +		a5psw_reg_rmw(a5psw, offsets[i], BIT(port),
> > +			      set ? BIT(port) : 0);
> >  }
> > =20
> >  static int a5psw_port_bridge_join(struct dsa_switch *ds, int port,
> > @@ -326,6 +322,8 @@ static int a5psw_port_bridge_join(struct dsa_switch=
 *ds, int port,
> >  	a5psw_flooding_set_resolution(a5psw, port, true);
> >  	a5psw_port_mgmtfwd_set(a5psw, port, false);
> > =20
> > +	a5psw->bridged_ports |=3D BIT(port);
> > +
> >  	return 0;
> >  }
> > =20
> > @@ -334,6 +332,8 @@ static void a5psw_port_bridge_leave(struct dsa_swit=
ch *ds, int port,
> >  {
> >  	struct a5psw *a5psw =3D ds->priv;
> > =20
> > +	a5psw->bridged_ports &=3D ~BIT(port);
> > +
> >  	a5psw_flooding_set_resolution(a5psw, port, false);
> >  	a5psw_port_mgmtfwd_set(a5psw, port, true);
> > =20
> > --=20
> > 2.39.0
> >  =20
>=20
> What about the a5psw_flooding_set_resolution() call for the CPU port, fro=
m a5psw_setup()?
> Isn't this an undocumented change? Does this logic in a5psw_port_bridge_l=
eave() still work,
> now that bridged_ports will no longer contain BIT(A5PSW_CPU_PORT)?
>=20
> 	/* No more ports bridged */
> 	if (a5psw->bridged_ports =3D=3D BIT(A5PSW_CPU_PORT))
> 		a5psw->br_dev =3D NULL;

You are right, this actually disallow to create a bridge multiple
times. I'll fix that.

--=20
Cl=C3=A9ment L=C3=A9ger,
Embedded Linux and Kernel engineer at Bootlin
https://bootlin.com
