Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C735522504F
	for <lists+netdev@lfdr.de>; Sun, 19 Jul 2020 09:24:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727026AbgGSHYE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 Jul 2020 03:24:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52548 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726570AbgGSHXM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 19 Jul 2020 03:23:12 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 44E34C0619D4;
        Sun, 19 Jul 2020 00:23:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=3WQQnCcmCr6BLXjMsFbUu7ChFG/4BFHfb5pEQcXU4a4=; b=EJPTbvREo5XujCo5PKlYn6ZAFY
        QFbIfyUjlzzCHTyi5cANb8TGTxhsoE0QilSWoGYay0LZaA6++3teIQu/aAn6j3FUyZJXgeM1zpcgI
        +V3qpt18MH8vVol+1Vxn6bq1wiO0H2S5uBJubfaTvNciV/SXJEEmysCBCs+esHSVe9SAaQRWZtx+q
        TaoYab9dXneHzFnjPGfYUJtCEWmQTRXk01NeUQwKkrjN+DKyUSh3oIjQCMz8suq6LMuj1CTZOWyRG
        aLO2f8eGQfCTSjlfRtKci5pL/tv4+oKgF+6i1kEjF3PrssRLduidWoT7nm7/Hvp6QvGUKUlFQ6pCj
        nhkn4dvg==;
Received: from [2001:4bb8:105:4a81:4ef5:9f24:cda4:103f] (helo=localhost)
        by casper.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jx3f6-0000Uh-PI; Sun, 19 Jul 2020 07:23:05 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     Vlad Yasevich <vyasevich@gmail.com>,
        Neil Horman <nhorman@tuxdriver.com>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        David Laight <David.Laight@ACULAB.COM>,
        linux-sctp@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH 27/51] sctp: pass a kernel pointer to sctp_setsockopt_auth_key
Date:   Sun, 19 Jul 2020 09:22:04 +0200
Message-Id: <20200719072228.112645-28-hch@lst.de>
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
directly handling the user pointer.  Adapt sctp_setsockopt to use a
kzfree for this case.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 net/sctp/socket.c | 10 ++--------
 1 file changed, 2 insertions(+), 8 deletions(-)

diff --git a/net/sctp/socket.c b/net/sctp/socket.c
index 365145746b559d..b4dcccba5787e3 100644
--- a/net/sctp/socket.c
+++ b/net/sctp/socket.c
@@ -3594,11 +3594,10 @@ static int sctp_setsockopt_hmac_ident(struct sock *sk,
  * association shared key.
  */
 static int sctp_setsockopt_auth_key(struct sock *sk,
-				    char __user *optval,
+				    struct sctp_authkey *authkey,
 				    unsigned int optlen)
 {
 	struct sctp_endpoint *ep = sctp_sk(sk)->ep;
-	struct sctp_authkey *authkey;
 	struct sctp_association *asoc;
 	int ret = -EINVAL;
 
@@ -3609,10 +3608,6 @@ static int sctp_setsockopt_auth_key(struct sock *sk,
 	 */
 	optlen = min_t(unsigned int, optlen, USHRT_MAX + sizeof(*authkey));
 
-	authkey = memdup_user(optval, optlen);
-	if (IS_ERR(authkey))
-		return PTR_ERR(authkey);
-
 	if (authkey->sca_keylength > optlen - sizeof(*authkey))
 		goto out;
 
@@ -3650,7 +3645,6 @@ static int sctp_setsockopt_auth_key(struct sock *sk,
 
 out:
 	memzero_explicit(authkey, optlen);
-	kfree(authkey);
 	return ret;
 }
 
@@ -4692,7 +4686,7 @@ static int sctp_setsockopt(struct sock *sk, int level, int optname,
 		retval = sctp_setsockopt_hmac_ident(sk, kopt, optlen);
 		break;
 	case SCTP_AUTH_KEY:
-		retval = sctp_setsockopt_auth_key(sk, optval, optlen);
+		retval = sctp_setsockopt_auth_key(sk, kopt, optlen);
 		break;
 	case SCTP_AUTH_ACTIVE_KEY:
 		retval = sctp_setsockopt_active_key(sk, optval, optlen);
-- 
2.27.0

