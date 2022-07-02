Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BAAB656424F
	for <lists+netdev@lfdr.de>; Sat,  2 Jul 2022 21:04:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232418AbiGBTEg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 2 Jul 2022 15:04:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56438 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231865AbiGBTE2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 2 Jul 2022 15:04:28 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 739FF9FE6
        for <netdev@vger.kernel.org>; Sat,  2 Jul 2022 12:04:27 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 066A8B808C2
        for <netdev@vger.kernel.org>; Sat,  2 Jul 2022 19:04:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B02A3C341C8;
        Sat,  2 Jul 2022 19:04:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1656788664;
        bh=wxJUrxFgsI74QjlbkC0rjKL0UzQg+ml8KAKhayW9Ujc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nLP5D1HAbWaNOTYIUmm9djmx5TPPNmd0C7f6K363aWho6DXSPsP4kPMOY/EBhaV3K
         a7eZR9TNnJ08hHnlTJ5sCwub2qhffwuHM1omG0M6Ys4iZtacw76854vSiO5NmDnVOj
         lrm+h9v1fRbtv88fNt7tsJNXhKRcGPBBKeWjUJ+LQuKuxy2ne9Cjv5DU40RNN8H0/V
         tpLWX/I7cYuCGI5YBlMUds+3u1qjdLYthrSMs4jNdVUjV51xDdYZRInTyGPil580F2
         q56aT3k92ek7KF4ARL7akU0EKeAtdtHKTx4YpocayWmmO2JcJ93n+kexS1XLuH1m9R
         ljZbFuLjZfuGQ==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Chris Mi <cmi@nvidia.com>, Mark Bloch <mbloch@nvidia.com>,
        Roi Dayan <roid@nvidia.com>
Subject: [net-next v2 04/15] net/mlx5: E-switch, Introduce flag to indicate if fdb table is created
Date:   Sat,  2 Jul 2022 12:02:02 -0700
Message-Id: <20220702190213.80858-5-saeed@kernel.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220702190213.80858-1-saeed@kernel.org>
References: <20220702190213.80858-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Chris Mi <cmi@nvidia.com>

Introduce flag to indicate if fdb table is created as a pre-step
to prepare for removing dependency between sriov and eswitch mode
in the downstream patches.

Signed-off-by: Chris Mi <cmi@nvidia.com>
Reviewed-by: Mark Bloch <mbloch@nvidia.com>
Reviewed-by: Roi Dayan <roid@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/eswitch.c | 3 +++
 drivers/net/ethernet/mellanox/mlx5/core/eswitch.h | 9 +++++++++
 2 files changed, 12 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
index 823bfcff7846..b9a3473f5672 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
@@ -1274,6 +1274,8 @@ int mlx5_eswitch_enable_locked(struct mlx5_eswitch *esw, int mode, int num_vfs)
 	if (err)
 		goto abort;
 
+	esw->fdb_table.flags |= MLX5_ESW_FDB_CREATED;
+
 	mlx5_eswitch_event_handlers_register(esw);
 
 	esw_info(esw->dev, "Enable: mode(%s), nvfs(%d), active vports(%d)\n",
@@ -1356,6 +1358,7 @@ void mlx5_eswitch_disable_locked(struct mlx5_eswitch *esw, bool clear_vf)
 
 	mlx5_eswitch_event_handlers_unregister(esw);
 
+	esw->fdb_table.flags &= ~MLX5_ESW_FDB_CREATED;
 	if (esw->mode == MLX5_ESWITCH_LEGACY)
 		esw_legacy_disable(esw);
 	else if (esw->mode == MLX5_ESWITCH_OFFLOADS)
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h
index a08f5315d768..a9ba0e324834 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h
@@ -287,6 +287,10 @@ enum {
 
 struct mlx5_esw_bridge_offloads;
 
+enum {
+	MLX5_ESW_FDB_CREATED = BIT(0),
+};
+
 struct mlx5_eswitch {
 	struct mlx5_core_dev    *dev;
 	struct mlx5_nb          nb;
@@ -576,6 +580,11 @@ mlx5_esw_devlink_port_index_to_vport_num(unsigned int dl_port_index)
 	return dl_port_index & 0xffff;
 }
 
+static inline bool mlx5_esw_is_fdb_created(struct mlx5_eswitch *esw)
+{
+	return esw->fdb_table.flags & MLX5_ESW_FDB_CREATED;
+}
+
 /* TODO: This mlx5e_tc function shouldn't be called by eswitch */
 void mlx5e_tc_clean_fdb_peer_flows(struct mlx5_eswitch *esw);
 
-- 
2.36.1

