Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2CF2740834E
	for <lists+netdev@lfdr.de>; Mon, 13 Sep 2021 06:06:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233364AbhIMEGT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Sep 2021 00:06:19 -0400
Received: from out0.migadu.com ([94.23.1.103]:63795 "EHLO out0.migadu.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229793AbhIMEGS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 13 Sep 2021 00:06:18 -0400
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1631505896;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=dDi0EBey+fTk+gMxs/hbMAsZ2CO16dXmIG7oQmqFe8A=;
        b=cKMmrn9huapcnUmubkdisNXNbhQlWCXmDlVuLqmofy44yzsjPddlQy/hOxGWcqlogPidJA
        Deb0UNOOmpqbmHAlRj0b1CwZKHuDdEETtXThRPxf5eVm38fhqivt0FO1ED7Gi1+L+VvGQF
        9wb1/1yTkkLL1BgImVvE4uHiNnph90w=
From:   Yajun Deng <yajun.deng@linux.dev>
To:     davem@davemloft.net, yoshfuji@linux-ipv6.org, dsahern@kernel.org,
        kuba@kernel.org
Cc:     edumazet@google.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Yajun Deng <yajun.deng@linux.dev>
Subject: [PATCH] Revert "ipv4: fix memory leaks in ip_cmsg_send() callers"
Date:   Mon, 13 Sep 2021 12:04:42 +0800
Message-Id: <20210913040442.2627-1-yajun.deng@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Migadu-Auth-User: yajun.deng@linux.dev
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This reverts commit 919483096bfe75dda338e98d56da91a263746a0a.

There is only when ip_options_get() return zero need to free.
It already called kfree() when return error.

Fixes: 919483096bfe ("ipv4: fix memory leaks in ip_cmsg_send() callers")
Signed-off-by: Yajun Deng <yajun.deng@linux.dev>
---
 net/ipv4/ip_sockglue.c | 2 +-
 net/ipv4/ping.c        | 5 ++---
 net/ipv4/raw.c         | 5 ++---
 net/ipv4/udp.c         | 5 ++---
 4 files changed, 7 insertions(+), 10 deletions(-)

diff --git a/net/ipv4/ip_sockglue.c b/net/ipv4/ip_sockglue.c
index b297bb28556e..7cef9987ab4a 100644
--- a/net/ipv4/ip_sockglue.c
+++ b/net/ipv4/ip_sockglue.c
@@ -279,7 +279,7 @@ int ip_cmsg_send(struct sock *sk, struct msghdr *msg, struct ipcm_cookie *ipc,
 		case IP_RETOPTS:
 			err = cmsg->cmsg_len - sizeof(struct cmsghdr);
 
-			/* Our caller is responsible for freeing ipc->opt */
+			/* Our caller is responsible for freeing ipc->opt when err = 0 */
 			err = ip_options_get(net, &ipc->opt,
 					     KERNEL_SOCKPTR(CMSG_DATA(cmsg)),
 					     err < 40 ? err : 40);
diff --git a/net/ipv4/ping.c b/net/ipv4/ping.c
index 1e44a43acfe2..c588f9f2f46c 100644
--- a/net/ipv4/ping.c
+++ b/net/ipv4/ping.c
@@ -727,10 +727,9 @@ static int ping_v4_sendmsg(struct sock *sk, struct msghdr *msg, size_t len)
 
 	if (msg->msg_controllen) {
 		err = ip_cmsg_send(sk, msg, &ipc, false);
-		if (unlikely(err)) {
-			kfree(ipc.opt);
+		if (unlikely(err))
 			return err;
-		}
+
 		if (ipc.opt)
 			free = 1;
 	}
diff --git a/net/ipv4/raw.c b/net/ipv4/raw.c
index bb446e60cf58..1c98063a3ae8 100644
--- a/net/ipv4/raw.c
+++ b/net/ipv4/raw.c
@@ -562,10 +562,9 @@ static int raw_sendmsg(struct sock *sk, struct msghdr *msg, size_t len)
 
 	if (msg->msg_controllen) {
 		err = ip_cmsg_send(sk, msg, &ipc, false);
-		if (unlikely(err)) {
-			kfree(ipc.opt);
+		if (unlikely(err))
 			goto out;
-		}
+
 		if (ipc.opt)
 			free = 1;
 	}
diff --git a/net/ipv4/udp.c b/net/ipv4/udp.c
index 8851c9463b4b..d5f5981d7a43 100644
--- a/net/ipv4/udp.c
+++ b/net/ipv4/udp.c
@@ -1122,10 +1122,9 @@ int udp_sendmsg(struct sock *sk, struct msghdr *msg, size_t len)
 		if (err > 0)
 			err = ip_cmsg_send(sk, msg, &ipc,
 					   sk->sk_family == AF_INET6);
-		if (unlikely(err < 0)) {
-			kfree(ipc.opt);
+		if (unlikely(err < 0))
 			return err;
-		}
+
 		if (ipc.opt)
 			free = 1;
 		connected = 0;
-- 
2.32.0

