Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DCC03225044
	for <lists+netdev@lfdr.de>; Sun, 19 Jul 2020 09:24:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726964AbgGSHXz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 Jul 2020 03:23:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52622 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726658AbgGSHXb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 19 Jul 2020 03:23:31 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9885BC0619D5;
        Sun, 19 Jul 2020 00:23:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=fGU2DavvsCT/ttr+PlXC/yi0peewSyI5X9A3AAd8Tb4=; b=i7Gud9az1OCMtM2avpPM2AyhsM
        P0i8w3pqi4byYzXZkns+1PtkYqJgLd6w4c/J+QlNiPabeC3mElkFcLVo3S4sxPhJDK9RiCZdi+ESb
        orfNsPM3jV9ZA+7eWIm7CjGX31qsSWPqlfPzsgcQFz/DL9aK03XaKyw9iB02wxgXOPraL3aQt3dDm
        oeEA6fizuXzrEdmfRuAh3+67E3yB/rZzNiHl9SerpxXlXmeuoJG/9yC2X0b0ljwYp2a+VVu19wkJZ
        gYz29q2Zt8eCDFaogrXm4JRaBQhft/UhHagj3BXU2ehmCp7LRnnuEkqU3Y56i86bIQpXBPxZpSr4F
        oAFxlAkA==;
Received: from [2001:4bb8:105:4a81:4ef5:9f24:cda4:103f] (helo=localhost)
        by casper.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jx3fT-0000Xg-O7; Sun, 19 Jul 2020 07:23:28 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     Vlad Yasevich <vyasevich@gmail.com>,
        Neil Horman <nhorman@tuxdriver.com>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        David Laight <David.Laight@ACULAB.COM>,
        linux-sctp@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH 44/51] sctp: pass a kernel pointer to sctp_setsockopt_interleaving_supported
Date:   Sun, 19 Jul 2020 09:22:21 +0200
Message-Id: <20200719072228.112645-45-hch@lst.de>
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
 net/sctp/socket.c | 34 ++++++++++------------------------
 1 file changed, 10 insertions(+), 24 deletions(-)

diff --git a/net/sctp/socket.c b/net/sctp/socket.c
index 4b660e6bf3bb54..6232e46c4cdebd 100644
--- a/net/sctp/socket.c
+++ b/net/sctp/socket.c
@@ -4193,39 +4193,25 @@ static int sctp_setsockopt_scheduler_value(struct sock *sk,
 }
 
 static int sctp_setsockopt_interleaving_supported(struct sock *sk,
-						  char __user *optval,
+						  struct sctp_assoc_value *p,
 						  unsigned int optlen)
 {
 	struct sctp_sock *sp = sctp_sk(sk);
-	struct sctp_assoc_value params;
 	struct sctp_association *asoc;
-	int retval = -EINVAL;
 
-	if (optlen < sizeof(params))
-		goto out;
-
-	optlen = sizeof(params);
-	if (copy_from_user(&params, optval, optlen)) {
-		retval = -EFAULT;
-		goto out;
-	}
+	if (optlen < sizeof(*p))
+		return -EINVAL;
 
-	asoc = sctp_id2assoc(sk, params.assoc_id);
-	if (!asoc && params.assoc_id != SCTP_FUTURE_ASSOC &&
-	    sctp_style(sk, UDP))
-		goto out;
+	asoc = sctp_id2assoc(sk, p->assoc_id);
+	if (!asoc && p->assoc_id != SCTP_FUTURE_ASSOC && sctp_style(sk, UDP))
+		return -EINVAL;
 
 	if (!sock_net(sk)->sctp.intl_enable || !sp->frag_interleave) {
-		retval = -EPERM;
-		goto out;
+		return -EPERM;
 	}
 
-	sp->ep->intl_enable = !!params.assoc_value;
-
-	retval = 0;
-
-out:
-	return retval;
+	sp->ep->intl_enable = !!p->assoc_value;
+	return 0;
 }
 
 static int sctp_setsockopt_reuse_port(struct sock *sk, char __user *optval,
@@ -4655,7 +4641,7 @@ static int sctp_setsockopt(struct sock *sk, int level, int optname,
 		retval = sctp_setsockopt_scheduler_value(sk, kopt, optlen);
 		break;
 	case SCTP_INTERLEAVING_SUPPORTED:
-		retval = sctp_setsockopt_interleaving_supported(sk, optval,
+		retval = sctp_setsockopt_interleaving_supported(sk, kopt,
 								optlen);
 		break;
 	case SCTP_REUSE_PORT:
-- 
2.27.0

