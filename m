Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7BF486CAE4D
	for <lists+netdev@lfdr.de>; Mon, 27 Mar 2023 21:13:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232847AbjC0TNL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Mar 2023 15:13:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34450 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232730AbjC0TMs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Mar 2023 15:12:48 -0400
Received: from mail-qt1-x82f.google.com (mail-qt1-x82f.google.com [IPv6:2607:f8b0:4864:20::82f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F86E2120
        for <netdev@vger.kernel.org>; Mon, 27 Mar 2023 12:11:55 -0700 (PDT)
Received: by mail-qt1-x82f.google.com with SMTP id ga7so9657052qtb.2
        for <netdev@vger.kernel.org>; Mon, 27 Mar 2023 12:11:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1679944314;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=S7E9eRcSCLzdTAiji7pdc0DuBlF56s7eyY//klMw3tw=;
        b=d3eN6OSJuaVX6CcBZqY1aT3ZOcXwvSw17gTVbVUb/6buh/zJJ9cMCdo26BFC6wjl1b
         xqfE2s6dpUYipxmnYTaYaLiZXXxEhIDR+1nTxFujOUQR1PsvLkwR9kZcEkmcerwsMaUH
         bmwfx0bGnG+I4sTTaa49SUutDN+LPoApuN5Q7MKr1uMYlrsFZ1Tu2N+8gZv4C+WAwh73
         NjxiXMyw4Z3IbTuXvauKNRS0TzdpTVTAu3Nfrssi/4Hy2TwpUJij1+odzb9QzZAp21S+
         n9WcgZL+aHtQwBgjvEXpAgz/LTmAju3PX+ZFiS/cemMIiadmYb+UfsUyUJLRcHo8RpoK
         g13w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679944314;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=S7E9eRcSCLzdTAiji7pdc0DuBlF56s7eyY//klMw3tw=;
        b=Qgk8wr66U8YyIiP7VcdW+I7PmeW/JIPq+7CcEs5csQSLfkge7dikpqQWfpP51R8OtQ
         HzsNu+VUIrfdNXdghIHnfbbNAUOeg/jBPwFHszkqsYoqBWwAAbH8RnNElSfJsS84f3YU
         Rcszc/6BgyCGrLoL8xFgOVqcmC0xIV7uhAF29DgEXsZTD4+L4T0wrtsjVWa+nLHqsUZH
         1VzLFcANcGoDjT30DyVtoaMzgaUM2Ew+QedgkHiY/8BNxujA5w5xk8OpbcbVVVVj9WRZ
         FZtrq6cYCul5k9MrMvvtH9cyG4eP5SrYZ9LUzas7cI5lk7FLxwcXSll5gedgbF73i4ly
         gAZg==
X-Gm-Message-State: AO0yUKXkZKlxs8OUn50JkUIa4zJhFAwfUI3xWFjew7vDRzMTOnNTP9qW
        mlt240aiNyI/9GJCOexsy5E3rg==
X-Google-Smtp-Source: AK7set8TqWWZdzdukJFkEeB4pIRLk59auh4IPSUzMCmPS2Y6mDrPMbVemdA7q32SnFo3mz2rASll3A==
X-Received: by 2002:a05:622a:1a8e:b0:3bf:9f6e:a383 with SMTP id s14-20020a05622a1a8e00b003bf9f6ea383mr22944122qtc.20.1679944314237;
        Mon, 27 Mar 2023 12:11:54 -0700 (PDT)
Received: from [172.17.0.3] ([130.44.215.126])
        by smtp.gmail.com with ESMTPSA id d185-20020a37b4c2000000b007425ef4cbc2sm16989236qkf.100.2023.03.27.12.11.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Mar 2023 12:11:53 -0700 (PDT)
From:   Bobby Eshleman <bobby.eshleman@bytedance.com>
Date:   Mon, 27 Mar 2023 19:11:51 +0000
Subject: [PATCH net-next v4 1/3] vsock: support sockmap
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20230327-vsock-sockmap-v4-1-c62b7cd92a85@bytedance.com>
References: <20230327-vsock-sockmap-v4-0-c62b7cd92a85@bytedance.com>
In-Reply-To: <20230327-vsock-sockmap-v4-0-c62b7cd92a85@bytedance.com>
To:     Stefan Hajnoczi <stefanha@redhat.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        Mykola Lysenko <mykolal@fb.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <martin.lau@linux.dev>,
        Song Liu <song@kernel.org>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Stanislav Fomichev <sdf@google.com>,
        Hao Luo <haoluo@google.com>, Jiri Olsa <jolsa@kernel.org>,
        Shuah Khan <shuah@kernel.org>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org, linux-kselftest@vger.kernel.org,
        Bobby Eshleman <bobby.eshleman@bytedance.com>
X-Mailer: b4 0.12.2
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch adds sockmap support for vsock sockets. It is intended to be
usable by all transports, but only the virtio and loopback transports
are implemented.

SOCK_STREAM, SOCK_DGRAM, and SOCK_SEQPACKET are all supported.

Signed-off-by: Bobby Eshleman <bobby.eshleman@bytedance.com>
Acked-by: Michael S. Tsirkin <mst@redhat.com>
---
 drivers/vhost/vsock.c                   |   1 +
 include/linux/virtio_vsock.h            |   1 +
 include/net/af_vsock.h                  |  17 ++++
 net/vmw_vsock/Makefile                  |   1 +
 net/vmw_vsock/af_vsock.c                |  64 ++++++++++--
 net/vmw_vsock/virtio_transport.c        |   2 +
 net/vmw_vsock/virtio_transport_common.c |  25 +++++
 net/vmw_vsock/vsock_bpf.c               | 174 ++++++++++++++++++++++++++++++++
 net/vmw_vsock/vsock_loopback.c          |   2 +
 9 files changed, 281 insertions(+), 6 deletions(-)

diff --git a/drivers/vhost/vsock.c b/drivers/vhost/vsock.c
index c8e6087769a1..6578db78f0ae 100644
--- a/drivers/vhost/vsock.c
+++ b/drivers/vhost/vsock.c
@@ -439,6 +439,7 @@ static struct virtio_transport vhost_transport = {
 		.notify_send_post_enqueue = virtio_transport_notify_send_post_enqueue,
 		.notify_buffer_size       = virtio_transport_notify_buffer_size,
 
+		.read_skb = virtio_transport_read_skb,
 	},
 
 	.send_pkt = vhost_transport_send_pkt,
diff --git a/include/linux/virtio_vsock.h b/include/linux/virtio_vsock.h
index 3f9c16611306..c58453699ee9 100644
--- a/include/linux/virtio_vsock.h
+++ b/include/linux/virtio_vsock.h
@@ -245,4 +245,5 @@ u32 virtio_transport_get_credit(struct virtio_vsock_sock *vvs, u32 wanted);
 void virtio_transport_put_credit(struct virtio_vsock_sock *vvs, u32 credit);
 void virtio_transport_deliver_tap_pkt(struct sk_buff *skb);
 int virtio_transport_purge_skbs(void *vsk, struct sk_buff_head *list);
+int virtio_transport_read_skb(struct vsock_sock *vsk, skb_read_actor_t read_actor);
 #endif /* _LINUX_VIRTIO_VSOCK_H */
diff --git a/include/net/af_vsock.h b/include/net/af_vsock.h
index 568a87c5e0d0..0e7504a42925 100644
--- a/include/net/af_vsock.h
+++ b/include/net/af_vsock.h
@@ -75,6 +75,7 @@ struct vsock_sock {
 	void *trans;
 };
 
+s64 vsock_connectible_has_data(struct vsock_sock *vsk);
 s64 vsock_stream_has_data(struct vsock_sock *vsk);
 s64 vsock_stream_has_space(struct vsock_sock *vsk);
 struct sock *vsock_create_connected(struct sock *parent);
@@ -173,6 +174,9 @@ struct vsock_transport {
 
 	/* Addressing. */
 	u32 (*get_local_cid)(void);
+
+	/* Read a single skb */
+	int (*read_skb)(struct vsock_sock *, skb_read_actor_t);
 };
 
 /**** CORE ****/
@@ -225,5 +229,18 @@ int vsock_init_tap(void);
 int vsock_add_tap(struct vsock_tap *vt);
 int vsock_remove_tap(struct vsock_tap *vt);
 void vsock_deliver_tap(struct sk_buff *build_skb(void *opaque), void *opaque);
+int vsock_connectible_recvmsg(struct socket *sock, struct msghdr *msg, size_t len,
+			      int flags);
+int vsock_dgram_recvmsg(struct socket *sock, struct msghdr *msg,
+			size_t len, int flags);
+
+#ifdef CONFIG_BPF_SYSCALL
+extern struct proto vsock_proto;
+int vsock_bpf_update_proto(struct sock *sk, struct sk_psock *psock, bool restore);
+void __init vsock_bpf_build_proto(void);
+#else
+static inline void __init vsock_bpf_build_proto(void)
+{}
+#endif
 
 #endif /* __AF_VSOCK_H__ */
diff --git a/net/vmw_vsock/Makefile b/net/vmw_vsock/Makefile
index 6a943ec95c4a..5da74c4a9f1d 100644
--- a/net/vmw_vsock/Makefile
+++ b/net/vmw_vsock/Makefile
@@ -8,6 +8,7 @@ obj-$(CONFIG_HYPERV_VSOCKETS) += hv_sock.o
 obj-$(CONFIG_VSOCKETS_LOOPBACK) += vsock_loopback.o
 
 vsock-y += af_vsock.o af_vsock_tap.o vsock_addr.o
+vsock-$(CONFIG_BPF_SYSCALL) += vsock_bpf.o
 
 vsock_diag-y += diag.o
 
diff --git a/net/vmw_vsock/af_vsock.c b/net/vmw_vsock/af_vsock.c
index 19aea7cba26e..5f2dda35c980 100644
--- a/net/vmw_vsock/af_vsock.c
+++ b/net/vmw_vsock/af_vsock.c
@@ -116,10 +116,13 @@ static void vsock_sk_destruct(struct sock *sk);
 static int vsock_queue_rcv_skb(struct sock *sk, struct sk_buff *skb);
 
 /* Protocol family. */
-static struct proto vsock_proto = {
+struct proto vsock_proto = {
 	.name = "AF_VSOCK",
 	.owner = THIS_MODULE,
 	.obj_size = sizeof(struct vsock_sock),
+#ifdef CONFIG_BPF_SYSCALL
+	.psock_update_sk_prot = vsock_bpf_update_proto,
+#endif
 };
 
 /* The default peer timeout indicates how long we will wait for a peer response
@@ -865,7 +868,7 @@ s64 vsock_stream_has_data(struct vsock_sock *vsk)
 }
 EXPORT_SYMBOL_GPL(vsock_stream_has_data);
 
-static s64 vsock_connectible_has_data(struct vsock_sock *vsk)
+s64 vsock_connectible_has_data(struct vsock_sock *vsk)
 {
 	struct sock *sk = sk_vsock(vsk);
 
@@ -874,6 +877,7 @@ static s64 vsock_connectible_has_data(struct vsock_sock *vsk)
 	else
 		return vsock_stream_has_data(vsk);
 }
+EXPORT_SYMBOL_GPL(vsock_connectible_has_data);
 
 s64 vsock_stream_has_space(struct vsock_sock *vsk)
 {
@@ -1131,6 +1135,13 @@ static __poll_t vsock_poll(struct file *file, struct socket *sock,
 	return mask;
 }
 
+static int vsock_read_skb(struct sock *sk, skb_read_actor_t read_actor)
+{
+	struct vsock_sock *vsk = vsock_sk(sk);
+
+	return vsk->transport->read_skb(vsk, read_actor);
+}
+
 static int vsock_dgram_sendmsg(struct socket *sock, struct msghdr *msg,
 			       size_t len)
 {
@@ -1242,18 +1253,42 @@ static int vsock_dgram_connect(struct socket *sock,
 	memcpy(&vsk->remote_addr, remote_addr, sizeof(vsk->remote_addr));
 	sock->state = SS_CONNECTED;
 
+	/* sock map disallows redirection of non-TCP sockets with sk_state !=
+	 * TCP_ESTABLISHED (see sock_map_redirect_allowed()), so we set
+	 * TCP_ESTABLISHED here to allow redirection of connected vsock dgrams.
+	 *
+	 * This doesn't seem to be abnormal state for datagram sockets, as the
+	 * same approach can be see in other datagram socket types as well
+	 * (such as unix sockets).
+	 */
+	sk->sk_state = TCP_ESTABLISHED;
+
 out:
 	release_sock(sk);
 	return err;
 }
 
-static int vsock_dgram_recvmsg(struct socket *sock, struct msghdr *msg,
-			       size_t len, int flags)
+int vsock_dgram_recvmsg(struct socket *sock, struct msghdr *msg,
+			size_t len, int flags)
 {
-	struct vsock_sock *vsk = vsock_sk(sock->sk);
+#ifdef CONFIG_BPF_SYSCALL
+	const struct proto *prot;
+#endif
+	struct vsock_sock *vsk;
+	struct sock *sk;
+
+	sk = sock->sk;
+	vsk = vsock_sk(sk);
+
+#ifdef CONFIG_BPF_SYSCALL
+	prot = READ_ONCE(sk->sk_prot);
+	if (prot != &vsock_proto)
+		return prot->recvmsg(sk, msg, len, flags, NULL);
+#endif
 
 	return vsk->transport->dgram_dequeue(vsk, msg, len, flags);
 }
+EXPORT_SYMBOL_GPL(vsock_dgram_recvmsg);
 
 static const struct proto_ops vsock_dgram_ops = {
 	.family = PF_VSOCK,
@@ -1272,6 +1307,7 @@ static const struct proto_ops vsock_dgram_ops = {
 	.recvmsg = vsock_dgram_recvmsg,
 	.mmap = sock_no_mmap,
 	.sendpage = sock_no_sendpage,
+	.read_skb = vsock_read_skb,
 };
 
 static int vsock_transport_cancel_pkt(struct vsock_sock *vsk)
@@ -2086,13 +2122,16 @@ static int __vsock_seqpacket_recvmsg(struct sock *sk, struct msghdr *msg,
 	return err;
 }
 
-static int
+int
 vsock_connectible_recvmsg(struct socket *sock, struct msghdr *msg, size_t len,
 			  int flags)
 {
 	struct sock *sk;
 	struct vsock_sock *vsk;
 	const struct vsock_transport *transport;
+#ifdef CONFIG_BPF_SYSCALL
+	const struct proto *prot;
+#endif
 	int err;
 
 	sk = sock->sk;
@@ -2139,6 +2178,14 @@ vsock_connectible_recvmsg(struct socket *sock, struct msghdr *msg, size_t len,
 		goto out;
 	}
 
+#ifdef CONFIG_BPF_SYSCALL
+	prot = READ_ONCE(sk->sk_prot);
+	if (prot != &vsock_proto) {
+		release_sock(sk);
+		return prot->recvmsg(sk, msg, len, flags, NULL);
+	}
+#endif
+
 	if (sk->sk_type == SOCK_STREAM)
 		err = __vsock_stream_recvmsg(sk, msg, len, flags);
 	else
@@ -2148,6 +2195,7 @@ vsock_connectible_recvmsg(struct socket *sock, struct msghdr *msg, size_t len,
 	release_sock(sk);
 	return err;
 }
+EXPORT_SYMBOL_GPL(vsock_connectible_recvmsg);
 
 static int vsock_set_rcvlowat(struct sock *sk, int val)
 {
@@ -2188,6 +2236,7 @@ static const struct proto_ops vsock_stream_ops = {
 	.mmap = sock_no_mmap,
 	.sendpage = sock_no_sendpage,
 	.set_rcvlowat = vsock_set_rcvlowat,
+	.read_skb = vsock_read_skb,
 };
 
 static const struct proto_ops vsock_seqpacket_ops = {
@@ -2209,6 +2258,7 @@ static const struct proto_ops vsock_seqpacket_ops = {
 	.recvmsg = vsock_connectible_recvmsg,
 	.mmap = sock_no_mmap,
 	.sendpage = sock_no_sendpage,
+	.read_skb = vsock_read_skb,
 };
 
 static int vsock_create(struct net *net, struct socket *sock,
@@ -2348,6 +2398,8 @@ static int __init vsock_init(void)
 		goto err_unregister_proto;
 	}
 
+	vsock_bpf_build_proto();
+
 	return 0;
 
 err_unregister_proto:
diff --git a/net/vmw_vsock/virtio_transport.c b/net/vmw_vsock/virtio_transport.c
index 28b5a8e8e094..e95df847176b 100644
--- a/net/vmw_vsock/virtio_transport.c
+++ b/net/vmw_vsock/virtio_transport.c
@@ -457,6 +457,8 @@ static struct virtio_transport virtio_transport = {
 		.notify_send_pre_enqueue  = virtio_transport_notify_send_pre_enqueue,
 		.notify_send_post_enqueue = virtio_transport_notify_send_post_enqueue,
 		.notify_buffer_size       = virtio_transport_notify_buffer_size,
+
+		.read_skb = virtio_transport_read_skb,
 	},
 
 	.send_pkt = virtio_transport_send_pkt,
diff --git a/net/vmw_vsock/virtio_transport_common.c b/net/vmw_vsock/virtio_transport_common.c
index 957cdc01c8e8..cb0748dc281b 100644
--- a/net/vmw_vsock/virtio_transport_common.c
+++ b/net/vmw_vsock/virtio_transport_common.c
@@ -1383,6 +1383,31 @@ int virtio_transport_purge_skbs(void *vsk, struct sk_buff_head *queue)
 }
 EXPORT_SYMBOL_GPL(virtio_transport_purge_skbs);
 
+int virtio_transport_read_skb(struct vsock_sock *vsk, skb_read_actor_t recv_actor)
+{
+	struct virtio_vsock_sock *vvs = vsk->trans;
+	struct sock *sk = sk_vsock(vsk);
+	struct sk_buff *skb;
+	int off = 0;
+	int copied;
+	int err;
+
+	spin_lock_bh(&vvs->rx_lock);
+	/* Use __skb_recv_datagram() for race-free handling of the receive. It
+	 * works for types other than dgrams.
+	 */
+	skb = __skb_recv_datagram(sk, &vvs->rx_queue, MSG_DONTWAIT, &off, &err);
+	spin_unlock_bh(&vvs->rx_lock);
+
+	if (!skb)
+		return err;
+
+	copied = recv_actor(sk, skb);
+	kfree_skb(skb);
+	return copied;
+}
+EXPORT_SYMBOL_GPL(virtio_transport_read_skb);
+
 MODULE_LICENSE("GPL v2");
 MODULE_AUTHOR("Asias He");
 MODULE_DESCRIPTION("common code for virtio vsock");
diff --git a/net/vmw_vsock/vsock_bpf.c b/net/vmw_vsock/vsock_bpf.c
new file mode 100644
index 000000000000..a3c97546ab84
--- /dev/null
+++ b/net/vmw_vsock/vsock_bpf.c
@@ -0,0 +1,174 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Copyright (c) 2022 Bobby Eshleman <bobby.eshleman@bytedance.com>
+ *
+ * Based off of net/unix/unix_bpf.c
+ */
+
+#include <linux/bpf.h>
+#include <linux/module.h>
+#include <linux/skmsg.h>
+#include <linux/socket.h>
+#include <linux/wait.h>
+#include <net/af_vsock.h>
+#include <net/sock.h>
+
+#define vsock_sk_has_data(__sk, __psock)				\
+		({	!skb_queue_empty(&(__sk)->sk_receive_queue) ||	\
+			!skb_queue_empty(&(__psock)->ingress_skb) ||	\
+			!list_empty(&(__psock)->ingress_msg);		\
+		})
+
+static struct proto *vsock_prot_saved __read_mostly;
+static DEFINE_SPINLOCK(vsock_prot_lock);
+static struct proto vsock_bpf_prot;
+
+static bool vsock_has_data(struct sock *sk, struct sk_psock *psock)
+{
+	struct vsock_sock *vsk = vsock_sk(sk);
+	s64 ret;
+
+	ret = vsock_connectible_has_data(vsk);
+	if (ret > 0)
+		return true;
+
+	return vsock_sk_has_data(sk, psock);
+}
+
+static bool vsock_msg_wait_data(struct sock *sk, struct sk_psock *psock, long timeo)
+{
+	bool ret;
+
+	DEFINE_WAIT_FUNC(wait, woken_wake_function);
+
+	if (sk->sk_shutdown & RCV_SHUTDOWN)
+		return true;
+
+	if (!timeo)
+		return false;
+
+	add_wait_queue(sk_sleep(sk), &wait);
+	sk_set_bit(SOCKWQ_ASYNC_WAITDATA, sk);
+	ret = vsock_has_data(sk, psock);
+	if (!ret) {
+		wait_woken(&wait, TASK_INTERRUPTIBLE, timeo);
+		ret = vsock_has_data(sk, psock);
+	}
+	sk_clear_bit(SOCKWQ_ASYNC_WAITDATA, sk);
+	remove_wait_queue(sk_sleep(sk), &wait);
+	return ret;
+}
+
+static int __vsock_recvmsg(struct sock *sk, struct msghdr *msg, size_t len, int flags)
+{
+	struct socket *sock = sk->sk_socket;
+	int err;
+
+	if (sk->sk_type == SOCK_STREAM || sk->sk_type == SOCK_SEQPACKET)
+		err = vsock_connectible_recvmsg(sock, msg, len, flags);
+	else if (sk->sk_type == SOCK_DGRAM)
+		err = vsock_dgram_recvmsg(sock, msg, len, flags);
+	else
+		err = -EPROTOTYPE;
+
+	return err;
+}
+
+static int vsock_bpf_recvmsg(struct sock *sk, struct msghdr *msg,
+			     size_t len, int flags, int *addr_len)
+{
+	struct sk_psock *psock;
+	int copied;
+
+	psock = sk_psock_get(sk);
+	if (unlikely(!psock))
+		return __vsock_recvmsg(sk, msg, len, flags);
+
+	lock_sock(sk);
+	if (vsock_has_data(sk, psock) && sk_psock_queue_empty(psock)) {
+		release_sock(sk);
+		sk_psock_put(sk, psock);
+		return __vsock_recvmsg(sk, msg, len, flags);
+	}
+
+	copied = sk_msg_recvmsg(sk, psock, msg, len, flags);
+	while (copied == 0) {
+		long timeo = sock_rcvtimeo(sk, flags & MSG_DONTWAIT);
+
+		if (!vsock_msg_wait_data(sk, psock, timeo)) {
+			copied = -EAGAIN;
+			break;
+		}
+
+		if (sk_psock_queue_empty(psock)) {
+			release_sock(sk);
+			sk_psock_put(sk, psock);
+			return __vsock_recvmsg(sk, msg, len, flags);
+		}
+
+		copied = sk_msg_recvmsg(sk, psock, msg, len, flags);
+	}
+
+	release_sock(sk);
+	sk_psock_put(sk, psock);
+
+	return copied;
+}
+
+/* Copy of original proto with updated sock_map methods */
+static struct proto vsock_bpf_prot = {
+	.close = sock_map_close,
+	.recvmsg = vsock_bpf_recvmsg,
+	.sock_is_readable = sk_msg_is_readable,
+	.unhash = sock_map_unhash,
+};
+
+static void vsock_bpf_rebuild_protos(struct proto *prot, const struct proto *base)
+{
+	*prot        = *base;
+	prot->close  = sock_map_close;
+	prot->recvmsg = vsock_bpf_recvmsg;
+	prot->sock_is_readable = sk_msg_is_readable;
+}
+
+static void vsock_bpf_check_needs_rebuild(struct proto *ops)
+{
+	/* Paired with the smp_store_release() below. */
+	if (unlikely(ops != smp_load_acquire(&vsock_prot_saved))) {
+		spin_lock_bh(&vsock_prot_lock);
+		if (likely(ops != vsock_prot_saved)) {
+			vsock_bpf_rebuild_protos(&vsock_bpf_prot, ops);
+			/* Make sure proto function pointers are updated before publishing the
+			 * pointer to the struct.
+			 */
+			smp_store_release(&vsock_prot_saved, ops);
+		}
+		spin_unlock_bh(&vsock_prot_lock);
+	}
+}
+
+int vsock_bpf_update_proto(struct sock *sk, struct sk_psock *psock, bool restore)
+{
+	struct vsock_sock *vsk;
+
+	if (restore) {
+		sk->sk_write_space = psock->saved_write_space;
+		sock_replace_proto(sk, psock->sk_proto);
+		return 0;
+	}
+
+	vsk = vsock_sk(sk);
+	if (!vsk->transport)
+		return -ENODEV;
+
+	if (!vsk->transport->read_skb)
+		return -EOPNOTSUPP;
+
+	vsock_bpf_check_needs_rebuild(psock->sk_proto);
+	sock_replace_proto(sk, &vsock_bpf_prot);
+	return 0;
+}
+
+void __init vsock_bpf_build_proto(void)
+{
+	vsock_bpf_rebuild_protos(&vsock_bpf_prot, &vsock_proto);
+}
diff --git a/net/vmw_vsock/vsock_loopback.c b/net/vmw_vsock/vsock_loopback.c
index 671e03240fc5..40753b661c13 100644
--- a/net/vmw_vsock/vsock_loopback.c
+++ b/net/vmw_vsock/vsock_loopback.c
@@ -94,6 +94,8 @@ static struct virtio_transport loopback_transport = {
 		.notify_send_pre_enqueue  = virtio_transport_notify_send_pre_enqueue,
 		.notify_send_post_enqueue = virtio_transport_notify_send_post_enqueue,
 		.notify_buffer_size       = virtio_transport_notify_buffer_size,
+
+		.read_skb = virtio_transport_read_skb,
 	},
 
 	.send_pkt = vsock_loopback_send_pkt,

-- 
2.30.2

