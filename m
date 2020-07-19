Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8E7D122504A
	for <lists+netdev@lfdr.de>; Sun, 19 Jul 2020 09:24:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726977AbgGSHX6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 Jul 2020 03:23:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52572 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726653AbgGSHXS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 19 Jul 2020 03:23:18 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 88293C0619D2;
        Sun, 19 Jul 2020 00:23:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=Zj7hmEo86pGetlE6GBaVU9piMfmujvy4eCn8Ax20yT4=; b=A7/OOMmjMVWTVKqJuEXUw5UlvH
        THGd9LWmxGDV1L9buF9B1w/Jk68mthbJQcgyQn+oaWQcA+lgP77JK03Am1TEvPPvxK/SsGCB/YD5O
        1JxbIflC/tWxmuN/Cyi5EPBGjPs90bLGvRtFWo2VxOSffMTJhJHihWwS6PPV6zgWcFQqDSIUpS1tS
        s2aWKKvecxYqCTuGWWKu+/86dovdKYppTCUuHP0IlYtzqYcyrwvzpP0OL0YeHADQDetGyaSEbkLLD
        IKzCXamYspKP903yrgy44D2b85KOu9HsWMMicmEmXlkex8Gz8frBZ5me5POHJsFQducXYx9zawkg0
        Nu6q+NuA==;
Received: from [2001:4bb8:105:4a81:4ef5:9f24:cda4:103f] (helo=localhost)
        by casper.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jx3fG-0000Vx-Qy; Sun, 19 Jul 2020 07:23:15 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     Vlad Yasevich <vyasevich@gmail.com>,
        Neil Horman <nhorman@tuxdriver.com>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        David Laight <David.Laight@ACULAB.COM>,
        linux-sctp@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH 34/51] sctp: pass a kernel pointer to sctp_setsockopt_recvnxtinfo
Date:   Sun, 19 Jul 2020 09:22:11 +0200
Message-Id: <20200719072228.112645-35-hch@lst.de>
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
 net/sctp/socket.c | 11 +++--------
 1 file changed, 3 insertions(+), 8 deletions(-)

diff --git a/net/sctp/socket.c b/net/sctp/socket.c
index ac56fb7eb394f9..7beb26e5749d7e 100644
--- a/net/sctp/socket.c
+++ b/net/sctp/socket.c
@@ -3913,18 +3913,13 @@ static int sctp_setsockopt_recvrcvinfo(struct sock *sk, int *val,
 	return 0;
 }
 
-static int sctp_setsockopt_recvnxtinfo(struct sock *sk,
-				       char __user *optval,
+static int sctp_setsockopt_recvnxtinfo(struct sock *sk, int *val,
 				       unsigned int optlen)
 {
-	int val;
-
 	if (optlen < sizeof(int))
 		return -EINVAL;
-	if (get_user(val, (int __user *) optval))
-		return -EFAULT;
 
-	sctp_sk(sk)->recvnxtinfo = (val == 0) ? 0 : 1;
+	sctp_sk(sk)->recvnxtinfo = (*val == 0) ? 0 : 1;
 
 	return 0;
 }
@@ -4693,7 +4688,7 @@ static int sctp_setsockopt(struct sock *sk, int level, int optname,
 		retval = sctp_setsockopt_recvrcvinfo(sk, kopt, optlen);
 		break;
 	case SCTP_RECVNXTINFO:
-		retval = sctp_setsockopt_recvnxtinfo(sk, optval, optlen);
+		retval = sctp_setsockopt_recvnxtinfo(sk, kopt, optlen);
 		break;
 	case SCTP_PR_SUPPORTED:
 		retval = sctp_setsockopt_pr_supported(sk, optval, optlen);
-- 
2.27.0

