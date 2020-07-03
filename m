Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 46C74213298
	for <lists+netdev@lfdr.de>; Fri,  3 Jul 2020 06:09:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726139AbgGCEJc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Jul 2020 00:09:32 -0400
Received: from mail-eopbgr80059.outbound.protection.outlook.com ([40.107.8.59]:59118
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725294AbgGCEJb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 3 Jul 2020 00:09:31 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TuND2T4HjIw2a86FFktHzA4OcC7+UfL+iZ8LRD/ptaZuR8485hsRzM+mDW1ckNrmclNUSbE6vhEceRSAYz9nwqqhyQlZ+E4pMHAAM5vrn1aneJrs0w+KBF4qBvrgb/jV1O4n0W3DdlX3ZALfhyCK9GQ9sXQJ1SdmZsnahkpBinw+xVyiKXDWhVNyrEvjMCluCxqX43M34sPBSCjazp9a/BqUGeV09Wgl232WdmG9+rd9tB5TJ8nseUcHuOHfKpsC8zoUY71DKu8JkrnCDSEbpnSQwxFdQKUtzbXzKnYXxBynt970atgW3nRq5Fv+doBe3vHqgezZokZBA5esb7gyCw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oJriQAZqrXirNVjZg2tmSril3yBmZ2DXUDW4kjpJGRI=;
 b=oWZ3dAGYwAkyh9/ndZulLxMpOAzV+9BKBkTdhWYkjBenfQshJv/Id6mP7TGenlC7v30k+XVbljeMNx0BQHPHawStutTLrhTlD3g4yCx7m8shJL+0H1vofRefdU24AGys+jbW7hSm8o02J8fnCrid04loFVWHAO51grocAzsyZOYt/60tz1EIcS7I+ZEAUEifq8RVkJLNjdcc78KACLe22DaZxXQYIKiOq9YkHjK46xDdqpcgGf6DPHqKdw9tqm0PucivsdiJJsSBU/NNENiTU/GsF0GzjKsImFF83gg+Rvf4JKbFkMZ3v+bz8vPK69m1L4CWaOhPJX/V0pG3F9Umsg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oJriQAZqrXirNVjZg2tmSril3yBmZ2DXUDW4kjpJGRI=;
 b=JTX1XgwYQoHKHx9SPFGfEKbP3dY6jWIzkZfr3MSgijFZjpnuqN9MGCARrRWyY6zrD6y7DtQHBpkkHP7TmpcROeoQG1yPSkFGMpnS8GEh0d9gpPOYwF361qbl6MH+EK92d14kv/nt1rOhM0Rx3y8aKh5OyB4TVC6yma7AUffC6L0=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=mellanox.com;
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (2603:10a6:803:5e::23)
 by VI1PR05MB5534.eurprd05.prod.outlook.com (2603:10a6:803:9c::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3153.28; Fri, 3 Jul
 2020 04:09:16 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::2405:4594:97a:13c]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::2405:4594:97a:13c%2]) with mapi id 15.20.3153.023; Fri, 3 Jul 2020
 04:09:16 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Aya Levin <ayal@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net-next 06/12] net/mlx5e: Add helper to get RQ WQE's head
Date:   Thu,  2 Jul 2020 21:08:26 -0700
Message-Id: <20200703040832.670860-7-saeedm@mellanox.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200703040832.670860-1-saeedm@mellanox.com>
References: <20200703040832.670860-1-saeedm@mellanox.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BYAPR01CA0065.prod.exchangelabs.com (2603:10b6:a03:94::42)
 To VI1PR05MB5102.eurprd05.prod.outlook.com (2603:10a6:803:5e::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from smtp.office365.com (73.15.39.150) by BYAPR01CA0065.prod.exchangelabs.com (2603:10b6:a03:94::42) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3153.24 via Frontend Transport; Fri, 3 Jul 2020 04:09:14 +0000
X-Mailer: git-send-email 2.26.2
X-Originating-IP: [73.15.39.150]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: f3b14d34-3b02-49cb-91a6-08d81f06d9db
X-MS-TrafficTypeDiagnostic: VI1PR05MB5534:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR05MB5534818BBA6F2679403BBC15BE6A0@VI1PR05MB5534.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2089;
X-Forefront-PRVS: 045315E1EE
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: a2EeJPEIUJSzD7FF9hj89TYQv+2HTSraTeeXkV1ZCPr2xzlLwEFSxNpjdwmua+SC8xdC6O1JwZDWGRqeKyQ1cXlm8mNe0xAwvz+GJY2qNVbAPV6uvTOopLfokJhceEu6Ve9S2pBYRZ/fqIBZe5Iv+WLcPnwOnE/3sw2AKZYfOYaGJ07EXhIewkjA9QP7K16PS6bWHQSR2Hgn94ILj8EDWuE9cvg487SHPk8CxLxmvQEa91rdaYpEXsOKtZIJJobEylyAjwxFuxxAVz1SYeN1PictJwN5sI60EXJd13ULglyISnSjpOo63bdvEJy2hWaELQrZ/ivj/eWgf6hdUvgpnIIXRRf9yDvlLY1Go4GPBz1lCSCFvEnabW6sPBZ4jiD0
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR05MB5102.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(346002)(366004)(39860400002)(396003)(136003)(376002)(6486002)(107886003)(26005)(16526019)(186003)(2906002)(1076003)(6512007)(83380400001)(86362001)(66556008)(66476007)(36756003)(66946007)(956004)(2616005)(5660300002)(6666004)(478600001)(4326008)(8936002)(6506007)(8676002)(52116002)(110136005)(54906003)(316002)(54420400002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: 5TH8G4a/0hDvjoGx5exF8pbcvZYvcqbR64jppEZKo7Xr/aAm62CzhG2uQ+FLXCL55utlEaYNj1RHtTdZPgC/gJH2M9NmzyquDKm9l2NuEc72lL3/2hRpMDHYee+PLs4ScGDGdT4IPKWmAerKXqXv7GKUKcVdWbxfOFiph2hkf6DRbg1yQxkTPwk0sdpI2y5Fu1Kc18lF0/k4ZMG0JAd66ILAcecZhcWqT+1KQhl11xib+bdfwLC8NOTwBxUT2iy9dppPJCk5ILSyuPmawigz+u2O8McHG6E01jLfWcMIpVq4WfONNsR6ql63hBGQl0SfKB3KLpGB3DNqkwtxAasiGgbsSDgjDfKduzp0Hk0Tt2YehnMSc+UjU0YeMJVsxOEwXn3eEDl8utTmWUDP4FBmJuF5t3whQMwUSpcM/zMNviJYlWYSuoec3y0s6VRgPCXZBZb4NmW64xc+jwk2fR/gG0weY9fmT4YAyzax3hk0oEo=
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f3b14d34-3b02-49cb-91a6-08d81f06d9db
X-MS-Exchange-CrossTenant-AuthSource: VI1PR05MB5102.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Jul 2020 04:09:16.0134
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: isX4HL+PWU5IwiNJfeDxzA+7J8mVkskcN487qPi4w9lTg1iNN6tECbdjXptNXKhwpPdbC56jhVqvdzv/o3XPIg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB5534
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Aya Levin <ayal@mellanox.com>

Add helper which retrieves the RQ WQE's head. Use this helper in RX
reporter diagnose callback.

Signed-off-by: Aya Levin <ayal@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 .../net/ethernet/mellanox/mlx5/core/en/reporter_rx.c   |  5 +----
 drivers/net/ethernet/mellanox/mlx5/core/en/txrx.h      | 10 ++++++++++
 drivers/net/ethernet/mellanox/mlx5/core/wq.h           |  4 ++++
 3 files changed, 15 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/reporter_rx.c b/drivers/net/ethernet/mellanox/mlx5/core/en/reporter_rx.c
index bfdf9c185f02..f0e639ef4ec5 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/reporter_rx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/reporter_rx.c
@@ -181,7 +181,6 @@ static int mlx5e_rx_reporter_build_diagnose_output(struct mlx5e_rq *rq,
 						   struct devlink_fmsg *fmsg)
 {
 	struct mlx5e_priv *priv = rq->channel->priv;
-	struct mlx5e_params *params;
 	struct mlx5e_icosq *icosq;
 	u8 icosq_hw_state;
 	int wqes_sz;
@@ -189,7 +188,6 @@ static int mlx5e_rx_reporter_build_diagnose_output(struct mlx5e_rq *rq,
 	u16 wq_head;
 	int err;
 
-	params = &priv->channels.params;
 	icosq = &rq->channel->icosq;
 	err = mlx5e_query_rq_state(priv->mdev, rq->rqn, &hw_state);
 	if (err)
@@ -200,8 +198,7 @@ static int mlx5e_rx_reporter_build_diagnose_output(struct mlx5e_rq *rq,
 		return err;
 
 	wqes_sz = mlx5e_rqwq_get_cur_sz(rq);
-	wq_head = params->rq_wq_type == MLX5_WQ_TYPE_LINKED_LIST_STRIDING_RQ ?
-		  rq->mpwqe.wq.head : mlx5_wq_cyc_get_head(&rq->wqe.wq);
+	wq_head = mlx5e_rqwq_get_head(rq);
 
 	err = devlink_fmsg_obj_nest_start(fmsg);
 	if (err)
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/txrx.h b/drivers/net/ethernet/mellanox/mlx5/core/en/txrx.h
index ed9e0b8a6f9e..d787e8fc2e99 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/txrx.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/txrx.h
@@ -304,6 +304,16 @@ static inline u32 mlx5e_rqwq_get_cur_sz(struct mlx5e_rq *rq)
 	}
 }
 
+static inline u16 mlx5e_rqwq_get_head(struct mlx5e_rq *rq)
+{
+	switch (rq->wq_type) {
+	case MLX5_WQ_TYPE_LINKED_LIST_STRIDING_RQ:
+		return mlx5_wq_ll_get_head(&rq->mpwqe.wq);
+	default:
+		return mlx5_wq_cyc_get_head(&rq->wqe.wq);
+	}
+}
+
 /* SW parser related functions */
 
 struct mlx5e_swp_spec {
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/wq.h b/drivers/net/ethernet/mellanox/mlx5/core/wq.h
index 4cadc336593f..27dece35df7e 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/wq.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/wq.h
@@ -290,4 +290,8 @@ static inline void mlx5_wq_ll_update_db_record(struct mlx5_wq_ll *wq)
 	*wq->db = cpu_to_be32(wq->wqe_ctr);
 }
 
+static inline u16 mlx5_wq_ll_get_head(struct mlx5_wq_ll *wq)
+{
+	return wq->head;
+}
 #endif /* __MLX5_WQ_H__ */
-- 
2.26.2

