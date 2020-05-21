Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 923FA1DD4D9
	for <lists+netdev@lfdr.de>; Thu, 21 May 2020 19:50:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730089AbgEURsK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 May 2020 13:48:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57820 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729029AbgEURsF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 May 2020 13:48:05 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C03B6C061A0E;
        Thu, 21 May 2020 10:48:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=VFUc5VLPQ2zd1n4PsADX1SOcmkM8UdnR7Y7BDWQYGXA=; b=Z/GClBkD4hKho6eXO4JpZUIrx7
        l+WRx8LKOdpBWG2idx4vrprPF94B4hSBKQAB9RhzhQXzUaaHvYOtwLQMSCuS5P/Vl0hTHZsS0J+ba
        vqR9geB5ZfukcgOwGET1wzAnQS9dC3FY9ckWUdr4p7zgi1PNTDRUyrnWh3STTT/6WXBI/h/siXeFW
        VLyHwloIugB9fP2WIj/7hBpeQ0HJj4ePenY3mjjfHOBQhSu61eLGtDKRhNkDI571fjhVEOHqAM5Xi
        ko8iHtIeVaNiQeQTcGJEVzAHi1b8SUdz42nI8OukV34bnMtESI0MC4uw6z4Rl46tn7SIcJrb/VKxN
        KCKoTvcA==;
Received: from [2001:4bb8:18c:5da7:c70:4a89:bc61:2] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jbpIR-0003B6-I6; Thu, 21 May 2020 17:47:55 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     Vlad Yasevich <vyasevich@gmail.com>,
        Neil Horman <nhorman@tuxdriver.com>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        David Laight <David.Laight@ACULAB.COM>,
        linux-sctp@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH 10/49] sctp: pass a kernel pointer to sctp_setsockopt_initmsg
Date:   Thu, 21 May 2020 19:46:45 +0200
Message-Id: <20200521174724.2635475-11-hch@lst.de>
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
 net/sctp/socket.c | 24 +++++++++++-------------
 1 file changed, 11 insertions(+), 13 deletions(-)

diff --git a/net/sctp/socket.c b/net/sctp/socket.c
index 6dd6b0cfcfe03..0180b22087c0b 100644
--- a/net/sctp/socket.c
+++ b/net/sctp/socket.c
@@ -2829,24 +2829,22 @@ static int sctp_setsockopt_delayed_ack(struct sock *sk,
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
@@ -4691,7 +4689,7 @@ static int sctp_setsockopt(struct sock *sk, int level, int optname,
 		break;
 
 	case SCTP_INITMSG:
-		retval = sctp_setsockopt_initmsg(sk, optval, optlen);
+		retval = sctp_setsockopt_initmsg(sk, kopt, optlen);
 		break;
 	case SCTP_DEFAULT_SEND_PARAM:
 		retval = sctp_setsockopt_default_send_param(sk, optval,
-- 
2.26.2

