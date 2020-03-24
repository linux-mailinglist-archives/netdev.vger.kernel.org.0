Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CC5DD191C53
	for <lists+netdev@lfdr.de>; Tue, 24 Mar 2020 22:53:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728374AbgCXVxd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Mar 2020 17:53:33 -0400
Received: from mail-vi1eur05on2072.outbound.protection.outlook.com ([40.107.21.72]:6069
        "EHLO EUR05-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728227AbgCXVxd (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 24 Mar 2020 17:53:33 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EhlFoeMLijh/Ie7GGKYwO6+scREHl9OFyvqJU3sN2AyHEUmrLhCiZhftBdUnjADU7EIa29f8RgfSeD4e+JsfPxTcqujOKt6u/eaU3gICny5pglRYCvdyAulekoE+dGsJHMA7IPJk6hAOfGuQ5oiYrVzLh+UvTgxr+s8p7H6WO0QIekLa33E7Tk+ELqAnrql85qc7erz5E3wz8ILAKgpngotKmtH5WCOSP99sisiTWU3kbMLKSD3W4MGQr7FX2PnG49UvTfz+0inuAOYxrwdIR0iVP66nJ2qBvhOE4P1TCtNtX25gD7ZKaFzT8YCe0yeKSRKyts1qBDhL3SlIra4+9g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=13OnoSYXt8E9PbkKAg3QSl1OTkJdesyX1N4zERjnB8g=;
 b=Y33vhSnE5r+ygKUbwCgcynYCJzhrXXTjbLbTgO4oRiuU456Ak/3k7WCC9EMEV9NhqvFybjKhC32R/Z5SMXs+mV0mJeBoNpYY4Jc8e8e11KzTD7q4S0tVp4tcBnHBhhX2R+k9eFq3zf74DW7OslFRfY8ubNQMb86qdatxqY9wmVu6UPZKsgg5CcKNbKOS7deCcicS4QrgMyh2+c9cNeAw4fSwqbCHFv8aWcBZO0wjgz2sRV8Dnq+NYqDPahiDcRTca/w+NQCZvZLV7GHHC0IqfmHF13y9dwmT9NfHFMMlG6nRoWlIqzabPb4hbRdXYvL5I6RsPNNmlt25rAsr+yiSXQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=13OnoSYXt8E9PbkKAg3QSl1OTkJdesyX1N4zERjnB8g=;
 b=Z39DO0gNyVE7Ush5nMSM5q0lmtRu2PVdYShmMQ0p+8K0uN5fAYFL1+y8Qmp8pdwbqvkX7zeWgp2eZBnkr8fSnB7I1YBtY44n628DQbqUZzS15QcSJ/zYds5iKKyUeFXDxNd+0qTWt0Jr51TAeJyyv/po2APjkRKX30hu6W/yi6A=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (20.177.51.151) by
 VI1PR05MB4973.eurprd05.prod.outlook.com (20.177.52.18) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2835.20; Tue, 24 Mar 2020 21:53:28 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::8cea:6c66:19fe:fbc2]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::8cea:6c66:19fe:fbc2%7]) with mapi id 15.20.2835.023; Tue, 24 Mar 2020
 21:53:28 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>
Cc:     netdev@vger.kernel.org, kuba@kernel.org,
        Aya Levin <ayal@mellanox.com>,
        Tariq Toukan <tariqt@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net 4/5] net/mlx5e: Fix ICOSQ recovery flow with Striding RQ
Date:   Tue, 24 Mar 2020 14:52:56 -0700
Message-Id: <20200324215257.150911-5-saeedm@mellanox.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200324215257.150911-1-saeedm@mellanox.com>
References: <20200324215257.150911-1-saeedm@mellanox.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BYAPR06CA0049.namprd06.prod.outlook.com
 (2603:10b6:a03:14b::26) To VI1PR05MB5102.eurprd05.prod.outlook.com
 (2603:10a6:803:5e::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from smtp.office365.com (73.15.39.150) by BYAPR06CA0049.namprd06.prod.outlook.com (2603:10b6:a03:14b::26) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2835.19 via Frontend Transport; Tue, 24 Mar 2020 21:53:26 +0000
X-Mailer: git-send-email 2.25.1
X-Originating-IP: [73.15.39.150]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: baf51da8-bade-4e8a-2bf3-08d7d03dc92c
X-MS-TrafficTypeDiagnostic: VI1PR05MB4973:|VI1PR05MB4973:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR05MB4973BC43DB4D0B373431451FBEF10@VI1PR05MB4973.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5797;
X-Forefront-PRVS: 03524FBD26
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(4636009)(376002)(136003)(39860400002)(346002)(366004)(396003)(6666004)(107886003)(54906003)(8936002)(2616005)(16526019)(8676002)(81156014)(86362001)(956004)(36756003)(6486002)(81166006)(186003)(66946007)(6512007)(52116002)(2906002)(5660300002)(6916009)(66476007)(66556008)(316002)(26005)(6506007)(478600001)(4326008)(1076003)(54420400002);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR05MB4973;H:VI1PR05MB5102.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;
Received-SPF: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: SpK0VtDHJj+9XhF4wzKRL6Y+ZjGaOIB0lc2JBXPSoHO8Y/deZqru2R6O2AWgOKa0d2zxI07N/Sq4TSCzdhmWw6O3IjyW0sRxgNhtlF/tM3f1pu4TS3v9dezXS7n9mCy1EY/is3vgcOHhLhErq7QMjGnuEjAOd70OodQSbQR/XpQeCcJEoVo5YXQbGWx/5Y1JkuWxH/aV+Mn2aA0vV8g5cID6617tUS4EEIMp3Ep+zMuT/jp2UJWeDsyYDS+SPZoERl6XEoLUyMed4VEWMdgr8K55XybNrLCLpCNWPwgnuYIaNxMSh9a246e/iCEZyvgoX9qlyk1+vkOMj6n9K6EQjvPjUSw/9aZC4W6RKV9yttWTAFEm4F6dUza8cLHs2DIuhL+2eSWS8oq7lKmlTDw5OapEF2qIat9ZTr8AEKZ91dImbgGV2f99Io5ix0aoW1PfllQoTUP9e0gzveWChH4Yn4NkAiAuqrmQa7jEFFaMifp6BSMWVCXIOHSTR575u4R/bcBzAK2JsTQuQxEUeyTAjW3WWQy3+6FHOxnu3LGTepk=
X-MS-Exchange-AntiSpam-MessageData: Ff39shP8M9WxeZJ+OBK8nyMSQWAfx4syAnJlvxfaQV0kNHIETPc9Ll8UQ/x7M6PdJGtAVtOyESvCK8CCWpYsQg1NoONfpPyCW26ojqCP6Dq/c3v7/SWZSyKlDnxS1jPxlWbCYZznafvcqoQ9FXGCmQ==
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: baf51da8-bade-4e8a-2bf3-08d7d03dc92c
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Mar 2020 21:53:28.4721
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: DM9w4Bwe+ZDuIlZoHIbp71qpkOOJyZE0hHTTOFonHrRBUoNCP9LQR6P7ArLk1wbVz0WyN8ENznQ6xOkoKNExvw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB4973
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Aya Levin <ayal@mellanox.com>

In striding RQ mode, the buffers of an RX WQE are first
prepared and posted to the HW using a UMR WQEs via the ICOSQ.
We maintain the state of these in-progress WQEs in the RQ
SW struct.

In the flow of ICOSQ recovery, the corresponding RQ is not
in error state, hence:

- The buffers of the in-progress WQEs must be released
  and the RQ metadata should reflect it.
- Existing RX WQEs in the RQ should not be affected.

For this, wrap the dealloc of the in-progress WQEs in
a function, and use it in the ICOSQ recovery flow
instead of mlx5e_free_rx_descs().

Fixes: be5323c8379f ("net/mlx5e: Report and recover from CQE error on ICOSQ")
Signed-off-by: Aya Levin <ayal@mellanox.com>
Reviewed-by: Tariq Toukan <tariqt@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en.h  |  1 +
 .../mellanox/mlx5/core/en/reporter_rx.c       |  2 +-
 .../net/ethernet/mellanox/mlx5/core/en_main.c | 31 ++++++++++++++-----
 3 files changed, 26 insertions(+), 8 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en.h b/drivers/net/ethernet/mellanox/mlx5/core/en.h
index 571ac5976549..c9606b8ab6ef 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en.h
@@ -1060,6 +1060,7 @@ int mlx5e_modify_rq_state(struct mlx5e_rq *rq, int curr_state, int next_state);
 void mlx5e_activate_rq(struct mlx5e_rq *rq);
 void mlx5e_deactivate_rq(struct mlx5e_rq *rq);
 void mlx5e_free_rx_descs(struct mlx5e_rq *rq);
+void mlx5e_free_rx_in_progress_descs(struct mlx5e_rq *rq);
 void mlx5e_activate_icosq(struct mlx5e_icosq *icosq);
 void mlx5e_deactivate_icosq(struct mlx5e_icosq *icosq);
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/reporter_rx.c b/drivers/net/ethernet/mellanox/mlx5/core/en/reporter_rx.c
index 6c72b592315b..a01e2de2488f 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/reporter_rx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/reporter_rx.c
@@ -90,7 +90,7 @@ static int mlx5e_rx_reporter_err_icosq_cqe_recover(void *ctx)
 		goto out;
 
 	mlx5e_reset_icosq_cc_pc(icosq);
-	mlx5e_free_rx_descs(rq);
+	mlx5e_free_rx_in_progress_descs(rq);
 	clear_bit(MLX5E_SQ_STATE_RECOVERING, &icosq->state);
 	mlx5e_activate_icosq(icosq);
 	mlx5e_activate_rq(rq);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
index 21de4764d4c0..4ef3dc79f73c 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -813,6 +813,29 @@ int mlx5e_wait_for_min_rx_wqes(struct mlx5e_rq *rq, int wait_time)
 	return -ETIMEDOUT;
 }
 
+void mlx5e_free_rx_in_progress_descs(struct mlx5e_rq *rq)
+{
+	struct mlx5_wq_ll *wq;
+	u16 head;
+	int i;
+
+	if (rq->wq_type != MLX5_WQ_TYPE_LINKED_LIST_STRIDING_RQ)
+		return;
+
+	wq = &rq->mpwqe.wq;
+	head = wq->head;
+
+	/* Outstanding UMR WQEs (in progress) start at wq->head */
+	for (i = 0; i < rq->mpwqe.umr_in_progress; i++) {
+		rq->dealloc_wqe(rq, head);
+		head = mlx5_wq_ll_get_wqe_next_ix(wq, head);
+	}
+
+	rq->mpwqe.actual_wq_head = wq->head;
+	rq->mpwqe.umr_in_progress = 0;
+	rq->mpwqe.umr_completed = 0;
+}
+
 void mlx5e_free_rx_descs(struct mlx5e_rq *rq)
 {
 	__be16 wqe_ix_be;
@@ -820,14 +843,8 @@ void mlx5e_free_rx_descs(struct mlx5e_rq *rq)
 
 	if (rq->wq_type == MLX5_WQ_TYPE_LINKED_LIST_STRIDING_RQ) {
 		struct mlx5_wq_ll *wq = &rq->mpwqe.wq;
-		u16 head = wq->head;
-		int i;
 
-		/* Outstanding UMR WQEs (in progress) start at wq->head */
-		for (i = 0; i < rq->mpwqe.umr_in_progress; i++) {
-			rq->dealloc_wqe(rq, head);
-			head = mlx5_wq_ll_get_wqe_next_ix(wq, head);
-		}
+		mlx5e_free_rx_in_progress_descs(rq);
 
 		while (!mlx5_wq_ll_is_empty(wq)) {
 			struct mlx5e_rx_wqe_ll *wqe;
-- 
2.25.1

