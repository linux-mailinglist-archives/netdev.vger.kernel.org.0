Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9CE0C444917
	for <lists+netdev@lfdr.de>; Wed,  3 Nov 2021 20:38:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231335AbhKCTlQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Nov 2021 15:41:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44788 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229918AbhKCTlI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Nov 2021 15:41:08 -0400
Received: from todd.t-8ch.de (todd.t-8ch.de [IPv6:2a01:4f8:c010:41de::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 51BA6C061714;
        Wed,  3 Nov 2021 12:38:31 -0700 (PDT)
From:   =?UTF-8?q?Thomas=20Wei=C3=9Fschuh?= <linux@weissschuh.net>
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=weissschuh.net;
        s=mail; t=1635968309;
        bh=1lvpZBMnAiuoh4ysYuD5bGBkS7W06lh/Tvn7af7xom4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=V0vse0iZPtrez5azQFc4VRg+v50Qjlu533fDW9EO24pn6RadYpzudPv2eBVRKdhBv
         Ldmwe1uopJf2M5qCpN5zOFHyqBvRTBZIC06gXi0mrxvak4Nsq+tf5C6DqwETqbFWL9
         0+JoW1z7UT/7goMsweC24PQaCICTYUDx7BHpP5IA=
To:     v9fs-developer@lists.sourceforge.net, netdev@vger.kernel.org
Cc:     =?UTF-8?q?Thomas=20Wei=C3=9Fschuh?= <linux@weissschuh.net>,
        Dominique Martinet <asmadeus@codewreck.org>,
        Eric Van Hensbergen <ericvh@gmail.com>,
        Latchesar Ionkov <lucho@ionkov.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Stefano Stabellini <stefano@aporeto.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 2/4] 9p/trans_fd: split into dedicated module
Date:   Wed,  3 Nov 2021 20:38:21 +0100
Message-Id: <20211103193823.111007-3-linux@weissschuh.net>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211103193823.111007-1-linux@weissschuh.net>
References: <20211103193823.111007-1-linux@weissschuh.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This allows these transports only to be used when needed.

Signed-off-by: Thomas Weißschuh <linux@weissschuh.net>
---
 include/net/9p/9p.h |  2 --
 net/9p/Kconfig      |  7 +++++++
 net/9p/Makefile     |  5 ++++-
 net/9p/mod.c        |  2 --
 net/9p/trans_fd.c   | 14 ++++++++++++--
 5 files changed, 23 insertions(+), 7 deletions(-)

diff --git a/include/net/9p/9p.h b/include/net/9p/9p.h
index 03614de86942..f420f8cb378d 100644
--- a/include/net/9p/9p.h
+++ b/include/net/9p/9p.h
@@ -553,6 +553,4 @@ struct p9_fcall {
 int p9_errstr2errno(char *errstr, int len);
 
 int p9_error_init(void);
-int p9_trans_fd_init(void);
-void p9_trans_fd_exit(void);
 #endif /* NET_9P_H */
diff --git a/net/9p/Kconfig b/net/9p/Kconfig
index 64468c49791f..af601129f1bb 100644
--- a/net/9p/Kconfig
+++ b/net/9p/Kconfig
@@ -15,6 +15,13 @@ menuconfig NET_9P
 
 if NET_9P
 
+config NET_9P_FD
+	depends on VIRTIO
+	tristate "9P FD Transport"
+	help
+	  This builds support for transports over TCP, Unix sockets and
+	  filedescriptors.
+
 config NET_9P_VIRTIO
 	depends on VIRTIO
 	tristate "9P Virtio Transport"
diff --git a/net/9p/Makefile b/net/9p/Makefile
index aa0a5641e5d0..1df9b344c30b 100644
--- a/net/9p/Makefile
+++ b/net/9p/Makefile
@@ -1,5 +1,6 @@
 # SPDX-License-Identifier: GPL-2.0
 obj-$(CONFIG_NET_9P) := 9pnet.o
+obj-$(CONFIG_NET_9P_FD) += 9pnet_fd.o
 obj-$(CONFIG_NET_9P_XEN) += 9pnet_xen.o
 obj-$(CONFIG_NET_9P_VIRTIO) += 9pnet_virtio.o
 obj-$(CONFIG_NET_9P_RDMA) += 9pnet_rdma.o
@@ -9,9 +10,11 @@ obj-$(CONFIG_NET_9P_RDMA) += 9pnet_rdma.o
 	client.o \
 	error.o \
 	protocol.o \
-	trans_fd.o \
 	trans_common.o \
 
+9pnet_fd-objs := \
+	trans_fd.o \
+
 9pnet_virtio-objs := \
 	trans_virtio.o \
 
diff --git a/net/9p/mod.c b/net/9p/mod.c
index c95416c1d1a2..8f1d067b272e 100644
--- a/net/9p/mod.c
+++ b/net/9p/mod.c
@@ -182,7 +182,6 @@ static int __init init_p9(void)
 
 	p9_error_init();
 	pr_info("Installing 9P2000 support\n");
-	p9_trans_fd_init();
 
 	return ret;
 }
@@ -196,7 +195,6 @@ static void __exit exit_p9(void)
 {
 	pr_info("Unloading 9P2000 support\n");
 
-	p9_trans_fd_exit();
 	p9_client_exit();
 }
 
diff --git a/net/9p/trans_fd.c b/net/9p/trans_fd.c
index 007bbcc68010..e3f4a7a5c845 100644
--- a/net/9p/trans_fd.c
+++ b/net/9p/trans_fd.c
@@ -1092,6 +1092,7 @@ static struct p9_trans_module p9_tcp_trans = {
 	.show_options = p9_fd_show_options,
 	.owner = THIS_MODULE,
 };
+MODULE_ALIAS_9P("tcp");
 
 static struct p9_trans_module p9_unix_trans = {
 	.name = "unix",
@@ -1105,6 +1106,7 @@ static struct p9_trans_module p9_unix_trans = {
 	.show_options = p9_fd_show_options,
 	.owner = THIS_MODULE,
 };
+MODULE_ALIAS_9P("unix");
 
 static struct p9_trans_module p9_fd_trans = {
 	.name = "fd",
@@ -1118,6 +1120,7 @@ static struct p9_trans_module p9_fd_trans = {
 	.show_options = p9_fd_show_options,
 	.owner = THIS_MODULE,
 };
+MODULE_ALIAS_9P("fd");
 
 /**
  * p9_poll_workfn - poll worker thread
@@ -1151,7 +1154,7 @@ static void p9_poll_workfn(struct work_struct *work)
 	p9_debug(P9_DEBUG_TRANS, "finish\n");
 }
 
-int p9_trans_fd_init(void)
+static int __init p9_trans_fd_init(void)
 {
 	v9fs_register_trans(&p9_tcp_trans);
 	v9fs_register_trans(&p9_unix_trans);
@@ -1160,10 +1163,17 @@ int p9_trans_fd_init(void)
 	return 0;
 }
 
-void p9_trans_fd_exit(void)
+static void __exit p9_trans_fd_exit(void)
 {
 	flush_work(&p9_poll_work);
 	v9fs_unregister_trans(&p9_tcp_trans);
 	v9fs_unregister_trans(&p9_unix_trans);
 	v9fs_unregister_trans(&p9_fd_trans);
 }
+
+module_init(p9_trans_fd_init);
+module_exit(p9_trans_fd_exit);
+
+MODULE_AUTHOR("Eric Van Hensbergen <ericvh@gmail.com>");
+MODULE_DESCRIPTION("Filedescriptor Transport for 9P");
+MODULE_LICENSE("GPL");
-- 
2.33.1

