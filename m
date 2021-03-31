Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5447834F6CD
	for <lists+netdev@lfdr.de>; Wed, 31 Mar 2021 04:33:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233508AbhCaCdY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Mar 2021 22:33:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60498 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233414AbhCaCdC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Mar 2021 22:33:02 -0400
Received: from mail-ot1-x334.google.com (mail-ot1-x334.google.com [IPv6:2607:f8b0:4864:20::334])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 72FACC061574;
        Tue, 30 Mar 2021 19:33:02 -0700 (PDT)
Received: by mail-ot1-x334.google.com with SMTP id 31-20020a9d00220000b02901b64b9b50b1so17551925ota.9;
        Tue, 30 Mar 2021 19:33:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=KLA6Vftyh0UcPve9MLTcr/Qlwo1Hmm6TlBTby3/AhU0=;
        b=nncVWsyALY/qAVVnTVLmIDmmWq7d9N37BKXAEw9cf9jMFEUH//A8tpQgVgtPzLEMRv
         8F8kOBTvRxz4GKTvExU0TyY4ph1qLT1ViH66h3laVThVoOk3HMtV8TsqSw8Do1gcuBqu
         4KqBF4S834QFA7Zbbthh3lZW0i0csUj17dTG44u2c51Zgs6hs6Yq4yghlFFUntAkhGjX
         BysxC2fGue+WHDgeXEh8X5Uz7HYTrNUq6IhALyshiKV21Kn08ChBCtUGTkJUAWsQsSi7
         GxamNFsrFpMWThU9izyAYqLACZqDW5YPBQ+9xymaq12Bw/LeY8pZxLmbAe54SV9UhQOB
         UvYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=KLA6Vftyh0UcPve9MLTcr/Qlwo1Hmm6TlBTby3/AhU0=;
        b=B003eKpD1lFMbeZvEXrO/KGziqkjR0fmdU4Go8cvJfZcTqc//xEJ70bztXtvr4HYz7
         kqxKmOF2pivHRPzejYSDfSO9X047IadMaIb3g7g0v/nyrD20Yf5TDeAqGmHHMvlp7ctp
         3bCJksi8LRXWh5pUgt4Qrscyh8EUQUssuAO54NFoTAjiKuDd6hk523gHirLzDvngyv+s
         eBUDMKk4TPG+GyM+1WxV8Uexe2n3xszCYLgmKg6J4a3mh2Th7yZOqrSX5HC6f8mV2bXJ
         LVDgNWLcHL3BU97YgJS/N24UEYrUPwuosp/kDpOgHqM/TA6xnSR/8g65Hto8XtiFNdqP
         OxNA==
X-Gm-Message-State: AOAM531R0WE1YvN9OtymjgLsJ7yroGOllPQYGrqP/NwnRLVa6cHQULR8
        Ua2jLB2oF/lNNcUZmpjDYbLuupuRxlEcCA==
X-Google-Smtp-Source: ABdhPJzYgZruCowa/vXbDQ34akW/QikuayDx6Kx52AUkE8sQTVZ9k10RgbjOeMTLMkIzfN0DquOr7A==
X-Received: by 2002:a05:6830:1b7a:: with SMTP id d26mr780789ote.324.1617157981724;
        Tue, 30 Mar 2021 19:33:01 -0700 (PDT)
Received: from unknown.attlocal.net ([2600:1700:65a0:ab60:a099:767b:2b62:48df])
        by smtp.gmail.com with ESMTPSA id 7sm188125ois.20.2021.03.30.19.33.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 30 Mar 2021 19:33:01 -0700 (PDT)
From:   Cong Wang <xiyou.wangcong@gmail.com>
To:     netdev@vger.kernel.org
Cc:     bpf@vger.kernel.org, duanxiongchun@bytedance.com,
        wangdongdong.6@bytedance.com, jiang.wang@bytedance.com,
        Cong Wang <cong.wang@bytedance.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jakub Sitnicki <jakub@cloudflare.com>,
        Lorenz Bauer <lmb@cloudflare.com>
Subject: [Patch bpf-next v8 12/16] skmsg: extract __tcp_bpf_recvmsg() and tcp_bpf_wait_data()
Date:   Tue, 30 Mar 2021 19:32:33 -0700
Message-Id: <20210331023237.41094-13-xiyou.wangcong@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210331023237.41094-1-xiyou.wangcong@gmail.com>
References: <20210331023237.41094-1-xiyou.wangcong@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Cong Wang <cong.wang@bytedance.com>

Although these two functions are only used by TCP, they are not
specific to TCP at all, both operate on skmsg and ingress_msg,
so fit in net/core/skmsg.c very well.

And we will need them for non-TCP, so rename and move them to
skmsg.c and export them to modules.

Cc: John Fastabend <john.fastabend@gmail.com>
Cc: Daniel Borkmann <daniel@iogearbox.net>
Cc: Jakub Sitnicki <jakub@cloudflare.com>
Cc: Lorenz Bauer <lmb@cloudflare.com>
Signed-off-by: Cong Wang <cong.wang@bytedance.com>
---
 include/linux/skmsg.h |   4 ++
 include/net/tcp.h     |   2 -
 net/core/skmsg.c      |  98 +++++++++++++++++++++++++++++++++++++++++
 net/ipv4/tcp_bpf.c    | 100 +-----------------------------------------
 net/tls/tls_sw.c      |   4 +-
 5 files changed, 106 insertions(+), 102 deletions(-)

diff --git a/include/linux/skmsg.h b/include/linux/skmsg.h
index 5e800ddc2dc6..f78e90a04a69 100644
--- a/include/linux/skmsg.h
+++ b/include/linux/skmsg.h
@@ -125,6 +125,10 @@ int sk_msg_zerocopy_from_iter(struct sock *sk, struct iov_iter *from,
 			      struct sk_msg *msg, u32 bytes);
 int sk_msg_memcopy_from_iter(struct sock *sk, struct iov_iter *from,
 			     struct sk_msg *msg, u32 bytes);
+int sk_msg_wait_data(struct sock *sk, struct sk_psock *psock, int flags,
+		     long timeo, int *err);
+int sk_msg_recvmsg(struct sock *sk, struct sk_psock *psock, struct msghdr *msg,
+		   int len, int flags);
 
 static inline void sk_msg_check_to_free(struct sk_msg *msg, u32 i, u32 bytes)
 {
diff --git a/include/net/tcp.h b/include/net/tcp.h
index 2efa4e5ea23d..31b1696c62ba 100644
--- a/include/net/tcp.h
+++ b/include/net/tcp.h
@@ -2209,8 +2209,6 @@ void tcp_bpf_clone(const struct sock *sk, struct sock *newsk);
 
 int tcp_bpf_sendmsg_redir(struct sock *sk, struct sk_msg *msg, u32 bytes,
 			  int flags);
-int __tcp_bpf_recvmsg(struct sock *sk, struct sk_psock *psock,
-		      struct msghdr *msg, int len, int flags);
 #endif /* CONFIG_NET_SOCK_MSG */
 
 #if !defined(CONFIG_BPF_SYSCALL) || !defined(CONFIG_NET_SOCK_MSG)
diff --git a/net/core/skmsg.c b/net/core/skmsg.c
index 9fc83f7cc1a0..92a83c02562a 100644
--- a/net/core/skmsg.c
+++ b/net/core/skmsg.c
@@ -399,6 +399,104 @@ int sk_msg_memcopy_from_iter(struct sock *sk, struct iov_iter *from,
 }
 EXPORT_SYMBOL_GPL(sk_msg_memcopy_from_iter);
 
+int sk_msg_wait_data(struct sock *sk, struct sk_psock *psock, int flags,
+		     long timeo, int *err)
+{
+	DEFINE_WAIT_FUNC(wait, woken_wake_function);
+	int ret = 0;
+
+	if (sk->sk_shutdown & RCV_SHUTDOWN)
+		return 1;
+
+	if (!timeo)
+		return ret;
+
+	add_wait_queue(sk_sleep(sk), &wait);
+	sk_set_bit(SOCKWQ_ASYNC_WAITDATA, sk);
+	ret = sk_wait_event(sk, &timeo,
+			    !list_empty(&psock->ingress_msg) ||
+			    !skb_queue_empty(&sk->sk_receive_queue), &wait);
+	sk_clear_bit(SOCKWQ_ASYNC_WAITDATA, sk);
+	remove_wait_queue(sk_sleep(sk), &wait);
+	return ret;
+}
+EXPORT_SYMBOL_GPL(sk_msg_wait_data);
+
+/* Receive sk_msg from psock->ingress_msg to @msg. */
+int sk_msg_recvmsg(struct sock *sk, struct sk_psock *psock, struct msghdr *msg,
+		   int len, int flags)
+{
+	struct iov_iter *iter = &msg->msg_iter;
+	int peek = flags & MSG_PEEK;
+	struct sk_msg *msg_rx;
+	int i, copied = 0;
+
+	msg_rx = sk_psock_peek_msg(psock);
+	while (copied != len) {
+		struct scatterlist *sge;
+
+		if (unlikely(!msg_rx))
+			break;
+
+		i = msg_rx->sg.start;
+		do {
+			struct page *page;
+			int copy;
+
+			sge = sk_msg_elem(msg_rx, i);
+			copy = sge->length;
+			page = sg_page(sge);
+			if (copied + copy > len)
+				copy = len - copied;
+			copy = copy_page_to_iter(page, sge->offset, copy, iter);
+			if (!copy)
+				return copied ? copied : -EFAULT;
+
+			copied += copy;
+			if (likely(!peek)) {
+				sge->offset += copy;
+				sge->length -= copy;
+				if (!msg_rx->skb)
+					sk_mem_uncharge(sk, copy);
+				msg_rx->sg.size -= copy;
+
+				if (!sge->length) {
+					sk_msg_iter_var_next(i);
+					if (!msg_rx->skb)
+						put_page(page);
+				}
+			} else {
+				/* Lets not optimize peek case if copy_page_to_iter
+				 * didn't copy the entire length lets just break.
+				 */
+				if (copy != sge->length)
+					return copied;
+				sk_msg_iter_var_next(i);
+			}
+
+			if (copied == len)
+				break;
+		} while (i != msg_rx->sg.end);
+
+		if (unlikely(peek)) {
+			msg_rx = sk_psock_next_msg(psock, msg_rx);
+			if (!msg_rx)
+				break;
+			continue;
+		}
+
+		msg_rx->sg.start = i;
+		if (!sge->length && msg_rx->sg.start == msg_rx->sg.end) {
+			msg_rx = sk_psock_dequeue_msg(psock);
+			kfree_sk_msg(msg_rx);
+		}
+		msg_rx = sk_psock_peek_msg(psock);
+	}
+
+	return copied;
+}
+EXPORT_SYMBOL_GPL(sk_msg_recvmsg);
+
 static struct sk_msg *sk_psock_create_ingress_msg(struct sock *sk,
 						  struct sk_buff *skb)
 {
diff --git a/net/ipv4/tcp_bpf.c b/net/ipv4/tcp_bpf.c
index ac8cfbaeacd2..3d622a0d0753 100644
--- a/net/ipv4/tcp_bpf.c
+++ b/net/ipv4/tcp_bpf.c
@@ -10,80 +10,6 @@
 #include <net/inet_common.h>
 #include <net/tls.h>
 
-int __tcp_bpf_recvmsg(struct sock *sk, struct sk_psock *psock,
-		      struct msghdr *msg, int len, int flags)
-{
-	struct iov_iter *iter = &msg->msg_iter;
-	int peek = flags & MSG_PEEK;
-	struct sk_msg *msg_rx;
-	int i, copied = 0;
-
-	msg_rx = sk_psock_peek_msg(psock);
-	while (copied != len) {
-		struct scatterlist *sge;
-
-		if (unlikely(!msg_rx))
-			break;
-
-		i = msg_rx->sg.start;
-		do {
-			struct page *page;
-			int copy;
-
-			sge = sk_msg_elem(msg_rx, i);
-			copy = sge->length;
-			page = sg_page(sge);
-			if (copied + copy > len)
-				copy = len - copied;
-			copy = copy_page_to_iter(page, sge->offset, copy, iter);
-			if (!copy)
-				return copied ? copied : -EFAULT;
-
-			copied += copy;
-			if (likely(!peek)) {
-				sge->offset += copy;
-				sge->length -= copy;
-				if (!msg_rx->skb)
-					sk_mem_uncharge(sk, copy);
-				msg_rx->sg.size -= copy;
-
-				if (!sge->length) {
-					sk_msg_iter_var_next(i);
-					if (!msg_rx->skb)
-						put_page(page);
-				}
-			} else {
-				/* Lets not optimize peek case if copy_page_to_iter
-				 * didn't copy the entire length lets just break.
-				 */
-				if (copy != sge->length)
-					return copied;
-				sk_msg_iter_var_next(i);
-			}
-
-			if (copied == len)
-				break;
-		} while (i != msg_rx->sg.end);
-
-		if (unlikely(peek)) {
-			msg_rx = sk_psock_next_msg(psock, msg_rx);
-			if (!msg_rx)
-				break;
-			continue;
-		}
-
-		msg_rx->sg.start = i;
-		if (!sge->length && msg_rx->sg.start == msg_rx->sg.end) {
-			msg_rx = sk_psock_dequeue_msg(psock);
-			kfree_sk_msg(msg_rx);
-		}
-		msg_rx = sk_psock_peek_msg(psock);
-	}
-
-	return copied;
-}
-EXPORT_SYMBOL_GPL(__tcp_bpf_recvmsg);
-
 static int bpf_tcp_ingress(struct sock *sk, struct sk_psock *psock,
 			   struct sk_msg *msg, u32 apply_bytes, int flags)
 {
@@ -237,28 +163,6 @@ static bool tcp_bpf_stream_read(const struct sock *sk)
 	return !empty;
 }
 
-static int tcp_bpf_wait_data(struct sock *sk, struct sk_psock *psock,
-			     int flags, long timeo, int *err)
-{
-	DEFINE_WAIT_FUNC(wait, woken_wake_function);
-	int ret = 0;
-
-	if (sk->sk_shutdown & RCV_SHUTDOWN)
-		return 1;
-
-	if (!timeo)
-		return ret;
-
-	add_wait_queue(sk_sleep(sk), &wait);
-	sk_set_bit(SOCKWQ_ASYNC_WAITDATA, sk);
-	ret = sk_wait_event(sk, &timeo,
-			    !list_empty(&psock->ingress_msg) ||
-			    !skb_queue_empty(&sk->sk_receive_queue), &wait);
-	sk_clear_bit(SOCKWQ_ASYNC_WAITDATA, sk);
-	remove_wait_queue(sk_sleep(sk), &wait);
-	return ret;
-}
-
 static int tcp_bpf_recvmsg(struct sock *sk, struct msghdr *msg, size_t len,
 		    int nonblock, int flags, int *addr_len)
 {
@@ -278,13 +182,13 @@ static int tcp_bpf_recvmsg(struct sock *sk, struct msghdr *msg, size_t len,
 	}
 	lock_sock(sk);
 msg_bytes_ready:
-	copied = __tcp_bpf_recvmsg(sk, psock, msg, len, flags);
+	copied = sk_msg_recvmsg(sk, psock, msg, len, flags);
 	if (!copied) {
 		int data, err = 0;
 		long timeo;
 
 		timeo = sock_rcvtimeo(sk, nonblock);
-		data = tcp_bpf_wait_data(sk, psock, flags, timeo, &err);
+		data = sk_msg_wait_data(sk, psock, flags, timeo, &err);
 		if (data) {
 			if (!sk_psock_queue_empty(psock))
 				goto msg_bytes_ready;
diff --git a/net/tls/tls_sw.c b/net/tls/tls_sw.c
index 01d933ae5f16..1dcb34dfd56b 100644
--- a/net/tls/tls_sw.c
+++ b/net/tls/tls_sw.c
@@ -1789,8 +1789,8 @@ int tls_sw_recvmsg(struct sock *sk,
 		skb = tls_wait_data(sk, psock, flags, timeo, &err);
 		if (!skb) {
 			if (psock) {
-				int ret = __tcp_bpf_recvmsg(sk, psock,
-							    msg, len, flags);
+				int ret = sk_msg_recvmsg(sk, psock, msg, len,
+							 flags);
 
 				if (ret > 0) {
 					decrypted += ret;
-- 
2.25.1

