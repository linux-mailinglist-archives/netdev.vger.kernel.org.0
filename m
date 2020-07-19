Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5639F225026
	for <lists+netdev@lfdr.de>; Sun, 19 Jul 2020 09:23:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726734AbgGSHXZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 Jul 2020 03:23:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52582 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726706AbgGSHXV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 19 Jul 2020 03:23:21 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E022C0619D2;
        Sun, 19 Jul 2020 00:23:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=8OR9qpMnS5mQw0pc2YMhJ2Lnzd56qrdFj4ouvThUCCU=; b=NLOd8hPKIu892wkjzc8qoUzh50
        PteG7hEXYJQfPVlr5oy3XCVSCqSLH+JEnJFTPxl6luKPFqMJedYs/lWvKsS4mefJked69+fJH6dNC
        tPqJa9R5LzGtPlHQh0EZPcD6h2gVFSnyrfRloE2cM8T4Z6VF+L5INJPfRuYw2NWJL5zcqpf5MXia7
        RAXMNpL0GOLARHPHBw6wCwXmOmFgnboPdfyrFi6KPoBc4t0X7Dcs2N90USIlS8M6p4LC0B1iv5HVl
        WHUGOnwSNahm2NYuJr4kFNAUVsSW7NLXn9uPezbbBAfG06uIhw2WyJB8vNd5MXjq+2Qa2IBHxezZa
        UcaWANPA==;
Received: from [2001:4bb8:105:4a81:4ef5:9f24:cda4:103f] (helo=localhost)
        by casper.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jx3fJ-0000WN-Al; Sun, 19 Jul 2020 07:23:17 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     Vlad Yasevich <vyasevich@gmail.com>,
        Neil Horman <nhorman@tuxdriver.com>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        David Laight <David.Laight@ACULAB.COM>,
        linux-sctp@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH 36/51] sctp: pass a kernel pointer to sctp_setsockopt_default_prinfo
Date:   Sun, 19 Jul 2020 09:22:13 +0200
Message-Id: <20200719072228.112645-37-hch@lst.de>
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
 net/sctp/socket.c | 45 ++++++++++++++++++++-------------------------
 1 file changed, 20 insertions(+), 25 deletions(-)

diff --git a/net/sctp/socket.c b/net/sctp/socket.c
index 245186327896b3..0eeb6e6162ad61 100644
--- a/net/sctp/socket.c
+++ b/net/sctp/socket.c
@@ -3944,55 +3944,50 @@ static int sctp_setsockopt_pr_supported(struct sock *sk,
 }
 
 static int sctp_setsockopt_default_prinfo(struct sock *sk,
-					  char __user *optval,
+					  struct sctp_default_prinfo *info,
 					  unsigned int optlen)
 {
 	struct sctp_sock *sp = sctp_sk(sk);
-	struct sctp_default_prinfo info;
 	struct sctp_association *asoc;
 	int retval = -EINVAL;
 
-	if (optlen != sizeof(info))
-		goto out;
-
-	if (copy_from_user(&info, optval, sizeof(info))) {
-		retval = -EFAULT;
+	if (optlen != sizeof(*info))
 		goto out;
-	}
 
-	if (info.pr_policy & ~SCTP_PR_SCTP_MASK)
+	if (info->pr_policy & ~SCTP_PR_SCTP_MASK)
 		goto out;
 
-	if (info.pr_policy == SCTP_PR_SCTP_NONE)
-		info.pr_value = 0;
+	if (info->pr_policy == SCTP_PR_SCTP_NONE)
+		info->pr_value = 0;
 
-	asoc = sctp_id2assoc(sk, info.pr_assoc_id);
-	if (!asoc && info.pr_assoc_id > SCTP_ALL_ASSOC &&
+	asoc = sctp_id2assoc(sk, info->pr_assoc_id);
+	if (!asoc && info->pr_assoc_id > SCTP_ALL_ASSOC &&
 	    sctp_style(sk, UDP))
 		goto out;
 
 	retval = 0;
 
 	if (asoc) {
-		SCTP_PR_SET_POLICY(asoc->default_flags, info.pr_policy);
-		asoc->default_timetolive = info.pr_value;
+		SCTP_PR_SET_POLICY(asoc->default_flags, info->pr_policy);
+		asoc->default_timetolive = info->pr_value;
 		goto out;
 	}
 
 	if (sctp_style(sk, TCP))
-		info.pr_assoc_id = SCTP_FUTURE_ASSOC;
+		info->pr_assoc_id = SCTP_FUTURE_ASSOC;
 
-	if (info.pr_assoc_id == SCTP_FUTURE_ASSOC ||
-	    info.pr_assoc_id == SCTP_ALL_ASSOC) {
-		SCTP_PR_SET_POLICY(sp->default_flags, info.pr_policy);
-		sp->default_timetolive = info.pr_value;
+	if (info->pr_assoc_id == SCTP_FUTURE_ASSOC ||
+	    info->pr_assoc_id == SCTP_ALL_ASSOC) {
+		SCTP_PR_SET_POLICY(sp->default_flags, info->pr_policy);
+		sp->default_timetolive = info->pr_value;
 	}
 
-	if (info.pr_assoc_id == SCTP_CURRENT_ASSOC ||
-	    info.pr_assoc_id == SCTP_ALL_ASSOC) {
+	if (info->pr_assoc_id == SCTP_CURRENT_ASSOC ||
+	    info->pr_assoc_id == SCTP_ALL_ASSOC) {
 		list_for_each_entry(asoc, &sp->ep->asocs, asocs) {
-			SCTP_PR_SET_POLICY(asoc->default_flags, info.pr_policy);
-			asoc->default_timetolive = info.pr_value;
+			SCTP_PR_SET_POLICY(asoc->default_flags,
+					   info->pr_policy);
+			asoc->default_timetolive = info->pr_value;
 		}
 	}
 
@@ -4690,7 +4685,7 @@ static int sctp_setsockopt(struct sock *sk, int level, int optname,
 		retval = sctp_setsockopt_pr_supported(sk, kopt, optlen);
 		break;
 	case SCTP_DEFAULT_PRINFO:
-		retval = sctp_setsockopt_default_prinfo(sk, optval, optlen);
+		retval = sctp_setsockopt_default_prinfo(sk, kopt, optlen);
 		break;
 	case SCTP_RECONFIG_SUPPORTED:
 		retval = sctp_setsockopt_reconfig_supported(sk, optval, optlen);
-- 
2.27.0

