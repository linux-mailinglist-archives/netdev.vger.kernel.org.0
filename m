Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9CBA35650B6
	for <lists+netdev@lfdr.de>; Mon,  4 Jul 2022 11:26:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231744AbiGDJ0e (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Jul 2022 05:26:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50938 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231339AbiGDJ0c (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 Jul 2022 05:26:32 -0400
Received: from JPN01-TYC-obe.outbound.protection.outlook.com (mail-tycjpn01on2116.outbound.protection.outlook.com [40.107.114.116])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E869DBC3D;
        Mon,  4 Jul 2022 02:26:30 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XGjgbqFH+fGFFR9dCDxUW4JS9gvAXH5qbksJ11i1ACq88gghypAwj6ZJZ1rQL7CIjpd1ZG1/i9+/+JU7cybbJPBUVc1q/iEF2Hl9aDcC39KV3mT+qPg4SRpMtBGVAnmP1EA/MZdMECqHXapcTFGoksk/KggKMotvlxVnoSnK0OFJJFykqP5JaJz8oEqRcquKz3A4u38n4EiMjmP6zYdhwfMNYQ56YQEiutSU9/gKHGxJXrJExbxEmzUv9IckAks9at1krxoNgc05LPa7eSwVvY77XWI8dIdq9DVpHVUJc+E9QtviX4Y7Mbi/b7P64b7wHP3i7v6kyXTlFbwTZSjWjQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=OZTpWwYo4JJ51f8go0FLOf+qV2ze2QOW7qh7mTBsFYQ=;
 b=hT8faKLSWJcIIBIxZNY4jW7TVzzABMbDOjfV2wAZofyo8JMZ74OkQndBATAgGnv5+JhNyRoXnIgrj9JHAhxOyTDxGY1M020GdXIbYQtnEowQgCFZsd4+boNz/D3VgwJeFPEQjUZaJerj2+53qb2F+Yyugtshw+i8JqjBvEtE97OIpXRS+dRhUg231Hzjrt9mxadD252RbXrdAXF3z2y/rGl9mQPveXTAhfdMiC5BirORir8UaU32vp8t/rQXpee63kCLgVds7BIdYJQrL7rgrqmClv8NyPbAWjGGk79+8AmkIrO+nIGZvJ4kmDPP6KrX+qZZNReUEEl8MDQQBLIHUw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=bp.renesas.com; dmarc=pass action=none
 header.from=bp.renesas.com; dkim=pass header.d=bp.renesas.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bp.renesas.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OZTpWwYo4JJ51f8go0FLOf+qV2ze2QOW7qh7mTBsFYQ=;
 b=aRJgBjp7tbtP2pmTzgFctO9W/EkKtmUhKt9ypR9KMvHmUK/1RsLiNP8xRA54nugeKSaIKcZOjSDTL5lRkJiprPO6WISC48OQcsBOMdwjGCZyD7iZhVCuZilVY46y89UCJKH0clXm1X2J4wX7yWuEaAay0xg9bMYUFON1MvHZVhc=
Received: from OS0PR01MB5922.jpnprd01.prod.outlook.com (2603:1096:604:bb::5)
 by TY2PR01MB4569.jpnprd01.prod.outlook.com (2603:1096:404:110::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5395.17; Mon, 4 Jul
 2022 09:26:28 +0000
Received: from OS0PR01MB5922.jpnprd01.prod.outlook.com
 ([fe80::dc06:eb07:874:ecce]) by OS0PR01MB5922.jpnprd01.prod.outlook.com
 ([fe80::dc06:eb07:874:ecce%9]) with mapi id 15.20.5395.020; Mon, 4 Jul 2022
 09:26:28 +0000
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
Thread-Index: AQHYj3rFeZoOr/6TGk2WlkP02UFvdK1t5gwAgAAB4DCAAARmgIAAA7eg
Date:   Mon, 4 Jul 2022 09:26:28 +0000
Message-ID: <OS0PR01MB5922969554D0FA70D2F323D886BE9@OS0PR01MB5922.jpnprd01.prod.outlook.com>
References: <20220704075032.383700-1-biju.das.jz@bp.renesas.com>
 <20220704075032.383700-2-biju.das.jz@bp.renesas.com>
 <ed032ae8-6a2b-b79f-d42a-6e96fe53a0d7@linaro.org>
 <OS0PR01MB5922ECBBEFF973867CC23B2786BE9@OS0PR01MB5922.jpnprd01.prod.outlook.com>
 <404a0146-5e74-b0df-6e1a-c6a689e2c858@linaro.org>
In-Reply-To: <404a0146-5e74-b0df-6e1a-c6a689e2c858@linaro.org>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=bp.renesas.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 98ee79e6-1801-4c96-f73a-08da5d9f45ec
x-ms-traffictypediagnostic: TY2PR01MB4569:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: dJW8FarpqM4eWfLEeuw58fzNQ4+0HZf6RPCJyzTtA/JiX7Cus4SWqYZttoTy0GhJUJcZrQR4EvXw0gHiYP0bPUeNsjNNUlv/X0DDRVIW4fYn/NhjP+dVgNeHqtIbcTO5Rf6Am1BrFomMu1Z7h+kU3U78s5iWCtIEr41xZHUe7XQynAS/T+xF00q6Geid/ttXBAClTIaAAmrl4I8vx4+p1u/339KvHPtmVB3ae9woNJdGCFllFpGYq5inSm3bk2Rl0W2gBsW4D8IoCXhN7R7VY5sFIJUWfhZ/sOMvkEbuN/oVh90IGAVGmTQkxoxO9mO712IfQH5LKaZp1bcZ2XnH86Ba3k39KbKQVNhjVyUD9ZVBVRHZk6bDH3NjUOxf1BK+EBd2921q6FJdTzG2NqHKSBhFIKG098NgV4FFoRjqa6GyVAKaxqof9r/Jzlf/NsnN017WUXSLBb80iZvYfZiRosiy9WkhkkW9EPMcXj87vOpZY636cEd5IS3KNZW64KaMOo1Rt8intzOlcX7T8GBAtZ3+JW8qqAHOByE94AAWBACs1YSzXSe0XgoQQoqr8GbJRSLkxwUHxte7PUyTHfr/0d073SHCkT0s88t+E9oqR4tPNKrCv9VsRUPbdM/roISWZq88Bts5s4aLN1b3E5FEcCe2ir5kKEcYeAJeSdk1eHm7Xv4reA3UoOzrYcYjPASrslqPER81DiaJITvgAqfGQ4JrQADqRFrCXfJbKG6yX3XIlxX3W7hBvFRf22KfaLF2E4E0NZhVM/J1Odw30h3J/21yeNzNkLKW3elVAaoXtzZgy6x/WJ6bv3GcfIuL/nbm
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:OS0PR01MB5922.jpnprd01.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(136003)(39860400002)(346002)(396003)(376002)(366004)(71200400001)(41300700001)(83380400001)(9686003)(26005)(55016003)(86362001)(33656002)(478600001)(8936002)(52536014)(76116006)(66946007)(38100700002)(66476007)(66556008)(110136005)(66446008)(7416002)(2906002)(7696005)(316002)(186003)(53546011)(6506007)(122000001)(54906003)(4326008)(64756008)(38070700005)(8676002)(5660300002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-1?Q?Gj9UMzTFu9xPeWiRGI4IVYOK8cSBiV2uS682wlb/Yhe0AhvDeQKU5Y6KIE?=
 =?iso-8859-1?Q?ez27Xwno7HDTPs8Yp1TJC2+f2KymisRg6PGblU5nLI+DuzZP96NNJ/vsIi?=
 =?iso-8859-1?Q?eJwiFTOh2yNRBh/sQJTUYozl9nhbC9Y8aoAmwpgnWyy6AZNkRM95AP8p2i?=
 =?iso-8859-1?Q?3VMOal4V7qAGkldV2wWvCKDrPRBVv/OUqzihYlwkTGaQxKa28jpqyZRmN4?=
 =?iso-8859-1?Q?IUczgUZIg1XfVCCElDj28tgIH+HbWsBXMoxiEZDi1rKiXdVJTXJk1hro7t?=
 =?iso-8859-1?Q?NyUquWrHdrbpmcabc7wCeAMGsbpL//mo3LUhI41N20wt9oLt2Ltok3tV94?=
 =?iso-8859-1?Q?9NV3KG/xdShOdNg0HZorHt714FXbdouqo90fmpsqWkDcrJiRIDJs6YOKSs?=
 =?iso-8859-1?Q?2u0L9Ym0LCbenzedAR+xmjo6Dmq6mvme4PozFSVbGSWBHZUk5on2xGU4D/?=
 =?iso-8859-1?Q?tOgcGwSLIvQsWSBc3MlBW1TCqH2gZtiHcivUB06ftI57OdH/VaoAr4pIxo?=
 =?iso-8859-1?Q?d1Wdcoytj2g3YUS3VNshQB+rksO6AtplXXGnpxUPGOWrtmsbknXr6Iixle?=
 =?iso-8859-1?Q?U+wU3nPzLyzmAnKUU1x1sA3CPPAFhM/Xg30687Wbz9ryL8+yV9OGWCNFfE?=
 =?iso-8859-1?Q?xakwqBHiCeW9t8yCC2Q36hScBx2O8XxtB+HTzwV46u7oFiEqLxEd9q7yVL?=
 =?iso-8859-1?Q?NfnIyeLNMvIHI1xeZrWaB8kLqnzmlCrh/bIQHOpJpjCbRWvcAYkXJ6jyrO?=
 =?iso-8859-1?Q?AAkp1CGNvamkK494kQD/il2RxxqlYFW5+1r2zCwrSbj0RMINRRuK1p8mvQ?=
 =?iso-8859-1?Q?tk8cnps87XROWRP2UJodPDkQg21TIFalQjj5wlgTypd1O97q8V8en9PHV9?=
 =?iso-8859-1?Q?3TAN3Vk41zZ15I3GHv81AYOJ/Z08AqkJCB/Jd9wMea+I0skHp7CWWP5+71?=
 =?iso-8859-1?Q?flbGL4J/23+11qazjyYi4qDkCrNgnlDmu6w74Y+F/eExe3tOYaqygwBefx?=
 =?iso-8859-1?Q?uMQAPRnsdO1qCL3aMWj6ZurcRNpqmML9SHoT0lo5b6jJ4w6JvBjI1r0Dnf?=
 =?iso-8859-1?Q?xzid//GXxwV9TKAL6+Nm6G3cD+4jp3iPp+4vFHV5C9OlFUpwxfT+g5Kosi?=
 =?iso-8859-1?Q?wBVlSF+9ZkfxlXxZC0Dgm04DYfej61wZai0HJcPhlnveXGERoqbieUsVpE?=
 =?iso-8859-1?Q?Emr4lzRWAHVk3DiS8aWEKNGTSdFiR37r+qD8fqqcjWMl1iAoPL5VDcudsb?=
 =?iso-8859-1?Q?CZmHgPat1g2/12lt65NJ+ATceVyo5eUdROA/Wg6ozIlVZaYZGU9hvyHYv9?=
 =?iso-8859-1?Q?b0/55qBvxUGNPGpR4/q5TMFkJCDIGxv1hBbR0bWxzJlCQocxmUy3VTlUZG?=
 =?iso-8859-1?Q?jFownkdWKXmy7Vnl+lHqC5jbqReuL7lCK7k//IgUKRhCXkM7udMm8iUHia?=
 =?iso-8859-1?Q?+WO78IaOwN9ebsd+wBKNy+SWwFGHCnPueQPNK2afBzJ/xJYcsWIzL5th42?=
 =?iso-8859-1?Q?7s22NWIpCQOnp7YvD0ziupza/P60yes+B6Y+8XrtZaH4QldOhf2zbiqCI2?=
 =?iso-8859-1?Q?iIIwa/ZMLSWCzaOjJbylhoCin2P+gFmJuwpsOOYWBppu9Y5n8tsfDSS+kn?=
 =?iso-8859-1?Q?vsFYiXSGHKRXSt459bm7/qiQN6CJSZPPLcX9wUYjyPQsNv56DvOfF2Zg?=
 =?iso-8859-1?Q?=3D=3D?=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: bp.renesas.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: OS0PR01MB5922.jpnprd01.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 98ee79e6-1801-4c96-f73a-08da5d9f45ec
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Jul 2022 09:26:28.0374
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 53d82571-da19-47e4-9cb4-625a166a4a2a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: vCQkfMsb+0nQH4dRGrhapZU8WM31f8TzeE4p226U6uI7GxgbHJLZUIKOC5b63bIU5GEFc8gxdUh8zcza+59Tqmvv8aStEeBrloTcwFz3ZZY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TY2PR01MB4569
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Krzysztof,

Thanks for the feedback.

> Subject: Re: [PATCH v3 1/6] dt-bindings: can: sja1000: Convert to json-
> schema
>=20
> On 04/07/2022 11:03, Biju Das wrote:
> > Hi Krystof,
> >
> > Thanks for the feedback.
> >
> >> Subject: Re: [PATCH v3 1/6] dt-bindings: can: sja1000: Convert to
> >> json- schema
> >>
> >> On 04/07/2022 09:50, Biju Das wrote:
> >>> Convert the NXP SJA1000 CAN Controller Device Tree binding
> >>> documentation to json-schema.
> >>>
> >>> Update the example to match reality.
> >>>
> >>> Signed-off-by: Biju Das <biju.das.jz@bp.renesas.com>
> >>> ---
> >>> v2->v3:
> >>>  * Added reg-io-width is a required property for technologic,sja1000
> >>>  * Removed enum type from nxp,tx-output-config and updated the
> >> description
> >>>    for combination of TX0 and TX1.
> >>>  * Updated the example
> >>> v1->v2:
> >>>  * Moved $ref: can-controller.yaml# to top along with if conditional
> >>> to
> >>> =A0 =A0avoid multiple mapping issues with the if conditional in the
> >> subsequent
> >>>    patch.
> >>> ---
> >>>  .../bindings/net/can/nxp,sja1000.yaml         | 103
> ++++++++++++++++++
> >>>  .../devicetree/bindings/net/can/sja1000.txt   |  58 ----------
> >>>  2 files changed, 103 insertions(+), 58 deletions(-)  create mode
> >>> 100644 Documentation/devicetree/bindings/net/can/nxp,sja1000.yaml
> >>>  delete mode 100644
> >>> Documentation/devicetree/bindings/net/can/sja1000.txt
> >>>
> >>> diff --git
> >>> a/Documentation/devicetree/bindings/net/can/nxp,sja1000.yaml
> >>> b/Documentation/devicetree/bindings/net/can/nxp,sja1000.yaml
> >>> new file mode 100644
> >>> index 000000000000..d34060226e4e
> >>> --- /dev/null
> >>> +++ b/Documentation/devicetree/bindings/net/can/nxp,sja1000.yaml
> >>> @@ -0,0 +1,103 @@
> >>> +# SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause) %YAML 1.2
> >>> +---
> >>> +$id:
> >>> +
> >>> +title: Memory mapped SJA1000 CAN controller from NXP (formerly
> >>> +Philips)
> >>> +
> >>> +maintainers:
> >>> +  - Wolfgang Grandegger <wg@grandegger.com>
> >>> +
> >>> +allOf:
> >>> +  - $ref: can-controller.yaml#
> >>> +  - if:
> >>
> >> The advice of moving it up was not correct. The allOf containing ref
> >> and if:then goes to place like in example-schema, so before
> >> additional/unevaluatedProperties at the bottom.
> >>
> >> Please do not introduce some inconsistent style.
> >
> > There are some examples like[1], where allOf is at the top.
> > [1]
=3DMw4Fhkri5BLK1Cqg8Wd1EKkbe0xDg%2Fnbl0JSd5j6Kmo%3D&amp;reser
> > ved=3D0
>=20
> And they are wrong. There is always some incorrect code in the kernel,
> but that's not argument to do it in incorrect way. The coding style is
> here expressed in example-schema, so use this as an argument.

OK. Will stick to example-schema as coding style.

Cheers,
Biju

