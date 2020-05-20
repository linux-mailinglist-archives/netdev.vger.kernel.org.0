Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 20A801DBEFA
	for <lists+netdev@lfdr.de>; Wed, 20 May 2020 21:58:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728527AbgETT5t (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 May 2020 15:57:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51266 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728392AbgETT5D (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 May 2020 15:57:03 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6BAB1C061A0F;
        Wed, 20 May 2020 12:57:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=TdxZOAuFy69KHn/dIFhOGI32U8H99MaSy14m7/E8SrM=; b=caFkmXfUsLNb9SZxDTt3hdNDl4
        6a9x3Cx/9e5I899dMA+Ip5zzKxO8EDimI1c3WV1JTZW/H/jyz8KkpWqa+iqSOzZ7Bw9Z/Mb0Co3Ml
        uRNInlY+rOAuGQL46+AxMN8+QGuTpTd4qKst5g9zXNoTXHEJ6ifsT3mFauWseMxvL/jXjsboqnBC6
        fVz/IlgMqTQ0VFU4f7SZzy+IC3jhtq/VmfxMgrHVUMkmBOOtnW1I0RtoYAkZVRzoTIlL7nsDAhsU5
        5UkcJkQARWOe3SYdH/R7a0wAAj6KJiqCXf43xx9Pj5OLfxrVt2mGvghBfjI/J8Mx+WUo6pNWWxChF
        4VOY/EJQ==;
Received: from [2001:4bb8:188:1506:c70:4a89:bc61:2] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jbUpK-0003Nh-KO; Wed, 20 May 2020 19:56:31 +0000
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
Subject: [PATCH 28/33] ipv6: add ip6_sock_set_recvpktinfo
Date:   Wed, 20 May 2020 21:55:04 +0200
Message-Id: <20200520195509.2215098-29-hch@lst.de>
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

Add a helper to directly set the IPV6_RECVPKTINFO sockopt from kernel
space without going through a fake uaccess.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 include/net/ipv6.h   |  7 +++++++
 net/sunrpc/svcsock.c | 10 ++--------
 2 files changed, 9 insertions(+), 8 deletions(-)

diff --git a/include/net/ipv6.h b/include/net/ipv6.h
index 80260cff7e0c0..79b68ee3820e7 100644
--- a/include/net/ipv6.h
+++ b/include/net/ipv6.h
@@ -1261,4 +1261,11 @@ static inline int ip6_sock_set_addr_preferences(struct sock *sk, bool val)
 	return ret;
 }
 
+static inline void ip6_sock_set_recvpktinfo(struct sock *sk)
+{
+	lock_sock(sk);
+	inet6_sk(sk)->rxopt.bits.rxinfo = true;
+	release_sock(sk);
+}
+
 #endif /* _NET_IPV6_H */
diff --git a/net/sunrpc/svcsock.c b/net/sunrpc/svcsock.c
index a391892977cd2..e7a0037d9b56c 100644
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
@@ -617,17 +615,13 @@ static void svc_udp_init(struct svc_sock *svsk, struct svc_serv *serv)
 	switch (svsk->sk_sk->sk_family) {
 	case AF_INET:
 		ip_sock_set_pktinfo(svsk->sk_sock->sk);
-		return;
+		break;
 	case AF_INET6:
-		level = SOL_IPV6;
-		optname = IPV6_RECVPKTINFO;
+		ip6_sock_set_recvpktinfo(svsk->sk_sock->sk);
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

