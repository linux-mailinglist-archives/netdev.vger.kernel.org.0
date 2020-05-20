Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3F4011DBEC6
	for <lists+netdev@lfdr.de>; Wed, 20 May 2020 21:58:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728350AbgETT44 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 May 2020 15:56:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51228 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726823AbgETT4x (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 May 2020 15:56:53 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 87212C061A0E;
        Wed, 20 May 2020 12:56:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=z+Z2TW/3RPJPOSxfa96vk+0o2LedKuFggBBQbhx1yZo=; b=dMr9xo9u0A3lqfinh/X1UWLHNk
        Q48tNnUezgV62MrJJ8bU2AAxq2nkyuI+ixj2f6xi1tir7MhDQX8OPRXlOfbEWNHzjzkS3ZXCDnoa7
        SFXasl15hh+9XUMU02ShM1gOxQ1Op81msGT2rAEoYAaSXT8RkXhGKrwZyiWFVYE4fhYTF7CkOoFBP
        IXqpAd6SQfo1LbFbKg5zJBlY9a//68ffBHvr5YFQp8GtquK2H2qnYW6MFXnAvveCBUAIvyAsr7jul
        JSFi0jA8xnywl5OfT4JmyAZA/14Hv8p657eQBvZ6FmUDT/ZdKcSLxAtmTMBZ8gm7UD5HPEvwQlIES
        dsVO99oQ==;
Received: from [2001:4bb8:188:1506:c70:4a89:bc61:2] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jbUpC-0003Ct-0A; Wed, 20 May 2020 19:56:22 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Eric Dumazet <edumazet@google.com>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Vlad Yasevich <vyasevich@gmail.com>,
        Neil Horman <nhorman@tuxdriver.com>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Jon Maloy <jmaloy@redhat.com>,
        Ying Xue <ying.xue@windriver.com>, drbd-dev@lists.linbit.com,
        linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org,
        linux-nvme@lists.infradead.org, target-devel@vger.kernel.org,
        linux-afs@lists.infradead.org, linux-cifs@vger.kernel.org,
        cluster-devel@redhat.com, ocfs2-devel@oss.oracle.com,
        netdev@vger.kernel.org, linux-sctp@vger.kernel.org,
        ceph-devel@vger.kernel.org, rds-devel@oss.oracle.com,
        linux-nfs@vger.kernel.org
Subject: [PATCH 25/33] ipv6: add ip6_sock_set_v6only
Date:   Wed, 20 May 2020 21:55:01 +0200
Message-Id: <20200520195509.2215098-26-hch@lst.de>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200520195509.2215098-1-hch@lst.de>
References: <20200520195509.2215098-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add a helper to directly set the IPV6_V6ONLY sockopt from kernel space
without going through a fake uaccess.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 include/net/ipv6.h        | 11 +++++++++++
 net/ipv6/ip6_udp_tunnel.c |  5 +----
 net/sunrpc/svcsock.c      |  6 +-----
 3 files changed, 13 insertions(+), 9 deletions(-)

diff --git a/include/net/ipv6.h b/include/net/ipv6.h
index 5fc3a9d7b053e..7d1cb9f0f5388 100644
--- a/include/net/ipv6.h
+++ b/include/net/ipv6.h
@@ -1176,4 +1176,15 @@ int ipv6_sock_mc_join_ssm(struct sock *sk, int ifindex,
 			  const struct in6_addr *addr, unsigned int mode);
 int ipv6_sock_mc_drop(struct sock *sk, int ifindex,
 		      const struct in6_addr *addr);
+
+static inline int ip6_sock_set_v6only(struct sock *sk)
+{
+	if (inet_sk(sk)->inet_num)
+		return -EINVAL;
+	lock_sock(sk);
+	sk->sk_ipv6only = true;
+	release_sock(sk);
+	return 0;
+}
+
 #endif /* _NET_IPV6_H */
diff --git a/net/ipv6/ip6_udp_tunnel.c b/net/ipv6/ip6_udp_tunnel.c
index 6523609516d25..2e0ad1bc84a83 100644
--- a/net/ipv6/ip6_udp_tunnel.c
+++ b/net/ipv6/ip6_udp_tunnel.c
@@ -25,10 +25,7 @@ int udp_sock_create6(struct net *net, struct udp_port_cfg *cfg,
 		goto error;
 
 	if (cfg->ipv6_v6only) {
-		int val = 1;
-
-		err = kernel_setsockopt(sock, IPPROTO_IPV6, IPV6_V6ONLY,
-					(char *) &val, sizeof(val));
+		err = ip6_sock_set_v6only(sock->sk);
 		if (err < 0)
 			goto error;
 	}
diff --git a/net/sunrpc/svcsock.c b/net/sunrpc/svcsock.c
index 7a805d165689c..a391892977cd2 100644
--- a/net/sunrpc/svcsock.c
+++ b/net/sunrpc/svcsock.c
@@ -1328,7 +1328,6 @@ static struct svc_xprt *svc_create_socket(struct svc_serv *serv,
 	struct sockaddr *newsin = (struct sockaddr *)&addr;
 	int		newlen;
 	int		family;
-	int		val;
 	RPC_IFDEBUG(char buf[RPC_MAX_ADDRBUFLEN]);
 
 	dprintk("svc: svc_create_socket(%s, %d, %s)\n",
@@ -1364,11 +1363,8 @@ static struct svc_xprt *svc_create_socket(struct svc_serv *serv,
 	 * getting requests from IPv4 remotes.  Those should
 	 * be shunted to a PF_INET listener via rpcbind.
 	 */
-	val = 1;
 	if (family == PF_INET6)
-		kernel_setsockopt(sock, SOL_IPV6, IPV6_V6ONLY,
-					(char *)&val, sizeof(val));
-
+		ip6_sock_set_v6only(sock->sk);
 	if (type == SOCK_STREAM)
 		sock->sk->sk_reuse = SK_CAN_REUSE; /* allow address reuse */
 	error = kernel_bind(sock, sin, len);
-- 
2.26.2

