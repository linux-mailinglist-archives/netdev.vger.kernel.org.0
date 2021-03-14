Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 063A433A4B5
	for <lists+netdev@lfdr.de>; Sun, 14 Mar 2021 13:22:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235389AbhCNMVD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 14 Mar 2021 08:21:03 -0400
Received: from new2-smtp.messagingengine.com ([66.111.4.224]:39577 "EHLO
        new2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235336AbhCNMUd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 14 Mar 2021 08:20:33 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailnew.nyi.internal (Postfix) with ESMTP id 4667F5808BA;
        Sun, 14 Mar 2021 08:20:33 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Sun, 14 Mar 2021 08:20:33 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm2; bh=ogpzI+RjoHAfLxMaxGt/+Vex6AxaXI/KcSkgcoGSs/Q=; b=sqLSvs6+
        FtorReYCeVzpkZMw3sjgYcC+46pejllUUxXLSmURO/BZ0ACIX0GFFbTFC+G4Z6Az
        QgKp61NWlMcLLEwZD6TrP1/lbPzW413DbwkTAX7Mveq1zO2RBlBy3onldsDEwdbS
        uADkqzulhYDl/PvPCpdqdHO0p9I+mLsVk2fjpfWu6gPoWU/mI8gbOUyNaqm0dyqo
        X8c9EpfeQBROq2G1L0s52+Vk5FKYxgjWE6QTQXe5uP2tcxNh772w82mpCbxvlhxe
        gI2szgAtsge4KJK+8jhFAuq5qevf6NZEDxU0efE8mIkGht1/eeUXl3e/VG30Vj3l
        J/52Mh/j0e0+nQ==
X-ME-Sender: <xms:kf9NYPvxLqR59fRLhj043t8UUoI32-GH5y8IMselh59Imq9jHlStFg>
    <xme:kf9NYAemvhreszFJCfojQlodvCherBHCKbOQExy9UtS3KentA6V4M9ZuuSqgUgZKm
    KJDp7bKArc4LbI>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledruddvjedgudefucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecuggftrfgrthhtvghrnhepudetieevffffveelkeeljeffkefhke
    ehgfdtffethfelvdejgffghefgveejkefhnecukfhppeekgedrvddvledrudehfedrgeeg
    necuvehluhhsthgvrhfuihiivgepgeenucfrrghrrghmpehmrghilhhfrhhomhepihguoh
    hstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:kf9NYCxTK8S-GvmtVRSvnReQTR5XSPQBBXAsudFicmB_VtV_7ddgWA>
    <xmx:kf9NYONdn4z6EhH8yMY4ahIf2K7YS74WuBT7HUwPhg89d7dzmT_nJA>
    <xmx:kf9NYP-vvLHpIZEUC_NeDkMAzvEb4mW4ESS1t7Wpz3DAUrox2x3pzg>
    <xmx:kf9NYLReRY3mqlGVwXDBgrsv5X_9lZ-s3XlW9Ea7xanHMNrm8f5ARw>
Received: from shredder.lan (igld-84-229-153-44.inter.net.il [84.229.153.44])
        by mail.messagingengine.com (Postfix) with ESMTPA id 87371240054;
        Sun, 14 Mar 2021 08:20:30 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, jiri@nvidia.com,
        yotam.gi@gmail.com, jhs@mojatatu.com, xiyou.wangcong@gmail.com,
        roopa@nvidia.com, peter.phaal@inmon.com, neil.mckee@inmon.com,
        mlxsw@nvidia.com, Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 06/11] mlxsw: Create dedicated field for Rx metadata in skb control block
Date:   Sun, 14 Mar 2021 14:19:35 +0200
Message-Id: <20210314121940.2807621-7-idosch@idosch.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210314121940.2807621-1-idosch@idosch.org>
References: <20210314121940.2807621-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@nvidia.com>

Next patch will need to encode more Rx metadata in the skb control
block, so create a dedicated field for it and move the cookie index
there.

Signed-off-by: Ido Schimmel <idosch@nvidia.com>
Reviewed-by: Jiri Pirko <jiri@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlxsw/core.h          | 6 +++++-
 drivers/net/ethernet/mellanox/mlxsw/pci.c           | 2 +-
 drivers/net/ethernet/mellanox/mlxsw/spectrum_trap.c | 2 +-
 3 files changed, 7 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/core.h b/drivers/net/ethernet/mellanox/mlxsw/core.h
index 8af7d9d03475..86adc17c8901 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/core.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/core.h
@@ -58,6 +58,10 @@ struct mlxsw_tx_info {
 	bool is_emad;
 };
 
+struct mlxsw_rx_md_info {
+	u32 cookie_index;
+};
+
 bool mlxsw_core_skb_transmit_busy(struct mlxsw_core *mlxsw_core,
 				  const struct mlxsw_tx_info *tx_info);
 int mlxsw_core_skb_transmit(struct mlxsw_core *mlxsw_core, struct sk_buff *skb,
@@ -515,7 +519,7 @@ enum mlxsw_devlink_param_id {
 struct mlxsw_skb_cb {
 	union {
 		struct mlxsw_tx_info tx_info;
-		u32 cookie_index; /* Only used during receive */
+		struct mlxsw_rx_md_info rx_md_info;
 	};
 };
 
diff --git a/drivers/net/ethernet/mellanox/mlxsw/pci.c b/drivers/net/ethernet/mellanox/mlxsw/pci.c
index d0052537e627..8eee8b3c675e 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/pci.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/pci.c
@@ -581,7 +581,7 @@ static void mlxsw_pci_cqe_rdq_handle(struct mlxsw_pci *mlxsw_pci,
 
 		if (mlxsw_pci->max_cqe_ver >= MLXSW_PCI_CQE_V2)
 			cookie_index = mlxsw_pci_cqe2_user_def_val_orig_pkt_len_get(cqe);
-		mlxsw_skb_cb(skb)->cookie_index = cookie_index;
+		mlxsw_skb_cb(skb)->rx_md_info.cookie_index = cookie_index;
 	} else if (rx_info.trap_id >= MLXSW_TRAP_ID_MIRROR_SESSION0 &&
 		   rx_info.trap_id <= MLXSW_TRAP_ID_MIRROR_SESSION7 &&
 		   mlxsw_pci->max_cqe_ver >= MLXSW_PCI_CQE_V2) {
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_trap.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_trap.c
index e0e6ee58d31a..5d4ae4886f76 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_trap.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_trap.c
@@ -108,7 +108,7 @@ static void mlxsw_sp_rx_drop_listener(struct sk_buff *skb, u8 local_port,
 static void mlxsw_sp_rx_acl_drop_listener(struct sk_buff *skb, u8 local_port,
 					  void *trap_ctx)
 {
-	u32 cookie_index = mlxsw_skb_cb(skb)->cookie_index;
+	u32 cookie_index = mlxsw_skb_cb(skb)->rx_md_info.cookie_index;
 	const struct flow_action_cookie *fa_cookie;
 	struct devlink_port *in_devlink_port;
 	struct mlxsw_sp_port *mlxsw_sp_port;
-- 
2.29.2

