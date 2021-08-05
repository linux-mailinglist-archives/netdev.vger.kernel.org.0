Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8C1263E1ED4
	for <lists+netdev@lfdr.de>; Fri,  6 Aug 2021 00:35:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241265AbhHEWfd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Aug 2021 18:35:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40772 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241124AbhHEWf3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Aug 2021 18:35:29 -0400
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A44E2C06179B
        for <netdev@vger.kernel.org>; Thu,  5 Aug 2021 15:35:14 -0700 (PDT)
Received: by mail-pj1-x1029.google.com with SMTP id u13-20020a17090abb0db0290177e1d9b3f7so18497115pjr.1
        for <netdev@vger.kernel.org>; Thu, 05 Aug 2021 15:35:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ICipkKbzq88BSRiOxtXO45G+rfdVEGpaxLCIN/F6ASU=;
        b=NYrELORXF/cIB8Kl0LO3EvtHT5mLgqszleUWfq0uKXINHE5O622oihG0vM5oEhl6Vx
         Y9pSNBjHEhcqa/gJfDoYSHcfHj33GbAkUf8EJRLB0MuErKTrNfZkHQVqq8IUlXWrHX0i
         weBg1iY+dIk/kwpo6KhhtSlxT8P2eRpO+ss2/z+ezIWIybXTaG0F9bxdaH2yR0jKWAdy
         YIeY3TdyH6MHFPZQpjFihrD2BSxz+H90J/pXpFVf6GP07vLwHxFsWedo04p7ZKeFzD1L
         4olhsTj2H4oyHJepJ5rhWOOq9j1dELTy7ezr0F1oU8AsZpXBAM1JS9feakvXnn+Hwxlp
         ZnxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ICipkKbzq88BSRiOxtXO45G+rfdVEGpaxLCIN/F6ASU=;
        b=UFdlQD4g57RnQUrE11iq4fgPX4U8u0h6C9rTx2sue+6FyxjO2wE4/Xzf/PaWniTWRN
         7aLZbD0M8Sij/pC48d7fuIgBlPF+TydxjDLkazdiu2VlPQG611hBEOU1t348lJ9kH/Ho
         JnvIbTGH3GCfBO6LXeCxDXwuKt7Nx7KjsgTQVd3H7CvzLfa6m5/y/BHEYfFSN2jA8XTn
         92QewZg0x1ApQps5fHLzIkpEfP+/+dVyWsAhzmdsh1WA3E0fPMhFzDz92QB5onWY54PR
         KiLKA7bi/wNi3pRznPJb7hVDXShds27Uc+uXz6xEpnaL2jHIq1iBpU7w8sWlgeoHyAM2
         3Ojw==
X-Gm-Message-State: AOAM5323GdwrRcR76b83McwGP3v8qOGkZrVpLuEiabRmeQBDWhheeoTX
        3eiWMlDLVj3UiTBmO6ILEI5ZmA5BaQe5QQ==
X-Google-Smtp-Source: ABdhPJwrAVaNVFO4ocD4eMWA0W2O2/+lfI704WCyRosGVTy6qO+bqOO6iNAExjoH1UfdB/t7Swn5FQ==
X-Received: by 2002:a17:903:2302:b029:12c:bb4f:cbdf with SMTP id d2-20020a1709032302b029012cbb4fcbdfmr5868117plh.22.1628202913995;
        Thu, 05 Aug 2021 15:35:13 -0700 (PDT)
Received: from ip-10-124-121-13.byted.org (ec2-54-241-92-238.us-west-1.compute.amazonaws.com. [54.241.92.238])
        by smtp.gmail.com with ESMTPSA id z8sm7931638pfa.113.2021.08.05.15.35.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Aug 2021 15:35:13 -0700 (PDT)
From:   Jiang Wang <jiang.wang@bytedance.com>
To:     netdev@vger.kernel.org
Cc:     cong.wang@bytedance.com, duanxiongchun@bytedance.com,
        xieyongji@bytedance.com, chaiwen.cc@bytedance.com,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jakub Sitnicki <jakub@cloudflare.com>,
        Lorenz Bauer <lmb@cloudflare.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        KP Singh <kpsingh@kernel.org>, Shuah Khan <shuah@kernel.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Christian Brauner <christian.brauner@ubuntu.com>,
        Johan Almbladh <johan.almbladh@anyfinetworks.com>,
        linux-kernel@vger.kernel.org, bpf@vger.kernel.org,
        linux-kselftest@vger.kernel.org
Subject: [PATCH bpf-next v5 2/5] af_unix: add unix_stream_proto for sockmap
Date:   Thu,  5 Aug 2021 22:34:39 +0000
Message-Id: <20210805223445.624330-3-jiang.wang@bytedance.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20210805223445.624330-1-jiang.wang@bytedance.com>
References: <20210805223445.624330-1-jiang.wang@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Previously, sockmap for AF_UNIX protocol only supports
dgram type. This patch add unix stream type support, which
is similar to unix_dgram_proto. To support sockmap, dgram
and stream cannot share the same unix_proto anymore, because
they have different implementations, such as unhash for stream
type (which will remove closed or disconnected sockets from the map),
so rename unix_proto to unix_dgram_proto and add a new
unix_stream_proto.

Also implement stream related sockmap functions.
And add dgram key words to those dgram specific functions.

Signed-off-by: Jiang Wang <jiang.wang@bytedance.com>
Reviewed-by: Cong Wang <cong.wang@bytedance.com>
---
 include/net/af_unix.h |  8 +++-
 net/unix/af_unix.c    | 75 +++++++++++++++++++++++++++++-----
 net/unix/unix_bpf.c   | 93 +++++++++++++++++++++++++++++++++----------
 3 files changed, 141 insertions(+), 35 deletions(-)

diff --git a/include/net/af_unix.h b/include/net/af_unix.h
index 435a2c3d5a6f..5d04fbf8aac8 100644
--- a/include/net/af_unix.h
+++ b/include/net/af_unix.h
@@ -84,6 +84,8 @@ long unix_outq_len(struct sock *sk);
 
 int __unix_dgram_recvmsg(struct sock *sk, struct msghdr *msg, size_t size,
 			 int flags);
+int __unix_stream_recvmsg(struct sock *sk, struct msghdr *msg, size_t size,
+			  int flags);
 #ifdef CONFIG_SYSCTL
 int unix_sysctl_register(struct net *net);
 void unix_sysctl_unregister(struct net *net);
@@ -93,9 +95,11 @@ static inline void unix_sysctl_unregister(struct net *net) {}
 #endif
 
 #ifdef CONFIG_BPF_SYSCALL
-extern struct proto unix_proto;
+extern struct proto unix_dgram_proto;
+extern struct proto unix_stream_proto;
 
-int unix_bpf_update_proto(struct sock *sk, struct sk_psock *psock, bool restore);
+int unix_dgram_bpf_update_proto(struct sock *sk, struct sk_psock *psock, bool restore);
+int unix_stream_bpf_update_proto(struct sock *sk, struct sk_psock *psock, bool restore);
 void __init unix_bpf_build_proto(void);
 #else
 static inline void __init unix_bpf_build_proto(void)
diff --git a/net/unix/af_unix.c b/net/unix/af_unix.c
index c020ad0e8438..8dd7ff0b1c31 100644
--- a/net/unix/af_unix.c
+++ b/net/unix/af_unix.c
@@ -791,17 +791,35 @@ static void unix_close(struct sock *sk, long timeout)
 	 */
 }
 
-struct proto unix_proto = {
-	.name			= "UNIX",
+static void unix_unhash(struct sock *sk)
+{
+	/* Nothing to do here, unix socket does not need a ->unhash().
+	 * This is merely for sockmap.
+	 */
+}
+
+struct proto unix_dgram_proto = {
+	.name			= "UNIX-DGRAM",
+	.owner			= THIS_MODULE,
+	.obj_size		= sizeof(struct unix_sock),
+	.close			= unix_close,
+#ifdef CONFIG_BPF_SYSCALL
+	.psock_update_sk_prot	= unix_dgram_bpf_update_proto,
+#endif
+};
+
+struct proto unix_stream_proto = {
+	.name			= "UNIX-STREAM",
 	.owner			= THIS_MODULE,
 	.obj_size		= sizeof(struct unix_sock),
 	.close			= unix_close,
+	.unhash			= unix_unhash,
 #ifdef CONFIG_BPF_SYSCALL
-	.psock_update_sk_prot	= unix_bpf_update_proto,
+	.psock_update_sk_prot	= unix_stream_bpf_update_proto,
 #endif
 };
 
-static struct sock *unix_create1(struct net *net, struct socket *sock, int kern)
+static struct sock *unix_create1(struct net *net, struct socket *sock, int kern, int type)
 {
 	struct sock *sk = NULL;
 	struct unix_sock *u;
@@ -810,7 +828,11 @@ static struct sock *unix_create1(struct net *net, struct socket *sock, int kern)
 	if (atomic_long_read(&unix_nr_socks) > 2 * get_max_files())
 		goto out;
 
-	sk = sk_alloc(net, PF_UNIX, GFP_KERNEL, &unix_proto, kern);
+	if (type == SOCK_STREAM)
+		sk = sk_alloc(net, PF_UNIX, GFP_KERNEL, &unix_stream_proto, kern);
+	else /*dgram and  seqpacket */
+		sk = sk_alloc(net, PF_UNIX, GFP_KERNEL, &unix_dgram_proto, kern);
+
 	if (!sk)
 		goto out;
 
@@ -872,7 +894,7 @@ static int unix_create(struct net *net, struct socket *sock, int protocol,
 		return -ESOCKTNOSUPPORT;
 	}
 
-	return unix_create1(net, sock, kern) ? 0 : -ENOMEM;
+	return unix_create1(net, sock, kern, sock->type) ? 0 : -ENOMEM;
 }
 
 static int unix_release(struct socket *sock)
@@ -1286,7 +1308,7 @@ static int unix_stream_connect(struct socket *sock, struct sockaddr *uaddr,
 	err = -ENOMEM;
 
 	/* create new sock for complete connection */
-	newsk = unix_create1(sock_net(sk), NULL, 0);
+	newsk = unix_create1(sock_net(sk), NULL, 0, sock->type);
 	if (newsk == NULL)
 		goto out;
 
@@ -2261,7 +2283,7 @@ static int unix_dgram_recvmsg(struct socket *sock, struct msghdr *msg, size_t si
 	struct sock *sk = sock->sk;
 
 #ifdef CONFIG_BPF_SYSCALL
-	if (sk->sk_prot != &unix_proto)
+	if (READ_ONCE(sk->sk_prot) != &unix_dgram_proto)
 		return sk->sk_prot->recvmsg(sk, msg, size, flags & MSG_DONTWAIT,
 					    flags & ~MSG_DONTWAIT, NULL);
 #endif
@@ -2580,6 +2602,20 @@ static int unix_stream_read_actor(struct sk_buff *skb,
 	return ret ?: chunk;
 }
 
+int __unix_stream_recvmsg(struct sock *sk, struct msghdr *msg,
+			  size_t size, int flags)
+{
+	struct unix_stream_read_state state = {
+		.recv_actor = unix_stream_read_actor,
+		.socket = sk->sk_socket,
+		.msg = msg,
+		.size = size,
+		.flags = flags
+	};
+
+	return unix_stream_read_generic(&state, true);
+}
+
 static int unix_stream_recvmsg(struct socket *sock, struct msghdr *msg,
 			       size_t size, int flags)
 {
@@ -2591,6 +2627,12 @@ static int unix_stream_recvmsg(struct socket *sock, struct msghdr *msg,
 		.flags = flags
 	};
 
+#ifdef CONFIG_BPF_SYSCALL
+	struct sock *sk = sock->sk;
+	if (READ_ONCE(sk->sk_prot) != &unix_stream_proto)
+		return sk->sk_prot->recvmsg(sk, msg, size, flags & MSG_DONTWAIT,
+					    flags & ~MSG_DONTWAIT, NULL);
+#endif
 	return unix_stream_read_generic(&state, true);
 }
 
@@ -2652,6 +2694,8 @@ static int unix_shutdown(struct socket *sock, int mode)
 
 		int peer_mode = 0;
 
+		READ_ONCE(other->sk_prot);
+		other->sk_prot->unhash(other);
 		if (mode&RCV_SHUTDOWN)
 			peer_mode |= SEND_SHUTDOWN;
 		if (mode&SEND_SHUTDOWN)
@@ -2660,8 +2704,10 @@ static int unix_shutdown(struct socket *sock, int mode)
 		other->sk_shutdown |= peer_mode;
 		unix_state_unlock(other);
 		other->sk_state_change(other);
-		if (peer_mode == SHUTDOWN_MASK)
+		if (peer_mode == SHUTDOWN_MASK) {
 			sk_wake_async(other, SOCK_WAKE_WAITD, POLL_HUP);
+			other->sk_state = TCP_CLOSE;
+		}
 		else if (peer_mode & RCV_SHUTDOWN)
 			sk_wake_async(other, SOCK_WAKE_WAITD, POLL_IN);
 	}
@@ -3040,7 +3086,13 @@ static int __init af_unix_init(void)
 
 	BUILD_BUG_ON(sizeof(struct unix_skb_parms) > sizeof_field(struct sk_buff, cb));
 
-	rc = proto_register(&unix_proto, 1);
+	rc = proto_register(&unix_dgram_proto, 1);
+	if (rc != 0) {
+		pr_crit("%s: Cannot create unix_sock SLAB cache!\n", __func__);
+		goto out;
+	}
+
+	rc = proto_register(&unix_stream_proto, 1);
 	if (rc != 0) {
 		pr_crit("%s: Cannot create unix_sock SLAB cache!\n", __func__);
 		goto out;
@@ -3056,7 +3108,8 @@ static int __init af_unix_init(void)
 static void __exit af_unix_exit(void)
 {
 	sock_unregister(PF_UNIX);
-	proto_unregister(&unix_proto);
+	proto_unregister(&unix_dgram_proto);
+	proto_unregister(&unix_stream_proto);
 	unregister_pernet_subsys(&unix_net_ops);
 }
 
diff --git a/net/unix/unix_bpf.c b/net/unix/unix_bpf.c
index 20f53575b5c9..cbb0cdad63ba 100644
--- a/net/unix/unix_bpf.c
+++ b/net/unix/unix_bpf.c
@@ -38,9 +38,18 @@ static int unix_msg_wait_data(struct sock *sk, struct sk_psock *psock,
 	return ret;
 }
 
-static int unix_dgram_bpf_recvmsg(struct sock *sk, struct msghdr *msg,
-				  size_t len, int nonblock, int flags,
-				  int *addr_len)
+static int __unix_recvmsg(struct sock *sk, struct msghdr *msg,
+			   size_t len, int flags)
+{
+	if (sk->sk_type == SOCK_DGRAM)
+		return __unix_dgram_recvmsg(sk, msg, len, flags);
+	else
+		return __unix_stream_recvmsg(sk, msg, len, flags);
+}
+
+static int unix_bpf_recvmsg(struct sock *sk, struct msghdr *msg,
+			    size_t len, int nonblock, int flags,
+			    int *addr_len)
 {
 	struct unix_sock *u = unix_sk(sk);
 	struct sk_psock *psock;
@@ -48,14 +57,14 @@ static int unix_dgram_bpf_recvmsg(struct sock *sk, struct msghdr *msg,
 
 	psock = sk_psock_get(sk);
 	if (unlikely(!psock))
-		return __unix_dgram_recvmsg(sk, msg, len, flags);
+		return __unix_recvmsg(sk, msg, len, flags);
 
 	mutex_lock(&u->iolock);
 	if (!skb_queue_empty(&sk->sk_receive_queue) &&
 	    sk_psock_queue_empty(psock)) {
 		mutex_unlock(&u->iolock);
 		sk_psock_put(sk, psock);
-		return __unix_dgram_recvmsg(sk, msg, len, flags);
+		return __unix_recvmsg(sk, msg, len, flags);
 	}
 
 msg_bytes_ready:
@@ -71,7 +80,7 @@ static int unix_dgram_bpf_recvmsg(struct sock *sk, struct msghdr *msg,
 				goto msg_bytes_ready;
 			mutex_unlock(&u->iolock);
 			sk_psock_put(sk, psock);
-			return __unix_dgram_recvmsg(sk, msg, len, flags);
+			return __unix_recvmsg(sk, msg, len, flags);
 		}
 		copied = -EAGAIN;
 	}
@@ -80,30 +89,55 @@ static int unix_dgram_bpf_recvmsg(struct sock *sk, struct msghdr *msg,
 	return copied;
 }
 
-static struct proto *unix_prot_saved __read_mostly;
-static DEFINE_SPINLOCK(unix_prot_lock);
-static struct proto unix_bpf_prot;
+static struct proto *unix_dgram_prot_saved __read_mostly;
+static DEFINE_SPINLOCK(unix_dgram_prot_lock);
+static struct proto unix_dgram_bpf_prot;
+
+static struct proto *unix_stream_prot_saved __read_mostly;
+static DEFINE_SPINLOCK(unix_stream_prot_lock);
+static struct proto unix_stream_bpf_prot;
 
-static void unix_bpf_rebuild_protos(struct proto *prot, const struct proto *base)
+static void unix_dgram_bpf_rebuild_protos(struct proto *prot, const struct proto *base)
 {
 	*prot        = *base;
 	prot->close  = sock_map_close;
-	prot->recvmsg = unix_dgram_bpf_recvmsg;
+	prot->recvmsg = unix_bpf_recvmsg;
+}
+
+static void unix_stream_bpf_rebuild_protos(struct proto *prot,
+					   const struct proto *base)
+{
+	*prot        = *base;
+	prot->close  = sock_map_close;
+	prot->recvmsg = unix_bpf_recvmsg;
+	prot->unhash  = sock_map_unhash;
+}
+
+static void unix_dgram_bpf_check_needs_rebuild(struct proto *ops)
+{
+	if (unlikely(ops != smp_load_acquire(&unix_dgram_prot_saved))) {
+		spin_lock_bh(&unix_dgram_prot_lock);
+		if (likely(ops != unix_dgram_prot_saved)) {
+			unix_dgram_bpf_rebuild_protos(&unix_dgram_bpf_prot, ops);
+			smp_store_release(&unix_dgram_prot_saved, ops);
+		}
+		spin_unlock_bh(&unix_dgram_prot_lock);
+	}
 }
 
-static void unix_bpf_check_needs_rebuild(struct proto *ops)
+static void unix_stream_bpf_check_needs_rebuild(struct proto *ops)
 {
-	if (unlikely(ops != smp_load_acquire(&unix_prot_saved))) {
-		spin_lock_bh(&unix_prot_lock);
-		if (likely(ops != unix_prot_saved)) {
-			unix_bpf_rebuild_protos(&unix_bpf_prot, ops);
-			smp_store_release(&unix_prot_saved, ops);
+	if (unlikely(ops != smp_load_acquire(&unix_stream_prot_saved))) {
+		spin_lock_bh(&unix_stream_prot_lock);
+		if (likely(ops != unix_stream_prot_saved)) {
+			unix_stream_bpf_rebuild_protos(&unix_stream_bpf_prot, ops);
+			smp_store_release(&unix_stream_prot_saved, ops);
 		}
-		spin_unlock_bh(&unix_prot_lock);
+		spin_unlock_bh(&unix_stream_prot_lock);
 	}
 }
 
-int unix_bpf_update_proto(struct sock *sk, struct sk_psock *psock, bool restore)
+int unix_dgram_bpf_update_proto(struct sock *sk, struct sk_psock *psock, bool restore)
 {
 	if (sk->sk_type != SOCK_DGRAM)
 		return -EOPNOTSUPP;
@@ -114,12 +148,27 @@ int unix_bpf_update_proto(struct sock *sk, struct sk_psock *psock, bool restore)
 		return 0;
 	}
 
-	unix_bpf_check_needs_rebuild(psock->sk_proto);
-	WRITE_ONCE(sk->sk_prot, &unix_bpf_prot);
+	unix_dgram_bpf_check_needs_rebuild(psock->sk_proto);
+	WRITE_ONCE(sk->sk_prot, &unix_dgram_bpf_prot);
+	return 0;
+}
+
+int unix_stream_bpf_update_proto(struct sock *sk, struct sk_psock *psock, bool restore)
+{
+	if (restore) {
+		sk->sk_write_space = psock->saved_write_space;
+		WRITE_ONCE(sk->sk_prot, psock->sk_proto);
+		return 0;
+	}
+
+	unix_stream_bpf_check_needs_rebuild(psock->sk_proto);
+	WRITE_ONCE(sk->sk_prot, &unix_stream_bpf_prot);
 	return 0;
 }
 
 void __init unix_bpf_build_proto(void)
 {
-	unix_bpf_rebuild_protos(&unix_bpf_prot, &unix_proto);
+	unix_dgram_bpf_rebuild_protos(&unix_dgram_bpf_prot, &unix_dgram_proto);
+	unix_stream_bpf_rebuild_protos(&unix_stream_bpf_prot, &unix_stream_proto);
+
 }
-- 
2.20.1

