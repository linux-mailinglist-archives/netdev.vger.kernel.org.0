Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DC4CC1DD4E3
	for <lists+netdev@lfdr.de>; Thu, 21 May 2020 19:50:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730149AbgEURsS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 May 2020 13:48:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57858 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727966AbgEURsR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 May 2020 13:48:17 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 484B4C061A0E;
        Thu, 21 May 2020 10:48:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=iOe6JgwGaZZrHfSABkfjp3vB27JIcpUw1fCRdF6mDx8=; b=CgMYwaA3Pxe/EsgRrHHe6WDWK9
        6AbJQFVJK/OdbSqBwmjhVLlpS6Rl4lEMXoh93nKrA8Jf9Hvv5LGBs6iJWZP/c+ZQqBeJLje8Cg9N6
        McW9Ind4uKlfm2rhxqtBQRhAzvNMYhn2DXelo1zR6fYH4wrjgK/Ym2X3bFc/zTSGEUPQ6fejJ3/fO
        y2QpiH7G2j8uRnZIItEMbAMuKr+cDBOvxDiWOooeMRIEMmvx+XiecGpy8/1YCV3zswwHGmBSF5kND
        SymtwWgC5838UGHjA4wxRaC3jBQqQhLKwvVHkO7SJr3RmGd4IywazFJY0Kmthe3jHLfFO41DRLwZy
        NOsWQPow==;
Received: from [2001:4bb8:18c:5da7:c70:4a89:bc61:2] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jbpIc-0003Dr-PF; Thu, 21 May 2020 17:48:07 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     Vlad Yasevich <vyasevich@gmail.com>,
        Neil Horman <nhorman@tuxdriver.com>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        David Laight <David.Laight@ACULAB.COM>,
        linux-sctp@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH 14/49] sctp: pass a kernel pointer to sctp_setsockopt_peer_primary_addr
Date:   Thu, 21 May 2020 19:46:49 +0200
Message-Id: <20200521174724.2635475-15-hch@lst.de>
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
 net/sctp/socket.c | 21 +++++++++------------
 1 file changed, 9 insertions(+), 12 deletions(-)

diff --git a/net/sctp/socket.c b/net/sctp/socket.c
index df00342ac74f9..eb01992da7949 100644
--- a/net/sctp/socket.c
+++ b/net/sctp/socket.c
@@ -3281,12 +3281,12 @@ static int sctp_setsockopt_maxseg(struct sock *sk, char __user *optval, unsigned
  *   locally bound addresses. The following structure is used to make a
  *   set primary request:
  */
-static int sctp_setsockopt_peer_primary_addr(struct sock *sk, char __user *optval,
+static int sctp_setsockopt_peer_primary_addr(struct sock *sk,
+					     struct sctp_setpeerprim *prim,
 					     unsigned int optlen)
 {
 	struct sctp_sock	*sp;
 	struct sctp_association	*asoc = NULL;
-	struct sctp_setpeerprim	prim;
 	struct sctp_chunk	*chunk;
 	struct sctp_af		*af;
 	int 			err;
@@ -3299,10 +3299,7 @@ static int sctp_setsockopt_peer_primary_addr(struct sock *sk, char __user *optva
 	if (optlen != sizeof(struct sctp_setpeerprim))
 		return -EINVAL;
 
-	if (copy_from_user(&prim, optval, optlen))
-		return -EFAULT;
-
-	asoc = sctp_id2assoc(sk, prim.sspp_assoc_id);
+	asoc = sctp_id2assoc(sk, prim->sspp_assoc_id);
 	if (!asoc)
 		return -EINVAL;
 
@@ -3315,26 +3312,26 @@ static int sctp_setsockopt_peer_primary_addr(struct sock *sk, char __user *optva
 	if (!sctp_state(asoc, ESTABLISHED))
 		return -ENOTCONN;
 
-	af = sctp_get_af_specific(prim.sspp_addr.ss_family);
+	af = sctp_get_af_specific(prim->sspp_addr.ss_family);
 	if (!af)
 		return -EINVAL;
 
-	if (!af->addr_valid((union sctp_addr *)&prim.sspp_addr, sp, NULL))
+	if (!af->addr_valid((union sctp_addr *)&prim->sspp_addr, sp, NULL))
 		return -EADDRNOTAVAIL;
 
-	if (!sctp_assoc_lookup_laddr(asoc, (union sctp_addr *)&prim.sspp_addr))
+	if (!sctp_assoc_lookup_laddr(asoc, (union sctp_addr *)&prim->sspp_addr))
 		return -EADDRNOTAVAIL;
 
 	/* Allow security module to validate address. */
 	err = security_sctp_bind_connect(sk, SCTP_SET_PEER_PRIMARY_ADDR,
-					 (struct sockaddr *)&prim.sspp_addr,
+					 (struct sockaddr *)&prim->sspp_addr,
 					 af->sockaddr_len);
 	if (err)
 		return err;
 
 	/* Create an ASCONF chunk with SET_PRIMARY parameter	*/
 	chunk = sctp_make_asconf_set_prim(asoc,
-					  (union sctp_addr *)&prim.sspp_addr);
+					  (union sctp_addr *)&prim->sspp_addr);
 	if (!chunk)
 		return -ENOMEM;
 
@@ -4691,7 +4688,7 @@ static int sctp_setsockopt(struct sock *sk, int level, int optname,
 		retval = sctp_setsockopt_primary_addr(sk, kopt, optlen);
 		break;
 	case SCTP_SET_PEER_PRIMARY_ADDR:
-		retval = sctp_setsockopt_peer_primary_addr(sk, optval, optlen);
+		retval = sctp_setsockopt_peer_primary_addr(sk, kopt, optlen);
 		break;
 	case SCTP_NODELAY:
 		retval = sctp_setsockopt_nodelay(sk, optval, optlen);
-- 
2.26.2

