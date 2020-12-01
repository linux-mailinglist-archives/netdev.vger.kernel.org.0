Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C020F2C9E18
	for <lists+netdev@lfdr.de>; Tue,  1 Dec 2020 10:41:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726614AbgLAJcN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Dec 2020 04:32:13 -0500
Received: from szxga04-in.huawei.com ([45.249.212.190]:8226 "EHLO
        szxga04-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727744AbgLAJcM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Dec 2020 04:32:12 -0500
Received: from DGGEMS408-HUB.china.huawei.com (unknown [172.30.72.58])
        by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4ClcKK1VJczkjNd;
        Tue,  1 Dec 2020 17:30:45 +0800 (CST)
Received: from huawei.com (10.175.103.91) by DGGEMS408-HUB.china.huawei.com
 (10.3.19.208) with Microsoft SMTP Server id 14.3.487.0; Tue, 1 Dec 2020
 17:31:10 +0800
From:   Yang Yingliang <yangyingliang@huawei.com>
To:     <netdev@vger.kernel.org>
CC:     <davem@davemloft.net>, <kuba@kernel.org>,
        <toshiaki.makita1@gmail.com>, <rkovhaev@gmail.com>,
        <Jason@zx2c4.com>, <yangyingliang@huawei.com>
Subject: [PATCH net v2 1/2] wireguard: device: don't call free_netdev() in priv_destructor()
Date:   Tue, 1 Dec 2020 17:29:02 +0800
Message-ID: <20201201092903.3269202-1-yangyingliang@huawei.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.103.91]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

After commit cf124db566e6 ("net: Fix inconsistent teardown and..."),
priv_destruct() doesn't call free_netdev() in driver, we use
dev->needs_free_netdev to indicate whether free_netdev() should be
called on release path.
This patch remove free_netdev() from priv_destructor() and set
dev->needs_free_netdev to true.

Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
---
 drivers/net/wireguard/device.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireguard/device.c b/drivers/net/wireguard/device.c
index c9f65e96ccb0..578ac6097d7e 100644
--- a/drivers/net/wireguard/device.c
+++ b/drivers/net/wireguard/device.c
@@ -247,7 +247,6 @@ static void wg_destruct(struct net_device *dev)
 	mutex_unlock(&wg->device_update_lock);
 
 	pr_debug("%s: Interface destroyed\n", dev->name);
-	free_netdev(dev);
 }
 
 static const struct device_type device_type = { .name = KBUILD_MODNAME };
@@ -360,6 +359,7 @@ static int wg_newlink(struct net *src_net, struct net_device *dev,
 	 * register_netdevice doesn't call it for us if it fails.
 	 */
 	dev->priv_destructor = wg_destruct;
+	dev->needs_free_netdev = true;
 
 	pr_debug("%s: Interface created\n", dev->name);
 	return ret;
-- 
2.25.1

