Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 96346396C55
	for <lists+netdev@lfdr.de>; Tue,  1 Jun 2021 06:30:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231375AbhFAEbp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Jun 2021 00:31:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:49960 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229460AbhFAEbn (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 1 Jun 2021 00:31:43 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D50B061364;
        Tue,  1 Jun 2021 04:30:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1622521802;
        bh=cf7uT1qIsUt6MtE6dAECA9+37OawbN0iLEE3uGrkYio=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=dcrZFxlzAzfa1YZNYqmRsoKbzaBsd6rXk89p2L17B2cwredQLcAOkjLKavSxbJtP1
         Sr0NYjHfHrfNuKJ2NtPmjLiCzpqLC1/61LjR2BSd4Bf9QBj+6JnSPjGHbKpvJzV0Pw
         iKnq7REiXcj6lsTqJH/zRHWu/TreA+WZfgDYNpKG9tuVe3cKlCkSdtzqMdUd1+4wwc
         cLnBuuA34UMnUnwuZbRvR+6/6lqdtDVLDb5k1VGep5nlLiAxu9z2M2GfLSULFqbcD3
         anjGt5dsoWrIdCa21oYqjeolWA+wUigebe2PMzxv+Jv4buaRdtsy7VmP5wAomlUhK+
         0xtdtBDl3E2uQ==
Date:   Mon, 31 May 2021 21:30:00 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Steen Hegelund <steen.hegelund@microchip.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Andrew Lunn <andrew@lunn.ch>,
        Russell King <linux@armlinux.org.uk>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Madalin Bucur <madalin.bucur@oss.nxp.com>,
        Mark Einon <mark.einon@gmail.com>,
        Masahiro Yamada <masahiroy@kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        "Simon Horman" <simon.horman@netronome.com>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        Bjarni Jonasson <bjarni.jonasson@microchip.com>,
        Lars Povlsen <lars.povlsen@microchip.com>
Subject: Re: [PATCH net-next v2 03/10] net: sparx5: add hostmode with
 phylink support
Message-ID: <20210531213000.46143fad@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <5719f0fad28e453e0398048ebcfbc421b85a9647.camel@microchip.com>
References: <20210528123419.1142290-1-steen.hegelund@microchip.com>
        <20210528123419.1142290-4-steen.hegelund@microchip.com>
        <20210530141502.561920a7@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
        <5719f0fad28e453e0398048ebcfbc421b85a9647.camel@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 31 May 2021 16:02:54 +0200 Steen Hegelund wrote:
> > > +=C2=A0=C2=A0=C2=A0=C2=A0 val =3D ether_addr_to_u64(sparx5->base_mac)=
 + portno + 1;
> > > +=C2=A0=C2=A0=C2=A0=C2=A0 u64_to_ether_addr(val, ndev->dev_addr);
> > > +
> > > +=C2=A0=C2=A0=C2=A0=C2=A0 return ndev;
> > > +} =20
> >  =20
> > > +static void sparx5_xtr_grp(struct sparx5 *sparx5, u8 grp, bool byte_=
swap)
> > > +{
> > > +=C2=A0=C2=A0=C2=A0=C2=A0 bool eof_flag =3D false, pruned_flag =3D fa=
lse, abort_flag =3D false;
> > > +=C2=A0=C2=A0=C2=A0=C2=A0 struct net_device *netdev;
> > > +=C2=A0=C2=A0=C2=A0=C2=A0 struct sparx5_port *port;
> > > +=C2=A0=C2=A0=C2=A0=C2=A0 struct frame_info fi;
> > > +=C2=A0=C2=A0=C2=A0=C2=A0 int i, byte_cnt =3D 0;
> > > +=C2=A0=C2=A0=C2=A0=C2=A0 struct sk_buff *skb;
> > > +=C2=A0=C2=A0=C2=A0=C2=A0 u32 ifh[IFH_LEN];
> > > +=C2=A0=C2=A0=C2=A0=C2=A0 u32 *rxbuf;
> > > +
> > > +=C2=A0=C2=A0=C2=A0=C2=A0 /* Get IFH */
> > > +=C2=A0=C2=A0=C2=A0=C2=A0 for (i =3D 0; i < IFH_LEN; i++)
> > > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0 ifh[i] =3D spx5_rd(sparx5, QS_XTR_RD(grp));
> > > +
> > > +=C2=A0=C2=A0=C2=A0=C2=A0 /* Decode IFH (whats needed) */
> > > +=C2=A0=C2=A0=C2=A0=C2=A0 sparx5_ifh_parse(ifh, &fi);
> > > +
> > > +=C2=A0=C2=A0=C2=A0=C2=A0 /* Map to port netdev */
> > > +=C2=A0=C2=A0=C2=A0=C2=A0 port =3D fi.src_port < SPX5_PORTS ?
> > > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0 sparx5->ports[fi.src_port] : NULL;
> > > +=C2=A0=C2=A0=C2=A0=C2=A0 if (!port || !port->ndev) {
> > > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0 dev_err(sparx5->dev, "Data on inactive port %d\n", fi.src_port);
> > > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0 sparx5_xtr_flush(sparx5, grp);
> > > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0 return; =20
> >=20
> > You should probably increment appropriate counter for each error
> > condition. =20
>=20
> At this first check I do not have the netdev, so it will not be
> possible to update any counters, but below I can use rx_dropped. =20
> Is that what you mean?

Yes, sorry, I just scrolled up to the earliest drop I could find.
Indeed nothing we can increment here.=20

> > > +
> > > +=C2=A0=C2=A0=C2=A0=C2=A0 /* Finish up skb */
> > > +=C2=A0=C2=A0=C2=A0=C2=A0 skb_put(skb, byte_cnt - ETH_FCS_LEN);
> > > +=C2=A0=C2=A0=C2=A0=C2=A0 eth_skb_pad(skb);
> > > +=C2=A0=C2=A0=C2=A0=C2=A0 skb->protocol =3D eth_type_trans(skb, netde=
v);
> > > +=C2=A0=C2=A0=C2=A0=C2=A0 netif_rx(skb);
> > > +=C2=A0=C2=A0=C2=A0=C2=A0 netdev->stats.rx_bytes +=3D skb->len;
> > > +=C2=A0=C2=A0=C2=A0=C2=A0 netdev->stats.rx_packets++; =20
> >=20
> > Does the Rx really need to happen in an interrupt context?
> > Did you consider using NAPI or a tasklet? =20
>=20
> This register base injection and extraction is just preliminary.  I
> have the next series waiting with support for Frame DMA'ing and there
> I use NAPI, so if possible I would like to leave this as it is, since
> it only a stopgap.

Ah, that's fine.

> > What do you expect to happen at this point? Kernel can retry sending
> > for ever, is there a way for the driver to find out that the fifo is
> > no longer busy to stop/start the software queuing appropriately? =20
>=20
> Hmm.  I am not too familiar with the netdev queuing, but would this
> be a way forward?
>=20
> 1) In sparx5_inject: After injecting a frame then test for HW queue
> readiness and watermark levels, and if there is a problem then call
> netif_queue_stop
>=20
> 2) Add an implementation of ndo_tx_timeout where the HW queue and
> Watermark level is checked and if all is OK, then do a
> netif_wake_queue.

timeout is not a good mechanism because it will print a stack trace and
an error to logs. timeout is used for detecting broken interfaced.
Perhaps use a hrtimer or a normal timer? What kind of time scales are
we talking here?

> 3) But if the HW queue and/or Watermark level is still not OK - then
> probably something went seriously wrong, or the wait was to short.
> Will the ndo_tx_timeout be called again or is this a one-off?
>=20
> If the ndo_tx_timeout call is a one-off the driver would need to
> reset the HW queue system or even deeper down...
