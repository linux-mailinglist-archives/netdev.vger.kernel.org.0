Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 979844DD7C4
	for <lists+netdev@lfdr.de>; Fri, 18 Mar 2022 11:14:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234917AbiCRKPL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Mar 2022 06:15:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36954 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234904AbiCRKPH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Mar 2022 06:15:07 -0400
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2122.outbound.protection.outlook.com [40.107.244.122])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C723103B89
        for <netdev@vger.kernel.org>; Fri, 18 Mar 2022 03:13:43 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=g3ulKVqkkgA2L2+PbI/c/32RrBW8PoltD2kVqsY7QX2vzQB3V7+iTIQ79WHxJYKH1F5Aaf7iBJBDe3hwkSAGPRN2bVIm1VMqwhlzeRE4w9+ZmxgbBW6PI7ZBrln/vGi5ZRBTEdBZw4P34l29QdOHRkKE6RmD+Byek7xZOuGsNAxr0qQ8b37q6knCxlAlxVqNdkG09O49ZvzLQ+TxOAwHEXxUYoHABZdEelI7gqD63S0y1HdYiDBYtz94UbGuutl8arC4F0ZsLQwtd9C8kDLQEypBfkTPqdNYh87O3ZbqdUKtCVH+hJEPSRxg+ZcJ8pOrvDYAOG9EelJ85CS42lILKg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rCVXXopX/Tc+V/yC47aaVFkT3EJ85MlTUU/eVVjkyG4=;
 b=DGGw4S3TsgM+inJrzDlfvGzrTOPF/HmamkWHRVLfRTjPzftJW6uThngEH1wf+eijhFyEJfEAWe6cFBdNoUj42a7ZUyLW8jeJvmK2zSdNZBDgPfUpxNz9rBFq6pWhTZZJc9B6xwPuSM8Hg3Gvq0dx1S9kjJGkDT4+FHByG0pxyhoZiJ67YJcFtGSmnFH97IpK/ebVWZw6SuhwESq2t8Gqju92nN/k30+14//TgdvQCfe4N5uGObVImuxlUbMB0WKx2EGx8f4GhRXzDFHH+R5O8l3hg2dzpLFJURRL24C+BnyB/j4dwcQwd1cM4R4SEueioiy4D4edVDLYdDiHKxwNhg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rCVXXopX/Tc+V/yC47aaVFkT3EJ85MlTUU/eVVjkyG4=;
 b=bSUGbGGP7Q18cpAJfdZTC5v+j1w28R0G4k/ug9ZiMYemay68hzAPpoLpI6Utjtksq/Jzu3vLeE6Im8YJU7kpT1eFPvzWltNzivyeaqrBwTM1ypVKUfgUc5Nl1dDjKXvnNLGI7ZMz3hC4/q7DeRwcfkPF7vzJhFEIUKVnpOttDvc=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by DM5PR1301MB2090.namprd13.prod.outlook.com (2603:10b6:4:33::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5102.7; Fri, 18 Mar
 2022 10:13:37 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::d27:c7d9:8880:a73e]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::d27:c7d9:8880:a73e%2]) with mapi id 15.20.5081.015; Fri, 18 Mar 2022
 10:13:37 +0000
From:   Simon Horman <simon.horman@corigine.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, oss-drivers@corigine.com
Subject: [PATCH net-next 04/10] nfp: prepare for multi-part descriptors
Date:   Fri, 18 Mar 2022 11:12:56 +0100
Message-Id: <20220318101302.113419-5-simon.horman@corigine.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220318101302.113419-1-simon.horman@corigine.com>
References: <20220318101302.113419-1-simon.horman@corigine.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM0PR02CA0114.eurprd02.prod.outlook.com
 (2603:10a6:20b:28c::11) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b82db2bf-99c2-46b0-d6fb-08da08c7f7b2
X-MS-TrafficTypeDiagnostic: DM5PR1301MB2090:EE_
X-Microsoft-Antispam-PRVS: <DM5PR1301MB2090C49D1865CF06741FA0EBE8139@DM5PR1301MB2090.namprd13.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: nGYh6/GX9W4y8SckoPpWUl8+OizbC9HfSsiUjsaiNyKCZMCa13h0X79KJ28sJTRPwQHaIJkge8JfI2cZuG2xIKueNKvZmgitKra0/xnjszg7QcAR2iH2EFxDBSacRnAfuqQUNU+JRnM180K693892BvjbMdnk3YzW9WIszh33tjy8N+rbmWrXKz9zavj7OO6t7g3rzpf48vA2rb/I+/uilcWfd5FuDHbN5/OLxUFKH342v3RoeXkxn5xBK01dp+78kIFy41Dz7P68ap3mVy0oOB7ALC6KZjXMOA1F0gHN7E3K4qPCiRJP+2DQcAEi5wEkXnXMRb0VMcAn1tcuZ9j0e3rqplZZRmz12YfLYMfzB+5pUslZdgCbN9nI0/DbcMxOvXOj8/j8vvyb6OleIksSY1J4/7C0KE4EevvafU9fqW5Fxf9ew74vhWqwFNWQBFHfYrNcQRUb9WV39Udzyi8p1przJ7xtHlgW61v3mzDBgsfU8QFVPYSFPRXHegIHaMSlPoBKQxuiMVbO69QVJbp/CLLByGOSM05OLHozP08V32R1zt84qa4wqYowxBP/yyhS4tDZbI2IsccwA3Xw6/ti4zz1dQX+ARApUsFbGcKq1afFSP9iGTJIsEV/5bs23juvCAcGG3tlbBDDu5Q8GmiGA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(376002)(396003)(136003)(366004)(39830400003)(346002)(2616005)(107886003)(2906002)(186003)(1076003)(8676002)(86362001)(6512007)(36756003)(6506007)(52116002)(508600001)(83380400001)(5660300002)(66946007)(66556008)(66476007)(44832011)(4326008)(6486002)(38100700002)(316002)(6666004)(110136005)(8936002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?aG6G/O8Pa7Ml/cE2Lh1eYvsasPOwz11loDWOvGdpqro4qVRPzxrMCGdqagpd?=
 =?us-ascii?Q?mq5icESFgfkZ348R7u2gbz4xZK3xAOuyYoMfQOLSlGVxxcMl/x6/NB6USv7k?=
 =?us-ascii?Q?bGotz5F7fxE8aOtMylTr3E3mRZI2CwiagWxfwQlaC6rrEba/nBRl4TkHoOJa?=
 =?us-ascii?Q?5psh4mEL7Pz74JUwOqcsLmwwA9KqYLLjy8NrqkRrLloL1pHhxaFH3BD0PH9S?=
 =?us-ascii?Q?Qo60E4ylnT1UiA48Sk/Slw8FFwhBBVRy1bLQCG9ZKl4at3t+LSAPr+5hH4pK?=
 =?us-ascii?Q?ZdLTMOu2E/jRACJV9V1aRPJICfMgMvyNIv2m6Y3O9Y4dcwwWL6NQLE6lKW5M?=
 =?us-ascii?Q?k1sC0TD3bNsrc9LBUvc8RstSLP2wQ+J9kAShoecWMBFg+qbs8510VfF9ibxC?=
 =?us-ascii?Q?3talOCPKgqE8VDiYVsN4XqaHHskFL4qSlqxzoytk5GspvSG+zTUK6FsOckkI?=
 =?us-ascii?Q?cG0Tlmvp9b47c9XSIT6/YVo+TgSEe2gzyzXAIV3UWh06BtV2aVD9XKH8dHVx?=
 =?us-ascii?Q?7w4HvE8RwdqdiUk0FKYlXvyBhJbo7bGBx90rBh5ne9/O3j1uM20hyQQjS5t+?=
 =?us-ascii?Q?OQEP6DCKbp8z1CFsMrLtJ5xBZxPd+EHyhz3J3Wt+lW+PeoWsa3DRSHFR8oK7?=
 =?us-ascii?Q?BmpGoQIGrldUSwCRXdD9bGMegSuRkdoGdM7+rSEg5bVMk+LxdLzfOI2aeerP?=
 =?us-ascii?Q?aFkGnDn1A5Hsjo4jmHSbeR4XC7DBW8lrK7EvfTmwr9C2kw3rBMv8wWfI1RLL?=
 =?us-ascii?Q?jqj5BAK5TMX+JM0cG6L2WH3xujBEsKeThbKyZCaPUvfsCzGtH3tUjohObAGD?=
 =?us-ascii?Q?56Qvy6Xz2zAvF7ZrpoqQXjB8jj8GuScbhP4EAoStiOWSjBxAYA1R/pptg0i2?=
 =?us-ascii?Q?2PwWNT1VSaUV8vLJ6a6pG6awMzQJ06QgGULRTum2BJLDi6dDwtkhvI0A3vOI?=
 =?us-ascii?Q?0WE4st5SeXzOIKzi06gHy3tiUhA/hD2jN1ADE9fQeStJs+Qjj46ANXnbqHgB?=
 =?us-ascii?Q?pzXZNLJGs20GZt2IU9a3qKitYISALcwGml5vwwVGFIKb1Cq5F23XKGSEdwqe?=
 =?us-ascii?Q?kcUvTPy71WX/thygN0jJT3zkn0n8Wy/y/3KIKmq0RN7IjKycik6cYIadULwg?=
 =?us-ascii?Q?++8rc1UJOEOCr991hw7JfCU912rylP1bbqKujxkZdO93Hrr7VjLS0gg0gu1K?=
 =?us-ascii?Q?u6qGkogoUXpfJjoWXX0LF1oznr7XIoBkRnShSrM0XXKC3w93LVPGpvyV+zeq?=
 =?us-ascii?Q?18fe6xgQCUVKV2LFrSzCX9RlojY6Ig47rr39SHeEIriqaNR7BDlFAVqaZ0Le?=
 =?us-ascii?Q?rg4WLjaYXQ0Ppr4PV1Qr8sCirT7lPOEsjdxIdr7OZLZ2Ittz2n1Pb1k1LDc4?=
 =?us-ascii?Q?vx7M7ROfmWwZoYyhzQBvWNNFYL5JOcUdaysyxP8S1nuNVhMELiCjfOHXbP5u?=
 =?us-ascii?Q?GKA3iVtRtPWpdtvP7PHEK71ZEzyfESDoF9tRRRAtWcywhs5guBgGw0daoDiq?=
 =?us-ascii?Q?V0KbRPidyw+c9CG3d2MrwzvIU88TYnQ5/I9RmRcOlNlNCqD3wQiaTZ2aBg?=
 =?us-ascii?Q?=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b82db2bf-99c2-46b0-d6fb-08da08c7f7b2
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Mar 2022 10:13:37.5126
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: jf+MIs9qolIZoKA8zvT/bgZIO1pjd6Soi5y48Re+OKxlOS/5CGH5Jq5yPm+eBKqkYyl/Rj19D/l4leElIFkJFW27p3nwTsLzRTOtOrco04M=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR1301MB2090
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jakub Kicinski <jakub.kicinski@netronome.com>

New datapaths may use multiple descriptor units to describe
a single packet.  Prepare for that by adding a descriptors
per simple frame constant into ring size calculations.

Signed-off-by: Jakub Kicinski <jakub.kicinski@netronome.com>
Signed-off-by: Fei Qin <fei.qin@corigine.com>
Signed-off-by: Simon Horman <simon.horman@corigine.com>
---
 drivers/net/ethernet/netronome/nfp/nfd3/rings.c      | 1 +
 drivers/net/ethernet/netronome/nfp/nfp_net.h         | 4 ++--
 drivers/net/ethernet/netronome/nfp/nfp_net_dp.h      | 2 ++
 drivers/net/ethernet/netronome/nfp/nfp_net_ethtool.c | 8 +++++---
 4 files changed, 10 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/netronome/nfp/nfd3/rings.c b/drivers/net/ethernet/netronome/nfp/nfd3/rings.c
index 342871d23e15..3ebbedd8ba64 100644
--- a/drivers/net/ethernet/netronome/nfp/nfd3/rings.c
+++ b/drivers/net/ethernet/netronome/nfp/nfd3/rings.c
@@ -244,6 +244,7 @@ nfp_nfd3_print_tx_descs(struct seq_file *file,
 
 const struct nfp_dp_ops nfp_nfd3_ops = {
 	.version		= NFP_NFD_VER_NFD3,
+	.tx_min_desc_per_pkt	= 1,
 	.poll			= nfp_nfd3_poll,
 	.xsk_poll		= nfp_nfd3_xsk_poll,
 	.ctrl_poll		= nfp_nfd3_ctrl_poll,
diff --git a/drivers/net/ethernet/netronome/nfp/nfp_net.h b/drivers/net/ethernet/netronome/nfp/nfp_net.h
index 13a9e6731d0d..d4b82c893c2a 100644
--- a/drivers/net/ethernet/netronome/nfp/nfp_net.h
+++ b/drivers/net/ethernet/netronome/nfp/nfp_net.h
@@ -441,8 +441,8 @@ struct nfp_stat_pair {
  * @ctrl_bar:		Pointer to mapped control BAR
  *
  * @ops:		Callbacks and parameters for this vNIC's NFD version
- * @txd_cnt:		Size of the TX ring in number of descriptors
- * @rxd_cnt:		Size of the RX ring in number of descriptors
+ * @txd_cnt:		Size of the TX ring in number of min size packets
+ * @rxd_cnt:		Size of the RX ring in number of min size packets
  * @num_r_vecs:		Number of used ring vectors
  * @num_tx_rings:	Currently configured number of TX rings
  * @num_stack_tx_rings:	Number of TX rings used by the stack (not XDP)
diff --git a/drivers/net/ethernet/netronome/nfp/nfp_net_dp.h b/drivers/net/ethernet/netronome/nfp/nfp_net_dp.h
index 25af0e3c7af7..81be8d17fa93 100644
--- a/drivers/net/ethernet/netronome/nfp/nfp_net_dp.h
+++ b/drivers/net/ethernet/netronome/nfp/nfp_net_dp.h
@@ -106,6 +106,7 @@ enum nfp_nfd_version {
 /**
  * struct nfp_dp_ops - Hooks to wrap different implementation of different dp
  * @version:			Indicate dp type
+ * @tx_min_desc_per_pkt:	Minimal TX descs needed for each packet
  * @poll:			Napi poll for normal rx/tx
  * @xsk_poll:			Napi poll when xsk is enabled
  * @ctrl_poll:			Tasklet poll for ctrl rx/tx
@@ -121,6 +122,7 @@ enum nfp_nfd_version {
  */
 struct nfp_dp_ops {
 	enum nfp_nfd_version version;
+	unsigned int tx_min_desc_per_pkt;
 
 	int (*poll)(struct napi_struct *napi, int budget);
 	int (*xsk_poll)(struct napi_struct *napi, int budget);
diff --git a/drivers/net/ethernet/netronome/nfp/nfp_net_ethtool.c b/drivers/net/ethernet/netronome/nfp/nfp_net_ethtool.c
index b9abae176793..7d7150600485 100644
--- a/drivers/net/ethernet/netronome/nfp/nfp_net_ethtool.c
+++ b/drivers/net/ethernet/netronome/nfp/nfp_net_ethtool.c
@@ -26,6 +26,7 @@
 #include "nfp_app.h"
 #include "nfp_main.h"
 #include "nfp_net_ctrl.h"
+#include "nfp_net_dp.h"
 #include "nfp_net.h"
 #include "nfp_port.h"
 
@@ -390,7 +391,7 @@ static void nfp_net_get_ringparam(struct net_device *netdev,
 	u32 qc_max = nn->dev_info->max_qc_size;
 
 	ring->rx_max_pending = qc_max;
-	ring->tx_max_pending = qc_max;
+	ring->tx_max_pending = qc_max / nn->dp.ops->tx_min_desc_per_pkt;
 	ring->rx_pending = nn->dp.rxd_cnt;
 	ring->tx_pending = nn->dp.txd_cnt;
 }
@@ -414,8 +415,8 @@ static int nfp_net_set_ringparam(struct net_device *netdev,
 				 struct kernel_ethtool_ringparam *kernel_ring,
 				 struct netlink_ext_ack *extack)
 {
+	u32 tx_dpp, qc_min, qc_max, rxd_cnt, txd_cnt;
 	struct nfp_net *nn = netdev_priv(netdev);
-	u32 qc_min, qc_max, rxd_cnt, txd_cnt;
 
 	/* We don't have separate queues/rings for small/large frames. */
 	if (ring->rx_mini_pending || ring->rx_jumbo_pending)
@@ -423,12 +424,13 @@ static int nfp_net_set_ringparam(struct net_device *netdev,
 
 	qc_min = nn->dev_info->min_qc_size;
 	qc_max = nn->dev_info->max_qc_size;
+	tx_dpp = nn->dp.ops->tx_min_desc_per_pkt;
 	/* Round up to supported values */
 	rxd_cnt = roundup_pow_of_two(ring->rx_pending);
 	txd_cnt = roundup_pow_of_two(ring->tx_pending);
 
 	if (rxd_cnt < qc_min || rxd_cnt > qc_max ||
-	    txd_cnt < qc_min || txd_cnt > qc_max)
+	    txd_cnt < qc_min / tx_dpp || txd_cnt > qc_max / tx_dpp)
 		return -EINVAL;
 
 	if (nn->dp.rxd_cnt == rxd_cnt && nn->dp.txd_cnt == txd_cnt)
-- 
2.30.2

