Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 03D703935AE
	for <lists+netdev@lfdr.de>; Thu, 27 May 2021 20:56:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236220AbhE0S6R (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 May 2021 14:58:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:59980 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236038AbhE0S6K (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 27 May 2021 14:58:10 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 651B3610C7;
        Thu, 27 May 2021 18:56:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1622141796;
        bh=prmKBcqe1I8xbX8RHXCkZwLSWtFeXvvyAArBwg9Z96I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YhZ6DVv1XJhPw31jcIg3TJbrcxgmy9hjWU7Vp0ILWpAmae88LCZwQExKxcj88An3I
         iqfFJ827tichT+4vte3J30Muw1byq5y0nHCbZRFTD239BENRyHcB3MC18cZb78n3Nf
         hsatr+dVvXjH428+IrApldFODZi6KKs/y8abBol2mufTERKCOLPmm6UOfPQQ5nJqlb
         gyaroE87TnTENkKMN4zdTuLQINdT9W1QNaACviXgqIPXWG+2wtaoBoaZ3k0wwncqtX
         h9RFTEEAqKsJbEpyfLyKiPD6c+U+ctD3Z/wgKjCgQtpfTSr8MQLqI/PPqp9+Z4SWEQ
         LUOCH4vA6ZcXQ==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Tariq Toukan <tariqt@nvidia.com>,
        Huy Nguyen <huyn@nvidia.com>, Raed Salem <raeds@nvidia.com>,
        Paul Blakey <paulb@nvidia.com>, Roi Dayan <roid@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next V2 04/15] net/mlx5e: TC: Reserved bit 31 of REG_C1 for IPsec offload
Date:   Thu, 27 May 2021 11:56:13 -0700
Message-Id: <20210527185624.694304-5-saeed@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210527185624.694304-1-saeed@kernel.org>
References: <20210527185624.694304-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Huy Nguyen <huyn@nvidia.com>

Currently ASAP features fully utilize all the bits of the CQE's flow tag
and ft_metadata field. The flow tag field cannot be used because the
flow table tagging in FTE does not allow partial write.

We agree to reserve bit 31 of CQE's ft_metadata for IPsec to avoid
ASAP CT from dropping IPsec offloaded packet

Here is the new bit layout of REG_C1. Tunnel option id is reduced to
11 bits:
< IPSEC MARKER (1) | ESW_TUN_ID(12) | ESW_TUN_OPTS(11) | ESW_ZONE_ID(8) >

Signed-off-by: Huy Nguyen <huyn@nvidia.com>
Signed-off-by: Raed Salem <raeds@nvidia.com>
Reviewed-by: Paul Blakey <paulb@nvidia.com>
Reviewed-by: Roi Dayan <roid@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
Signed-off-by: Paul Blakey <paulb@nvidia.com>
---
 .../net/ethernet/mellanox/mlx5/core/en/rep/tc.c |  2 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.h |  2 +-
 include/linux/mlx5/eswitch.h                    | 17 ++++++++++-------
 3 files changed, 12 insertions(+), 9 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/rep/tc.c b/drivers/net/ethernet/mellanox/mlx5/core/en/rep/tc.c
index 6cdc52d50a48..8cef4e7cfa4b 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/rep/tc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/rep/tc.c
@@ -617,7 +617,7 @@ static bool mlx5e_restore_skb(struct sk_buff *skb, u32 chain, u32 reg_c1,
 			      struct mlx5e_tc_update_priv *tc_priv)
 {
 	struct mlx5e_priv *priv = netdev_priv(skb->dev);
-	u32 tunnel_id = reg_c1 >> ESW_TUN_OFFSET;
+	u32 tunnel_id = (reg_c1 >> ESW_TUN_OFFSET) & TUNNEL_ID_MASK;
 
 	if (chain) {
 		struct mlx5_rep_uplink_priv *uplink_priv;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.h b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.h
index 3534d14d7d5c..721093b55acc 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.h
@@ -129,7 +129,7 @@ struct tunnel_match_enc_opts {
  */
 #define TUNNEL_INFO_BITS 12
 #define TUNNEL_INFO_BITS_MASK GENMASK(TUNNEL_INFO_BITS - 1, 0)
-#define ENC_OPTS_BITS 12
+#define ENC_OPTS_BITS 11
 #define ENC_OPTS_BITS_MASK GENMASK(ENC_OPTS_BITS - 1, 0)
 #define TUNNEL_ID_BITS (TUNNEL_INFO_BITS + ENC_OPTS_BITS)
 #define TUNNEL_ID_MASK GENMASK(TUNNEL_ID_BITS - 1, 0)
diff --git a/include/linux/mlx5/eswitch.h b/include/linux/mlx5/eswitch.h
index 17109b65c1ac..bc7db2e059eb 100644
--- a/include/linux/mlx5/eswitch.h
+++ b/include/linux/mlx5/eswitch.h
@@ -98,10 +98,11 @@ u32 mlx5_eswitch_get_vport_metadata_for_set(struct mlx5_eswitch *esw,
 					    u16 vport_num);
 
 /* Reg C1 usage:
- * Reg C1 = < ESW_TUN_ID(12) | ESW_TUN_OPTS(12) | ESW_ZONE_ID(8) >
+ * Reg C1 = < Reserved(1) | ESW_TUN_ID(12) | ESW_TUN_OPTS(11) | ESW_ZONE_ID(8) >
  *
- * Highest 12 bits of reg c1 is the encapsulation tunnel id, next 12 bits is
- * encapsulation tunnel options, and the lowest 8 bits are used for zone id.
+ * Highest bit is reserved for other offloads as marker bit, next 12 bits of reg c1
+ * is the encapsulation tunnel id, next 11 bits is encapsulation tunnel options,
+ * and the lowest 8 bits are used for zone id.
  *
  * Zone id is used to restore CT flow when packet misses on chain.
  *
@@ -109,16 +110,18 @@ u32 mlx5_eswitch_get_vport_metadata_for_set(struct mlx5_eswitch *esw,
  * on miss and to support inner header rewrite by means of implicit chain 0
  * flows.
  */
+#define ESW_RESERVED_BITS 1
 #define ESW_ZONE_ID_BITS 8
-#define ESW_TUN_OPTS_BITS 12
+#define ESW_TUN_OPTS_BITS 11
 #define ESW_TUN_ID_BITS 12
 #define ESW_TUN_OPTS_OFFSET ESW_ZONE_ID_BITS
 #define ESW_TUN_OFFSET ESW_TUN_OPTS_OFFSET
 #define ESW_ZONE_ID_MASK GENMASK(ESW_ZONE_ID_BITS - 1, 0)
-#define ESW_TUN_OPTS_MASK GENMASK(32 - ESW_TUN_ID_BITS - 1, ESW_TUN_OPTS_OFFSET)
-#define ESW_TUN_MASK GENMASK(31, ESW_TUN_OFFSET)
+#define ESW_TUN_OPTS_MASK GENMASK(31 - ESW_TUN_ID_BITS - ESW_RESERVED_BITS, ESW_TUN_OPTS_OFFSET)
+#define ESW_TUN_MASK GENMASK(31 - ESW_RESERVED_BITS, ESW_TUN_OFFSET)
 #define ESW_TUN_ID_SLOW_TABLE_GOTO_VPORT 0 /* 0 is not a valid tunnel id */
-#define ESW_TUN_OPTS_SLOW_TABLE_GOTO_VPORT 0xFFF /* 0xFFF is a reserved mapping */
+/* 0x7FF is a reserved mapping */
+#define ESW_TUN_OPTS_SLOW_TABLE_GOTO_VPORT GENMASK(ESW_TUN_OPTS_BITS - 1, 0)
 #define ESW_TUN_SLOW_TABLE_GOTO_VPORT ((ESW_TUN_ID_SLOW_TABLE_GOTO_VPORT << ESW_TUN_OPTS_BITS) | \
 				       ESW_TUN_OPTS_SLOW_TABLE_GOTO_VPORT)
 #define ESW_TUN_SLOW_TABLE_GOTO_VPORT_MARK ESW_TUN_OPTS_MASK
-- 
2.31.1

