Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 909D11E52D2
	for <lists+netdev@lfdr.de>; Thu, 28 May 2020 03:19:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726649AbgE1BTD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 May 2020 21:19:03 -0400
Received: from mail-eopbgr150075.outbound.protection.outlook.com ([40.107.15.75]:32229
        "EHLO EUR01-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726487AbgE1BTC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 27 May 2020 21:19:02 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UueKmQCBBgw36MrY3DsO+hMV5QM1LcwwAGJt9dId+nDDXDjNqP593EaZKm88ZW63F5wa79Zpv9I0OTrJxaqNYm0znjjuywCT4TIDiiopyaLMk4S2gCituujuEheOfo8fHqwr79NSGOOEhzJUSphFP83dlHrWWR/cURMB31CRyVMO2kC9am/EonvCZa2OrhQT1rGPiB4CduTvrv9aIRm9kxhd/4lYUec78mMhhTtugtzOYLUW11HYFV0EM9nKKzIDSQaQcNjv4h1cM7HgYij0fWeIeXb60CMoDEOeEsBDTker/goJtUGRQDFxFmgO5nc+AJDAjxZQ3/GB3FvE7UarNw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qj1eiSik3vxTxYesZrsKuXlzr0f3YzXCeXcFtTHsV1g=;
 b=XRLMtdI0hFluldaxdXDA5haV2gHyfD/SqLq21cbV+ANYrtKHxfnGk8PbmvmJO/L1xRc24RN4sLjb00ypKVzqJdjuslg5DJatGy8FcH5T3YMwvVVqV7uxqc7yg4ZX3D5KoANnwAJYs1w8FGV5/o/PHR0hL5bS7tejgrDKlgmVGojpp69vZOcsTwZe6kv2wFcLHyRLdl9/oZSbyMHmyN8w4lKp5QU934WBt06pXLopCsmEN5u8qIuW4QaXdKvDf5FbUF2OiOq8w0sYCYc+ihoWbIID0fSNZZQt1CyEj0KrTShQeTKx/yEeQBatt0d1nvc4dOmmXdAUYBPllF1QNHuU/g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qj1eiSik3vxTxYesZrsKuXlzr0f3YzXCeXcFtTHsV1g=;
 b=dyUCoTKYUtcTQn0uRZo+O7gDxgOjweDdjtuG4Ewn9YFgIWk94pb2L0CkzDpzHdZL9rJveF0WjHJU0m0f5hiIE17zUbdVt5WnDwAVEK3CcZox84yIzOG8euCJuhGHBhGijGTIZDPRog7QBifQkI7xzYrOa8FzX918CXROJKVQe1M=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=mellanox.com;
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (2603:10a6:803:5e::23)
 by VI1PR05MB4368.eurprd05.prod.outlook.com (2603:10a6:803:44::26) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3045.17; Thu, 28 May
 2020 01:17:57 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::2405:4594:97a:13c]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::2405:4594:97a:13c%2]) with mapi id 15.20.3021.029; Thu, 28 May 2020
 01:17:57 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>, kuba@kernel.org
Cc:     netdev@vger.kernel.org, Alex Vesker <valex@mellanox.com>,
        Mark Bloch <markb@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net-next V3 14/15] net/mlx5: DR, Add a spinlock to protect the send ring
Date:   Wed, 27 May 2020 18:16:55 -0700
Message-Id: <20200528011656.559914-15-saeedm@mellanox.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200528011656.559914-1-saeedm@mellanox.com>
References: <20200528011656.559914-1-saeedm@mellanox.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BY5PR04CA0001.namprd04.prod.outlook.com
 (2603:10b6:a03:1d0::11) To VI1PR05MB5102.eurprd05.prod.outlook.com
 (2603:10a6:803:5e::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from smtp.office365.com (73.15.39.150) by BY5PR04CA0001.namprd04.prod.outlook.com (2603:10b6:a03:1d0::11) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3045.17 via Frontend Transport; Thu, 28 May 2020 01:17:55 +0000
X-Mailer: git-send-email 2.26.2
X-Originating-IP: [73.15.39.150]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 5544e9d9-ce31-4231-812a-08d802a4f485
X-MS-TrafficTypeDiagnostic: VI1PR05MB4368:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR05MB436891912E0F40B00E8E0724BE8E0@VI1PR05MB4368.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:612;
X-Forefront-PRVS: 0417A3FFD2
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 0BvDI1UyMG+32x+gBmnma9sPpOSYiuSc7xJGUH4ynxEx2AYn0umisZxrAnL2Maz/SnQvZhBDFzfjHZjkVpMiDRe6ToWi8JTbLX/fcdVaaCjt8dY5Z5ZIYZyxIxnCzPFhdTnNUGY6YCOlRAHDKQFfpk3/UCyw8FgVxOMeegMK+wHLKvMZabo0IOFhdgN54tqhIBQ3UWvKi+NiWF3pBYX6uVoj+ch/rQF0J87J9ompl8ffOLUg61Uqy81F+9h5yDnW+SVSlggGDtDTYPsMJ4T/J6FtAK36wAneeQtSY6Vflxw1Gco93VuRP3XiTA93T2PYnXXzElkm16xbsnJKLAKbM6zJvvgSOF+lhP9OCegyFPK0PWqgXRlLujqZ5ukYvY0R
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR05MB5102.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(376002)(366004)(346002)(136003)(396003)(39860400002)(26005)(54906003)(52116002)(66946007)(66476007)(86362001)(316002)(83380400001)(66556008)(5660300002)(6506007)(956004)(2616005)(1076003)(16526019)(36756003)(8676002)(6486002)(478600001)(8936002)(2906002)(4326008)(107886003)(186003)(6512007)(54420400002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: xenrTaoI4XcxIwZSsOvgCQWJYqSja9tfzStufypoUefb7EJKLj97lU8lqxzSR3bSjykroniXgkTWnJ4E1potTMj3+aJctVImtnDjN/iFEUmgsbwYolVZpfs4gTbpw5Gsuy/aKn4t78tqXVasQaku2R1Li0ZWd0O8PdvgotXCvAvqTtbwU7zMSCgBS/hGC5B3t6tt47j97Xq/H3wEn4YRR15svrH3b3YXCV16F2Mi9a7U920XPQYkZHiuA+QbndxryqJTl1EQMFiVhgvXpJn/9blr51zlBuuOkM0s3J3vfgBYQ9Uc2uJ9Gl8wJ+4RhuUMwCpS7pp68DyWdZYOLYxdJreU4F0ZmfV8TU4+zlFQuroZOVEzOLkyjJVzNRQjcft5yzOukwpoAHWzvfFRgjzJV3EpTh7eAYzeQYVbJHPIAp6+T7643tNzj7p/Iky/yY+1nfi7PJDL1HC/1LNRu6PPL2KX1Jn8W4mHys0R9zH3BbU=
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5544e9d9-ce31-4231-812a-08d802a4f485
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 May 2020 01:17:57.5286
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 6KUs+ko7WAMROU3NhewfnMFV1pKGJWvrwWzsAbCupreE9Ic1ymXZydHsbuAxlQBxm5Ye5nTvFzQbPDdbPTpWEQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB4368
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Alex Vesker <valex@mellanox.com>

Adding this lock will allow writing steering entries without
locking the dr_domain and allow parallel insertion.

Signed-off-by: Alex Vesker <valex@mellanox.com>
Reviewed-by: Mark Bloch <markb@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 .../ethernet/mellanox/mlx5/core/steering/dr_send.c  | 13 +++++++++----
 .../ethernet/mellanox/mlx5/core/steering/dr_types.h |  1 +
 2 files changed, 10 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_send.c b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_send.c
index b8d97d44be7b..f421013b0b54 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_send.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_send.c
@@ -357,9 +357,11 @@ static int dr_postsend_icm_data(struct mlx5dr_domain *dmn,
 	u32 buff_offset;
 	int ret;
 
+	spin_lock(&send_ring->lock);
+
 	ret = dr_handle_pending_wc(dmn, send_ring);
 	if (ret)
-		return ret;
+		goto out_unlock;
 
 	if (send_info->write.length > dmn->info.max_inline_size) {
 		buff_offset = (send_ring->tx_head &
@@ -377,7 +379,9 @@ static int dr_postsend_icm_data(struct mlx5dr_domain *dmn,
 	dr_fill_data_segs(send_ring, send_info);
 	dr_post_send(send_ring->qp, send_info);
 
-	return 0;
+out_unlock:
+	spin_unlock(&send_ring->lock);
+	return ret;
 }
 
 static int dr_get_tbl_copy_details(struct mlx5dr_domain *dmn,
@@ -563,9 +567,7 @@ int mlx5dr_send_postsend_action(struct mlx5dr_domain *dmn,
 	send_info.remote_addr = action->rewrite.chunk->mr_addr;
 	send_info.rkey = action->rewrite.chunk->rkey;
 
-	mutex_lock(&dmn->mutex);
 	ret = dr_postsend_icm_data(dmn, &send_info);
-	mutex_unlock(&dmn->mutex);
 
 	return ret;
 }
@@ -886,6 +888,7 @@ int mlx5dr_send_ring_alloc(struct mlx5dr_domain *dmn)
 	init_attr.pdn = dmn->pdn;
 	init_attr.uar = dmn->uar;
 	init_attr.max_send_wr = QUEUE_SIZE;
+	spin_lock_init(&dmn->send_ring->lock);
 
 	dmn->send_ring->qp = dr_create_rc_qp(dmn->mdev, &init_attr);
 	if (!dmn->send_ring->qp)  {
@@ -990,7 +993,9 @@ int mlx5dr_send_ring_force_drain(struct mlx5dr_domain *dmn)
 			return ret;
 	}
 
+	spin_lock(&send_ring->lock);
 	ret = dr_handle_pending_wc(dmn, send_ring);
+	spin_unlock(&send_ring->lock);
 
 	return ret;
 }
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_types.h b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_types.h
index 984783238baa..b6061c639cb1 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_types.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_types.h
@@ -1043,6 +1043,7 @@ struct mlx5dr_send_ring {
 	struct ib_wc wc[MAX_SEND_CQE];
 	u8 sync_buff[MIN_READ_SYNC];
 	struct mlx5dr_mr *sync_mr;
+	spinlock_t lock; /* Protect the data path of the send ring */
 };
 
 int mlx5dr_send_ring_alloc(struct mlx5dr_domain *dmn);
-- 
2.26.2

