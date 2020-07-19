Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7FDCC22501D
	for <lists+netdev@lfdr.de>; Sun, 19 Jul 2020 09:23:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726614AbgGSHXK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 Jul 2020 03:23:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52492 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726510AbgGSHW7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 19 Jul 2020 03:22:59 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F6CEC0619D4;
        Sun, 19 Jul 2020 00:22:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=wEfli0bKnmMvbqMdIzR/Xxdc4YVX2oyTOBz3cFFmjPM=; b=eQNWVlLigQ8j1rddf3jmicJZx/
        GtNBrPzTkUM1ooKl/ABnGiwBXTw6+29KnUxFz8TSdzOgVQHsafoNyG4FKcY03h1LkjlCMih8OmYkv
        bDYT6HIXD1IY24dMuWWe9gvBTwsZvLPiBpoR0JrxwPT4+mGmRXal3CZYsk6yu/Z37IuIDdV8d8w56
        nNOvzXBx6NWLd5rlnMJaSO+ZqT1HvktbQdIRQXlqfugWgwsqotNL9O1eyo0op36manXnRFG0NGTDw
        pb9YbF+RJ22+6F3ruXlvsaVi5p5ZJICDtE9ar5FZCdNCTHlV8O8LMmwLEWvDjIKWrTJCNRtwnh0Op
        j08FGj4Q==;
Received: from [2001:4bb8:105:4a81:4ef5:9f24:cda4:103f] (helo=localhost)
        by casper.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jx3eu-0000Sy-A9; Sun, 19 Jul 2020 07:22:52 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     Vlad Yasevich <vyasevich@gmail.com>,
        Neil Horman <nhorman@tuxdriver.com>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        David Laight <David.Laight@ACULAB.COM>,
        linux-sctp@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH 17/51] sctp: pass a kernel pointer to sctp_setsockopt_associnfo
Date:   Sun, 19 Jul 2020 09:21:54 +0200
Message-Id: <20200719072228.112645-18-hch@lst.de>
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
 net/sctp/socket.c | 32 ++++++++++++++++----------------
 1 file changed, 16 insertions(+), 16 deletions(-)

diff --git a/net/sctp/socket.c b/net/sctp/socket.c
index 6339a08b62dd2b..2a655c65e2943d 100644
--- a/net/sctp/socket.c
+++ b/net/sctp/socket.c
@@ -3105,26 +3105,25 @@ static int sctp_setsockopt_rtoinfo(struct sock *sk,
  * See [SCTP] for more information.
  *
  */
-static int sctp_setsockopt_associnfo(struct sock *sk, char __user *optval, unsigned int optlen)
+static int sctp_setsockopt_associnfo(struct sock *sk,
+				     struct sctp_assocparams *assocparams,
+				     unsigned int optlen)
 {
 
-	struct sctp_assocparams assocparams;
 	struct sctp_association *asoc;
 
 	if (optlen != sizeof(struct sctp_assocparams))
 		return -EINVAL;
-	if (copy_from_user(&assocparams, optval, optlen))
-		return -EFAULT;
 
-	asoc = sctp_id2assoc(sk, assocparams.sasoc_assoc_id);
+	asoc = sctp_id2assoc(sk, assocparams->sasoc_assoc_id);
 
-	if (!asoc && assocparams.sasoc_assoc_id != SCTP_FUTURE_ASSOC &&
+	if (!asoc && assocparams->sasoc_assoc_id != SCTP_FUTURE_ASSOC &&
 	    sctp_style(sk, UDP))
 		return -EINVAL;
 
 	/* Set the values to the specific association */
 	if (asoc) {
-		if (assocparams.sasoc_asocmaxrxt != 0) {
+		if (assocparams->sasoc_asocmaxrxt != 0) {
 			__u32 path_sum = 0;
 			int   paths = 0;
 			struct sctp_transport *peer_addr;
@@ -3141,24 +3140,25 @@ static int sctp_setsockopt_associnfo(struct sock *sk, char __user *optval, unsig
 			 * then one path.
 			 */
 			if (paths > 1 &&
-			    assocparams.sasoc_asocmaxrxt > path_sum)
+			    assocparams->sasoc_asocmaxrxt > path_sum)
 				return -EINVAL;
 
-			asoc->max_retrans = assocparams.sasoc_asocmaxrxt;
+			asoc->max_retrans = assocparams->sasoc_asocmaxrxt;
 		}
 
-		if (assocparams.sasoc_cookie_life != 0)
-			asoc->cookie_life = ms_to_ktime(assocparams.sasoc_cookie_life);
+		if (assocparams->sasoc_cookie_life != 0)
+			asoc->cookie_life =
+				ms_to_ktime(assocparams->sasoc_cookie_life);
 	} else {
 		/* Set the values to the endpoint */
 		struct sctp_sock *sp = sctp_sk(sk);
 
-		if (assocparams.sasoc_asocmaxrxt != 0)
+		if (assocparams->sasoc_asocmaxrxt != 0)
 			sp->assocparams.sasoc_asocmaxrxt =
-						assocparams.sasoc_asocmaxrxt;
-		if (assocparams.sasoc_cookie_life != 0)
+						assocparams->sasoc_asocmaxrxt;
+		if (assocparams->sasoc_cookie_life != 0)
 			sp->assocparams.sasoc_cookie_life =
-						assocparams.sasoc_cookie_life;
+						assocparams->sasoc_cookie_life;
 	}
 	return 0;
 }
@@ -4693,7 +4693,7 @@ static int sctp_setsockopt(struct sock *sk, int level, int optname,
 		retval = sctp_setsockopt_rtoinfo(sk, kopt, optlen);
 		break;
 	case SCTP_ASSOCINFO:
-		retval = sctp_setsockopt_associnfo(sk, optval, optlen);
+		retval = sctp_setsockopt_associnfo(sk, kopt, optlen);
 		break;
 	case SCTP_I_WANT_MAPPED_V4_ADDR:
 		retval = sctp_setsockopt_mappedv4(sk, optval, optlen);
-- 
2.27.0

