Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 05EF1225056
	for <lists+netdev@lfdr.de>; Sun, 19 Jul 2020 09:24:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726582AbgGSHXG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 Jul 2020 03:23:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52502 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726531AbgGSHXB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 19 Jul 2020 03:23:01 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 91997C0619D6;
        Sun, 19 Jul 2020 00:23:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=dpar8hE3QgCUb8gpIRH+DUz8umzgEPFSG+LoP93Of30=; b=BkXIMdivJJmcn287HRSALBghiw
        4jSeYaSC+R0FH6KV1hYrteAAZ1rH/1SVUKVo6BYeEWOIkZbLksw3aOTafV6byF3XRkpbznrIMJwqu
        78HcnxLtY7FyAuPQTNV+XN92Rup7wiv9QPWbL6+TUGYmJU6Q+D9HFDOLUJRaYA7SZBF08YxPjBa00
        i8Za3p9aMRias2cNoWjVh0jOAasQOkK5hhqZQ9893lIcw7namtFKJPWoUcPODNStLc21a81exNV3a
        wRcq7+5s3PJ/gZ0vqjPbeYh81r3JoqxoUN4+GUlBxi9dgnQcO8+djDdF74mR3RUbzXJo4hmcz7AHx
        +8yTaxGg==;
Received: from [2001:4bb8:105:4a81:4ef5:9f24:cda4:103f] (helo=localhost)
        by casper.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jx3ew-0000TN-Rz; Sun, 19 Jul 2020 07:22:55 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     Vlad Yasevich <vyasevich@gmail.com>,
        Neil Horman <nhorman@tuxdriver.com>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        David Laight <David.Laight@ACULAB.COM>,
        linux-sctp@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH 19/51] sctp: pass a kernel pointer to sctp_setsockopt_maxseg
Date:   Sun, 19 Jul 2020 09:21:56 +0200
Message-Id: <20200719072228.112645-20-hch@lst.de>
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
 net/sctp/socket.c | 22 +++++++++++-----------
 1 file changed, 11 insertions(+), 11 deletions(-)

diff --git a/net/sctp/socket.c b/net/sctp/socket.c
index 5007af318e134e..cc7d5430ad8858 100644
--- a/net/sctp/socket.c
+++ b/net/sctp/socket.c
@@ -3215,11 +3215,13 @@ static int sctp_setsockopt_mappedv4(struct sock *sk, int *val,
  *    changed (effecting future associations only).
  * assoc_value:  This parameter specifies the maximum size in bytes.
  */
-static int sctp_setsockopt_maxseg(struct sock *sk, char __user *optval, unsigned int optlen)
+static int sctp_setsockopt_maxseg(struct sock *sk,
+				  struct sctp_assoc_value *params,
+				  unsigned int optlen)
 {
 	struct sctp_sock *sp = sctp_sk(sk);
-	struct sctp_assoc_value params;
 	struct sctp_association *asoc;
+	sctp_assoc_t assoc_id;
 	int val;
 
 	if (optlen == sizeof(int)) {
@@ -3228,19 +3230,17 @@ static int sctp_setsockopt_maxseg(struct sock *sk, char __user *optval, unsigned
 				    "Use of int in maxseg socket option.\n"
 				    "Use struct sctp_assoc_value instead\n",
 				    current->comm, task_pid_nr(current));
-		if (copy_from_user(&val, optval, optlen))
-			return -EFAULT;
-		params.assoc_id = SCTP_FUTURE_ASSOC;
+		assoc_id = SCTP_FUTURE_ASSOC;
+		val = *(int *)params;
 	} else if (optlen == sizeof(struct sctp_assoc_value)) {
-		if (copy_from_user(&params, optval, optlen))
-			return -EFAULT;
-		val = params.assoc_value;
+		assoc_id = params->assoc_id;
+		val = params->assoc_value;
 	} else {
 		return -EINVAL;
 	}
 
-	asoc = sctp_id2assoc(sk, params.assoc_id);
-	if (!asoc && params.assoc_id != SCTP_FUTURE_ASSOC &&
+	asoc = sctp_id2assoc(sk, assoc_id);
+	if (!asoc && assoc_id != SCTP_FUTURE_ASSOC &&
 	    sctp_style(sk, UDP))
 		return -EINVAL;
 
@@ -4697,7 +4697,7 @@ static int sctp_setsockopt(struct sock *sk, int level, int optname,
 		retval = sctp_setsockopt_mappedv4(sk, kopt, optlen);
 		break;
 	case SCTP_MAXSEG:
-		retval = sctp_setsockopt_maxseg(sk, optval, optlen);
+		retval = sctp_setsockopt_maxseg(sk, kopt, optlen);
 		break;
 	case SCTP_ADAPTATION_LAYER:
 		retval = sctp_setsockopt_adaptation_layer(sk, optval, optlen);
-- 
2.27.0

