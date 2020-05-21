Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 751781DD50C
	for <lists+netdev@lfdr.de>; Thu, 21 May 2020 19:50:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730419AbgEURtG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 May 2020 13:49:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58016 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730393AbgEURtD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 May 2020 13:49:03 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 952BBC061A0F;
        Thu, 21 May 2020 10:49:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=hMMcnWtuAAJtPc8NpbfssV7xJ9mxnDIdkmX22F3Gy38=; b=oqAiXmkIMrvwrMVoAa1su4Le22
        WkWz38XfKBvXCbwmOKJLFyJQVfbWpImJwwGxf/Z4Ez2HVLdz0BCtdHCwU63KK/bZ7uBG0Jd51WhmU
        mo22w6935KK/IMZyFhCETu/MwzEtlEgiW6D+qoYxcVRGCgPUlxvQ+nnn5c8qg7Ew70l9UU9MPIc4o
        K9qjVgr8P+tINhpJR95UWiw1b/sX43D1WT1u448SVrnUaaePRASzQO7K9mzsNIjchfUNW84j0GTOJ
        aQcIjH5CXO32j/1FLiBZY3kLjIj3WDt+ocLhjdF+9+y5ijIvvKqLxKVEaktOMAtcbhF0rp7nHxZc4
        c0f6OpWg==;
Received: from [2001:4bb8:18c:5da7:c70:4a89:bc61:2] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jbpJV-0003NE-9P; Thu, 21 May 2020 17:49:01 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     Vlad Yasevich <vyasevich@gmail.com>,
        Neil Horman <nhorman@tuxdriver.com>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        David Laight <David.Laight@ACULAB.COM>,
        linux-sctp@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH 35/49] sctp: pass a kernel pointer to sctp_setsockopt_default_prinfo
Date:   Thu, 21 May 2020 19:47:10 +0200
Message-Id: <20200521174724.2635475-36-hch@lst.de>
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
 net/sctp/socket.c | 45 ++++++++++++++++++++-------------------------
 1 file changed, 20 insertions(+), 25 deletions(-)

diff --git a/net/sctp/socket.c b/net/sctp/socket.c
index fb7ed11382af1..6136f863095ef 100644
--- a/net/sctp/socket.c
+++ b/net/sctp/socket.c
@@ -3940,55 +3940,50 @@ static int sctp_setsockopt_pr_supported(struct sock *sk,
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
 
@@ -4686,7 +4681,7 @@ static int sctp_setsockopt(struct sock *sk, int level, int optname,
 		retval = sctp_setsockopt_pr_supported(sk, kopt, optlen);
 		break;
 	case SCTP_DEFAULT_PRINFO:
-		retval = sctp_setsockopt_default_prinfo(sk, optval, optlen);
+		retval = sctp_setsockopt_default_prinfo(sk, kopt, optlen);
 		break;
 	case SCTP_RECONFIG_SUPPORTED:
 		retval = sctp_setsockopt_reconfig_supported(sk, optval, optlen);
-- 
2.26.2

