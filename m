Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7482F690AD1
	for <lists+netdev@lfdr.de>; Thu,  9 Feb 2023 14:47:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230039AbjBINru (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Feb 2023 08:47:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49634 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229942AbjBINrt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Feb 2023 08:47:49 -0500
Received: from relay11.mail.gandi.net (relay11.mail.gandi.net [IPv6:2001:4b98:dc4:8::231])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4823B59545;
        Thu,  9 Feb 2023 05:47:47 -0800 (PST)
Received: (Authenticated sender: clement.leger@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id 0994B100003;
        Thu,  9 Feb 2023 13:47:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1675950465;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=A8RHB96FOxhxQqrq2UsYHiREFidPbx/nPkr7Cq/prjw=;
        b=RbIOZ9nIKUqyRy+Qc7sDbwwL3bAW72xgJ2vH0r17QUvDw6aZL/TDd0unyET75cQTakwXxb
        S/NxTVCX6fWYa65I31xbBDG4ZqdvRi/l5MHo/Ydf6RGELpQzkKGKy2F9tkI30fexBqDpHB
        NbAxgNsXSN986IscYWoN4TLz2mpstmVZX4nceFVhlty9VWBMEgy5zxjt/gPgXkJlhzuOCA
        dK5ZYY9UfUMB8mXi/lr9VSUEvvx1SAMq8FIWI6DwcB1fOvvithmMsj1+/DYh8nb7/ZyJQ9
        hsEimK3ub2ex3ILd/997xx9TN2iRdt8fnFo6or/S7fgJeVQxeNYCh6NXvdstRQ==
Date:   Thu, 9 Feb 2023 14:50:06 +0100
From:   =?UTF-8?B?Q2zDqW1lbnQgTMOpZ2Vy?= <clement.leger@bootlin.com>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>, Vladimir Oltean <olteanv@gmail.com>,
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
Subject: Re: [PATCH net-next v3 3/3] net: dsa: rzn1-a5psw: add vlan support
Message-ID: <20230209145006.2b42f5a3@fixe.home>
In-Reply-To: <317ec9fc-87de-2683-dfd4-30fe94e2efd7@gmail.com>
References: <20230208161749.331965-1-clement.leger@bootlin.com>
        <20230208161749.331965-4-clement.leger@bootlin.com>
        <317ec9fc-87de-2683-dfd4-30fe94e2efd7@gmail.com>
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

Le Wed, 8 Feb 2023 09:38:04 -0800,
Florian Fainelli <f.fainelli@gmail.com> a =C3=A9crit :

> > +static void a5psw_vlan_setup(struct a5psw *a5psw, int port)
> > +{
> > +	u32 reg;
> > +
> > +	/* Enable TAG always mode for the port, this is actually controlled
> > +	 * by VLAN_IN_MODE_ENA field which will be used for PVID insertion
> > +	 */
> > +	reg =3D A5PSW_VLAN_IN_MODE_TAG_ALWAYS;
> > +	reg <<=3D A5PSW_VLAN_IN_MODE_PORT_SHIFT(port);
> > +	a5psw_reg_rmw(a5psw, A5PSW_VLAN_IN_MODE, A5PSW_VLAN_IN_MODE_PORT(port=
),
> > +		      reg); =20
>=20
> If we always enable VLAN mode, which VLAN ID do switch ports not part of=
=20
> a VLAN aware bridge get classified into?

As answered on Vladimir question, it is VLAN_IN_MODE_ENAnot always VLAN ena=
bled as
stated by the comment above but only if VLAN_IN_MODE_ENA is set (which
is done when setting a PVID only).

>=20
> > +
> > +	/* Set transparent mode for output frame manipulation, this will depe=
nd
> > +	 * on the VLAN_RES configuration mode
> > +	 */
> > +	reg =3D A5PSW_VLAN_OUT_MODE_TRANSPARENT;
> > +	reg <<=3D A5PSW_VLAN_OUT_MODE_PORT_SHIFT(port);
> > +	a5psw_reg_rmw(a5psw, A5PSW_VLAN_OUT_MODE,
> > +		      A5PSW_VLAN_OUT_MODE_PORT(port), reg); =20
>=20
> Sort of a follow-on to the previous question, what does transparent=20
> mean? Does that mean the frames ingressing with a certain VLAN tag will=20
> egress with the same VLAN tag in the absence of a VLAN configuration=20
> rewriting the tag?

Yes, here is an excerpt of the documentation which should clarified your
question (VLAN Table is actually stored in VLAN_RES registers):

- If frame=E2=80=99s VLAN id is found in the VLAN table (see Section
4.5.3.9(3)(b), VLAN Domain Resolution / VLAN Table) and the port is
defined as tagged for the VLAN, the frame is not modified.

- If frame=E2=80=99s VLAN id is found in the VLAN table and the port is def=
ined
as untagged for the VLAN, the first VLAN tag is removed from the frame.

- If frame=E2=80=99s VLAN id is not found in the VLAN table, the frame is n=
ot
modified.

Thanks,

--=20
Cl=C3=A9ment L=C3=A9ger,
Embedded Linux and Kernel engineer at Bootlin
https://bootlin.com
