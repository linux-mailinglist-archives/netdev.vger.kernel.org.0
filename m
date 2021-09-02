Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 32E583FF3D3
	for <lists+netdev@lfdr.de>; Thu,  2 Sep 2021 21:06:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347356AbhIBTHd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Sep 2021 15:07:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:55084 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1347338AbhIBTHI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 2 Sep 2021 15:07:08 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C607C60F11;
        Thu,  2 Sep 2021 19:06:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1630609570;
        bh=nJ7vKu686Ge3w0w+LqR5ksFpU8EP6duJ8QC3lwhrT28=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QUXSwI0W9XctRMAVU+z9HuC0pAEJm2GyDH3I8GXinxtLjMGsKRE/B7FtOfZD0AKVS
         VUKhyDlKgUwTgvTjaZw4dFT56sPjJFeun1SI3HWiEafcxf7YKc2Opes9Qzg7UJfBZY
         p2p1Ad2isfENMKoyjQEa51JnbMXX7SCH5vs4qSL43sZVFdYBtyvct/5wJB9Ox57/Bu
         /XC4yruTpHl+ZlVwCR+8Nuu5rfmyHUSY52Ig1X3K8MwzT2KGR5nhQtm94J4N9JX/dP
         /SCI/witswlZOu0yIR5mp/y7+qd/cN0xfB3Vvaeds3sT56wFqCb6JnWki1x48Jh2jH
         6PhRKJMMaBwRQ==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Dima Chumak <dchumak@nvidia.com>,
        Vlad Buslov <vladbu@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next 12/15] net/mlx5e: Enable TC offload for ingress MACVLAN
Date:   Thu,  2 Sep 2021 12:05:51 -0700
Message-Id: <20210902190554.211497-13-saeed@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210902190554.211497-1-saeed@kernel.org>
References: <20210902190554.211497-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Dima Chumak <dchumak@nvidia.com>

Support offloading of TC rules that filter ingress traffic from a MACVLAN
device, which is attached to uplink representor.

Signed-off-by: Dima Chumak <dchumak@nvidia.com>
Reviewed-by: Vlad Buslov <vladbu@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../ethernet/mellanox/mlx5/core/en/rep/tc.c    | 18 ++++++++++++++++--
 1 file changed, 16 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/rep/tc.c b/drivers/net/ethernet/mellanox/mlx5/core/en/rep/tc.c
index 405e9da5c7e9..d46cba30683c 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/rep/tc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/rep/tc.c
@@ -3,6 +3,7 @@
 
 #include <net/dst_metadata.h>
 #include <linux/netdevice.h>
+#include <linux/if_macvlan.h>
 #include <linux/list.h>
 #include <linux/rculist.h>
 #include <linux/rtnetlink.h>
@@ -412,6 +413,13 @@ static void mlx5e_rep_indr_block_unbind(void *cb_priv)
 
 static LIST_HEAD(mlx5e_block_cb_list);
 
+static bool mlx5e_rep_macvlan_mode_supported(const struct net_device *dev)
+{
+	struct macvlan_dev *macvlan = netdev_priv(dev);
+
+	return macvlan->mode == MACVLAN_MODE_PASSTHRU;
+}
+
 static int
 mlx5e_rep_indr_setup_block(struct net_device *netdev, struct Qdisc *sch,
 			   struct mlx5e_rep_priv *rpriv,
@@ -425,8 +433,14 @@ mlx5e_rep_indr_setup_block(struct net_device *netdev, struct Qdisc *sch,
 	struct flow_block_cb *block_cb;
 
 	if (!mlx5e_tc_tun_device_to_offload(priv, netdev) &&
-	    !(is_vlan_dev(netdev) && vlan_dev_real_dev(netdev) == rpriv->netdev))
-		return -EOPNOTSUPP;
+	    !(is_vlan_dev(netdev) && vlan_dev_real_dev(netdev) == rpriv->netdev)) {
+		if (!(netif_is_macvlan(netdev) && macvlan_dev_real_dev(netdev) == rpriv->netdev))
+			return -EOPNOTSUPP;
+		if (!mlx5e_rep_macvlan_mode_supported(netdev)) {
+			netdev_warn(netdev, "Offloading ingress filter is supported only with macvlan passthru mode");
+			return -EOPNOTSUPP;
+		}
+	}
 
 	if (f->binder_type != FLOW_BLOCK_BINDER_TYPE_CLSACT_INGRESS)
 		return -EOPNOTSUPP;
-- 
2.31.1

