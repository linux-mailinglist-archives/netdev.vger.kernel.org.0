Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6D33A225059
	for <lists+netdev@lfdr.de>; Sun, 19 Jul 2020 09:25:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726126AbgGSHWq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 Jul 2020 03:22:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52424 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725783AbgGSHWp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 19 Jul 2020 03:22:45 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 96306C0619D4;
        Sun, 19 Jul 2020 00:22:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=cTfJ9auEl8ATge+G5CCeykW2bA/ms2zABDjxNgMhOpc=; b=fEIAaQkYAK6ZJ5wqYOZQZ4475I
        1iA+dqZV3M9KPSLzKrFo/h1FqinXmTWPEnKTdC65Z0XpR1i8lCPycDE8VJi2LYComzZo3ZcyftvYy
        1hAtK6add6oiGtjG+WUtgT80XfxhVIr/v7Mi0nCHGtn+cyacGW09fQ0OtOvjjGGBv3H3aBsGZ92YF
        JpZbmJL1dEyTAMjASGLNVPKA0pPvwxd6UmJPggOKekkJgtCfvtDk8lNcD5qMlh91BxvWoAvOpYL8o
        rpThntZetbHdNcBKT0WbBRXzrEUxxNxLFVYTYnrk9bEa3OEnZeDZRAFy+fPX9IIJsXGtbg2cCId48
        2wqOiyXg==;
Received: from [2001:4bb8:105:4a81:4ef5:9f24:cda4:103f] (helo=localhost)
        by casper.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jx3ed-0000Pm-7R; Sun, 19 Jul 2020 07:22:35 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     Vlad Yasevich <vyasevich@gmail.com>,
        Neil Horman <nhorman@tuxdriver.com>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        David Laight <David.Laight@ACULAB.COM>,
        linux-sctp@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH 04/51] sctp: pass a kernel pointer to sctp_setsockopt_disable_fragments
Date:   Sun, 19 Jul 2020 09:21:41 +0200
Message-Id: <20200719072228.112645-5-hch@lst.de>
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
 net/sctp/socket.c | 14 +++-----------
 1 file changed, 3 insertions(+), 11 deletions(-)

diff --git a/net/sctp/socket.c b/net/sctp/socket.c
index 44cf2848146a91..b259ea94aeddef 100644
--- a/net/sctp/socket.c
+++ b/net/sctp/socket.c
@@ -2184,20 +2184,12 @@ static int sctp_recvmsg(struct sock *sk, struct msghdr *msg, size_t len,
  * exceeds the current PMTU size, the message will NOT be sent and
  * instead a error will be indicated to the user.
  */
-static int sctp_setsockopt_disable_fragments(struct sock *sk,
-					     char __user *optval,
+static int sctp_setsockopt_disable_fragments(struct sock *sk, int *val,
 					     unsigned int optlen)
 {
-	int val;
-
 	if (optlen < sizeof(int))
 		return -EINVAL;
-
-	if (get_user(val, (int __user *)optval))
-		return -EFAULT;
-
-	sctp_sk(sk)->disable_fragments = (val == 0) ? 0 : 1;
-
+	sctp_sk(sk)->disable_fragments = (*val == 0) ? 0 : 1;
 	return 0;
 }
 
@@ -4701,7 +4693,7 @@ static int sctp_setsockopt(struct sock *sk, int level, int optname,
 		break;
 
 	case SCTP_DISABLE_FRAGMENTS:
-		retval = sctp_setsockopt_disable_fragments(sk, optval, optlen);
+		retval = sctp_setsockopt_disable_fragments(sk, kopt, optlen);
 		break;
 
 	case SCTP_EVENTS:
-- 
2.27.0

