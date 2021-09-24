Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B2C87417B4C
	for <lists+netdev@lfdr.de>; Fri, 24 Sep 2021 20:48:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347279AbhIXSuI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Sep 2021 14:50:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:46502 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1346770AbhIXSt6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 24 Sep 2021 14:49:58 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6B52061263;
        Fri, 24 Sep 2021 18:48:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1632509302;
        bh=kiLLjaAa1ott31TALhBEKcdy23pT2EGC4cH8S5g911Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Qu0f8ObICoXWT95gIIXo9i4D9o6Y7Fw5/dAPSR0VAzhOQjOTVwVIe4Fj4ak/mK9G8
         SCAv4VvsZO08ZZHTQnkkospYE+0pm4nNpIGKSm7QyFKOw8wnNm9VE48upEA+8QfZnd
         3KiwBr2ctEvDkQcQ+PoMFQzqWGzj/jSGAaTQdUFpQY44o2dGIEKa+emqAIYoNms12+
         CFnawrDzlrSSmFRjhWSMqNHSI+11d3DKI1eACPtWBPMIyF2AeDsJLkAsLJW5DBXR1h
         j/6KLMXv6UUQbNCxi2Pq7dV7FsHTr4DK7sV0fA2IuxWDsFLexHBZPADUwtHN4hHRvM
         1r13w9ut8KiwA==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Dima Chumak <dchumak@nvidia.com>,
        Vlad Buslov <vladbu@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next 12/12] net/mlx5e: Enable TC offload for ingress MACVLAN
Date:   Fri, 24 Sep 2021 11:48:08 -0700
Message-Id: <20210924184808.796968-13-saeed@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210924184808.796968-1-saeed@kernel.org>
References: <20210924184808.796968-1-saeed@kernel.org>
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
index 8451940c16ab..398c6761eeb3 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/rep/tc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/rep/tc.c
@@ -3,6 +3,7 @@
 
 #include <net/dst_metadata.h>
 #include <linux/netdevice.h>
+#include <linux/if_macvlan.h>
 #include <linux/list.h>
 #include <linux/rculist.h>
 #include <linux/rtnetlink.h>
@@ -409,6 +410,13 @@ static void mlx5e_rep_indr_block_unbind(void *cb_priv)
 
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
@@ -422,8 +430,14 @@ mlx5e_rep_indr_setup_block(struct net_device *netdev, struct Qdisc *sch,
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

