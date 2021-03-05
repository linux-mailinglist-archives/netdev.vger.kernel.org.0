Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 332E132DF59
	for <lists+netdev@lfdr.de>; Fri,  5 Mar 2021 02:57:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229955AbhCEB5Q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Mar 2021 20:57:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42582 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229801AbhCEB5O (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 4 Mar 2021 20:57:14 -0500
Received: from mail-oo1-xc30.google.com (mail-oo1-xc30.google.com [IPv6:2607:f8b0:4864:20::c30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E17BBC061574;
        Thu,  4 Mar 2021 17:57:13 -0800 (PST)
Received: by mail-oo1-xc30.google.com with SMTP id x23so62377oop.1;
        Thu, 04 Mar 2021 17:57:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=3XTHtLkllymrd1WOxkj/6/vStiqqEthpL5NfV3vGpJY=;
        b=NkI2BO2owhtpvAFC8K2p+6UYUolXQEg2QokzOjrHA1iLikYw0gVxVbCsvEHKLCMksm
         VKx633F28RPmI6AVL65jWXc2lSTeEWsOx+T/mlPhLWKdbFBlJlFFD8p6Gq9cP+ZXZYjn
         WgvINBwiTDcP2fdBfEhVdvLAWRT96l7chDl5q/DMxJiBukOfc30HaT6c5MCqa2sn0Vpa
         ZlMTmnRcFeHDrLZse5xm466F8pdW+aAcgb4tZEMVEJV74/a/oVHlZS/8rcN3UsJ7xR35
         eT2ItbG16BG5LMHAojOWssUXY1gK5yjGz/bQh6HhAZPEqtt2m7b+cjsRlGda5AUaY/KW
         X+lw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=3XTHtLkllymrd1WOxkj/6/vStiqqEthpL5NfV3vGpJY=;
        b=Bv3XC5HQNBeNIAikCt6mvE88QDUFY4vtz9iwft0cgp//l169i7if+UoE/ujrsYTa3H
         kyVlo2lloqrEtCRKfdpFnhJmZBMnqbc7MpE6pYgeKeAnkm6edBW7iWpiHNBBG317vLly
         PrYirQVphrw1PqkDCBRQnt5MnsJNSMUkkfr+LdEHQ77l7zZxIuFYaKueuppqwORSr1Vt
         NcWQ3pguASTPH++99X9t03XHgD5Wa9TaqgbVbWAL2TzFcZYOIAS3moTxeR6EspG00J9n
         I45wJsK0QHtsul9eQc1GV9j7wbHopmm7Ep44NTX3hE7OXzuFhh89PF43PHKbop/ARlWL
         2r/A==
X-Gm-Message-State: AOAM530cjNjn4AcfroKP/ueoG7pomIF5Dyxh/NHY2PoAVchYxHAc+o+4
        bAt89PKwuKGNl2b/Wy3ow9qZZ1BerIWLFQ==
X-Google-Smtp-Source: ABdhPJxaI+7Ja4ooWvXV8kSwGAg2PBDo1AcNpYxOhxx3zz8vlzKK455k/1Ud0BDkCj+7gzNrC3epBA==
X-Received: by 2002:a4a:d296:: with SMTP id h22mr5823027oos.23.1614909433092;
        Thu, 04 Mar 2021 17:57:13 -0800 (PST)
Received: from unknown.attlocal.net ([2600:1700:65a0:ab60:95de:1d5:1b36:946a])
        by smtp.gmail.com with ESMTPSA id r3sm224126oif.5.2021.03.04.17.57.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Mar 2021 17:57:12 -0800 (PST)
From:   Cong Wang <xiyou.wangcong@gmail.com>
To:     netdev@vger.kernel.org
Cc:     bpf@vger.kernel.org, duanxiongchun@bytedance.com,
        wangdongdong.6@bytedance.com, jiang.wang@bytedance.com,
        Cong Wang <cong.wang@bytedance.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jakub Sitnicki <jakub@cloudflare.com>,
        Lorenz Bauer <lmb@cloudflare.com>
Subject: [Patch bpf-next v3 6/9] skmsg: extract __tcp_bpf_recvmsg() and tcp_bpf_wait_data()
Date:   Thu,  4 Mar 2021 17:56:52 -0800
Message-Id: <20210305015655.14249-7-xiyou.wangcong@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210305015655.14249-1-xiyou.wangcong@gmail.com>
References: <20210305015655.14249-1-xiyou.wangcong@gmail.com>
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
index c2e2bdff7338..bb27b93aad95 100644
--- a/include/linux/skmsg.h
+++ b/include/linux/skmsg.h
@@ -126,6 +126,10 @@ int sk_msg_zerocopy_from_iter(struct sock *sk, struct iov_iter *from,
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
index 7dbd8344ec89..fa10d869a728 100644
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
index 2022de8b625a..3d622a0d0753 100644
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

