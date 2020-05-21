Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 240851DD509
	for <lists+netdev@lfdr.de>; Thu, 21 May 2020 19:50:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730414AbgEURtF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 May 2020 13:49:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58006 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730382AbgEURtA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 May 2020 13:49:00 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E082C061A0E;
        Thu, 21 May 2020 10:49:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=2g0u4o8Rvmwnji3cNAjrXaCaw/C+5697blWlj0zWtyA=; b=qvDb+ii6xtpMIuGfzmmMn3NENY
        W1uVexQ8lNKX13amLA/hy9Z0Ne8RjJRfvg+N4vR0zQb8OJqTwpIAwRBj+eMpEm50ln1YIWa0uCCOV
        lLqy4ZGK8+fCLAP1lU34qYLsFols4b2Zu+YtE1tfSYl/asTc8CZ3HjXQpYzyUbXCg4eGZQUItC4nZ
        6krYKAwaBZlj2QERw0r5chGR1vAjvJ7epF0S6Y97K8gXXvcc9YPVrZutZSOEoEmNtlUxBoMKpdw1J
        Kyam668iCCa9R0Pzk/yjDP3x5QUUYtgxz3PDIu0joHG7NL++2bZ9ZF8elDn2AmODWvGQRuD5k61UZ
        6+aSpVzw==;
Received: from [2001:4bb8:18c:5da7:c70:4a89:bc61:2] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jbpJS-0003Mx-PH; Thu, 21 May 2020 17:48:59 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     Vlad Yasevich <vyasevich@gmail.com>,
        Neil Horman <nhorman@tuxdriver.com>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        David Laight <David.Laight@ACULAB.COM>,
        linux-sctp@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH 34/49] sctp: pass a kernel pointer to sctp_setsockopt_pr_supported
Date:   Thu, 21 May 2020 19:47:09 +0200
Message-Id: <20200521174724.2635475-35-hch@lst.de>
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
 net/sctp/socket.c | 16 ++++++----------
 1 file changed, 6 insertions(+), 10 deletions(-)

diff --git a/net/sctp/socket.c b/net/sctp/socket.c
index fe8d1ea7d9c35..fb7ed11382af1 100644
--- a/net/sctp/socket.c
+++ b/net/sctp/socket.c
@@ -3921,24 +3921,20 @@ static int sctp_setsockopt_recvnxtinfo(struct sock *sk, int *val,
 }
 
 static int sctp_setsockopt_pr_supported(struct sock *sk,
-					char __user *optval,
+					struct sctp_assoc_value *params,
 					unsigned int optlen)
 {
-	struct sctp_assoc_value params;
 	struct sctp_association *asoc;
 
-	if (optlen != sizeof(params))
+	if (optlen != sizeof(*params))
 		return -EINVAL;
 
-	if (copy_from_user(&params, optval, optlen))
-		return -EFAULT;
-
-	asoc = sctp_id2assoc(sk, params.assoc_id);
-	if (!asoc && params.assoc_id != SCTP_FUTURE_ASSOC &&
+	asoc = sctp_id2assoc(sk, params->assoc_id);
+	if (!asoc && params->assoc_id != SCTP_FUTURE_ASSOC &&
 	    sctp_style(sk, UDP))
 		return -EINVAL;
 
-	sctp_sk(sk)->ep->prsctp_enable = !!params.assoc_value;
+	sctp_sk(sk)->ep->prsctp_enable = !!params->assoc_value;
 
 	return 0;
 }
@@ -4687,7 +4683,7 @@ static int sctp_setsockopt(struct sock *sk, int level, int optname,
 		retval = sctp_setsockopt_recvnxtinfo(sk, kopt, optlen);
 		break;
 	case SCTP_PR_SUPPORTED:
-		retval = sctp_setsockopt_pr_supported(sk, optval, optlen);
+		retval = sctp_setsockopt_pr_supported(sk, kopt, optlen);
 		break;
 	case SCTP_DEFAULT_PRINFO:
 		retval = sctp_setsockopt_default_prinfo(sk, optval, optlen);
-- 
2.26.2

