Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C77B342171A
	for <lists+netdev@lfdr.de>; Mon,  4 Oct 2021 21:15:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238611AbhJDTRI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Oct 2021 15:17:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:36624 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238404AbhJDTQs (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 4 Oct 2021 15:16:48 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E363161501;
        Mon,  4 Oct 2021 19:14:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1633374899;
        bh=9/RHAQQZgC9fpMwaL8P+0DEnpCLpnJ3FeCVAPYsyM20=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gd9N3670GclAWCQ5ycpODo97gXEPli/wpivbjeFGS+zilW1XxU2DE4trW8D6XAHig
         IL5lwkWD64H7XGwch37f/Ne3aEWMVhtIl3CfM0lO4G9fkI5ORtvuzmoqFna6oB/ffu
         QPqfuSY2ZyzOB6BhjuzLpikI6rm1ZbgjJ7bDl2oUFFBmyIPMCkHBsRYGGgurRvvMiM
         ytGBI6iygPW1MYM0YkAKe9QF8icp/n+vB94LNja3f3F7a5apRmdUCevFT9M6p1EAZ1
         yim2pLnE2gNERsVzf6ZesB31dgabX8eLZGOyn0CCA+cK8XM1XE9uqO6BXr4rZ+YGVW
         p4NksC/AfINDA==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, tariqt@nvidia.com, yishaih@nvidia.com,
        linux-rdma@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next 4/4] mlx4: constify args for const dev_addr
Date:   Mon,  4 Oct 2021 12:14:46 -0700
Message-Id: <20211004191446.2127522-5-kuba@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211004191446.2127522-1-kuba@kernel.org>
References: <20211004191446.2127522-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

netdev->dev_addr will become const soon. Make sure all
functions which pass it around mark appropriate args
as const.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx4/en_netdev.c | 8 +++++---
 drivers/net/ethernet/mellanox/mlx4/mcg.c       | 2 +-
 include/linux/mlx4/device.h                    | 2 +-
 3 files changed, 7 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx4/en_netdev.c b/drivers/net/ethernet/mellanox/mlx4/en_netdev.c
index dce228170b14..3f6d5c384637 100644
--- a/drivers/net/ethernet/mellanox/mlx4/en_netdev.c
+++ b/drivers/net/ethernet/mellanox/mlx4/en_netdev.c
@@ -536,7 +536,8 @@ static void mlx4_en_u64_to_mac(struct net_device *dev, u64 src_mac)
 }
 
 
-static int mlx4_en_tunnel_steer_add(struct mlx4_en_priv *priv, unsigned char *addr,
+static int mlx4_en_tunnel_steer_add(struct mlx4_en_priv *priv,
+				    const unsigned char *addr,
 				    int qpn, u64 *reg_id)
 {
 	int err;
@@ -557,7 +558,7 @@ static int mlx4_en_tunnel_steer_add(struct mlx4_en_priv *priv, unsigned char *ad
 
 
 static int mlx4_en_uc_steer_add(struct mlx4_en_priv *priv,
-				unsigned char *mac, int *qpn, u64 *reg_id)
+				const unsigned char *mac, int *qpn, u64 *reg_id)
 {
 	struct mlx4_en_dev *mdev = priv->mdev;
 	struct mlx4_dev *dev = mdev->dev;
@@ -609,7 +610,8 @@ static int mlx4_en_uc_steer_add(struct mlx4_en_priv *priv,
 }
 
 static void mlx4_en_uc_steer_release(struct mlx4_en_priv *priv,
-				     unsigned char *mac, int qpn, u64 reg_id)
+				     const unsigned char *mac,
+				     int qpn, u64 reg_id)
 {
 	struct mlx4_en_dev *mdev = priv->mdev;
 	struct mlx4_dev *dev = mdev->dev;
diff --git a/drivers/net/ethernet/mellanox/mlx4/mcg.c b/drivers/net/ethernet/mellanox/mlx4/mcg.c
index f1b4ad9c66d2..f1716a83a4d3 100644
--- a/drivers/net/ethernet/mellanox/mlx4/mcg.c
+++ b/drivers/net/ethernet/mellanox/mlx4/mcg.c
@@ -1046,7 +1046,7 @@ int mlx4_flow_detach(struct mlx4_dev *dev, u64 reg_id)
 }
 EXPORT_SYMBOL_GPL(mlx4_flow_detach);
 
-int mlx4_tunnel_steer_add(struct mlx4_dev *dev, unsigned char *addr,
+int mlx4_tunnel_steer_add(struct mlx4_dev *dev, const unsigned char *addr,
 			  int port, int qpn, u16 prio, u64 *reg_id)
 {
 	int err;
diff --git a/include/linux/mlx4/device.h b/include/linux/mlx4/device.h
index 30bb59fe970c..6646634a0b9d 100644
--- a/include/linux/mlx4/device.h
+++ b/include/linux/mlx4/device.h
@@ -1436,7 +1436,7 @@ int mlx4_map_sw_to_hw_steering_id(struct mlx4_dev *dev,
 				  enum mlx4_net_trans_rule_id id);
 int mlx4_hw_rule_sz(struct mlx4_dev *dev, enum mlx4_net_trans_rule_id id);
 
-int mlx4_tunnel_steer_add(struct mlx4_dev *dev, unsigned char *addr,
+int mlx4_tunnel_steer_add(struct mlx4_dev *dev, const unsigned char *addr,
 			  int port, int qpn, u16 prio, u64 *reg_id);
 
 void mlx4_sync_pkey_table(struct mlx4_dev *dev, int slave, int port,
-- 
2.31.1

