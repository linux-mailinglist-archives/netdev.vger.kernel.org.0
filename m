Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 039EC3D273F
	for <lists+netdev@lfdr.de>; Thu, 22 Jul 2021 18:06:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229554AbhGVPZL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Jul 2021 11:25:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39654 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229549AbhGVPZJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Jul 2021 11:25:09 -0400
Received: from mail-qv1-xf2d.google.com (mail-qv1-xf2d.google.com [IPv6:2607:f8b0:4864:20::f2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 853A4C061757;
        Thu, 22 Jul 2021 09:05:44 -0700 (PDT)
Received: by mail-qv1-xf2d.google.com with SMTP id bz7so1069008qvb.7;
        Thu, 22 Jul 2021 09:05:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=LcdkUBavjDbrAs7Vlr0AuUelUjYUB1tsVVkbu76Tqy8=;
        b=s/VcMshKKlprUR+cDoR+uiDzsjAIjhVmOeRDWt/jrLqlS8wYnkSGBnOnx2cc4b0ODT
         EbK/AFX9XDT+iw3HfJK+rqih584UuJMn2BpbvAYntxzaWbWsijKEg56SKn0eMqvogUkz
         w0tuYkDaOLJxymZISm6O9a+eJZC+rXZUgKPFmBcHR6BqD57cPhpOBdNnvve2wwm4mgsW
         J04Q5U1Dot5xQk4z9fFqksWLmxMZNwJg+ruqKNXAVbVlqAsVaL8+5P2FCNEIrmysBzF+
         benBokb7saQ6s0nKOuhMi+byeSuNesQH/yB34ShuXrAhLMXhOiSo9cV770xuf8ld4th2
         u+oA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=LcdkUBavjDbrAs7Vlr0AuUelUjYUB1tsVVkbu76Tqy8=;
        b=YaxEYnsInIWkWqZKZNXWHOp11CbnBYHbedlw0fJ85f+aURFAihLnNM8V3RJkNBcCrh
         dxtmY+nT9h31E9Dofx2v4cBmbhLKWRKL6LD9Xea6Y1MIqpjBD/KltHSPhR2Cackpyo0q
         XTxlfJdjnPh1ie7r0tu8DrpAOzvehnGTX2see4nSIK8ERvgLEi7vLxICa/GGVrafjqAd
         2/LcK2vb+nQU3pyJ8FN/HckW8EJWi9B2rxTPIw070rRZ/tEQID/ug8qouKUPJc8iqIj7
         Wn+R4vr6ohZBG0heTW5oiS2AADdsbUG4E6g5TUxiyFHByjXk+m+60t7FEagJs1RxGWMR
         laQg==
X-Gm-Message-State: AOAM5322UqwnCOezvlLmnkqaSvlbqijnWtERKCBkeLSj+C1DIgi7adB6
        ERZ6HUA4T9yoPaTuo2TIf1DuTiEISsPF+Q==
X-Google-Smtp-Source: ABdhPJyn4BMFf/ULemWQpWhvlDU4NqjR6XZ6wwneWdHcRhLyiD+IHjeRPAP06/nJpMwOjdjv0WBHzQ==
X-Received: by 2002:a05:6214:1cb:: with SMTP id c11mr661094qvt.47.1626969943474;
        Thu, 22 Jul 2021 09:05:43 -0700 (PDT)
Received: from localhost (nat-pool-bos-t.redhat.com. [66.187.233.206])
        by smtp.gmail.com with ESMTPSA id 12sm12883718qkr.10.2021.07.22.09.05.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 Jul 2021 09:05:43 -0700 (PDT)
From:   Xin Long <lucien.xin@gmail.com>
To:     network dev <netdev@vger.kernel.org>, davem@davemloft.net,
        kuba@kernel.org, tipc-discussion@lists.sourceforge.net,
        linux-sctp@vger.kernel.org
Cc:     Jon Maloy <jmaloy@redhat.com>
Subject: [PATCH net] tipc: fix implicit-connect for SYN+
Date:   Thu, 22 Jul 2021 12:05:41 -0400
Message-Id: <9f7076d5dd455e26df404b917bfe99f301c0eb72.1626969941.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

For implicit-connect, when it's either SYN- or SYN+, an ACK should
be sent back to the client immediately. It's not appropriate for
the client to enter established state only after receiving data
from the server.

On client side, after the SYN is sent out, tipc_wait_for_connect()
should be called to wait for the ACK if timeout is set.

This patch also restricts __tipc_sendstream() to call __sendmsg()
only when it's in TIPC_OPEN state, so that the client can program
in a single loop doing both connecting and data sending like:

  for (...)
      sendmsg(dest, buf);

This makes the implicit-connect more implicit.

Fixes: b97bf3fd8f6a ("[TIPC] Initial merge")
Signed-off-by: Xin Long <lucien.xin@gmail.com>
Acked-by: Jon Maloy <jmaloy@redhat.com>
---
 net/tipc/socket.c | 21 +++++++++++++--------
 1 file changed, 13 insertions(+), 8 deletions(-)

diff --git a/net/tipc/socket.c b/net/tipc/socket.c
index 34a97ea36cc8..ebd300c26a44 100644
--- a/net/tipc/socket.c
+++ b/net/tipc/socket.c
@@ -158,6 +158,7 @@ static void tipc_sk_remove(struct tipc_sock *tsk);
 static int __tipc_sendstream(struct socket *sock, struct msghdr *m, size_t dsz);
 static int __tipc_sendmsg(struct socket *sock, struct msghdr *m, size_t dsz);
 static void tipc_sk_push_backlog(struct tipc_sock *tsk, bool nagle_ack);
+static int tipc_wait_for_connect(struct socket *sock, long *timeo_p);
 
 static const struct proto_ops packet_ops;
 static const struct proto_ops stream_ops;
@@ -1515,8 +1516,13 @@ static int __tipc_sendmsg(struct socket *sock, struct msghdr *m, size_t dlen)
 		rc = 0;
 	}
 
-	if (unlikely(syn && !rc))
+	if (unlikely(syn && !rc)) {
 		tipc_set_sk_state(sk, TIPC_CONNECTING);
+		if (timeout) {
+			timeout = msecs_to_jiffies(timeout);
+			tipc_wait_for_connect(sock, &timeout);
+		}
+	}
 
 	return rc ? rc : dlen;
 }
@@ -1564,7 +1570,7 @@ static int __tipc_sendstream(struct socket *sock, struct msghdr *m, size_t dlen)
 		return -EMSGSIZE;
 
 	/* Handle implicit connection setup */
-	if (unlikely(dest)) {
+	if (unlikely(dest && sk->sk_state == TIPC_OPEN)) {
 		rc = __tipc_sendmsg(sock, m, dlen);
 		if (dlen && dlen == rc) {
 			tsk->peer_caps = tipc_node_get_capabilities(net, dnode);
@@ -2689,9 +2695,10 @@ static int tipc_accept(struct socket *sock, struct socket *new_sock, int flags,
 		       bool kern)
 {
 	struct sock *new_sk, *sk = sock->sk;
-	struct sk_buff *buf;
 	struct tipc_sock *new_tsock;
+	struct msghdr m = {NULL,};
 	struct tipc_msg *msg;
+	struct sk_buff *buf;
 	long timeo;
 	int res;
 
@@ -2737,19 +2744,17 @@ static int tipc_accept(struct socket *sock, struct socket *new_sock, int flags,
 	}
 
 	/*
-	 * Respond to 'SYN-' by discarding it & returning 'ACK'-.
-	 * Respond to 'SYN+' by queuing it on new socket.
+	 * Respond to 'SYN-' by discarding it & returning 'ACK'.
+	 * Respond to 'SYN+' by queuing it on new socket & returning 'ACK'.
 	 */
 	if (!msg_data_sz(msg)) {
-		struct msghdr m = {NULL,};
-
 		tsk_advance_rx_queue(sk);
-		__tipc_sendstream(new_sock, &m, 0);
 	} else {
 		__skb_dequeue(&sk->sk_receive_queue);
 		__skb_queue_head(&new_sk->sk_receive_queue, buf);
 		skb_set_owner_r(buf, new_sk);
 	}
+	__tipc_sendstream(new_sock, &m, 0);
 	release_sock(new_sk);
 exit:
 	release_sock(sk);
-- 
2.27.0

