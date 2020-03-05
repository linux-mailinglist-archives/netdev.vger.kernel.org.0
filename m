Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5505217A072
	for <lists+netdev@lfdr.de>; Thu,  5 Mar 2020 08:17:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726676AbgCEHRo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Mar 2020 02:17:44 -0500
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:48589 "EHLO
        out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726498AbgCEHRn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Mar 2020 02:17:43 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.nyi.internal (Postfix) with ESMTP id 5CE8C21FED;
        Thu,  5 Mar 2020 02:17:42 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Thu, 05 Mar 2020 02:17:42 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm2; bh=OylGPVVfDvN71Vv7kNRo6R0tMWWw8eg9NN1AeGtXJb4=; b=rKhtHpSU
        fj3cA+seuD+zDF8pJ070rnkd62m83CpibdTL6TDD/VZrHPHrgKZunJKte6ZvjOBp
        +GyVRkD4tJ5figk2bT8Kku1vNykOJKgHxYenxUZEJwvQ8Rd+5RMZDKx2aLaFPbtZ
        kpZgNnqsAttI9wCo3TVdO7GbpxrjcxoJEwkLFPbfFzIA4rHhpej95+GhMXE9zYNU
        WTgZMO885TsWtBCJzMLPfJEvBPPgtigRJNREKEVn5CR5b7bAyhacrRaym/8wmZu2
        lNBVaADcJSN0kMHWo1oU2/8GpBAiH2wLoq3Si5OQ9Onr/AyfKL1G83+tAg3dRs50
        qt5jscDJdMFwjA==
X-ME-Sender: <xms:lqdgXsrxeVs3gXR-obX2FCM8Ypq1hl5Ky1c3K4gNFsBbY6za1TpC6w>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedugedruddtledguddtiecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecunecujfgurhephffvufffkffojghfggfgsedtke
    ertdertddtnecuhfhrohhmpefkughoucfutghhihhmmhgvlhcuoehiughoshgthhesihgu
    ohhstghhrdhorhhgqeenucfkphepudelfedrgeejrdduieehrddvhedunecuvehluhhsth
    gvrhfuihiivgepvdenucfrrghrrghmpehmrghilhhfrhhomhepihguohhstghhsehiugho
    shgthhdrohhrgh
X-ME-Proxy: <xmx:lqdgXm5khDV5hBsc1xVUNXHu3OzsFEQ2XYjZNwTVyjCaZJ_8KOW_3A>
    <xmx:lqdgXsODrHZ6Cp9gwRu_KPUpSBNNHVSyrlI57ejxqbMIe1etSF7IlQ>
    <xmx:lqdgXoNVmCY3S8gVhlbtZqV1RFRvN819v8pNtS1xBS3KscoyN1ZjQQ>
    <xmx:lqdgXhb-sRxAdhj89M3dsZNPH8I-E3MXtrKIlSVlDDq3q7tmxYlFVQ>
Received: from splinter.mtl.com (unknown [193.47.165.251])
        by mail.messagingengine.com (Postfix) with ESMTPA id 654B7328005D;
        Thu,  5 Mar 2020 02:17:40 -0500 (EST)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, jiri@mellanox.com,
        petrm@mellanox.com, jhs@mojatatu.com, xiyou.wangcong@gmail.com,
        mlxsw@mellanox.com, Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next 4/5] mlxsw: spectrum_qdisc: Support offloading of FIFO Qdisc
Date:   Thu,  5 Mar 2020 09:16:43 +0200
Message-Id: <20200305071644.117264-5-idosch@idosch.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200305071644.117264-1-idosch@idosch.org>
References: <20200305071644.117264-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Petr Machata <petrm@mellanox.com>

There are two peculiarities about offloading FIFO:

- sometimes the qdisc has an unspecified handle (it is "invisible")
- it may be created before the qdisc that it will be a child of

These features make the offload a bit more tricky. The approach chosen in
this patch is to make note of all the FIFOs that needed to be rejected
because their parents were not known. Later when the parent is created,
they are offloaded

FIFO is only offloaded for its counters, queue length is ignored.

Signed-off-by: Petr Machata <petrm@mellanox.com>
Signed-off-by: Ido Schimmel <idosch@mellanox.com>
---
 .../net/ethernet/mellanox/mlxsw/spectrum.c    |   2 +
 .../net/ethernet/mellanox/mlxsw/spectrum.h    |   2 +
 .../ethernet/mellanox/mlxsw/spectrum_qdisc.c  | 146 +++++++++++++++++-
 3 files changed, 149 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
index 673fa2fd995c..51709012593e 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
@@ -1783,6 +1783,8 @@ static int mlxsw_sp_setup_tc(struct net_device *dev, enum tc_setup_type type,
 		return mlxsw_sp_setup_tc_ets(mlxsw_sp_port, type_data);
 	case TC_SETUP_QDISC_TBF:
 		return mlxsw_sp_setup_tc_tbf(mlxsw_sp_port, type_data);
+	case TC_SETUP_QDISC_FIFO:
+		return mlxsw_sp_setup_tc_fifo(mlxsw_sp_port, type_data);
 	default:
 		return -EOPNOTSUPP;
 	}
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum.h b/drivers/net/ethernet/mellanox/mlxsw/spectrum.h
index f952fbf96b41..ff61cad74bb0 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum.h
@@ -867,6 +867,8 @@ int mlxsw_sp_setup_tc_ets(struct mlxsw_sp_port *mlxsw_sp_port,
 			  struct tc_ets_qopt_offload *p);
 int mlxsw_sp_setup_tc_tbf(struct mlxsw_sp_port *mlxsw_sp_port,
 			  struct tc_tbf_qopt_offload *p);
+int mlxsw_sp_setup_tc_fifo(struct mlxsw_sp_port *mlxsw_sp_port,
+			   struct tc_fifo_qopt_offload *p);
 
 /* spectrum_fid.c */
 bool mlxsw_sp_fid_is_dummy(struct mlxsw_sp *mlxsw_sp, u16 fid_index);
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_qdisc.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_qdisc.c
index 55751faa9fa4..b9f429ec0db4 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_qdisc.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_qdisc.c
@@ -20,6 +20,7 @@ enum mlxsw_sp_qdisc_type {
 	MLXSW_SP_QDISC_PRIO,
 	MLXSW_SP_QDISC_ETS,
 	MLXSW_SP_QDISC_TBF,
+	MLXSW_SP_QDISC_FIFO,
 };
 
 struct mlxsw_sp_qdisc;
@@ -69,6 +70,20 @@ struct mlxsw_sp_qdisc {
 struct mlxsw_sp_qdisc_state {
 	struct mlxsw_sp_qdisc root_qdisc;
 	struct mlxsw_sp_qdisc tclass_qdiscs[IEEE_8021QAZ_MAX_TCS];
+
+	/* When a PRIO or ETS are added, the invisible FIFOs in their bands are
+	 * created first. When notifications for these FIFOs arrive, it is not
+	 * known what qdisc their parent handle refers to. It could be a
+	 * newly-created PRIO that will replace the currently-offloaded one, or
+	 * it could be e.g. a RED that will be attached below it.
+	 *
+	 * As the notifications start to arrive, use them to note what the
+	 * future parent handle is, and keep track of which child FIFOs were
+	 * seen. Then when the parent is known, retroactively offload those
+	 * FIFOs.
+	 */
+	u32 future_handle;
+	bool future_fifos[IEEE_8021QAZ_MAX_TCS];
 };
 
 static bool
@@ -160,7 +175,11 @@ mlxsw_sp_qdisc_replace(struct mlxsw_sp_port *mlxsw_sp_port, u32 handle,
 	if (err)
 		goto err_config;
 
-	if (mlxsw_sp_qdisc->handle != handle) {
+	/* Check if the Qdisc changed. That includes a situation where an
+	 * invisible Qdisc replaces another one, or is being added for the
+	 * first time.
+	 */
+	if (mlxsw_sp_qdisc->handle != handle || handle == TC_H_UNSPEC) {
 		mlxsw_sp_qdisc->ops = ops;
 		if (ops->clean_stats)
 			ops->clean_stats(mlxsw_sp_port, mlxsw_sp_qdisc);
@@ -745,6 +764,118 @@ int mlxsw_sp_setup_tc_tbf(struct mlxsw_sp_port *mlxsw_sp_port,
 	}
 }
 
+static int
+mlxsw_sp_qdisc_fifo_destroy(struct mlxsw_sp_port *mlxsw_sp_port,
+			    struct mlxsw_sp_qdisc *mlxsw_sp_qdisc)
+{
+	struct mlxsw_sp_qdisc_state *qdisc_state = mlxsw_sp_port->qdisc;
+	struct mlxsw_sp_qdisc *root_qdisc = &qdisc_state->root_qdisc;
+
+	if (root_qdisc != mlxsw_sp_qdisc)
+		root_qdisc->stats_base.backlog -=
+					mlxsw_sp_qdisc->stats_base.backlog;
+	return 0;
+}
+
+static int
+mlxsw_sp_qdisc_fifo_check_params(struct mlxsw_sp_port *mlxsw_sp_port,
+				 struct mlxsw_sp_qdisc *mlxsw_sp_qdisc,
+				 void *params)
+{
+	return 0;
+}
+
+static int
+mlxsw_sp_qdisc_fifo_replace(struct mlxsw_sp_port *mlxsw_sp_port, u32 handle,
+			    struct mlxsw_sp_qdisc *mlxsw_sp_qdisc,
+			    void *params)
+{
+	return 0;
+}
+
+static int
+mlxsw_sp_qdisc_get_fifo_stats(struct mlxsw_sp_port *mlxsw_sp_port,
+			      struct mlxsw_sp_qdisc *mlxsw_sp_qdisc,
+			      struct tc_qopt_offload_stats *stats_ptr)
+{
+	mlxsw_sp_qdisc_get_tc_stats(mlxsw_sp_port, mlxsw_sp_qdisc,
+				    stats_ptr);
+	return 0;
+}
+
+static struct mlxsw_sp_qdisc_ops mlxsw_sp_qdisc_ops_fifo = {
+	.type = MLXSW_SP_QDISC_FIFO,
+	.check_params = mlxsw_sp_qdisc_fifo_check_params,
+	.replace = mlxsw_sp_qdisc_fifo_replace,
+	.destroy = mlxsw_sp_qdisc_fifo_destroy,
+	.get_stats = mlxsw_sp_qdisc_get_fifo_stats,
+	.clean_stats = mlxsw_sp_setup_tc_qdisc_leaf_clean_stats,
+};
+
+int mlxsw_sp_setup_tc_fifo(struct mlxsw_sp_port *mlxsw_sp_port,
+			   struct tc_fifo_qopt_offload *p)
+{
+	struct mlxsw_sp_qdisc_state *qdisc_state = mlxsw_sp_port->qdisc;
+	struct mlxsw_sp_qdisc *mlxsw_sp_qdisc;
+	int tclass, child_index;
+	u32 parent_handle;
+
+	/* Invisible FIFOs are tracked in future_handle and future_fifos. Make
+	 * sure that not more than one qdisc is created for a port at a time.
+	 * RTNL is a simple proxy for that.
+	 */
+	ASSERT_RTNL();
+
+	mlxsw_sp_qdisc = mlxsw_sp_qdisc_find(mlxsw_sp_port, p->parent, false);
+	if (!mlxsw_sp_qdisc && p->handle == TC_H_UNSPEC) {
+		parent_handle = TC_H_MAJ(p->parent);
+		if (parent_handle != qdisc_state->future_handle) {
+			/* This notifications is for a different Qdisc than
+			 * previously. Wipe the future cache.
+			 */
+			memset(qdisc_state->future_fifos, 0,
+			       sizeof(qdisc_state->future_fifos));
+			qdisc_state->future_handle = parent_handle;
+		}
+
+		child_index = TC_H_MIN(p->parent);
+		tclass = MLXSW_SP_PRIO_CHILD_TO_TCLASS(child_index);
+		if (tclass < IEEE_8021QAZ_MAX_TCS) {
+			if (p->command == TC_FIFO_REPLACE)
+				qdisc_state->future_fifos[tclass] = true;
+			else if (p->command == TC_FIFO_DESTROY)
+				qdisc_state->future_fifos[tclass] = false;
+		}
+	}
+	if (!mlxsw_sp_qdisc)
+		return -EOPNOTSUPP;
+
+	if (p->command == TC_FIFO_REPLACE) {
+		return mlxsw_sp_qdisc_replace(mlxsw_sp_port, p->handle,
+					      mlxsw_sp_qdisc,
+					      &mlxsw_sp_qdisc_ops_fifo, NULL);
+	}
+
+	if (!mlxsw_sp_qdisc_compare(mlxsw_sp_qdisc, p->handle,
+				    MLXSW_SP_QDISC_FIFO))
+		return -EOPNOTSUPP;
+
+	switch (p->command) {
+	case TC_FIFO_DESTROY:
+		if (p->handle == mlxsw_sp_qdisc->handle)
+			return mlxsw_sp_qdisc_destroy(mlxsw_sp_port,
+						      mlxsw_sp_qdisc);
+		return 0;
+	case TC_FIFO_STATS:
+		return mlxsw_sp_qdisc_get_stats(mlxsw_sp_port, mlxsw_sp_qdisc,
+						&p->stats);
+	case TC_FIFO_REPLACE: /* Handled above. */
+		break;
+	}
+
+	return -EOPNOTSUPP;
+}
+
 static int
 __mlxsw_sp_qdisc_ets_destroy(struct mlxsw_sp_port *mlxsw_sp_port)
 {
@@ -835,6 +966,16 @@ __mlxsw_sp_qdisc_ets_replace(struct mlxsw_sp_port *mlxsw_sp_port, u32 handle,
 						      child_qdisc);
 			child_qdisc->stats_base.backlog = backlog;
 		}
+
+		if (handle == qdisc_state->future_handle &&
+		    qdisc_state->future_fifos[tclass]) {
+			err = mlxsw_sp_qdisc_replace(mlxsw_sp_port, TC_H_UNSPEC,
+						     child_qdisc,
+						     &mlxsw_sp_qdisc_ops_fifo,
+						     NULL);
+			if (err)
+				return err;
+		}
 	}
 	for (; band < IEEE_8021QAZ_MAX_TCS; band++) {
 		tclass = MLXSW_SP_PRIO_BAND_TO_TCLASS(band);
@@ -845,6 +986,9 @@ __mlxsw_sp_qdisc_ets_replace(struct mlxsw_sp_port *mlxsw_sp_port, u32 handle,
 				      MLXSW_REG_QEEC_HR_SUBGROUP,
 				      tclass, 0, false, 0);
 	}
+
+	qdisc_state->future_handle = TC_H_UNSPEC;
+	memset(qdisc_state->future_fifos, 0, sizeof(qdisc_state->future_fifos));
 	return 0;
 }
 
-- 
2.24.1

