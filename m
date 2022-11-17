Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E562F62D07D
	for <lists+netdev@lfdr.de>; Thu, 17 Nov 2022 02:15:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233955AbiKQBPu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Nov 2022 20:15:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57044 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229939AbiKQBPt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Nov 2022 20:15:49 -0500
Received: from EUR04-VI1-obe.outbound.protection.outlook.com (mail-eopbgr80070.outbound.protection.outlook.com [40.107.8.70])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A4978DFB1;
        Wed, 16 Nov 2022 17:15:47 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YU2E1lKl57xS5F9rmZ6xdwqNlwg6x34elsdafO852ZunHNpL5Mb5K+JYXbrH8IaQ8Z2055Cj2WwW/DZLC3AsfjPxtrtkBM1OvR5xHXBBumX+5GZwVBKi9cdwIoHTIbuFHsCeGOjzzjC5LWEoLjHb9sNSmub5HdOR1DDQJeCx1WyKr2pgGRv+p6WITaaaqw4liqlfUhurD90OMEXfLeLuRDAulho5AGfIbzc9tR2Job9qQDdnd6cnZ0wK2WveKlRFZJc291kIm92I6t04xH288MgRxDyF2f/7AP3bEGGW9GazbTmVBYmZBS5R2oLqMVPIZGNdwqCytS8voa7HOkehsQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PE1wNtbyZcu3LqjehuzcX68267zG1FhZXKWmquZla3A=;
 b=dpj2/OCWwW1JzMO4PDGAbcL/RB03+/mIAU1slqCrF1cJ1lo5ECFPTjBjzK5u80yhJ8MTAc4/Pr1iaBtV4OX2flAospPQKmBpqTwbQiCzN+d2qoSqDRArbcXssXeLG28JrNYQo+/8XdOj89B2/sQUYRv1xub6hqXVtp4g94haRUhQBNQZ3ZsWD3g6O1M9+Om+6Qxi6RlTjyI9t4tkRiCOk2QD+MXMaJZLuPZN9e42TsC6LhyROMqghg8XTRxK0M4w2tEE4wy8iQk4OvJGNT3a7SgLJVLljkMgqcA3H2geuDxNQfVd/rui4RGA00b9fEfSsVkPzmie7CEaBZt/xknTvw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PE1wNtbyZcu3LqjehuzcX68267zG1FhZXKWmquZla3A=;
 b=Oq9nltX5BPOKt3A7gRC+D/VEt3b0GNJGZyAzI/h47AZ1dT+aOgQlfISQpZJOgO/YYekqp8cSgp9nI1uEYn8TSZfbJhDTQkipe9hUKltIBy4evrmbSn4QHrLQGc5hQ75ehaaMLvuJ5MM/XqKX779lDVChFXuFJXJOHPPjSt9AL7M=
Received: from PAXPR04MB9185.eurprd04.prod.outlook.com (2603:10a6:102:231::11)
 by AM0PR04MB6916.eurprd04.prod.outlook.com (2603:10a6:208:185::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5813.17; Thu, 17 Nov
 2022 01:15:44 +0000
Received: from PAXPR04MB9185.eurprd04.prod.outlook.com
 ([fe80::6b44:4677:ad1d:b33a]) by PAXPR04MB9185.eurprd04.prod.outlook.com
 ([fe80::6b44:4677:ad1d:b33a%6]) with mapi id 15.20.5813.019; Thu, 17 Nov 2022
 01:15:44 +0000
From:   Shenwei Wang <shenwei.wang@nxp.com>
To:     Alexander Lobakin <alexandr.lobakin@intel.com>
CC:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        John Fastabend <john.fastabend@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "imx@lists.linux.dev" <imx@lists.linux.dev>,
        kernel test robot <lkp@intel.com>
Subject: RE: [EXT] Re: [PATCH v5 2/3] net: fec: add xdp statistics
Thread-Topic: [EXT] Re: [PATCH v5 2/3] net: fec: add xdp statistics
Thread-Index: AQHY+TPeAaUOROa7LEatDrU3+Adq865Bty+AgACaFLA=
Date:   Thu, 17 Nov 2022 01:15:44 +0000
Message-ID: <PAXPR04MB9185C6B616C16CF8D1DEB71789069@PAXPR04MB9185.eurprd04.prod.outlook.com>
References: <20221115204951.370217-1-shenwei.wang@nxp.com>
 <20221115204951.370217-3-shenwei.wang@nxp.com>
 <20221116160215.3391284-1-alexandr.lobakin@intel.com>
In-Reply-To: <20221116160215.3391284-1-alexandr.lobakin@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PAXPR04MB9185:EE_|AM0PR04MB6916:EE_
x-ms-office365-filtering-correlation-id: 4160c248-e2bf-4520-f80f-08dac8394053
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 9aVckXRSroFjy/fRbmz8Q3RbHablxOZQ45zRG/qH1+OYoUeeTujn0q5hTbEz8f0CDB4OHBqCGtilI0U80Fte35LttsZqSlX3nO31Ghkuy53HunGMEB15vWz6Y1If06Wskr6oU3PVfruyMhV2faztqF+EDXtVgL3mQTrA8BysYscpdtYroNT2rp13TzDoY+ygeEAdtyxLa2I7oOPOir73OgHl7pV52FThw0CBr07BRCjti1+lPK7220DP6SNKwFSbJohs8SBs10FPzgGONhFYwfugDjIAY+UPgLtCNZDAwijPcpETFctK0J5b7KlI9VYbHaiy9XXZfso4tx8ongyGDsLXMgFtMcFdQpIcsDFPJk4bTUasoMvUlvZ/Dk8hjq8mR/jFUU0U8Z8HLRNrmGJlvXR1HEYBhTiYyPBG1Zay2eChm7fYT/uOzag3P7JOIf2ID/a5HbEaMPzph2nDQJmdJHFKnQSbWCdXCMIVKFEBwYor0UXTBKfx33BA+e+m/6QRvHgz0/qW5BxtkkvLTNOKbdkYVN95LJ9KlcvQj1W9MBLtw/BispXY2XPGvH61OD54n13h7YAK6wO1yH/0fpVVZr7FC3KpgSMDiyD2bynW21HTtuhsm49KFlgLwh7KuMzYxpdAhmb4Y+DukR5BB4UOe+ar/AL0wg6v85rPVJbLpqDHFMoKfI717XWx5iLkmBqIn+USOfi4fqo6hI8QmdK9WhxC22Zxe6Cng3GUF3+WBJLi+/Ek245Z+Bfmjwf6XoNLKGh7UVwFuyxfeCr0Ubq+rg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PAXPR04MB9185.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(366004)(39860400002)(346002)(376002)(136003)(396003)(451199015)(8676002)(64756008)(26005)(4326008)(66476007)(66556008)(38100700002)(76116006)(316002)(9686003)(66446008)(7416002)(186003)(6506007)(8936002)(122000001)(7696005)(41300700001)(66946007)(53546011)(44832011)(52536014)(2906002)(55016003)(86362001)(38070700005)(83380400001)(33656002)(5660300002)(71200400001)(6916009)(478600001)(54906003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?eHmdoN6MpWufo3oAtsGRHRyRG8GRwNSNuNHZQm+X+3X+iNNRa99xkHBy/BUy?=
 =?us-ascii?Q?NRB506l27jyrKL7sYAtCp9lCpoTFmnHFCkPrJXUhJEwMF8Q5XlATwkDrFlPB?=
 =?us-ascii?Q?t2jSHNDFfwtpiuLxXoTKq+hG71TSfpzDgkb1jf4nNv6oA9rzBmJiuHsAFWzG?=
 =?us-ascii?Q?u6tePGOOdSryTmtJC2Pq+G+SZHqCFh7V0E/2Mqq73c36oEGuKNmUNuOP5UH5?=
 =?us-ascii?Q?dcnooxr21TlZA2wqwzR9zSvg4kW83+rgGKHz8+YUmA4WQid83OzkYWQGBGFP?=
 =?us-ascii?Q?5x/LUJdrxDlx10LXIfBE5KU/4fwdXWJI8R7s2NAYnmhymMNzRiI44t3Bm0c9?=
 =?us-ascii?Q?UmSbiJ53CYk43XniZp7FBmZLgjz0j9AbTK9xP/PD4A9xBvrD5ukQqR9QkMk1?=
 =?us-ascii?Q?ntaBf4ja9E0mQFH8SxOrRWvXRnRWwaOvKEn2rmg5NrRVfPtglsps64K6yoY1?=
 =?us-ascii?Q?uWRlCYDY9fSQpL64xWMhGxjeaxIorOPUGSp0O1i2faetmKjE/y/qz5S30zQr?=
 =?us-ascii?Q?V1CXTNGRcGWV61OLQFsX2dfsch2QAVw3gGOvH4C+Sx88r096t/OhzMOnwdct?=
 =?us-ascii?Q?r6ce6V2IOkiWGXjwa3U4TNyGUf7hNfZP0Z0F142JzZ+1SF7XBTqVX3nDnu5u?=
 =?us-ascii?Q?qG+KOrTIcOyauOpUopncur2Y+DYFvSmZR2UWc7i1cOQYDN33yrxIjtBIIGHV?=
 =?us-ascii?Q?CcWpt7X7HaoFGZBqMjbj+tNWgUaZwor9c0xVnMLPyLwyPJHIxVFS+sywN9QG?=
 =?us-ascii?Q?8rxUb5so51hgycr50AlL6CUaVVUaRbYUEEuyocKItfffrQqQf04Y3lmYKqvk?=
 =?us-ascii?Q?VOb7WzlUvQ+BtMxdEJ38XJGCt9afeCF9d4ya6sK/aj0Puyj0Srjfto3H/0Vx?=
 =?us-ascii?Q?KCqIait65VqBXss6duxcQCS8Ya9tesYjS7wglPC1inETtDVH8q4o9FxAxOGf?=
 =?us-ascii?Q?RA6/cKGPp+TFgRWCtHbOcC1J8UhPsg3a4K+Q6yWYykxAENPkavL0P7gYPF99?=
 =?us-ascii?Q?ehitrb0hriPn6bLUwUNedngPQbOKZ6oj3n1qUFEYcdov+wLJnlazxe7CU8tm?=
 =?us-ascii?Q?ESSphd8TLw0K5Qqje+DQQK+3WQXq3+UBuPwwU9Yy9MPbRa6l4LPdyTWcNVUQ?=
 =?us-ascii?Q?F+bU22ta/tWggwpIgycVudbO6RMp6QNfQdxtnUQfZsAuHHar8F8sJnYrvRpc?=
 =?us-ascii?Q?r1XPwW5T2c3My7zl/N4mz3F1oCTbq3kUQl4ocAzmTjHeH9zZS+0hpVeR3TYf?=
 =?us-ascii?Q?rF1vEGR1hh8ulOuh2FscSLs5af1yCXiKDBG6cPdtJc/s3nd8rhjIoFIvDlNN?=
 =?us-ascii?Q?vcsd7gHuiHErgq177bJCUQVPQKXNHJ3BE9LVjXvB840RqYIbTFFPc4hYxPag?=
 =?us-ascii?Q?J3Wvvv17RoTLOPEZmuYNrh6Tiy82D2Gmz38nBvBgz0n1vE6G6brj3RiKQbeq?=
 =?us-ascii?Q?dEPmPHEfxp8Ht/LpilLJJk1Rva3xaZM4GStpXt7Z44b7e6Og6cfQv0NqhssF?=
 =?us-ascii?Q?RE3lPpxWns6s46dinQxDzvhKe/FxfpWmsGnj1I98qK9kZ5rzW+ftvAIq2CEA?=
 =?us-ascii?Q?TbLCaGxnQiz+EzFYFkh79VzMSOeU8MpS30TI38XO?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PAXPR04MB9185.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4160c248-e2bf-4520-f80f-08dac8394053
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Nov 2022 01:15:44.3657
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: iWJ6jRGcMUGgUqSLK7o+AK+B1aiwTpxQlMBD6hU40XJo3P34GsFEda7k+1wJN0848zmrI8ZnDBIlpFrIpkUXzA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR04MB6916
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: Alexander Lobakin <alexandr.lobakin@intel.com>
> Sent: Wednesday, November 16, 2022 10:02 AM
> To: Shenwei Wang <shenwei.wang@nxp.com>
> Cc: Alexander Lobakin <alexandr.lobakin@intel.com>; David S. Miller
> <davem@davemloft.net>; Eric Dumazet <edumazet@google.com>; Jakub
> Kicinski <kuba@kernel.org>; Paolo Abeni <pabeni@redhat.com>; Jesper
> Dangaard Brouer <hawk@kernel.org>; Ilias Apalodimas
> <ilias.apalodimas@linaro.org>; Alexei Starovoitov <ast@kernel.org>; Danie=
l
> Borkmann <daniel@iogearbox.net>; John Fastabend
> <john.fastabend@gmail.com>; netdev@vger.kernel.org; linux-
> kernel@vger.kernel.org; imx@lists.linux.dev; kernel test robot <lkp@intel=
.com>
> Subject: [EXT] Re: [PATCH v5 2/3] net: fec: add xdp statistics
>=20
> Caution: EXT Email
>=20
> From: Shenwei Wang <shenwei.wang@nxp.com>
> Date: Tue, 15 Nov 2022 14:49:50 -0600
>=20
> > Add xdp statistics for ethtool stats and using u64 to record the xdp co=
unters.
> >
> > Signed-off-by: Shenwei Wang <shenwei.wang@nxp.com>
> > Reported-by: kernel test robot <lkp@intel.com>
>=20
> Nit: would be nice if you Cc me for the next submissions as I was comment=
ing on
> the previous ones. Just to make sure reviewers won't miss anything.

Sure of course.

>=20
> > ---
> >  drivers/net/ethernet/freescale/fec.h      | 15 +++++
> >  drivers/net/ethernet/freescale/fec_main.c | 74
> > +++++++++++++++++++++--
> >  2 files changed, 83 insertions(+), 6 deletions(-)
> >
> > diff --git a/drivers/net/ethernet/freescale/fec.h
> > b/drivers/net/ethernet/freescale/fec.h
> > index 61e847b18343..adbe661552be 100644
> > --- a/drivers/net/ethernet/freescale/fec.h
> > +++ b/drivers/net/ethernet/freescale/fec.h
> > @@ -526,6 +526,19 @@ struct fec_enet_priv_txrx_info {
> >       struct  sk_buff *skb;
> >  };
> >
> > +enum {
> > +     RX_XDP_REDIRECT =3D 0,
> > +     RX_XDP_PASS,
> > +     RX_XDP_DROP,
> > +     RX_XDP_TX,
> > +     RX_XDP_TX_ERRORS,
> > +     TX_XDP_XMIT,
> > +     TX_XDP_XMIT_ERRORS,
> > +
> > +     /* The following must be the last one */
> > +     XDP_STATS_TOTAL,
> > +};
> > +
> >  struct fec_enet_priv_tx_q {
> >       struct bufdesc_prop bd;
> >       unsigned char *tx_bounce[TX_RING_SIZE]; @@ -546,6 +559,8 @@
> > struct fec_enet_priv_rx_q {
> >       /* page_pool */
> >       struct page_pool *page_pool;
> >       struct xdp_rxq_info xdp_rxq;
> > +     struct u64_stats_sync syncp;
> > +     u64 stats[XDP_STATS_TOTAL];
>=20
> Why `u64`? u64_stats infra declares `u64_stat_t` type and a bunch of help=
ers like
> u64_stats_add(), u64_stats_read() and so on, they will be solved then by =
the
> compiler to the most appropriate ops for the architecture. So they're mor=
e
> "generic" if you prefer.
> Sure, if you show some numbers where `u64_stat_t` is slower than `u64` on=
 your
> machine, then okay, but otherwise...

I will take a leave next week. Will do a compare testing when I come back. =
Then
we can decide which way to go.

Thanks,
Shenwei=20

>=20
> >
> >       /* rx queue number, in the range 0-7 */
> >       u8 id;
>=20
> [...]
>=20
> > --
> > 2.34.1
>=20
> Thanks,
> Olek
