Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8C789637B19
	for <lists+netdev@lfdr.de>; Thu, 24 Nov 2022 15:09:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229912AbiKXOJY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Nov 2022 09:09:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39052 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229630AbiKXOJX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Nov 2022 09:09:23 -0500
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B68149099;
        Thu, 24 Nov 2022 06:09:21 -0800 (PST)
Received: from dggpeml500023.china.huawei.com (unknown [172.30.72.53])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4NJ0GP4HGtzmVJ8;
        Thu, 24 Nov 2022 22:08:45 +0800 (CST)
Received: from localhost.localdomain (10.175.101.6) by
 dggpeml500023.china.huawei.com (7.185.36.114) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Thu, 24 Nov 2022 22:09:18 +0800
From:   Zhang Xiaoxu <zhangxiaoxu5@huawei.com>
To:     <linux-wireless@vger.kernel.org>, <netdev@vger.kernel.org>,
        <kvalo@kernel.org>, <davem@davemloft.net>, <edumazet@google.com>,
        <kuba@kernel.org>, <pabeni@redhat.com>,
        <ajay.kathat@microchip.com>, <claudiu.beznea@microchip.com>,
        <zhangxiaoxu5@huawei.com>
Subject: [PATCH wireless] wifi: wilc1000: Fix UAF in wilc_netdev_cleanup() when iterator the RCU list
Date:   Thu, 24 Nov 2022 23:13:49 +0800
Message-ID: <20221124151349.2386077-1-zhangxiaoxu5@huawei.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.101.6]
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
 dggpeml500023.china.huawei.com (7.185.36.114)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There is a UAF read when remove the wilc1000_spi module:

 BUG: KASAN: use-after-free in wilc_netdev_cleanup.cold+0xc4/0xe0 [wilc1000]
 Read of size 8 at addr ffff888116846900 by task rmmod/386

 CPU: 2 PID: 386 Comm: rmmod Tainted: G                 N 6.1.0-rc6+ #8
 Call Trace:
  dump_stack_lvl+0x68/0x85
  print_report+0x16c/0x4a3
  kasan_report+0x95/0x190
  wilc_netdev_cleanup.cold+0xc4/0xe0
  wilc_bus_remove+0x52/0x60
  spi_remove+0x46/0x60
  device_remove+0x73/0xc0
  device_release_driver_internal+0x12d/0x210
  driver_detach+0x84/0x100
  bus_remove_driver+0x90/0x120
  driver_unregister+0x4f/0x80
  __x64_sys_delete_module+0x2fc/0x440
  do_syscall_64+0x38/0x90
  entry_SYSCALL_64_after_hwframe+0x63/0xcd

Since set 'needs_free_netdev=true' when initialize the net device, the
net device will be freed when unregister, then use the freed 'vif' to
find the next will UAF read.

Let's unregister the net device after removed from wilc list to avoid
the UAF.

Fixes: 8399918f3056 ("staging: wilc1000: use RCU list to maintain vif interfaces list")
Signed-off-by: Zhang Xiaoxu <zhangxiaoxu5@huawei.com>
---
 drivers/net/wireless/microchip/wilc1000/netdev.c | 13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/microchip/wilc1000/netdev.c b/drivers/net/wireless/microchip/wilc1000/netdev.c
index 9b319a455b96..d6374bfd7650 100644
--- a/drivers/net/wireless/microchip/wilc1000/netdev.c
+++ b/drivers/net/wireless/microchip/wilc1000/netdev.c
@@ -879,6 +879,7 @@ void wilc_netdev_cleanup(struct wilc *wilc)
 {
 	struct wilc_vif *vif;
 	int srcu_idx, ifc_cnt = 0;
+	LIST_HEAD(list_kill);
 
 	if (!wilc)
 		return;
@@ -888,16 +889,14 @@ void wilc_netdev_cleanup(struct wilc *wilc)
 		wilc->firmware = NULL;
 	}
 
+	rtnl_lock();
 	srcu_idx = srcu_read_lock(&wilc->srcu);
 	list_for_each_entry_rcu(vif, &wilc->vif_list, list) {
 		if (vif->ndev)
-			unregister_netdev(vif->ndev);
+			unregister_netdevice_queue(vif->ndev, &list_kill);
 	}
 	srcu_read_unlock(&wilc->srcu, srcu_idx);
 
-	wilc_wfi_deinit_mon_interface(wilc, false);
-	destroy_workqueue(wilc->hif_workqueue);
-
 	while (ifc_cnt < WILC_NUM_CONCURRENT_IFC) {
 		mutex_lock(&wilc->vif_mutex);
 		if (wilc->vif_num <= 0) {
@@ -914,6 +913,12 @@ void wilc_netdev_cleanup(struct wilc *wilc)
 		ifc_cnt++;
 	}
 
+	unregister_netdevice_many(&list_kill);
+	rtnl_unlock();
+
+	wilc_wfi_deinit_mon_interface(wilc, false);
+	destroy_workqueue(wilc->hif_workqueue);
+
 	wilc_wlan_cfg_deinit(wilc);
 	wlan_deinit_locks(wilc);
 	wiphy_unregister(wilc->wiphy);
-- 
2.31.1

