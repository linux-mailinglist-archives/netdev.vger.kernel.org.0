Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B5EF34D481B
	for <lists+netdev@lfdr.de>; Thu, 10 Mar 2022 14:34:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238297AbiCJNfK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Mar 2022 08:35:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42430 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233477AbiCJNfJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Mar 2022 08:35:09 -0500
Received: from EUR04-HE1-obe.outbound.protection.outlook.com (mail-eopbgr70049.outbound.protection.outlook.com [40.107.7.49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EBBA2148657
        for <netdev@vger.kernel.org>; Thu, 10 Mar 2022 05:34:07 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PRUDg0tG8h+ZI9nvvtCowGF/VJEjW4YEh/dUxj5AXN/BFsMBERewhHrYFVl2TsZz6UhSg/AuWk1TgGLX2AYL/kbbgkTg9UUVE+dAWgOv+HP0iAkiFltuKoqzRyWn0Eth9xTmYHqI1XEy4kX8/hcFPGgw0BYdgNv2G/98WzqXGXy6NwiasKgm75I2zmwZcZLhWmvsn0k2DGjtJvOgbNpVJQJq2lnKqgqVGtwRPbMlt1wNIw/XGCkGzy7wL2yN3eWPKND/f3WfAGfjun0EzRvsiym7NXOC4AcWsKafSoOThmQmxhYJdeR+9EGQJnaTKZ87M57HkzKpEC1QclbZPSCBTA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=BFzXWTzzslx5U9X7qQUrd6X3o46nBMrSyF2ENI57XAo=;
 b=HVDUCMXXoSRKz6s+Qz+eaW8tyJYmrkUaZ8MST0hLMjCdwJTLioxO1/sK1gRGSALtsP/zjQq9YAT4uRChOxGGwKQYq135j94qrk0wUtj0BEVBCqtbm4V2zsM7qeKRtn0JQjg8lpNOZRFk1lS8zPdfJPEW86q9CM1IeN5vuQ60rs/GteAlqvzWwcgmHVXeQcwLF0FaTd3EQmT9KN7/e9d7LcJnCB+muZMkhwYfFeluvmumzZZLA0lNrMPGw/NDxu3RJ10TqbnasyAP6uFvvIkCd4iQTwpPF4yZwujQVojOh2XLa7i29M+m5Jbs96Bn6LpvtwhcDk1W0wzKEFk2F4M3Mg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BFzXWTzzslx5U9X7qQUrd6X3o46nBMrSyF2ENI57XAo=;
 b=dZZ/dudfEzG2QWOPgNx/E17m70r6YG8bsbNbuDa07YhECe5iv7i/ZzcS6KuoaF84io83fy76XHz3SYZV5N2L1Ywf82GTBILHx0nNDrPt2d8ODuL+PSS8ZzCepWJBQpZmE+2y/OImYU6Czf3fbhCMayHuYFDFRiS527AU7i+msmQ=
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by DB9PR04MB9499.eurprd04.prod.outlook.com (2603:10a6:10:362::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5038.20; Thu, 10 Mar
 2022 13:34:03 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::ac0c:d5d:aaa9:36]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::ac0c:d5d:aaa9:36%5]) with mapi id 15.20.5038.027; Thu, 10 Mar 2022
 13:34:03 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Kurt Kanzenbach <kurt@linutronix.de>
CC:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        Alexander Lobakin <alobakin@pm.me>,
        Eric Dumazet <edumazet@google.com>,
        Paul Blakey <paulb@nvidia.com>,
        Yoshiki Komachi <komachi.yoshiki@gmail.com>,
        zhang kai <zhangkaiheb@126.com>,
        Juhee Kang <claudiajkang@gmail.com>,
        Andreas Oetken <ennoerlangen@gmail.com>,
        George McCollister <george.mccollister@gmail.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Anthony Harivel <anthony.harivel@linutronix.de>
Subject: Re: [PATCH net-next] flow_dissector: Add support for HSRv0
Thread-Topic: [PATCH net-next] flow_dissector: Add support for HSRv0
Thread-Index: AQHYNFFpodv7PslbYE+FNdV48Aq/G6y4nmCA
Date:   Thu, 10 Mar 2022 13:34:03 +0000
Message-ID: <20220310133403.bjf2k4tgpwl5xtsy@skbuf>
References: <20220310073505.49990-1-kurt@linutronix.de>
In-Reply-To: <20220310073505.49990-1-kurt@linutronix.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 49ea2643-9b72-4f54-5d18-08da029aa49f
x-ms-traffictypediagnostic: DB9PR04MB9499:EE_
x-microsoft-antispam-prvs: <DB9PR04MB94998559709C69FE8D1CAD33E00B9@DB9PR04MB9499.eurprd04.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: mvZFcbZjz+kAt/bjDLqWPFWg15HwP8RJbBIDiOUXBNLcq3Ak11GUZtgs3rUmVxL7uF9jHez1ScOgMqBcDezbqtz74py9J2kisVy304SkT5xlJ4R+4tM1Nyaz21oT1cnOoFXEmUPvInCECqOHftr7oHJanz1/IUuFb2Kx+NqZLvrTAP87kaBz6uULBc/DazN4jfqf5mS/9jCCF8PhYKr6SxCP07dAqYFE/1HBpkjh8u90rHAY6SMC9Scfp8fTQ5RWxTlY+tu8LYDev5Yn4JIMCyGXnQgKY4G1El4utQbQHBsNEsKxE7RP68o6HP4nNE2KGmbI2BKU2rKmfJvTkBxYsCq6IoRmBw7D+ZfS7MwIZbMfJjGqpoTjMk24Mw+2wM6r24jyYB8M1O99tgg9Sz+eZKuPPLbUOxf3PKh/KOpTELKLQJBsnflL72Lj2u6Wc5myGM6E+VIisJXFhRKIz75ArJt3HOr3jf+k2qYwvPH4rOnUz6kq7XPRa1gx0Y7lUNyPuEMRirSLEvhAWog0Gq6I+P7RtcuzxlfhPy4tzZu60r5KF29aa3AZiJOdJXYTvClBdTq5BlHX4QlhUkU/cjZ7qFzgN5x7Xu5uVHFxaGhY5O+1V+gT2wjI900C/44h1ftVfrqKluyvCMpWrSbbRfM0VkG4FbLfxlQIEz0Naf3gApqgKaRTvmMrbNIZOPoINNw+3wppiTKIFr4gRugNUdaSXg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(7916004)(366004)(71200400001)(6486002)(66446008)(76116006)(54906003)(8936002)(66476007)(66556008)(498600001)(9686003)(2906002)(122000001)(33716001)(6512007)(38100700002)(86362001)(66946007)(1076003)(186003)(5660300002)(4326008)(8676002)(6916009)(4744005)(7416002)(44832011)(38070700005)(6506007)(26005)(64756008);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?eP72UYJKpjAnAYMw1h73aFFIeAMfkZ4kJjew5INdJuLg0sfPQQf7XRIPrNew?=
 =?us-ascii?Q?OQssfOhHcgoS+zN92PdrmIz9SBuTIiFzrLLa15aX2uX1ENf9Ia8Xi0RutiLG?=
 =?us-ascii?Q?jSk4IPbZq0vy3Lw6u9fiev2RVBeV6FYJUf9vfsiMxhHMcT/G+GH5nE7jELw/?=
 =?us-ascii?Q?6qwSebfarMOYi/gwU/y0qAb5bSdYnqc7J3U0CLBxPzUyk04t8ykpSmwq8qtp?=
 =?us-ascii?Q?wfKkHN4hCMfX2STMusNZZOHaoUHx4OwI4FZfkjq05Z5e7H9Jck+9DctbI1YK?=
 =?us-ascii?Q?BGwI96DTJTp8ea8JNSCfoxeMXG5OCflZ+km1Xh27GS5XR2MpfzW9EaatGUEu?=
 =?us-ascii?Q?bb3RqaXsWLPxhc5IqFYL/bMRWEtcjI5f11bLTCc0g2OsusjV7tVLgFdcMwE9?=
 =?us-ascii?Q?OsmSfqJbmRjha2hK0l8eHviaKOE91OKQ00rR6zpL/N5f5qE4nQ5BPia1zchE?=
 =?us-ascii?Q?cP8R2e7Ra/8suq0WK+70gRMRsbSjvQkgZRhxx8SBbhKkRektgbUM/Ws7EivQ?=
 =?us-ascii?Q?ZHQYBHk+3HVVWvHO4Is+/KkwThuEYOZIR62HJUoF4lfkMgrYs/0ffUHWP0wr?=
 =?us-ascii?Q?Zrc5iFc3ncKpnya/+b2FqYxk/G6tddjIUeLDlEp4oC6rjgGE3mYvUSNQzVZu?=
 =?us-ascii?Q?6884CetJOtk/jLNRtcUKOKFzn23ODC/VuJMZAO5ySrmqf2S8Qaq9fftAwe1T?=
 =?us-ascii?Q?7C/Bez2OECwEuuDL+k2d8TcGIyEL9O9273hGSAwRRztRXvKhd5ItBl5/3UHi?=
 =?us-ascii?Q?5GpBDGLN+jHiivLaX9n18iVFAdukhTYYfUmfW5mMHd2EBoXu33lYt0JcHuVh?=
 =?us-ascii?Q?2bLtjI6wW5A7FfyP/uadZyir9pWciwadpVoWV/U5PvdEp6VEO8aSfXrI2TMQ?=
 =?us-ascii?Q?U1PHwE49V/oOuHe1OJds1Ny7LcaOfw/LGv4MAgy7rD8iQ1kQS/zJRSl6/lMj?=
 =?us-ascii?Q?E+txGTAtFt+h8TaGOIrNJtnjWM3zH9XAN82rQHkVNo2fAvt1SNZnFojMvZlq?=
 =?us-ascii?Q?SrhyWAoPrPURXM5ajwB8VLqHXnKjnckVGqxaIadiCu53jXbxKgxpS9Rxh+Be?=
 =?us-ascii?Q?5ckJhrteZzib3nC9IndnP4sc/eJGxG/3LSHfCZLpgJw+yoXju6zFZDPKt1kv?=
 =?us-ascii?Q?L+NxoQAb0zFOhZnSdstMjER/sBN6OGyUfB2eO9wlOslIKDQkyQ6KdG2NgJJb?=
 =?us-ascii?Q?mLKggUt/MTayEyIVOsLZ5AO1EerUKNr0ixeRECxFBJVQfXN77xLt6xqbhEH1?=
 =?us-ascii?Q?C/CsA1F/pRU27+3eCk9sXjvWT4MRDT+0DNd9npWBh19MHOzPtlfws+kvAVgX?=
 =?us-ascii?Q?DAYze/F/9RGQUbYb+o3P39mPM3aElhEGOxrIXyoXiaPYGcRxiBYbvftoYbkQ?=
 =?us-ascii?Q?zwNsKR9bXGeutvlXdrWxTUMrYdtTbntOe+nkBHlFpbb+losORaAqwnfxbUoN?=
 =?us-ascii?Q?aK7fETgE52U0YRj4C8pM4FzZKPpZOBpgjuNYaS8Y3uSX/U97MeYcOsG7D2+Q?=
 =?us-ascii?Q?QCXRGfEDPpQqyiuPsUUYUln7th4G4qKa+uiQCrtbFKhLfCoOsHp557//voL0?=
 =?us-ascii?Q?04KUv8RSgNB6GO0mIim77/5tQljlo087eZhBu/3b1foJHluRMnzjmbu9EKDK?=
 =?us-ascii?Q?zVqr/Wq41hXt9K2eRlT7Cug=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <FDB6543001782242B9BFC209A915FBC7@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 49ea2643-9b72-4f54-5d18-08da029aa49f
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Mar 2022 13:34:03.5379
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: sitSPwcOQZ+TJKHrukuIe7Oza71LGCtKAdC/C7Ukjxl2pRlJdsbk595gqD+V7QSE4oT6aksjXjR4mSBfV9jF2w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB9PR04MB9499
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 10, 2022 at 08:35:05AM +0100, Kurt Kanzenbach wrote:
> Commit bf08824a0f47 ("flow_dissector: Add support for HSR") added support=
 for
> HSR within the flow dissector. However, it only works for HSR in version
> 1. Version 0 uses a different Ether Type. Add support for it.
>=20
> Reported-by: Anthony Harivel <anthony.harivel@linutronix.de>
> Signed-off-by: Kurt Kanzenbach <kurt@linutronix.de>

This observation came up as a result of the fact that HSRv0 is still in
actual use, or just for correctness' sake?

> ---
>  net/core/flow_dissector.c | 1 +
>  1 file changed, 1 insertion(+)
>=20
> diff --git a/net/core/flow_dissector.c b/net/core/flow_dissector.c
> index 34441a32e3be..03b6e649c428 100644
> --- a/net/core/flow_dissector.c
> +++ b/net/core/flow_dissector.c
> @@ -1283,6 +1283,7 @@ bool __skb_flow_dissect(const struct net *net,
>  		break;
>  	}
> =20
> +	case htons(ETH_P_PRP):
>  	case htons(ETH_P_HSR): {
>  		struct hsr_tag *hdr, _hdr;
> =20
> --=20
> 2.30.2
>=
