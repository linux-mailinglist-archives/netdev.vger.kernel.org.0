Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3283322A78E
	for <lists+netdev@lfdr.de>; Thu, 23 Jul 2020 08:11:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728076AbgGWGK4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Jul 2020 02:10:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56540 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727779AbgGWGJy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Jul 2020 02:09:54 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 845FAC0619E2;
        Wed, 22 Jul 2020 23:09:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=B8ko5pqj9E5RJoiDMAT4LWCptgAPGsTT9yGUOg+zWgY=; b=MjJqnKULSWCVH3PByQuNM/qNXX
        HtMB9dNpDBTWgJugcO7sE/5ko9tHLFvQQR2XB+seIcDgNTq0BIUT+jAS9YnxntKaMacKvA3QzLDz+
        zGlGK28S4DDyYfe4AW2lZ7egTVp764ymWynHmgHFOMbVH5dRl56eBZKRzkiXR6tj4nh5pm3fHpJ0C
        D7KIViHus2vbs8lwyCCqFoTyuA7CUg8gUDjDutcOgepeoe8H4V4VclrD+KVF5iFtHs5JYWGRp57sI
        ctRlfcOu0L+2rfrA9FFOOVRguL7CObocmaxk45GM10m0ZW5jysNmi0VmrX1q8LwS7ICnZPKjKkGuJ
        piwC5ebg==;
Received: from [2001:4bb8:18c:2acc:91df:aae8:fa3b:de9c] (helo=localhost)
        by casper.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jyUQG-0003oW-J1; Thu, 23 Jul 2020 06:09:41 +0000
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
Subject: [PATCH 22/26] net/udp: switch udp_lib_setsockopt to sockptr_t
Date:   Thu, 23 Jul 2020 08:09:04 +0200
Message-Id: <20200723060908.50081-23-hch@lst.de>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200723060908.50081-1-hch@lst.de>
References: <20200723060908.50081-1-hch@lst.de>
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
 include/net/udp.h | 2 +-
 net/ipv4/udp.c    | 7 ++++---
 net/ipv6/udp.c    | 3 ++-
 3 files changed, 7 insertions(+), 5 deletions(-)

diff --git a/include/net/udp.h b/include/net/udp.h
index 17a9e86a807638..295d52a7359827 100644
--- a/include/net/udp.h
+++ b/include/net/udp.h
@@ -306,7 +306,7 @@ struct sk_buff *skb_udp_tunnel_segment(struct sk_buff *skb,
 int udp_lib_getsockopt(struct sock *sk, int level, int optname,
 		       char __user *optval, int __user *optlen);
 int udp_lib_setsockopt(struct sock *sk, int level, int optname,
-		       char __user *optval, unsigned int optlen,
+		       sockptr_t optval, unsigned int optlen,
 		       int (*push_pending_frames)(struct sock *));
 struct sock *udp4_lib_lookup(struct net *net, __be32 saddr, __be16 sport,
 			     __be32 daddr, __be16 dport, int dif);
diff --git a/net/ipv4/udp.c b/net/ipv4/udp.c
index bb95cddcb040a6..c6cb2d09dbc75e 100644
--- a/net/ipv4/udp.c
+++ b/net/ipv4/udp.c
@@ -2588,7 +2588,7 @@ void udp_destroy_sock(struct sock *sk)
  *	Socket option code for UDP
  */
 int udp_lib_setsockopt(struct sock *sk, int level, int optname,
-		       char __user *optval, unsigned int optlen,
+		       sockptr_t optval, unsigned int optlen,
 		       int (*push_pending_frames)(struct sock *))
 {
 	struct udp_sock *up = udp_sk(sk);
@@ -2599,7 +2599,7 @@ int udp_lib_setsockopt(struct sock *sk, int level, int optname,
 	if (optlen < sizeof(int))
 		return -EINVAL;
 
-	if (get_user(val, (int __user *)optval))
+	if (copy_from_sockptr(&val, optval, sizeof(val)))
 		return -EFAULT;
 
 	valbool = val ? 1 : 0;
@@ -2707,7 +2707,8 @@ int udp_setsockopt(struct sock *sk, int level, int optname,
 		   char __user *optval, unsigned int optlen)
 {
 	if (level == SOL_UDP  ||  level == SOL_UDPLITE)
-		return udp_lib_setsockopt(sk, level, optname, optval, optlen,
+		return udp_lib_setsockopt(sk, level, optname,
+					  USER_SOCKPTR(optval), optlen,
 					  udp_push_pending_frames);
 	return ip_setsockopt(sk, level, optname, optval, optlen);
 }
diff --git a/net/ipv6/udp.c b/net/ipv6/udp.c
index 7c1143feb2bf7e..2df1e6c9d7cbf6 100644
--- a/net/ipv6/udp.c
+++ b/net/ipv6/udp.c
@@ -1622,7 +1622,8 @@ int udpv6_setsockopt(struct sock *sk, int level, int optname,
 		     char __user *optval, unsigned int optlen)
 {
 	if (level == SOL_UDP  ||  level == SOL_UDPLITE)
-		return udp_lib_setsockopt(sk, level, optname, optval, optlen,
+		return udp_lib_setsockopt(sk, level, optname,
+					  USER_SOCKPTR(optval), optlen,
 					  udp_v6_push_pending_frames);
 	return ipv6_setsockopt(sk, level, optname, optval, optlen);
 }
-- 
2.27.0

