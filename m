Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 02C181DD4E1
	for <lists+netdev@lfdr.de>; Thu, 21 May 2020 19:50:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730143AbgEURsQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 May 2020 13:48:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57848 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727966AbgEURsO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 May 2020 13:48:14 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 917A9C061A0E;
        Thu, 21 May 2020 10:48:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=Fw5nGx5iNocIYr+4Z6YLggjghVsrFkUZRCH/JS2bxRs=; b=mD5WHemwvPX5CN+ZYPSwgVjB9v
        sWKC0k/povdSEjWJz7G2t9pT5e3uHf7+uL7JOJYYWCROel/TY9PTmoy5RjP0l1L1kGIvN5S62t5Zl
        eMroxuj1t0ghXjHH0+gZW37nb4AD79sm7eHt4XkXkBYSufrhI4P99BCvBHmZY2FlrTLvp/hJUTgEv
        ALnmQEg8vpvBELSNnj1epyDwLXWcfx03kV+BE20KedIlCxxf/S1KOKa5Dz820pC8WCj6QaSJzEQdd
        KxClXJ7V3KqX7z87aQX8BBJIBCMyhpv8Ir9LTlzdnJF9mC090k9p4Kc+RDgA1/E4Sv+ZutwHcSrqc
        TQakRqAQ==;
Received: from [2001:4bb8:18c:5da7:c70:4a89:bc61:2] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jbpIa-0003DH-6P; Thu, 21 May 2020 17:48:04 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     Vlad Yasevich <vyasevich@gmail.com>,
        Neil Horman <nhorman@tuxdriver.com>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        David Laight <David.Laight@ACULAB.COM>,
        linux-sctp@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH 13/49] sctp: pass a kernel pointer to sctp_setsockopt_primary_addr
Date:   Thu, 21 May 2020 19:46:48 +0200
Message-Id: <20200521174724.2635475-14-hch@lst.de>
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
 net/sctp/socket.c | 14 +++++---------
 1 file changed, 5 insertions(+), 9 deletions(-)

diff --git a/net/sctp/socket.c b/net/sctp/socket.c
index 53bd58a5cc954..df00342ac74f9 100644
--- a/net/sctp/socket.c
+++ b/net/sctp/socket.c
@@ -2979,10 +2979,9 @@ static int sctp_setsockopt_default_sndinfo(struct sock *sk,
  * the association primary.  The enclosed address must be one of the
  * association peer's addresses.
  */
-static int sctp_setsockopt_primary_addr(struct sock *sk, char __user *optval,
+static int sctp_setsockopt_primary_addr(struct sock *sk, struct sctp_prim *prim,
 					unsigned int optlen)
 {
-	struct sctp_prim prim;
 	struct sctp_transport *trans;
 	struct sctp_af *af;
 	int err;
@@ -2990,21 +2989,18 @@ static int sctp_setsockopt_primary_addr(struct sock *sk, char __user *optval,
 	if (optlen != sizeof(struct sctp_prim))
 		return -EINVAL;
 
-	if (copy_from_user(&prim, optval, sizeof(struct sctp_prim)))
-		return -EFAULT;
-
 	/* Allow security module to validate address but need address len. */
-	af = sctp_get_af_specific(prim.ssp_addr.ss_family);
+	af = sctp_get_af_specific(prim->ssp_addr.ss_family);
 	if (!af)
 		return -EINVAL;
 
 	err = security_sctp_bind_connect(sk, SCTP_PRIMARY_ADDR,
-					 (struct sockaddr *)&prim.ssp_addr,
+					 (struct sockaddr *)&prim->ssp_addr,
 					 af->sockaddr_len);
 	if (err)
 		return err;
 
-	trans = sctp_addr_id2transport(sk, &prim.ssp_addr, prim.ssp_assoc_id);
+	trans = sctp_addr_id2transport(sk, &prim->ssp_addr, prim->ssp_assoc_id);
 	if (!trans)
 		return -EINVAL;
 
@@ -4692,7 +4688,7 @@ static int sctp_setsockopt(struct sock *sk, int level, int optname,
 		retval = sctp_setsockopt_default_sndinfo(sk, kopt, optlen);
 		break;
 	case SCTP_PRIMARY_ADDR:
-		retval = sctp_setsockopt_primary_addr(sk, optval, optlen);
+		retval = sctp_setsockopt_primary_addr(sk, kopt, optlen);
 		break;
 	case SCTP_SET_PEER_PRIMARY_ADDR:
 		retval = sctp_setsockopt_peer_primary_addr(sk, optval, optlen);
-- 
2.26.2

