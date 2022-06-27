Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 39EE655D8CE
	for <lists+netdev@lfdr.de>; Tue, 28 Jun 2022 15:20:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233609AbiF0InJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Jun 2022 04:43:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38512 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232724AbiF0InI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Jun 2022 04:43:08 -0400
Received: from relay2-d.mail.gandi.net (relay2-d.mail.gandi.net [217.70.183.194])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B4E06327;
        Mon, 27 Jun 2022 01:43:06 -0700 (PDT)
Received: (Authenticated sender: miquel.raynal@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id 53EA440012;
        Mon, 27 Jun 2022 08:43:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1656319385;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=f9dzcE7F6naI6mowy0rxK9mblp39wVly6K3avxay1Us=;
        b=LJlYD6NaMBVpI/YwBWTZstDh+bxlTmdcM1yQc5wXwT43opSBBshs1JoB7wK5LcUlazzmFv
        Ads1vpPz0lxNP3A6ZwDUXyxtYamb3UQHOCuv2JviMAVg7wv3fER/jo5Hz1G/YaV19ZUJTv
        /TtHvg3Yav9ZwzP9tsys5mCK4yjYOjSSMoSiLvL5q3wA+3OMYGgpdareyembNpyjaIOCb8
        358uMtQ6KIBFBK4NL7IDCQFcIf0qJmJ+EGtu7qHreOFoBSOZBMPQS7uSe5fIpt2yFlUzKP
        MIolH27kigwg8IJ1lRTg6m4jkU6d295aiLFNwWuHQr0jaqYePEXDVeySTpbcMA==
Date:   Mon, 27 Jun 2022 10:43:03 +0200
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
Subject: Re: [PATCH wpan-next v3 2/4] net: ieee802154: Add support for inter
 PAN management
Message-ID: <20220627104303.5392c7f6@xps-13>
In-Reply-To: <CAK-6q+jAhikJq5tp-DRx1C_7ka5M4w6EKUB_cUdagSSwP5Tk_A@mail.gmail.com>
References: <20220620134018.62414-1-miquel.raynal@bootlin.com>
        <20220620134018.62414-3-miquel.raynal@bootlin.com>
        <CAK-6q+jAhikJq5tp-DRx1C_7ka5M4w6EKUB_cUdagSSwP5Tk_A@mail.gmail.com>
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

aahringo@redhat.com wrote on Sat, 25 Jun 2022 22:29:08 -0400:

> Hi,
>=20
> On Mon, Jun 20, 2022 at 10:26 AM Miquel Raynal
> <miquel.raynal@bootlin.com> wrote:
> >
> > Let's introduce the basics for defining PANs:
> > - structures defining a PAN
> > - helpers for PAN registration
> > - helpers discarding old PANs
> > =20
>=20
> I think the whole pan management can/should be stored in user space by
> a daemon running in background.

We need both, and currently:
- while the scan is happening, the kernel saves all the discovered PANs
- the kernel PAN list can be dumped (and also flushed) asynchronously by
  the userspace

IOW the userspace is responsible of keeping its own list of PANs in
sync with what the kernel discovers, so at any moment it can ask the
kernel what it has in memory, it can be done during a scan or after. It
can request a new scan to update the entries, or flush the kernel list.
The scan operation is always requested by the user anyway, it's not
something happening in the background.

> This can be a network manager as it
> listens to netlink events as "detect PAN xy" and stores it and offers
> it in their list to associate with it.

There are events produced, yes. But really, this is not something we
actually need. The user requests a scan over a given range, when the
scan is over it looks at the list and decides which PAN it
wants to associate with, and through which coordinator (95% of the
scenarii).

> We need somewhere to draw a line and I guess the line is "Is this
> information used e.g. as any lookup or something in the hot path", I
> don't see this currently...

Each PAN descriptor is like 20 bytes, so that's why I don't feel back
keeping them, I think it's easier to be able to serve the list of PANs
upon request rather than only forwarding events and not being able to
retrieve the list a second time (at least during the development).

Overall I feel like this part is still a little bit blurry because it
has currently no user, perhaps I should send the next series which
actually makes the current series useful.

Thanks,
Miqu=C3=A8l
