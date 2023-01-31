Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AC4F4682B62
	for <lists+netdev@lfdr.de>; Tue, 31 Jan 2023 12:25:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230104AbjAaLZf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 Jan 2023 06:25:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57060 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229693AbjAaLZe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 31 Jan 2023 06:25:34 -0500
Received: from relay7-d.mail.gandi.net (relay7-d.mail.gandi.net [IPv6:2001:4b98:dc4:8::227])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9113B49940;
        Tue, 31 Jan 2023 03:25:32 -0800 (PST)
Received: (Authenticated sender: miquel.raynal@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id 0D98820011;
        Tue, 31 Jan 2023 11:25:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1675164330;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=tAuea4GKGxpxlpyo6uDuczjlm4urx1r7jKAW9TwYw58=;
        b=gVNzG7gXQ0X6Pzs6miC99X48DN/XicLuSE0DYYAaa/+Imvqn70W8KZ4rq3vLAvP/tahg3O
        p4NqIdMTakYZyuWQcoJK/IgpauZCO5069+38mM7Jsizs7iOuOgyceYG6wMWCAXxRNmLfYR
        dkeRd4fBvrpce5Yj2UwkJrfBMKZ2zLy0zj04NhCcPb2O+P6Pv9/FO85cHWi+zmtUv/Ekq8
        wo4JBoHDtg8r3qpIdSZiVlx/aY4Jysd/Q/69j0YtuvT+g+zBsUszyQVrp0WrMbsBABhHru
        /48KeGdIcVeGuvGY0yFhWyPkxB8a+Hz2BfioSwexSxhh6UTWTCCYzA6wQDIong==
Date:   Tue, 31 Jan 2023 12:25:25 +0100
From:   Miquel Raynal <miquel.raynal@bootlin.com>
To:     Alexander Aring <aahringo@redhat.com>
Cc:     Alexander Aring <alex.aring@gmail.com>,
        Stefan Schmidt <stefan@datenfreihafen.org>,
        linux-wpan@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>, netdev@vger.kernel.org,
        David Girault <david.girault@qorvo.com>,
        Romuald Despres <romuald.despres@qorvo.com>,
        Frederic Blain <frederic.blain@qorvo.com>,
        Nicolas Schodet <nico@ni.fr.eu.org>,
        Guilhem Imberton <guilhem.imberton@qorvo.com>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>
Subject: Re: [PATCH wpan-next v2 0/2] ieee802154: Beaconing support
Message-ID: <20230131122525.7bd35c2b@xps-13>
In-Reply-To: <CAK-6q+gqQgFxqBUAhHDMaWv9VfuKa=bCVee_oSLQeVtk_G8=ow@mail.gmail.com>
References: <20230125102923.135465-1-miquel.raynal@bootlin.com>
        <CAK-6q+jN1bnP1FdneGrfDJuw3r3b=depEdEP49g_t3PKQ-F=Lw@mail.gmail.com>
        <CAK-6q+hoquVswZTm+juLasQzUJpGdO+aQ7Q3PCRRwYagge5dTw@mail.gmail.com>
        <20230130105508.38a25780@xps-13>
        <CAK-6q+gqQgFxqBUAhHDMaWv9VfuKa=bCVee_oSLQeVtk_G8=ow@mail.gmail.com>
Organization: Bootlin
X-Mailer: Claws Mail 4.0.0 (GTK+ 3.24.33; x86_64-pc-linux-gnu)
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

Hi Alexander,

> > > > > Changes in v2:
> > > > > * Clearly state in the commit log llsec is not supported yet.
> > > > > * Do not use mlme transmission helpers because we don't really ne=
ed to
> > > > >   stop the queue when sending a beacon, as we don't expect any fe=
edback
> > > > >   from the PHY nor from the peers. However, we don't want to go t=
hrough
> > > > >   the whole net stack either, so we bypass it calling the subif h=
elper
> > > > >   directly.
> > > > > =20
> > >
> > > moment, we use the mlme helpers to stop tx =20
> >
> > No, we no longer use the mlme helpers to stop tx when sending beacons
> > (but true MLME transmissions, we ack handling and return codes will be
> > used for other purposes).
> > =20
>=20
> then we run into an issue overwriting the framebuffer while the normal
> transmit path is active?

Crap, yes you're right. That's not gonna work.

The net core acquires HARD_TX_LOCK() to avoid these issues and we are
no bypassing the net core without taking care of the proper frame
transmissions either (which would have worked with mlme_tx_one()). So I
guess there are two options:

* Either we deal with the extra penalty of stopping the queue and
  waiting for the beacon to be transmitted with an mlme_tx_one() call,
  as proposed initially.

* Or we hardcode our own "net" transmit helper, something like:

mac802154_fast_mlme_tx() {
	struct net_device *dev =3D skb->dev;
	struct netdev_queue *txq;

	txq =3D netdev_core_pick_tx(dev, skb, NULL);
	cpu =3D smp_processor_id();
	HARD_TX_LOCK(dev, txq, cpu);
	if (!netif_xmit_frozen_or_drv_stopped(txq))
		netdev_start_xmit(skb, dev, txq, 0);
	HARD_TX_UNLOCK(dev, txq);
}

Note1: this is very close to generic_xdp_tx() which tries to achieve the
same goal: sending packets, bypassing qdisc et al. I don't know whether
it makes sense to define it under mac802154/tx.c or core/dev.c and give
it another name, like generic_tx() or whatever would be more
appropriate. Or even adapting generic_xdp_tx() to make it look more
generic and use that function instead (without the xdp struct pointer).

Note2: I am wondering if it makes sense to disable bh here as well?

Once we settle, I send a patch.

Thanks,
Miqu=C3=A8l
