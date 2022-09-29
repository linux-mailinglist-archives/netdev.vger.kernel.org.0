Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 66CB75EF597
	for <lists+netdev@lfdr.de>; Thu, 29 Sep 2022 14:40:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235578AbiI2MkT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Sep 2022 08:40:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37258 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235620AbiI2MkL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Sep 2022 08:40:11 -0400
Received: from EUR03-DBA-obe.outbound.protection.outlook.com (mail-dbaeur03on2069.outbound.protection.outlook.com [40.107.104.69])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A3320F50A2;
        Thu, 29 Sep 2022 05:40:04 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=eoCXPefD8tgcl3rVeJutxSxXTvGVUm32Ahculb0D+U4dTvRm+SEfGRQ/3hAJJEFrRDict9c9R43rv+Ni4k6rLJMZigXsMm+JFOxohKoBSdDnrY2oc+3Ful5uYC7AXnJPykMU3vdw4tms1Yp7JJX9M55QE55j2sIzKOdUTr7zpfhvKCQmn/86wn4CF61HE2vaPqcw3XL+Zv7UIqAk+RtBQJnRqBx5N6H0A20673HAxgq5cd5jNyDt7pABfzStS763LO+9uulUWYKOJqo49Z6NwmaDqG6ecNdl6riljvsvI58gMTcxHibuaTnSkwbqnUpSR/ZWekDY08TxOU6NGPWmfg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=MBpmg3KBjTY1dJBsgQWRQ6/CtV9VLEQJJ9xX5oavwGE=;
 b=fCfiRoLCi/x0HvlYWpZOdHfG24cfkF3kXZ67XJ4IpAXwOicfmjYTCOmgVtL0+DWN/2OYSZbTmzFmyZdteAkfv8Pv51dYexAvAe3AkeShis4xv3kEbN1uPnG2JTN1ycsLgR3JXFH+bMTZD/iBbnpz1nuyCQjFJ6lfwUESFpIVrMVGoD5TGgM2B/YMnG+HPn3Rkra5pV393xv6ypiMHMzLHzw+gqmIKOX+ixwa2p9T35y4ii7bHtFlQz5A/mTbHcy6Y1Fd39nfFjaIAyo5FAWkPl4OetO1bwrBIF8Kgf24rvrAgsOLyQsHofOCRLFa2RmWh9P5AqgxIenHZHrYPsuKtg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MBpmg3KBjTY1dJBsgQWRQ6/CtV9VLEQJJ9xX5oavwGE=;
 b=jq9C2Ev8nBG0wJh6rRZlYmaRRp6UCMRAv1FyXbS9Y2zEx8aJNHZEuf/xritdK6PUpTzf/IWBs/DjwXzIKTCNLp7Bot2bjIXTItoSSwbyp6W+26kc7cSVDWGS/ZcD6J0bWO93/CfpDdTx91CC/XzMU3k9wR/wf1vLbbl1V9HD8T4=
Received: from PAXPR04MB9185.eurprd04.prod.outlook.com (2603:10a6:102:231::11)
 by AS8PR04MB8753.eurprd04.prod.outlook.com (2603:10a6:20b:42c::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5676.17; Thu, 29 Sep
 2022 12:40:02 +0000
Received: from PAXPR04MB9185.eurprd04.prod.outlook.com
 ([fe80::a543:fc4e:f6c5:b11f]) by PAXPR04MB9185.eurprd04.prod.outlook.com
 ([fe80::a543:fc4e:f6c5:b11f%9]) with mapi id 15.20.5676.020; Thu, 29 Sep 2022
 12:40:02 +0000
From:   Shenwei Wang <shenwei.wang@nxp.com>
To:     Andrew Lunn <andrew@lunn.ch>
CC:     Joakim Zhang <qiangqing.zhang@nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "imx@lists.linux.dev" <imx@lists.linux.dev>
Subject: RE: [EXT] Re: [PATCH 1/1] net: fec: add initial XDP support
Thread-Topic: [EXT] Re: [PATCH 1/1] net: fec: add initial XDP support
Thread-Index: AQHY006sqGpD/PA5gEmZiYlRlE0jhK31oHQAgAC4dcA=
Date:   Thu, 29 Sep 2022 12:40:02 +0000
Message-ID: <PAXPR04MB9185141B58499FD00C43BB6889579@PAXPR04MB9185.eurprd04.prod.outlook.com>
References: <20220928152509.141490-1-shenwei.wang@nxp.com>
 <YzT2An2J5afN1w3L@lunn.ch>
In-Reply-To: <YzT2An2J5afN1w3L@lunn.ch>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PAXPR04MB9185:EE_|AS8PR04MB8753:EE_
x-ms-office365-filtering-correlation-id: a9b61a33-9585-40b8-e877-08daa217ba85
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 9P0IcVUxws4cf2upaskErY4EmM+bR7QDpm4OKigmsBapjZcn1Py+doNY/ZS+06KebTdIyO1O205FD06vowW99VjAOrkgTHs1zoaW74aUibIJnmxvzkDRSNDbgPDwAyy7JTrqN4Tww68pSQDTteO4It5gg3IUjLIZczjggOEAiv4XSsBl1o8Jx3dV8B79uPtUKoQQfgbf3IRevfBhAgFKjYShCY4EA6XOWnA9uObfzOwFUSzwvxOifmxTvIWwtVgCRkFEjd5734k7XDCfoJnMltffl+tYFv0CcRJmtxw5iipU1khYExGRJChS3LJqPi4zreCDcFJuGAqzx87omUEW9cwgiKmgzJsAs56pglpjQByM17sZ+ATTw8wo6nTg4hzLu1h6AvADSPFMvnQsz/7gApT4xsDK/SI2dr48iHCjwv00IjFVXeCF4ViYmXQ5+rTR41MIYL/R14By7/orify14YPMIMS5HQQL6h3ceAemfpu76i2iAvCC/YQeUq/X2CV0KUvsUW5vAl4WiSMdMSbyfpZlbSzZ/aCHyC5MXT+Ip9oft1/25dAlvjDMDrWpRoUd2HijsiMac30SifPr5vTlS8pc/wemHo9R4N/vYuNnVXT0DkJ4ywsLx7UzddY3QxHqVvKulaEY+HlsWreVAVPzcnaJhFxkpghN5epzbYShraaJL92ZzwvFHWNYsghouwSpx4unT4wdry27E+n0t4cgFQF2gRTSV9BOpiswTd7DQ/WU8n50bMAXhAutI987C/gm4N0WDEsUSe4ElIuJ3Watwg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PAXPR04MB9185.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(376002)(39860400002)(346002)(396003)(366004)(136003)(451199015)(478600001)(71200400001)(55236004)(53546011)(7696005)(6506007)(8936002)(316002)(122000001)(33656002)(52536014)(54906003)(2906002)(6916009)(38070700005)(38100700002)(66556008)(9686003)(26005)(83380400001)(41300700001)(8676002)(4326008)(66946007)(86362001)(76116006)(44832011)(7416002)(55016003)(5660300002)(64756008)(66476007)(186003)(66446008);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?pCOAP2SfafRfXJMNX/M9+Fledfq2rDbwmtLUV9cYDuQlI/d1MCsbKFd1z33l?=
 =?us-ascii?Q?RoLMcJLZhogg4GI2M4rj3qOzucK9p+y0KSG7tKUs+XRgDd0gNYypoOyHajCg?=
 =?us-ascii?Q?A0HaBNxWQuvhseYgm8v+snbegUV+nyeKxhLf5IvjjQg6tBwF4+zBeu3Ph5fR?=
 =?us-ascii?Q?hYmdtfjVnDZa/reyfXmiBt9ao4KBGfA/6hjGTbnhLwzM+1qvafFfSEsEiF+Y?=
 =?us-ascii?Q?ZPdIQ/YPO93ZOtzq4GdKvpvOXIIrdqvv5uWy1obXfzpbn/BjhmyR5uTPCkUc?=
 =?us-ascii?Q?3MYBJmHco+OfFhLZkLPaNTFrtlzZJUudV9xxsnCsPi5N1UknMBkVzfAFL2RE?=
 =?us-ascii?Q?HI9CM/RvZTcP0+iCcNxXRGaoo7/a17rblVCIIXIlvn877Fvfai3R3xYedXvC?=
 =?us-ascii?Q?S4JNhvEtCDMioPTS4jKW+G7BOy0vSlBzlMBCRu0WwCcgq6/pl65NTvsKN0d4?=
 =?us-ascii?Q?FVMExIA/GDlp+OswxOajJjJYbl1PA35TczwD6Fh6Kv54iPsa4hKAO0PjUfqJ?=
 =?us-ascii?Q?s/0tnq/+yyXQvlvwriIr6B8db6vHOg0Lh7bceBJXKjXLg9/Vmz30IEf1g77e?=
 =?us-ascii?Q?NRlTnWd2JcLV5738nzmMJG4vQC3kRnfP6h5XGxf/XfiJJaLtTcM13GdX4yh8?=
 =?us-ascii?Q?MflbXpZh3+D8sIq2/cBdhECeireZkp4J7HmdzBkV7x/DHy2ZgQ2pPCQwDNlP?=
 =?us-ascii?Q?aXxB3Plnz/3+elX1Yw8VePF2wWqR9lfMsLJHoB6EekwYIZszvHkWTZ6BWT2W?=
 =?us-ascii?Q?VIurBebIBgcSzKBf/rSDEnl8SlwApHXbJa3CekRK9X30Uv23/2gY3Ix5invn?=
 =?us-ascii?Q?Ty+vLtgNC4xjmIxlzWfEAstbt/xM/mtcTHvvm3Ku/08bShc0cKxSnRuW+aag?=
 =?us-ascii?Q?UCNXLWwNJ18GyC3mQASYhQN98Uyo/OiQRONGBf/QVVA44xlRisYvPTAUeyFD?=
 =?us-ascii?Q?EmjVOYpBHLs4sl/H7S8aTHMi4gzMqviFKAvTyCH/Gc5D7ll3LSAepp7UeZwJ?=
 =?us-ascii?Q?ALfy9QOc3m5wU8CNufwslh5qp4dWgpsufrRdLs/4kULCkpV+TFhLtPm5uZJj?=
 =?us-ascii?Q?zXrJk88czr18LN9I3EZDGStVBZg+WAAD1SnRmjV99H9dnMznnn2SsfWZa3+k?=
 =?us-ascii?Q?dy+ugaM+fdPEJkCoTl1OxOHKmvWfQTiWsueQvh2Gx/9AYJN6VfsUf60GijaK?=
 =?us-ascii?Q?TjgU59FtysuEJOhnbe0+L48DZ0pYJ5DDZSmAXBblzrKlYFhC5zpqVeS4qXfs?=
 =?us-ascii?Q?+JiY/msySXRBLMHb8AZ5vs4fo6piVIJbAurNlBWm9er2cJQwYMj9s0nRFwQ8?=
 =?us-ascii?Q?ZyWTq4+AbRXqqxg+yETF9ZS4/eXspGkrUpuzvaiPkCjF4DILZcv26caouxLt?=
 =?us-ascii?Q?BqXmnyANttB2/pVNahgh5HHoCd6dOjzHVHcNwmELwT76C9d5gHY3i0aZhM+y?=
 =?us-ascii?Q?RVArQUpHrYTFwCW+lk/ND60C6mdrY/1Gw+FUdUg5PZ8C1By1GOI61ozeo7/U?=
 =?us-ascii?Q?/J6qb3QpDhxNydWSUycAaGXuTDHPwlPvlOVGXYYvKKH/o6Pa3+BDL0g7d5Xb?=
 =?us-ascii?Q?AT5KbZHMQuzUZrPuswXZb6UIRUE85Y+JMhil4+cK?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PAXPR04MB9185.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a9b61a33-9585-40b8-e877-08daa217ba85
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Sep 2022 12:40:02.3319
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: deQMpgdUVpzxgHF1X9Ey2fxIvBWDgb8NTl0duB4Dsu2QPpaGjNJOosHSy14WrxRdj+PXuzyGztj/u98nvVPk8A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR04MB8753
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: Andrew Lunn <andrew@lunn.ch>
> Sent: Wednesday, September 28, 2022 8:34 PM
> To: Shenwei Wang <shenwei.wang@nxp.com>
> Cc: Joakim Zhang <qiangqing.zhang@nxp.com>; David S. Miller
> <davem@davemloft.net>; Eric Dumazet <edumazet@google.com>; Jakub
> Kicinski <kuba@kernel.org>; Paolo Abeni <pabeni@redhat.com>; Alexei
> Starovoitov <ast@kernel.org>; Daniel Borkmann <daniel@iogearbox.net>;
> Jesper Dangaard Brouer <hawk@kernel.org>; John Fastabend
> <john.fastabend@gmail.com>; netdev@vger.kernel.org; linux-
> kernel@vger.kernel.org; imx@lists.linux.dev
> Subject: [EXT] Re: [PATCH 1/1] net: fec: add initial XDP support
>=20
> Caution: EXT Email
>=20
> On Wed, Sep 28, 2022 at 10:25:09AM -0500, Shenwei Wang wrote:
> > This patch adds the initial XDP support to Freescale driver. It
> > supports XDP_PASS, XDP_DROP and XDP_REDIRECT actions. Upcoming
> patches
> > will add support for XDP_TX and Zero Copy features.
> >
> > This patch also optimizes the RX buffers by using the page pool, which
> > uses one frame per page for easy management. In the future, it can be
> > further improved to use two frames per page.
>=20
> Please could you split this patch up. It is rather large and hard to revi=
ew. I think
> you can first add support for the page pool, and then add XDP support, fo=
r
> example.
>=20

Will do it in the next version. Thanks for the review.

> I would be interesting to see how the page pool helps performance for nor=
mal
> traffic, since that is what most people use it for. And for a range of de=
vices,
> since we need to make sure it does not cause any regressions for older de=
vices.
>=20

I actually did some compare testing regarding the page pool for normal traf=
fic.=20
So far I don't see significant improvement in the current implementation. T=
he performance for large packets improves a little, and the performance for=
 small packets get a little worse.

Thanks,
Shenwei

>             Andrew
