Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CC85F691CF0
	for <lists+netdev@lfdr.de>; Fri, 10 Feb 2023 11:36:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232125AbjBJKgZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Feb 2023 05:36:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51822 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232126AbjBJKgX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Feb 2023 05:36:23 -0500
Received: from relay5-d.mail.gandi.net (relay5-d.mail.gandi.net [217.70.183.197])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD6616D616;
        Fri, 10 Feb 2023 02:35:49 -0800 (PST)
Received: (Authenticated sender: miquel.raynal@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id 3D8681C0004;
        Fri, 10 Feb 2023 10:35:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1676025334;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Bn0Yz2hmjOIf/6ehEzdV6KOtEqHvIMheqpoKEObsFN8=;
        b=bX/DQVUMus4JCkxJ0+ddQVY4zRVxKIJYQuxuDdhQJYWOYlYcSMNp9z9JwfQGU1AmEe0xM0
        iLnNbzLTbFkCljqNqFWtM3MHHszbcEPzpJ0dcgauvWXQ2HQUsi2tlhez76DKnyd1YObOTV
        BQ36Rl0ZpDXHnpgikiBu9X+wtUXXML8dv36YetZtP0/wQQlEJbFnNSbPQK8iW9GCJ7aDPf
        5eg53plcNWe/GUQg/KMqT4a++j7xlIDD+NbM6raL5MB18u5+07DLYP3BI0LZSoA8ZL/VAX
        vrtN6+er2P8PLe9pjCAlHggGVAVBKOZVCQz6PlHJOhf0XrYcfRknM8XAWzBH0A==
Date:   Fri, 10 Feb 2023 11:35:31 +0100
From:   Miquel Raynal <miquel.raynal@bootlin.com>
To:     Stefan Schmidt <stefan@datenfreihafen.org>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Alexander Aring <alex.aring@gmail.com>,
        linux-wpan@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>, netdev@vger.kernel.org,
        David Girault <david.girault@qorvo.com>,
        Romuald Despres <romuald.despres@qorvo.com>,
        Frederic Blain <frederic.blain@qorvo.com>,
        Nicolas Schodet <nico@ni.fr.eu.org>,
        Guilhem Imberton <guilhem.imberton@qorvo.com>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>
Subject: Re: [PATCH wpan-next 1/6] ieee802154: Add support for user scanning
 requests
Message-ID: <20230210113531.4ec5d368@xps-13>
In-Reply-To: <47d8bd5f-a384-41fd-8d42-0b5037c4a7a5@datenfreihafen.org>
References: <20221129160046.538864-1-miquel.raynal@bootlin.com>
        <20221129160046.538864-2-miquel.raynal@bootlin.com>
        <20230203201923.6de5c692@kernel.org>
        <20230210111843.0817d0d3@xps-13>
        <47d8bd5f-a384-41fd-8d42-0b5037c4a7a5@datenfreihafen.org>
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

stefan@datenfreihafen.org wrote on Fri, 10 Feb 2023 11:26:45 +0100:

> Hello.
>=20
> On 10.02.23 11:18, Miquel Raynal wrote:
> > Hi Stefan, Jakub,
> >=20
> > kuba@kernel.org wrote on Fri, 3 Feb 2023 20:19:23 -0800:
> >  =20
> >> On Tue, 29 Nov 2022 17:00:41 +0100 Miquel Raynal wrote: =20
> >>> +static int nl802154_trigger_scan(struct sk_buff *skb, struct genl_in=
fo *info)
> >>> +{
> >>> +	struct cfg802154_registered_device *rdev =3D info->user_ptr[0];
> >>> +	struct net_device *dev =3D info->user_ptr[1];
> >>> +	struct wpan_dev *wpan_dev =3D dev->ieee802154_ptr;
> >>> +	struct wpan_phy *wpan_phy =3D &rdev->wpan_phy;
> >>> +	struct cfg802154_scan_request *request;
> >>> +	u8 type;
> >>> +	int err;
> >>> +
> >>> +	/* Monitors are not allowed to perform scans */
> >>> +	if (wpan_dev->iftype =3D=3D NL802154_IFTYPE_MONITOR) =20
> >>
> >> extack ? =20
> >=20
> > Thanks for pointing at it, I just did know about it. I did convert
> > most of the printk's into extack strings. Shall I keep both or is fine
> > to just keep the extack thing?
> >=20
> > For now I've dropped the printk's, please tell me if this is wrong.
> >  =20
> >> =20
> >>> +		return -EPERM; =20
> >=20
> > Stefan, do you prefer a series of patches applying on top of your
> > current next or should I re-roll the entire series (scan + beacons)?
> >=20
> > I am preparing a series applying on top of the current list of applied
> > patches. This means next PR to net maintainers will include this patch
> > as it is today + fixes on top. If this is fine for both parties, I will
> > send these (including the other changes discussed with Alexander). Just
> > let me know. =20
>=20
> On top please. The other patches are already sitting in a published git t=
ree and I want to avoid doing a rebase on the published tree.
>=20
> Once your new patches are in and Jakub is happy I will send an updated pu=
ll request with them included.

Thanks a lot for the quick answer!

Thanks,
Miqu=C3=A8l
