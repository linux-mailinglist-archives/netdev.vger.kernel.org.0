Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 388E7225033
	for <lists+netdev@lfdr.de>; Sun, 19 Jul 2020 09:23:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726853AbgGSHXh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 Jul 2020 03:23:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52620 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726801AbgGSHXa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 19 Jul 2020 03:23:30 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4BDD7C0619D4;
        Sun, 19 Jul 2020 00:23:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=JgiMFVIrFe9Ub2ygGtZpvGFynHERJH/MIl+RaUSzU90=; b=MCFzk2i8J2hyQk4eldYGhth5rl
        6PNzrF9zZJYvYOZjid3n2QVCDAFI1KbxBeBdYbgBIsgzhsSn319534JdwMW3STum2a0SvhdoN8oj4
        OTcAE0ZsALY5mCkQ2+Y0eo0Und9N/NaAmpBbn91zM8FqqSTO42HhZB3q2zyDGBWw2q3BZcJNJvyNv
        /e6qrxpZuwn3KDQ+2A+tWn+Pee/Fw70GIn4SLInIGrVFhQ30te0/bAI9DKU8A7LxPoo/SuEU9dnV9
        2qLJHDVG8tNGR2ZmtX5KwOHtksJK/Q+P4lHCosvUrKzfaILMAomgeLhi3/d0/IPGxE3Y1toWm5GS1
        SdrokLLQ==;
Received: from [2001:4bb8:105:4a81:4ef5:9f24:cda4:103f] (helo=localhost)
        by casper.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jx3fS-0000XW-E2; Sun, 19 Jul 2020 07:23:26 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     Vlad Yasevich <vyasevich@gmail.com>,
        Neil Horman <nhorman@tuxdriver.com>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        David Laight <David.Laight@ACULAB.COM>,
        linux-sctp@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH 43/51] sctp: pass a kernel pointer to sctp_setsockopt_scheduler_value
Date:   Sun, 19 Jul 2020 09:22:20 +0200
Message-Id: <20200719072228.112645-44-hch@lst.de>
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
 net/sctp/socket.c | 26 ++++++++++----------------
 1 file changed, 10 insertions(+), 16 deletions(-)

diff --git a/net/sctp/socket.c b/net/sctp/socket.c
index a7d6a66fbe2113..4b660e6bf3bb54 100644
--- a/net/sctp/socket.c
+++ b/net/sctp/socket.c
@@ -4158,38 +4158,32 @@ static int sctp_setsockopt_scheduler(struct sock *sk,
 }
 
 static int sctp_setsockopt_scheduler_value(struct sock *sk,
-					   char __user *optval,
+					   struct sctp_stream_value *params,
 					   unsigned int optlen)
 {
-	struct sctp_stream_value params;
 	struct sctp_association *asoc;
 	int retval = -EINVAL;
 
-	if (optlen < sizeof(params))
-		goto out;
-
-	optlen = sizeof(params);
-	if (copy_from_user(&params, optval, optlen)) {
-		retval = -EFAULT;
+	if (optlen < sizeof(*params))
 		goto out;
-	}
 
-	asoc = sctp_id2assoc(sk, params.assoc_id);
-	if (!asoc && params.assoc_id != SCTP_CURRENT_ASSOC &&
+	asoc = sctp_id2assoc(sk, params->assoc_id);
+	if (!asoc && params->assoc_id != SCTP_CURRENT_ASSOC &&
 	    sctp_style(sk, UDP))
 		goto out;
 
 	if (asoc) {
-		retval = sctp_sched_set_value(asoc, params.stream_id,
-					      params.stream_value, GFP_KERNEL);
+		retval = sctp_sched_set_value(asoc, params->stream_id,
+					      params->stream_value, GFP_KERNEL);
 		goto out;
 	}
 
 	retval = 0;
 
 	list_for_each_entry(asoc, &sctp_sk(sk)->ep->asocs, asocs) {
-		int ret = sctp_sched_set_value(asoc, params.stream_id,
-					       params.stream_value, GFP_KERNEL);
+		int ret = sctp_sched_set_value(asoc, params->stream_id,
+					       params->stream_value,
+					       GFP_KERNEL);
 		if (ret && !retval) /* try to return the 1st error. */
 			retval = ret;
 	}
@@ -4658,7 +4652,7 @@ static int sctp_setsockopt(struct sock *sk, int level, int optname,
 		retval = sctp_setsockopt_scheduler(sk, kopt, optlen);
 		break;
 	case SCTP_STREAM_SCHEDULER_VALUE:
-		retval = sctp_setsockopt_scheduler_value(sk, optval, optlen);
+		retval = sctp_setsockopt_scheduler_value(sk, kopt, optlen);
 		break;
 	case SCTP_INTERLEAVING_SUPPORTED:
 		retval = sctp_setsockopt_interleaving_supported(sk, optval,
-- 
2.27.0

