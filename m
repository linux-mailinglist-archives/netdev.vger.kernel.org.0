Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 073891DAD6F
	for <lists+netdev@lfdr.de>; Wed, 20 May 2020 10:29:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726819AbgETI3a (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 May 2020 04:29:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:49336 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726224AbgETI33 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 20 May 2020 04:29:29 -0400
Received: from localhost (unknown [213.57.247.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 72C83206C3;
        Wed, 20 May 2020 08:29:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589963369;
        bh=XNw0hT48zGZQdbIlQl/Q2t+QaeF7/dJWJf+ntVn24Hw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nzuUcZgeIjxF1qkQTSd7sXBRTv8/uhn/eyLTam/TxD1SeRoVEDVxtoPbPUhh3CQZN
         kgCdBKb9rYzooQ71ZoVewJlO1qUCLlpJx7pX69YlRw7q9ju/kqgrpIlR3/6+YeoLRQ
         gvMwBtzdNvs/Tc5/UXdE5xKj8AGXFvB2g1znVpB8=
From:   Leon Romanovsky <leon@kernel.org>
To:     Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@mellanox.com>
Cc:     Leon Romanovsky <leonro@mellanox.com>, linux-rdma@vger.kernel.org,
        Maor Gottlieb <maorg@mellanox.com>, netdev@vger.kernel.org,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [PATCH mlx5-next 1/8] net/mlx5: Add ability to read and write ECE options
Date:   Wed, 20 May 2020 11:29:12 +0300
Message-Id: <20200520082919.440939-2-leon@kernel.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200520082919.440939-1-leon@kernel.org>
References: <20200520082919.440939-1-leon@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Leon Romanovsky <leonro@mellanox.com>

The end result of RDMA-CM ECE handshake is ECE options, which is
needed to be used while configuring data QPs. Such options can
come in any QP state, so add in/out fields to set and query
ECE options.

OUT fields:
* create_qp()/create_dct() - default ECE options for that type of QP.
* modify_qp() - enabled ECE options after QP state transition.

IN fields:
* create_qp()/create_dct() - create QP with this ECE option.
* modify_qp() - requested options. For unconnected QPs, the FW
will return an error if ECE is already configured with any options
that not equal to previously set.

Reviewed-by: Maor Gottlieb <maorg@mellanox.com>
Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
---
 include/linux/mlx5/mlx5_ifc.h | 29 +++++++++++++++++------------
 1 file changed, 17 insertions(+), 12 deletions(-)

diff --git a/include/linux/mlx5/mlx5_ifc.h b/include/linux/mlx5/mlx5_ifc.h
index 6b22e5a96f10..5e73bc7322c4 100644
--- a/include/linux/mlx5/mlx5_ifc.h
+++ b/include/linux/mlx5/mlx5_ifc.h
@@ -1296,7 +1296,7 @@ struct mlx5_ifc_cmd_hca_cap_bits {
 	u8         port_type[0x2];
 	u8         num_ports[0x8];
 
-	u8         reserved_at_1c0[0x1];
+	u8         ece_support[0x1];
 	u8         pps[0x1];
 	u8         pps_modify[0x1];
 	u8         log_max_msg[0x5];
@@ -3690,7 +3690,8 @@ struct mlx5_ifc_dctc_bits {
 	u8         ecn[0x2];
 	u8         dscp[0x6];
 
-	u8         reserved_at_1c0[0x40];
+	u8         reserved_at_1c0[0x20];
+	u8	   ece[0x20];
 };
 
 enum {
@@ -4220,7 +4221,8 @@ struct mlx5_ifc_rts2rts_qp_out_bits {
 
 	u8         syndrome[0x20];
 
-	u8         reserved_at_40[0x40];
+	u8         reserved_at_40[0x20];
+	u8         ece[0x20];
 };
 
 struct mlx5_ifc_rts2rts_qp_in_bits {
@@ -4237,7 +4239,7 @@ struct mlx5_ifc_rts2rts_qp_in_bits {
 
 	u8         opt_param_mask[0x20];
 
-	u8         reserved_at_a0[0x20];
+	u8         ece[0x20];
 
 	struct mlx5_ifc_qpc_bits qpc;
 
@@ -4250,7 +4252,8 @@ struct mlx5_ifc_rtr2rts_qp_out_bits {
 
 	u8         syndrome[0x20];
 
-	u8         reserved_at_40[0x40];
+	u8         reserved_at_40[0x20];
+	u8         ece[0x20];
 };
 
 struct mlx5_ifc_rtr2rts_qp_in_bits {
@@ -4267,7 +4270,7 @@ struct mlx5_ifc_rtr2rts_qp_in_bits {
 
 	u8         opt_param_mask[0x20];
 
-	u8         reserved_at_a0[0x20];
+	u8         ece[0x20];
 
 	struct mlx5_ifc_qpc_bits qpc;
 
@@ -4819,7 +4822,8 @@ struct mlx5_ifc_query_qp_out_bits {
 
 	u8         syndrome[0x20];
 
-	u8         reserved_at_40[0x40];
+	u8         reserved_at_40[0x20];
+	u8         ece[0x20];
 
 	u8         opt_param_mask[0x20];
 
@@ -6584,7 +6588,8 @@ struct mlx5_ifc_init2rtr_qp_out_bits {
 
 	u8         syndrome[0x20];
 
-	u8         reserved_at_40[0x40];
+	u8         reserved_at_40[0x20];
+	u8         ece[0x20];
 };
 
 struct mlx5_ifc_init2rtr_qp_in_bits {
@@ -6601,7 +6606,7 @@ struct mlx5_ifc_init2rtr_qp_in_bits {
 
 	u8         opt_param_mask[0x20];
 
-	u8         reserved_at_a0[0x20];
+	u8         ece[0x20];
 
 	struct mlx5_ifc_qpc_bits qpc;
 
@@ -7697,7 +7702,7 @@ struct mlx5_ifc_create_qp_out_bits {
 	u8         reserved_at_40[0x8];
 	u8         qpn[0x18];
 
-	u8         reserved_at_60[0x20];
+	u8         ece[0x20];
 };
 
 struct mlx5_ifc_create_qp_in_bits {
@@ -7711,7 +7716,7 @@ struct mlx5_ifc_create_qp_in_bits {
 
 	u8         opt_param_mask[0x20];
 
-	u8         reserved_at_a0[0x20];
+	u8         ece[0x20];
 
 	struct mlx5_ifc_qpc_bits qpc;
 
@@ -7936,7 +7941,7 @@ struct mlx5_ifc_create_dct_out_bits {
 	u8         reserved_at_40[0x8];
 	u8         dctn[0x18];
 
-	u8         reserved_at_60[0x20];
+	u8         ece[0x20];
 };
 
 struct mlx5_ifc_create_dct_in_bits {
-- 
2.26.2

