Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8522A351AD7
	for <lists+netdev@lfdr.de>; Thu,  1 Apr 2021 20:07:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237097AbhDASDX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Apr 2021 14:03:23 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:45220 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S237032AbhDAR7W (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Apr 2021 13:59:22 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1617299959;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=hg5lDUjDIV35CST3SAEwKb0ItcnfppBDuUprlCff6EM=;
        b=L5D89mfm8rrZnIsQ766LReI3R5/aAcOA5MZYrtFuhSxTQE9Q7wHyDqpja51r2zmtR1wM6a
        +TO7tgiehis1qbZzUjwgu92pW7pMnoB8hn1aL0xI/Ax5Yyc8oznn4Gs2jduLaIDf/QdliT
        kWsgh+c7f7CInAgVqFZ1lcF0cVDEoaU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-245-mRmZ1xVZNXmvFUIOjOwkDg-1; Thu, 01 Apr 2021 12:58:12 -0400
X-MC-Unique: mRmZ1xVZNXmvFUIOjOwkDg-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 345A91019623;
        Thu,  1 Apr 2021 16:58:11 +0000 (UTC)
Received: from gerbillo.redhat.com (ovpn-114-240.ams2.redhat.com [10.36.114.240])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 0C1AF19C46;
        Thu,  1 Apr 2021 16:58:09 +0000 (UTC)
From:   Paolo Abeni <pabeni@redhat.com>
To:     netdev@vger.kernel.org
Cc:     mptcp@lists.linux.dev, "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net 2/2] mptcp: revert "mptcp: provide subflow aware release function"
Date:   Thu,  1 Apr 2021 18:57:45 +0200
Message-Id: <ad4571485ca31026738cf57d67d68d681997a012.1617295578.git.pabeni@redhat.com>
In-Reply-To: <cover.1617295578.git.pabeni@redhat.com>
References: <cover.1617295578.git.pabeni@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This change reverts commit ad98dd37051e ("mptcp: provide subflow aware
release function"). The latter introduced a deadlock spotted by
syzkaller and is not needed anymore after the previous commit.

Fixes: ad98dd37051e ("mptcp: provide subflow aware release function")
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
---
 net/mptcp/protocol.c | 55 ++------------------------------------------
 1 file changed, 2 insertions(+), 53 deletions(-)

diff --git a/net/mptcp/protocol.c b/net/mptcp/protocol.c
index e06cea0a3c54..4bde960e19dc 100644
--- a/net/mptcp/protocol.c
+++ b/net/mptcp/protocol.c
@@ -11,7 +11,6 @@
 #include <linux/netdevice.h>
 #include <linux/sched/signal.h>
 #include <linux/atomic.h>
-#include <linux/igmp.h>
 #include <net/sock.h>
 #include <net/inet_common.h>
 #include <net/inet_hashtables.h>
@@ -20,7 +19,6 @@
 #include <net/tcp_states.h>
 #if IS_ENABLED(CONFIG_MPTCP_IPV6)
 #include <net/transp_v6.h>
-#include <net/addrconf.h>
 #endif
 #include <net/mptcp.h>
 #include <net/xfrm.h>
@@ -3464,34 +3462,10 @@ static __poll_t mptcp_poll(struct file *file, struct socket *sock,
 	return mask;
 }
 
-static int mptcp_release(struct socket *sock)
-{
-	struct mptcp_subflow_context *subflow;
-	struct sock *sk = sock->sk;
-	struct mptcp_sock *msk;
-
-	if (!sk)
-		return 0;
-
-	lock_sock(sk);
-
-	msk = mptcp_sk(sk);
-
-	mptcp_for_each_subflow(msk, subflow) {
-		struct sock *ssk = mptcp_subflow_tcp_sock(subflow);
-
-		ip_mc_drop_socket(ssk);
-	}
-
-	release_sock(sk);
-
-	return inet_release(sock);
-}
-
 static const struct proto_ops mptcp_stream_ops = {
 	.family		   = PF_INET,
 	.owner		   = THIS_MODULE,
-	.release	   = mptcp_release,
+	.release	   = inet_release,
 	.bind		   = mptcp_bind,
 	.connect	   = mptcp_stream_connect,
 	.socketpair	   = sock_no_socketpair,
@@ -3583,35 +3557,10 @@ void __init mptcp_proto_init(void)
 }
 
 #if IS_ENABLED(CONFIG_MPTCP_IPV6)
-static int mptcp6_release(struct socket *sock)
-{
-	struct mptcp_subflow_context *subflow;
-	struct mptcp_sock *msk;
-	struct sock *sk = sock->sk;
-
-	if (!sk)
-		return 0;
-
-	lock_sock(sk);
-
-	msk = mptcp_sk(sk);
-
-	mptcp_for_each_subflow(msk, subflow) {
-		struct sock *ssk = mptcp_subflow_tcp_sock(subflow);
-
-		ip_mc_drop_socket(ssk);
-		ipv6_sock_mc_close(ssk);
-		ipv6_sock_ac_close(ssk);
-	}
-
-	release_sock(sk);
-	return inet6_release(sock);
-}
-
 static const struct proto_ops mptcp_v6_stream_ops = {
 	.family		   = PF_INET6,
 	.owner		   = THIS_MODULE,
-	.release	   = mptcp6_release,
+	.release	   = inet6_release,
 	.bind		   = mptcp_bind,
 	.connect	   = mptcp_stream_connect,
 	.socketpair	   = sock_no_socketpair,
-- 
2.26.2

