Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 978444D5FFA
	for <lists+netdev@lfdr.de>; Fri, 11 Mar 2022 11:44:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236341AbiCKKou (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Mar 2022 05:44:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34556 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235845AbiCKKoq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Mar 2022 05:44:46 -0500
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2138.outbound.protection.outlook.com [40.107.244.138])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A128E1BBF5F
        for <netdev@vger.kernel.org>; Fri, 11 Mar 2022 02:43:36 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fsXCqnoNeudZN3UsAlHlGJ+0eYXucp3xk1qPD2QPZ/3y+PIdKNfnYOReNa0FUSlJ2nHwpMn85VLB0+QxMqgr131lmCtuRXOjLPtuBGte7RthOssTPYXnn2h9ytVNTqxSqhgTcWmUq6nYMIBchJUAMznVXrgUREsyrgUcxiz1MSVpUid0AwDw0I1Xhtk9NOPQ8aVLPTmu/W+A3Cx/ioKpk5An2lgxsgJNI6AxBSpp1PMe/ts3Nj9OZdLyVOu0efristopu/3M1XaZ+RcooOKhLvpsW9+2cYm7wwFuDYzExH6isPukDn9/5KKAJMWo09iCw8gR/OABia2MQ86MXhsQdA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=QU+esHQ3+6E/hvVYxBXC1Q4lQVmlreq1ogGAgxVLIx4=;
 b=FnmsjeNSmStHjQWq1DxXypZU4HnrsIHAVsknhEwE+tsveVhJH/Bv+PE+UJ8F55FIgkDyopmRfB1HRuhppwElR77hks9cp7yapjUFdElkZKNGpASKhcfNyQqzXXEql5vch//kuy3tXe95HGBYYaxgZtevQtBmxAOwiFNinVSupB4SX/cxWKBZ8JJY3A1fLJOHl0l1wFH6P+iQ3mr++ySamyx4LnPzjs73/Plz+ro8CKiUGftDh9nDBxaHxtLTreZAXAzEQ4XFueWGETnWjCUhOXIvO2tfLKX4IdxpZACQKgx6nab4z/oaI4BaIJpayouUopNMPeqAyLB0QoKftS0BmQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QU+esHQ3+6E/hvVYxBXC1Q4lQVmlreq1ogGAgxVLIx4=;
 b=lWGaAC75NS+DMLzUPH/9yJvy19YHy3ZYt/ANqpvuWeXHs6RaRqFPz4QZO22t0LWDromg873ccO92u9tRov+tS5u3AOmMiXzrkx5oxQ1aeWPOOwYxEOC9Bf+j0HQ3ITN84rrCwTJrwwBxxyYEBVF0jXpwCH9c2EorOjEECv334mA=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by CH0PR13MB4748.namprd13.prod.outlook.com (2603:10b6:610:c3::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5081.9; Fri, 11 Mar
 2022 10:43:35 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::d27:c7d9:8880:a73e]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::d27:c7d9:8880:a73e%2]) with mapi id 15.20.5061.018; Fri, 11 Mar 2022
 10:43:35 +0000
From:   Simon Horman <simon.horman@corigine.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, oss-drivers@corigine.com
Subject: [PATCH net-next 10/11] nfp: take chip version into account for ring sizes
Date:   Fri, 11 Mar 2022 11:43:05 +0100
Message-Id: <20220311104306.28357-11-simon.horman@corigine.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220311104306.28357-1-simon.horman@corigine.com>
References: <20220311104306.28357-1-simon.horman@corigine.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM0P190CA0026.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:208:190::36) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c7a2021d-8726-40cb-1126-08da034bfe2d
X-MS-TrafficTypeDiagnostic: CH0PR13MB4748:EE_
X-Microsoft-Antispam-PRVS: <CH0PR13MB47486FA2196E10381FE2FFC9E80C9@CH0PR13MB4748.namprd13.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: n+FHFxgM0HYZOYwxtxW4IdSaM0t1QW5RqUbE0NODg0n+7eSjhggWSD1nBUH169W71PZw9pwcaCejVELxkGrevUW+1ET1HGEso/52AiU4hCs4L56W+OyycRu3nQ1e7WnKVLvd0KIF0WJGC+Oc9WLFGHUnGjNaSk3YKoNEUkKx1JCzn+AzxTS8SKb4UDnAPmNJyh8CHlEPXOxhHgW/LR7Mn4BLEnQK3TkIarg7QYbRjSzsz2pRR/fh3imqjpDGbHppdwKt5JYSkf+5Kyg7enate/KdGA9t8AgnugDRCYlCwnaHFXsP2n/gzVKAHY5RYJMU9QWIBygoSO6KR+TpiroSSNmZz5jF/KylHisJCMUQ+PopSbCF9rbhlXXlGQbWT74FwCT0PuUCIyp/ko006M2ORvR2VjrojrrZaG/7/N9lX61rLXeKeyPdFELJ510LfUeR7jIu/N+qHqwH9KQJasJeX+3uIyKHQ8qntlxEuZjdWVnT64En3l90nQ8l26+ZqoFofga8zAmwGK3DAGxtbIm8YXe2s4hF1BkOmIJI9WNeF77TRZcBQuxGYEuP50E+uihL3av47YLjf/Fk39xNQljFVSpfbAjmKtIMQW++zc4PGs95377upfL1ILZCvEB0x0DwuFyuOPcxr656ia7ZcbEfzQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(346002)(376002)(366004)(396003)(136003)(39840400004)(66946007)(66556008)(66476007)(4326008)(316002)(36756003)(8676002)(52116002)(86362001)(6666004)(6512007)(6506007)(5660300002)(508600001)(6486002)(110136005)(8936002)(44832011)(38100700002)(186003)(1076003)(2616005)(15650500001)(2906002)(107886003)(83380400001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?cM4OijPgHjARIrJZ1r6O6OrTdnUgiV1IbweaEDZIJExPS27ihhgnU4QTlPF3?=
 =?us-ascii?Q?yAzIQ3VKLWG1iFKJk60vRbTWk7zRFYywS0edcMCnHYzP0lJpnl+kcV+cAZeb?=
 =?us-ascii?Q?IKxGjkC9/rI63bEMVFJ7SCwXQWbHEDk+12VWY0PR9VZxjznpVvIIlJ7KhP4l?=
 =?us-ascii?Q?lKI5/40aGDr9FDHcBcWPMfXhNfqY5G3eR+zxhRjQpUbP/VI9GyzQT2f77AgJ?=
 =?us-ascii?Q?VxtTF4c4z8h+2jvP+fuhlLZuUDoozc0QnJBQ768Th2LC0URemunvXnE1DmHG?=
 =?us-ascii?Q?j4C3aaPl2abaRTKyNUH3cUrPEOzktMCH9G4NRz/sBJm1BKXJp9DWPJ3Sv98x?=
 =?us-ascii?Q?lzj61gZJa6Brw3cX6cvOBTEASfpV77rp0+L7JYIQO9oIRiQAs94G3LCTNNcz?=
 =?us-ascii?Q?XgwXrCfH4WZc5LSZ0XGL++ctJ6qN1KOvN6U3RDkjDhF70KJngXKPV/xz7pYg?=
 =?us-ascii?Q?q0CI41wfDua9TeVHXPXVbkOVaHMLzlollMiqa4Tvy+58QJ1ofa98IC78OqIG?=
 =?us-ascii?Q?eYdEcst6eHGewl5niZLqsYV2mZ6OxSEwrcoOjGgQTr+u0OvYYjAGvReuWNSs?=
 =?us-ascii?Q?wHmQ1JeVqpoei8dCzkEMzj3RMBJIvaAunf/QiJajDx5VEvN4sthumZOSJide?=
 =?us-ascii?Q?pZD/r3BvZgB/EaTwbQhjXUrhURFgx3jkOzVpfHVqvPXK1ZKsqSEWq409D7pk?=
 =?us-ascii?Q?Ls0HJAUxdipQPN3obgEqeRJz2d1p40gqfZ2BD3jRmOmiaZ/LlW+MtHu3qCs+?=
 =?us-ascii?Q?n21Ixlmyl9gZUgWfbmjNGqDLpUzFoLmhVPugwRMgAkA4t/l3Q+j+Ax+H9bt+?=
 =?us-ascii?Q?r6YvkmY3gNrMbmpaGUlgYl0YFjt1YbTM40bEpGTFDx2/ifCwzEIqiED++v1G?=
 =?us-ascii?Q?szaHuIfDKy0xmBOAshdG6fduSWBH1aACpHQ2lyfHnTmb4dMYHJDHuUWzHtHu?=
 =?us-ascii?Q?xCVbjj7EAzvbEPVKCvpFF6bYQVtpdnEp00mvNurXWNhCw0Hui6KczHGv9G5f?=
 =?us-ascii?Q?DKe5ji9ECnzOBF/gZ9C/CJ2oGFeWTvN6A02TD2MNBkKu6tE6iFfXXJMYtG6G?=
 =?us-ascii?Q?TZN35BZ/CtsfD59okFCpeL5xhxU24/WQS+iLztbVMe7XMurytfyP1YHesveC?=
 =?us-ascii?Q?q0dUsCZru1ZZRj43Vdg4GtpE1evFVH6+cO3IlkpSH5bbDdCZGWA2T2yc2jZ7?=
 =?us-ascii?Q?iVGIRO8rCUui0XnerUqQLyfx1jNz8FAj6ZQtg70g324bnV83Z4pjHLaAqSUO?=
 =?us-ascii?Q?KV7JFYYGxHMFMYo6O7OHfaR8MzawQ66nm/wHeu8EcSq466heyk3Bq3gHezUw?=
 =?us-ascii?Q?ZqLXtRpFtaa7+vTjOk7bjuVCcYgbP0H2wYIIRT/jjDNwZk4gp1vL15RJHT+V?=
 =?us-ascii?Q?spH5iybgsuA+5yrLy2HkUtFkN7C/DV3VJNLWrNCesmhcu4uxloetNciMuYxT?=
 =?us-ascii?Q?0aMc1jkeXJUuTD2r3uRqyFkrq09Y7/I3St+97HlIonPX4Vi1j+a4mBw/N2C1?=
 =?us-ascii?Q?NbWZK9XZCLj5/SPLdL/6cuyIaabAkTeniLvTONOyIA1oBV9m/1JQiIrESw?=
 =?us-ascii?Q?=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c7a2021d-8726-40cb-1126-08da034bfe2d
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Mar 2022 10:43:35.0174
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Nzk8kcr3oat630gmpBKVEWTIXnn54oqfDYa2M0CcQzskpP0rJFVUruHnHTKck/+d2bu+uV3jy5G3wczsHC/ENOUCl8o/8q4WpSJkg+XBQaw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR13MB4748
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jakub Kicinski <jakub.kicinski@netronome.com>

NFP3800 has slightly different queue controller range bounds.
Use the static chip data instead of defines.  This commit
still assumes unchanged descriptor format.  Later datapath
changes will allow adjusting for descriptor accounting.

Signed-off-by: Jakub Kicinski <jakub.kicinski@netronome.com>
Signed-off-by: Fei Qin <fei.qin@corigine.com>
Signed-off-by: Simon Horman <simon.horman@corigine.com>
---
 drivers/net/ethernet/netronome/nfp/nfp_net.h       |  5 -----
 .../net/ethernet/netronome/nfp/nfp_net_ethtool.c   | 14 +++++++++-----
 .../net/ethernet/netronome/nfp/nfpcore/nfp_dev.c   |  5 +++++
 .../net/ethernet/netronome/nfp/nfpcore/nfp_dev.h   |  2 ++
 4 files changed, 16 insertions(+), 10 deletions(-)

diff --git a/drivers/net/ethernet/netronome/nfp/nfp_net.h b/drivers/net/ethernet/netronome/nfp/nfp_net.h
index 5ae15046e585..49b5fcb49aef 100644
--- a/drivers/net/ethernet/netronome/nfp/nfp_net.h
+++ b/drivers/net/ethernet/netronome/nfp/nfp_net.h
@@ -82,11 +82,6 @@
 				 NFP_NET_MAX_TX_RINGS : NFP_NET_MAX_RX_RINGS)
 #define NFP_NET_MAX_IRQS	(NFP_NET_NON_Q_VECTORS + NFP_NET_MAX_R_VECS)
 
-#define NFP_NET_MIN_TX_DESCS	256	/* Min. # of Tx descs per ring */
-#define NFP_NET_MIN_RX_DESCS	256	/* Min. # of Rx descs per ring */
-#define NFP_NET_MAX_TX_DESCS	(256 * 1024) /* Max. # of Tx descs per ring */
-#define NFP_NET_MAX_RX_DESCS	(256 * 1024) /* Max. # of Rx descs per ring */
-
 #define NFP_NET_TX_DESCS_DEFAULT 4096	/* Default # of Tx descs per ring */
 #define NFP_NET_RX_DESCS_DEFAULT 4096	/* Default # of Rx descs per ring */
 
diff --git a/drivers/net/ethernet/netronome/nfp/nfp_net_ethtool.c b/drivers/net/ethernet/netronome/nfp/nfp_net_ethtool.c
index e0c27471bcdb..b9abae176793 100644
--- a/drivers/net/ethernet/netronome/nfp/nfp_net_ethtool.c
+++ b/drivers/net/ethernet/netronome/nfp/nfp_net_ethtool.c
@@ -21,6 +21,7 @@
 #include <linux/sfp.h>
 
 #include "nfpcore/nfp.h"
+#include "nfpcore/nfp_dev.h"
 #include "nfpcore/nfp_nsp.h"
 #include "nfp_app.h"
 #include "nfp_main.h"
@@ -386,9 +387,10 @@ static void nfp_net_get_ringparam(struct net_device *netdev,
 				  struct netlink_ext_ack *extack)
 {
 	struct nfp_net *nn = netdev_priv(netdev);
+	u32 qc_max = nn->dev_info->max_qc_size;
 
-	ring->rx_max_pending = NFP_NET_MAX_RX_DESCS;
-	ring->tx_max_pending = NFP_NET_MAX_TX_DESCS;
+	ring->rx_max_pending = qc_max;
+	ring->tx_max_pending = qc_max;
 	ring->rx_pending = nn->dp.rxd_cnt;
 	ring->tx_pending = nn->dp.txd_cnt;
 }
@@ -413,18 +415,20 @@ static int nfp_net_set_ringparam(struct net_device *netdev,
 				 struct netlink_ext_ack *extack)
 {
 	struct nfp_net *nn = netdev_priv(netdev);
-	u32 rxd_cnt, txd_cnt;
+	u32 qc_min, qc_max, rxd_cnt, txd_cnt;
 
 	/* We don't have separate queues/rings for small/large frames. */
 	if (ring->rx_mini_pending || ring->rx_jumbo_pending)
 		return -EINVAL;
 
+	qc_min = nn->dev_info->min_qc_size;
+	qc_max = nn->dev_info->max_qc_size;
 	/* Round up to supported values */
 	rxd_cnt = roundup_pow_of_two(ring->rx_pending);
 	txd_cnt = roundup_pow_of_two(ring->tx_pending);
 
-	if (rxd_cnt < NFP_NET_MIN_RX_DESCS || rxd_cnt > NFP_NET_MAX_RX_DESCS ||
-	    txd_cnt < NFP_NET_MIN_TX_DESCS || txd_cnt > NFP_NET_MAX_TX_DESCS)
+	if (rxd_cnt < qc_min || rxd_cnt > qc_max ||
+	    txd_cnt < qc_min || txd_cnt > qc_max)
 		return -EINVAL;
 
 	if (nn->dp.rxd_cnt == rxd_cnt && nn->dp.txd_cnt == txd_cnt)
diff --git a/drivers/net/ethernet/netronome/nfp/nfpcore/nfp_dev.c b/drivers/net/ethernet/netronome/nfp/nfpcore/nfp_dev.c
index 368c6a08d887..0c1ef01f90eb 100644
--- a/drivers/net/ethernet/netronome/nfp/nfpcore/nfp_dev.c
+++ b/drivers/net/ethernet/netronome/nfp/nfpcore/nfp_dev.c
@@ -3,6 +3,7 @@
 
 #include <linux/dma-mapping.h>
 #include <linux/kernel.h>
+#include <linux/sizes.h>
 
 #include "nfp_dev.h"
 
@@ -11,6 +12,8 @@ const struct nfp_dev_info nfp_dev_info[NFP_DEV_CNT] = {
 		.dma_mask		= DMA_BIT_MASK(40),
 		.qc_idx_mask		= GENMASK(7, 0),
 		.qc_addr_offset		= 0x80000,
+		.min_qc_size		= 256,
+		.max_qc_size		= SZ_256K,
 
 		.chip_names		= "NFP4000/NFP5000/NFP6000",
 		.pcie_cfg_expbar_offset	= 0x0400,
@@ -21,5 +24,7 @@ const struct nfp_dev_info nfp_dev_info[NFP_DEV_CNT] = {
 		.dma_mask		= DMA_BIT_MASK(40),
 		.qc_idx_mask		= GENMASK(7, 0),
 		.qc_addr_offset		= 0,
+		.min_qc_size		= 256,
+		.max_qc_size		= SZ_256K,
 	},
 };
diff --git a/drivers/net/ethernet/netronome/nfp/nfpcore/nfp_dev.h b/drivers/net/ethernet/netronome/nfp/nfpcore/nfp_dev.h
index 4152be0f8b01..deadd9b97f9f 100644
--- a/drivers/net/ethernet/netronome/nfp/nfpcore/nfp_dev.h
+++ b/drivers/net/ethernet/netronome/nfp/nfpcore/nfp_dev.h
@@ -17,6 +17,8 @@ struct nfp_dev_info {
 	u64 dma_mask;
 	u32 qc_idx_mask;
 	u32 qc_addr_offset;
+	u32 min_qc_size;
+	u32 max_qc_size;
 
 	/* PF-only fields */
 	const char *chip_names;
-- 
2.30.2

