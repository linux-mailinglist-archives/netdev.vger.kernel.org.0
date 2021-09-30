Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 71C6B41D4FB
	for <lists+netdev@lfdr.de>; Thu, 30 Sep 2021 10:04:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349026AbhI3IGH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Sep 2021 04:06:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:60770 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1348955AbhI3IEb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 30 Sep 2021 04:04:31 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8600B615E2;
        Thu, 30 Sep 2021 08:02:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1632988958;
        bh=B5x/YfaxZWZGgYG2OovoXwMqdWqPRWYihCWBUob24u4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oJqXfPvIiHDaOB+avbUN10cNUsY0PybQRpOWg11rRwPBjFiYsYljpuHLhTVmRdelH
         hLfOCnyNNjv7If2i+vlfrpeVtsl3iWXQTOB242a497GQmfLLP4rVIa/Yk3/n9ooA4e
         vY0c3i0F/hlX64j/6JW2Ko0LNGqZHQQjezYlcHyWKEoUXz4xj55ZXi4PsGn7dT/4EN
         9EZ4G/X97dm3W1y7DeCgMGabEfLPJGo6O5jmvNjPbVaTC7PAYrWRl1w3R6ZFXQ6eBF
         vkk2w1tfQynMEnwc6drrB8EaT8FEodTxx9LSWLOMwr80EqmJV1LqAp7vo+fh5hmwjf
         /2ExUHQhqiVNA==
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
Subject: [PATCH mlx5-next v2 01/13] net/mlx5: Add ifc bits to support optional counters
Date:   Thu, 30 Sep 2021 11:02:17 +0300
Message-Id: <8874035d636b5b68777e40ac9e3c5b9f1f14d22d.1632988543.git.leonro@nvidia.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <cover.1632988543.git.leonro@nvidia.com>
References: <cover.1632988543.git.leonro@nvidia.com>
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

