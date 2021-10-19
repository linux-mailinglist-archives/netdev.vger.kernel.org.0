Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 868474330C8
	for <lists+netdev@lfdr.de>; Tue, 19 Oct 2021 10:08:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234594AbhJSIKa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Oct 2021 04:10:30 -0400
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:54371 "EHLO
        out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234595AbhJSIK2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Oct 2021 04:10:28 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id D9E125C015C;
        Tue, 19 Oct 2021 04:08:15 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Tue, 19 Oct 2021 04:08:15 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm1; bh=dLhs0q0t+BsqvEdK5VFjN7LhlpVaGpeTLmjXpqpSUC0=; b=LSBzPnoy
        Mngzbgr7dUW06QebQQT2mX2CAnWgUtymBrDA4WBRE+QDK2TlBy2nYeC2d4YZLWXY
        Poo3wUFh8MmzrcIUz9Tlhxk2lST7Mvcg/vCD7HJ87JzEP1TJUq6hFmAvANAPBTEm
        pS5vAFGBf+4TFgkOO6dG+RyS2xm9CxFuRJkM8m5lTkL5FmS6ddgfsiJCV2XFMOE1
        GlgJQILvTZiAa63/J9eUZ5HbnsuBjoQ02nFtuA501LkBqGahtQEuaItZQ5CZlbxr
        tugKObi07Cyhb4Q3+G8YKk6Y8Ry0d5/HomtUiOmOA5T4IZMghpWFOTCTEIByZRgG
        ogJJDnArb7+wlA==
X-ME-Sender: <xms:73xuYXbDKZ-AFQKBDzmkU55D9XSyqtQsk5Nyx9EshfQ2bOss37q1wA>
    <xme:73xuYWZZIhc7GJ5L1-5OSbjnLkWsR7ljC9zKF6GXuxLQAqEHHdXgMS8_pRYUlnNDJ
    j02kdtUZ17gOh8>
X-ME-Received: <xmr:73xuYZ8MWosPxG-xhssjagT_BbAwUmvneeDRH1kGT8EorNo6-yB97ax6hOScqRQLAng9o3KkgL4s3PCtaa0k6O59utRMZRAi-MdZkMNAeL0>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvtddrvddvuddguddvhecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecunecujfgurhephffvufffkffojghfggfgsedtke
    ertdertddtnecuhfhrohhmpefkughoucfutghhihhmmhgvlhcuoehiughoshgthhesihgu
    ohhstghhrdhorhhgqeenucggtffrrghtthgvrhhnpeduteeiveffffevleekleejffekhf
    ekhefgtdfftefhledvjefggfehgfevjeekhfenucevlhhushhtvghrufhiiigvpedvnecu
    rfgrrhgrmhepmhgrihhlfhhrohhmpehiughoshgthhesihguohhstghhrdhorhhg
X-ME-Proxy: <xmx:73xuYdqlJQZEorPMvojSD7m_h_AqczHbqOuVN-LK4JbIfJo3_UqDnw>
    <xmx:73xuYSo-RZ52ihCKsrzymCz7XLODvw6MkMkjIvjclXJHf0xh0hSuIA>
    <xmx:73xuYTTQ89TQXegfcU14fHvBqHuxVdwJykeYPhXf6pbJmMHmhuy04g>
    <xmx:73xuYTfyBjp_DuMqaL3TA2X4MUSWitHdfMnLoBQLrfR6zQ9YqRtyVw>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 19 Oct 2021 04:08:13 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, jiri@nvidia.com,
        petrm@nvidia.com, jhs@mojatatu.com, xiyou.wangcong@gmail.com,
        mlxsw@nvidia.com, Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 6/9] mlxsw: spectrum_qdisc: Clean stats recursively when priomap changes
Date:   Tue, 19 Oct 2021 11:07:09 +0300
Message-Id: <20211019080712.705464-7-idosch@idosch.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211019080712.705464-1-idosch@idosch.org>
References: <20211019080712.705464-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Petr Machata <petrm@nvidia.com>

On Spectrum, there are no per-TC TX counters. Instead, mlxsw uses per-prio
counters and aggregates them according to the priomap. Therefore when
priomap changes, the counter base values need to be reset to reflect the
change. Previously, this was only done for the sole child qdisc, but a
following patch makes RED and TBF classful. Thus apply the request to the
whole sub-tree.

Signed-off-by: Petr Machata <petrm@nvidia.com>
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 .../ethernet/mellanox/mlxsw/spectrum_qdisc.c  | 37 +++++++++++++++----
 1 file changed, 29 insertions(+), 8 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_qdisc.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_qdisc.c
index 62ec3768c615..412394e02d2a 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_qdisc.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_qdisc.c
@@ -1169,6 +1169,31 @@ mlxsw_sp_qdisc_prio_check_params(struct mlxsw_sp_port *mlxsw_sp_port,
 	return __mlxsw_sp_qdisc_ets_check_params(p->bands);
 }
 
+static struct mlxsw_sp_qdisc *
+mlxsw_sp_qdisc_walk_cb_clean_stats(struct mlxsw_sp_qdisc *mlxsw_sp_qdisc,
+				   void *mlxsw_sp_port)
+{
+	u64 backlog;
+
+	if (mlxsw_sp_qdisc->ops) {
+		backlog = mlxsw_sp_qdisc->stats_base.backlog;
+		if (mlxsw_sp_qdisc->ops->clean_stats)
+			mlxsw_sp_qdisc->ops->clean_stats(mlxsw_sp_port,
+							 mlxsw_sp_qdisc);
+		mlxsw_sp_qdisc->stats_base.backlog = backlog;
+	}
+
+	return NULL;
+}
+
+static void
+mlxsw_sp_qdisc_tree_clean_stats(struct mlxsw_sp_port *mlxsw_sp_port,
+				struct mlxsw_sp_qdisc *mlxsw_sp_qdisc)
+{
+	mlxsw_sp_qdisc_walk(mlxsw_sp_qdisc, mlxsw_sp_qdisc_walk_cb_clean_stats,
+			    mlxsw_sp_port);
+}
+
 static int
 __mlxsw_sp_qdisc_ets_replace(struct mlxsw_sp_port *mlxsw_sp_port,
 			     struct mlxsw_sp_qdisc *mlxsw_sp_qdisc,
@@ -1181,7 +1206,7 @@ __mlxsw_sp_qdisc_ets_replace(struct mlxsw_sp_port *mlxsw_sp_port,
 	struct mlxsw_sp_qdisc_ets_band *ets_band;
 	struct mlxsw_sp_qdisc *child_qdisc;
 	u8 old_priomap, new_priomap;
-	int i, band, backlog;
+	int i, band;
 	int err;
 
 	if (!ets_data) {
@@ -1229,13 +1254,9 @@ __mlxsw_sp_qdisc_ets_replace(struct mlxsw_sp_port *mlxsw_sp_port,
 
 		ets_band->prio_bitmap = new_priomap;
 
-		if (old_priomap != new_priomap &&
-		    child_qdisc->ops && child_qdisc->ops->clean_stats) {
-			backlog = child_qdisc->stats_base.backlog;
-			child_qdisc->ops->clean_stats(mlxsw_sp_port,
-						      child_qdisc);
-			child_qdisc->stats_base.backlog = backlog;
-		}
+		if (old_priomap != new_priomap)
+			mlxsw_sp_qdisc_tree_clean_stats(mlxsw_sp_port,
+							child_qdisc);
 
 		err = mlxsw_sp_qdisc_future_fifo_replace(mlxsw_sp_port, handle,
 							 band, child_qdisc);
-- 
2.31.1

