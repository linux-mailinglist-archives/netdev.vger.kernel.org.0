Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 91C0A5AD398
	for <lists+netdev@lfdr.de>; Mon,  5 Sep 2022 15:16:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237087AbiIENOj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Sep 2022 09:14:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58866 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237051AbiIENOg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Sep 2022 09:14:36 -0400
Received: from EUR02-HE1-obe.outbound.protection.outlook.com (mail-eopbgr10115.outbound.protection.outlook.com [40.107.1.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 782E7DE97;
        Mon,  5 Sep 2022 06:14:35 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UI0Fajl2AWPwsvu8WMCbXXdpnPhuZ+G2VuFN8rowyoN2639x+bg2YXAd5ryup3zvpNZ58v+kmqbMv3cGlCVm/u72wBsFmfczBhMDmv/n2jsMpUL6xp3CVUDSgfg+cR3HpGr1xdTLDYgTETv4pfePQyhdI8xnctHrvh/BhjqZhLv53qv2JATVFai96nhjdLKt8++X/Lz9Qcg+kdxJrzU2TjMeGBadTrz+AbJLey0m+rCXxq4DNutp0wxCw2elkC9toCSDQpOCuQZQUJcvciPs3wVQxBQv7u14yBW2f96fSb3k8urNtJiyke8yFFdDV2nLOtg+Lox77sCw4lHwEuzbmQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kWbFfX05MbZo0jiKLS6k1Gq7a9gJ2smj0Gf2Veso7gA=;
 b=NZDBTdJVawK01EhKCw40R4NbSmRcDi2HDluNCjerCbjWeSX/7fkJhbVmseI6UMCUkwZRnnGYudYyvDFbvivEXh/oYl6uAUr7RlSgbm5xOaQsH4yfxD9i3Pi5iwT0pecZABhkYdc0UfQe3KZNFdiWPETJ9lZQzoKxBLGICFVlG5BZbfI69HIIngf8DASpvH7wTqNR3UV0HBX9uQTR2ErjJqzM/WIoD/aG6CAHKKqvFxuu4jZbp9xCsAboELgm/eguv+7H0nOg/NjudHvC/GU2QnViaOYVa01PW3YbpOWZRWa0766DfHdqEfYIE2FLyjwX77Z+hes90w4U3x2QOd8r/g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=plvision.eu; dmarc=pass action=none header.from=plvision.eu;
 dkim=pass header.d=plvision.eu; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=plvision.eu;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kWbFfX05MbZo0jiKLS6k1Gq7a9gJ2smj0Gf2Veso7gA=;
 b=PrAWnC0tphU/kh/De2A70cyX8AkkJoF9eUw0U62QSqka3eCQxTQLd+bHQEw9SBnck+lTN/uE1y9XKCCnjjOGOuPbOjbaLrIsmINQ7Nm+F+E5Ce9RcFvVsdAi2BnJPmntm021eTqPSH8kdT9gAipIdrRSXFOE5EUu+k6BGocwY0c=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=plvision.eu;
Received: from GV1P190MB2019.EURP190.PROD.OUTLOOK.COM (2603:10a6:150:5b::20)
 by DB8P190MB0779.EURP190.PROD.OUTLOOK.COM (2603:10a6:10:123::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5588.10; Mon, 5 Sep
 2022 13:14:32 +0000
Received: from GV1P190MB2019.EURP190.PROD.OUTLOOK.COM
 ([fe80::edb9:99a7:7852:6336]) by GV1P190MB2019.EURP190.PROD.OUTLOOK.COM
 ([fe80::edb9:99a7:7852:6336%6]) with mapi id 15.20.5588.014; Mon, 5 Sep 2022
 13:14:31 +0000
From:   Oleksandr Mazur <oleksandr.mazur@plvision.eu>
To:     netdev@vger.kernel.org, Taras Chornyi <tchornyi@marvell.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     linux-kernel@vger.kernel.org, oleksandr.mazur@plvision.eu,
        taras.chornyi@plvision.eu
Subject: [PATCH net-next] net marvell: prestera: add support for for Aldrin2
Date:   Mon,  5 Sep 2022 16:14:14 +0300
Message-Id: <20220905131414.8318-1-oleksandr.mazur@plvision.eu>
X-Mailer: git-send-email 2.17.1
Content-Type: text/plain
X-ClientProxiedBy: FR0P281CA0057.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:49::14) To GV1P190MB2019.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:150:5b::20)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4c0c1b2d-9d80-48ca-5719-08da8f4091f2
X-MS-TrafficTypeDiagnostic: DB8P190MB0779:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: eibYdRNsbDDgV6h54BJ7rf4yBxq5lxOxUUZ4AxvURqD9o2GD2xqcYiPd4UnCc8AMjikX+EYY7lnW5kx1gF1mlN7Ov4xvWogqA7s2tNDknsekxCh0Pors+yx6hgYbiIAPqBuSQ2PE44s2xwl3TTPdKtB+C8krlGCz/SaMDyTrdvjP4DfeIpAVAXe/ylxgbZeip6uL7Iz+eA9b+GMfMKsKarJxRbWmzrOl1RXiCkfRtQ8qTE+SlKJd8CEGBr7a5+hYWcNtq4maPPrjT8mJ2tj2MRf1EbkSzrdQ4HvADUTHXhvXU34GRKdld0Cjt4Y2GBd+Uw+d2fwhkQO8KpeFqnW6NZkHjg0cwRk2FO4Oc07ShQuYy0ruRTwXXu0BvvJhwZQQSRwbasQOLTI6OpLfKq+MX15WPow79ffJsd5IcfFchcZdsCnM3KEzt0jHSJ+ldH8628kQbGdyYbEMc7hw1iw/Eq0zNl3yKpnMdF/3hb1FLKRk8omU2pPu0Jczq60xuR4btsILbhKuR30ASS3a+F3wYRgqMEtJZJuemgSY/DoVbw9jvuNyv2SJL9x8Y7DMZzCfn3PcCfakd9H7lByAqeM0bT690doz2vF0tDD4Vn4CdLpSfIX2sDaKL49kzt5UI78y4WSbExWqxUkQ1dXTnbolCgkZ30ZRy9O2HWthvdtA3/BGNhJh2QyPnS7lYPM7YmI1kHuvGzq5jtnBbTQXLqjtSMMeFlL7k4j2nIA+6mdnoLHBAd27qwsZxke3d7vufx+9unjFbiXiaTVRgXY19HNNHg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:GV1P190MB2019.EURP190.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230016)(4636009)(376002)(39830400003)(136003)(396003)(34036004)(366004)(346002)(8936002)(36756003)(8676002)(4326008)(66556008)(66946007)(86362001)(66476007)(38100700002)(38350700002)(2616005)(26005)(6486002)(508600001)(6506007)(6666004)(107886003)(41300700001)(316002)(44832011)(41320700001)(6512007)(110136005)(186003)(1076003)(52116002)(2906002)(5660300002)(4744005);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?0ePJQUiSuX1WIQXt9INTvKts7gEBGA7uEXr28Y38HWBPL9gdCQcJhPwgKYhc?=
 =?us-ascii?Q?Qfo115V+0sEdtFnZijmN98s7sd8xwPnK7glSCqnDrCQuu/NLLY2Q0Gdch58B?=
 =?us-ascii?Q?fP0tRLjAyoqOCRGUaAblMmhedY79sMrGUYXicONX4JfTk7tA6LOvbBrVuGFv?=
 =?us-ascii?Q?qkUNqVoCVqE1gebVgNGGMFQ9uvMjWAyQgLy6FVhjsGiVJYg8HKRvdt9Tk9jo?=
 =?us-ascii?Q?bCXzFzCKMv2404xEAfCKCoSj8kcrJ3HBxDByIqvgn5rBCruG2jnoNkXu6rCS?=
 =?us-ascii?Q?xO++PnFA1UB9WzzZy7quEurQREp0M0Ay7sCnK8ccyZVdVg+WxIVd8qiM1bxU?=
 =?us-ascii?Q?krTqnXtde0BdVik0puGixqKg+kU3AnCDxL3gAPyJA7t5n9xRPBEy6HbA2AX/?=
 =?us-ascii?Q?3pu/R6z8tcpL2nLfeyb222Q0Gq3qUmltGW3l/t95QkxjgkL/TNq6uPtAEk7f?=
 =?us-ascii?Q?KdQac2iXHgoQPq/xUvBfwTbz10Pq6N+s7U3rrQpKWWwTBmtoldSCZYPEZ6SH?=
 =?us-ascii?Q?IAJW2gd/OHvHaAXXF6OGetL53bJRoZ1jOtQW5I7lRiNQQZEfsPVaDWK1ofMf?=
 =?us-ascii?Q?GAR68cZPI6z0vPajWTv5ZQnJ0jwPMvdnxPkHfFC7G3hwj6Z+7NCNAzXrXeP4?=
 =?us-ascii?Q?XZfiqHJAxvLDZDTGvUqw6S/S1DHxBfnWMVN3wmI07PkHlQsgAZcVwfwWriMw?=
 =?us-ascii?Q?5Ez7aiAOKsnNpcljT/O53pnPw2Tw6IM3Fuy4Hi0gPd6i3Bk+ptrX0NVUto5Q?=
 =?us-ascii?Q?i/4Zs+YEwNU2Lfw60+ztrBHLqj2uOc2B8deftCj2yoneS/6kIRpzHJc5YD29?=
 =?us-ascii?Q?sYX2xygOIo1QOf8PyEz7RFHg/CchWZyRC/iN1XEzAA29jyEZECOY0K0J2tAu?=
 =?us-ascii?Q?cf//bCsYcQl1VEmoJgZiAu1SPPYIwcWm75wsZZaNHOSptIPTPrReuGkfJIxy?=
 =?us-ascii?Q?tpYBfga4k9Y+B5ji6+hKwHp6Mcd3uJXZ6s3NjlyQfgYJNjbAeZbbPbjB/hcA?=
 =?us-ascii?Q?Oyyj6xOd0XLILgTqJ2PEJQzDbNNbDHueN8wy7pp0R7eVSjJ9EmgWwUoN9z4z?=
 =?us-ascii?Q?pWhbCNC+/jWI879XeE9VKS5aMbj82tiTiwLDkHtFITjYuOCqB21LnYNMpYih?=
 =?us-ascii?Q?wQ8hw/LQ7NdItIMQlEjF4cBPW/RLX1ylSKytMBhfWx24opkREIZpHImclBbQ?=
 =?us-ascii?Q?ZTRdiV1YecWywj2AgwPMTDk9wKdjlngPGlC/FKNqM7DJF/xet5JC9yQRHP1s?=
 =?us-ascii?Q?/f5ZdltkgRcvC0RQ4w3WJNtsakP/jTkTS1nCy62FKjl7TIqei9MDCWPRoj7P?=
 =?us-ascii?Q?cx6SPd4GLwSjWN2K5/NnILZeJW++Id5kXoQJeBvg/Ordg2JeZZaBG5lcEQKn?=
 =?us-ascii?Q?VXR7q/zyde/r9mah3+D3xzRHuiWIFCplel0LaprthX9DXevvm/vZJZOTlayM?=
 =?us-ascii?Q?wJg7nOtgYe/e8+na8gL7gG5GduQxBsH4u91QPckbkqTM6gQrzXK+Pn1v7mqF?=
 =?us-ascii?Q?lpcta0Us6VFJSmwY+05fbkgVy7R0SVWUtKAE5L/wY4DOIb/T6GxAmZV1dP18?=
 =?us-ascii?Q?59F7y2k7Npx4UEL4PzYoHgrC8tYEezK2dzlY8VQoHErx65QMF943LRN3K53A?=
 =?us-ascii?Q?7g=3D=3D?=
X-OriginatorOrg: plvision.eu
X-MS-Exchange-CrossTenant-Network-Message-Id: 4c0c1b2d-9d80-48ca-5719-08da8f4091f2
X-MS-Exchange-CrossTenant-AuthSource: GV1P190MB2019.EURP190.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Sep 2022 13:14:31.7947
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 03707b74-30f3-46b6-a0e0-ff0a7438c9c4
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 5v851i21LAAy8k9ON2x1DIevXT9/3Sl3J5BQlV9O84R6SY/DZ2ffdDgxAiVNPPuQZ37YTxbIi5OI1vXsbrDSr3kZVSaZteNuiuDcOTyw0hY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB8P190MB0779
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Aldrin2 (98DX8525) is a Marvell Prestera PP, with 100G support.

Signed-off-by: Oleksandr Mazur <oleksandr.mazur@plvision.eu>
---
 drivers/net/ethernet/marvell/prestera/prestera_pci.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/marvell/prestera/prestera_pci.c b/drivers/net/ethernet/marvell/prestera/prestera_pci.c
index f538a749ebd4..59470d99f522 100644
--- a/drivers/net/ethernet/marvell/prestera/prestera_pci.c
+++ b/drivers/net/ethernet/marvell/prestera/prestera_pci.c
@@ -872,6 +872,7 @@ static void prestera_pci_remove(struct pci_dev *pdev)
 static const struct pci_device_id prestera_pci_devices[] = {
 	{ PCI_DEVICE(PCI_VENDOR_ID_MARVELL, 0xC804) },
 	{ PCI_DEVICE(PCI_VENDOR_ID_MARVELL, 0xC80C) },
+	{ PCI_DEVICE(PCI_VENDOR_ID_MARVELL, 0xCC1E) },
 	{ }
 };
 MODULE_DEVICE_TABLE(pci, prestera_pci_devices);
-- 
2.17.1

