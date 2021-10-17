Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 211A443096E
	for <lists+netdev@lfdr.de>; Sun, 17 Oct 2021 15:46:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343751AbhJQNsh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 17 Oct 2021 09:48:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57228 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236636AbhJQNsd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 17 Oct 2021 09:48:33 -0400
Received: from todd.t-8ch.de (todd.t-8ch.de [IPv6:2a01:4f8:c010:41de::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B2C67C061765;
        Sun, 17 Oct 2021 06:46:21 -0700 (PDT)
From:   =?UTF-8?q?Thomas=20Wei=C3=9Fschuh?= <linux@weissschuh.net>
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=weissschuh.net;
        s=mail; t=1634478378;
        bh=wR87lV2AvLHU2BiA+MBy+H4caEohoJSe1P0T82Xg4Dg=;
        h=From:To:Cc:Subject:Date:From;
        b=lNKuPHRHKGNVTavzu/k74VYow1C1bT2cY2gEkAt0HZv3W6RPzPdnuK8ws1GDpB86Q
         qIn9qku6kTVoe8lEhKpMz6eCnSnSeLksV+uDEoeYltu0v9xl2uloK4ggqukd930OH+
         tzdOH/klKNJ9yF1Talc+bBsvpxc7ukZmqw+Ui6HQ=
To:     Eric Van Hensbergen <ericvh@gmail.com>,
        Latchesar Ionkov <lucho@ionkov.net>,
        Dominique Martinet <asmadeus@codewreck.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        v9fs-developer@lists.sourceforge.net, netdev@vger.kernel.org
Cc:     =?UTF-8?q?Thomas=20Wei=C3=9Fschuh?= <linux@weissschuh.net>,
        linux-kernel@vger.kernel.org
Subject: [PATCH] net/9p: autoload transport modules
Date:   Sun, 17 Oct 2021 15:46:11 +0200
Message-Id: <20211017134611.4330-1-linux@weissschuh.net>
X-Mailer: git-send-email 2.33.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Automatically load transport modules based on the trans= parameter
passed to mount.
The removes the requirement for the user to know which module to use.

Signed-off-by: Thomas Weißschuh <linux@weissschuh.net>
---
 include/net/9p/transport.h |  6 ++++++
 net/9p/mod.c               | 30 ++++++++++++++++++++++++------
 net/9p/trans_rdma.c        |  1 +
 net/9p/trans_virtio.c      |  1 +
 net/9p/trans_xen.c         |  1 +
 5 files changed, 33 insertions(+), 6 deletions(-)

diff --git a/include/net/9p/transport.h b/include/net/9p/transport.h
index 3eb4261b2958..581555d88cba 100644
--- a/include/net/9p/transport.h
+++ b/include/net/9p/transport.h
@@ -11,6 +11,8 @@
 #ifndef NET_9P_TRANSPORT_H
 #define NET_9P_TRANSPORT_H
 
+#include <linux/module.h>
+
 #define P9_DEF_MIN_RESVPORT	(665U)
 #define P9_DEF_MAX_RESVPORT	(1023U)
 
@@ -55,4 +57,8 @@ void v9fs_unregister_trans(struct p9_trans_module *m);
 struct p9_trans_module *v9fs_get_trans_by_name(char *s);
 struct p9_trans_module *v9fs_get_default_trans(void);
 void v9fs_put_trans(struct p9_trans_module *m);
+
+#define MODULE_ALIAS_9P(transport) \
+	MODULE_ALIAS("9p-" transport)
+
 #endif /* NET_9P_TRANSPORT_H */
diff --git a/net/9p/mod.c b/net/9p/mod.c
index 5126566850bd..aa38b8b0e0f6 100644
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
+static struct p9_trans_module *_p9_get_trans_by_name(char *s)
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
+struct p9_trans_module *v9fs_get_trans_by_name(char *s)
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

base-commit: fac3cb82a54a4b7c49c932f96ef196cf5774344c
-- 
2.33.1

