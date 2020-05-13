Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 152551D0813
	for <lists+netdev@lfdr.de>; Wed, 13 May 2020 08:33:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732114AbgEMG27 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 May 2020 02:28:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46178 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730583AbgEMG25 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 May 2020 02:28:57 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E5AA5C061A0C;
        Tue, 12 May 2020 23:28:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=H54azrsd7E+axT6O+qhvgxc728YbsMwbwoaorN8dTak=; b=ELbWvom7OLUEPHUlh+K/wa+2Yz
        MIv09pB/hz0X4YfDe4pQIyKwYEMo67G3o6vnn79V8nmNHPPF/8QEIv7y4djVl7U7gw9S6CXyOBYUY
        q5cq7qzzyhYmaJ6XpEvfcRSJzBGzliLAWlLnXNFGxaQVa9CR1qc+ntgF7igPhKb9A7i4KFlp1VOE/
        zWCTktm4v/FY3kUg8KD9KT9vFaPVeVzDfxceYE5Yqbdlg6LN2IyetU3B4z/6U3piE5rRIhndG7rCk
        lpMzjxU2n05eGTSTGNdgaUVraTLoFYMtpD9HQ7YSAJo96c8eLvv0+iJrPMIRl+S0ztiUuHEnpfb3e
        uMYRSzvg==;
Received: from [2001:4bb8:180:9d3f:c70:4a89:bc61:2] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jYkrz-0004i7-0s; Wed, 13 May 2020 06:27:55 +0000
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
Subject: [PATCH 21/33] ipv4: add ip_sock_set_mtu_discover
Date:   Wed, 13 May 2020 08:26:36 +0200
Message-Id: <20200513062649.2100053-22-hch@lst.de>
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

Add a helper to directly set the IP_MTU_DISCOVER sockopt from kernel
space without going through a fake uaccess.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 include/net/ip.h         |  2 ++
 net/ipv4/ip_sockglue.c   | 22 ++++++++++++++++++++++
 net/rxrpc/local_object.c |  8 +-------
 net/rxrpc/output.c       | 14 +++++---------
 net/sunrpc/svcsock.c     |  5 ++---
 5 files changed, 32 insertions(+), 19 deletions(-)

diff --git a/include/net/ip.h b/include/net/ip.h
index 7ab8140b54429..536eaffec59f0 100644
--- a/include/net/ip.h
+++ b/include/net/ip.h
@@ -768,5 +768,7 @@ static inline bool inetdev_valid_mtu(unsigned int mtu)
 void ip_sock_set_tos(struct sock *sk, int val);
 void ip_sock_set_freebind(struct sock *sk, bool val);
 void ip_sock_set_recverr(struct sock *sk, bool val);
+int ip_sock_set_mtu_discover(struct sock *sk, int val);
+void ip_sock_set_pktinfo(struct sock *sk, bool val);
 
 #endif	/* _IP_H */
diff --git a/net/ipv4/ip_sockglue.c b/net/ipv4/ip_sockglue.c
index 9abecc3195520..df6ce0a7b0e3d 100644
--- a/net/ipv4/ip_sockglue.c
+++ b/net/ipv4/ip_sockglue.c
@@ -599,6 +599,28 @@ void ip_sock_set_recverr(struct sock *sk, bool val)
 }
 EXPORT_SYMBOL(ip_sock_set_recverr);
 
+int ip_sock_set_mtu_discover(struct sock *sk, int val)
+{
+	if (val < IP_PMTUDISC_DONT || val > IP_PMTUDISC_OMIT)
+		return -EINVAL;
+	lock_sock(sk);
+	inet_sk(sk)->pmtudisc = val;
+	release_sock(sk);
+	return 0;
+}
+EXPORT_SYMBOL(ip_sock_set_mtu_discover);
+
+void ip_sock_set_pktinfo(struct sock *sk, bool val)
+{
+	lock_sock(sk);
+	if (val)
+		inet_sk(sk)->cmsg_flags |= IP_CMSG_PKTINFO;
+	else
+		inet_sk(sk)->cmsg_flags &= ~IP_CMSG_PKTINFO;
+	release_sock(sk);
+}
+EXPORT_SYMBOL(ip_sock_set_pktinfo);
+
 /*
  *	Socket option code for IP. This is the end of the line after any
  *	TCP,UDP etc options on an IP socket.
diff --git a/net/rxrpc/local_object.c b/net/rxrpc/local_object.c
index 1b87b8a9ff725..20236ddecd2ef 100644
--- a/net/rxrpc/local_object.c
+++ b/net/rxrpc/local_object.c
@@ -174,13 +174,7 @@ static int rxrpc_open_socket(struct rxrpc_local *local, struct net *net)
 		ip_sock_set_recverr(local->socket->sk, true);
 
 		/* we want to set the don't fragment bit */
-		opt = IP_PMTUDISC_DO;
-		ret = kernel_setsockopt(local->socket, SOL_IP, IP_MTU_DISCOVER,
-					(char *) &opt, sizeof(opt));
-		if (ret < 0) {
-			_debug("setsockopt failed");
-			goto error;
-		}
+		ip_sock_set_mtu_discover(local->socket->sk, IP_PMTUDISC_DO);
 
 		/* We want receive timestamps. */
 		sock_set_timestamps(local->socket->sk, true, false, true);
diff --git a/net/rxrpc/output.c b/net/rxrpc/output.c
index 90e263c6aa69e..ad0234e1e1713 100644
--- a/net/rxrpc/output.c
+++ b/net/rxrpc/output.c
@@ -321,7 +321,7 @@ int rxrpc_send_data_packet(struct rxrpc_call *call, struct sk_buff *skb,
 	struct kvec iov[2];
 	rxrpc_serial_t serial;
 	size_t len;
-	int ret, opt;
+	int ret;
 
 	_enter(",{%d}", skb->len);
 
@@ -476,18 +476,14 @@ int rxrpc_send_data_packet(struct rxrpc_call *call, struct sk_buff *skb,
 	switch (conn->params.local->srx.transport.family) {
 	case AF_INET6:
 	case AF_INET:
-		opt = IP_PMTUDISC_DONT;
-		kernel_setsockopt(conn->params.local->socket,
-				  SOL_IP, IP_MTU_DISCOVER,
-				  (char *)&opt, sizeof(opt));
+		ip_sock_set_mtu_discover(conn->params.local->socket->sk,
+				IP_PMTUDISC_DONT);
 		ret = kernel_sendmsg(conn->params.local->socket, &msg,
 				     iov, 2, len);
 		conn->params.peer->last_tx_at = ktime_get_seconds();
 
-		opt = IP_PMTUDISC_DO;
-		kernel_setsockopt(conn->params.local->socket,
-				  SOL_IP, IP_MTU_DISCOVER,
-				  (char *)&opt, sizeof(opt));
+		ip_sock_set_mtu_discover(conn->params.local->socket->sk,
+				IP_PMTUDISC_DO);
 		break;
 
 	default:
diff --git a/net/sunrpc/svcsock.c b/net/sunrpc/svcsock.c
index 0f6b78d0e6170..7a4f01c79e0f1 100644
--- a/net/sunrpc/svcsock.c
+++ b/net/sunrpc/svcsock.c
@@ -616,9 +616,8 @@ static void svc_udp_init(struct svc_sock *svsk, struct svc_serv *serv)
 	/* make sure we get destination address info */
 	switch (svsk->sk_sk->sk_family) {
 	case AF_INET:
-		level = SOL_IP;
-		optname = IP_PKTINFO;
-		break;
+		ip_sock_set_pktinfo(svsk->sk_sock->sk, true);
+		return;
 	case AF_INET6:
 		level = SOL_IPV6;
 		optname = IPV6_RECVPKTINFO;
-- 
2.26.2

