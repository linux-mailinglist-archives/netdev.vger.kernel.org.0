Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 431936186A1
	for <lists+netdev@lfdr.de>; Thu,  3 Nov 2022 18:52:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231778AbiKCRwR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Nov 2022 13:52:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59074 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231771AbiKCRwQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Nov 2022 13:52:16 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 13A2A1B1D1
        for <netdev@vger.kernel.org>; Thu,  3 Nov 2022 10:51:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1667497881;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=GQImf9Hv4afZMj4Qw1J//pdoitM4VAh9TDFkKqnfKCM=;
        b=OXRT+a2JJy/GgZ7WlUc2/Pt5N/FnU0XgZCSvp3M6Eob+pTsPYQ2qzA6piXgqIxNqDHmZNW
        5NVlgsxN/q95OwAN64wNyvo9Jb6kP7f2J4vBq6MzCDLzb2gtqU5GQffv7HzHLfU/q2LIGM
        8cOywZesJwYi88vJEt54/8MZOtdl4yg=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-271-QqpiePYmOri3ltpgSBVk-Q-1; Thu, 03 Nov 2022 13:51:15 -0400
X-MC-Unique: QqpiePYmOri3ltpgSBVk-Q-1
Received: by mail-wm1-f71.google.com with SMTP id v23-20020a1cf717000000b003bff630f31aso785643wmh.5
        for <netdev@vger.kernel.org>; Thu, 03 Nov 2022 10:51:15 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=GQImf9Hv4afZMj4Qw1J//pdoitM4VAh9TDFkKqnfKCM=;
        b=bgWJ/deTaoi/0hiAs4EbiMtXXEU097lwEhlKamYsk09CmsaaTeu9IWFqaBkWuexVih
         J6wuvpjKdpY8vowfxnkiw6TlA8/gUtHdmNSDEgLmOHoPuLG5tHFyslvv/Lxi1TaeCzjL
         6VjYpJYyjZIbeKkQb/ddqsnuq6yZj7c4J7gvov8sIXSIeCZtZWseUlYnsuFQBnIwKlp8
         FgUBdQni9tyvxaIqEeGRlRjyNwMQd3gRMYci9vKjLOMQPDVYN3bf1TFYVG3C9K5x8OQP
         uVVs8L6/QhJqL3ubgwtfKlgMwM7XYrRCKEh39L6hUfXbuz2rx/6ED4n6GNAhbpg8OZR/
         lojw==
X-Gm-Message-State: ACrzQf3Iqi3T8gwQLtbNdB7Ay8q/eO+nySILPLgqlMZ7ZYdAZydMEeVC
        1l+SpuEGiVRLtjhrdSMkU7Tx17ayn+xHBCVWA3YroP0jkvVxr6sBGnb7p/fTz0WChCNEM2FH5gO
        lujtzL00jNnHhBnDm
X-Received: by 2002:a5d:4887:0:b0:226:ed34:7bbd with SMTP id g7-20020a5d4887000000b00226ed347bbdmr19030768wrq.561.1667497874268;
        Thu, 03 Nov 2022 10:51:14 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM4BsszzoEjWalLkPkjB8Sz//22kVfpI+WgL/5sgLwheMUq1Uv7dUC02uIG/sfgg6LoymmGNFQ==
X-Received: by 2002:a5d:4887:0:b0:226:ed34:7bbd with SMTP id g7-20020a5d4887000000b00226ed347bbdmr19030750wrq.561.1667497873990;
        Thu, 03 Nov 2022 10:51:13 -0700 (PDT)
Received: from localhost (net-188-216-77-84.cust.vodafonedsl.it. [188.216.77.84])
        by smtp.gmail.com with ESMTPSA id n25-20020a7bc5d9000000b003c6c5a5a651sm523805wmk.28.2022.11.03.10.51.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Nov 2022 10:51:12 -0700 (PDT)
Date:   Thu, 3 Nov 2022 18:51:10 +0100
From:   Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To:     Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Cc:     Lorenzo Bianconi <lorenzo@kernel.org>, netdev@vger.kernel.org,
        nbd@nbd.name, john@phrozen.org, sean.wang@mediatek.com,
        Mark-MC.Lee@mediatek.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, matthias.bgg@gmail.com,
        linux-mediatek@lists.infradead.org, Bo.Jiao@mediatek.com,
        sujuan.chen@mediatek.com, ryder.Lee@mediatek.com,
        evelyn.tsai@mediatek.com, devicetree@vger.kernel.org,
        robh+dt@kernel.org, daniel@makrotopia.org,
        krzysztof.kozlowski+dt@linaro.org
Subject: Re: [PATCH v3 net-next 2/8] dt-bindings: net: mediatek: add WED RX
 binding for MT7986 eth driver
Message-ID: <Y2P/jq34IjyM2iXu@lore-desk>
References: <cover.1667466887.git.lorenzo@kernel.org>
 <2d92c3e282c6a788e54370604f966fc7a5b479bf.1667466887.git.lorenzo@kernel.org>
 <6d1bd86e-29f0-a3b2-700b-978d64990d56@linaro.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="CvIRv7FT2oWJS31l"
Content-Disposition: inline
In-Reply-To: <6d1bd86e-29f0-a3b2-700b-978d64990d56@linaro.org>
X-Spam-Status: No, score=-3.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--CvIRv7FT2oWJS31l
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

> On 03/11/2022 05:28, Lorenzo Bianconi wrote:
> > Document the binding for the RX Wireless Ethernet Dispatch core on the
> > MT7986 ethernet driver used to offload traffic received by WLAN NIC and
> > forwarded to LAN/WAN one.
> >=20
> > Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
> > ---
> >  .../arm/mediatek/mediatek,mt7622-wed.yaml     | 62 ++++++++++++++++++-
> >  .../arm/mediatek/mediatek,mt7986-wo-boot.yaml | 47 ++++++++++++++
> >  .../arm/mediatek/mediatek,mt7986-wo-ccif.yaml | 50 +++++++++++++++
> >  .../arm/mediatek/mediatek,mt7986-wo-dlm.yaml  | 50 +++++++++++++++
> >  4 files changed, 206 insertions(+), 3 deletions(-)
> >  create mode 100644 Documentation/devicetree/bindings/arm/mediatek/medi=
atek,mt7986-wo-boot.yaml
> >  create mode 100644 Documentation/devicetree/bindings/arm/mediatek/medi=
atek,mt7986-wo-ccif.yaml
> >  create mode 100644 Documentation/devicetree/bindings/arm/mediatek/medi=
atek,mt7986-wo-dlm.yaml
> >=20
> > diff --git a/Documentation/devicetree/bindings/arm/mediatek/mediatek,mt=
7622-wed.yaml b/Documentation/devicetree/bindings/arm/mediatek/mediatek,mt7=
622-wed.yaml
> > index 84fb0a146b6e..9e34c5d15cec 100644
> > --- a/Documentation/devicetree/bindings/arm/mediatek/mediatek,mt7622-we=
d.yaml
> > +++ b/Documentation/devicetree/bindings/arm/mediatek/mediatek,mt7622-we=
d.yaml
> > @@ -1,8 +1,8 @@
> >  # SPDX-License-Identifier: (GPL-2.0 OR BSD-2-Clause)
> >  %YAML 1.2
> >  ---
> > -$id: "http://devicetree.org/schemas/arm/mediatek/mediatek,mt7622-wed.y=
aml#"
> > -$schema: "http://devicetree.org/meta-schemas/core.yaml#"
> > +$id: http://devicetree.org/schemas/arm/mediatek/mediatek,mt7622-wed.ya=
ml#
> > +$schema: http://devicetree.org/meta-schemas/core.yaml#
>=20
> Split the cleanups from essential/functional changes.

ack, I will fix it in v4

>=20
> > =20
> >  title: MediaTek Wireless Ethernet Dispatch Controller for MT7622
> > =20
> > @@ -29,6 +29,50 @@ properties:
> >    interrupts:
> >      maxItems: 1
> > =20
> > +  memory-region:
> > +    items:
> > +      - description:
> > +          Phandle for the node used to run firmware EMI region
>=20
> Merge above two lines. Drop "phandle for the node used to run"

ack, I will fix it in v4

>=20
> > +      - description:
> > +          Phandle for the node used to run firmware ILM region
> > +      - description:
> > +          Phandle for the node used to run firmware CPU DATA region
> > +
> > +  memory-region-names:
> > +    items:
> > +      - const: wo-emi
> > +      - const: wo-ilm
> > +      - const: wo-data
> > +
> > +  mediatek,wo-ccif:
> > +    $ref: /schemas/types.yaml#/definitions/phandle
> > +    description:
> > +      Phandle to the mediatek wed-wo controller.
>=20
> Drop "Phandle to". Same in other cases.

ack, I will fix it in v4

>=20
> > +
> > +  mediatek,wo-boot:
> > +    $ref: /schemas/types.yaml#/definitions/phandle
> > +    description:
> > +      Phandle to the mediatek wed-wo boot interface.
> > +
> > +  mediatek,wo-dlm:
> > +    $ref: /schemas/types.yaml#/definitions/phandle
> > +    description:
> > +      Phandle to the mediatek wed-wo rx hw ring.
>=20
> rx->RX?
> hw->HW?

ack, I will fix it in v4

>=20
> > +
> > +allOf:
> > +  - if:
> > +      properties:
> > +        compatible:
> > +          contains:
> > +            const: mediatek,mt7622-wed
> > +    then:
> > +      properties:
> > +        memory-region-names: false
> > +        memory-region: false
> > +        mediatek,wo-boot: false
> > +        mediatek,wo-ccif: false
> > +        mediatek,wo-dlm: false
> > +
> >  required:
> >    - compatible
> >    - reg
> > @@ -44,8 +88,20 @@ examples:
> >        #address-cells =3D <2>;
> >        #size-cells =3D <2>;
> >        wed0: wed@1020a000 {
> > -        compatible =3D "mediatek,mt7622-wed","syscon";
> > +        compatible =3D "mediatek,mt7622-wed", "syscon";
> >          reg =3D <0 0x1020a000 0 0x1000>;
> >          interrupts =3D <GIC_SPI 214 IRQ_TYPE_LEVEL_LOW>;
> >        };
> > +
> > +      wed1: wed@15010000 {
>=20
> That's a separate example. - |
> Drop wed1 label.

ack, I will fix it in v4

>=20
> > +        compatible =3D "mediatek,mt7986-wed", "syscon";
>=20
> And where is the compatible added?
>=20
> > +        reg =3D <0 0x15010000 0 0x1000>;
> > +        interrupts =3D <GIC_SPI 205 IRQ_TYPE_LEVEL_HIGH>;
> > +
> > +        memory-region =3D <&wo_emi>, <&wo_data>, <&wo_ilm>;
> > +        memory-region-names =3D "wo-emi", "wo-ilm", "wo-data";
> > +        mediatek,wo-ccif =3D <&wo_ccif0>;
> > +        mediatek,wo-boot =3D <&wo_boot>;
> > +        mediatek,wo-dlm =3D <&wo_dlm0>;
> > +      };
> >      };
> > diff --git a/Documentation/devicetree/bindings/arm/mediatek/mediatek,mt=
7986-wo-boot.yaml b/Documentation/devicetree/bindings/arm/mediatek/mediatek=
,mt7986-wo-boot.yaml
> > new file mode 100644
> > index 000000000000..6c3c514c48ef
> > --- /dev/null
> > +++ b/Documentation/devicetree/bindings/arm/mediatek/mediatek,mt7986-wo=
-boot.yaml
>=20
> arm is only for top-level stuff. Choose appropriate subsystem, soc as
> last resort.

these chips are used only for networking so is net folder fine?

>=20
> > @@ -0,0 +1,47 @@
> > +# SPDX-License-Identifier: (GPL-2.0 OR BSD-2-Clause)
> > +%YAML 1.2
> > +---
> > +$id: http://devicetree.org/schemas/arm/mediatek/mediatek,mt7986-wo-boo=
t.yaml#
> > +$schema: http://devicetree.org/meta-schemas/core.yaml#
> > +
> > +title:
> > +  MediaTek Wireless Ethernet Dispatch WO boot controller interface for=
 MT7986
> > +
> > +maintainers:
> > +  - Lorenzo Bianconi <lorenzo@kernel.org>
> > +  - Felix Fietkau <nbd@nbd.name>
> > +
> > +description:
> > +  The mediatek wo-boot provides a configuration interface for WED WO
> > +  boot controller on MT7986 soc.
>=20
> And what is "WED WO boot controller?

WED WO is a chip used for networking packet processing offloaded to the Soc
(e.g. packet reordering). WED WO boot is the memory used to store start add=
ress
of wo firmware. Anyway I will let Sujuan comment on this.

>=20
> > +
> > +properties:
> > +  compatible:
> > +    items:
> > +      - enum:
> > +          - mediatek,mt7986-wo-boot
> > +      - const: syscon
> > +
> > +  reg:
> > +    maxItems: 1
> > +
> > +  interrupts:
> > +    maxItems: 1
> > +
> > +required:
> > +  - compatible
> > +  - reg
> > +
> > +additionalProperties: false
> > +
> > +examples:
> > +  - |
> > +    soc {
> > +      #address-cells =3D <2>;
> > +      #size-cells =3D <2>;
> > +
> > +      wo_boot: syscon@15194000 {
> > +        compatible =3D "mediatek,mt7986-wo-boot", "syscon";
> > +        reg =3D <0 0x15194000 0 0x1000>;
> > +      };
> > +    };
> > diff --git a/Documentation/devicetree/bindings/arm/mediatek/mediatek,mt=
7986-wo-ccif.yaml b/Documentation/devicetree/bindings/arm/mediatek/mediatek=
,mt7986-wo-ccif.yaml
> > new file mode 100644
> > index 000000000000..6357a206587a
> > --- /dev/null
> > +++ b/Documentation/devicetree/bindings/arm/mediatek/mediatek,mt7986-wo=
-ccif.yaml
> > @@ -0,0 +1,50 @@
> > +# SPDX-License-Identifier: (GPL-2.0 OR BSD-2-Clause)
> > +%YAML 1.2
> > +---
> > +$id: http://devicetree.org/schemas/arm/mediatek/mediatek,mt7986-wo-cci=
f.yaml#
> > +$schema: http://devicetree.org/meta-schemas/core.yaml#
> > +
> > +title: MediaTek Wireless Ethernet Dispatch WO controller interface for=
 MT7986
> > +
> > +maintainers:
> > +  - Lorenzo Bianconi <lorenzo@kernel.org>
> > +  - Felix Fietkau <nbd@nbd.name>
> > +
> > +description:
> > +  The mediatek wo-ccif provides a configuration interface for WED WO
> > +  controller on MT7986 soc.
>=20
> All previous comments apply.
>=20
> > +
> > +properties:
> > +  compatible:
> > +    items:
> > +      - enum:
> > +          - mediatek,mt7986-wo-ccif
> > +      - const: syscon
> > +
> > +  reg:
> > +    maxItems: 1
> > +
> > +  interrupts:
> > +    maxItems: 1
> > +
> > +required:
> > +  - compatible
> > +  - reg
> > +  - interrupts
> > +
> > +additionalProperties: false
> > +
> > +examples:
> > +  - |
> > +    #include <dt-bindings/interrupt-controller/arm-gic.h>
> > +    #include <dt-bindings/interrupt-controller/irq.h>
> > +    soc {
> > +      #address-cells =3D <2>;
> > +      #size-cells =3D <2>;
> > +
> > +      wo_ccif0: syscon@151a5000 {
> > +        compatible =3D "mediatek,mt7986-wo-ccif", "syscon";
> > +        reg =3D <0 0x151a5000 0 0x1000>;
> > +        interrupts =3D <GIC_SPI 205 IRQ_TYPE_LEVEL_HIGH>;
> > +      };
> > +    };
> > diff --git a/Documentation/devicetree/bindings/arm/mediatek/mediatek,mt=
7986-wo-dlm.yaml b/Documentation/devicetree/bindings/arm/mediatek/mediatek,=
mt7986-wo-dlm.yaml
> > new file mode 100644
> > index 000000000000..a499956d9e07
> > --- /dev/null
> > +++ b/Documentation/devicetree/bindings/arm/mediatek/mediatek,mt7986-wo=
-dlm.yaml
> > @@ -0,0 +1,50 @@
> > +# SPDX-License-Identifier: (GPL-2.0 OR BSD-2-Clause)
> > +%YAML 1.2
> > +---
> > +$id: http://devicetree.org/schemas/arm/mediatek/mediatek,mt7986-wo-dlm=
=2Eyaml#
> > +$schema: http://devicetree.org/meta-schemas/core.yaml#
> > +
> > +title: MediaTek Wireless Ethernet Dispatch WO hw rx ring interface for=
 MT7986
> > +
> > +maintainers:
> > +  - Lorenzo Bianconi <lorenzo@kernel.org>
> > +  - Felix Fietkau <nbd@nbd.name>
> > +
> > +description:
> > +  The mediatek wo-dlm provides a configuration interface for WED WO
> > +  rx ring on MT7986 soc.
> > +
> > +properties:
> > +  compatible:
> > +    const: mediatek,mt7986-wo-dlm
> > +
> > +  reg:
> > +    maxItems: 1
> > +
> > +  resets:
> > +    maxItems: 1
> > +
> > +  reset-names:
> > +    maxItems: 1
> > +
> > +required:
> > +  - compatible
> > +  - reg
> > +  - resets
> > +  - reset-names
> > +
> > +additionalProperties: false
> > +
> > +examples:
> > +  - |
> > +    soc {
> > +      #address-cells =3D <2>;
> > +      #size-cells =3D <2>;
> > +
> > +      wo_dlm0: wo-dlm@151e8000 {
>=20
> Node names should be generic.
> https://devicetree-specification.readthedocs.io/en/latest/chapter2-device=
tree-basics.html#generic-names-recommendation

DLM is a chip used to store the data rx ring of wo firmware. I do not have a
better node name (naming is always hard). Can you please suggest a better n=
ame?

Regards,
Lorenzo

>=20
>=20
> Best regards,
> Krzysztof
>=20

--CvIRv7FT2oWJS31l
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQTquNwa3Txd3rGGn7Y6cBh0uS2trAUCY2P/jgAKCRA6cBh0uS2t
rLpxAQCDCSba4V5YXMALehIXkI39A3vfHz3ilEmxvWH7zgmeUwEA4llv7tevkBsa
j5/EJ5CSj10Lyp+Kic3Gvk36FpvUBAM=
=bjKx
-----END PGP SIGNATURE-----

--CvIRv7FT2oWJS31l--

