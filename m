Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2A26B225063
	for <lists+netdev@lfdr.de>; Sun, 19 Jul 2020 09:25:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727055AbgGSHYO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 Jul 2020 03:24:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52514 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726548AbgGSHXE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 19 Jul 2020 03:23:04 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A8B2C0619D2;
        Sun, 19 Jul 2020 00:23:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=28t6SNMLFdGdZeq+zLRrENcz+L5SC9YewWrrLkso/xI=; b=HIaDQWi4IsbuVWaaH0pJflKghu
        Cib3C0FqKXgxYcjd4LG/ZtJGW0LOwRd4uuLgLQqYJ8FtV1/kjDH24do3AGgABPiPLIbPlMgOAFBcR
        Z3ByoiJGkjAv68QOJzYpnLN7FQ+ZAB7DqrYTDRbWeacnLKi+9U/Y3umOGv9sMxI11cmS4gJtvn6Hy
        2Ru0Lw4LIN/xQksjVnR77tOaUPcbHxaKwomrk3pGcuAAYvUuYZTf55CWIBrt+bj4ls2Loh0tT99ig
        pDNezcgiyltHeVkwsAxFf8usDSLMbDCNdBO+xYCec/NLoraJ2mHGiHOqRvGsibmprBmguGK9ed5MK
        0ddtN/sA==;
Received: from [2001:4bb8:105:4a81:4ef5:9f24:cda4:103f] (helo=localhost)
        by casper.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jx3ez-0000Th-AZ; Sun, 19 Jul 2020 07:22:57 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     Vlad Yasevich <vyasevich@gmail.com>,
        Neil Horman <nhorman@tuxdriver.com>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        David Laight <David.Laight@ACULAB.COM>,
        linux-sctp@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH 21/51] sctp: pass a kernel pointer to sctp_setsockopt_context
Date:   Sun, 19 Jul 2020 09:21:58 +0200
Message-Id: <20200719072228.112645-22-hch@lst.de>
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
 net/sctp/socket.c | 28 +++++++++++++---------------
 1 file changed, 13 insertions(+), 15 deletions(-)

diff --git a/net/sctp/socket.c b/net/sctp/socket.c
index b29452f58ff988..2862047054d55a 100644
--- a/net/sctp/socket.c
+++ b/net/sctp/socket.c
@@ -3362,40 +3362,38 @@ static int sctp_setsockopt_adaptation_layer(struct sock *sk,
  * received messages from the peer and does not effect the value that is
  * saved with outbound messages.
  */
-static int sctp_setsockopt_context(struct sock *sk, char __user *optval,
+static int sctp_setsockopt_context(struct sock *sk,
+				   struct sctp_assoc_value *params,
 				   unsigned int optlen)
 {
 	struct sctp_sock *sp = sctp_sk(sk);
-	struct sctp_assoc_value params;
 	struct sctp_association *asoc;
 
 	if (optlen != sizeof(struct sctp_assoc_value))
 		return -EINVAL;
-	if (copy_from_user(&params, optval, optlen))
-		return -EFAULT;
 
-	asoc = sctp_id2assoc(sk, params.assoc_id);
-	if (!asoc && params.assoc_id > SCTP_ALL_ASSOC &&
+	asoc = sctp_id2assoc(sk, params->assoc_id);
+	if (!asoc && params->assoc_id > SCTP_ALL_ASSOC &&
 	    sctp_style(sk, UDP))
 		return -EINVAL;
 
 	if (asoc) {
-		asoc->default_rcv_context = params.assoc_value;
+		asoc->default_rcv_context = params->assoc_value;
 
 		return 0;
 	}
 
 	if (sctp_style(sk, TCP))
-		params.assoc_id = SCTP_FUTURE_ASSOC;
+		params->assoc_id = SCTP_FUTURE_ASSOC;
 
-	if (params.assoc_id == SCTP_FUTURE_ASSOC ||
-	    params.assoc_id == SCTP_ALL_ASSOC)
-		sp->default_rcv_context = params.assoc_value;
+	if (params->assoc_id == SCTP_FUTURE_ASSOC ||
+	    params->assoc_id == SCTP_ALL_ASSOC)
+		sp->default_rcv_context = params->assoc_value;
 
-	if (params.assoc_id == SCTP_CURRENT_ASSOC ||
-	    params.assoc_id == SCTP_ALL_ASSOC)
+	if (params->assoc_id == SCTP_CURRENT_ASSOC ||
+	    params->assoc_id == SCTP_ALL_ASSOC)
 		list_for_each_entry(asoc, &sp->ep->asocs, asocs)
-			asoc->default_rcv_context = params.assoc_value;
+			asoc->default_rcv_context = params->assoc_value;
 
 	return 0;
 }
@@ -4700,7 +4698,7 @@ static int sctp_setsockopt(struct sock *sk, int level, int optname,
 		retval = sctp_setsockopt_adaptation_layer(sk, kopt, optlen);
 		break;
 	case SCTP_CONTEXT:
-		retval = sctp_setsockopt_context(sk, optval, optlen);
+		retval = sctp_setsockopt_context(sk, kopt, optlen);
 		break;
 	case SCTP_FRAGMENT_INTERLEAVE:
 		retval = sctp_setsockopt_fragment_interleave(sk, optval, optlen);
-- 
2.27.0

