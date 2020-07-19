Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 915D522502B
	for <lists+netdev@lfdr.de>; Sun, 19 Jul 2020 09:23:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726784AbgGSHXa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 Jul 2020 03:23:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52606 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726658AbgGSHX1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 19 Jul 2020 03:23:27 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8FC16C0619D2;
        Sun, 19 Jul 2020 00:23:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=F+jrvh2cscLcor+NdLwZfZmVP8/ENrMW5fv32NP/k9k=; b=FCngSRQeGTKDP6v1KI36beVkfg
        Xx1PgwI3zyYes24nE4jdOSOevW68qcJ5WJHMkhCfJL10d3s0JO/ZvlCn8JFyHbkjI3P1MhLq18qob
        a7wIdobPONfL92lK1SK9iHeJM3aZOR5wFczz9N8lYSeVIqMCk1sG3xXIi1nCeU/8kKqM1rYd8bLRQ
        V4w/JBhzjF9rf7TAKmkxdGnrKN7feIjbsa3PFcCSffH5i01BX8oAA1kcMsPE0t9wc211uCrDEd8xq
        /nS2LmstcdeEBGuRp0PXuhAccZ4cLdXuhFmLbCKjRK91/xYgN/5dwOcYl5C5dhQO5WLHJFvMgXj72
        Ruov37kA==;
Received: from [2001:4bb8:105:4a81:4ef5:9f24:cda4:103f] (helo=localhost)
        by casper.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jx3fP-0000X6-Pj; Sun, 19 Jul 2020 07:23:24 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     Vlad Yasevich <vyasevich@gmail.com>,
        Neil Horman <nhorman@tuxdriver.com>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        David Laight <David.Laight@ACULAB.COM>,
        linux-sctp@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH 41/51] sctp: pass a kernel pointer to sctp_setsockopt_add_streams
Date:   Sun, 19 Jul 2020 09:22:18 +0200
Message-Id: <20200719072228.112645-42-hch@lst.de>
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
 net/sctp/socket.c | 24 +++++++-----------------
 1 file changed, 7 insertions(+), 17 deletions(-)

diff --git a/net/sctp/socket.c b/net/sctp/socket.c
index f190f59f29595a..4dedb94bca7714 100644
--- a/net/sctp/socket.c
+++ b/net/sctp/socket.c
@@ -4099,29 +4099,19 @@ static int sctp_setsockopt_reset_assoc(struct sock *sk, sctp_assoc_t *associd,
 }
 
 static int sctp_setsockopt_add_streams(struct sock *sk,
-				       char __user *optval,
+				       struct sctp_add_streams *params,
 				       unsigned int optlen)
 {
 	struct sctp_association *asoc;
-	struct sctp_add_streams params;
-	int retval = -EINVAL;
-
-	if (optlen != sizeof(params))
-		goto out;
 
-	if (copy_from_user(&params, optval, optlen)) {
-		retval = -EFAULT;
-		goto out;
-	}
+	if (optlen != sizeof(*params))
+		return -EINVAL;
 
-	asoc = sctp_id2assoc(sk, params.sas_assoc_id);
+	asoc = sctp_id2assoc(sk, params->sas_assoc_id);
 	if (!asoc)
-		goto out;
-
-	retval = sctp_send_add_streams(asoc, &params);
+		return -EINVAL;
 
-out:
-	return retval;
+	return sctp_send_add_streams(asoc, params);
 }
 
 static int sctp_setsockopt_scheduler(struct sock *sk,
@@ -4667,7 +4657,7 @@ static int sctp_setsockopt(struct sock *sk, int level, int optname,
 		retval = sctp_setsockopt_reset_assoc(sk, kopt, optlen);
 		break;
 	case SCTP_ADD_STREAMS:
-		retval = sctp_setsockopt_add_streams(sk, optval, optlen);
+		retval = sctp_setsockopt_add_streams(sk, kopt, optlen);
 		break;
 	case SCTP_STREAM_SCHEDULER:
 		retval = sctp_setsockopt_scheduler(sk, optval, optlen);
-- 
2.27.0

