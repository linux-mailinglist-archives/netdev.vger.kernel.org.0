Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D187B4BF580
	for <lists+netdev@lfdr.de>; Tue, 22 Feb 2022 11:10:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230454AbiBVKK3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Feb 2022 05:10:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38678 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230414AbiBVKKX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Feb 2022 05:10:23 -0500
Received: from EUR05-VI1-obe.outbound.protection.outlook.com (mail-vi1eur05on2087.outbound.protection.outlook.com [40.107.21.87])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F14D6128654;
        Tue, 22 Feb 2022 02:09:34 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bTFjvQU5ENdzgfb6zlhxByF+OK687WNCsYBQ0e/jrIFUVoiShOdG2+H2ownOM5BD9DiNTQkRU7X1Ik/CNUOZAkQ1Svi6jCLt8FLUO5bmwsxudJYw6SF7OSNbe9xTwKsNXta1uwS0Tk1qD50pLpur4FtqvAV2OQGCPU7nuNpzizFFDgKMyEHtlW87hkz96c/JjGIZEEQN/kxs9X4tW+Li7z8AW0PvbmgDGaU2bZYdzZYrrsHOfoGfjvz77JBLZkkKZEHySEWijMJ+no7YvlhfJFi6sAwGm/TsGCEb4W172xkZ+w/YEQIhFlM796RcDlnu7yPMPWIeGD67pYOL9fKmmA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7qHNF4oidD9b3o+iTj/2kSS1vHervG20f1/BBKwECy4=;
 b=dSZXjMpCPErycovVxpM3E4AOAuFqgDdWitVZHu9Oqo7XYuvThv9zB51k3FJAEmK7BBnUji7x+LX4Na8KkRFFU7OV8Uwf4HHNPrPKcJ5t8P8inCaqeGBlqTKI7u8YY7TAnoaVHryYbGZXrQXrhonvfUF+12O0bwyIGvSyWov8kNnhK2cvC08ySlq5WV6UjgW+d0fhDgCDV85AcOnSPkhR8v64MlAYm+An/3eVMhvBh25SdyUQE/pAPbJ69qIgXdtwJXv1ix+Fiq6ISI2jm2N6/cZtSeobfbJDO0YygoivWU2l701aoJqj38jyQq3Irk+x4Hle3BntNNQmN4TxRingAA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7qHNF4oidD9b3o+iTj/2kSS1vHervG20f1/BBKwECy4=;
 b=SZpRD6QDDj5uzkwDE9sNwT6t1fdalEBCRlxLjADU6ZqvW30U6XqAnDBFlh6YUQP1D0Gd8ykH5r5Vi8/B/fw1s/Jh2y9WXjMw8YIKBfPMSrqGJXcSCg6pdIZbAY70GjKBVpg6rBeKlL7rKWQ0JFzOYqqTumwomHy7shzbUBfSfUY=
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by AM7PR04MB6981.eurprd04.prod.outlook.com (2603:10a6:20b:103::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4995.27; Tue, 22 Feb
 2022 10:09:31 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::95cf:8c40:b887:a7b9]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::95cf:8c40:b887:a7b9%4]) with mapi id 15.20.4951.019; Tue, 22 Feb 2022
 10:09:31 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Jianbo Liu <jianbol@nvidia.com>
CC:     "olteanv@gmail.com" <olteanv@gmail.com>,
        "andrew@lunn.ch" <andrew@lunn.ch>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        "vivien.didelot@gmail.com" <vivien.didelot@gmail.com>,
        Petr Machata <petrm@nvidia.com>,
        "jhs@mojatatu.com" <jhs@mojatatu.com>,
        "oss-drivers@corigine.com" <oss-drivers@corigine.com>,
        "hkelam@marvell.com" <hkelam@marvell.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "leon@kernel.org" <leon@kernel.org>,
        "peng.zhang@corigine.com" <peng.zhang@corigine.com>,
        "louis.peens@netronome.com" <louis.peens@netronome.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "alexandre.belloni@bootlin.com" <alexandre.belloni@bootlin.com>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "UNGLinuxDriver@microchip.com" <UNGLinuxDriver@microchip.com>,
        "rajur@chelsio.com" <rajur@chelsio.com>,
        Ido Schimmel <idosch@nvidia.com>,
        "simon.horman@corigine.com" <simon.horman@corigine.com>,
        "sbhatta@marvell.com" <sbhatta@marvell.com>,
        "xiyou.wangcong@gmail.com" <xiyou.wangcong@gmail.com>,
        Roi Dayan <roid@nvidia.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "baowen.zheng@corigine.com" <baowen.zheng@corigine.com>,
        "jiri@resnulli.us" <jiri@resnulli.us>,
        Saeed Mahameed <saeedm@nvidia.com>,
        "sgoutham@marvell.com" <sgoutham@marvell.com>,
        "gakula@marvell.com" <gakula@marvell.com>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH net-next v2 2/2] flow_offload: reject offload for all
 drivers with invalid police parameters
Thread-Topic: [PATCH net-next v2 2/2] flow_offload: reject offload for all
 drivers with invalid police parameters
Thread-Index: AQHYI9hnxKB/8XMkm0uWEB4X3Xu2BqyXsfCAgAcltYCAAIk4gA==
Date:   Tue, 22 Feb 2022 10:09:30 +0000
Message-ID: <20220222100929.gj2my4maclyrwz35@skbuf>
References: <20220217082803.3881-1-jianbol@nvidia.com>
 <20220217082803.3881-3-jianbol@nvidia.com>
 <20220217124935.p7pbgv2cfmhpshxv@skbuf>
 <6291dabcca7dd2d95b4961f660ec8b0226b8fbce.camel@nvidia.com>
In-Reply-To: <6291dabcca7dd2d95b4961f660ec8b0226b8fbce.camel@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: yes
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: f4b3b281-4931-4be1-01c9-08d9f5eb6b07
x-ms-traffictypediagnostic: AM7PR04MB6981:EE_
x-microsoft-antispam-prvs: <AM7PR04MB69814A7F1B47CB73B5FDA0C6E03B9@AM7PR04MB6981.eurprd04.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: QLDznENwbfwAI1VTPR5/YkXeh0jKF18x9/209TyNoEOsbJso2Kg/uzILUtXxv/P8J8JBsdfkDHhpSNw6ICOTeXEWZle2QlPtBt6uhvCcT47GHMm9AAf8CqWcpEo2iVmo86t01dvcOs3OQYwOLr6xIWObm8Zhoxu0jxJeKIZTfPaab6z1JYiaTvxDmMqRGRNv0E7a9+F/uBI15qMV3a+PWRUrYOMIwuMbO3ULhuea23pgp8LS+SMPdt4fLFAro9YmqrbGVFyZZSAHWOndbB8C8f1VlqJORFTxwSWWXVCn17cIZhk1EdMG0FqzLn8RwKwgfeiAdSZmt1iww5Ii2YHp9Jmluyudr9CAmirww9sLd3DW6sVNWuxp3obAE+rRFymKYYzZntJAwq3Xk7GdERbXUSoRXKCffl4vNALR4YZLlx2WXC/7gwAcb3VWxvxlEUWtxt/wjd751fEzfwYZQLbympb8/ZuLVnD4Z3pDheBfwIhqFEyENhkqCm5/GYwDm1NAwvFc00bl7k3teaGk2x42gUB3ulpbi7ybq6tiisRoA5l+TBnvG6Ia3yfEleoFn8GUMc9zJltdWhRTuuJqY0LaLg3BXY5mbfKsKT2AxFYyCoQoUMuOzt5XEHIgSZE6r8Jwiztbn0EQ31KALspXusJFO+gLg5Mv5jQ8tEs3bfsvCYbdNAizE++ghD/nk8vsqVrFZVfnYmwze3Bepm38c0YTqw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(7916004)(366004)(1076003)(38070700005)(7416002)(86362001)(26005)(8936002)(4744005)(99936003)(33716001)(122000001)(9686003)(38100700002)(6512007)(5660300002)(186003)(7406005)(2906002)(44832011)(316002)(64756008)(76116006)(71200400001)(83380400001)(66946007)(91956017)(54906003)(6916009)(6506007)(66556008)(8676002)(508600001)(4326008)(66476007)(6486002)(66446008);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?an0hj9ZTfysLTHezu3RbQ/IaOejfpiFZkZEP/zheCtREmuBjqt+ZaT7gI2U7?=
 =?us-ascii?Q?S2Lk/685AgVUaT9Gl+EZaxR7s/QFNMN1lTCt2ZuSGz2LnWVvkqDazXfPJKJn?=
 =?us-ascii?Q?r938BA8qPyBhN4llHLUI0k/rIllELcjxAefSLD5Iqf0QdYWQFWti/Ei3x4YC?=
 =?us-ascii?Q?dh9to4AG5TKB02lC6HjAHbCic6FR+rBQoh41/e+FNA/NORURt0zlTwfjVA0y?=
 =?us-ascii?Q?sRv0Xovmi/K7uwxjRW9Z4U1izO2mkVorhcP8b9AnF8lfGNg2j959tU/kW4Ud?=
 =?us-ascii?Q?nurZV1TQM6SWKbO4zLXHIdeyfKwHfDVSaedB8ofZ9JzPWdL2NCqjs6+JPKEP?=
 =?us-ascii?Q?r2aOUcjUQcmIrLdYXREMhBgY4UYei2IFj/vSG/Flqmv5ULG64sM91/f/PBNX?=
 =?us-ascii?Q?Jeli19iH9cOykpvUvijaXtyvbcih9vbmfACIyEipMKbtdCWLKjAsHrq1zr8P?=
 =?us-ascii?Q?GmzBgA5tw6UTznaW1VH0Lavvua0IgrFaZ+/SZbnRAAmxg2ueFmKgfTCR+T9E?=
 =?us-ascii?Q?q1v5EAINhbENdUiYiBavvRlAJ79dRayDKACeQoo5zaJbr+YV/WckrA0yRwvC?=
 =?us-ascii?Q?3jrF67gqLMKoEhuB7GRHrnJeIAAuJlVaDnWx/IJaPU671HIFS+CM57CF5xKZ?=
 =?us-ascii?Q?Nv7wy7imOKjC1pUaFETY9FismKP//iTZxbsDdzuswH+IMW84PiMZ82jP0k8r?=
 =?us-ascii?Q?93EbeRdXanS5PusR5niKUzT1cYv3+yR5dvZuAnXfZeHMGB5MzB8teDzf4rLR?=
 =?us-ascii?Q?7MUNhX5JiMap3PfO1SzrVoSGZOG3dYGeRv4IxV9PFTaDcMLf6QEct4tmuqe+?=
 =?us-ascii?Q?HSAFPRxL96jQylWU9V4aa1ech9uDvw7WX+nJMN6YOYbYMVu7AAU0fK04xdvP?=
 =?us-ascii?Q?b8B/W98CO0kaI7vqLAQC8jvYsErkj7EeFsBYOngD8wnjtwccvvugtH7lIM20?=
 =?us-ascii?Q?nN8m+tbVA8/ulgW+xdZvaUhdYT+VvYvDnkj1DzsphdnFCBaxsEmttpNLtSCm?=
 =?us-ascii?Q?mydsZaERbJThMvVps3ont0CEE9jR/Cv/CrPlaDnqRWLdOhzwoZhzILzavW6V?=
 =?us-ascii?Q?vFAY2V392C6u8oAhC+XWPzgHC9K5FGjF2WANqH4s7eAkfYZG7GbKwXSZVMou?=
 =?us-ascii?Q?B+lVMjYkojV3FrVQ8ud1yROa/RskBVETGKPRPy94lgQ6RC6tXO+8bD0zAM0X?=
 =?us-ascii?Q?k9cYgAuaBgcqVwUb/2J9XY95C2EdoesG5i7TN/HOKukP0vIwZCuTQbTzXfv/?=
 =?us-ascii?Q?bY0X5GAz2r/+d2JBgqugZgQzNWHc1c7FChCAq9aEc2DHNvVcD1ZYasgCLsg3?=
 =?us-ascii?Q?WK5TsafirmmalOh4gcv2NhfHZGeN/15qpVrP4aoANsBpth59HUj+0Atr0zDb?=
 =?us-ascii?Q?snav028EcUa49C+PRB6yiiR8OGbOc0QfxZG2Ukp3TFk2mlfEHL8OJ9ojKvmt?=
 =?us-ascii?Q?BtJ+Hnl8H2yWiPqH69ZaK3TN4x4gVhdUToIyMBNJsKnYOVr6NOVpwG9d02ZX?=
 =?us-ascii?Q?0w/8a8m1a5EWFGUo/kGWg4v4Unw3yOl4AUEEyGIojx1tHi+MDP2etv70c/Wj?=
 =?us-ascii?Q?9NXT2YOwzvvoFT68zm8UukwcKefw1vpGP0+E/XnBh0sa/oFT0/3sTojuHw9q?=
 =?us-ascii?Q?h8lw8s2UnU26mZHwRnNEDLI=3D?=
Content-Type: multipart/mixed;
        boundary="_002_20220222100929gj2my4maclyrwz35skbuf_"
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f4b3b281-4931-4be1-01c9-08d9f5eb6b07
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Feb 2022 10:09:31.0126
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: GIO9X6X5tmp6PjkjnarJBYcZVZUOw4J+tf5NIQ4evO17QRPO75T6/dB4hfzZ6+AkYHYsHI0Zeb74McBaZs6T2Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM7PR04MB6981
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--_002_20220222100929gj2my4maclyrwz35skbuf_
Content-Type: text/plain; charset="us-ascii"
Content-ID: <D274212F23BB97449DB14F7988646B19@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable

Hi Jianbo,

On Tue, Feb 22, 2022 at 01:58:23AM +0000, Jianbo Liu wrote:
> Hi Vladimir,
>=20
> I'd love to hear your suggestion regarding where this validate function
> to be placed for drivers/net/ethernet/mscc, as it will be used by both
> ocelot_net.c and ocelot_flower.c.=20
>=20
> Thanks!
> Jianbo

Try the attached patch on top of yours.

--_002_20220222100929gj2my4maclyrwz35skbuf_
Content-Type: text/x-diff; name="0001-ocelot-policer-validate.patch"
Content-Description: 0001-ocelot-policer-validate.patch
Content-Disposition: attachment;
	filename="0001-ocelot-policer-validate.patch"; size=7837;
	creation-date="Tue, 22 Feb 2022 10:09:30 GMT";
	modification-date="Tue, 22 Feb 2022 10:09:30 GMT"
Content-ID: <90324B3CA641684D8184513C511A9B14@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: base64

RnJvbSBkNDAxZjU1YTM0MzkwYzI3YjM1YWU2NDdkMjYwZTJiOTAwNTI4NTE3IE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQ0KRnJvbTogVmxhZGltaXIgT2x0ZWFuIDx2bGFkaW1pci5vbHRlYW5Abnhw
LmNvbT4NCkRhdGU6IFR1ZSwgMjIgRmViIDIwMjIgMTI6MDU6NTkgKzAyMDANClN1YmplY3Q6IFtQ
QVRDSF0gb2NlbG90IHBvbGljZXIgdmFsaWRhdGUNCg0KU2lnbmVkLW9mZi1ieTogVmxhZGltaXIg
T2x0ZWFuIDx2bGFkaW1pci5vbHRlYW5AbnhwLmNvbT4NCi0tLQ0KIGRyaXZlcnMvbmV0L2V0aGVy
bmV0L21zY2Mvb2NlbG90X2Zsb3dlci5jIHwgMzggKysrKy0tLS0tLS0tLS0tLS0tLS0tDQogZHJp
dmVycy9uZXQvZXRoZXJuZXQvbXNjYy9vY2Vsb3RfbmV0LmMgICAgfCAzNyArKystLS0tLS0tLS0t
LS0tLS0tLQ0KIGRyaXZlcnMvbmV0L2V0aGVybmV0L21zY2Mvb2NlbG90X3BvbGljZS5jIHwgNDEg
KysrKysrKysrKysrKysrKysrKysrKysNCiBkcml2ZXJzL25ldC9ldGhlcm5ldC9tc2NjL29jZWxv
dF9wb2xpY2UuaCB8ICA1ICsrKw0KIDQgZmlsZXMgY2hhbmdlZCwgNTcgaW5zZXJ0aW9ucygrKSwg
NjQgZGVsZXRpb25zKC0pDQoNCmRpZmYgLS1naXQgYS9kcml2ZXJzL25ldC9ldGhlcm5ldC9tc2Nj
L29jZWxvdF9mbG93ZXIuYyBiL2RyaXZlcnMvbmV0L2V0aGVybmV0L21zY2Mvb2NlbG90X2Zsb3dl
ci5jDQppbmRleCA0NjgwYTYyYjRkOWEuLmIzZjU0MThkYzYyMiAxMDA2NDQNCi0tLSBhL2RyaXZl
cnMvbmV0L2V0aGVybmV0L21zY2Mvb2NlbG90X2Zsb3dlci5jDQorKysgYi9kcml2ZXJzL25ldC9l
dGhlcm5ldC9tc2NjL29jZWxvdF9mbG93ZXIuYw0KQEAgLTYsNiArNiw3IEBADQogI2luY2x1ZGUg
PG5ldC9wa3RfY2xzLmg+DQogI2luY2x1ZGUgPG5ldC90Y19hY3QvdGNfZ2FjdC5oPg0KICNpbmNs
dWRlIDxzb2MvbXNjYy9vY2Vsb3RfdmNhcC5oPg0KKyNpbmNsdWRlICJvY2Vsb3RfcG9saWNlLmgi
DQogI2luY2x1ZGUgIm9jZWxvdF92Y2FwLmgiDQogDQogLyogQXJiaXRyYXJpbHkgY2hvc2VuIGNv
bnN0YW50cyBmb3IgZW5jb2RpbmcgdGhlIFZDQVAgYmxvY2sgYW5kIGxvb2t1cCBudW1iZXINCkBA
IC0yMTcsNiArMjE4LDcgQEAgc3RhdGljIGludCBvY2Vsb3RfZmxvd2VyX3BhcnNlX2FjdGlvbihz
dHJ1Y3Qgb2NlbG90ICpvY2Vsb3QsIGludCBwb3J0LA0KIAkJCQkgICAgICBib29sIGluZ3Jlc3Ms
IHN0cnVjdCBmbG93X2Nsc19vZmZsb2FkICpmLA0KIAkJCQkgICAgICBzdHJ1Y3Qgb2NlbG90X3Zj
YXBfZmlsdGVyICpmaWx0ZXIpDQogew0KKwljb25zdCBzdHJ1Y3QgZmxvd19hY3Rpb24gKmFjdGlv
biA9ICZmLT5ydWxlLT5hY3Rpb247DQogCXN0cnVjdCBuZXRsaW5rX2V4dF9hY2sgKmV4dGFjayA9
IGYtPmNvbW1vbi5leHRhY2s7DQogCWJvb2wgYWxsb3dfbWlzc2luZ19nb3RvX3RhcmdldCA9IGZh
bHNlOw0KIAljb25zdCBzdHJ1Y3QgZmxvd19hY3Rpb25fZW50cnkgKmE7DQpAQCAtMjQ0LDcgKzI0
Niw3IEBAIHN0YXRpYyBpbnQgb2NlbG90X2Zsb3dlcl9wYXJzZV9hY3Rpb24oc3RydWN0IG9jZWxv
dCAqb2NlbG90LCBpbnQgcG9ydCwNCiAJZmlsdGVyLT5nb3RvX3RhcmdldCA9IC0xOw0KIAlmaWx0
ZXItPnR5cGUgPSBPQ0VMT1RfVkNBUF9GSUxURVJfRFVNTVk7DQogDQotCWZsb3dfYWN0aW9uX2Zv
cl9lYWNoKGksIGEsICZmLT5ydWxlLT5hY3Rpb24pIHsNCisJZmxvd19hY3Rpb25fZm9yX2VhY2go
aSwgYSwgYWN0aW9uKSB7DQogCQlzd2l0Y2ggKGEtPmlkKSB7DQogCQljYXNlIEZMT1dfQUNUSU9O
X0RST1A6DQogCQkJaWYgKGZpbHRlci0+YmxvY2tfaWQgIT0gVkNBUF9JUzIpIHsNCkBAIC0yOTgs
MzggKzMwMCwxMCBAQCBzdGF0aWMgaW50IG9jZWxvdF9mbG93ZXJfcGFyc2VfYWN0aW9uKHN0cnVj
dCBvY2Vsb3QgKm9jZWxvdCwgaW50IHBvcnQsDQogCQkJCXJldHVybiAtRU9QTk9UU1VQUDsNCiAJ
CQl9DQogDQotCQkJaWYgKGEtPnBvbGljZS5leGNlZWQuYWN0X2lkICE9IEZMT1dfQUNUSU9OX0RS
T1ApIHsNCi0JCQkJTkxfU0VUX0VSUl9NU0dfTU9EKGV4dGFjaywNCi0JCQkJCQkgICAiUG9saWNl
IG9mZmxvYWQgaXMgbm90IHN1cHBvcnRlZCB3aGVuIHRoZSBleGNlZWQgYWN0aW9uIGlzIG5vdCBk
cm9wIik7DQotCQkJCXJldHVybiAtRU9QTk9UU1VQUDsNCi0JCQl9DQotDQotCQkJaWYgKGEtPnBv
bGljZS5ub3RleGNlZWQuYWN0X2lkICE9IEZMT1dfQUNUSU9OX1BJUEUgJiYNCi0JCQkgICAgYS0+
cG9saWNlLm5vdGV4Y2VlZC5hY3RfaWQgIT0gRkxPV19BQ1RJT05fQUNDRVBUKSB7DQotCQkJCU5M
X1NFVF9FUlJfTVNHX01PRChleHRhY2ssDQotCQkJCQkJICAgIlBvbGljZSBvZmZsb2FkIGlzIG5v
dCBzdXBwb3J0ZWQgd2hlbiB0aGUgY29uZm9ybSBhY3Rpb24gaXMgbm90IHBpcGUgb3Igb2siKTsN
Ci0JCQkJcmV0dXJuIC1FT1BOT1RTVVBQOw0KLQkJCX0NCi0NCi0JCQlpZiAoYS0+cG9saWNlLm5v
dGV4Y2VlZC5hY3RfaWQgPT0gRkxPV19BQ1RJT05fQUNDRVBUICYmDQotCQkJICAgICFmbG93X2Fj
dGlvbl9pc19sYXN0X2VudHJ5KCZmLT5ydWxlLT5hY3Rpb24sIGEpKSB7DQotCQkJCU5MX1NFVF9F
UlJfTVNHX01PRChleHRhY2ssDQotCQkJCQkJICAgIlBvbGljZSBvZmZsb2FkIGlzIG5vdCBzdXBw
b3J0ZWQgd2hlbiB0aGUgY29uZm9ybSBhY3Rpb24gaXMgb2ssIGJ1dCBwb2xpY2UgYWN0aW9uIGlz
IG5vdCBsYXN0Iik7DQotCQkJCXJldHVybiAtRU9QTk9UU1VQUDsNCi0JCQl9DQotDQotCQkJaWYg
KGEtPnBvbGljZS5wZWFrcmF0ZV9ieXRlc19wcyB8fA0KLQkJCSAgICBhLT5wb2xpY2UuYXZyYXRl
IHx8IGEtPnBvbGljZS5vdmVyaGVhZCkgew0KLQkJCQlOTF9TRVRfRVJSX01TR19NT0QoZXh0YWNr
LA0KLQkJCQkJCSAgICJQb2xpY2Ugb2ZmbG9hZCBpcyBub3Qgc3VwcG9ydGVkIHdoZW4gcGVha3Jh
dGUvYXZyYXRlL292ZXJoZWFkIGlzIGNvbmZpZ3VyZWQiKTsNCi0JCQkJcmV0dXJuIC1FT1BOT1RT
VVBQOw0KLQkJCX0NCisJCQllcnIgPSBvY2Vsb3RfcG9saWNlcl92YWxpZGF0ZShhY3Rpb24sIGEs
IGV4dGFjayk7DQorCQkJaWYgKGVycikNCisJCQkJcmV0dXJuIGVycjsNCiANCi0JCQlpZiAoYS0+
cG9saWNlLnJhdGVfcGt0X3BzKSB7DQotCQkJCU5MX1NFVF9FUlJfTVNHX01PRChleHRhY2ssDQot
CQkJCQkJICAgIlFvUyBvZmZsb2FkIG5vdCBzdXBwb3J0IHBhY2tldHMgcGVyIHNlY29uZCIpOw0K
LQkJCQlyZXR1cm4gLUVPUE5PVFNVUFA7DQotCQkJfQ0KIAkJCWZpbHRlci0+YWN0aW9uLnBvbGlj
ZV9lbmEgPSB0cnVlOw0KIA0KIAkJCXBvbF9peCA9IGEtPmh3X2luZGV4ICsgb2NlbG90LT52Y2Fw
X3BvbC5iYXNlOw0KZGlmZiAtLWdpdCBhL2RyaXZlcnMvbmV0L2V0aGVybmV0L21zY2Mvb2NlbG90
X25ldC5jIGIvZHJpdmVycy9uZXQvZXRoZXJuZXQvbXNjYy9vY2Vsb3RfbmV0LmMNCmluZGV4IDRl
MzhkNDFkYmEyOS4uNTc2N2UzOGMwYzVhIDEwMDY0NA0KLS0tIGEvZHJpdmVycy9uZXQvZXRoZXJu
ZXQvbXNjYy9vY2Vsb3RfbmV0LmMNCisrKyBiL2RyaXZlcnMvbmV0L2V0aGVybmV0L21zY2Mvb2Nl
bG90X25ldC5jDQpAQCAtMTQsNiArMTQsNyBAQA0KICNpbmNsdWRlIDxsaW51eC9waHkvcGh5Lmg+
DQogI2luY2x1ZGUgPG5ldC9wa3RfY2xzLmg+DQogI2luY2x1ZGUgIm9jZWxvdC5oIg0KKyNpbmNs
dWRlICJvY2Vsb3RfcG9saWNlLmgiDQogI2luY2x1ZGUgIm9jZWxvdF92Y2FwLmgiDQogI2luY2x1
ZGUgIm9jZWxvdF9mZG1hLmgiDQogDQpAQCAtMjU4LDM4ICsyNTksMTAgQEAgc3RhdGljIGludCBv
Y2Vsb3Rfc2V0dXBfdGNfY2xzX21hdGNoYWxsKHN0cnVjdCBvY2Vsb3RfcG9ydF9wcml2YXRlICpw
cml2LA0KIAkJCXJldHVybiAtRUVYSVNUOw0KIAkJfQ0KIA0KLQkJaWYgKGFjdGlvbi0+cG9saWNl
LmV4Y2VlZC5hY3RfaWQgIT0gRkxPV19BQ1RJT05fRFJPUCkgew0KLQkJCU5MX1NFVF9FUlJfTVNH
X01PRChleHRhY2ssDQotCQkJCQkgICAiUG9saWNlIG9mZmxvYWQgaXMgbm90IHN1cHBvcnRlZCB3
aGVuIHRoZSBleGNlZWQgYWN0aW9uIGlzIG5vdCBkcm9wIik7DQotCQkJcmV0dXJuIC1FT1BOT1RT
VVBQOw0KLQkJfQ0KLQ0KLQkJaWYgKGFjdGlvbi0+cG9saWNlLm5vdGV4Y2VlZC5hY3RfaWQgIT0g
RkxPV19BQ1RJT05fUElQRSAmJg0KLQkJICAgIGFjdGlvbi0+cG9saWNlLm5vdGV4Y2VlZC5hY3Rf
aWQgIT0gRkxPV19BQ1RJT05fQUNDRVBUKSB7DQotCQkJTkxfU0VUX0VSUl9NU0dfTU9EKGV4dGFj
aywNCi0JCQkJCSAgICJQb2xpY2Ugb2ZmbG9hZCBpcyBub3Qgc3VwcG9ydGVkIHdoZW4gdGhlIGNv
bmZvcm0gYWN0aW9uIGlzIG5vdCBwaXBlIG9yIG9rIik7DQotCQkJcmV0dXJuIC1FT1BOT1RTVVBQ
Ow0KLQkJfQ0KLQ0KLQkJaWYgKGFjdGlvbi0+cG9saWNlLm5vdGV4Y2VlZC5hY3RfaWQgPT0gRkxP
V19BQ1RJT05fQUNDRVBUICYmDQotCQkgICAgIWZsb3dfYWN0aW9uX2lzX2xhc3RfZW50cnkoJmYt
PnJ1bGUtPmFjdGlvbiwgYWN0aW9uKSkgew0KLQkJCU5MX1NFVF9FUlJfTVNHX01PRChleHRhY2ss
DQotCQkJCQkgICAiUG9saWNlIG9mZmxvYWQgaXMgbm90IHN1cHBvcnRlZCB3aGVuIHRoZSBjb25m
b3JtIGFjdGlvbiBpcyBvaywgYnV0IHBvbGljZSBhY3Rpb24gaXMgbm90IGxhc3QiKTsNCi0JCQly
ZXR1cm4gLUVPUE5PVFNVUFA7DQotCQl9DQotDQotCQlpZiAoYWN0aW9uLT5wb2xpY2UucGVha3Jh
dGVfYnl0ZXNfcHMgfHwNCi0JCSAgICBhY3Rpb24tPnBvbGljZS5hdnJhdGUgfHwgYWN0aW9uLT5w
b2xpY2Uub3ZlcmhlYWQpIHsNCi0JCQlOTF9TRVRfRVJSX01TR19NT0QoZXh0YWNrLA0KLQkJCQkJ
ICAgIlBvbGljZSBvZmZsb2FkIGlzIG5vdCBzdXBwb3J0ZWQgd2hlbiBwZWFrcmF0ZS9hdnJhdGUv
b3ZlcmhlYWQgaXMgY29uZmlndXJlZCIpOw0KLQkJCXJldHVybiAtRU9QTk9UU1VQUDsNCi0JCX0N
Ci0NCi0JCWlmIChhY3Rpb24tPnBvbGljZS5yYXRlX3BrdF9wcykgew0KLQkJCU5MX1NFVF9FUlJf
TVNHX01PRChleHRhY2ssDQotCQkJCQkgICAiUW9TIG9mZmxvYWQgbm90IHN1cHBvcnQgcGFja2V0
cyBwZXIgc2Vjb25kIik7DQotCQkJcmV0dXJuIC1FT1BOT1RTVVBQOw0KLQkJfQ0KKwkJZXJyID0g
b2NlbG90X3BvbGljZXJfdmFsaWRhdGUoJmYtPnJ1bGUtPmFjdGlvbiwgYWN0aW9uLA0KKwkJCQkJ
ICAgICAgZXh0YWNrKTsNCisJCWlmIChlcnIpDQorCQkJcmV0dXJuIGVycjsNCiANCiAJCXBvbC5y
YXRlID0gKHUzMilkaXZfdTY0KGFjdGlvbi0+cG9saWNlLnJhdGVfYnl0ZXNfcHMsIDEwMDApICog
ODsNCiAJCXBvbC5idXJzdCA9IGFjdGlvbi0+cG9saWNlLmJ1cnN0Ow0KZGlmZiAtLWdpdCBhL2Ry
aXZlcnMvbmV0L2V0aGVybmV0L21zY2Mvb2NlbG90X3BvbGljZS5jIGIvZHJpdmVycy9uZXQvZXRo
ZXJuZXQvbXNjYy9vY2Vsb3RfcG9saWNlLmMNCmluZGV4IDZmNTA2OGMxMDQxYS4uYTY1NjA2YmI4
NGEwIDEwMDY0NA0KLS0tIGEvZHJpdmVycy9uZXQvZXRoZXJuZXQvbXNjYy9vY2Vsb3RfcG9saWNl
LmMNCisrKyBiL2RyaXZlcnMvbmV0L2V0aGVybmV0L21zY2Mvb2NlbG90X3BvbGljZS5jDQpAQCAt
MTU0LDYgKzE1NCw0NyBAQCBpbnQgcW9zX3BvbGljZXJfY29uZl9zZXQoc3RydWN0IG9jZWxvdCAq
b2NlbG90LCBpbnQgcG9ydCwgdTMyIHBvbF9peCwNCiAJcmV0dXJuIDA7DQogfQ0KIA0KK2ludCBv
Y2Vsb3RfcG9saWNlcl92YWxpZGF0ZShjb25zdCBzdHJ1Y3QgZmxvd19hY3Rpb24gKmFjdGlvbiwN
CisJCQkgICAgY29uc3Qgc3RydWN0IGZsb3dfYWN0aW9uX2VudHJ5ICphLA0KKwkJCSAgICBzdHJ1
Y3QgbmV0bGlua19leHRfYWNrICpleHRhY2spDQorew0KKwlpZiAoYS0+cG9saWNlLmV4Y2VlZC5h
Y3RfaWQgIT0gRkxPV19BQ1RJT05fRFJPUCkgew0KKwkJTkxfU0VUX0VSUl9NU0dfTU9EKGV4dGFj
aywNCisJCQkJICAgIk9mZmxvYWQgbm90IHN1cHBvcnRlZCB3aGVuIGV4Y2VlZCBhY3Rpb24gaXMg
bm90IGRyb3AiKTsNCisJCXJldHVybiAtRU9QTk9UU1VQUDsNCisJfQ0KKw0KKwlpZiAoYS0+cG9s
aWNlLm5vdGV4Y2VlZC5hY3RfaWQgIT0gRkxPV19BQ1RJT05fUElQRSAmJg0KKwkgICAgYS0+cG9s
aWNlLm5vdGV4Y2VlZC5hY3RfaWQgIT0gRkxPV19BQ1RJT05fQUNDRVBUKSB7DQorCQlOTF9TRVRf
RVJSX01TR19NT0QoZXh0YWNrLA0KKwkJCQkgICAiT2ZmbG9hZCBub3Qgc3VwcG9ydGVkIHdoZW4g
Y29uZm9ybSBhY3Rpb24gaXMgbm90IHBpcGUgb3Igb2siKTsNCisJCXJldHVybiAtRU9QTk9UU1VQ
UDsNCisJfQ0KKw0KKwlpZiAoYS0+cG9saWNlLm5vdGV4Y2VlZC5hY3RfaWQgPT0gRkxPV19BQ1RJ
T05fQUNDRVBUICYmDQorCSAgICAhZmxvd19hY3Rpb25faXNfbGFzdF9lbnRyeShhY3Rpb24sIGEp
KSB7DQorCQlOTF9TRVRfRVJSX01TR19NT0QoZXh0YWNrLA0KKwkJCQkgICAiT2ZmbG9hZCBub3Qg
c3VwcG9ydGVkIHdoZW4gY29uZm9ybSBhY3Rpb24gaXMgb2ssIGJ1dCBwb2xpY2UgYWN0aW9uIGlz
IG5vdCBsYXN0Iik7DQorCQlyZXR1cm4gLUVPUE5PVFNVUFA7DQorCX0NCisNCisJaWYgKGEtPnBv
bGljZS5wZWFrcmF0ZV9ieXRlc19wcyB8fA0KKwkgICAgYS0+cG9saWNlLmF2cmF0ZSB8fCBhLT5w
b2xpY2Uub3ZlcmhlYWQpIHsNCisJCU5MX1NFVF9FUlJfTVNHX01PRChleHRhY2ssDQorCQkJCSAg
ICJPZmZsb2FkIG5vdCBzdXBwb3J0ZWQgd2hlbiBwZWFrcmF0ZS9hdnJhdGUvb3ZlcmhlYWQgaXMg
Y29uZmlndXJlZCIpOw0KKwkJcmV0dXJuIC1FT1BOT1RTVVBQOw0KKwl9DQorDQorCWlmIChhLT5w
b2xpY2UucmF0ZV9wa3RfcHMpIHsNCisJCU5MX1NFVF9FUlJfTVNHX01PRChleHRhY2ssDQorCQkJ
CSAgICJPZmZsb2FkIGRvZXMgbm90IHN1cHBvcnQgcGFja2V0cyBwZXIgc2Vjb25kIik7DQorCQly
ZXR1cm4gLUVPUE5PVFNVUFA7DQorCX0NCisNCisJcmV0dXJuIDA7DQorfQ0KK0VYUE9SVF9TWU1C
T0wob2NlbG90X3BvbGljZXJfdmFsaWRhdGUpOw0KKw0KIGludCBvY2Vsb3RfcG9ydF9wb2xpY2Vy
X2FkZChzdHJ1Y3Qgb2NlbG90ICpvY2Vsb3QsIGludCBwb3J0LA0KIAkJCSAgICBzdHJ1Y3Qgb2Nl
bG90X3BvbGljZXIgKnBvbCkNCiB7DQpkaWZmIC0tZ2l0IGEvZHJpdmVycy9uZXQvZXRoZXJuZXQv
bXNjYy9vY2Vsb3RfcG9saWNlLmggYi9kcml2ZXJzL25ldC9ldGhlcm5ldC9tc2NjL29jZWxvdF9w
b2xpY2UuaA0KaW5kZXggN2FkYjA1ZjcxOTk5Li43NTUyOTk1ZjhiMTcgMTAwNjQ0DQotLS0gYS9k
cml2ZXJzL25ldC9ldGhlcm5ldC9tc2NjL29jZWxvdF9wb2xpY2UuaA0KKysrIGIvZHJpdmVycy9u
ZXQvZXRoZXJuZXQvbXNjYy9vY2Vsb3RfcG9saWNlLmgNCkBAIC04LDYgKzgsNyBAQA0KICNkZWZp
bmUgX01TQ0NfT0NFTE9UX1BPTElDRV9IXw0KIA0KICNpbmNsdWRlICJvY2Vsb3QuaCINCisjaW5j
bHVkZSA8bmV0L2Zsb3dfb2ZmbG9hZC5oPg0KIA0KIGVudW0gbXNjY19xb3NfcmF0ZV9tb2RlIHsN
CiAJTVNDQ19RT1NfUkFURV9NT0RFX0RJU0FCTEVELCAvKiBQb2xpY2VyL3NoYXBlciBkaXNhYmxl
ZCAqLw0KQEAgLTMzLDQgKzM0LDggQEAgc3RydWN0IHFvc19wb2xpY2VyX2NvbmYgew0KIGludCBx
b3NfcG9saWNlcl9jb25mX3NldChzdHJ1Y3Qgb2NlbG90ICpvY2Vsb3QsIGludCBwb3J0LCB1MzIg
cG9sX2l4LA0KIAkJCSBzdHJ1Y3QgcW9zX3BvbGljZXJfY29uZiAqY29uZik7DQogDQoraW50IG9j
ZWxvdF9wb2xpY2VyX3ZhbGlkYXRlKGNvbnN0IHN0cnVjdCBmbG93X2FjdGlvbiAqYWN0aW9uLA0K
KwkJCSAgICBjb25zdCBzdHJ1Y3QgZmxvd19hY3Rpb25fZW50cnkgKmEsDQorCQkJICAgIHN0cnVj
dCBuZXRsaW5rX2V4dF9hY2sgKmV4dGFjayk7DQorDQogI2VuZGlmIC8qIF9NU0NDX09DRUxPVF9Q
T0xJQ0VfSF8gKi8NCi0tIA0KMi4yNS4xDQoNCg==

--_002_20220222100929gj2my4maclyrwz35skbuf_--
