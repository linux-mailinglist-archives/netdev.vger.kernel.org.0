Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 741BD65C461
	for <lists+netdev@lfdr.de>; Tue,  3 Jan 2023 17:58:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238240AbjACQ6n (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Jan 2023 11:58:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40104 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230373AbjACQ6i (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Jan 2023 11:58:38 -0500
Received: from relay6-d.mail.gandi.net (relay6-d.mail.gandi.net [217.70.183.198])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 58E3DB30;
        Tue,  3 Jan 2023 08:58:37 -0800 (PST)
Received: (Authenticated sender: miquel.raynal@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id 49F56C0004;
        Tue,  3 Jan 2023 16:58:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1672765115;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Z3YY0y8n4MkUC0S8OdeC49w8r7G1CDvUP8dmuAEtvkg=;
        b=WULtpYAREMjOgIWDs6YatM0r20CvNT54R064S+okpztYFjfWNFJg9N8xaOOKP7o6j8KemB
        lcn6jJDEmCn8CWZQ1LDl9JBstq0Hm0HFTiPhJKAr10UJWesbopXpkP70+0ewAX/kloHOvb
        I3khMF+PnjtzVdvuTybr6SdSiYN8XpjnZOxhpqLdvaWkhSLeK21Yq8YNoarifQMat5nCCQ
        5Cwm2oOoCngs08CrJoQcheXOqgE2z0YiMsRATGjt7fTHDyCNEKeqixZABnqBMJm/Lw3ysv
        06KLliCkJDKlzwXgiyJv69lY7fv3kGssD7SGYVLFD3LWt4nJ4fHD+AhDAYArsA==
Date:   Tue, 3 Jan 2023 17:58:32 +0100
From:   Miquel Raynal <miquel.raynal@bootlin.com>
To:     Stefan Schmidt <stefan@datenfreihafen.org>
Cc:     Alexander Aring <alex.aring@gmail.com>, linux-wpan@vger.kernel.org,
        David Girault <david.girault@qorvo.com>,
        Romuald Despres <romuald.despres@qorvo.com>,
        Frederic Blain <frederic.blain@qorvo.com>,
        Nicolas Schodet <nico@ni.fr.eu.org>,
        Guilhem Imberton <guilhem.imberton@qorvo.com>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>, netdev@vger.kernel.org
Subject: Re: [PATCH wpan-next v2 3/6] ieee802154: Introduce a helper to
 validate a channel
Message-ID: <20230103175832.0b2ae9c6@xps-13>
In-Reply-To: <20230103155950.7cf2e5fe@xps-13>
References: <20221217000226.646767-1-miquel.raynal@bootlin.com>
        <20221217000226.646767-4-miquel.raynal@bootlin.com>
        <b1c095d1-6dee-b49d-52d4-a5ea84f36cfd@datenfreihafen.org>
        <20230103155950.7cf2e5fe@xps-13>
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

Hi Stefan,

miquel.raynal@bootlin.com wrote on Tue, 3 Jan 2023 15:59:50 +0100:

> Hi Stefan,
>=20
> stefan@datenfreihafen.org wrote on Tue, 3 Jan 2023 15:14:46 +0100:
>=20
> > Hello Miquel.
> >=20
> > On 17.12.22 01:02, Miquel Raynal wrote: =20
> > > This helper for now only checks if the page member and channel member
> > > are valid (in the specification range) and supported (by checking the
> > > device capabilities). Soon two new parameters will be introduced and
> > > having this helper will let us only modify its content rather than
> > > modifying the logic everywhere else in the subsystem.
> > >=20
> > > There is not functional change.
> > >=20
> > > Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
> > > ---
> > >   include/net/cfg802154.h   | 11 +++++++++++
> > >   net/ieee802154/nl802154.c |  3 +--
> > >   2 files changed, 12 insertions(+), 2 deletions(-)
> > >=20
> > > diff --git a/include/net/cfg802154.h b/include/net/cfg802154.h
> > > index 76d4f95e9974..11bedfa96371 100644
> > > --- a/include/net/cfg802154.h
> > > +++ b/include/net/cfg802154.h
> > > @@ -246,6 +246,17 @@ static inline void wpan_phy_net_set(struct wpan_=
phy *wpan_phy, struct net *net)
> > >   	write_pnet(&wpan_phy->_net, net);
> > >   }   =20
> > >   > +static inline bool ieee802154_chan_is_valid(struct wpan_phy *phy=
,   =20
> > > +                                            u8 page, u8 channel)
> > > +{
> > > +        if (page > IEEE802154_MAX_PAGE ||
> > > +            channel > IEEE802154_MAX_CHANNEL ||
> > > +            !(phy->supported.channels[page] & BIT(channel)))
> > > +                return false;
> > > +
> > > +	return true;
> > > +}
> > > +   =20
> >=20
> > This patch has some indent problems. =20
>=20
> I will check all the patches of this series and fix what checkpatch.pl
> reports.

I left the warnings in the trace.h headers to keep the visual
consistent. The other warnings should be gone.

Thanks,
Miqu=C3=A8l

