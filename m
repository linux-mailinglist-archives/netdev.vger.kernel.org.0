Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 710C258FF7C
	for <lists+netdev@lfdr.de>; Thu, 11 Aug 2022 17:30:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235850AbiHKPaM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Aug 2022 11:30:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48142 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235746AbiHKP3p (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Aug 2022 11:29:45 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CBCE796747;
        Thu, 11 Aug 2022 08:29:33 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1E350615CE;
        Thu, 11 Aug 2022 15:29:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 82044C433C1;
        Thu, 11 Aug 2022 15:29:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660231771;
        bh=Qein4jotMuYQonx6x2QvIt87OKd3haE8/BzXpAt4ElE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WIPm7BDZGqiBOor68IqUoGXq5F7LkFpiUTi8F2K/8XK1CmqRxQMukLk4iJohM8d40
         R0eD0dW5vSxNOMjwy7uyMN8O6G/RBeBpwLlpgDByoqXmiAwujHsE1fw4EGsSl6pT17
         fxg1nGrBit1fZy2o1QFc3eJGZND+wb4p0b0O5d+ZEEgpCkvnP5w+F+iaqhjNi/UR7m
         60dNzqUh5j/n0rxmvoJAzTZMTqs6BaoW1OpEky1iQjlJUxw+w6DpZjb4CZDjnh6uXu
         PsbJ1MT64Zhe/uHWUNqY69T+abni3F8ukvzzZiKemYq0XU1D5homtxJ0kNrV/6QR4Z
         Ug0qZNsdUxW6Q==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Wang Yufen <wangyufen@huawei.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Jakub Sitnicki <jakub@cloudflare.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Sasha Levin <sashal@kernel.org>, ast@kernel.org,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, yoshfuji@linux-ipv6.org, dsahern@kernel.org,
        bpf@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.19 010/105] bpf, sockmap: Fix sk->sk_forward_alloc warn_on in sk_stream_kill_queues
Date:   Thu, 11 Aug 2022 11:26:54 -0400
Message-Id: <20220811152851.1520029-10-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220811152851.1520029-1-sashal@kernel.org>
References: <20220811152851.1520029-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Wang Yufen <wangyufen@huawei.com>

[ Upstream commit d8616ee2affcff37c5d315310da557a694a3303d ]

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
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
Acked-by: Jakub Sitnicki <jakub@cloudflare.com>
Acked-by: John Fastabend <john.fastabend@gmail.com>
Link: https://lore.kernel.org/bpf/20220524075311.649153-1-wangyufen@huawei.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/bpf.h   |  1 +
 include/linux/skmsg.h |  1 +
 net/core/skmsg.c      |  1 +
 net/core/sock_map.c   | 23 +++++++++++++++++++++++
 net/ipv4/tcp_bpf.c    |  1 +
 5 files changed, 27 insertions(+)

diff --git a/include/linux/bpf.h b/include/linux/bpf.h
index 2b914a56a2c5..8e6092d0ea95 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -2104,6 +2104,7 @@ int sock_map_bpf_prog_query(const union bpf_attr *attr,
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
index b0fcd0200e84..fc69154bbc88 100644
--- a/net/core/skmsg.c
+++ b/net/core/skmsg.c
@@ -720,6 +720,7 @@ struct sk_psock *sk_psock_init(struct sock *sk, int node)
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
index 0d3f68bb51c0..a1626afe87a1 100644
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
2.35.1

