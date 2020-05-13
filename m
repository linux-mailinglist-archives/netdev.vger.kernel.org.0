Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7565D1D083A
	for <lists+netdev@lfdr.de>; Wed, 13 May 2020 08:34:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732246AbgEMG3N (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 May 2020 02:29:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46226 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732222AbgEMG3J (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 May 2020 02:29:09 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E3C6C061A0C;
        Tue, 12 May 2020 23:29:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=dCMTZO0AdXjanUxIKH6Ern8zD2+Bu/Awr8QhCk3IXDc=; b=mfGOYIKeamT2jkXYkmTd0SjiaE
        ivFhJZpttZo8rrFan2BdS0MPg3NgLaDTAXqwrnyNLNtg40m4gDO88/m5t/fydFMRS3h9Tl1v5i9CN
        S7tMbeb/KfoSzluyFajTeL3ImS2ticzZMcMkDz29xbj0tIUCgYzABdLklKDBQ11zhLGwh7m+dFEiR
        jjv7YN33T71S920gPnhbcZMfA/WYXo2SqDrwjk8Y7C7+ECOts9ho2eutNZ9VYrdJJOZI9nMOEeCho
        DXMniEsj3nA8965ed0T870qPya9DyyYccqlB3qnYYvZcQHmYzvwxtQAk8NaylIGq6sGmO/dd0FiGp
        zqi6GGrQ==;
Received: from [2001:4bb8:180:9d3f:c70:4a89:bc61:2] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jYksC-0004vd-Gn; Wed, 13 May 2020 06:28:08 +0000
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
Subject: [PATCH 25/33] ipv6: add ip6_sock_set_recvpktinfo
Date:   Wed, 13 May 2020 08:26:40 +0200
Message-Id: <20200513062649.2100053-26-hch@lst.de>
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

Add a helper to directly set the IPV6_RECVPKTINFO sockopt from kernel
space without going through a fake uaccess.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 include/net/ipv6.h       |  1 +
 net/ipv6/ipv6_sockglue.c |  8 ++++++++
 net/sunrpc/svcsock.c     | 11 +++--------
 3 files changed, 12 insertions(+), 8 deletions(-)

diff --git a/include/net/ipv6.h b/include/net/ipv6.h
index 04b2bc1935054..170872bc4e960 100644
--- a/include/net/ipv6.h
+++ b/include/net/ipv6.h
@@ -1178,5 +1178,6 @@ int ipv6_sock_mc_drop(struct sock *sk, int ifindex,
 int ip6_sock_set_v6only(struct sock *sk, bool val);
 void ip6_sock_set_recverr(struct sock *sk, bool val);
 int ip6_sock_set_addr_preferences(struct sock *sk, bool val);
+void ip6_sock_set_recvpktinfo(struct sock *sk, bool val);
 
 #endif /* _NET_IPV6_H */
diff --git a/net/ipv6/ipv6_sockglue.c b/net/ipv6/ipv6_sockglue.c
index c23d42e809d7e..d60adb018d71c 100644
--- a/net/ipv6/ipv6_sockglue.c
+++ b/net/ipv6/ipv6_sockglue.c
@@ -225,6 +225,14 @@ int ip6_sock_set_addr_preferences(struct sock *sk, bool val)
 }
 EXPORT_SYMBOL(ip6_sock_set_addr_preferences);
 
+void ip6_sock_set_recvpktinfo(struct sock *sk, bool val)
+{
+	lock_sock(sk);
+	inet6_sk(sk)->rxopt.bits.rxinfo = val;
+	release_sock(sk);
+}
+EXPORT_SYMBOL(ip6_sock_set_recvpktinfo);
+
 static int do_ipv6_setsockopt(struct sock *sk, int level, int optname,
 		    char __user *optval, unsigned int optlen)
 {
diff --git a/net/sunrpc/svcsock.c b/net/sunrpc/svcsock.c
index 7fa7fedec3c5a..7cf8389b6f46f 100644
--- a/net/sunrpc/svcsock.c
+++ b/net/sunrpc/svcsock.c
@@ -595,8 +595,6 @@ static struct svc_xprt_class svc_udp_class = {
 
 static void svc_udp_init(struct svc_sock *svsk, struct svc_serv *serv)
 {
-	int err, level, optname, one = 1;
-
 	svc_xprt_init(sock_net(svsk->sk_sock->sk), &svc_udp_class,
 		      &svsk->sk_xprt, serv);
 	clear_bit(XPT_CACHE_AUTH, &svsk->sk_xprt.xpt_flags);
@@ -617,17 +615,14 @@ static void svc_udp_init(struct svc_sock *svsk, struct svc_serv *serv)
 	switch (svsk->sk_sk->sk_family) {
 	case AF_INET:
 		ip_sock_set_pktinfo(svsk->sk_sock->sk, true);
-		return;
+		break;
 	case AF_INET6:
-		level = SOL_IPV6;
-		optname = IPV6_RECVPKTINFO;
+		if (IS_REACHABLE(CONFIG_IPV6))
+			ip6_sock_set_recvpktinfo(svsk->sk_sock->sk, true);
 		break;
 	default:
 		BUG();
 	}
-	err = kernel_setsockopt(svsk->sk_sock, level, optname,
-					(char *)&one, sizeof(one));
-	dprintk("svc: kernel_setsockopt returned %d\n", err);
 }
 
 /*
-- 
2.26.2

