Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A3B4E6718A9
	for <lists+netdev@lfdr.de>; Wed, 18 Jan 2023 11:13:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229868AbjARKNY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Jan 2023 05:13:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46162 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230035AbjARKMI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Jan 2023 05:12:08 -0500
Received: from relay4-d.mail.gandi.net (relay4-d.mail.gandi.net [217.70.183.196])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D5CD438010;
        Wed, 18 Jan 2023 01:21:03 -0800 (PST)
Received: (Authenticated sender: miquel.raynal@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id 48263E0006;
        Wed, 18 Jan 2023 09:20:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1674033661;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=BgsM5LrO3RoOdBjZxxGARC7vt+3hHl9epXc2QRCLjR4=;
        b=dzTUTaRwkWUP4gWns2+ckP65M6ewUGi8FV5z/cZnsZo8t34a/dVjIS7SN0Sp9/kWGfGRb2
        0qb9rYMETyJdj5BK3jB/uE5g9lhi9PPdSsKN+Qv4k8cFibcdkttONwi0eghjPAwLptm9sL
        TDq0SHUSaGstdP1tH72M+NPffYP2p0Q0vYflQvW/npJJR+33OPcVFrm6Q7iILuhUhUmiVK
        QRkkElMHmyBtqTMJ9YOaB06MYGKvM1/SreXq4l1hlZbJ8im4+6i/FAXGKpQuUz7YeM+nm4
        x8v5aNDmZyCExgeqMjQ7Uo9Tz4vUIjqxVAkAHGE5bE3NRf4dCqxhLq0WnJMnJQ==
Date:   Wed, 18 Jan 2023 10:20:58 +0100
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
Subject: Re: [PATCH wpan-next 0/2] ieee802154: Beaconing support
Message-ID: <20230118102058.3b1f275b@xps-13>
In-Reply-To: <CAK-6q+jNmvtBKKxSp1WepVXbaQ65CghZv3bS2ptjB9jyzOSGTA@mail.gmail.com>
References: <20230106113129.694750-1-miquel.raynal@bootlin.com>
        <CAK-6q+jNmvtBKKxSp1WepVXbaQ65CghZv3bS2ptjB9jyzOSGTA@mail.gmail.com>
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

Hi Alexander,

aahringo@redhat.com wrote on Sun, 15 Jan 2023 20:54:02 -0500:

> Hi,
>=20
> On Fri, Jan 6, 2023 at 6:33 AM Miquel Raynal <miquel.raynal@bootlin.com> =
wrote:
> >
> > Scanning being now supported, we can eg. play with hwsim to verify
> > everything works as soon as this series including beaconing support gets
> > merged.
> > =20
>=20
> I am not sure if a beacon send should be handled by an mlme helper
> handling as this is a different use-case and the user does not trigger
> an mac command and is waiting for some reply and a more complex
> handling could be involved. There is also no need for hotpath xmit
> handling is disabled during this time. It is just an async messaging
> in some interval and just "try" to send it and don't care if it fails,
> or? For mac802154 therefore I think we should use the dev_queue_xmit()
> function to queue it up to send it through the hotpath?
>=20
> I can ack those patches, it will work as well. But I think we should
> switch at some point to dev_queue_xmit(). It should be simple to
> switch it. Just want to mention there is a difference which will be
> there in mac-cmds like association.

I see what you mean. That's indeed true, we might just switch to
a less constrained transmit path.

In practice, what is deliberately "not enough" here is the precision
when sending the beacons, eg. for ranging purposes (UWB) we will need
to send the beacons at a strict pace. But there are two ways for doing
that :
- use a dedicated scheduler (not supported yet)
- move this logic into a firmware, within an embedded controller on the
  PHY

But that is something that we will have to sort out later on. For now,
let's KISS.

> btw: what is about security handling... however I would declare this
> feature as experimental anyway.

I haven't tested the security layer at all yet, would you have a few
commands to start with, which I could try using eg. hwsim?

Thanks,
Miqu=C3=A8l
