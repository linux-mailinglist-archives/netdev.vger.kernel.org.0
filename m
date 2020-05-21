Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 833221DD4F4
	for <lists+netdev@lfdr.de>; Thu, 21 May 2020 19:50:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730296AbgEURsn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 May 2020 13:48:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57928 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730236AbgEURsh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 May 2020 13:48:37 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3EB1AC061A0E;
        Thu, 21 May 2020 10:48:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=Bv65sC4uAgBaRnpAKqnPt6Y54+pI7qtIct0VTY/fthc=; b=ieUXnWwwjI+3F0dbwr5+oAc8qH
        Cw8+vr4g8XCP8YNUCrkSGlhyXvBY68D3aVC1y++9cVNHeW/wYCx39YIXNRK28ln8E+dgegMx/P1Pl
        Y4fTSHACfL2cxWETi3/u/Fma+2Cv0WomGN3RR1arsbfS8GUPOgFWuQ0JsV1KBpRWPutnC5Dmc/Rbg
        j0tPxNaJK02KFRVfwk2idBGZWr3HS1xP5vj5sO3CWwE7zrtrESFdOLqyEYqrptbKjbBRkvGdEpghE
        e5q+Wnox8iOtiath/82E++ZB/DTcHvQhdKDfRu3Sc6P6W0dbZzSYq4qoogn0zlHNJRiToDC/zpkEP
        NxSgENHA==;
Received: from [2001:4bb8:18c:5da7:c70:4a89:bc61:2] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jbpJ5-0003Ip-Nf; Thu, 21 May 2020 17:48:36 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     Vlad Yasevich <vyasevich@gmail.com>,
        Neil Horman <nhorman@tuxdriver.com>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        David Laight <David.Laight@ACULAB.COM>,
        linux-sctp@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH 25/49] sctp: pass a kernel pointer to sctp_setsockopt_hmac_ident
Date:   Thu, 21 May 2020 19:47:00 +0200
Message-Id: <20200521174724.2635475-26-hch@lst.de>
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
 net/sctp/socket.c | 21 +++++----------------
 1 file changed, 5 insertions(+), 16 deletions(-)

diff --git a/net/sctp/socket.c b/net/sctp/socket.c
index aa06affcd66e0..88edf5413fd22 100644
--- a/net/sctp/socket.c
+++ b/net/sctp/socket.c
@@ -3562,13 +3562,11 @@ static int sctp_setsockopt_auth_chunk(struct sock *sk,
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
@@ -3578,21 +3576,12 @@ static int sctp_setsockopt_hmac_ident(struct sock *sk,
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
@@ -4696,7 +4685,7 @@ static int sctp_setsockopt(struct sock *sk, int level, int optname,
 		retval = sctp_setsockopt_auth_chunk(sk, kopt, optlen);
 		break;
 	case SCTP_HMAC_IDENT:
-		retval = sctp_setsockopt_hmac_ident(sk, optval, optlen);
+		retval = sctp_setsockopt_hmac_ident(sk, kopt, optlen);
 		break;
 	case SCTP_AUTH_KEY:
 		retval = sctp_setsockopt_auth_key(sk, optval, optlen);
-- 
2.26.2

