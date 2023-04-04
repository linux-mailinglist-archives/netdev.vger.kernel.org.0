Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 791256D59A0
	for <lists+netdev@lfdr.de>; Tue,  4 Apr 2023 09:30:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234055AbjDDHaQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Apr 2023 03:30:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57162 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233899AbjDDH36 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Apr 2023 03:29:58 -0400
Received: from out30-99.freemail.mail.aliyun.com (out30-99.freemail.mail.aliyun.com [115.124.30.99])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 61A27B7;
        Tue,  4 Apr 2023 00:29:38 -0700 (PDT)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R531e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018045192;MF=yang.lee@linux.alibaba.com;NM=1;PH=DS;RN=12;SR=0;TI=SMTPD_---0VfKsUhm_1680593374;
Received: from localhost(mailfrom:yang.lee@linux.alibaba.com fp:SMTPD_---0VfKsUhm_1680593374)
          by smtp.aliyun-inc.com;
          Tue, 04 Apr 2023 15:29:34 +0800
From:   Yang Li <yang.lee@linux.alibaba.com>
To:     davem@davemloft.net
Cc:     edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        saeedm@nvidia.com, leon@kernel.org, netdev@vger.kernel.org,
        simon.horman@corigine.com, linux-rdma@vger.kernel.org,
        linux-kernel@vger.kernel.org, Yang Li <yang.lee@linux.alibaba.com>,
        Abaci Robot <abaci@linux.alibaba.com>
Subject: [PATCH net-next v3] net/mlx5e: Remove NULL check before dev_{put, hold}
Date:   Tue,  4 Apr 2023 15:29:32 +0800
Message-Id: <20230404072932.88383-1-yang.lee@linux.alibaba.com>
X-Mailer: git-send-email 2.20.1.7.g153144c
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.0 required=5.0 tests=ENV_AND_HDR_SPF_MATCH,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
        USER_IN_DEF_SPF_WL autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

./drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun.c:35:2-9: WARNING: NULL check before dev_{put, hold} functions is not needed.
./drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun.c:72:2-10: WARNING: NULL check before dev_{put, hold} functions is not needed.
./drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun.c:80:2-9: WARNING: NULL check before dev_{put, hold} functions is not needed.
./drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun_encap.c:35:2-9: WARNING: NULL check before dev_{put, hold} functions is not needed.
./drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun_encap.c:734:2-9: WARNING: NULL check before dev_{put, hold} functions is not needed.
./drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun_encap.c:769:2-9: WARNING: NULL check before dev_{put, hold} functions is not needed.
./drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c:1450:2-10: WARNING: NULL check before dev_{put, hold} functions is not needed.

Reported-by: Abaci Robot <abaci@linux.alibaba.com>
Link: https://bugzilla.openanolis.cn/show_bug.cgi?id=4667
Signed-off-by: Yang Li <yang.lee@linux.alibaba.com>
---

change in v3:
--According to Leon's suggestion, do this cleanup for whole driver.

 drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun.c    |  9 +++------
 .../net/ethernet/mellanox/mlx5/core/en/tc_tun_encap.c  | 10 +++-------
 drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c      |  3 +--
 3 files changed, 7 insertions(+), 15 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun.c b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun.c
index 00a04fdd756f..20f6e7ed7475 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun.c
@@ -31,8 +31,7 @@ static void mlx5e_tc_tun_route_attr_cleanup(struct mlx5e_tc_tun_route_attr *attr
 {
 	if (attr->n)
 		neigh_release(attr->n);
-	if (attr->route_dev)
-		dev_put(attr->route_dev);
+	dev_put(attr->route_dev);
 }
 
 struct mlx5e_tc_tunnel *mlx5e_get_tc_tun(struct net_device *tunnel_dev)
@@ -68,16 +67,14 @@ static int get_route_and_out_devs(struct mlx5e_priv *priv,
 	 * while holding rcu read lock. Take the net_device for correctness
 	 * sake.
 	 */
-	if (uplink_upper)
-		dev_hold(uplink_upper);
+	dev_hold(uplink_upper);
 	rcu_read_unlock();
 
 	dst_is_lag_dev = (uplink_upper &&
 			  netif_is_lag_master(uplink_upper) &&
 			  real_dev == uplink_upper &&
 			  mlx5_lag_is_sriov(priv->mdev));
-	if (uplink_upper)
-		dev_put(uplink_upper);
+	dev_put(uplink_upper);
 
 	/* if the egress device isn't on the same HW e-switch or
 	 * it's a LAG device, use the uplink
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun_encap.c b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun_encap.c
index 20c2d2ecaf93..2cb2ba857155 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun_encap.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun_encap.c
@@ -32,9 +32,7 @@ static int mlx5e_set_int_port_tunnel(struct mlx5e_priv *priv,
 						&attr->action, out_index);
 
 out:
-	if (route_dev)
-		dev_put(route_dev);
-
+	dev_put(route_dev);
 	return err;
 }
 
@@ -730,8 +728,7 @@ static int mlx5e_set_vf_tunnel(struct mlx5_eswitch *esw,
 	}
 
 out:
-	if (route_dev)
-		dev_put(route_dev);
+	dev_put(route_dev);
 	return err;
 }
 
@@ -765,8 +762,7 @@ static int mlx5e_update_vf_tunnel(struct mlx5_eswitch *esw,
 	mlx5e_tc_match_to_reg_mod_hdr_change(esw->dev, mod_hdr_acts, VPORT_TO_REG, act_id, data);
 
 out:
-	if (route_dev)
-		dev_put(route_dev);
+	dev_put(route_dev);
 	return err;
 }
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c b/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c
index 5d331b940f4d..f0216bf6e215 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c
@@ -1446,8 +1446,7 @@ struct net_device *mlx5_lag_get_roce_netdev(struct mlx5_core_dev *dev)
 	} else {
 		ndev = ldev->pf[MLX5_LAG_P1].netdev;
 	}
-	if (ndev)
-		dev_hold(ndev);
+	dev_hold(ndev);
 
 unlock:
 	spin_unlock_irqrestore(&lag_lock, flags);
-- 
2.20.1.7.g153144c

