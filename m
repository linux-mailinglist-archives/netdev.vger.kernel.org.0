Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 18EEC225040
	for <lists+netdev@lfdr.de>; Sun, 19 Jul 2020 09:24:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726818AbgGSHXd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 Jul 2020 03:23:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52596 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726714AbgGSHXZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 19 Jul 2020 03:23:25 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 03655C0619D4;
        Sun, 19 Jul 2020 00:23:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=u6LoSUZgLNINER2xG1h2Yz6yQwOqkFf/Iw3heaLgVhQ=; b=m2VLbN9zwebJL5E/WSr91jj3uu
        Xftt7/UDbd57YcTo/5/FsumCJi+kh6K2u6A56UFO8QYiPdZqLGYEEYT08+vhRxm9Be5TuxhsBm34R
        pPM+2xVPCnWX3oNU+TQd6Icio5aUwij/OOmyyVH35FsHPZ4TY7Tr3et3OCxjCwYoK9NO6cMipWPX5
        Nrl8yVyikWeM5KutZQkX9eU/uT76Y8guqz1hz26AL6Nq/2hMnW5RkI5410SpwLrmbX6ZcMVgOf/d8
        H6ra1FplG/uPGNakDOGB3Z9EQYjSDrAUdzNwRjqnbxSF+YbG5EfAhkQ9s9a+m91kMOBub9+KNe8LG
        N6OJ2ZXA==;
Received: from [2001:4bb8:105:4a81:4ef5:9f24:cda4:103f] (helo=localhost)
        by casper.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jx3fM-0000Wd-0N; Sun, 19 Jul 2020 07:23:20 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     Vlad Yasevich <vyasevich@gmail.com>,
        Neil Horman <nhorman@tuxdriver.com>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        David Laight <David.Laight@ACULAB.COM>,
        linux-sctp@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH 38/51] sctp: pass a kernel pointer to sctp_setsockopt_enable_strreset
Date:   Sun, 19 Jul 2020 09:22:15 +0200
Message-Id: <20200719072228.112645-39-hch@lst.de>
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
 net/sctp/socket.c | 34 ++++++++++++++--------------------
 1 file changed, 14 insertions(+), 20 deletions(-)

diff --git a/net/sctp/socket.c b/net/sctp/socket.c
index 270c5d53fbf7c3..9899d208f40f8d 100644
--- a/net/sctp/socket.c
+++ b/net/sctp/socket.c
@@ -4019,48 +4019,42 @@ static int sctp_setsockopt_reconfig_supported(struct sock *sk,
 }
 
 static int sctp_setsockopt_enable_strreset(struct sock *sk,
-					   char __user *optval,
+					   struct sctp_assoc_value *params,
 					   unsigned int optlen)
 {
 	struct sctp_endpoint *ep = sctp_sk(sk)->ep;
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
 
-	if (params.assoc_value & (~SCTP_ENABLE_STRRESET_MASK))
+	if (params->assoc_value & (~SCTP_ENABLE_STRRESET_MASK))
 		goto out;
 
-	asoc = sctp_id2assoc(sk, params.assoc_id);
-	if (!asoc && params.assoc_id > SCTP_ALL_ASSOC &&
+	asoc = sctp_id2assoc(sk, params->assoc_id);
+	if (!asoc && params->assoc_id > SCTP_ALL_ASSOC &&
 	    sctp_style(sk, UDP))
 		goto out;
 
 	retval = 0;
 
 	if (asoc) {
-		asoc->strreset_enable = params.assoc_value;
+		asoc->strreset_enable = params->assoc_value;
 		goto out;
 	}
 
 	if (sctp_style(sk, TCP))
-		params.assoc_id = SCTP_FUTURE_ASSOC;
+		params->assoc_id = SCTP_FUTURE_ASSOC;
 
-	if (params.assoc_id == SCTP_FUTURE_ASSOC ||
-	    params.assoc_id == SCTP_ALL_ASSOC)
-		ep->strreset_enable = params.assoc_value;
+	if (params->assoc_id == SCTP_FUTURE_ASSOC ||
+	    params->assoc_id == SCTP_ALL_ASSOC)
+		ep->strreset_enable = params->assoc_value;
 
-	if (params.assoc_id == SCTP_CURRENT_ASSOC ||
-	    params.assoc_id == SCTP_ALL_ASSOC)
+	if (params->assoc_id == SCTP_CURRENT_ASSOC ||
+	    params->assoc_id == SCTP_ALL_ASSOC)
 		list_for_each_entry(asoc, &ep->asocs, asocs)
-			asoc->strreset_enable = params.assoc_value;
+			asoc->strreset_enable = params->assoc_value;
 
 out:
 	return retval;
@@ -4685,7 +4679,7 @@ static int sctp_setsockopt(struct sock *sk, int level, int optname,
 		retval = sctp_setsockopt_reconfig_supported(sk, kopt, optlen);
 		break;
 	case SCTP_ENABLE_STREAM_RESET:
-		retval = sctp_setsockopt_enable_strreset(sk, optval, optlen);
+		retval = sctp_setsockopt_enable_strreset(sk, kopt, optlen);
 		break;
 	case SCTP_RESET_STREAMS:
 		retval = sctp_setsockopt_reset_streams(sk, optval, optlen);
-- 
2.27.0

