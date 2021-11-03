Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1C76A44490F
	for <lists+netdev@lfdr.de>; Wed,  3 Nov 2021 20:38:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231265AbhKCTlJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Nov 2021 15:41:09 -0400
Received: from todd.t-8ch.de ([159.69.126.157]:55531 "EHLO todd.t-8ch.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230441AbhKCTlH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 3 Nov 2021 15:41:07 -0400
From:   =?UTF-8?q?Thomas=20Wei=C3=9Fschuh?= <linux@weissschuh.net>
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=weissschuh.net;
        s=mail; t=1635968309;
        bh=R/4AG9vLH5gheMs6GHXMBsH1IwvhwsPI0SJ8kMELE9U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sA+3LazFHbb2drW5DJ9iQnl4eWVgM0XsJF3P5woPPasdkd9cZYA1LHi8WQJ7L0Zog
         S3DVJ2BXAH4hL3NYr1M10MgAcdnkQs11cuq6iXAOUxwjySWJbS7M+Xi+JLALEPwwME
         z6xfjt9R4MotGtI/jR1aI4B4VWxSz4nfyBG/0Q1I=
To:     v9fs-developer@lists.sourceforge.net, netdev@vger.kernel.org
Cc:     =?UTF-8?q?Thomas=20Wei=C3=9Fschuh?= <linux@weissschuh.net>,
        Dominique Martinet <asmadeus@codewreck.org>,
        Eric Van Hensbergen <ericvh@gmail.com>,
        Latchesar Ionkov <lucho@ionkov.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Stefano Stabellini <stefano@aporeto.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 1/4] net/9p: autoload transport modules
Date:   Wed,  3 Nov 2021 20:38:20 +0100
Message-Id: <20211103193823.111007-2-linux@weissschuh.net>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211103193823.111007-1-linux@weissschuh.net>
References: <20211103193823.111007-1-linux@weissschuh.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Automatically load transport modules based on the trans= parameter
passed to mount.
This removes the requirement for the user to know which module to use.

Signed-off-by: Thomas Weißschuh <linux@weissschuh.net>
---
 include/net/9p/transport.h |  8 +++++++-
 net/9p/mod.c               | 30 ++++++++++++++++++++++++------
 net/9p/trans_rdma.c        |  1 +
 net/9p/trans_virtio.c      |  1 +
 net/9p/trans_xen.c         |  1 +
 5 files changed, 34 insertions(+), 7 deletions(-)

diff --git a/include/net/9p/transport.h b/include/net/9p/transport.h
index 3eb4261b2958..b9a009534f99 100644
--- a/include/net/9p/transport.h
+++ b/include/net/9p/transport.h
@@ -11,6 +11,8 @@
 #ifndef NET_9P_TRANSPORT_H
 #define NET_9P_TRANSPORT_H
 
+#include <linux/module.h>
+
 #define P9_DEF_MIN_RESVPORT	(665U)
 #define P9_DEF_MAX_RESVPORT	(1023U)
 
@@ -52,7 +54,11 @@ struct p9_trans_module {
 
 void v9fs_register_trans(struct p9_trans_module *m);
 void v9fs_unregister_trans(struct p9_trans_module *m);
-struct p9_trans_module *v9fs_get_trans_by_name(char *s);
+struct p9_trans_module *v9fs_get_trans_by_name(const char *s);
 struct p9_trans_module *v9fs_get_default_trans(void);
 void v9fs_put_trans(struct p9_trans_module *m);
+
+#define MODULE_ALIAS_9P(transport) \
+	MODULE_ALIAS("9p-" transport)
+
 #endif /* NET_9P_TRANSPORT_H */
diff --git a/net/9p/mod.c b/net/9p/mod.c
index 5126566850bd..c95416c1d1a2 100644
--- a/net/9p/mod.c
+++ b/net/9p/mod.c
@@ -12,6 +12,7 @@
 #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
 
 #include <linux/module.h>
+#include <linux/kmod.h>
 #include <linux/errno.h>
 #include <linux/sched.h>
 #include <linux/moduleparam.h>
@@ -87,12 +88,7 @@ void v9fs_unregister_trans(struct p9_trans_module *m)
 }
 EXPORT_SYMBOL(v9fs_unregister_trans);
 
-/**
- * v9fs_get_trans_by_name - get transport with the matching name
- * @s: string identifying transport
- *
- */
-struct p9_trans_module *v9fs_get_trans_by_name(char *s)
+static struct p9_trans_module *_p9_get_trans_by_name(const char *s)
 {
 	struct p9_trans_module *t, *found = NULL;
 
@@ -106,6 +102,28 @@ struct p9_trans_module *v9fs_get_trans_by_name(char *s)
 		}
 
 	spin_unlock(&v9fs_trans_lock);
+
+	return found;
+}
+
+/**
+ * v9fs_get_trans_by_name - get transport with the matching name
+ * @s: string identifying transport
+ *
+ */
+struct p9_trans_module *v9fs_get_trans_by_name(const char *s)
+{
+	struct p9_trans_module *found = NULL;
+
+	found = _p9_get_trans_by_name(s);
+
+#ifdef CONFIG_MODULES
+	if (!found) {
+		request_module("9p-%s", s);
+		found = _p9_get_trans_by_name(s);
+	}
+#endif
+
 	return found;
 }
 EXPORT_SYMBOL(v9fs_get_trans_by_name);
diff --git a/net/9p/trans_rdma.c b/net/9p/trans_rdma.c
index af0a8a6cd3fd..480fd27760d7 100644
--- a/net/9p/trans_rdma.c
+++ b/net/9p/trans_rdma.c
@@ -767,6 +767,7 @@ static void __exit p9_trans_rdma_exit(void)
 
 module_init(p9_trans_rdma_init);
 module_exit(p9_trans_rdma_exit);
+MODULE_ALIAS_9P("rdma");
 
 MODULE_AUTHOR("Tom Tucker <tom@opengridcomputing.com>");
 MODULE_DESCRIPTION("RDMA Transport for 9P");
diff --git a/net/9p/trans_virtio.c b/net/9p/trans_virtio.c
index 490a4c900339..bd5a89c4960d 100644
--- a/net/9p/trans_virtio.c
+++ b/net/9p/trans_virtio.c
@@ -794,6 +794,7 @@ static void __exit p9_virtio_cleanup(void)
 
 module_init(p9_virtio_init);
 module_exit(p9_virtio_cleanup);
+MODULE_ALIAS_9P("virtio");
 
 MODULE_DEVICE_TABLE(virtio, id_table);
 MODULE_AUTHOR("Eric Van Hensbergen <ericvh@gmail.com>");
diff --git a/net/9p/trans_xen.c b/net/9p/trans_xen.c
index 3ec1a51a6944..e264dcee019a 100644
--- a/net/9p/trans_xen.c
+++ b/net/9p/trans_xen.c
@@ -552,6 +552,7 @@ static int p9_trans_xen_init(void)
 	return rc;
 }
 module_init(p9_trans_xen_init);
+MODULE_ALIAS_9P("xen");
 
 static void p9_trans_xen_exit(void)
 {
-- 
2.33.1

