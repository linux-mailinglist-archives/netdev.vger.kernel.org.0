Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 29AE861ED31
	for <lists+netdev@lfdr.de>; Mon,  7 Nov 2022 09:44:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231431AbiKGIn6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Nov 2022 03:43:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46812 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231439AbiKGIny (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Nov 2022 03:43:54 -0500
Received: from relay4-d.mail.gandi.net (relay4-d.mail.gandi.net [IPv6:2001:4b98:dc4:8::224])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 468262AFB;
        Mon,  7 Nov 2022 00:43:52 -0800 (PST)
Received: (Authenticated sender: miquel.raynal@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id B7ADCE000A;
        Mon,  7 Nov 2022 08:43:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1667810630;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=+diWClweYU6nEI2akBP8wXXCuDU5VOiWiAyIXHE2MIw=;
        b=AdtxRfl/Z/tTiZzRHQ7+VXqfYnTmskbQCfoguH8dvA0tRhb3YmSHoQ6oW+33wj896ZGbRE
        5L9CxrIvXXS8oQ9amLdYWVToo3Tz6/3vd9+OK+6LKTsxmdTPnRpGhGDtrLVu7ZXDpNC8Xi
        T16VotLwqXKF7njeXilImNWDirkUSoGs+pQEwg4Pc64qQ2fAavrTWt6Sfi1yYF9opnNirL
        m3FvFmJe8GbI/0Wo76yxawOPAR7IRlf16SCCrgAL4odhS1HYe+b5H4t+Oqt2GGE4zV9bWp
        0dYycICFkXvaw5Kgm0CibZWzuuwdm5sbAWnqpEjWyFKkskbkH2gh4UxduZp2WQ==
Date:   Mon, 7 Nov 2022 09:43:48 +0100
From:   Miquel Raynal <miquel.raynal@bootlin.com>
To:     Alexander Aring <aahringo@redhat.com>
Cc:     Alexander Aring <alex.aring@gmail.com>,
        Stefan Schmidt <stefan@datenfreihafen.org>,
        linux-wpan@vger.kernel.org,
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
Subject: Re: [PATCH wpan-next 2/3] ieee802154: Handle coordinators discovery
Message-ID: <20221107094348.72223dc8@xps-13>
In-Reply-To: <CAK-6q+hh4Ny7zV-MbdjrGQq-Dtb783A8m3G5GMcXSdhSwicuiw@mail.gmail.com>
References: <20221102151915.1007815-1-miquel.raynal@bootlin.com>
        <20221102151915.1007815-3-miquel.raynal@bootlin.com>
        <CAK-6q+hh4Ny7zV-MbdjrGQq-Dtb783A8m3G5GMcXSdhSwicuiw@mail.gmail.com>
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

> > +static bool
> > +cfg802154_is_same_coordinator(struct ieee802154_coord_desc *a,
> > +                             struct ieee802154_coord_desc *b)
> > +{
> > +       if (a->addr->pan_id !=3D b->addr->pan_id)
> > +               return false;
> > +
> > +       if (a->addr->mode !=3D b->addr->mode)
> > +               return false;
> > +
> > +       if (a->addr->mode =3D=3D IEEE802154_ADDR_SHORT &&
> > +           a->addr->short_addr =3D=3D b->addr->short_addr)
> > +               return true;
> > +       else if (a->addr->mode =3D=3D IEEE802154_ADDR_LONG &&
> > +                a->addr->extended_addr =3D=3D b->addr->extended_addr)
> > +               return true;
> > +
> > +       return false; =20
>=20
> semantic is a little bit different, can we use "ieee802154_addr_equal()" =
here?

No problem, I will.

Thanks,
Miqu=C3=A8l
