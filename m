Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 948891D5C87
	for <lists+netdev@lfdr.de>; Sat, 16 May 2020 00:49:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727805AbgEOWti (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 May 2020 18:49:38 -0400
Received: from mail-db8eur05on2084.outbound.protection.outlook.com ([40.107.20.84]:33656
        "EHLO EUR05-DB8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726183AbgEOWth (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 15 May 2020 18:49:37 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=haBZhMvVnVi8lxd7dgprSBuYDPkeWv9fIU+IC1E+yz1VJMzURifANjCxKfFC+SriK1N2cAqnxcfnYUn9+OVjEpavC9YgqxOR+dW5yR+193JrkmiouXg+emi5khfE4ZNuYM4Leb+uTwGdSAvJTrvHMU9hLU8IspjoxBPzjbBMAp6wybkXSipmaVJCHVzvfK9FnJjE4RPFAXu5lcOEzLbHlbOPirqIG2JXoSj5FfydzgzzMT+YVFmnIvRk1cv0eemO+Tz8MnUj2LfhEWQl6amkvgZTbJfsEM7cnmP8FsjpxtvytHOIIFlPK5gH9GVSYSPg1HDygq/iZul7rK2sVPTalg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ok16s3hSPcveUll6FJlj0telfEeEthfBQdO29zu+tzI=;
 b=R+I9b7m5nuo1nV0R6MBxVRvcLziGWTnxb4Rk89AYJqpw3x2pizOg7nmsNVlj6KhfWzk/LfUNkgefKv/q6ucfYKyisg65/Txu5ZIcxU96zrtLdnxExYj08qdOfPHSH6SO+j8uYCzRm7teM8+9G966vo3Xs3eqnRRENjCalHdIwCX3pRrK0KPmOg9QD3N76sHUcjKVL5j00O7vDI9JYi7owSpHzAI8wN9NpuxWRPg3xHDlhXrV3cYT+LezIf1Kz8Nxr0uPpx0z9DUeNbuCJ3b0pMsHEbVyZHioJ968LQEaF36WnLi9c3404TbiprHo2TpvdbnQ7lYGJrqgSgA9/1/EHA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ok16s3hSPcveUll6FJlj0telfEeEthfBQdO29zu+tzI=;
 b=VigfnjZqHG8Ek6koywXpVE6LXDCl7U4Y4fhdjSbkHqbmpIKpAuW2P7XpWjWOksOHaI8YhG1CdVdARGBNDUY8iWLLS+RFWCLSNo2futc+AxcLzfv+5xPR11G8J1J30jEUaLvXnYYLJcx07ZjS3FhEnblEFnDTyBIx15kERmeydlA=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=mellanox.com;
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (2603:10a6:803:5e::23)
 by VI1PR05MB3200.eurprd05.prod.outlook.com (2603:10a6:802:1b::29) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3000.24; Fri, 15 May
 2020 22:49:30 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::2405:4594:97a:13c]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::2405:4594:97a:13c%2]) with mapi id 15.20.3000.022; Fri, 15 May 2020
 22:49:30 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>, kuba@kernel.org
Cc:     netdev@vger.kernel.org, Eran Ben Elisha <eranbe@mellanox.com>,
        Aya Levin <ayal@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net-next 06/11] net/mlx5: Move internal timer read function to clock library
Date:   Fri, 15 May 2020 15:48:49 -0700
Message-Id: <20200515224854.20390-7-saeedm@mellanox.com>
X-Mailer: git-send-email 2.25.4
In-Reply-To: <20200515224854.20390-1-saeedm@mellanox.com>
References: <20200515224854.20390-1-saeedm@mellanox.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BYAPR06CA0053.namprd06.prod.outlook.com
 (2603:10b6:a03:14b::30) To VI1PR05MB5102.eurprd05.prod.outlook.com
 (2603:10a6:803:5e::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from smtp.office365.com (73.15.39.150) by BYAPR06CA0053.namprd06.prod.outlook.com (2603:10b6:a03:14b::30) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3000.20 via Frontend Transport; Fri, 15 May 2020 22:49:28 +0000
X-Mailer: git-send-email 2.25.4
X-Originating-IP: [73.15.39.150]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 729ff7e7-1417-4fb6-b0e9-08d7f9223a9b
X-MS-TrafficTypeDiagnostic: VI1PR05MB3200:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR05MB3200367B7DA411D4334087A6BEBD0@VI1PR05MB3200.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2399;
X-Forefront-PRVS: 04041A2886
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: dIpUlJ97O8VjT9tAbGAd0SHZSt/UrI/4tUEDV9+dC5/D6vydrz+JeK0vR5kD4osyMZFfJDe9beDQ2+y0B4G9VOeIyLjOmOqdOMehrsTWQ5EVeCsgJpc/k7JFpngbzfO4q4CV45AgB/g9xITWotnEifWVavM8C0uYj7a10egRpEIjtNlH9rAhCGw/nJcQG/vuQjkwcLYbDKUBhDsPOJA2Q+ChENoFr4RrCcIaNXtbeY70D//WpMKYUlrjXWqxMFKOTuMLUgZyzdL1lgjcls/ZCResgxBtCy9NKdzQ47V+9qjpR6JoobxPgr8CJzKvxFOGtHZWvs7WUQebXVmZ2Zh75aYZUoLxg7M96S+OCPafyzVxzmksFd3TqTVn2CQ97FSkCorV2HnqqxsAAnS/nNk8dy4dmb3Vj7TTHozPoOXuOIiGKDhwp8Tvt9RbcDFSHgL9oSa2bcrI4AVANUX9imY2MOBc26Nr9blGh8mVREL2/E7ZngU8x5n4HzZ5vB/d+0y7
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR05MB5102.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(376002)(366004)(39860400002)(346002)(396003)(136003)(16526019)(26005)(107886003)(4326008)(6512007)(6486002)(6666004)(478600001)(66476007)(2616005)(66946007)(66556008)(54906003)(956004)(52116002)(316002)(6506007)(186003)(1076003)(86362001)(5660300002)(8936002)(8676002)(2906002)(36756003)(54420400002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: L400jNwxyHorRe6vvRgrBfav/KopXLJ4XlPi3rqRtSEnlUOywWklgfsm1ZCx/MxOKV7tADBTxha4ZtgFnbghCaUX+COv0HkRcigTo96praIHF9dp1W2uG9ulOzdfrIMsbY5ed2oc+n2y/L7zd9thmqZOpj5+Xi3ELShMwcxTl3KDInEon7TyNdIFuXUdzL37NoIaCu+z1JYLX8Ho+TpPXnkWmNo0/DU6P23N/y+QeBfsWkEFEEyQP3K3gFzDeAyXF8zyvKoiYBit7hfsIPcNwoWH+BycKOIvmRGvcuqOjtNLAX2P0tQbDeQFQ/rngshTCOMylXfcPHVKFnc5Cl5A1ruwQrX+N0rGtz35txQvS90yTATm+/JYc6U6z+vemM1mRTuuauT4QZCGlqSTYLhLR/dUjOljBztPPKdSj51XFyzfYz/mJ2DW3Xl5syEo0eGyVidrjni/DeUJ12dcpNCdOFPvJZGVv2ElHG/eovnhMpk=
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 729ff7e7-1417-4fb6-b0e9-08d7f9223a9b
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 May 2020 22:49:30.6389
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: OM+ZNq0EBw2hv+kBkMk6jpOh6Jg2OogjWBrBt4u6r7ungvevAMDIJgHlyIf7KjjcEYsCPeBZlN0DDGBmHpn7/A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB3200
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eran Ben Elisha <eranbe@mellanox.com>

Move mlx5_read_internal_timer() into lib/clock.c file as it is being
used there. As such, make this function a static one.

In addition, rearrange headers include to support function move.

Signed-off-by: Eran Ben Elisha <eranbe@mellanox.com>
Reviewed-by: Aya Levin <ayal@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en.h  |  1 -
 .../ethernet/mellanox/mlx5/core/lib/clock.c   | 21 +++++++++++++++++++
 .../net/ethernet/mellanox/mlx5/core/main.c    | 20 ------------------
 .../ethernet/mellanox/mlx5/core/mlx5_core.h   |  3 ---
 4 files changed, 21 insertions(+), 24 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en.h b/drivers/net/ethernet/mellanox/mlx5/core/en.h
index 26911b15f8fe..195162b9b245 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en.h
@@ -36,7 +36,6 @@
 #include <linux/etherdevice.h>
 #include <linux/timecounter.h>
 #include <linux/net_tstamp.h>
-#include <linux/ptp_clock_kernel.h>
 #include <linux/crash_dump.h>
 #include <linux/mlx5/driver.h>
 #include <linux/mlx5/qp.h>
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lib/clock.c b/drivers/net/ethernet/mellanox/mlx5/core/lib/clock.c
index 43f97601b500..ef0706d15a5b 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/lib/clock.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/lib/clock.c
@@ -32,6 +32,7 @@
 
 #include <linux/clocksource.h>
 #include <linux/highmem.h>
+#include <linux/ptp_clock_kernel.h>
 #include <rdma/mlx5-abi.h>
 #include "lib/eq.h"
 #include "en.h"
@@ -66,6 +67,26 @@ enum {
 	MLX5_MTPPS_FS_ENH_OUT_PER_ADJ		= BIT(0x7),
 };
 
+static u64 mlx5_read_internal_timer(struct mlx5_core_dev *dev,
+				    struct ptp_system_timestamp *sts)
+{
+	u32 timer_h, timer_h1, timer_l;
+
+	timer_h = ioread32be(&dev->iseg->internal_timer_h);
+	ptp_read_system_prets(sts);
+	timer_l = ioread32be(&dev->iseg->internal_timer_l);
+	ptp_read_system_postts(sts);
+	timer_h1 = ioread32be(&dev->iseg->internal_timer_h);
+	if (timer_h != timer_h1) {
+		/* wrap around */
+		ptp_read_system_prets(sts);
+		timer_l = ioread32be(&dev->iseg->internal_timer_l);
+		ptp_read_system_postts(sts);
+	}
+
+	return (u64)timer_l | (u64)timer_h1 << 32;
+}
+
 static u64 read_internal_timer(const struct cyclecounter *cc)
 {
 	struct mlx5_clock *clock = container_of(cc, struct mlx5_clock, cycles);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/main.c b/drivers/net/ethernet/mellanox/mlx5/core/main.c
index d6a8128f667a..4d2e1e982460 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/main.c
@@ -672,26 +672,6 @@ int mlx5_core_disable_hca(struct mlx5_core_dev *dev, u16 func_id)
 	return mlx5_cmd_exec_in(dev, disable_hca, in);
 }
 
-u64 mlx5_read_internal_timer(struct mlx5_core_dev *dev,
-			     struct ptp_system_timestamp *sts)
-{
-	u32 timer_h, timer_h1, timer_l;
-
-	timer_h = ioread32be(&dev->iseg->internal_timer_h);
-	ptp_read_system_prets(sts);
-	timer_l = ioread32be(&dev->iseg->internal_timer_l);
-	ptp_read_system_postts(sts);
-	timer_h1 = ioread32be(&dev->iseg->internal_timer_h);
-	if (timer_h != timer_h1) {
-		/* wrap around */
-		ptp_read_system_prets(sts);
-		timer_l = ioread32be(&dev->iseg->internal_timer_l);
-		ptp_read_system_postts(sts);
-	}
-
-	return (u64)timer_l | (u64)timer_h1 << 32;
-}
-
 static int mlx5_core_set_issi(struct mlx5_core_dev *dev)
 {
 	u32 query_out[MLX5_ST_SZ_DW(query_issi_out)] = {};
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/mlx5_core.h b/drivers/net/ethernet/mellanox/mlx5/core/mlx5_core.h
index a8fb43a85d1d..fc1649dac11b 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/mlx5_core.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/mlx5_core.h
@@ -38,7 +38,6 @@
 #include <linux/sched.h>
 #include <linux/if_link.h>
 #include <linux/firmware.h>
-#include <linux/ptp_clock_kernel.h>
 #include <linux/mlx5/cq.h>
 #include <linux/mlx5/fs.h>
 #include <linux/mlx5/driver.h>
@@ -141,8 +140,6 @@ int mlx5_modify_scheduling_element_cmd(struct mlx5_core_dev *dev, u8 hierarchy,
 int mlx5_destroy_scheduling_element_cmd(struct mlx5_core_dev *dev, u8 hierarchy,
 					u32 element_id);
 int mlx5_wait_for_pages(struct mlx5_core_dev *dev, int *pages);
-u64 mlx5_read_internal_timer(struct mlx5_core_dev *dev,
-			     struct ptp_system_timestamp *sts);
 
 void mlx5_cmd_trigger_completions(struct mlx5_core_dev *dev);
 void mlx5_cmd_flush(struct mlx5_core_dev *dev);
-- 
2.25.4

