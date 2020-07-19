Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DBD3E225025
	for <lists+netdev@lfdr.de>; Sun, 19 Jul 2020 09:23:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726698AbgGSHXU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 Jul 2020 03:23:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52566 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726675AbgGSHXR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 19 Jul 2020 03:23:17 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 84A61C0619D2;
        Sun, 19 Jul 2020 00:23:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=unXsF6l9zV0bKIsbK7+uX6lK+1k0UjWp9iX4GMsw6+c=; b=r8uBtqnJIfRf0SV0hhu29uOFLp
        +KMZgZsvGtg4lM7DkaLSxr9vlXCpCf+/hgOgAshdTTBe/DJsdfwqrc+GLC6d6EDvNz7ajAHvEG4/W
        HAIWP40pHNouPNfYhffE7tofYNgUbiQF0BlEcumVU2tqMBq5ZxLXwrvkJ0MkcsFLMoBnPQ6RFHLUa
        HTX2rSJxJwUzgGae2zPEKf9P5TsOgKPCFi+eiPZ1KvtLP7KkxsmL0zrO/+4cLKa7u6+wZSMBBsB4Y
        GiF73cpI4y4I3oI5EWpPyjJ2l7NzSNQd74LYdAalMIPP88V4+JFaRcK/pVbmLthr/MiqRzPta+yCw
        JQFGudUg==;
Received: from [2001:4bb8:105:4a81:4ef5:9f24:cda4:103f] (helo=localhost)
        by casper.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jx3fF-0000Vn-Kh; Sun, 19 Jul 2020 07:23:14 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     Vlad Yasevich <vyasevich@gmail.com>,
        Neil Horman <nhorman@tuxdriver.com>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        David Laight <David.Laight@ACULAB.COM>,
        linux-sctp@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH 33/51] sctp: pass a kernel pointer to sctp_setsockopt_recvrcvinfo
Date:   Sun, 19 Jul 2020 09:22:10 +0200
Message-Id: <20200719072228.112645-34-hch@lst.de>
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
index ea027ea74ba557..ac56fb7eb394f9 100644
--- a/net/sctp/socket.c
+++ b/net/sctp/socket.c
@@ -3902,18 +3902,13 @@ static int sctp_setsockopt_paddr_thresholds(struct sock *sk,
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
@@ -4695,7 +4690,7 @@ static int sctp_setsockopt(struct sock *sk, int level, int optname,
 							  true);
 		break;
 	case SCTP_RECVRCVINFO:
-		retval = sctp_setsockopt_recvrcvinfo(sk, optval, optlen);
+		retval = sctp_setsockopt_recvrcvinfo(sk, kopt, optlen);
 		break;
 	case SCTP_RECVNXTINFO:
 		retval = sctp_setsockopt_recvnxtinfo(sk, optval, optlen);
-- 
2.27.0

