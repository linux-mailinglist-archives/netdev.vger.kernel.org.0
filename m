Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1A80A40BBE8
	for <lists+netdev@lfdr.de>; Wed, 15 Sep 2021 01:07:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235873AbhINXJD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Sep 2021 19:09:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:45134 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235594AbhINXJA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 14 Sep 2021 19:09:00 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D250960F46;
        Tue, 14 Sep 2021 23:07:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631660862;
        bh=aaKaYR2sBksQpkejwPiEc/hFK8LOLip8JH6pG0FuYYQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GdpSESlgOZVM9dF+qXPtUkqrOS+0LwY6sAC9iKummXUgP2gipTbABg/yP/eCZ82As
         bvx4NiGnjJLSnMIUFvwyLTgKjYapAgJK4k83DSKfM/71vvFh3yFMeT9qtsuYfVCcOd
         RaM0BqPaPKFaBioHvqDZM7tmF1PI8MndSNI7zX6BdjPxilAqml7KV+X/z+gZ/tXpYT
         YX/VeXpLl87/S+wpQXf6WZsTUZe/KII6QZcngNDusziGVhrEo4kBGF7CisFXk3A24P
         t8h6o9J3ZWoqqw190sOZdrKaqGMW5XkTM1czeNo7GWsn38RiV0DjveteFP1gGhPI9w
         GHzLCAz0cCzhw==
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
        Naresh Kumar PBS <nareshkumar.pbs@broadcom.com>,
        netdev@vger.kernel.org, Potnuri Bharat Teja <bharat@chelsio.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Selvin Xavier <selvin.xavier@broadcom.com>,
        Shiraz Saleem <shiraz.saleem@intel.com>,
        Yishai Hadas <yishaih@nvidia.com>,
        Zhu Yanjun <zyjzyj2000@gmail.com>
Subject: [PATCH mlx5-next v1 01/11] net/mlx5: Add ifc bits to support optional counters
Date:   Wed, 15 Sep 2021 02:07:20 +0300
Message-Id: <939e84d6d3e312330f4527dcd75df2275d675f19.1631660727.git.leonro@nvidia.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <cover.1631660727.git.leonro@nvidia.com>
References: <cover.1631660727.git.leonro@nvidia.com>
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
index 4a7e6914ed9b..d90a65b6824f 100644
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

