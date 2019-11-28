Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CE1AC10C2CE
	for <lists+netdev@lfdr.de>; Thu, 28 Nov 2019 04:24:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727231AbfK1DYP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Nov 2019 22:24:15 -0500
Received: from f0-dek.dektech.com.au ([210.10.221.142]:32832 "EHLO
        mail.dektech.com.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727146AbfK1DYP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Nov 2019 22:24:15 -0500
Received: from localhost (localhost [127.0.0.1])
        by mail.dektech.com.au (Postfix) with ESMTP id F27414B9D0;
        Thu, 28 Nov 2019 14:10:13 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=dektech.com.au;
         h=references:in-reply-to:x-mailer:message-id:date:date:subject
        :subject:from:from:received:received:received; s=mail_dkim; t=
        1574910613; bh=ucB/mpLQr+FlKPjIb3X0L0kJML9o22R6k+C578E75g4=; b=Y
        0Yrd+9CVuPfFp7vdidRAVuz8NaFGe+cE8WZ18TrF+zJql7342lsT3BJBxQ7K1pzq
        Q3KW8PlwyQbFqgkHxEr/t02n9HbBVWxFMuQ3PS4yiBREGX7FDMQWFH99ew/YIgYU
        Z9CK4ajMhXBEAJ5aeK/JSeR61dh4cz76qfjG7taZqg=
X-Virus-Scanned: amavisd-new at dektech.com.au
Received: from mail.dektech.com.au ([127.0.0.1])
        by localhost (mail2.dektech.com.au [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id h6vQfWFuOPIY; Thu, 28 Nov 2019 14:10:13 +1100 (AEDT)
Received: from mail.dektech.com.au (localhost [127.0.0.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.dektech.com.au (Postfix) with ESMTPS id CB35D4B9D1;
        Thu, 28 Nov 2019 14:10:13 +1100 (AEDT)
Received: from ubuntu.dek-tpc.internal (unknown [14.161.14.188])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.dektech.com.au (Postfix) with ESMTPSA id 3A84C4B9D0;
        Thu, 28 Nov 2019 14:10:13 +1100 (AEDT)
From:   Tung Nguyen <tung.q.nguyen@dektech.com.au>
To:     davem@davemloft.net, netdev@vger.kernel.org,
        tipc-discussion@lists.sourceforge.net
Subject: [tipc-discussion] [net v1 4/4] tipc: fix duplicate SYN messages under link congestion
Date:   Thu, 28 Nov 2019 10:10:08 +0700
Message-Id: <20191128031008.2045-5-tung.q.nguyen@dektech.com.au>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20191128031008.2045-1-tung.q.nguyen@dektech.com.au>
References: <20191128031008.2045-1-tung.q.nguyen@dektech.com.au>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Scenario:
1. A client socket initiates a SYN message to a listening socket.
2. The send link is congested, the SYN message is put in the
send link and a wakeup message is put in wakeup queue.
3. The congestion situation is abated, the wakeup message is
pulled out of the wakeup queue. Function tipc_sk_push_backlog()
is called to send out delayed messages by Nagle. However,
the client socket is still in CONNECTING state. So, it sends
the SYN message in the socket write queue to the listening socket
again.
4. The listening socket receives the first SYN message and creates
first server socket. The client socket receives ACK- and establishes
a connection to the first server socket. The client socket closes
its connection with the first server socket.
5. The listening socket receives the second SYN message and creates
second server socket. The second server socket sends ACK- to the
client socket, but it has been closed. It results in connection
reset error when reading from the server socket in user space.

Solution: return from function tipc_sk_push_backlog() immediately
if there is pending SYN message in the socket write queue.

Fixes: c0bceb97db9e ("tipc: add smart nagle feature")
Signed-off-by: Tung Nguyen <tung.q.nguyen@dektech.com.au>
Acked-by: Jon Maloy <jon.maloy@ericsson.com>
---
 net/tipc/socket.c | 17 ++++++++++-------
 1 file changed, 10 insertions(+), 7 deletions(-)

diff --git a/net/tipc/socket.c b/net/tipc/socket.c
index da5fb84852a6..41688da233ab 100644
--- a/net/tipc/socket.c
+++ b/net/tipc/socket.c
@@ -540,12 +540,10 @@ static void __tipc_shutdown(struct socket *sock, int error)
 	tipc_wait_for_cond(sock, &timeout, (!tsk->cong_link_cnt &&
 					    !tsk_conn_cong(tsk)));
 
-	/* Push out unsent messages or remove if pending SYN */
-	skb = skb_peek(&sk->sk_write_queue);
-	if (skb && !msg_is_syn(buf_msg(skb)))
-		tipc_sk_push_backlog(tsk);
-	else
-		__skb_queue_purge(&sk->sk_write_queue);
+	/* Push out delayed messages if in Nagle mode */
+	tipc_sk_push_backlog(tsk);
+	/* Remove pending SYN */
+	__skb_queue_purge(&sk->sk_write_queue);
 
 	/* Reject all unreceived messages, except on an active connection
 	 * (which disconnects locally & sends a 'FIN+' to peer).
@@ -1248,9 +1246,14 @@ static void tipc_sk_push_backlog(struct tipc_sock *tsk)
 	struct sk_buff_head *txq = &tsk->sk.sk_write_queue;
 	struct net *net = sock_net(&tsk->sk);
 	u32 dnode = tsk_peer_node(tsk);
+	struct sk_buff *skb = skb_peek(txq);
 	int rc;
 
-	if (skb_queue_empty(txq) || tsk->cong_link_cnt)
+	if (!skb || tsk->cong_link_cnt)
+		return;
+
+	/* Do not send SYN again after congestion */
+	if (msg_is_syn(buf_msg(skb)))
 		return;
 
 	tsk->snt_unacked += tsk->snd_backlog;
-- 
2.17.1

