Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 990EE6D9202
	for <lists+netdev@lfdr.de>; Thu,  6 Apr 2023 10:51:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235911AbjDFIv5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Apr 2023 04:51:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37034 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235883AbjDFIvr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Apr 2023 04:51:47 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4CF9B4EE2
        for <netdev@vger.kernel.org>; Thu,  6 Apr 2023 01:51:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1680771060;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=W1Bdx/wsQfRAwIInAabAl9Jx8i29x6dlAdIxMNIdY9w=;
        b=D+bJgOZCRTg/iJX67fgU+KIIdNrNmFGhgdV9v/Z19n9jvvrZw0Pb0YhbIEn+VggqMc8NGg
        VjcVpa+fn+AxNzWaxMmfop12qLNCbV3cqF4z39cUxyCWcdFIFFHvCeu/9vwVllNFmPHhed
        O3r/H8wk8IiOOhPS44ubUNskewfrl0c=
Received: from mail-qt1-f199.google.com (mail-qt1-f199.google.com
 [209.85.160.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-577-ODX7MRDYO5y7UBzP0Ot2cA-1; Thu, 06 Apr 2023 04:50:59 -0400
X-MC-Unique: ODX7MRDYO5y7UBzP0Ot2cA-1
Received: by mail-qt1-f199.google.com with SMTP id d75a77b69052e-3e2daffa0d4so13699761cf.0
        for <netdev@vger.kernel.org>; Thu, 06 Apr 2023 01:50:59 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680771059;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=W1Bdx/wsQfRAwIInAabAl9Jx8i29x6dlAdIxMNIdY9w=;
        b=uA54mQaKah9DIkhk9PISlY3lIEIMRwG4lKkSw8eudblGRJwNeZhxVoX/77w6QSoppB
         knnGKL8shzU6SwW9cWrMh7DgmuIZuvY+qUyB8OSnARDE5NwZzcADCBdZdNsfx9iUk8pg
         sCE4ktoItS4xAi2m4Y2e/ZT69SYtWStCl5X2/7o0RZZTuYI5Cok0HhtBXZCA3nfEuK+c
         e6RZD5Uc10wzRJpBEpXzLhJv54bZDGx5fynYAEcbNXKyl5r6ArQwf4yOKc0QqhBaqStb
         m37UuI051a89bB2ZE1rIjQt3ZnzULtusbvXcXIWnt0Ghz38+Xm8Ybm8AXp0G7AknBC0K
         vtSA==
X-Gm-Message-State: AAQBX9epryZ8R1F7UuNSFfHTZGUgfTJCLU6oy2p1iZ3VTCmmhvp+2Cbs
        HOULXFKdlHFmqNrgV3FGRw0IGcIFp8k7bn7b8HLqaScN3Y7JjzrB2uQ7DcyLGlAPWXc9Q/NbTLP
        LRw1qTlyN6EKqZknv
X-Received: by 2002:a05:622a:1a24:b0:3e6:707e:d3c2 with SMTP id f36-20020a05622a1a2400b003e6707ed3c2mr10814501qtb.0.1680771059054;
        Thu, 06 Apr 2023 01:50:59 -0700 (PDT)
X-Google-Smtp-Source: AKy350bo5VqIhFeRZZcRwVCtgs8cYkmbupz1mYsttbY1gkrcv9BmYYkg1QFtxoLmxwuXn4DxKkvkSg==
X-Received: by 2002:a05:622a:1a24:b0:3e6:707e:d3c2 with SMTP id f36-20020a05622a1a2400b003e6707ed3c2mr10814489qtb.0.1680771058733;
        Thu, 06 Apr 2023 01:50:58 -0700 (PDT)
Received: from gerbillo.redhat.com (146-241-227-151.dyn.eolo.it. [146.241.227.151])
        by smtp.gmail.com with ESMTPSA id p15-20020a37420f000000b00749fc742ab4sm327473qka.7.2023.04.06.01.50.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 06 Apr 2023 01:50:58 -0700 (PDT)
Message-ID: <17cb566ef79342f77b50ad999e9fa910be4cb27f.camel@redhat.com>
Subject: Re: [PATCH v2 net-next 06/10] dt-bindings: soc: mediatek: move ilm
 in a dedicated dts node
From:   Paolo Abeni <pabeni@redhat.com>
To:     krzysztof.kozlowski+dt@linaro.org, robh+dt@kernel.org
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        matthias.bgg@gmail.com, linux-mediatek@lists.infradead.org,
        nbd@nbd.name, john@phrozen.org, sean.wang@mediatek.com,
        Mark-MC.Lee@mediatek.com, lorenzo.bianconi@redhat.com,
        daniel@makrotopia.org, devicetree@vger.kernel.org,
        Lorenzo Bianconi <lorenzo@kernel.org>, netdev@vger.kernel.org
Date:   Thu, 06 Apr 2023 10:50:54 +0200
In-Reply-To: <18109725ba14d2fe5c00e627b064b38b5c8f2223.1680268101.git.lorenzo@kernel.org>
References: <cover.1680268101.git.lorenzo@kernel.org>
         <18109725ba14d2fe5c00e627b064b38b5c8f2223.1680268101.git.lorenzo@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.46.4 (3.46.4-1.fc37) 
MIME-Version: 1.0
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 2023-03-31 at 15:12 +0200, Lorenzo Bianconi wrote:
> Since the ilm memory region is not part of the MT7986 RAM SoC, move ilm
> in a deidicated syscon node.
>=20
> Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
> ---
>  .../arm/mediatek/mediatek,mt7622-wed.yaml     | 14 +++---
>  .../soc/mediatek/mediatek,mt7986-wo-ilm.yaml  | 45 +++++++++++++++++++
>  2 files changed, 53 insertions(+), 6 deletions(-)
>  create mode 100644 Documentation/devicetree/bindings/soc/mediatek/mediat=
ek,mt7986-wo-ilm.yaml
>=20
> diff --git a/Documentation/devicetree/bindings/arm/mediatek/mediatek,mt76=
22-wed.yaml b/Documentation/devicetree/bindings/arm/mediatek/mediatek,mt762=
2-wed.yaml
> index 7f6638d43854..e63fb22447c6 100644
> --- a/Documentation/devicetree/bindings/arm/mediatek/mediatek,mt7622-wed.=
yaml
> +++ b/Documentation/devicetree/bindings/arm/mediatek/mediatek,mt7622-wed.=
yaml
> @@ -32,14 +32,12 @@ properties:
>    memory-region:
>      items:
>        - description: firmware EMI region
> -      - description: firmware ILM region
>        - description: firmware DLM region
>        - description: firmware CPU DATA region
> =20
>    memory-region-names:
>      items:
>        - const: wo-emi
> -      - const: wo-ilm
>        - const: wo-dlm
>        - const: wo-data
> =20
> @@ -51,6 +49,10 @@ properties:
>      $ref: /schemas/types.yaml#/definitions/phandle
>      description: mediatek wed-wo cpuboot controller interface.
> =20
> +  mediatek,wo-ilm:
> +    $ref: /schemas/types.yaml#/definitions/phandle
> +    description: mediatek wed-wo ilm interface.
> +
>  allOf:
>    - if:
>        properties:
> @@ -63,6 +65,7 @@ allOf:
>          memory-region: false
>          mediatek,wo-ccif: false
>          mediatek,wo-cpuboot: false
> +        mediatek,wo-ilm: false
> =20
>  required:
>    - compatible
> @@ -97,11 +100,10 @@ examples:
>          reg =3D <0 0x15010000 0 0x1000>;
>          interrupts =3D <GIC_SPI 205 IRQ_TYPE_LEVEL_HIGH>;
> =20
> -        memory-region =3D <&wo_emi>, <&wo_ilm>, <&wo_dlm>,
> -                        <&wo_data>;
> -        memory-region-names =3D "wo-emi", "wo-ilm", "wo-dlm",
> -                              "wo-data";
> +        memory-region =3D <&wo_emi>, <&wo_dlm>, <&wo_data>;
> +        memory-region-names =3D "wo-emi", "wo-dlm", "wo-data";
>          mediatek,wo-ccif =3D <&wo_ccif0>;
>          mediatek,wo-cpuboot =3D <&wo_cpuboot>;
> +        mediatek,wo-ilm =3D <&wo_ilm>;
>        };
>      };
> diff --git a/Documentation/devicetree/bindings/soc/mediatek/mediatek,mt79=
86-wo-ilm.yaml b/Documentation/devicetree/bindings/soc/mediatek/mediatek,mt=
7986-wo-ilm.yaml
> new file mode 100644
> index 000000000000..2a3775cd941e
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/soc/mediatek/mediatek,mt7986-wo-i=
lm.yaml
> @@ -0,0 +1,45 @@
> +# SPDX-License-Identifier: (GPL-2.0 OR BSD-2-Clause)
> +%YAML 1.2
> +---
> +$id: http://devicetree.org/schemas/soc/mediatek/mediatek,mt7986-wo-ilm.y=
aml#
> +$schema: http://devicetree.org/meta-schemas/core.yaml#
> +
> +title: MediaTek Wireless Ethernet Dispatch (WED) WO ILM firmware interfa=
ce for MT7986
> +
> +maintainers:
> +  - Lorenzo Bianconi <lorenzo@kernel.org>
> +  - Felix Fietkau <nbd@nbd.name>
> +
> +description:
> +  The MediaTek wo-ilm (Information Lifecycle Management) provides a conf=
iguration
> +  interface for WiFi critical data used by WED WO firmware. WED WO contr=
oller is
> +  used to perform offload rx packet processing (e.g. 802.11 aggregation =
packet
> +  reordering or rx header translation) on MT7986 soc.
> +
> +properties:
> +  compatible:
> +    items:
> +      - enum:
> +          - mediatek,mt7986-wo-ilm
> +      - const: syscon
> +
> +  reg:
> +    maxItems: 1
> +
> +required:
> +  - compatible
> +  - reg
> +
> +additionalProperties: false
> +
> +examples:
> +  - |
> +    soc {
> +      #address-cells =3D <2>;
> +      #size-cells =3D <2>;
> +
> +      syscon@151e0000 {
> +        compatible =3D "mediatek,mt7986-wo-ilm", "syscon";
> +        reg =3D <0 0x151e0000 0 0x8000>;
> +      };
> +    };

Hi Rob,

it's not clear to me if this version and Lorenzo's replies on the
previous one address your doubts here. Do you have any further
comments?

Thanks,

Paolo

