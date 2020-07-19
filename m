Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C8F3922506B
	for <lists+netdev@lfdr.de>; Sun, 19 Jul 2020 09:25:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727101AbgGSHY1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 Jul 2020 03:24:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52458 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726359AbgGSHWu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 19 Jul 2020 03:22:50 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 18558C0619D2;
        Sun, 19 Jul 2020 00:22:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=BbEXe2CwIjzrfU+0nbl470wmFzJmGW9yvHic1d8Ms0w=; b=vurpB6GEazg1CR6ssBpDQZowrS
        inwdLYTVGZE+jEyT/M4aRzMtGeJzSFFzdPI071VBHHLMamEx2B/0OZe7rBFtqm+rB+pTn9oBvvDAd
        W7ri17XOoK4b3n2SYb+hmTfKq5Vm+UdCsT4wVZ4mrkaqiFZyvGtxkvmtq3Kbvc+6OthbGEhwTg0mg
        N1l4rhWT2aQmW5VIh3e88BLJtTdrVWGhgruf5n0dKGmd1f8g+0VD/xBrcpJz19GrrADITfGkZtabG
        j4XhS2OIdQSie4P5k/UTLBbTby7tdwEBucbsZyt6vyER0XwutlG9vEfV1DevjwgBhGDScROvMPah5
        Qv4nGq0Q==;
Received: from [2001:4bb8:105:4a81:4ef5:9f24:cda4:103f] (helo=localhost)
        by casper.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jx3el-0000Rd-8C; Sun, 19 Jul 2020 07:22:43 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     Vlad Yasevich <vyasevich@gmail.com>,
        Neil Horman <nhorman@tuxdriver.com>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        David Laight <David.Laight@ACULAB.COM>,
        linux-sctp@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH 10/51] sctp: pass a kernel pointer to sctp_setsockopt_initmsg
Date:   Sun, 19 Jul 2020 09:21:47 +0200
Message-Id: <20200719072228.112645-11-hch@lst.de>
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
 net/sctp/socket.c | 24 +++++++++++-------------
 1 file changed, 11 insertions(+), 13 deletions(-)

diff --git a/net/sctp/socket.c b/net/sctp/socket.c
index deccfe54d2fc7d..d62c02d0b79346 100644
--- a/net/sctp/socket.c
+++ b/net/sctp/socket.c
@@ -2832,24 +2832,22 @@ static int sctp_setsockopt_delayed_ack(struct sock *sk,
  * by the change).  With TCP-style sockets, this option is inherited by
  * sockets derived from a listener socket.
  */
-static int sctp_setsockopt_initmsg(struct sock *sk, char __user *optval, unsigned int optlen)
+static int sctp_setsockopt_initmsg(struct sock *sk, struct sctp_initmsg *sinit,
+				   unsigned int optlen)
 {
-	struct sctp_initmsg sinit;
 	struct sctp_sock *sp = sctp_sk(sk);
 
 	if (optlen != sizeof(struct sctp_initmsg))
 		return -EINVAL;
-	if (copy_from_user(&sinit, optval, optlen))
-		return -EFAULT;
 
-	if (sinit.sinit_num_ostreams)
-		sp->initmsg.sinit_num_ostreams = sinit.sinit_num_ostreams;
-	if (sinit.sinit_max_instreams)
-		sp->initmsg.sinit_max_instreams = sinit.sinit_max_instreams;
-	if (sinit.sinit_max_attempts)
-		sp->initmsg.sinit_max_attempts = sinit.sinit_max_attempts;
-	if (sinit.sinit_max_init_timeo)
-		sp->initmsg.sinit_max_init_timeo = sinit.sinit_max_init_timeo;
+	if (sinit->sinit_num_ostreams)
+		sp->initmsg.sinit_num_ostreams = sinit->sinit_num_ostreams;
+	if (sinit->sinit_max_instreams)
+		sp->initmsg.sinit_max_instreams = sinit->sinit_max_instreams;
+	if (sinit->sinit_max_attempts)
+		sp->initmsg.sinit_max_attempts = sinit->sinit_max_attempts;
+	if (sinit->sinit_max_init_timeo)
+		sp->initmsg.sinit_max_init_timeo = sinit->sinit_max_init_timeo;
 
 	return 0;
 }
@@ -4694,7 +4692,7 @@ static int sctp_setsockopt(struct sock *sk, int level, int optname,
 		break;
 
 	case SCTP_INITMSG:
-		retval = sctp_setsockopt_initmsg(sk, optval, optlen);
+		retval = sctp_setsockopt_initmsg(sk, kopt, optlen);
 		break;
 	case SCTP_DEFAULT_SEND_PARAM:
 		retval = sctp_setsockopt_default_send_param(sk, optval,
-- 
2.27.0

