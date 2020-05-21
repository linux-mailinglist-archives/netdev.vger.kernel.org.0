Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C6FD91DD506
	for <lists+netdev@lfdr.de>; Thu, 21 May 2020 19:50:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730397AbgEURs6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 May 2020 13:48:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57988 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730382AbgEURsz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 May 2020 13:48:55 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 50716C061A0E;
        Thu, 21 May 2020 10:48:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=LGgjnUDD7/tNYRvFOkgjYDhRsSm/aq2XucU7vT1iu30=; b=eZsFjT4Z3lDCaYWrwDrzYiaHN2
        IqAGWVOAFl2wcm1brlABhC+UHyt55NhoRHkgfNpLezdsXJLM4KS9DunXsZtnN4d5vRvpsJ7JP5GTw
        OXFIKRtgv0LyEzA/uK3ZV90WBMDWg1hDZvKUCPeBb8vPji3lS5Ya0qpCz3D83Rh1+hH168KMJXbPZ
        q6a9lthqF5ioX8orzs3smAcYHUv3j3wI8IKNkw0wbnjPm9uoy+Cj3esfn3xekdWPg+V1ihkFQndVO
        5ZRF/DD49YCMJmdRvnTOOMGxyDLnAQCEAtsgNAmDY1YA6vRXFQiJSqVwoP6Hd0Po+9bMwvVJkX8tr
        UNOYrLtg==;
Received: from [2001:4bb8:18c:5da7:c70:4a89:bc61:2] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jbpJN-0003MA-Qr; Thu, 21 May 2020 17:48:54 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     Vlad Yasevich <vyasevich@gmail.com>,
        Neil Horman <nhorman@tuxdriver.com>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        David Laight <David.Laight@ACULAB.COM>,
        linux-sctp@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH 32/49] sctp: pass a kernel pointer to sctp_setsockopt_recvrcvinfo
Date:   Thu, 21 May 2020 19:47:07 +0200
Message-Id: <20200521174724.2635475-33-hch@lst.de>
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
 net/sctp/socket.c | 11 +++--------
 1 file changed, 3 insertions(+), 8 deletions(-)

diff --git a/net/sctp/socket.c b/net/sctp/socket.c
index a2aa1e309d595..e4b537e6d61da 100644
--- a/net/sctp/socket.c
+++ b/net/sctp/socket.c
@@ -3898,18 +3898,13 @@ static int sctp_setsockopt_paddr_thresholds(struct sock *sk,
 	return 0;
 }
 
-static int sctp_setsockopt_recvrcvinfo(struct sock *sk,
-				       char __user *optval,
+static int sctp_setsockopt_recvrcvinfo(struct sock *sk, int *val,
 				       unsigned int optlen)
 {
-	int val;
-
 	if (optlen < sizeof(int))
 		return -EINVAL;
-	if (get_user(val, (int __user *) optval))
-		return -EFAULT;
 
-	sctp_sk(sk)->recvrcvinfo = (val == 0) ? 0 : 1;
+	sctp_sk(sk)->recvrcvinfo = (*val == 0) ? 0 : 1;
 
 	return 0;
 }
@@ -4691,7 +4686,7 @@ static int sctp_setsockopt(struct sock *sk, int level, int optname,
 							  true);
 		break;
 	case SCTP_RECVRCVINFO:
-		retval = sctp_setsockopt_recvrcvinfo(sk, optval, optlen);
+		retval = sctp_setsockopt_recvrcvinfo(sk, kopt, optlen);
 		break;
 	case SCTP_RECVNXTINFO:
 		retval = sctp_setsockopt_recvnxtinfo(sk, optval, optlen);
-- 
2.26.2

