Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 164AE68E06F
	for <lists+netdev@lfdr.de>; Tue,  7 Feb 2023 19:47:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232351AbjBGSrO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Feb 2023 13:47:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40330 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232476AbjBGSq7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Feb 2023 13:46:59 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1CAA222A0A
        for <netdev@vger.kernel.org>; Tue,  7 Feb 2023 10:46:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1675795568;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=DcjAUBS6DrJjvz1ZmqpbBWVyrgU0V5f/ycGA4W1BQYc=;
        b=i7tyKtUn7cqRW2EOODbGUuC8XzZIluCNvCmhhZmLBnUjW7Vxx/U1P27rDtfCce/eN0FiVP
        +6A4TmQe0kSDoIJsg/DzPqt7bJ4Cl4r/I/1MIPWpbpS/apdhJGCOGdin3mxeia/BK77Xpp
        sD4VMSP8ck57uh90qFeVnnNMYm8aI5A=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-168-TsvNPkVyP8Gl7Yleci5f2A-1; Tue, 07 Feb 2023 13:46:04 -0500
X-MC-Unique: TsvNPkVyP8Gl7Yleci5f2A-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id A12BD1C0754A;
        Tue,  7 Feb 2023 18:46:03 +0000 (UTC)
Received: from gerbillo.redhat.com (unknown [10.39.193.110])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 6F46A400D9D0;
        Tue,  7 Feb 2023 18:46:02 +0000 (UTC)
From:   Paolo Abeni <pabeni@redhat.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Jonathan Corbet <corbet@lwn.net>, Shuah Khan <shuah@kernel.org>
Subject: [PATCH v4 net-next 3/4] net: introduce default_rps_mask netns attribute
Date:   Tue,  7 Feb 2023 19:44:57 +0100
Message-Id: <174196670b96f53db4b16239ee4847575b4998e5.1675789134.git.pabeni@redhat.com>
In-Reply-To: <cover.1675789134.git.pabeni@redhat.com>
References: <cover.1675789134.git.pabeni@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.1
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If RPS is enabled, this allows configuring a default rps
mask, which is effective since receive queue creation time.

A default RPS mask allows the system admin to ensure proper
isolation, avoiding races at network namespace or device
creation time.

The default RPS mask is initially empty, and can be
modified via a newly added sysctl entry.

Signed-off-by: Paolo Abeni <pabeni@redhat.com>
---
v2 -> v3:
 - avoid a bit of code duplication thanks to new
   helpers in patch 1/4 and 2/4
---
 Documentation/admin-guide/sysctl/net.rst |  6 ++++
 include/linux/netdevice.h                |  1 +
 net/core/net-sysfs.c                     |  7 +++++
 net/core/sysctl_net_core.c               | 37 +++++++++++++++++++++++-
 4 files changed, 50 insertions(+), 1 deletion(-)

diff --git a/Documentation/admin-guide/sysctl/net.rst b/Documentation/admin-guide/sysctl/net.rst
index 6394f5dc2303..466c560b0c30 100644
--- a/Documentation/admin-guide/sysctl/net.rst
+++ b/Documentation/admin-guide/sysctl/net.rst
@@ -215,6 +215,12 @@ rmem_max
 
 The maximum receive socket buffer size in bytes.
 
+rps_default_mask
+----------------
+
+The default RPS CPU mask used on newly created network devices. An empty
+mask means RPS disabled by default.
+
 tstamp_allow_data
 -----------------
 Allow processes to receive tx timestamps looped together with the original
diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index d5ef4c1fedd2..38ab96ae0d68 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -223,6 +223,7 @@ struct net_device_core_stats {
 #include <linux/static_key.h>
 extern struct static_key_false rps_needed;
 extern struct static_key_false rfs_needed;
+extern struct cpumask rps_default_mask;
 #endif
 
 struct neighbour;
diff --git a/net/core/net-sysfs.c b/net/core/net-sysfs.c
index 2126970a4bfd..4b361ac6a252 100644
--- a/net/core/net-sysfs.c
+++ b/net/core/net-sysfs.c
@@ -1083,6 +1083,13 @@ static int rx_queue_add_kobject(struct net_device *dev, int index)
 			goto err;
 	}
 
+#if IS_ENABLED(CONFIG_RPS) && IS_ENABLED(CONFIG_SYSCTL)
+	if (!cpumask_empty(&rps_default_mask)) {
+		error = netdev_rx_queue_set_rps_mask(queue, &rps_default_mask);
+		if (error)
+			goto err;
+	}
+#endif
 	kobject_uevent(kobj, KOBJ_ADD);
 
 	return error;
diff --git a/net/core/sysctl_net_core.c b/net/core/sysctl_net_core.c
index 6935ecdc84b0..7130e6d9e263 100644
--- a/net/core/sysctl_net_core.c
+++ b/net/core/sysctl_net_core.c
@@ -16,6 +16,7 @@
 #include <linux/vmalloc.h>
 #include <linux/init.h>
 #include <linux/slab.h>
+#include <linux/sched/isolation.h>
 
 #include <net/ip.h>
 #include <net/sock.h>
@@ -45,7 +46,7 @@ EXPORT_SYMBOL(sysctl_fb_tunnels_only_for_init_net);
 int sysctl_devconf_inherit_init_net __read_mostly;
 EXPORT_SYMBOL(sysctl_devconf_inherit_init_net);
 
-#if IS_ENABLED(CONFIG_NET_FLOW_LIMIT)
+#if IS_ENABLED(CONFIG_NET_FLOW_LIMIT) || IS_ENABLED(CONFIG_RPS)
 static void dump_cpumask(void *buffer, size_t *lenp, loff_t *ppos,
 			 struct cpumask *mask)
 {
@@ -73,6 +74,31 @@ static void dump_cpumask(void *buffer, size_t *lenp, loff_t *ppos,
 #endif
 
 #ifdef CONFIG_RPS
+struct cpumask rps_default_mask;
+
+static int rps_default_mask_sysctl(struct ctl_table *table, int write,
+				   void *buffer, size_t *lenp, loff_t *ppos)
+{
+	int err = 0;
+
+	rtnl_lock();
+	if (write) {
+		err = cpumask_parse(buffer, &rps_default_mask);
+		if (err)
+			goto done;
+
+		err = rps_cpumask_housekeeping(&rps_default_mask);
+		if (err)
+			goto done;
+	} else {
+		dump_cpumask(buffer, lenp, ppos, &rps_default_mask);
+	}
+
+done:
+	rtnl_unlock();
+	return err;
+}
+
 static int rps_sock_flow_sysctl(struct ctl_table *table, int write,
 				void *buffer, size_t *lenp, loff_t *ppos)
 {
@@ -482,6 +508,11 @@ static struct ctl_table net_core_table[] = {
 		.mode		= 0644,
 		.proc_handler	= rps_sock_flow_sysctl
 	},
+	{
+		.procname	= "rps_default_mask",
+		.mode		= 0644,
+		.proc_handler	= rps_default_mask_sysctl
+	},
 #endif
 #ifdef CONFIG_NET_FLOW_LIMIT
 	{
@@ -685,6 +716,10 @@ static __net_initdata struct pernet_operations sysctl_core_ops = {
 
 static __init int sysctl_core_init(void)
 {
+#if IS_ENABLED(CONFIG_RPS)
+	cpumask_copy(&rps_default_mask, cpu_none_mask);
+#endif
+
 	register_net_sysctl(&init_net, "net/core", net_core_table);
 	return register_pernet_subsys(&sysctl_core_ops);
 }
-- 
2.39.1

