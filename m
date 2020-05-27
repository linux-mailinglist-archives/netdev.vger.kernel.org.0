Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 184261E49D2
	for <lists+netdev@lfdr.de>; Wed, 27 May 2020 18:23:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390959AbgE0QXH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 May 2020 12:23:07 -0400
Received: from mail-am6eur05on2085.outbound.protection.outlook.com ([40.107.22.85]:6062
        "EHLO EUR05-AM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2389867AbgE0QXG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 27 May 2020 12:23:06 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=O5SmOO5uS1zLzrpyP/bihpkn+EzZVtNq1VTXBUhkgKbRfrX/cFiupKNkpAYNONmGt5oIron3x0oRQEayMuObnMwpqax+p4W1kgc48desRo5j/7fVt1nQvamO4UmVjLHq5NXRhNGBNDkd1k0f7n43mHnqif+VIBIFom5TN4SKe76skLSekXquqsg4+AAEbqDcc6Xk1v5EFBvDLWcahRVAVZu+L5aybA0L3y2n39RmWCy89hB4tHv8pP/CHbW7nXQu2rt5JOVpyhHzPCaL0cLs2Twc0vrzepI4e7DmMtOPDu2wFmIjNENsWJcZAcLdF37XfhrBPGsoVS7Ih18P0PG+0Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qj1eiSik3vxTxYesZrsKuXlzr0f3YzXCeXcFtTHsV1g=;
 b=kEz/WTxsdECQDgFVr8yvbL8yNqqMEf6lai2C0NWTOolJUUKyszkaNY59YdkP3IFxHM6lhv46X8SeiLve2bwSOi77ReAWIdJP3Y7V3WKPV1Zimkz28+GXm92vVs+WOzCZe5AJzwt7gLzhZLYcZEeCw6PkX5svgGAvskPwOKKb5FeKPdONOVVEbtzGIjizrsxXx1aJYVN7XWs6Wx0uTLmmYewQVwMiYMAs5aeev+kna6VzjIsIjcnAOaWWZE1JNn1C2JQMI/qZx9RfRC/Lr20WbUcOmBWh2Mtugqi8AB8Dfb/fhD0DfiIlUAuUHoM9Qt5OWInucAqzGU1j4Ob+4o40ag==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qj1eiSik3vxTxYesZrsKuXlzr0f3YzXCeXcFtTHsV1g=;
 b=A9DcielwsgoO1nYlGtOimmcFQ+1ODOwFasz7oCEjhhcM7IIwZzQ1MaaBA516TogaMptWgL+T0sQlSxIwv5dgUQmToEsyD/flofhu3THh9UVitoysMCXpVos9ddqvoqBQZjrhPwiDNSyrtC7zW8TYvvt+tvcnYHJCi0XXTPXK8mg=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=mellanox.com;
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (2603:10a6:803:5e::23)
 by VI1PR05MB7039.eurprd05.prod.outlook.com (2603:10a6:800:186::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3021.23; Wed, 27 May
 2020 16:22:28 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::2405:4594:97a:13c]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::2405:4594:97a:13c%2]) with mapi id 15.20.3021.029; Wed, 27 May 2020
 16:22:28 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>, kuba@kernel.org
Cc:     netdev@vger.kernel.org, Alex Vesker <valex@mellanox.com>,
        Mark Bloch <markb@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net-next V2 14/15] net/mlx5: DR, Add a spinlock to protect the send ring
Date:   Wed, 27 May 2020 09:21:38 -0700
Message-Id: <20200527162139.333643-15-saeedm@mellanox.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200527162139.333643-1-saeedm@mellanox.com>
References: <20200527162139.333643-1-saeedm@mellanox.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BYAPR02CA0071.namprd02.prod.outlook.com
 (2603:10b6:a03:54::48) To VI1PR05MB5102.eurprd05.prod.outlook.com
 (2603:10a6:803:5e::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from smtp.office365.com (73.15.39.150) by BYAPR02CA0071.namprd02.prod.outlook.com (2603:10b6:a03:54::48) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3045.18 via Frontend Transport; Wed, 27 May 2020 16:22:27 +0000
X-Mailer: git-send-email 2.26.2
X-Originating-IP: [73.15.39.150]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 77e84865-f71d-4e79-2bc4-08d8025a2640
X-MS-TrafficTypeDiagnostic: VI1PR05MB7039:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR05MB70396D056EA5F8BFBC693CA0BEB10@VI1PR05MB7039.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:612;
X-Forefront-PRVS: 04163EF38A
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: iQ5JHzgArRNdWnYgElibB65mURRzjPVXCMcy/k5opFsxmG7F4vplYI+RSgYd579YXzuEkKpe8FChnI7O4M53Dl6TBvNAmdgUmAQG/spQP7T2iMeL5j5rNnKarehT+GYgkC8Swakw5Zm8sBet8kI8IeUh09PEDZG7GUyR/nAFg9pnU/vY5hqJSeppJKV4536D72hzvHaM0Sb8vhARWyvkGdSjHMqMNfBTTkpLUaJeA2U/JWnCuVu73A6LVOmJQGiklb7P8rWJczVHq1JputTdiuHkfgHuABdoRdTRKJImeihDFVlYoMV0Y3KI90jNWKJ+QbaOlYt/Dm9qieSoWx1SMlTiQ75p9Xlx5hxG1yRLAALwKV3HLxgzXuZGrDYVuvHN
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR05MB5102.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(346002)(376002)(39860400002)(396003)(136003)(366004)(956004)(36756003)(6486002)(54906003)(478600001)(107886003)(6512007)(86362001)(83380400001)(316002)(5660300002)(26005)(16526019)(6506007)(66476007)(66946007)(66556008)(186003)(52116002)(1076003)(2616005)(4326008)(6666004)(2906002)(8676002)(8936002)(54420400002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: DHn1Kae3wRqHoZfSsVAfLB1PSF2ZUgFk7BkTjSge3HeMhL1BxlcAIyS/+QsT13tYM46QemHMvoUAhnkb25vEJ53gcy23J9rIDbeOavSS/bZpccBDalww4uLbpZUMm5lLkYjvAOGRALQWazSRt9PB4sTHKyGCmY1t3ZFC6LDnk0n9QAHiB8/DFCbflsY82v/IWJhmfMpGU45MAwuj+iQHNeCixr8/qRIi5JfFfF+wasGHIZYVgmADBrzyI4eTz2+NNFl/QTWwKPHcNhk3eLaQ89YZh39tYL7JTtgXpKDry0ybgkBOV1G0t8dkQmhH8JWfNePoFgcmiymBSR2vLzvBY8x35mv0oTxy3GV/eMY/x9qpfA2OhB/HF43PxpbjnO2VSYJkyDzoiPnh0luGakseJFHxkVCzVXRbK8apL8QA8FnNX2fbS64ZzNms2DD4jyzIseqKBfhrSH0XcrzeM1Aixr4wzI/mZ8Jdg8hveYf5S/Y=
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 77e84865-f71d-4e79-2bc4-08d8025a2640
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 May 2020 16:22:28.7065
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: N1PuvJiHacHQ9Wn4T6wWrmh+93H/MkoEmuRQL5CcIWB1eYwFNF8c6ShQMy6SiTr+BoHaWdIU2ce9iN1l4BIHkA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB7039
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

