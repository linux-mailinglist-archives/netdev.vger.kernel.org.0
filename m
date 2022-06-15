Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C3BEF54C29A
	for <lists+netdev@lfdr.de>; Wed, 15 Jun 2022 09:26:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244260AbiFOH0H (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jun 2022 03:26:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35810 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244082AbiFOH0G (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Jun 2022 03:26:06 -0400
Received: from relay11.mail.gandi.net (relay11.mail.gandi.net [217.70.178.231])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 323C546B0C;
        Wed, 15 Jun 2022 00:26:01 -0700 (PDT)
Received: (Authenticated sender: miquel.raynal@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id 3B14F10000C;
        Wed, 15 Jun 2022 07:25:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1655277959;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=zO0xvjnAdiWCC3fl4XNSZUcbR7Vf7IuLgnpt/+jYI/s=;
        b=Q+tNJrysONQKzp7E+Si+nDTgGXxl0p6WTOsNmMK0mCzCg82RVhxuJVkQ/7zrfFsxmwlBs5
        n5C+Us4ksn4n2panlscHAR+q0m0tz00el1OQSBeo1zUh94DwA76lfBa2AzNm+t3v2wyO04
        ZCBo+4pR7r0UOcDnKUmExt8gUPZpaciRDFPNs5M26bS7Tjx3VlpHbcJ+LhtOMcQSya2xBT
        3m2hwWxKVjy8QZLl3JKklMoLEzhozb3AZMVWvHkkVszWOHQk5HkU/9BOrm40ExxL6gcpdJ
        oSZ2TWRPszSK/azMBSF2Tgrl7n9VXrMihERtev0+Jqpl8pwH4unfmdqrvyQ61Q==
Date:   Wed, 15 Jun 2022 09:25:58 +0200
From:   Miquel Raynal <miquel.raynal@bootlin.com>
To:     Alexander Aring <aahringo@redhat.com>
Cc:     Stefan Schmidt <stefan@datenfreihafen.org>,
        linux-wpan - ML <linux-wpan@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>
Subject: Re: [PATCHv2 wpan-next 0/2] mac802154: atomic_dec_and_test() fixes
Message-ID: <20220615092558.1ebe6abe@xps-13>
In-Reply-To: <CAK-6q+ioLUC=M-i00JX4mq8a9dh6+Jh=q4ZhYgmZmeoS8WMN+g@mail.gmail.com>
References: <20220613043735.1039895-1-aahringo@redhat.com>
        <20220613161457.0a05cda0@xps-13>
        <CAK-6q+ioLUC=M-i00JX4mq8a9dh6+Jh=q4ZhYgmZmeoS8WMN+g@mail.gmail.com>
Organization: Bootlin
X-Mailer: Claws Mail 4.0.0 (GTK+ 3.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Alex,

aahringo@redhat.com wrote on Tue, 14 Jun 2022 22:53:19 -0400:

> Hi,
>=20
> On Mon, Jun 13, 2022 at 10:15 AM Miquel Raynal
> <miquel.raynal@bootlin.com> wrote:
> >
> > Hi Alex,
> >
> > aahringo@redhat.com wrote on Mon, 13 Jun 2022 00:37:33 -0400:
> > =20
> > > Hi,
> > >
> > > I was wondering why nothing worked anymore. I found it...
> > >
> > > changes since v2:
> > >
> > >  - fix fixes tags in mac802154: util: fix release queue handling
> > >  - add patch mac802154: fix atomic_dec_and_test checks got somehow
> > >    confused 2 patch same issue =20
> >
> > I've got initially confused with your patchset but yes indeed the API
> > works the opposite way compared to my gut understanding.
> > =20
>=20
> not the first time I am seeing this, I fixed similar issues already at
> other places.
>=20
> btw I told you the right semantic at [0] ....

I focused on the if statement more than the actual syntax...

>=20
> > We bought hardware and I am currently setting up a real network to
> > hopefully track these regressions myself in the future.
> > =20
>=20
> I wonder why you don't use hwsim... and you already mentioned hwsim to
> me.

I do use hwsim but I was exclusively testing the mlme ops with it.

> You can simply make a 6lowpan interface on it and ping it - no
> hardware needed and this would already show issues...

Actually I just learnt about how to create 6lowpan interfaces and do
basic data exchanges, it's rather easy and straightforward, but I must
admit I was not familiar at all with this area and thought it would be
more complex... Indeed, hwsim would work just fine for this purpose,
I will add this to my checklist.

> Now you can say,
> why I do not test it... maybe I do next time but review takes longer
> then.

I'm not saying this at all :) It is my duty, not yours, reviews and
feedback are more than enough.

>=20
> - Alex
>=20
> [0] https://lore.kernel.org/linux-wpan/CAK-6q+jCYDQ-rtyawz1m2Yt+ti=3D3d6P=
rhZebB=3D-PjcX-6L-Kdg@mail.gmail.com/

Thanks,
Miqu=C3=A8l
