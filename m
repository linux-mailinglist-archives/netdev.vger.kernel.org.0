Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 768624822BC
	for <lists+netdev@lfdr.de>; Fri, 31 Dec 2021 09:20:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242808AbhLaIUz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Dec 2021 03:20:55 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:60672 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239991AbhLaIUs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 Dec 2021 03:20:48 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 840EBB81D56
        for <netdev@vger.kernel.org>; Fri, 31 Dec 2021 08:20:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB904C36AEB;
        Fri, 31 Dec 2021 08:20:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1640938846;
        bh=b24/Cfjj4XzttS8S/kP/BczFnFSBKX2oVToyqyy0WH0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kxsIiYX6hyLjkYIxsHIe7HdDH2+MXIC0gxKm0adTTQE+9MuXu1iQspkhu/Sk/90mG
         wPVXcZvXSiVaO4AzWiSv5xRaBs5TimUKfxWyVw3ePXxlPJuwOkS/DTN4f5blI9IccK
         RRCArTF9Wurx1bfwt0hqTWY5Jefe3/Qkn208wwrr83AGmcOpYZDU1JUDK6NIYJWb+g
         KORUq6plv7cJLQHWmViEcqO4SHv3qF9h/BgN8ZKP/RVdtOWwP0W1ZNXy2Kif4xZc6L
         qtpvEO7oPCGzK/osuj/R38+9iBfUwIZkkSS+zd/W3o2FBkqdkGbAB16sNOSsniFFoH
         8K2Hj5tVdU6lA==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Muhammad Sammar <muhammads@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next v2 06/16] net/mlx5: DR, Add missing reserved fields to dr_match_param
Date:   Fri, 31 Dec 2021 00:20:28 -0800
Message-Id: <20211231082038.106490-7-saeed@kernel.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211231082038.106490-1-saeed@kernel.org>
References: <20211231082038.106490-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Muhammad Sammar <muhammads@nvidia.com>

Add the reserved fields to dr_match_param and arrange
as mlx5_ifc_dr_match_param_bits.

Signed-off-by: Muhammad Sammar <muhammads@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../mellanox/mlx5/core/steering/dr_types.h    | 213 ++++++++++--------
 1 file changed, 124 insertions(+), 89 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_types.h b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_types.h
index a19b40a6e813..9f21a72e23b1 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_types.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_types.h
@@ -494,57 +494,64 @@ struct mlx5dr_match_spec {
 	/* Incoming packet Ethertype - this is the Ethertype
 	 * following the last VLAN tag of the packet
 	 */
-	u32 ethertype:16;
 	u32 smac_15_0:16;	/* Source MAC address of incoming packet */
+	u32 ethertype:16;
+
 	u32 dmac_47_16;		/* Destination MAC address of incoming packet */
-	/* VLAN ID of first VLAN tag in the incoming packet.
+
+	u32 dmac_15_0:16;	/* Destination MAC address of incoming packet */
+	/* Priority of first VLAN tag in the incoming packet.
 	 * Valid only when cvlan_tag==1 or svlan_tag==1
 	 */
-	u32 first_vid:12;
+	u32 first_prio:3;
 	/* CFI bit of first VLAN tag in the incoming packet.
 	 * Valid only when cvlan_tag==1 or svlan_tag==1
 	 */
 	u32 first_cfi:1;
-	/* Priority of first VLAN tag in the incoming packet.
+	/* VLAN ID of first VLAN tag in the incoming packet.
 	 * Valid only when cvlan_tag==1 or svlan_tag==1
 	 */
-	u32 first_prio:3;
-	u32 dmac_15_0:16;	/* Destination MAC address of incoming packet */
-	/* TCP flags. ;Bit 0: FIN;Bit 1: SYN;Bit 2: RST;Bit 3: PSH;Bit 4: ACK;
-	 *             Bit 5: URG;Bit 6: ECE;Bit 7: CWR;Bit 8: NS
+	u32 first_vid:12;
+
+	u32 ip_protocol:8;	/* IP protocol */
+	/* Differentiated Services Code Point derived from
+	 * Traffic Class/TOS field of IPv6/v4
 	 */
-	u32 tcp_flags:9;
-	u32 ip_version:4;	/* IP version */
-	u32 frag:1;		/* Packet is an IP fragment */
-	/* The first vlan in the packet is s-vlan (0x8a88).
-	 * cvlan_tag and svlan_tag cannot be set together
+	u32 ip_dscp:6;
+	/* Explicit Congestion Notification derived from
+	 * Traffic Class/TOS field of IPv6/v4
 	 */
-	u32 svlan_tag:1;
+	u32 ip_ecn:2;
 	/* The first vlan in the packet is c-vlan (0x8100).
 	 * cvlan_tag and svlan_tag cannot be set together
 	 */
 	u32 cvlan_tag:1;
-	/* Explicit Congestion Notification derived from
-	 * Traffic Class/TOS field of IPv6/v4
+	/* The first vlan in the packet is s-vlan (0x8a88).
+	 * cvlan_tag and svlan_tag cannot be set together
 	 */
-	u32 ip_ecn:2;
-	/* Differentiated Services Code Point derived from
-	 * Traffic Class/TOS field of IPv6/v4
+	u32 svlan_tag:1;
+	u32 frag:1;		/* Packet is an IP fragment */
+	u32 ip_version:4;	/* IP version */
+	/* TCP flags. ;Bit 0: FIN;Bit 1: SYN;Bit 2: RST;Bit 3: PSH;Bit 4: ACK;
+	 *             Bit 5: URG;Bit 6: ECE;Bit 7: CWR;Bit 8: NS
 	 */
-	u32 ip_dscp:6;
-	u32 ip_protocol:8;	/* IP protocol */
+	u32 tcp_flags:9;
+
+	/* TCP source port.;tcp and udp sport/dport are mutually exclusive */
+	u32 tcp_sport:16;
 	/* TCP destination port.
 	 * tcp and udp sport/dport are mutually exclusive
 	 */
 	u32 tcp_dport:16;
-	/* TCP source port.;tcp and udp sport/dport are mutually exclusive */
-	u32 tcp_sport:16;
+
+	u32 reserved_auto1:24;
 	u32 ttl_hoplimit:8;
-	u32 reserved:24;
-	/* UDP destination port.;tcp and udp sport/dport are mutually exclusive */
-	u32 udp_dport:16;
+
 	/* UDP source port.;tcp and udp sport/dport are mutually exclusive */
 	u32 udp_sport:16;
+	/* UDP destination port.;tcp and udp sport/dport are mutually exclusive */
+	u32 udp_dport:16;
+
 	/* IPv6 source address of incoming packets
 	 * For IPv4 address use bits 31:0 (rest of the bits are reserved)
 	 * This field should be qualified by an appropriate ethertype
@@ -588,96 +595,113 @@ struct mlx5dr_match_spec {
 };
 
 struct mlx5dr_match_misc {
-	u32 source_sqn:24;		/* Source SQN */
-	u32 source_vhca_port:4;
-	/* used with GRE, sequence number exist when gre_s_present == 1 */
-	u32 gre_s_present:1;
-	/* used with GRE, key exist when gre_k_present == 1 */
-	u32 gre_k_present:1;
-	u32 reserved_auto1:1;
 	/* used with GRE, checksum exist when gre_c_present == 1 */
 	u32 gre_c_present:1;
+	u32 reserved_auto1:1;
+	/* used with GRE, key exist when gre_k_present == 1 */
+	u32 gre_k_present:1;
+	/* used with GRE, sequence number exist when gre_s_present == 1 */
+	u32 gre_s_present:1;
+	u32 source_vhca_port:4;
+	u32 source_sqn:24;		/* Source SQN */
+
+	u32 source_eswitch_owner_vhca_id:16;
 	/* Source port.;0xffff determines wire port */
 	u32 source_port:16;
-	u32 source_eswitch_owner_vhca_id:16;
-	/* VLAN ID of first VLAN tag the inner header of the incoming packet.
-	 * Valid only when inner_second_cvlan_tag ==1 or inner_second_svlan_tag ==1
-	 */
-	u32 inner_second_vid:12;
-	/* CFI bit of first VLAN tag in the inner header of the incoming packet.
-	 * Valid only when inner_second_cvlan_tag ==1 or inner_second_svlan_tag ==1
-	 */
-	u32 inner_second_cfi:1;
-	/* Priority of second VLAN tag in the inner header of the incoming packet.
-	 * Valid only when inner_second_cvlan_tag ==1 or inner_second_svlan_tag ==1
-	 */
-	u32 inner_second_prio:3;
-	/* VLAN ID of first VLAN tag the outer header of the incoming packet.
+
+	/* Priority of second VLAN tag in the outer header of the incoming packet.
 	 * Valid only when outer_second_cvlan_tag ==1 or outer_second_svlan_tag ==1
 	 */
-	u32 outer_second_vid:12;
+	u32 outer_second_prio:3;
 	/* CFI bit of first VLAN tag in the outer header of the incoming packet.
 	 * Valid only when outer_second_cvlan_tag ==1 or outer_second_svlan_tag ==1
 	 */
 	u32 outer_second_cfi:1;
-	/* Priority of second VLAN tag in the outer header of the incoming packet.
+	/* VLAN ID of first VLAN tag the outer header of the incoming packet.
 	 * Valid only when outer_second_cvlan_tag ==1 or outer_second_svlan_tag ==1
 	 */
-	u32 outer_second_prio:3;
-	u32 gre_protocol:16;		/* GRE Protocol (outer) */
-	u32 reserved_auto3:12;
-	/* The second vlan in the inner header of the packet is s-vlan (0x8a88).
-	 * inner_second_cvlan_tag and inner_second_svlan_tag cannot be set together
+	u32 outer_second_vid:12;
+	/* Priority of second VLAN tag in the inner header of the incoming packet.
+	 * Valid only when inner_second_cvlan_tag ==1 or inner_second_svlan_tag ==1
 	 */
-	u32 inner_second_svlan_tag:1;
-	/* The second vlan in the outer header of the packet is s-vlan (0x8a88).
+	u32 inner_second_prio:3;
+	/* CFI bit of first VLAN tag in the inner header of the incoming packet.
+	 * Valid only when inner_second_cvlan_tag ==1 or inner_second_svlan_tag ==1
+	 */
+	u32 inner_second_cfi:1;
+	/* VLAN ID of first VLAN tag the inner header of the incoming packet.
+	 * Valid only when inner_second_cvlan_tag ==1 or inner_second_svlan_tag ==1
+	 */
+	u32 inner_second_vid:12;
+
+	u32 outer_second_cvlan_tag:1;
+	u32 inner_second_cvlan_tag:1;
+	/* The second vlan in the outer header of the packet is c-vlan (0x8100).
 	 * outer_second_cvlan_tag and outer_second_svlan_tag cannot be set together
 	 */
 	u32 outer_second_svlan_tag:1;
 	/* The second vlan in the inner header of the packet is c-vlan (0x8100).
 	 * inner_second_cvlan_tag and inner_second_svlan_tag cannot be set together
 	 */
-	u32 inner_second_cvlan_tag:1;
-	/* The second vlan in the outer header of the packet is c-vlan (0x8100).
+	u32 inner_second_svlan_tag:1;
+	/* The second vlan in the outer header of the packet is s-vlan (0x8a88).
 	 * outer_second_cvlan_tag and outer_second_svlan_tag cannot be set together
 	 */
-	u32 outer_second_cvlan_tag:1;
-	u32 gre_key_l:8;		/* GRE Key [7:0] (outer) */
+	u32 reserved_auto2:12;
+	/* The second vlan in the inner header of the packet is s-vlan (0x8a88).
+	 * inner_second_cvlan_tag and inner_second_svlan_tag cannot be set together
+	 */
+	u32 gre_protocol:16;		/* GRE Protocol (outer) */
+
 	u32 gre_key_h:24;		/* GRE Key[31:8] (outer) */
-	u32 reserved_auto4:8;
+	u32 gre_key_l:8;		/* GRE Key [7:0] (outer) */
+
 	u32 vxlan_vni:24;		/* VXLAN VNI (outer) */
-	u32 geneve_oam:1;		/* GENEVE OAM field (outer) */
-	u32 reserved_auto5:7;
+	u32 reserved_auto3:8;
+
 	u32 geneve_vni:24;		/* GENEVE VNI field (outer) */
+	u32 reserved_auto4:7;
+	u32 geneve_oam:1;		/* GENEVE OAM field (outer) */
+
+	u32 reserved_auto5:12;
 	u32 outer_ipv6_flow_label:20;	/* Flow label of incoming IPv6 packet (outer) */
+
 	u32 reserved_auto6:12;
 	u32 inner_ipv6_flow_label:20;	/* Flow label of incoming IPv6 packet (inner) */
-	u32 reserved_auto7:12;
-	u32 geneve_protocol_type:16;	/* GENEVE protocol type (outer) */
+
+	u32 reserved_auto7:10;
 	u32 geneve_opt_len:6;		/* GENEVE OptLen (outer) */
-	u32 reserved_auto8:10;
+	u32 geneve_protocol_type:16;	/* GENEVE protocol type (outer) */
+
+	u32 reserved_auto8:8;
 	u32 bth_dst_qp:24;		/* Destination QP in BTH header */
-	u32 reserved_auto9:8;
-	u8 reserved_auto10[20];
+
+	u32 reserved_auto9;
+	u32 outer_esp_spi;
+	u32 reserved_auto10[3];
 };
 
 struct mlx5dr_match_misc2 {
-	u32 outer_first_mpls_ttl:8;		/* First MPLS TTL (outer) */
-	u32 outer_first_mpls_s_bos:1;		/* First MPLS S_BOS (outer) */
-	u32 outer_first_mpls_exp:3;		/* First MPLS EXP (outer) */
 	u32 outer_first_mpls_label:20;		/* First MPLS LABEL (outer) */
-	u32 inner_first_mpls_ttl:8;		/* First MPLS TTL (inner) */
-	u32 inner_first_mpls_s_bos:1;		/* First MPLS S_BOS (inner) */
-	u32 inner_first_mpls_exp:3;		/* First MPLS EXP (inner) */
+	u32 outer_first_mpls_exp:3;		/* First MPLS EXP (outer) */
+	u32 outer_first_mpls_s_bos:1;		/* First MPLS S_BOS (outer) */
+	u32 outer_first_mpls_ttl:8;		/* First MPLS TTL (outer) */
+
 	u32 inner_first_mpls_label:20;		/* First MPLS LABEL (inner) */
-	u32 outer_first_mpls_over_gre_ttl:8;	/* last MPLS TTL (outer) */
-	u32 outer_first_mpls_over_gre_s_bos:1;	/* last MPLS S_BOS (outer) */
-	u32 outer_first_mpls_over_gre_exp:3;	/* last MPLS EXP (outer) */
+	u32 inner_first_mpls_exp:3;		/* First MPLS EXP (inner) */
+	u32 inner_first_mpls_s_bos:1;		/* First MPLS S_BOS (inner) */
+	u32 inner_first_mpls_ttl:8;		/* First MPLS TTL (inner) */
+
 	u32 outer_first_mpls_over_gre_label:20;	/* last MPLS LABEL (outer) */
-	u32 outer_first_mpls_over_udp_ttl:8;	/* last MPLS TTL (outer) */
-	u32 outer_first_mpls_over_udp_s_bos:1;	/* last MPLS S_BOS (outer) */
-	u32 outer_first_mpls_over_udp_exp:3;	/* last MPLS EXP (outer) */
+	u32 outer_first_mpls_over_gre_exp:3;	/* last MPLS EXP (outer) */
+	u32 outer_first_mpls_over_gre_s_bos:1;	/* last MPLS S_BOS (outer) */
+	u32 outer_first_mpls_over_gre_ttl:8;	/* last MPLS TTL (outer) */
+
 	u32 outer_first_mpls_over_udp_label:20;	/* last MPLS LABEL (outer) */
+	u32 outer_first_mpls_over_udp_exp:3;	/* last MPLS EXP (outer) */
+	u32 outer_first_mpls_over_udp_s_bos:1;	/* last MPLS S_BOS (outer) */
+	u32 outer_first_mpls_over_udp_ttl:8;	/* last MPLS TTL (outer) */
+
 	u32 metadata_reg_c_7;			/* metadata_reg_c_7 */
 	u32 metadata_reg_c_6;			/* metadata_reg_c_6 */
 	u32 metadata_reg_c_5;			/* metadata_reg_c_5 */
@@ -687,7 +711,7 @@ struct mlx5dr_match_misc2 {
 	u32 metadata_reg_c_1;			/* metadata_reg_c_1 */
 	u32 metadata_reg_c_0;			/* metadata_reg_c_0 */
 	u32 metadata_reg_a;			/* metadata_reg_a */
-	u8 reserved_auto2[12];
+	u32 reserved_auto1[3];
 };
 
 struct mlx5dr_match_misc3 {
@@ -695,24 +719,34 @@ struct mlx5dr_match_misc3 {
 	u32 outer_tcp_seq_num;
 	u32 inner_tcp_ack_num;
 	u32 outer_tcp_ack_num;
-	u32 outer_vxlan_gpe_vni:24;
+
 	u32 reserved_auto1:8;
-	u32 reserved_auto2:16;
-	u32 outer_vxlan_gpe_flags:8;
+	u32 outer_vxlan_gpe_vni:24;
+
 	u32 outer_vxlan_gpe_next_protocol:8;
+	u32 outer_vxlan_gpe_flags:8;
+	u32 reserved_auto2:16;
+
 	u32 icmpv4_header_data;
 	u32 icmpv6_header_data;
-	u8 icmpv6_code;
-	u8 icmpv6_type;
-	u8 icmpv4_code;
+
 	u8 icmpv4_type;
+	u8 icmpv4_code;
+	u8 icmpv6_type;
+	u8 icmpv6_code;
+
 	u32 geneve_tlv_option_0_data;
-	u8 gtpu_msg_flags;
-	u8 gtpu_msg_type;
+
 	u32 gtpu_teid;
+
+	u8 gtpu_msg_type;
+	u8 gtpu_msg_flags;
+	u32 reserved_auto3:16;
+
 	u32 gtpu_dw_2;
 	u32 gtpu_first_ext_dw_0;
 	u32 gtpu_dw_0;
+	u32 reserved_auto4;
 };
 
 struct mlx5dr_match_misc4 {
@@ -724,6 +758,7 @@ struct mlx5dr_match_misc4 {
 	u32 prog_sample_field_id_2;
 	u32 prog_sample_field_value_3;
 	u32 prog_sample_field_id_3;
+	u32 reserved_auto1[8];
 };
 
 struct mlx5dr_match_param {
-- 
2.33.1

