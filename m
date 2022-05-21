Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 585DF52FE19
	for <lists+netdev@lfdr.de>; Sat, 21 May 2022 18:21:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245515AbiEUQVR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 21 May 2022 12:21:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58616 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230071AbiEUQVO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 21 May 2022 12:21:14 -0400
Received: from EUR02-VE1-obe.outbound.protection.outlook.com (mail-eopbgr20074.outbound.protection.outlook.com [40.107.2.74])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 35C62110F;
        Sat, 21 May 2022 09:21:12 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jROYLp2vgCEcRJ1cCobUah/SsKf/qC0qVxspK2/Ghi4QUXSBxhK+x6hq9Ghy+UoOfxNeQPFJxzUPmzMso4gee+9Fav1s5fZpDbuTr2Pz00IhsSquBDd+743JUPEUdcgSCh9wzCDHpsfxgzo2aV2rD5OeXBNHGeiiMZ8fCDahuaNuN8F/s6YYvU4CVK0nh/ROWhl0X5cC9U1Co/ZIlIVGsTy7NHImY4AQ3rZkZfgjcrY3NGvUEC3pnBk84U4VgC8j7nRboABcvYB1OAdSQQ8nScB61o6vtWoNA4KZ8a8ZjbqiNtuxEsAnWXnkHDMCodzrX8QkWCaym7vSmBRi5PtOXw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/o7Gy8fJzd+tNNWSHmqBpF9S9zatJXRgAX6j4a7DJKE=;
 b=EO/S+KgPrCasDjCqhbrlARlncWB/B46tXFDX7VMKi/oU1hs4X+MQaDMhYVGYIbzpFScUSmL/ivf2qWTSPmFpcWXD+1sp1eUkRNHQPKuQe/BfU94wO1KRITgzlLV+bEzE4v48eSTeNMVOwiUGiB+qJP8sagMmT/P9nqm+N49eWjJd6czFJVectT9NSuhSLNRFSsw2N73b7pWwwztzj8V3leKWAxk4MTQAUbvQyDgkwi81V8OVvz4aAXc64PtbFQBm6OUodbVk/ztqB9rYAVuAZmHjLa2T0ei0s5RxK2wlD4/zxamn6m3RVQk0k0CW7A/chWmDGemRNMuh6kyLN/CEgQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/o7Gy8fJzd+tNNWSHmqBpF9S9zatJXRgAX6j4a7DJKE=;
 b=idvDqytNGYcgR24pf7djMQ84MKfJ5fI2VxfXX4TeM+s+4QIeO1sXzMnArry83WV2uwoXTFFilrwqfnrDX0rY6yOWZ3EY8SA6JOueKhwFVjfUSy6RGTdKIuR87k41NLjhy6qMQy8XXNYMpv+gshGe4yneJZiwheN/CzJc9BpR29o=
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by AM0PR0402MB3379.eurprd04.prod.outlook.com (2603:10a6:208:1a::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5273.19; Sat, 21 May
 2022 16:21:10 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::fd1f:cc16:dafe:4bf5]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::fd1f:cc16:dafe:4bf5%5]) with mapi id 15.20.5250.014; Sat, 21 May 2022
 16:21:09 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Andrew Lunn <andrew@lunn.ch>
CC:     Pavel Skripkin <paskripkin@gmail.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        "alexandre.belloni@bootlin.com" <alexandre.belloni@bootlin.com>,
        "UNGLinuxDriver@microchip.com" <UNGLinuxDriver@microchip.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "clement.leger@bootlin.com" <clement.leger@bootlin.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2] net: ocelot: fix wrong time_after usage
Thread-Topic: [PATCH v2] net: ocelot: fix wrong time_after usage
Thread-Index: AQHYbJD0POeq/e10YUezilbAbovQL60pW7sAgAAosAA=
Date:   Sat, 21 May 2022 16:21:09 +0000
Message-ID: <20220521162108.bact3sn4z2yuysdt@skbuf>
References: <YoeMW+/KGk8VpbED@lunn.ch>
 <20220520213115.7832-1-paskripkin@gmail.com> <YojvUsJ090H/wfEk@lunn.ch>
In-Reply-To: <YojvUsJ090H/wfEk@lunn.ch>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 1a48084c-f60e-4ea9-86d7-08da3b45ea6b
x-ms-traffictypediagnostic: AM0PR0402MB3379:EE_
x-microsoft-antispam-prvs: <AM0PR0402MB33790DC0A584032CC486B64AE0D29@AM0PR0402MB3379.eurprd04.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: CeFSBZ6O+jMVxiJZg1kppz1HSFfSCFAcSXBWVWOSZdHnH2grIwoWT04g2DrSMXEhHxS8Lk1pSylVGeNEEGJTXg1GsBjdwzXOWbw8IhYS5fmMPDBZ2rehPecdNrv8zVy6FZ07f5TBK33kQhlNs77cnQCO/c21QwgTnKCwQ/wzEnizFHuZvfCEp3KKFjsxz8+SQKb5L2/DCXdWML3Ac72L3r6FhZpQwciikeKe2tH4BSocX5PbnZLK44a7lZzZ4uStZn5pgBWUtGt6P0BO5txA1E1V6J+GHPGfBkXE2uamghZufiwvt9s4SqgcPIzcukO14j1kEb/ZtmW5O/zMYPmv4FTOfPT0gbneWbWbyrvlHsj6XLiIFazp05Q9gW9hxZ2Fay9mvSxf2TvsCycl1BZH8D/jQmHK3M+mUMrcJqg+xS6Z/ove2f7jBXxJnOt8EiY3BMFOsvXkL4zgnsZYxdpUzx/FbOX0MXpQge09V5IRcQ9clBDj4ubrPoIgJ9S9e8lfX2jjEbkChzvMEWvOI/AWbDi0vdHbdxRCtxy8teo7+2Wlqdd3V66pY+ottsVp7Mxz1miiS+05T/H4lODptd2fkgQ+WZTJtzExF2vIYctbN3QHx+8kolvOgN0TMdrSd14Xlr1Fz1kEnt3DrflO8wmayhvOwinyvuEu8u0DMtnh5U0K5vg/oWNLCj3TjD863URfS2erT5OxSpMvpZZ2VO0nMg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(7916004)(4636009)(366004)(6916009)(6506007)(86362001)(66946007)(5660300002)(44832011)(38070700005)(316002)(2906002)(66446008)(66476007)(66556008)(64756008)(8676002)(4326008)(91956017)(76116006)(6486002)(54906003)(186003)(71200400001)(83380400001)(8936002)(38100700002)(122000001)(33716001)(1076003)(26005)(508600001)(6512007)(9686003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?u+tfl66U34HeL7vvO8RTg1Y9s8RQB3DW3ZceSUs7j04+WHWRU3l9Le7lXh9I?=
 =?us-ascii?Q?g6llKRh/BAjqtMX68YdV1GrCRO+oV+3ujMGp0s9OY4xpZ/TZeNca++aejU1e?=
 =?us-ascii?Q?T4Rs2rA1qe79XE7GE1DHzExcUV6BBPm/2XM2mtE7BKNYyLU362R4YdWwc9+i?=
 =?us-ascii?Q?/k7OwZVFp7lGWmVw6D/vtKLiy7tQqoqS/8O3L7MxDF5jH/J2qPYBfZzZodgC?=
 =?us-ascii?Q?5ND+eKNHOer/TotefsbZ0VNcPq577JSbwJaVp1WnWtE/0VHc6Q2qRyyb5A6R?=
 =?us-ascii?Q?XdvbNm5b//7KY/2yICy6wx0v7OCrtcVR1Xub8UYcJhhlS9eYQMtTIDKk3eEO?=
 =?us-ascii?Q?aPfvfk1JON1m+INplLkcQhcteoIw2qa4zOotlB365PJ6EEW5jpi/HqusAi7+?=
 =?us-ascii?Q?dLCdVd71WDZofWBx9CNm3QgGeSMw9xAlbVtfqNuwN+/Fks6Gs41uYkyd59oy?=
 =?us-ascii?Q?ggH64Qs7KCry0uKMcAKFDbt0FZQ4ya7KoSw1yhymCy8MBmI6FtcV2dHs0MZ7?=
 =?us-ascii?Q?Qow7Gzyte2fsAEmeHRGzMrkNWIaDHfzizl/8/ox3GYpH3s4E7bcrr7YBBJ8A?=
 =?us-ascii?Q?F6Is/1fqdtv7zEtcUWvzNnXFl7XRV7hHK+dqEMsJGxSmIw21Te5IeyxO1kdd?=
 =?us-ascii?Q?DFbEADYu4ZzQ4+pjYhTCzuBkEoWKZF8S9melIlbDf5stQUJB+Ob0h+yMcpQU?=
 =?us-ascii?Q?TbHGy29FwuWHEmKCUlOJA9q+efS7akSu7bCe4dQySjWU7gh7tm8ZgPzStHxO?=
 =?us-ascii?Q?T1hu7hXLBQUk+UtWBy1bmkKBavcy6QQzLzJwvT0Rlm5kTehEzeW9w+3jPcWF?=
 =?us-ascii?Q?Fdyhh9B3xUoXjzKr52+jevAOTA+nVFgsCHvdHW/OyKaCGTdDzeF7nuI0iXYh?=
 =?us-ascii?Q?ahnCQ26787RjunlsJlrjJppyymWsF104KjedLWdT6c5NRPZ59zoHKHLe3YjA?=
 =?us-ascii?Q?6ZlGW0Fp0AiR1WUP/whfthGapjIxV40XxE5p/Xfz8ZPZfVXX0GSjg4/G0umS?=
 =?us-ascii?Q?Q62+8p5Ua+zfmsePMd8EaLLM0MxqnR/lZSV4R/wHpZIfHeUbjcjcHgKC0Nqs?=
 =?us-ascii?Q?exjYKXazJb8svhu3IX0kOdYm+HYv/v5g8B8T/4UCTMOx9HGeJCrGEGe6JUmn?=
 =?us-ascii?Q?4vpJBMVXn6OFXhaJMmmMCuc0wxMRGhs5znHUcNDkl4gB63GDreaflekDrz5i?=
 =?us-ascii?Q?fbN1tSPm108GZ92v7BgF4ZLDsvXytOZwlpQOVXYWjS/wUA5guf+zhgzK4R7w?=
 =?us-ascii?Q?qJBhh7nfA8slPqtzsaxR+vfo05DDLCSYaLgnVSbNslLXc31GHqoBThVkbYIo?=
 =?us-ascii?Q?QGL6rhpsjw6yahv8ynP3yNG4X1G0Qics9R3Ej/K3hnFTVAKtNTJQCXAZ31cd?=
 =?us-ascii?Q?otAuX4WADNrhrCjKyHNJHhwU0nj/dGKIgWm+8RgNCtyThTUIKCNSP74WmV5f?=
 =?us-ascii?Q?9jSQBrO5EQN9WKSggXnsrwsmV/Gvm+fBXHRTapRMy1xTJGgrUXW02IfPakd/?=
 =?us-ascii?Q?2by1hmd4zzlhRof6J4mGLk4JXZevX89qvu4hUjezInX+8xWHH79KhdgEudYw?=
 =?us-ascii?Q?i0mEw/PFui4BEiCmfw4j5qNdMwk88ddvxOIXx9iJs5ETGCywwwZhF5DgHRgz?=
 =?us-ascii?Q?lfk43y7UX4RRIl0Rh9iWvvhkygDXgF5h8oOHH8B7+akLW+BHPPV6CbgR+To+?=
 =?us-ascii?Q?6w2lwRlyJO+SsXBKuabf2vbaSzcaUgs05zNok/gVpq/pwG0T4LWDa8F7W2+s?=
 =?us-ascii?Q?bsWy/h4hhui0ow3yGLMB56M4Pl0uigE=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <44352338C3D41741A8CDA2E58D079E14@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1a48084c-f60e-4ea9-86d7-08da3b45ea6b
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 May 2022 16:21:09.7731
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: UwkzkrRdPYBcAgIfSSLEyuCCoXMOCmpdThQCqVOyFN7mVZPp49x8VGwzv5netRFLfveOYTIhXhuMSmyqRe7CGA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR0402MB3379
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, May 21, 2022 at 03:55:30PM +0200, Andrew Lunn wrote:
> On Sat, May 21, 2022 at 12:31:15AM +0300, Pavel Skripkin wrote:
> > Accidentally noticed, that this driver is the only user of
> > while (time_after(jiffies...)).
> >=20
> > It looks like typo, because likely this while loop will finish after 1s=
t
> > iteration, because time_after() returns true when 1st argument _is afte=
r_
> > 2nd one.
> >=20
> > There is one possible problem with this poll loop: the scheduler could =
put
> > the thread to sleep, and it does not get woken up for
> > OCELOT_FDMA_CH_SAFE_TIMEOUT_US. During that time, the hardware has done
> > its thing, but you exit the while loop and return -ETIMEDOUT.
> >=20
> > Fix it by using sane poll API that avoids all problems described above
> >=20
> > Fixes: 753a026cfec1 ("net: ocelot: add FDMA support")
> > Suggested-by: Andrew Lunn <andrew@lunn.ch>
> > Signed-off-by: Pavel Skripkin <paskripkin@gmail.com>
> > ---
> >=20
> > I can't say if 0 is a good choise for 5th readx_poll_timeout() argument=
,
> > so this patch is build-tested only.
>=20
> > Testing and suggestions are welcomed!
>=20
> If you had the hardware, i would suggest you profile how often it does
> complete on the first iteration. And when it does not complete on the
> first iteration, how many more iterations it needs.
>=20
> Tobias made an interesting observation with the mv88e6xxx switch. He
> found that two tight polls was enough 99% of the time. Putting a sleep
> in there doubles the time it took to setup the switch. So he ended up
> with a hybrid of open coded polling twice, followed by iopoll with a
> timer value set.
>=20
> That was with a heavily used poll function. How often is this function
> used? No point in overly optimising this if it is not used much.

If you're looking at me, I don't have the hardware to test, sorry.
Frame DMA is one of the components NXP removed when building their DSA
variants of these switches. But the function is called once or twice per
NAPI poll cycle, so it's worth optimizing as much as possible.

Clement, could you please do some testing? The patch that Andrew is
talking about is 35da1dfd9484 ("net: dsa: mv88e6xxx: Improve performance
of busy bit polling").=
