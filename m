Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6B8812EB5CB
	for <lists+netdev@lfdr.de>; Wed,  6 Jan 2021 00:07:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727239AbhAEXFr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Jan 2021 18:05:47 -0500
Received: from mail.kernel.org ([198.145.29.99]:57186 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726600AbhAEXFr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 5 Jan 2021 18:05:47 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6CBBD230FA;
        Tue,  5 Jan 2021 23:05:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1609887905;
        bh=oVozARm5POr/JOkFPQR119eca0CCfkCDxQuf3XMWkrU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rtdx8mLwY//Wvws62eUUKMbYQC2OBYUCfFDzgyxUWJQeqwXJHYgMsc24IU7vEFGMo
         kq4I6E4zucArnCaDheP41KhW7DQ8z47qZCAQv2G0k4D0wvOgfT4vhNO7kUD97wx5Lj
         ZLq1BxoN5482Yu+MT4ADNNbUmWI2Ucx2GDZlRgNSAhoE7KpATsml8LjEcELJoF1lxk
         nmICX711pzM0ZI7bspBS8VQekyqARUuOYbKsbDfm8blG9R+AMWi/L0qg6Buqdnmfwr
         EE38oncYD2RA0nEmmGCm7yUkQNctqO4/x8h1xBx939EU+LOIkf60YyUcAOYTsPU7hO
         VaeSpCQ/AZ52w==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Yevgeny Kliteynik <kliteyn@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next 02/16] net/mlx5: DR, Move macros from dr_ste.c to header
Date:   Tue,  5 Jan 2021 15:03:19 -0800
Message-Id: <20210105230333.239456-3-saeed@kernel.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210105230333.239456-1-saeed@kernel.org>
References: <20210105230333.239456-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yevgeny Kliteynik <kliteyn@nvidia.com>

Move some macros from dr_ste.c to header - these macros
will be used by all the format-specific functions.

Signed-off-by: Yevgeny Kliteynik <kliteyn@nvidia.com>
Reviewed-by: Saeed Mahameed <saeedm@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../mellanox/mlx5/core/steering/dr_ste.c      | 74 ------------------
 .../mellanox/mlx5/core/steering/dr_ste.h      | 76 +++++++++++++++++++
 2 files changed, 76 insertions(+), 74 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ste.c b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ste.c
index 171f7836fb23..697fdb452e4c 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ste.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ste.c
@@ -6,83 +6,9 @@
 #include "dr_ste.h"
 
 #define DR_STE_CRC_POLY 0xEDB88320L
-#define STE_IPV4 0x1
-#define STE_IPV6 0x2
-#define STE_TCP 0x1
-#define STE_UDP 0x2
-#define STE_SPI 0x3
-#define IP_VERSION_IPV4 0x4
-#define IP_VERSION_IPV6 0x6
-#define STE_SVLAN 0x1
-#define STE_CVLAN 0x2
 
 #define DR_STE_ENABLE_FLOW_TAG BIT(31)
 
-/* Set to STE a specific value using DR_STE_SET */
-#define DR_STE_SET_VAL(lookup_type, tag, t_fname, spec, s_fname, value) do { \
-	if ((spec)->s_fname) { \
-		MLX5_SET(ste_##lookup_type, tag, t_fname, value); \
-		(spec)->s_fname = 0; \
-	} \
-} while (0)
-
-/* Set to STE spec->s_fname to tag->t_fname */
-#define DR_STE_SET_TAG(lookup_type, tag, t_fname, spec, s_fname) \
-	DR_STE_SET_VAL(lookup_type, tag, t_fname, spec, s_fname, spec->s_fname)
-
-/* Set to STE -1 to bit_mask->bm_fname and set spec->s_fname as used */
-#define DR_STE_SET_MASK(lookup_type, bit_mask, bm_fname, spec, s_fname) \
-	DR_STE_SET_VAL(lookup_type, bit_mask, bm_fname, spec, s_fname, -1)
-
-/* Set to STE spec->s_fname to bit_mask->bm_fname and set spec->s_fname as used */
-#define DR_STE_SET_MASK_V(lookup_type, bit_mask, bm_fname, spec, s_fname) \
-	DR_STE_SET_VAL(lookup_type, bit_mask, bm_fname, spec, s_fname, (spec)->s_fname)
-
-#define DR_STE_SET_TCP_FLAGS(lookup_type, tag, spec) do { \
-	MLX5_SET(ste_##lookup_type, tag, tcp_ns, !!((spec)->tcp_flags & (1 << 8))); \
-	MLX5_SET(ste_##lookup_type, tag, tcp_cwr, !!((spec)->tcp_flags & (1 << 7))); \
-	MLX5_SET(ste_##lookup_type, tag, tcp_ece, !!((spec)->tcp_flags & (1 << 6))); \
-	MLX5_SET(ste_##lookup_type, tag, tcp_urg, !!((spec)->tcp_flags & (1 << 5))); \
-	MLX5_SET(ste_##lookup_type, tag, tcp_ack, !!((spec)->tcp_flags & (1 << 4))); \
-	MLX5_SET(ste_##lookup_type, tag, tcp_psh, !!((spec)->tcp_flags & (1 << 3))); \
-	MLX5_SET(ste_##lookup_type, tag, tcp_rst, !!((spec)->tcp_flags & (1 << 2))); \
-	MLX5_SET(ste_##lookup_type, tag, tcp_syn, !!((spec)->tcp_flags & (1 << 1))); \
-	MLX5_SET(ste_##lookup_type, tag, tcp_fin, !!((spec)->tcp_flags & (1 << 0))); \
-} while (0)
-
-#define DR_STE_SET_MPLS_MASK(lookup_type, mask, in_out, bit_mask) do { \
-	DR_STE_SET_MASK_V(lookup_type, mask, mpls0_label, mask, \
-			  in_out##_first_mpls_label);\
-	DR_STE_SET_MASK_V(lookup_type, mask, mpls0_s_bos, mask, \
-			  in_out##_first_mpls_s_bos); \
-	DR_STE_SET_MASK_V(lookup_type, mask, mpls0_exp, mask, \
-			  in_out##_first_mpls_exp); \
-	DR_STE_SET_MASK_V(lookup_type, mask, mpls0_ttl, mask, \
-			  in_out##_first_mpls_ttl); \
-} while (0)
-
-#define DR_STE_SET_MPLS_TAG(lookup_type, mask, in_out, tag) do { \
-	DR_STE_SET_TAG(lookup_type, tag, mpls0_label, mask, \
-		       in_out##_first_mpls_label);\
-	DR_STE_SET_TAG(lookup_type, tag, mpls0_s_bos, mask, \
-		       in_out##_first_mpls_s_bos); \
-	DR_STE_SET_TAG(lookup_type, tag, mpls0_exp, mask, \
-		       in_out##_first_mpls_exp); \
-	DR_STE_SET_TAG(lookup_type, tag, mpls0_ttl, mask, \
-		       in_out##_first_mpls_ttl); \
-} while (0)
-
-#define DR_STE_IS_OUTER_MPLS_OVER_GRE_SET(_misc) (\
-	(_misc)->outer_first_mpls_over_gre_label || \
-	(_misc)->outer_first_mpls_over_gre_exp || \
-	(_misc)->outer_first_mpls_over_gre_s_bos || \
-	(_misc)->outer_first_mpls_over_gre_ttl)
-#define DR_STE_IS_OUTER_MPLS_OVER_UDP_SET(_misc) (\
-	(_misc)->outer_first_mpls_over_udp_label || \
-	(_misc)->outer_first_mpls_over_udp_exp || \
-	(_misc)->outer_first_mpls_over_udp_s_bos || \
-	(_misc)->outer_first_mpls_over_udp_ttl)
-
 #define DR_STE_CALC_LU_TYPE(lookup_type, rx, inner) \
 	((inner) ? MLX5DR_STE_LU_TYPE_##lookup_type##_I : \
 		   (rx) ? MLX5DR_STE_LU_TYPE_##lookup_type##_D : \
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ste.h b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ste.h
index 59850925ebd2..1bc8fa31c04e 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ste.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ste.h
@@ -6,6 +6,82 @@
 
 #include "dr_types.h"
 
+#define STE_IPV4 0x1
+#define STE_IPV6 0x2
+#define STE_TCP 0x1
+#define STE_UDP 0x2
+#define STE_SPI 0x3
+#define IP_VERSION_IPV4 0x4
+#define IP_VERSION_IPV6 0x6
+#define STE_SVLAN 0x1
+#define STE_CVLAN 0x2
+
+/* Set to STE a specific value using DR_STE_SET */
+#define DR_STE_SET_VAL(lookup_type, tag, t_fname, spec, s_fname, value) do { \
+	if ((spec)->s_fname) { \
+		MLX5_SET(ste_##lookup_type, tag, t_fname, value); \
+		(spec)->s_fname = 0; \
+	} \
+} while (0)
+
+/* Set to STE spec->s_fname to tag->t_fname */
+#define DR_STE_SET_TAG(lookup_type, tag, t_fname, spec, s_fname) \
+	DR_STE_SET_VAL(lookup_type, tag, t_fname, spec, s_fname, spec->s_fname)
+
+/* Set to STE -1 to bit_mask->bm_fname and set spec->s_fname as used */
+#define DR_STE_SET_MASK(lookup_type, bit_mask, bm_fname, spec, s_fname) \
+	DR_STE_SET_VAL(lookup_type, bit_mask, bm_fname, spec, s_fname, -1)
+
+/* Set to STE spec->s_fname to bit_mask->bm_fname and set spec->s_fname as used */
+#define DR_STE_SET_MASK_V(lookup_type, bit_mask, bm_fname, spec, s_fname) \
+	DR_STE_SET_VAL(lookup_type, bit_mask, bm_fname, spec, s_fname, (spec)->s_fname)
+
+#define DR_STE_SET_TCP_FLAGS(lookup_type, tag, spec) do { \
+	MLX5_SET(ste_##lookup_type, tag, tcp_ns, !!((spec)->tcp_flags & (1 << 8))); \
+	MLX5_SET(ste_##lookup_type, tag, tcp_cwr, !!((spec)->tcp_flags & (1 << 7))); \
+	MLX5_SET(ste_##lookup_type, tag, tcp_ece, !!((spec)->tcp_flags & (1 << 6))); \
+	MLX5_SET(ste_##lookup_type, tag, tcp_urg, !!((spec)->tcp_flags & (1 << 5))); \
+	MLX5_SET(ste_##lookup_type, tag, tcp_ack, !!((spec)->tcp_flags & (1 << 4))); \
+	MLX5_SET(ste_##lookup_type, tag, tcp_psh, !!((spec)->tcp_flags & (1 << 3))); \
+	MLX5_SET(ste_##lookup_type, tag, tcp_rst, !!((spec)->tcp_flags & (1 << 2))); \
+	MLX5_SET(ste_##lookup_type, tag, tcp_syn, !!((spec)->tcp_flags & (1 << 1))); \
+	MLX5_SET(ste_##lookup_type, tag, tcp_fin, !!((spec)->tcp_flags & (1 << 0))); \
+} while (0)
+
+#define DR_STE_SET_MPLS_MASK(lookup_type, mask, in_out, bit_mask) do { \
+	DR_STE_SET_MASK_V(lookup_type, bit_mask, mpls0_label, mask, \
+			  in_out##_first_mpls_label);\
+	DR_STE_SET_MASK_V(lookup_type, bit_mask, mpls0_s_bos, mask, \
+			  in_out##_first_mpls_s_bos); \
+	DR_STE_SET_MASK_V(lookup_type, bit_mask, mpls0_exp, mask, \
+			  in_out##_first_mpls_exp); \
+	DR_STE_SET_MASK_V(lookup_type, bit_mask, mpls0_ttl, mask, \
+			  in_out##_first_mpls_ttl); \
+} while (0)
+
+#define DR_STE_SET_MPLS_TAG(lookup_type, mask, in_out, tag) do { \
+	DR_STE_SET_TAG(lookup_type, tag, mpls0_label, mask, \
+		       in_out##_first_mpls_label);\
+	DR_STE_SET_TAG(lookup_type, tag, mpls0_s_bos, mask, \
+		       in_out##_first_mpls_s_bos); \
+	DR_STE_SET_TAG(lookup_type, tag, mpls0_exp, mask, \
+		       in_out##_first_mpls_exp); \
+	DR_STE_SET_TAG(lookup_type, tag, mpls0_ttl, mask, \
+		       in_out##_first_mpls_ttl); \
+} while (0)
+
+#define DR_STE_IS_OUTER_MPLS_OVER_GRE_SET(_misc) (\
+	(_misc)->outer_first_mpls_over_gre_label || \
+	(_misc)->outer_first_mpls_over_gre_exp || \
+	(_misc)->outer_first_mpls_over_gre_s_bos || \
+	(_misc)->outer_first_mpls_over_gre_ttl)
+
+#define DR_STE_IS_OUTER_MPLS_OVER_UDP_SET(_misc) (\
+	(_misc)->outer_first_mpls_over_udp_label || \
+	(_misc)->outer_first_mpls_over_udp_exp || \
+	(_misc)->outer_first_mpls_over_udp_s_bos || \
+	(_misc)->outer_first_mpls_over_udp_ttl)
+
 #define DR_STE_CTX_BUILDER(fname) \
 	((*build_##fname##_init)(struct mlx5dr_ste_build *sb, \
 				 struct mlx5dr_match_param *mask))
-- 
2.26.2

