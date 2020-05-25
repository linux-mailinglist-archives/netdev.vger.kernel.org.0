Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7BA7B1E1393
	for <lists+netdev@lfdr.de>; Mon, 25 May 2020 19:44:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388874AbgEYRoS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 May 2020 13:44:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:48102 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388621AbgEYRoR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 25 May 2020 13:44:17 -0400
Received: from localhost (unknown [213.57.247.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7AA252078B;
        Mon, 25 May 2020 17:44:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1590428656;
        bh=U4xEoEAMD+gxN54kmCrCFqtSFiVJjCxsHrJxV0/5Fa0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TCKhCsW+OoAIo7AkmCic/StxTvvhqwP45yg4ezvDW7a3gFce9tJI6bsufCbNrGiD7
         QBBWw+otWB7BPhloXI3VSMBcJVAedpdusM6EQzpqhZ6fW5Ux3Z5PcK3y9PUwteBK2e
         +uD63H3D5+cdf+ojQw1AUEj0ktELtnudo2v/1qbg=
From:   Leon Romanovsky <leon@kernel.org>
To:     Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@mellanox.com>
Cc:     Leon Romanovsky <leonro@mellanox.com>, linux-rdma@vger.kernel.org,
        Maor Gottlieb <maorg@mellanox.com>,
        Mark Zhang <markz@mellanox.com>, netdev@vger.kernel.org,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [PATCH mlx5-next v2 1/9] net/mlx5: Add ability to read and write ECE options
Date:   Mon, 25 May 2020 20:43:53 +0300
Message-Id: <20200525174401.71152-2-leon@kernel.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200525174401.71152-1-leon@kernel.org>
References: <20200525174401.71152-1-leon@kernel.org>
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
* create_qp() - default ECE options for that type of QP.
* modify_qp() - enabled ECE options after QP state transition.

IN fields:
* create_qp() - create QP with this ECE option.
* modify_qp() - requested options. For unconnected QPs, the FW
will return an error if ECE is already configured with any options
that not equal to previously set.

Reviewed-by: Mark Zhang <markz@mellanox.com>
Reviewed-by: Maor Gottlieb <maorg@mellanox.com>
Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
---
 include/linux/mlx5/mlx5_ifc.h | 24 ++++++++++++++----------
 1 file changed, 14 insertions(+), 10 deletions(-)

diff --git a/include/linux/mlx5/mlx5_ifc.h b/include/linux/mlx5/mlx5_ifc.h
index 6b22e5a96f10..01f24e34ffc9 100644
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
@@ -4220,7 +4220,8 @@ struct mlx5_ifc_rts2rts_qp_out_bits {
 
 	u8         syndrome[0x20];
 
-	u8         reserved_at_40[0x40];
+	u8         reserved_at_40[0x20];
+	u8         ece[0x20];
 };
 
 struct mlx5_ifc_rts2rts_qp_in_bits {
@@ -4237,7 +4238,7 @@ struct mlx5_ifc_rts2rts_qp_in_bits {
 
 	u8         opt_param_mask[0x20];
 
-	u8         reserved_at_a0[0x20];
+	u8         ece[0x20];
 
 	struct mlx5_ifc_qpc_bits qpc;
 
@@ -4250,7 +4251,8 @@ struct mlx5_ifc_rtr2rts_qp_out_bits {
 
 	u8         syndrome[0x20];
 
-	u8         reserved_at_40[0x40];
+	u8         reserved_at_40[0x20];
+	u8         ece[0x20];
 };
 
 struct mlx5_ifc_rtr2rts_qp_in_bits {
@@ -4267,7 +4269,7 @@ struct mlx5_ifc_rtr2rts_qp_in_bits {
 
 	u8         opt_param_mask[0x20];
 
-	u8         reserved_at_a0[0x20];
+	u8         ece[0x20];
 
 	struct mlx5_ifc_qpc_bits qpc;
 
@@ -4819,7 +4821,8 @@ struct mlx5_ifc_query_qp_out_bits {
 
 	u8         syndrome[0x20];
 
-	u8         reserved_at_40[0x40];
+	u8         reserved_at_40[0x20];
+	u8         ece[0x20];
 
 	u8         opt_param_mask[0x20];
 
@@ -6584,7 +6587,8 @@ struct mlx5_ifc_init2rtr_qp_out_bits {
 
 	u8         syndrome[0x20];
 
-	u8         reserved_at_40[0x40];
+	u8         reserved_at_40[0x20];
+	u8         ece[0x20];
 };
 
 struct mlx5_ifc_init2rtr_qp_in_bits {
@@ -6601,7 +6605,7 @@ struct mlx5_ifc_init2rtr_qp_in_bits {
 
 	u8         opt_param_mask[0x20];
 
-	u8         reserved_at_a0[0x20];
+	u8         ece[0x20];
 
 	struct mlx5_ifc_qpc_bits qpc;
 
@@ -7697,7 +7701,7 @@ struct mlx5_ifc_create_qp_out_bits {
 	u8         reserved_at_40[0x8];
 	u8         qpn[0x18];
 
-	u8         reserved_at_60[0x20];
+	u8         ece[0x20];
 };
 
 struct mlx5_ifc_create_qp_in_bits {
@@ -7711,7 +7715,7 @@ struct mlx5_ifc_create_qp_in_bits {
 
 	u8         opt_param_mask[0x20];
 
-	u8         reserved_at_a0[0x20];
+	u8         ece[0x20];
 
 	struct mlx5_ifc_qpc_bits qpc;
 
-- 
2.26.2

