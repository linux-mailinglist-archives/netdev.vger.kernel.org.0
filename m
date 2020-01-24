Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BFE5E1489A3
	for <lists+netdev@lfdr.de>; Fri, 24 Jan 2020 15:37:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391335AbgAXOTL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Jan 2020 09:19:11 -0500
Received: from mail.kernel.org ([198.145.29.99]:39306 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2403984AbgAXOTK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 24 Jan 2020 09:19:10 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9022F214AF;
        Fri, 24 Jan 2020 14:19:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579875549;
        bh=818dV68auhzfZV8Z6AwH03tA4JCYnv794bYqjpVR21c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kp5f89L3W2SQNelsC3+v9B5AhvMe4uczht4aq62s/zdsYaeJ9peiUKgK3GFGItKf6
         +XVTVSd9TISMXQwOVAkeUtfvAGmCOBbMk9HoDX8A6QQ0qqkr3BGHAp3ANaM4Zsg42t
         uykbhpadGk3jKKWNL9s4GOqIe6jsnf4ZzETHvOX8=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Lingpeng Chen <forrest0579@gmail.com>,
        Arika Chen <eaglesora@gmail.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Song Liu <songliubraving@fb.com>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 044/107] bpf/sockmap: Read psock ingress_msg before sk_receive_queue
Date:   Fri, 24 Jan 2020 09:17:14 -0500
Message-Id: <20200124141817.28793-44-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200124141817.28793-1-sashal@kernel.org>
References: <20200124141817.28793-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Lingpeng Chen <forrest0579@gmail.com>

[ Upstream commit e7a5f1f1cd0008e5ad379270a8657e121eedb669 ]

Right now in tcp_bpf_recvmsg, sock read data first from sk_receive_queue
if not empty than psock->ingress_msg otherwise. If a FIN packet arrives
and there's also some data in psock->ingress_msg, the data in
psock->ingress_msg will be purged. It is always happen when request to a
HTTP1.0 server like python SimpleHTTPServer since the server send FIN
packet after data is sent out.

Fixes: 604326b41a6fb ("bpf, sockmap: convert to generic sk_msg interface")
Reported-by: Arika Chen <eaglesora@gmail.com>
Suggested-by: Arika Chen <eaglesora@gmail.com>
Signed-off-by: Lingpeng Chen <forrest0579@gmail.com>
Signed-off-by: John Fastabend <john.fastabend@gmail.com>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Acked-by: Song Liu <songliubraving@fb.com>
Link: https://lore.kernel.org/bpf/20200109014833.18951-1-forrest0579@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/tcp_bpf.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/net/ipv4/tcp_bpf.c b/net/ipv4/tcp_bpf.c
index e38705165ac9b..e6b08b5a08955 100644
--- a/net/ipv4/tcp_bpf.c
+++ b/net/ipv4/tcp_bpf.c
@@ -121,14 +121,14 @@ int tcp_bpf_recvmsg(struct sock *sk, struct msghdr *msg, size_t len,
 	struct sk_psock *psock;
 	int copied, ret;
 
-	if (unlikely(flags & MSG_ERRQUEUE))
-		return inet_recv_error(sk, msg, len, addr_len);
-	if (!skb_queue_empty(&sk->sk_receive_queue))
-		return tcp_recvmsg(sk, msg, len, nonblock, flags, addr_len);
-
 	psock = sk_psock_get(sk);
 	if (unlikely(!psock))
 		return tcp_recvmsg(sk, msg, len, nonblock, flags, addr_len);
+	if (unlikely(flags & MSG_ERRQUEUE))
+		return inet_recv_error(sk, msg, len, addr_len);
+	if (!skb_queue_empty(&sk->sk_receive_queue) &&
+	    sk_psock_queue_empty(psock))
+		return tcp_recvmsg(sk, msg, len, nonblock, flags, addr_len);
 	lock_sock(sk);
 msg_bytes_ready:
 	copied = __tcp_bpf_recvmsg(sk, psock, msg, len, flags);
@@ -139,7 +139,7 @@ msg_bytes_ready:
 		timeo = sock_rcvtimeo(sk, nonblock);
 		data = tcp_bpf_wait_data(sk, psock, flags, timeo, &err);
 		if (data) {
-			if (skb_queue_empty(&sk->sk_receive_queue))
+			if (!sk_psock_queue_empty(psock))
 				goto msg_bytes_ready;
 			release_sock(sk);
 			sk_psock_put(sk, psock);
-- 
2.20.1

