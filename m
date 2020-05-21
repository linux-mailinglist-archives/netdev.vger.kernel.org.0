Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2CF691DD512
	for <lists+netdev@lfdr.de>; Thu, 21 May 2020 19:50:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730441AbgEURtO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 May 2020 13:49:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58044 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728455AbgEURtL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 May 2020 13:49:11 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D8F0C061A0E;
        Thu, 21 May 2020 10:49:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=aUKDMgTQ446FHVdBoFwTCqwAiuUqTZTHVAnQ1zjxnoY=; b=jzpuWfZco1JtDo5PmrkM0eBhiQ
        zjwdLXmYQYvUCwuWjnrDkf+x+9RgwM2CWpYQKA2Rlu72dh4Gb0PXC/LMOJWPBeBuYRrCXDYfiD9/V
        tXNnxoxvXa1RITR840FIYjlNn8sjb2A0CvLEewTi0EUzCnyKknOFeI8POGBA5SRJzVmD+sMZt2OLn
        77kWm+/UGGUw6Ah29CA2tiqJJkO+0jhvYUUuScqM2IAgQM+2mBGQsmziTSn4kmLCXqCygmNLTTNzt
        XYID8gPL2Xx1BJkL5a3uv6ZweZ/kUljuV0TU62SCGpgXt3T6sh7797AhTWrxb8ABg/7UOWPKMPHvN
        g4GeLyxQ==;
Received: from [2001:4bb8:18c:5da7:c70:4a89:bc61:2] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jbpJd-0003Oh-Fd; Thu, 21 May 2020 17:49:09 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     Vlad Yasevich <vyasevich@gmail.com>,
        Neil Horman <nhorman@tuxdriver.com>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        David Laight <David.Laight@ACULAB.COM>,
        linux-sctp@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH 38/49] sctp: pass a kernel pointer to sctp_setsockopt_reset_streams
Date:   Thu, 21 May 2020 19:47:13 +0200
Message-Id: <20200521174724.2635475-39-hch@lst.de>
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
 net/sctp/socket.c | 20 +++++---------------
 1 file changed, 5 insertions(+), 15 deletions(-)

diff --git a/net/sctp/socket.c b/net/sctp/socket.c
index c5a4e9375bb55..70451a9177407 100644
--- a/net/sctp/socket.c
+++ b/net/sctp/socket.c
@@ -4057,12 +4057,10 @@ static int sctp_setsockopt_enable_strreset(struct sock *sk,
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
@@ -4070,23 +4068,15 @@ static int sctp_setsockopt_reset_streams(struct sock *sk,
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
@@ -4678,7 +4668,7 @@ static int sctp_setsockopt(struct sock *sk, int level, int optname,
 		retval = sctp_setsockopt_enable_strreset(sk, kopt, optlen);
 		break;
 	case SCTP_RESET_STREAMS:
-		retval = sctp_setsockopt_reset_streams(sk, optval, optlen);
+		retval = sctp_setsockopt_reset_streams(sk, kopt, optlen);
 		break;
 	case SCTP_RESET_ASSOC:
 		retval = sctp_setsockopt_reset_assoc(sk, optval, optlen);
-- 
2.26.2

