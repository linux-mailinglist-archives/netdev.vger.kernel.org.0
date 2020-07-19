Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B6B0022500A
	for <lists+netdev@lfdr.de>; Sun, 19 Jul 2020 09:22:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726274AbgGSHWs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 Jul 2020 03:22:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52436 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726038AbgGSHWq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 19 Jul 2020 03:22:46 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E45AC0619D8;
        Sun, 19 Jul 2020 00:22:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=jPdTd28iUSNhYIgdC4mnp/tHaHN1RrWtLfqJJDqMFYE=; b=qWyv/4PBaXFQRp68MfgddS/2tS
        /7HLrzv/vmv8+ShgkPPBrVEOiE7MU3nyQv17/2BYHnLyPVhJIR381KtNiDXTk6c3wojIFVpsajWlL
        ZUAuBx6Atv4Oa0KzWe1i0LsWtFcHwyzW5nIcKpUuaNxPVk3isL6Ez/r7GM58AQy0YlvBZ1T7yPFV+
        2K2EgYiwaDHawT8el1jdxvulMagGeO3B9U5tTh0IZyL6RXdrSSOoaZl2XdFVFB/8LELdmRcI1N+rz
        +g9PXEnN9Kt20RlI+N0QM7K3+Jc5vUaRu8z57cdgIPquaL/S8CMWTCZTWU5qQlUaGioFB9PWR2/II
        sHX6Oung==;
Received: from [2001:4bb8:105:4a81:4ef5:9f24:cda4:103f] (helo=localhost)
        by casper.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jx3eb-0000Pj-Q2; Sun, 19 Jul 2020 07:22:34 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     Vlad Yasevich <vyasevich@gmail.com>,
        Neil Horman <nhorman@tuxdriver.com>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        David Laight <David.Laight@ACULAB.COM>,
        linux-sctp@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH 03/51] sctp: pass a kernel pointer to __sctp_setsockopt_connectx
Date:   Sun, 19 Jul 2020 09:21:40 +0200
Message-Id: <20200719072228.112645-4-hch@lst.de>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200719072228.112645-1-hch@lst.de>
References: <20200719072228.112645-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
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
index 85ba5155b177b1..44cf2848146a91 100644
--- a/net/sctp/socket.c
+++ b/net/sctp/socket.c
@@ -1286,36 +1286,29 @@ static int __sctp_connect(struct sock *sk, struct sockaddr *kaddrs,
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
@@ -1323,12 +1316,7 @@ static int __sctp_setsockopt_connectx(struct sock *sk,
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
@@ -1336,10 +1324,10 @@ static int __sctp_setsockopt_connectx(struct sock *sk,
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
@@ -1349,13 +1337,13 @@ static int sctp_setsockopt_connectx_old(struct sock *sk,
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
@@ -1385,6 +1373,7 @@ static int sctp_getsockopt_connectx3(struct sock *sk, int len,
 {
 	struct sctp_getaddrs_old param;
 	sctp_assoc_t assoc_id = 0;
+	struct sockaddr *kaddrs;
 	int err = 0;
 
 #ifdef CONFIG_COMPAT
@@ -1408,9 +1397,12 @@ static int sctp_getsockopt_connectx3(struct sock *sk, int len,
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
@@ -4700,16 +4692,12 @@ static int sctp_setsockopt(struct sock *sk, int level, int optname,
 
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
2.27.0

