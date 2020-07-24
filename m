Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5CA4522BE37
	for <lists+netdev@lfdr.de>; Fri, 24 Jul 2020 08:49:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726711AbgGXGtD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Jul 2020 02:49:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59890 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725942AbgGXGtD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Jul 2020 02:49:03 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 456C0C0619D3;
        Thu, 23 Jul 2020 23:49:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:In-Reply-To:References;
        bh=YcAlNQqcIcGDr2B+/Yvv6z/Qr+jVunRviF7RSthRvHY=; b=gFoYp28O1E91wObEVpVrL9eGmc
        sJmw43c7RboH1+iDGZMVAY09HNC6/KqFJRg6aVnl5dFtKfu3CW2y/R42S8KnZL730V+tOcuXAWYu0
        PCF20JEql2K9yHxtT5fE3KLI6r13gbjB2kDywNxgdSFUnt4nfi/h6CsJyMbMb4b7xR3zYMV2IeE1j
        bxkZDlSxYTNNK/Mf5fUh/IE+v2B2jqCxfc1HlIvC/c91H8YsbiX1ZDynBs5Ux5+ADorUjjJoxDjLq
        NisbB1QdnSAYWNRbsQHh6HEFjf1mIgZ3YaADK3W16UROdjj5tiC1/gnAo4HX7Mg3UaDKsuqSklxS3
        I52UkXIQ==;
Received: from [2001:4bb8:18c:2acc:8dfe:be3c:592c:efc5] (helo=localhost)
        by casper.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jyrVq-0003O7-Ki; Fri, 24 Jul 2020 06:48:59 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     marcelo.leitner@gmail.com, nhorman@tuxdriver.com
Cc:     linux-sctp@vger.kernel.org, netdev@vger.kernel.org,
        syzbot+0e4699d000d8b874d8dc@syzkaller.appspotmail.com
Subject: [PATCH v2 net-next] sctp: fix slab-out-of-bounds in SCTP_DELAYED_SACK processing
Date:   Fri, 24 Jul 2020 08:48:55 +0200
Message-Id: <20200724064855.132552-1-hch@lst.de>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This sockopt accepts two kinds of parameters, using struct
sctp_sack_info and struct sctp_assoc_value. The mentioned commit didn't
notice an implicit cast from the smaller (latter) struct to the bigger
one (former) when copying the data from the user space, which now leads
to an attempt to write beyond the buffer (because it assumes the storing
buffer is bigger than the parameter itself).

Fix it by allocating a sctp_sack_info on stack and filling it out based
on the small struct for the compat case.

Changelog stole from an earlier patch from Marcelo Ricardo Leitner.

Fixes: ebb25defdc17 ("sctp: pass a kernel pointer to sctp_setsockopt_delayed_ack")
Reported-by: syzbot+0e4699d000d8b874d8dc@syzkaller.appspotmail.com
Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 net/sctp/socket.c | 50 +++++++++++++++++++++++++++--------------------
 1 file changed, 29 insertions(+), 21 deletions(-)

diff --git a/net/sctp/socket.c b/net/sctp/socket.c
index 9a767f35971865..2c6f910b3afac0 100644
--- a/net/sctp/socket.c
+++ b/net/sctp/socket.c
@@ -2749,31 +2749,12 @@ static void sctp_apply_asoc_delayed_ack(struct sctp_sack_info *params,
  *    timer to expire.  The default value for this is 2, setting this
  *    value to 1 will disable the delayed sack algorithm.
  */
-
-static int sctp_setsockopt_delayed_ack(struct sock *sk,
-				       struct sctp_sack_info *params,
-				       unsigned int optlen)
+static int __sctp_setsockopt_delayed_ack(struct sock *sk,
+					 struct sctp_sack_info *params)
 {
 	struct sctp_sock *sp = sctp_sk(sk);
 	struct sctp_association *asoc;
 
-	if (optlen == sizeof(struct sctp_sack_info)) {
-		if (params->sack_delay == 0 && params->sack_freq == 0)
-			return 0;
-	} else if (optlen == sizeof(struct sctp_assoc_value)) {
-		pr_warn_ratelimited(DEPRECATED
-				    "%s (pid %d) "
-				    "Use of struct sctp_assoc_value in delayed_ack socket option.\n"
-				    "Use struct sctp_sack_info instead\n",
-				    current->comm, task_pid_nr(current));
-
-		if (params->sack_delay == 0)
-			params->sack_freq = 1;
-		else
-			params->sack_freq = 0;
-	} else
-		return -EINVAL;
-
 	/* Validate value parameter. */
 	if (params->sack_delay > 500)
 		return -EINVAL;
@@ -2821,6 +2802,33 @@ static int sctp_setsockopt_delayed_ack(struct sock *sk,
 	return 0;
 }
 
+static int sctp_setsockopt_delayed_ack(struct sock *sk,
+				       struct sctp_sack_info *params,
+				       unsigned int optlen)
+{
+	if (optlen == sizeof(struct sctp_assoc_value)) {
+		struct sctp_assoc_value *v = (struct sctp_assoc_value *)params;
+		struct sctp_sack_info p;
+
+		pr_warn_ratelimited(DEPRECATED
+				    "%s (pid %d) "
+				    "Use of struct sctp_assoc_value in delayed_ack socket option.\n"
+				    "Use struct sctp_sack_info instead\n",
+				    current->comm, task_pid_nr(current));
+
+		p.sack_assoc_id = v->assoc_id;
+		p.sack_delay = v->assoc_value;
+		p.sack_freq = v->assoc_value ? 0 : 1;
+		return __sctp_setsockopt_delayed_ack(sk, &p);
+	}
+
+	if (optlen != sizeof(struct sctp_sack_info))
+		return -EINVAL;
+	if (params->sack_delay == 0 && params->sack_freq == 0)
+		return 0;
+	return __sctp_setsockopt_delayed_ack(sk, params);
+}
+
 /* 7.1.3 Initialization Parameters (SCTP_INITMSG)
  *
  * Applications can specify protocol parameters for the default association
-- 
2.27.0

