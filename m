Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D56CD1DD535
	for <lists+netdev@lfdr.de>; Thu, 21 May 2020 19:50:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730011AbgEURuS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 May 2020 13:50:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57934 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730258AbgEURsl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 May 2020 13:48:41 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B12EC061A0E;
        Thu, 21 May 2020 10:48:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=uV/6VvsFrT7rKBrCOkAvlvdEtjI8hO5JNu4RqbiP830=; b=ppTFQsKZ3rWwcP0V3c4MTkWFcE
        TkUqfpDfcz18zodm3yXMkFZ9uISSOvhpmi8wHdg6ZE/wPAtLLriRrEe4GjtR+jI8UdiX0ZQd29PhB
        fHiWFZjkYpWpBpims5cma4xv2Tvji76lkbmH460VzroB9Llfx1Xol0CrwGRaAjoLFUuUwWCouwkBk
        qnL2bbUrE+AFgQWkAMgwoF9BBRLQecWOl7Jw11CWNRY5JXPO9Sbt70TlTlbefwUsi6z14XoLpg9Dp
        lms5i/rOgwCTsrqtzF64VVODoSpfZha8MpCPs+2tqvG/zr2P3gkCEWwPfXIn/ySBs4T6vlEHvdG5/
        KIhWRQPw==;
Received: from [2001:4bb8:18c:5da7:c70:4a89:bc61:2] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jbpJ8-0003JD-73; Thu, 21 May 2020 17:48:38 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     Vlad Yasevich <vyasevich@gmail.com>,
        Neil Horman <nhorman@tuxdriver.com>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        David Laight <David.Laight@ACULAB.COM>,
        linux-sctp@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH 26/49] sctp: pass a kernel pointer to sctp_setsockopt_auth_key
Date:   Thu, 21 May 2020 19:47:01 +0200
Message-Id: <20200521174724.2635475-27-hch@lst.de>
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
directly handling the user pointer.  Adapt sctp_setsockopt to use a
kzfree for this case.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 net/sctp/socket.c | 15 ++++++---------
 1 file changed, 6 insertions(+), 9 deletions(-)

diff --git a/net/sctp/socket.c b/net/sctp/socket.c
index 88edf5413fd22..d3442dcd49aa8 100644
--- a/net/sctp/socket.c
+++ b/net/sctp/socket.c
@@ -3591,11 +3591,10 @@ static int sctp_setsockopt_hmac_ident(struct sock *sk,
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
 
@@ -3606,10 +3605,6 @@ static int sctp_setsockopt_auth_key(struct sock *sk,
 	 */
 	optlen = min_t(unsigned int, optlen, USHRT_MAX + sizeof(*authkey));
 
-	authkey = memdup_user(optval, optlen);
-	if (IS_ERR(authkey))
-		return PTR_ERR(authkey);
-
 	if (authkey->sca_keylength > optlen - sizeof(*authkey))
 		goto out;
 
@@ -3646,7 +3641,6 @@ static int sctp_setsockopt_auth_key(struct sock *sk,
 	}
 
 out:
-	kzfree(authkey);
 	return ret;
 }
 
@@ -4688,7 +4682,7 @@ static int sctp_setsockopt(struct sock *sk, int level, int optname,
 		retval = sctp_setsockopt_hmac_ident(sk, kopt, optlen);
 		break;
 	case SCTP_AUTH_KEY:
-		retval = sctp_setsockopt_auth_key(sk, optval, optlen);
+		retval = sctp_setsockopt_auth_key(sk, kopt, optlen);
 		break;
 	case SCTP_AUTH_ACTIVE_KEY:
 		retval = sctp_setsockopt_active_key(sk, optval, optlen);
@@ -4771,7 +4765,10 @@ static int sctp_setsockopt(struct sock *sk, int level, int optname,
 	}
 
 	release_sock(sk);
-	kfree(kopt);
+	if (optname == SCTP_AUTH_KEY)
+		kzfree(kopt);
+	else
+		kfree(kopt);
 
 out_nounlock:
 	return retval;
-- 
2.26.2

