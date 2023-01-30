Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7F2D36809E8
	for <lists+netdev@lfdr.de>; Mon, 30 Jan 2023 10:51:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235741AbjA3JvC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Jan 2023 04:51:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53864 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229694AbjA3JvA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Jan 2023 04:51:00 -0500
Received: from relay4-d.mail.gandi.net (relay4-d.mail.gandi.net [IPv6:2001:4b98:dc4:8::224])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7BB461BAC5;
        Mon, 30 Jan 2023 01:50:58 -0800 (PST)
Received: (Authenticated sender: miquel.raynal@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id 09DF3E0009;
        Mon, 30 Jan 2023 09:50:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1675072256;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=6oEeGGNGwoJYbO3Up6NrhRX8Nz4lo6PBQZ7bv235o2Q=;
        b=GIhRUFcq13oJqopJ7gQwjse9DYg3Yztmsw3ZI65BFVLnbIpbb2Yef3gI8f0b0TOijNVNR2
        CeGLSR9mRnyeXgIpYRuh5Kpn63YINOmu4+RGm/Q9itrHy7+fDiQdmUnC3ztPK1FN2+qr65
        y/hO7Ce0assFDUIW8LZONP1SJj/AdzmR3UaS/xZQQ2ATCu3yXXi0S/3DoiwCTjL4yafsLz
        8CILr9mWV2eXFZ4r4rIWUV/rMHtc4bqDUBcFOl28si9SgpIV5R9omSLn6W+5qaGdEyGLhR
        UKXdsy3dTwEsSaxoAPf6hTXb97UMmJNiywlkcUIO4RBM80YiVvinx09Olb1Cew==
Date:   Mon, 30 Jan 2023 10:50:51 +0100
From:   Miquel Raynal <miquel.raynal@bootlin.com>
To:     Alexander Aring <aahringo@redhat.com>
Cc:     Michael Richardson <mcr@sandelman.ca>,
        Alexander Aring <alex.aring@gmail.com>,
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
Subject: Re: [PATCH wpan-next 0/2] ieee802154: Beaconing support
Message-ID: <20230130105051.24926c5f@xps-13>
In-Reply-To: <CAK-6q+ix3PybA-Af-QRRZ2BwSLYH76SnqhRCsmRpiy_6PFrorw@mail.gmail.com>
References: <20230106113129.694750-1-miquel.raynal@bootlin.com>
        <CAK-6q+jNmvtBKKxSp1WepVXbaQ65CghZv3bS2ptjB9jyzOSGTA@mail.gmail.com>
        <20230118102058.3b1f275b@xps-13>
        <CAK-6q+gwP8P--5e9HKt2iPhjeefMXrXUVy-G+szGdFXZvgYKvg@mail.gmail.com>
        <CAK-6q+gn7W9x2+ihSC41RzkhmBn1E44pKtJFHgqRdd8aBpLrVQ@mail.gmail.com>
        <20230124110814.6096ecbe@xps-13>
        <CAB_54W69KcM0UJjf8py-VyRXx2iEUvcAKspXiAkykkQoF6ccDA@mail.gmail.com>
        <20230125105653.44e9498f@xps-13>
        <CAK-6q+irhYroxV_P5ORtO9Ui9-Bs=SNS+vO5bZ7_X-geab+XrA@mail.gmail.com>
        <1322777.1674848380@dyas>
        <CAK-6q+ix3PybA-Af-QRRZ2BwSLYH76SnqhRCsmRpiy_6PFrorw@mail.gmail.com>
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

Hello,

aahringo@redhat.com wrote on Fri, 27 Jan 2023 20:57:08 -0500:

> Hi,
>=20
> On Fri, Jan 27, 2023 at 2:52 PM Michael Richardson <mcr@sandelman.ca> wro=
te:
> >
> >
> > Alexander Aring <aahringo@redhat.com> wrote: =20
> >     >> - MLME ops without feedback constraints like beacons -> should go
> >     >> through the hot path, but not through the whole net stack, so
> >     >> ieee802154_subif_start_xmit()
> >     >> =20
> > =20
> >     > it will bypass the qdisc handling (+ some other things which are =
around
> >     > there). The current difference is what I see llsec handling and o=
ther
> >     > things which might be around there?

Not exactly, because llsec handling is not done in the net/ stack, but
right inside the ieee802154 transmit callbacks, so I'd say it will be
quite easy to tweak when we have a clear view of what we want in terms
of encryption/integrity checking/signatures.

> >     > It depends if other "MLME-ops" need
> >     > to be e.g. encrypted or not. =20
> >
> > I haven't followed the whole thread.
> > So I am neither agreeing nor disagreeing, just clarifying.
> > Useful beacons are "signed" (have integrity applied), but not encrypted.
> > =20
>=20
> I see. But that means they need to be going through llsec, just the
> payload isn't encrypted and the MIC is appended to provide integrity.
>=20
> > It's important for userspace to be able to receive them, even if we don=
't
> > have a key that can verify them.  AFAIK, we have no specific interface =
to
> > receive beacons.
> > =20
>=20
> This can be done over multiple ways. Either over a socket
> communication or if they appear rarely we can put them into a netlink
> event. In my opinion we already put that in a higher level API in
> passive scan to interpret the receiving of a beacon on kernel level
> and trigger netlink events.

Indeed.

> I am not sure how HardMAC transceivers handle them on the transceiver
> side only or if they ever provide them to the next layer or not?
> For SoftMAC you can actually create a AF_PACKET raw socket, and you
> should see everything which bypass hardware address filters and kernel
> filters. Then an application can listen to them.

Thanks,
Miqu=C3=A8l
