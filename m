Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 79C454E2487
	for <lists+netdev@lfdr.de>; Mon, 21 Mar 2022 11:42:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346435AbiCUKoD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Mar 2022 06:44:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34438 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346430AbiCUKoA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Mar 2022 06:44:00 -0400
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2132.outbound.protection.outlook.com [40.107.243.132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C7367147AE8
        for <netdev@vger.kernel.org>; Mon, 21 Mar 2022 03:42:34 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EkscJbjna8cFcS4qF5sWryRbg7BoNAOzaoikQS7/CJq2Pff+K+q499VBoEVUliGnlQe8dYs9kHHnEfQMDf74eBmKTexkhVmWJNnHi4jHXoEVpl9WpcnpmUEZwkOoDGT2y5vuUJVdRWP1teQ6ASJuqrOwZlYc8XOlXtHMZjTLlk4JHXuDob7iRvNs5F1F1mFr9FFv2n5Nbu2kLjKWFn//CZqUGc1iGUqFv8AdUHDmNtofzIEyAyIzQOzgTq6Y0EgGA3DACkhjZWwRVpV3m3Q6wI4g3Wh9AcK2X0j5JZ7b5i9m0qq54gcw7pUz0A4arslCOg2o3ucp3kz/Oe8tAOUXfg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rCVXXopX/Tc+V/yC47aaVFkT3EJ85MlTUU/eVVjkyG4=;
 b=MmVxjh+C58PBF885OnjWovYWoafsUGzBrWloRnDYaPNGDDnVqpzciP58Cjl7dWQatKFp1sGvSDj/xETOPFhGW0DS2apz7Kxuf4Waw7ym3atFv6tBF3rDeeitdN6HYY+OjTFE+ebGroROqp74J8HGKhsmbzxiKLFJWl+lHrz1LmOgeeHD7OLsun5jb6d3M0i2Xa4+RP7u48fAovapc4EldVM5qdTFUGllg9oo+1V3LVf3OMPRDN2MyskHKl78n72saWhqp0O5FvRB8/mbAPAO4G0T7QqtSCcLCLVXf//gwZLXL99kE5JyZvhZfvFIJ/fcRLrXUqGv8OkvJRvw0WJV2w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rCVXXopX/Tc+V/yC47aaVFkT3EJ85MlTUU/eVVjkyG4=;
 b=ZamoSrUn6WIIcIqE0H0RG9EJRmcrX7LS8ZC8LaZZjqxdkTLTNOuJ1Gz4XRFbgdSm1QPbmzXz384ea5M80ikwt1PMGou/yAlhPJc/NyRLX1vKXUp+qQoJgaiyIujNbAH75dRV8dG4Sos8lWQMeHV8oN10bqNpwQNEf55QE+o728s=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by CY4PR13MB1512.namprd13.prod.outlook.com (2603:10b6:903:12f::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5102.15; Mon, 21 Mar
 2022 10:42:31 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::7077:d057:db6b:3113]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::7077:d057:db6b:3113%4]) with mapi id 15.20.5102.015; Mon, 21 Mar 2022
 10:42:31 +0000
From:   Simon Horman <simon.horman@corigine.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Yinjun Zhang <yinjun.zhang@corigine.com>, netdev@vger.kernel.org,
        oss-drivers@corigine.com
Subject: [PATCH net-next v2 04/10] nfp: prepare for multi-part descriptors
Date:   Mon, 21 Mar 2022 11:42:03 +0100
Message-Id: <20220321104209.273535-5-simon.horman@corigine.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220321104209.273535-1-simon.horman@corigine.com>
References: <20220321104209.273535-1-simon.horman@corigine.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM0PR02CA0001.eurprd02.prod.outlook.com
 (2603:10a6:208:3e::14) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 25497156-08c1-4797-e796-08da0b278097
X-MS-TrafficTypeDiagnostic: CY4PR13MB1512:EE_
X-Microsoft-Antispam-PRVS: <CY4PR13MB1512B6E34E96AE911C7E4D46E8169@CY4PR13MB1512.namprd13.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: B6QQXJ1cRYF7SEEksoNxScoHUKKYc/RV5bLoib3zcZAllqhEYHObHqjfG4dE4++oNAFIU7p8WOai/cKX7fbl/OPs9dVRcaCrqpcM8cgnXnOqn6fskdF/WzxgKy1x1EEdyLxahVRoH1DhsEH1EWzqNOaiZFPX32lPB0mbmLaTNbZe5x9u+Mv97SYYwSu5EAeGVpUOEETB9sWjqr/LO9+mICUERm6MBpDCGbMz9udMfPj1aBrx3ShzJaIK3r1gcKx3hOIABX/ziYgzNgBDjrpRH7UEMBZu0C2Z1nEvXARXtNTWjn0DauQqix3sEv3+GxqF8UqV1vueCw5XZP8IM0AEnqjjy7aOOinWK5D9SSRkjm45FhDvv2jXO3exPI3hjCn9HjnyuKAJXeIzHRBt5k21S7Q9Vths9PcCC1UvPRuvvTjtXA4O74/6P7pKhoE/BT2Rx5uylGHm8hDcQA0+RmbwIiRN16fzlEPb6bs0wdxOzq3CkjG1v2vw/4SXRTDXuX51ULwZ/lZrzHkFQ4LafedUqIMCL1jfsWkx8mh8GrJ+G0a6+Qnr9unhTKMiCLrbKPTwJp/j63EFMvpg4KjqiZbVVHrd4NGAPbts4ZypBLiBNActRIas/sgfZmEL5uv3yTZX3e2A3fZ7fkQlJQ0DnkV46A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(39830400003)(136003)(396003)(376002)(366004)(346002)(8936002)(186003)(1076003)(6512007)(110136005)(6506007)(2906002)(8676002)(5660300002)(86362001)(52116002)(107886003)(6666004)(6486002)(44832011)(66946007)(4326008)(38100700002)(66556008)(2616005)(66476007)(316002)(83380400001)(508600001)(36756003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?h1hBqus7dNXlhjQAmlB1ouAd0f6YCHmh0X8m/zaDM96uytG4ONA4fTLAwczL?=
 =?us-ascii?Q?UCvA9CiyabPGl25zEmR/b9/RqK+kTtRDQ9wxr7PpdzJuFrbHyS+tPKh4Le7M?=
 =?us-ascii?Q?ni6Yr+sQmWfwNFkhWG7Q3ygFx8MyCG82ofvmDv7cJMUkOWQ6KmK1Lz5F4TXI?=
 =?us-ascii?Q?z5f/CV9ueCkhGCkxBXwzSW4kEPKm756qKw9j2GI9i94z43TBWGe8fsvWem/i?=
 =?us-ascii?Q?v/LNJAikuVzbNZNq4M7AB5aGudqevesvY+xrBzeihO1X8d/WUfNGrxUkpma3?=
 =?us-ascii?Q?Yz71paJgz1NFUCigKJFNLGv3CM9pTRUre3e8OCxY/0k3fx1Jdw3SD0UbvsMi?=
 =?us-ascii?Q?yzBghMt5tnh8pwMRex95SqOVMBi+9zgLzRW3LjAPRu1XDUbJIElDZd7NaaF/?=
 =?us-ascii?Q?kTbyEUthlm2mAqUjBIQkP//o2IZyq6ZF1vgmpZxZx1o//mwha5N2ScBNWDa+?=
 =?us-ascii?Q?1ozTipzsxQ8GI2MHFhit59w5kO72zgmxLbyufyoNu60l7dzzdsq0g4eE2a81?=
 =?us-ascii?Q?PVDOk2CVipwHMuXSi7tE2Z9QeV2UjptBkhqUQg/UccCu1EenPHzWEyJwaotC?=
 =?us-ascii?Q?mHMabbHvOpABdjjMuiAn7u4canAJ/yld4LzzF+eeOjo8ahIe9x6YfGApc8Oe?=
 =?us-ascii?Q?K7cf+v44vwXRXT6B8ssC5gggqusqHbYE0hp07xbQM5g5m+hlpt1TYtm+CXe+?=
 =?us-ascii?Q?JLoHMGGR6pFy3HSQ1BVvZxcBD+zZ8vHB4tQAv1ZD7wcnvL0y97hz+Ynze/nk?=
 =?us-ascii?Q?wAmMKPOpPAYk+HdfpHTlf/1Hws7cdhGI3bQ6Q/FJDtqkPqc/4yYoMV5sCN4u?=
 =?us-ascii?Q?vpgutEpgP8vAqroIIExGVBstPzs9yAvhIbT3q5WhnksDG1+P+fzDZrXIlFZX?=
 =?us-ascii?Q?pZ5BrAU4SVqu6ndm9IJ/Gwx9yBLJmiCQm6koe6uTptO9NBvDGx99tVVt1OTB?=
 =?us-ascii?Q?WeKLqmSJT0h6EniXXy94cJcxZB/g/TLD5UZhVGzqR7ia/R9TUVYNupScLvGZ?=
 =?us-ascii?Q?W3f4op5eeY75nlNRSNZMx6Zm1J5V9R370sQnzZ9mtmjQMkHD/2axbLM+m6Xo?=
 =?us-ascii?Q?6IQ1BiAcxaFQwdW5sKXGfYjgm7fd4BzP/yB5m1lG8TLlSmcYe+Rg6DFhZQbV?=
 =?us-ascii?Q?yt+z4cKANox2HpKXWpUJeYgKFWeNZyOEXiNl/0F3FFMjpWUTrzJry6tYlR4k?=
 =?us-ascii?Q?l8zBhIAivLb7wKVmBt3maumsdDxHYu9I60XxwDNl/8UF2YiJmJGyjwXD1TDb?=
 =?us-ascii?Q?HQlKoh7mApYLGtTheY/WVXXFzvtE7PYnBeP5pZ9wfRoL6Hgiqi/ltlZqk9jM?=
 =?us-ascii?Q?mjrqYY3et44nyFI+Nvg3+qvX7vvz4kR6xLGKArtssRRwitNaV9Vtsgh7RDYb?=
 =?us-ascii?Q?KFLkOaLytpJj+AaD/64Vlfz8QBuxuK//LhoN2skvYGfs0lkr/fBeMeVDdsa3?=
 =?us-ascii?Q?8m1+wAWr/BbU4mFG4fIKmuo/2VIZDlppMQ98pch72rJ7nbsc6rAH5seh0+kB?=
 =?us-ascii?Q?E7HnAJxu3KcNaGNlnEgkrN7H51zn2wkz4ru3GHEWBkoMjWz2hTGbz30GXg?=
 =?us-ascii?Q?=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 25497156-08c1-4797-e796-08da0b278097
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Mar 2022 10:42:31.6196
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: KEIdZX28qGyjo9Q3VPt591CkXgqqKCmUynr/UOH5lg9wY2dEfpIgCBvEZ1eWk0sUB4p+Z4zUnrzJKmIjp9KFMSY4LD+AiDODleMUP9g5yC4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR13MB1512
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

