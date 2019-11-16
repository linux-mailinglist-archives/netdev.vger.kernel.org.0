Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2634BFF31B
	for <lists+netdev@lfdr.de>; Sat, 16 Nov 2019 17:23:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729246AbfKPQXm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 16 Nov 2019 11:23:42 -0500
Received: from mail.kernel.org ([198.145.29.99]:46602 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728448AbfKPPmt (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 16 Nov 2019 10:42:49 -0500
Received: from sasha-vm.mshome.net (unknown [50.234.116.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 337D7207DD;
        Sat, 16 Nov 2019 15:42:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573918967;
        bh=JsC3oQ7k2jnfFKtbfYMCHgatAefXE5BD7sW+AdDdzsY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=00N1zSnlcW3BnXkYpXi+rva69fpJC/FHqe1BL2w5K/eFEIP0XPmvs+XeiB4k9sl4T
         kJnMujaFK+X0o0fiC9rZ5aeU7DclqN56sQl9w1RVGsjp89JVtfXaIbw2ZQvrg/gVZr
         q1qECgahiRBDH6rUDy6DFF8dZbxMh8Fa7GPq3PuQ=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     "J. Bruce Fields" <bfields@redhat.com>,
        Trond Myklebust <trond.myklebust@hammerspace.com>,
        Sasha Levin <sashal@kernel.org>, linux-nfs@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 083/237] sunrpc: safely reallow resvport min/max inversion
Date:   Sat, 16 Nov 2019 10:38:38 -0500
Message-Id: <20191116154113.7417-83-sashal@kernel.org>
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

From: "J. Bruce Fields" <bfields@redhat.com>

[ Upstream commit 826799e66e8683e5698e140bb9ef69afc8c0014e ]

Commits ffb6ca33b04b and e08ea3a96fc7 prevent setting xprt_min_resvport
greater than xprt_max_resvport, but may also break simple code that sets
one parameter then the other, if the new range does not overlap the old.

Also it looks racy to me, unless there's some serialization I'm not
seeing.  Granted it would probably require malicious privileged processes
(unless there's a chance these might eventually be settable in unprivileged
containers), but still it seems better not to let userspace panic the
kernel.

Simpler seems to be to allow setting the parameters to whatever you want
but interpret xprt_min_resvport > xprt_max_resvport as the empty range.

Fixes: ffb6ca33b04b "sunrpc: Prevent resvport min/max inversion..."
Fixes: e08ea3a96fc7 "sunrpc: Prevent rexvport min/max inversion..."
Signed-off-by: J. Bruce Fields <bfields@redhat.com>
Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sunrpc/xprtsock.c | 34 ++++++++++++++++++----------------
 1 file changed, 18 insertions(+), 16 deletions(-)

diff --git a/net/sunrpc/xprtsock.c b/net/sunrpc/xprtsock.c
index 7d8cce1dfcad3..adecfd40953f6 100644
--- a/net/sunrpc/xprtsock.c
+++ b/net/sunrpc/xprtsock.c
@@ -129,7 +129,7 @@ static struct ctl_table xs_tunables_table[] = {
 		.mode		= 0644,
 		.proc_handler	= proc_dointvec_minmax,
 		.extra1		= &xprt_min_resvport_limit,
-		.extra2		= &xprt_max_resvport
+		.extra2		= &xprt_max_resvport_limit
 	},
 	{
 		.procname	= "max_resvport",
@@ -137,7 +137,7 @@ static struct ctl_table xs_tunables_table[] = {
 		.maxlen		= sizeof(unsigned int),
 		.mode		= 0644,
 		.proc_handler	= proc_dointvec_minmax,
-		.extra1		= &xprt_min_resvport,
+		.extra1		= &xprt_min_resvport_limit,
 		.extra2		= &xprt_max_resvport_limit
 	},
 	{
@@ -1773,11 +1773,17 @@ static void xs_udp_timer(struct rpc_xprt *xprt, struct rpc_task *task)
 	spin_unlock_bh(&xprt->transport_lock);
 }
 
-static unsigned short xs_get_random_port(void)
+static int xs_get_random_port(void)
 {
-	unsigned short range = xprt_max_resvport - xprt_min_resvport + 1;
-	unsigned short rand = (unsigned short) prandom_u32() % range;
-	return rand + xprt_min_resvport;
+	unsigned short min = xprt_min_resvport, max = xprt_max_resvport;
+	unsigned short range;
+	unsigned short rand;
+
+	if (max < min)
+		return -EADDRINUSE;
+	range = max - min + 1;
+	rand = (unsigned short) prandom_u32() % range;
+	return rand + min;
 }
 
 /**
@@ -1833,9 +1839,9 @@ static void xs_set_srcport(struct sock_xprt *transport, struct socket *sock)
 		transport->srcport = xs_sock_getport(sock);
 }
 
-static unsigned short xs_get_srcport(struct sock_xprt *transport)
+static int xs_get_srcport(struct sock_xprt *transport)
 {
-	unsigned short port = transport->srcport;
+	int port = transport->srcport;
 
 	if (port == 0 && transport->xprt.resvport)
 		port = xs_get_random_port();
@@ -1856,7 +1862,7 @@ static int xs_bind(struct sock_xprt *transport, struct socket *sock)
 {
 	struct sockaddr_storage myaddr;
 	int err, nloop = 0;
-	unsigned short port = xs_get_srcport(transport);
+	int port = xs_get_srcport(transport);
 	unsigned short last;
 
 	/*
@@ -1874,8 +1880,8 @@ static int xs_bind(struct sock_xprt *transport, struct socket *sock)
 	 * transport->xprt.resvport == 1) xs_get_srcport above will
 	 * ensure that port is non-zero and we will bind as needed.
 	 */
-	if (port == 0)
-		return 0;
+	if (port <= 0)
+		return port;
 
 	memcpy(&myaddr, &transport->srcaddr, transport->xprt.addrlen);
 	do {
@@ -3317,12 +3323,8 @@ static int param_set_uint_minmax(const char *val,
 
 static int param_set_portnr(const char *val, const struct kernel_param *kp)
 {
-	if (kp->arg == &xprt_min_resvport)
-		return param_set_uint_minmax(val, kp,
-			RPC_MIN_RESVPORT,
-			xprt_max_resvport);
 	return param_set_uint_minmax(val, kp,
-			xprt_min_resvport,
+			RPC_MIN_RESVPORT,
 			RPC_MAX_RESVPORT);
 }
 
-- 
2.20.1

