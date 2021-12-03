Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A0C4F466ED9
	for <lists+netdev@lfdr.de>; Fri,  3 Dec 2021 01:56:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343626AbhLCA74 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Dec 2021 19:59:56 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:60698 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245297AbhLCA7y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Dec 2021 19:59:54 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 150436291D
        for <netdev@vger.kernel.org>; Fri,  3 Dec 2021 00:56:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 83D3CC56747;
        Fri,  3 Dec 2021 00:56:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1638492990;
        bh=pqb4XF7KYhI8aMTdW8nPJNcVsIutSo0c0atOU/CDoPs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CFXo98od7Q8Zcj3sCZGNb9tBvsPpiqd34tcUtyCtlZYqayfBZ7xW704AizTtz8+gc
         jebZkWu9LzIkp57XCG1nw1M1P2ht9Mm+5Z8/fHBGt44mgr+qKXFYrcSRZ/lW1QQ1ll
         /psugylmga+MBX5qvLvIjQfk8yBjcRGB5Cz8q8gAHaGVzbaf1Dx7JRKnrWMwDz4y+m
         n98Rs9Ow+lK1lklG8DVmvAPgKPqhkFNiSOV/rFb4ynUpYyYMQKYCpAhfTl2FZkkgzM
         xQRGHCcX2fYX9EGXF5BTN+SrPSuUYd2dfE78ihf1zULVg3dYy5Cz9Ls55x1FufOPEh
         ho1y+y7Kehrug==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Roi Dayan <roid@nvidia.com>,
        Oz Shlomo <ozsh@nvidia.com>, Maor Dickman <maord@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next v0 11/14] net/mlx5e: Remove redundant actions arg from vlan push/pop funcs
Date:   Thu,  2 Dec 2021 16:56:19 -0800
Message-Id: <20211203005622.183325-12-saeed@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211203005622.183325-1-saeed@kernel.org>
References: <20211203005622.183325-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Roi Dayan <roid@nvidia.com>

Passing actions is redundant and can be retrieved from flow attr.

Signed-off-by: Roi Dayan <roid@nvidia.com>
Reviewed-by: Oz Shlomo <ozsh@nvidia.com>
Reviewed-by: Maor Dickman <maord@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.c | 16 ++++++----------
 1 file changed, 6 insertions(+), 10 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
index 90fca3555563..3c5e9efb9873 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
@@ -3682,7 +3682,6 @@ static struct net_device *get_fdb_out_dev(struct net_device *uplink_dev,
 static int add_vlan_push_action(struct mlx5e_priv *priv,
 				struct mlx5_flow_attr *attr,
 				struct net_device **out_dev,
-				u32 *action,
 				struct netlink_ext_ack *extack)
 {
 	struct net_device *vlan_dev = *out_dev;
@@ -3694,7 +3693,7 @@ static int add_vlan_push_action(struct mlx5e_priv *priv,
 	};
 	int err;
 
-	err = parse_tc_vlan_action(priv, &vlan_act, attr->esw_attr, action, extack);
+	err = parse_tc_vlan_action(priv, &vlan_act, attr->esw_attr, &attr->action, extack);
 	if (err)
 		return err;
 
@@ -3705,14 +3704,13 @@ static int add_vlan_push_action(struct mlx5e_priv *priv,
 		return -ENODEV;
 
 	if (is_vlan_dev(*out_dev))
-		err = add_vlan_push_action(priv, attr, out_dev, action, extack);
+		err = add_vlan_push_action(priv, attr, out_dev, extack);
 
 	return err;
 }
 
 static int add_vlan_pop_action(struct mlx5e_priv *priv,
 			       struct mlx5_flow_attr *attr,
-			       u32 *action,
 			       struct netlink_ext_ack *extack)
 {
 	struct flow_action_entry vlan_act = {
@@ -3723,7 +3721,8 @@ static int add_vlan_pop_action(struct mlx5e_priv *priv,
 	nest_level = attr->parse_attr->filter_dev->lower_level -
 						priv->netdev->lower_level;
 	while (nest_level--) {
-		err = parse_tc_vlan_action(priv, &vlan_act, attr->esw_attr, action, extack);
+		err = parse_tc_vlan_action(priv, &vlan_act, attr->esw_attr,
+					   &attr->action, extack);
 		if (err)
 			return err;
 	}
@@ -4093,16 +4092,13 @@ static int parse_tc_fdb_actions(struct mlx5e_priv *priv,
 					return -ENODEV;
 
 				if (is_vlan_dev(out_dev)) {
-					err = add_vlan_push_action(priv, attr,
-								   &out_dev,
-								   &attr->action, extack);
+					err = add_vlan_push_action(priv, attr, &out_dev, extack);
 					if (err)
 						return err;
 				}
 
 				if (is_vlan_dev(parse_attr->filter_dev)) {
-					err = add_vlan_pop_action(priv, attr,
-								  &attr->action, extack);
+					err = add_vlan_pop_action(priv, attr, extack);
 					if (err)
 						return err;
 				}
-- 
2.31.1

