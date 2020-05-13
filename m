Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1B2D51D085E
	for <lists+netdev@lfdr.de>; Wed, 13 May 2020 08:34:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732336AbgEMGaJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 May 2020 02:30:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46186 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732083AbgEMG27 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 May 2020 02:28:59 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 86381C061A0C;
        Tue, 12 May 2020 23:28:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=6XOFdt3BhFcNF2nq+dKDKc/KE/QRe9Oo6tdZvR2zaY4=; b=P605jlmOKAHwaUzXuMGp80OJVA
        BxJvfSS1jIOttJdhLLliXi+cn2s5stvO7DkT3dFlQnHT0OlF0paUa9fGcjWDX8p/0XOlblpNK+4Z0
        Fql+YGdCYGrimgaS8bfFOQlB3d0B4mkOixklXM8AHtWqkvDIo5V0VJqmZqTvk4igECtxsLprp+77k
        5dKVYi5NUi8T6PMDU0L9OA3mTR4RHlv8Nu/AyQ4BvAKCxtVsavtzw+7QwsCvy82LgMqo6+KfG4/4S
        GLTV4Jr5N8SLyMjerprlkzI5pWNBaxR8hgUvoPwE3uL0b7BJRs+6bx01dW/QNyFPEK/uvAHSIWqou
        alAce1uw==;
Received: from [2001:4bb8:180:9d3f:c70:4a89:bc61:2] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jYksY-0005Ge-1j; Wed, 13 May 2020 06:28:30 +0000
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
Subject: [PATCH 32/33] sctp: add sctp_sock_get_primary_addr
Date:   Wed, 13 May 2020 08:26:47 +0200
Message-Id: <20200513062649.2100053-33-hch@lst.de>
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

Add a helper to directly get the SCTP_PRIMARY_ADDR sockopt from kernel
space without going through a fake uaccess.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/dlm/lowcomms.c       | 11 +++-----
 include/net/sctp/sctp.h |  1 +
 net/sctp/socket.c       | 57 +++++++++++++++++++++++++----------------
 3 files changed, 39 insertions(+), 30 deletions(-)

diff --git a/fs/dlm/lowcomms.c b/fs/dlm/lowcomms.c
index 6fa45365666a8..46d2d71b62c57 100644
--- a/fs/dlm/lowcomms.c
+++ b/fs/dlm/lowcomms.c
@@ -855,10 +855,9 @@ static int tcp_accept_from_sock(struct connection *con)
 static int sctp_accept_from_sock(struct connection *con)
 {
 	/* Check that the new node is in the lockspace */
-	struct sctp_prim prim;
+	struct sctp_prim prim = { };
 	int nodeid;
-	int prim_len, ret;
-	int addr_len;
+	int addr_len, ret;
 	struct connection *newcon;
 	struct connection *addcon;
 	struct socket *newsock;
@@ -876,11 +875,7 @@ static int sctp_accept_from_sock(struct connection *con)
 	if (ret < 0)
 		goto accept_err;
 
-	memset(&prim, 0, sizeof(struct sctp_prim));
-	prim_len = sizeof(struct sctp_prim);
-
-	ret = kernel_getsockopt(newsock, IPPROTO_SCTP, SCTP_PRIMARY_ADDR,
-				(char *)&prim, &prim_len);
+	ret = sctp_sock_get_primary_addr(con->sock->sk, &prim);
 	if (ret < 0) {
 		log_print("getsockopt/sctp_primary_addr failed: %d", ret);
 		goto accept_err;
diff --git a/include/net/sctp/sctp.h b/include/net/sctp/sctp.h
index b505fa082f254..c98b1d14db853 100644
--- a/include/net/sctp/sctp.h
+++ b/include/net/sctp/sctp.h
@@ -618,5 +618,6 @@ static inline bool sctp_newsk_ready(const struct sock *sk)
 int sctp_setsockopt_bindx(struct sock *sk, struct sockaddr *kaddrs,
 		int addrs_size, int op);
 void sctp_sock_set_nodelay(struct sock *sk, bool val);
+int sctp_sock_get_primary_addr(struct sock *sk, struct sctp_prim *prim);
 
 #endif /* __net_sctp_h__ */
diff --git a/net/sctp/socket.c b/net/sctp/socket.c
index 64c395f7a86d5..39bf8090dbe1e 100644
--- a/net/sctp/socket.c
+++ b/net/sctp/socket.c
@@ -6411,6 +6411,35 @@ static int sctp_getsockopt_local_addrs(struct sock *sk, int len,
 	return err;
 }
 
+static int __sctp_sock_get_primary_addr(struct sock *sk, struct sctp_prim *prim)
+{
+	struct sctp_association *asoc;
+
+	asoc = sctp_id2assoc(sk, prim->ssp_assoc_id);
+	if (!asoc)
+		return -EINVAL;
+	if (!asoc->peer.primary_path)
+		return -ENOTCONN;
+
+	memcpy(&prim->ssp_addr, &asoc->peer.primary_path->ipaddr,
+		asoc->peer.primary_path->af_specific->sockaddr_len);
+
+	sctp_get_pf_specific(sk->sk_family)->addr_to_user(sctp_sk(sk),
+			(union sctp_addr *)&prim->ssp_addr);
+	return 0;
+}
+
+int sctp_sock_get_primary_addr(struct sock *sk, struct sctp_prim *prim)
+{
+	int ret;
+
+	lock_sock(sk);
+	ret = __sctp_sock_get_primary_addr(sk, prim);
+	release_sock(sk);
+	return ret;
+}
+EXPORT_SYMBOL(sctp_sock_get_primary_addr);
+
 /* 7.1.10 Set Primary Address (SCTP_PRIMARY_ADDR)
  *
  * Requests that the local SCTP stack use the enclosed peer address as
@@ -6421,35 +6450,19 @@ static int sctp_getsockopt_primary_addr(struct sock *sk, int len,
 					char __user *optval, int __user *optlen)
 {
 	struct sctp_prim prim;
-	struct sctp_association *asoc;
-	struct sctp_sock *sp = sctp_sk(sk);
+	int ret;
 
 	if (len < sizeof(struct sctp_prim))
 		return -EINVAL;
-
-	len = sizeof(struct sctp_prim);
-
-	if (copy_from_user(&prim, optval, len))
+	if (copy_from_user(&prim, optval, sizeof(struct sctp_prim)))
 		return -EFAULT;
 
-	asoc = sctp_id2assoc(sk, prim.ssp_assoc_id);
-	if (!asoc)
-		return -EINVAL;
-
-	if (!asoc->peer.primary_path)
-		return -ENOTCONN;
-
-	memcpy(&prim.ssp_addr, &asoc->peer.primary_path->ipaddr,
-		asoc->peer.primary_path->af_specific->sockaddr_len);
-
-	sctp_get_pf_specific(sk->sk_family)->addr_to_user(sp,
-			(union sctp_addr *)&prim.ssp_addr);
+	ret = __sctp_sock_get_primary_addr(sk, &prim);
+	if (ret)
+		return ret;
 
-	if (put_user(len, optlen))
+	if (put_user(len, optlen) || copy_to_user(optval, &prim, len))
 		return -EFAULT;
-	if (copy_to_user(optval, &prim, len))
-		return -EFAULT;
-
 	return 0;
 }
 
-- 
2.26.2

