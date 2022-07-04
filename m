Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B1CE0565041
	for <lists+netdev@lfdr.de>; Mon,  4 Jul 2022 11:03:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231652AbiGDJDL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Jul 2022 05:03:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34134 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232520AbiGDJDJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 Jul 2022 05:03:09 -0400
Received: from JPN01-TYC-obe.outbound.protection.outlook.com (mail-tycjpn01on2125.outbound.protection.outlook.com [40.107.114.125])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 597011109;
        Mon,  4 Jul 2022 02:03:04 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=M0galHOWW+YV3Rxfu2RcBUqqE3rBybPATnlk4KW/+yuWuvMpM7qrGM8zFvMuybo2uN+EtWlyfMJpyG2HHFaARZEpWB82+iamHGz1u1njGnP3v9sxRQ27hiR7mMeI/bLCCJuu+Py9XRbb6XwBDtayAlKMImHZHrbrDrUtCpB05w/YMEywNmsNrIR9Wen2nowxNrtjhXQdebH8257h9hyl7N+cSBvgN7PA9j3f69uuoAlBcKzWU8hY0S2qb9Q5N1MUHdNpoZOfSP4Dhy5NyI9rDzhk7jO78bKbu8MvewXT7WGKxzFW0QCRmZAxRpZMwTFP3iRT1Fzvfq2uAU+xeK9+Rw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=i41UJYsDgUHxIRvuCXaw55olDpDkK2az9d9YJI0kY8U=;
 b=R5GnifO5boLo4LMzAfpUr9w8wuJEW+ef3Ois61jE0zUgVmAmgDHu5W6RW4Lx7sTnhU/EYj8XCi0gzfGqsZzCp+Vk8xAlWyXW/AHQhE0qP8Wb73Folt1CMf3wMGdqX9WtpTB7ieZtmBjYAB0+ij3DywvOGE5TWwZCU649OD6DwLLTn52BFGinGfn/AC3ESwqu2VQZiCWkforCBygsesKIq8Up7GaEFL0A59NBVuIbOlWAToqUq19EpF6wXgbCZ3oO0VDoH46O/h8sqjBB856d4awJlkBI+npNOG5JxNEe01kdt9nqUl11qUOVv2SBJ4cElnCih6TsdrtTyuQLtjWdIA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=bp.renesas.com; dmarc=pass action=none
 header.from=bp.renesas.com; dkim=pass header.d=bp.renesas.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bp.renesas.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=i41UJYsDgUHxIRvuCXaw55olDpDkK2az9d9YJI0kY8U=;
 b=w5E72BC68bibzFDNaKUNBeBy6zZ+Md95ZatYfYymgQBgyBPqTPxtwsLdu61Wq5hEDo4PjDhNKgnKIgBC/x7bsmU9CKzWTUZBbgOd7dWFRVOrDVB2I0e3BwX8AkGuj/6tLbyi5alC7EgKFH/EQoYK5Di55Gd573bq44Cxdvgp3Bw=
Received: from OS0PR01MB5922.jpnprd01.prod.outlook.com (2603:1096:604:bb::5)
 by TYBPR01MB5454.jpnprd01.prod.outlook.com (2603:1096:404:801d::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5395.14; Mon, 4 Jul
 2022 09:03:01 +0000
Received: from OS0PR01MB5922.jpnprd01.prod.outlook.com
 ([fe80::dc06:eb07:874:ecce]) by OS0PR01MB5922.jpnprd01.prod.outlook.com
 ([fe80::dc06:eb07:874:ecce%9]) with mapi id 15.20.5395.020; Mon, 4 Jul 2022
 09:03:01 +0000
From:   Biju Das <biju.das.jz@bp.renesas.com>
To:     Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        Wolfgang Grandegger <wg@grandegger.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>
CC:     "linux-can@vger.kernel.org" <linux-can@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        =?iso-8859-1?Q?Uwe_Kleine-K=F6nig?= 
        <u.kleine-koenig@pengutronix.de>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Chris Paterson <Chris.Paterson2@renesas.com>,
        Biju Das <biju.das@bp.renesas.com>,
        "linux-renesas-soc@vger.kernel.org" 
        <linux-renesas-soc@vger.kernel.org>
Subject: RE: [PATCH v3 1/6] dt-bindings: can: sja1000: Convert to json-schema
Thread-Topic: [PATCH v3 1/6] dt-bindings: can: sja1000: Convert to json-schema
Thread-Index: AQHYj3rFeZoOr/6TGk2WlkP02UFvdK1t5gwAgAAB4DA=
Date:   Mon, 4 Jul 2022 09:03:01 +0000
Message-ID: <OS0PR01MB5922ECBBEFF973867CC23B2786BE9@OS0PR01MB5922.jpnprd01.prod.outlook.com>
References: <20220704075032.383700-1-biju.das.jz@bp.renesas.com>
 <20220704075032.383700-2-biju.das.jz@bp.renesas.com>
 <ed032ae8-6a2b-b79f-d42a-6e96fe53a0d7@linaro.org>
In-Reply-To: <ed032ae8-6a2b-b79f-d42a-6e96fe53a0d7@linaro.org>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=bp.renesas.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 8c1d8f47-3c40-4937-c8fc-08da5d9bff76
x-ms-traffictypediagnostic: TYBPR01MB5454:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: PV2IKhFHoejknYMZUTCVH+fZAOqN+c8iSczT1UknzaAwrM4iOoDlbfB1Fxp2gcUVSks+ny1Ww9izZN1SuZlkrVvJxo7fSAjyR2/tZH4CxZhYn/GRZyZ+G/AZrC3zSOkxXDzUKr8prblJguZVvzVQrjD6VqC2H/k5yQebflJYIwSOnW4Lj5VgKrS9M9kAV11QOJRDNoazxgfRw5IIvuGzfW4OXhWe6qICKHWHoXjqcFSUCVAV/SJO78+5X24lVtXJ29yKAdTvQEQobBGeUxvR8iB9skzknmNg118HIhQk+exLT2aV//jvofqefPIJCzVUlJSHqxDugEAfgA+lHqLM/9gOwwYaM3qMdoncaOTzbdiIkN2Ohvq/uMjYhO8E+wTsI0sm5sBls3qW+brhhaFureQVcvb1arQt66Ah50sulQ+1pWiO2/orMTPSaIzzt9f95SC6acdoF62nhgZr4r78zVudrlY9OkYjr7oP5ehk1XXbXFj7GINFQUd9xK/A8dF8aGV62K72/z9KHtqmucgDu5sjjfhEbRDq0omT219GGAEW/sJyEQF443qCXjs+ilDpL2yBwT4R5WywFmqFpK+XOvcSUpI98KuOS47Zq7Hn+azKVlDtxhnTwnXUb4AiQnesnkYwM+MUC6TTFJTyFkCUzY6wD7whlncqmLxtawf7cludhJrFTr1yVBc+8GnYgjxPkkDZH/KI2VV7tkGfqoTRFM65Abq+p8idcwuUfMkwfQpfFIjD3a3+dPeA71eqGGeYybcc5s3xIZMxLLsR8w7HZYYmCCmGHze0V1wLsBjDgWMkOoN0eWZv4na4EnJUDUNUmjRy0nDgstAhYWkEuu8X9zKNXlk2HdspaRlNy1m5SFk=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:OS0PR01MB5922.jpnprd01.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(376002)(136003)(39860400002)(396003)(346002)(366004)(66556008)(66446008)(8676002)(64756008)(4326008)(76116006)(66946007)(66476007)(83380400001)(54906003)(110136005)(52536014)(8936002)(86362001)(316002)(7416002)(5660300002)(186003)(966005)(33656002)(38070700005)(478600001)(9686003)(2906002)(53546011)(7696005)(26005)(6506007)(122000001)(71200400001)(41300700001)(55016003)(38100700002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-1?Q?aeK2ucb6mOTRHcyttIQxkd9hX97RLb5Jghl4vcvc24HYBp3J1z/EMdrK5v?=
 =?iso-8859-1?Q?DhUpE4IOoIBc7xdTqNvEZvpVDq2T4NOWj+bmCw+Psd5HfynIeqs+uBaY3k?=
 =?iso-8859-1?Q?yod3N/W0IIOBZjzvkgh6vW6Y++x8JVeMme+V5ESxS6JxOF8jkpU/JSuyRh?=
 =?iso-8859-1?Q?kHf9qFUAt5257KUeJ4LIgFPd457Cx8ROgL6pX2UdYpjf32w0MAHZLcbIJH?=
 =?iso-8859-1?Q?vvbPXYuefm9tIp1QDoG/XpEhR8czZij8ElUdyc1wIqRwvEKqLvCPO1331N?=
 =?iso-8859-1?Q?3tFuXpWN2NzLaCFs68ZV3+ugsuyk/vFlXqFf8oOYVS9zPJu2mWAF/YpNeF?=
 =?iso-8859-1?Q?1t2IAhssFOAPVWiyZjihSfOUkyh0RGHuARE+/PjzvbSsTZCl42KEfa01Wo?=
 =?iso-8859-1?Q?MxuyU8iP/PgDnPMkk1O+Sracim4ht0Ph96Elvn28F4JhkuFuSDg2Wnr9mP?=
 =?iso-8859-1?Q?3KXjXOqcJpi8AJ7cbrpncRTZj0tx6tMi2ZsKSovRND4N23FxykVBffm+Q2?=
 =?iso-8859-1?Q?WEQsHEICpB7KxithI7s1Jr6W2Y9Ug035IVD6GEr/lAwz0l08R3EyMvrKf0?=
 =?iso-8859-1?Q?lhMCfeuvMq2UV70uKsc7jcuGBMlmWcrnA4h7n5kEnjyvCuplBAlQ3CgNnb?=
 =?iso-8859-1?Q?c+kOAiOo9vJk8AcjnPFcoMla2uoPcp1+7A/VbWuZs5u1QXiLF5YdzxmOpb?=
 =?iso-8859-1?Q?vz0ih7YMrF6/VG4mGs+wSN0JNCvSQle7dTYXPg8SUfiYd3IukifXVit4+U?=
 =?iso-8859-1?Q?/TAakY6giB3NCMvVzKnQhESmWY93CEyD/ueVDPEfKrwnSaqoPXJ4Qrq4Tb?=
 =?iso-8859-1?Q?QzOqEE5/P3vsft2rgzDa1eY/yXkJ/yfN9cXPMaf4UXSOLCI1OQIbRRO5a+?=
 =?iso-8859-1?Q?AfNLg+xbBoVaVl/uqoE5nmBtjZOIaidjav3VUPkg+8REEuv0AWk3QBUWyW?=
 =?iso-8859-1?Q?6VDK7hB/QaOYngG9aMtF9nsLQYFhE8eMJijL6IIabGFEhlG0cI5djuFMpd?=
 =?iso-8859-1?Q?685My7QcTn4IcfOJNZSL1VYmFqe/W3sxPYwE8qyfJVtrvymuUjsSR6qv2y?=
 =?iso-8859-1?Q?Qj3LrZlBiD6wjgPE8gmC7KJzAM7pKHzjpsVXmFc2tD1AiqDu3n+DZSzu0J?=
 =?iso-8859-1?Q?njE7b1Xev2quwvM7N+6qh3JhHqePnGnCqynuurib1OzHlDng3LsPNcljLM?=
 =?iso-8859-1?Q?GVeloY8pIxXLv5NKpAHykPwrOSfjPRSK4VIdGUIu0UctCHA2JZSV/zfsAA?=
 =?iso-8859-1?Q?Nf20ZKD17sD9/xDod2bFKtt05J4zQyz9sncol3/LHnatq7RGkEbvtlUKZ2?=
 =?iso-8859-1?Q?dlrZl7dCPr9cdMu+Gs0ZpFRk9bKuRlaTw1phTHt+2S3jsQ6BJWuPie79Lo?=
 =?iso-8859-1?Q?kNojLH2BweX8c8SaB2idjLKWUlyWDi6zqZtH26XVuwXPb34np2MszR3Bwn?=
 =?iso-8859-1?Q?JlrvW3JGFeGmBO2mcc7DAj4DwyRNGCqPWq2H1nnKKVLWgC58tfPiKjcdL+?=
 =?iso-8859-1?Q?zKx0GfdB2n9wrw4JtVpYb9OY8PB8oCibVLHqTaQJ5+4xZV9sjtLF5UQyCs?=
 =?iso-8859-1?Q?43LET7EWJ8vkj+yVCHqi0P+qjjdYzEHOOpaXkbQllekno8pyDT5wcm8+rQ?=
 =?iso-8859-1?Q?wv7katSsGWA9Kzur0HsAw90YbwwqS4uaFOYYCCXRR+Li65FSGnpFZ9Yg?=
 =?iso-8859-1?Q?=3D=3D?=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: bp.renesas.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: OS0PR01MB5922.jpnprd01.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8c1d8f47-3c40-4937-c8fc-08da5d9bff76
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Jul 2022 09:03:01.3166
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 53d82571-da19-47e4-9cb4-625a166a4a2a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: qEiUT/bZmq3RXzl85cV1AgO0b6vsmYoYw88nbMUnh0jzJmCSWX769axWQpkNcLNUe0hR5EdohyLoibZhff4+8xf6nfQ8hRKsSyI1yqVX5iQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TYBPR01MB5454
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Krystof,

Thanks for the feedback.

> Subject: Re: [PATCH v3 1/6] dt-bindings: can: sja1000: Convert to json-
> schema
>=20
> On 04/07/2022 09:50, Biju Das wrote:
> > Convert the NXP SJA1000 CAN Controller Device Tree binding
> > documentation to json-schema.
> >
> > Update the example to match reality.
> >
> > Signed-off-by: Biju Das <biju.das.jz@bp.renesas.com>
> > ---
> > v2->v3:
> >  * Added reg-io-width is a required property for technologic,sja1000
> >  * Removed enum type from nxp,tx-output-config and updated the
> description
> >    for combination of TX0 and TX1.
> >  * Updated the example
> > v1->v2:
> >  * Moved $ref: can-controller.yaml# to top along with if conditional
> > to
> > =A0 =A0avoid multiple mapping issues with the if conditional in the
> subsequent
> >    patch.
> > ---
> >  .../bindings/net/can/nxp,sja1000.yaml         | 103 ++++++++++++++++++
> >  .../devicetree/bindings/net/can/sja1000.txt   |  58 ----------
> >  2 files changed, 103 insertions(+), 58 deletions(-)  create mode
> > 100644 Documentation/devicetree/bindings/net/can/nxp,sja1000.yaml
> >  delete mode 100644
> > Documentation/devicetree/bindings/net/can/sja1000.txt
> >
> > diff --git
> > a/Documentation/devicetree/bindings/net/can/nxp,sja1000.yaml
> > b/Documentation/devicetree/bindings/net/can/nxp,sja1000.yaml
> > new file mode 100644
> > index 000000000000..d34060226e4e
> > --- /dev/null
> > +++ b/Documentation/devicetree/bindings/net/can/nxp,sja1000.yaml
> > @@ -0,0 +1,103 @@
> > +# SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause) %YAML 1.2
> > +---
> > +$id:
> > +
> > +title: Memory mapped SJA1000 CAN controller from NXP (formerly
> > +Philips)
> > +
> > +maintainers:
> > +  - Wolfgang Grandegger <wg@grandegger.com>
> > +
> > +allOf:
> > +  - $ref: can-controller.yaml#
> > +  - if:
>=20
> The advice of moving it up was not correct. The allOf containing ref and
> if:then goes to place like in example-schema, so before
> additional/unevaluatedProperties at the bottom.
>=20
> Please do not introduce some inconsistent style.

There are some examples like[1], where allOf is at the top.
[1] https://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git/tre=
e/Documentation/devicetree/bindings/spi/snps,dw-apb-ssi.yaml?h=3Dnext-20220=
704

Marc, please let us know, if you still prefer allOf at the top.

>=20
> > +      properties:
> > +        compatible:
> > +          contains:
> > +            const: technologic,sja1000
> > +    then:
> > +      required:
> > +        - reg-io-width
> > +
> > +properties:
> > +  compatible:
> > +    oneOf:
> > +      - description: NXP SJA1000 CAN Controller
> > +        const: nxp,sja1000
> > +      - description: Technologic Systems SJA1000 CAN Controller
> > +        const: technologic,sja1000
>=20
> Entire entry should be just enum. Descriptions do not bring any
> information - they copy compatible.

OK, I will remove description and will use enum.

>=20
> > +
> > +  reg:
> > +    maxItems: 1
> > +
> > +  interrupts:
> > +    maxItems: 1
> > +
> > +  reg-io-width:
> > +    $ref: /schemas/types.yaml#/definitions/uint32
> > +    description: I/O register width (in bytes) implemented by this
> device
> > +    default: 1
> > +    enum: [ 1, 2, 4 ]
> > +
> > +  nxp,external-clock-frequency:
> > +    $ref: /schemas/types.yaml#/definitions/uint32
> > +    default: 16000000
> > +    description: |
> > +      Frequency of the external oscillator clock in Hz.
> > +      The internal clock frequency used by the SJA1000 is half of that
> value.
> > +
> > +  nxp,tx-output-mode:
> > +    $ref: /schemas/types.yaml#/definitions/uint32
> > +    enum: [ 0, 1, 2, 3 ]
> > +    default: 1
> > +    description: |
> > +      operation mode of the TX output control logic. Valid values are:
> > +        <0x0> : bi-phase output mode
> > +        <0x1> : normal output mode (default)
> > +        <0x2> : test output mode
> > +        <0x3> : clock output mode
>=20
> Use decimal values, just like in enum.

OK.

>=20
> > +
> > +  nxp,tx-output-config:
> > +    $ref: /schemas/types.yaml#/definitions/uint32
> > +    default: 0x02
> > +    description: |
> > +      TX output pin configuration. Valid values are any one of the
> below
> > +      or combination of TX0 and TX1:
> > +        <0x01> : TX0 invert
> > +        <0x02> : TX0 pull-down (default)
> > +        <0x04> : TX0 pull-up
> > +        <0x06> : TX0 push-pull
> > +        <0x08> : TX1 invert
> > +        <0x10> : TX1 pull-down
> > +        <0x20> : TX1 pull-up
> > +        <0x30> : TX1 push-pull
> > +
> > +  nxp,clock-out-frequency:
> > +    $ref: /schemas/types.yaml#/definitions/uint32
> > +    description: |
> > +      clock frequency in Hz on the CLKOUT pin.
> > +      If not specified or if the specified value is 0, the CLKOUT pin
> > +      will be disabled.
> > +
> > +  nxp,no-comparator-bypass:
> > +    type: boolean
> > +    description: Allows to disable the CAN input comparator.
> > +
> > +required:
> > +  - compatible
> > +  - reg
> > +  - interrupts
> > +
> > +unevaluatedProperties: false
> > +
> > +examples:
> > +  - |
> > +    can@1a000 {
> > +            compatible =3D "technologic,sja1000";
>=20
> Unusual indentation. Use 4 spaces for the DTS example.

OK, Will do.

Cheers,
Biju

>=20
> > +            reg =3D <0x1a000 0x100>;
> > +            interrupts =3D <1>;
> > +            reg-io-width =3D <2>;
> > +            nxp,tx-output-config =3D <0x06>;
> > +            nxp,external-clock-frequency =3D <24000000>;
> > +    };
> > diff --git a/Documentation/devicetree/bindings/net/can/sja1000.txt
> > b/Documentation/devicetree/bindings/net/can/sja1000.txt
> > deleted file mode 100644
> > index ac3160eca96a..000000000000
> > --- a/Documentation/devicetree/bindings/net/can/sja1000.txt
> > +++ /dev/null
> > @@ -1,58 +0,0 @@
> > -Memory mapped SJA1000 CAN controller from NXP (formerly Philips)
> > -
> > -Required properties:
> > -
> > -- compatible : should be one of "nxp,sja1000", "technologic,sja1000".
> > -
> > -- reg : should specify the chip select, address offset and size
> required
> > -	to map the registers of the SJA1000. The size is usually 0x80.
> > -
> > -- interrupts: property with a value describing the interrupt source
> > -	(number and sensitivity) required for the SJA1000.
> > -
> > -Optional properties:
> > -
> > -- reg-io-width : Specify the size (in bytes) of the IO accesses that
> > -	should be performed on the device.  Valid value is 1, 2 or 4.
> > -	This property is ignored for technologic version.
> > -	Default to 1 (8 bits).
> > -
> > -- nxp,external-clock-frequency : Frequency of the external oscillator
> > -	clock in Hz. Note that the internal clock frequency used by the
> > -	SJA1000 is half of that value. If not specified, a default value
> > -	of 16000000 (16 MHz) is used.
> > -
> > -- nxp,tx-output-mode : operation mode of the TX output control logic:
> > -	<0x0> : bi-phase output mode
> > -	<0x1> : normal output mode (default)
> > -	<0x2> : test output mode
> > -	<0x3> : clock output mode
> > -
> > -- nxp,tx-output-config : TX output pin configuration:
> > -	<0x01> : TX0 invert
> > -	<0x02> : TX0 pull-down (default)
> > -	<0x04> : TX0 pull-up
> > -	<0x06> : TX0 push-pull
> > -	<0x08> : TX1 invert
> > -	<0x10> : TX1 pull-down
> > -	<0x20> : TX1 pull-up
> > -	<0x30> : TX1 push-pull
> > -
> > -- nxp,clock-out-frequency : clock frequency in Hz on the CLKOUT pin.
> > -	If not specified or if the specified value is 0, the CLKOUT pin
> > -	will be disabled.
> > -
> > -- nxp,no-comparator-bypass : Allows to disable the CAN input
> comparator.
> > -
> > -For further information, please have a look to the SJA1000 data sheet.
> > -
> > -Examples:
> > -
> > -can@3,100 {
> > -	compatible =3D "nxp,sja1000";
> > -	reg =3D <3 0x100 0x80>;
> > -	interrupts =3D <2 0>;
> > -	interrupt-parent =3D <&mpic>;
> > -	nxp,external-clock-frequency =3D <16000000>;
> > -};
> > -
