Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A70AE1DD4E7
	for <lists+netdev@lfdr.de>; Thu, 21 May 2020 19:50:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730182AbgEURs0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 May 2020 13:48:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57872 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730167AbgEURsV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 May 2020 13:48:21 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D2A21C061A0E;
        Thu, 21 May 2020 10:48:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=7YBgaCywWM6LfPYvDZlnjDLcZ8eXI/141IQ0aKc6DMc=; b=MDQ/13zx0n+2jOhGptovQcWp2p
        pvfqCVX22drn6bH7giIuvM3fiO3wqoMdyhhGCJXkfUk9k9oh+SW5jo//aCXOMP7eAsyr+kvNBV0KJ
        frXDTP2Ot/ZpeSIb2fmKPM6KedUfPh60Aw/GevAnVABSrkV4+3Ud9zzWdXurdJk7V+GlwH9G1er2Y
        /z9Hh9bNPrvZfQEUYWN0lae+BV/qf0PeqibfczAHcHitRbyx/bq1NPXEW3ZTaHbSMz3DZfPPVdFp5
        2kthG/ddXTAZrduwlyLm9vVR7cg14ytgJRZleOZUHEZGgWWKJLG4aiDVpN6thqbK025hGxpSLJfj/
        L3b3kF2A==;
Received: from [2001:4bb8:18c:5da7:c70:4a89:bc61:2] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jbpIh-0003F0-MI; Thu, 21 May 2020 17:48:12 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     Vlad Yasevich <vyasevich@gmail.com>,
        Neil Horman <nhorman@tuxdriver.com>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        David Laight <David.Laight@ACULAB.COM>,
        linux-sctp@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH 16/49] sctp: pass a kernel pointer to sctp_setsockopt_rtoinfo
Date:   Thu, 21 May 2020 19:46:51 +0200
Message-Id: <20200521174724.2635475-17-hch@lst.de>
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
 net/sctp/socket.c | 26 ++++++++++++--------------
 1 file changed, 12 insertions(+), 14 deletions(-)

diff --git a/net/sctp/socket.c b/net/sctp/socket.c
index 99df37bbcb903..7998b25a8a271 100644
--- a/net/sctp/socket.c
+++ b/net/sctp/socket.c
@@ -3038,9 +3038,10 @@ static int sctp_setsockopt_nodelay(struct sock *sk, int *val,
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
@@ -3048,18 +3049,15 @@ static int sctp_setsockopt_rtoinfo(struct sock *sk, char __user *optval, unsigne
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
@@ -3075,17 +3073,17 @@ static int sctp_setsockopt_rtoinfo(struct sock *sk, char __user *optval, unsigne
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
@@ -4689,7 +4687,7 @@ static int sctp_setsockopt(struct sock *sk, int level, int optname,
 		retval = sctp_setsockopt_nodelay(sk, kopt, optlen);
 		break;
 	case SCTP_RTOINFO:
-		retval = sctp_setsockopt_rtoinfo(sk, optval, optlen);
+		retval = sctp_setsockopt_rtoinfo(sk, kopt, optlen);
 		break;
 	case SCTP_ASSOCINFO:
 		retval = sctp_setsockopt_associnfo(sk, optval, optlen);
-- 
2.26.2

