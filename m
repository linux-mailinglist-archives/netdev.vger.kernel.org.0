Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A02496BB68D
	for <lists+netdev@lfdr.de>; Wed, 15 Mar 2023 15:52:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232783AbjCOOwG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Mar 2023 10:52:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34606 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232725AbjCOOwA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Mar 2023 10:52:00 -0400
Received: from relay7-d.mail.gandi.net (relay7-d.mail.gandi.net [217.70.183.200])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C1C457D1D;
        Wed, 15 Mar 2023 07:51:46 -0700 (PDT)
Received: (Authenticated sender: clement.leger@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id E36BB20017;
        Wed, 15 Mar 2023 14:51:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1678891905;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=fZnT0k4cJKJ12/O+T0hqu1DAsCopKhvIX+KSpp9TDMw=;
        b=WgVyYzIIMVuBl5hSzvQ+tl6Qsdf20HYyNRcUuMzLWbotXVcq319eG3xS4y8eXZJcfBx6tV
        SKYzJ0MTDXB2DIcnXkq4OkS/9QWT96+KeUhN7nfHyETFWIIEnVqYOOQsSDTEDsSGk4cnJS
        UTThI1DIXO0irADLtjIEdLi3vcDYuwTQr1V7EHckQoVnx4b7c7DaZ1D2u8VZuDXGhX9KLR
        3wl92JWh+0ARBqbqoSafw4dQWDITF1pNZWdhv4LuCKLyL4MujFfqW05dvtdHZCpt3QGpjb
        JYKXQBeQYgTEhGAUjLiS76/U+4nXX/Od5oVNpTixAzIoY0LbOArBGJtcUbuC9w==
Date:   Wed, 15 Mar 2023 15:54:30 +0100
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
Subject: Re: [PATCH RESEND net-next v4 3/3] net: dsa: rzn1-a5psw: add vlan
 support
Message-ID: <20230315155430.5873cdb6@fixe.home>
In-Reply-To: <20230314233454.3zcpzhobif475hl2@skbuf>
References: <20230314163651.242259-1-clement.leger@bootlin.com>
        <20230314163651.242259-1-clement.leger@bootlin.com>
        <20230314163651.242259-4-clement.leger@bootlin.com>
        <20230314163651.242259-4-clement.leger@bootlin.com>
        <20230314233454.3zcpzhobif475hl2@skbuf>
Organization: Bootlin
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.36; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Le Wed, 15 Mar 2023 01:34:54 +0200,
Vladimir Oltean <olteanv@gmail.com> a =C3=A9crit :

> On Tue, Mar 14, 2023 at 05:36:51PM +0100, Cl=C3=A9ment L=C3=A9ger wrote:
> > Add support for vlan operation (add, del, filtering) on the RZN1
> > driver. The a5psw switch supports up to 32 VLAN IDs with filtering,
> > tagged/untagged VLANs and PVID for each ports.
> >=20
> > Signed-off-by: Cl=C3=A9ment L=C3=A9ger <clement.leger@bootlin.com>
> > ---
> >  drivers/net/dsa/rzn1_a5psw.c | 164 +++++++++++++++++++++++++++++++++++
> >  drivers/net/dsa/rzn1_a5psw.h |   8 +-
> >  2 files changed, 169 insertions(+), 3 deletions(-)
> >=20
> > diff --git a/drivers/net/dsa/rzn1_a5psw.c b/drivers/net/dsa/rzn1_a5psw.c
> > index 5059b2814cdd..a9a42a8bc7e3 100644
> > --- a/drivers/net/dsa/rzn1_a5psw.c
> > +++ b/drivers/net/dsa/rzn1_a5psw.c
> > @@ -583,6 +583,144 @@ static int a5psw_port_fdb_dump(struct dsa_switch =
*ds, int port,
> >  	return ret;
> >  }
> > =20
> > +static int a5psw_port_vlan_filtering(struct dsa_switch *ds, int port,
> > +				     bool vlan_filtering,
> > +				     struct netlink_ext_ack *extack)
> > +{
> > +	u32 mask =3D BIT(port + A5PSW_VLAN_VERI_SHIFT) |
> > +		   BIT(port + A5PSW_VLAN_DISC_SHIFT); =20
>=20
> I'm curious what the A5PSW_VLAN_VERI_SHIFT and A5PSW_VLAN_DISC_SHIFT
> bits do. Also curious in general what does this hardware do w.r.t.
> VLANs. There would be several things on the checklist:
>=20
> - can it drop a VLAN which isn't present in the port membership list?
>   I guess this is what A5PSW_VLAN_DISC_SHIFT does.

Yes, A5PSW_VLAN_DISC_SHIFT stands for "discard" which means the packet
is discarded if the port is not a member of the VLAN.
A5PSW_VLAN_VERI_SHIFT is meant to enable VLAN lookup for packet
flooding (instead of the default lookup).

>=20
> - can it use VLAN information from the packet (with a fallback on the
>   port PVID) to determine where to send, and where *not* to send the
>   packet? How does this relate to the flooding registers? Is the flood
>   mask restricted by the VLAN mask? Is there a default VLAN installed in
>   the hardware tables, which is also the PVID of all ports, and all
>   ports are members of it? Could you implement standalone/bridged port
>   forwarding isolation based on VLANs, rather than the flimsy and most
>   likely buggy implementation done based on flooding domains, from this
>   patch set?

Yes, the VLAN membership is used for packet flooding. The flooding
registers are used when the packets come has a src MAC that is not in
the FDB. For more infiormation, see section 4.5.3.9, paragraph 3.c
which describe the whole lookup process.

Regarding your other question, by default, there is no default VLAN
installed but indeed, I see what you mean, a default VLAN could be used
to isolate each ports rather than setting the rule to forward only to
root CPU port + disabling of flooding. I guess a unique VLAN ID per port
should be used to isolate each of them and added to the root port to
untag the input frames tagged with the PVID ?

>=20
> - is the FDB looked up per {MAC DA, VLAN ID} or just MAC DA? Looking at
>   a5psw_port_fdb_add(), there's absolutely no sign of "vid" being used,
>   so I guess it's Shared VLAN Learning. In that case, there's absolutely
>   no hope to implement ds->fdb_isolation for this hardware. But at the
>   *very* least, please disable address learning on standalone ports,
>   *and* implement ds->ops->port_fast_age() so that ports quickly forget
>   their learned MAC adddresses after leaving a bridge and become
>   standalone again.

Indeed, the lookup table does not contain the VLAN ID and thus it is
unused. We talked about it in a previous review and you already
mentionned that there is no hope to implement fdb_isolation. Ok for
disabling learning on standalone ports, and indeed, by default, it's
enabled. Regarding ds->ops->port_fast_age(), it is already implemented.

>=20
> - if the port PVID is indeed used to filter the flooding mask of
>   untagged packets, then I speculate that when A5PSW_VLAN_VERI_SHIFT
>   is set, the hardware searches for a VLAN tag in the packet, whereas if
>   it's unset, all packets will be forwarded according just to the port
>   PVID (A5PSW_SYSTEM_TAGINFO). That would be absolutely magnificent if
>   true, but it also means that you need to be *a lot* more careful when
>   programming this register. See the "Address databases" section from
>   Documentation/networking/dsa/dsa.rst for an explanation of the
>   asynchronous nature of .port_vlan_add() relative to .port_vlan_filterin=
g().
>   Also see the call paths of sja1105_commit_pvid() and mv88e6xxx_port_com=
mit_pvid()
>   for an example of how this should be managed correctly, and how the
>   bridge PVID should be committed to hardware only when the port is
>   currently VLAN-aware.

The port PVID itself is not used to filter the flooding mask. But each
time a PVID is set, the port must also be programmed as a membership of
the PVID VLAN ID in the VLAN resolution table. So actually, the PVID is
just here to tag (or not) the input packet, it does not take a role in
packet forwading. This is entirely done by the VLAN resolution table
content (VLAN_RES_TABLE register). Does this means I don't have to be
extra careful when programming it ?

>=20
> > +	u32 val =3D vlan_filtering ? mask : 0;
> > +	struct a5psw *a5psw =3D ds->priv;
> > +
> > +	a5psw_reg_rmw(a5psw, A5PSW_VLAN_VERIFY, mask, val);
> > +
> > +	return 0;
> > +}
> > +
> > +static int a5psw_port_vlan_del(struct dsa_switch *ds, int port,
> > +			       const struct switchdev_obj_port_vlan *vlan)
> > +{
> > +	struct a5psw *a5psw =3D ds->priv;
> > +	u16 vid =3D vlan->vid;
> > +	int vlan_res_id;
> > +
> > +	dev_dbg(a5psw->dev, "Removing VLAN %d on port %d\n", vid, port);
> > +
> > +	vlan_res_id =3D a5psw_find_vlan_entry(a5psw, vid);
> > +	if (vlan_res_id < 0)
> > +		return -EINVAL;
> > +
> > +	a5psw_port_vlan_cfg(a5psw, vlan_res_id, port, false);
> > +	a5psw_port_vlan_tagged_cfg(a5psw, vlan_res_id, port, false);
> > +
> > +	/* Disable PVID if the vid is matching the port one */ =20
>=20
> What does it mean to disable PVID?

It means it disable the input tagging of packets with this PVID.
Incoming packets will not be modified and passed as-is.

>=20
> > +	if (vid =3D=3D a5psw_reg_readl(a5psw, A5PSW_SYSTEM_TAGINFO(port)))
> > +		a5psw_reg_rmw(a5psw, A5PSW_VLAN_IN_MODE_ENA, BIT(port), 0);
> > +
> > +	return 0;
> > +}
> > +
> >  static u64 a5psw_read_stat(struct a5psw *a5psw, u32 offset, int port)
> >  {
> >  	u32 reg_lo, reg_hi;
> > @@ -700,6 +838,27 @@ static void a5psw_get_eth_ctrl_stats(struct dsa_sw=
itch *ds, int port,
> >  	ctrl_stats->MACControlFramesReceived =3D stat;
> >  }
> > =20
> > +static void a5psw_vlan_setup(struct a5psw *a5psw, int port)
> > +{
> > +	u32 reg;
> > +
> > +	/* Enable TAG always mode for the port, this is actually controlled
> > +	 * by VLAN_IN_MODE_ENA field which will be used for PVID insertion
> > +	 */ =20
>=20
> What does the "tag always" mode do, and what are the alternatives?

The name of the mode is probably missleading. When setting VLAN_IN_MODE
with A5PSW_VLAN_IN_MODE_TAG_ALWAYS, the input packet will be tagged
_only_ if VLAN_IN_MODE_ENA port bit is set. If this bit is not set for
the port, packet will passthrough transparently. This bit is actually
enabled in a5psw_port_vlan_add() when a PVID is set and unset when the
PVID is removed. Maybe the comment above these lines was not clear
enough.

There are actually 3 modes (excerpt of the documentation):

0) Single Tagging with Passthrough/VID Overwrite:
Insert tag if untagged frame. Leave frame unmodified if tagged and VID
> 0. If tagged with VID =3D 0 (priority tagged), then the VID will be
overwritten with the VID from SYSTEM_TAGINFO and priority is kept.

1) Single Tagging with Replace:
If untagged, add the tag, if single tagged, overwrite the tag.

2) Tag always:
Insert a tag always. This results in a single tagged frame when an
untagged is received, and a double tagged frame, when a single tagged
frame is received (or triple tagged if double-tagged received etc.).

This mode is then enforced (or not) using VLAN_IN_MODE. Input
manipulation can be enabled per port with register VLAN_IN_MODE_ENA and
its port individual mode is configured in register VLAN_IN_MODE.
Moreover, the tag that will be inserted is stored in the
SYSTEM_TAGINFO[port] register.
>=20
> > +	reg =3D A5PSW_VLAN_IN_MODE_TAG_ALWAYS;
> > +	reg <<=3D A5PSW_VLAN_IN_MODE_PORT_SHIFT(port);
> > +	a5psw_reg_rmw(a5psw, A5PSW_VLAN_IN_MODE,
> > A5PSW_VLAN_IN_MODE_PORT(port),
> > +		      reg);
> > +
> > +	/* Set transparent mode for output frame manipulation,
> > this will depend
> > +	 * on the VLAN_RES configuration mode
> > +	 */ =20
>=20
> What does the "transparent" output mode do, and how does it compare to
> the "dis", "strip" and "tag through" alternatives?

Here is a description of the 4 modes (excerpt of the documentation):

0) Disabled:
No frame manipulation occurs, frame is output as-is.

1) Strip mode:
All the tags (single or double) are removed from frame before sending
it.

2) Tag through mode:
Always removes first tag from frame only. In Tag Through mode, the
inner Tag is passed through while the outer Tag is removed for a double
Tagged frame. The following rules apply:
  =E2=97=8F When a single tagged frame is received, strip the tag from the
   frame.
  =E2=97=8F When a double tagged frame is received, strip the outer tag fro=
m the
    frame

3) VLAN domain mode / transparent mode:
The first tag of a frame is removed (same as Mode 2) when the VLAN is
defined as untagged for the port. The following rules apply:
  =E2=97=8F If frame=E2=80=99s VLAN id is found in the VLAN table (see Sect=
ion
    4.5.3.9(3)(b), VLAN Domain Resolution / VLAN Table) and the port is
    defined (in the table) as tagged for the VLAN, the frame is not
    modified.
  =E2=97=8F If frame=E2=80=99s VLAN id is found in the VLAN table and the p=
ort is
    defined as untagged for the VLAN, the first VLAN tag is removed from
    the frame.
  =E2=97=8F If frame=E2=80=99s VLAN id is not found in the VLAN table, the =
frame is not
    modified.

This last mode allows for a fine grain control oveer tagged/untagged
VLAN since each VLAN setup is in the VLAN table.

>=20
> > +	reg =3D A5PSW_VLAN_OUT_MODE_TRANSPARENT;
> > +	reg <<=3D A5PSW_VLAN_OUT_MODE_PORT_SHIFT(port);
> > +	a5psw_reg_rmw(a5psw, A5PSW_VLAN_OUT_MODE,
> > +		      A5PSW_VLAN_OUT_MODE_PORT(port), reg);
> > +} =20
>=20
> Sorry for asking all these questions, but VLAN configuration on a switch
> such as to bring it in line with the bridge driver expectations is a
> rather tricky thing, so I'd like to have as clear of a mental model of
> this hardware as possible, if public documentation isn't available.

No worries, that's your "job" to make sure drivers are in line with
what is expected in DSA. The documentation is public and available at
[1]. Section 4.5.3 is of interest for your understanding of the VLAN
filtering support. Let's hope I answered most of your questions.


[1]
https://www.renesas.com/us/en/document/mah/rzn1d-group-rzn1s-group-rzn1l-gr=
oup-users-manual-r-engine-and-ethernet-peripherals?r=3D1054561

--=20
Cl=C3=A9ment L=C3=A9ger,
Embedded Linux and Kernel engineer at Bootlin
https://bootlin.com
