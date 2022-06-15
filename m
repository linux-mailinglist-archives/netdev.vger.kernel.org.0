Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 94ED654C456
	for <lists+netdev@lfdr.de>; Wed, 15 Jun 2022 11:08:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238922AbiFOJIh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jun 2022 05:08:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48146 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346746AbiFOJIG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Jun 2022 05:08:06 -0400
Received: from relay3-d.mail.gandi.net (relay3-d.mail.gandi.net [217.70.183.195])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B50813E0E5;
        Wed, 15 Jun 2022 02:08:04 -0700 (PDT)
Received: (Authenticated sender: miquel.raynal@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id 020C960003;
        Wed, 15 Jun 2022 09:08:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1655284082;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=MymE6MOX0GlwQVuLH2UMzj0yLsWSK4MgouE3pnUGsOI=;
        b=nezqxXEmW4FzurCD+Ou0ZngVNbU8PnTEZLxMUU4ge3iDVxKRZalp0zCN7WB4I5U3+99EWT
        1tSSDwnO/NzQNc9ZHkSBOKRUDd4mcRGGnSh3dLIQMcQjTj1ugBL1EYFrx4VMXrydv6ZRfN
        2PbUCd/xKbhQ27HDPOZRjJ/vw8RA/cV3/0X39XN+9kSV2BwpveoWrTtn5A6Wa/mQAjueea
        0OQM65NQ6yQOA4HTxeBfWJMvj3KhxfLHSPc5MdmtAxKmqMFTjfYQV9nWTlE17MJcm+q7tg
        diBXLlDZaP/ceLm88Wc4u6/3Gg+RPGQVcEj52I8jbriwwMm0HtmZbnhq1LNdAg==
Date:   Wed, 15 Jun 2022 11:08:00 +0200
From:   Miquel Raynal <miquel.raynal@bootlin.com>
To:     Alexander Aring <aahringo@redhat.com>
Cc:     Stefan Schmidt <stefan@datenfreihafen.org>,
        linux-wpan - ML <linux-wpan@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>
Subject: Re: [PATCHv2 wpan-next 0/2] mac802154: atomic_dec_and_test() fixes
Message-ID: <20220615110800.6b17960b@xps-13>
In-Reply-To: <20220615092558.1ebe6abe@xps-13>
References: <20220613043735.1039895-1-aahringo@redhat.com>
        <20220613161457.0a05cda0@xps-13>
        <CAK-6q+ioLUC=M-i00JX4mq8a9dh6+Jh=q4ZhYgmZmeoS8WMN+g@mail.gmail.com>
        <20220615092558.1ebe6abe@xps-13>
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


miquel.raynal@bootlin.com wrote on Wed, 15 Jun 2022 09:25:58 +0200:

> Hi Alex,
>=20
> aahringo@redhat.com wrote on Tue, 14 Jun 2022 22:53:19 -0400:
>=20
> > Hi,
> >=20
> > On Mon, Jun 13, 2022 at 10:15 AM Miquel Raynal
> > <miquel.raynal@bootlin.com> wrote:
> > >
> > > Hi Alex,
> > >
> > > aahringo@redhat.com wrote on Mon, 13 Jun 2022 00:37:33 -0400:
> > > =20
> > > > Hi,
> > > >
> > > > I was wondering why nothing worked anymore. I found it...
> > > >
> > > > changes since v2:
> > > >
> > > >  - fix fixes tags in mac802154: util: fix release queue handling
> > > >  - add patch mac802154: fix atomic_dec_and_test checks got somehow
> > > >    confused 2 patch same issue =20
> > >
> > > I've got initially confused with your patchset but yes indeed the API
> > > works the opposite way compared to my gut understanding.
> > > =20
> >=20
> > not the first time I am seeing this, I fixed similar issues already at
> > other places.
> >=20
> > btw I told you the right semantic at [0] ....
>=20
> I focused on the if statement more than the actual syntax...
>=20
> >=20
> > > We bought hardware and I am currently setting up a real network to
> > > hopefully track these regressions myself in the future.
> > > =20
> >=20
> > I wonder why you don't use hwsim... and you already mentioned hwsim to
> > me.
>=20
> I do use hwsim but I was exclusively testing the mlme ops with it.
>=20
> > You can simply make a 6lowpan interface on it and ping it - no
> > hardware needed and this would already show issues...
>=20
> Actually I just learnt about how to create 6lowpan interfaces and do
> basic data exchanges, it's rather easy and straightforward, but I must
> admit I was not familiar at all with this area and thought it would be
> more complex... Indeed, hwsim would work just fine for this purpose,
> I will add this to my checklist.
>=20
> > Now you can say,
> > why I do not test it... maybe I do next time but review takes longer
> > then.
>=20
> I'm not saying this at all :) It is my duty, not yours, reviews and
> feedback are more than enough.

Ok 6lowpan is _really_ well integrated, apologies for not taking the
time to use it before.

BTW I see all around the internet that ping6 produces this warning:

	ping6: Warning: source address might be selected on device
	other than: lowpan0

At a first glance I could not find an explanation, do you also have it
on your side? Do you know what it means?


Thanks,
Miqu=C3=A8l
