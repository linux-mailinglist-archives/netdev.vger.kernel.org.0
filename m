Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6443153242A
	for <lists+netdev@lfdr.de>; Tue, 24 May 2022 09:35:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235301AbiEXHfl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 May 2022 03:35:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54486 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235300AbiEXHfl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 May 2022 03:35:41 -0400
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B727A6AA65;
        Tue, 24 May 2022 00:35:39 -0700 (PDT)
Received: from canpemm500010.china.huawei.com (unknown [172.30.72.55])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4L6mDv52lwzhYnG;
        Tue, 24 May 2022 15:34:55 +0800 (CST)
Received: from container.huawei.com (10.175.104.82) by
 canpemm500010.china.huawei.com (7.192.105.118) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Tue, 24 May 2022 15:35:36 +0800
From:   Wang Yufen <wangyufen@huawei.com>
To:     <ast@kernel.org>, <john.fastabend@gmail.com>, <andrii@kernel.org>,
        <daniel@iogearbox.net>, <jakub@cloudflare.com>,
        <lmb@cloudflare.com>, <davem@davemloft.net>, <kafai@fb.com>,
        <dsahern@kernel.org>, <kuba@kernel.org>, <songliubraving@fb.com>,
        <yhs@fb.com>, <kpsingh@kernel.org>
CC:     <netdev@vger.kernel.org>, <bpf@vger.kernel.org>,
        Wang Yufen <wangyufen@huawei.com>
Subject: [PATCH bpf-next] bpf,sockmap: fix sk->sk_forward_alloc warn_on in sk_stream_kill_queues
Date:   Tue, 24 May 2022 15:53:11 +0800
Message-ID: <20220524075311.649153-1-wangyufen@huawei.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.104.82]
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
 canpemm500010.china.huawei.com (7.192.105.118)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

During TCP sockmap redirect pressure test, the following warning is triggered:
WARNING: CPU: 3 PID: 2145 at net/core/stream.c:205 sk_stream_kill_queues+0xbc/0xd0
CPU: 3 PID: 2145 Comm: iperf Kdump: loaded Tainted: G        W         5.10.0+ #9
Call Trace:
 inet_csk_destroy_sock+0x55/0x110
 inet_csk_listen_stop+0xbb/0x380
 tcp_close+0x41b/0x480
 inet_release+0x42/0x80
 __sock_release+0x3d/0xa0
 sock_close+0x11/0x20
 __fput+0x9d/0x240
 task_work_run+0x62/0x90
 exit_to_user_mode_prepare+0x110/0x120
 syscall_exit_to_user_mode+0x27/0x190
 entry_SYSCALL_64_after_hwframe+0x44/0xa9

The reason we observed is that:
When the listener is closing, a connection may have completed the three-way
handshake but not accepted, and the client has sent some packets. The child
sks in accept queue release by inet_child_forget()->inet_csk_destroy_sock(),
but psocks of child sks have not released.

To fix, add sock_map_destroy to release psocks.

Signed-off-by: Wang Yufen <wangyufen@huawei.com>
---
 include/linux/bpf.h   |  1 +
 include/linux/skmsg.h |  1 +
 net/core/skmsg.c      |  1 +
 net/core/sock_map.c   | 23 +++++++++++++++++++++++
 net/ipv4/tcp_bpf.c    |  1 +
 5 files changed, 27 insertions(+)

diff --git a/include/linux/bpf.h b/include/linux/bpf.h
index cc4d5e394031..c4de82d5e72c 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -2092,6 +2092,7 @@ int sock_map_bpf_prog_query(const union bpf_attr *attr,
 			    union bpf_attr __user *uattr);
 
 void sock_map_unhash(struct sock *sk);
+void sock_map_destroy(struct sock *sk);
 void sock_map_close(struct sock *sk, long timeout);
 #else
 static inline int bpf_prog_offload_init(struct bpf_prog *prog,
diff --git a/include/linux/skmsg.h b/include/linux/skmsg.h
index c5a2d6f50f25..153b6dec9b6a 100644
--- a/include/linux/skmsg.h
+++ b/include/linux/skmsg.h
@@ -95,6 +95,7 @@ struct sk_psock {
 	spinlock_t			link_lock;
 	refcount_t			refcnt;
 	void (*saved_unhash)(struct sock *sk);
+	void (*saved_destroy)(struct sock *sk);
 	void (*saved_close)(struct sock *sk, long timeout);
 	void (*saved_write_space)(struct sock *sk);
 	void (*saved_data_ready)(struct sock *sk);
diff --git a/net/core/skmsg.c b/net/core/skmsg.c
index 22b983ade0e7..7e03f96e441b 100644
--- a/net/core/skmsg.c
+++ b/net/core/skmsg.c
@@ -715,6 +715,7 @@ struct sk_psock *sk_psock_init(struct sock *sk, int node)
 	psock->eval = __SK_NONE;
 	psock->sk_proto = prot;
 	psock->saved_unhash = prot->unhash;
+	psock->saved_destroy = prot->destroy;
 	psock->saved_close = prot->close;
 	psock->saved_write_space = sk->sk_write_space;
 
diff --git a/net/core/sock_map.c b/net/core/sock_map.c
index 81d4b4756a02..9f08ccfaf6da 100644
--- a/net/core/sock_map.c
+++ b/net/core/sock_map.c
@@ -1561,6 +1561,29 @@ void sock_map_unhash(struct sock *sk)
 }
 EXPORT_SYMBOL_GPL(sock_map_unhash);
 
+void sock_map_destroy(struct sock *sk)
+{
+	void (*saved_destroy)(struct sock *sk);
+	struct sk_psock *psock;
+
+	rcu_read_lock();
+	psock = sk_psock_get(sk);
+	if (unlikely(!psock)) {
+		rcu_read_unlock();
+		if (sk->sk_prot->destroy)
+			sk->sk_prot->destroy(sk);
+		return;
+	}
+
+	saved_destroy = psock->saved_destroy;
+	sock_map_remove_links(sk, psock);
+	rcu_read_unlock();
+	sk_psock_stop(psock, true);
+	sk_psock_put(sk, psock);
+	saved_destroy(sk);
+}
+EXPORT_SYMBOL_GPL(sock_map_destroy);
+
 void sock_map_close(struct sock *sk, long timeout)
 {
 	void (*saved_close)(struct sock *sk, long timeout);
diff --git a/net/ipv4/tcp_bpf.c b/net/ipv4/tcp_bpf.c
index be3947e70fec..38550bb1b90b 100644
--- a/net/ipv4/tcp_bpf.c
+++ b/net/ipv4/tcp_bpf.c
@@ -540,6 +540,7 @@ static void tcp_bpf_rebuild_protos(struct proto prot[TCP_BPF_NUM_CFGS],
 				   struct proto *base)
 {
 	prot[TCP_BPF_BASE]			= *base;
+	prot[TCP_BPF_BASE].destroy		= sock_map_destroy;
 	prot[TCP_BPF_BASE].close		= sock_map_close;
 	prot[TCP_BPF_BASE].recvmsg		= tcp_bpf_recvmsg;
 	prot[TCP_BPF_BASE].sock_is_readable	= sk_msg_is_readable;
-- 
2.25.1

