Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CA9D85B8072
	for <lists+netdev@lfdr.de>; Wed, 14 Sep 2022 07:01:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229546AbiINFBh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Sep 2022 01:01:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50620 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229437AbiINFBf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Sep 2022 01:01:35 -0400
Received: from JPN01-OS0-obe.outbound.protection.outlook.com (mail-os0jpn01on2101.outbound.protection.outlook.com [40.107.113.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1180D67CA0;
        Tue, 13 Sep 2022 22:01:33 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lvFQog7hD0LIQC9pKZ+e3eT8ff3ipAFfHGHdTGq4EnMGWOIWCaFGSUrVH4Z6EY3e2f7fU1VgOQwMzrIhFcw+35dlmY3K5O8TP7mP56E7JwWrhq4H3tBp0D7k9xc4jqqp3PyuD/0dP3bOhq1uY5XC8HHlyMXoHliqtEBlj+kLFFX4506GiH7jstE3pxxOOrll/ZxSINfh/GQkNEK5lwGh7JH4jyX/LADbcBQwkjNwh/hoCh2pbAMu9KUe5CT4dfks17EStnElSkyJAa3NVaWL4QmKngAz4Iw1iKNWW7l85cm99KlesRaVWdyrrf1Lb0LYhUNYL0SAXWpb3PckK8C6RA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=KcNOCBxSPcoh8FaVsD5rmKLidsSYDYu7G3ENwNTYqog=;
 b=Vb/xFqPgY7apcfU70i3edj2aFP7RInXUEij5Y8rP124aul2CAjg0Zw171Ep3PSZiv1VW32/wwePHOoYCMQmiU0jkZNAMg2Qod05Q40KOpbZavYzjEFl6sSzxk/5TnNs5M2OwVafcEt/74MUNogNNo5Tydpay4UPzx/jHe69L+FnMboLb+T0MYpBHLMeYI5XRUGV1wjVjTk2dAelIXgO226FjpBvwyp4Ken7+H4UXxADFJskFPTaCuNv9FXrOR6wZidSKsXWyL0WvsgK9YOh3dz2LfBp8v9EcvhcyHckYsygMFJwIR2rSsQdJLpSO6ZX7ufnyhJkKyG4vu3xyg/xEtA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=renesas.com; dmarc=pass action=none header.from=renesas.com;
 dkim=pass header.d=renesas.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=renesas.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KcNOCBxSPcoh8FaVsD5rmKLidsSYDYu7G3ENwNTYqog=;
 b=T2eOEKKmmQvxM8zyhnQIkHUYIS5xDh+c/UDcN7uTP5oX1uCzh/Vv7DNjhf4OlCHubqTSsVp4PQjYHnm1xkjIVRwyoWn/xn/COwCWLXFEs7nyYyJ8XeGrekTVtb7iOYE0kfaZxI61vGZhFM8u4c36lByLcR8v9VBGOvVnoL6JufI=
Received: from TYBPR01MB5341.jpnprd01.prod.outlook.com
 (2603:1096:404:8028::13) by TY3PR01MB10596.jpnprd01.prod.outlook.com
 (2603:1096:400:318::10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5612.12; Wed, 14 Sep
 2022 05:01:30 +0000
Received: from TYBPR01MB5341.jpnprd01.prod.outlook.com
 ([fe80::194:78eb:38cf:d6db]) by TYBPR01MB5341.jpnprd01.prod.outlook.com
 ([fe80::194:78eb:38cf:d6db%4]) with mapi id 15.20.5612.022; Wed, 14 Sep 2022
 05:01:30 +0000
From:   Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
To:     Rob Herring <robh@kernel.org>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "edumazet@google.com" <edumazet@google.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "krzysztof.kozlowski+dt@linaro.org" 
        <krzysztof.kozlowski+dt@linaro.org>,
        "geert+renesas@glider.be" <geert+renesas@glider.be>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-renesas-soc@vger.kernel.org" 
        <linux-renesas-soc@vger.kernel.org>
Subject: RE: [PATCH 2/5] dt-bindings: net: renesas: Document Renesas Ethernet
 Switch
Thread-Topic: [PATCH 2/5] dt-bindings: net: renesas: Document Renesas Ethernet
 Switch
Thread-Index: AQHYxE/JYHnObnoZ8E2hxqzBhga8oq3dWZKAgAEIb0A=
Date:   Wed, 14 Sep 2022 05:01:30 +0000
Message-ID: <TYBPR01MB5341C874D8F2FB7702426D15D8469@TYBPR01MB5341.jpnprd01.prod.outlook.com>
References: <20220909132614.1967276-1-yoshihiro.shimoda.uh@renesas.com>
 <20220909132614.1967276-3-yoshihiro.shimoda.uh@renesas.com>
 <20220913130237.GA3475975-robh@kernel.org>
In-Reply-To: <20220913130237.GA3475975-robh@kernel.org>
Accept-Language: ja-JP, en-US
Content-Language: ja-JP
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=renesas.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: TYBPR01MB5341:EE_|TY3PR01MB10596:EE_
x-ms-office365-filtering-correlation-id: e5ebf08d-e519-434b-013b-08da960e302d
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: kpZvh+F21R7oCDdCnlbozFvBvSaTUpKTNZwbfUop25Qm6LAB6a2DQRq3qtenjfqA7DIrN3eXJvJXecrPjeYAchogxEpjrI8hBLkvAfFD5gI27lWk9Id3MZ1hQMCoUjy/EQCPo2Fbh/vAdjoX6Q1FxDUmVTFoHYx8fr4wuZBiP4/yeYH7eD2fagpiuVoSjTwNH65MnyIuFC5yzORIDqSNwiTYy4zOj5fVqSZGUxcC/9HO6oX7+L8zUw3U3UfgEC9ZT19XqKRtQjAoySH5S1SvC9WIW+TomFxyfSaZAUfVoc4zqjzDcPDSqL+4iUiGy0YE+N6aQOVI684WnYJa34wIfxstA66LrCjyYb3wS1I2i7AWMSDblAEz5fqARoe1kIi7Xl/UvHzxcAealUeFFqh5DpwJXfodXjLhayt6dYs//XLsjrbf7axTG2lM6lC7Gk/TqFscic7PjbzA8SqdRWNRzSGPL9GIfV7HhtT1QzEBAOtfKR0/ZjmlLcAk4K56OlVTQMddy3nrqRuj+uSW+GiD567zzYoL/x2ISaQuEfuTXOoLSy6n1QomHkimxUbnJK2PwAabIsAyhJvQORNHzYEpv1XioS3OAtI96U+Gk67qmJuriU5NhEHc1gknWUZRuu6/sA/e7PPRObydIbPh/zk8Mku353jlB+3eNTcJ+20KEqCUk5Epoh1LizBFxkKrSsOQC0jbqkFxFzKbwanPJyGoXz6iQOnoKmojkbigWrvXrjNBzXvdjzpbpIF2Rij97iljaVweijxbDAjVvX6313jhEg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:TYBPR01MB5341.jpnprd01.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(136003)(376002)(39860400002)(366004)(396003)(346002)(451199015)(6506007)(6916009)(122000001)(316002)(5660300002)(66476007)(38100700002)(76116006)(71200400001)(186003)(7696005)(33656002)(478600001)(41300700001)(8676002)(54906003)(4326008)(7416002)(83380400001)(86362001)(66556008)(55016003)(64756008)(2906002)(66446008)(38070700005)(9686003)(8936002)(66946007)(52536014);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?zp9lgqER/bpq9o5qMXbH2WYSCjrqP074fsWdo5X4DZg0TRiQs5gu/o6yFKLy?=
 =?us-ascii?Q?EWGEcOnHee7uLsM38mvvo1lrRsyh79jkdbq2bN5UGXqEJnRaVmcIifUg6KvI?=
 =?us-ascii?Q?DtHXb79J/pTKtjnJ5XyJ2kr4AMdbwXVXWymBUexPEcq4IwKIOdvQYgG0jeo6?=
 =?us-ascii?Q?euo+RFyMqSbaFhbB/fNb0WZZzsAQZes8TK+0MNtOdwpN9CWQQNAfjID23FyO?=
 =?us-ascii?Q?VFw8fXQ0axRvfH/019U8nh8sllMFqKIpReohe/nwl5E0LlwOCjGUdDEJIoEk?=
 =?us-ascii?Q?L62v/A+zIS6DfA8oBgbgbZlPdaNUz09zV0U8X8TwMINibP8QUNCY+aQ0/xLd?=
 =?us-ascii?Q?X3+BsbafEC+naaecA/W6Uv6wi8Hw1a6JBB+fBK8DhyE6ywGuemTeCzTecMoj?=
 =?us-ascii?Q?fh7EFu9psqBRsoUTxnanNBl608sfK3bs1B4G79Yg0tdViA//0kqGLEsPrYiR?=
 =?us-ascii?Q?yphb3+rUKbyDzEX7FGOCix0ASjqIFywn3YGdBD8aseJVJvBQ9BAkrnV4ucNe?=
 =?us-ascii?Q?3w5xLq9ZWO8JCv4M1mU5CYm9YjtWldbTsasiecLNV4AkBGzO1kcxtmvmVj0l?=
 =?us-ascii?Q?pWraR48CMHBjXlFKy3qZXZCpFzATf3RunCM2ZICFhDWyyRzqiv1OdqxL9sG7?=
 =?us-ascii?Q?jOcpf7rjD34Oz8etbiByKNS+Ax1CUVHpYB6fTfZI0ZCE1nNEQTANaQgCyomq?=
 =?us-ascii?Q?epNdPXT7M7wCqTWzhXm6WyVyYrchzb8S+WH5UOfzlV4csOIUUqzDsydRSaew?=
 =?us-ascii?Q?YryDSPwRLbT/dkLp5h43iguMpuk2p+QC70pPlXCAD2su2OTyVy/gs/9Pf+Z8?=
 =?us-ascii?Q?Sx0FnEVGSKCdw+A+Z0hK13Df3Cn4KRCnf7iB39QXsYXo5cL8L8yvYjQyr/MK?=
 =?us-ascii?Q?7yD1Vpei1HcgAkmtd9hDGZuwEfAs2TLG1TCqMn4p5VTRZWsCaWTwrq+EPhwn?=
 =?us-ascii?Q?qT3+tX8rxjUkamCBk/47YncHu5xGc6l4NUe/ksGt11TQTIsYFK3FpbVvC8YT?=
 =?us-ascii?Q?/FdnkQ8m6UyqTw5OcnPaJWwtfRirf3nqKu10sdAwX3UpSxtmvMLCZ431WMLc?=
 =?us-ascii?Q?65TDq8568sXOwCl7E1AUgL6atGSEn8C2OWjWuOIA2actTDoruYxs8vOEhzK+?=
 =?us-ascii?Q?eh4If6rQe24MG91eCDfRhzLIeabn5zcXMIIv9ubx43piqTViT0PCOXWY1/hl?=
 =?us-ascii?Q?C0oKeIa6C8607vGI5XqOm/YGvajGqA7KtNI1Ozzk9H71V9VcKjZnNE8nxRVC?=
 =?us-ascii?Q?fFcG1+MOO545miuJRFysldM98X1NW/g1vU9J9wUQQwxGiXn4QWfQHGA96hF8?=
 =?us-ascii?Q?AG404HZHPMplifoQR2HISHB+dZgxd5u7c7b+OdSvNoShaCyetfUZFagTTTjA?=
 =?us-ascii?Q?WDK3Km17icAI4MYXyBIviURTPXdY74yGe0u729tFr3y9zWX1T+1qfuQ8yORS?=
 =?us-ascii?Q?HAvm5BVFm8l9TBP370zNiC0MRb0yCgi52uVcu2xPWJ8F9AQ01vgFUI6oBNv9?=
 =?us-ascii?Q?SfhuSzEPxdwmKmSjUQLhN18smuaNFbW3cIFJaSqSaOnibr9DDZOXLqpuMuqF?=
 =?us-ascii?Q?ls4gcHaQWcIvY5J9CZkTcPzS6e9Rfob0ysg7fyye3InvXC2BGCN39TjdyTdz?=
 =?us-ascii?Q?EhsMzh+aCexCrEjN/y2+M2mWVgQiK9lw512Nl9Wnz75kG1j95dIjMP0Q7Ych?=
 =?us-ascii?Q?jBcCAg=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: renesas.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: TYBPR01MB5341.jpnprd01.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e5ebf08d-e519-434b-013b-08da960e302d
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Sep 2022 05:01:30.7237
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 53d82571-da19-47e4-9cb4-625a166a4a2a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: xo8O47tz4xCxvuhWt+U3SJQ4txtQq+T95M7nEmwg6wtcHSiwlcwSMBnGvHCWWGGNkDA+7U5m24KDV32wt0NYTNbK374sNqsLceEb36OmbTUMUfUDAsiurwGG1zr+MGT7
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TY3PR01MB10596
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Rob,

Thank you for your review!

> From: Rob Herring, Sent: Tuesday, September 13, 2022 10:03 PM
>=20
> On Fri, Sep 09, 2022 at 10:26:11PM +0900, Yoshihiro Shimoda wrote:
> > Document Renesas Etherent Switch for R-Car S4-8 (r8a779f0).
> >
> > Signed-off-by: Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
> > ---
> >  .../bindings/net/renesas,etherswitch.yaml     | 252 ++++++++++++++++++
> >  1 file changed, 252 insertions(+)
> >  create mode 100644 Documentation/devicetree/bindings/net/renesas,ether=
switch.yaml
> >
> > diff --git a/Documentation/devicetree/bindings/net/renesas,etherswitch.=
yaml
> b/Documentation/devicetree/bindings/net/renesas,etherswitch.yaml
> > new file mode 100644
> > index 000000000000..1affbf208829
> > --- /dev/null
> > +++ b/Documentation/devicetree/bindings/net/renesas,etherswitch.yaml
<snip>
> > +title: Renesas Ethernet Switch
> > +
> > +maintainers:
> > +  - Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
> > +
> > +properties:
> > +  compatible:
> > +    const: renesas,r8a779f0-ether-switch
> > +
> > +  reg:
> > +    maxItems: 3
> > +
> > +  reg-names:
> > +    items:
> > +      - const: base
> > +      - const: secure_base
> > +      - const: serdes
>=20
> Is serdes really the same h/w block? Based on addresses, doesn't seem
> like it.

You're correct. The serdes is not the same h/w block. I'll fix it somehow.

> > +
> > +  interrupts:
> > +    maxItems: 47
> > +
> > +  interrupt-names:
> > +    items:
> > +      - const: mfwd_error
> > +      - const: race_error
> > +      - const: coma_error
> > +      - const: gwca0_error
> > +      - const: gwca1_error
> > +      - const: etha0_error
> > +      - const: etha1_error
> > +      - const: etha2_error
> > +      - const: gptp0_status
> > +      - const: gptp1_status
> > +      - const: mfwd_status
> > +      - const: race_status
> > +      - const: coma_status
> > +      - const: gwca0_status
> > +      - const: gwca1_status
> > +      - const: etha0_status
> > +      - const: etha1_status
> > +      - const: etha2_status
> > +      - const: rmac0_status
> > +      - const: rmac1_status
> > +      - const: rmac2_status
> > +      - const: gwca0_rxtx0
> > +      - const: gwca0_rxtx1
> > +      - const: gwca0_rxtx2
> > +      - const: gwca0_rxtx3
> > +      - const: gwca0_rxtx4
> > +      - const: gwca0_rxtx5
> > +      - const: gwca0_rxtx6
> > +      - const: gwca0_rxtx7
> > +      - const: gwca1_rxtx0
> > +      - const: gwca1_rxtx1
> > +      - const: gwca1_rxtx2
> > +      - const: gwca1_rxtx3
> > +      - const: gwca1_rxtx4
> > +      - const: gwca1_rxtx5
> > +      - const: gwca1_rxtx6
> > +      - const: gwca1_rxtx7
> > +      - const: gwca0_rxts0
> > +      - const: gwca0_rxts1
> > +      - const: gwca1_rxts0
> > +      - const: gwca1_rxts1
> > +      - const: rmac0_mdio
> > +      - const: rmac1_mdio
> > +      - const: rmac2_mdio
> > +      - const: rmac0_phy
> > +      - const: rmac1_phy
> > +      - const: rmac2_phy
> > +
> > +  clocks:
> > +    maxItems: 2
> > +
> > +  clock-names:
> > +    items:
> > +      - const: fck
> > +      - const: tsn
> > +
> > +  resets:
> > +    maxItems: 2
>=20
> What is each one?

"tsn" and "rswitch2". So, I'll add reset-names for it.

> > +
> > +  iommus:
> > +    maxItems: 16
> > +
> > +  power-domains:
> > +    maxItems: 1
> > +
> > +  '#address-cells':
> > +    description: Number of address cells for the MDIO bus.
> > +    const: 1
> > +
> > +  '#size-cells':
> > +    description: Number of size cells on the MDIO bus.
> > +    const: 0
>=20
> It's better if you put MDIO under an 'mdio' node. That also needs a ref
> to mdio.yaml.

I got it.

> > +
> > +  ports:
> > +    type: object
> > +
> > +    properties:
> > +      '#address-cells':
> > +        const: 1
> > +      '#size-cells':
> > +        const: 0
> > +
> > +    additionalProperties: false
> > +
> > +    patternProperties:
> > +      "^port@[0-9a-f]+$":
> > +        type: object
> > +
> > +        $ref: "/schemas/net/ethernet-controller.yaml#"
> > +        unevaluatedProperties: false
> > +
> > +        properties:
> > +          '#address-cells':
> > +            const: 1
> > +          '#size-cells':
> > +            const: 0
> > +
> > +          reg:
> > +            description:
> > +              Switch port number
> > +
> > +          phy-handle:
> > +            description:
> > +              Phandle of an Ethernet PHY.
> > +
> > +          phy-mode:
> > +            description:
> > +              This specifies the interface used by the Ethernet PHY.
> > +            enum:
> > +              - mii
> > +              - sgmii
> > +              - usxgmii
> > +
> > +        required:
> > +          - reg
> > +          - phy-handle
> > +          - phy-mode
> > +
> > +required:
> > +  - compatible
> > +  - reg
> > +  - reg-names
> > +  - interrupts
> > +  - interrupt-names
> > +  - clocks
> > +  - clock-names
> > +  - resets
> > +  - power-domains
> > +  - '#address-cells'
> > +  - '#size-cells'
> > +
> > +additionalProperties: false
> > +
> > +examples:
> > +  - |
> > +    #include <dt-bindings/clock/r8a779f0-cpg-mssr.h>
> > +    #include <dt-bindings/interrupt-controller/arm-gic.h>
> > +    #include <dt-bindings/power/r8a779f0-sysc.h>
> > +
> > +    rswitch: ethernet@e6880000 {
>=20
> Drop unused labels.

I'll drop it.

Best regards,
Yoshihiro Shimoda
=20
