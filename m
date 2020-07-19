Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D6C11225030
	for <lists+netdev@lfdr.de>; Sun, 19 Jul 2020 09:23:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726834AbgGSHXe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 Jul 2020 03:23:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52598 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726719AbgGSHXZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 19 Jul 2020 03:23:25 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3FF10C0619D2;
        Sun, 19 Jul 2020 00:23:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=zhrPdKjc7Zu+eeAwCrJDJjgyMDV8UtPZUeqP8I1Rrig=; b=WNms+71wA9tRuU9GC4r0I1P4tB
        iIPajcR81CY/JgQQinpgLwzdJINWvJChIiVui3d9aakLSE7GuHJ1L7aPalyQpk+qG93KwiJHZxB3q
        pSav+b7skTrEXGyL0tiuqJgGAp7bifXPo9qQlb2R56lnybcJEJIrK01UtiwrfOcGFXUTpFTBGAlj5
        lXx4a4u75aQciCfF0eCBbYP+9EnSyhf9fQBEjXFo0lm1wp/JsdVjExz4dhXyFcg5Q/FHkXsCi/onY
        A1yHLYWsjoxU46lXOQrLwF7kB5nNJLr73doAakh3oNLLztJv6jZutEEdyOqChlN6ekwttQhmQKewC
        JsUHnteA==;
Received: from [2001:4bb8:105:4a81:4ef5:9f24:cda4:103f] (helo=localhost)
        by casper.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jx3fN-0000Wo-H7; Sun, 19 Jul 2020 07:23:21 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     Vlad Yasevich <vyasevich@gmail.com>,
        Neil Horman <nhorman@tuxdriver.com>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        David Laight <David.Laight@ACULAB.COM>,
        linux-sctp@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH 39/51] sctp: pass a kernel pointer to sctp_setsockopt_reset_streams
Date:   Sun, 19 Jul 2020 09:22:16 +0200
Message-Id: <20200719072228.112645-40-hch@lst.de>
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
 net/sctp/socket.c | 20 +++++---------------
 1 file changed, 5 insertions(+), 15 deletions(-)

diff --git a/net/sctp/socket.c b/net/sctp/socket.c
index 9899d208f40f8d..1365351fd2c86a 100644
--- a/net/sctp/socket.c
+++ b/net/sctp/socket.c
@@ -4061,12 +4061,10 @@ static int sctp_setsockopt_enable_strreset(struct sock *sk,
 }
 
 static int sctp_setsockopt_reset_streams(struct sock *sk,
-					 char __user *optval,
+					 struct sctp_reset_streams *params,
 					 unsigned int optlen)
 {
-	struct sctp_reset_streams *params;
 	struct sctp_association *asoc;
-	int retval = -EINVAL;
 
 	if (optlen < sizeof(*params))
 		return -EINVAL;
@@ -4074,23 +4072,15 @@ static int sctp_setsockopt_reset_streams(struct sock *sk,
 	optlen = min_t(unsigned int, optlen, USHRT_MAX +
 					     sizeof(__u16) * sizeof(*params));
 
-	params = memdup_user(optval, optlen);
-	if (IS_ERR(params))
-		return PTR_ERR(params);
-
 	if (params->srs_number_streams * sizeof(__u16) >
 	    optlen - sizeof(*params))
-		goto out;
+		return -EINVAL;
 
 	asoc = sctp_id2assoc(sk, params->srs_assoc_id);
 	if (!asoc)
-		goto out;
-
-	retval = sctp_send_reset_streams(asoc, params);
+		return -EINVAL;
 
-out:
-	kfree(params);
-	return retval;
+	return sctp_send_reset_streams(asoc, params);
 }
 
 static int sctp_setsockopt_reset_assoc(struct sock *sk,
@@ -4682,7 +4672,7 @@ static int sctp_setsockopt(struct sock *sk, int level, int optname,
 		retval = sctp_setsockopt_enable_strreset(sk, kopt, optlen);
 		break;
 	case SCTP_RESET_STREAMS:
-		retval = sctp_setsockopt_reset_streams(sk, optval, optlen);
+		retval = sctp_setsockopt_reset_streams(sk, kopt, optlen);
 		break;
 	case SCTP_RESET_ASSOC:
 		retval = sctp_setsockopt_reset_assoc(sk, optval, optlen);
-- 
2.27.0

