Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 04D3B1DD4C3
	for <lists+netdev@lfdr.de>; Thu, 21 May 2020 19:47:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728987AbgEURrr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 May 2020 13:47:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57754 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728955AbgEURrq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 May 2020 13:47:46 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B0D17C061A0F;
        Thu, 21 May 2020 10:47:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=C9+H6Xn6ip36AyynWP3ffX974faJzKNlFKVMb3gYWuc=; b=pankMyV5AOEzWAug314ygmdW4w
        vjB6wOjEqxBRPoMQxKuK4eMr05N7Bldoep7JDnjyczDk4gSJ+/JXTOcrA+05u1A94VQ94aykGEtcC
        vDCmSXaPNeZSnbzrUu3MaAd0xACNtdtw/3tpgTpF696CAJqj4v1noK+r55vE6PyyztMJZJ++at4zr
        U54IrBzSaTFYM1u33rxadhNFIcUUdQTXvKUPGCTh2djFN4pSDq8k/uCFG+cR7otKVSMD7eVZ9P0GR
        buIGwVUfU76yN9FbB5+FklPksVjZ2ynjWLvQSdYtY5KgN47eAKgtfAxG2YRr+z1Sn87kdnzzf3rkk
        BwE0YuxQ==;
Received: from [2001:4bb8:18c:5da7:c70:4a89:bc61:2] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jbpI5-0002tK-PI; Thu, 21 May 2020 17:47:34 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     Vlad Yasevich <vyasevich@gmail.com>,
        Neil Horman <nhorman@tuxdriver.com>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        David Laight <David.Laight@ACULAB.COM>,
        linux-sctp@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH 02/49] sctp: pass a kernel pointer to sctp_setsockopt_bindx
Date:   Thu, 21 May 2020 19:46:37 +0200
Message-Id: <20200521174724.2635475-3-hch@lst.de>
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
 net/sctp/socket.c | 38 ++++++++++++--------------------------
 1 file changed, 12 insertions(+), 26 deletions(-)

diff --git a/net/sctp/socket.c b/net/sctp/socket.c
index ee6a618ee3e8e..eb08e44c0c57a 100644
--- a/net/sctp/socket.c
+++ b/net/sctp/socket.c
@@ -972,42 +972,33 @@ int sctp_asconf_mgmt(struct sctp_sock *sp, struct sctp_sockaddr_entry *addrw)
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
-				 int addrs_size, int op)
+static int sctp_setsockopt_bindx(struct sock *sk, void *addr_buf,
+				  int addrs_size, int op)
 {
-	struct sockaddr *kaddrs;
+	struct sockaddr *kaddrs = addr_buf;
 	int err;
 	int addrcnt = 0;
 	int walk_size = 0;
 	struct sockaddr *sa_addr;
-	void *addr_buf;
 	struct sctp_af *af;
 
 	pr_debug("%s: sk:%p addrs:%p addrs_size:%d opt:%d\n",
-		 __func__, sk, addrs, addrs_size, op);
+		 __func__, sk, addr_buf, addrs_size, op);
 
 	if (unlikely(addrs_size <= 0))
 		return -EINVAL;
 
-	kaddrs = memdup_user(addrs, addrs_size);
-	if (IS_ERR(kaddrs))
-		return PTR_ERR(kaddrs);
-
 	/* Walk through the addrs buffer and count the number of addresses. */
-	addr_buf = kaddrs;
 	while (walk_size < addrs_size) {
-		if (walk_size + sizeof(sa_family_t) > addrs_size) {
-			kfree(kaddrs);
+		if (walk_size + sizeof(sa_family_t) > addrs_size)
 			return -EINVAL;
-		}
 
 		sa_addr = addr_buf;
 		af = sctp_get_af_specific(sa_addr->sa_family);
@@ -1015,10 +1006,8 @@ static int sctp_setsockopt_bindx(struct sock *sk,
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
@@ -1029,8 +1018,7 @@ static int sctp_setsockopt_bindx(struct sock *sk,
 	case SCTP_BINDX_ADD_ADDR:
 		/* Allow security module to validate bindx addresses. */
 		err = security_sctp_bind_connect(sk, SCTP_SOCKOPT_BINDX_ADD,
-						 (struct sockaddr *)kaddrs,
-						 addrs_size);
+						 kaddrs, addrs_size);
 		if (err)
 			goto out;
 		err = sctp_bindx_add(sk, kaddrs, addrcnt);
@@ -1052,8 +1040,6 @@ static int sctp_setsockopt_bindx(struct sock *sk,
 	}
 
 out:
-	kfree(kaddrs);
-
 	return err;
 }
 
@@ -4698,14 +4684,14 @@ static int sctp_setsockopt(struct sock *sk, int level, int optname,
 	switch (optname) {
 	case SCTP_SOCKOPT_BINDX_ADD:
 		/* 'optlen' is the size of the addresses buffer. */
-		retval = sctp_setsockopt_bindx(sk, (struct sockaddr __user *)optval,
-					       optlen, SCTP_BINDX_ADD_ADDR);
+		retval = sctp_setsockopt_bindx(sk, kopt, optlen,
+					       SCTP_BINDX_ADD_ADDR);
 		break;
 
 	case SCTP_SOCKOPT_BINDX_REM:
 		/* 'optlen' is the size of the addresses buffer. */
-		retval = sctp_setsockopt_bindx(sk, (struct sockaddr __user *)optval,
-					       optlen, SCTP_BINDX_REM_ADDR);
+		retval = sctp_setsockopt_bindx(sk, kopt, optlen,
+					       SCTP_BINDX_REM_ADDR);
 		break;
 
 	case SCTP_SOCKOPT_CONNECTX_OLD:
-- 
2.26.2

