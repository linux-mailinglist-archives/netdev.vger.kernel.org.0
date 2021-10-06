Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 05CFE423AF3
	for <lists+netdev@lfdr.de>; Wed,  6 Oct 2021 11:52:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238098AbhJFJy2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Oct 2021 05:54:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:50528 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238080AbhJFJyY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 6 Oct 2021 05:54:24 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A5D6B61058;
        Wed,  6 Oct 2021 09:52:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1633513952;
        bh=B5x/YfaxZWZGgYG2OovoXwMqdWqPRWYihCWBUob24u4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Rx7IF2CTyk+0cIJEUDqNcTOg6TcevhXQUMls0FlibD5gROqMhoUvikiw+Q68sxXA/
         Ek7Fv5yVNPODEGuU3okMDEGSHftJXDzb0QwVQeLqXTgDUFHwrTZ1bEEQplHVa6Emm1
         t9rGLEhJsGEa7Lb2O2xSjofovp7uqunFhDRV9/rADQcfGRF9T02NZW2JSAAmqD5wQj
         YWgouWYK20y29DCPD7f0BJW9EuCmDkgxkVkSiI32spkP5E0/TuTJ5n0aEm3NBiCn5p
         UU0rC1aoHqMjbNKlaYPIMSnC40JJLjCc3In6TMIctBX1SCm6F5iAy01Cg1e8nXoMfB
         jicdfCTf0UWQA==
From:   Leon Romanovsky <leon@kernel.org>
To:     Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@nvidia.com>
Cc:     Aharon Landau <aharonl@nvidia.com>,
        Dennis Dalessandro <dennis.dalessandro@cornelisnetworks.com>,
        Gal Pressman <galpress@amazon.com>,
        Jakub Kicinski <kuba@kernel.org>, linux-kernel@vger.kernel.org,
        linux-rdma@vger.kernel.org, Maor Gottlieb <maorg@nvidia.com>,
        Mark Zhang <markzhang@nvidia.com>,
        Mike Marciniszyn <mike.marciniszyn@cornelisnetworks.com>,
        Mustafa Ismail <mustafa.ismail@intel.com>,
        netdev@vger.kernel.org, Potnuri Bharat Teja <bharat@chelsio.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Selvin Xavier <selvin.xavier@broadcom.com>,
        Shiraz Saleem <shiraz.saleem@intel.com>,
        Yishai Hadas <yishaih@nvidia.com>,
        Zhu Yanjun <zyjzyj2000@gmail.com>
Subject: [PATCH mlx5-next v3 01/13] net/mlx5: Add ifc bits to support optional counters
Date:   Wed,  6 Oct 2021 12:52:04 +0300
Message-Id: <7afaf0a646c014ad1ba777377dd5d44f7d3ce337.1633513239.git.leonro@nvidia.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <cover.1633513239.git.leonro@nvidia.com>
References: <cover.1633513239.git.leonro@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Aharon Landau <aharonl@nvidia.com>

Adding bth_opcode field and the relevant bits. This field will be used
to capture and count congestion notification packets (CNP).

Adding source_vhca_port support bit.
This field will be used to check the capability to use the
source_vhca_port as a match criteria in cases of dual port.

Signed-off-by: Aharon Landau <aharonl@nvidia.com>
Reviewed-by: Maor Gottlieb <maorg@nvidia.com>
Signed-off-by: Mark Zhang <markzhang@nvidia.com>
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 include/linux/mlx5/mlx5_ifc.h | 22 +++++++++++++++++++---
 1 file changed, 19 insertions(+), 3 deletions(-)

diff --git a/include/linux/mlx5/mlx5_ifc.h b/include/linux/mlx5/mlx5_ifc.h
index c1cef8f35e00..399ea52171fe 100644
--- a/include/linux/mlx5/mlx5_ifc.h
+++ b/include/linux/mlx5/mlx5_ifc.h
@@ -342,7 +342,7 @@ struct mlx5_ifc_flow_table_fields_supported_bits {
 	u8         outer_geneve_oam[0x1];
 	u8         outer_geneve_protocol_type[0x1];
 	u8         outer_geneve_opt_len[0x1];
-	u8         reserved_at_1e[0x1];
+	u8         source_vhca_port[0x1];
 	u8         source_eswitch_port[0x1];
 
 	u8         inner_dmac[0x1];
@@ -393,6 +393,14 @@ struct mlx5_ifc_flow_table_fields_supported_bits {
 	u8         metadata_reg_c_0[0x1];
 };
 
+struct mlx5_ifc_flow_table_fields_supported_2_bits {
+	u8         reserved_at_0[0xe];
+	u8         bth_opcode[0x1];
+	u8         reserved_at_f[0x11];
+
+	u8         reserved_at_20[0x60];
+};
+
 struct mlx5_ifc_flow_table_prop_layout_bits {
 	u8         ft_support[0x1];
 	u8         reserved_at_1[0x1];
@@ -539,7 +547,7 @@ struct mlx5_ifc_fte_match_set_misc_bits {
 	union mlx5_ifc_gre_key_bits gre_key;
 
 	u8         vxlan_vni[0x18];
-	u8         reserved_at_b8[0x8];
+	u8         bth_opcode[0x8];
 
 	u8         geneve_vni[0x18];
 	u8         reserved_at_d8[0x7];
@@ -756,7 +764,15 @@ struct mlx5_ifc_flow_table_nic_cap_bits {
 
 	struct mlx5_ifc_flow_table_prop_layout_bits flow_table_properties_nic_transmit_sniffer;
 
-	u8         reserved_at_e00[0x1200];
+	u8         reserved_at_e00[0x700];
+
+	struct mlx5_ifc_flow_table_fields_supported_2_bits ft_field_support_2_nic_receive_rdma;
+
+	u8         reserved_at_1580[0x280];
+
+	struct mlx5_ifc_flow_table_fields_supported_2_bits ft_field_support_2_nic_transmit_rdma;
+
+	u8         reserved_at_1880[0x780];
 
 	u8         sw_steering_nic_rx_action_drop_icm_address[0x40];
 
-- 
2.31.1

