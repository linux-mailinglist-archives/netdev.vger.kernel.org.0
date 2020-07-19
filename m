Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A138022500C
	for <lists+netdev@lfdr.de>; Sun, 19 Jul 2020 09:22:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726397AbgGSHWv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 Jul 2020 03:22:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52452 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726097AbgGSHWt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 19 Jul 2020 03:22:49 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B422C0619D2;
        Sun, 19 Jul 2020 00:22:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=Nu0+EJto9U+uPtJQOVTR3gEYooNi9VGCnWKywFC8l0c=; b=lj2cQBafKvFoG2U9bkHjNh75M/
        n9J+N+eXPUITLQdCGplk1Pp5/+RGMqfvBklc8/KaZRzZquIliB4sm0UERAcmCuj4KCB0tjPvwAHli
        eFnMCz8n+ov60UBJst0KyMBTq9u4WALH8WCSTYwiyP1GqEjMntzqEjX/FTr7cRTGz2q+vB9qzitAZ
        IX+o3UlImQ+tG5z/gM0qCdy2hZwnbZwHO7TzNwQouRWH7WU7JsY4cdrwmwz/0Kgjz1m47z33Mzxnt
        55VJ0BpXVCiqkmbt6+yB+McXrzNB6OCRcGabDk8HNIUsUCcMSO89IdF1N41gn09C0INauBNzFLnUG
        BYt2nB0w==;
Received: from [2001:4bb8:105:4a81:4ef5:9f24:cda4:103f] (helo=localhost)
        by casper.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jx3ek-0000RO-2Z; Sun, 19 Jul 2020 07:22:42 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     Vlad Yasevich <vyasevich@gmail.com>,
        Neil Horman <nhorman@tuxdriver.com>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        David Laight <David.Laight@ACULAB.COM>,
        linux-sctp@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH 09/51] sctp: pass a kernel pointer to sctp_setsockopt_partial_delivery_point
Date:   Sun, 19 Jul 2020 09:21:46 +0200
Message-Id: <20200719072228.112645-10-hch@lst.de>
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
 net/sctp/socket.c | 13 ++++---------
 1 file changed, 4 insertions(+), 9 deletions(-)

diff --git a/net/sctp/socket.c b/net/sctp/socket.c
index 2dfbd7f8799114..deccfe54d2fc7d 100644
--- a/net/sctp/socket.c
+++ b/net/sctp/socket.c
@@ -3487,24 +3487,19 @@ static int sctp_setsockopt_fragment_interleave(struct sock *sk,
  * call as long as the user provided buffer is large enough to hold the
  * message.
  */
-static int sctp_setsockopt_partial_delivery_point(struct sock *sk,
-						  char __user *optval,
+static int sctp_setsockopt_partial_delivery_point(struct sock *sk, u32 *val,
 						  unsigned int optlen)
 {
-	u32 val;
-
 	if (optlen != sizeof(u32))
 		return -EINVAL;
-	if (get_user(val, (int __user *)optval))
-		return -EFAULT;
 
 	/* Note: We double the receive buffer from what the user sets
 	 * it to be, also initial rwnd is based on rcvbuf/2.
 	 */
-	if (val > (sk->sk_rcvbuf >> 1))
+	if (*val > (sk->sk_rcvbuf >> 1))
 		return -EINVAL;
 
-	sctp_sk(sk)->pd_point = val;
+	sctp_sk(sk)->pd_point = *val;
 
 	return 0; /* is this the right error code? */
 }
@@ -4695,7 +4690,7 @@ static int sctp_setsockopt(struct sock *sk, int level, int optname,
 		retval = sctp_setsockopt_delayed_ack(sk, kopt, optlen);
 		break;
 	case SCTP_PARTIAL_DELIVERY_POINT:
-		retval = sctp_setsockopt_partial_delivery_point(sk, optval, optlen);
+		retval = sctp_setsockopt_partial_delivery_point(sk, kopt, optlen);
 		break;
 
 	case SCTP_INITMSG:
-- 
2.27.0

