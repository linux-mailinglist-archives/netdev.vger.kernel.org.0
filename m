Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F15FD619BE6
	for <lists+netdev@lfdr.de>; Fri,  4 Nov 2022 16:40:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232125AbiKDPkx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Nov 2022 11:40:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50192 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232401AbiKDPkv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Nov 2022 11:40:51 -0400
Received: from EUR02-DB5-obe.outbound.protection.outlook.com (mail-db5eur02on2067.outbound.protection.outlook.com [40.107.249.67])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A72D631DDD;
        Fri,  4 Nov 2022 08:40:50 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=apsqvNmoivZeSfg0PtZr75m8wVqWp5qvziMRPc1nlwoDdy+gMNs7yWLoTPolDhKx1KiEsXGY/GnIIsh9xTCe86RlGyUQoyEzlmMB5HhWtaJUZXPXyDoR7+zkRRz8NjNeqNUjgvIJGVbygoo5IEBoIr3dmc4cy+fOBS3rIPbsCXorrGD+1UPsvO4PXIDf/c01J14XLse/H3mGECMEYynIYgJbrqLBpjXLkZPPK2D1vykcg0X8ESEQ9Lcr8/u1KtiLBAJBTDpVB9rv4XVNQGvnOfKW61kjpFBvX2nI+P7V6qFXrtBKpMCwKRXKoNnskMRXPsTFz6eSkf79ml76uF/Yng==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xJ2RtlbbxGPKWY1YF6EMscoSJUtVaxAKeYAqelSE9mg=;
 b=kiCidIDBuGRN099hrltF9yp/OcxXc5mODOsL13XnGEauCgsoX6Y0o2LwgCGyCsdsdZzDWsg1RKE543lUiCdHDZBy+O8mekj3NlSC/CiyYEIp7Dncxf4ZjtnFW5zKdaKsAdExGYLveSGi9WpPtXzZxQFWXf6v893nocvhIqF2W+6BKvffBmwyb9MuojUFSSgPqLxs+hWYGui4BKezQFb47vum41U4+vHRv+HgHEpS36ZXuyEngBwzJTK7LhyRvHVQ3ZTsG+ikubeb0k8wZMgoUVPEWSLv7OSeZz+x1dRVFCCaXDsstLjFe8NEoQKHOOAeirjBjHNp0ekHtjmywz35rA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xJ2RtlbbxGPKWY1YF6EMscoSJUtVaxAKeYAqelSE9mg=;
 b=SFCi6Jiqd5JImY+asULPcZIsUgBOb9FrXsjw2M3kStuGSxj7FWAusYeyYs/jvhF559ts0ONmC/iEhy9Hk/Tkt0SwXpmp+XH3MGcB36RHcG6qPCG7+capSWoSBOeGxL6rpLV1h2cwpGrrpq6WKVxHJiLMBZPzuXechJ+KRhwhXX8=
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by AS8PR04MB7976.eurprd04.prod.outlook.com (2603:10a6:20b:2af::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5791.22; Fri, 4 Nov
 2022 15:40:48 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::df5b:6133:6d4c:a336]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::df5b:6133:6d4c:a336%7]) with mapi id 15.20.5769.022; Fri, 4 Nov 2022
 15:40:48 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
CC:     Maxime Chevallier <maxime.chevallier@bootlin.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "thomas.petazzoni@bootlin.com" <thomas.petazzoni@bootlin.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        Luka Perkov <luka.perkov@sartura.hr>,
        Robert Marko <robert.marko@sartura.hr>,
        Andy Gross <agross@kernel.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Konrad Dybcio <konrad.dybcio@somainline.org>
Subject: Re: [PATCH net-next v7 5/5] ARM: dts: qcom: ipq4019: Add description
 for the IPQESS Ethernet controller
Thread-Topic: [PATCH net-next v7 5/5] ARM: dts: qcom: ipq4019: Add description
 for the IPQESS Ethernet controller
Thread-Index: AQHY8FmpmsPL59Zv3k23UVCewDzxaK4u03IAgAAAfACAAAnbgIAACSGA
Date:   Fri, 4 Nov 2022 15:40:48 +0000
Message-ID: <20221104154047.6rtchfslvijqyxp6@skbuf>
References: <20221104142746.350468-1-maxime.chevallier@bootlin.com>
 <20221104142746.350468-6-maxime.chevallier@bootlin.com>
 <50814a5b-03d3-95b4-ab14-bfd19adae52b@linaro.org>
 <20221104143250.6qjkphkhrycp75rv@skbuf>
 <3bdb7b04-27a2-8d50-b96a-76ad914a0988@linaro.org>
In-Reply-To: <3bdb7b04-27a2-8d50-b96a-76ad914a0988@linaro.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: VI1PR04MB5136:EE_|AS8PR04MB7976:EE_
x-ms-office365-filtering-correlation-id: 10df03c4-a6e4-4462-27c5-08dabe7af22d
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: HhOUMYWxGaCRaajdEqfNvqsbrjfTYsU9I374ln1AcVOfJuZFhTOfAIsQDNIL8hhvISKUeXVzxorM4lhhl+YXLcI9VAvrYm7nNKSzw3NawafAxc2vYFGR7npoJLaAgfm8aKK1RxhjPGQwS/GcarBys1A6LC022qtSdmTs1gzXhD3ElvdmMUkWhyft7duV93idFEQp5PvxLiI2Iope4jIRuioy6yMoBBUCtyVaEJwYWIshxg+wvajFVbSPGsnfp+lR6Sa7U7W/2SRtUFp+VPymH6BKUgOUdF0DfL+hr6fwl2c970S1QVoNQawDHB1ugXB4qvTxElUz9QejTSz7kCVJm9fQW2et0y9UobJ2sjGY2Y+sHa2uSbY6jBa+DSjro2AP8/9WH+FWj3wAPQf4LpBB9r8y0kHab3V6tvk5QilHh3S1X4IFKQI/Y/+fXfychhRSwEdqW3/f6UO3CCrC8Ax6hYi3MZQRJtofOObBxh52hwLRGvnTLL3njBReusxxutOvxmKraMgevx7P84qRD9tZEn0xOQK01zNeC7sucHsogPBMOBtkpAbWC55K4nRQFIDXHbs1g9MT53XZLhvcmInvJ/KuOYDvUftWWlnZvmOikgDqgtdhch3tMxIFoQLa+4maQjLLJamCgwZ3pF+Fekbbxu5dI3rrerYiM++QySUy21RQAc3CFwxos7/zM+k8pyvn3GygHBcwihnkXyITppCrk5hkb/1DhaEZuHXah/+dptQcf58Qig/4zsklnmZ854cbB8l/fi8YGPKLLuh5EymDuQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(7916004)(376002)(136003)(366004)(396003)(346002)(39860400002)(451199015)(7416002)(44832011)(2906002)(122000001)(38100700002)(5660300002)(316002)(83380400001)(38070700005)(86362001)(41300700001)(6916009)(478600001)(9686003)(26005)(54906003)(186003)(71200400001)(1076003)(91956017)(6512007)(6486002)(53546011)(66946007)(76116006)(66556008)(66446008)(4326008)(8936002)(8676002)(66476007)(33716001)(6506007)(64756008);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?CB3B/GYy63xhYCG/s0x3f8NoT4BOt67S1c+spwy3z0j4BfvQpnHbBkNyzqfB?=
 =?us-ascii?Q?t8PgScK/3n8kJ0tPrGcnby5iGi33P8dlLHJbLvZwJ4ijytmyhP4M2Kn/05SB?=
 =?us-ascii?Q?MSln/f1/Y/k52VUeNRYTrelMEbLLV53QXc70/XKH6GJ9EtGLMR7hIclEg2gy?=
 =?us-ascii?Q?wLqurDQ8BK/VYsbMAODXxjBcTq9TULS0iEZ74ZaA6TANKBbDo/svMpfiFJz8?=
 =?us-ascii?Q?XtTxxaXr/tOjZeqjqK1P5h9QVGk6TdDbfeh2pzHTpF30uiJAkLUUaOJdI6fQ?=
 =?us-ascii?Q?qZGY74kM1hP6I3TZ93h3+wpyjOQpvijHQDpFSooc5mht7LrN6pvLlpedDaqr?=
 =?us-ascii?Q?XqHMTF8m7IlLU7DoFlKE1mXEV9RcSkjkP5AqStQ+5adzVloHZZT4032Uv5Ry?=
 =?us-ascii?Q?2mmZKrbZzcP70uqVh3dOS34haRf/l9iZGbR/hJMuN1AvUNo1N8142NFoeHaE?=
 =?us-ascii?Q?5oMdTB+SseAP7WSMx4WcdGNvkuW12atlnVSeW1R2hV99xYTzR/slAQPDkBaX?=
 =?us-ascii?Q?pC1LI7A96MtL8CmjWwaRzVptEPIQFSrBKgtvawSpjso/OPeMNIQF5/YAxycJ?=
 =?us-ascii?Q?gFPzAgNiS743T5S5KJl/75slKZQglce35xMlspwVJ07cCj3zyUTSEsG010j1?=
 =?us-ascii?Q?JNQ2sxpNm216rhZw5LM0c4HT/YVkhAPMewCDs9aPoKHfFx8r3mBakBSXEqVu?=
 =?us-ascii?Q?T1LfQsFxhozF83E5HSxS9ojnVJBMghdvnXyaBysd2rZTa58PyhqYy1M1D+r5?=
 =?us-ascii?Q?jszvcjcS/13ynI2pCf9Vq/gvoBGdoG1kFmsl/gNmcUzURbkBR/Ppp5Bq/aTk?=
 =?us-ascii?Q?1AKJ+a3eZyGnLpLgaH7VbwmvjCYvDyJc+7mco08Hb9Q/bXZ8mp4M9cd8a95q?=
 =?us-ascii?Q?S9d5FOd0E5dBJh+k13zo/eitkTjLVxqCxwJcIJVlXGug4etYudCwPQ6yMIlF?=
 =?us-ascii?Q?Xv4xz7iTQQ62qOvOeNHEqk4o4MA2afPrQxP2EArHBsUTm6U0z/8GDLrQmrST?=
 =?us-ascii?Q?A83dyfq5d6d3aoGe9b87xi6i3wkZcQpu54XhFRdbZUUgpHoxYyZr7jCdzqMi?=
 =?us-ascii?Q?ZeNlUzJygn2eP4z8MbKLOKC0BiDcVuBmbU9A5hGu8Mb5zrcX9qnIoVZP5/Hd?=
 =?us-ascii?Q?E7FyQwXT8Vgd5nFn+1X7egikVnmHUtvCuYEW1EB2yCZqXKufbWuZ/hQdBGQj?=
 =?us-ascii?Q?Dz2pddmT9x8N1GdVI7+Q5oxOPnXdd4//FiBEJIcRDyNGv/M1aoMe9scCSQS8?=
 =?us-ascii?Q?FxQYxLKgAdzFZzqG4/wcuxIv/fooHxtnfRLZ8kohaqUvSYx9DPDBHo6fs0z/?=
 =?us-ascii?Q?bHcTnGw8RUxjkEX7oM+CCLMzIyMY/SFO9nzJsY42e4yJbxjzpOzmcDKQaA7c?=
 =?us-ascii?Q?FJcFRxqj22S7oV0274Lt5/xhdyS1/fu2GNb7HazjTlcNY96rrhnR7X9qcnb+?=
 =?us-ascii?Q?VQ+KkUBLS9GizECcf+qmGBsNc2yXqhHGxnTnl+VfswYNDGYM+kdotnR0Ee5A?=
 =?us-ascii?Q?0kDg+IB2BfhfHRhRcRNV2p5IszaTCvTmg+C/RVliqkMnWkAcoVzSDvOBZfD5?=
 =?us-ascii?Q?1XhejNcCGHETE0l0ohpOsc03tKQSgV3HYjtTaylggzrQ3+R2rUyi6b8hxShL?=
 =?us-ascii?Q?kg=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <98BF04E0DD06C34B80D9E2CA7E9B6280@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 10df03c4-a6e4-4462-27c5-08dabe7af22d
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Nov 2022 15:40:48.4367
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 1CNObh92O0UTBGmcZB9XrI4laeZ8NC94C0cvRkAt2b4/BOaa8mqO0xFe+zPr9oZU6ouLffvS+ZkMIjTWcRZbDw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR04MB7976
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Nov 04, 2022 at 11:08:07AM -0400, Krzysztof Kozlowski wrote:
> On 04/11/2022 10:32, Vladimir Oltean wrote:
> > On Fri, Nov 04, 2022 at 10:31:06AM -0400, Krzysztof Kozlowski wrote:
> >>> diff --git a/arch/arm/boot/dts/qcom-ipq4019.dtsi b/arch/arm/boot/dts/=
qcom-ipq4019.dtsi
> >>> index b23591110bd2..5fa1af147df9 100644
> >>> --- a/arch/arm/boot/dts/qcom-ipq4019.dtsi
> >>> +++ b/arch/arm/boot/dts/qcom-ipq4019.dtsi
> >>> @@ -38,6 +38,7 @@ aliases {
> >>>  		spi1 =3D &blsp1_spi2;
> >>>  		i2c0 =3D &blsp1_i2c3;
> >>>  		i2c1 =3D &blsp1_i2c4;
> >>> +		ethernet0 =3D &gmac;
> >>
> >> Hm, I have doubts about this one. Why alias is needed and why it is a
> >> property of a SoC? Not every board has Ethernet enabled, so this looks
> >> like board property.
> >>
> >> I also wonder why do you need it at all?
> >=20
> > In general, Ethernet aliases are needed so that the bootloader can fix
> > up the MAC address of each port's OF node with values it gets from the
> > U-Boot environment or an AT24 EEPROM or something like that.
>=20
> Assuming that's the case here, my other part of question remains - is
> this property of SoC or board? The buses (SPI, I2C) are properties of
> boards, even though were incorrectly put here. If the board has multiple
> ethernets, the final ordering is the property of the board, not SoC. I
> would assume that bootloader also configures the MAC address based on
> the board config, not per SoC...

I don't disagree. On NXP LS1028A, we also have all aliases in board
device trees and not in the SoC dtsi.=
