Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BFECB225032
	for <lists+netdev@lfdr.de>; Sun, 19 Jul 2020 09:23:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726845AbgGSHXf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 Jul 2020 03:23:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52614 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726775AbgGSHX3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 19 Jul 2020 03:23:29 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F3FC5C0619D2;
        Sun, 19 Jul 2020 00:23:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=JNBRunJNcyL9FnN9AEevlWStE/t4qY/mti7iqHIWc4c=; b=dyr5jx1aL5sRvJ2caPhP68zIKk
        l+UPcSZBQe3DhWUo3QYJxMvDe+oBf5ZsMyE4+GS4Ci20y3xEghJ+/PT+vWaf51HEAAU7sI/ijwo7d
        2tf9qQnjQO+GZnAws2Uqgb47JoQKRJ/MiZU1mR2whEuTFPMoI3st7RK5M45rTBWTbd3eu/ug/M1ba
        xUVhYSTURtAkFBxv18zUEINaXNK8C2pO9UyjghhlM5GL0VQFJCiEfdSvWv/7swKfuFT/JvGZQCqj1
        MdU5OHj51XRq13fu57k776j3N6t6S6Zs0fnqlbga0wnbDCwYbBYmG6k7WmKAguYPvLKyATPDacSeH
        am28Y5sg==;
Received: from [2001:4bb8:105:4a81:4ef5:9f24:cda4:103f] (helo=localhost)
        by casper.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jx3fQ-0000XG-TS; Sun, 19 Jul 2020 07:23:25 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     Vlad Yasevich <vyasevich@gmail.com>,
        Neil Horman <nhorman@tuxdriver.com>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        David Laight <David.Laight@ACULAB.COM>,
        linux-sctp@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH 42/51] sctp: pass a kernel pointer to sctp_setsockopt_scheduler
Date:   Sun, 19 Jul 2020 09:22:19 +0200
Message-Id: <20200719072228.112645-43-hch@lst.de>
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
 net/sctp/socket.c | 33 ++++++++++++++-------------------
 1 file changed, 14 insertions(+), 19 deletions(-)

diff --git a/net/sctp/socket.c b/net/sctp/socket.c
index 4dedb94bca7714..a7d6a66fbe2113 100644
--- a/net/sctp/socket.c
+++ b/net/sctp/socket.c
@@ -4115,44 +4115,39 @@ static int sctp_setsockopt_add_streams(struct sock *sk,
 }
 
 static int sctp_setsockopt_scheduler(struct sock *sk,
-				     char __user *optval,
+				     struct sctp_assoc_value *params,
 				     unsigned int optlen)
 {
 	struct sctp_sock *sp = sctp_sk(sk);
 	struct sctp_association *asoc;
-	struct sctp_assoc_value params;
 	int retval = 0;
 
-	if (optlen < sizeof(params))
+	if (optlen < sizeof(*params))
 		return -EINVAL;
 
-	optlen = sizeof(params);
-	if (copy_from_user(&params, optval, optlen))
-		return -EFAULT;
-
-	if (params.assoc_value > SCTP_SS_MAX)
+	if (params->assoc_value > SCTP_SS_MAX)
 		return -EINVAL;
 
-	asoc = sctp_id2assoc(sk, params.assoc_id);
-	if (!asoc && params.assoc_id > SCTP_ALL_ASSOC &&
+	asoc = sctp_id2assoc(sk, params->assoc_id);
+	if (!asoc && params->assoc_id > SCTP_ALL_ASSOC &&
 	    sctp_style(sk, UDP))
 		return -EINVAL;
 
 	if (asoc)
-		return sctp_sched_set_sched(asoc, params.assoc_value);
+		return sctp_sched_set_sched(asoc, params->assoc_value);
 
 	if (sctp_style(sk, TCP))
-		params.assoc_id = SCTP_FUTURE_ASSOC;
+		params->assoc_id = SCTP_FUTURE_ASSOC;
 
-	if (params.assoc_id == SCTP_FUTURE_ASSOC ||
-	    params.assoc_id == SCTP_ALL_ASSOC)
-		sp->default_ss = params.assoc_value;
+	if (params->assoc_id == SCTP_FUTURE_ASSOC ||
+	    params->assoc_id == SCTP_ALL_ASSOC)
+		sp->default_ss = params->assoc_value;
 
-	if (params.assoc_id == SCTP_CURRENT_ASSOC ||
-	    params.assoc_id == SCTP_ALL_ASSOC) {
+	if (params->assoc_id == SCTP_CURRENT_ASSOC ||
+	    params->assoc_id == SCTP_ALL_ASSOC) {
 		list_for_each_entry(asoc, &sp->ep->asocs, asocs) {
 			int ret = sctp_sched_set_sched(asoc,
-						       params.assoc_value);
+						       params->assoc_value);
 
 			if (ret && !retval)
 				retval = ret;
@@ -4660,7 +4655,7 @@ static int sctp_setsockopt(struct sock *sk, int level, int optname,
 		retval = sctp_setsockopt_add_streams(sk, kopt, optlen);
 		break;
 	case SCTP_STREAM_SCHEDULER:
-		retval = sctp_setsockopt_scheduler(sk, optval, optlen);
+		retval = sctp_setsockopt_scheduler(sk, kopt, optlen);
 		break;
 	case SCTP_STREAM_SCHEDULER_VALUE:
 		retval = sctp_setsockopt_scheduler_value(sk, optval, optlen);
-- 
2.27.0

