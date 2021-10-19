Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 22E354330CA
	for <lists+netdev@lfdr.de>; Tue, 19 Oct 2021 10:08:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234638AbhJSIKg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Oct 2021 04:10:36 -0400
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:37021 "EHLO
        out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234705AbhJSIKe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Oct 2021 04:10:34 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id 9B10B5C00DD;
        Tue, 19 Oct 2021 04:08:21 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute6.internal (MEProxy); Tue, 19 Oct 2021 04:08:21 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm1; bh=YbP9CWNuUGjr6qIi66GkYzkuK4UxDxrzINjldg1UZXg=; b=OLaW4xwM
        a5JsyrCJHDsW93meeSsmtMwGwI/vybkrCBij3OtVKDixEHt5K8Q/AEoOWqOrI73c
        PidYZR0jVuwHYgLI8bho3GZYlMY0GFLkavTDkPw2k/p9Cv5KwekqQYRmFdu+51aS
        6s8txpbDfsAvg37dXR9FGvWEaAMIb/mZFq+mYPyH/LDohZ/AeQ9xDXk8cJK2LIlq
        0fzvRrHWS436jM4NVyRQslbbWCZNnJsuusD+w8ttVj0ibS0lcIxjTuWFknlwxfV2
        mhhdq2+MsqJo4Uw7WUhAvZv0UCfLOK3mcxuALuwj/3lSGlD+8Je7RA+6wivmJiVw
        2SKP4hzbQ9HVDQ==
X-ME-Sender: <xms:9XxuYXVqveEWX87Orp4eUhWT-YCdKgaxSwnmivVnXmfgFTRaT_Bi2A>
    <xme:9XxuYfmNHS2EIRrZ27wzVFB1LgNXiGq6dwya_sk5R-13-YsEPd5m1-nwgTD8uM44a
    y5LcnsDWcAQauw>
X-ME-Received: <xmr:9XxuYTaBD4pUhvH3fbjDAGX6gpaujXswO8528bKOHxM5VAhTnSimLwceFYygKK0xURao0ZHEVR2FO0MS0Mc41R815l8Jk5FO6ggXXT1b9CM>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvtddrvddvuddguddvhecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecunecujfgurhephffvufffkffojghfggfgsedtke
    ertdertddtnecuhfhrohhmpefkughoucfutghhihhmmhgvlhcuoehiughoshgthhesihgu
    ohhstghhrdhorhhgqeenucggtffrrghtthgvrhhnpeduteeiveffffevleekleejffekhf
    ekhefgtdfftefhledvjefggfehgfevjeekhfenucevlhhushhtvghrufhiiigvpedtnecu
    rfgrrhgrmhepmhgrihhlfhhrohhmpehiughoshgthhesihguohhstghhrdhorhhg
X-ME-Proxy: <xmx:9XxuYSX0W-1FcnpHEoq-oqTm1zcbzZOcgK8tGY-kRBiIIt_df2eEag>
    <xmx:9XxuYRn23xHgrOs_vR9M_wwNy6ShqKvQwSTM1Cb-bOMtmHVObnmNyA>
    <xmx:9XxuYffaaOFBBO3REENcTV7r-B6NVUGu99AVT0IOtClWH3mUAJNQwQ>
    <xmx:9XxuYfZWXpTDZikc4cRFsWdw7IwJCSqLgA-h4aQQtWe0DMTcykO1uw>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 19 Oct 2021 04:08:19 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, jiri@nvidia.com,
        petrm@nvidia.com, jhs@mojatatu.com, xiyou.wangcong@gmail.com,
        mlxsw@nvidia.com, Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 8/9] mlxsw: spectrum_qdisc: Make RED, TBF offloads classful
Date:   Tue, 19 Oct 2021 11:07:11 +0300
Message-Id: <20211019080712.705464-9-idosch@idosch.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211019080712.705464-1-idosch@idosch.org>
References: <20211019080712.705464-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Petr Machata <petrm@nvidia.com>

Permit offloading qdiscs below RED and TBF. In order to avoid having to
implement trivial propagating callbacks for get_prio_bitmap and
get_tclass_num, extend mlxsw_sp_qdisc_get_prio_bitmap() and
..._get_tclass_num() to handle the lack of the callback as a cue to forward
the request to the parent.

Signed-off-by: Petr Machata <petrm@nvidia.com>
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 .../ethernet/mellanox/mlxsw/spectrum_qdisc.c  | 32 ++++++++++++++++++-
 1 file changed, 31 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_qdisc.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_qdisc.c
index b865fd3ccf31..ddb5ad88b350 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_qdisc.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_qdisc.c
@@ -207,6 +207,8 @@ static u8 mlxsw_sp_qdisc_get_prio_bitmap(struct mlxsw_sp_port *mlxsw_sp_port,
 
 	if (!parent)
 		return 0xff;
+	if (!parent->ops->get_prio_bitmap)
+		return mlxsw_sp_qdisc_get_prio_bitmap(mlxsw_sp_port, parent);
 	return parent->ops->get_prio_bitmap(parent, mlxsw_sp_qdisc);
 }
 
@@ -219,6 +221,8 @@ static int mlxsw_sp_qdisc_get_tclass_num(struct mlxsw_sp_port *mlxsw_sp_port,
 
 	if (!parent)
 		return MLXSW_SP_PORT_DEFAULT_TCLASS;
+	if (!parent->ops->get_tclass_num)
+		return mlxsw_sp_qdisc_get_tclass_num(mlxsw_sp_port, parent);
 	return parent->ops->get_tclass_num(parent, mlxsw_sp_qdisc);
 }
 
@@ -689,6 +693,14 @@ mlxsw_sp_qdisc_red_check_params(struct mlxsw_sp_port *mlxsw_sp_port,
 	return 0;
 }
 
+static int
+mlxsw_sp_qdisc_future_fifo_replace(struct mlxsw_sp_port *mlxsw_sp_port,
+				   u32 handle, unsigned int band,
+				   struct mlxsw_sp_qdisc *child_qdisc);
+static void
+mlxsw_sp_qdisc_future_fifos_init(struct mlxsw_sp_port *mlxsw_sp_port,
+				 u32 handle);
+
 static int
 mlxsw_sp_qdisc_red_replace(struct mlxsw_sp_port *mlxsw_sp_port, u32 handle,
 			   struct mlxsw_sp_qdisc *mlxsw_sp_qdisc,
@@ -699,6 +711,13 @@ mlxsw_sp_qdisc_red_replace(struct mlxsw_sp_port *mlxsw_sp_port, u32 handle,
 	int tclass_num;
 	u32 min, max;
 	u64 prob;
+	int err;
+
+	err = mlxsw_sp_qdisc_future_fifo_replace(mlxsw_sp_port, handle, 0,
+						 &mlxsw_sp_qdisc->qdiscs[0]);
+	if (err)
+		return err;
+	mlxsw_sp_qdisc_future_fifos_init(mlxsw_sp_port, TC_H_UNSPEC);
 
 	tclass_num = mlxsw_sp_qdisc_get_tclass_num(mlxsw_sp_port,
 						   mlxsw_sp_qdisc);
@@ -797,7 +816,10 @@ static struct mlxsw_sp_qdisc *
 mlxsw_sp_qdisc_leaf_find_class(struct mlxsw_sp_qdisc *mlxsw_sp_qdisc,
 			       u32 parent)
 {
-	return NULL;
+	/* RED and TBF are formally classful qdiscs, but all class references,
+	 * including X:0, just refer to the same one class.
+	 */
+	return &mlxsw_sp_qdisc->qdiscs[0];
 }
 
 static struct mlxsw_sp_qdisc_ops mlxsw_sp_qdisc_ops_red = {
@@ -810,6 +832,7 @@ static struct mlxsw_sp_qdisc_ops mlxsw_sp_qdisc_ops_red = {
 	.get_xstats = mlxsw_sp_qdisc_get_red_xstats,
 	.clean_stats = mlxsw_sp_setup_tc_qdisc_red_clean_stats,
 	.find_class = mlxsw_sp_qdisc_leaf_find_class,
+	.num_classes = 1,
 };
 
 static int mlxsw_sp_qdisc_graft(struct mlxsw_sp_port *mlxsw_sp_port,
@@ -979,6 +1002,12 @@ mlxsw_sp_qdisc_tbf_replace(struct mlxsw_sp_port *mlxsw_sp_port, u32 handle,
 	u8 burst_size;
 	int err;
 
+	err = mlxsw_sp_qdisc_future_fifo_replace(mlxsw_sp_port, handle, 0,
+						 &mlxsw_sp_qdisc->qdiscs[0]);
+	if (err)
+		return err;
+	mlxsw_sp_qdisc_future_fifos_init(mlxsw_sp_port, TC_H_UNSPEC);
+
 	tclass_num = mlxsw_sp_qdisc_get_tclass_num(mlxsw_sp_port,
 						   mlxsw_sp_qdisc);
 
@@ -1030,6 +1059,7 @@ static struct mlxsw_sp_qdisc_ops mlxsw_sp_qdisc_ops_tbf = {
 	.get_stats = mlxsw_sp_qdisc_get_tbf_stats,
 	.clean_stats = mlxsw_sp_setup_tc_qdisc_leaf_clean_stats,
 	.find_class = mlxsw_sp_qdisc_leaf_find_class,
+	.num_classes = 1,
 };
 
 static int __mlxsw_sp_setup_tc_tbf(struct mlxsw_sp_port *mlxsw_sp_port,
-- 
2.31.1

