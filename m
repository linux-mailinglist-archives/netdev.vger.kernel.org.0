Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 81CD750CBA7
	for <lists+netdev@lfdr.de>; Sat, 23 Apr 2022 17:19:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232536AbiDWPWC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 23 Apr 2022 11:22:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33522 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231865AbiDWPWB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 23 Apr 2022 11:22:01 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B75533A22;
        Sat, 23 Apr 2022 08:19:04 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D9EF96129D;
        Sat, 23 Apr 2022 15:19:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DFA4BC385A5;
        Sat, 23 Apr 2022 15:19:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1650727143;
        bh=hS6vEZ8V/9Ol1z7LqoToremx0bzUhHSfVzIKUsnXP74=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=JCbsVngf/6vdSkM+K2ZHc5EPuYfoKWEempL7dDynQSK25hJ7HPY7EatcNlzIl5Jts
         3qyuDjzF+6c0QJ48BTQJQy05JxkFdRhtOQMX8YBtMuGhDlV+AGRSVlIafg90stOMX8
         1iXKDBm5Xhq4yrmAWJqolAKuIaJvCIJn/qWB1iYnPASlvxYRf1unrszfUJVWwa4zfS
         5Fy/H34/tMOrzwCRx0GQyqW2EIu0qwtYfnB8kMj9fKhtmdLii7pWNEF4rlJUgJpmsj
         oG0fIT37gCFr7twXc7G5ZiC4jsqJQy3spuU/qiHHWUZTLZ+Vv2szowRdbU6+FFA/Jl
         uSltq4n01IZdg==
Date:   Sat, 23 Apr 2022 17:18:57 +0200
From:   Marek =?UTF-8?B?QmVow7pu?= <kabel@kernel.org>
To:     Nathan Rossi <nathan@nathanrossi.com>
Cc:     Andrew Lunn <andrew@lunn.ch>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Subject: Re: [PATCH 2/2] net: dsa: mv88e6xxx: Handle single-chip-address OF
 property
Message-ID: <20220423171857.3d731efb@thinkpad>
In-Reply-To: <CA+aJhH3EtAxAKy8orC-SU8UnagBCibF3dHXrp78zfjuAzj4vUg@mail.gmail.com>
References: <20220423131427.237160-1-nathan@nathanrossi.com>
        <20220423131427.237160-2-nathan@nathanrossi.com>
        <YmQIHWL4iTS5qVIz@lunn.ch>
        <CA+aJhH3EtAxAKy8orC-SU8UnagBCibF3dHXrp78zfjuAzj4vUg@mail.gmail.com>
X-Mailer: Claws Mail 3.18.0 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, 24 Apr 2022 00:41:22 +1000
Nathan Rossi <nathan@nathanrossi.com> wrote:

> On Sun, 24 Apr 2022 at 00:07, Andrew Lunn <andrew@lunn.ch> wrote:
> >
> > On Sat, Apr 23, 2022 at 01:14:27PM +0000, Nathan Rossi wrote: =20
> > > Handle the parsing and use of single chip addressing when the switch =
has
> > > the single-chip-address property defined. This allows for specifying =
the
> > > switch as using single chip addressing even when mdio address 0 is us=
ed
> > > by another device on the bus. This is a feature of some switches (e.g.
> > > the MV88E6341/MV88E6141) where the switch shares the bus only respond=
ing
> > > to the higher 16 addresses. =20
> >
> > Hi Nathan
> >
> > I think i'm missing something in this explanation:
> >
> > smi.c says:
> >
> > /* The switch ADDR[4:1] configuration pins define the chip SMI device a=
ddress
> >  * (ADDR[0] is always zero, thus only even SMI addresses can be strappe=
d).
> >  *
> >  * When ADDR is all zero, the chip uses Single-chip Addressing Mode, as=
suming it
> >  * is the only device connected to the SMI master. In this mode it resp=
onds to
> >  * all 32 possible SMI addresses, and thus maps directly the internal d=
evices.
> >  *
> >  * When ADDR is non-zero, the chip uses Multi-chip Addressing Mode, all=
owing
> >  * multiple devices to share the SMI interface. In this mode it respond=
s to only
> >  * 2 registers, used to indirectly access the internal SMI devices.
> >  *
> >  * Some chips use a different scheme: Only the ADDR4 pin is used for
> >  * configuration, and the device responds to 16 of the 32 SMI
> >  * addresses, allowing two to coexist on the same SMI interface.
> >  */
> >
> > So if ADDR =3D 0, it takes up the whole bus. And in this case reg =3D 0.
> > If ADDR !=3D 0, it is in multi chip mode, and DT reg =3D ADDR.
> >
> > int mv88e6xxx_smi_init(struct mv88e6xxx_chip *chip,
> >                        struct mii_bus *bus, int sw_addr)
> > {
> >         if (chip->info->dual_chip)
> >                 chip->smi_ops =3D &mv88e6xxx_smi_dual_direct_ops;
> >         else if (sw_addr =3D=3D 0)
> >                 chip->smi_ops =3D &mv88e6xxx_smi_direct_ops;
> >         else if (chip->info->multi_chip)
> >                 chip->smi_ops =3D &mv88e6xxx_smi_indirect_ops;
> >         else
> >                 return -EINVAL;
> >
> > This seems to implement what is above. smi_direct_ops =3D=3D whole bus,
> > smi_indirect_ops =3D=3D multi-chip mode.
> >
> > In what situation do you see this not working? What device are you
> > using, what does you DT look like, and what at the ADDR value? =20
>=20
> The device I am using is the MV88E6141, it follows the second scheme
> such that it only responds to the upper 16 of the 32 SMI addresses in
> single chip addressing mode. I am able to define the switch at address
> 0, and everything works. However in the device I am using (Netgate
> SG-3100) the ethernet phys for the non switch ethernet interfaces are
> also on the same mdio bus as the switch. One of those phys is
> configured with address 0. Defining both the ethernet-phy and switch
> as address 0 does not work.

This makes the need of new property reasonable. You can add my

Acked-by: Marek Beh=C3=BAn <kabel@kernel.org>
