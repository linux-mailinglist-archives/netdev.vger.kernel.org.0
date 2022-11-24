Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E064B63776F
	for <lists+netdev@lfdr.de>; Thu, 24 Nov 2022 12:18:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229626AbiKXLSn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Nov 2022 06:18:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45380 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229601AbiKXLSc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Nov 2022 06:18:32 -0500
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 763BE827CD;
        Thu, 24 Nov 2022 03:18:14 -0800 (PST)
Received: from canpemm500010.china.huawei.com (unknown [172.30.72.57])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4NHwSz4SnmzmW8P;
        Thu, 24 Nov 2022 19:17:39 +0800 (CST)
Received: from localhost.localdomain (10.175.112.70) by
 canpemm500010.china.huawei.com (7.192.105.118) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Thu, 24 Nov 2022 19:18:11 +0800
From:   Wang Yufen <wangyufen@huawei.com>
To:     <ajay.kathat@microchip.com>, <claudiu.beznea@microchip.com>,
        <kvalo@kernel.org>, <davem@davemloft.net>, <edumazet@google.com>,
        <kuba@kernel.org>, <pabeni@redhat.com>
CC:     <davidm@egauge.net>, <wangyufen@huawei.com>,
        <linux-wireless@vger.kernel.org>, <netdev@vger.kernel.org>
Subject: [PATCH wireless] wilc1000: add missing unregister_netdev() in wilc_netdev_ifc_init()
Date:   Thu, 24 Nov 2022 19:38:22 +0800
Message-ID: <1669289902-23639-1-git-send-email-wangyufen@huawei.com>
X-Mailer: git-send-email 1.8.3.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.175.112.70]
X-ClientProxiedBy: dggems705-chm.china.huawei.com (10.3.19.182) To
 canpemm500010.china.huawei.com (7.192.105.118)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fault injection test reports this issue:

kernel BUG at net/core/dev.c:10731!
invalid opcode: 0000 [#1] PREEMPT SMP KASAN PTI
Call Trace:
  <TASK>
  wilc_netdev_ifc_init+0x19f/0x220 [wilc1000 884bf126e9e98af6a708f266a8dffd53f99e4bf5]
  wilc_cfg80211_init+0x30c/0x380 [wilc1000 884bf126e9e98af6a708f266a8dffd53f99e4bf5]
  wilc_bus_probe+0xad/0x2b0 [wilc1000_spi 1520a7539b6589cc6cde2ae826a523a33f8bacff]
  spi_probe+0xe4/0x140
  really_probe+0x17e/0x3f0
  __driver_probe_device+0xe3/0x170
  driver_probe_device+0x49/0x120

The root case here is alloc_ordered_workqueue() fails, but
cfg80211_unregister_netdevice() or unregister_netdev() not be called in
error handling path. To fix add unregister_netdev goto lable to add the
unregister operation in error handling path.

Fixes: 09ed8bfc5215 ("wilc1000: Rename workqueue from "WILC_wq" to "NETDEV-wq"")
Signed-off-by: Wang Yufen <wangyufen@huawei.com>
---
 drivers/net/wireless/microchip/wilc1000/netdev.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/microchip/wilc1000/netdev.c b/drivers/net/wireless/microchip/wilc1000/netdev.c
index 9b319a4..7b39701 100644
--- a/drivers/net/wireless/microchip/wilc1000/netdev.c
+++ b/drivers/net/wireless/microchip/wilc1000/netdev.c
@@ -980,7 +980,7 @@ struct wilc_vif *wilc_netdev_ifc_init(struct wilc *wl, const char *name,
 						    ndev->name);
 	if (!wl->hif_workqueue) {
 		ret = -ENOMEM;
-		goto error;
+		goto unregister_netdev;
 	}
 
 	ndev->needs_free_netdev = true;
@@ -995,6 +995,11 @@ struct wilc_vif *wilc_netdev_ifc_init(struct wilc *wl, const char *name,
 
 	return vif;
 
+unregister_netdev:
+	if (rtnl_locked)
+		cfg80211_unregister_netdevice(ndev);
+	else
+		unregister_netdev(ndev);
   error:
 	free_netdev(ndev);
 	return ERR_PTR(ret);
-- 
1.8.3.1

