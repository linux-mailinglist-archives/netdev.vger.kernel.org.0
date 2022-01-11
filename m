Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D7A3748A538
	for <lists+netdev@lfdr.de>; Tue, 11 Jan 2022 02:43:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346226AbiAKBnx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Jan 2022 20:43:53 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:39898 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344470AbiAKBnu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Jan 2022 20:43:50 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 99FE2B8182F
        for <netdev@vger.kernel.org>; Tue, 11 Jan 2022 01:43:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0ABE6C36AED;
        Tue, 11 Jan 2022 01:43:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1641865428;
        bh=22QCVNaMPeeE/Ut7goYl44UaHTrYnP0Lpr2ll5FByxE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=E/aqikJ4TgcAHyqqmpGR2nNztrHR1UDCm4q88/AXgbljnIGlBXJmxff+DWVdS3hKQ
         tEJ5fGEbC0AnwTFOUy0itgc+fEQmBmYxRf41W5Zreqi3bu6kjXLo3P2gwUmpUrEoax
         xnGgqaJ3WUIpifouShjhs8ZbhPD/aMdoHjo5aIcUkuml+M494vSOrLzzl1PnukPA50
         4SmpJEumCtEFgLixM6+DDU1uCDZqdcPx7V7vgR4RuAnthFOH8+u3nUKWGQLxAG5g9Y
         ZZJ2VGt3t+cMgMEvodXSXkOKd3jw4T68xOlURnD03XEKPdwYCqSWS+50Y4vl+f3Db+
         AgvK62Rw9lGvg==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Roi Dayan <roid@nvidia.com>,
        Oz Shlomo <ozsh@nvidia.com>, Maor Dickman <maord@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next 06/17] net/mlx5e: TC, Split pedit offloads verify from alloc_tc_pedit_action()
Date:   Mon, 10 Jan 2022 17:43:24 -0800
Message-Id: <20220111014335.178121-7-saeed@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220111014335.178121-1-saeed@kernel.org>
References: <20220111014335.178121-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Roi Dayan <roid@nvidia.com>

Split pedit verify part into a new subfunction for better
maintainability.

Signed-off-by: Roi Dayan <roid@nvidia.com>
Reviewed-by: Oz Shlomo <ozsh@nvidia.com>
Reviewed-by: Maor Dickman <maord@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../net/ethernet/mellanox/mlx5/core/en_tc.c   | 33 ++++++++++++-------
 1 file changed, 22 insertions(+), 11 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
index e4677f1a8341..5eb5f6ec2f0d 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
@@ -2993,19 +2993,13 @@ static int offload_pedit_fields(struct mlx5e_priv *priv,
 
 static const struct pedit_headers zero_masks = {};
 
-static int alloc_tc_pedit_action(struct mlx5e_priv *priv, int namespace,
-				 struct mlx5e_tc_flow_parse_attr *parse_attr,
-				 u32 *action_flags,
-				 struct netlink_ext_ack *extack)
+static int verify_offload_pedit_fields(struct mlx5e_priv *priv,
+				       struct mlx5e_tc_flow_parse_attr *parse_attr,
+				       struct netlink_ext_ack *extack)
 {
 	struct pedit_headers *cmd_masks;
-	int err;
 	u8 cmd;
 
-	err = offload_pedit_fields(priv, namespace, parse_attr, action_flags, extack);
-	if (err < 0)
-		goto out_dealloc_parsed_actions;
-
 	for (cmd = 0; cmd < __PEDIT_CMD_MAX; cmd++) {
 		cmd_masks = &parse_attr->hdrs[cmd].masks;
 		if (memcmp(cmd_masks, &zero_masks, sizeof(zero_masks))) {
@@ -3013,12 +3007,29 @@ static int alloc_tc_pedit_action(struct mlx5e_priv *priv, int namespace,
 			netdev_warn(priv->netdev, "attempt to offload an unsupported field (cmd %d)\n", cmd);
 			print_hex_dump(KERN_WARNING, "mask: ", DUMP_PREFIX_ADDRESS,
 				       16, 1, cmd_masks, sizeof(zero_masks), true);
-			err = -EOPNOTSUPP;
-			goto out_dealloc_parsed_actions;
+			return -EOPNOTSUPP;
 		}
 	}
 
 	return 0;
+}
+
+static int alloc_tc_pedit_action(struct mlx5e_priv *priv, int namespace,
+				 struct mlx5e_tc_flow_parse_attr *parse_attr,
+				 u32 *action_flags,
+				 struct netlink_ext_ack *extack)
+{
+	int err;
+
+	err = offload_pedit_fields(priv, namespace, parse_attr, action_flags, extack);
+	if (err)
+		goto out_dealloc_parsed_actions;
+
+	err = verify_offload_pedit_fields(priv, parse_attr, extack);
+	if (err)
+		goto out_dealloc_parsed_actions;
+
+	return 0;
 
 out_dealloc_parsed_actions:
 	mlx5e_mod_hdr_dealloc(&parse_attr->mod_hdr_acts);
-- 
2.34.1

