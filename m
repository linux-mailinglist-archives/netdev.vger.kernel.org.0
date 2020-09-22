Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5D98A27377A
	for <lists+netdev@lfdr.de>; Tue, 22 Sep 2020 02:31:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729165AbgIVAbT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Sep 2020 20:31:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:60454 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729126AbgIVAbP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 21 Sep 2020 20:31:15 -0400
Received: from sx1.lan (c-24-6-56-119.hsd1.ca.comcast.net [24.6.56.119])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8FE0423AAA;
        Tue, 22 Sep 2020 00:31:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600734674;
        bh=hzvoX9+gvPe5oT68Ks+WfxJxXsRQDHRIiy9J2+Rn6PU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=m2MjxvJ6I+Wd6QsxJQB/R9ZkS6m6mCV0luIRtUblLeg2tFwNp5jbg/UEO8qjCjKJN
         aewqaW93z89fTuwF3zciekSILY4EDVglQSpI1K/u/sQi7SBzWF6xkEAP5/A1+Vxejm
         HH+p416RNoKagwFz8sM/m2aqM5bqnMxckgXaE8ts=
From:   saeed@kernel.org
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Maor Dickman <maord@nvidia.com>,
        Roi Dayan <roid@nvidia.com>, Saeed Mahameed <saeedm@nvidia.com>
Subject: [net V2 07/15] net/mlx5e: Fix endianness when calculating pedit mask first bit
Date:   Mon, 21 Sep 2020 17:30:53 -0700
Message-Id: <20200922003101.529117-8-saeed@kernel.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200922003101.529117-1-saeed@kernel.org>
References: <20200922003101.529117-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Maor Dickman <maord@nvidia.com>

The field mask value is provided in network byte order and has to
be converted to host byte order before calculating pedit mask
first bit.

Fixes: 88f30bbcbaaa ("net/mlx5e: Bit sized fields rewrite support")
Signed-off-by: Maor Dickman <maord@nvidia.com>
Reviewed-by: Roi Dayan <roid@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../net/ethernet/mellanox/mlx5/core/en_tc.c   | 34 ++++++++++++-------
 1 file changed, 21 insertions(+), 13 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
index bf0c6f063941..1c93f92d9210 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
@@ -2624,6 +2624,22 @@ static struct mlx5_fields fields[] = {
 	OFFLOAD(UDP_DPORT, 16, U16_MAX, udp.dest,   0, udp_dport),
 };
 
+static unsigned long mask_to_le(unsigned long mask, int size)
+{
+	__be32 mask_be32;
+	__be16 mask_be16;
+
+	if (size == 32) {
+		mask_be32 = (__force __be32)(mask);
+		mask = (__force unsigned long)cpu_to_le32(be32_to_cpu(mask_be32));
+	} else if (size == 16) {
+		mask_be32 = (__force __be32)(mask);
+		mask_be16 = *(__be16 *)&mask_be32;
+		mask = (__force unsigned long)cpu_to_le16(be16_to_cpu(mask_be16));
+	}
+
+	return mask;
+}
 static int offload_pedit_fields(struct mlx5e_priv *priv,
 				int namespace,
 				struct pedit_headers_action *hdrs,
@@ -2637,9 +2653,7 @@ static int offload_pedit_fields(struct mlx5e_priv *priv,
 	u32 *s_masks_p, *a_masks_p, s_mask, a_mask;
 	struct mlx5e_tc_mod_hdr_acts *mod_acts;
 	struct mlx5_fields *f;
-	unsigned long mask;
-	__be32 mask_be32;
-	__be16 mask_be16;
+	unsigned long mask, field_mask;
 	int err;
 	u8 cmd;
 
@@ -2705,14 +2719,7 @@ static int offload_pedit_fields(struct mlx5e_priv *priv,
 		if (skip)
 			continue;
 
-		if (f->field_bsize == 32) {
-			mask_be32 = (__force __be32)(mask);
-			mask = (__force unsigned long)cpu_to_le32(be32_to_cpu(mask_be32));
-		} else if (f->field_bsize == 16) {
-			mask_be32 = (__force __be32)(mask);
-			mask_be16 = *(__be16 *)&mask_be32;
-			mask = (__force unsigned long)cpu_to_le16(be16_to_cpu(mask_be16));
-		}
+		mask = mask_to_le(mask, f->field_bsize);
 
 		first = find_first_bit(&mask, f->field_bsize);
 		next_z = find_next_zero_bit(&mask, f->field_bsize, first);
@@ -2743,9 +2750,10 @@ static int offload_pedit_fields(struct mlx5e_priv *priv,
 		if (cmd == MLX5_ACTION_TYPE_SET) {
 			int start;
 
+			field_mask = mask_to_le(f->field_mask, f->field_bsize);
+
 			/* if field is bit sized it can start not from first bit */
-			start = find_first_bit((unsigned long *)&f->field_mask,
-					       f->field_bsize);
+			start = find_first_bit(&field_mask, f->field_bsize);
 
 			MLX5_SET(set_action_in, action, offset, first - start);
 			/* length is num of bits to be written, zero means length of 32 */
-- 
2.26.2

