Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1A3861D081C
	for <lists+netdev@lfdr.de>; Wed, 13 May 2020 08:33:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732148AbgEMG3B (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 May 2020 02:29:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46192 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732108AbgEMG27 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 May 2020 02:28:59 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4169CC061A0F;
        Tue, 12 May 2020 23:28:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=laiP2pIgR17FT/t8Imc4/ycg5SRQQsuUMTciW2PU5vo=; b=pY3veeA+QdrH2Y3cxgddbqG2fK
        YhKJofr/d0WcuMvhkg9AgsNyYEpLaEqDIqy+bNPk7aNYpyhP7tTREV1wHDN2wB2OyUeyw1fMNS/pd
        t6gFNx0T3/QN1KV1i/TghY6xl075Y4iYtWXRG9M7MIS5+3N4XRo6J97oxDoYS5RU7VEmL/faPgx4t
        /N7eHXbtoK8K3sh0NipcKxTIplDwUf1tYHkQnJVOl9sX6IzclWKZZizQsctNh6rde7Q3WfsoenDrh
        wVX/yFuruxYCw5llFQVCO2NhcI7i+yjhGW9WTjwc3F6A5TC8a5hjoayQKOO9tlzgKK0Zd8tvtL+I+
        FPB2XpLQ==;
Received: from [2001:4bb8:180:9d3f:c70:4a89:bc61:2] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jYks2-0004lp-2x; Wed, 13 May 2020 06:27:58 +0000
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
        linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-rdma@vger.kernel.org, linux-nvme@lists.infradead.org,
        target-devel@vger.kernel.org, linux-afs@lists.infradead.org,
        linux-cifs@vger.kernel.org, cluster-devel@redhat.com,
        ocfs2-devel@oss.oracle.com, netdev@vger.kernel.org,
        linux-sctp@vger.kernel.org, ceph-devel@vger.kernel.org,
        rds-devel@oss.oracle.com, linux-nfs@vger.kernel.org
Subject: [PATCH 22/33] ipv6: add ip6_sock_set_v6only
Date:   Wed, 13 May 2020 08:26:37 +0200
Message-Id: <20200513062649.2100053-23-hch@lst.de>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200513062649.2100053-1-hch@lst.de>
References: <20200513062649.2100053-1-hch@lst.de>
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
 include/net/ipv6.h        |  3 +++
 net/ipv6/ip6_udp_tunnel.c |  5 +----
 net/ipv6/ipv6_sockglue.c  | 11 +++++++++++
 net/sunrpc/svcsock.c      |  8 ++------
 4 files changed, 17 insertions(+), 10 deletions(-)

diff --git a/include/net/ipv6.h b/include/net/ipv6.h
index 955badd1e8ffc..e24b59201a00d 100644
--- a/include/net/ipv6.h
+++ b/include/net/ipv6.h
@@ -1174,4 +1174,7 @@ int ipv6_sock_mc_join_ssm(struct sock *sk, int ifindex,
 			  const struct in6_addr *addr, unsigned int mode);
 int ipv6_sock_mc_drop(struct sock *sk, int ifindex,
 		      const struct in6_addr *addr);
+
+int ip6_sock_set_v6only(struct sock *sk, bool val);
+
 #endif /* _NET_IPV6_H */
diff --git a/net/ipv6/ip6_udp_tunnel.c b/net/ipv6/ip6_udp_tunnel.c
index 6523609516d25..bc4ee5cb14c8b 100644
--- a/net/ipv6/ip6_udp_tunnel.c
+++ b/net/ipv6/ip6_udp_tunnel.c
@@ -25,10 +25,7 @@ int udp_sock_create6(struct net *net, struct udp_port_cfg *cfg,
 		goto error;
 
 	if (cfg->ipv6_v6only) {
-		int val = 1;
-
-		err = kernel_setsockopt(sock, IPPROTO_IPV6, IPV6_V6ONLY,
-					(char *) &val, sizeof(val));
+		err = ip6_sock_set_v6only(sock->sk, true);
 		if (err < 0)
 			goto error;
 	}
diff --git a/net/ipv6/ipv6_sockglue.c b/net/ipv6/ipv6_sockglue.c
index 18d05403d3b52..f26224bb3e098 100644
--- a/net/ipv6/ipv6_sockglue.c
+++ b/net/ipv6/ipv6_sockglue.c
@@ -136,6 +136,17 @@ static bool setsockopt_needs_rtnl(int optname)
 	return false;
 }
 
+int ip6_sock_set_v6only(struct sock *sk, bool val)
+{
+	if (inet_sk(sk)->inet_num)
+		return -EINVAL;
+	lock_sock(sk);
+	sk->sk_ipv6only = val;
+	release_sock(sk);
+	return 0;
+}
+EXPORT_SYMBOL(ip6_sock_set_v6only);
+
 static int do_ipv6_setsockopt(struct sock *sk, int level, int optname,
 		    char __user *optval, unsigned int optlen)
 {
diff --git a/net/sunrpc/svcsock.c b/net/sunrpc/svcsock.c
index 7a4f01c79e0f1..7fa7fedec3c5a 100644
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
-	if (family == PF_INET6)
-		kernel_setsockopt(sock, SOL_IPV6, IPV6_V6ONLY,
-					(char *)&val, sizeof(val));
-
+	if (family == PF_INET6 && IS_REACHABLE(CONFIG_IPV6))
+		ip6_sock_set_v6only(sock->sk, true);
 	if (type == SOCK_STREAM)
 		sock->sk->sk_reuse = SK_CAN_REUSE; /* allow address reuse */
 	error = kernel_bind(sock, sin, len);
-- 
2.26.2

