Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 116C9454C6C
	for <lists+netdev@lfdr.de>; Wed, 17 Nov 2021 18:47:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239609AbhKQRud (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Nov 2021 12:50:33 -0500
Received: from mail.kernel.org ([198.145.29.99]:47038 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239613AbhKQRua (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 17 Nov 2021 12:50:30 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id DB6C661BE6;
        Wed, 17 Nov 2021 17:47:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637171252;
        bh=XoUcCz4LrVAQpS4BSOrvX1FNe4vwBSutpSeAOiIRoLw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EyozGDQcASQ9hTGX+aSqVckrhzjP+IwtDvy0XM1UxaczFempym+qjFNUnWhoD/u3P
         MontphRJgHbvpeo5EUcEF10+MeDRY59x+5Xp8iRa0BoUbpdSSF+WqiOfWmeq0H4BcR
         CHI6gw2qAaNNf48Z2RIHvvZLijOkKGsXjEItSxREVdznfyzElkLbFH2xLFgOeBjz6t
         R4Qev3yFTbXGsXFANWurDdOr+3kUr/53/CucCfNU3vYUCpXdk4ZkzQ30KCF8RS65MX
         vsQ9M/rC6wAmROD4xFQpU12PSKoIXkGwhhbKl2LbkCygjgGPu+Uzt4v2lukRPKnVnE
         pX21EycOLpShw==
From:   Jakub Kicinski <kuba@kernel.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, eric.dumazet@gmail.com,
        Jakub Kicinski <kuba@kernel.org>
Subject: [RFC net-next 1/2] net: add netdev_refs debug
Date:   Wed, 17 Nov 2021 09:47:22 -0800
Message-Id: <20211117174723.2305681-2-kuba@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211117174723.2305681-1-kuba@kernel.org>
References: <20211117174723.2305681-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Debugging netdev ref leaks is still pretty hard. Eric added
optional use of a normal refcount which is useful for tracking
abuse of existing users.

For new code, however, it'd be great if we could actually track
the refs per-user. Allowing us to detect leaks where they happen.
This patch introduces a netdev_ref type and uses the debug_objects
infra to track refs being lost or misused.

In the future we can extend this structure to also catch those
who fail to release the ref on unregistering notification.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 MAINTAINERS                 |   1 +
 include/linux/netdev_refs.h | 104 ++++++++++++++++++++++++++++++++++++
 lib/Kconfig.debug           |   7 +++
 net/core/dev.c              |   8 +++
 4 files changed, 120 insertions(+)
 create mode 100644 include/linux/netdev_refs.h

diff --git a/MAINTAINERS b/MAINTAINERS
index 4c74516e4353..47fe27175c9f 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -18482,6 +18482,7 @@ F:	include/uapi/linux/pkt_sched.h
 F:	include/uapi/linux/tc_act/
 F:	include/uapi/linux/tc_ematch/
 F:	net/sched/
+F:	tools/testing/selftests/tc-testing/
 
 TC90522 MEDIA DRIVER
 M:	Akihiro Tsukada <tskd08@gmail.com>
diff --git a/include/linux/netdev_refs.h b/include/linux/netdev_refs.h
new file mode 100644
index 000000000000..326772ea0a63
--- /dev/null
+++ b/include/linux/netdev_refs.h
@@ -0,0 +1,104 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
+
+#ifndef _LINUX_NETDEV_REFS_H
+#define _LINUX_NETDEV_REFS_H
+
+#include <linux/debugobjects.h>
+#include <linux/netdevice.h>
+
+/* Explicit netdevice references
+ * struct netdev_ref is a storage for a reference. It's equivalent
+ * to a netdev pointer, but when debug is enabled it performs extra checks.
+ * Most users will want to take a reference with netdev_hold(), access it
+ * via netdev_ref_ptr() and release with netdev_put().
+ */
+
+struct netdev_ref {
+	struct net_device *dev;
+#ifdef CONFIG_DEBUG_OBJECTS_NETDEV_REFS
+	refcount_t cnt;
+#endif
+};
+
+extern const struct debug_obj_descr netdev_ref_debug_descr;
+
+/* Store a raw, unprotected pointer */
+static inline void __netdev_ref_store(struct netdev_ref *ref,
+				      struct net_device *dev)
+{
+	ref->dev = dev;
+
+#ifdef CONFIG_DEBUG_OBJECTS_NETDEV_REFS
+	refcount_set(&ref->cnt, 0);
+	debug_object_init(ref, &netdev_ref_debug_descr);
+#endif
+}
+
+/* Convert a previously stored unprotected pointer to a normal ref */
+static inline void __netdev_hold_stored(struct netdev_ref *ref)
+{
+	dev_hold(ref->dev);
+
+#ifdef CONFIG_DEBUG_OBJECTS_NETDEV_REFS
+	refcount_set(&ref->cnt, 1);
+	debug_object_activate(ref, &netdev_ref_debug_descr);
+#endif
+}
+
+/* Take a reference on a netdev and store it in @ref */
+static inline void netdev_hold(struct netdev_ref *ref, struct net_device *dev)
+{
+	__netdev_ref_store(ref, dev);
+	__netdev_hold_stored(ref);
+}
+
+/* Release a reference on a netdev previously acquired by netdev_hold() */
+static inline void netdev_put(struct netdev_ref *ref)
+{
+	dev_put(ref->dev);
+
+#ifdef CONFIG_DEBUG_OBJECTS_NETDEV_REFS
+	WARN_ON(refcount_read(&ref->cnt) != 1);
+	debug_object_deactivate(ref, &netdev_ref_debug_descr);
+#endif
+}
+
+/* Increase refcount of a reference, reference must be valid -
+ * initialized by netdev_hold() or equivalent set of sub-functions.
+ */
+static inline void netdev_ref_get(struct netdev_ref *ref)
+{
+	dev_hold(ref->dev);
+
+#ifdef CONFIG_DEBUG_OBJECTS_NETDEV_REFS
+	refcount_inc(&ref->cnt);
+#endif
+}
+
+/* Release a reference with unknown number of refs */
+static inline void netdev_ref_put(struct netdev_ref *ref)
+{
+	dev_put(ref->dev);
+
+#ifdef CONFIG_DEBUG_OBJECTS_NETDEV_REFS
+	if (refcount_dec_and_test(&ref->cnt))
+		debug_object_deactivate(ref, &netdev_ref_debug_descr);
+#endif
+}
+
+/* Unprotected access to a pointer stored by __netdev_ref_store() */
+static inline struct net_device *__netdev_ref_ptr(const struct netdev_ref *ref)
+{
+	return ref->dev;
+}
+
+/* Netdev pointer access on a normal ref */
+static inline struct net_device *netdev_ref_ptr(const struct netdev_ref *ref)
+{
+#ifdef CONFIG_DEBUG_OBJECTS_NETDEV_REFS
+	WARN_ON(!refcount_read(&ref->cnt));
+#endif
+	return ref->dev;
+}
+
+#endif
diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
index 9ef7ce18b4f5..e07b1cbb4228 100644
--- a/lib/Kconfig.debug
+++ b/lib/Kconfig.debug
@@ -655,6 +655,13 @@ config DEBUG_OBJECTS_PERCPU_COUNTER
 	  percpu counter routines to track the life time of percpu counter
 	  objects and validate the percpu counter operations.
 
+config DEBUG_OBJECTS_NETDEV_REFS
+	bool "Debug net_device references"
+	depends on DEBUG_OBJECTS
+	help
+	  If you say Y here, additional code will be inserted into the
+	  net_device reference routines to catch incorrect use.
+
 config DEBUG_OBJECTS_ENABLE_DEFAULT
 	int "debug_objects bootup default value (0-1)"
 	range 0 1
diff --git a/net/core/dev.c b/net/core/dev.c
index 92c9258cbf28..c8c9be59de89 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -150,6 +150,7 @@
 #include <linux/pm_runtime.h>
 #include <linux/prandom.h>
 #include <linux/once_lite.h>
+#include <linux/netdev_refs.h>
 
 #include "net-sysfs.h"
 
@@ -158,6 +159,13 @@ static DEFINE_SPINLOCK(ptype_lock);
 struct list_head ptype_base[PTYPE_HASH_SIZE] __read_mostly;
 struct list_head ptype_all __read_mostly;	/* Taps */
 
+const struct debug_obj_descr netdev_ref_debug_descr = {
+	.name		= "netdev_ref",
+};
+#ifdef CONFIG_DEBUG_OBJECTS_NETDEV_REFS
+EXPORT_SYMBOL(netdev_ref_debug_descr);
+#endif
+
 static int netif_rx_internal(struct sk_buff *skb);
 static int call_netdevice_notifiers_info(unsigned long val,
 					 struct netdev_notifier_info *info);
-- 
2.31.1

