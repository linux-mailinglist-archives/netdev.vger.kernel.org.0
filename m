Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 54F1AC1CB0
	for <lists+netdev@lfdr.de>; Mon, 30 Sep 2019 10:17:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729991AbfI3IPT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Sep 2019 04:15:19 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:42245 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726121AbfI3IPS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Sep 2019 04:15:18 -0400
Received: by mail-wr1-f65.google.com with SMTP id n14so10085537wrw.9
        for <netdev@vger.kernel.org>; Mon, 30 Sep 2019 01:15:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=69kJFwUKO4AC21wRVBRK0p2Y5z+75KMtG7Q64IsGAbM=;
        b=dPpx08ZlhpEZfbufNNNTrU/q7WfNG7y46d1xS/ANlcgqsePKbg0RGVdIzF3miugJFW
         FtcGr/RdHag5/vKvtu2M9K8XkK8NY0/gtM3stWD8f4t2b3oi8r26enIDyUey2iQqSrZ3
         Cb7O8hGC8LdLoHfBtGXTV7BzFH3w/pnGAKO38vaZYjIVnBx8f8gBEPk6nNlwh44Wlasq
         kXl3mCvTf0wgsEHwp5tOddcKoyn9XhRDMB9onmfrRArzZVS0hD48fQFjYsBxt8XpPEg4
         2L6T2U1GkxE8j2WcaQ6pBiQqAAJaVbtGJxRaa/C5Zcn6D0Zb5dOzdJmwfqEdiFPb4Bu+
         Wu4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=69kJFwUKO4AC21wRVBRK0p2Y5z+75KMtG7Q64IsGAbM=;
        b=hfy0r31STERaEgCUCtMc9wsQKSMcCyXwTqXEVmP86y+xMTEdqx5fghHMLzTehx751w
         +CmamY7e6norMJOKeJfqWgZI2QB9zmM7qfagraZux9oA4zZvlYiM63oXK7242T8o+JSd
         JiGZUrjNLVIS7xs8TithScfb/hHLaLYf2+dcO43n8W60rQAIzzE3x/89US7+aDM2ijnv
         vVjH3+Mgee2feJ444JsC65kqXijPMeag1l0LUm1Y2mtkTFofjY3dY0ZYP7sWbC0ZPkIC
         619HI3ZNUjiEY3bvTRwKOKlYywnkfEH20rTJXmvDNFcdf6KyjXDzwKpMXIOnHU4l7Njx
         d90Q==
X-Gm-Message-State: APjAAAXKpGlfZwFcnECyfXTxnDLjjU6lv3f6cLmu+MhppUIIPyS5+4Mj
        DIWB5IGjCbeBb7PlaUi2LaiSEioPEto=
X-Google-Smtp-Source: APXvYqzS7RzCNYgm5zp6Wr3fzJPmJzsZM3pibmFGmIJhWQhWKUzzcEonZDJvgmxnZOa3rkJ0yky2Wg==
X-Received: by 2002:adf:ec44:: with SMTP id w4mr11668195wrn.251.1569831315042;
        Mon, 30 Sep 2019 01:15:15 -0700 (PDT)
Received: from localhost (ip-89-177-132-96.net.upcbroadband.cz. [89.177.132.96])
        by smtp.gmail.com with ESMTPSA id x129sm18974507wmg.8.2019.09.30.01.15.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 30 Sep 2019 01:15:14 -0700 (PDT)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, idosch@mellanox.com, pabeni@redhat.com,
        edumazet@google.com, petrm@mellanox.com, sd@queasysnail.net,
        f.fainelli@gmail.com, stephen@networkplumber.org,
        mlxsw@mellanox.com
Subject: [patch net-next 2/3] net: introduce per-netns netdevice notifiers
Date:   Mon, 30 Sep 2019 10:15:10 +0200
Message-Id: <20190930081511.26915-3-jiri@resnulli.us>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190930081511.26915-1-jiri@resnulli.us>
References: <20190930081511.26915-1-jiri@resnulli.us>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jiri Pirko <jiri@mellanox.com>

Often the code for example in drivers is interested in getting notifier
call only from certain network namespace. In addition to the existing
global netdevice notifier chain introduce per-netns chains and allow
users to register to that. Eventually this would eliminate unnecessary
overhead in case there are many netdevices in many network namespaces.

Signed-off-by: Jiri Pirko <jiri@mellanox.com>
---
 include/linux/netdevice.h   |  3 ++
 include/net/net_namespace.h |  3 ++
 net/core/dev.c              | 87 +++++++++++++++++++++++++++++++++++++
 3 files changed, 93 insertions(+)

diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index 4f390eec106b..184f54f1b9e1 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -2494,6 +2494,9 @@ const char *netdev_cmd_to_name(enum netdev_cmd cmd);
 
 int register_netdevice_notifier(struct notifier_block *nb);
 int unregister_netdevice_notifier(struct notifier_block *nb);
+int register_netdevice_notifier_net(struct net *net, struct notifier_block *nb);
+int unregister_netdevice_notifier_net(struct net *net,
+				      struct notifier_block *nb);
 
 struct netdev_notifier_info {
 	struct net_device	*dev;
diff --git a/include/net/net_namespace.h b/include/net/net_namespace.h
index c5a98e03591d..5ac2bb16d4b3 100644
--- a/include/net/net_namespace.h
+++ b/include/net/net_namespace.h
@@ -36,6 +36,7 @@
 #include <linux/ns_common.h>
 #include <linux/idr.h>
 #include <linux/skbuff.h>
+#include <linux/notifier.h>
 
 struct user_namespace;
 struct proc_dir_entry;
@@ -96,6 +97,8 @@ struct net {
 	struct list_head 	dev_base_head;
 	struct hlist_head 	*dev_name_head;
 	struct hlist_head	*dev_index_head;
+	struct raw_notifier_head	netdev_chain;
+
 	unsigned int		dev_base_seq;	/* protected by rtnl_mutex */
 	int			ifindex;
 	unsigned int		dev_unreg_count;
diff --git a/net/core/dev.c b/net/core/dev.c
index 6a87d0e71201..3302cefd3041 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -1766,6 +1766,80 @@ int unregister_netdevice_notifier(struct notifier_block *nb)
 }
 EXPORT_SYMBOL(unregister_netdevice_notifier);
 
+/**
+ * register_netdevice_notifier_net - register a per-netns network notifier block
+ * @net: network namespace
+ * @nb: notifier
+ *
+ * Register a notifier to be called when network device events occur.
+ * The notifier passed is linked into the kernel structures and must
+ * not be reused until it has been unregistered. A negative errno code
+ * is returned on a failure.
+ *
+ * When registered all registration and up events are replayed
+ * to the new notifier to allow device to have a race free
+ * view of the network device list.
+ */
+
+int register_netdevice_notifier_net(struct net *net, struct notifier_block *nb)
+{
+	int err;
+
+	rtnl_lock();
+	err = raw_notifier_chain_register(&net->netdev_chain, nb);
+	if (err)
+		goto unlock;
+	if (dev_boot_phase)
+		goto unlock;
+
+	err = call_netdevice_register_net_notifiers(nb, net);
+	if (err)
+		goto chain_unregister;
+
+unlock:
+	rtnl_unlock();
+	return err;
+
+chain_unregister:
+	raw_notifier_chain_unregister(&netdev_chain, nb);
+	goto unlock;
+}
+EXPORT_SYMBOL(register_netdevice_notifier_net);
+
+/**
+ * unregister_netdevice_notifier_net - unregister a per-netns
+ *                                     network notifier block
+ * @net: network namespace
+ * @nb: notifier
+ *
+ * Unregister a notifier previously registered by
+ * register_netdevice_notifier(). The notifier is unlinked into the
+ * kernel structures and may then be reused. A negative errno code
+ * is returned on a failure.
+ *
+ * After unregistering unregister and down device events are synthesized
+ * for all devices on the device list to the removed notifier to remove
+ * the need for special case cleanup code.
+ */
+
+int unregister_netdevice_notifier_net(struct net *net,
+				      struct notifier_block *nb)
+{
+	int err;
+
+	rtnl_lock();
+	err = raw_notifier_chain_unregister(&net->netdev_chain, nb);
+	if (err)
+		goto unlock;
+
+	call_netdevice_unregister_net_notifiers(nb, net);
+
+unlock:
+	rtnl_unlock();
+	return err;
+}
+EXPORT_SYMBOL(unregister_netdevice_notifier_net);
+
 /**
  *	call_netdevice_notifiers_info - call all network notifier blocks
  *	@val: value passed unmodified to notifier function
@@ -1778,7 +1852,18 @@ EXPORT_SYMBOL(unregister_netdevice_notifier);
 static int call_netdevice_notifiers_info(unsigned long val,
 					 struct netdev_notifier_info *info)
 {
+	struct net *net = dev_net(info->dev);
+	int ret;
+
 	ASSERT_RTNL();
+
+	/* Run per-netns notifier block chain first, then run the global one.
+	 * Hopefully, one day, the global one is going to be removed after
+	 * all notifier block registrators get converted to be per-netns.
+	 */
+	ret = raw_notifier_call_chain(&net->netdev_chain, val, info);
+	if (ret & NOTIFY_STOP_MASK)
+		return ret;
 	return raw_notifier_call_chain(&netdev_chain, val, info);
 }
 
@@ -9668,6 +9753,8 @@ static int __net_init netdev_init(struct net *net)
 	if (net->dev_index_head == NULL)
 		goto err_idx;
 
+	RAW_INIT_NOTIFIER_HEAD(&net->netdev_chain);
+
 	return 0;
 
 err_idx:
-- 
2.21.0

