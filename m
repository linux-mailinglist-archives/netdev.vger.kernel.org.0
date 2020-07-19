Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A573B225034
	for <lists+netdev@lfdr.de>; Sun, 19 Jul 2020 09:23:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726863AbgGSHXi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 Jul 2020 03:23:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52630 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726811AbgGSHXd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 19 Jul 2020 03:23:33 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD866C0619D2;
        Sun, 19 Jul 2020 00:23:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=C4GJvpsbQV+Ulfkn3k4dQ+lkjvbIs+yw2OmQS1CxxtQ=; b=SIKUpvMqx7xCEOQJcTvkxDslB7
        NZWxuDfzIChMT0TaHVPTmRPF67/BitIgLfwcjojmz7QD8TniqePKtUshsPyPuPTGOCb9nqIPZq0Hy
        Gs12pJblLB+BpMIkibs2JTMLJHkwQSnIIFY2teBA+fpa1V8o2htjumZVm7w0DveWpWqZfs0WOBYFx
        +IzmyXrOtCC5vVuEu7cwcD3rGEKFTVDTZeNISY04RJPFHZR+rjEsg66v5n06RBjt/pclVG5rAoSA8
        0yf34yl3VwvFiwjFpRk22+pB11p9WQiVvjeX0EP7joL1Xv9EsOdSDHNpp82xgXX7IArBVgR5Z4Ubn
        gvwqCIJQ==;
Received: from [2001:4bb8:105:4a81:4ef5:9f24:cda4:103f] (helo=localhost)
        by casper.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jx3fU-0000Xp-SF; Sun, 19 Jul 2020 07:23:29 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     Vlad Yasevich <vyasevich@gmail.com>,
        Neil Horman <nhorman@tuxdriver.com>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        David Laight <David.Laight@ACULAB.COM>,
        linux-sctp@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH 45/51] sctp: pass a kernel pointer to sctp_setsockopt_reuse_port
Date:   Sun, 19 Jul 2020 09:22:22 +0200
Message-Id: <20200719072228.112645-46-hch@lst.de>
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
index 6232e46c4cdebd..a5b95e68cc129f 100644
--- a/net/sctp/socket.c
+++ b/net/sctp/socket.c
@@ -4214,11 +4214,9 @@ static int sctp_setsockopt_interleaving_supported(struct sock *sk,
 	return 0;
 }
 
-static int sctp_setsockopt_reuse_port(struct sock *sk, char __user *optval,
+static int sctp_setsockopt_reuse_port(struct sock *sk, int *val,
 				      unsigned int optlen)
 {
-	int val;
-
 	if (!sctp_style(sk, TCP))
 		return -EOPNOTSUPP;
 
@@ -4228,10 +4226,7 @@ static int sctp_setsockopt_reuse_port(struct sock *sk, char __user *optval,
 	if (optlen < sizeof(int))
 		return -EINVAL;
 
-	if (get_user(val, (int __user *)optval))
-		return -EFAULT;
-
-	sctp_sk(sk)->reuse = !!val;
+	sctp_sk(sk)->reuse = !!*val;
 
 	return 0;
 }
@@ -4645,7 +4640,7 @@ static int sctp_setsockopt(struct sock *sk, int level, int optname,
 								optlen);
 		break;
 	case SCTP_REUSE_PORT:
-		retval = sctp_setsockopt_reuse_port(sk, optval, optlen);
+		retval = sctp_setsockopt_reuse_port(sk, kopt, optlen);
 		break;
 	case SCTP_EVENT:
 		retval = sctp_setsockopt_event(sk, optval, optlen);
-- 
2.27.0

