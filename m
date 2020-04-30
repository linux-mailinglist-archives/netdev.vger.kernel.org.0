Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 651F01C03CC
	for <lists+netdev@lfdr.de>; Thu, 30 Apr 2020 19:21:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726933AbgD3RV0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Apr 2020 13:21:26 -0400
Received: from mail-eopbgr70055.outbound.protection.outlook.com ([40.107.7.55]:6237
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726544AbgD3RVZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 30 Apr 2020 13:21:25 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IewmJoJzQ9ibbLvlCK6sCrO90uGKWqK3RoJGgti5viINa0V156J1AP6xS+pt9RJdF9zpYVKvRW5BvcFXatjqeaVpib+9TdTjksHwNvUaQ5HSedYcl/GzGpb1Hw5BJ35znYE2kWLTcbmtTCNHqBDHruUZOBQVpRCsmBp8M4bJJfIqpAZwCc8r++/zz8jf6YkkfMZlPpo3HSY7yvkRMyvLr4NIGhPBQijOu/TD3OSnpfwWvbG8MoFKoTz6qtCCLYT+WVdrGWohsJvnzuUqIaZjSbxf+Vhnnt1RvFg2e50QepJLWjMlyChea0B4i2/MFk8tNmyABj4KpL24divXZfNHvQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9oEGnROaHifYoaF1LTqqNfYV14C1iYdVA1fcVv8y/5o=;
 b=oDJDWFT88pxp3yDfPEu+bDTeovtl3M2eYhW7iiexZW6nJPb698P+WU3zkJ9H5HrbPkc5viJGR9niuxtxdlbyv2V8E7UncaeBX6TorgETDtSqawWcpr5zuAmX6nuxbN2WOJsh30ZW5L/tHb8G3hS+VaOtu6Qp+KI/e4XbeTCtIUj4+l/fqrZvc9ObV9QRS398vLMgBJrQJM7TjM8jUXhLwvQ3yxpOUyQ1FlANwlUp54TiiWW+xFkZYvfzKPpMjjLr1lVwDV+am5rRvjN18uebv8hIao6PT+G65hnVz5LGsV7oglI6ex5fLSJJOppoi7adMBjFWT8oJ0lPjnYICGjA8A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9oEGnROaHifYoaF1LTqqNfYV14C1iYdVA1fcVv8y/5o=;
 b=saAQgojDOJI6IAjbc5mDgPGjjjpWL8+HItr9RqrIsky80SJyGNLKqylYEdZvQgJXh86c1pSsObjUQ8iYLFIlbpN4QZhtjuctugjAfS9BgcwDfRKu+Xva4YqNgYxIoAZyNyKLfnD9lYgCprmYAhLN3IchK9as7tbITxFtDdO3kLg=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=mellanox.com;
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (2603:10a6:803:5e::23)
 by VI1PR05MB3296.eurprd05.prod.outlook.com (2603:10a6:802:1c::29) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2958.20; Thu, 30 Apr
 2020 17:21:16 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::9d19:a564:b84e:7c19]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::9d19:a564:b84e:7c19%7]) with mapi id 15.20.2937.028; Thu, 30 Apr 2020
 17:21:16 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>, kuba@kernel.org
Cc:     netdev@vger.kernel.org, Eran Ben Elisha <eranbe@mellanox.com>,
        Moshe Shemesh <moshe@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net-next 09/15] net/mlx5: Add support for release all pages event
Date:   Thu, 30 Apr 2020 10:18:29 -0700
Message-Id: <20200430171835.20812-10-saeedm@mellanox.com>
X-Mailer: git-send-email 2.25.4
In-Reply-To: <20200430171835.20812-1-saeedm@mellanox.com>
References: <20200430171835.20812-1-saeedm@mellanox.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BY5PR17CA0030.namprd17.prod.outlook.com
 (2603:10b6:a03:1b8::43) To VI1PR05MB5102.eurprd05.prod.outlook.com
 (2603:10a6:803:5e::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from smtp.office365.com (73.15.39.150) by BY5PR17CA0030.namprd17.prod.outlook.com (2603:10b6:a03:1b8::43) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2958.20 via Frontend Transport; Thu, 30 Apr 2020 17:21:14 +0000
X-Mailer: git-send-email 2.25.4
X-Originating-IP: [73.15.39.150]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: f2c1cf15-546f-4dc9-ad3e-08d7ed2ae3b5
X-MS-TrafficTypeDiagnostic: VI1PR05MB3296:|VI1PR05MB3296:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR05MB3296D03AF4E7DC33A03B14EBBEAA0@VI1PR05MB3296.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5516;
X-Forefront-PRVS: 0389EDA07F
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: VOqZXG9u1HqAIUbmkyH1nKURtfRh3JaXaFDjpWg1m/Ln2n01Fjikjv40BslGHiOYQFR9JZodlZI+vMaeIupFjbLRuj5ywaq9K6ioe6S1s9endK/rjc09k+cXWrH9stnwe6/UJ96EP9neNXUCXU7adTgJ2NrCnsj9F78ZiHbIEyqs8x1m24XbXQnDffc0j+RIYn0nMIDPZwyWDAnRRalD5hkHYGRSJU2v63LKQ9KOz4c6uhTC1rPVnYucs27cu2rsN2Qh1Ld1+ke0zfYaFO1t4zg9ZsZR4iXtkD24V5Vz7ekvO8iyEPEq6mTy3SyTwfTQqYa0PI9xE7Kf7v39+1IdrdtVvCF4mM62tv3RbeA8pzCZdDjqg9REJMlpVvlNR1ALos/kbzc+CjOzb3F3Qjz/NDkDmdFQub8A9ttZo4oDoM88smbbsQIElN/OYVIj/0d1oixJWhmsD5/aSsLmHMUYYUWXOUVeAcsG28DzwNqHq3Ji08+QdmOJgicBXzUw7zNL
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR05MB5102.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(396003)(376002)(39860400002)(366004)(136003)(346002)(52116002)(6666004)(54906003)(2616005)(956004)(316002)(2906002)(478600001)(107886003)(4326008)(66946007)(86362001)(66476007)(66556008)(36756003)(6486002)(16526019)(186003)(26005)(8936002)(6512007)(8676002)(6506007)(1076003)(5660300002)(54420400002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: zYP242V+o98I5dwwLsOI5uCuC8d+LVgB65/4RcPXaTxycPZVjAuNX8XdW33WHDG+WtxAkN6HQ7ut9owd4w20BL9uKnRsjj8yfJ0cUP1RR6RyW8963RxmaB1iC0zyhWeRkH/ogch4J4HcW3Hmam6cBMDTQzjbG3elDKgeBnXHTezdnhQTZk6972Z4pK1jAh1ZvCW/c3xQ+BYhYqPnxf21idcrDxi/heT7NZVmjeoXOZR7MAj/UM0F1NDqZNCmNoA5CDuxsE5dI2HLWE8Npy5iaiUFXIEPdbh2u4cRYz3gMRH9Ti/gnYv39Rd084EoFSh4jykZrC1b65ACPfmUgHHYwmnIxgiIyLsAi5i2wHcaAcJzaJ6Dcqsia5zFJrfBX/Iz8xvpY67FlQxvmXRYIlLCXoFOVDvzUUJonB9bGTMtVlr/g4CbsF50pawQNiW0hs4zrmzINWMAv9lPG724i/XjIXQkCxtobfv8suVJulqbpZKCGYy1h8HMMPohp9YKU8TZ2aVHHWgtoQMUD3qbKVcHdPGMbSuoDUM0aGLDoKxU2hehHyWvzsCegjrwuyPjt07wFqjowbYlFY7ZjyoynuXeDPqaMhpjZtkSpfPGQZHJgX12wQ7cuD5+LI5AyfBtwHyGcfQ4zTON46hej8olx75ZmOg9RKVPvCzA09b4Yfs4LBnyLvliLNYAQ+fLUotGSm3Koh3F//7wRsQ6pq+mvEC5mpRcIVX6GcYHBw+cdUb+cGuEP4cQ+bQqJh+2DJzT8e73qKrV85d25mLnQXAovGoUKizS9l6lS8wF2/wsMmNNMwc=
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f2c1cf15-546f-4dc9-ad3e-08d7ed2ae3b5
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Apr 2020 17:21:16.3206
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Ox8fWv563DoMx25rvpdrTumb2M2PGogtnVAoJhOTer2mbQOhZn/WERxyb5S1KXZehu/+fR9J/ajkyQ/4el6CWA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB3296
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eran Ben Elisha <eranbe@mellanox.com>

If FW sets release_all_pages bit in MLX5_EVENT_TYPE_PAGE_REQUEST,
driver shall release all pages of a given function id, with no further
pages reclaim negotiation with FW nor MANAGE_PAGES commands from driver
towards FW.

Upon receiving this bit as part of pages reclaim event, driver will
initiate release all flow, in which it will iterate and release all
function's pages.

As part of driver <-> FW capabilities handshake, FW will report
release_all_pages max HCA cap bit, and driver will set the
release_all_pages bit in HCA cap.

NIC: ConnectX-4 Lx
CPU: Intel(R) Xeon(R) CPU E5-2650 v2 @ 2.60GHz
Test case: Simulataniously FLR 4 VFs, and measure FW release pages by
driver.
Before: 3.18 Sec
After:  0.31 Sec

Signed-off-by: Eran Ben Elisha <eranbe@mellanox.com>
Reviewed-by: Moshe Shemesh <moshe@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 .../net/ethernet/mellanox/mlx5/core/main.c    |  3 ++
 .../ethernet/mellanox/mlx5/core/pagealloc.c   | 41 +++++++++++++++++--
 2 files changed, 41 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/main.c b/drivers/net/ethernet/mellanox/mlx5/core/main.c
index fbbf51026b52..742ba012c234 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/main.c
@@ -549,6 +549,9 @@ static int handle_hca_cap(struct mlx5_core_dev *dev, void *set_ctx)
 			 num_vhca_ports,
 			 MLX5_CAP_GEN_MAX(dev, num_vhca_ports));
 
+	if (MLX5_CAP_GEN_MAX(dev, release_all_pages))
+		MLX5_SET(cmd_hca_cap, set_hca_cap, release_all_pages, 1);
+
 	return set_caps(dev, set_ctx, MLX5_SET_HCA_CAP_OP_MOD_GENERAL_DEVICE);
 }
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/pagealloc.c b/drivers/net/ethernet/mellanox/mlx5/core/pagealloc.c
index c790d6e3d204..8ce78f42dfc0 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/pagealloc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/pagealloc.c
@@ -50,6 +50,7 @@ struct mlx5_pages_req {
 	u8	ec_function;
 	s32	npages;
 	struct work_struct work;
+	u8	release_all;
 };
 
 struct fw_page {
@@ -341,6 +342,33 @@ static int give_pages(struct mlx5_core_dev *dev, u16 func_id, int npages,
 	return err;
 }
 
+static void release_all_pages(struct mlx5_core_dev *dev, u32 func_id,
+			      bool ec_function)
+{
+	struct rb_node *p;
+	int npages = 0;
+
+	p = rb_first(&dev->priv.page_root);
+	while (p) {
+		struct fw_page *fwp = rb_entry(p, struct fw_page, rb_node);
+
+		p = rb_next(p);
+		if (fwp->func_id != func_id)
+			continue;
+		free_fwp(dev, fwp);
+		npages++;
+	}
+
+	dev->priv.fw_pages -= npages;
+	if (func_id)
+		dev->priv.vfs_pages -= npages;
+	else if (mlx5_core_is_ecpf(dev) && !ec_function)
+		dev->priv.peer_pf_pages -= npages;
+
+	mlx5_core_dbg(dev, "npages %d, ec_function %d, func_id 0x%x\n",
+		      npages, ec_function, func_id);
+}
+
 static int reclaim_pages_cmd(struct mlx5_core_dev *dev,
 			     u32 *in, int in_size, u32 *out, int out_size)
 {
@@ -434,7 +462,9 @@ static void pages_work_handler(struct work_struct *work)
 	struct mlx5_core_dev *dev = req->dev;
 	int err = 0;
 
-	if (req->npages < 0)
+	if (req->release_all)
+		release_all_pages(dev, req->func_id, req->ec_function);
+	else if (req->npages < 0)
 		err = reclaim_pages(dev, req->func_id, -1 * req->npages, NULL,
 				    req->ec_function);
 	else if (req->npages > 0)
@@ -449,6 +479,7 @@ static void pages_work_handler(struct work_struct *work)
 
 enum {
 	EC_FUNCTION_MASK = 0x8000,
+	RELEASE_ALL_PAGES_MASK = 0x4000,
 };
 
 static int req_pages_handler(struct notifier_block *nb,
@@ -459,6 +490,7 @@ static int req_pages_handler(struct notifier_block *nb,
 	struct mlx5_priv *priv;
 	struct mlx5_eqe *eqe;
 	bool ec_function;
+	bool release_all;
 	u16 func_id;
 	s32 npages;
 
@@ -469,8 +501,10 @@ static int req_pages_handler(struct notifier_block *nb,
 	func_id = be16_to_cpu(eqe->data.req_pages.func_id);
 	npages  = be32_to_cpu(eqe->data.req_pages.num_pages);
 	ec_function = be16_to_cpu(eqe->data.req_pages.ec_function) & EC_FUNCTION_MASK;
-	mlx5_core_dbg(dev, "page request for func 0x%x, npages %d\n",
-		      func_id, npages);
+	release_all = be16_to_cpu(eqe->data.req_pages.ec_function) &
+		      RELEASE_ALL_PAGES_MASK;
+	mlx5_core_dbg(dev, "page request for func 0x%x, npages %d, release_all %d\n",
+		      func_id, npages, release_all);
 	req = kzalloc(sizeof(*req), GFP_ATOMIC);
 	if (!req) {
 		mlx5_core_warn(dev, "failed to allocate pages request\n");
@@ -481,6 +515,7 @@ static int req_pages_handler(struct notifier_block *nb,
 	req->func_id = func_id;
 	req->npages = npages;
 	req->ec_function = ec_function;
+	req->release_all = release_all;
 	INIT_WORK(&req->work, pages_work_handler);
 	queue_work(dev->priv.pg_wq, &req->work);
 	return NOTIFY_OK;
-- 
2.25.4

