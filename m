Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3AC9F639C8D
	for <lists+netdev@lfdr.de>; Sun, 27 Nov 2022 20:18:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229610AbiK0TSt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 27 Nov 2022 14:18:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52018 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229597AbiK0TSq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 27 Nov 2022 14:18:46 -0500
Received: from fritzc.com (mail.fritzc.com [IPv6:2a00:17d8:100::e31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9EAFFDFEF;
        Sun, 27 Nov 2022 11:18:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=fritzc.com;
        s=dkim; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=C/vENORAh9FTRnO+WBV63DAMfi0IBlkeZpSgVUwP8Vc=; b=L9zthdNTNF7Omfx30tZyp7qmOH
        olQ9qIAJCYxrrfaxU2A3PPvTZlVH4Jfxs61Hj0HGSchDrhANRKn/ORZK+IfqR5ZQZu/a0si2HUg7r
        ZEqzFn4azZxHT1MKLuObVHBy44gDLrC7u0b3dqZyVdVQR/OGmutpN3id+xLY7Sf+dm4o=;
Received: from 127.0.0.1
        by fritzc.com with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim latest)
        (envelope-from <christoph.fritz@hexdev.de>)
        id 1ozMvl-000XD6-WF; Sun, 27 Nov 2022 20:03:10 +0100
From:   Christoph Fritz <christoph.fritz@hexdev.de>
To:     Oliver Hartkopp <socketcan@hartkopp.net>,
        Pavel Pisa <pisa@cmp.felk.cvut.cz>,
        Richard Weinberger <richard@nod.at>,
        Andreas Lauser <andreas.lauser@mbition.io>,
        Wolfgang Grandegger <wg@grandegger.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>
Cc:     linux-can@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] [RFC] can: Add LIN proto skeleton
Date:   Sun, 27 Nov 2022 20:02:44 +0100
Message-Id: <20221127190244.888414-3-christoph.fritz@hexdev.de>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20221127190244.888414-1-christoph.fritz@hexdev.de>
References: <20221127190244.888414-1-christoph.fritz@hexdev.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam_score: -1.0
X-Spam_bar: -
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,SPF_HELO_PASS,SPF_PASS autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Richard Weinberger <richard@nod.at>

Signed-off-by: Richard Weinberger <richard@nod.at>
---
 include/uapi/linux/can.h     |   7 +-
 include/uapi/linux/can/lin.h |  15 +++
 net/can/Kconfig              |   5 +
 net/can/Makefile             |   3 +
 net/can/lin.c                | 207 +++++++++++++++++++++++++++++++++++
 5 files changed, 236 insertions(+), 1 deletion(-)
 create mode 100644 include/uapi/linux/can/lin.h
 create mode 100644 net/can/lin.c

diff --git a/include/uapi/linux/can.h b/include/uapi/linux/can.h
index 8596f9b23c68..73526805dc5f 100644
--- a/include/uapi/linux/can.h
+++ b/include/uapi/linux/can.h
@@ -178,7 +178,8 @@ struct canfd_frame {
 #define CAN_MCNET	5 /* Bosch MCNet */
 #define CAN_ISOTP	6 /* ISO 15765-2 Transport Protocol */
 #define CAN_J1939	7 /* SAE J1939 */
-#define CAN_NPROTO	8
+#define CAN_LIN		8 /* LIN Bus */
+#define CAN_NPROTO	9
 
 #define SOL_CAN_BASE 100
 
@@ -212,6 +213,10 @@ struct sockaddr_can {
 			__u8 addr;
 		} j1939;
 
+		struct {
+			__u8 addr; //Dummy for now
+		} lin;
+
 		/* reserved for future CAN protocols address information */
 	} can_addr;
 };
diff --git a/include/uapi/linux/can/lin.h b/include/uapi/linux/can/lin.h
new file mode 100644
index 000000000000..7e9f44992b7d
--- /dev/null
+++ b/include/uapi/linux/can/lin.h
@@ -0,0 +1,15 @@
+/* SPDX-License-Identifier: (GPL-2.0-only WITH Linux-syscall-note) */
+/*
+ * linux/can/lin.h
+ * TODO
+ */
+
+#ifndef _UAPI_CAN_LIN_H
+#define _UAPI_CAN_LIN_H
+
+#include <linux/types.h>
+#include <linux/can.h>
+
+#define SOL_CAN_LIN (SOL_CAN_BASE + CAN_LIN)
+
+#endif /* !_UAPI_CAN_LIN_H */
diff --git a/net/can/Kconfig b/net/can/Kconfig
index cb56be8e3862..d05e3fa813e2 100644
--- a/net/can/Kconfig
+++ b/net/can/Kconfig
@@ -70,4 +70,9 @@ config CAN_ISOTP
 	  If you want to perform automotive vehicle diagnostic services (UDS),
 	  say 'y'.
 
+config CAN_LIN
+	tristate "Support for LIN bus"
+	help
+	  TODO
+
 endif
diff --git a/net/can/Makefile b/net/can/Makefile
index 58f2c31c1ef3..5db51a56a78a 100644
--- a/net/can/Makefile
+++ b/net/can/Makefile
@@ -20,3 +20,6 @@ obj-$(CONFIG_CAN_J1939)	+= j1939/
 
 obj-$(CONFIG_CAN_ISOTP)	+= can-isotp.o
 can-isotp-y		:= isotp.o
+
+obj-$(CONFIG_CAN_LIN)	+= can-lin.o
+can-lin-y		:= lin.o
diff --git a/net/can/lin.c b/net/can/lin.c
new file mode 100644
index 000000000000..f8c8217efc8c
--- /dev/null
+++ b/net/can/lin.c
@@ -0,0 +1,207 @@
+// SPDX-License-Identifier: (GPL-2.0 OR BSD-3-Clause)
+
+//TODO copyright
+
+#include <linux/module.h>
+#include <linux/init.h>
+#include <linux/interrupt.h>
+#include <linux/spinlock.h>
+#include <linux/hrtimer.h>
+#include <linux/wait.h>
+#include <linux/uio.h>
+#include <linux/net.h>
+#include <linux/netdevice.h>
+#include <linux/socket.h>
+#include <linux/if_arp.h>
+#include <linux/skbuff.h>
+#include <linux/can.h>
+#include <linux/can/core.h>
+#include <linux/can/skb.h>
+#include <linux/can/lin.h>
+#include <linux/slab.h>
+#include <net/sock.h>
+#include <net/net_namespace.h>
+
+MODULE_DESCRIPTION("PF_CAN LIN protocol");
+MODULE_LICENSE("GPLv2");
+MODULE_ALIAS("can-proto-8");
+
+struct lin_sock {
+	struct sock sk;
+};
+
+static inline struct lin_sock *lin_sk(const struct sock *sk)
+{
+	return (struct lin_sock *)sk;
+}
+
+static int lin_release(struct socket *sock)
+{
+	struct sock *sk = sock->sk;
+	struct lin_sock *so;
+	struct net *net;
+
+	if (!sk)
+		return 0;
+
+	so = lin_sk(sk);
+	net = sock_net(sk);
+
+	// Nothing do to so far
+
+	sock_orphan(sk);
+	sock->sk = NULL;
+
+	release_sock(sk);
+	sock_put(sk);
+
+	return 0;
+}
+
+static int lin_bind(struct socket *sock, struct sockaddr *uaddr, int len)
+{
+	struct sockaddr_can *addr = (struct sockaddr_can *)uaddr;
+	struct sock *sk = sock->sk;
+	struct net *net = sock_net(sk);
+	struct net_device *dev;
+	int err = 0;
+
+	//TODO
+	dev = dev_get_by_index(net, addr->can_ifindex);
+	if (!dev) {
+		err = -ENODEV;
+		goto out;
+	}
+	if (dev->type != ARPHRD_CAN) {
+		dev_put(dev);
+		err = -ENODEV;
+		goto out;
+	}
+
+out:
+	return err;
+}
+
+static int lin_setsockopt_locked(struct socket *sock, int level, int optname,
+			    sockptr_t optval, unsigned int optlen)
+{
+	struct sock *sk = sock->sk;
+	struct lin_sock *so = lin_sk(sk);
+	int ret = 0;
+
+	(void)so;
+
+	switch (optname) {
+	// Nothing to do so far
+	default:
+		ret = -ENOPROTOOPT;
+	}
+
+	return ret;
+}
+
+static int lin_setsockopt(struct socket *sock, int level, int optname,
+			    sockptr_t optval, unsigned int optlen)
+
+{
+	struct sock *sk = sock->sk;
+	int ret;
+
+	if (level != SOL_CAN_LIN)
+		return -EINVAL;
+
+	lock_sock(sk);
+	ret = lin_setsockopt_locked(sock, level, optname, optval, optlen);
+	release_sock(sk);
+	return ret;
+}
+
+static int lin_getsockopt(struct socket *sock, int level, int optname,
+			    char __user *optval, int __user *optlen)
+{
+	struct sock *sk = sock->sk;
+	struct lin_sock *so = lin_sk(sk);
+	int len;
+	void *val;
+
+	(void)so;
+
+	if (level != SOL_CAN_LIN)
+		return -EINVAL;
+	if (get_user(len, optlen))
+		return -EFAULT;
+	if (len < 0)
+		return -EINVAL;
+
+	switch (optname) {
+	//Nothing to do so far.
+	default:
+		return -ENOPROTOOPT;
+	}
+
+	if (put_user(len, optlen))
+		return -EFAULT;
+	if (copy_to_user(optval, val, len))
+		return -EFAULT;
+	return 0;
+}
+
+static int lin_init(struct sock *sk)
+{
+	struct lin_sock *so = lin_sk(sk);
+
+	(void)so;
+	// Nothing to do so far
+
+	return 0;
+}
+
+static const struct proto_ops lin_ops = {
+	.family = PF_CAN,
+	.release = lin_release,
+	.bind = lin_bind,
+	.connect = sock_no_connect,
+	.socketpair = sock_no_socketpair,
+	.accept = sock_no_accept,
+	.getname = sock_no_getname,
+	.poll = datagram_poll,
+	.ioctl = sock_no_ioctl,
+	.gettstamp = sock_gettstamp,
+	.listen = sock_no_listen,
+	.shutdown = sock_no_shutdown,
+	.setsockopt = lin_setsockopt,
+	.getsockopt = lin_getsockopt,
+	.sendmsg = sock_no_sendmsg,
+	.recvmsg = sock_no_recvmsg,
+	.mmap = sock_no_mmap,
+	.sendpage = sock_no_sendpage,
+};
+
+static struct proto lin_proto __read_mostly = {
+	.name = "CAN_LIN",
+	.owner = THIS_MODULE,
+	.obj_size = sizeof(struct lin_sock),
+	.init = lin_init,
+};
+
+static const struct can_proto lin_can_proto = {
+	.type = SOCK_DGRAM,
+	.protocol = CAN_LIN,
+	.ops = &lin_ops,
+	.prot = &lin_proto,
+};
+
+static __init int lin_module_init(void)
+{
+	pr_info("can: lin protocol\n");
+
+	return can_proto_register(&lin_can_proto);
+}
+
+static __exit void lin_module_exit(void)
+{
+	can_proto_unregister(&lin_can_proto);
+}
+
+module_init(lin_module_init);
+module_exit(lin_module_exit);
-- 
2.30.2

