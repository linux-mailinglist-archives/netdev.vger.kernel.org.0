Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E506D5F1A19
	for <lists+netdev@lfdr.de>; Sat,  1 Oct 2022 08:02:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229528AbiJAGCJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 1 Oct 2022 02:02:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39808 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229504AbiJAGB5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 1 Oct 2022 02:01:57 -0400
Received: from mail-ej1-x62a.google.com (mail-ej1-x62a.google.com [IPv6:2a00:1450:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 322C4D69CA
        for <netdev@vger.kernel.org>; Fri, 30 Sep 2022 23:01:56 -0700 (PDT)
Received: by mail-ej1-x62a.google.com with SMTP id a26so12934663ejc.4
        for <netdev@vger.kernel.org>; Fri, 30 Sep 2022 23:01:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date;
        bh=lea5PLKZ58znw+DawppjRC65v5mDRzmWPn10Zx3u/qc=;
        b=EvokO5T+X/OIQDXPrShYSGMAeLoNuLIvwvVFgksFIDGXHtJ5/EMQl7/oFNVg9opI/9
         rnvw3ieSAKhLJt6czFzb70i1wDL81tAWZ1O+uBmTGnYiJnYAkysMukuGQFGkI8Wq1HSp
         a30QJpEDqaHV8hPtrta+lAtUpl4DGVpDe7cO6uL0voE/HVFQZ3a6/Ge3/6YMVJwxZBP0
         jhcN/dRXwRuB3uLcxs9zATROZ2zVQ6cND8RnEZUgTOCyfwzu2iqzIlP202WbgXDaw9Nq
         Tgye5Ni6892NrQhyHj6QTxjoBvdQZzmBKWXZkALpR+Q2AFr52V28ZfjmLropBCsOaRwh
         DxiA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date;
        bh=lea5PLKZ58znw+DawppjRC65v5mDRzmWPn10Zx3u/qc=;
        b=gyCju8QEr5R2CXlw80eFGZD0CnhmuED/Gd1wCKFmKd49QG93olSZvK4ORvsYAt5O2R
         HhTsjo1STntjQlFscj794+r9j+rzkUUaRQ5w/1SVS5n2Gd7sP+uugfFoVNa0Pqxzck3+
         ZvkIsC/E8UWqlhCGZh6yP9QyNyRmTwAAfuWfojutQG+ie7IGrV6ZHi/nqdlea5Nc75I3
         FpTbqF9IoKTzcOj9hLC50wqUN1ps+LCsHkG42LGN9K2clHwgO48cum525s2CP4b0JJRf
         MILdPtMo6j5jTKE770e7l+XYFgF8Q5Bbg7xzgeN9Qsnf5w1Xso3Agu9dRbK0TjHtAWfJ
         C0fQ==
X-Gm-Message-State: ACrzQf3e67NkJc1iGd01qapgUCc1AbA3iC5H4SoKFAc3oCNiPWBIan2t
        CMs2lq8QWcHpQ+vN5mu9ojGymg0qGDLFnlkg
X-Google-Smtp-Source: AMsMyM6ceQt0nxHRCLDQaHjBwpzTf3C2fCAs0s525/lSvVAf2Q5nQajglFnJOLNwUfS9MfM23FVfPQ==
X-Received: by 2002:a17:907:94d0:b0:783:d969:f30c with SMTP id dn16-20020a17090794d000b00783d969f30cmr8703739ejc.165.1664604115717;
        Fri, 30 Sep 2022 23:01:55 -0700 (PDT)
Received: from localhost (host-213-179-129-39.customer.m-online.net. [213.179.129.39])
        by smtp.gmail.com with ESMTPSA id c5-20020a170906528500b0078194737761sm2167032ejm.124.2022.09.30.23.01.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 30 Sep 2022 23:01:55 -0700 (PDT)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, tariqt@nvidia.com, moshe@nvidia.com,
        saeedm@nvidia.com
Subject: [patch net-next 05/13] net: devlink: track netdev with devlink_port assigned
Date:   Sat,  1 Oct 2022 08:01:37 +0200
Message-Id: <20221001060145.3199964-6-jiri@resnulli.us>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20221001060145.3199964-1-jiri@resnulli.us>
References: <20221001060145.3199964-1-jiri@resnulli.us>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
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
 include/linux/netdevice.h | 14 ++++++++
 net/core/dev.c            | 11 +++---
 net/core/devlink.c        | 75 ++++++++++++++++++++++++++++++++++++---
 3 files changed, 92 insertions(+), 8 deletions(-)

diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index eddf8ee270e7..73ae13dd3657 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -2349,9 +2349,22 @@ struct net_device {
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
+#define SET_NETDEV_DEVLINK_PORT(dev, _devlink_port)		\
+({								\
+	WARN_ON(dev->reg_state != NETREG_UNINITIALIZED);	\
+	((dev)->devlink_port = (_devlink_port));		\
+})
+
 static inline bool netif_elide_gro(const struct net_device *dev)
 {
 	if (!(dev->features & NETIF_F_GRO) || dev->xdp_prog)
@@ -2785,6 +2798,7 @@ enum netdev_cmd {
 	NETDEV_PRE_TYPE_CHANGE,
 	NETDEV_POST_TYPE_CHANGE,
 	NETDEV_POST_INIT,
+	NETDEV_PRE_UNINIT,
 	NETDEV_RELEASE,
 	NETDEV_NOTIFY_PEERS,
 	NETDEV_JOIN,
diff --git a/net/core/dev.c b/net/core/dev.c
index fa53830d0683..1b45aa5c976e 100644
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
@@ -10103,6 +10103,7 @@ int register_netdevice(struct net_device *dev)
 	return ret;
 
 err_uninit:
+	call_netdevice_notifiers(NETDEV_PRE_UNINIT, dev);
 	if (dev->netdev_ops->ndo_uninit)
 		dev->netdev_ops->ndo_uninit(dev);
 	if (dev->priv_destructor)
@@ -10856,6 +10857,8 @@ void unregister_netdevice_many(struct list_head *head)
 		netdev_name_node_alt_flush(dev);
 		netdev_name_node_free(dev->name_node);
 
+		call_netdevice_notifiers(NETDEV_PRE_UNINIT, dev);
+
 		if (dev->netdev_ops->ndo_uninit)
 			dev->netdev_ops->ndo_uninit(dev);
 
diff --git a/net/core/devlink.c b/net/core/devlink.c
index ee14520d4690..87aa39bc481e 100644
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
2.37.1

