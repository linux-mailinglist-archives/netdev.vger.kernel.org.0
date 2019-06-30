Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4AA575AED5
	for <lists+netdev@lfdr.de>; Sun, 30 Jun 2019 08:06:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726798AbfF3GGS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 30 Jun 2019 02:06:18 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:58253 "EHLO
        out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726666AbfF3GGQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 30 Jun 2019 02:06:16 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id CF24821470;
        Sun, 30 Jun 2019 02:06:15 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Sun, 30 Jun 2019 02:06:15 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm3; bh=EKua49dwVM3ml3+QfAsJtSjox8Zxuxhx9/De98NfYeY=; b=vwY+qfq0
        /LPmGBtBJnnkFPKu/kZO68CkqyyT9ghhXweBVZOMw9sBeAlALsAGTdyoJLBZjNuA
        nwZyqm1LRU7YGEY6X6nYRtzV26xqgyYb8mfKyS8pmXB32oBgvRqsd3qwLEJJ7mIM
        cX0n+LsykES0iIwGCIThPSIKmF1o7qfYK0hTgi2LhgiQznxGuqnboPa/lS/YYHzJ
        T7iG3eXz1oQLACEHxzlo2lCcdNDQOrDYb98Rr6eBNi93q/qFbpDojda8QwRC4p0A
        CzuqSCBu9V9OqEdX5kaQwuG4IALvkLeplEPPvS2NJdSY7TRxDD9Zoo4rFXBDnJxC
        B9dL5VqpR8r1tQ==
X-ME-Sender: <xms:V1EYXbc8nldrozNvzNWEZjecHMS6xMHPggtS3JsCTq-3rIAPG_V1-w>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduvddrvdefgddutddvucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecukfhppeduleefrdegjedrudeihedrvdehudenucfrrghrrghmpe
    hmrghilhhfrhhomhepihguohhstghhsehiughoshgthhdrohhrghenucevlhhushhtvghr
    ufhiiigvpedufe
X-ME-Proxy: <xmx:V1EYXdgwS-Vbu-o7WzN_eA4gls6PmDMlhaSmIRBYNGcZgK8izm41YQ>
    <xmx:V1EYXXTlBJXLSyPo5MLcG8AT-tSjwO0EJYPZIuXgdu4dqi_1zc1J9Q>
    <xmx:V1EYXeyJv9ABUkY3NwqRjX11A-Kiee6E33egoR1PqoFCpeeey0CDeA>
    <xmx:V1EYXRWD4FGsml0D3GQX6FFxxhb8F9BZKwvvXUCwmNrRy-QIxqwFCw>
Received: from splinter.mtl.com (unknown [193.47.165.251])
        by mail.messagingengine.com (Postfix) with ESMTPA id B9C8A8005B;
        Sun, 30 Jun 2019 02:06:13 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, richardcochran@gmail.com, jiri@mellanox.com,
        petrm@mellanox.com, mlxsw@mellanox.com,
        Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next v2 14/16] mlxsw: spectrum: PTP: Configure PTP traps and FIFO events
Date:   Sun, 30 Jun 2019 09:04:58 +0300
Message-Id: <20190630060500.7882-15-idosch@idosch.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190630060500.7882-1-idosch@idosch.org>
References: <20190630060500.7882-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Petr Machata <petrm@mellanox.com>

Configure MTPTPT to set which message types should arrive under which
PTP trap, and MOGCR to clear the timestamp queue after its contents are
reported through PTP_ING_FIFO or PTP_EGR_FIFO.

With this configuration, PTP packets start arriving through the PTP
traps. However since timestamping is disabled by default and there is
currently no way to enable it, they will not be timestamped.

Signed-off-by: Petr Machata <petrm@mellanox.com>
Acked-by: Jiri Pirko <jiri@mellanox.com>
Signed-off-by: Ido Schimmel <idosch@mellanox.com>
---
 .../ethernet/mellanox/mlxsw/spectrum_ptp.c    | 58 +++++++++++++++++++
 .../ethernet/mellanox/mlxsw/spectrum_ptp.h    |  7 +++
 2 files changed, 65 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_ptp.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_ptp.c
index f0f0c20ecc2e..b3e4f78d5f07 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_ptp.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_ptp.c
@@ -718,9 +718,35 @@ static void mlxsw_sp1_ptp_ht_gc(struct work_struct *work)
 			       MLXSW_SP1_PTP_HT_GC_INTERVAL);
 }
 
+static int mlxsw_sp_ptp_mtptpt_set(struct mlxsw_sp *mlxsw_sp,
+				   enum mlxsw_reg_mtptpt_trap_id trap_id,
+				   u16 message_type)
+{
+	char mtptpt_pl[MLXSW_REG_MTPTPT_LEN];
+
+	mlxsw_reg_mtptptp_pack(mtptpt_pl, trap_id, message_type);
+	return mlxsw_reg_write(mlxsw_sp->core, MLXSW_REG(mtptpt), mtptpt_pl);
+}
+
+static int mlxsw_sp1_ptp_set_fifo_clr_on_trap(struct mlxsw_sp *mlxsw_sp,
+					      bool clr)
+{
+	char mogcr_pl[MLXSW_REG_MOGCR_LEN] = {0};
+	int err;
+
+	err = mlxsw_reg_query(mlxsw_sp->core, MLXSW_REG(mogcr), mogcr_pl);
+	if (err)
+		return err;
+
+	mlxsw_reg_mogcr_ptp_iftc_set(mogcr_pl, clr);
+	mlxsw_reg_mogcr_ptp_eftc_set(mogcr_pl, clr);
+	return mlxsw_reg_write(mlxsw_sp->core, MLXSW_REG(mogcr), mogcr_pl);
+}
+
 struct mlxsw_sp_ptp_state *mlxsw_sp1_ptp_init(struct mlxsw_sp *mlxsw_sp)
 {
 	struct mlxsw_sp_ptp_state *ptp_state;
+	u16 message_type;
 	int err;
 
 	ptp_state = kzalloc(sizeof(*ptp_state), GFP_KERNEL);
@@ -735,11 +761,38 @@ struct mlxsw_sp_ptp_state *mlxsw_sp1_ptp_init(struct mlxsw_sp *mlxsw_sp)
 	if (err)
 		goto err_hashtable_init;
 
+	/* Delive these message types as PTP0. */
+	message_type = BIT(MLXSW_SP_PTP_MESSAGE_TYPE_SYNC) |
+		       BIT(MLXSW_SP_PTP_MESSAGE_TYPE_DELAY_REQ) |
+		       BIT(MLXSW_SP_PTP_MESSAGE_TYPE_PDELAY_REQ) |
+		       BIT(MLXSW_SP_PTP_MESSAGE_TYPE_PDELAY_RESP);
+	err = mlxsw_sp_ptp_mtptpt_set(mlxsw_sp, MLXSW_REG_MTPTPT_TRAP_ID_PTP0,
+				      message_type);
+	if (err)
+		goto err_mtptpt_set;
+
+	/* Everything else is PTP1. */
+	message_type = ~message_type;
+	err = mlxsw_sp_ptp_mtptpt_set(mlxsw_sp, MLXSW_REG_MTPTPT_TRAP_ID_PTP1,
+				      message_type);
+	if (err)
+		goto err_mtptpt1_set;
+
+	err = mlxsw_sp1_ptp_set_fifo_clr_on_trap(mlxsw_sp, true);
+	if (err)
+		goto err_fifo_clr;
+
 	INIT_DELAYED_WORK(&ptp_state->ht_gc_dw, mlxsw_sp1_ptp_ht_gc);
 	mlxsw_core_schedule_dw(&ptp_state->ht_gc_dw,
 			       MLXSW_SP1_PTP_HT_GC_INTERVAL);
 	return ptp_state;
 
+err_fifo_clr:
+	mlxsw_sp_ptp_mtptpt_set(mlxsw_sp, MLXSW_REG_MTPTPT_TRAP_ID_PTP1, 0);
+err_mtptpt1_set:
+	mlxsw_sp_ptp_mtptpt_set(mlxsw_sp, MLXSW_REG_MTPTPT_TRAP_ID_PTP0, 0);
+err_mtptpt_set:
+	rhashtable_destroy(&ptp_state->unmatched_ht);
 err_hashtable_init:
 	kfree(ptp_state);
 	return ERR_PTR(err);
@@ -747,7 +800,12 @@ struct mlxsw_sp_ptp_state *mlxsw_sp1_ptp_init(struct mlxsw_sp *mlxsw_sp)
 
 void mlxsw_sp1_ptp_fini(struct mlxsw_sp_ptp_state *ptp_state)
 {
+	struct mlxsw_sp *mlxsw_sp = ptp_state->mlxsw_sp;
+
 	cancel_delayed_work_sync(&ptp_state->ht_gc_dw);
+	mlxsw_sp1_ptp_set_fifo_clr_on_trap(mlxsw_sp, false);
+	mlxsw_sp_ptp_mtptpt_set(mlxsw_sp, MLXSW_REG_MTPTPT_TRAP_ID_PTP1, 0);
+	mlxsw_sp_ptp_mtptpt_set(mlxsw_sp, MLXSW_REG_MTPTPT_TRAP_ID_PTP0, 0);
 	rhashtable_free_and_destroy(&ptp_state->unmatched_ht,
 				    &mlxsw_sp1_ptp_unmatched_free_fn, NULL);
 	kfree(ptp_state);
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_ptp.h b/drivers/net/ethernet/mellanox/mlxsw/spectrum_ptp.h
index 40c9e82e2920..497ff7d90fb9 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_ptp.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_ptp.h
@@ -11,6 +11,13 @@ struct mlxsw_sp;
 struct mlxsw_sp_port;
 struct mlxsw_sp_ptp_clock;
 
+enum {
+	MLXSW_SP_PTP_MESSAGE_TYPE_SYNC,
+	MLXSW_SP_PTP_MESSAGE_TYPE_DELAY_REQ,
+	MLXSW_SP_PTP_MESSAGE_TYPE_PDELAY_REQ,
+	MLXSW_SP_PTP_MESSAGE_TYPE_PDELAY_RESP,
+};
+
 #if IS_REACHABLE(CONFIG_PTP_1588_CLOCK)
 
 struct mlxsw_sp_ptp_clock *
-- 
2.20.1

