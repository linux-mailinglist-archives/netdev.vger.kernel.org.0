Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DD6F51DD53C
	for <lists+netdev@lfdr.de>; Thu, 21 May 2020 19:51:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729967AbgEURu2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 May 2020 13:50:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57760 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729163AbgEURrs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 May 2020 13:47:48 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1370EC061A0E;
        Thu, 21 May 2020 10:47:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=SJ+Ph6rC+YitHvOexDFQbdPJO37rQFZR+I4PuJi52Yo=; b=H0f9X8jq4vOBnfRh4Um8Yr83tI
        BKBr3FtbdP1bG86iCyZTdXArHKEn6+ftfcSt1oZsgAFsuSfuIfqND8jOAC1JOzFcWqOgosbi0ixNo
        5u8PJewel2hPgAH+cBwuASIHqbc4Vd6DpgJ5ZGqVhsGRm2ci1H23GAUUe9jVDsLT0qU2hdRtrQYFJ
        JOFTsarYrOys7ND7a/pt45XcSzd5jWbLpxoabt8s6iLGmvbJozR1JUH2z2vXH2q5m6QmHYreaUCXe
        2SQUWQ162t3XCR+kRnirIyIU2W/vPG4WF9giJhHF7gTFECgczEW931Zf4PhhOZCC4PxMV7ikrI4bd
        IdnoVHdg==;
Received: from [2001:4bb8:18c:5da7:c70:4a89:bc61:2] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jbpI8-0002wm-9F; Thu, 21 May 2020 17:47:36 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     Vlad Yasevich <vyasevich@gmail.com>,
        Neil Horman <nhorman@tuxdriver.com>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        David Laight <David.Laight@ACULAB.COM>,
        linux-sctp@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH 03/49] sctp: pass a kernel pointer to __sctp_setsockopt_connectx
Date:   Thu, 21 May 2020 19:46:38 +0200
Message-Id: <20200521174724.2635475-4-hch@lst.de>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200521174724.2635475-1-hch@lst.de>
References: <20200521174724.2635475-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use the kernel pointer that sctp_setsockopt has available instead of
directly handling the user pointer.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 net/sctp/socket.c | 50 ++++++++++++++++++-----------------------------
 1 file changed, 19 insertions(+), 31 deletions(-)

diff --git a/net/sctp/socket.c b/net/sctp/socket.c
index eb08e44c0c57a..f7621ea99340e 100644
--- a/net/sctp/socket.c
+++ b/net/sctp/socket.c
@@ -1282,36 +1282,29 @@ static int __sctp_connect(struct sock *sk, struct sockaddr *kaddrs,
  * it.
  *
  * sk        The sk of the socket
- * addrs     The pointer to the addresses in user land
+ * addrs     The pointer to the addresses
  * addrssize Size of the addrs buffer
  *
  * Returns >=0 if ok, <0 errno code on error.
  */
-static int __sctp_setsockopt_connectx(struct sock *sk,
-				      struct sockaddr __user *addrs,
-				      int addrs_size,
-				      sctp_assoc_t *assoc_id)
+static int __sctp_setsockopt_connectx(struct sock *sk, struct sockaddr *kaddrs,
+				      int addrs_size, sctp_assoc_t *assoc_id)
 {
-	struct sockaddr *kaddrs;
 	int err = 0, flags = 0;
 
 	pr_debug("%s: sk:%p addrs:%p addrs_size:%d\n",
-		 __func__, sk, addrs, addrs_size);
+		 __func__, sk, kaddrs, addrs_size);
 
 	/* make sure the 1st addr's sa_family is accessible later */
 	if (unlikely(addrs_size < sizeof(sa_family_t)))
 		return -EINVAL;
 
-	kaddrs = memdup_user(addrs, addrs_size);
-	if (IS_ERR(kaddrs))
-		return PTR_ERR(kaddrs);
-
 	/* Allow security module to validate connectx addresses. */
 	err = security_sctp_bind_connect(sk, SCTP_SOCKOPT_CONNECTX,
 					 (struct sockaddr *)kaddrs,
 					  addrs_size);
 	if (err)
-		goto out_free;
+		return err;
 
 	/* in-kernel sockets don't generally have a file allocated to them
 	 * if all they do is call sock_create_kern().
@@ -1319,12 +1312,7 @@ static int __sctp_setsockopt_connectx(struct sock *sk,
 	if (sk->sk_socket->file)
 		flags = sk->sk_socket->file->f_flags;
 
-	err = __sctp_connect(sk, kaddrs, addrs_size, flags, assoc_id);
-
-out_free:
-	kfree(kaddrs);
-
-	return err;
+	return __sctp_connect(sk, kaddrs, addrs_size, flags, assoc_id);
 }
 
 /*
@@ -1332,10 +1320,10 @@ static int __sctp_setsockopt_connectx(struct sock *sk,
  * to the option that doesn't provide association id.
  */
 static int sctp_setsockopt_connectx_old(struct sock *sk,
-					struct sockaddr __user *addrs,
+					struct sockaddr *kaddrs,
 					int addrs_size)
 {
-	return __sctp_setsockopt_connectx(sk, addrs, addrs_size, NULL);
+	return __sctp_setsockopt_connectx(sk, kaddrs, addrs_size, NULL);
 }
 
 /*
@@ -1345,13 +1333,13 @@ static int sctp_setsockopt_connectx_old(struct sock *sk,
  * always positive.
  */
 static int sctp_setsockopt_connectx(struct sock *sk,
-				    struct sockaddr __user *addrs,
+				    struct sockaddr *kaddrs,
 				    int addrs_size)
 {
 	sctp_assoc_t assoc_id = 0;
 	int err = 0;
 
-	err = __sctp_setsockopt_connectx(sk, addrs, addrs_size, &assoc_id);
+	err = __sctp_setsockopt_connectx(sk, kaddrs, addrs_size, &assoc_id);
 
 	if (err)
 		return err;
@@ -1381,6 +1369,7 @@ static int sctp_getsockopt_connectx3(struct sock *sk, int len,
 {
 	struct sctp_getaddrs_old param;
 	sctp_assoc_t assoc_id = 0;
+	struct sockaddr *kaddrs;
 	int err = 0;
 
 #ifdef CONFIG_COMPAT
@@ -1404,9 +1393,12 @@ static int sctp_getsockopt_connectx3(struct sock *sk, int len,
 			return -EFAULT;
 	}
 
-	err = __sctp_setsockopt_connectx(sk, (struct sockaddr __user *)
-					 param.addrs, param.addr_num,
-					 &assoc_id);
+	kaddrs = memdup_user(param.addrs, param.addr_num);
+	if (IS_ERR(kaddrs))
+		return PTR_ERR(kaddrs);
+
+	err = __sctp_setsockopt_connectx(sk, kaddrs, param.addr_num, &assoc_id);
+	kfree(kaddrs);
 	if (err == 0 || err == -EINPROGRESS) {
 		if (copy_to_user(optval, &assoc_id, sizeof(assoc_id)))
 			return -EFAULT;
@@ -4696,16 +4688,12 @@ static int sctp_setsockopt(struct sock *sk, int level, int optname,
 
 	case SCTP_SOCKOPT_CONNECTX_OLD:
 		/* 'optlen' is the size of the addresses buffer. */
-		retval = sctp_setsockopt_connectx_old(sk,
-					    (struct sockaddr __user *)optval,
-					    optlen);
+		retval = sctp_setsockopt_connectx_old(sk, kopt, optlen);
 		break;
 
 	case SCTP_SOCKOPT_CONNECTX:
 		/* 'optlen' is the size of the addresses buffer. */
-		retval = sctp_setsockopt_connectx(sk,
-					    (struct sockaddr __user *)optval,
-					    optlen);
+		retval = sctp_setsockopt_connectx(sk, kopt, optlen);
 		break;
 
 	case SCTP_DISABLE_FRAGMENTS:
-- 
2.26.2

