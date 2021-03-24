Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 53485347070
	for <lists+netdev@lfdr.de>; Wed, 24 Mar 2021 05:16:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230382AbhCXEQO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Mar 2021 00:16:14 -0400
Received: from m97179.mail.qiye.163.com ([220.181.97.179]:35210 "EHLO
        m97179.mail.qiye.163.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229788AbhCXEPp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Mar 2021 00:15:45 -0400
Received: from localhost.localdomain (unknown [123.59.132.129])
        by m97179.mail.qiye.163.com (Hmail) with ESMTPA id 15757E01827;
        Wed, 24 Mar 2021 12:15:41 +0800 (CST)
From:   wenxu@ucloud.cn
To:     saeedm@nvidia.com, kuba@kernel.org, davem@davemloft.net
Cc:     netdev@vger.kernel.org
Subject: [PATCH net] net/mlx5e: Fix ipsec/tls netdev features build
Date:   Wed, 24 Mar 2021 12:15:39 +0800
Message-Id: <1616559339-1853-1-git-send-email-wenxu@ucloud.cn>
X-Mailer: git-send-email 1.8.3.1
X-HM-Spam-Status: e1kfGhgUHx5ZQUtXWQgYFAkeWUFZS1VLWVdZKFlBSUI3V1ktWUFJV1kPCR
        oVCBIfWUFZTE0fGRlIS0wZSklLVkpNSk1OTkJIT0pKSU5VGRETFhoSFyQUDg9ZV1kWGg8SFR0UWU
        FZT0tIVUpKS0hKTFVLWQY+
X-HM-Sender-Digest: e1kMHhlZQR0aFwgeV1kSHx4VD1lBWUc6Ok06Sxw6Tj09KR0sIk45MTpW
        MktPCxBVSlVKTUpNTk5CSE9KSU5CVTMWGhIXVQweFQMOOw4YFxQOH1UYFUVZV1kSC1lBWUpJSFVO
        QlVKSElVSklCWVdZCAFZQUlLT0M3Bg++
X-HM-Tid: 0a786271fe3720bdkuqy15757e01827
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: wenxu <wenxu@ucloud.cn>

Ipsec and tls netdev features build should be done after the
mlx5e_init_ipesc/tls which finishs the init for the ipsec/tls
in the driver.

Fixes: 3ef14e463f6e ("net/mlx5e: Separate between netdev objects and mlx5e profiles initialization")
Signed-off-by: wenxu <wenxu@ucloud.cn>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
index 158f947..14c3f1f 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -5218,8 +5218,6 @@ static void mlx5e_build_nic_netdev(struct net_device *netdev)
 	netdev->priv_flags       |= IFF_UNICAST_FLT;
 
 	mlx5e_set_netdev_dev_addr(netdev);
-	mlx5e_ipsec_build_netdev(priv);
-	mlx5e_tls_build_netdev(priv);
 }
 
 void mlx5e_create_q_counters(struct mlx5e_priv *priv)
@@ -5274,10 +5272,15 @@ static int mlx5e_nic_init(struct mlx5_core_dev *mdev,
 	err = mlx5e_ipsec_init(priv);
 	if (err)
 		mlx5_core_err(mdev, "IPSec initialization failed, %d\n", err);
+	else
+		mlx5e_ipsec_build_netdev(priv);
+
 
 	err = mlx5e_tls_init(priv);
 	if (err)
 		mlx5_core_err(mdev, "TLS initialization failed, %d\n", err);
+	else
+		mlx5e_tls_build_netdev(priv);
 
 	err = mlx5e_devlink_port_register(priv);
 	if (err)
-- 
1.8.3.1

