Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C446D9D3D4
	for <lists+netdev@lfdr.de>; Mon, 26 Aug 2019 18:19:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732550AbfHZQTV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Aug 2019 12:19:21 -0400
Received: from mail-vs1-f73.google.com ([209.85.217.73]:33078 "EHLO
        mail-vs1-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731762AbfHZQTU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Aug 2019 12:19:20 -0400
Received: by mail-vs1-f73.google.com with SMTP id q9so4292430vsj.0
        for <netdev@vger.kernel.org>; Mon, 26 Aug 2019 09:19:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=DJ+6xkGcgyScOol90QOAB9AN4dI/Ae0xLaHyCIFw5WI=;
        b=RUt/mCRQbnazDc/fEerBOVJrNp326dZ/XXzqTJIJznCiLWFUt9qnzKnAmMmVbdah3a
         JrH7Ma0YIZJRgooR+EE0do94zrVpj+S8JbYzT1nXE3AT+AINuc7fOVAKxzQHWuGuCNyf
         uOE/scxsvSNF0skPteG48vCNgmFXTTO0TIWLGM6cihGSAYYgNvfbBZ2mxw6uHvZ5Rik+
         tV43sHfAvQ1cn4NCbQxpcAoTfKmEhTG1pZ0HlKJTxWIhbXmH3zukydRbE/PbzXRCPZZI
         +cO4rI98z63CpM+AqZttIaFrJo+FHKGLOFbpDFwsRPCUTPNmsncCP8IDHsSh8lACrZpO
         EmsQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=DJ+6xkGcgyScOol90QOAB9AN4dI/Ae0xLaHyCIFw5WI=;
        b=ALBtyKMwIQBp6S0LFxFwCz2pQwN9fiXjhVEJwEyPGBtoES1QJ78waKZY6J/iguO7+d
         uWnLfvhcabmGnB2lK6cp1VlbIPlgE9J/SxlGsq5EK2i0gjZtBAt5MdkqueU96njUnESw
         xMsHcNmxCF1LYirPI3M7EQcNQi0CaVT7Oe5LiPrZITanMf01yeI+ltiqiA7qkaqQm7RP
         fts92RyOOOa6qKt8dEsTs4fDFmtgkW0+LpDmNWEWImq77oZJ++D27MQWvifZxyj6hN4+
         IRx89mleuQEmnTym4TfKcSDK8SAp1dDiFBIKsC6Yci20hqTC8246z294tLBdepakrAFL
         Oo5Q==
X-Gm-Message-State: APjAAAWjbgUASaV+DTgtRcq9zz071v9kG0NB5PFb/Nuoq3Ie3IpkR51+
        o8qDKSi2bGMLzGlBlHEt1izmE4OQ/cjSVA==
X-Google-Smtp-Source: APXvYqwdxMh+eiHweUAohBxNKZJWsLlPJnAP9fRFB/iev+LtODjmk6gHqWDdoRyYmtUZAFj9rRl/drus3w/HVg==
X-Received: by 2002:ab0:2748:: with SMTP id c8mr8736777uap.79.1566836359375;
 Mon, 26 Aug 2019 09:19:19 -0700 (PDT)
Date:   Mon, 26 Aug 2019 09:19:15 -0700
Message-Id: <20190826161915.81676-1-edumazet@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.23.0.187.g17f5b7556c-goog
Subject: [PATCH net] tcp: remove empty skb from write queue in error cases
From:   Eric Dumazet <edumazet@google.com>
To:     "David S . Miller" <davem@davemloft.net>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Soheil Hassas Yeganeh <soheil@google.com>,
        Neal Cardwell <ncardwell@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Jason Baron <jbaron@akamai.com>,
        Vladimir Rutsky <rutsky@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Vladimir Rutsky reported stuck TCP sessions after memory pressure
events. Edge Trigger epoll() user would never receive an EPOLLOUT
notification allowing them to retry a sendmsg().

Jason tested the case of sk_stream_alloc_skb() returning NULL,
but there are other paths that could lead both sendmsg() and sendpage()
to return -1 (EAGAIN), with an empty skb queued on the write queue.

This patch makes sure we remove this empty skb so that
Jason code can detect that the queue is empty, and
call sk->sk_write_space(sk) accordingly.

Fixes: ce5ec440994b ("tcp: ensure epoll edge trigger wakeup when write queue is empty")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Cc: Jason Baron <jbaron@akamai.com>
Reported-by: Vladimir Rutsky <rutsky@google.com>
Cc: Soheil Hassas Yeganeh <soheil@google.com>
Cc: Neal Cardwell <ncardwell@google.com>
---
 net/ipv4/tcp.c | 30 ++++++++++++++++++++----------
 1 file changed, 20 insertions(+), 10 deletions(-)

diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
index 77b485d60b9d0e00edc4e2f0d6c5bb3a9460b23b..61082065b26a068975c411b74eb46739ab0632ca 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -935,6 +935,22 @@ static int tcp_send_mss(struct sock *sk, int *size_goal, int flags)
 	return mss_now;
 }
 
+/* In some cases, both sendpage() and sendmsg() could have added
+ * an skb to the write queue, but failed adding payload on it.
+ * We need to remove it to consume less memory, but more
+ * importantly be able to generate EPOLLOUT for Edge Trigger epoll()
+ * users.
+ */
+static void tcp_remove_empty_skb(struct sock *sk, struct sk_buff *skb)
+{
+	if (skb && !skb->len) {
+		tcp_unlink_write_queue(skb, sk);
+		if (tcp_write_queue_empty(sk))
+			tcp_chrono_stop(sk, TCP_CHRONO_BUSY);
+		sk_wmem_free_skb(sk, skb);
+	}
+}
+
 ssize_t do_tcp_sendpages(struct sock *sk, struct page *page, int offset,
 			 size_t size, int flags)
 {
@@ -1064,6 +1080,7 @@ ssize_t do_tcp_sendpages(struct sock *sk, struct page *page, int offset,
 	return copied;
 
 do_error:
+	tcp_remove_empty_skb(sk, tcp_write_queue_tail(sk));
 	if (copied)
 		goto out;
 out_err:
@@ -1388,18 +1405,11 @@ int tcp_sendmsg_locked(struct sock *sk, struct msghdr *msg, size_t size)
 	sock_zerocopy_put(uarg);
 	return copied + copied_syn;
 
+do_error:
+	skb = tcp_write_queue_tail(sk);
 do_fault:
-	if (!skb->len) {
-		tcp_unlink_write_queue(skb, sk);
-		/* It is the one place in all of TCP, except connection
-		 * reset, where we can be unlinking the send_head.
-		 */
-		if (tcp_write_queue_empty(sk))
-			tcp_chrono_stop(sk, TCP_CHRONO_BUSY);
-		sk_wmem_free_skb(sk, skb);
-	}
+	tcp_remove_empty_skb(sk, skb);
 
-do_error:
 	if (copied + copied_syn)
 		goto out;
 out_err:
-- 
2.23.0.187.g17f5b7556c-goog

