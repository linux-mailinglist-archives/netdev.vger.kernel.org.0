Return-Path: <netdev+bounces-7502-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 216E67207A2
	for <lists+netdev@lfdr.de>; Fri,  2 Jun 2023 18:33:04 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 958381C2123E
	for <lists+netdev@lfdr.de>; Fri,  2 Jun 2023 16:33:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5290D1F936;
	Fri,  2 Jun 2023 16:31:50 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 426811F933
	for <netdev@vger.kernel.org>; Fri,  2 Jun 2023 16:31:50 +0000 (UTC)
Received: from mail-wr1-f53.google.com (mail-wr1-f53.google.com [209.85.221.53])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C2C613D;
	Fri,  2 Jun 2023 09:31:45 -0700 (PDT)
Received: by mail-wr1-f53.google.com with SMTP id ffacd0b85a97d-30aebe2602fso2026815f8f.3;
        Fri, 02 Jun 2023 09:31:45 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685723504; x=1688315504;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=18UhzK738wPEQcyF4xD6HjJXU4O/6TwIlfmaC3jrcC8=;
        b=iPK4xxx+4EQWqNqTKB6x/4E4iQ3/Ou2MHUb+t8WoabXucAMY3+P133gu7arwGHvFis
         mq8CaHzaTD+BPpbdGAUuqtyN7jRKi1JuwlE3uOZsAN2AjKEJNzB6Y6rVBQKJYJuiP2U7
         HaAY9/BqclETBGy5xmMrGIY9kpPU98Ywe+Ws295mpMfsH6LJnIREZQPmtVGz5V5z0GVS
         teatz/RmOEKoNnQfTaCU88wWYuV4oiUg0RXZ1SxHQNQ2XNNXVu5poLKjay6KxWP4Lylr
         wYxypImS6+wL02NUN+zCUtogEj9kvLTLJTB3mi4pJqf3UwNo/UgdVLnJTccFqIrMdKND
         N77w==
X-Gm-Message-State: AC+VfDysMHl1bcZbRwNQRdk1j5WhBhAi+a/3IqhFhrWsLopnBilKP+2o
	txvleDbAbwrbOT3GJzhFwMI=
X-Google-Smtp-Source: ACHHUZ6T3AjKJFllO+VZFLFWdwuFgzsKtxJ8oPRtMl9inDmYAjYOwfwvttsrYr6mx6itG1M8ITE7sA==
X-Received: by 2002:adf:f544:0:b0:309:4e06:ff0b with SMTP id j4-20020adff544000000b003094e06ff0bmr354928wrp.27.1685723503371;
        Fri, 02 Jun 2023 09:31:43 -0700 (PDT)
Received: from localhost (fwdproxy-cln-011.fbsv.net. [2a03:2880:31ff:b::face:b00c])
        by smtp.gmail.com with ESMTPSA id b14-20020a5d40ce000000b002e5ff05765esm2145755wrq.73.2023.06.02.09.31.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 02 Jun 2023 09:31:42 -0700 (PDT)
From: Breno Leitao <leitao@debian.org>
To: Remi Denis-Courmont <courmisch@gmail.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Alexander Aring <alex.aring@gmail.com>,
	Stefan Schmidt <stefan@datenfreihafen.org>,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	David Ahern <dsahern@kernel.org>,
	Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
	Matthieu Baerts <matthieu.baerts@tessares.net>,
	Mat Martineau <martineau@kernel.org>,
	Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
	Xin Long <lucien.xin@gmail.com>
Cc: axboe@kernel.dk,
	asml.silence@gmail.com,
	leit@fb.com,
	leitao@debian.org,
	linux-kernel@vger.kernel.org,
	netdev@vger.kernel.org,
	dccp@vger.kernel.org,
	linux-wpan@vger.kernel.org,
	mptcp@lists.linux.dev,
	linux-sctp@vger.kernel.org
Subject: [PATCH net-next v5] net: ioctl: Use kernel memory on protocol ioctl callbacks
Date: Fri,  2 Jun 2023 09:30:41 -0700
Message-Id: <20230602163044.1820619-1-leitao@debian.org>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,
	FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
	RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Most of the ioctls to net protocols operates directly on userspace
argument (arg). Usually doing get_user()/put_user() directly in the
ioctl callback.  This is not flexible, because it is hard to reuse these
functions without passing userspace buffers.

Change the "struct proto" ioctls to avoid touching userspace memory and
operate on kernel buffers, i.e., all protocol's ioctl callbacks is
adapted to operate on a kernel memory other than on userspace (so, no
more {put,get}_user() and friends being called in the ioctl callback).

This changes the "struct proto" ioctl format in the following way:

    int                     (*ioctl)(struct sock *sk, int cmd,
-                                        unsigned long arg);
+                                        int *karg);

So, the "karg" argument, which is passed to the ioctl callback, is a
pointer allocated to kernel space memory (inside a function wrapper).
This buffer (karg) may contain input argument (copied from userspace in
a prep function) and it might return a value/buffer, which is copied
back to userspace if necessary. There is not one-size-fits-all format
(that is I am using 'may' above), but basically, there are three type of
ioctls:

1) Do not read from userspace, returns a result to userspace
2) Read an input parameter from userspace, and does not return anything
  to userspace
3) Read an input from userspace, and return a buffer to userspace.

The default case (1) (where no input parameter is given, and an "int" is
returned to userspace) encompasses more than 90% of the cases, but there
are two other exceptions. Here is a list of exceptions:

* Protocol RAW:
   * cmd = SIOCGETVIFCNT:
     * input and output = struct sioc_vif_req
   * cmd = SIOCGETSGCNT
     * input and output = struct sioc_sg_req
   * Explanation: for the SIOCGETVIFCNT case, userspace passes the input
     argument, which is struct sioc_vif_req. Then the callback populates
     the struct, which is copied back to userspace.

* Protocol RAW6:
   * cmd = SIOCGETMIFCNT_IN6
     * input and output = struct sioc_mif_req6
   * cmd = SIOCGETSGCNT_IN6
     * input and output = struct sioc_sg_req6

* Protocol PHONET:
  * cmd == SIOCPNADDRESOURCE | SIOCPNDELRESOURCE
     * input int (4 bytes)
  * Nothing is copied back to userspace.

For the exception cases, functions sock_sk_ioctl_inout() will
copy the userspace input, and copy it back to kernel space.

The wrapper that prepare the buffer and put the buffer back to user is
sk_ioctl(), so, instead of calling sk->sk_prot->ioctl(), the callee now
calls sk_ioctl(), which will handle all cases.

Signed-off-by: Breno Leitao <leitao@debian.org>

---
V1 -> V2:
   * Rename mouthful functions to have saner names
   * Make functions statics and export sk_ioctl()
   * Allocate kernel structures at sk_ioctl()
V2 -> V3:
   * Move protocol specific logic to the protocol code (instead of
     keeping it on core code), and simplify sk_ioctl() by relaying
     on protocol code, for ioctl specifics.
V3 -> V4:
   * Rename and improved the sk_is_proto functions
   * Inline phonet_sk_ioctl()
V4 -> V5:
   * Renamed sk_is_ip6mr() -> sk_is_icmpv6()
   * Inline ip6mr_sk_ioctl() to avoid depending on external modules,
     such as IPV6 (which contains ip6mr code) if CONFIG_IPV6 is compiled
     as a module

---
 include/linux/icmpv6.h      |  6 ++++
 include/linux/mroute.h      | 21 ++++++++++--
 include/linux/mroute6.h     | 28 ++++++++++++++--
 include/net/phonet/phonet.h | 20 ++++++++++++
 include/net/sock.h          |  5 ++-
 include/net/tcp.h           |  2 +-
 include/net/udp.h           |  2 +-
 net/core/sock.c             | 64 +++++++++++++++++++++++++++++++++++++
 net/dccp/dccp.h             |  2 +-
 net/dccp/proto.c            | 12 +++----
 net/ieee802154/socket.c     | 15 ++++-----
 net/ipv4/af_inet.c          |  2 +-
 net/ipv4/ipmr.c             | 63 ++++++++++++++++++++++--------------
 net/ipv4/raw.c              | 16 +++++-----
 net/ipv4/tcp.c              |  5 +--
 net/ipv4/udp.c              | 12 +++----
 net/ipv6/af_inet6.c         |  2 +-
 net/ipv6/ip6mr.c            | 43 ++++++++++---------------
 net/ipv6/raw.c              | 16 +++++-----
 net/l2tp/l2tp_core.h        |  2 +-
 net/l2tp/l2tp_ip.c          |  9 +++---
 net/mptcp/protocol.c        | 11 +++----
 net/phonet/datagram.c       | 11 +++----
 net/phonet/pep.c            | 11 +++----
 net/phonet/socket.c         |  2 +-
 net/sctp/socket.c           |  8 ++---
 26 files changed, 261 insertions(+), 129 deletions(-)

diff --git a/include/linux/icmpv6.h b/include/linux/icmpv6.h
index db0f4fcfdaf4..1fe33e6741cc 100644
--- a/include/linux/icmpv6.h
+++ b/include/linux/icmpv6.h
@@ -111,4 +111,10 @@ static inline bool icmpv6_is_err(int type)
 	return false;
 }
 
+static inline int sk_is_icmpv6(struct sock *sk)
+{
+	return sk->sk_family == AF_INET6 &&
+		inet_sk(sk)->inet_num == IPPROTO_ICMPV6;
+}
+
 #endif
diff --git a/include/linux/mroute.h b/include/linux/mroute.h
index 80b8400ab8b2..5e6787f700db 100644
--- a/include/linux/mroute.h
+++ b/include/linux/mroute.h
@@ -16,12 +16,19 @@ static inline int ip_mroute_opt(int opt)
 	return opt >= MRT_BASE && opt <= MRT_MAX;
 }
 
+static inline int sk_is_ipmr(struct sock *sk)
+{
+	return sk->sk_family == AF_INET &&
+		inet_sk(sk)->inet_num == IPPROTO_IGMP;
+}
+
 int ip_mroute_setsockopt(struct sock *, int, sockptr_t, unsigned int);
 int ip_mroute_getsockopt(struct sock *, int, sockptr_t, sockptr_t);
-int ipmr_ioctl(struct sock *sk, int cmd, void __user *arg);
+int ipmr_ioctl(struct sock *sk, int cmd, void *arg);
 int ipmr_compat_ioctl(struct sock *sk, unsigned int cmd, void __user *arg);
 int ip_mr_init(void);
 bool ipmr_rule_default(const struct fib_rule *rule);
+int ipmr_sk_ioctl(struct sock *sk, unsigned int cmd, void __user *arg);
 #else
 static inline int ip_mroute_setsockopt(struct sock *sock, int optname,
 				       sockptr_t optval, unsigned int optlen)
@@ -35,7 +42,7 @@ static inline int ip_mroute_getsockopt(struct sock *sk, int optname,
 	return -ENOPROTOOPT;
 }
 
-static inline int ipmr_ioctl(struct sock *sk, int cmd, void __user *arg)
+static inline int ipmr_ioctl(struct sock *sk, int cmd, void *arg)
 {
 	return -ENOIOCTLCMD;
 }
@@ -50,10 +57,20 @@ static inline int ip_mroute_opt(int opt)
 	return 0;
 }
 
+static inline int sk_is_ipmr(struct sock *sk)
+{
+	return 0;
+}
+
 static inline bool ipmr_rule_default(const struct fib_rule *rule)
 {
 	return true;
 }
+
+static inline int ipmr_sk_ioctl(struct sock *sk, unsigned int cmd, void __user *arg)
+{
+	return 1;
+}
 #endif
 
 #define VIFF_STATIC 0x8000
diff --git a/include/linux/mroute6.h b/include/linux/mroute6.h
index 8f2b307fb124..7694dd6198e6 100644
--- a/include/linux/mroute6.h
+++ b/include/linux/mroute6.h
@@ -29,7 +29,7 @@ struct sock;
 extern int ip6_mroute_setsockopt(struct sock *, int, sockptr_t, unsigned int);
 extern int ip6_mroute_getsockopt(struct sock *, int, sockptr_t, sockptr_t);
 extern int ip6_mr_input(struct sk_buff *skb);
-extern int ip6mr_ioctl(struct sock *sk, int cmd, void __user *arg);
+extern int ip6mr_ioctl(struct sock *sk, int cmd, void *arg);
 extern int ip6mr_compat_ioctl(struct sock *sk, unsigned int cmd, void __user *arg);
 extern int ip6_mr_init(void);
 extern void ip6_mr_cleanup(void);
@@ -48,7 +48,7 @@ int ip6_mroute_getsockopt(struct sock *sock,
 }
 
 static inline
-int ip6mr_ioctl(struct sock *sk, int cmd, void __user *arg)
+int ip6mr_ioctl(struct sock *sk, int cmd, void *arg)
 {
 	return -ENOIOCTLCMD;
 }
@@ -100,6 +100,26 @@ extern int ip6mr_get_route(struct net *net, struct sk_buff *skb,
 #ifdef CONFIG_IPV6_MROUTE
 bool mroute6_is_socket(struct net *net, struct sk_buff *skb);
 extern int ip6mr_sk_done(struct sock *sk);
+static inline int ip6mr_sk_ioctl(struct sock *sk, unsigned int cmd, void __user *arg)
+{
+	switch (cmd) {
+	/* These userspace buffers will be consumed by ip6mr_ioctl() */
+	case SIOCGETMIFCNT_IN6: {
+		struct sioc_mif_req6 buffer;
+
+		return sock_ioctl_inout(sk, cmd, arg, &buffer,
+				      sizeof(buffer));
+		}
+	case SIOCGETSGCNT_IN6: {
+		struct sioc_mif_req6 buffer;
+
+		return sock_ioctl_inout(sk, cmd, arg, &buffer,
+				      sizeof(buffer));
+		}
+	}
+
+	return 1;
+}
 #else
 static inline bool mroute6_is_socket(struct net *net, struct sk_buff *skb)
 {
@@ -109,5 +129,9 @@ static inline int ip6mr_sk_done(struct sock *sk)
 {
 	return 0;
 }
+static inline int ip6mr_sk_ioctl(struct sock *sk, unsigned int cmd, void __user *arg)
+{
+	return 1;
+}
 #endif
 #endif
diff --git a/include/net/phonet/phonet.h b/include/net/phonet/phonet.h
index 862f1719b523..83215bab79c0 100644
--- a/include/net/phonet/phonet.h
+++ b/include/net/phonet/phonet.h
@@ -109,4 +109,24 @@ void phonet_sysctl_exit(void);
 int isi_register(void);
 void isi_unregister(void);
 
+static inline bool sk_is_phonet(struct sock *sk)
+{
+	return sk->sk_family == PF_PHONET;
+}
+
+static inline int phonet_sk_ioctl(struct sock *sk, unsigned int cmd, void __user *arg)
+{
+	int karg;
+
+	switch (cmd) {
+	case SIOCPNADDRESOURCE:
+	case SIOCPNDELRESOURCE:
+		if (get_user(karg, (int __user *)arg))
+			return -EFAULT;
+
+		return sk->sk_prot->ioctl(sk, cmd, &karg);
+	}
+	/* A positive return value means that the ioctl was not processed */
+	return 1;
+}
 #endif
diff --git a/include/net/sock.h b/include/net/sock.h
index b418425d7230..accd287c6c53 100644
--- a/include/net/sock.h
+++ b/include/net/sock.h
@@ -1250,7 +1250,7 @@ struct proto {
 					  bool kern);
 
 	int			(*ioctl)(struct sock *sk, int cmd,
-					 unsigned long arg);
+					 int *karg);
 	int			(*init)(struct sock *sk);
 	void			(*destroy)(struct sock *sk);
 	void			(*shutdown)(struct sock *sk, int how);
@@ -2965,6 +2965,9 @@ int sock_get_timeout(long timeo, void *optval, bool old_timeval);
 int sock_copy_user_timeval(struct __kernel_sock_timeval *tv,
 			   sockptr_t optval, int optlen, bool old_timeval);
 
+int sock_ioctl_inout(struct sock *sk, unsigned int cmd,
+		     void __user *arg, void *karg, size_t size);
+int sk_ioctl(struct sock *sk, unsigned int cmd, void __user *arg);
 static inline bool sk_is_readable(struct sock *sk)
 {
 	if (sk->sk_prot->sock_is_readable)
diff --git a/include/net/tcp.h b/include/net/tcp.h
index 5066e4586cf0..b84e15d0c41b 100644
--- a/include/net/tcp.h
+++ b/include/net/tcp.h
@@ -342,7 +342,7 @@ void tcp_release_cb(struct sock *sk);
 void tcp_wfree(struct sk_buff *skb);
 void tcp_write_timer_handler(struct sock *sk);
 void tcp_delack_timer_handler(struct sock *sk);
-int tcp_ioctl(struct sock *sk, int cmd, unsigned long arg);
+int tcp_ioctl(struct sock *sk, int cmd, int *karg);
 int tcp_rcv_state_process(struct sock *sk, struct sk_buff *skb);
 void tcp_rcv_established(struct sock *sk, struct sk_buff *skb);
 void tcp_rcv_space_adjust(struct sock *sk);
diff --git a/include/net/udp.h b/include/net/udp.h
index de4b528522bb..9ff5bce33aa0 100644
--- a/include/net/udp.h
+++ b/include/net/udp.h
@@ -283,7 +283,7 @@ void udp_flush_pending_frames(struct sock *sk);
 int udp_cmsg_send(struct sock *sk, struct msghdr *msg, u16 *gso_size);
 void udp4_hwcsum(struct sk_buff *skb, __be32 src, __be32 dst);
 int udp_rcv(struct sk_buff *skb);
-int udp_ioctl(struct sock *sk, int cmd, unsigned long arg);
+int udp_ioctl(struct sock *sk, int cmd, int *karg);
 int udp_init_sock(struct sock *sk);
 int udp_pre_connect(struct sock *sk, struct sockaddr *uaddr, int addr_len);
 int __udp_disconnect(struct sock *sk, int flags);
diff --git a/net/core/sock.c b/net/core/sock.c
index 24f2761bdb1d..dc2bd917ddf6 100644
--- a/net/core/sock.c
+++ b/net/core/sock.c
@@ -114,6 +114,9 @@
 #include <linux/memcontrol.h>
 #include <linux/prefetch.h>
 #include <linux/compat.h>
+#include <linux/mroute.h>
+#include <linux/mroute6.h>
+#include <linux/icmpv6.h>
 
 #include <linux/uaccess.h>
 
@@ -138,6 +141,7 @@
 
 #include <net/tcp.h>
 #include <net/busy_poll.h>
+#include <net/phonet/phonet.h>
 
 #include <linux/ethtool.h>
 
@@ -4106,3 +4110,63 @@ int sock_bind_add(struct sock *sk, struct sockaddr *addr, int addr_len)
 	return sk->sk_prot->bind_add(sk, addr, addr_len);
 }
 EXPORT_SYMBOL(sock_bind_add);
+
+/* Copy 'size' bytes from userspace and return `size` back to userspace */
+int sock_ioctl_inout(struct sock *sk, unsigned int cmd,
+		     void __user *arg, void *karg, size_t size)
+{
+	int ret;
+
+	if (copy_from_user(karg, arg, size))
+		return -EFAULT;
+
+	ret = sk->sk_prot->ioctl(sk, cmd, karg);
+	if (ret)
+		return ret;
+
+	if (copy_to_user(arg, karg, size))
+		return -EFAULT;
+
+	return 0;
+}
+EXPORT_SYMBOL(sock_ioctl_inout);
+
+/* This is the most common ioctl prep function, where the result (4 bytes) is
+ * copied back to userspace if the ioctl() returns successfully. No input is
+ * copied from userspace as input argument.
+ */
+static int sock_ioctl_out(struct sock *sk, unsigned int cmd, void __user *arg)
+{
+	int ret, karg = 0;
+
+	ret = sk->sk_prot->ioctl(sk, cmd, &karg);
+	if (ret)
+		return ret;
+
+	return put_user(karg, (int __user *)arg);
+}
+
+/* A wrapper around sock ioctls, which copies the data from userspace
+ * (depending on the protocol/ioctl), and copies back the result to userspace.
+ * The main motivation for this function is to pass kernel memory to the
+ * protocol ioctl callbacks, instead of userspace memory.
+ */
+int sk_ioctl(struct sock *sk, unsigned int cmd, void __user *arg)
+{
+	int rc = 1;
+
+	if (sk_is_ipmr(sk))
+		rc = ipmr_sk_ioctl(sk, cmd, arg);
+	else if (sk_is_icmpv6(sk))
+		rc = ip6mr_sk_ioctl(sk, cmd, arg);
+	else if (sk_is_phonet(sk))
+		rc = phonet_sk_ioctl(sk, cmd, arg);
+
+	/* If ioctl was processed, returns its value */
+	if (rc <= 0)
+		return rc;
+
+	/* Otherwise call the default handler */
+	return sock_ioctl_out(sk, cmd, arg);
+}
+EXPORT_SYMBOL(sk_ioctl);
diff --git a/net/dccp/dccp.h b/net/dccp/dccp.h
index 9ddc3a9e89e4..1f748ed1279d 100644
--- a/net/dccp/dccp.h
+++ b/net/dccp/dccp.h
@@ -292,7 +292,7 @@ int dccp_getsockopt(struct sock *sk, int level, int optname,
 		    char __user *optval, int __user *optlen);
 int dccp_setsockopt(struct sock *sk, int level, int optname,
 		    sockptr_t optval, unsigned int optlen);
-int dccp_ioctl(struct sock *sk, int cmd, unsigned long arg);
+int dccp_ioctl(struct sock *sk, int cmd, int *karg);
 int dccp_sendmsg(struct sock *sk, struct msghdr *msg, size_t size);
 int dccp_recvmsg(struct sock *sk, struct msghdr *msg, size_t len, int flags,
 		 int *addr_len);
diff --git a/net/dccp/proto.c b/net/dccp/proto.c
index a06b5641287a..9fc3ba4f62de 100644
--- a/net/dccp/proto.c
+++ b/net/dccp/proto.c
@@ -359,7 +359,7 @@ __poll_t dccp_poll(struct file *file, struct socket *sock,
 
 EXPORT_SYMBOL_GPL(dccp_poll);
 
-int dccp_ioctl(struct sock *sk, int cmd, unsigned long arg)
+int dccp_ioctl(struct sock *sk, int cmd, int *karg)
 {
 	int rc = -ENOTCONN;
 
@@ -370,17 +370,17 @@ int dccp_ioctl(struct sock *sk, int cmd, unsigned long arg)
 
 	switch (cmd) {
 	case SIOCOUTQ: {
-		int amount = sk_wmem_alloc_get(sk);
+		*karg = sk_wmem_alloc_get(sk);
 		/* Using sk_wmem_alloc here because sk_wmem_queued is not used by DCCP and
 		 * always 0, comparably to UDP.
 		 */
 
-		rc = put_user(amount, (int __user *)arg);
+		rc = 0;
 	}
 		break;
 	case SIOCINQ: {
 		struct sk_buff *skb;
-		unsigned long amount = 0;
+		*karg = 0;
 
 		skb = skb_peek(&sk->sk_receive_queue);
 		if (skb != NULL) {
@@ -388,9 +388,9 @@ int dccp_ioctl(struct sock *sk, int cmd, unsigned long arg)
 			 * We will only return the amount of this packet since
 			 * that is all that will be read.
 			 */
-			amount = skb->len;
+			*karg = skb->len;
 		}
-		rc = put_user(amount, (int __user *)arg);
+		rc = 0;
 	}
 		break;
 	default:
diff --git a/net/ieee802154/socket.c b/net/ieee802154/socket.c
index 1fa2fe041ec0..9c124705120d 100644
--- a/net/ieee802154/socket.c
+++ b/net/ieee802154/socket.c
@@ -162,7 +162,7 @@ static int ieee802154_sock_ioctl(struct socket *sock, unsigned int cmd,
 	default:
 		if (!sk->sk_prot->ioctl)
 			return -ENOIOCTLCMD;
-		return sk->sk_prot->ioctl(sk, cmd, arg);
+		return sk_ioctl(sk, cmd, (void __user *)arg);
 	}
 }
 
@@ -531,22 +531,21 @@ static int dgram_bind(struct sock *sk, struct sockaddr *uaddr, int len)
 	return err;
 }
 
-static int dgram_ioctl(struct sock *sk, int cmd, unsigned long arg)
+static int dgram_ioctl(struct sock *sk, int cmd, int *karg)
 {
 	switch (cmd) {
 	case SIOCOUTQ:
 	{
-		int amount = sk_wmem_alloc_get(sk);
+		*karg = sk_wmem_alloc_get(sk);
 
-		return put_user(amount, (int __user *)arg);
+		return 0;
 	}
 
 	case SIOCINQ:
 	{
 		struct sk_buff *skb;
-		unsigned long amount;
 
-		amount = 0;
+		*karg = 0;
 		spin_lock_bh(&sk->sk_receive_queue.lock);
 		skb = skb_peek(&sk->sk_receive_queue);
 		if (skb) {
@@ -554,10 +553,10 @@ static int dgram_ioctl(struct sock *sk, int cmd, unsigned long arg)
 			 * of this packet since that is all
 			 * that will be read.
 			 */
-			amount = skb->len - ieee802154_hdr_length(skb);
+			*karg = skb->len - ieee802154_hdr_length(skb);
 		}
 		spin_unlock_bh(&sk->sk_receive_queue.lock);
-		return put_user(amount, (int __user *)arg);
+		return 0;
 	}
 	}
 
diff --git a/net/ipv4/af_inet.c b/net/ipv4/af_inet.c
index 4a76ebf793b8..1111c3b1acdc 100644
--- a/net/ipv4/af_inet.c
+++ b/net/ipv4/af_inet.c
@@ -980,7 +980,7 @@ int inet_ioctl(struct socket *sock, unsigned int cmd, unsigned long arg)
 		break;
 	default:
 		if (sk->sk_prot->ioctl)
-			err = sk->sk_prot->ioctl(sk, cmd, arg);
+			err = sk_ioctl(sk, cmd, (void __user *)arg);
 		else
 			err = -ENOIOCTLCMD;
 		break;
diff --git a/net/ipv4/ipmr.c b/net/ipv4/ipmr.c
index eec1f6df80d8..3f0c6d602fb7 100644
--- a/net/ipv4/ipmr.c
+++ b/net/ipv4/ipmr.c
@@ -1547,6 +1547,28 @@ int ip_mroute_setsockopt(struct sock *sk, int optname, sockptr_t optval,
 	return ret;
 }
 
+/* Execute if this ioctl is a special mroute ioctl */
+int ipmr_sk_ioctl(struct sock *sk, unsigned int cmd, void __user *arg)
+{
+	switch (cmd) {
+	/* These userspace buffers will be consumed by ipmr_ioctl() */
+	case SIOCGETVIFCNT: {
+		struct sioc_vif_req buffer;
+
+		return sock_ioctl_inout(sk, cmd, arg, &buffer,
+				      sizeof(buffer));
+		}
+	case SIOCGETSGCNT: {
+		struct sioc_sg_req buffer;
+
+		return sock_ioctl_inout(sk, cmd, arg, &buffer,
+				      sizeof(buffer));
+		}
+	}
+	/* return code > 0 means that the ioctl was not executed */
+	return 1;
+}
+
 /* Getsock opt support for the multicast routing system. */
 int ip_mroute_getsockopt(struct sock *sk, int optname, sockptr_t optval,
 			 sockptr_t optlen)
@@ -1593,13 +1615,13 @@ int ip_mroute_getsockopt(struct sock *sk, int optname, sockptr_t optval,
 }
 
 /* The IP multicast ioctl support routines. */
-int ipmr_ioctl(struct sock *sk, int cmd, void __user *arg)
+int ipmr_ioctl(struct sock *sk, int cmd, void *arg)
 {
-	struct sioc_sg_req sr;
-	struct sioc_vif_req vr;
 	struct vif_device *vif;
 	struct mfc_cache *c;
 	struct net *net = sock_net(sk);
+	struct sioc_vif_req *vr;
+	struct sioc_sg_req *sr;
 	struct mr_table *mrt;
 
 	mrt = ipmr_get_table(net, raw_sk(sk)->ipmr_table ? : RT_TABLE_DEFAULT);
@@ -1608,40 +1630,33 @@ int ipmr_ioctl(struct sock *sk, int cmd, void __user *arg)
 
 	switch (cmd) {
 	case SIOCGETVIFCNT:
-		if (copy_from_user(&vr, arg, sizeof(vr)))
-			return -EFAULT;
-		if (vr.vifi >= mrt->maxvif)
+		vr = (struct sioc_vif_req *)arg;
+		if (vr->vifi >= mrt->maxvif)
 			return -EINVAL;
-		vr.vifi = array_index_nospec(vr.vifi, mrt->maxvif);
+		vr->vifi = array_index_nospec(vr->vifi, mrt->maxvif);
 		rcu_read_lock();
-		vif = &mrt->vif_table[vr.vifi];
-		if (VIF_EXISTS(mrt, vr.vifi)) {
-			vr.icount = READ_ONCE(vif->pkt_in);
-			vr.ocount = READ_ONCE(vif->pkt_out);
-			vr.ibytes = READ_ONCE(vif->bytes_in);
-			vr.obytes = READ_ONCE(vif->bytes_out);
+		vif = &mrt->vif_table[vr->vifi];
+		if (VIF_EXISTS(mrt, vr->vifi)) {
+			vr->icount = READ_ONCE(vif->pkt_in);
+			vr->ocount = READ_ONCE(vif->pkt_out);
+			vr->ibytes = READ_ONCE(vif->bytes_in);
+			vr->obytes = READ_ONCE(vif->bytes_out);
 			rcu_read_unlock();
 
-			if (copy_to_user(arg, &vr, sizeof(vr)))
-				return -EFAULT;
 			return 0;
 		}
 		rcu_read_unlock();
 		return -EADDRNOTAVAIL;
 	case SIOCGETSGCNT:
-		if (copy_from_user(&sr, arg, sizeof(sr)))
-			return -EFAULT;
+		sr = (struct sioc_sg_req *)arg;
 
 		rcu_read_lock();
-		c = ipmr_cache_find(mrt, sr.src.s_addr, sr.grp.s_addr);
+		c = ipmr_cache_find(mrt, sr->src.s_addr, sr->grp.s_addr);
 		if (c) {
-			sr.pktcnt = c->_c.mfc_un.res.pkt;
-			sr.bytecnt = c->_c.mfc_un.res.bytes;
-			sr.wrong_if = c->_c.mfc_un.res.wrong_if;
+			sr->pktcnt = c->_c.mfc_un.res.pkt;
+			sr->bytecnt = c->_c.mfc_un.res.bytes;
+			sr->wrong_if = c->_c.mfc_un.res.wrong_if;
 			rcu_read_unlock();
-
-			if (copy_to_user(arg, &sr, sizeof(sr)))
-				return -EFAULT;
 			return 0;
 		}
 		rcu_read_unlock();
diff --git a/net/ipv4/raw.c b/net/ipv4/raw.c
index eadf1c9ef7e4..6b041e6069c0 100644
--- a/net/ipv4/raw.c
+++ b/net/ipv4/raw.c
@@ -858,29 +858,29 @@ static int raw_getsockopt(struct sock *sk, int level, int optname,
 	return do_raw_getsockopt(sk, level, optname, optval, optlen);
 }
 
-static int raw_ioctl(struct sock *sk, int cmd, unsigned long arg)
+static int raw_ioctl(struct sock *sk, int cmd, int *karg)
 {
 	switch (cmd) {
 	case SIOCOUTQ: {
-		int amount = sk_wmem_alloc_get(sk);
-
-		return put_user(amount, (int __user *)arg);
+		*karg = sk_wmem_alloc_get(sk);
+		return 0;
 	}
 	case SIOCINQ: {
 		struct sk_buff *skb;
-		int amount = 0;
 
 		spin_lock_bh(&sk->sk_receive_queue.lock);
 		skb = skb_peek(&sk->sk_receive_queue);
 		if (skb)
-			amount = skb->len;
+			*karg = skb->len;
+		else
+			*karg = 0;
 		spin_unlock_bh(&sk->sk_receive_queue.lock);
-		return put_user(amount, (int __user *)arg);
+		return 0;
 	}
 
 	default:
 #ifdef CONFIG_IP_MROUTE
-		return ipmr_ioctl(sk, cmd, (void __user *)arg);
+		return ipmr_ioctl(sk, cmd, karg);
 #else
 		return -ENOIOCTLCMD;
 #endif
diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
index 8d20d9221238..425a26aef5c0 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -599,7 +599,7 @@ __poll_t tcp_poll(struct file *file, struct socket *sock, poll_table *wait)
 }
 EXPORT_SYMBOL(tcp_poll);
 
-int tcp_ioctl(struct sock *sk, int cmd, unsigned long arg)
+int tcp_ioctl(struct sock *sk, int cmd, int *karg)
 {
 	struct tcp_sock *tp = tcp_sk(sk);
 	int answ;
@@ -641,7 +641,8 @@ int tcp_ioctl(struct sock *sk, int cmd, unsigned long arg)
 		return -ENOIOCTLCMD;
 	}
 
-	return put_user(answ, (int __user *)arg);
+	*karg = answ;
+	return 0;
 }
 EXPORT_SYMBOL(tcp_ioctl);
 
diff --git a/net/ipv4/udp.c b/net/ipv4/udp.c
index 9482def1f310..e12e2c173c25 100644
--- a/net/ipv4/udp.c
+++ b/net/ipv4/udp.c
@@ -1720,21 +1720,19 @@ static int first_packet_length(struct sock *sk)
  *	IOCTL requests applicable to the UDP protocol
  */
 
-int udp_ioctl(struct sock *sk, int cmd, unsigned long arg)
+int udp_ioctl(struct sock *sk, int cmd, int *karg)
 {
 	switch (cmd) {
 	case SIOCOUTQ:
 	{
-		int amount = sk_wmem_alloc_get(sk);
-
-		return put_user(amount, (int __user *)arg);
+		*karg = sk_wmem_alloc_get(sk);
+		return 0;
 	}
 
 	case SIOCINQ:
 	{
-		int amount = max_t(int, 0, first_packet_length(sk));
-
-		return put_user(amount, (int __user *)arg);
+		*karg = max_t(int, 0, first_packet_length(sk));
+		return 0;
 	}
 
 	default:
diff --git a/net/ipv6/af_inet6.c b/net/ipv6/af_inet6.c
index 2bbf13216a3d..001ba5a17af9 100644
--- a/net/ipv6/af_inet6.c
+++ b/net/ipv6/af_inet6.c
@@ -579,7 +579,7 @@ int inet6_ioctl(struct socket *sock, unsigned int cmd, unsigned long arg)
 		prot = READ_ONCE(sk->sk_prot);
 		if (!prot->ioctl)
 			return -ENOIOCTLCMD;
-		return prot->ioctl(sk, cmd, arg);
+		return sk_ioctl(sk, cmd, (void __user *)arg);
 	}
 	/*NOTREACHED*/
 	return 0;
diff --git a/net/ipv6/ip6mr.c b/net/ipv6/ip6mr.c
index 51cf37abd142..0b6974daa666 100644
--- a/net/ipv6/ip6mr.c
+++ b/net/ipv6/ip6mr.c
@@ -1879,11 +1879,10 @@ int ip6_mroute_getsockopt(struct sock *sk, int optname, sockptr_t optval,
 /*
  *	The IP multicast ioctl support routines.
  */
-
-int ip6mr_ioctl(struct sock *sk, int cmd, void __user *arg)
+int ip6mr_ioctl(struct sock *sk, int cmd, void *arg)
 {
-	struct sioc_sg_req6 sr;
-	struct sioc_mif_req6 vr;
+	struct sioc_sg_req6 *sr;
+	struct sioc_mif_req6 *vr;
 	struct vif_device *vif;
 	struct mfc6_cache *c;
 	struct net *net = sock_net(sk);
@@ -1895,40 +1894,32 @@ int ip6mr_ioctl(struct sock *sk, int cmd, void __user *arg)
 
 	switch (cmd) {
 	case SIOCGETMIFCNT_IN6:
-		if (copy_from_user(&vr, arg, sizeof(vr)))
-			return -EFAULT;
-		if (vr.mifi >= mrt->maxvif)
+		vr = (struct sioc_mif_req6 *)arg;
+		if (vr->mifi >= mrt->maxvif)
 			return -EINVAL;
-		vr.mifi = array_index_nospec(vr.mifi, mrt->maxvif);
+		vr->mifi = array_index_nospec(vr->mifi, mrt->maxvif);
 		rcu_read_lock();
-		vif = &mrt->vif_table[vr.mifi];
-		if (VIF_EXISTS(mrt, vr.mifi)) {
-			vr.icount = READ_ONCE(vif->pkt_in);
-			vr.ocount = READ_ONCE(vif->pkt_out);
-			vr.ibytes = READ_ONCE(vif->bytes_in);
-			vr.obytes = READ_ONCE(vif->bytes_out);
+		vif = &mrt->vif_table[vr->mifi];
+		if (VIF_EXISTS(mrt, vr->mifi)) {
+			vr->icount = READ_ONCE(vif->pkt_in);
+			vr->ocount = READ_ONCE(vif->pkt_out);
+			vr->ibytes = READ_ONCE(vif->bytes_in);
+			vr->obytes = READ_ONCE(vif->bytes_out);
 			rcu_read_unlock();
-
-			if (copy_to_user(arg, &vr, sizeof(vr)))
-				return -EFAULT;
 			return 0;
 		}
 		rcu_read_unlock();
 		return -EADDRNOTAVAIL;
 	case SIOCGETSGCNT_IN6:
-		if (copy_from_user(&sr, arg, sizeof(sr)))
-			return -EFAULT;
+		sr = (struct sioc_sg_req6 *)arg;
 
 		rcu_read_lock();
-		c = ip6mr_cache_find(mrt, &sr.src.sin6_addr, &sr.grp.sin6_addr);
+		c = ip6mr_cache_find(mrt, &sr->src.sin6_addr, &sr->grp.sin6_addr);
 		if (c) {
-			sr.pktcnt = c->_c.mfc_un.res.pkt;
-			sr.bytecnt = c->_c.mfc_un.res.bytes;
-			sr.wrong_if = c->_c.mfc_un.res.wrong_if;
+			sr->pktcnt = c->_c.mfc_un.res.pkt;
+			sr->bytecnt = c->_c.mfc_un.res.bytes;
+			sr->wrong_if = c->_c.mfc_un.res.wrong_if;
 			rcu_read_unlock();
-
-			if (copy_to_user(arg, &sr, sizeof(sr)))
-				return -EFAULT;
 			return 0;
 		}
 		rcu_read_unlock();
diff --git a/net/ipv6/raw.c b/net/ipv6/raw.c
index 44ee7a2e72ac..c9caeb5a43ed 100644
--- a/net/ipv6/raw.c
+++ b/net/ipv6/raw.c
@@ -1118,29 +1118,29 @@ static int rawv6_getsockopt(struct sock *sk, int level, int optname,
 	return do_rawv6_getsockopt(sk, level, optname, optval, optlen);
 }
 
-static int rawv6_ioctl(struct sock *sk, int cmd, unsigned long arg)
+static int rawv6_ioctl(struct sock *sk, int cmd, int *karg)
 {
 	switch (cmd) {
 	case SIOCOUTQ: {
-		int amount = sk_wmem_alloc_get(sk);
-
-		return put_user(amount, (int __user *)arg);
+		*karg = sk_wmem_alloc_get(sk);
+		return 0;
 	}
 	case SIOCINQ: {
 		struct sk_buff *skb;
-		int amount = 0;
 
 		spin_lock_bh(&sk->sk_receive_queue.lock);
 		skb = skb_peek(&sk->sk_receive_queue);
 		if (skb)
-			amount = skb->len;
+			*karg = skb->len;
+		else
+			*karg = 0;
 		spin_unlock_bh(&sk->sk_receive_queue.lock);
-		return put_user(amount, (int __user *)arg);
+		return 0;
 	}
 
 	default:
 #ifdef CONFIG_IPV6_MROUTE
-		return ip6mr_ioctl(sk, cmd, (void __user *)arg);
+		return ip6mr_ioctl(sk, cmd, karg);
 #else
 		return -ENOIOCTLCMD;
 #endif
diff --git a/net/l2tp/l2tp_core.h b/net/l2tp/l2tp_core.h
index a88e070b431d..91ebf0a3f499 100644
--- a/net/l2tp/l2tp_core.h
+++ b/net/l2tp/l2tp_core.h
@@ -272,7 +272,7 @@ int l2tp_nl_register_ops(enum l2tp_pwtype pw_type, const struct l2tp_nl_cmd_ops
 void l2tp_nl_unregister_ops(enum l2tp_pwtype pw_type);
 
 /* IOCTL helper for IP encap modules. */
-int l2tp_ioctl(struct sock *sk, int cmd, unsigned long arg);
+int l2tp_ioctl(struct sock *sk, int cmd, int *karg);
 
 /* Extract the tunnel structure from a socket's sk_user_data pointer,
  * validating the tunnel magic feather.
diff --git a/net/l2tp/l2tp_ip.c b/net/l2tp/l2tp_ip.c
index 41a74fc84ca1..2b795c1064f5 100644
--- a/net/l2tp/l2tp_ip.c
+++ b/net/l2tp/l2tp_ip.c
@@ -562,19 +562,18 @@ static int l2tp_ip_recvmsg(struct sock *sk, struct msghdr *msg,
 	return err ? err : copied;
 }
 
-int l2tp_ioctl(struct sock *sk, int cmd, unsigned long arg)
+int l2tp_ioctl(struct sock *sk, int cmd, int *karg)
 {
 	struct sk_buff *skb;
-	int amount;
 
 	switch (cmd) {
 	case SIOCOUTQ:
-		amount = sk_wmem_alloc_get(sk);
+		*karg = sk_wmem_alloc_get(sk);
 		break;
 	case SIOCINQ:
 		spin_lock_bh(&sk->sk_receive_queue.lock);
 		skb = skb_peek(&sk->sk_receive_queue);
-		amount = skb ? skb->len : 0;
+		*karg = skb ? skb->len : 0;
 		spin_unlock_bh(&sk->sk_receive_queue.lock);
 		break;
 
@@ -582,7 +581,7 @@ int l2tp_ioctl(struct sock *sk, int cmd, unsigned long arg)
 		return -ENOIOCTLCMD;
 	}
 
-	return put_user(amount, (int __user *)arg);
+	return 0;
 }
 EXPORT_SYMBOL_GPL(l2tp_ioctl);
 
diff --git a/net/mptcp/protocol.c b/net/mptcp/protocol.c
index 67311e7d5b21..cc7bc182ee96 100644
--- a/net/mptcp/protocol.c
+++ b/net/mptcp/protocol.c
@@ -3570,11 +3570,10 @@ static int mptcp_ioctl_outq(const struct mptcp_sock *msk, u64 v)
 	return (int)delta;
 }
 
-static int mptcp_ioctl(struct sock *sk, int cmd, unsigned long arg)
+static int mptcp_ioctl(struct sock *sk, int cmd, int *karg)
 {
 	struct mptcp_sock *msk = mptcp_sk(sk);
 	bool slow;
-	int answ;
 
 	switch (cmd) {
 	case SIOCINQ:
@@ -3583,24 +3582,24 @@ static int mptcp_ioctl(struct sock *sk, int cmd, unsigned long arg)
 
 		lock_sock(sk);
 		__mptcp_move_skbs(msk);
-		answ = mptcp_inq_hint(sk);
+		*karg = mptcp_inq_hint(sk);
 		release_sock(sk);
 		break;
 	case SIOCOUTQ:
 		slow = lock_sock_fast(sk);
-		answ = mptcp_ioctl_outq(msk, READ_ONCE(msk->snd_una));
+		*karg = mptcp_ioctl_outq(msk, READ_ONCE(msk->snd_una));
 		unlock_sock_fast(sk, slow);
 		break;
 	case SIOCOUTQNSD:
 		slow = lock_sock_fast(sk);
-		answ = mptcp_ioctl_outq(msk, msk->snd_nxt);
+		*karg = mptcp_ioctl_outq(msk, msk->snd_nxt);
 		unlock_sock_fast(sk, slow);
 		break;
 	default:
 		return -ENOIOCTLCMD;
 	}
 
-	return put_user(answ, (int __user *)arg);
+	return 0;
 }
 
 static void mptcp_subflow_early_fallback(struct mptcp_sock *msk,
diff --git a/net/phonet/datagram.c b/net/phonet/datagram.c
index ff5f49ab236e..3aa50dc7535b 100644
--- a/net/phonet/datagram.c
+++ b/net/phonet/datagram.c
@@ -28,24 +28,21 @@ static void pn_sock_close(struct sock *sk, long timeout)
 	sk_common_release(sk);
 }
 
-static int pn_ioctl(struct sock *sk, int cmd, unsigned long arg)
+static int pn_ioctl(struct sock *sk, int cmd, int *karg)
 {
 	struct sk_buff *skb;
-	int answ;
 
 	switch (cmd) {
 	case SIOCINQ:
 		lock_sock(sk);
 		skb = skb_peek(&sk->sk_receive_queue);
-		answ = skb ? skb->len : 0;
+		*karg = skb ? skb->len : 0;
 		release_sock(sk);
-		return put_user(answ, (int __user *)arg);
+		return 0;
 
 	case SIOCPNADDRESOURCE:
 	case SIOCPNDELRESOURCE: {
-			u32 res;
-			if (get_user(res, (u32 __user *)arg))
-				return -EFAULT;
+			u32 res = *karg;
 			if (res >= 256)
 				return -EINVAL;
 			if (cmd == SIOCPNADDRESOURCE)
diff --git a/net/phonet/pep.c b/net/phonet/pep.c
index 83ea13a50690..faba31f2eff2 100644
--- a/net/phonet/pep.c
+++ b/net/phonet/pep.c
@@ -917,10 +917,9 @@ static int pep_sock_enable(struct sock *sk, struct sockaddr *addr, int len)
 	return 0;
 }
 
-static int pep_ioctl(struct sock *sk, int cmd, unsigned long arg)
+static int pep_ioctl(struct sock *sk, int cmd, int *karg)
 {
 	struct pep_sock *pn = pep_sk(sk);
-	int answ;
 	int ret = -ENOIOCTLCMD;
 
 	switch (cmd) {
@@ -933,13 +932,13 @@ static int pep_ioctl(struct sock *sk, int cmd, unsigned long arg)
 		lock_sock(sk);
 		if (sock_flag(sk, SOCK_URGINLINE) &&
 		    !skb_queue_empty(&pn->ctrlreq_queue))
-			answ = skb_peek(&pn->ctrlreq_queue)->len;
+			*karg = skb_peek(&pn->ctrlreq_queue)->len;
 		else if (!skb_queue_empty(&sk->sk_receive_queue))
-			answ = skb_peek(&sk->sk_receive_queue)->len;
+			*karg = skb_peek(&sk->sk_receive_queue)->len;
 		else
-			answ = 0;
+			*karg = 0;
 		release_sock(sk);
-		ret = put_user(answ, (int __user *)arg);
+		ret = 0;
 		break;
 
 	case SIOCPNENABLEPIPE:
diff --git a/net/phonet/socket.c b/net/phonet/socket.c
index 71e2caf6ab85..967f9b4dc026 100644
--- a/net/phonet/socket.c
+++ b/net/phonet/socket.c
@@ -387,7 +387,7 @@ static int pn_socket_ioctl(struct socket *sock, unsigned int cmd,
 		return put_user(handle, (__u16 __user *)arg);
 	}
 
-	return sk->sk_prot->ioctl(sk, cmd, arg);
+	return sk_ioctl(sk, cmd, (void __user *)arg);
 }
 
 static int pn_socket_listen(struct socket *sock, int backlog)
diff --git a/net/sctp/socket.c b/net/sctp/socket.c
index cda8c2874691..3acd6e223cd4 100644
--- a/net/sctp/socket.c
+++ b/net/sctp/socket.c
@@ -4895,7 +4895,7 @@ static struct sock *sctp_accept(struct sock *sk, int flags, int *err, bool kern)
 }
 
 /* The SCTP ioctl handler. */
-static int sctp_ioctl(struct sock *sk, int cmd, unsigned long arg)
+static int sctp_ioctl(struct sock *sk, int cmd, int *karg)
 {
 	int rc = -ENOTCONN;
 
@@ -4911,7 +4911,7 @@ static int sctp_ioctl(struct sock *sk, int cmd, unsigned long arg)
 	switch (cmd) {
 	case SIOCINQ: {
 		struct sk_buff *skb;
-		unsigned int amount = 0;
+		*karg = 0;
 
 		skb = skb_peek(&sk->sk_receive_queue);
 		if (skb != NULL) {
@@ -4919,9 +4919,9 @@ static int sctp_ioctl(struct sock *sk, int cmd, unsigned long arg)
 			 * We will only return the amount of this packet since
 			 * that is all that will be read.
 			 */
-			amount = skb->len;
+			*karg = skb->len;
 		}
-		rc = put_user(amount, (int __user *)arg);
+		rc = 0;
 		break;
 	}
 	default:
-- 
2.34.1


