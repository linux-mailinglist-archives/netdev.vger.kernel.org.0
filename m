Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 468BA617B5E
	for <lists+netdev@lfdr.de>; Thu,  3 Nov 2022 12:09:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230502AbiKCLJC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Nov 2022 07:09:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39452 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230396AbiKCLJB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Nov 2022 07:09:01 -0400
Received: from mailgw01.mediatek.com (unknown [60.244.123.138])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1278811832;
        Thu,  3 Nov 2022 04:08:58 -0700 (PDT)
X-UUID: 2a56852038c248fca6a79efe1aacfcac-20221103
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=Content-Type:MIME-Version:Message-ID:Date:Subject:CC:To:From; bh=xb3BFa3zX2eptx7zzYygsloKR3H20FuSbwEuVyz13eI=;
        b=GcA8G8l1NAAiD07stMszIw8DTv0H7QWfgZXosJhkoD7m2Jz3I61JeugNIwpVhO7SYW7Cr+TLM6k1QeOS6n3ID1YNHtrVpfFBnVuQHSTU5/yRd5EwW37jYG5uvOz3vjJ0rb76OSGvbN8RVs0OP8FtCfl56VECMthsXE8Ix+Isv90=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.1.12,REQID:649264ba-6866-447f-8ec9-8e6dd454b0ff,IP:0,U
        RL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
        release,TS:0
X-CID-META: VersionHash:62cd327,CLOUDID:387b55eb-84ac-4628-a416-bc50d5503da6,B
        ulkID:nil,BulkQuantity:0,Recheck:0,SF:102,TC:nil,Content:0,EDM:-3,IP:nil,U
        RL:0,File:nil,Bulk:nil,QS:nil,BEC:nil,COL:0
X-UUID: 2a56852038c248fca6a79efe1aacfcac-20221103
Received: from mtkexhb02.mediatek.inc [(172.21.101.103)] by mailgw01.mediatek.com
        (envelope-from <zhaoping.shu@mediatek.com>)
        (Generic MTA with TLSv1.2 ECDHE-RSA-AES256-SHA384 256/256)
        with ESMTP id 1464031517; Thu, 03 Nov 2022 19:08:53 +0800
Received: from mtkmbs11n2.mediatek.inc (172.21.101.187) by
 mtkmbs10n1.mediatek.inc (172.21.101.34) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.792.15; Thu, 3 Nov 2022 19:08:52 +0800
Received: from mcddlt001.gcn.mediatek.inc (10.19.240.15) by
 mtkmbs11n2.mediatek.inc (172.21.101.73) with Microsoft SMTP Server id
 15.2.792.15 via Frontend Transport; Thu, 3 Nov 2022 19:08:51 +0800
From:   <zhaoping.shu@mediatek.com>
To:     <m.chetan.kumar@intel.com>, <linuxwwan@intel.com>,
        <loic.poulain@linaro.org>, <ryazanov.s.a@gmail.com>,
        <johannes@sipsolutions.net>, <davem@davemloft.net>,
        <edumazet@google.com>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC:     <srv_heupstream@mediatek.com>, <haijun.liu@mediatek.com>,
        <xiayu.zhang@mediatek.com>, <lambert.wang@mediatek.com>,
        Zhaoping Shu <zhaoping.shu@mediatek.com>
Subject: [PATCH RESEND] net: wwan: iosm: Remove unnecessary if_mutex lock
Date:   Thu, 3 Nov 2022 19:08:49 +0800
Message-ID: <20221103110849.195886-1-zhaoping.shu@mediatek.com>
X-Mailer: git-send-email 2.17.0
MIME-Version: 1.0
Content-Type: text/plain
X-MTK:  N
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_PASS,UNPARSEABLE_RELAY autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Zhaoping Shu <zhaoping.shu@mediatek.com>

These WWAN network interface operations (create/delete/open/close)
are already protected by RTNL lock, i.e., wwan_ops.newlink(),
wwan_ops.dellink(), net_device_ops.ndo_open() and
net_device.ndo_stop() are called with RTNL lock held.
Therefore, this patch removes the unnecessary if_mutex.

Signed-off-by: Zhaoping Shu <zhaoping.shu@mediatek.com>
---
 drivers/net/wwan/iosm/iosm_ipc_wwan.c | 42 ++++-----------------------
 1 file changed, 6 insertions(+), 36 deletions(-)

diff --git a/drivers/net/wwan/iosm/iosm_ipc_wwan.c b/drivers/net/wwan/iosm/iosm_ipc_wwan.c
index 2f1f8b5d5b59..fa2261697d53 100644
--- a/drivers/net/wwan/iosm/iosm_ipc_wwan.c
+++ b/drivers/net/wwan/iosm/iosm_ipc_wwan.c
@@ -40,13 +40,11 @@ struct iosm_netdev_priv {
  * @ipc_imem:		Pointer to imem data-struct
  * @sub_netlist:	List of active netdevs
  * @dev:		Pointer device structure
- * @if_mutex:		Mutex used for add and remove interface id
  */
 struct iosm_wwan {
 	struct iosm_imem *ipc_imem;
 	struct iosm_netdev_priv __rcu *sub_netlist[IP_MUX_SESSION_END + 1];
 	struct device *dev;
-	struct mutex if_mutex; /* Mutex used for add and remove interface id */
 };
 
 /* Bring-up the wwan net link */
@@ -55,14 +53,11 @@ static int ipc_wwan_link_open(struct net_device *netdev)
 	struct iosm_netdev_priv *priv = wwan_netdev_drvpriv(netdev);
 	struct iosm_wwan *ipc_wwan = priv->ipc_wwan;
 	int if_id = priv->if_id;
-	int ret;
 
 	if (if_id < IP_MUX_SESSION_START ||
 	    if_id >= ARRAY_SIZE(ipc_wwan->sub_netlist))
 		return -EINVAL;
 
-	mutex_lock(&ipc_wwan->if_mutex);
-
 	/* get channel id */
 	priv->ch_id = ipc_imem_sys_wwan_open(ipc_wwan->ipc_imem, if_id);
 
@@ -70,8 +65,7 @@ static int ipc_wwan_link_open(struct net_device *netdev)
 		dev_err(ipc_wwan->dev,
 			"cannot connect wwan0 & id %d to the IPC mem layer",
 			if_id);
-		ret = -ENODEV;
-		goto out;
+		return -ENODEV;
 	}
 
 	/* enable tx path, DL data may follow */
@@ -80,10 +74,7 @@ static int ipc_wwan_link_open(struct net_device *netdev)
 	dev_dbg(ipc_wwan->dev, "Channel id %d allocated to if_id %d",
 		priv->ch_id, priv->if_id);
 
-	ret = 0;
-out:
-	mutex_unlock(&ipc_wwan->if_mutex);
-	return ret;
+	return 0;
 }
 
 /* Bring-down the wwan net link */
@@ -93,11 +84,9 @@ static int ipc_wwan_link_stop(struct net_device *netdev)
 
 	netif_stop_queue(netdev);
 
-	mutex_lock(&priv->ipc_wwan->if_mutex);
 	ipc_imem_sys_wwan_close(priv->ipc_wwan->ipc_imem, priv->if_id,
 				priv->ch_id);
 	priv->ch_id = -1;
-	mutex_unlock(&priv->ipc_wwan->if_mutex);
 
 	return 0;
 }
@@ -189,26 +178,17 @@ static int ipc_wwan_newlink(void *ctxt, struct net_device *dev,
 	priv->netdev = dev;
 	priv->ipc_wwan = ipc_wwan;
 
-	mutex_lock(&ipc_wwan->if_mutex);
-	if (rcu_access_pointer(ipc_wwan->sub_netlist[if_id])) {
-		err = -EBUSY;
-		goto out_unlock;
-	}
+	if (rcu_access_pointer(ipc_wwan->sub_netlist[if_id]))
+		return -EBUSY;
 
 	err = register_netdevice(dev);
 	if (err)
-		goto out_unlock;
+		return err;
 
 	rcu_assign_pointer(ipc_wwan->sub_netlist[if_id], priv);
-	mutex_unlock(&ipc_wwan->if_mutex);
-
 	netif_device_attach(dev);
 
 	return 0;
-
-out_unlock:
-	mutex_unlock(&ipc_wwan->if_mutex);
-	return err;
 }
 
 static void ipc_wwan_dellink(void *ctxt, struct net_device *dev,
@@ -222,17 +202,12 @@ static void ipc_wwan_dellink(void *ctxt, struct net_device *dev,
 		    if_id >= ARRAY_SIZE(ipc_wwan->sub_netlist)))
 		return;
 
-	mutex_lock(&ipc_wwan->if_mutex);
-
 	if (WARN_ON(rcu_access_pointer(ipc_wwan->sub_netlist[if_id]) != priv))
-		goto unlock;
+		return;
 
 	RCU_INIT_POINTER(ipc_wwan->sub_netlist[if_id], NULL);
 	/* unregistering includes synchronize_net() */
 	unregister_netdevice_queue(dev, head);
-
-unlock:
-	mutex_unlock(&ipc_wwan->if_mutex);
 }
 
 static const struct wwan_ops iosm_wwan_ops = {
@@ -323,12 +298,9 @@ struct iosm_wwan *ipc_wwan_init(struct iosm_imem *ipc_imem, struct device *dev)
 	ipc_wwan->dev = dev;
 	ipc_wwan->ipc_imem = ipc_imem;
 
-	mutex_init(&ipc_wwan->if_mutex);
-
 	/* WWAN core will create a netdev for the default IP MUX channel */
 	if (wwan_register_ops(ipc_wwan->dev, &iosm_wwan_ops, ipc_wwan,
 			      IP_MUX_SESSION_DEFAULT)) {
-		mutex_destroy(&ipc_wwan->if_mutex);
 		kfree(ipc_wwan);
 		return NULL;
 	}
@@ -341,7 +313,5 @@ void ipc_wwan_deinit(struct iosm_wwan *ipc_wwan)
 	/* This call will remove all child netdev(s) */
 	wwan_unregister_ops(ipc_wwan->dev);
 
-	mutex_destroy(&ipc_wwan->if_mutex);
-
 	kfree(ipc_wwan);
 }
-- 
2.17.0

