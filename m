Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3B1141DD51B
	for <lists+netdev@lfdr.de>; Thu, 21 May 2020 19:50:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730469AbgEURt2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 May 2020 13:49:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58088 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730453AbgEURtY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 May 2020 13:49:24 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B779C061A0E;
        Thu, 21 May 2020 10:49:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=5tPMqSURDR0UDtFhBlgZgSBiCIrl7O1eqcFWzN5W/kc=; b=qe00OQKrwINSDpPOYY23V/knsH
        SZ6ZWydSb8vc2DrkNpmkuu9Zh2rr/N8jgJwtK7qTHDtmGuU8oPa5Cg5dc+u0MgcE7N9uotikWbzMq
        uR/fThZFTjUHrcEiT+SOLHyZ3fjV5wJJ7G0oeCI1v01tX5JdpAq1TmHigqC4dTSZQLY8rDfxveufh
        syccO0IKmZefG3KM8sf4hI3X7NROVPuCz0W6fmI1sQTWHyqhcBVf+9Fk0b7EjKPPfxglzrtp6Wc/X
        AkZkzrwKchQ9ZjMpokta9wxFHkMS65hnxiskp98HH9IOmcf8DLrGdBn2/RUekj/IhlmIHmTK8C0oi
        6vzLecWg==;
Received: from [2001:4bb8:18c:5da7:c70:4a89:bc61:2] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jbpJn-0003QM-VC; Thu, 21 May 2020 17:49:20 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     Vlad Yasevich <vyasevich@gmail.com>,
        Neil Horman <nhorman@tuxdriver.com>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        David Laight <David.Laight@ACULAB.COM>,
        linux-sctp@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH 42/49] sctp: pass a kernel pointer to sctp_setsockopt_scheduler_value
Date:   Thu, 21 May 2020 19:47:17 +0200
Message-Id: <20200521174724.2635475-43-hch@lst.de>
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
 net/sctp/socket.c | 26 ++++++++++----------------
 1 file changed, 10 insertions(+), 16 deletions(-)

diff --git a/net/sctp/socket.c b/net/sctp/socket.c
index 122e6b95a8f0d..4d61c2885f8f2 100644
--- a/net/sctp/socket.c
+++ b/net/sctp/socket.c
@@ -4154,38 +4154,32 @@ static int sctp_setsockopt_scheduler(struct sock *sk,
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
@@ -4654,7 +4648,7 @@ static int sctp_setsockopt(struct sock *sk, int level, int optname,
 		retval = sctp_setsockopt_scheduler(sk, kopt, optlen);
 		break;
 	case SCTP_STREAM_SCHEDULER_VALUE:
-		retval = sctp_setsockopt_scheduler_value(sk, optval, optlen);
+		retval = sctp_setsockopt_scheduler_value(sk, kopt, optlen);
 		break;
 	case SCTP_INTERLEAVING_SUPPORTED:
 		retval = sctp_setsockopt_interleaving_supported(sk, optval,
-- 
2.26.2

