Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0404A225067
	for <lists+netdev@lfdr.de>; Sun, 19 Jul 2020 09:25:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727073AbgGSHYS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 Jul 2020 03:24:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52490 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726486AbgGSHW5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 19 Jul 2020 03:22:57 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BDCA6C0619D2;
        Sun, 19 Jul 2020 00:22:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=1ec3vRpnhKa7ct+IoEvBbNMPDDMUXnzAIik6WdzVJ+0=; b=o9mhekMWa+cOB2n1Nn9sN87TkH
        tvY0VQaas8ip2ut6FwEluUmTht+zL4gqfICoha/s7KSZyRa99i18msgVXCKcy4WwAe5NkASmVkv89
        FAD16ZGDhRZ442KDl4b0XmFIr99tvSqkXG/kUnaJzooVbPegiLClqhwZs9O2qeAODw4aLEoCQIaV8
        pxlvsjOU7Z1FbpRLjyZ/7BplSyO/RGJ2yCI1iu/XyDgyML1x9QGZjeBIh2KauBY2yM5leCowTVTbY
        X6LiFzqp9YeYGp/Kp4PAulAjHsH26F1kwd7Qdfogcgcop50vYNZ8lIvB6+QzBIM9ZpGC3fJUjG7Qy
        /z7m1A3w==;
Received: from [2001:4bb8:105:4a81:4ef5:9f24:cda4:103f] (helo=localhost)
        by casper.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jx3es-0000Sn-Vi; Sun, 19 Jul 2020 07:22:51 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     Vlad Yasevich <vyasevich@gmail.com>,
        Neil Horman <nhorman@tuxdriver.com>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        David Laight <David.Laight@ACULAB.COM>,
        linux-sctp@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH 16/51] sctp: pass a kernel pointer to sctp_setsockopt_rtoinfo
Date:   Sun, 19 Jul 2020 09:21:53 +0200
Message-Id: <20200719072228.112645-17-hch@lst.de>
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
 net/sctp/socket.c | 26 ++++++++++++--------------
 1 file changed, 12 insertions(+), 14 deletions(-)

diff --git a/net/sctp/socket.c b/net/sctp/socket.c
index f9fe93e865b970..6339a08b62dd2b 100644
--- a/net/sctp/socket.c
+++ b/net/sctp/socket.c
@@ -3041,9 +3041,10 @@ static int sctp_setsockopt_nodelay(struct sock *sk, int *val,
  * be changed.
  *
  */
-static int sctp_setsockopt_rtoinfo(struct sock *sk, char __user *optval, unsigned int optlen)
+static int sctp_setsockopt_rtoinfo(struct sock *sk,
+				   struct sctp_rtoinfo *rtoinfo,
+				   unsigned int optlen)
 {
-	struct sctp_rtoinfo rtoinfo;
 	struct sctp_association *asoc;
 	unsigned long rto_min, rto_max;
 	struct sctp_sock *sp = sctp_sk(sk);
@@ -3051,18 +3052,15 @@ static int sctp_setsockopt_rtoinfo(struct sock *sk, char __user *optval, unsigne
 	if (optlen != sizeof (struct sctp_rtoinfo))
 		return -EINVAL;
 
-	if (copy_from_user(&rtoinfo, optval, optlen))
-		return -EFAULT;
-
-	asoc = sctp_id2assoc(sk, rtoinfo.srto_assoc_id);
+	asoc = sctp_id2assoc(sk, rtoinfo->srto_assoc_id);
 
 	/* Set the values to the specific association */
-	if (!asoc && rtoinfo.srto_assoc_id != SCTP_FUTURE_ASSOC &&
+	if (!asoc && rtoinfo->srto_assoc_id != SCTP_FUTURE_ASSOC &&
 	    sctp_style(sk, UDP))
 		return -EINVAL;
 
-	rto_max = rtoinfo.srto_max;
-	rto_min = rtoinfo.srto_min;
+	rto_max = rtoinfo->srto_max;
+	rto_min = rtoinfo->srto_min;
 
 	if (rto_max)
 		rto_max = asoc ? msecs_to_jiffies(rto_max) : rto_max;
@@ -3078,17 +3076,17 @@ static int sctp_setsockopt_rtoinfo(struct sock *sk, char __user *optval, unsigne
 		return -EINVAL;
 
 	if (asoc) {
-		if (rtoinfo.srto_initial != 0)
+		if (rtoinfo->srto_initial != 0)
 			asoc->rto_initial =
-				msecs_to_jiffies(rtoinfo.srto_initial);
+				msecs_to_jiffies(rtoinfo->srto_initial);
 		asoc->rto_max = rto_max;
 		asoc->rto_min = rto_min;
 	} else {
 		/* If there is no association or the association-id = 0
 		 * set the values to the endpoint.
 		 */
-		if (rtoinfo.srto_initial != 0)
-			sp->rtoinfo.srto_initial = rtoinfo.srto_initial;
+		if (rtoinfo->srto_initial != 0)
+			sp->rtoinfo.srto_initial = rtoinfo->srto_initial;
 		sp->rtoinfo.srto_max = rto_max;
 		sp->rtoinfo.srto_min = rto_min;
 	}
@@ -4692,7 +4690,7 @@ static int sctp_setsockopt(struct sock *sk, int level, int optname,
 		retval = sctp_setsockopt_nodelay(sk, kopt, optlen);
 		break;
 	case SCTP_RTOINFO:
-		retval = sctp_setsockopt_rtoinfo(sk, optval, optlen);
+		retval = sctp_setsockopt_rtoinfo(sk, kopt, optlen);
 		break;
 	case SCTP_ASSOCINFO:
 		retval = sctp_setsockopt_associnfo(sk, optval, optlen);
-- 
2.27.0

