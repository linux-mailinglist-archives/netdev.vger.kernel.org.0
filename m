Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6407D225024
	for <lists+netdev@lfdr.de>; Sun, 19 Jul 2020 09:23:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726711AbgGSHXV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 Jul 2020 03:23:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52578 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726658AbgGSHXU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 19 Jul 2020 03:23:20 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E0FECC0619D2;
        Sun, 19 Jul 2020 00:23:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=0PT+CMb+FCws5R92XqK5QHgx7tSC+qSHHRq5+a9lAyQ=; b=nTKDKfqbl6DaXn8Sj9+BNILDi0
        7zqH9HAl01D9A3KAAG6+fHCeyTVJOjl3/VGeZWfBgjkb4BQWsygDyRX+wRDFMdlOpwqa1RdUg/z8C
        /WKUWR11nz1Jikb42+jnGPKghOAceK60JVtmD2Byn/YPsE0wViR1SuEKdP9mgnkFKYES7aMol9duw
        AEP97S7M+Rw7NK5QlNFEL6GZ2tL3RGDiCwVviVKZeNSqLPC0zfeyMmT6igli9xrHYyp+VQ0M1a14L
        qLN4OKbrJM2zR4q61uwIM7BR75VVjdh+R2RTTwf32v6grHWkAl6AViOWInr7BcMg6p/wH8d5C2Vfk
        8AW/LHUw==;
Received: from [2001:4bb8:105:4a81:4ef5:9f24:cda4:103f] (helo=localhost)
        by casper.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jx3fI-0000WC-39; Sun, 19 Jul 2020 07:23:16 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     Vlad Yasevich <vyasevich@gmail.com>,
        Neil Horman <nhorman@tuxdriver.com>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        David Laight <David.Laight@ACULAB.COM>,
        linux-sctp@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH 35/51] sctp: pass a kernel pointer to sctp_setsockopt_pr_supported
Date:   Sun, 19 Jul 2020 09:22:12 +0200
Message-Id: <20200719072228.112645-36-hch@lst.de>
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
 net/sctp/socket.c | 16 ++++++----------
 1 file changed, 6 insertions(+), 10 deletions(-)

diff --git a/net/sctp/socket.c b/net/sctp/socket.c
index 7beb26e5749d7e..245186327896b3 100644
--- a/net/sctp/socket.c
+++ b/net/sctp/socket.c
@@ -3925,24 +3925,20 @@ static int sctp_setsockopt_recvnxtinfo(struct sock *sk, int *val,
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
@@ -4691,7 +4687,7 @@ static int sctp_setsockopt(struct sock *sk, int level, int optname,
 		retval = sctp_setsockopt_recvnxtinfo(sk, kopt, optlen);
 		break;
 	case SCTP_PR_SUPPORTED:
-		retval = sctp_setsockopt_pr_supported(sk, optval, optlen);
+		retval = sctp_setsockopt_pr_supported(sk, kopt, optlen);
 		break;
 	case SCTP_DEFAULT_PRINFO:
 		retval = sctp_setsockopt_default_prinfo(sk, optval, optlen);
-- 
2.27.0

