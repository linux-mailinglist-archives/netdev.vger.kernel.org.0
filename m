Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 58340DD43E
	for <lists+netdev@lfdr.de>; Sat, 19 Oct 2019 00:23:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405253AbfJRWX0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Oct 2019 18:23:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:37158 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729538AbfJRWFU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 18 Oct 2019 18:05:20 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AE0C2222C2;
        Fri, 18 Oct 2019 22:05:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1571436319;
        bh=vk8+b7SiuqvG0ZON2WuQ93hgwJbDz+Km6Ck2/nY0Gbk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CNtOLVi0qpFF0oxMhwmPfNDBlFnjOpq8IbVp4GA/H/4ZWw5r4LXNjhGqbkx5Q4GON
         SXICx90omnYQQ0DzVrhfRbhzzjW/K0lmA/Fvx3zyY1lt7SqxY1SFHLe65Q4cQK78Tx
         1Rv4/vPtzgFgjOI6CUlQOg/tNrUDo4IEHm7r4uVg=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Benjamin Coddington <bcodding@redhat.com>,
        Anna Schumaker <Anna.Schumaker@Netapp.com>,
        Sasha Levin <sashal@kernel.org>, linux-nfs@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.3 87/89] SUNRPC: fix race to sk_err after xs_error_report
Date:   Fri, 18 Oct 2019 18:03:22 -0400
Message-Id: <20191018220324.8165-87-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191018220324.8165-1-sashal@kernel.org>
References: <20191018220324.8165-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Benjamin Coddington <bcodding@redhat.com>

[ Upstream commit af84537dbd1b39505d1f3d8023029b4a59666513 ]

Since commit 4f8943f80883 ("SUNRPC: Replace direct task wakeups from
softirq context") there has been a race to the value of the sk_err if both
XPRT_SOCK_WAKE_ERROR and XPRT_SOCK_WAKE_DISCONNECT are set.  In that case,
we may end up losing the sk_err value that existed when xs_error_report was
called.

Fix this by reverting to the previous behavior: instead of using SO_ERROR
to retrieve the value at a later time (which might also return sk_err_soft),
copy the sk_err value onto struct sock_xprt, and use that value to wake
pending tasks.

Signed-off-by: Benjamin Coddington <bcodding@redhat.com>
Fixes: 4f8943f80883 ("SUNRPC: Replace direct task wakeups from softirq context")
Signed-off-by: Anna Schumaker <Anna.Schumaker@Netapp.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/sunrpc/xprtsock.h |  1 +
 net/sunrpc/xprtsock.c           | 17 ++++++++---------
 2 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/include/linux/sunrpc/xprtsock.h b/include/linux/sunrpc/xprtsock.h
index 7638dbe7bc500..a940de03808dd 100644
--- a/include/linux/sunrpc/xprtsock.h
+++ b/include/linux/sunrpc/xprtsock.h
@@ -61,6 +61,7 @@ struct sock_xprt {
 	struct mutex		recv_mutex;
 	struct sockaddr_storage	srcaddr;
 	unsigned short		srcport;
+	int			xprt_err;
 
 	/*
 	 * UDP socket buffer size parameters
diff --git a/net/sunrpc/xprtsock.c b/net/sunrpc/xprtsock.c
index e2176c167a579..4e0b5bed6c737 100644
--- a/net/sunrpc/xprtsock.c
+++ b/net/sunrpc/xprtsock.c
@@ -1243,19 +1243,21 @@ static void xs_error_report(struct sock *sk)
 {
 	struct sock_xprt *transport;
 	struct rpc_xprt *xprt;
-	int err;
 
 	read_lock_bh(&sk->sk_callback_lock);
 	if (!(xprt = xprt_from_sock(sk)))
 		goto out;
 
 	transport = container_of(xprt, struct sock_xprt, xprt);
-	err = -sk->sk_err;
-	if (err == 0)
+	transport->xprt_err = -sk->sk_err;
+	if (transport->xprt_err == 0)
 		goto out;
 	dprintk("RPC:       xs_error_report client %p, error=%d...\n",
-			xprt, -err);
-	trace_rpc_socket_error(xprt, sk->sk_socket, err);
+			xprt, -transport->xprt_err);
+	trace_rpc_socket_error(xprt, sk->sk_socket, transport->xprt_err);
+
+	/* barrier ensures xprt_err is set before XPRT_SOCK_WAKE_ERROR */
+	smp_mb__before_atomic();
 	xs_run_error_worker(transport, XPRT_SOCK_WAKE_ERROR);
  out:
 	read_unlock_bh(&sk->sk_callback_lock);
@@ -2470,7 +2472,6 @@ static void xs_wake_write(struct sock_xprt *transport)
 static void xs_wake_error(struct sock_xprt *transport)
 {
 	int sockerr;
-	int sockerr_len = sizeof(sockerr);
 
 	if (!test_bit(XPRT_SOCK_WAKE_ERROR, &transport->sock_state))
 		return;
@@ -2479,9 +2480,7 @@ static void xs_wake_error(struct sock_xprt *transport)
 		goto out;
 	if (!test_and_clear_bit(XPRT_SOCK_WAKE_ERROR, &transport->sock_state))
 		goto out;
-	if (kernel_getsockopt(transport->sock, SOL_SOCKET, SO_ERROR,
-				(char *)&sockerr, &sockerr_len) != 0)
-		goto out;
+	sockerr = xchg(&transport->xprt_err, 0);
 	if (sockerr < 0)
 		xprt_wake_pending_tasks(&transport->xprt, sockerr);
 out:
-- 
2.20.1

