Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BE145FA432
	for <lists+netdev@lfdr.de>; Wed, 13 Nov 2019 03:17:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730132AbfKMCPA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Nov 2019 21:15:00 -0500
Received: from mail.kernel.org ([198.145.29.99]:49944 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728645AbfKMB5D (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 12 Nov 2019 20:57:03 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7C58C222D4;
        Wed, 13 Nov 2019 01:57:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573610222;
        bh=Suk00SgfBhbrNb/3ynvFXyR8ZpUSM4dQi1HdmAwqQ+4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=W43LY7aaSswr7v8WT37vWBUMYQNavlCDPEnFbUdr53uBDZwB/5a6JvIBKUMJtMNBr
         dvm1nqrV8y7hs0UpbgZKCvvYx8tfeeBgqYyFPsoz6Ii46hk527YwJJSJuO0gVQsaGV
         A5jocQNSSVmsEMkSXkN7PWwQOBy9vQ5r3+2xG+Rs=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Chuck Lever <chuck.lever@oracle.com>,
        Anna Schumaker <Anna.Schumaker@Netapp.com>,
        Sasha Levin <sashal@kernel.org>, linux-nfs@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 027/115] sunrpc: Fix connect metrics
Date:   Tue, 12 Nov 2019 20:54:54 -0500
Message-Id: <20191113015622.11592-27-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191113015622.11592-1-sashal@kernel.org>
References: <20191113015622.11592-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Chuck Lever <chuck.lever@oracle.com>

[ Upstream commit 3968a8a5310404c2f0b9e4d9f28cab13a12bc4fd ]

For TCP, the logic in xprt_connect_status is currently never invoked
to record a successful connection. Commit 2a4919919a97 ("SUNRPC:
Return EAGAIN instead of ENOTCONN when waking up xprt->pending")
changed the way TCP xprt's are awoken after a connect succeeds.

Instead, change connection-oriented transports to bump connect_count
and compute connect_time the moment that XPRT_CONNECTED is set.

Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Anna Schumaker <Anna.Schumaker@Netapp.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sunrpc/xprt.c               | 14 ++++----------
 net/sunrpc/xprtrdma/transport.c |  6 +++++-
 net/sunrpc/xprtsock.c           | 10 ++++++----
 3 files changed, 15 insertions(+), 15 deletions(-)

diff --git a/net/sunrpc/xprt.c b/net/sunrpc/xprt.c
index d0282cc88b145..b852c34bb6373 100644
--- a/net/sunrpc/xprt.c
+++ b/net/sunrpc/xprt.c
@@ -795,17 +795,11 @@ void xprt_connect(struct rpc_task *task)
 
 static void xprt_connect_status(struct rpc_task *task)
 {
-	struct rpc_xprt	*xprt = task->tk_rqstp->rq_xprt;
-
-	if (task->tk_status == 0) {
-		xprt->stat.connect_count++;
-		xprt->stat.connect_time += (long)jiffies - xprt->stat.connect_start;
+	switch (task->tk_status) {
+	case 0:
 		dprintk("RPC: %5u xprt_connect_status: connection established\n",
 				task->tk_pid);
-		return;
-	}
-
-	switch (task->tk_status) {
+		break;
 	case -ECONNREFUSED:
 	case -ECONNRESET:
 	case -ECONNABORTED:
@@ -822,7 +816,7 @@ static void xprt_connect_status(struct rpc_task *task)
 	default:
 		dprintk("RPC: %5u xprt_connect_status: error %d connecting to "
 				"server %s\n", task->tk_pid, -task->tk_status,
-				xprt->servername);
+				task->tk_rqstp->rq_xprt->servername);
 		task->tk_status = -EIO;
 	}
 }
diff --git a/net/sunrpc/xprtrdma/transport.c b/net/sunrpc/xprtrdma/transport.c
index 8cf5ccfe180d3..b1b40a1be8c57 100644
--- a/net/sunrpc/xprtrdma/transport.c
+++ b/net/sunrpc/xprtrdma/transport.c
@@ -238,8 +238,12 @@ rpcrdma_connect_worker(struct work_struct *work)
 	if (++xprt->connect_cookie == 0)	/* maintain a reserved value */
 		++xprt->connect_cookie;
 	if (ep->rep_connected > 0) {
-		if (!xprt_test_and_set_connected(xprt))
+		if (!xprt_test_and_set_connected(xprt)) {
+			xprt->stat.connect_count++;
+			xprt->stat.connect_time += (long)jiffies -
+						   xprt->stat.connect_start;
 			xprt_wake_pending_tasks(xprt, 0);
+		}
 	} else {
 		if (xprt_test_and_clear_connected(xprt))
 			xprt_wake_pending_tasks(xprt, -ENOTCONN);
diff --git a/net/sunrpc/xprtsock.c b/net/sunrpc/xprtsock.c
index 05a58cc1b0cdb..a42871a59f3b9 100644
--- a/net/sunrpc/xprtsock.c
+++ b/net/sunrpc/xprtsock.c
@@ -1592,6 +1592,9 @@ static void xs_tcp_state_change(struct sock *sk)
 			clear_bit(XPRT_SOCK_CONNECTING, &transport->sock_state);
 			xprt_clear_connecting(xprt);
 
+			xprt->stat.connect_count++;
+			xprt->stat.connect_time += (long)jiffies -
+						   xprt->stat.connect_start;
 			xprt_wake_pending_tasks(xprt, -EAGAIN);
 		}
 		spin_unlock(&xprt->transport_lock);
@@ -2008,8 +2011,6 @@ static int xs_local_finish_connecting(struct rpc_xprt *xprt,
 	}
 
 	/* Tell the socket layer to start connecting... */
-	xprt->stat.connect_count++;
-	xprt->stat.connect_start = jiffies;
 	return kernel_connect(sock, xs_addr(xprt), xprt->addrlen, 0);
 }
 
@@ -2041,6 +2042,9 @@ static int xs_local_setup_socket(struct sock_xprt *transport)
 	case 0:
 		dprintk("RPC:       xprt %p connected to %s\n",
 				xprt, xprt->address_strings[RPC_DISPLAY_ADDR]);
+		xprt->stat.connect_count++;
+		xprt->stat.connect_time += (long)jiffies -
+					   xprt->stat.connect_start;
 		xprt_set_connected(xprt);
 	case -ENOBUFS:
 		break;
@@ -2361,8 +2365,6 @@ static int xs_tcp_finish_connecting(struct rpc_xprt *xprt, struct socket *sock)
 	xs_set_memalloc(xprt);
 
 	/* Tell the socket layer to start connecting... */
-	xprt->stat.connect_count++;
-	xprt->stat.connect_start = jiffies;
 	set_bit(XPRT_SOCK_CONNECTING, &transport->sock_state);
 	ret = kernel_connect(sock, xs_addr(xprt), xprt->addrlen, O_NONBLOCK);
 	switch (ret) {
-- 
2.20.1

