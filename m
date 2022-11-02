Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0929B61653B
	for <lists+netdev@lfdr.de>; Wed,  2 Nov 2022 15:33:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229934AbiKBOdf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Nov 2022 10:33:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36636 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230487AbiKBOdd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Nov 2022 10:33:33 -0400
Received: from relay10.mail.gandi.net (relay10.mail.gandi.net [217.70.178.230])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B2B82A735;
        Wed,  2 Nov 2022 07:33:30 -0700 (PDT)
Received: (Authenticated sender: miquel.raynal@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id C169624000A;
        Wed,  2 Nov 2022 14:33:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1667399609;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ylD505SuiRTh12GS+d78SfZyuPJFm3TcRfpoXBv+HeQ=;
        b=fPzEfrAldPsEjv9RFEQ5+X7Erd1TbHXqsz6qz6gWNGAgSVON4mcA1pXTFKCIcHMc7Nu3dU
        tuv+tYzcVizxamIHs9t2OxH7cAoA8/S8omic3eZkUV821mjSXHZt2FbC1MW5j2oxoGD+pv
        ic6Ug+TZuSSd5kY/mtkhrPciWviMFNrZqux0o50oUxs9ubT3KeAEnCMwd8nB7G8cZb+FS0
        XTtaZrDFdSWXQpwGKiyq0P7MzNJoLlP24ivG3kK+VHOEJUgYbVDraWZoOzSah9o0bSesLg
        MXwnRvbbH+yk7kuid2Ma07J0ujzddWRQF5Xk4b4kkC+BRcbo1nvC3cGJTrdoKw==
Date:   Wed, 2 Nov 2022 15:33:23 +0100
From:   Miquel Raynal <miquel.raynal@bootlin.com>
To:     Michael Walle <michael@walle.cc>
Cc:     Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
        linux-kernel@vger.kernel.org, Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzk+dt@kernel.org>,
        devicetree@vger.kernel.org, Marcin Wojtas <mw@semihalf.com>,
        Russell King <linux@armlinux.org.uk>,
        Maxime Chevallier <maxime.chevallier@bootlin.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>, netdev@vger.kernel.org,
        Robert Marko <robert.marko@sartura.hr>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>
Subject: Re: [PATCH 5/5] net: mvpp2: Consider NVMEM cells as possible MAC
 address source
Message-ID: <20221102153323.7b7fc0a5@xps-13>
In-Reply-To: <30660579be1f7c964eafa825246916ac@walle.cc>
References: <20221028092337.822840-1-miquel.raynal@bootlin.com>
        <20221028092337.822840-6-miquel.raynal@bootlin.com>
        <30660579be1f7c964eafa825246916ac@walle.cc>
Organization: Bootlin
X-Mailer: Claws Mail 4.0.0 (GTK+ 3.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_PASS,URIBL_BLACK autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Michael,

michael@walle.cc wrote on Fri, 28 Oct 2022 15:33:31 +0200:

> Am 2022-10-28 11:23, schrieb Miquel Raynal:
> > The ONIE standard describes the organization of tlv (type-length-value)
> > arrays commonly stored within NVMEM devices on common networking
> > hardware.
> >=20
> > Several drivers already make use of NVMEM cells for purposes like
> > retrieving a default MAC address provided by the manufacturer.
> >=20
> > What made ONIE tables unusable so far was the fact that the information
> > where "dynamically" located within the table depending on the
> > manufacturer wishes, while Linux NVMEM support only allowed statically
> > defined NVMEM cells. Fortunately, this limitation was eventually > tack=
led
> > with the introduction of discoverable cells through the use of NVMEM
> > layouts, making it possible to extract and consistently use the content
> > of tables like ONIE's tlv arrays.
> >=20
> > Parsing this table at runtime in order to get various information is > =
now
> > possible. So, because many Marvell networking switches already follow
> > this standard, let's consider using NVMEM cells as a new valid source >=
 of
> > information when looking for a base MAC address, which is one of the
> > primary uses of these new fields. Indeed, manufacturers following the
> > ONIE standard are encouraged to provide a default MAC address there, so
> > let's eventually use it if no other MAC address has been found using > =
the
> > existing methods.
> >=20
> > Link: > https://opencomputeproject.github.io/onie/design-spec/hw_requir=
ements.html
> > Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
> > ---
> >=20
> > Hello, I suppose my change is safe but I don't want to break existing
> > setups so a review on this would be welcome!
> >=20
> >  drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c | 6 ++++++
> >  1 file changed, 6 insertions(+)
> >=20
> > diff --git a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
> > b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
> > index eb0fb8128096..7c8c323f4411 100644
> > --- a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
> > +++ b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
> > @@ -6104,6 +6104,12 @@ static void mvpp2_port_copy_mac_addr(struct
> > net_device *dev, struct mvpp2 *priv,
> >  		}
> >  	}
> >=20
> > +	if (!of_get_mac_address(to_of_node(fwnode), hw_mac_addr)) { =20
>=20
> Mh, the driver already does a fwnode_get_mac_address() which might
> fetch it from OF. But that variant doesn't try to get the mac address
> via nvmem; in contrast to the of_get_mac_address() variant which will
> also try NVMEM.
> Maybe it would be better to just use device_get_ethdev_address() and
> extend that one to also try the nvmem store. Just to align all the
> different variants to get a mac address.

Actually this choice was made on purpose: I am adding this method to
retrieve the MAC address only if no other way has succeeded. I don't
know if the MAC addresses are expected to remain stable over time, I
assumed it was somehow part of the ABI.

Using device_get_ethdev_address() with support for MAC addresses in
nvmem cells would possibly change the MAC address of many existing
devices after an update because we found a MAC address in the tlv table
before checking the device's own registers (as in this driver)

So I assumed it was better avoiding changing the MAC address providers
order in the probe...

Thanks,
Miqu=C3=A8l
