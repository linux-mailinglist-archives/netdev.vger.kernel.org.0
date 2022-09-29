Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3885A5EF5A9
	for <lists+netdev@lfdr.de>; Thu, 29 Sep 2022 14:46:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235065AbiI2Mqf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Sep 2022 08:46:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53982 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234880AbiI2Mqd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Sep 2022 08:46:33 -0400
Received: from EUR05-DB8-obe.outbound.protection.outlook.com (mail-db8eur05on2079.outbound.protection.outlook.com [40.107.20.79])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 83E7613C846;
        Thu, 29 Sep 2022 05:46:31 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Sj8gquFjJPbtG/7AblNEo4WavehRgDAXqKcAGv/9E41ORcZhI/7pjyuf8zYITMxzd8E57G2cgmjdWbDwoh7gXEHBsg46ADX0V+lVCw+wwq5V8ElKilJ5QHe+9Dfz3kX1KDYdhqv6gNj13PhV8S+N9GMRe+FHw5+EkRNe41LiFxQvW5jQWAgs4VpycEurvJNJBsPxF7SUyZ8Kp5PbtRgXfCY+OmOfU8WLIb9zX0C2a1ezONrJ6mzFX5UsF7a69vIOxFX0VhIuqC9Wre5xisaYzOy0wheXX2hCMbxbGqaS5Eeecy6RwyFw1FFOWYr7nRLLRT4ohwpAlbI4adai7CYiSg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9AMJ2s+AOUujP/fAtsiB+D1o9Ix2brg6lcJC3/btTp8=;
 b=gyI5aNzS7l7P6OE4KQJdGrmK0zTY4IhcP9rQ9gihqZlA6PHLOsESpjmu19m2qmfIqfqd8O8wPiqivRNO3rPe29x8Ft4WRc6hufwz6NgAFw6/2suphRrF/2zbs9F4xIhFIMwXMbuUPeyV0R7vz+JX7WKPqwXMt4RHI0o0+MTjhjwlj4ZAZaOAQ8F/UYWr9CAR9YYhc3Q+UKeSMtlsLa2C4JLE2MjaKX2051nW3qhRG6RtV7PEiImF4EQHP+NJ3lpNesM4lDL+qsaHqOL1Dstn3uhNE3ms6AlVA/ki4pXIhXo15rsmdy5bCwNG1Nt9r6xIFp4RS1dJ6pnuEmSeJQlf1w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9AMJ2s+AOUujP/fAtsiB+D1o9Ix2brg6lcJC3/btTp8=;
 b=KgURH1tyPlOQ7k148ofg81UzQCZdWUXrEo3trDtEaWyOaEbd9TlU2v36nEkmvEsP1K2X28IoOG1pc0mOwx7q3YWz/mQzauCZhI6qpvjgPdt5OkG6zOi+OPlVi4jy+v+AaROOnOz57EgppzkUt+AbwTQDAgNprsEMlE1k0x+Yl/8=
Received: from PAXPR04MB9185.eurprd04.prod.outlook.com (2603:10a6:102:231::11)
 by VE1PR04MB7375.eurprd04.prod.outlook.com (2603:10a6:800:1a8::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5676.17; Thu, 29 Sep
 2022 12:46:29 +0000
Received: from PAXPR04MB9185.eurprd04.prod.outlook.com
 ([fe80::a543:fc4e:f6c5:b11f]) by PAXPR04MB9185.eurprd04.prod.outlook.com
 ([fe80::a543:fc4e:f6c5:b11f%9]) with mapi id 15.20.5676.020; Thu, 29 Sep 2022
 12:46:29 +0000
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
Thread-Index: AQHY006sqGpD/PA5gEmZiYlRlE0jhK31pSmAgAC11xA=
Date:   Thu, 29 Sep 2022 12:46:29 +0000
Message-ID: <PAXPR04MB91859C7C1F1C4FE94611D5A789579@PAXPR04MB9185.eurprd04.prod.outlook.com>
References: <20220928152509.141490-1-shenwei.wang@nxp.com>
 <YzT59R+zx4dA5G5Q@lunn.ch>
In-Reply-To: <YzT59R+zx4dA5G5Q@lunn.ch>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PAXPR04MB9185:EE_|VE1PR04MB7375:EE_
x-ms-office365-filtering-correlation-id: 02fb5de1-c259-4b0c-3a03-08daa218a13d
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: TLo/nvR8tgnu/JDBCFfprg2/ULt5Cd7WENyUg2+1Dg/36liw++cEdFU2bO2tBO2pzAxPnkJ1MfNJfH6SaZiF1ZBz0NYuiHnshRTuR32HP0D0PcqVc/jjV3saGOOCzY7Q2HnVkjHPBKh89yfPFo9zY7G5Dcyk6dr4G/VBDI0i6ayd7LC1t6oFMbrSYlmdcpsheiMWVuBhyWyTh+46NwsFizGgK15i4o3qLLZBGz8KNAi5dxuF1phdMDFUr+VMICZjxTcX0yACCPvgiGwWSqqc2HorKUv5pPClkJudcGBTFO3J45RqbJHrq7CB74RjQ/tZbDQElb3csztM0vACVB6RVT4HPGV4XFA90gKdUSpkwLOzDzRURQMp2yTmEbUh4NjXL47BpY17XOT69nsuH3oBgT0ZeWnHbT2V/xHLkb3OeExpVpJ1qy4EO6NNMEkVgoEapaD4UokGVdjTC2aDJkAIaEIoNruqLnX+9P9kmCZsQI70N+dPct3QDOxfNzdcREDpUvneP27f0GK6i1OL58YthhwDW7Kn61UlNHTIES/mBm8WyyNPO9AGVrDwvaMcQvnbQOxsFcO31AeX3bU06hE3mc4fszSi1+Bu8Ld2eoUckiBWl5ByIar6cHOtPqyTG1weud4GXgZtEEksdkcpjT/FPF3lu2LFKcqjrQqJs4FRh9e4F2YS3mPB7OckXI/pmxdVqkXJ6Azg5ozZ89YYRmTZDP7/qtU0vYtR+bO52b7rk1WbTKGz3nQuvF2MDRleqVFHB85yfLrcG9elUPbMeQQfeA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PAXPR04MB9185.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(366004)(39860400002)(396003)(376002)(136003)(346002)(451199015)(66476007)(26005)(9686003)(186003)(66446008)(478600001)(54906003)(316002)(7696005)(6506007)(38070700005)(38100700002)(83380400001)(71200400001)(55236004)(53546011)(2906002)(33656002)(7416002)(6916009)(8936002)(86362001)(52536014)(76116006)(122000001)(5660300002)(4326008)(66556008)(66946007)(41300700001)(64756008)(8676002)(55016003)(44832011);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?OEHGkJLnBHzmMB/SKGECg5yNrSzO5+zk85/0hlJHXd9lHBwHVnCIDzYTVwi6?=
 =?us-ascii?Q?ZnOxo1ELhOCLDxqpqy0ea7HC9D9hCJ0x7u3KClH027Kw3/a+mbXfCwOH6l6Y?=
 =?us-ascii?Q?5TYmqglxF+kasP4nV+OX44lsOwHgSDki7U4dxeqqXu59AUJg81elWhYE5yXm?=
 =?us-ascii?Q?hTW13nMRLIxMxEKmnUjPkS+NyNvEhltDz51mlniTnNsgiG1HG1LcDVdm2u0D?=
 =?us-ascii?Q?Raps0k/XMVx+mnsH3thtq7c7q0khV1u9O5/ksHPwrtD7NS+R48qrdPXmkdZm?=
 =?us-ascii?Q?fhCspDieIKYBvE7cvuUvzuui2kWWXRuYuSQJlYp3OCSzBHRuEpEX6m7evkBk?=
 =?us-ascii?Q?AOnRsXvmbNkPt2m1nGc9ZNhzRvkGd4Ok4qInQtbG7PewzRm8kE7cgtTVFRVH?=
 =?us-ascii?Q?A7BN2qfkI8qfqqLoSmYBbBkAlvF87MB8C308GTTyHKsMzk4fO83sH+zI/z/+?=
 =?us-ascii?Q?dCrA0Yh4tbGWJYUTkU7ZgfBjVh1FVjUEIKpbGm0HFFSNGx4Vnmq6cZHaLUH+?=
 =?us-ascii?Q?Uo/YYynPGbtvyUVsRQeWENhuR7QkZhugVFA9np+T7WBynDTh8kpXt7VCcD+U?=
 =?us-ascii?Q?YYjxTDPj8lxJ+JQKNVGqxjwvesHVNYpi9xDICDaMr5JETYGXCfHl6/tignSW?=
 =?us-ascii?Q?9dQt2tT2ZujG8GYf7CgWjBxStp2eE4HL+QEIIpvZw438qX3gEGIMY3Vsr6r5?=
 =?us-ascii?Q?VjTyv5R0aji4CadYrSnGtaE8GiOu3bJFGFMtR4JJCuiv7RBcTaSndDsTrhvx?=
 =?us-ascii?Q?nJRGwQvi4pCJWUjBhVNrwY8GHw9YO9QPQAUQHGV+WLbzUE3CcpTUHYS5gNLA?=
 =?us-ascii?Q?WsgPbuzymhYYbd3wnE2HPJ54t6LHyMNlAalVIf3gsTgIGo4GA0khp5XXNn1t?=
 =?us-ascii?Q?htp0lH5uQxPGPBUDFxLAVFd5NcIejWmFIFm3opnPVUBOQWVecYRHLOkFsKZQ?=
 =?us-ascii?Q?POfchJOXPJ14/5UcBIAjNFDdK1IjFGI+6Mgeb5Z+mc7ASLOj3p5SNzB2g3SE?=
 =?us-ascii?Q?+AIpINqZ3Eyl2PA2Da4N+0bTPsr3UmsmSydsqtzm07yZpH40rHXyIq8NAObI?=
 =?us-ascii?Q?cXQ6RAN7HLr6qsVZ/5/iaikblWHpbQXaszpvmY0ForulA5YC1PT0TtuWw+Kg?=
 =?us-ascii?Q?aTfyXsnJE7ZOB1qKVTWG9XrEwzkNR/TmKdyrzgjYgiBVVeXbc3xUbu2fbhiz?=
 =?us-ascii?Q?8hmMSgh6PMJD60OcL2NbfK8FU9OZuULRU/AmzTv9jaaTn2e0eG3xQ7oCEwja?=
 =?us-ascii?Q?FnGTRnkuYX4chXbxGH4SXc3W7JNcyXfs2GhLVT4UDZAB49VpPG6jyJx/lN1D?=
 =?us-ascii?Q?JNN8rz7O3SwucPfLnzFzptcGztCpWm0nAOqskWYQfW41R33LM6p02CqC8F+T?=
 =?us-ascii?Q?pQjzcZUVTljvIhxJXfHUIRRDzrb6UxY53p4uigtYrCRdDXnUo6PNgyeC2/Yi?=
 =?us-ascii?Q?C0BhEcNMwmWZQHMXlETJ2ErgQJERFO1XKGN8Bla3S+hnNin9Wvyw+zIa0TJt?=
 =?us-ascii?Q?oEnbfZqRruZWh2EHADJjw9FdJAM+gFs68z/Knv2VepH/IccsuGcfq5g1+be4?=
 =?us-ascii?Q?EjMUE0mfmHIyPJUWA4YoNLKRrouLoS4s9cAmng1G?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PAXPR04MB9185.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 02fb5de1-c259-4b0c-3a03-08daa218a13d
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Sep 2022 12:46:29.4249
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 8UnSMaY81YW2lMlT4ZqRFZ2QZIzjCiU7G1kCDNK52cnMwnnsfUB1Ne7VkmcDJpfadbj2RP436qYjzZyVTOoBFQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VE1PR04MB7375
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
> From: Andrew Lunn <andrew@lunn.ch>
> Sent: Wednesday, September 28, 2022 8:51 PM
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
> > +struct fec_enet_xdp_stats {
> > +     u64     xdp_pass;
> > +     u64     xdp_drop;
> > +     u64     xdp_xmit;
> > +     u64     xdp_redirect;
> > +     u64     xdp_xmit_err;
> > +     u64     xdp_tx;
> > +     u64     xdp_tx_err;
> > +};
> > +
> > +     switch (act) {
> > +     case XDP_PASS:
> > +             rxq->stats.xdp_pass++;
>=20
> Since the stats are u64, and most machines using the FEC are 32 bit, you =
cannot
> just do an increment. Took a look at u64_stats_sync.h.
>=20

As this increment is only executed under the NAPI kthread context,  is the =
protection still required?

> > -#define FEC_STATS_SIZE               (ARRAY_SIZE(fec_stats) * sizeof(u=
64))
> > +static struct fec_xdp_stat {
> > +     char name[ETH_GSTRING_LEN];
> > +     u32 count;
> > +} fec_xdp_stats[] =3D {
> > +     { "rx_xdp_redirect", 0 },
> > +     { "rx_xdp_pass", 0 },
> > +     { "rx_xdp_drop", 0 },
> > +     { "rx_xdp_tx", 0 },
> > +     { "rx_xdp_tx_errors", 0 },
> > +     { "tx_xdp_xmit", 0 },
> > +     { "tx_xdp_xmit_errors", 0 },
> > +};
> > +
> > +#define FEC_STATS_SIZE       ((ARRAY_SIZE(fec_stats) + \
> > +                     ARRAY_SIZE(fec_xdp_stats)) * sizeof(u64))
>=20
> The page pool also has some stats. See page_pool_get_stats(),
> page_pool_ethtool_stats_get_strings() etc.
>=20

Will add those stats in the next version.

Thanks,
Shenwei

>       Andrew
