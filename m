Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1BFDA1E55AA
	for <lists+netdev@lfdr.de>; Thu, 28 May 2020 07:14:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728249AbgE1FO2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 May 2020 01:14:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40590 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728214AbgE1FOZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 May 2020 01:14:25 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 65BABC05BD1E;
        Wed, 27 May 2020 22:14:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=ArfUN0byB3Uq+uJrbTK/3I3YkF2OfRio3Yy2O4aNtms=; b=UaviI5C9wMtc9Cj3+spf+9ZU69
        mrryeoJ0Z24pMECma7sLfjamDNtvTIZHcvRX6hhmdhbV1gPc+qbf3wfcc8w7DtqWITfpHph9PYzLn
        5ymVNaMWfn/XGub0CLh14e5L7USg2ZvzywnFuqkJwY3+3argGWy/9U9NDdYSnF46EhcCoKD+1B/Tv
        7mKVIbG8oCz3QPehKktSh5Dkz3kvNspUdWuOTFhjLBkPfY5eJWpoj/IpcXEAmJPN5hWqWXzjWChn2
        bGti+9Kq0PXPHviBYkG9jPARS5FbNooLqsUGcj9stkvGpjNl8u7q5HHk56NUt3VWkyncMBkoIJLPW
        7G/1PxuQ==;
Received: from p4fdb1ad2.dip0.t-ipconnect.de ([79.219.26.210] helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jeArh-0002Z7-IZ; Thu, 28 May 2020 05:14:02 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Eric Dumazet <edumazet@google.com>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Jon Maloy <jmaloy@redhat.com>,
        Ying Xue <ying.xue@windriver.com>, drbd-dev@lists.linbit.com,
        linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org,
        linux-nvme@lists.infradead.org, target-devel@vger.kernel.org,
        linux-afs@lists.infradead.org, linux-cifs@vger.kernel.org,
        cluster-devel@redhat.com, ocfs2-devel@oss.oracle.com,
        netdev@vger.kernel.org, ceph-devel@vger.kernel.org,
        rds-devel@oss.oracle.com, linux-nfs@vger.kernel.org,
        tipc-discussion@lists.sourceforge.net
Subject: [PATCH 25/28] ipv6: add ip6_sock_set_addr_preferences
Date:   Thu, 28 May 2020 07:12:33 +0200
Message-Id: <20200528051236.620353-26-hch@lst.de>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200528051236.620353-1-hch@lst.de>
References: <20200528051236.620353-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add a helper to directly set the IPV6_ADD_PREFERENCES sockopt from kernel
space without going through a fake uaccess.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 include/net/ipv6.h       | 67 ++++++++++++++++++++++++++++++++++++++++
 net/ipv6/ipv6_sockglue.c | 59 +----------------------------------
 net/sunrpc/xprtsock.c    |  7 +++--
 3 files changed, 72 insertions(+), 61 deletions(-)

diff --git a/include/net/ipv6.h b/include/net/ipv6.h
index 49c4abf991489..9a90759830162 100644
--- a/include/net/ipv6.h
+++ b/include/net/ipv6.h
@@ -1195,4 +1195,71 @@ static inline void ip6_sock_set_recverr(struct sock *sk)
 	release_sock(sk);
 }
 
+static inline int __ip6_sock_set_addr_preferences(struct sock *sk, int val)
+{
+	unsigned int pref = 0;
+	unsigned int prefmask = ~0;
+
+	/* check PUBLIC/TMP/PUBTMP_DEFAULT conflicts */
+	switch (val & (IPV6_PREFER_SRC_PUBLIC |
+		       IPV6_PREFER_SRC_TMP |
+		       IPV6_PREFER_SRC_PUBTMP_DEFAULT)) {
+	case IPV6_PREFER_SRC_PUBLIC:
+		pref |= IPV6_PREFER_SRC_PUBLIC;
+		prefmask &= ~(IPV6_PREFER_SRC_PUBLIC |
+			      IPV6_PREFER_SRC_TMP);
+		break;
+	case IPV6_PREFER_SRC_TMP:
+		pref |= IPV6_PREFER_SRC_TMP;
+		prefmask &= ~(IPV6_PREFER_SRC_PUBLIC |
+			      IPV6_PREFER_SRC_TMP);
+		break;
+	case IPV6_PREFER_SRC_PUBTMP_DEFAULT:
+		prefmask &= ~(IPV6_PREFER_SRC_PUBLIC |
+			      IPV6_PREFER_SRC_TMP);
+		break;
+	case 0:
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	/* check HOME/COA conflicts */
+	switch (val & (IPV6_PREFER_SRC_HOME | IPV6_PREFER_SRC_COA)) {
+	case IPV6_PREFER_SRC_HOME:
+		prefmask &= ~IPV6_PREFER_SRC_COA;
+		break;
+	case IPV6_PREFER_SRC_COA:
+		pref |= IPV6_PREFER_SRC_COA;
+		break;
+	case 0:
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	/* check CGA/NONCGA conflicts */
+	switch (val & (IPV6_PREFER_SRC_CGA|IPV6_PREFER_SRC_NONCGA)) {
+	case IPV6_PREFER_SRC_CGA:
+	case IPV6_PREFER_SRC_NONCGA:
+	case 0:
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	inet6_sk(sk)->srcprefs = (inet6_sk(sk)->srcprefs & prefmask) | pref;
+	return 0;
+}
+
+static inline int ip6_sock_set_addr_preferences(struct sock *sk, bool val)
+{
+	int ret;
+
+	lock_sock(sk);
+	ret = __ip6_sock_set_addr_preferences(sk, val);
+	release_sock(sk);
+	return ret;
+}
+
 #endif /* _NET_IPV6_H */
diff --git a/net/ipv6/ipv6_sockglue.c b/net/ipv6/ipv6_sockglue.c
index e10258c2210e8..adbfed6adf11c 100644
--- a/net/ipv6/ipv6_sockglue.c
+++ b/net/ipv6/ipv6_sockglue.c
@@ -845,67 +845,10 @@ static int do_ipv6_setsockopt(struct sock *sk, int level, int optname,
 		break;
 
 	case IPV6_ADDR_PREFERENCES:
-	    {
-		unsigned int pref = 0;
-		unsigned int prefmask = ~0;
-
 		if (optlen < sizeof(int))
 			goto e_inval;
-
-		retv = -EINVAL;
-
-		/* check PUBLIC/TMP/PUBTMP_DEFAULT conflicts */
-		switch (val & (IPV6_PREFER_SRC_PUBLIC|
-			       IPV6_PREFER_SRC_TMP|
-			       IPV6_PREFER_SRC_PUBTMP_DEFAULT)) {
-		case IPV6_PREFER_SRC_PUBLIC:
-			pref |= IPV6_PREFER_SRC_PUBLIC;
-			break;
-		case IPV6_PREFER_SRC_TMP:
-			pref |= IPV6_PREFER_SRC_TMP;
-			break;
-		case IPV6_PREFER_SRC_PUBTMP_DEFAULT:
-			break;
-		case 0:
-			goto pref_skip_pubtmp;
-		default:
-			goto e_inval;
-		}
-
-		prefmask &= ~(IPV6_PREFER_SRC_PUBLIC|
-			      IPV6_PREFER_SRC_TMP);
-pref_skip_pubtmp:
-
-		/* check HOME/COA conflicts */
-		switch (val & (IPV6_PREFER_SRC_HOME|IPV6_PREFER_SRC_COA)) {
-		case IPV6_PREFER_SRC_HOME:
-			break;
-		case IPV6_PREFER_SRC_COA:
-			pref |= IPV6_PREFER_SRC_COA;
-		case 0:
-			goto pref_skip_coa;
-		default:
-			goto e_inval;
-		}
-
-		prefmask &= ~IPV6_PREFER_SRC_COA;
-pref_skip_coa:
-
-		/* check CGA/NONCGA conflicts */
-		switch (val & (IPV6_PREFER_SRC_CGA|IPV6_PREFER_SRC_NONCGA)) {
-		case IPV6_PREFER_SRC_CGA:
-		case IPV6_PREFER_SRC_NONCGA:
-		case 0:
-			break;
-		default:
-			goto e_inval;
-		}
-
-		np->srcprefs = (np->srcprefs & prefmask) | pref;
-		retv = 0;
-
+		retv = __ip6_sock_set_addr_preferences(sk, val);
 		break;
-	    }
 	case IPV6_MINHOPCOUNT:
 		if (optlen < sizeof(int))
 			goto e_inval;
diff --git a/net/sunrpc/xprtsock.c b/net/sunrpc/xprtsock.c
index 0d3ec055bc12f..3a143e250b9ac 100644
--- a/net/sunrpc/xprtsock.c
+++ b/net/sunrpc/xprtsock.c
@@ -2150,7 +2150,6 @@ static int xs_tcp_finish_connecting(struct rpc_xprt *xprt, struct socket *sock)
 
 	if (!transport->inet) {
 		struct sock *sk = sock->sk;
-		unsigned int addr_pref = IPV6_PREFER_SRC_PUBLIC;
 
 		/* Avoid temporary address, they are bad for long-lived
 		 * connections such as NFS mounts.
@@ -2159,8 +2158,10 @@ static int xs_tcp_finish_connecting(struct rpc_xprt *xprt, struct socket *sock)
 		 *    knowledge about the normal duration of connections,
 		 *    MAY override this as appropriate.
 		 */
-		kernel_setsockopt(sock, SOL_IPV6, IPV6_ADDR_PREFERENCES,
-				(char *)&addr_pref, sizeof(addr_pref));
+		if (xs_addr(xprt)->sa_family == PF_INET6) {
+			ip6_sock_set_addr_preferences(sk,
+				IPV6_PREFER_SRC_PUBLIC);
+		}
 
 		xs_tcp_set_socket_timeouts(xprt, sock);
 
-- 
2.26.2

