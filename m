Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1382E2A03E6
	for <lists+netdev@lfdr.de>; Fri, 30 Oct 2020 12:16:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726430AbgJ3LQi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Oct 2020 07:16:38 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:28883 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726308AbgJ3LQg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Oct 2020 07:16:36 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1604056594;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Vb6FoObRC7TNOdfp5eIxNq4N0EhVG53AtqK1jDnGeFM=;
        b=GtQImrB2voOOHdq6TMFerKksp3KG2HpQ+EUqPflqrbgwXrDRycOCnTOaczYkDbQc02WHQI
        mT+RmhAcqpX0N6WVWe4A0Rp/Sn08pu4OqV7ch5/g8L6rpaB3WgS81p5eCheliS6Cn6u0F6
        6H/YYEykE05PO391cEuz1Pxf0YYkHag=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-563-f98EyH-0N7e3KeSZhSIiSQ-1; Fri, 30 Oct 2020 07:16:30 -0400
X-MC-Unique: f98EyH-0N7e3KeSZhSIiSQ-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 6B78D425CB;
        Fri, 30 Oct 2020 11:16:28 +0000 (UTC)
Received: from gerbillo.redhat.com (ovpn-114-14.ams2.redhat.com [10.36.114.14])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 8054110027AA;
        Fri, 30 Oct 2020 11:16:26 +0000 (UTC)
From:   Paolo Abeni <pabeni@redhat.com>
To:     netdev@vger.kernel.org
Cc:     Jonathan Corbet <corbet@lwn.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Shuah Khan <shuah@kernel.org>, linux-doc@vger.kernel.org,
        linux-kselftest@vger.kernel.org,
        Marcelo Tosatti <mtosatti@redhat.com>
Subject: [PATCH net-next v2 2/3] net/core: introduce default_rps_mask netns attribute
Date:   Fri, 30 Oct 2020 12:16:02 +0100
Message-Id: <6ecd98ecb73e3d723e8cb9a80700ef9adc8e3428.1604055792.git.pabeni@redhat.com>
In-Reply-To: <cover.1604055792.git.pabeni@redhat.com>
References: <cover.1604055792.git.pabeni@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
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

v1 -> v2:
 - declare rps_default_mask in netdevice.h to avoid a
   sparse warning - Jakub

Signed-off-by: Paolo Abeni <pabeni@redhat.com>
---
 Documentation/admin-guide/sysctl/net.rst |  6 +++
 include/linux/netdevice.h                |  1 +
 net/core/net-sysfs.c                     |  7 +++
 net/core/sysctl_net_core.c               | 58 ++++++++++++++++++++++++
 4 files changed, 72 insertions(+)

diff --git a/Documentation/admin-guide/sysctl/net.rst b/Documentation/admin-guide/sysctl/net.rst
index 57fd6ce68fe0..818cb2030a8b 100644
--- a/Documentation/admin-guide/sysctl/net.rst
+++ b/Documentation/admin-guide/sysctl/net.rst
@@ -211,6 +211,12 @@ rmem_max
 
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
index 964b494b0e8d..2593689648d3 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -200,6 +200,7 @@ struct net_device_stats {
 #include <linux/static_key.h>
 extern struct static_key_false rps_needed;
 extern struct static_key_false rfs_needed;
+extern struct cpumask rps_default_mask;
 #endif
 
 struct neighbour;
diff --git a/net/core/net-sysfs.c b/net/core/net-sysfs.c
index b57426707216..3f3d1d467fe0 100644
--- a/net/core/net-sysfs.c
+++ b/net/core/net-sysfs.c
@@ -983,6 +983,13 @@ static int rx_queue_add_kobject(struct net_device *dev, int index)
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
index d86d8d11cfe4..13451ac88a74 100644
--- a/net/core/sysctl_net_core.c
+++ b/net/core/sysctl_net_core.c
@@ -15,6 +15,7 @@
 #include <linux/vmalloc.h>
 #include <linux/init.h>
 #include <linux/slab.h>
+#include <linux/sched/isolation.h>
 
 #include <net/ip.h>
 #include <net/sock.h>
@@ -46,6 +47,54 @@ int sysctl_devconf_inherit_init_net __read_mostly;
 EXPORT_SYMBOL(sysctl_devconf_inherit_init_net);
 
 #ifdef CONFIG_RPS
+struct cpumask rps_default_mask;
+
+static int rps_default_mask_sysctl(struct ctl_table *table, int write,
+				   void *buffer, size_t *lenp, loff_t *ppos)
+{
+	int len, err = 0;
+
+	rtnl_lock();
+	if (write) {
+		err = cpumask_parse(buffer, &rps_default_mask);
+		if (err)
+			goto done;
+
+		if (!cpumask_empty(&rps_default_mask)) {
+			int hk_flags = HK_FLAG_DOMAIN | HK_FLAG_WQ;
+			cpumask_and(&rps_default_mask, &rps_default_mask,
+				    housekeeping_cpumask(hk_flags));
+			if (cpumask_empty(&rps_default_mask)) {
+				err = -EINVAL;
+				goto done;
+			}
+		}
+	} else {
+		char kbuf[128];
+
+		if (*ppos || !*lenp) {
+			*lenp = 0;
+			goto done;
+		}
+
+		len = min(sizeof(kbuf) - 1, *lenp);
+		len = scnprintf(kbuf, len, "%*pb", cpumask_pr_args(&rps_default_mask));
+		if (!len) {
+			*lenp = 0;
+			goto done;
+		}
+		if (len < *lenp)
+			kbuf[len++] = '\n';
+		memcpy(buffer, kbuf, len);
+		*lenp = len;
+		*ppos += len;
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
@@ -466,6 +515,11 @@ static struct ctl_table net_core_table[] = {
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
@@ -648,6 +702,10 @@ static __net_initdata struct pernet_operations sysctl_core_ops = {
 
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
2.26.2

