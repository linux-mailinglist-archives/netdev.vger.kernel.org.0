Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 20DCE42ADB7
	for <lists+netdev@lfdr.de>; Tue, 12 Oct 2021 22:21:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234182AbhJLUW5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Oct 2021 16:22:57 -0400
Received: from relay2-d.mail.gandi.net ([217.70.183.194]:37395 "EHLO
        relay2-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231902AbhJLUWx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Oct 2021 16:22:53 -0400
Received: from h7.dl5rb.org.uk (pd95470b6.dip0.t-ipconnect.de [217.84.112.182])
        (Authenticated sender: ralf@linux-mips.org)
        by relay2-d.mail.gandi.net (Postfix) with ESMTPSA id 5EC0640002;
        Tue, 12 Oct 2021 20:20:48 +0000 (UTC)
Received: from h7.dl5rb.org.uk (localhost [127.0.0.1])
        by h7.dl5rb.org.uk (8.16.1/8.16.1) with ESMTPS id 19CKKkCU217658
        (version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
        Tue, 12 Oct 2021 22:20:46 +0200
Received: (from ralf@localhost)
        by h7.dl5rb.org.uk (8.16.1/8.16.1/Submit) id 19CKKkBp217657;
        Tue, 12 Oct 2021 22:20:46 +0200
Message-Id: <4a2f53386509164e60531750a02480a4c032d51a.1634069168.git.ralf@linux-mips.org>
In-Reply-To: <2dea23e9208d008e74faddf92acf4ef557f97a85.1634069168.git.ralf@linux-mips.org>
References: <2dea23e9208d008e74faddf92acf4ef557f97a85.1634069168.git.ralf@linux-mips.org>
From:   Ralf Baechle <ralf@linux-mips.org>
Date:   Tue, 12 Oct 2021 22:05:30 +0200
Subject: [PATCH 2/2] ax25: Fix deadlock hang during concurrent read and
 write on socket.
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Christoph Hellwig <hch@lst.de>,
        Thomas Osterried <thomas@osterried.de>,
        linux-hams@vger.kernel.org
Lines:  68
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Thomas Habets <thomas@habets.se>

Before this patch, this hangs, because the read(2) blocks the
write(2).

Before:
strace -f -eread,write ./examples/client_lockcheck M0THC-9 M0THC-0 M0THC-2
strace: Process 3888 attached
[pid  3888] read(3,  <unfinished ...>
[pid  3887] write(3, "hello world", 11
[hang]

After:
strace -f -eread,write ./examples/client_lockcheck M0THC-9 M0THC-0 M0THC-2
strace: Process 2433 attached
[pid  2433] read(3,  <unfinished ...>
[pid  2432] write(3, "hello world", 11) = 11
[pid  2433] <... read resumed> "yo", 1000) = 2
[pid  2433] write(1, "yo\n", 3yo
)         = 3
[successful exit]

Signed-off-by: Thomas Habets <thomas@habets.se>
Signed-off-by: Ralf Baechle <ralf@linux-mips.org>
---
 net/ax25/af_ax25.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/net/ax25/af_ax25.c b/net/ax25/af_ax25.c
index 5e7ab76f7f9b..d2d0dd744bb4 100644
--- a/net/ax25/af_ax25.c
+++ b/net/ax25/af_ax25.c
@@ -1624,22 +1624,22 @@ static int ax25_recvmsg(struct socket *sock, struct msghdr *msg, size_t size,
 	int copied;
 	int err = 0;
 
-	lock_sock(sk);
 	/*
 	 * 	This works for seqpacket too. The receiver has ordered the
 	 *	queue for us! We do one quick check first though
 	 */
 	if (sk->sk_type == SOCK_SEQPACKET && sk->sk_state != TCP_ESTABLISHED) {
 		err =  -ENOTCONN;
-		goto out;
+		goto out_nolock;
 	}
 
 	/* Now we can treat all alike */
 	skb = skb_recv_datagram(sk, flags & ~MSG_DONTWAIT,
 				flags & MSG_DONTWAIT, &err);
 	if (skb == NULL)
-		goto out;
+		goto out_nolock;
 
+	lock_sock(sk);
 	if (!sk_to_ax25(sk)->pidincl)
 		skb_pull(skb, 1);		/* Remove PID */
 
@@ -1684,6 +1684,7 @@ static int ax25_recvmsg(struct socket *sock, struct msghdr *msg, size_t size,
 
 out:
 	release_sock(sk);
+out_nolock:
 
 	return err;
 }
-- 
2.31.1

