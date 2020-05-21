Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5960D1DD50E
	for <lists+netdev@lfdr.de>; Thu, 21 May 2020 19:50:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730426AbgEURtJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 May 2020 13:49:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58024 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730413AbgEURtF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 May 2020 13:49:05 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B8327C061A0E;
        Thu, 21 May 2020 10:49:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=A4RhtAlMgtV+Kx8yN7Qg619HsYQu5dhP4W31YOOBSSs=; b=YjMqvKB1ihEEls1yt7enB1lR+c
        06iz1KNEVKQTTLHwGJiQ966iSj7Roe/SNce72zQZ2QDg2rb2zUYhbksux9r6ZNuXTU+rQ8WyRIP//
        UU641ZqsvBxFISVoh6id/hlfs4NzmffkYtafQbiivOTNF/2KEKYCHeMifrdanAOWVS9Wk1b7MIKKd
        3GA3wBMTRrfCpt3Ml0+SNIjvuZFujRsej5sKqzKTqYAGIoXjYvYWWXLLdVmEaOGH6WaB6mJ02OFLv
        MwL6NiKmILUvayrP3sbbWgS1ZkN1cf+HtCvnZ65RNx0KRKjpwjVhun+pcbSpKIjLw9IMMuPjUdbni
        jAzF/CyA==;
Received: from [2001:4bb8:18c:5da7:c70:4a89:bc61:2] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jbpJY-0003Ns-8t; Thu, 21 May 2020 17:49:04 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     Vlad Yasevich <vyasevich@gmail.com>,
        Neil Horman <nhorman@tuxdriver.com>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        David Laight <David.Laight@ACULAB.COM>,
        linux-sctp@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH 36/49] sctp: pass a kernel pointer to sctp_setsockopt_reconfig_supported
Date:   Thu, 21 May 2020 19:47:11 +0200
Message-Id: <20200521174724.2635475-37-hch@lst.de>
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
 net/sctp/socket.c | 18 ++++++------------
 1 file changed, 6 insertions(+), 12 deletions(-)

diff --git a/net/sctp/socket.c b/net/sctp/socket.c
index 6136f863095ef..9173b1b80ee17 100644
--- a/net/sctp/socket.c
+++ b/net/sctp/socket.c
@@ -3992,27 +3992,21 @@ static int sctp_setsockopt_default_prinfo(struct sock *sk,
 }
 
 static int sctp_setsockopt_reconfig_supported(struct sock *sk,
-					      char __user *optval,
+					      struct sctp_assoc_value *params,
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
 
-	sctp_sk(sk)->ep->reconf_enable = !!params.assoc_value;
+	sctp_sk(sk)->ep->reconf_enable = !!params->assoc_value;
 
 	retval = 0;
 
@@ -4684,7 +4678,7 @@ static int sctp_setsockopt(struct sock *sk, int level, int optname,
 		retval = sctp_setsockopt_default_prinfo(sk, kopt, optlen);
 		break;
 	case SCTP_RECONFIG_SUPPORTED:
-		retval = sctp_setsockopt_reconfig_supported(sk, optval, optlen);
+		retval = sctp_setsockopt_reconfig_supported(sk, kopt, optlen);
 		break;
 	case SCTP_ENABLE_STREAM_RESET:
 		retval = sctp_setsockopt_enable_strreset(sk, optval, optlen);
-- 
2.26.2

