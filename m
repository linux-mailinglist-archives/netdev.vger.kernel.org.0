Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 751FF225038
	for <lists+netdev@lfdr.de>; Sun, 19 Jul 2020 09:23:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726899AbgGSHXm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 Jul 2020 03:23:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52654 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726882AbgGSHXj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 19 Jul 2020 03:23:39 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E7E1C0619D5;
        Sun, 19 Jul 2020 00:23:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=BEtcvHZJ8IW6l2BUs1f2QFgyVR03AW0Go7POuH98rsU=; b=Vn+zgqlNrnScCXbLTy8Jl0mgrX
        nmupqrVnbBcRCUrRpjOrr06Xjf8fXJIJCGgU3MDNEfE8vnXVIblvJJSlMR+m6o9E6JkdQRNG7UozK
        xFP8CTPM6dlLqG2OrXaCiqtJ+2U+XsovYd7BzR5IdVC+rm4AHOiHZTxmGK6/Uu12jtYAd+YKe6wZo
        I+AmNFXiUp9hWQSdOqYhNH5hW2ZLQtKyROMr2riGpvSqaF3TPC1ftVJC7LcnmvI4wtwns5O79Q6N2
        jtMweuUCOG3iax28wLph74OQC8XfXxVdFIxCWWGvs8q+FWpbTFw2SEIRbXVYCRsZxbEljAdZCECI8
        PZJ4vo7A==;
Received: from [2001:4bb8:105:4a81:4ef5:9f24:cda4:103f] (helo=localhost)
        by casper.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jx3fb-0000Z0-2e; Sun, 19 Jul 2020 07:23:35 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     Vlad Yasevich <vyasevich@gmail.com>,
        Neil Horman <nhorman@tuxdriver.com>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        David Laight <David.Laight@ACULAB.COM>,
        linux-sctp@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH 50/51] sctp: pass a kernel pointer to sctp_setsockopt_pf_expose
Date:   Sun, 19 Jul 2020 09:22:27 +0200
Message-Id: <20200719072228.112645-51-hch@lst.de>
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
 net/sctp/socket.c | 22 ++++++++--------------
 1 file changed, 8 insertions(+), 14 deletions(-)

diff --git a/net/sctp/socket.c b/net/sctp/socket.c
index 9f7f9aa50d4bd7..f2d4f8a0c426bb 100644
--- a/net/sctp/socket.c
+++ b/net/sctp/socket.c
@@ -4382,33 +4382,27 @@ static int sctp_setsockopt_ecn_supported(struct sock *sk,
 }
 
 static int sctp_setsockopt_pf_expose(struct sock *sk,
-				     char __user *optval,
+				     struct sctp_assoc_value *params,
 				     unsigned int optlen)
 {
-	struct sctp_assoc_value params;
 	struct sctp_association *asoc;
 	int retval = -EINVAL;
 
-	if (optlen != sizeof(params))
-		goto out;
-
-	if (copy_from_user(&params, optval, optlen)) {
-		retval = -EFAULT;
+	if (optlen != sizeof(*params))
 		goto out;
-	}
 
-	if (params.assoc_value > SCTP_PF_EXPOSE_MAX)
+	if (params->assoc_value > SCTP_PF_EXPOSE_MAX)
 		goto out;
 
-	asoc = sctp_id2assoc(sk, params.assoc_id);
-	if (!asoc && params.assoc_id != SCTP_FUTURE_ASSOC &&
+	asoc = sctp_id2assoc(sk, params->assoc_id);
+	if (!asoc && params->assoc_id != SCTP_FUTURE_ASSOC &&
 	    sctp_style(sk, UDP))
 		goto out;
 
 	if (asoc)
-		asoc->pf_expose = params.assoc_value;
+		asoc->pf_expose = params->assoc_value;
 	else
-		sctp_sk(sk)->pf_expose = params.assoc_value;
+		sctp_sk(sk)->pf_expose = params->assoc_value;
 	retval = 0;
 
 out:
@@ -4632,7 +4626,7 @@ static int sctp_setsockopt(struct sock *sk, int level, int optname,
 		retval = sctp_setsockopt_ecn_supported(sk, kopt, optlen);
 		break;
 	case SCTP_EXPOSE_POTENTIALLY_FAILED_STATE:
-		retval = sctp_setsockopt_pf_expose(sk, optval, optlen);
+		retval = sctp_setsockopt_pf_expose(sk, kopt, optlen);
 		break;
 	default:
 		retval = -ENOPROTOOPT;
-- 
2.27.0

