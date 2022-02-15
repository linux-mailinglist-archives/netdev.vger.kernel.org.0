Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4215B4B754F
	for <lists+netdev@lfdr.de>; Tue, 15 Feb 2022 21:47:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239590AbiBOUNM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Feb 2022 15:13:12 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:56174 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230355AbiBOUNL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Feb 2022 15:13:11 -0500
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2041.outbound.protection.outlook.com [40.107.92.41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C14EDEACBD;
        Tue, 15 Feb 2022 12:13:00 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Vsc/hAOuJAg5o52jiHfaw4rRBCnQD9SVt2uQ5GXa+DYOhQ7k86DjKcoTFq6zd8nXfdvEsqjfll7UNXAO1OyXoHduF1+JtjvxzzDmkni6KwAo0bXjMcv+YupKpem1LHLP+5993mHcwUcLi9CSrODBmQP2coiUZ7x6jaFexyplZ4+8fKVWy6BwNuQrJryS8c1R2s6mbKUWC4B4B9hwjoy4S0d2r5tHkAa3wpBTBOivl9Nu5RNYcAkAOmrGOa3K0DkvVBDrfuYfU7UvfSWAVc4PwOSuyFev3N8aEooplpmQCoOAyMvxeyMQDZDxa2ZHhsFeiFx53v3BZY+0obTvKnoR5Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hKswz/XUL9ucYSel09DjVbaUfTnWJN3ZiaI99xR+rDQ=;
 b=MSEt5eLDrYTUjiU8YJW0Zp0Usc6fVwCtmTJJNLBDj491P92cF3yfiTfYv8injA4OXZewVoSMaJt5hx7Rx0JE/VdyOgqIlHLRxM6fO0GKdwNqSnexBpUkhpxeFiZyp7lhWRyFhRPkhdDRQO/oZmqszO0zn9I0NEkI/H0i8QCbZlCH4I9kQj6ecaAhMb4Yhzr7Gk/X9aQXluwHfsF61Z4Y30Vr9t/nFqslKoHWyPr8StnNJC3QhjDf3LEtBqsDF7gVj1MMcIuShwsKYnvfAv4wxO7GDA23ZzbW6FgLp95V9GTTN/xIYvAcG0BG5F/DthjLqqbtoZmqn7lGtKkZ1X1Ijw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=xilinx.onmicrosoft.com; s=selector2-xilinx-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hKswz/XUL9ucYSel09DjVbaUfTnWJN3ZiaI99xR+rDQ=;
 b=AuTsQOhsivu5xGpYkOQJ3s3uiYppj5nT5D3FwsOmz7OMKHQh5FPsFFf3zXbEdKxkp11kxwgwWeeyXUvaIqGd0Wv0JvMK4Pfj2O5lYGsvjvwd9kpjzj0SzbSIdqto1LCKAkQST7R0R/XrUChHihI4PtfYurkMmqmJYihXtctVuzc=
Received: from SA1PR02MB8560.namprd02.prod.outlook.com (2603:10b6:806:1fb::24)
 by BYAPR02MB4200.namprd02.prod.outlook.com (2603:10b6:a02:fe::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4975.15; Tue, 15 Feb
 2022 20:12:57 +0000
Received: from SA1PR02MB8560.namprd02.prod.outlook.com
 ([fe80::5c01:aa4b:f709:6530]) by SA1PR02MB8560.namprd02.prod.outlook.com
 ([fe80::5c01:aa4b:f709:6530%7]) with mapi id 15.20.4975.019; Tue, 15 Feb 2022
 20:12:57 +0000
From:   Radhey Shyam Pandey <radheys@xilinx.com>
To:     "trix@redhat.com" <trix@redhat.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        Michal Simek <michals@xilinx.com>,
        "gary@garyguo.net" <gary@garyguo.net>,
        "rdunlap@infradead.org" <rdunlap@infradead.org>,
        "esben@geanix.com" <esben@geanix.com>,
        "huangguangbin2@huawei.com" <huangguangbin2@huawei.com>,
        "michael@walle.cc" <michael@walle.cc>,
        "moyufeng@huawei.com" <moyufeng@huawei.com>,
        "arnd@arndb.de" <arnd@arndb.de>,
        "chenhao288@hisilicon.com" <chenhao288@hisilicon.com>,
        "andrew@lunn.ch" <andrew@lunn.ch>,
        "prabhakar.mahadev-lad.rj@bp.renesas.com" 
        <prabhakar.mahadev-lad.rj@bp.renesas.com>,
        "yuehaibing@huawei.com" <yuehaibing@huawei.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] net: ethernet: xilinx: cleanup comments
Thread-Topic: [PATCH] net: ethernet: xilinx: cleanup comments
Thread-Index: AQHYIp7xXhjSSzjrMkGFnJCoRpO+AqyVC4Uw
Date:   Tue, 15 Feb 2022 20:12:57 +0000
Message-ID: <SA1PR02MB8560EDD6D9B6B2C26EB1B2A5C7349@SA1PR02MB8560.namprd02.prod.outlook.com>
References: <20220215190447.3030710-1-trix@redhat.com>
In-Reply-To: <20220215190447.3030710-1-trix@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-Auto-Response-Suppress: DR, RN, NRN, OOF, AutoReply
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=xilinx.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: e58c790f-ee81-4fd3-cb9c-08d9f0bf8ed9
x-ms-traffictypediagnostic: BYAPR02MB4200:EE_
x-microsoft-antispam-prvs: <BYAPR02MB4200BFBAD297AEFB4B54221EC7349@BYAPR02MB4200.namprd02.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:5516;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Ys6XTj5TTADut7PpNqJp9lp7dw87I0hCuqi0fmQ0c2d2lMblevg1nblu0I0Jq41tDQADDd+Xbppc2EIYJwheOL4AJ+lQOyE4hmzDuRkEQtZfd20ehyxc5o1m67WpEkIfyA/gHFdKTLbWdH3B5wC1/8G+X+OIy1JNVuVHdwUAfq8r9tDU+T5VFJDdqYVH4jiilwtCLpu/YpS1OrfhLHqsI8rHfQC9N6+Pt0xlcc1PGhZkIsofeN2otuef0ZaANMXJABBk72GCfiLEGJDVrGT+/ghGq24t8K935CFdlBK6oZ/szL4bhtWBpduIk9pvHPJSJZK6RmwNG+5T+nXZmi9VARMEE/RK70gSAASbxwbYqBFrvxfvdM51z/luurYQ7rG5CDbHTHfvfwj92KySx4EaaYTqHNLRFm6g4ADVczo0yD9uIM9LPW3ldkZnZ24O49STUS5DP3ky/uz7aoiVB6auSrTRqh0OH4rWUcS6PPnHZComDegVm/InhXn5JwAzsN7o+kOoZj7LasUAcQfycUszxmoU5PoOJGlmW1kWkdpWtAfz5tak+7gUzp4JLrHXkICT/1QZ+si7x4kA6BelIRGxdSoiJNFUGLQuGXgVsjJzHIzsJF/xnL1zUa0HUwz7p8fiAMyz6O4FmyHH4dPYCkM73kafFNsKOuyn2rXUYGwXuwL9HJGyPW+QElWGx2pqQo+0uiZ2ePv53yid4M8FBrLcPt54BtDDN0PXBQJdBPURbc0=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR02MB8560.namprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(38100700002)(55016003)(921005)(122000001)(71200400001)(38070700005)(52536014)(7696005)(8936002)(53546011)(54906003)(508600001)(2906002)(9686003)(33656002)(66476007)(66446008)(64756008)(8676002)(316002)(66946007)(4326008)(186003)(6506007)(7416002)(83380400001)(26005)(86362001)(76116006)(5660300002)(110136005)(66556008);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?6nthAKMNLrhZwASWsjqwpvIkiYfHTCOtvbU5inB+jHl69hrOrX21d+vzIclS?=
 =?us-ascii?Q?4IJcGYqge8di3JBMDLOv4qEdmCLnpjbFUf8MEJZY81wF/D35voXXIZkXMQOA?=
 =?us-ascii?Q?rRVUvDK3UktgoJmcIxNRIKp8iH8sbKmJNcppoSmowanlnqb35Bw2Bwbaxjdh?=
 =?us-ascii?Q?57vq2yfMcLdtzb2lOuvw4yg7Dd1O6W++syf9hHb2kX+kjLbVFZYF0T5VzvaA?=
 =?us-ascii?Q?EX3GzQTNKndrGtHo1KZor2Xa60w5otN5+Utn+8C2VwHqqTHCRsD5r5RjU0RQ?=
 =?us-ascii?Q?I60oO4EABwMB6+65cANyG/jWeY0MN2i53wwEuKVJXn4NNEewhJOeAWWV/l8+?=
 =?us-ascii?Q?R4MmNyMAug4nKXLhrZLM/Rr1Gk16/WOCuPJik2rNtqoDZDnQYh7LBugHCwDZ?=
 =?us-ascii?Q?6Apta2Tn9unGyMICB6LXY79hYgiDAnuVBhhR7/amNXxHOTfeG+tdApVjqQQ8?=
 =?us-ascii?Q?/KWthTMes+tRQSjQDInGSXI09i6BfQtdbLDY+reamcgvU+ma1ZkrSlRg1KQ5?=
 =?us-ascii?Q?/Aw+oxhO54heDbljnmZN/KLhYbniFjZ2j3SktulRzpwhAaXoTptiOYjfeIFn?=
 =?us-ascii?Q?ZwF6RYQd2WrGvCwmJfaiQ9S5Qem3VKNiP5Ti9tUjV/Cvdop5VfiOREViE8z3?=
 =?us-ascii?Q?mgZkJgJqvFnpE6fZMeSvzZa86OBJd0fMZOgGipFbFZDLRK9rV5w29ca6i0PD?=
 =?us-ascii?Q?5NwR+RGpjmOuo3YvND/E0mlbIuT3FWNTVO+gwEio6VGn1QMbxQs1HESkZlEm?=
 =?us-ascii?Q?jtc0B095RM1H0TnAzHDNyeSWH6eQN/h0PENH2HoA+eo5XQ4UBRWhYGqt+llm?=
 =?us-ascii?Q?0pEBGgDxEK31b4hp5wwW28j33gimCV0ltWA2SlrojNZqTLjKnxF3mWGQd8HJ?=
 =?us-ascii?Q?ELOAWhhaVn0QhXaN78/uVK68aBz5zepisBzb4lQ+uTeWoyOBA0Ah2XhPElBM?=
 =?us-ascii?Q?oz1MwnOGzuiHFE0OLyz2qeqdOA20BKhA7vBUATaxhsWjgnKEaln5cTudu5UF?=
 =?us-ascii?Q?Yx2fl0P7qXc+UFrY8qrJ9AF0bsL70vBJ1Avi1elEaLgIof6rAEjkcrQCs4jW?=
 =?us-ascii?Q?k4EofCG8zEJbx0MSfM8U5KueXwkbL7TgMkD6vXZ+5fh6Hufh/UFlc3fcnWLk?=
 =?us-ascii?Q?WA9gnDdbAZCQid9af4F/2fDf51A8Y9PKmSYXX8MUkCeHWZoT+pcoLw0nsEMd?=
 =?us-ascii?Q?92AyoerfSvlGI+C6enCYQ21AAIJYUKFEC9KViMJRCnkBpG1CnTrVRC9NkV0l?=
 =?us-ascii?Q?mmBhAD0cp3G386EkJefLgaqWSWV92rAfS2cNcYy55M9ge1itrk/iVFh/e+2x?=
 =?us-ascii?Q?YPhSMp3HtkfqHrQWpbjlWDKmkrpZTNZ0hv3b2QPgTRDnvwc/l0pm2MnlA9jM?=
 =?us-ascii?Q?d5HjUMon7JVMjr0evr+NpnEugCXA128cwA8sJMyunymoZHr21rTrO9hWumGk?=
 =?us-ascii?Q?zhxVeR45U6gMuQpf4UxpV6fdpoziEntrf5wObKnG7OVEVoGPYOGf41qRWhSu?=
 =?us-ascii?Q?x8fvau5xG5j8JCBGWseTQDG+lW+XGu5U/YqlHxA/w8CjQVRH+SCL/aWgyi0g?=
 =?us-ascii?Q?8QHAcETjQ+VVEuR8zUoVDeJqkWsWujzO2Gsw4IebJ+M4pchzObE6FPZAALYw?=
 =?us-ascii?Q?zo9pe+4qaFw5pssf7ebA1D4=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: xilinx.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA1PR02MB8560.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e58c790f-ee81-4fd3-cb9c-08d9f0bf8ed9
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Feb 2022 20:12:57.5068
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 657af505-d5df-48d0-8300-c31994686c5c
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: OcSAv+UWdODxcotaXn5HBaiZbpHLokFw7+oqcBrVAUn1yuL6pWBazzUSeLun79jpYY7IfFrBVJV8eSvueTu4jg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR02MB4200
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> -----Original Message-----
> From: trix@redhat.com <trix@redhat.com>
> Sent: Wednesday, February 16, 2022 12:35 AM
> To: davem@davemloft.net; kuba@kernel.org; Michal Simek
> <michals@xilinx.com>; Radhey Shyam Pandey <radheys@xilinx.com>;
> gary@garyguo.net; rdunlap@infradead.org; esben@geanix.com;
> huangguangbin2@huawei.com; michael@walle.cc; moyufeng@huawei.com;
> arnd@arndb.de; chenhao288@hisilicon.com; andrew@lunn.ch;
> prabhakar.mahadev-lad.rj@bp.renesas.com; yuehaibing@huawei.com
> Cc: netdev@vger.kernel.org; linux-arm-kernel@lists.infradead.org; linux-
> kernel@vger.kernel.org; Tom Rix <trix@redhat.com>
> Subject: [PATCH] net: ethernet: xilinx: cleanup comments
>=20
> From: Tom Rix <trix@redhat.com>
>=20
> Remove the second 'the'.
> Replacements:
> endiannes to endianness
> areconnected to are connected
> Mamagement to Management
> undoccumented to undocumented
> Xilink to Xilinx
> strucutre to structure
>=20
> Signed-off-by: Tom Rix <trix@redhat.com>

Reviewed-by: Radhey Shyam Pandey <radhey.shyam.pandey@xilinx.com>
Thanks!

> ---
>  drivers/net/ethernet/xilinx/Kconfig               | 2 +-
>  drivers/net/ethernet/xilinx/ll_temac.h            | 4 ++--
>  drivers/net/ethernet/xilinx/ll_temac_main.c       | 2 +-
>  drivers/net/ethernet/xilinx/xilinx_axienet_main.c | 2 +-
>  drivers/net/ethernet/xilinx/xilinx_emaclite.c     | 2 +-
>  5 files changed, 6 insertions(+), 6 deletions(-)
>=20
> diff --git a/drivers/net/ethernet/xilinx/Kconfig
> b/drivers/net/ethernet/xilinx/Kconfig
> index 911b5ef9e680..0014729b8865 100644
> --- a/drivers/net/ethernet/xilinx/Kconfig
> +++ b/drivers/net/ethernet/xilinx/Kconfig
> @@ -1,6 +1,6 @@
>  # SPDX-License-Identifier: GPL-2.0-only  # -# Xilink device configuratio=
n
> +# Xilinx device configuration
>  #
>=20
>  config NET_VENDOR_XILINX
> diff --git a/drivers/net/ethernet/xilinx/ll_temac.h
> b/drivers/net/ethernet/xilinx/ll_temac.h
> index 4a73127e10a6..ad8d29f84be6 100644
> --- a/drivers/net/ethernet/xilinx/ll_temac.h
> +++ b/drivers/net/ethernet/xilinx/ll_temac.h
> @@ -271,7 +271,7 @@ This option defaults to enabled (set) */
>=20
>  #define XTE_TIE_OFFSET			0x000003A4 /* Interrupt
> enable */
>=20
> -/**  MII Mamagement Control register (MGTCR) */
> +/**  MII Management Control register (MGTCR) */
>  #define XTE_MGTDR_OFFSET		0x000003B0 /* MII data */
>  #define XTE_MIIMAI_OFFSET		0x000003B4 /* MII control */
>=20
> @@ -283,7 +283,7 @@ This option defaults to enabled (set) */
>=20
>  #define STS_CTRL_APP0_ERR         (1 << 31)
>  #define STS_CTRL_APP0_IRQONEND    (1 << 30)
> -/* undoccumented */
> +/* undocumented */
>  #define STS_CTRL_APP0_STOPONEND   (1 << 29)
>  #define STS_CTRL_APP0_CMPLT       (1 << 28)
>  #define STS_CTRL_APP0_SOP         (1 << 27)
> diff --git a/drivers/net/ethernet/xilinx/ll_temac_main.c
> b/drivers/net/ethernet/xilinx/ll_temac_main.c
> index b900ab5aef2a..7171b5cdec26 100644
> --- a/drivers/net/ethernet/xilinx/ll_temac_main.c
> +++ b/drivers/net/ethernet/xilinx/ll_temac_main.c
> @@ -1008,7 +1008,7 @@ static void ll_temac_recv(struct net_device *ndev)
>  		    (skb->len > 64)) {
>=20
>  			/* Convert from device endianness (be32) to cpu
> -			 * endiannes, and if necessary swap the bytes
> +			 * endianness, and if necessary swap the bytes
>  			 * (back) for proper IP checksum byte order
>  			 * (be16).
>  			 */
> diff --git a/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
> b/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
> index de0a6372ae0e..6eeaab77fbe0 100644
> --- a/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
> +++ b/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
> @@ -537,7 +537,7 @@ static int __axienet_device_reset(struct axienet_loca=
l
> *lp)
>   * This function is called to reset and initialize the Axi Ethernet core=
. This
>   * is typically called during initialization. It does a reset of the Axi=
 DMA
>   * Rx/Tx channels and initializes the Axi DMA BDs. Since Axi DMA reset l=
ines
> - * areconnected to Axi Ethernet reset lines, this in turn resets the Axi
> + * are connected to Axi Ethernet reset lines, this in turn resets the
> + Axi
>   * Ethernet core. No separate hardware reset is done for the Axi Etherne=
t
>   * core.
>   * Returns 0 on success or a negative error number otherwise.
> diff --git a/drivers/net/ethernet/xilinx/xilinx_emaclite.c
> b/drivers/net/ethernet/xilinx/xilinx_emaclite.c
> index 519599480b15..f65a638b7239 100644
> --- a/drivers/net/ethernet/xilinx/xilinx_emaclite.c
> +++ b/drivers/net/ethernet/xilinx/xilinx_emaclite.c
> @@ -498,7 +498,7 @@ static void xemaclite_update_address(struct net_local
> *drvdata,
>   * @dev:	Pointer to the network device instance
>   * @address:	Void pointer to the sockaddr structure
>   *
> - * This function copies the HW address from the sockaddr strucutre to th=
e
> + * This function copies the HW address from the sockaddr structure to
> + the
>   * net_device structure and updates the address in HW.
>   *
>   * Return:	Error if the net device is busy or 0 if the addr is set
> --
> 2.26.3

