Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5F83A22505B
	for <lists+netdev@lfdr.de>; Sun, 19 Jul 2020 09:25:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726093AbgGSHWq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 Jul 2020 03:22:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52422 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725355AbgGSHWp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 19 Jul 2020 03:22:45 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 90155C0619D2;
        Sun, 19 Jul 2020 00:22:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=uMqX8X0kyN7UNdKBMrK73jtuf3bxh1KypyTLgrs4j84=; b=NyTyiZcSAzRR0CP4ThmxsQODEx
        UyUw+6noRDECQ24NeTpSSnMpnPYwyrx91sA3hQf4qZakoSZ6bW5SmcxABDtq8k+4+kvYFNXHqGOz8
        4W4/wzQyashtZtTHSW/Fmlsa/GTJPgwtNxS/Lo/FqHrvWNx3TnpRLLEhqJtQJoTdLLiPHeJSq1TJZ
        YTS1UH8k2B9zS1oJ3D3PwgmQzdunAh4Fo4fNKX0MHjKONMi0W235FNNOr5YWPKmCFM1GNFhMTd8ky
        jXjLCUpopO7lQNJVlltAvfvCBdYwWsSeoxq+TOQ1TyMZCCnnvJl9/3QcvFW3AVJDFKtQLr+qsZ7z2
        QVVuH4YQ==;
Received: from [2001:4bb8:105:4a81:4ef5:9f24:cda4:103f] (helo=localhost)
        by casper.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jx3eZ-0000Pa-VU; Sun, 19 Jul 2020 07:22:32 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     Vlad Yasevich <vyasevich@gmail.com>,
        Neil Horman <nhorman@tuxdriver.com>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        David Laight <David.Laight@ACULAB.COM>,
        linux-sctp@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH 02/51] sctp: pass a kernel pointer to sctp_setsockopt_bindx
Date:   Sun, 19 Jul 2020 09:21:39 +0200
Message-Id: <20200719072228.112645-3-hch@lst.de>
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

Rename sctp_setsockopt_bindx_kernel back to sctp_setsockopt_bindx,
and use the kernel pointer that sctp_setsockopt has available instead of
directly handling the user pointer in the old sctp_setsockopt_bindx.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 net/sctp/socket.c | 33 ++++++++-------------------------
 1 file changed, 8 insertions(+), 25 deletions(-)

diff --git a/net/sctp/socket.c b/net/sctp/socket.c
index af1ebc8313d303..85ba5155b177b1 100644
--- a/net/sctp/socket.c
+++ b/net/sctp/socket.c
@@ -979,9 +979,8 @@ int sctp_asconf_mgmt(struct sctp_sock *sp, struct sctp_sockaddr_entry *addrw)
  *
  * Returns 0 if ok, <0 errno code on error.
  */
-static int sctp_setsockopt_bindx_kernel(struct sock *sk,
-					struct sockaddr *addrs, int addrs_size,
-					int op)
+static int sctp_setsockopt_bindx(struct sock *sk, struct sockaddr *addrs,
+				 int addrs_size, int op)
 {
 	int err;
 	int addrcnt = 0;
@@ -991,7 +990,7 @@ static int sctp_setsockopt_bindx_kernel(struct sock *sk,
 	struct sctp_af *af;
 
 	pr_debug("%s: sk:%p addrs:%p addrs_size:%d opt:%d\n",
-		 __func__, sk, addrs, addrs_size, op);
+		 __func__, sk, addr_buf, addrs_size, op);
 
 	if (unlikely(addrs_size <= 0))
 		return -EINVAL;
@@ -1037,29 +1036,13 @@ static int sctp_setsockopt_bindx_kernel(struct sock *sk,
 	}
 }
 
-static int sctp_setsockopt_bindx(struct sock *sk,
-				 struct sockaddr __user *addrs,
-				 int addrs_size, int op)
-{
-	struct sockaddr *kaddrs;
-	int err;
-
-	kaddrs = memdup_user(addrs, addrs_size);
-	if (IS_ERR(kaddrs))
-		return PTR_ERR(kaddrs);
-	err = sctp_setsockopt_bindx_kernel(sk, kaddrs, addrs_size, op);
-	kfree(kaddrs);
-	return err;
-}
-
 static int sctp_bind_add(struct sock *sk, struct sockaddr *addrs,
 		int addrlen)
 {
 	int err;
 
 	lock_sock(sk);
-	err = sctp_setsockopt_bindx_kernel(sk, addrs, addrlen,
-					   SCTP_BINDX_ADD_ADDR);
+	err = sctp_setsockopt_bindx(sk, addrs, addrlen, SCTP_BINDX_ADD_ADDR);
 	release_sock(sk);
 	return err;
 }
@@ -4705,14 +4688,14 @@ static int sctp_setsockopt(struct sock *sk, int level, int optname,
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
2.27.0

