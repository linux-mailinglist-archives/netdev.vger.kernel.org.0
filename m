Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DFFA4FED34
	for <lists+netdev@lfdr.de>; Sat, 16 Nov 2019 16:42:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728430AbfKPPmp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 16 Nov 2019 10:42:45 -0500
Received: from mail.kernel.org ([198.145.29.99]:46518 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728408AbfKPPmo (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 16 Nov 2019 10:42:44 -0500
Received: from sasha-vm.mshome.net (unknown [50.234.116.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 11D9C2084E;
        Sat, 16 Nov 2019 15:42:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573918963;
        bh=Dj2rTLwWDO1pOTVTST4jx2q+awzIqfqNPlMUZC3OWqM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YWSwGJDYb0S1qe158zQ5AN5ZFUc5s+vMe4qlzglMtPiQfXg7OmMf6hfWTPINHx/gY
         FkIBKZAPOxqz7ziL1MEON0X3SPKXO4RcGoqPHsdX+RIITzSg6V0Qfyo7xGFCuREECu
         eYFgCC5a+GprUrPgxSCt5x5gJXZASEnge1V2EW/g=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Xin Long <lucien.xin@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, linux-sctp@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 079/237] sctp: use sk_wmem_queued to check for writable space
Date:   Sat, 16 Nov 2019 10:38:34 -0500
Message-Id: <20191116154113.7417-79-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191116154113.7417-1-sashal@kernel.org>
References: <20191116154113.7417-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Xin Long <lucien.xin@gmail.com>

[ Upstream commit cd305c74b0f8b49748a79a8f67fc8e5e3e0c4794 ]

sk->sk_wmem_queued is used to count the size of chunks in out queue
while sk->sk_wmem_alloc is for counting the size of chunks has been
sent. sctp is increasing both of them before enqueuing the chunks,
and using sk->sk_wmem_alloc to check for writable space.

However, sk_wmem_alloc is also increased by 1 for the skb allocked
for sending in sctp_packet_transmit() but it will not wake up the
waiters when sk_wmem_alloc is decreased in this skb's destructor.

If msg size is equal to sk_sndbuf and sendmsg is waiting for sndbuf,
the check 'msg_len <= sctp_wspace(asoc)' in sctp_wait_for_sndbuf()
will keep waiting if there's a skb allocked in sctp_packet_transmit,
and later even if this skb got freed, the waiting thread will never
get waked up.

This issue has been there since very beginning, so we change to use
sk->sk_wmem_queued to check for writable space as sk_wmem_queued is
not increased for the skb allocked for sending, also as TCP does.

SOCK_SNDBUF_LOCK check is also removed here as it's for tx buf auto
tuning which I will add in another patch.

Signed-off-by: Xin Long <lucien.xin@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sctp/socket.c | 38 +++++++++-----------------------------
 1 file changed, 9 insertions(+), 29 deletions(-)

diff --git a/net/sctp/socket.c b/net/sctp/socket.c
index c766315527226..e7a11cd7633f5 100644
--- a/net/sctp/socket.c
+++ b/net/sctp/socket.c
@@ -83,7 +83,7 @@
 #include <net/sctp/stream_sched.h>
 
 /* Forward declarations for internal helper functions. */
-static int sctp_writeable(struct sock *sk);
+static bool sctp_writeable(struct sock *sk);
 static void sctp_wfree(struct sk_buff *skb);
 static int sctp_wait_for_sndbuf(struct sctp_association *asoc, long *timeo_p,
 				size_t msg_len);
@@ -119,25 +119,10 @@ static void sctp_enter_memory_pressure(struct sock *sk)
 /* Get the sndbuf space available at the time on the association.  */
 static inline int sctp_wspace(struct sctp_association *asoc)
 {
-	int amt;
+	struct sock *sk = asoc->base.sk;
 
-	if (asoc->ep->sndbuf_policy)
-		amt = asoc->sndbuf_used;
-	else
-		amt = sk_wmem_alloc_get(asoc->base.sk);
-
-	if (amt >= asoc->base.sk->sk_sndbuf) {
-		if (asoc->base.sk->sk_userlocks & SOCK_SNDBUF_LOCK)
-			amt = 0;
-		else {
-			amt = sk_stream_wspace(asoc->base.sk);
-			if (amt < 0)
-				amt = 0;
-		}
-	} else {
-		amt = asoc->base.sk->sk_sndbuf - amt;
-	}
-	return amt;
+	return asoc->ep->sndbuf_policy ? sk->sk_sndbuf - asoc->sndbuf_used
+				       : sk_stream_wspace(sk);
 }
 
 /* Increment the used sndbuf space count of the corresponding association by
@@ -1928,10 +1913,10 @@ static int sctp_sendmsg_to_asoc(struct sctp_association *asoc,
 		asoc->pmtu_pending = 0;
 	}
 
-	if (sctp_wspace(asoc) < msg_len)
+	if (sctp_wspace(asoc) < (int)msg_len)
 		sctp_prsctp_prune(asoc, sinfo, msg_len - sctp_wspace(asoc));
 
-	if (!sctp_wspace(asoc)) {
+	if (sctp_wspace(asoc) <= 0) {
 		timeo = sock_sndtimeo(sk, msg->msg_flags & MSG_DONTWAIT);
 		err = sctp_wait_for_sndbuf(asoc, &timeo, msg_len);
 		if (err)
@@ -8516,7 +8501,7 @@ static int sctp_wait_for_sndbuf(struct sctp_association *asoc, long *timeo_p,
 			goto do_error;
 		if (signal_pending(current))
 			goto do_interrupted;
-		if (msg_len <= sctp_wspace(asoc))
+		if ((int)msg_len <= sctp_wspace(asoc))
 			break;
 
 		/* Let another process have a go.  Since we are going
@@ -8591,14 +8576,9 @@ void sctp_write_space(struct sock *sk)
  * UDP-style sockets or TCP-style sockets, this code should work.
  *  - Daisy
  */
-static int sctp_writeable(struct sock *sk)
+static bool sctp_writeable(struct sock *sk)
 {
-	int amt = 0;
-
-	amt = sk->sk_sndbuf - sk_wmem_alloc_get(sk);
-	if (amt < 0)
-		amt = 0;
-	return amt;
+	return sk->sk_sndbuf > sk->sk_wmem_queued;
 }
 
 /* Wait for an association to go into ESTABLISHED state. If timeout is 0,
-- 
2.20.1

