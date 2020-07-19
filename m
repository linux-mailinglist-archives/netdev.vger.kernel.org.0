Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 21BA8225049
	for <lists+netdev@lfdr.de>; Sun, 19 Jul 2020 09:24:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726663AbgGSHXQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 Jul 2020 03:23:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52530 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726598AbgGSHXI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 19 Jul 2020 03:23:08 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 25267C0619D2;
        Sun, 19 Jul 2020 00:23:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=dHQVEHBrsREGSlOpOhDSl/gETJHcuoDyU2jK9hXFBu8=; b=ragtpvvEJpY5mxpulV1syBNzot
        MbmisJH/xDc5+XATdm7eyJepE9FS+nZiWkpak8iyS6S/9KL/TVDL2yje89tgrqh0TY/TXThorpx+l
        jrQL35KonEWtYVVAFD9R2oRwLxKcU78P15z2M/fCi3AmEHi6Z7tUUWt6DgRfcO8u/Et084bNgzzPg
        icln0pj9fAdrZFiIavt10O/BXti1DBVv8+2Tzbbc6QzoMRBxy4bBrcW0kHYEUYfVNN/nCcO8pVatD
        rmYzU7dDThdG9oXXWkJmoc7/ZDvzlbM2AfXitn+bJQvfeIdyFqC55cjuttKVaUvCYGFeuWyZZUs4H
        BcwuRHGw==;
Received: from [2001:4bb8:105:4a81:4ef5:9f24:cda4:103f] (helo=localhost)
        by casper.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jx3f3-0000UB-2F; Sun, 19 Jul 2020 07:23:01 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     Vlad Yasevich <vyasevich@gmail.com>,
        Neil Horman <nhorman@tuxdriver.com>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        David Laight <David.Laight@ACULAB.COM>,
        linux-sctp@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH 24/51] sctp: pass a kernel pointer to sctp_setsockopt_auth_chunk
Date:   Sun, 19 Jul 2020 09:22:01 +0200
Message-Id: <20200719072228.112645-25-hch@lst.de>
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
 net/sctp/socket.c | 11 ++++-------
 1 file changed, 4 insertions(+), 7 deletions(-)

diff --git a/net/sctp/socket.c b/net/sctp/socket.c
index ac7dff849290dc..f68aa3936df3f3 100644
--- a/net/sctp/socket.c
+++ b/net/sctp/socket.c
@@ -3535,21 +3535,18 @@ static int sctp_setsockopt_maxburst(struct sock *sk,
  * will only effect future associations on the socket.
  */
 static int sctp_setsockopt_auth_chunk(struct sock *sk,
-				      char __user *optval,
+				      struct sctp_authchunk *val,
 				      unsigned int optlen)
 {
 	struct sctp_endpoint *ep = sctp_sk(sk)->ep;
-	struct sctp_authchunk val;
 
 	if (!ep->auth_enable)
 		return -EACCES;
 
 	if (optlen != sizeof(struct sctp_authchunk))
 		return -EINVAL;
-	if (copy_from_user(&val, optval, optlen))
-		return -EFAULT;
 
-	switch (val.sauth_chunk) {
+	switch (val->sauth_chunk) {
 	case SCTP_CID_INIT:
 	case SCTP_CID_INIT_ACK:
 	case SCTP_CID_SHUTDOWN_COMPLETE:
@@ -3558,7 +3555,7 @@ static int sctp_setsockopt_auth_chunk(struct sock *sk,
 	}
 
 	/* add this chunk id to the endpoint */
-	return sctp_auth_ep_add_chunkid(ep, val.sauth_chunk);
+	return sctp_auth_ep_add_chunkid(ep, val->sauth_chunk);
 }
 
 /*
@@ -4699,7 +4696,7 @@ static int sctp_setsockopt(struct sock *sk, int level, int optname,
 		retval = sctp_setsockopt_maxburst(sk, kopt, optlen);
 		break;
 	case SCTP_AUTH_CHUNK:
-		retval = sctp_setsockopt_auth_chunk(sk, optval, optlen);
+		retval = sctp_setsockopt_auth_chunk(sk, kopt, optlen);
 		break;
 	case SCTP_HMAC_IDENT:
 		retval = sctp_setsockopt_hmac_ident(sk, optval, optlen);
-- 
2.27.0

