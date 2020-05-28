Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 500D31E55EA
	for <lists+netdev@lfdr.de>; Thu, 28 May 2020 07:15:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728385AbgE1FPj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 May 2020 01:15:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40546 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728118AbgE1FOK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 May 2020 01:14:10 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 50610C05BD1E;
        Wed, 27 May 2020 22:14:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=OfDlGdyFJbY3guIEMLUBPt/bisXMPCmZcgN0xNtZrAc=; b=hdih7qS1Ki00+vlbsFVix20bhy
        Ak2PsMf4AXQkQYfbDYkq3IO9ziSk1NeqT/FGOQebDmIBaH/KGLVSE0lHtRKOlTJ+rlFHNEEoYTjaW
        4tkbnZM6DzHod7Zs+rvQ1WoywwMIGUmoE5sw9PUrN4ZYX6wGVLvJQzzmr6kQInq7ztb34uRKxh58H
        P+9BVM3RUyQVtiyxH49xwC17LFVdK7Z3BzAchWikaZJrq0xPd612f1RI/WWE4B7buHnklx+pmc9bW
        KHnhBIdKdvYgFsqO4PVjF9DAWgCVca5a99N7taEQQ2niAR+IYVUP5SMNsFh4t2gl3uB4ji3zLEJTD
        XPp7smhw==;
Received: from p4fdb1ad2.dip0.t-ipconnect.de ([79.219.26.210] helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jeArU-0002Pc-U3; Thu, 28 May 2020 05:13:49 +0000
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
        tipc-discussion@lists.sourceforge.net,
        David Howells <dhowells@redhat.com>
Subject: [PATCH 21/28] ipv4: add ip_sock_set_mtu_discover
Date:   Thu, 28 May 2020 07:12:29 +0200
Message-Id: <20200528051236.620353-22-hch@lst.de>
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

Add a helper to directly set the IP_MTU_DISCOVER sockopt from kernel
space without going through a fake uaccess.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: David Howells <dhowells@redhat.com> [rxrpc bits]
---
 include/net/ip.h         |  1 +
 net/ipv4/ip_sockglue.c   | 11 +++++++++++
 net/rxrpc/local_object.c |  8 +-------
 net/rxrpc/output.c       | 14 +++++---------
 4 files changed, 18 insertions(+), 16 deletions(-)

diff --git a/include/net/ip.h b/include/net/ip.h
index f063a491b9063..d3649c49dd333 100644
--- a/include/net/ip.h
+++ b/include/net/ip.h
@@ -766,6 +766,7 @@ static inline bool inetdev_valid_mtu(unsigned int mtu)
 }
 
 void ip_sock_set_freebind(struct sock *sk);
+int ip_sock_set_mtu_discover(struct sock *sk, int val);
 void ip_sock_set_recverr(struct sock *sk);
 void ip_sock_set_tos(struct sock *sk, int val);
 
diff --git a/net/ipv4/ip_sockglue.c b/net/ipv4/ip_sockglue.c
index aca6b81da9bae..aa115be11dcfb 100644
--- a/net/ipv4/ip_sockglue.c
+++ b/net/ipv4/ip_sockglue.c
@@ -597,6 +597,17 @@ void ip_sock_set_recverr(struct sock *sk)
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
 /*
  *	Socket option code for IP. This is the end of the line after any
  *	TCP,UDP etc options on an IP socket.
diff --git a/net/rxrpc/local_object.c b/net/rxrpc/local_object.c
index 4c0e8fe5ec1fb..6f4e6b4817cf2 100644
--- a/net/rxrpc/local_object.c
+++ b/net/rxrpc/local_object.c
@@ -174,13 +174,7 @@ static int rxrpc_open_socket(struct rxrpc_local *local, struct net *net)
 		ip_sock_set_recverr(local->socket->sk);
 
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
 		sock_enable_timestamps(local->socket->sk);
diff --git a/net/rxrpc/output.c b/net/rxrpc/output.c
index f8b632a5c6197..1ba43c3df4adb 100644
--- a/net/rxrpc/output.c
+++ b/net/rxrpc/output.c
@@ -321,7 +321,7 @@ int rxrpc_send_data_packet(struct rxrpc_call *call, struct sk_buff *skb,
 	struct kvec iov[2];
 	rxrpc_serial_t serial;
 	size_t len;
-	int ret, opt;
+	int ret;
 
 	_enter(",{%d}", skb->len);
 
@@ -473,18 +473,14 @@ int rxrpc_send_data_packet(struct rxrpc_call *call, struct sk_buff *skb,
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
-- 
2.26.2

