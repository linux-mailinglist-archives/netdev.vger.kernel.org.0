Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6AF111E55A3
	for <lists+netdev@lfdr.de>; Thu, 28 May 2020 07:14:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728185AbgE1FOR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 May 2020 01:14:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40536 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728092AbgE1FOH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 May 2020 01:14:07 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 30745C08C5C4;
        Wed, 27 May 2020 22:14:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=rkPSLt83JgtGQXMIhVazd1jON1AmWkQMFJTFZxl0OWU=; b=Tyq5sSYa9G10GlkbQvW78Dk2ex
        M3xSVesP+2fGjwzr43486Tig80pF4p43ospcSpNKSyeK0iebc6ZzpklYnfUekSB0x56OR/GFnTF0m
        Su3bgd4b10XJuuMQ+sz7ZRCn6hoiVFa+vC0puKPN2qxZz7JY7B8ZKLmZzm8CmaPSHKEpYtZAmPSI6
        BBxIhFSXa5bczPHR6FL8AuXaOQkVuvAcnPDmqJwaNoM4yrImcnnRm+vFHjH53vyCw+ZpfacExy6TK
        ZM+zcCmW7OVPAoya33Lt2ndc5y4P5DAfvxleTi+sI1LrTUQe4M+IGXWf/K5f0Gva75fD0ujVhj5Rt
        s5IX4mtw==;
Received: from p4fdb1ad2.dip0.t-ipconnect.de ([79.219.26.210] helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jeArL-0002Fz-6e; Thu, 28 May 2020 05:13:39 +0000
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
        Sagi Grimberg <sagi@grimberg.me>
Subject: [PATCH 18/28] ipv4: add ip_sock_set_tos
Date:   Thu, 28 May 2020 07:12:26 +0200
Message-Id: <20200528051236.620353-19-hch@lst.de>
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

Add a helper to directly set the IP_TOS sockopt from kernel space without
going through a fake uaccess.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Acked-by: Sagi Grimberg <sagi@grimberg.me>
---
 drivers/nvme/host/tcp.c   | 14 +++-----------
 drivers/nvme/target/tcp.c | 10 ++--------
 include/net/ip.h          |  2 ++
 net/ipv4/ip_sockglue.c    | 30 +++++++++++++++++++++---------
 4 files changed, 28 insertions(+), 28 deletions(-)

diff --git a/drivers/nvme/host/tcp.c b/drivers/nvme/host/tcp.c
index 2872584f52f63..4c972d8abf317 100644
--- a/drivers/nvme/host/tcp.c
+++ b/drivers/nvme/host/tcp.c
@@ -1313,7 +1313,7 @@ static int nvme_tcp_alloc_queue(struct nvme_ctrl *nctrl,
 {
 	struct nvme_tcp_ctrl *ctrl = to_tcp_ctrl(nctrl);
 	struct nvme_tcp_queue *queue = &ctrl->queues[qid];
-	int ret, opt, rcv_pdu_size;
+	int ret, rcv_pdu_size;
 
 	queue->ctrl = ctrl;
 	INIT_LIST_HEAD(&queue->send_list);
@@ -1352,16 +1352,8 @@ static int nvme_tcp_alloc_queue(struct nvme_ctrl *nctrl,
 		sock_set_priority(queue->sock->sk, so_priority);
 
 	/* Set socket type of service */
-	if (nctrl->opts->tos >= 0) {
-		opt = nctrl->opts->tos;
-		ret = kernel_setsockopt(queue->sock, SOL_IP, IP_TOS,
-				(char *)&opt, sizeof(opt));
-		if (ret) {
-			dev_err(nctrl->device,
-				"failed to set IP_TOS sock opt %d\n", ret);
-			goto err_sock;
-		}
-	}
+	if (nctrl->opts->tos >= 0)
+		ip_sock_set_tos(queue->sock->sk, nctrl->opts->tos);
 
 	queue->sock->sk->sk_allocation = GFP_ATOMIC;
 	nvme_tcp_set_queue_io_cpu(queue);
diff --git a/drivers/nvme/target/tcp.c b/drivers/nvme/target/tcp.c
index 55bc4c3c0a74a..4546049a96b37 100644
--- a/drivers/nvme/target/tcp.c
+++ b/drivers/nvme/target/tcp.c
@@ -1452,14 +1452,8 @@ static int nvmet_tcp_set_queue_sock(struct nvmet_tcp_queue *queue)
 		sock_set_priority(sock->sk, so_priority);
 
 	/* Set socket type of service */
-	if (inet->rcv_tos > 0) {
-		int tos = inet->rcv_tos;
-
-		ret = kernel_setsockopt(sock, SOL_IP, IP_TOS,
-				(char *)&tos, sizeof(tos));
-		if (ret)
-			return ret;
-	}
+	if (inet->rcv_tos > 0)
+		ip_sock_set_tos(sock->sk, inet->rcv_tos);
 
 	write_lock_bh(&sock->sk->sk_callback_lock);
 	sock->sk->sk_user_data = queue;
diff --git a/include/net/ip.h b/include/net/ip.h
index 5b317c9f4470a..2fc52e26fa88b 100644
--- a/include/net/ip.h
+++ b/include/net/ip.h
@@ -765,4 +765,6 @@ static inline bool inetdev_valid_mtu(unsigned int mtu)
 	return likely(mtu >= IPV4_MIN_MTU);
 }
 
+void ip_sock_set_tos(struct sock *sk, int val);
+
 #endif	/* _IP_H */
diff --git a/net/ipv4/ip_sockglue.c b/net/ipv4/ip_sockglue.c
index f43d5f12aa86a..b43a29e11f4a5 100644
--- a/net/ipv4/ip_sockglue.c
+++ b/net/ipv4/ip_sockglue.c
@@ -560,6 +560,26 @@ int ip_recv_error(struct sock *sk, struct msghdr *msg, int len, int *addr_len)
 	return err;
 }
 
+static void __ip_sock_set_tos(struct sock *sk, int val)
+{
+	if (sk->sk_type == SOCK_STREAM) {
+		val &= ~INET_ECN_MASK;
+		val |= inet_sk(sk)->tos & INET_ECN_MASK;
+	}
+	if (inet_sk(sk)->tos != val) {
+		inet_sk(sk)->tos = val;
+		sk->sk_priority = rt_tos2priority(val);
+		sk_dst_reset(sk);
+	}
+}
+
+void ip_sock_set_tos(struct sock *sk, int val)
+{
+	lock_sock(sk);
+	__ip_sock_set_tos(sk, val);
+	release_sock(sk);
+}
+EXPORT_SYMBOL(ip_sock_set_tos);
 
 /*
  *	Socket option code for IP. This is the end of the line after any
@@ -823,15 +843,7 @@ static int do_ip_setsockopt(struct sock *sk, int level,
 			inet->cmsg_flags &= ~IP_CMSG_RECVFRAGSIZE;
 		break;
 	case IP_TOS:	/* This sets both TOS and Precedence */
-		if (sk->sk_type == SOCK_STREAM) {
-			val &= ~INET_ECN_MASK;
-			val |= inet->tos & INET_ECN_MASK;
-		}
-		if (inet->tos != val) {
-			inet->tos = val;
-			sk->sk_priority = rt_tos2priority(val);
-			sk_dst_reset(sk);
-		}
+		__ip_sock_set_tos(sk, val);
 		break;
 	case IP_TTL:
 		if (optlen < 1)
-- 
2.26.2

