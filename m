Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8D59561FAC4
	for <lists+netdev@lfdr.de>; Mon,  7 Nov 2022 18:05:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231995AbiKGRFB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Nov 2022 12:05:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54418 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231302AbiKGRFA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Nov 2022 12:05:00 -0500
Received: from EUR05-VI1-obe.outbound.protection.outlook.com (mail-vi1eur05on2063.outbound.protection.outlook.com [40.107.21.63])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B36D460CD;
        Mon,  7 Nov 2022 09:04:58 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=c+gNk+qAx19QIKuY1RFFOCLhleC0ki+TFot+YfuvmNWFP2locqohzv+FMBzvK7TeGBTy9UPfqZsR3KzwqsvbtzPkbFMP/amzttUYc4vWaGeZ/+bLMeytueFFK+6a3nQLVsgFTn/x607EahQKI47yPjnbdO9kcTJsyz8uDttL9GH4CDPdEJBQgstz4pvDRuOMjoGuez1MBFabHZs81RAt6yBpRzpP50PkTcoH837y8la/tnyw0uphYLUCipO++eBdgg/P4UbhrOwzu3RLoca6cCiLN5lHvsNJ8xlnnjo2S4c8k7JUdoZPsK9646JP3T1V3U2mJ/eN0xo+2wgGyzgAEg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2CR6kinhAIkUAOOeCLXQni//s064yQHn2u47KSNtmPA=;
 b=GzoYKZkKupp3iSZJT4NpVFLxCv3+PQ6P64x7zU//w/3oTlvK73/0Ornc68enUhP9lAEBuSOCkMJiPGAgjH31s4bzhGoWkt82Z6apT7quP8VaMkgwvmml+rUcfOgDThYlqSVeyz296CRyeigaHA9UBufuAH4ilUTAe+UCt8FqIyw+x87yIcqBTSp8aZFa12XEbsZ1CEiSBt++syJBArZSgpkFlj2gAd8uG5NFdnv1rGvIBEok+oJdjTTC50bwe7ZlhWkvd3JSd+vQDSEo6JgrI9o0rrdkZsB66wSwFTDdp+QTvQjH/OnlGj4n4KcQQPcetgP70F8YhYiniC2QWFrPRA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2CR6kinhAIkUAOOeCLXQni//s064yQHn2u47KSNtmPA=;
 b=MAMw3n2qsNkDiosVJH7ymtqVBc3w41vI4zJ/LDdbeyqsooS0tmPdm7bj/SEViVgIXFUgZaFixUdMp4lXt6LreIHjn55Bg3UnbiNqUpss9UvRbieLsj4xNBYHnN3OeMxgJJGtsudIUHiaIKf8rzlFQNjeV0ykcwa2FQA8z9K7CkM=
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by AS4PR04MB9552.eurprd04.prod.outlook.com (2603:10a6:20b:4fb::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5791.25; Mon, 7 Nov
 2022 17:04:55 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::4a73:29eb:28e3:f66d]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::4a73:29eb:28e3:f66d%7]) with mapi id 15.20.5791.024; Mon, 7 Nov 2022
 17:04:55 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     Maxime Chevallier <maxime.chevallier@bootlin.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
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
Subject: Re: [PATCH net-next v8 3/5] net: dsa: add out-of-band tagging
 protocol
Thread-Topic: [PATCH net-next v8 3/5] net: dsa: add out-of-band tagging
 protocol
Thread-Index: AQHY8HTAfetHoGxM5E6HcRPQNrr8s64vpgIAgAOw8wCAABdsAIAAQokAgAAESoA=
Date:   Mon, 7 Nov 2022 17:04:55 +0000
Message-ID: <20221107170455.dqyf5lf55lot2hra@skbuf>
References: <20221104174151.439008-1-maxime.chevallier@bootlin.com>
 <20221104174151.439008-4-maxime.chevallier@bootlin.com>
 <20221104200530.3bbe18c6@kernel.org> <20221107112736.mbdfflh6z37sijwg@skbuf>
 <20221107125126.py5n244zk3inawsx@skbuf> <20221107084934.157becba@kernel.org>
In-Reply-To: <20221107084934.157becba@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: VI1PR04MB5136:EE_|AS4PR04MB9552:EE_
x-ms-office365-filtering-correlation-id: e56b8ef1-16db-415d-bbfb-08dac0e231e7
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: YQ2oL5oYjcjdldZPtLn3OXBVLlxmw1m3w+wgvr7fpYZSXGojbeU7iiKY1WXZlwyZz6fZqLh7h9XenNzHTLwqN2bR8iCWb4ATSbYpVpfKBcz4qCydhmlbmU5skU8TMQxmZyTC7OhmPD0OPg5nSIElH48d+pHSlPF1XNqKNl18u8Udw5xuZodonp1kBxHUxuBEw8HA5OrDKRSAX98Qwr8ixR6fJrwQqOp68gLcPs4E6gZrYIYhKbf7gCM8d5UN425Pr3gOTyhthbObTrEfbQCPA4Xr/BlDzgSo6pfSql8VBldwbX8Y+TLMwaVD3uSHjPgbZrv9UoGEbBzaKgO97EV1dJK8kD0BXkPmDAbSDrI8h87khjEOYMVrR9dpzeikEdV+gpc4bEsi2Lj7/y0Ipn/audHosdHntXKpi3bS4j2DCRU0JhHWnTRWIoYc0BwJFZQ2lezbfelOIPNKMoJE8F+HIa6iNEansLeg8bTNKXeaNCOboqFWuGhZniyWoHdmQxIRlg8Hy65WeHerGbTEHXdyjsPb1j3zI0IBfCrjpbsBRUXcrH/7kXER5G6qwVw7YiBnnfwV1eyL6SU8jgYnnOIYF3xjIogZCNsCGArMdTVuvNI9K7xZonDHscLEqNbpBQ1uFinay/MqdbUBbuVorZldWN24LyOAiNWgbNcMzb5fdx97VP0syeuMs3Mn2+Ar7i1dykUGz1HJ54Nu+btaAvErs5gW8orWtM7zPSEWyWOTtMG2KQYcTLnpg2FL74+xMGImjsXVwAEJT0gwkyvjOYmdnQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(7916004)(4636009)(39860400002)(396003)(376002)(366004)(136003)(346002)(451199015)(1076003)(186003)(33716001)(54906003)(8936002)(6486002)(5660300002)(7416002)(71200400001)(38070700005)(2906002)(6916009)(44832011)(478600001)(66946007)(91956017)(41300700001)(66476007)(64756008)(4326008)(8676002)(66446008)(316002)(76116006)(66556008)(26005)(6512007)(38100700002)(9686003)(122000001)(86362001)(6506007);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?w9XC2G976XBUZIQEgAbyZN+UJ9feA7vB8yrQbXt3wYhFHNYBS6RIib80NktR?=
 =?us-ascii?Q?BPFWBn6akImTBPwcU9FhMSHZsUGwLXVqQfD5mr2fcHnnJlSLadYcoNroEaSG?=
 =?us-ascii?Q?Y3y2vS1zuNRKWv6/Hk2kdt2zOwygE9i94PpVlgwaEJ4PLwNDxuF6ZevRizzm?=
 =?us-ascii?Q?BtU1h/QYv0VGkkv7qcPxLKxfJFgEVSZ3U1ao5esu0Nxb3JrjC9YF+O17Rfaf?=
 =?us-ascii?Q?LormMzPVrj5j55SpGPjoKrvJ2Igguxnj+782tzU6bCaNOVrLJrrmwCYvrQ2c?=
 =?us-ascii?Q?E9p82gHMLMYx9Y5h5n/jNYG6q4Nf3nAgl/ccnJbfPj3BILG96KFJWE+m1vya?=
 =?us-ascii?Q?Hy3FtgU0G3dSe1nrAD/Ca06M+V62AVPQuxVRDR9lyUHtkEsnIyKfL+pQ5pos?=
 =?us-ascii?Q?qCrFz8SQZzvPFCVxq6xDyn4Qoj+SMD/eiLPKR9ZGnQjZfUhD4tdpT/PY7iSJ?=
 =?us-ascii?Q?t3Yjk4OOOb0/SqgBJZuu9TIAXgfXZNwW7wEltVI1ANTvl+njB/QQ0GryzI9j?=
 =?us-ascii?Q?ZH3iDWvVo89YNXxD50X/bQ8iKnWSG9S3KF+YBZ7GSg3fq9WRRt8X3q0ZZiIx?=
 =?us-ascii?Q?FNPszOpgR9oV7TIgApREOgsh1d/ALo1SpTMtHl6uan4cHnJ5YyzCXft0f3rg?=
 =?us-ascii?Q?rHOo1dDsNY3kE8+A+WH638iNThGevJhn1Q65aOrd/bEgFpLlHVZhnuHpzBn7?=
 =?us-ascii?Q?yK4ZiBrnUH8rPZe5AlraEjO6tWq3bHfLEE0LQZ2hI9VdoO0vfgL7/KyMfCOv?=
 =?us-ascii?Q?SAdnNdGAxQEP6XvDFgdeB3s5FJm3McWvEu+FMNc8e6td8hRhoYTDKU3z1BTN?=
 =?us-ascii?Q?kRm7XkvrkWWwG8OnhnzvSpPCkDnaFnt2szFWYCkXoRBNRkGgudAvsX0fvFIB?=
 =?us-ascii?Q?84JUVovP2Mj4EYxeBXF7q2uPAfcyNVgGucaI95Gg/dt6xA24UpULb3kEinTC?=
 =?us-ascii?Q?buaNYSinJ3mUEUgG4lE3+N0yswnIjE+CfLx/xa3oXx0lbTe5bO3fuhmrlaql?=
 =?us-ascii?Q?2V650IZiQVyj4zYU9pohWrTdr5gJj8Tfc7mdYtuOQZEsHqfZv5dg3Nv6IegE?=
 =?us-ascii?Q?P+7341RWaY5+ufs/kbMNkyznuWFNhquXhsAJQ9lzlpNSNimFNM7EmHhizLum?=
 =?us-ascii?Q?WW7hkpRVpccEtKvcmPTD03g1EOXErkaOdzJL3tEVbgspxb07sB54ekpVhnZs?=
 =?us-ascii?Q?mEtFDHUINq5twV+TxIkAladU97r/WP2wxwpKQ7fpbw1MMmg1Gx8nTZxudMQe?=
 =?us-ascii?Q?Itxv8gb57KMiNkEKwR+EYYsgXzlhyxYpJ82XjQlEJCM7+xYoj3I13ooqA51g?=
 =?us-ascii?Q?qRGYYNVKaN/49NWwZ6xoyBXd4nE+zJIUNmhKDGFdYjPO+coOVeP+xmTAFTGr?=
 =?us-ascii?Q?4jVIzmS36OhaWHwu9iP8t8CZ+E+bEEcVRgxTWIuKLarlLeNX8Dpg1Ul6Y4LN?=
 =?us-ascii?Q?RzHERCLKP0cKMZNTpYW575SDAom00aJpJqr+30D/nre874jvgZIyD86lAUT/?=
 =?us-ascii?Q?76xnWpXYVL7zbxcSNJ3C+vfh8FzKgOvohX7klPuLIw/CKdfqr1A7wD1DZujB?=
 =?us-ascii?Q?cZYFrEKRgqDy0H2oGXBIAn2SI2HlOhztp4+GQl4COtL7gxPe+tAjFbn+m7we?=
 =?us-ascii?Q?2A=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <958660427AE74C4B86FBDB70EB012860@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e56b8ef1-16db-415d-bbfb-08dac0e231e7
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Nov 2022 17:04:55.8602
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Z4pksT+NIR3s6TZNMmm+6AjmE/vi+tZPiOmgZjcTnLHtxjT76g3kttvCn7mCdqKAOWfieGFFPT2Ma5m9/SIOhA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS4PR04MB9552
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 07, 2022 at 08:49:34AM -0800, Jakub Kicinski wrote:
> On Mon, 7 Nov 2022 12:51:26 +0000 Vladimir Oltean wrote:
> > There is also another problem having to do with future extensibility of
> > METADATA_HW_PORT_MUX for DSA. I don't know how much of this is going to
> > be applicable for qca8k, but DSA tags might also carry such information
> > as trap reason (RX) or injection type (into forwarding plane or control
> > packet; the latter bypasses port STP state) and the FID to which the
> > packet should be classified by the hardware (TX). If we're going to
> > design a mechanism which only preallocates metadata dst's for ports,
> > it's going to be difficult to make that work for more information later=
 on.
>
> The entire patch we're commenting on is 100 LoC. Seems like a small
> thing, which can be rewritten later as needed. I don't think hand wave-y
> arguments are sufficient to go with a much heavier solution from the
> start.

I don't think it's as hand wavey as you think. Maxime did not present
the switch-side changes or device tree in this patch set. If it's going
to be based on drivers/net/dsa/qca/qca8k-common.c as I suspect, then it
might have some obscure features which are already supported by 'normal'
QCA8K DSA switches, like register read/write over Ethernet, and MIB
autocasting. If these features exist in hardware (they aren't exposed by
this patch set for sure), you'd be hard-pressed to fit them into the
METADATA_HW_PORT_MUX model, since it's pure management traffic consumed
by the switch driver and not delivered to the network stack, as opposed
to packets sent/received on behalf of any switch port.=
