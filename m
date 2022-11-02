Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 95C036166D8
	for <lists+netdev@lfdr.de>; Wed,  2 Nov 2022 17:02:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231179AbiKBQCd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Nov 2022 12:02:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41558 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230527AbiKBQCa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Nov 2022 12:02:30 -0400
Received: from mail-wm1-x32f.google.com (mail-wm1-x32f.google.com [IPv6:2a00:1450:4864:20::32f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DDB522C131
        for <netdev@vger.kernel.org>; Wed,  2 Nov 2022 09:02:21 -0700 (PDT)
Received: by mail-wm1-x32f.google.com with SMTP id o30so1271765wms.2
        for <netdev@vger.kernel.org>; Wed, 02 Nov 2022 09:02:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=4YcInQYj1ZdT5s/+ztHGDij8izUdzxlqFZLkv50wYZg=;
        b=z72usTUkxyh+1UzaffamJ3ccqnFqR6ULlrLvMd/crrRYBM2GrRwc1vyKoHRT1bHLKV
         Ciip5mF39FBtdo6DThMtdHCcfO7OjAKCgSFg8YnzF9tFZDCK2v8OlxwdqlIDDIYx88gK
         VEf+yOIhV70bFnlWe+ZXCKTcA1M0463zgMkFAJPx42g1+k8iH17OUbz0PwNYvgbsY0Hh
         x8VxoiLriEQfmfm2qnRFUTra7pXIIxQXO20GXdk+iCbP+ClvDj/mIEIE1rAI1Fk/U/wA
         4LymgxbLyqtfRIGlSYI85fCpYcNw1QP8eX0EyL9iN/amdLGa2G446mP9sQcBuwM6TH0/
         whcg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=4YcInQYj1ZdT5s/+ztHGDij8izUdzxlqFZLkv50wYZg=;
        b=ENDj5SG+xYp3SxsdVxRLwRWtZzhFZglFDx2tBdrNy8shnL8cl6biOX2h44lvbYGLDp
         izjU5G/rrwplKGtF6Npw3AxoVEEA9W5TDpavU2btBA2h9fxrJhaglFF9fVTvAZyoznCY
         lvnbkoE2OTjybRf/8F3nMBEzo7yZj3HeOGoGwMrhqC7JsptEFWC/xB5dwoZj79hw0SyG
         y1d0oAAtihniS4IOrDguHZchb1oI++PrVkaKHMlC7Ft0gkFVgZxjZ9GKxusznt9w5IXB
         JCZPjQcFOOAnDHo2+oyc5ZsDBOeS0VMIyusHynvEThcRte5OlE9qW9IZa/JrFJ4MnlQW
         l7PQ==
X-Gm-Message-State: ACrzQf18ax+ogRyVSNsuRkpJ3ywP8NXAJldHBGYeVKqXUYCjSpzdl4T+
        ECeq6gofR/I74GXBOdEIeRB4W4+sopFYAKD0Q28=
X-Google-Smtp-Source: AMsMyM6C/BN17E2FPcnuCMnQbQ0bcE6bTicwiazECuHjURlVvyOJKDDS+zWzx//K7C9mo9rJCaiHwg==
X-Received: by 2002:a05:600c:3509:b0:3c6:fd36:ef19 with SMTP id h9-20020a05600c350900b003c6fd36ef19mr16549919wmq.191.1667404940268;
        Wed, 02 Nov 2022 09:02:20 -0700 (PDT)
Received: from localhost ([86.61.181.4])
        by smtp.gmail.com with ESMTPSA id n15-20020a5d420f000000b0022da3977ec5sm13009611wrq.113.2022.11.02.09.02.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Nov 2022 09:02:19 -0700 (PDT)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, tariqt@nvidia.com, moshe@nvidia.com,
        saeedm@nvidia.com, linux-rdma@vger.kernel.org
Subject: [patch net-next v4 05/13] net: devlink: track netdev with devlink_port assigned
Date:   Wed,  2 Nov 2022 17:02:03 +0100
Message-Id: <20221102160211.662752-6-jiri@resnulli.us>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20221102160211.662752-1-jiri@resnulli.us>
References: <20221102160211.662752-1-jiri@resnulli.us>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jiri Pirko <jiri@nvidia.com>

Currently, ethernet drivers are using devlink_port_type_eth_set() and
devlink_port_type_clear() to set devlink port type and link to related
netdev.

Instead of calling them directly, let the driver use
SET_NETDEV_DEVLINK_PORT macro to assign devlink_port pointer and let
devlink to track it. Note the devlink port pointer is static during
the time netdevice is registered.

In devlink code, use per-namespace netdev notifier to track
the netdevices with devlink_port assigned and change the internal
devlink_port type and related type pointer accordingly.

Signed-off-by: Jiri Pirko <jiri@nvidia.com>
---
v3->v4:
- s/_devlink_port/port in SET_NETDEV_DEVLINK_PORT() macro
- fixed register_netdevice() error path
- put "dev" into into "()" in SET_NETDEV_DEVLINK_PORT() macro
v1->v2:
- added kdoc for devlink_port struct field
---
 include/linux/netdevice.h | 19 ++++++++++
 net/core/dev.c            | 14 +++++---
 net/core/devlink.c        | 75 ++++++++++++++++++++++++++++++++++++---
 3 files changed, 99 insertions(+), 9 deletions(-)

diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index 4b5052db978f..f048a30ea10b 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -1999,6 +1999,11 @@ enum netdev_ml_priv_type {
  *					registered
  *	@offload_xstats_l3:	L3 HW stats for this netdevice.
  *
+ *	@devlink_port:	Pointer to related devlink port structure.
+ *			Assigned by a driver before netdev registration using
+ *			SET_NETDEV_DEVLINK_PORT macro. This pointer is static
+ *			during the time netdevice is registered.
+ *
  *	FIXME: cleanup struct net_device such that network protocol info
  *	moves out.
  */
@@ -2349,9 +2354,22 @@ struct net_device {
 	netdevice_tracker	watchdog_dev_tracker;
 	netdevice_tracker	dev_registered_tracker;
 	struct rtnl_hw_stats64	*offload_xstats_l3;
+
+	struct devlink_port	*devlink_port;
 };
 #define to_net_dev(d) container_of(d, struct net_device, dev)
 
+/*
+ * Driver should use this to assign devlink port instance to a netdevice
+ * before it registers the netdevice. Therefore devlink_port is static
+ * during the netdev lifetime after it is registered.
+ */
+#define SET_NETDEV_DEVLINK_PORT(dev, port)			\
+({								\
+	WARN_ON((dev)->reg_state != NETREG_UNINITIALIZED);	\
+	((dev)->devlink_port = (port));				\
+})
+
 static inline bool netif_elide_gro(const struct net_device *dev)
 {
 	if (!(dev->features & NETIF_F_GRO) || dev->xdp_prog)
@@ -2785,6 +2803,7 @@ enum netdev_cmd {
 	NETDEV_PRE_TYPE_CHANGE,
 	NETDEV_POST_TYPE_CHANGE,
 	NETDEV_POST_INIT,
+	NETDEV_PRE_UNINIT,
 	NETDEV_RELEASE,
 	NETDEV_NOTIFY_PEERS,
 	NETDEV_JOIN,
diff --git a/net/core/dev.c b/net/core/dev.c
index 2e4f1c97b59e..3bacee3bee78 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -1621,10 +1621,10 @@ const char *netdev_cmd_to_name(enum netdev_cmd cmd)
 	N(UP) N(DOWN) N(REBOOT) N(CHANGE) N(REGISTER) N(UNREGISTER)
 	N(CHANGEMTU) N(CHANGEADDR) N(GOING_DOWN) N(CHANGENAME) N(FEAT_CHANGE)
 	N(BONDING_FAILOVER) N(PRE_UP) N(PRE_TYPE_CHANGE) N(POST_TYPE_CHANGE)
-	N(POST_INIT) N(RELEASE) N(NOTIFY_PEERS) N(JOIN) N(CHANGEUPPER)
-	N(RESEND_IGMP) N(PRECHANGEMTU) N(CHANGEINFODATA) N(BONDING_INFO)
-	N(PRECHANGEUPPER) N(CHANGELOWERSTATE) N(UDP_TUNNEL_PUSH_INFO)
-	N(UDP_TUNNEL_DROP_INFO) N(CHANGE_TX_QUEUE_LEN)
+	N(POST_INIT) N(PRE_UNINIT) N(RELEASE) N(NOTIFY_PEERS) N(JOIN)
+	N(CHANGEUPPER) N(RESEND_IGMP) N(PRECHANGEMTU) N(CHANGEINFODATA)
+	N(BONDING_INFO) N(PRECHANGEUPPER) N(CHANGELOWERSTATE)
+	N(UDP_TUNNEL_PUSH_INFO) N(UDP_TUNNEL_DROP_INFO) N(CHANGE_TX_QUEUE_LEN)
 	N(CVLAN_FILTER_PUSH_INFO) N(CVLAN_FILTER_DROP_INFO)
 	N(SVLAN_FILTER_PUSH_INFO) N(SVLAN_FILTER_DROP_INFO)
 	N(PRE_CHANGEADDR) N(OFFLOAD_XSTATS_ENABLE) N(OFFLOAD_XSTATS_DISABLE)
@@ -10060,7 +10060,7 @@ int register_netdevice(struct net_device *dev)
 	dev->reg_state = ret ? NETREG_UNREGISTERED : NETREG_REGISTERED;
 	write_unlock(&dev_base_lock);
 	if (ret)
-		goto err_uninit;
+		goto err_uninit_notify;
 
 	__netdev_update_features(dev);
 
@@ -10107,6 +10107,8 @@ int register_netdevice(struct net_device *dev)
 out:
 	return ret;
 
+err_uninit_notify:
+	call_netdevice_notifiers(NETDEV_PRE_UNINIT, dev);
 err_uninit:
 	if (dev->netdev_ops->ndo_uninit)
 		dev->netdev_ops->ndo_uninit(dev);
@@ -10856,6 +10858,8 @@ void unregister_netdevice_many_notify(struct list_head *head,
 		netdev_name_node_alt_flush(dev);
 		netdev_name_node_free(dev->name_node);
 
+		call_netdevice_notifiers(NETDEV_PRE_UNINIT, dev);
+
 		if (dev->netdev_ops->ndo_uninit)
 			dev->netdev_ops->ndo_uninit(dev);
 
diff --git a/net/core/devlink.c b/net/core/devlink.c
index 3387dfbb80c5..6f06c05c7b1a 100644
--- a/net/core/devlink.c
+++ b/net/core/devlink.c
@@ -71,6 +71,7 @@ struct devlink {
 	refcount_t refcount;
 	struct completion comp;
 	struct rcu_head rcu;
+	struct notifier_block netdevice_nb;
 	char priv[] __aligned(NETDEV_ALIGN);
 };
 
@@ -9615,6 +9616,9 @@ void devlink_set_features(struct devlink *devlink, u64 features)
 }
 EXPORT_SYMBOL_GPL(devlink_set_features);
 
+static int devlink_netdevice_event(struct notifier_block *nb,
+				   unsigned long event, void *ptr);
+
 /**
  *	devlink_alloc_ns - Allocate new devlink instance resources
  *	in specific namespace
@@ -9645,10 +9649,13 @@ struct devlink *devlink_alloc_ns(const struct devlink_ops *ops,
 
 	ret = xa_alloc_cyclic(&devlinks, &devlink->index, devlink, xa_limit_31b,
 			      &last_id, GFP_KERNEL);
-	if (ret < 0) {
-		kfree(devlink);
-		return NULL;
-	}
+	if (ret < 0)
+		goto err_xa_alloc;
+
+	devlink->netdevice_nb.notifier_call = devlink_netdevice_event;
+	ret = register_netdevice_notifier_net(net, &devlink->netdevice_nb);
+	if (ret)
+		goto err_register_netdevice_notifier;
 
 	devlink->dev = dev;
 	devlink->ops = ops;
@@ -9675,6 +9682,12 @@ struct devlink *devlink_alloc_ns(const struct devlink_ops *ops,
 	init_completion(&devlink->comp);
 
 	return devlink;
+
+err_register_netdevice_notifier:
+	xa_erase(&devlinks, devlink->index);
+err_xa_alloc:
+	kfree(devlink);
+	return NULL;
 }
 EXPORT_SYMBOL_GPL(devlink_alloc_ns);
 
@@ -9828,6 +9841,10 @@ void devlink_free(struct devlink *devlink)
 	WARN_ON(!list_empty(&devlink->port_list));
 
 	xa_destroy(&devlink->snapshot_ids);
+
+	unregister_netdevice_notifier_net(devlink_net(devlink),
+					  &devlink->netdevice_nb);
+
 	xa_erase(&devlinks, devlink->index);
 
 	kfree(devlink);
@@ -10121,6 +10138,56 @@ void devlink_port_type_clear(struct devlink_port *devlink_port)
 }
 EXPORT_SYMBOL_GPL(devlink_port_type_clear);
 
+static int devlink_netdevice_event(struct notifier_block *nb,
+				   unsigned long event, void *ptr)
+{
+	struct net_device *netdev = netdev_notifier_info_to_dev(ptr);
+	struct devlink_port *devlink_port = netdev->devlink_port;
+	struct devlink *devlink;
+
+	devlink = container_of(nb, struct devlink, netdevice_nb);
+
+	if (!devlink_port || devlink_port->devlink != devlink)
+		return NOTIFY_OK;
+
+	switch (event) {
+	case NETDEV_POST_INIT:
+		/* Set the type but not netdev pointer. It is going to be set
+		 * later on by NETDEV_REGISTER event. Happens once during
+		 * netdevice register
+		 */
+		__devlink_port_type_set(devlink_port, DEVLINK_PORT_TYPE_ETH,
+					NULL, true);
+		break;
+	case NETDEV_REGISTER:
+		/* Set the netdev on top of previously set type. Note this
+		 * event happens also during net namespace change so here
+		 * we take into account netdev pointer appearing in this
+		 * namespace.
+		 */
+		__devlink_port_type_set(devlink_port, DEVLINK_PORT_TYPE_ETH,
+					netdev, true);
+		break;
+	case NETDEV_UNREGISTER:
+		/* Clear netdev pointer, but not the type. This event happens
+		 * also during net namespace change so we need to clear
+		 * pointer to netdev that is going to another net namespace.
+		 */
+		__devlink_port_type_set(devlink_port, DEVLINK_PORT_TYPE_ETH,
+					NULL, true);
+		break;
+	case NETDEV_PRE_UNINIT:
+		/* Clear the type and the netdev pointer. Happens one during
+		 * netdevice unregister.
+		 */
+		__devlink_port_type_set(devlink_port, DEVLINK_PORT_TYPE_NOTSET,
+					NULL, true);
+		break;
+	}
+
+	return NOTIFY_OK;
+}
+
 static int __devlink_port_attrs_set(struct devlink_port *devlink_port,
 				    enum devlink_port_flavour flavour)
 {
-- 
2.37.3

