Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1C23D1E3508
	for <lists+netdev@lfdr.de>; Wed, 27 May 2020 03:51:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728442AbgE0Buo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 May 2020 21:50:44 -0400
Received: from mail-eopbgr40067.outbound.protection.outlook.com ([40.107.4.67]:57088
        "EHLO EUR03-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728223AbgE0Buk (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 26 May 2020 21:50:40 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iq0NWQoP4AXHgzNN2NdkrdHn5B1Fld8e3r8GjMB/Oh4AU63qXZkbSvQYcnirZtKuQAZT4ODQElOyKbmnmAK2eCc9ryzzR0Noacxr1OUMPn5Rd1wg+tM90LZdPKE8YkL8DyK9ohks93xmU6D3qEd2iQcyJotwl17FJgamAcjegEpteAN4E9vbAIiptpSfGnQ/B16KVO7SWjeWIA5+G83swcZXIYWItfNO3+k0ApMEeez5+2/Hx33Qu35zrzhqMIZeJXmJ+U5JeDuK+roox3tqdxaxlg36IHzHKJz+n9qd3EaqlIAH3F6uV2I+ltO/JPQn4JIaRIBDEl9rTBZgClP0kA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qj1eiSik3vxTxYesZrsKuXlzr0f3YzXCeXcFtTHsV1g=;
 b=fa/ALaO3W+Y/Moz1VS+f3LNx2A5YDHpmyRDkQ+022yWBifbm3KRm0RTW+f0zjdaACJumabAHjLcJp60xLiBY3IifzCGYyyXZXflcnRZ7M1LxtPjQwYW1U1SMpVCebu7chA6DDbAgsxG5hTFsMz+kXcblx8POtTzg2spwl8Gyt/sh37mGX1jpdQBPjbXXHEo1NjAhj9ZzCFn/Y0y0pZCNpv6aW/H4wknseb9PNmEsuN8C+Rp4R3pPmtAhr/Ov3lZXFPddgC7OivRLlB31sRmQ3fVnEAqpIU+Fw+nm/itgyDTh8nCMwRn2H41qsRMTS+28Ux/putZUqffYWT05UwY9Aw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qj1eiSik3vxTxYesZrsKuXlzr0f3YzXCeXcFtTHsV1g=;
 b=BqIp9cfU4hR/6VN75u8g2vS5dthlJWdQycuG9L8/QEdeObVPheuuHm7elYiX0h64u3V/LopbDOyV0AZi5zHAROzjvJ4BQpdc4JlMFm4pKjZxcUiUF7bDPxsVzEVLqs6nEBwAUij0rpgH8LOyYBjBAIxTZTwXwXeNN5DLP13gaaU=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=mellanox.com;
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (2603:10a6:803:5e::23)
 by VI1PR05MB4704.eurprd05.prod.outlook.com (2603:10a6:802:68::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3021.27; Wed, 27 May
 2020 01:50:28 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::2405:4594:97a:13c]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::2405:4594:97a:13c%2]) with mapi id 15.20.3021.029; Wed, 27 May 2020
 01:50:27 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>, kuba@kernel.org
Cc:     netdev@vger.kernel.org, Alex Vesker <valex@mellanox.com>,
        Mark Bloch <markb@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net-next 15/16] net/mlx5: DR, Add a spinlock to protect the send ring
Date:   Tue, 26 May 2020 18:49:23 -0700
Message-Id: <20200527014924.278327-16-saeedm@mellanox.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200527014924.278327-1-saeedm@mellanox.com>
References: <20200527014924.278327-1-saeedm@mellanox.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BYAPR11CA0061.namprd11.prod.outlook.com
 (2603:10b6:a03:80::38) To VI1PR05MB5102.eurprd05.prod.outlook.com
 (2603:10a6:803:5e::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from smtp.office365.com (73.15.39.150) by BYAPR11CA0061.namprd11.prod.outlook.com (2603:10b6:a03:80::38) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3021.24 via Frontend Transport; Wed, 27 May 2020 01:50:25 +0000
X-Mailer: git-send-email 2.26.2
X-Originating-IP: [73.15.39.150]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 404dab16-fe4d-420a-dc65-08d801e05466
X-MS-TrafficTypeDiagnostic: VI1PR05MB4704:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR05MB470492C010D2A4F7F260E586BEB10@VI1PR05MB4704.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:612;
X-Forefront-PRVS: 04163EF38A
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: hQLhmt8IO/CgKbShARSS9UCUFeOS7l8Ps5dmbYVNu4zfCaxsFoCC8PZeS6wZSF7zvevX1+vMtLFokTgTpqIzHwjxrMK0m/HbQkAaC/cLdngUOenwXU0FClcGq14AZF4V/CXd+TrDF25grhiGOdZq0/3DAEHtl++aBxGLr+2L7bUIlUYPCRHgENR31bPW+u4GkB5nnPza5zU3MXElxrLaIqvfKPe+0Fy2Qc948pe9ESSocPHwxZZlTZmDAQYK4oYOpa95VU8l1+Llp7HOQNczfETzVTJ91+ADNF2KoRxhNNIpekEV6SWr2edKc1L/UrXALEd6aGtBR7RT4E3qNpKNt/g8YxUqMv3xB34Mq9lZV2igVtfInEh34UuCMMzrBk9x
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR05MB5102.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(346002)(376002)(39850400004)(396003)(136003)(366004)(2906002)(2616005)(66556008)(26005)(66476007)(66946007)(956004)(6506007)(6512007)(52116002)(478600001)(36756003)(316002)(186003)(4326008)(16526019)(54906003)(107886003)(1076003)(86362001)(8936002)(8676002)(5660300002)(83380400001)(6486002)(54420400002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: Pb0bmLPdYvLENL1MaMr4Qn3PNYXq+EkDitsVr4uoJPSpVKm6tuvPBfhxQytv0kVO7UfsRJG8aM7CtVyFMGdlxH7KSeoOhvRQqqGE7afJDP4k1L4CazXNdWlM/NjpdcLUIWztIrWdxpw11S6rgxKVkj60sgtK3TJW8I06oQbYMcN5Quz/A+MtGJSNUHoTmev3UjZeY3aOa186S/2TEuxF4jY8PtLvCffW1jirmTArndd9v/MY2BVd7/Q2w8N5n8p/e87TlWJtFD+d8gJDVR0tjkKC5nJbOFi7wdWMgOgvNX8uagKixEYCtnPgElcDgMZD23gyylP/bXbAMmfddEDSMRfznU36dxExHVRTgXNU7j6E3KHoBUjk+iEDtXh9hBrq6A/mv1fgKDa75TwEnfAt0zGjj5NkgARmq519W2Fh9sxUoSLwP8vwHShe7fcBmAenPdalvMvBwVNE2je6sMD0+7WTTrNVLd41LWQpyzW2T4s=
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 404dab16-fe4d-420a-dc65-08d801e05466
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 May 2020 01:50:27.5433
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: BPZU+KFs13LJl808Lo6tbhJ5S2SVkAill1pf8gSr4UhUREDr5epiSQsaxjCD4XMDf2uakjVEGrXULVWIhefE8Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB4704
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

