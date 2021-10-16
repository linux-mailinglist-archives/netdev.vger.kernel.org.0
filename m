Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0390842FF73
	for <lists+netdev@lfdr.de>; Sat, 16 Oct 2021 02:39:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239317AbhJPAlO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Oct 2021 20:41:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:58738 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236462AbhJPAlL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 15 Oct 2021 20:41:11 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0838761242;
        Sat, 16 Oct 2021 00:39:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1634344744;
        bh=Fiwv/lYWx0cc/u+2z5E2ASE8v9H3yAUrKvOUdYx4X6A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fOfV7OGTrW7oyWPtoXJ79hxOeuyvSKR+3v/tZ9otQOYyuJwXigTdmBrx8TlTpau+j
         2KecHgL+0O1e8wR2eO2rbEiobPIBEUMb0imP0qjXb6iSVtFkmpkvnMMS9p3+q5wr4u
         R5jWWMBEMNQoMrAi1YKMX300pwazR8Z1rKEJv2U2i9bYTciauSOryZyXQadUDS3T+K
         xAOWW5SgX+SUwlz4pNT6tEadoWN0MyQaJSczPOPf8wq+T7x79iuEoM9p5RAVUxQErB
         xN++XbR4G5JySlCXxnXW5OE3RnFtZWBk+1i+Mxv2k6iybRZENcTdcgMbLDbDBWAiRA
         BIyyUkg88zxhQ==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Amir Tzin <amirtz@nvidia.com>,
        Moshe Shemesh <moshe@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next 01/13] net/mlx5: Add layout to support default timeouts register
Date:   Fri, 15 Oct 2021 17:38:50 -0700
Message-Id: <20211016003902.57116-2-saeed@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211016003902.57116-1-saeed@kernel.org>
References: <20211016003902.57116-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Amir Tzin <amirtz@nvidia.com>

Add needed structures and defines for DTOR (default timeouts register).
This will be used to get timeouts values from FW instead of hard coded
values in the driver code thus enabling support for slower devices which
need longer timeouts.

Signed-off-by: Amir Tzin <amirtz@nvidia.com>
Reviewed-by: Moshe Shemesh <moshe@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 include/linux/mlx5/device.h   |  4 +++-
 include/linux/mlx5/driver.h   |  1 +
 include/linux/mlx5/mlx5_ifc.h | 37 ++++++++++++++++++++++++++++++++++-
 3 files changed, 40 insertions(+), 2 deletions(-)

diff --git a/include/linux/mlx5/device.h b/include/linux/mlx5/device.h
index 66eaf0aa7f69..109cc8106d16 100644
--- a/include/linux/mlx5/device.h
+++ b/include/linux/mlx5/device.h
@@ -577,7 +577,9 @@ struct mlx5_init_seg {
 	__be32			rsvd1[120];
 	__be32			initializing;
 	struct health_buffer	health;
-	__be32			rsvd2[880];
+	__be32			rsvd2[878];
+	__be32			cmd_exec_to;
+	__be32			cmd_q_init_to;
 	__be32			internal_timer_h;
 	__be32			internal_timer_l;
 	__be32			rsvd3[2];
diff --git a/include/linux/mlx5/driver.h b/include/linux/mlx5/driver.h
index 0ca719c00824..ccbd87fbd3bf 100644
--- a/include/linux/mlx5/driver.h
+++ b/include/linux/mlx5/driver.h
@@ -156,6 +156,7 @@ enum {
 	MLX5_REG_MIRC		 = 0x9162,
 	MLX5_REG_SBCAM		 = 0xB01F,
 	MLX5_REG_RESOURCE_DUMP   = 0xC000,
+	MLX5_REG_DTOR            = 0xC00E,
 };
 
 enum mlx5_qpts_trust_state {
diff --git a/include/linux/mlx5/mlx5_ifc.h b/include/linux/mlx5/mlx5_ifc.h
index 993204a6c1a1..b8bff5109656 100644
--- a/include/linux/mlx5/mlx5_ifc.h
+++ b/include/linux/mlx5/mlx5_ifc.h
@@ -1306,7 +1306,8 @@ struct mlx5_ifc_cmd_hca_cap_bits {
 	u8         vhca_resource_manager[0x1];
 
 	u8         hca_cap_2[0x1];
-	u8         reserved_at_21[0x2];
+	u8         reserved_at_21[0x1];
+	u8         dtor[0x1];
 	u8         event_on_vhca_state_teardown_request[0x1];
 	u8         event_on_vhca_state_in_use[0x1];
 	u8         event_on_vhca_state_active[0x1];
@@ -2807,6 +2808,40 @@ struct mlx5_ifc_dropped_packet_logged_bits {
 	u8         reserved_at_0[0xe0];
 };
 
+struct mlx5_ifc_default_timeout_bits {
+	u8         to_multiplier[0x3];
+	u8         reserved_at_3[0x9];
+	u8         to_value[0x14];
+};
+
+struct mlx5_ifc_dtor_reg_bits {
+	u8         reserved_at_0[0x20];
+
+	struct mlx5_ifc_default_timeout_bits pcie_toggle_to;
+
+	u8         reserved_at_40[0x60];
+
+	struct mlx5_ifc_default_timeout_bits health_poll_to;
+
+	struct mlx5_ifc_default_timeout_bits full_crdump_to;
+
+	struct mlx5_ifc_default_timeout_bits fw_reset_to;
+
+	struct mlx5_ifc_default_timeout_bits flush_on_err_to;
+
+	struct mlx5_ifc_default_timeout_bits pci_sync_update_to;
+
+	struct mlx5_ifc_default_timeout_bits tear_down_to;
+
+	struct mlx5_ifc_default_timeout_bits fsm_reactivate_to;
+
+	struct mlx5_ifc_default_timeout_bits reclaim_pages_to;
+
+	struct mlx5_ifc_default_timeout_bits reclaim_vfs_pages_to;
+
+	u8         reserved_at_1c0[0x40];
+};
+
 enum {
 	MLX5_CQ_ERROR_SYNDROME_CQ_OVERRUN                 = 0x1,
 	MLX5_CQ_ERROR_SYNDROME_CQ_ACCESS_VIOLATION_ERROR  = 0x2,
-- 
2.31.1

