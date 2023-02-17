Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D53A569AB7F
	for <lists+netdev@lfdr.de>; Fri, 17 Feb 2023 13:29:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229787AbjBQM3x (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Feb 2023 07:29:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35402 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229974AbjBQM3v (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Feb 2023 07:29:51 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3DEAE66058
        for <netdev@vger.kernel.org>; Fri, 17 Feb 2023 04:29:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1676636952;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Xl6b2R9ZFciSVzJsFD9A6yzvWOLcM2ydxS1cz874sp4=;
        b=Zdp+iG7qYh5iFkMaUqZftwD638O5vBP4KQSPBSM2hZUYza9KhDiELhVViSGSRi0tWP5+YH
        tM0nGY+7aKh6yK6hUrz3feAxV32xYkumtLpMp+KDZhMHhGeFzd+Rq8uc9JeXeKHVvOz3Ls
        RQIv0FW0GDYFowx73cPu9Y4oRtE1KuU=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-55-aarHVRZxMS2iPVTicTyVbQ-1; Fri, 17 Feb 2023 07:29:07 -0500
X-MC-Unique: aarHVRZxMS2iPVTicTyVbQ-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id AC4A13C218A5;
        Fri, 17 Feb 2023 12:29:06 +0000 (UTC)
Received: from gerbillo.redhat.com (unknown [10.39.192.169])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 99E9D404CD84;
        Fri, 17 Feb 2023 12:29:05 +0000 (UTC)
From:   Paolo Abeni <pabeni@redhat.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Shuah Khan <shuah@kernel.org>
Subject: [PATCH v2 net-next 1/2] net: make default_rps_mask a per netns attribute
Date:   Fri, 17 Feb 2023 13:28:49 +0100
Message-Id: <25427ebf3d3f533bca446f9df4794a1b7021f318.1676635317.git.pabeni@redhat.com>
In-Reply-To: <cover.1676635317.git.pabeni@redhat.com>
References: <cover.1676635317.git.pabeni@redhat.com>
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
v1 -> v2:
 - fix build issue for !CONFIG_CPUMASK_OFFSTACK build
---
 include/linux/netdevice.h  |  1 -
 include/net/netns/core.h   |  5 ++++
 net/core/net-sysfs.c       | 23 +++++++++++------
 net/core/sysctl_net_core.c | 51 ++++++++++++++++++++++++++++----------
 4 files changed, 59 insertions(+), 21 deletions(-)

diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index efbee940bb03..6a14b7b11766 100644
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
index 7130e6d9e263..74842b453407 100644
--- a/net/core/sysctl_net_core.c
+++ b/net/core/sysctl_net_core.c
@@ -74,24 +74,47 @@ static void dump_cpumask(void *buffer, size_t *lenp, loff_t *ppos,
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
+	rps_default_mask = kzalloc(cpumask_size(), GFP_KERNEL);
+	if (!rps_default_mask)
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
@@ -508,11 +531,6 @@ static struct ctl_table net_core_table[] = {
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
@@ -639,6 +657,14 @@ static struct ctl_table net_core_table[] = {
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
@@ -706,6 +732,9 @@ static __net_exit void sysctl_core_net_exit(struct net *net)
 	tbl = net->core.sysctl_hdr->ctl_table_arg;
 	unregister_net_sysctl_table(net->core.sysctl_hdr);
 	BUG_ON(tbl == netns_core_table);
+#if IS_ENABLED(CONFIG_RPS)
+	kfree(net->core.rps_default_mask);
+#endif
 	kfree(tbl);
 }
 
@@ -716,10 +745,6 @@ static __net_initdata struct pernet_operations sysctl_core_ops = {
 
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

