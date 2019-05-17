Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BE17721549
	for <lists+netdev@lfdr.de>; Fri, 17 May 2019 10:22:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727849AbfEQIWK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 May 2019 04:22:10 -0400
Received: from m97188.mail.qiye.163.com ([220.181.97.188]:2674 "EHLO
        smtp.qiye.163.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726893AbfEQIWK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 May 2019 04:22:10 -0400
Received: from 10.19.61.167master (unknown [123.59.132.129])
        by smtp.qiye.163.com (Hmail) with ESMTPA id 8B42C966B4C;
        Fri, 17 May 2019 16:22:06 +0800 (CST)
From:   wenxu@ucloud.cn
To:     saeedm@mellanox.com, roid@mellanox.com
Cc:     netdev@vger.kernel.org
Subject: [PATCH] net/mlx5e: Add bonding device for indr block to offload the packet received from bonding device
Date:   Fri, 17 May 2019 16:21:58 +0800
Message-Id: <1558081318-15810-1-git-send-email-wenxu@ucloud.cn>
X-Mailer: git-send-email 1.8.3.1
X-HM-Spam-Status: e1kIGBQJHllBWUtVS1lXWShZQUlCN1dZLVlBSVdZCQ4XHghZQVkyNS06Nz
        I*QUtVS1kG
X-HM-Sender-Digest: e1kMHhlZQR0aFwgeV1kSHx4VD1lBWUc6N0k6Ghw6Nzg8SS4LKRVREhdM
        DVZPCwJVSlVKTk5DS0NKSElNTE1NVTMWGhIXVQweFQMOOw4YFxQOH1UYFUVZV1kSC1lBWUpJSFVO
        QlVKSElVSklCWVdZCAFZQUpNSUM3Bg++
X-HM-Tid: 0a6ac4e24e3f20bckuqy8b42c966b4c
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: wenxu <wenxu@ucloud.cn>

The mlx5e support the lag mode. When add mlx_p0 and mlx_p1 to bond0.
packet received from mlx_p0 or mlx_p1 and in the ingress tc flower
forward to vf0. The tc rule can't be offloaded for the non indr
rejistor block for the bonding device.

Signed-off-by: wenxu <wenxu@ucloud.cn>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_rep.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
index 91e24f1..134fa0b 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
@@ -796,6 +796,7 @@ static int mlx5e_nic_rep_netdevice_event(struct notifier_block *nb,
 	struct net_device *netdev = netdev_notifier_info_to_dev(ptr);
 
 	if (!mlx5e_tc_tun_device_to_offload(priv, netdev) &&
+	    !netif_is_bond_master(netdev) &&
 	    !is_vlan_dev(netdev))
 		return NOTIFY_OK;
 
-- 
1.8.3.1

