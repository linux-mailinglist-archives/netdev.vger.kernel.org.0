Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 143F056D29A
	for <lists+netdev@lfdr.de>; Mon, 11 Jul 2022 03:32:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229792AbiGKBcb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 10 Jul 2022 21:32:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36280 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229704AbiGKBcY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 10 Jul 2022 21:32:24 -0400
Received: from na01-obe.outbound.protection.outlook.com (mail-cusazon11020027.outbound.protection.outlook.com [52.101.61.27])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4356F167FF;
        Sun, 10 Jul 2022 18:32:19 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mTW4cFmFwzHOLbob/AWfLsO8sf9U6ptI7nBikW7KKyIBaWxxQTkZ24QKGmHxb5HJmac0CpclW7olRF8Bp1I8jpHlAXfejX/cKfOz6HkhNiivn1dJJFnl6oqErWzFTgkbD+3UkaQlkGKMgadAVPSIfReSF7N59dYmYK2IdES4mdUZ9sYG0UXjsEIY9iPXfori52rGHJraWf2/SeL70zThSnpP1DFLLJpWNg7emHjVmIBp1X4vp0ulWMFg79Dy7EDUkIiv4k6a5onK/vLgOqdvESMWQSVQsqijdrb1aO+dH4HxfXkVf4VEWTrPr011PdgiMsh/dw49I/ZQ7pRF28h48A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=pJ49vM1qOhRvBfzjX8VccAKKHgFG+H1/ts8ciJkV1Ew=;
 b=Fv8+jDzxcbd8yEUiqOcEat9Psb6aThvsQlQJBvTLz766R80LR67ha8CfOypAvwNGmwQ9+vccswQXi94Gz8epHylZMuJOVfjvSP9MkQgJ8IfN+aQIgFOV0Mmzw1s0nWiJ71dR3Jhkdo7mUdQ8jmK+q2Ge4z8zWR/Y13cEC90GKAjp5HDGu6qhuOA3eToqTmt+jCQoI5/kO3TQzm+CZTN9raIYDHoTABRPvuBkmNQ6bhA8BG3svu6+Wri2OTF01ipgGzx8sVSmNd7aXKHBA4IBKiMWtBkHDzV0kDdGz1drXHd/DrgGSzT4O/xDR8aQMJIGzsiuflhPRHWxLLPOWOzM2Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pJ49vM1qOhRvBfzjX8VccAKKHgFG+H1/ts8ciJkV1Ew=;
 b=UJiuqkDkx3WLDQcOhB2BJLNyrcw8sm1veJ+wmWup3QT5qTHPn9Pp498NLPWno/iXEg87aM3ZWrpEc5FzSmG9BxvnW6pGHtqY98ZefKb4+GDnuRDpxoWk4pDh32Ve/EbLwIFa1ZdWUKEXZB5C/Thhg80aflf1bMeHMgo9fTIG4r8=
Received: from SN6PR2101MB1327.namprd21.prod.outlook.com
 (2603:10b6:805:107::9) by MN0PR21MB3508.namprd21.prod.outlook.com
 (2603:10b6:208:3d3::16) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5458.2; Mon, 11 Jul
 2022 01:32:17 +0000
Received: from SN6PR2101MB1327.namprd21.prod.outlook.com
 ([fe80::59ea:cdde:5229:d4f0]) by SN6PR2101MB1327.namprd21.prod.outlook.com
 ([fe80::59ea:cdde:5229:d4f0%7]) with mapi id 15.20.5458.003; Mon, 11 Jul 2022
 01:32:17 +0000
From:   Dexuan Cui <decui@microsoft.com>
To:     Long Li <longli@microsoft.com>, KY Srinivasan <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        Wei Liu <wei.liu@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Jason Gunthorpe <jgg@ziepe.ca>,
        Leon Romanovsky <leon@kernel.org>,
        "edumazet@google.com" <edumazet@google.com>,
        "shiraz.saleem@intel.com" <shiraz.saleem@intel.com>,
        Ajay Sharma <sharmaajay@microsoft.com>
CC:     "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>
Subject: RE: [Patch v4 09/12] net: mana: Move header files to a common
 location
Thread-Topic: [Patch v4 09/12] net: mana: Move header files to a common
 location
Thread-Index: AQHYgSXaoPYPprkNxk2WpnFJM/piu612/GgA
Date:   Mon, 11 Jul 2022 01:32:17 +0000
Message-ID: <SN6PR2101MB13272FC31CE629D2D9DE0534BF879@SN6PR2101MB1327.namprd21.prod.outlook.com>
References: <1655345240-26411-1-git-send-email-longli@linuxonhyperv.com>
 <1655345240-26411-10-git-send-email-longli@linuxonhyperv.com>
In-Reply-To: <1655345240-26411-10-git-send-email-longli@linuxonhyperv.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=aa06b335-6150-40e0-bfd9-b9f81e44a9ed;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ContentBits=0;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=true;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Method=Standard;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=Internal;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2022-07-10T01:49:54Z;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microsoft.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: ca4221c5-d243-43e3-2a2b-08da62dd30d1
x-ms-traffictypediagnostic: MN0PR21MB3508:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: o3Ero7LnT1hTGumQ5qlxdCrE2AiYn+3iLfZg3ebj/VNVdhuIgxlOJBszBhcaKMVF0XK91EiTI3a3Eg24GoVA51+u66ZYPfppBEjkLWrlqBb38iM8aw3qJtITWL/GaS48ASq2DpScLvxJDiadPaP7JYIzqKf9ZJ6oOdDPYE6JfgkBc6k1gqlSzo+JocGtYiGHSt4NrX6UYARvTZ4cIruh+T8NRmV+TMG/pRzb+Haa+zuHLFDapMwr0UhVLTscw70B7Zcwi9T6w5d+H3BnxolrDBs2oitv1IgvBCubGzw6+wYncbxZcrV/I7RSBHGX7zOjYz+/UE44rjO7TP/As6S20nz7L0ZPhDKlNk114GietBvIb5EOKfQ+A2LqKltZKELG0cOgNakvw3Qfsu2VRC8TxuLySscq8aJctyCY/W5NqCygd37GqQ43RF4BNLfH8RCwgrn7Skrwsp3AH98zDC37ThRbmc9qQQan/ggS4gM4n1KC23GcvZVleIPTfEXylXu3h1WmXPVRK/T3Q98b+ACVnYCTJGGP3DQoc7M+BDNrb1tv5TILxyunXp+FHnpGlH0EhaMwcMm2QiepnsAQi2oIYpIa215u68a4al3zksElz7S50LQcpYP+zmDhIrACulqjhMja6lmbfTh83DnEhJhrYJUngfwHeGvkxKt41hMclLi+SpceHtx4yqunLPdgWp7OIdEazTm0ldqgelxH+ky5SROpgcD4DVNXidcl4kX4MnDKBa4P17DKpKQfwK0qH92A+g1J06RlG/bTXkcsk4pScjbMFy83Aa3URZsKsqaFx3MO1QMCcfM63fEIXoo3ohJOUgFFBFecD59HHsPu9w4+WEnWaXpDnu1C4rsgOKmYO2U6JfsQ5JyqGZ0SSKgubNAP
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR2101MB1327.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(346002)(39860400002)(366004)(136003)(396003)(376002)(451199009)(2906002)(6506007)(55016003)(7696005)(41300700001)(33656002)(186003)(26005)(8990500004)(9686003)(71200400001)(66446008)(66476007)(66556008)(66946007)(64756008)(54906003)(316002)(110136005)(8676002)(38070700005)(10290500003)(86362001)(8936002)(6636002)(52536014)(4326008)(4744005)(5660300002)(7416002)(478600001)(122000001)(38100700002)(921005)(82950400001)(76116006)(82960400001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?iVJdD491eYFA2BtJuXPqjXXpTj6JJvrd9J51yz7HXXkgVsgV4RETF9um5gVA?=
 =?us-ascii?Q?NV2Extv/0L0RMrEwouhMme7Rnyy5zlW4wOjK+d3e/o6w87J3O8O7Ry4ktS+A?=
 =?us-ascii?Q?N4Rltwmi8ITsVSQnkPnD4x0BAD1t/UlMkt1WSoughQSO+8pHptiLuz43e5Aj?=
 =?us-ascii?Q?agbO5DyJ2T/pHpfayPPF1V3anuVtjWpngcZNHn7WCCsjDZ6PFEE9KXUl0iym?=
 =?us-ascii?Q?Lic8pxwCTuiUQPF0NbUVFanTsl9URNaSmS1u7zbbkwO6Jzh+LLC+O4X1eqAp?=
 =?us-ascii?Q?MnWWZS5SPRg1Wx5O+r4pBTQEhmrCXiJb6jfekmDGmunMwka6fFP3P5OFnf1Z?=
 =?us-ascii?Q?wHJs40ZpXlJXcYMvr96/8nT4gGIuCEx4KXeZkKY5107xg8XkUjHH7QyTK2OR?=
 =?us-ascii?Q?8O9ybch1siVvg6N8FcrrKn9+1XGH2rpgGM9Cu6h5I4DpPD8ZJmLZSgywOL+X?=
 =?us-ascii?Q?/2lL1OktJ1B/AeNVHRCYxQMblp9g0YwwZxKLG1lspZ4x42lDb0f/WFyUmKP/?=
 =?us-ascii?Q?yiqDfPHz2bcPugzsiN+V0RNdBDfvKgax+5FLTisJ6aar3RL6UE2na6H051lZ?=
 =?us-ascii?Q?WsapLxVTZxKxgQA/5lLG7YrrClPXuA8P8860lcf/XzABdRioONAYxoVWkfru?=
 =?us-ascii?Q?Myc/DWgYLF7DNyyKDHhS1m6UZ39CJPS6Jaze4y1BBZv6i5c2TKSDAn3nXbHr?=
 =?us-ascii?Q?WkKbWBGveply/lK+1BuFBDZNHLFr4gwEOG4UHIHQJqo2gcxKi80xSwr3Ufnz?=
 =?us-ascii?Q?qhOihOkcXhL0GuDk1lS/7Oe2e9ATVXWOJQipGAdKlpOjFGcZX297EetXNBR3?=
 =?us-ascii?Q?4HcIITL6cMOGB6DsGtpGpJRmMvJi6tPbAwQ/8KVxY1tdP6q1L0iRfZdunwZJ?=
 =?us-ascii?Q?b1u/0nMr94DDuHmNtSM82cyXgI/x1e3MzE7TaH+koqx+NjFtx78Xbzz93Mtl?=
 =?us-ascii?Q?dTapPyLJj3t5iP5MjOAfe3W4Hl3IXaZLCQq+XOGWnxTTpLqsNgpA+ps6+btg?=
 =?us-ascii?Q?jnnA104ZM9XVXhZ7mUZPPbGa7cqmKr4rYbN3ONv78rHn8cdyHRUxb2+8gP8I?=
 =?us-ascii?Q?hEWhSlcPvFByjhVXsAliGC2DM2m7pLKi1oiC4uufQVUv0VVmIHM5jkginOAM?=
 =?us-ascii?Q?CnAVIfPEW4/qUkLIBf7Kfsh7msZ3CFHUBhG2rp9DUIe3DJY3yA4r6gAgslgb?=
 =?us-ascii?Q?qHov5o49lkdxD4OODKRWsSV1zaFzNRS4CyqTFzoAiuWnLYINX8YMsBIZhheM?=
 =?us-ascii?Q?uTCcW5SUPjP3D56JKiesDPOSML6ZiebSllGNTDgqzwDUY0pVzJcj7+9knv5N?=
 =?us-ascii?Q?42d43TlE62yMqjcXbMndsuvc7Dv9X8N51FTmF/jwd+wc5GgJINzcL6Xz3xO6?=
 =?us-ascii?Q?iM62LOrjPOydDHMU7zcl49QQAE+NOs69grNvT7Z522SZFe1rPh7dwfeGtdxu?=
 =?us-ascii?Q?b8Hzv3XL0EDwmbLhl27hH4qu7ir2Y73hcxqZCI8/0TrAVxQ2r/q/XLFg6xg8?=
 =?us-ascii?Q?lg/pC45A60+sYHZuyybyIa3jwIadMQvjPwwdx/ZAjVxKmQt9TtsDyT243BKD?=
 =?us-ascii?Q?yDD+YWyrM3IIU+DClxEqW+7KeLSBz1iVAF1QOA6I?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR2101MB1327.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ca4221c5-d243-43e3-2a2b-08da62dd30d1
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Jul 2022 01:32:17.2498
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: eAtPmHqV8OtV9qujhAD/zGk0Ok09giyUJaPgRdriPSe4eiLSNt39Vlv7VCeKwtgkkc49V801RmyF4o50gKXkbg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR21MB3508
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> From: longli@linuxonhyperv.com <longli@linuxonhyperv.com>
> Sent: Wednesday, June 15, 2022 7:07 PM
> ...
> In preparation to add MANA RDMA driver, move all the required header file=
s
> to a common location for use by both Ethernet and RDMA drivers.
>=20
> Signed-off-by: Long Li <longli@microsoft.com>
> ---
> Change log:
> v2: Move headers to include/net/mana, instead of include/linux/mana
> ...
>  rename {drivers/net/ethernet/microsoft =3D> include/net}/mana/gdma.h
> (100%)
>  rename {drivers/net/ethernet/microsoft =3D> include/net}/mana/hw_channel=
.h
> (100%)
>  rename {drivers/net/ethernet/microsoft =3D> include/net}/mana/mana.h
> (100%)
>  rename {drivers/net/ethernet/microsoft =3D>
> include/net}/mana/shm_channel.h (100%)

While I'm giving my Reviewed-by, I hope someone who has a better judgement
can share thoughts as well.

Reviewed-by: Dexuan Cui <decui@microsoft.com>
=20

