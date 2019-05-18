Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 976412236A
	for <lists+netdev@lfdr.de>; Sat, 18 May 2019 13:46:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729803AbfERLqM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 18 May 2019 07:46:12 -0400
Received: from m9783.mail.qiye.163.com ([220.181.97.83]:38349 "EHLO
        m9783.mail.qiye.163.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729792AbfERLqL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 18 May 2019 07:46:11 -0400
Received: from 10.19.61.167master (unknown [123.59.132.129])
        by m9783.mail.qiye.163.com (Hmail) with ESMTPA id 95180C1694;
        Sat, 18 May 2019 19:46:08 +0800 (CST)
From:   wenxu@ucloud.cn
To:     saeedm@mellanox.com, roid@mellanox.com, markb@mellanox.com
Cc:     netdev@vger.kernel.org
Subject: [PATCH v3] net/mlx5e: Add bonding device for indr block to offload the packet received from bonding device
Date:   Sat, 18 May 2019 19:45:58 +0800
Message-Id: <1558179958-6268-1-git-send-email-wenxu@ucloud.cn>
X-Mailer: git-send-email 1.8.3.1
X-HM-Spam-Status: e1kIGBQJHllBWUlVTUpPQkJCTExKSkpDSk1ZV1koWUFJQjdXWS1ZQUlXWQ
        kOFx4IWUFZNTQpNjo3JCkuNz5ZBg++
X-HM-Sender-Digest: e1kMHhlZQR0aFwgeV1kSHx4VD1lBWUc6PjY6Qww6Nzg#FC4wLDMpIwkt
        HDYaCwtVSlVKTk5DSkxCQk1DTUJLVTMWGhIXVQweFQMOOw4YFxQOH1UYFUVZV1kSC1lBWUpJSFVO
        QlVKSElVSklCWVdZCAFZQUlISUk3Bg++
X-HM-Tid: 0a6acac376722085kuqy95180c1694
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: wenxu <wenxu@ucloud.cn>

The mlx5e support the lag mode. When add mlx_p0 and mlx_p1 to bond0.
packet received from mlx_p0 or mlx_p1 and in the ingress tc flower
forward to vf0. The tc rule can't be offloaded because there is
no indr_register_block for the bonding device.

Signed-off-by: wenxu <wenxu@ucloud.cn>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_rep.c | 1 +
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.c  | 3 +++
 2 files changed, 4 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
index 5283e16..883ade4 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
@@ -813,6 +813,7 @@ static int mlx5e_nic_rep_netdevice_event(struct notifier_block *nb,
 	struct net_device *netdev = netdev_notifier_info_to_dev(ptr);
 
 	if (!mlx5e_tc_tun_device_to_offload(priv, netdev) &&
+	    !netif_is_lag_master(netdev) &&
 	    !is_vlan_dev(netdev))
 		return NOTIFY_OK;
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
index 31cd02f..7bf9b3d 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
@@ -2886,6 +2886,9 @@ static int parse_tc_fdb_actions(struct mlx5e_priv *priv,
 					if (err)
 						return err;
 				}
+				if (netif_is_lag_master(parse_attr->filter_dev) &&
+				    uplink_upper != parse_attr->filter_dev)
+					return -EOPNOTSUPP;
 
 				if (!mlx5e_eswitch_rep(out_dev))
 					return -EOPNOTSUPP;
-- 
1.8.3.1

