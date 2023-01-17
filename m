Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7523566DD2D
	for <lists+netdev@lfdr.de>; Tue, 17 Jan 2023 13:05:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236647AbjAQMFY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Jan 2023 07:05:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42368 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236485AbjAQMFX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Jan 2023 07:05:23 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B878A36B15
        for <netdev@vger.kernel.org>; Tue, 17 Jan 2023 04:04:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1673957076;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=EGd8Gv7zO6+RZus69tR/m6BH1nFkS1nUUO+DcJcAeOU=;
        b=gC6QjGVqUmmeV9ycolklps4r5JJ13egQSenoj2ZLO1gRnVecd65lzVUmnr0gxw5z7pnrib
        +7IEMoiZnz9uucxIiKE4a9hEpM6m2U2FSe2xF1h28yqpI3rmsGFbwILYDEgapJUxocvrE2
        t0cujwiLyJ3NMru1vM6nseIY0eLsSAc=
Received: from mail-yb1-f200.google.com (mail-yb1-f200.google.com
 [209.85.219.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-567-RVw27z3bNdi8Q74KRbeXWQ-1; Tue, 17 Jan 2023 07:04:35 -0500
X-MC-Unique: RVw27z3bNdi8Q74KRbeXWQ-1
Received: by mail-yb1-f200.google.com with SMTP id z17-20020a256651000000b007907852ca4dso33667350ybm.16
        for <netdev@vger.kernel.org>; Tue, 17 Jan 2023 04:04:35 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=EGd8Gv7zO6+RZus69tR/m6BH1nFkS1nUUO+DcJcAeOU=;
        b=g+Is/8mi7Go8Vpqo1a/KdtQJnBWeNYBsv9RKDtS9S36KXzw+AlNKiGNxqaqkKNxYpW
         zchJYT34G3QgT13NM5tA99BQpr6YlJa/skq21jKnvsParjV5Aw6HT0ESnl33XNgx6c7/
         13jU8/GyIQYHiA5i6i33xEBtlIoSr9DQzqletS0Y50XyH1KPb7lPPhWuBY8SBpoL76ac
         f/ol6yW4aBiJLFvsBVxankhiB5h7z/DJ4T8yFio+opmAnhsr9eA47tReNHTAWDZ5Op+9
         Tzyj1MXU6d84zT0C8knpnJ0vsRGnqdnNrSIlo+QJ9jZQ50L9rdk7OvOMJcvDK1jdZLS+
         4Kyg==
X-Gm-Message-State: AFqh2koK2QmBAaUTqBdyot213yAgTobDb28ubUrb4brT6CP7p2XJsAQ1
        yr6F0wG3OlS7jnfHMywt8oJsr5wWXKp6AXmn/+SViQ+Sc+vqPSrUK3eam6ULHNX9Q4LYMWvdwUw
        218G4X+W6ORvbBVil
X-Received: by 2002:a0d:ebc7:0:b0:4d2:df5d:4f8a with SMTP id u190-20020a0debc7000000b004d2df5d4f8amr2479246ywe.11.1673957074953;
        Tue, 17 Jan 2023 04:04:34 -0800 (PST)
X-Google-Smtp-Source: AMrXdXtHxspuMUbwpLPxkzC/BX7aJ3whS1J+KUFaZG4ER3Z2qEHdLvNUwS4DQIn2g/GbJHhFhtDxaQ==
X-Received: by 2002:a0d:ebc7:0:b0:4d2:df5d:4f8a with SMTP id u190-20020a0debc7000000b004d2df5d4f8amr2479226ywe.11.1673957074632;
        Tue, 17 Jan 2023 04:04:34 -0800 (PST)
Received: from gerbillo.redhat.com (146-241-115-179.dyn.eolo.it. [146.241.115.179])
        by smtp.gmail.com with ESMTPSA id bi27-20020a05620a319b00b00706a1551428sm634487qkb.6.2023.01.17.04.04.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Jan 2023 04:04:34 -0800 (PST)
Message-ID: <699f6ee109b3a72b2b377f42a78705f47d4a77b9.camel@redhat.com>
Subject: Re: [PATCH net-next] net: phy: meson-gxl: support more
 G12A-internal PHY versions
From:   Paolo Abeni <pabeni@redhat.com>
To:     Heiner Kallweit <hkallweit1@gmail.com>,
        Neil Armstrong <neil.armstrong@linaro.org>,
        Andrew Lunn <andrew@lunn.ch>
Cc:     Russell King - ARM Linux <linux@armlinux.org.uk>,
        David Miller <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Kevin Hilman <khilman@baylibre.com>,
        Jerome Brunet <jbrunet@baylibre.com>,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "open list:ARM/Amlogic Meson..." <linux-amlogic@lists.infradead.org>
Date:   Tue, 17 Jan 2023 13:04:30 +0100
In-Reply-To: <6de25c61-c187-fb88-5bd7-477b1db1510e@gmail.com>
References: <d75ef7df-a645-7fdd-491a-f89f70dbea01@gmail.com>
         <Y8Qwk5H8Yd7qiN0j@lunn.ch> <03ea260e-f03c-d9d7-6f5f-ff72836f5739@gmail.com>
         <51abd8ca-8172-edfa-1c18-b1e48231f316@linaro.org>
         <6de25c61-c187-fb88-5bd7-477b1db1510e@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.46.3 (3.46.3-1.fc37) 
MIME-Version: 1.0
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

On Sun, 2023-01-15 at 21:38 +0100, Heiner Kallweit wrote:
> On 15.01.2023 19:43, Neil Armstrong wrote:
> > Hi Heiner,
> >=20
> > Le 15/01/2023 =C3=A0 18:09, Heiner Kallweit a =C3=A9crit=C2=A0:
> > > On 15.01.2023 17:57, Andrew Lunn wrote:
> > > > On Sun, Jan 15, 2023 at 04:19:37PM +0100, Heiner Kallweit wrote:
> > > > > On my SC2-based system the genphy driver was used because the PHY
> > > > > identifies as 0x01803300. It works normal with the meson g12a
> > > > > driver after this change.
> > > > > Switch to PHY_ID_MATCH_MODEL to cover the different sub-versions.
> > > >=20
> > > > Hi Heiner
> > > >=20
> > > > Are there any datasheets for these devices? Anything which document=
s
> > > > the lower nibble really is a revision?
> > > >=20
> > > > I'm just trying to avoid future problems where we find it is actual=
ly
> > > > a different PHY, needs its own MATCH_EXACT entry, and then we find =
we
> > > > break devices using 0x01803302 which we had no idea exists, but got
> > > > covered by this change.
> > > >=20
> > > The SC2 platform inherited a lot from G12A, therefore it's plausible
> > > that it's the same PHY. Also the vendor driver for SC2 gives a hint
> > > as it has the following compatible for the PHY:
> > >=20
> > > compatible =3D "ethernet-phy-id0180.3301", "ethernet-phy-ieee802.3-c2=
2";
> > >=20
> > > But you're right, I can't say for sure as I don't have the datasheets=
.
> >=20
> > On G12A (& GXL), the PHY ID is set in the MDIO MUX registers,
> > please see:
> > https://elixir.bootlin.com/linux/latest/source/drivers/net/mdio/mdio-mu=
x-meson-g12a.c#L36
> >=20
> > So you should either add support for the PHY mux in SC2 or check
> > what is in the ETH_PHY_CNTL0 register.
> >=20
> Thanks for the hint. I just checked and reading back ETH_PHY_CNTL0 at the
> end of g12a_enable_internal_mdio() gives me the expected result of 0x3301=
0180.
> But still the PHY reports 3300.
> Even if I write some other random value to ETH_PHY_CNTL0, I get 0180/3300
> as PHY ID.
>=20
> For u-boot I found the following:
>=20
> https://github.com/khadas/u-boot/blob/khadas-vim4-r-64bit/drivers/net/phy=
/amlogic.c
>=20
> static struct phy_driver amlogic_internal_driver =3D {
> 	.name =3D "Meson GXL Internal PHY",
> 	.uid =3D 0x01803300,
> 	.mask =3D 0xfffffff0,
> 	.features =3D PHY_BASIC_FEATURES,
> 	.config =3D &meson_phy_config,
> 	.startup =3D &meson_aml_startup,
> 	.shutdown =3D &genphy_shutdown,
> };
>=20
> So it's the same PHY ID I'm seeing in Linux.
>=20
> My best guess is that the following is the case:
>=20
> The PHY compatible string in DT is the following in all cases:
> compatible =3D "ethernet-phy-id0180.3301", "ethernet-phy-ieee802.3-c22";
>=20
> Therefore id 0180/3301 is used even if the PHY reports something else.
> Means it doesn't matter which value you write to ETH_PHY_CNTL0.
>=20
> I reduced the compatible string to compatible =3D "ethernet-phy-ieee802.3=
-c22"
> and this resulted in the actual PHY ID being used.
> You could change the compatible in dts the same way for any g12a system
> and I assume you would get 0180/3300 too.
>=20
> Remaining question is why the value in ETH_PHY_CNTL0 is ignored.

I [mis?]read the above as we can't completely rule out Andrew's doubt,
as such marking this patch as changed requested.

Cheers,

Paolo

