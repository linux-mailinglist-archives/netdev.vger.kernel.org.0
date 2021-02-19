Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E9A7931FDF5
	for <lists+netdev@lfdr.de>; Fri, 19 Feb 2021 18:38:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229774AbhBSRhi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Feb 2021 12:37:38 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:22537 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229684AbhBSRh3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Feb 2021 12:37:29 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1613756162;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=72/1zlL2fq+dcx2pAD2Hqg5FusOljmJGA1jb8pYkP9k=;
        b=Av4cKaxcdSBVOaAU5V37Z08DHeiE8wO+j+23tkSrsqdVuYgZdxYuFbN7759ASG4y/YX/r5
        rfIwEy/fDzAzyENlzsCrNmp26LCKSqC4xDK5NcxbxX/zr8V4hheqbbOm+TeX85lailrcYY
        gZ6yqhlNKuwOXhmgehaoIBwcoWauG5s=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-323-IEiKWl7qNwiILxA0_wO_ng-1; Fri, 19 Feb 2021 12:35:58 -0500
X-MC-Unique: IEiKWl7qNwiILxA0_wO_ng-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D1B54107ACF3;
        Fri, 19 Feb 2021 17:35:56 +0000 (UTC)
Received: from gerbillo.redhat.com (ovpn-115-85.ams2.redhat.com [10.36.115.85])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 511341971D;
        Fri, 19 Feb 2021 17:35:55 +0000 (UTC)
From:   Paolo Abeni <pabeni@redhat.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, mptcp@lists.01.org,
        Florian Westphal <fw@strlen.de>
Subject: [PATCH net 3/4] mptcp: provide subflow aware release function
Date:   Fri, 19 Feb 2021 18:35:39 +0100
Message-Id: <eba48b97ded37ff2bd9598adbe01f75f86e221fa.1613755058.git.pabeni@redhat.com>
In-Reply-To: <cover.1613755058.git.pabeni@redhat.com>
References: <cover.1613755058.git.pabeni@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Florian Westphal <fw@strlen.de>

mptcp re-used inet(6)_release, so the subflow sockets are ignored.
Need to invoke ip(v6)_mc_drop_socket function to ensure mcast join
resources get free'd.

Fixes: 717e79c867ca5 ("mptcp: Add setsockopt()/getsockopt() socket operations")
Closes: https://github.com/multipath-tcp/mptcp_net-next/issues/110
Acked-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 net/mptcp/protocol.c | 55 ++++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 53 insertions(+), 2 deletions(-)

diff --git a/net/mptcp/protocol.c b/net/mptcp/protocol.c
index 78bd4bed07ac..0a6d12d2967d 100644
--- a/net/mptcp/protocol.c
+++ b/net/mptcp/protocol.c
@@ -11,6 +11,7 @@
 #include <linux/netdevice.h>
 #include <linux/sched/signal.h>
 #include <linux/atomic.h>
+#include <linux/igmp.h>
 #include <net/sock.h>
 #include <net/inet_common.h>
 #include <net/inet_hashtables.h>
@@ -19,6 +20,7 @@
 #include <net/tcp_states.h>
 #if IS_ENABLED(CONFIG_MPTCP_IPV6)
 #include <net/transp_v6.h>
+#include <net/addrconf.h>
 #endif
 #include <net/mptcp.h>
 #include <net/xfrm.h>
@@ -3374,10 +3376,34 @@ static __poll_t mptcp_poll(struct file *file, struct socket *sock,
 	return mask;
 }
 
+static int mptcp_release(struct socket *sock)
+{
+	struct mptcp_subflow_context *subflow;
+	struct sock *sk = sock->sk;
+	struct mptcp_sock *msk;
+
+	if (!sk)
+		return 0;
+
+	lock_sock(sk);
+
+	msk = mptcp_sk(sk);
+
+	mptcp_for_each_subflow(msk, subflow) {
+		struct sock *ssk = mptcp_subflow_tcp_sock(subflow);
+
+		ip_mc_drop_socket(ssk);
+	}
+
+	release_sock(sk);
+
+	return inet_release(sock);
+}
+
 static const struct proto_ops mptcp_stream_ops = {
 	.family		   = PF_INET,
 	.owner		   = THIS_MODULE,
-	.release	   = inet_release,
+	.release	   = mptcp_release,
 	.bind		   = mptcp_bind,
 	.connect	   = mptcp_stream_connect,
 	.socketpair	   = sock_no_socketpair,
@@ -3424,10 +3450,35 @@ void __init mptcp_proto_init(void)
 }
 
 #if IS_ENABLED(CONFIG_MPTCP_IPV6)
+static int mptcp6_release(struct socket *sock)
+{
+	struct mptcp_subflow_context *subflow;
+	struct mptcp_sock *msk;
+	struct sock *sk = sock->sk;
+
+	if (!sk)
+		return 0;
+
+	lock_sock(sk);
+
+	msk = mptcp_sk(sk);
+
+	mptcp_for_each_subflow(msk, subflow) {
+		struct sock *ssk = mptcp_subflow_tcp_sock(subflow);
+
+		ip_mc_drop_socket(ssk);
+		ipv6_sock_mc_close(ssk);
+		ipv6_sock_ac_close(ssk);
+	}
+
+	release_sock(sk);
+	return inet6_release(sock);
+}
+
 static const struct proto_ops mptcp_v6_stream_ops = {
 	.family		   = PF_INET6,
 	.owner		   = THIS_MODULE,
-	.release	   = inet6_release,
+	.release	   = mptcp6_release,
 	.bind		   = mptcp_bind,
 	.connect	   = mptcp_stream_connect,
 	.socketpair	   = sock_no_socketpair,
-- 
2.26.2

