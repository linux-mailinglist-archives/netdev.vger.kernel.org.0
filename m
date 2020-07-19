Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EAB8A225058
	for <lists+netdev@lfdr.de>; Sun, 19 Jul 2020 09:24:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727047AbgGSHYL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 Jul 2020 03:24:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52534 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726612AbgGSHXJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 19 Jul 2020 03:23:09 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB9C8C0619D4;
        Sun, 19 Jul 2020 00:23:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=TWfnHdbhaugISv9Ww7c5URzTXgxPxJbinqrgAwDc7fM=; b=IeCeRdx0rMaEhP/6KFuEvHL4C7
        09fuwFokjtnZPvmUfNyeuUbOaxxiWkywIz6W49E60SpOMEtWltdZ3/u6Wh1nc3uPnbAOQ5XTFWNZo
        Dl9uP804RIDO3SFS/Y7lsTNIMjlRxosk45nqL3pC8UfDC3gXWOuUZHsV+3DxhEJLHWA6UJahg500r
        9RDM30pliEp4Utafr0tjThGWR6EmTk+S2DR10jYChZAzwTrahsKIOUclMlHbBon8mclML+PmkloBw
        1PGUaOBuD+kStyCQvtv1lAl+UF9WFMXtVWQQlzLPr55F1M/0oQiDJ7QQBiAotJc//TmxTOPeP7+ka
        KfT8jiRA==;
Received: from [2001:4bb8:105:4a81:4ef5:9f24:cda4:103f] (helo=localhost)
        by casper.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jx3f4-0000UK-8D; Sun, 19 Jul 2020 07:23:02 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     Vlad Yasevich <vyasevich@gmail.com>,
        Neil Horman <nhorman@tuxdriver.com>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        David Laight <David.Laight@ACULAB.COM>,
        linux-sctp@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH 25/51] sctp: pass a kernel pointer to sctp_setsockopt_hmac_ident
Date:   Sun, 19 Jul 2020 09:22:02 +0200
Message-Id: <20200719072228.112645-26-hch@lst.de>
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
 net/sctp/socket.c | 21 +++++----------------
 1 file changed, 5 insertions(+), 16 deletions(-)

diff --git a/net/sctp/socket.c b/net/sctp/socket.c
index f68aa3936df3f3..a573af7dfe41f5 100644
--- a/net/sctp/socket.c
+++ b/net/sctp/socket.c
@@ -3565,13 +3565,11 @@ static int sctp_setsockopt_auth_chunk(struct sock *sk,
  * endpoint requires the peer to use.
  */
 static int sctp_setsockopt_hmac_ident(struct sock *sk,
-				      char __user *optval,
+				      struct sctp_hmacalgo *hmacs,
 				      unsigned int optlen)
 {
 	struct sctp_endpoint *ep = sctp_sk(sk)->ep;
-	struct sctp_hmacalgo *hmacs;
 	u32 idents;
-	int err;
 
 	if (!ep->auth_enable)
 		return -EACCES;
@@ -3581,21 +3579,12 @@ static int sctp_setsockopt_hmac_ident(struct sock *sk,
 	optlen = min_t(unsigned int, optlen, sizeof(struct sctp_hmacalgo) +
 					     SCTP_AUTH_NUM_HMACS * sizeof(u16));
 
-	hmacs = memdup_user(optval, optlen);
-	if (IS_ERR(hmacs))
-		return PTR_ERR(hmacs);
-
 	idents = hmacs->shmac_num_idents;
 	if (idents == 0 || idents > SCTP_AUTH_NUM_HMACS ||
-	    (idents * sizeof(u16)) > (optlen - sizeof(struct sctp_hmacalgo))) {
-		err = -EINVAL;
-		goto out;
-	}
+	    (idents * sizeof(u16)) > (optlen - sizeof(struct sctp_hmacalgo)))
+		return -EINVAL;
 
-	err = sctp_auth_ep_set_hmacs(ep, hmacs);
-out:
-	kfree(hmacs);
-	return err;
+	return sctp_auth_ep_set_hmacs(ep, hmacs);
 }
 
 /*
@@ -4699,7 +4688,7 @@ static int sctp_setsockopt(struct sock *sk, int level, int optname,
 		retval = sctp_setsockopt_auth_chunk(sk, kopt, optlen);
 		break;
 	case SCTP_HMAC_IDENT:
-		retval = sctp_setsockopt_hmac_ident(sk, optval, optlen);
+		retval = sctp_setsockopt_hmac_ident(sk, kopt, optlen);
 		break;
 	case SCTP_AUTH_KEY:
 		retval = sctp_setsockopt_auth_key(sk, optval, optlen);
-- 
2.27.0

