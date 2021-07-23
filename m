Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 74E843D36AD
	for <lists+netdev@lfdr.de>; Fri, 23 Jul 2021 10:30:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234519AbhGWHtR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Jul 2021 03:49:17 -0400
Received: from pi.codeconstruct.com.au ([203.29.241.158]:33976 "EHLO
        codeconstruct.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234355AbhGWHtO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Jul 2021 03:49:14 -0400
Received: by codeconstruct.com.au (Postfix, from userid 10000)
        id 9392C2144E; Fri, 23 Jul 2021 16:29:46 +0800 (AWST)
From:   Jeremy Kerr <jk@codeconstruct.com.au>
To:     netdev@vger.kernel.org
Cc:     Matt Johnston <matt@codeconstruct.com.au>,
        Andrew Jeffery <andrew@aj.id.au>
Subject: [PATCH net-next v3 02/16] mctp: Add base socket/protocol definitions
Date:   Fri, 23 Jul 2021 16:29:18 +0800
Message-Id: <20210723082932.3570396-3-jk@codeconstruct.com.au>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210723082932.3570396-1-jk@codeconstruct.com.au>
References: <20210723082932.3570396-1-jk@codeconstruct.com.au>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add an empty socket implementation, plus initialisation/destruction
handlers.

Signed-off-by: Jeremy Kerr <jk@codeconstruct.com.au>

---
v2:
 - Controller -> component
---
 net/mctp/af_mctp.c | 169 +++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 169 insertions(+)

diff --git a/net/mctp/af_mctp.c b/net/mctp/af_mctp.c
index 1b63b753057b..b3aeca6486e3 100644
--- a/net/mctp/af_mctp.c
+++ b/net/mctp/af_mctp.c
@@ -5,3 +5,172 @@
  * Copyright (c) 2021 Code Construct
  * Copyright (c) 2021 Google
  */
+
+#include <linux/net.h>
+#include <linux/mctp.h>
+#include <linux/module.h>
+#include <linux/socket.h>
+
+#include <net/sock.h>
+
+struct mctp_sock {
+	struct sock	sk;
+};
+
+static int mctp_release(struct socket *sock)
+{
+	struct sock *sk = sock->sk;
+
+	if (sk) {
+		sock->sk = NULL;
+		sk->sk_prot->close(sk, 0);
+	}
+
+	return 0;
+}
+
+static int mctp_bind(struct socket *sock, struct sockaddr *addr, int addrlen)
+{
+	return 0;
+}
+
+static int mctp_sendmsg(struct socket *sock, struct msghdr *msg, size_t len)
+{
+	return 0;
+}
+
+static int mctp_recvmsg(struct socket *sock, struct msghdr *msg, size_t len,
+			int flags)
+{
+	return 0;
+}
+
+static int mctp_setsockopt(struct socket *sock, int level, int optname,
+			   sockptr_t optval, unsigned int optlen)
+{
+	return -EINVAL;
+}
+
+static int mctp_getsockopt(struct socket *sock, int level, int optname,
+			   char __user *optval, int __user *optlen)
+{
+	return -EINVAL;
+}
+
+static const struct proto_ops mctp_dgram_ops = {
+	.family		= PF_MCTP,
+	.release	= mctp_release,
+	.bind		= mctp_bind,
+	.connect	= sock_no_connect,
+	.socketpair	= sock_no_socketpair,
+	.accept		= sock_no_accept,
+	.getname	= sock_no_getname,
+	.poll		= datagram_poll,
+	.ioctl		= sock_no_ioctl,
+	.gettstamp	= sock_gettstamp,
+	.listen		= sock_no_listen,
+	.shutdown	= sock_no_shutdown,
+	.setsockopt	= mctp_setsockopt,
+	.getsockopt	= mctp_getsockopt,
+	.sendmsg	= mctp_sendmsg,
+	.recvmsg	= mctp_recvmsg,
+	.mmap		= sock_no_mmap,
+	.sendpage	= sock_no_sendpage,
+};
+
+static void mctp_sk_close(struct sock *sk, long timeout)
+{
+	sk_common_release(sk);
+}
+
+static struct proto mctp_proto = {
+	.name		= "MCTP",
+	.owner		= THIS_MODULE,
+	.obj_size	= sizeof(struct mctp_sock),
+	.close		= mctp_sk_close,
+};
+
+static int mctp_pf_create(struct net *net, struct socket *sock,
+			  int protocol, int kern)
+{
+	const struct proto_ops *ops;
+	struct proto *proto;
+	struct sock *sk;
+	int rc;
+
+	if (protocol)
+		return -EPROTONOSUPPORT;
+
+	/* only datagram sockets are supported */
+	if (sock->type != SOCK_DGRAM)
+		return -ESOCKTNOSUPPORT;
+
+	proto = &mctp_proto;
+	ops = &mctp_dgram_ops;
+
+	sock->state = SS_UNCONNECTED;
+	sock->ops = ops;
+
+	sk = sk_alloc(net, PF_MCTP, GFP_KERNEL, proto, kern);
+	if (!sk)
+		return -ENOMEM;
+
+	sock_init_data(sock, sk);
+
+	rc = 0;
+	if (sk->sk_prot->init)
+		rc = sk->sk_prot->init(sk);
+
+	if (rc)
+		goto err_sk_put;
+
+	return 0;
+
+err_sk_put:
+	sock_orphan(sk);
+	sock_put(sk);
+	return rc;
+}
+
+static struct net_proto_family mctp_pf = {
+	.family = PF_MCTP,
+	.create = mctp_pf_create,
+	.owner = THIS_MODULE,
+};
+
+static __init int mctp_init(void)
+{
+	int rc;
+
+	pr_info("mctp: management component transport protocol core\n");
+
+	rc = sock_register(&mctp_pf);
+	if (rc)
+		return rc;
+
+	rc = proto_register(&mctp_proto, 0);
+	if (rc)
+		goto err_unreg_sock;
+
+	return 0;
+
+err_unreg_sock:
+	sock_unregister(PF_MCTP);
+
+	return rc;
+}
+
+static __exit void mctp_exit(void)
+{
+	proto_unregister(&mctp_proto);
+	sock_unregister(PF_MCTP);
+}
+
+module_init(mctp_init);
+module_exit(mctp_exit);
+
+MODULE_DESCRIPTION("MCTP core");
+MODULE_LICENSE("GPL v2");
+MODULE_AUTHOR("Jeremy Kerr <jk@codeconstruct.com.au>");
+
+MODULE_ALIAS_NETPROTO(PF_MCTP);
-- 
2.30.2

