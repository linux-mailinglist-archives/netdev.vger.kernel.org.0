Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D8277225014
	for <lists+netdev@lfdr.de>; Sun, 19 Jul 2020 09:23:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726512AbgGSHXA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 Jul 2020 03:23:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52476 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726021AbgGSHWz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 19 Jul 2020 03:22:55 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 629BCC0619D2;
        Sun, 19 Jul 2020 00:22:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=TV7LxvkA/tVpU6u7HAdUrK4DKXZplC1ABNW570Ku/5M=; b=fHDMRXQ7I2AzslhPg+GMxdrTww
        ET3xiBocMbzVRtJTChJAMh0EG3rsi2ibHYG5S3+wpRr9lEM2ClzrImJ6kNohTPVSunTjvmWWdw16A
        R0RM8y6DzH8MsOQRAWZ2bc55DzTBTamN5gV045a/9Eywx+VhtVrpEY4e8qlqv3qxkY/6ueFshnfDa
        ftt2sn6ep9iRIfwlri43dxCfTEGX3FONl4jlWHEBI3QbA7KG2eR/TckcvzpzjeawYbgtAcRY1bgJk
        axOKScbFAVzIvKC1h81Hv0Zk1EKRUYlLXeBP9mqDHe1oC/GC5ZBs+FbTiNfdk9thHmDhSaj2Aw0ov
        3g2QkO+Q==;
Received: from [2001:4bb8:105:4a81:4ef5:9f24:cda4:103f] (helo=localhost)
        by casper.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jx3eq-0000SR-Er; Sun, 19 Jul 2020 07:22:48 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     Vlad Yasevich <vyasevich@gmail.com>,
        Neil Horman <nhorman@tuxdriver.com>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        David Laight <David.Laight@ACULAB.COM>,
        linux-sctp@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH 14/51] sctp: pass a kernel pointer to sctp_setsockopt_peer_primary_addr
Date:   Sun, 19 Jul 2020 09:21:51 +0200
Message-Id: <20200719072228.112645-15-hch@lst.de>
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
 net/sctp/socket.c | 21 +++++++++------------
 1 file changed, 9 insertions(+), 12 deletions(-)

diff --git a/net/sctp/socket.c b/net/sctp/socket.c
index abdec7b412bcbc..ff3b720eab0aa2 100644
--- a/net/sctp/socket.c
+++ b/net/sctp/socket.c
@@ -3284,12 +3284,12 @@ static int sctp_setsockopt_maxseg(struct sock *sk, char __user *optval, unsigned
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
@@ -3302,10 +3302,7 @@ static int sctp_setsockopt_peer_primary_addr(struct sock *sk, char __user *optva
 	if (optlen != sizeof(struct sctp_setpeerprim))
 		return -EINVAL;
 
-	if (copy_from_user(&prim, optval, optlen))
-		return -EFAULT;
-
-	asoc = sctp_id2assoc(sk, prim.sspp_assoc_id);
+	asoc = sctp_id2assoc(sk, prim->sspp_assoc_id);
 	if (!asoc)
 		return -EINVAL;
 
@@ -3318,26 +3315,26 @@ static int sctp_setsockopt_peer_primary_addr(struct sock *sk, char __user *optva
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
 
@@ -4694,7 +4691,7 @@ static int sctp_setsockopt(struct sock *sk, int level, int optname,
 		retval = sctp_setsockopt_primary_addr(sk, kopt, optlen);
 		break;
 	case SCTP_SET_PEER_PRIMARY_ADDR:
-		retval = sctp_setsockopt_peer_primary_addr(sk, optval, optlen);
+		retval = sctp_setsockopt_peer_primary_addr(sk, kopt, optlen);
 		break;
 	case SCTP_NODELAY:
 		retval = sctp_setsockopt_nodelay(sk, optval, optlen);
-- 
2.27.0

