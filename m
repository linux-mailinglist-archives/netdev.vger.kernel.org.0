Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C305114923B
	for <lists+netdev@lfdr.de>; Sat, 25 Jan 2020 01:04:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387475AbgAYAET (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Jan 2020 19:04:19 -0500
Received: from mga14.intel.com ([192.55.52.115]:45732 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729368AbgAYAES (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 24 Jan 2020 19:04:18 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga103.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 24 Jan 2020 16:04:18 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,359,1574150400"; 
   d="scan'208";a="251447332"
Received: from mjmartin-nuc02.mjmartin-nuc02 (HELO mjmartin-nuc02.sea.intel.com) ([10.251.22.36])
  by fmsmga004.fm.intel.com with ESMTP; 24 Jan 2020 16:04:18 -0800
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     netdev@vger.kernel.org
Cc:     Florian Westphal <fw@strlen.de>, mptcp@lists.01.org,
        edumazet@google.com, Christoph Paasch <cpaasch@apple.com>,
        Mat Martineau <mathew.j.martineau@linux.intel.com>
Subject: [PATCH net-next 1/2] mptcp: do not inherit inet proto ops
Date:   Fri, 24 Jan 2020 16:04:02 -0800
Message-Id: <20200125000403.251894-2-mathew.j.martineau@linux.intel.com>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200125000403.251894-1-mathew.j.martineau@linux.intel.com>
References: <20200125000403.251894-1-mathew.j.martineau@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Florian Westphal <fw@strlen.de>

We need to initialise the struct ourselves, else we expose tcp-specific
callbacks such as tcp_splice_read which will then trigger splat because
the socket is an mptcp one:

BUG: KASAN: slab-out-of-bounds in tcp_mstamp_refresh+0x80/0xa0 net/ipv4/tcp_output.c:57
Write of size 8 at addr ffff888116aa21d0 by task syz-executor.0/5478

CPU: 1 PID: 5478 Comm: syz-executor.0 Not tainted 5.5.0-rc6 #3
Call Trace:
 tcp_mstamp_refresh+0x80/0xa0 net/ipv4/tcp_output.c:57
 tcp_rcv_space_adjust+0x72/0x7f0 net/ipv4/tcp_input.c:612
 tcp_read_sock+0x622/0x990 net/ipv4/tcp.c:1674
 tcp_splice_read+0x20b/0xb40 net/ipv4/tcp.c:791
 do_splice+0x1259/0x1560 fs/splice.c:1205

To prevent build error with ipv6, add the recv/sendmsg function
declaration to ipv6.h.  The functions are already accessible "thanks"
to retpoline related work, but they are currently only made visible
by socket.c specific INDIRECT_CALLABLE macros.

Reported-by: Christoph Paasch <cpaasch@apple.com>
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
---
 include/net/ipv6.h   |  3 ++
 net/mptcp/protocol.c | 70 ++++++++++++++++++++++++++++++++------------
 2 files changed, 54 insertions(+), 19 deletions(-)

diff --git a/include/net/ipv6.h b/include/net/ipv6.h
index 4e95f6df508c..cec1a54401f2 100644
--- a/include/net/ipv6.h
+++ b/include/net/ipv6.h
@@ -1113,6 +1113,9 @@ int inet6_ioctl(struct socket *sock, unsigned int cmd, unsigned long arg);
 
 int inet6_hash_connect(struct inet_timewait_death_row *death_row,
 			      struct sock *sk);
+int inet6_sendmsg(struct socket *sock, struct msghdr *msg, size_t size);
+int inet6_recvmsg(struct socket *sock, struct msghdr *msg, size_t size,
+		  int flags);
 
 /*
  * reassembly.c
diff --git a/net/mptcp/protocol.c b/net/mptcp/protocol.c
index ee916b3686fe..41d49126d29a 100644
--- a/net/mptcp/protocol.c
+++ b/net/mptcp/protocol.c
@@ -1163,7 +1163,31 @@ static int mptcp_shutdown(struct socket *sock, int how)
 	return ret;
 }
 
-static struct proto_ops mptcp_stream_ops;
+static const struct proto_ops mptcp_stream_ops = {
+	.family		   = PF_INET,
+	.owner		   = THIS_MODULE,
+	.release	   = inet_release,
+	.bind		   = mptcp_bind,
+	.connect	   = mptcp_stream_connect,
+	.socketpair	   = sock_no_socketpair,
+	.accept		   = mptcp_stream_accept,
+	.getname	   = mptcp_v4_getname,
+	.poll		   = mptcp_poll,
+	.ioctl		   = inet_ioctl,
+	.gettstamp	   = sock_gettstamp,
+	.listen		   = mptcp_listen,
+	.shutdown	   = mptcp_shutdown,
+	.setsockopt	   = sock_common_setsockopt,
+	.getsockopt	   = sock_common_getsockopt,
+	.sendmsg	   = inet_sendmsg,
+	.recvmsg	   = inet_recvmsg,
+	.mmap		   = sock_no_mmap,
+	.sendpage	   = inet_sendpage,
+#ifdef CONFIG_COMPAT
+	.compat_setsockopt = compat_sock_common_setsockopt,
+	.compat_getsockopt = compat_sock_common_getsockopt,
+#endif
+};
 
 static struct inet_protosw mptcp_protosw = {
 	.type		= SOCK_STREAM,
@@ -1176,14 +1200,6 @@ static struct inet_protosw mptcp_protosw = {
 void mptcp_proto_init(void)
 {
 	mptcp_prot.h.hashinfo = tcp_prot.h.hashinfo;
-	mptcp_stream_ops = inet_stream_ops;
-	mptcp_stream_ops.bind = mptcp_bind;
-	mptcp_stream_ops.connect = mptcp_stream_connect;
-	mptcp_stream_ops.poll = mptcp_poll;
-	mptcp_stream_ops.accept = mptcp_stream_accept;
-	mptcp_stream_ops.getname = mptcp_v4_getname;
-	mptcp_stream_ops.listen = mptcp_listen;
-	mptcp_stream_ops.shutdown = mptcp_shutdown;
 
 	mptcp_subflow_init();
 
@@ -1194,7 +1210,32 @@ void mptcp_proto_init(void)
 }
 
 #if IS_ENABLED(CONFIG_MPTCP_IPV6)
-static struct proto_ops mptcp_v6_stream_ops;
+static const struct proto_ops mptcp_v6_stream_ops = {
+	.family		   = PF_INET6,
+	.owner		   = THIS_MODULE,
+	.release	   = inet6_release,
+	.bind		   = mptcp_bind,
+	.connect	   = mptcp_stream_connect,
+	.socketpair	   = sock_no_socketpair,
+	.accept		   = mptcp_stream_accept,
+	.getname	   = mptcp_v6_getname,
+	.poll		   = mptcp_poll,
+	.ioctl		   = inet6_ioctl,
+	.gettstamp	   = sock_gettstamp,
+	.listen		   = mptcp_listen,
+	.shutdown	   = mptcp_shutdown,
+	.setsockopt	   = sock_common_setsockopt,
+	.getsockopt	   = sock_common_getsockopt,
+	.sendmsg	   = inet6_sendmsg,
+	.recvmsg	   = inet6_recvmsg,
+	.mmap		   = sock_no_mmap,
+	.sendpage	   = inet_sendpage,
+#ifdef CONFIG_COMPAT
+	.compat_setsockopt = compat_sock_common_setsockopt,
+	.compat_getsockopt = compat_sock_common_getsockopt,
+#endif
+};
+
 static struct proto mptcp_v6_prot;
 
 static void mptcp_v6_destroy(struct sock *sk)
@@ -1226,15 +1267,6 @@ int mptcp_proto_v6_init(void)
 	if (err)
 		return err;
 
-	mptcp_v6_stream_ops = inet6_stream_ops;
-	mptcp_v6_stream_ops.bind = mptcp_bind;
-	mptcp_v6_stream_ops.connect = mptcp_stream_connect;
-	mptcp_v6_stream_ops.poll = mptcp_poll;
-	mptcp_v6_stream_ops.accept = mptcp_stream_accept;
-	mptcp_v6_stream_ops.getname = mptcp_v6_getname;
-	mptcp_v6_stream_ops.listen = mptcp_listen;
-	mptcp_v6_stream_ops.shutdown = mptcp_shutdown;
-
 	err = inet6_register_protosw(&mptcp_v6_protosw);
 	if (err)
 		proto_unregister(&mptcp_v6_prot);
-- 
2.25.0

