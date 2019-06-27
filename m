Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B2248583EE
	for <lists+netdev@lfdr.de>; Thu, 27 Jun 2019 15:54:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726497AbfF0NyH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Jun 2019 09:54:07 -0400
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:38381 "EHLO
        out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727099AbfF0NyE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Jun 2019 09:54:04 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id 0A8F92208E;
        Thu, 27 Jun 2019 09:54:04 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Thu, 27 Jun 2019 09:54:04 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm3; bh=ApzIbIXfdRa4IKOY9T3M1ZunpN3l6G2W74totH354Fk=; b=R7b2tMuS
        B05/IGEktumJD5BeGy4R0hFlcgT8lCNg0oNf8ESqXrh4LHdv1RrEPynAKinu0BPS
        Tn88rqEhWGf7PGCxTx2wHAyAcUzQ4m+El+bAmhage3fffP7tIZvWj0bfll9yGq1k
        l7EvIlVORJyLaKQOWWoeEYh5TOwUjD3JsSOjk6O/lFvKH9g0RIzPjAKNbZjgfZdo
        YcIbj3FhgXVJAPCsby74ClVRAyFfpWYasPm6Oevcngz3yjXpucJpXYlKO9uA4d7/
        TDcA4doYbztW2bf2bRk1VJ/qFgASfzgZRwycvYqkpwjVz6zjLf/LxqFfBWPjyy9+
        A2aSub4zCEJNZg==
X-ME-Sender: <xms:e8oUXZFtoLbXyA21HmcDfXaELTECzZCy5EWwFL_24dXVwNeQvvkHPw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduvddrudekgdejudcutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhephffvufffkffojghfggfgsedtkeertd
    ertddtnecuhfhrohhmpefkughoucfutghhihhmmhgvlhcuoehiughoshgthhesihguohhs
    tghhrdhorhhgqeenucfkphepudelfedrgeejrdduieehrddvhedunecurfgrrhgrmhepmh
    grihhlfhhrohhmpehiughoshgthhesihguohhstghhrdhorhhgnecuvehluhhsthgvrhfu
    ihiivgepuddu
X-ME-Proxy: <xmx:e8oUXY9F6PSI0zJikMTXIH_uQjtJ2VDwnKisWD1_Km2u4Td4WDRCvA>
    <xmx:e8oUXfMCneALqJZGLh78n6tSvnDwbLshswJJSYUKRVhJ7RrlgaJ9tA>
    <xmx:e8oUXUUY-xmmrfb7JJvnN9HCzMCNfEC5_rqGWn-q7DZNOj6s8jfzaA>
    <xmx:fMoUXXjqetIHyqBF5GkaAAE5LgLy5Knz8DbVTDwUUpPvRH2s3_qFdQ>
Received: from splinter.mtl.com (unknown [193.47.165.251])
        by mail.messagingengine.com (Postfix) with ESMTPA id 297C58005B;
        Thu, 27 Jun 2019 09:54:01 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, jiri@mellanox.com, petrm@mellanox.com,
        mlxsw@mellanox.com, Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next 14/16] mlxsw: spectrum: PTP: Configure PTP traps and FIFO events
Date:   Thu, 27 Jun 2019 16:52:57 +0300
Message-Id: <20190627135259.7292-15-idosch@idosch.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190627135259.7292-1-idosch@idosch.org>
References: <20190627135259.7292-1-idosch@idosch.org>
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
index f0f0c20ecc2e..4d6dbac18049 100644
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
+	message_type = BIT(MLXSW_PTP_MESSAGE_TYPE_SYNC) |
+		       BIT(MLXSW_PTP_MESSAGE_TYPE_DELAY_REQ) |
+		       BIT(MLXSW_PTP_MESSAGE_TYPE_PDELAY_REQ) |
+		       BIT(MLXSW_PTP_MESSAGE_TYPE_PDELAY_RESP);
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
index 40c9e82e2920..a135c6a0a051 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_ptp.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_ptp.h
@@ -11,6 +11,13 @@ struct mlxsw_sp;
 struct mlxsw_sp_port;
 struct mlxsw_sp_ptp_clock;
 
+enum {
+	MLXSW_PTP_MESSAGE_TYPE_SYNC,
+	MLXSW_PTP_MESSAGE_TYPE_DELAY_REQ,
+	MLXSW_PTP_MESSAGE_TYPE_PDELAY_REQ,
+	MLXSW_PTP_MESSAGE_TYPE_PDELAY_RESP,
+};
+
 #if IS_REACHABLE(CONFIG_PTP_1588_CLOCK)
 
 struct mlxsw_sp_ptp_clock *
-- 
2.20.1

