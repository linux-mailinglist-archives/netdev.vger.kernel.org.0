Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 098A640AD39
	for <lists+netdev@lfdr.de>; Tue, 14 Sep 2021 14:13:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232781AbhINMOR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Sep 2021 08:14:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:46574 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232833AbhINMOK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 14 Sep 2021 08:14:10 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 222036112D;
        Tue, 14 Sep 2021 12:12:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631621572;
        bh=/guvqv519fLLLPCrNhLwtZ/c6qWEgPHi2aboPFDaiAo=;
        h=From:To:Cc:Subject:Date:From;
        b=YsAcbD59dUw9CAYmjsQ9XPgUveUh55lTIM54vqR6TWlLwRheYyeIzQ/PKOudm/bQJ
         IALFukrxc2jJSvR6fdUspz/fVfJD0B3Tckc6yzkafRKMbSk3mmzToOjWDK7ncgePA2
         pPSpADQ8jm9PxIravgVdWkL3Rk0V0HXKGDXBNQPLIgtuUmppDNZhMOsUuJT2g4dOpl
         DQ4BaAXku2VqkzCdUugX7arQM8yc4jymFFBXRtQ+dAPj3D1epyP0jWsQZ7rP+JYNHf
         ilHpGcDyaMfMmfzYSFTWpc/SYYwBQHbItCyXiRqbx9M/hSaO62DPZaZg1lNC6vDmzV
         pwEJsbxaz7Qjg==
From:   Leon Romanovsky <leon@kernel.org>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Saeed Mahameed <saeedm@nvidia.com>
Cc:     Leon Romanovsky <leonro@nvidia.com>, linux-kernel@vger.kernel.org,
        linux-rdma@vger.kernel.org, Mark Bloch <mbloch@nvidia.com>,
        Naresh Kamboju <naresh.kamboju@linaro.org>,
        netdev@vger.kernel.org, Roi Dayan <roid@nvidia.com>,
        Vlad Buslov <vladbu@nvidia.com>
Subject: [PATCH net-next] net/mlx5: Fix use of uninitialized variable in bridge.c
Date:   Tue, 14 Sep 2021 15:12:47 +0300
Message-Id: <9e9eb5df93dbcba6faff199d71222785c1f1faf7.1631621485.git.leonro@nvidia.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Leon Romanovsky <leonro@nvidia.com>

Rewrite the code to fix the following compilation warnings that were
discovered once Linus enabled -Werror flag.

drivers/net/ethernet/mellanox/mlx5/core/en/rep/bridge.c:157:11: error:
variable 'err' is used uninitialized whenever 'if' condition is false
[-Werror,-Wsometimes-uninitialized]
        else if (mlx5_esw_bridge_dev_same_hw(rep, esw))
                 ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
drivers/net/ethernet/mellanox/mlx5/core/en/rep/bridge.c:164:9: note:
uninitialized use occurs here
        return err;
               ^~~
drivers/net/ethernet/mellanox/mlx5/core/en/rep/bridge.c:157:7: note:
remove the 'if' if its condition is always true
        else if (mlx5_esw_bridge_dev_same_hw(rep, esw))
             ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
drivers/net/ethernet/mellanox/mlx5/core/en/rep/bridge.c:140:9: note:
initialize the variable 'err' to silence this warning
        int err;
               ^
                = 0
drivers/net/ethernet/mellanox/mlx5/core/en/rep/bridge.c:262:7: error:
variable 'err' is used uninitialized whenever switch case is taken
[-Werror,-Wsometimes-uninitialized]
        case SWITCHDEV_ATTR_ID_PORT_BRIDGE_FLAGS:
             ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
drivers/net/ethernet/mellanox/mlx5/core/en/rep/bridge.c:276:9: note:
uninitialized use occurs here
        return err;
               ^~~
drivers/net/ethernet/mellanox/mlx5/core/en/rep/bridge.c:257:7: error:
variable 'err' is used uninitialized whenever 'if' condition is false
[-Werror,-Wsometimes-uninitialized]
                if (attr->u.brport_flags.mask & ~(BR_LEARNING |
BR_FLOOD | BR_MCAST_FLOOD)) {

^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
drivers/net/ethernet/mellanox/mlx5/core/en/rep/bridge.c:276:9: note:
uninitialized use occurs here
        return err;
               ^~~
drivers/net/ethernet/mellanox/mlx5/core/en/rep/bridge.c:257:3: note:
remove the 'if' if its condition is always true
                if (attr->u.brport_flags.mask & ~(BR_LEARNING |
BR_FLOOD | BR_MCAST_FLOOD)) {

^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
drivers/net/ethernet/mellanox/mlx5/core/en/rep/bridge.c:247:9: note:
initialize the variable 'err' to silence this warning
        int err;
               ^
                = 0
3 errors generated.

Fixes: ff9b7521468b ("net/mlx5: Bridge, support LAG")
Reported-by: Naresh Kamboju <naresh.kamboju@linaro.org>
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 .../mellanox/mlx5/core/en/rep/bridge.c        | 36 +++++++++++--------
 1 file changed, 22 insertions(+), 14 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/rep/bridge.c b/drivers/net/ethernet/mellanox/mlx5/core/en/rep/bridge.c
index 0c38c2e319be..55b4ce37bcae 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/rep/bridge.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/rep/bridge.c
@@ -137,7 +137,6 @@ static int mlx5_esw_bridge_port_changeupper(struct notifier_block *nb, void *ptr
 	u16 vport_num, esw_owner_vhca_id;
 	struct netlink_ext_ack *extack;
 	int ifindex = upper->ifindex;
-	int err;
 
 	if (!netif_is_bridge_master(upper))
 		return 0;
@@ -148,20 +147,29 @@ static int mlx5_esw_bridge_port_changeupper(struct notifier_block *nb, void *ptr
 
 	extack = netdev_notifier_info_to_extack(&info->info);
 
-	if (mlx5_esw_bridge_is_local(dev, rep, esw))
-		err = info->linking ?
-			mlx5_esw_bridge_vport_link(ifindex, vport_num, esw_owner_vhca_id,
-						   br_offloads, extack) :
-			mlx5_esw_bridge_vport_unlink(ifindex, vport_num, esw_owner_vhca_id,
-						     br_offloads, extack);
-	else if (mlx5_esw_bridge_dev_same_hw(rep, esw))
-		err = info->linking ?
-			mlx5_esw_bridge_vport_peer_link(ifindex, vport_num, esw_owner_vhca_id,
-							br_offloads, extack) :
-			mlx5_esw_bridge_vport_peer_unlink(ifindex, vport_num, esw_owner_vhca_id,
+	if (mlx5_esw_bridge_is_local(dev, rep, esw)) {
+		if (info->linking)
+			return mlx5_esw_bridge_vport_link(ifindex, vport_num,
+							  esw_owner_vhca_id,
 							  br_offloads, extack);
 
-	return err;
+		return mlx5_esw_bridge_vport_unlink(ifindex, vport_num,
+						    esw_owner_vhca_id,
+						    br_offloads, extack);
+	}
+
+	if (mlx5_esw_bridge_dev_same_hw(rep, esw)) {
+		if (info->linking)
+			return mlx5_esw_bridge_vport_peer_link(
+				ifindex, vport_num, esw_owner_vhca_id,
+				br_offloads, extack);
+		return mlx5_esw_bridge_vport_peer_unlink(ifindex, vport_num,
+							 esw_owner_vhca_id,
+							 br_offloads, extack);
+	}
+
+	WARN_ON(true);
+	return -EINVAL;
 }
 
 static int mlx5_esw_bridge_switchdev_port_event(struct notifier_block *nb,
@@ -244,7 +252,7 @@ mlx5_esw_bridge_port_obj_attr_set(struct net_device *dev,
 	struct netlink_ext_ack *extack = switchdev_notifier_info_to_extack(&port_attr_info->info);
 	const struct switchdev_attr *attr = port_attr_info->attr;
 	u16 vport_num, esw_owner_vhca_id;
-	int err;
+	int err = 0;
 
 	if (!mlx5_esw_bridge_lower_rep_vport_num_vhca_id_get(dev, br_offloads->esw, &vport_num,
 							     &esw_owner_vhca_id))
-- 
2.31.1

