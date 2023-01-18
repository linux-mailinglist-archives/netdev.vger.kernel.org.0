Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A9C57672952
	for <lists+netdev@lfdr.de>; Wed, 18 Jan 2023 21:30:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230038AbjARUaF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Jan 2023 15:30:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36418 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230116AbjARU3x (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Jan 2023 15:29:53 -0500
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 07DD359551
        for <netdev@vger.kernel.org>; Wed, 18 Jan 2023 12:29:25 -0800 (PST)
Received: by mail-pj1-x102e.google.com with SMTP id v10-20020a17090abb8a00b00229c517a6eeso3643867pjr.5
        for <netdev@vger.kernel.org>; Wed, 18 Jan 2023 12:29:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20210112.gappssmtp.com; s=20210112;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Lq7eoWcP1Bqz5Hmg1IjmuHVsG4Vd15X6JCRiloyT4Z8=;
        b=S61C0XuE3H40q55osbUFcZgQrJnG5PFV4iy4OnYCQ3yxKLvsU4qtrwcQ9jUX0Exph4
         vLosugYKAd6Q5BXtOolVOJCEbv7QVQOQ8P9HC3C5AVugxi3QLuBGmx53SqsKGF1fCZRV
         7E6mlguGHlGg0PWvNaWTGu/6WxXvBTg/wxEWQB5n8+az63Ou97e6/PVTqVuVOSEGxOjG
         iPSxC8EVLkhZHydJZ4wNeExWSphZFewSroCxxHPjuFn4bp8HkUhn89Sj5NzIReh++XUR
         9MOFBdP2xFoVmZ+Pw4VZweqA6MvcS8PDTqa6hZFjKxCgmxM+5PlHbZauJvedxAsoLPvh
         X4IQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Lq7eoWcP1Bqz5Hmg1IjmuHVsG4Vd15X6JCRiloyT4Z8=;
        b=Z3CzBF40ADSuP02GSBwJV3+EZP5uplFs/IsT3pt+Siqh8azv2wClr2pQl5Rzj5FMIR
         NwUPsvTAvLao8S+txsbZcoVmmjdZU/FZOtA8C9yOq/9GC3z6RtTUA2SAvjvU1T9l2EFu
         pXgVTmEuTfRGK/vjqV5nlsknqfhYWK0c/dCXKl5FZCqqr/a4O/e4BEMGXw6x+jwh16lM
         acoNzSPmmgfc6GjKTYn+EVDnGfn3YT34RubdwlIdrtPNhwdoeBM8XjuODbd0hO8URFQq
         jBanvVmZprEuTRCcVFnHvZ8Zp47ZI/jPA+DyA+GFhJiMHcV2Z4AflMynZYktTvTFOofM
         JT5w==
X-Gm-Message-State: AFqh2kohrJpYZ+Slv+owlqSadUkoGGRCwWBUSOAm3dORvA5AsoUb9spi
        icRbrwQZrpsB4d2dbNmju1pm7w==
X-Google-Smtp-Source: AMrXdXtZ+0HOEgB6gqv4eQNR6kDH390b85FSCx2kY9YdNA+VJJqhtQLZ66sYrnKmr/p9tMUlAmN00Q==
X-Received: by 2002:a17:90a:6a46:b0:219:158d:61c2 with SMTP id d6-20020a17090a6a4600b00219158d61c2mr8749503pjm.19.1674073764501;
        Wed, 18 Jan 2023 12:29:24 -0800 (PST)
Received: from [127.0.1.1] (c-73-164-155-12.hsd1.wa.comcast.net. [73.164.155.12])
        by smtp.gmail.com with ESMTPSA id t13-20020a17090a3b4d00b002132f3e71c6sm1724948pjf.52.2023.01.18.12.29.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Jan 2023 12:29:24 -0800 (PST)
From:   Bobby Eshleman <bobby.eshleman@bytedance.com>
Date:   Wed, 18 Jan 2023 12:27:39 -0800
Subject: [PATCH RFC 1/3] vsock: support sockmap
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20230118-support-vsock-sockmap-connectible-v1-1-d47e6294827b@bytedance.com>
References: <20230118-support-vsock-sockmap-connectible-v1-0-d47e6294827b@bytedance.com>
In-Reply-To: <20230118-support-vsock-sockmap-connectible-v1-0-d47e6294827b@bytedance.com>
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
        Bobby Eshleman <bobby.eshleman@bytedance.com>,
        Cong Wang <cong.wang@bytedance.com>
X-Mailer: b4 0.11.2
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch adds sockmap support for vsock sockets. It is intended to be
usable by all transports, but only the virtio transport is implemented.

Signed-off-by: Bobby Eshleman <bobby.eshleman@bytedance.com>
---
 drivers/vhost/vsock.c                   |   1 +
 include/linux/virtio_vsock.h            |   1 +
 include/net/af_vsock.h                  |  17 +++
 net/vmw_vsock/Makefile                  |   1 +
 net/vmw_vsock/af_vsock.c                |  59 +++++++++--
 net/vmw_vsock/virtio_transport.c        |   2 +
 net/vmw_vsock/virtio_transport_common.c |  22 ++++
 net/vmw_vsock/vsock_bpf.c               | 180 ++++++++++++++++++++++++++++++++
 net/vmw_vsock/vsock_loopback.c          |   2 +
 9 files changed, 279 insertions(+), 6 deletions(-)

diff --git a/drivers/vhost/vsock.c b/drivers/vhost/vsock.c
index 1f3b89c885cca..3c6dc036b9044 100644
--- a/drivers/vhost/vsock.c
+++ b/drivers/vhost/vsock.c
@@ -439,6 +439,7 @@ static struct virtio_transport vhost_transport = {
 		.notify_send_post_enqueue = virtio_transport_notify_send_post_enqueue,
 		.notify_buffer_size       = virtio_transport_notify_buffer_size,
 
+		.read_skb = virtio_transport_read_skb,
 	},
 
 	.send_pkt = vhost_transport_send_pkt,
diff --git a/include/linux/virtio_vsock.h b/include/linux/virtio_vsock.h
index 3f9c166113063..c58453699ee98 100644
--- a/include/linux/virtio_vsock.h
+++ b/include/linux/virtio_vsock.h
@@ -245,4 +245,5 @@ u32 virtio_transport_get_credit(struct virtio_vsock_sock *vvs, u32 wanted);
 void virtio_transport_put_credit(struct virtio_vsock_sock *vvs, u32 credit);
 void virtio_transport_deliver_tap_pkt(struct sk_buff *skb);
 int virtio_transport_purge_skbs(void *vsk, struct sk_buff_head *list);
+int virtio_transport_read_skb(struct vsock_sock *vsk, skb_read_actor_t read_actor);
 #endif /* _LINUX_VIRTIO_VSOCK_H */
diff --git a/include/net/af_vsock.h b/include/net/af_vsock.h
index 568a87c5e0d0f..a73f5fbd296af 100644
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
+			       size_t len, int flags);
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
index 6a943ec95c4a5..5da74c4a9f1d1 100644
--- a/net/vmw_vsock/Makefile
+++ b/net/vmw_vsock/Makefile
@@ -8,6 +8,7 @@ obj-$(CONFIG_HYPERV_VSOCKETS) += hv_sock.o
 obj-$(CONFIG_VSOCKETS_LOOPBACK) += vsock_loopback.o
 
 vsock-y += af_vsock.o af_vsock_tap.o vsock_addr.o
+vsock-$(CONFIG_BPF_SYSCALL) += vsock_bpf.o
 
 vsock_diag-y += diag.o
 
diff --git a/net/vmw_vsock/af_vsock.c b/net/vmw_vsock/af_vsock.c
index d593d5b6d4b15..7081b3a992c1e 100644
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
@@ -1131,6 +1135,19 @@ static __poll_t vsock_poll(struct file *file, struct socket *sock,
 	return mask;
 }
 
+static int vsock_read_skb(struct sock *sk, skb_read_actor_t read_actor)
+{
+	struct vsock_sock *vsk = vsock_sk(sk);
+
+	if (!vsk->transport)
+		return -ENODEV;
+
+	if (!vsk->transport->read_skb)
+		return -EOPNOTSUPP;
+
+	return vsk->transport->read_skb(vsk, read_actor);
+}
+
 static int vsock_dgram_sendmsg(struct socket *sock, struct msghdr *msg,
 			       size_t len)
 {
@@ -1241,19 +1258,32 @@ static int vsock_dgram_connect(struct socket *sock,
 
 	memcpy(&vsk->remote_addr, remote_addr, sizeof(vsk->remote_addr));
 	sock->state = SS_CONNECTED;
+	sk->sk_state = TCP_ESTABLISHED;
 
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
+	const struct proto *prot;
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
@@ -1272,6 +1302,7 @@ static const struct proto_ops vsock_dgram_ops = {
 	.recvmsg = vsock_dgram_recvmsg,
 	.mmap = sock_no_mmap,
 	.sendpage = sock_no_sendpage,
+	.read_skb = vsock_read_skb,
 };
 
 static int vsock_transport_cancel_pkt(struct vsock_sock *vsk)
@@ -2085,13 +2116,16 @@ static int __vsock_seqpacket_recvmsg(struct sock *sk, struct msghdr *msg,
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
@@ -2138,6 +2172,14 @@ vsock_connectible_recvmsg(struct socket *sock, struct msghdr *msg, size_t len,
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
@@ -2147,6 +2189,7 @@ vsock_connectible_recvmsg(struct socket *sock, struct msghdr *msg, size_t len,
 	release_sock(sk);
 	return err;
 }
+EXPORT_SYMBOL_GPL(vsock_connectible_recvmsg);
 
 static int vsock_set_rcvlowat(struct sock *sk, int val)
 {
@@ -2187,6 +2230,7 @@ static const struct proto_ops vsock_stream_ops = {
 	.mmap = sock_no_mmap,
 	.sendpage = sock_no_sendpage,
 	.set_rcvlowat = vsock_set_rcvlowat,
+	.read_skb = vsock_read_skb,
 };
 
 static const struct proto_ops vsock_seqpacket_ops = {
@@ -2208,6 +2252,7 @@ static const struct proto_ops vsock_seqpacket_ops = {
 	.recvmsg = vsock_connectible_recvmsg,
 	.mmap = sock_no_mmap,
 	.sendpage = sock_no_sendpage,
+	.read_skb = vsock_read_skb,
 };
 
 static int vsock_create(struct net *net, struct socket *sock,
@@ -2347,6 +2392,8 @@ static int __init vsock_init(void)
 		goto err_unregister_proto;
 	}
 
+	vsock_bpf_build_proto();
+
 	return 0;
 
 err_unregister_proto:
diff --git a/net/vmw_vsock/virtio_transport.c b/net/vmw_vsock/virtio_transport.c
index 28b5a8e8e0948..e95df847176b6 100644
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
index a1581c77cf84a..9a87ead5b1fc5 100644
--- a/net/vmw_vsock/virtio_transport_common.c
+++ b/net/vmw_vsock/virtio_transport_common.c
@@ -1388,6 +1388,28 @@ int virtio_transport_purge_skbs(void *vsk, struct sk_buff_head *queue)
 }
 EXPORT_SYMBOL_GPL(virtio_transport_purge_skbs);
 
+int virtio_transport_read_skb(struct vsock_sock *vsk, skb_read_actor_t recv_actor)
+{
+	struct virtio_vsock_sock *vvs = vsk->trans;
+	struct sock *sk = sk_vsock(vsk);
+	struct sk_buff *skb;
+	int copied = 0;
+	int off = 0;
+	int err;
+
+	spin_lock_bh(&vvs->rx_lock);
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
index 0000000000000..9e11282d3bc1f
--- /dev/null
+++ b/net/vmw_vsock/vsock_bpf.c
@@ -0,0 +1,180 @@
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
+#include <net/af_vsock.h>
+#include <net/sock.h>
+
+#define vsock_sk_has_data(__sk, __psock)				\
+		({	!skb_queue_empty(&__sk->sk_receive_queue) ||	\
+			!skb_queue_empty(&__psock->ingress_skb) ||	\
+			!list_empty(&__psock->ingress_msg);		\
+		})
+
+static struct proto *vsock_dgram_prot_saved __read_mostly;
+static DEFINE_SPINLOCK(vsock_dgram_prot_lock);
+static struct proto vsock_dgram_bpf_prot;
+
+static bool vsock_has_data(struct vsock_sock *vsk, struct sk_psock *psock)
+{
+	struct sock *sk = sk_vsock(vsk);
+	s64 ret;
+
+	ret = vsock_connectible_has_data(vsk);
+	if (ret > 0)
+		return true;
+
+	return vsock_sk_has_data(sk, psock);
+}
+
+static int vsock_msg_wait_data(struct sock *sk, struct sk_psock *psock, long timeo)
+{
+	struct vsock_sock *vsk;
+	int err;
+
+	DEFINE_WAIT(wait);
+
+	vsk = vsock_sk(sk);
+	err = 0;
+
+	while (vsock_has_data(vsk, psock)) {
+		prepare_to_wait(sk_sleep(sk), &wait, TASK_INTERRUPTIBLE);
+
+		if (sk->sk_err != 0 ||
+		    (sk->sk_shutdown & RCV_SHUTDOWN) ||
+		    (vsk->peer_shutdown & SEND_SHUTDOWN)) {
+			break;
+		}
+
+		if (timeo == 0) {
+			err = -EAGAIN;
+			break;
+		}
+
+		release_sock(sk);
+		timeo = schedule_timeout(timeo);
+		lock_sock(sk);
+
+		if (signal_pending(current)) {
+			err = sock_intr_errno(timeo);
+			break;
+		} else if (timeo == 0) {
+			err = -EAGAIN;
+			break;
+		}
+	}
+
+	finish_wait(sk_sleep(sk), &wait);
+
+	if (err)
+		return err;
+
+	return 0;
+}
+
+static int vsock_recvmsg(struct sock *sk, struct msghdr *msg, size_t len, int flags)
+{
+	int err;
+	struct socket *sock = sk->sk_socket;
+
+	if (sk->sk_type == SOCK_STREAM || sk->sk_type == SOCK_SEQPACKET)
+		err = vsock_connectible_recvmsg(sock, msg, len, flags);
+	else
+		err = vsock_dgram_recvmsg(sock, msg, len, flags);
+
+	return err;
+}
+
+static int vsock_bpf_recvmsg(struct sock *sk, struct msghdr *msg,
+			     size_t len, int flags, int *addr_len)
+{
+	int copied;
+	struct sk_psock *psock;
+
+	lock_sock(sk);
+	psock = sk_psock_get(sk);
+	if (unlikely(!psock)) {
+		release_sock(sk);
+		return vsock_recvmsg(sk, msg, len, flags);
+	}
+
+	if (vsock_has_data(vsock_sk(sk), psock) && sk_psock_queue_empty(psock)) {
+		sk_psock_put(sk, psock);
+		release_sock(sk);
+		return vsock_recvmsg(sk, msg, len, flags);
+	}
+
+msg_bytes_ready:
+	copied = sk_msg_recvmsg(sk, psock, msg, len, flags);
+	if (!copied) {
+		long timeo;
+		int data;
+
+		timeo = sock_rcvtimeo(sk, flags & MSG_DONTWAIT);
+		data = vsock_msg_wait_data(sk, psock, timeo);
+		if (data) {
+			if (!sk_psock_queue_empty(psock))
+				goto msg_bytes_ready;
+			sk_psock_put(sk, psock);
+			release_sock(sk);
+			return vsock_recvmsg(sk, msg, len, flags);
+		}
+		copied = -EAGAIN;
+	}
+	sk_psock_put(sk, psock);
+	release_sock(sk);
+
+	return copied;
+}
+
+/* Copy of original proto with updated sock_map methods */
+static struct proto vsock_dgram_bpf_prot = {
+	.close = sock_map_close,
+	.recvmsg = vsock_bpf_recvmsg,
+	.sock_is_readable = sk_msg_is_readable,
+	.unhash = sock_map_unhash,
+};
+
+static void vsock_dgram_bpf_rebuild_protos(struct proto *prot, const struct proto *base)
+{
+	*prot        = *base;
+	prot->close  = sock_map_close;
+	prot->recvmsg = vsock_bpf_recvmsg;
+	prot->sock_is_readable = sk_msg_is_readable;
+}
+
+static void vsock_dgram_bpf_check_needs_rebuild(struct proto *ops)
+{
+	if (unlikely(ops != smp_load_acquire(&vsock_dgram_prot_saved))) {
+		spin_lock_bh(&vsock_dgram_prot_lock);
+		if (likely(ops != vsock_dgram_prot_saved)) {
+			vsock_dgram_bpf_rebuild_protos(&vsock_dgram_bpf_prot, ops);
+			smp_store_release(&vsock_dgram_prot_saved, ops);
+		}
+		spin_unlock_bh(&vsock_dgram_prot_lock);
+	}
+}
+
+int vsock_bpf_update_proto(struct sock *sk, struct sk_psock *psock, bool restore)
+{
+	if (restore) {
+		sk->sk_write_space = psock->saved_write_space;
+		sock_replace_proto(sk, psock->sk_proto);
+		return 0;
+	}
+
+	vsock_dgram_bpf_check_needs_rebuild(psock->sk_proto);
+	sock_replace_proto(sk, &vsock_dgram_bpf_prot);
+	return 0;
+}
+
+void __init vsock_bpf_build_proto(void)
+{
+	vsock_dgram_bpf_rebuild_protos(&vsock_dgram_bpf_prot, &vsock_proto);
+}
diff --git a/net/vmw_vsock/vsock_loopback.c b/net/vmw_vsock/vsock_loopback.c
index 671e03240fc52..40753b661c135 100644
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
