Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5C39222503A
	for <lists+netdev@lfdr.de>; Sun, 19 Jul 2020 09:23:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726916AbgGSHXn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 Jul 2020 03:23:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52644 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726848AbgGSHXg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 19 Jul 2020 03:23:36 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C3CFC0619D2;
        Sun, 19 Jul 2020 00:23:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=WIHtWYpXJ+laPQx/RzblJzhs+noYqvzplP7L1+sZ74I=; b=RLSMk6kFyAfW+HGLVu9PcXWleE
        lEB8xoMGFKIeTNO/KdKtIhHZ/egVnVpyYEckhPynCd64BZOTgXVdJf2Ziy2L3oB+Wn/5QGHYzSjBC
        OvCoJeursaBe9WzoyFAHpobsuynqxekUX+R3gIqp4Jv6q1pSWIJcd7AkqCX8e7r/ScdkGqvJ0n8LJ
        fvyj830KKxeLjY330MG0DU3kaWAMzDD3erEO3hIoD+RUx5BDcS2XDTXAoXf5ll32Oi6/PgQ/ZY2wX
        l4+4X7s1NcqVa42s4EDymiEGkYViJO7joba2qyltX8qAyMt3/Zl+1RWyUpeOS66GdBdyK+fiyISn8
        HZuxgL/A==;
Received: from [2001:4bb8:105:4a81:4ef5:9f24:cda4:103f] (helo=localhost)
        by casper.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jx3fY-0000Yc-MY; Sun, 19 Jul 2020 07:23:33 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     Vlad Yasevich <vyasevich@gmail.com>,
        Neil Horman <nhorman@tuxdriver.com>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        David Laight <David.Laight@ACULAB.COM>,
        linux-sctp@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH 48/51] sctp: pass a kernel pointer to sctp_setsockopt_auth_supported
Date:   Sun, 19 Jul 2020 09:22:25 +0200
Message-Id: <20200719072228.112645-49-hch@lst.de>
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
 net/sctp/socket.c | 20 +++++++-------------
 1 file changed, 7 insertions(+), 13 deletions(-)

diff --git a/net/sctp/socket.c b/net/sctp/socket.c
index b52acbf231ab9e..ca369447237a77 100644
--- a/net/sctp/socket.c
+++ b/net/sctp/socket.c
@@ -4326,29 +4326,23 @@ static int sctp_setsockopt_asconf_supported(struct sock *sk,
 }
 
 static int sctp_setsockopt_auth_supported(struct sock *sk,
-					  char __user *optval,
+					  struct sctp_assoc_value *params,
 					  unsigned int optlen)
 {
-	struct sctp_assoc_value params;
 	struct sctp_association *asoc;
 	struct sctp_endpoint *ep;
 	int retval = -EINVAL;
 
-	if (optlen != sizeof(params))
-		goto out;
-
-	if (copy_from_user(&params, optval, optlen)) {
-		retval = -EFAULT;
+	if (optlen != sizeof(*params))
 		goto out;
-	}
 
-	asoc = sctp_id2assoc(sk, params.assoc_id);
-	if (!asoc && params.assoc_id != SCTP_FUTURE_ASSOC &&
+	asoc = sctp_id2assoc(sk, params->assoc_id);
+	if (!asoc && params->assoc_id != SCTP_FUTURE_ASSOC &&
 	    sctp_style(sk, UDP))
 		goto out;
 
 	ep = sctp_sk(sk)->ep;
-	if (params.assoc_value) {
+	if (params->assoc_value) {
 		retval = sctp_auth_init(ep, GFP_KERNEL);
 		if (retval)
 			goto out;
@@ -4358,7 +4352,7 @@ static int sctp_setsockopt_auth_supported(struct sock *sk,
 		}
 	}
 
-	ep->auth_enable = !!params.assoc_value;
+	ep->auth_enable = !!params->assoc_value;
 	retval = 0;
 
 out:
@@ -4638,7 +4632,7 @@ static int sctp_setsockopt(struct sock *sk, int level, int optname,
 		retval = sctp_setsockopt_asconf_supported(sk, kopt, optlen);
 		break;
 	case SCTP_AUTH_SUPPORTED:
-		retval = sctp_setsockopt_auth_supported(sk, optval, optlen);
+		retval = sctp_setsockopt_auth_supported(sk, kopt, optlen);
 		break;
 	case SCTP_ECN_SUPPORTED:
 		retval = sctp_setsockopt_ecn_supported(sk, optval, optlen);
-- 
2.27.0

