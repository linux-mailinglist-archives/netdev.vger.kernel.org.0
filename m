Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5E98649EC89
	for <lists+netdev@lfdr.de>; Thu, 27 Jan 2022 21:40:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344051AbiA0UkO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Jan 2022 15:40:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52204 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240140AbiA0UkN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Jan 2022 15:40:13 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C51D1C061714
        for <netdev@vger.kernel.org>; Thu, 27 Jan 2022 12:40:13 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6479661889
        for <netdev@vger.kernel.org>; Thu, 27 Jan 2022 20:40:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D3E2DC340E6;
        Thu, 27 Jan 2022 20:40:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643316013;
        bh=22QCVNaMPeeE/Ut7goYl44UaHTrYnP0Lpr2ll5FByxE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TyTJaF6nsVrdQQsgGmXQyONU3WAf7jS8Qnq2fjzVQtaRaqFNMg/tKmmK9P3hrFGpz
         1AEMJUXuVoiQR4zQPJyzjA/vM3JCVhwD3LaXdwxdZCTqLEUvU+g0ly215Ky9Dw1fmi
         g59pah5o8yfkdEnqaDM40jnVCvI/tALVSACw/Bv7Q1tJL7GeCdJ/sriTdwyqHu3/Fk
         fL6fKqMbAXJ4mh2b+WOFiJoVdd5Eya4CBh9hZJTATZ4lgo8MocuD2GUiQYg8uBIUgH
         jPX0gHKmSgBVe7gjRKzXnMqMpU6YefTwc67tKIKyQOCeo8hlFGL/UU6lwSnhsEduuz
         ZuDKjnxIh1kfQ==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Roi Dayan <roid@nvidia.com>,
        Oz Shlomo <ozsh@nvidia.com>, Maor Dickman <maord@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next RESEND 05/17] net/mlx5e: TC, Split pedit offloads verify from alloc_tc_pedit_action()
Date:   Thu, 27 Jan 2022 12:39:55 -0800
Message-Id: <20220127204007.146300-6-saeed@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220127204007.146300-1-saeed@kernel.org>
References: <20220127204007.146300-1-saeed@kernel.org>
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

