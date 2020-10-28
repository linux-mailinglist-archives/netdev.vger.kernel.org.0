Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1CA4229D402
	for <lists+netdev@lfdr.de>; Wed, 28 Oct 2020 22:48:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727799AbgJ1VsX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Oct 2020 17:48:23 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:48123 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727739AbgJ1VsP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Oct 2020 17:48:15 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1603921693;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=PEE231hPUo3ICeopUFgljqFJfbF/lI2sunK5lJ1xv+0=;
        b=FuMmOga7NqRpBg2Ux+usq7Wa/9LwdBoRt7EOITMS/qzbEI5jYNRjE96+vyeuCSzDVXCXjE
        zMTW8Zg9hg7OUkUn3uBEnHiO1ZNxXuGY7DE5FNnzd2KZUD1RWpoaLrbrlxq829nBNcS6bx
        9+qqmFQUjf2Vo9wM0Sb/g0T/3CJaahU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-248-1r-j0238PgmTTE84SwwMUg-1; Wed, 28 Oct 2020 13:46:57 -0400
X-MC-Unique: 1r-j0238PgmTTE84SwwMUg-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 903991020913;
        Wed, 28 Oct 2020 17:46:37 +0000 (UTC)
Received: from gerbillo.redhat.com (ovpn-115-68.ams2.redhat.com [10.36.115.68])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 9E85F6198D;
        Wed, 28 Oct 2020 17:46:35 +0000 (UTC)
From:   Paolo Abeni <pabeni@redhat.com>
To:     netdev@vger.kernel.org
Cc:     Jonathan Corbet <corbet@lwn.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Shuah Khan <shuah@kernel.org>, linux-doc@vger.kernel.org,
        linux-kselftest@vger.kernel.org,
        Marcelo Tosatti <mtosatti@redhat.com>
Subject: [PATCH net-next 2/3] net/core: introduce default_rps_mask netns attribute
Date:   Wed, 28 Oct 2020 18:46:02 +0100
Message-Id: <9e86568c264696dbe0fd44b2a8662bd233e2c3e8.1603906564.git.pabeni@redhat.com>
In-Reply-To: <cover.1603906564.git.pabeni@redhat.com>
References: <cover.1603906564.git.pabeni@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
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
 Documentation/admin-guide/sysctl/net.rst |  6 +++
 net/core/net-sysfs.c                     |  9 ++++
 net/core/sysctl_net_core.c               | 58 ++++++++++++++++++++++++
 3 files changed, 73 insertions(+)

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
diff --git a/net/core/net-sysfs.c b/net/core/net-sysfs.c
index b57426707216..991b668f8a12 100644
--- a/net/core/net-sysfs.c
+++ b/net/core/net-sysfs.c
@@ -715,6 +715,8 @@ static const struct sysfs_ops rx_queue_sysfs_ops = {
 };
 
 #ifdef CONFIG_RPS
+extern struct cpumask rps_default_mask;
+
 static ssize_t show_rps_map(struct netdev_rx_queue *queue, char *buf)
 {
 	struct rps_map *map;
@@ -983,6 +985,13 @@ static int rx_queue_add_kobject(struct net_device *dev, int index)
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

