Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2B70C1EB1E
	for <lists+netdev@lfdr.de>; Wed, 15 May 2019 11:38:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726122AbfEOJim (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 May 2019 05:38:42 -0400
Received: from m9783.mail.qiye.163.com ([220.181.97.83]:23033 "EHLO
        m9783.mail.qiye.163.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725871AbfEOJil (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 May 2019 05:38:41 -0400
X-Greylist: delayed 759 seconds by postgrey-1.27 at vger.kernel.org; Wed, 15 May 2019 05:38:40 EDT
Received: from 10.19.61.167master (unknown [123.59.132.129])
        by m9783.mail.qiye.163.com (Hmail) with ESMTPA id 0DD0BC1B38;
        Wed, 15 May 2019 17:25:50 +0800 (CST)
From:   wenxu@ucloud.cn
To:     saeedm@mellanox.com
Cc:     netdev@vger.kernel.org
Subject: [PATCH] net/mlx5e: restrict the real_dev of vlan device is the same as uplink device
Date:   Wed, 15 May 2019 17:25:45 +0800
Message-Id: <1557912345-14649-1-git-send-email-wenxu@ucloud.cn>
X-Mailer: git-send-email 1.8.3.1
X-HM-Spam-Status: e1kIGBQJHllBWUtVS1lXWShZQUlCN1dZLVlBSVdZCQ4XHghZQVkyNS06Nz
        I*QUtVS1kG
X-HM-Sender-Digest: e1kMHhlZQR0aFwgeV1kSHx4VD1lBWUc6MAw6HCo5TjgyTS84FxgxKjBW
        ARwaChVVSlVKTk5MQkpJSE5MQklPVTMWGhIXVQweFQMOOw4YFxQOH1UYFUVZV1kSC1lBWUpJSFVO
        QlVKSElVSklCWVdZCAFZQUpOTk83Bg++
X-HM-Tid: 0a6abacfed782085kuqy0dd0bc1b38
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: wenxu <wenxu@ucloud.cn>

When register indr block for vlan device, it should check the real_dev
of vlan device is same as uplink device. Or it will set offload rule
to mlx5e which will never hit.

Signed-off-by: wenxu <wenxu@ucloud.cn>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_rep.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
index 91e24f1..a39fdac 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
@@ -796,7 +796,7 @@ static int mlx5e_nic_rep_netdevice_event(struct notifier_block *nb,
 	struct net_device *netdev = netdev_notifier_info_to_dev(ptr);
 
 	if (!mlx5e_tc_tun_device_to_offload(priv, netdev) &&
-	    !is_vlan_dev(netdev))
+	    !(is_vlan_dev(netdev) && vlan_dev_real_dev(netdev) == rpriv->netdev))
 		return NOTIFY_OK;
 
 	switch (event) {
-- 
1.8.3.1

