Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 74DE24330C5
	for <lists+netdev@lfdr.de>; Tue, 19 Oct 2021 10:08:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234655AbhJSIK3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Oct 2021 04:10:29 -0400
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:60913 "EHLO
        out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234853AbhJSIKT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Oct 2021 04:10:19 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id 2F0CC5C0154;
        Tue, 19 Oct 2021 04:08:07 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Tue, 19 Oct 2021 04:08:07 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm1; bh=UAaSUHhwf2bU9iNofLgaW3JXlxPKrjcpRwGRon6whm0=; b=llrSdVdq
        tQ0/S9Sf5RzmkAOUU8nfhIjavm/v2k2TDDuruu7m5b0lb6xYWg+5vBgvaoVFT/Q0
        EOuKf38XRyowiCr5KxDmJIv5Dn/3Eao4TCdzVwYGpbrd8KNVu600hq+tNIVZJjnP
        DSyytw5NnZy2XfAtjNc7s17mrwplIlwKMWvFuvBQWm0D2908U9L2Hkas810uSR5c
        o5V7PeEYrsJ5IQ4DW3ijUukZucEN8yqfkD1J0DFJ+9L9etcO4G9QL6G72zpAMGTl
        tS7Zg+4C6dlvCLIH+aFK8L4BkRT3vcsrbvDwSI4DWWG1MD3/IwMmbua33cfrSl5w
        Nr02jAsQSpYvog==
X-ME-Sender: <xms:53xuYXGTcxwls6vZU9nCANWIISEol9ZCZLHZ-32_CXdc-5PU5uJOHA>
    <xme:53xuYUVpzyVLZw3Gw5nYO72gFxoZqN-4-cpNFKxr7-tRwtyhFSoF4qp9Yle9evkIl
    L7sEnBSf51I77I>
X-ME-Received: <xmr:53xuYZIo4EoIJK2s_0Uhu9Dj-QSGSXybdgiA7yd2cvNQxOB-qRty4lfQhh8tPJ-QjCNShnMZUwv0S2eMBa2YNjzdkmrrCdbjoixOUAuESJM>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvtddrvddvuddguddvhecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecunecujfgurhephffvufffkffojghfggfgsedtke
    ertdertddtnecuhfhrohhmpefkughoucfutghhihhmmhgvlhcuoehiughoshgthhesihgu
    ohhstghhrdhorhhgqeenucggtffrrghtthgvrhhnpeduteeiveffffevleekleejffekhf
    ekhefgtdfftefhledvjefggfehgfevjeekhfenucevlhhushhtvghrufhiiigvpedtnecu
    rfgrrhgrmhepmhgrihhlfhhrohhmpehiughoshgthhesihguohhstghhrdhorhhg
X-ME-Proxy: <xmx:53xuYVHeX41S6dZGPX1DsKh13iezIndlnhEVneIQIke6Fk5M0h7v0w>
    <xmx:53xuYdUyfsDnBS_P-gIdejpbR4750rwmvD9Nq8H-IsWT5aaGytAjeg>
    <xmx:53xuYQOfqWr5Dj_6VJ_ztsKITy-NwcRDkN4G7nss4ssiHgx4-wHzFQ>
    <xmx:53xuYfK2IPtf7ldT-o5FsPA32t2KJ1XpVDSY-lj4-niDfNrl6hLLZQ>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 19 Oct 2021 04:08:04 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, jiri@nvidia.com,
        petrm@nvidia.com, jhs@mojatatu.com, xiyou.wangcong@gmail.com,
        mlxsw@nvidia.com, Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 3/9] mlxsw: spectrum_qdisc: Extract two helpers for handling future FIFOs
Date:   Tue, 19 Oct 2021 11:07:06 +0300
Message-Id: <20211019080712.705464-4-idosch@idosch.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211019080712.705464-1-idosch@idosch.org>
References: <20211019080712.705464-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Petr Machata <petrm@nvidia.com>

Extract from __mlxsw_sp_qdisc_ets_replace() two helpers for handling of one
future FIFO resp. reinitializing the array of future FIFOs.

Signed-off-by: Petr Machata <petrm@nvidia.com>
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 .../ethernet/mellanox/mlxsw/spectrum_qdisc.c  | 48 +++++++++++++------
 1 file changed, 33 insertions(+), 15 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_qdisc.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_qdisc.c
index 5114d65ed33f..7f29f51bdf1b 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_qdisc.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_qdisc.c
@@ -1022,6 +1022,32 @@ static struct mlxsw_sp_qdisc_ops mlxsw_sp_qdisc_ops_fifo = {
 	.clean_stats = mlxsw_sp_setup_tc_qdisc_leaf_clean_stats,
 };
 
+static int
+mlxsw_sp_qdisc_future_fifo_replace(struct mlxsw_sp_port *mlxsw_sp_port,
+				   u32 handle, unsigned int band,
+				   struct mlxsw_sp_qdisc *child_qdisc)
+{
+	struct mlxsw_sp_qdisc_state *qdisc_state = mlxsw_sp_port->qdisc;
+
+	if (handle == qdisc_state->future_handle &&
+	    qdisc_state->future_fifos[band])
+		return mlxsw_sp_qdisc_replace(mlxsw_sp_port, TC_H_UNSPEC,
+					      child_qdisc,
+					      &mlxsw_sp_qdisc_ops_fifo,
+					      NULL);
+	return 0;
+}
+
+static void
+mlxsw_sp_qdisc_future_fifos_init(struct mlxsw_sp_port *mlxsw_sp_port,
+				 u32 handle)
+{
+	struct mlxsw_sp_qdisc_state *qdisc_state = mlxsw_sp_port->qdisc;
+
+	qdisc_state->future_handle = handle;
+	memset(qdisc_state->future_fifos, 0, sizeof(qdisc_state->future_fifos));
+}
+
 static int __mlxsw_sp_setup_tc_fifo(struct mlxsw_sp_port *mlxsw_sp_port,
 				    struct tc_fifo_qopt_offload *p)
 {
@@ -1037,9 +1063,8 @@ static int __mlxsw_sp_setup_tc_fifo(struct mlxsw_sp_port *mlxsw_sp_port,
 			/* This notifications is for a different Qdisc than
 			 * previously. Wipe the future cache.
 			 */
-			memset(qdisc_state->future_fifos, 0,
-			       sizeof(qdisc_state->future_fifos));
-			qdisc_state->future_handle = parent_handle;
+			mlxsw_sp_qdisc_future_fifos_init(mlxsw_sp_port,
+							 parent_handle);
 		}
 
 		band = TC_H_MIN(p->parent) - 1;
@@ -1141,7 +1166,6 @@ __mlxsw_sp_qdisc_ets_replace(struct mlxsw_sp_port *mlxsw_sp_port,
 			     const u8 *priomap)
 {
 	struct mlxsw_sp_qdisc_ets_data *ets_data = mlxsw_sp_qdisc->ets_data;
-	struct mlxsw_sp_qdisc_state *qdisc_state = mlxsw_sp_port->qdisc;
 	struct mlxsw_sp_qdisc_ets_band *ets_band;
 	struct mlxsw_sp_qdisc *child_qdisc;
 	u8 old_priomap, new_priomap;
@@ -1201,15 +1225,10 @@ __mlxsw_sp_qdisc_ets_replace(struct mlxsw_sp_port *mlxsw_sp_port,
 			child_qdisc->stats_base.backlog = backlog;
 		}
 
-		if (handle == qdisc_state->future_handle &&
-		    qdisc_state->future_fifos[band]) {
-			err = mlxsw_sp_qdisc_replace(mlxsw_sp_port, TC_H_UNSPEC,
-						     child_qdisc,
-						     &mlxsw_sp_qdisc_ops_fifo,
-						     NULL);
-			if (err)
-				return err;
-		}
+		err = mlxsw_sp_qdisc_future_fifo_replace(mlxsw_sp_port, handle,
+							 band, child_qdisc);
+		if (err)
+			return err;
 	}
 	for (; band < IEEE_8021QAZ_MAX_TCS; band++) {
 		ets_band = &ets_data->bands[band];
@@ -1223,8 +1242,7 @@ __mlxsw_sp_qdisc_ets_replace(struct mlxsw_sp_port *mlxsw_sp_port,
 				      ets_band->tclass_num, 0, false, 0);
 	}
 
-	qdisc_state->future_handle = TC_H_UNSPEC;
-	memset(qdisc_state->future_fifos, 0, sizeof(qdisc_state->future_fifos));
+	mlxsw_sp_qdisc_future_fifos_init(mlxsw_sp_port, TC_H_UNSPEC);
 	return 0;
 }
 
-- 
2.31.1

