Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C931B22503B
	for <lists+netdev@lfdr.de>; Sun, 19 Jul 2020 09:23:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726933AbgGSHXp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 Jul 2020 03:23:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52648 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726855AbgGSHXh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 19 Jul 2020 03:23:37 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9BC04C0619D4;
        Sun, 19 Jul 2020 00:23:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=k0bkYRzoge5MBejOtmIuEPYy+LVXVRFxawXcdxwVT1c=; b=HO///KhlYi7fP5PDuXeQkZKOJd
        VjMb+nyRw/yailVdF5apEeWtybbohaRudzNfzdNbvJDBxcT2L7LYcRfIB0B6IYxhLDLMEw0jl1iOj
        da4qVSkUVmxkQXpHdF89YN6OemITwYrMovgQVGaFwdLTHJ8/X0y9L8gw0hQKEzsQFjGekO+zEMwf6
        YP/4y4vfCkFLiHqWNp1SWWuv8ae9S12Ag4v/ZZq6dTatlUE++ktq7vLKdk97aZZuI9DbcJBzuqycR
        bapvFmfpgjXxHOgGGA+MuVnYLjLufRXNcKeaXEBSL6WOsrWDDXem0UX5Vy4aoer7nJE1VBvWRhfCA
        MtlvWC5g==;
Received: from [2001:4bb8:105:4a81:4ef5:9f24:cda4:103f] (helo=localhost)
        by casper.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jx3fZ-0000Yo-Tf; Sun, 19 Jul 2020 07:23:34 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     Vlad Yasevich <vyasevich@gmail.com>,
        Neil Horman <nhorman@tuxdriver.com>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        David Laight <David.Laight@ACULAB.COM>,
        linux-sctp@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH 49/51] sctp: pass a kernel pointer to sctp_setsockopt_ecn_supported
Date:   Sun, 19 Jul 2020 09:22:26 +0200
Message-Id: <20200719072228.112645-50-hch@lst.de>
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
 net/sctp/socket.c | 18 ++++++------------
 1 file changed, 6 insertions(+), 12 deletions(-)

diff --git a/net/sctp/socket.c b/net/sctp/socket.c
index ca369447237a77..9f7f9aa50d4bd7 100644
--- a/net/sctp/socket.c
+++ b/net/sctp/socket.c
@@ -4360,27 +4360,21 @@ static int sctp_setsockopt_auth_supported(struct sock *sk,
 }
 
 static int sctp_setsockopt_ecn_supported(struct sock *sk,
-					 char __user *optval,
+					 struct sctp_assoc_value *params,
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
 
-	asoc = sctp_id2assoc(sk, params.assoc_id);
-	if (!asoc && params.assoc_id != SCTP_FUTURE_ASSOC &&
+	asoc = sctp_id2assoc(sk, params->assoc_id);
+	if (!asoc && params->assoc_id != SCTP_FUTURE_ASSOC &&
 	    sctp_style(sk, UDP))
 		goto out;
 
-	sctp_sk(sk)->ep->ecn_enable = !!params.assoc_value;
+	sctp_sk(sk)->ep->ecn_enable = !!params->assoc_value;
 	retval = 0;
 
 out:
@@ -4635,7 +4629,7 @@ static int sctp_setsockopt(struct sock *sk, int level, int optname,
 		retval = sctp_setsockopt_auth_supported(sk, kopt, optlen);
 		break;
 	case SCTP_ECN_SUPPORTED:
-		retval = sctp_setsockopt_ecn_supported(sk, optval, optlen);
+		retval = sctp_setsockopt_ecn_supported(sk, kopt, optlen);
 		break;
 	case SCTP_EXPOSE_POTENTIALLY_FAILED_STATE:
 		retval = sctp_setsockopt_pf_expose(sk, optval, optlen);
-- 
2.27.0

