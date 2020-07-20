Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DD380225FC8
	for <lists+netdev@lfdr.de>; Mon, 20 Jul 2020 14:52:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729396AbgGTMvn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Jul 2020 08:51:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40510 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728074AbgGTMsO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Jul 2020 08:48:14 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EAC52C061794;
        Mon, 20 Jul 2020 05:48:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=hs9nFYNbsiTuomEFW34Dm2rpOGJinL2S6O7KpsAcjME=; b=BBUuvJzBpBC1aFyeauCvglQq8E
        P5vbTaYJrzOfSVzV+SnJRcTwCUYxG4LLKMglWHnZPFl2XzAnXhasz+8O8V4/wM8oVj2zhW/9O1+qZ
        hmf4RhbXBF5UaoXK2YWIDefTrbZTJ6fLFJ2SwmMOzYkT/XKWIiv80if02d+k3RWh3VYotpm3hna49
        lefSoaeUyLwuYQGuHzhU9GiWeklaIMyjmuGpBKAdiFpdk7xOmG9puBEoym1BV0/rPgqn2GZLkJJVy
        j1+mmHWSYRaL4KreN8pZa8tqW6AzjeLOsrQRC4/C8nBrCRn4k0JnDb6Cq/EnirnC6aihy0mJk0wBk
        f6Osp7Og==;
Received: from [2001:4bb8:105:4a81:2a8f:15b1:2c3:7be7] (helo=localhost)
        by casper.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jxVD5-0004Xj-Ih; Mon, 20 Jul 2020 12:48:00 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Eric Dumazet <edumazet@google.com>
Cc:     linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        linux-sctp@vger.kernel.org, linux-hams@vger.kernel.org,
        linux-bluetooth@vger.kernel.org, bridge@lists.linux-foundation.org,
        linux-can@vger.kernel.org, dccp@vger.kernel.org,
        linux-decnet-user@lists.sourceforge.net,
        linux-wpan@vger.kernel.org, linux-s390@vger.kernel.org,
        mptcp@lists.01.org, lvs-devel@vger.kernel.org,
        rds-devel@oss.oracle.com, linux-afs@lists.infradead.org,
        tipc-discussion@lists.sourceforge.net, linux-x25@vger.kernel.org
Subject: [PATCH 07/24] net: switch sock_set_timeout to sockptr_t
Date:   Mon, 20 Jul 2020 14:47:20 +0200
Message-Id: <20200720124737.118617-8-hch@lst.de>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200720124737.118617-1-hch@lst.de>
References: <20200720124737.118617-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Pass a sockptr_t to prepare for set_fs-less handling of the kernel
pointer from bpf-cgroup.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 include/net/sock.h   |  3 ++-
 net/core/sock.c      | 26 ++++++++++++--------------
 net/mptcp/protocol.c |  6 ++++--
 net/socket.c         |  3 ++-
 4 files changed, 20 insertions(+), 18 deletions(-)

diff --git a/include/net/sock.h b/include/net/sock.h
index 62e18fc8ac9f96..bfb2fe2fc36876 100644
--- a/include/net/sock.h
+++ b/include/net/sock.h
@@ -59,6 +59,7 @@
 #include <linux/filter.h>
 #include <linux/rculist_nulls.h>
 #include <linux/poll.h>
+#include <linux/sockptr.h>
 
 #include <linux/atomic.h>
 #include <linux/refcount.h>
@@ -1669,7 +1670,7 @@ void sock_pfree(struct sk_buff *skb);
 #endif
 
 int sock_setsockopt(struct socket *sock, int level, int op,
-		    char __user *optval, unsigned int optlen);
+		    sockptr_t optval, unsigned int optlen);
 
 int sock_getsockopt(struct socket *sock, int level, int op,
 		    char __user *optval, int __user *optlen);
diff --git a/net/core/sock.c b/net/core/sock.c
index d45bb1c2c36abf..9cf8318bc51de4 100644
--- a/net/core/sock.c
+++ b/net/core/sock.c
@@ -825,7 +825,7 @@ EXPORT_SYMBOL(sock_set_rcvbuf);
  */
 
 int sock_setsockopt(struct socket *sock, int level, int optname,
-		    char __user *optval, unsigned int optlen)
+		    sockptr_t optval, unsigned int optlen)
 {
 	struct sock_txtime sk_txtime;
 	struct sock *sk = sock->sk;
@@ -839,12 +839,12 @@ int sock_setsockopt(struct socket *sock, int level, int optname,
 	 */
 
 	if (optname == SO_BINDTODEVICE)
-		return sock_setbindtodevice(sk, USER_SOCKPTR(optval), optlen);
+		return sock_setbindtodevice(sk, optval, optlen);
 
 	if (optlen < sizeof(int))
 		return -EINVAL;
 
-	if (get_user(val, (int __user *)optval))
+	if (copy_from_sockptr(&val, optval, sizeof(val)))
 		return -EFAULT;
 
 	valbool = val ? 1 : 0;
@@ -957,7 +957,7 @@ int sock_setsockopt(struct socket *sock, int level, int optname,
 			ret = -EINVAL;	/* 1003.1g */
 			break;
 		}
-		if (copy_from_user(&ling, optval, sizeof(ling))) {
+		if (copy_from_sockptr(&ling, optval, sizeof(ling))) {
 			ret = -EFAULT;
 			break;
 		}
@@ -1051,21 +1051,20 @@ int sock_setsockopt(struct socket *sock, int level, int optname,
 
 	case SO_RCVTIMEO_OLD:
 	case SO_RCVTIMEO_NEW:
-		ret = sock_set_timeout(&sk->sk_rcvtimeo, USER_SOCKPTR(optval),
+		ret = sock_set_timeout(&sk->sk_rcvtimeo, optval,
 				       optlen, optname == SO_RCVTIMEO_OLD);
 		break;
 
 	case SO_SNDTIMEO_OLD:
 	case SO_SNDTIMEO_NEW:
-		ret = sock_set_timeout(&sk->sk_sndtimeo, USER_SOCKPTR(optval),
+		ret = sock_set_timeout(&sk->sk_sndtimeo, optval,
 				       optlen, optname == SO_SNDTIMEO_OLD);
 		break;
 
 	case SO_ATTACH_FILTER: {
 		struct sock_fprog fprog;
 
-		ret = copy_bpf_fprog_from_user(&fprog, USER_SOCKPTR(optval),
-					       optlen);
+		ret = copy_bpf_fprog_from_user(&fprog, optval, optlen);
 		if (!ret)
 			ret = sk_attach_filter(&fprog, sk);
 		break;
@@ -1076,7 +1075,7 @@ int sock_setsockopt(struct socket *sock, int level, int optname,
 			u32 ufd;
 
 			ret = -EFAULT;
-			if (copy_from_user(&ufd, optval, sizeof(ufd)))
+			if (copy_from_sockptr(&ufd, optval, sizeof(ufd)))
 				break;
 
 			ret = sk_attach_bpf(ufd, sk);
@@ -1086,8 +1085,7 @@ int sock_setsockopt(struct socket *sock, int level, int optname,
 	case SO_ATTACH_REUSEPORT_CBPF: {
 		struct sock_fprog fprog;
 
-		ret = copy_bpf_fprog_from_user(&fprog, USER_SOCKPTR(optval),
-					       optlen);
+		ret = copy_bpf_fprog_from_user(&fprog, optval, optlen);
 		if (!ret)
 			ret = sk_reuseport_attach_filter(&fprog, sk);
 		break;
@@ -1098,7 +1096,7 @@ int sock_setsockopt(struct socket *sock, int level, int optname,
 			u32 ufd;
 
 			ret = -EFAULT;
-			if (copy_from_user(&ufd, optval, sizeof(ufd)))
+			if (copy_from_sockptr(&ufd, optval, sizeof(ufd)))
 				break;
 
 			ret = sk_reuseport_attach_bpf(ufd, sk);
@@ -1178,7 +1176,7 @@ int sock_setsockopt(struct socket *sock, int level, int optname,
 
 		if (sizeof(ulval) != sizeof(val) &&
 		    optlen >= sizeof(ulval) &&
-		    get_user(ulval, (unsigned long __user *)optval)) {
+		    copy_from_sockptr(&ulval, optval, sizeof(ulval))) {
 			ret = -EFAULT;
 			break;
 		}
@@ -1221,7 +1219,7 @@ int sock_setsockopt(struct socket *sock, int level, int optname,
 		if (optlen != sizeof(struct sock_txtime)) {
 			ret = -EINVAL;
 			break;
-		} else if (copy_from_user(&sk_txtime, optval,
+		} else if (copy_from_sockptr(&sk_txtime, optval,
 			   sizeof(struct sock_txtime))) {
 			ret = -EFAULT;
 			break;
diff --git a/net/mptcp/protocol.c b/net/mptcp/protocol.c
index f0b0b503c2628d..27b6f250b87dfd 100644
--- a/net/mptcp/protocol.c
+++ b/net/mptcp/protocol.c
@@ -1643,7 +1643,8 @@ static int mptcp_setsockopt_sol_socket(struct mptcp_sock *msk, int optname,
 			return -EINVAL;
 		}
 
-		ret = sock_setsockopt(ssock, SOL_SOCKET, optname, optval, optlen);
+		ret = sock_setsockopt(ssock, SOL_SOCKET, optname,
+				      USER_SOCKPTR(optval), optlen);
 		if (ret == 0) {
 			if (optname == SO_REUSEPORT)
 				sk->sk_reuseport = ssock->sk->sk_reuseport;
@@ -1654,7 +1655,8 @@ static int mptcp_setsockopt_sol_socket(struct mptcp_sock *msk, int optname,
 		return ret;
 	}
 
-	return sock_setsockopt(sk->sk_socket, SOL_SOCKET, optname, optval, optlen);
+	return sock_setsockopt(sk->sk_socket, SOL_SOCKET, optname,
+			       USER_SOCKPTR(optval), optlen);
 }
 
 static int mptcp_setsockopt_v6(struct mptcp_sock *msk, int optname,
diff --git a/net/socket.c b/net/socket.c
index 93846568c2fb7a..c97f83d879ae75 100644
--- a/net/socket.c
+++ b/net/socket.c
@@ -2130,7 +2130,8 @@ int __sys_setsockopt(int fd, int level, int optname, char __user *optval,
 	}
 
 	if (level == SOL_SOCKET && !sock_use_custom_sol_socket(sock))
-		err = sock_setsockopt(sock, level, optname, optval, optlen);
+		err = sock_setsockopt(sock, level, optname,
+				      USER_SOCKPTR(optval), optlen);
 	else if (unlikely(!sock->ops->setsockopt))
 		err = -EOPNOTSUPP;
 	else
-- 
2.27.0

