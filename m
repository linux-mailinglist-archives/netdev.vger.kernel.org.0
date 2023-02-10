Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1F10E691BF8
	for <lists+netdev@lfdr.de>; Fri, 10 Feb 2023 10:53:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231389AbjBJJxt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Feb 2023 04:53:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46668 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231219AbjBJJxs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Feb 2023 04:53:48 -0500
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2134.outbound.protection.outlook.com [40.107.237.134])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5AB448A5D
        for <netdev@vger.kernel.org>; Fri, 10 Feb 2023 01:53:47 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jOS1EA17QCtZaZKKtxF29UTwFE/UkYWwwcQP45HZk16pcLzu+NfdGI09E+YK9N07vDkwJcCqYKbmG+7ZHJ8ysb4ChIwJ8a6N35cP2zwUNiNkNBkbxdfgulbXQH0I1kS0C8q5T8SRSwfWvbuk1R0ZjjjjVmlN+JZFExACxLpwgLUVuAaUFUAqVvBrnRBG/yQOl3JxW+jntffV6oW1g5m7/1X9pTVxZY7S0NdJxlPBcOqIQYAXnSBvqO/FWZrnimWzjSKScX6AevtQehj5KdmsHrR6nDCw4pnrh5yL5/5kRreeIuzANydX7jtBJt1S75sP34kgWHc6B26OV/BusXpkWg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wqiN/lvjLrxm7A3B/5l7tOfXoeqrET8P3fGmMU5F3FI=;
 b=SnB33zoyJKu758gJpxr89eftUTN005U0UMGXSk3zQBUiPdSMZIoZ0Nr2dLqmvHuIf5eMQ3KS+xR0t4cOuYdHgH4Vk5VJbo058ipHaZrCJCi9fELdK/uSMDnp0Ua9FJM7WuZ8vttKMyepD8po45p0DBvxOgVd/lLyb647PTRYjPrGZJUfz/UGhIXS26H/1f+IpeP9TMMT5Scl9l56uY6nzZWFhBh/pbaazdDCmu7ihWlZBAd0ICWrGcGkj4NJq+/TFnohAJfhxFHy8Ax8T3AWDFKVhAHHqwsKCytR4z/L7+ACKqQS+iBkTqZv5pRunjvLKmPt4VL2hIiUhqmwymdXew==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wqiN/lvjLrxm7A3B/5l7tOfXoeqrET8P3fGmMU5F3FI=;
 b=hgco649NpRqToRCL7KZ2Mq6mJRX+YxYoFaQ975aAbEvOdbJANs8UdYXrmjcbr9vglBUJ8s7r0PyUTlT9rYV6eISxOCr/YR7sD/4rkKyEtJKz9pByJZuOLLemx53qRXRGeftm5gpi8kQOJ7J1/rH9h6wawvHJeV63ONaHJ9sid7c=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by MW4PR13MB5626.namprd13.prod.outlook.com (2603:10b6:303:182::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6086.19; Fri, 10 Feb
 2023 09:53:42 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::eb5c:910f:3730:fd65]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::eb5c:910f:3730:fd65%9]) with mapi id 15.20.6086.021; Fri, 10 Feb 2023
 09:53:42 +0000
From:   Simon Horman <simon.horman@corigine.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev@vger.kernel.org, oss-drivers@corigine.com,
        Yu Xiao <yu.xiao@corigine.com>,
        Simon Horman <simon.horman@corigine.com>
Subject: [PATCH net-next] nfp: ethtool: supplement nfp link modes supported
Date:   Fri, 10 Feb 2023 10:53:19 +0100
Message-Id: <20230210095319.603867-1-simon.horman@corigine.com>
X-Mailer: git-send-email 2.30.2
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM0PR02CA0088.eurprd02.prod.outlook.com
 (2603:10a6:208:154::29) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|MW4PR13MB5626:EE_
X-MS-Office365-Filtering-Correlation-Id: 3a28e0d0-fdc7-4aa5-d688-08db0b4cb113
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: hNYOqHT/sQSa3UHUep1O8PyYXArAJXBMMeRKRMbWwGrGvnvoCMTptngdtmN1fYhIuDOT5XW/6TOm6rGm59Jf0D33HJnObxzfzTui107p7ku1oJ7f9FHwjGldxHETKv+29jNhsq82LCvex3y7AGQYxAyboBo4YGKjGBMXGsS0qQVXRXyybNXdPK3zitGPhBmWnGluP8KuxjYUWBG/3/fOPjo+ZIpB1sMAPlTmVter8QT6UxTS5B0XGpCMKZ1njhtQiUBnQMJ4qJp5XVAkRx6MqNZVxTu9VSydLNjEasuLTr6CHqKjUNy2FF7G0nQB4ds2vp8Saa6l0GgrySjopIbmqVMCoX7KZnZUTdYOq/osncadHYfNxpB5Tb5K1hNO64zkNwmoEW+27z1+zQZOHV0e4Osur6WH9u0H1r2+aqKLsLZWo7gE79Kk9z3MkRiTqRKDwsSS7nOFLReSQdhvzwyFxhSHGfRpBRrWgWnxzZStaA39aJgSmgBBeIvibiTkqllmpDQoRToH+ohKiTtMuFUoO3+YpvTTlULQ7voMbiqgcq5tJIeaMhEpS+FEVWjq6w1QDfTIAbGHSd36kXQ58WpBTdxv2mELCuMmK5y8uBJqmmNJgCeVwbGgLD8ENccfShL8apAZqQlJqM+1/idEGpn0C6rwpMxtrmpoBceMYRjMDEMrJ8xkqIL84knVFZKj2I4w
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(366004)(136003)(39840400004)(376002)(346002)(396003)(451199018)(6506007)(1076003)(44832011)(83380400001)(8936002)(5660300002)(66476007)(2906002)(41300700001)(66556008)(2616005)(8676002)(316002)(6512007)(4326008)(186003)(107886003)(36756003)(66946007)(478600001)(110136005)(86362001)(54906003)(6486002)(6666004)(38100700002)(52116002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?HJIoM/tRDUYasNjeDqWxF1V7ApSQirc0EW103sdH49YvK0wwcWTCKHRP4DfL?=
 =?us-ascii?Q?fsa2cdAkz3RYlyz91f/zwBzydcHXvmZqmY1J90rWf3bxxiJQLGIqlsX1MQmr?=
 =?us-ascii?Q?KF173SsC63IaXgdi33BTSuQL6UVTUtAzTKBBNViM8dSyGRtwx6+xobTx3bHC?=
 =?us-ascii?Q?Y2fogwKAuVhLelR05MURHEwNzbRXEX1owCea5bZWRBdz/EyFpxfD1+eHXUA+?=
 =?us-ascii?Q?uxut0xegp0i97pQwvk6yLoEQweolPL7ct6Whr3oUyJ64REwfvLq52vuKm1No?=
 =?us-ascii?Q?i4XVrcR8C8zCPTl1sUwV0DsDNaqagiitlvv6/x8MS/uA2bz1MBIxjoLkIBBa?=
 =?us-ascii?Q?n+vJWIFWcY2OACkdZUrb0eFa90dIMKWsBWYFir8otEG/yqTrCSIZgrDgBmFr?=
 =?us-ascii?Q?xdxiL7xFdRnzTiU+//nD8+aZ/HItslmenEMVRKCO6KPGZsSQC2QY59syrDuZ?=
 =?us-ascii?Q?4awjGwev41BUrlhzQ82fNSFBRiwr0/P2+8uUplUbtbIZP4Y4oa8aKOXK5yco?=
 =?us-ascii?Q?+CRSmlvlBMKCD7DlOc8xxKGh8Lq8OFDSXSQ6BhKfa+WADX/ryiK2FfLhb1XC?=
 =?us-ascii?Q?Vpwu7FYUcLstBmqKqrb0B2oSlQQ9NNAdamRwyzXh3TZaDahdSqDITaHoTPvs?=
 =?us-ascii?Q?CKPWx2qkLLqpnd3hamsaiiNPmDsTcwKh+HlnvJFkTmZt4TwkPRUYvu28h95Y?=
 =?us-ascii?Q?gpvLm4M1S4I8fdVEunF1oSRUQXO0g/nJ+7tsTCX1OWzy/SI7t/KkF0l01jkK?=
 =?us-ascii?Q?3bKgi2qgtl7fCViGlZRqCQllNQmfqPAT2iV3GoLVDKuLnPhty1yiIaFhHlvb?=
 =?us-ascii?Q?2iQYB4CXDJhG/2j9GQ4JGYmfWiQUgZ7c4wrd1EGAsO7VBhD8wzHgBgJcAqzQ?=
 =?us-ascii?Q?QI6XwJBPvmHsWgWadOnlKx1CkRpsu15lP/vL1Xc5qr2XKfzVSWqFUHFwJEaR?=
 =?us-ascii?Q?OOzoPHW1HwvWcnGSDJhM5B84binwSCKha95TglVTtAJMTvaBrcmXzOCRJ4Tv?=
 =?us-ascii?Q?Lr0mHjfFjNXIkdkuXqxx3mvi32GuOaDaghAkxjZIbBrX+lwkcXWMOiK+CRDW?=
 =?us-ascii?Q?IhqnjhWi3x9gVMNpVqftCUtX51oZklXJwrjIEi2rC8le2KEiW3OuH72NZLGa?=
 =?us-ascii?Q?XgBjbZGIm5Em+Bo+6YBcnLbER4eVfVHierdmUPDhtOHUzAEpgy+Bhcixuj95?=
 =?us-ascii?Q?wO2Q7yzqSNY7pkNQZ53ShXyxVhhXzVCRkDkee/KVhErPmKHCcSlrnsZvUr5v?=
 =?us-ascii?Q?xpyF/fCJKCFrLQ4IRt1a5CHx+0oUCziTvuxv4eJyP39wUdczJQ57NXPgvGZZ?=
 =?us-ascii?Q?decO21RQopdj/tbS6jljLRsmp1kxPMGoFBVyIJr+mDxksyeq/lLXTf/lThks?=
 =?us-ascii?Q?9YlT6K00G4vyQUOJaqIMZpAQfZBKWQz5+zQxBiOSx0gH3gmUX1vM+pW5nIP6?=
 =?us-ascii?Q?YFXs8JqmxBow7rtXfamtPpR986aE3aJQNf5A+Vw3GIbUs0Bx4d0NrxRXy/5V?=
 =?us-ascii?Q?Caxysn8XXSgz0xbZT/pPey8XQ2AUim8Owv0QUvZNAS/ic5YJj44Vt+A8b5ie?=
 =?us-ascii?Q?WQaHerMG6rReZfEvriK7UiByJelB87OSXsgILLwscpe1Yf38CYdqvpoRazkN?=
 =?us-ascii?Q?SXId3F5setxK/8Eb4GvQRB0JTgM40Fw4uVE4ZcWNz6QrOsz1Benk7BK+b0Sn?=
 =?us-ascii?Q?XEeBqQ=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3a28e0d0-fdc7-4aa5-d688-08db0b4cb113
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Feb 2023 09:53:42.1062
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: EaIfgUvPSz+F+aVtzLNxgpdy/QibbOTyL87djp31s0H1iLu5J1Y//vhOZRIj4QixLXZPWG9o1AL0hBs9YwmrQnc3PsWWpLnsI88p67hfFzA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR13MB5626
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yu Xiao <yu.xiao@corigine.com>

Add support for the following modes to the nfp driver:

	NFP_MEDIA_10GBASE_LR
	NFP_MEDIA_25GBASE_LR
	NFP_MEDIA_25GBASE_ER

These modes are supported by the hardware and,
support for them was recently added to firmware.

Signed-off-by: Yu Xiao <yu.xiao@corigine.com>
Signed-off-by: Simon Horman <simon.horman@corigine.com>
---
 drivers/net/ethernet/netronome/nfp/nfp_net_ethtool.c | 12 ++++++++++++
 drivers/net/ethernet/netronome/nfp/nfpcore/nfp_nsp.h |  3 +++
 2 files changed, 15 insertions(+)

diff --git a/drivers/net/ethernet/netronome/nfp/nfp_net_ethtool.c b/drivers/net/ethernet/netronome/nfp/nfp_net_ethtool.c
index 918319f965b3..dfedb52b7e70 100644
--- a/drivers/net/ethernet/netronome/nfp/nfp_net_ethtool.c
+++ b/drivers/net/ethernet/netronome/nfp/nfp_net_ethtool.c
@@ -313,6 +313,10 @@ static const struct nfp_eth_media_link_mode {
 		.ethtool_link_mode	= ETHTOOL_LINK_MODE_10000baseKR_Full_BIT,
 		.speed			= NFP_SPEED_10G,
 	},
+	[NFP_MEDIA_10GBASE_LR] = {
+		.ethtool_link_mode	= ETHTOOL_LINK_MODE_10000baseLR_Full_BIT,
+		.speed			= NFP_SPEED_10G,
+	},
 	[NFP_MEDIA_10GBASE_CX4] = {
 		.ethtool_link_mode	= ETHTOOL_LINK_MODE_10000baseKX4_Full_BIT,
 		.speed			= NFP_SPEED_10G,
@@ -349,6 +353,14 @@ static const struct nfp_eth_media_link_mode {
 		.ethtool_link_mode	= ETHTOOL_LINK_MODE_25000baseSR_Full_BIT,
 		.speed			= NFP_SPEED_25G,
 	},
+	[NFP_MEDIA_25GBASE_LR] = {
+		.ethtool_link_mode	= ETHTOOL_LINK_MODE_25000baseSR_Full_BIT,
+		.speed			= NFP_SPEED_25G,
+	},
+	[NFP_MEDIA_25GBASE_ER] = {
+		.ethtool_link_mode	= ETHTOOL_LINK_MODE_25000baseSR_Full_BIT,
+		.speed			= NFP_SPEED_25G,
+	},
 	[NFP_MEDIA_40GBASE_CR4] = {
 		.ethtool_link_mode	= ETHTOOL_LINK_MODE_40000baseCR4_Full_BIT,
 		.speed			= NFP_SPEED_40G,
diff --git a/drivers/net/ethernet/netronome/nfp/nfpcore/nfp_nsp.h b/drivers/net/ethernet/netronome/nfp/nfpcore/nfp_nsp.h
index 8f5cab0032d0..781edc451bd4 100644
--- a/drivers/net/ethernet/netronome/nfp/nfpcore/nfp_nsp.h
+++ b/drivers/net/ethernet/netronome/nfp/nfpcore/nfp_nsp.h
@@ -140,6 +140,9 @@ enum nfp_ethtool_link_mode_list {
 	NFP_MEDIA_100GBASE_CR4,
 	NFP_MEDIA_100GBASE_KP4,
 	NFP_MEDIA_100GBASE_CR10,
+	NFP_MEDIA_10GBASE_LR,
+	NFP_MEDIA_25GBASE_LR,
+	NFP_MEDIA_25GBASE_ER,
 	NFP_MEDIA_LINK_MODES_NUMBER
 };
 
-- 
2.30.2

