Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 017A066B93D
	for <lists+netdev@lfdr.de>; Mon, 16 Jan 2023 09:45:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232069AbjAPIp4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Jan 2023 03:45:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55104 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231996AbjAPIpy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Jan 2023 03:45:54 -0500
Received: from relay11.mail.gandi.net (relay11.mail.gandi.net [IPv6:2001:4b98:dc4:8::231])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 87ADB1206D;
        Mon, 16 Jan 2023 00:45:51 -0800 (PST)
Received: (Authenticated sender: clement.leger@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id E682C100002;
        Mon, 16 Jan 2023 08:45:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1673858749;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=n/b403PRq8EYGPXwjQ32wy0AeZyf2Q6Ii5wKNkPIYQs=;
        b=PWlMcI1wVuALAcPFRY/9LfptlImGujZpLQaWGHOGuocEpoLSlZfDNIW9OEuA5O7ui7v7v5
        gFQUTshslMyQdyHmnM1bNTju8GYm8R5hRI4RWaHgS8NPQsFhCl3TeoEN0m6xz5NwP1YFCP
        b8hwqtUk6J29k/1JoQVyKwpvCDpY++k0wCsJ7XY42CmxbUG0kg0xCeGltMpfxS+9Je1fzB
        gki9k3EofdqyGxnOIxaFXzL+0H0Ualk9fmTvdWPV2eVTpBopIY+HxxafTPO8DZ3BvY8nd3
        UUKp8d1Rsh6j9o3/mZs3BVvxtXQxZ75a4ZFEam+k+ZPr5dJ6M+o6WcNQnKs7yg==
Date:   Mon, 16 Jan 2023 09:48:01 +0100
From:   =?UTF-8?B?Q2zDqW1lbnQgTMOpZ2Vy?= <clement.leger@bootlin.com>
To:     <Arun.Ramadoss@microchip.com>
Cc:     <olteanv@gmail.com>, <andrew@lunn.ch>, <linux@armlinux.org.uk>,
        <f.fainelli@gmail.com>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <edumazet@google.com>, <davem@davemloft.net>,
        <miquel.raynal@bootlin.com>, <linux-kernel@vger.kernel.org>,
        <linux-renesas-soc@vger.kernel.org>, <jimmy.lalande@se.com>,
        <herve.codina@bootlin.com>, <milan.stevanovic@se.com>,
        <thomas.petazzoni@bootlin.com>, <pascal.eberhard@se.com>,
        <netdev@vger.kernel.org>
Subject: Re: [PATCH net-next] net: dsa: rzn1-a5psw: Add vlan support
Message-ID: <20230116094801.348018de@fixe.home>
In-Reply-To: <be08c48a21623f1ad8165023ebe986138e44be74.camel@microchip.com>
References: <20230111115607.1146502-1-clement.leger@bootlin.com>
        <be08c48a21623f1ad8165023ebe986138e44be74.camel@microchip.com>
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

Le Fri, 13 Jan 2023 14:40:26 +0000,
<Arun.Ramadoss@microchip.com> a =C3=A9crit :

> Hi Clement,
> On Wed, 2023-01-11 at 12:56 +0100, Cl=C3=A9ment L=C3=A9ger wrote:
> > Add support for vlan operation (add, del, filtering) on the RZN1
> > driver. The a5psw switch supports up to 32 VLAN IDs with filtering,
> > tagged/untagged VLANs and PVID for each ports.
> >=20
> > Signed-off-by: Cl=C3=A9ment L=C3=A9ger <clement.leger@bootlin.com>
> > ---
> >  drivers/net/dsa/rzn1_a5psw.c | 182
> > +++++++++++++++++++++++++++++++++++
> >  drivers/net/dsa/rzn1_a5psw.h |  10 +-
> >  2 files changed, 189 insertions(+), 3 deletions(-)
> >=20
> > diff --git a/drivers/net/dsa/rzn1_a5psw.c
> > b/drivers/net/dsa/rzn1_a5psw.c
> > index ed413d555bec..8ecb9214b5e6 100644
> > --- a/drivers/net/dsa/rzn1_a5psw.c
> > +++ b/drivers/net/dsa/rzn1_a5psw.c
> > @@ -540,6 +540,161 @@ static int a5psw_port_fdb_dump(struct
> > dsa_switch *ds, int port,
> >  	return ret;
> >  }
> > =20
> > +static int a5psw_port_vlan_filtering(struct dsa_switch *ds, int
> > port,
> > +				     bool vlan_filtering,
> > +				     struct netlink_ext_ack *extack)
> > +{
> > +	u32 mask =3D BIT(port + A5PSW_VLAN_VERI_SHIFT)
> > +		   | BIT(port + A5PSW_VLAN_DISC_SHIFT); =20
>=20
> Operator | at the end of line
>=20
> > +	struct a5psw *a5psw =3D ds->priv;
> > +	u32 val =3D 0;
> > +
> > +	if (vlan_filtering)
> > +		val =3D BIT(port + A5PSW_VLAN_VERI_SHIFT)
> > +		      | BIT(port + A5PSW_VLAN_DISC_SHIFT); =20
>=20
> Operator | at the end of line

Hi Arun,

I'll fix that.

>=20
> > +
> > +	a5psw_reg_rmw(a5psw, A5PSW_VLAN_VERIFY, mask, val);
> > +
> > +	return 0;
> > +}
> > +
> > +static int a5psw_port_vlan_add(struct dsa_switch *ds, int port,
> > +			       const struct switchdev_obj_port_vlan
> > *vlan,
> > +			       struct netlink_ext_ack *extack)
> > +{
> > +	bool tagged =3D !(vlan->flags & BRIDGE_VLAN_INFO_UNTAGGED);
> > +	bool pvid =3D vlan->flags & BRIDGE_VLAN_INFO_PVID;
> > +	struct a5psw *a5psw =3D ds->priv;
> > +	u16 vid =3D vlan->vid;
> > +	int ret =3D -EINVAL;
> > +	int vlan_res_id;
> > +
> > +	dev_dbg(a5psw->dev, "Add VLAN %d on port %d, %s, %s\n",
> > +		vid, port, tagged ? "tagged" : "untagged",
> > +		pvid ? "PVID" : "no PVID");
> > +
> > +	mutex_lock(&a5psw->vlan_lock);
> > +
> > +	vlan_res_id =3D a5psw_find_vlan_entry(a5psw, vid);
> > +	if (vlan_res_id < 0) {
> > +		vlan_res_id =3D a5psw_get_vlan_res_entry(a5psw, vid);
> > +		if (vlan_res_id < 0) =20
>=20
> nit: We can initialize ret =3D 0 initially, and assign ret =3D -EINVAL he=
re
> & remove ret =3D 0 at end of function.
>=20
> > +			goto out;
> > +	}
> > +
> > +	a5psw_port_vlan_cfg(a5psw, vlan_res_id, port, true);
> > +	if (tagged)
> > +		a5psw_port_vlan_tagged_cfg(a5psw, vlan_res_id, port,
> > true);
> > +
> > +	if (pvid) {
> > +		a5psw_reg_rmw(a5psw, A5PSW_VLAN_IN_MODE_ENA, BIT(port),
> > +			      BIT(port));
> > +		a5psw_reg_writel(a5psw, A5PSW_SYSTEM_TAGINFO(port),
> > vid);
> > +	}
> > +
> > +	ret =3D 0;
> > +out:
> > +	mutex_unlock(&a5psw->vlan_lock);
> > +
> > +	return ret;
> > +}
> > +
> > +static int a5psw_port_vlan_del(struct dsa_switch *ds, int port,
> > +			       const struct switchdev_obj_port_vlan
> > *vlan)
> > +{
> > +	struct a5psw *a5psw =3D ds->priv;
> > +	u16 vid =3D vlan->vid;
> > +	int ret =3D -EINVAL; =20
>=20
> Simillarly here.

Since I removed the mutex thanks to the previous comments, I have
removed all the "ret" usage.

Thanks,

--=20
Cl=C3=A9ment L=C3=A9ger,
Embedded Linux and Kernel engineer at Bootlin
https://bootlin.com
