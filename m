Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B6A9A698386
	for <lists+netdev@lfdr.de>; Wed, 15 Feb 2023 19:36:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229744AbjBOSgD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Feb 2023 13:36:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49150 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230315AbjBOSer (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Feb 2023 13:34:47 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1CF439CD0
        for <netdev@vger.kernel.org>; Wed, 15 Feb 2023 10:33:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1676486035;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=p+zlbmZMR4hsld22bRV2DVnCcZSwmk5Nte8WxJWEv9g=;
        b=ZSKU9axbR+YCLo0taI03xsLDbFQkJYlegPnmz+ZW18s5G/84rRnKymmh5kQ+hO08dbsljG
        1ldNh/05+Ce6nS8aUwY1++WqOcTMyGw2IWyd80Y6IupSiX+zxdVzoGjC+olZDavkL7DihZ
        s7EBw+PETQQyYguY7kSld2/ZSb/WYA8=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-26-UvsGnOwSOxaJR4MqKqGsag-1; Wed, 15 Feb 2023 13:33:52 -0500
X-MC-Unique: UvsGnOwSOxaJR4MqKqGsag-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id CD44A1C08972;
        Wed, 15 Feb 2023 18:33:51 +0000 (UTC)
Received: from gerbillo.redhat.com (unknown [10.39.192.137])
        by smtp.corp.redhat.com (Postfix) with ESMTP id BFD0040C1106;
        Wed, 15 Feb 2023 18:33:50 +0000 (UTC)
From:   Paolo Abeni <pabeni@redhat.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Shuah Khan <shuah@kernel.org>
Subject: [PATCH net-next 1/2] net: make default_rps_mask a per netns attribute
Date:   Wed, 15 Feb 2023 19:33:36 +0100
Message-Id: <35bde791a3fd775f0a027bba04a549233b705494.1676484775.git.pabeni@redhat.com>
In-Reply-To: <cover.1676484775.git.pabeni@redhat.com>
References: <cover.1676484775.git.pabeni@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

That really was meant to be a per netns attribute from the beginning.

The idea is that once proper isolation is in place in the main
namespace, additional demux in the child namespaces will be redundant.
Let's make child netns default rps mask empty by default.

To avoid bloating the netns with a possibly large cpumask, allocate
it on-demand during the first write operation.

Signed-off-by: Paolo Abeni <pabeni@redhat.com>
---
 include/linux/netdevice.h  |  1 -
 include/net/netns/core.h   |  5 ++++
 net/core/net-sysfs.c       | 23 ++++++++++++------
 net/core/sysctl_net_core.c | 50 ++++++++++++++++++++++++++++----------
 4 files changed, 58 insertions(+), 21 deletions(-)

diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index d9cdbc047b49..409300524822 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -224,7 +224,6 @@ struct net_device_core_stats {
 #include <linux/static_key.h>
 extern struct static_key_false rps_needed;
 extern struct static_key_false rfs_needed;
-extern struct cpumask rps_default_mask;
 #endif
 
 struct neighbour;
diff --git a/include/net/netns/core.h b/include/net/netns/core.h
index 8249060cf5d0..a91ef9f8de60 100644
--- a/include/net/netns/core.h
+++ b/include/net/netns/core.h
@@ -6,6 +6,7 @@
 
 struct ctl_table_header;
 struct prot_inuse;
+struct cpumask;
 
 struct netns_core {
 	/* core sysctls */
@@ -17,6 +18,10 @@ struct netns_core {
 #ifdef CONFIG_PROC_FS
 	struct prot_inuse __percpu *prot_inuse;
 #endif
+
+#if IS_ENABLED(CONFIG_RPS) && IS_ENABLED(CONFIG_SYSCTL)
+	struct cpumask *rps_default_mask;
+#endif
 };
 
 #endif
diff --git a/net/core/net-sysfs.c b/net/core/net-sysfs.c
index e20784b6f873..15e3f4606b5f 100644
--- a/net/core/net-sysfs.c
+++ b/net/core/net-sysfs.c
@@ -1060,6 +1060,18 @@ static const struct kobj_type rx_queue_ktype = {
 	.get_ownership = rx_queue_get_ownership,
 };
 
+static int rx_queue_default_mask(struct net_device *dev,
+				 struct netdev_rx_queue *queue)
+{
+#if IS_ENABLED(CONFIG_RPS) && IS_ENABLED(CONFIG_SYSCTL)
+	struct cpumask *rps_default_mask = READ_ONCE(dev_net(dev)->core.rps_default_mask);
+
+	if (rps_default_mask && !cpumask_empty(rps_default_mask))
+		return netdev_rx_queue_set_rps_mask(queue, rps_default_mask);
+#endif
+	return 0;
+}
+
 static int rx_queue_add_kobject(struct net_device *dev, int index)
 {
 	struct netdev_rx_queue *queue = dev->_rx + index;
@@ -1083,13 +1095,10 @@ static int rx_queue_add_kobject(struct net_device *dev, int index)
 			goto err;
 	}
 
-#if IS_ENABLED(CONFIG_RPS) && IS_ENABLED(CONFIG_SYSCTL)
-	if (!cpumask_empty(&rps_default_mask)) {
-		error = netdev_rx_queue_set_rps_mask(queue, &rps_default_mask);
-		if (error)
-			goto err;
-	}
-#endif
+	error = rx_queue_default_mask(dev, queue);
+	if (error)
+		goto err;
+
 	kobject_uevent(kobj, KOBJ_ADD);
 
 	return error;
diff --git a/net/core/sysctl_net_core.c b/net/core/sysctl_net_core.c
index 7130e6d9e263..e9848f35495d 100644
--- a/net/core/sysctl_net_core.c
+++ b/net/core/sysctl_net_core.c
@@ -74,24 +74,46 @@ static void dump_cpumask(void *buffer, size_t *lenp, loff_t *ppos,
 #endif
 
 #ifdef CONFIG_RPS
-struct cpumask rps_default_mask;
+
+static struct cpumask *rps_default_mask_cow_alloc(struct net *net)
+{
+	struct cpumask *rps_default_mask;
+
+	if (net->core.rps_default_mask)
+		return net->core.rps_default_mask;
+
+	if (!zalloc_cpumask_var(&rps_default_mask, GFP_KERNEL))
+		return NULL;
+
+	/* pairs with READ_ONCE in rx_queue_default_mask() */
+	WRITE_ONCE(net->core.rps_default_mask, rps_default_mask);
+	return rps_default_mask;
+}
 
 static int rps_default_mask_sysctl(struct ctl_table *table, int write,
 				   void *buffer, size_t *lenp, loff_t *ppos)
 {
+	struct net *net = (struct net *)table->data;
 	int err = 0;
 
 	rtnl_lock();
 	if (write) {
-		err = cpumask_parse(buffer, &rps_default_mask);
+		struct cpumask *rps_default_mask = rps_default_mask_cow_alloc(net);
+
+		err = -ENOMEM;
+		if (!rps_default_mask)
+			goto done;
+
+		err = cpumask_parse(buffer, rps_default_mask);
 		if (err)
 			goto done;
 
-		err = rps_cpumask_housekeeping(&rps_default_mask);
+		err = rps_cpumask_housekeeping(rps_default_mask);
 		if (err)
 			goto done;
 	} else {
-		dump_cpumask(buffer, lenp, ppos, &rps_default_mask);
+		dump_cpumask(buffer, lenp, ppos,
+			     net->core.rps_default_mask ? : cpu_none_mask);
 	}
 
 done:
@@ -508,11 +530,6 @@ static struct ctl_table net_core_table[] = {
 		.mode		= 0644,
 		.proc_handler	= rps_sock_flow_sysctl
 	},
-	{
-		.procname	= "rps_default_mask",
-		.mode		= 0644,
-		.proc_handler	= rps_default_mask_sysctl
-	},
 #endif
 #ifdef CONFIG_NET_FLOW_LIMIT
 	{
@@ -639,6 +656,14 @@ static struct ctl_table net_core_table[] = {
 };
 
 static struct ctl_table netns_core_table[] = {
+#if IS_ENABLED(CONFIG_RPS)
+	{
+		.procname	= "rps_default_mask",
+		.data		= &init_net,
+		.mode		= 0644,
+		.proc_handler	= rps_default_mask_sysctl
+	},
+#endif
 	{
 		.procname	= "somaxconn",
 		.data		= &init_net.core.sysctl_somaxconn,
@@ -706,6 +731,9 @@ static __net_exit void sysctl_core_net_exit(struct net *net)
 	tbl = net->core.sysctl_hdr->ctl_table_arg;
 	unregister_net_sysctl_table(net->core.sysctl_hdr);
 	BUG_ON(tbl == netns_core_table);
+#if IS_ENABLED(CONFIG_RPS)
+	kfree(net->core.rps_default_mask);
+#endif
 	kfree(tbl);
 }
 
@@ -716,10 +744,6 @@ static __net_initdata struct pernet_operations sysctl_core_ops = {
 
 static __init int sysctl_core_init(void)
 {
-#if IS_ENABLED(CONFIG_RPS)
-	cpumask_copy(&rps_default_mask, cpu_none_mask);
-#endif
-
 	register_net_sysctl(&init_net, "net/core", net_core_table);
 	return register_pernet_subsys(&sysctl_core_ops);
 }
-- 
2.39.1

