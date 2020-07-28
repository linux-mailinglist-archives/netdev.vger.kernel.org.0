Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 904392306C7
	for <lists+netdev@lfdr.de>; Tue, 28 Jul 2020 11:45:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728534AbgG1JpL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jul 2020 05:45:11 -0400
Received: from mail-eopbgr10086.outbound.protection.outlook.com ([40.107.1.86]:23103
        "EHLO EUR02-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728524AbgG1JpJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 28 Jul 2020 05:45:09 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=j5YzY+bp7w5QhwsJvP9ovP3P04CAcAIdWXQ4JZX/30Zc263CaQVZNt/AxqAoMLYeFzFk2XcWMcIS2pKuCIxa5/mFuwolOPTdxXLepiGLsWS2+Gc+NfL7WcWev5LwTF78nxE24tZxYOD7kCcX8vguGCmBIW207dThG0rEDcVz/8Op94YGaQJC0cTheVLzlz7L3WHzc9djeSmAbK3LRnv4+eHsoSzXpuhRN8aFDvPem8l+W+fUDIJhc3oSUuTL0YVGvu2im2Pw1Iq9VjQV7pfbb2YPBPkTIpOaNop7tEDPYyK6/EqSYnScyg1GypSIicmIRvjZmAVp5J5z82jQ3L46eA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fnXzZA3ckoy04GCq9TdZIGOXEPBZ8Lx3729fgigd5NA=;
 b=dH3D5meneWg7BtklMaKd/DytVULerfzxMSyjhgaLxVDgUqwfu/j4VnvUiRnSAJ6gVMLpvmNwJfexPFoKLe7/0btmbkwPtkSMs8vK7zXeRir2iu4GKsUurePYdT8cbTlaa7URLTunK5cVfWi6JOOkYbFf6R+K674lh1jNivuGo5bh3gFSz6CY0njHrP3rt+niLX95JApPelo8kNCYozc0qN2PH5cWuy1yy/+4US9tr3PYaJ0Dct4JWuapC33Akty4R9KpSJDwdOfow3BTvYvZ7Ee91N6n7mTgSptDuVAsqMN6W7FAB8ODWHQ0fRpkuxx4zJxzd9milOgKK8ArfDVFdw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fnXzZA3ckoy04GCq9TdZIGOXEPBZ8Lx3729fgigd5NA=;
 b=V2RjIFpLXvMI5g/OQj43MttfYmUz36G2ALin8VI2ujOsoIigZd9OQrPNDv9r8H9DOfIGokq97E35/EAAkNs1I6dph3EWXenhUm3hSmZa9r0kObRcEy+yQICRMzW6vZSDkwnwKgCodz+GIqmVs5pHeuduU4O0TbPbAN8Vla/RVA0=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=mellanox.com;
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (2603:10a6:803:5e::23)
 by VI1PR05MB7117.eurprd05.prod.outlook.com (2603:10a6:800:178::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3216.23; Tue, 28 Jul
 2020 09:44:55 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::508a:d074:ad3a:3529]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::508a:d074:ad3a:3529%5]) with mapi id 15.20.3216.034; Tue, 28 Jul 2020
 09:44:55 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Tariq Toukan <tariqt@mellanox.com>,
        Maxim Mikityanskiy <maximmi@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net-next 09/13] net/mlx5e: Use indirect call wrappers for RX post WQEs functions
Date:   Tue, 28 Jul 2020 02:44:07 -0700
Message-Id: <20200728094411.116386-10-saeedm@mellanox.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200728094411.116386-1-saeedm@mellanox.com>
References: <20200728094411.116386-1-saeedm@mellanox.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BY3PR04CA0018.namprd04.prod.outlook.com
 (2603:10b6:a03:217::23) To VI1PR05MB5102.eurprd05.prod.outlook.com
 (2603:10a6:803:5e::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from smtp.office365.com (73.15.39.150) by BY3PR04CA0018.namprd04.prod.outlook.com (2603:10b6:a03:217::23) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3216.21 via Frontend Transport; Tue, 28 Jul 2020 09:44:53 +0000
X-Mailer: git-send-email 2.26.2
X-Originating-IP: [73.15.39.150]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 8d66b3fa-3205-4b33-1965-08d832dae211
X-MS-TrafficTypeDiagnostic: VI1PR05MB7117:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR05MB7117D8D95CA406B383821FFDBE730@VI1PR05MB7117.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1728;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: zHcOl+X47m8D/NlqhE7dfsIewcPkgI4dbWIusLmLfeJ0Fke6ZZ0xaTyOkJGrlr6q0sI7RQawnvoD4KVPPOSTIArIIgNj3nsJznHuKK+/xNcYGDq8WtBt0trucUscQzTL4wUn3gMaYhyLHoQhaYwuaWJAeMLrUihHygxbWfCHNJuW9fc1IUKJpuNwBalrurpO+7+aj9jhNAc0o21jjSuPcymUiUOh6xHHQiKMohKCLtFqO2W8kvJqLXXcG/AmV7OSV1/WXQOlENeS8OxDeKWpTFT+3LEmlRlMY/dF+UQRILI1gHaoDMFh413eyWZvVOyfO+gsP3/9ayX//hccjW4WqEO94aMqvkBx3p5rtfDeFbApKoe4gdHHVkKNHWC8pLXH
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR05MB5102.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(376002)(136003)(396003)(39860400002)(346002)(366004)(2906002)(83380400001)(8676002)(26005)(2616005)(5660300002)(186003)(6512007)(16526019)(52116002)(4326008)(8936002)(956004)(66476007)(107886003)(6486002)(66556008)(6506007)(6666004)(110136005)(54906003)(66946007)(36756003)(478600001)(316002)(1076003)(86362001)(54420400002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: Cw7+2ghDMq6zhdDwJSmMiGBfMt7eNQ+SB3sMAZUoHqd/YYoBd+chct7Y4Oik7PdoCtEOg6/+DAR/GMl9YMD+LrUEwdrZuQYwO2rhHY18f24KQ284cC8j4RCaGu+jQSwDbvG1b3FLae+cNHL55QXlKK90UKF6aWnCFTFV3+j7VLCGHmkM/IxW2viXfd17hoXJDuHyH1MgKoy6C1AEq0UDxF8dtY1WkqPWyoipCOWw5rcA0glnfhUzqGrc+xhGfEtNePDmGIaIZYRLt2Ox3hXlhnyfL3fJqswzcNZWzj7y9p2FIm//23hHcY+0BFa6J7DShUvNp7Zp1/+rplgXoYquYBMfQ8orPb0vwPfyX2gtBfmF2UxmSgP5jewVdjarr2cMhg/WmOlhEZ748TrnLHtTp1gP3ZTnBrybyXhx8/FHW9dws76NEjxGUZduep4GHvbqIgRYr6bcgqQlkOeYIQCyegkLs3DHwjuMfHweJ3SEZo8=
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8d66b3fa-3205-4b33-1965-08d832dae211
X-MS-Exchange-CrossTenant-AuthSource: VI1PR05MB5102.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Jul 2020 09:44:55.3219
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 2kdt/HZLt5UAucyZoYKhFVC3o42P8MdRknUEIRVbVNez1fgJVyEti3QfTEkO9a43MjyNzCoMH1/ytvy/zqvc5w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB7117
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tariq Toukan <tariqt@mellanox.com>

Use the indirect call wrapper API macros for declaration and scope
of the RX post WQEs functions.

Signed-off-by: Tariq Toukan <tariqt@mellanox.com>
Reviewed-by: Maxim Mikityanskiy <maximmi@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en/txrx.h   | 5 +++--
 drivers/net/ethernet/mellanox/mlx5/core/en/xdp.c    | 1 -
 drivers/net/ethernet/mellanox/mlx5/core/en/xsk/tx.c | 1 -
 drivers/net/ethernet/mellanox/mlx5/core/en_rx.c     | 6 +++---
 drivers/net/ethernet/mellanox/mlx5/core/en_txrx.c   | 2 +-
 5 files changed, 7 insertions(+), 8 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/txrx.h b/drivers/net/ethernet/mellanox/mlx5/core/en/txrx.h
index b25e4ec752281..f7fd2ed322792 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/txrx.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/txrx.h
@@ -5,6 +5,7 @@
 #define __MLX5_EN_TXRX_H___
 
 #include "en.h"
+#include <linux/indirect_call_wrapper.h>
 
 #define INL_HDR_START_SZ (sizeof(((struct mlx5_wqe_eth_seg *)NULL)->inline_hdr.start))
 
@@ -30,8 +31,8 @@ void mlx5e_page_dma_unmap(struct mlx5e_rq *rq, struct mlx5e_dma_info *dma_info);
 void mlx5e_page_release_dynamic(struct mlx5e_rq *rq,
 				struct mlx5e_dma_info *dma_info,
 				bool recycle);
-bool mlx5e_post_rx_wqes(struct mlx5e_rq *rq);
-bool mlx5e_post_rx_mpwqes(struct mlx5e_rq *rq);
+INDIRECT_CALLABLE_DECLARE(bool mlx5e_post_rx_wqes(struct mlx5e_rq *rq));
+INDIRECT_CALLABLE_DECLARE(bool mlx5e_post_rx_mpwqes(struct mlx5e_rq *rq));
 int mlx5e_poll_rx_cq(struct mlx5e_cq *cq, int budget);
 void mlx5e_free_rx_descs(struct mlx5e_rq *rq);
 void mlx5e_free_rx_in_progress_descs(struct mlx5e_rq *rq);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.c b/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.c
index e0c1b010d41ab..90db221e31df3 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.c
@@ -34,7 +34,6 @@
 #include <net/xdp_sock_drv.h>
 #include "en/xdp.h"
 #include "en/params.h"
-#include <linux/indirect_call_wrapper.h>
 
 int mlx5e_xdp_max_mtu(struct mlx5e_params *params, struct mlx5e_xsk_param *xsk)
 {
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/tx.c b/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/tx.c
index 0dfbc96e952ab..4d892f6cecb3e 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/tx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/tx.c
@@ -6,7 +6,6 @@
 #include "en/xdp.h"
 #include "en/params.h"
 #include <net/xdp_sock_drv.h>
-#include <linux/indirect_call_wrapper.h>
 
 int mlx5e_xsk_wakeup(struct net_device *dev, u32 qid, u32 flags)
 {
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c b/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
index 9c0ef6e5da881..65828af120b7a 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
@@ -34,11 +34,11 @@
 #include <linux/ip.h>
 #include <linux/ipv6.h>
 #include <linux/tcp.h>
-#include <linux/indirect_call_wrapper.h>
 #include <net/ip6_checksum.h>
 #include <net/page_pool.h>
 #include <net/inet_ecn.h>
 #include "en.h"
+#include "en/txrx.h"
 #include "en_tc.h"
 #include "eswitch.h"
 #include "en_rep.h"
@@ -561,7 +561,7 @@ static void mlx5e_dealloc_rx_mpwqe(struct mlx5e_rq *rq, u16 ix)
 	mlx5e_free_rx_mpwqe(rq, wi, false);
 }
 
-bool mlx5e_post_rx_wqes(struct mlx5e_rq *rq)
+INDIRECT_CALLABLE_SCOPE bool mlx5e_post_rx_wqes(struct mlx5e_rq *rq)
 {
 	struct mlx5_wq_cyc *wq = &rq->wqe.wq;
 	u8 wqe_bulk;
@@ -702,7 +702,7 @@ int mlx5e_poll_ico_cq(struct mlx5e_cq *cq)
 	return i;
 }
 
-bool mlx5e_post_rx_mpwqes(struct mlx5e_rq *rq)
+INDIRECT_CALLABLE_SCOPE bool mlx5e_post_rx_mpwqes(struct mlx5e_rq *rq)
 {
 	struct mlx5e_icosq *sq = &rq->channel->icosq;
 	struct mlx5_wq_ll *wq = &rq->mpwqe.wq;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_txrx.c b/drivers/net/ethernet/mellanox/mlx5/core/en_txrx.c
index e3dbab2a294cf..de10b06bade53 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_txrx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_txrx.c
@@ -31,8 +31,8 @@
  */
 
 #include <linux/irq.h>
-#include <linux/indirect_call_wrapper.h>
 #include "en.h"
+#include "en/txrx.h"
 #include "en/xdp.h"
 #include "en/xsk/rx.h"
 #include "en/xsk/tx.h"
-- 
2.26.2

