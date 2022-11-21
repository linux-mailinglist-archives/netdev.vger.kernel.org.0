Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8E71C631CDA
	for <lists+netdev@lfdr.de>; Mon, 21 Nov 2022 10:29:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229808AbiKUJ3i (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Nov 2022 04:29:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42912 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229650AbiKUJ3h (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Nov 2022 04:29:37 -0500
Received: from relay5-d.mail.gandi.net (relay5-d.mail.gandi.net [IPv6:2001:4b98:dc4:8::225])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 36B6D26139;
        Mon, 21 Nov 2022 01:29:35 -0800 (PST)
Received: (Authenticated sender: miquel.raynal@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id C20D01C0006;
        Mon, 21 Nov 2022 09:29:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1669022973;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=c/Vnj6MPjUKIBDRhrj8ixFI/juf2n4PkKcGC0BhMOmA=;
        b=ngrxWGtv0zVvk4sWmRJqaVEY8vjSErYieuuHoJBEcDxkLetxG+O/372w40aGiHEMcU8fHB
        tlncjX8G3cA/+qA95MCrxOpGbYpidkbdQltOZudwxNpYEnjU/OAz0Y/6RTZwylvVsaRPAq
        C3QVw196EX0DWK4OzNMFyMTzuSaGLIavSVq/1l8Xh5dAnE1+JW/nA/KLtDDunhamMXfKwM
        Cp4UkZ/59bsZp5BLHgtBKlxoDVTMbZnNmKXAAeUS2x/zq79tIesKT1IgsF74defA3WedcU
        A47FXXAxSRK1Zqnz9jjOCGk/iIHKjHfBGG3I5ENDFFKMcbDoTqNWieTKv6/U7w==
Date:   Mon, 21 Nov 2022 10:29:28 +0100
From:   Miquel Raynal <miquel.raynal@bootlin.com>
To:     Marcin Wojtas <mw@semihalf.com>
Cc:     Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzk+dt@kernel.org>,
        devicetree@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>, netdev@vger.kernel.org,
        Russell King <linux@armlinux.org.uk>,
        Taras Chornyi <tchornyi@marvell.com>,
        linux-kernel@vger.kernel.org,
        Robert Marko <robert.marko@sartura.hr>,
        Luka Perkov <luka.perkov@sartura.hr>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Michael Walle <michael@walle.cc>
Subject: Re: [PATCH net-next 6/6] net: mvpp2: Consider NVMEM cells as
 possible MAC address source
Message-ID: <20221121102928.7b190296@xps-13>
In-Reply-To: <CAPv3WKdZ+tsW-jRJt_n=KqT+oEe+5QAEFOWKrXsTjHCBBzEh0A@mail.gmail.com>
References: <20221117215557.1277033-1-miquel.raynal@bootlin.com>
        <20221117215557.1277033-7-miquel.raynal@bootlin.com>
        <CAPv3WKdZ+tsW-jRJt_n=KqT+oEe+5QAEFOWKrXsTjHCBBzEh0A@mail.gmail.com>
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

Hi Marcin,

mw@semihalf.com wrote on Sat, 19 Nov 2022 09:18:34 +0100:

> Hi Miquel,
>=20
>=20
> czw., 17 lis 2022 o 22:56 Miquel Raynal <miquel.raynal@bootlin.com> napis=
a=C5=82(a):
> >
> > The ONIE standard describes the organization of tlv (type-length-value)
> > arrays commonly stored within NVMEM devices on common networking
> > hardware.
> >
> > Several drivers already make use of NVMEM cells for purposes like
> > retrieving a default MAC address provided by the manufacturer.
> >
> > What made ONIE tables unusable so far was the fact that the information
> > where "dynamically" located within the table depending on the
> > manufacturer wishes, while Linux NVMEM support only allowed statically
> > defined NVMEM cells. Fortunately, this limitation was eventually tackled
> > with the introduction of discoverable cells through the use of NVMEM
> > layouts, making it possible to extract and consistently use the content
> > of tables like ONIE's tlv arrays.
> >
> > Parsing this table at runtime in order to get various information is now
> > possible. So, because many Marvell networking switches already follow
> > this standard, let's consider using NVMEM cells as a new valid source of
> > information when looking for a base MAC address, which is one of the
> > primary uses of these new fields. Indeed, manufacturers following the
> > ONIE standard are encouraged to provide a default MAC address there, so
> > let's eventually use it if no other MAC address has been found using the
> > existing methods.
> >
> > Link: https://opencomputeproject.github.io/onie/design-spec/hw_requirem=
ents.html =20
>=20
> Thanks for the patch. Did you manage to test in on a real HW? I am curiou=
s about

Yes, I have a Replica switch on which the commercial ports use the
replica PCI IP while the config "OOB" port is running with mvpp2:
[   16.737759] mvpp2 f2000000.ethernet eth52: Using nvmem cell mac address =
18:be:92:13:9a:00

> > Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
> > ---
> >  drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c | 6 ++++++
> >  1 file changed, 6 insertions(+)
> >
> > diff --git a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c b/drivers/=
net/ethernet/marvell/mvpp2/mvpp2_main.c
> > index eb0fb8128096..7c8c323f4411 100644
> > --- a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
> > +++ b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
> > @@ -6104,6 +6104,12 @@ static void mvpp2_port_copy_mac_addr(struct net_=
device *dev, struct mvpp2 *priv,
> >                 }
> >         }
> >
> > +       if (!of_get_mac_address(to_of_node(fwnode), hw_mac_addr)) { =20
>=20
> Unfortunately, nvmem cells seem to be not supported with ACPI yet, so
> we cannot extend fwnode_get_mac_address - I think it should be,
> however, an end solution.

Agreed.

> As of now, I'd prefer to use of_get_mac_addr_nvmem directly, to avoid
> parsing the DT again (after fwnode_get_mac_address) and relying
> implicitly on falling back to nvmem stuff (currently, without any
> comment it is not obvious).

I did not do that in the first place because of_get_mac_addr_nvmem()
was not exported, but I agree it would be the cleanest (and quickest)
approach, so I'll attempt to export the function first, and then use it
directly from the driver.

> Best regards,
> Marcin
>=20
> > +               *mac_from =3D "nvmem cell";
> > +               eth_hw_addr_set(dev, hw_mac_addr);
> > +               return;
> > +       }
> > +
> >         *mac_from =3D "random";
> >         eth_hw_addr_random(dev);
> >  }
> > --
> > 2.34.1
> > =20

Thanks a lot,
Miqu=C3=A8l
