Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B91021DD4D5
	for <lists+netdev@lfdr.de>; Thu, 21 May 2020 19:50:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730072AbgEURsE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 May 2020 13:48:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57812 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729029AbgEURsD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 May 2020 13:48:03 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AEF1CC061A0E;
        Thu, 21 May 2020 10:48:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=XdMJEjTtoaAs1w9xt+NgrWfZ6KjmtXggnReOY/jA7IY=; b=iQRMDtxQsnOLxaz23jBChf2PEg
        uVeLaeC+lSiJBk0Fs+wmzsnxBR6KvzuSOd0NQ0+5jMWhitPYBbVSZUDU4VuObSr4xVDLuv1hUlbtr
        /VzD0NW45J08oyJIXe6l4n3axca7pMmOLNMsBOnT74DXey3lX4Ds4/eAOhLe4lzwN0P1wY+Ai+X1X
        xnNMcrA3HKLSM0uMXynA2PkqyRF5CgZVgreO6CrO+asLfBjK46ygILuleuPIdYsdvpw9tdIp0F/Xj
        MsWUymY8KgKu7MmO3l0yXmJ0uKLEuuS4Ev8urtTK1p5MWemS4zQLDwDs9pkMmK43PP7iOD6huVqBo
        dIn5vevg==;
Received: from [2001:4bb8:18c:5da7:c70:4a89:bc61:2] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jbpIP-0003AV-4R; Thu, 21 May 2020 17:47:53 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     Vlad Yasevich <vyasevich@gmail.com>,
        Neil Horman <nhorman@tuxdriver.com>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        David Laight <David.Laight@ACULAB.COM>,
        linux-sctp@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH 09/49] sctp: pass a kernel pointer to sctp_setsockopt_partial_delivery_point
Date:   Thu, 21 May 2020 19:46:44 +0200
Message-Id: <20200521174724.2635475-10-hch@lst.de>
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
 net/sctp/socket.c | 13 ++++---------
 1 file changed, 4 insertions(+), 9 deletions(-)

diff --git a/net/sctp/socket.c b/net/sctp/socket.c
index 3763f124f9fea..6dd6b0cfcfe03 100644
--- a/net/sctp/socket.c
+++ b/net/sctp/socket.c
@@ -3484,24 +3484,19 @@ static int sctp_setsockopt_fragment_interleave(struct sock *sk,
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
@@ -4692,7 +4687,7 @@ static int sctp_setsockopt(struct sock *sk, int level, int optname,
 		retval = sctp_setsockopt_delayed_ack(sk, kopt, optlen);
 		break;
 	case SCTP_PARTIAL_DELIVERY_POINT:
-		retval = sctp_setsockopt_partial_delivery_point(sk, optval, optlen);
+		retval = sctp_setsockopt_partial_delivery_point(sk, kopt, optlen);
 		break;
 
 	case SCTP_INITMSG:
-- 
2.26.2

