Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F35C91D0842
	for <lists+netdev@lfdr.de>; Wed, 13 May 2020 08:34:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732270AbgEMG3S (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 May 2020 02:29:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46240 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732222AbgEMG3O (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 May 2020 02:29:14 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 93E9CC061A0E;
        Tue, 12 May 2020 23:29:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=RT06EoGrVrHQTvP6klOVHjd2ts3cATgXnJrV7ayJulk=; b=QBzoPB1rzH3PFbPgtT4mBt8Z4C
        eDmOZEDFQC3+q/X489vXRliFZorY9s1TopC/wftxfH855f5eicviKhhwdXbHN1/VqXOxza2GxHShH
        UAcK1CcHlTXN0T21/FQ2O7nzNgevcPNlkU33mT55t1OEn7vC1f7VIYnIX3k6qeSv8knz9rrlPfscn
        lHKhIGlmdyqw0cvvpYgJzFlsgeEb4W9B0bjxYfQdAV6tWgN+bTCRfVu8mxKinxAoO96zAXMpFDzav
        hUdXU2xeCrWvrse7AX/1hBtWmLVs9wOwiEf6f7ztqAi3UmqEtEt0oJ890C2vbl11UYJdZ2D3HZmEH
        zMCmmufQ==;
Received: from [2001:4bb8:180:9d3f:c70:4a89:bc61:2] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jYksF-0004z4-Gi; Wed, 13 May 2020 06:28:11 +0000
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
Subject: [PATCH 26/33] sctp: lift copying in addrs into sctp_setsockopt
Date:   Wed, 13 May 2020 08:26:41 +0200
Message-Id: <20200513062649.2100053-27-hch@lst.de>
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

Prepare for additional kernel-space callers of sctp_setsockopt_bindx.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 net/sctp/socket.c | 71 ++++++++++++++++++-----------------------------
 1 file changed, 27 insertions(+), 44 deletions(-)

diff --git a/net/sctp/socket.c b/net/sctp/socket.c
index 827a9903ee288..1c96b52c4aa28 100644
--- a/net/sctp/socket.c
+++ b/net/sctp/socket.c
@@ -972,18 +972,16 @@ int sctp_asconf_mgmt(struct sctp_sock *sp, struct sctp_sockaddr_entry *addrw)
  * it.
  *
  * sk        The sk of the socket
- * addrs     The pointer to the addresses in user land
+ * addrs     The pointer to the addresses
  * addrssize Size of the addrs buffer
  * op        Operation to perform (add or remove, see the flags of
  *           sctp_bindx)
  *
  * Returns 0 if ok, <0 errno code on error.
  */
-static int sctp_setsockopt_bindx(struct sock *sk,
-				 struct sockaddr __user *addrs,
+static int sctp_setsockopt_bindx(struct sock *sk, struct sockaddr *kaddrs,
 				 int addrs_size, int op)
 {
-	struct sockaddr *kaddrs;
 	int err;
 	int addrcnt = 0;
 	int walk_size = 0;
@@ -991,23 +989,13 @@ static int sctp_setsockopt_bindx(struct sock *sk,
 	void *addr_buf;
 	struct sctp_af *af;
 
-	pr_debug("%s: sk:%p addrs:%p addrs_size:%d opt:%d\n",
-		 __func__, sk, addrs, addrs_size, op);
-
-	if (unlikely(addrs_size <= 0))
-		return -EINVAL;
+	pr_debug("%s: sk:%p kaddrs:%p addrs_size:%d opt:%d\n",
+		 __func__, sk, kaddrs, addrs_size, op);
 
-	kaddrs = memdup_user(addrs, addrs_size);
-	if (IS_ERR(kaddrs))
-		return PTR_ERR(kaddrs);
-
-	/* Walk through the addrs buffer and count the number of addresses. */
 	addr_buf = kaddrs;
 	while (walk_size < addrs_size) {
-		if (walk_size + sizeof(sa_family_t) > addrs_size) {
-			kfree(kaddrs);
+		if (walk_size + sizeof(sa_family_t) > addrs_size)
 			return -EINVAL;
-		}
 
 		sa_addr = addr_buf;
 		af = sctp_get_af_specific(sa_addr->sa_family);
@@ -1015,10 +1003,8 @@ static int sctp_setsockopt_bindx(struct sock *sk,
 		/* If the address family is not supported or if this address
 		 * causes the address buffer to overflow return EINVAL.
 		 */
-		if (!af || (walk_size + af->sockaddr_len) > addrs_size) {
-			kfree(kaddrs);
+		if (!af || (walk_size + af->sockaddr_len) > addrs_size)
 			return -EINVAL;
-		}
 		addrcnt++;
 		addr_buf += af->sockaddr_len;
 		walk_size += af->sockaddr_len;
@@ -1032,29 +1018,19 @@ static int sctp_setsockopt_bindx(struct sock *sk,
 						 (struct sockaddr *)kaddrs,
 						 addrs_size);
 		if (err)
-			goto out;
+			return err;
 		err = sctp_bindx_add(sk, kaddrs, addrcnt);
 		if (err)
-			goto out;
-		err = sctp_send_asconf_add_ip(sk, kaddrs, addrcnt);
-		break;
-
+			return err;
+		return sctp_send_asconf_add_ip(sk, kaddrs, addrcnt);
 	case SCTP_BINDX_REM_ADDR:
 		err = sctp_bindx_rem(sk, kaddrs, addrcnt);
 		if (err)
-			goto out;
-		err = sctp_send_asconf_del_ip(sk, kaddrs, addrcnt);
-		break;
-
+			return err;
+		return sctp_send_asconf_del_ip(sk, kaddrs, addrcnt);
 	default:
-		err = -EINVAL;
-		break;
+		return -EINVAL;
 	}
-
-out:
-	kfree(kaddrs);
-
-	return err;
 }
 
 static int sctp_connect_new_asoc(struct sctp_endpoint *ep,
@@ -4670,6 +4646,7 @@ static int sctp_setsockopt_pf_expose(struct sock *sk,
 static int sctp_setsockopt(struct sock *sk, int level, int optname,
 			   char __user *optval, unsigned int optlen)
 {
+	struct sockaddr *kaddrs;
 	int retval = 0;
 
 	pr_debug("%s: sk:%p, optname:%d\n", __func__, sk, optname);
@@ -4682,30 +4659,37 @@ static int sctp_setsockopt(struct sock *sk, int level, int optname,
 	 */
 	if (level != SOL_SCTP) {
 		struct sctp_af *af = sctp_sk(sk)->pf->af;
-		retval = af->setsockopt(sk, level, optname, optval, optlen);
-		goto out_nounlock;
+		return af->setsockopt(sk, level, optname, optval, optlen);
 	}
 
+	if (unlikely(optlen <= 0))
+		return -EINVAL;
+
+	kaddrs = memdup_user(optval, optlen);
+	if (IS_ERR(kaddrs))
+		return PTR_ERR(kaddrs);
+
+	/* Walk through the addrs buffer and count the number of addresses. */
+
 	lock_sock(sk);
 
 	switch (optname) {
 	case SCTP_SOCKOPT_BINDX_ADD:
 		/* 'optlen' is the size of the addresses buffer. */
-		retval = sctp_setsockopt_bindx(sk, (struct sockaddr __user *)optval,
+		retval = sctp_setsockopt_bindx(sk, (struct sockaddr *)optval,
 					       optlen, SCTP_BINDX_ADD_ADDR);
 		break;
 
 	case SCTP_SOCKOPT_BINDX_REM:
 		/* 'optlen' is the size of the addresses buffer. */
-		retval = sctp_setsockopt_bindx(sk, (struct sockaddr __user *)optval,
+		retval = sctp_setsockopt_bindx(sk, (struct sockaddr *)optval,
 					       optlen, SCTP_BINDX_REM_ADDR);
 		break;
 
 	case SCTP_SOCKOPT_CONNECTX_OLD:
 		/* 'optlen' is the size of the addresses buffer. */
 		retval = sctp_setsockopt_connectx_old(sk,
-					    (struct sockaddr __user *)optval,
-					    optlen);
+					    (struct sockaddr *)optval, optlen);
 		break;
 
 	case SCTP_SOCKOPT_CONNECTX:
@@ -4871,8 +4855,7 @@ static int sctp_setsockopt(struct sock *sk, int level, int optname,
 	}
 
 	release_sock(sk);
-
-out_nounlock:
+	kfree(kaddrs);
 	return retval;
 }
 
-- 
2.26.2

