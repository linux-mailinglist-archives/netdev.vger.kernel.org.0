Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8404F4DD7E4
	for <lists+netdev@lfdr.de>; Fri, 18 Mar 2022 11:24:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234957AbiCRK0B (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Mar 2022 06:26:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48390 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232767AbiCRKZ7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Mar 2022 06:25:59 -0400
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D2ED521A8AE;
        Fri, 18 Mar 2022 03:24:39 -0700 (PDT)
Received: from canpemm500010.china.huawei.com (unknown [172.30.72.57])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4KKg7w1JLnzfYqx;
        Fri, 18 Mar 2022 18:23:08 +0800 (CST)
Received: from localhost.localdomain (10.175.104.82) by
 canpemm500010.china.huawei.com (7.192.105.118) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Fri, 18 Mar 2022 18:24:37 +0800
From:   Wang Yufen <wangyufen@huawei.com>
To:     <ast@kernel.org>, <john.fastabend@gmail.com>, <andrii@kernel.org>,
        <daniel@iogearbox.net>, <jakub@cloudflare.com>,
        <lmb@cloudflare.com>, <davem@davemloft.net>, <kafai@fb.com>,
        <dsahern@kernel.org>, <kuba@kernel.org>, <songliubraving@fb.com>,
        <yhs@fb.com>, <kpsingh@kernel.org>
CC:     <netdev@vger.kernel.org>, <bpf@vger.kernel.org>,
        Wang Yufen <wangyufen@huawei.com>
Subject: [PATCH bpf-next] bpf, sockmap: Add sk_rmem_alloc check for tcp_bpf_ingress()
Date:   Fri, 18 Mar 2022 18:42:22 +0800
Message-ID: <20220318104222.1410625-1-wangyufen@huawei.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.104.82]
X-ClientProxiedBy: dggems702-chm.china.huawei.com (10.3.19.179) To
 canpemm500010.china.huawei.com (7.192.105.118)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We use sk_msg to redirect with sock hash, like this:

  skA   redirect    skB
  Tx <----------->  Rx

And construct a scenario where the packet sending speed is high, the
packet receiving speed is slow, so the packets are stacked in the ingress
queue on the receiving side. After a period of time, the memory is
exhausted and the system ooms.

To fix, we add sk_rmem_alloc while sk_msg queued in the ingress queue
and subtract sk_rmem_alloc while sk_msg dequeued from the ingress queue
and check sk_rmem_alloc at the beginning of bpf_tcp_ingress().

Signed-off-by: Wang Yufen <wangyufen@huawei.com>
---
 include/linux/skmsg.h | 9 ++++++---
 net/core/skmsg.c      | 2 ++
 net/ipv4/tcp_bpf.c    | 6 ++++++
 3 files changed, 14 insertions(+), 3 deletions(-)

diff --git a/include/linux/skmsg.h b/include/linux/skmsg.h
index c5a2d6f50f25..d2cfd5fa2274 100644
--- a/include/linux/skmsg.h
+++ b/include/linux/skmsg.h
@@ -308,9 +308,10 @@ static inline void sk_psock_queue_msg(struct sk_psock *psock,
 				      struct sk_msg *msg)
 {
 	spin_lock_bh(&psock->ingress_lock);
-	if (sk_psock_test_state(psock, SK_PSOCK_TX_ENABLED))
+	if (sk_psock_test_state(psock, SK_PSOCK_TX_ENABLED)) {
 		list_add_tail(&msg->list, &psock->ingress_msg);
-	else {
+		atomic_add(msg->sg.size, &psock->sk->sk_rmem_alloc);
+	} else {
 		sk_msg_free(psock->sk, msg);
 		kfree(msg);
 	}
@@ -323,8 +324,10 @@ static inline struct sk_msg *sk_psock_dequeue_msg(struct sk_psock *psock)
 
 	spin_lock_bh(&psock->ingress_lock);
 	msg = list_first_entry_or_null(&psock->ingress_msg, struct sk_msg, list);
-	if (msg)
+	if (msg) {
 		list_del(&msg->list);
+		atomic_sub(msg->sg.size, &psock->sk->sk_rmem_alloc);
+	}
 	spin_unlock_bh(&psock->ingress_lock);
 	return msg;
 }
diff --git a/net/core/skmsg.c b/net/core/skmsg.c
index cc381165ea08..b19a3c49564f 100644
--- a/net/core/skmsg.c
+++ b/net/core/skmsg.c
@@ -445,6 +445,7 @@ int sk_msg_recvmsg(struct sock *sk, struct sk_psock *psock, struct msghdr *msg,
 				if (!msg_rx->skb)
 					sk_mem_uncharge(sk, copy);
 				msg_rx->sg.size -= copy;
+				atomic_sub(copy, &sk->sk_rmem_alloc);
 
 				if (!sge->length) {
 					sk_msg_iter_var_next(i);
@@ -754,6 +755,7 @@ static void __sk_psock_purge_ingress_msg(struct sk_psock *psock)
 
 	list_for_each_entry_safe(msg, tmp, &psock->ingress_msg, list) {
 		list_del(&msg->list);
+		atomic_sub(msg->sg.size, &psock->sk->sk_rmem_alloc);
 		sk_msg_free(psock->sk, msg);
 		kfree(msg);
 	}
diff --git a/net/ipv4/tcp_bpf.c b/net/ipv4/tcp_bpf.c
index 1cdcb4df0eb7..dd099875414c 100644
--- a/net/ipv4/tcp_bpf.c
+++ b/net/ipv4/tcp_bpf.c
@@ -24,6 +24,12 @@ static int bpf_tcp_ingress(struct sock *sk, struct sk_psock *psock,
 		return -ENOMEM;
 
 	lock_sock(sk);
+	if (atomic_read(&sk->sk_rmem_alloc) > sk->sk_rcvbuf) {
+		release_sock(sk);
+		kfree(tmp);
+		return -EAGAIN;
+	}
+
 	tmp->sg.start = msg->sg.start;
 	i = msg->sg.start;
 	do {
-- 
2.25.1

