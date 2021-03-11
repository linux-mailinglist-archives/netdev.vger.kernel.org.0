Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AC5A9336CF1
	for <lists+netdev@lfdr.de>; Thu, 11 Mar 2021 08:10:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232011AbhCKHKI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Mar 2021 02:10:08 -0500
Received: from mail.kernel.org ([198.145.29.99]:52356 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231623AbhCKHJo (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 11 Mar 2021 02:09:44 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id B746965007;
        Thu, 11 Mar 2021 07:09:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1615446584;
        bh=4q7hjJWPl7dW025LS2Jh+50dbVvqGiEw4iHY88uFuRU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iQF2/VQlOUJ5bgY/9zXNnOUp/+5JWRw7bqzXjWvp+OCJF5crG0j8x5TcetpFDPE2E
         bITMdyPuOGllz3dA1PMHeWh+KXOf56dH/yh6XRTu3K52ymsFNg9N9MJC/uKJZLiyDR
         gpToRjTb3pHNzvwlSdem2eEfzZBlmgBK0TwCQaflxOAsGG+C7A0r3CTZT/giweSYy0
         GiMPSkgVTzR/ilJ32wdliIvnsq/S9UBdLf/ROQQdIqKlk+Dgead1vXj0oe049vCTb1
         T+5gIjEs22zG2cwgUmab/8K8mHeKO5yqUkcUJJKfTc9qKi6J561M/z/tcGCg9KTsW/
         8t3d4lNHbljWw==
From:   Saeed Mahameed <saeed@kernel.org>
To:     Saeed Mahameed <saeedm@nvidia.com>,
        Leon Romanovsky <leonro@nvidia.com>, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org
Cc:     Mark Bloch <mbloch@nvidia.com>
Subject: [PATCH mlx5-next 8/9] net/mlx5: Add IFC bits needed for single FDB mode
Date:   Wed, 10 Mar 2021 23:09:14 -0800
Message-Id: <20210311070915.321814-9-saeed@kernel.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210311070915.321814-1-saeed@kernel.org>
References: <20210311070915.321814-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Mark Bloch <mbloch@nvidia.com>

Currently we operate in a mode where each eswitch manager has a separate
FDB. In order to combine these multiple FDBs we expose new caps to allow
this:

- Set root flow table which isn't native.
- Set FDB a different selection mode when in LAG mode.

Signed-off-by: Mark Bloch <mbloch@nvidia.com>
Reviewed-by: Saeed Mahameed <saeedm@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 include/linux/mlx5/mlx5_ifc.h | 21 +++++++++++++++------
 1 file changed, 15 insertions(+), 6 deletions(-)

diff --git a/include/linux/mlx5/mlx5_ifc.h b/include/linux/mlx5/mlx5_ifc.h
index df5d91c8b2d4..3ee7a86f39e4 100644
--- a/include/linux/mlx5/mlx5_ifc.h
+++ b/include/linux/mlx5/mlx5_ifc.h
@@ -806,9 +806,11 @@ struct mlx5_ifc_e_switch_cap_bits {
 	u8         vport_svlan_insert[0x1];
 	u8         vport_cvlan_insert_if_not_exist[0x1];
 	u8         vport_cvlan_insert_overwrite[0x1];
-	u8         reserved_at_5[0x3];
+	u8         reserved_at_5[0x2];
+	u8         esw_shared_ingress_acl[0x1];
 	u8         esw_uplink_ingress_acl[0x1];
-	u8         reserved_at_9[0x10];
+	u8         root_ft_on_other_esw[0x1];
+	u8         reserved_at_a[0xf];
 	u8         esw_functions_changed[0x1];
 	u8         reserved_at_1a[0x1];
 	u8         ecpf_vport_exists[0x1];
@@ -1502,7 +1504,8 @@ struct mlx5_ifc_cmd_hca_cap_bits {
 	u8         reserved_at_270[0x6];
 	u8         lag_dct[0x2];
 	u8         lag_tx_port_affinity[0x1];
-	u8         reserved_at_279[0x2];
+	u8         lag_native_fdb_selection[0x1];
+	u8         reserved_at_27a[0x1];
 	u8         lag_master[0x1];
 	u8         num_lag_ports[0x4];
 
@@ -10036,14 +10039,19 @@ struct mlx5_ifc_set_flow_table_root_in_bits {
 	u8         reserved_at_60[0x20];
 
 	u8         table_type[0x8];
-	u8         reserved_at_88[0x18];
+	u8         reserved_at_88[0x7];
+	u8         table_of_other_vport[0x1];
+	u8         table_vport_number[0x10];
 
 	u8         reserved_at_a0[0x8];
 	u8         table_id[0x18];
 
 	u8         reserved_at_c0[0x8];
 	u8         underlay_qpn[0x18];
-	u8         reserved_at_e0[0x120];
+	u8         table_eswitch_owner_vhca_id_valid[0x1];
+	u8         reserved_at_e1[0xf];
+	u8         table_eswitch_owner_vhca_id[0x10];
+	u8         reserved_at_100[0x100];
 };
 
 enum {
@@ -10273,7 +10281,8 @@ struct mlx5_ifc_dcbx_param_bits {
 };
 
 struct mlx5_ifc_lagc_bits {
-	u8         reserved_at_0[0x1d];
+	u8         fdb_selection_mode[0x1];
+	u8         reserved_at_1[0x1c];
 	u8         lag_state[0x3];
 
 	u8         reserved_at_20[0x14];
-- 
2.29.2

