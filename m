Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 97AE61E55E3
	for <lists+netdev@lfdr.de>; Thu, 28 May 2020 07:15:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728361AbgE1FPT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 May 2020 01:15:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40558 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728151AbgE1FON (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 May 2020 01:14:13 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB2DDC05BD1E;
        Wed, 27 May 2020 22:14:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=RW7ZqKy2D0i6aMR50NUIoRMS4UGwWL8V3Nqk5vVzkJU=; b=mlqmJtJEAdoKf9Xj8lmOlXm46b
        ISI7tlVg9LrVFkjsMDcUbUSdi1j4S9rGzg8Okqw8e5iU1kGfPkZ5EwQirpip/w1y5VhySxcM5Sye8
        nATpceTs4XMQlpjo/pkNd2IhBMu13oWQ0It8fHvgvHglK4IfWsvgmvd0bIXmmMiu5XXpNUCR+0Qcj
        /SnauKf6Nh2juSUxouSJ2Fqi6LYSkq6u5tGcJCn9zbhyGGWUjVjscdNsfywkx6n9081EXd1AwGUUv
        bMzfB6dY8tbI7dtfSALSTGDeFKl1KiXEwuVsEkNI/ML4x5oY7YwYgGYnJFwB7Y7ifDp5N6raIaOb1
        fWFk2MuA==;
Received: from p4fdb1ad2.dip0.t-ipconnect.de ([79.219.26.210] helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jeArY-0002SN-1s; Thu, 28 May 2020 05:13:52 +0000
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
Subject: [PATCH 22/28] ipv4: add ip_sock_set_pktinfo
Date:   Thu, 28 May 2020 07:12:30 +0200
Message-Id: <20200528051236.620353-23-hch@lst.de>
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

Add a helper to directly set the IP_PKTINFO sockopt from kernel
space without going through a fake uaccess.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 include/net/ip.h       | 1 +
 net/ipv4/ip_sockglue.c | 8 ++++++++
 net/sunrpc/svcsock.c   | 5 ++---
 3 files changed, 11 insertions(+), 3 deletions(-)

diff --git a/include/net/ip.h b/include/net/ip.h
index d3649c49dd333..04ebe7bf54c6a 100644
--- a/include/net/ip.h
+++ b/include/net/ip.h
@@ -767,6 +767,7 @@ static inline bool inetdev_valid_mtu(unsigned int mtu)
 
 void ip_sock_set_freebind(struct sock *sk);
 int ip_sock_set_mtu_discover(struct sock *sk, int val);
+void ip_sock_set_pktinfo(struct sock *sk);
 void ip_sock_set_recverr(struct sock *sk);
 void ip_sock_set_tos(struct sock *sk, int val);
 
diff --git a/net/ipv4/ip_sockglue.c b/net/ipv4/ip_sockglue.c
index aa115be11dcfb..84ec3703c9091 100644
--- a/net/ipv4/ip_sockglue.c
+++ b/net/ipv4/ip_sockglue.c
@@ -608,6 +608,14 @@ int ip_sock_set_mtu_discover(struct sock *sk, int val)
 }
 EXPORT_SYMBOL(ip_sock_set_mtu_discover);
 
+void ip_sock_set_pktinfo(struct sock *sk)
+{
+	lock_sock(sk);
+	inet_sk(sk)->cmsg_flags |= IP_CMSG_PKTINFO;
+	release_sock(sk);
+}
+EXPORT_SYMBOL(ip_sock_set_pktinfo);
+
 /*
  *	Socket option code for IP. This is the end of the line after any
  *	TCP,UDP etc options on an IP socket.
diff --git a/net/sunrpc/svcsock.c b/net/sunrpc/svcsock.c
index 6773dacc64d8e..7a805d165689c 100644
--- a/net/sunrpc/svcsock.c
+++ b/net/sunrpc/svcsock.c
@@ -616,9 +616,8 @@ static void svc_udp_init(struct svc_sock *svsk, struct svc_serv *serv)
 	/* make sure we get destination address info */
 	switch (svsk->sk_sk->sk_family) {
 	case AF_INET:
-		level = SOL_IP;
-		optname = IP_PKTINFO;
-		break;
+		ip_sock_set_pktinfo(svsk->sk_sock->sk);
+		return;
 	case AF_INET6:
 		level = SOL_IPV6;
 		optname = IPV6_RECVPKTINFO;
-- 
2.26.2

