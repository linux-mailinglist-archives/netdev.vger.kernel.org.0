Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EBBE530D28E
	for <lists+netdev@lfdr.de>; Wed,  3 Feb 2021 05:21:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233057AbhBCEUq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Feb 2021 23:20:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36770 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232767AbhBCESa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Feb 2021 23:18:30 -0500
Received: from mail-ot1-x333.google.com (mail-ot1-x333.google.com [IPv6:2607:f8b0:4864:20::333])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F178C0617AA;
        Tue,  2 Feb 2021 20:17:15 -0800 (PST)
Received: by mail-ot1-x333.google.com with SMTP id f6so22095833ots.9;
        Tue, 02 Feb 2021 20:17:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ffOSXHVfVukIRx64nQpYmmUG63thxvE/1brmM+JdKMs=;
        b=fJUbts7FCGnPppInUfONfJXujv3VIsSNHcxo918F3cp9xP4h7nq2Uav+3Wppjzpk8R
         HkB0SesEzijeJuNfXyjKIxpp3p/OhtS12CY6xqqlmj2N7txw3sqryBUhBxAWsSvCUogR
         OVN7gWyW9qfQgM5NKS0YlrKiIb8afyfiRXQ9gXiCbZN/qd4HMNjBk07Ez+PHxDbkqa9t
         FN20E4vf4d7kOmTJLw151lZqtCCv5BD2jePtZ1IuMzc1hUBfzKlE9m8s9Xi2MdmTkUuU
         XwzQUFJKxFUHFFwtVgywH7djnS2v7N6QaebiZ0KyySE2//cqf3NkQ+dpac9Vv5HEdCZz
         b1SA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ffOSXHVfVukIRx64nQpYmmUG63thxvE/1brmM+JdKMs=;
        b=MckenP15hOUHS60V4MqXjlAEbC4dX8mneRjNOdj5XxuZo/zipYT2aouz44uKWU6kmJ
         LpBVPTcO2WQgBy/18DtQT9jZN5PVICk05qEXBt/wH8tdjcIXg+nAlDhAiLFx0sQKnAwa
         F5AOAloiubekwL8au3oCADDy3gB+3xmVSXc7tO9GzXeXKiThj0qbtKHzUHMTbRTBXnsg
         wYvzhlCU/5DJaMP5xdRJhLnZhaIh7l70ZwejJNs2deyQHO2aN23hsPZGrogZx3dfPNYf
         db5ROO3FpgnkuiG7XkBXz4PTiHpZepN6fzEIPA8u2WUKtdkVaA+suhhoQzIZo/Y3ptVK
         btsQ==
X-Gm-Message-State: AOAM531WlwkITOYCuRcXDXWITfd4PlO3Digj0iYI65nhNPHhmzll8/k+
        eSHfbU6xhAB7vYQE7vxPiRRKplpJkZW8OQ==
X-Google-Smtp-Source: ABdhPJyVbJM6ZSydt4Uu3bZbe2jRyPOKOlHNwVJf8qqzIFFxqZzaxmGn0y5DarDq8xypZe+Cy9P9NQ==
X-Received: by 2002:a9d:71c6:: with SMTP id z6mr807246otj.276.1612325834550;
        Tue, 02 Feb 2021 20:17:14 -0800 (PST)
Received: from unknown.attlocal.net ([2600:1700:65a0:ab60:90c4:ffea:6079:8a0c])
        by smtp.gmail.com with ESMTPSA id s10sm209978ool.35.2021.02.02.20.17.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 02 Feb 2021 20:17:13 -0800 (PST)
From:   Cong Wang <xiyou.wangcong@gmail.com>
To:     netdev@vger.kernel.org
Cc:     bpf@vger.kernel.org, duanxiongchun@bytedance.com,
        wangdongdong.6@bytedance.com, jiang.wang@bytedance.com,
        Cong Wang <cong.wang@bytedance.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jakub Sitnicki <jakub@cloudflare.com>,
        Lorenz Bauer <lmb@cloudflare.com>
Subject: [Patch bpf-next 14/19] skmsg: extract __tcp_bpf_recvmsg() and tcp_bpf_wait_data()
Date:   Tue,  2 Feb 2021 20:16:31 -0800
Message-Id: <20210203041636.38555-15-xiyou.wangcong@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210203041636.38555-1-xiyou.wangcong@gmail.com>
References: <20210203041636.38555-1-xiyou.wangcong@gmail.com>
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
 net/core/skmsg.c      | 104 +++++++++++++++++++++++++++++++++++++++++
 net/ipv4/tcp_bpf.c    | 106 +-----------------------------------------
 net/tls/tls_sw.c      |   4 +-
 5 files changed, 112 insertions(+), 108 deletions(-)

diff --git a/include/linux/skmsg.h b/include/linux/skmsg.h
index cb94d0f89c08..0e52fc5521a0 100644
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
index c2fff35859b6..b314aee5800d 100644
--- a/include/net/tcp.h
+++ b/include/net/tcp.h
@@ -2194,8 +2194,6 @@ static inline void tcp_bpf_clone(const struct sock *sk, struct sock *newsk)
 #ifdef CONFIG_NET_SOCK_MSG
 int tcp_bpf_sendmsg_redir(struct sock *sk, struct sk_msg *msg, u32 bytes,
 			  int flags);
-int __tcp_bpf_recvmsg(struct sock *sk, struct sk_psock *psock,
-		      struct msghdr *msg, int len, int flags);
 #endif /* CONFIG_NET_SOCK_MSG */
 
 #ifdef CONFIG_CGROUP_BPF
diff --git a/net/core/skmsg.c b/net/core/skmsg.c
index ecbd6f0d49a5..8e3edbdf4c7c 100644
--- a/net/core/skmsg.c
+++ b/net/core/skmsg.c
@@ -399,6 +399,110 @@ int sk_msg_memcopy_from_iter(struct sock *sk, struct iov_iter *from,
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
+	msg_rx = list_first_entry_or_null(&psock->ingress_msg,
+					  struct sk_msg, list);
+
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
+			if (msg_rx == list_last_entry(&psock->ingress_msg,
+						      struct sk_msg, list))
+				break;
+			msg_rx = list_next_entry(msg_rx, list);
+			continue;
+		}
+
+		msg_rx->sg.start = i;
+		if (!sge->length && msg_rx->sg.start == msg_rx->sg.end) {
+			list_del(&msg_rx->list);
+			if (msg_rx->skb)
+				consume_skb(msg_rx->skb);
+			kfree(msg_rx);
+		}
+		msg_rx = list_first_entry_or_null(&psock->ingress_msg,
+						  struct sk_msg, list);
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
index 16e00802ccba..3c0206a4f0e0 100644
--- a/net/ipv4/tcp_bpf.c
+++ b/net/ipv4/tcp_bpf.c
@@ -10,86 +10,6 @@
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
-	msg_rx = list_first_entry_or_null(&psock->ingress_msg,
-					  struct sk_msg, list);
-
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
-			if (msg_rx == list_last_entry(&psock->ingress_msg,
-						      struct sk_msg, list))
-				break;
-			msg_rx = list_next_entry(msg_rx, list);
-			continue;
-		}
-
-		msg_rx->sg.start = i;
-		if (!sge->length && msg_rx->sg.start == msg_rx->sg.end) {
-			list_del(&msg_rx->list);
-			if (msg_rx->skb)
-				consume_skb(msg_rx->skb);
-			kfree(msg_rx);
-		}
-		msg_rx = list_first_entry_or_null(&psock->ingress_msg,
-						  struct sk_msg, list);
-	}
-
-	return copied;
-}
-EXPORT_SYMBOL_GPL(__tcp_bpf_recvmsg);
-
 static int bpf_tcp_ingress(struct sock *sk, struct sk_psock *psock,
 			   struct sk_msg *msg, u32 apply_bytes, int flags)
 {
@@ -243,28 +163,6 @@ static bool tcp_bpf_stream_read(const struct sock *sk)
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
@@ -284,13 +182,13 @@ static int tcp_bpf_recvmsg(struct sock *sk, struct msghdr *msg, size_t len,
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

