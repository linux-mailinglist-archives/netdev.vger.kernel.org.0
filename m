Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4865A59A477
	for <lists+netdev@lfdr.de>; Fri, 19 Aug 2022 20:05:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352109AbiHSRrj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Aug 2022 13:47:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56736 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354779AbiHSRrJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Aug 2022 13:47:09 -0400
Received: from relay3-d.mail.gandi.net (relay3-d.mail.gandi.net [217.70.183.195])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5294221E33;
        Fri, 19 Aug 2022 10:13:19 -0700 (PDT)
Received: (Authenticated sender: miquel.raynal@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id 09D7860005;
        Fri, 19 Aug 2022 17:13:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1660929198;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=T0IDZfd3PX5WHe7A8+HovyZzvIA0GNB8FthHffX8/4Y=;
        b=JFO/4/qTZaNKDb5LTY79XILEffypsrhffJDV1ydqr7OGq6SCA8ZdTFZNxbWfoj4pRsu17X
        oqZwmWvUi2Dr37ZZ7PyVxV5daVmgb8OX/aP++3o5MydkDlMN2RIFsFQkBVu9LHW/YobPZq
        tmCm9bL9PNB+34bZ2YjQ0vqyFWLl7TZn8VNi/7HsOn1ua+T91OyOi+AwSqZnmEGrZdxlxh
        gLoN0yTNtpsiDrXIAJRdYldWUbzqA5woygO0SnTozJNGGM7jDTUYCUfVVvuhf3s+vgBz3m
        y7GudVljZCyx4h9nA/PYkcO5VKghCurhmNifMe58gvq8rYALEoKy67dabP58nQ==
Date:   Fri, 19 Aug 2022 19:13:15 +0200
From:   Miquel Raynal <miquel.raynal@bootlin.com>
To:     Alexander Aring <aahringo@redhat.com>
Cc:     Alexander Aring <alex.aring@gmail.com>,
        Stefan Schmidt <stefan@datenfreihafen.org>,
        linux-wpan - ML <linux-wpan@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        Network Development <netdev@vger.kernel.org>,
        David Girault <david.girault@qorvo.com>,
        Romuald Despres <romuald.despres@qorvo.com>,
        Frederic Blain <frederic.blain@qorvo.com>,
        Nicolas Schodet <nico@ni.fr.eu.org>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>
Subject: Re: [PATCH wpan-next 17/20] net: ieee802154: Handle limited devices
 with only datagram support
Message-ID: <20220819191315.387ba71b@xps-13>
In-Reply-To: <CAK-6q+ifj5DNrq31qjjyk3OoAsf0+LuBttM5o8Rs8Pt_TA_JMg@mail.gmail.com>
References: <20220701143052.1267509-1-miquel.raynal@bootlin.com>
        <20220701143052.1267509-18-miquel.raynal@bootlin.com>
        <CAK-6q+ifj5DNrq31qjjyk3OoAsf0+LuBttM5o8Rs8Pt_TA_JMg@mail.gmail.com>
Organization: Bootlin
X-Mailer: Claws Mail 4.0.0 (GTK+ 3.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Alexander,

aahringo@redhat.com wrote on Thu, 14 Jul 2022 23:16:33 -0400:

> Hi,
>=20
> On Fri, Jul 1, 2022 at 10:37 AM Miquel Raynal <miquel.raynal@bootlin.com>=
 wrote:
> >
> > Some devices, like HardMAC ones can be a bit limited in the way they
> > handle mac commands. In particular, they might just not support it at
> > all and instead only be able to transmit and receive regular data
> > packets. In this case, they cannot be used for any of the internal
> > management commands that we have introduced so far and must be flagged
> > accordingly.
> >
> > Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
> > ---
> >  include/net/cfg802154.h   | 3 +++
> >  net/ieee802154/nl802154.c | 6 ++++++
> >  2 files changed, 9 insertions(+)
> >
> > diff --git a/include/net/cfg802154.h b/include/net/cfg802154.h
> > index d6ff60d900a9..20ac4df9dc7b 100644
> > --- a/include/net/cfg802154.h
> > +++ b/include/net/cfg802154.h
> > @@ -178,12 +178,15 @@ wpan_phy_cca_cmp(const struct wpan_phy_cca *a, co=
nst struct wpan_phy_cca *b)
> >   *     setting.
> >   * @WPAN_PHY_FLAG_STATE_QUEUE_STOPPED: Indicates that the transmit que=
ue was
> >   *     temporarily stopped.
> > + * @WPAN_PHY_FLAG_DATAGRAMS_ONLY: Indicates that transceiver is only a=
ble to
> > + *     send/receive datagrams.
> >   */
> >  enum wpan_phy_flags {
> >         WPAN_PHY_FLAG_TXPOWER           =3D BIT(1),
> >         WPAN_PHY_FLAG_CCA_ED_LEVEL      =3D BIT(2),
> >         WPAN_PHY_FLAG_CCA_MODE          =3D BIT(3),
> >         WPAN_PHY_FLAG_STATE_QUEUE_STOPPED =3D BIT(4),
> > +       WPAN_PHY_FLAG_DATAGRAMS_ONLY    =3D BIT(5),
> >  };
> >
> >  struct wpan_phy {
> > diff --git a/net/ieee802154/nl802154.c b/net/ieee802154/nl802154.c
> > index 00b03c33e826..b31a0bd36b08 100644
> > --- a/net/ieee802154/nl802154.c
> > +++ b/net/ieee802154/nl802154.c
> > @@ -1404,6 +1404,9 @@ static int nl802154_trigger_scan(struct sk_buff *=
skb, struct genl_info *info)
> >         if (wpan_dev->iftype =3D=3D NL802154_IFTYPE_MONITOR)
> >                 return -EPERM;
> >
> > +       if (wpan_phy->flags & WPAN_PHY_FLAG_DATAGRAMS_ONLY)
> > +               return -EOPNOTSUPP;
> > + =20
>=20
> for doing a scan it's also required to turn the transceiver into
> promiscuous mode, right?
>=20
> There is currently a flag if a driver supports promiscuous mode or
> not... I am not sure if all drivers have support for it. For me it
> looks like a mandatory feature but I am not sure if every driver
> supports it.
> We have a similar situation with acknowledge retransmit handling...
> some transceivers can't handle it and for normal dataframes we have a
> default behaviour that we don't set it. However sometimes it's
> required by the spec, then we can't do anything here.
>=20
> I think we should check on it but we should plan to drop this flag if
> promiscuous mode is supported or not.

Yes, you are right, I should check this flag is set, I will do it at
the creation of the MONITOR interface, which anyway does not make sense
if the device has no filtering support (promiscuous being a very
standard one, but, as you said below, will later be replaced by some
more advanced levels).

> I also think that the
> promiscuous driver_ops should be removed and moved as a parameter for
> start() driver_ops to declare which "receive mode" should be
> enabled... but we can do that in due course.

Agreed.

Thanks,
Miqu=C3=A8l
