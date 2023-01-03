Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 65C4C65C2A6
	for <lists+netdev@lfdr.de>; Tue,  3 Jan 2023 16:02:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233108AbjACPBa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Jan 2023 10:01:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38728 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230323AbjACPB1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Jan 2023 10:01:27 -0500
Received: from relay1-d.mail.gandi.net (relay1-d.mail.gandi.net [217.70.183.193])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CBA15DF5E;
        Tue,  3 Jan 2023 07:01:23 -0800 (PST)
Received: (Authenticated sender: miquel.raynal@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id D4F5E240005;
        Tue,  3 Jan 2023 14:59:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1672758082;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=0Nne6hDhqB3dQkpHePYHzCEsD4Z+XkdAEf5jm6hYkec=;
        b=L13d2ZUL6z19KTBfPvnsNRF5jRXEkAgx+uoizfNqThqk8v9cRer4ilPKwUzdboEqo0CXYc
        Ny+wNHWMI9rXlMxWXKoCN+4aEe4JhAWAOpxYdOIEA2FKwzqQE7uxnbh57NL1qWI77tumnL
        yuKhHAQNSQafJKYz8NY375jwM6fk9EzH12LtqlHSRDawJoate65uYppv8CirfPG6Rv895q
        +/Qq1uBH7xnekMdSlCy/gwQ9UifT9JfjCW4fmUUeRQyn/58C2HIt8r8cU281XXzMpUG4cF
        RLJi4SEIEfnADtc66tMC2137r3qsA+sr1UErLmCLrjhASJKqvQu+dlJ055xuVw==
Date:   Tue, 3 Jan 2023 15:59:50 +0100
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
Message-ID: <20230103155950.7cf2e5fe@xps-13>
In-Reply-To: <b1c095d1-6dee-b49d-52d4-a5ea84f36cfd@datenfreihafen.org>
References: <20221217000226.646767-1-miquel.raynal@bootlin.com>
        <20221217000226.646767-4-miquel.raynal@bootlin.com>
        <b1c095d1-6dee-b49d-52d4-a5ea84f36cfd@datenfreihafen.org>
Organization: Bootlin
X-Mailer: Claws Mail 4.0.0 (GTK+ 3.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Stefan,

stefan@datenfreihafen.org wrote on Tue, 3 Jan 2023 15:14:46 +0100:

> Hello Miquel.
>=20
> On 17.12.22 01:02, Miquel Raynal wrote:
> > This helper for now only checks if the page member and channel member
> > are valid (in the specification range) and supported (by checking the
> > device capabilities). Soon two new parameters will be introduced and
> > having this helper will let us only modify its content rather than
> > modifying the logic everywhere else in the subsystem.
> >=20
> > There is not functional change.
> >=20
> > Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
> > ---
> >   include/net/cfg802154.h   | 11 +++++++++++
> >   net/ieee802154/nl802154.c |  3 +--
> >   2 files changed, 12 insertions(+), 2 deletions(-)
> >=20
> > diff --git a/include/net/cfg802154.h b/include/net/cfg802154.h
> > index 76d4f95e9974..11bedfa96371 100644
> > --- a/include/net/cfg802154.h
> > +++ b/include/net/cfg802154.h
> > @@ -246,6 +246,17 @@ static inline void wpan_phy_net_set(struct wpan_ph=
y *wpan_phy, struct net *net)
> >   	write_pnet(&wpan_phy->_net, net);
> >   } =20
> >   > +static inline bool ieee802154_chan_is_valid(struct wpan_phy *phy, =
=20
> > +                                            u8 page, u8 channel)
> > +{
> > +        if (page > IEEE802154_MAX_PAGE ||
> > +            channel > IEEE802154_MAX_CHANNEL ||
> > +            !(phy->supported.channels[page] & BIT(channel)))
> > +                return false;
> > +
> > +	return true;
> > +}
> > + =20
>=20
> This patch has some indent problems.

I will check all the patches of this series and fix what checkpatch.pl
reports.

https://media.tenor.com/025m1-otvn0AAAAC/shame-game-of-thrones.gif

Cheers,
Miqu=C3=A8l

>=20
> Commit 6bbb25ee282b ("ieee802154: Introduce a helper to validate a channe=
l")
> -------------------------------------------------------------------------=
---
> ERROR: code indent should use tabs where possible
> #31: FILE: include/net/cfg802154.h:250:
> +                                            u8 page, u8 channel)$
>=20
> WARNING: please, no spaces at the start of a line
> #31: FILE: include/net/cfg802154.h:250:
> +                                            u8 page, u8 channel)$
>=20
> ERROR: code indent should use tabs where possible
> #33: FILE: include/net/cfg802154.h:252:
> +        if (page > IEEE802154_MAX_PAGE ||$
>=20
> WARNING: please, no spaces at the start of a line
> #33: FILE: include/net/cfg802154.h:252:
> +        if (page > IEEE802154_MAX_PAGE ||$
>=20
> ERROR: code indent should use tabs where possible
> #34: FILE: include/net/cfg802154.h:253:
> +            channel > IEEE802154_MAX_CHANNEL ||$
>=20
> WARNING: please, no spaces at the start of a line
> #34: FILE: include/net/cfg802154.h:253:
> +            channel > IEEE802154_MAX_CHANNEL ||$
>=20
> ERROR: code indent should use tabs where possible
> #35: FILE: include/net/cfg802154.h:254:
> +            !(phy->supported.channels[page] & BIT(channel)))$
>=20
> WARNING: please, no spaces at the start of a line
> #35: FILE: include/net/cfg802154.h:254:
> +            !(phy->supported.channels[page] & BIT(channel)))$
>=20
> ERROR: code indent should use tabs where possible
> #36: FILE: include/net/cfg802154.h:255:
> +                return false;$
>=20
> WARNING: please, no spaces at the start of a line
> #36: FILE: include/net/cfg802154.h:255:
> +                return false;$
>=20
> total: 5 errors, 5 warnings, 0 checks, 26 lines checked
>=20
> regards
> Stefan Schmidt
