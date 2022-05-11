Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E9F78522CD5
	for <lists+netdev@lfdr.de>; Wed, 11 May 2022 09:07:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241812AbiEKHHF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 May 2022 03:07:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39130 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237943AbiEKHHD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 May 2022 03:07:03 -0400
Received: from relay7-d.mail.gandi.net (relay7-d.mail.gandi.net [IPv6:2001:4b98:dc4:8::227])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B2C2239BB5;
        Wed, 11 May 2022 00:07:01 -0700 (PDT)
Received: (Authenticated sender: clement.leger@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id 2AB9A20003;
        Wed, 11 May 2022 07:06:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1652252819;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=6k9oVfxMoWnS5euSo4CM5CYub9UXjY9/qIWVMIQnhb8=;
        b=BTsmMt7ipKcPQ7U0u2hxYHpm1ja/aVvNLTyMpYEmzsnxXTDJYiHFHVkXg9nS80acNtAHEb
        OuYX0Wz1HRzOJaYHx28p9rWiT4aOU84rDEJWehtVvmM2/VhcPTQUWReHf7/M+VQtMEW02a
        TB4dwv0BE1gvEZ5oGwDoGEjPOlR62gmPQcwjFxvPuk3lmqLgMuY45vdtDEFkrOGzBmrGxt
        mylg+hCE5y8FMPZiDBOVbUACnLfaVztPf/dQMjTIxP9s3jWxK7KNrYeld4A2dHd04tX47v
        rl/GI+QEszJL0moZHK50az1guYwryJ7mGHKy5szXLO3hcQ9562LhPlHzULa/+Q==
Date:   Wed, 11 May 2022 09:06:56 +0200
From:   =?UTF-8?B?Q2zDqW1lbnQgTMOpZ2Vy?= <clement.leger@bootlin.com>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzk+dt@kernel.org>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Magnus Damm <magnus.damm@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Herve Codina <herve.codina@bootlin.com>,
        =?UTF-8?B?TWlxdcOobA==?= Raynal <miquel.raynal@bootlin.com>,
        Milan Stevanovic <milan.stevanovic@se.com>,
        Jimmy Lalande <jimmy.lalande@se.com>,
        Pascal Eberhard <pascal.eberhard@se.com>,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH net-next v4 07/12] net: dsa: rzn1-a5psw: add statistics
 support
Message-ID: <20220511090656.4c5af4e1@xps-bootlin>
In-Reply-To: <e31809b6-6f57-111b-3e01-76bfa69f9796@gmail.com>
References: <20220509131900.7840-1-clement.leger@bootlin.com>
        <20220509131900.7840-8-clement.leger@bootlin.com>
        <e31809b6-6f57-111b-3e01-76bfa69f9796@gmail.com>
Organization: Bootlin
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Le Tue, 10 May 2022 09:32:53 -0700,
Florian Fainelli <f.fainelli@gmail.com> a =C3=A9crit :

> On 5/9/22 06:18, Cl=C3=A9ment L=C3=A9ger wrote:
> > Add statistics support to the rzn1-a5psw driver by implementing the
> > following dsa_switch_ops callbacks:
> > - get_sset_count()
> > - get_strings()
> > - get_ethtool_stats()
> > - get_eth_mac_stats()
> > - get_eth_ctrl_stats()
> > - get_rmon_stats()
> >=20
> > Signed-off-by: Cl=C3=A9ment L=C3=A9ger <clement.leger@bootlin.com>
> > ---
> >   drivers/net/dsa/rzn1_a5psw.c | 178
> > +++++++++++++++++++++++++++++++++++ drivers/net/dsa/rzn1_a5psw.h |
> > 46 ++++++++- 2 files changed, 223 insertions(+), 1 deletion(-)
> >=20
> > diff --git a/drivers/net/dsa/rzn1_a5psw.c
> > b/drivers/net/dsa/rzn1_a5psw.c index 1e2fac80f3e0..46ba25672593
> > 100644 --- a/drivers/net/dsa/rzn1_a5psw.c
> > +++ b/drivers/net/dsa/rzn1_a5psw.c
> > @@ -17,6 +17,61 @@
> >  =20
> >   #include "rzn1_a5psw.h"
> >  =20
> > +struct a5psw_stats {
> > +	u16 offset;
> > +	const char name[ETH_GSTRING_LEN];
> > +};
> > +
> > +#define STAT_DESC(_offset, _name) {.offset =3D _offset, .name =3D
> > _name} =20
>=20
> You can build a more compact representation as long as you keep the=20
> offset constant and the name in sync, the attached patch and leverage=20
> the __stringify() macro to construct the name field:
>=20
> -#define STAT_DESC(_offset, _name) {.offset =3D _offset, .name =3D _name}
> +#define STAT_DESC(_offset) {   \
> +       .offset =3D A5PSW_##_offset,      \
> +       .name =3D __stringify(_offset),   \
> +}

Indeed, nice catch ! Thanks for the patch !

>=20
> The attached patch does the conversion if you want to fixup into your=20
> commit.

