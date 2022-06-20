Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 55010551453
	for <lists+netdev@lfdr.de>; Mon, 20 Jun 2022 11:29:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240867AbiFTJ2v (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Jun 2022 05:28:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38046 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240801AbiFTJ2j (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Jun 2022 05:28:39 -0400
Received: from relay3-d.mail.gandi.net (relay3-d.mail.gandi.net [217.70.183.195])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 899D611839;
        Mon, 20 Jun 2022 02:28:37 -0700 (PDT)
Received: (Authenticated sender: miquel.raynal@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id A55D36000E;
        Mon, 20 Jun 2022 09:28:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1655717315;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Ta+QqcmX9Xdpl0TN0UxKNlKGjpmQ7Q0Xo0XUFnZM264=;
        b=On0eqPIftHhXa7fiqe+YehLX1VIaOeL1PykIF7h7T5sS1EGsCXNZxsaNSMbZlRveIWFKqy
        ZvWvIlzDym1HHpYdlntBvZ8+cFnfK5vF0fvS/5pE7XmLwbOcBKssE+i5/0tZjZGDOhjkG8
        MJXQaWZCP7nKf5MZOIuekSojedigFLY6NE1+BUi4PhC2oryf06CRhIxFT+1StMeoej7GFJ
        eU3abOXknfTh3/WxWxrl8NuB4sIqGR4qdHCJssPBakUObBUJMaVSUeIp0Jak8pn2Bnfdd8
        yxRnfbP/XzXJRTxkeC371rq56PBmgt4YGKbK7qicTkcATZIHOBrWOq06EORoiQ==
Date:   Mon, 20 Jun 2022 11:28:34 +0200
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
Subject: Re: [PATCH wpan-next v2 2/6] net: ieee802154: Ensure only FFDs can
 become PAN coordinators
Message-ID: <20220620112834.7e8721a0@xps-13>
In-Reply-To: <CAK-6q+iJaZvtxXsFTPsYyWsDYmKhgVsMHKcDUCrCqmUR2YpEjg@mail.gmail.com>
References: <20220617193254.1275912-1-miquel.raynal@bootlin.com>
        <20220617193254.1275912-3-miquel.raynal@bootlin.com>
        <CAK-6q+iJaZvtxXsFTPsYyWsDYmKhgVsMHKcDUCrCqmUR2YpEjg@mail.gmail.com>
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

Hi Alex,

aahringo@redhat.com wrote on Sun, 19 Jun 2022 20:24:48 -0400:

> Hi,
>=20
> On Fri, Jun 17, 2022 at 3:35 PM Miquel Raynal <miquel.raynal@bootlin.com>=
 wrote:
> >
> > This is a limitation clearly listed in the specification. Now that we
> > have device types,let's ensure that only FFDs can become PAN
> > coordinators.
> >
> > Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
> > ---
> >  net/ieee802154/nl802154.c | 3 +++
> >  1 file changed, 3 insertions(+)
> >
> > diff --git a/net/ieee802154/nl802154.c b/net/ieee802154/nl802154.c
> > index 638bf544f102..0c6fc3385320 100644
> > --- a/net/ieee802154/nl802154.c
> > +++ b/net/ieee802154/nl802154.c
> > @@ -924,6 +924,9 @@ static int nl802154_new_interface(struct sk_buff *s=
kb, struct genl_info *info)
> >                         return -EINVAL;
> >         }
> >
> > +       if (type =3D=3D NL802154_IFTYPE_COORD && !cfg802154_is_ffd(rdev=
))
> > +               return -EINVAL;
> > + =20
>=20
> Look at my other mail regarding why the user needs to set this device
> capability, change the errno to "EOPNOTSUPP"... it would be nice to
> have an identically nl80211 handling like nl80211 to see which
> interfaces are supported. Please look how wireless is doing that and
> probably we should not take the standard about those "wording" too
> seriously. What I mean is that according to FFD or RFD it's implied on
> what interfaces you can create on.

This is true, I don't need this _is_ffd() helper, checking on the type
of interface should be enough. I will drop the DEV(PHY)_TYPE enum
entirely.

Thanks,
Miqu=C3=A8l
