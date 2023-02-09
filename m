Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5D7CD69061E
	for <lists+netdev@lfdr.de>; Thu,  9 Feb 2023 12:08:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229552AbjBILIx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Feb 2023 06:08:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36232 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229623AbjBILIv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Feb 2023 06:08:51 -0500
Received: from relay8-d.mail.gandi.net (relay8-d.mail.gandi.net [217.70.183.201])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC4631207B;
        Thu,  9 Feb 2023 03:08:47 -0800 (PST)
Received: (Authenticated sender: clement.leger@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id E5FD51BF218;
        Thu,  9 Feb 2023 11:08:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1675940926;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=EjPV6q9CtcMZIOnJ1euD00Dni4pwlunZAv2O8QKIdu4=;
        b=e2LJ1YEolCmgZ5fAvjkPlhcQhsw/VEg90JkC2QRPXy82n9VBbbHJnCLioaM2/Nmo/CuICA
        0qrxCbocoHv3ofoRud3Qeh1uXEDk9pZpkfj/Ll33kL49/w0UNbazqVzKY/BVq5RLOay8B1
        DQnePBKprEOr7meZmzRmiLQj62j03WSyFjcs0EEuEx8Z4OK7tdCVJe2l5wg4mCttXCdQWe
        YjZ8LYDt8OYAhaBcCUUHK6hgMwz6XEFe1DmpZG9qx+3bh4Ie+zH7jbHZoogK6ktKJ+9Sc9
        0Dse3azOey0oIvYihWk9C0J1+PBIJC+b+ZAmQHaEyJ+WAy91YtndNxby6tfQsA==
Date:   Thu, 9 Feb 2023 12:11:07 +0100
From:   =?UTF-8?B?Q2zDqW1lbnQgTMOpZ2Vy?= <clement.leger@bootlin.com>
To:     Simon Horman <simon.horman@corigine.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
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
Subject: Re: [PATCH 3/3] net: dsa: rzn1-a5psw: add vlan support
Message-ID: <20230209121107.1ea4128f@fixe.home>
In-Reply-To: <Y+TNDFovmcjy+ctb@corigine.com>
References: <20230208160453.325783-1-clement.leger@bootlin.com>
        <20230208160453.325783-4-clement.leger@bootlin.com>
        <Y+TNDFovmcjy+ctb@corigine.com>
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

Le Thu, 9 Feb 2023 11:38:04 +0100,
Simon Horman <simon.horman@corigine.com> a =C3=A9crit :

> On Wed, Feb 08, 2023 at 05:04:53PM +0100, Cl=C3=A9ment L=C3=A9ger wrote:
> > Add support for vlan operation (add, del, filtering) on the RZN1
> > driver. The a5psw switch supports up to 32 VLAN IDs with filtering,
> > tagged/untagged VLANs and PVID for each ports.
> >=20
> > Signed-off-by: Cl=C3=A9ment L=C3=A9ger <clement.leger@bootlin.com>
> > ---
> >  drivers/net/dsa/rzn1_a5psw.c | 167 +++++++++++++++++++++++++++++++++++
> >  drivers/net/dsa/rzn1_a5psw.h |   8 +-
> >  2 files changed, 172 insertions(+), 3 deletions(-)
> >=20
> > diff --git a/drivers/net/dsa/rzn1_a5psw.c b/drivers/net/dsa/rzn1_a5psw.c
> > index 0ce3948952db..de6b18ec647d 100644
> > --- a/drivers/net/dsa/rzn1_a5psw.c
> > +++ b/drivers/net/dsa/rzn1_a5psw.c
> > @@ -583,6 +583,147 @@ static int a5psw_port_fdb_dump(struct dsa_switch =
*ds, int port,
> >  	return ret;
> >  }
> > =20
> > +static int a5psw_port_vlan_filtering(struct dsa_switch *ds, int port,
> > +				     bool vlan_filtering,
> > +				     struct netlink_ext_ack *extack)
> > +{
> > +	u32 mask =3D BIT(port + A5PSW_VLAN_VERI_SHIFT) |
> > +		   BIT(port + A5PSW_VLAN_DISC_SHIFT);
> > +	struct a5psw *a5psw =3D ds->priv;
> > +	u32 val =3D 0;
> > +
> > +	if (vlan_filtering)
> > +		val =3D BIT(port + A5PSW_VLAN_VERI_SHIFT) |
> > +		      BIT(port + A5PSW_VLAN_DISC_SHIFT); =20
>=20
> nit: could this be expressed as follows?
>=20
> 	val =3D vlan_filtering ? mask : 0 ?

Yes clearly looks more concise.

Thanks,

>=20
> > +
> > +	a5psw_reg_rmw(a5psw, A5PSW_VLAN_VERIFY, mask, val);
> > +
> > +	return 0;
> > +} =20
>=20
> ...



--=20
Cl=C3=A9ment L=C3=A9ger,
Embedded Linux and Kernel engineer at Bootlin
https://bootlin.com
