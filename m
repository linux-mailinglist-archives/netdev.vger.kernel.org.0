Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CAE0622505E
	for <lists+netdev@lfdr.de>; Sun, 19 Jul 2020 09:25:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726159AbgGSHWr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 Jul 2020 03:22:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52430 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726009AbgGSHWp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 19 Jul 2020 03:22:45 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9BA0BC0619D5;
        Sun, 19 Jul 2020 00:22:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=RG1qDZyg1j1iH+gwK7A3BBVzcv/NNoYZS1h/7fn3uMo=; b=sDj2wG7XOyIL6YF6Xwa5uxxtDH
        WYY/8WB27gLMK9mOTmSW67CI7UEMIGaYM6UtyoeMSEniCWfPwC42yPZEixLfPbUuD/vCcCKCl9jYt
        s4p+P5rpQHdA5iaJ5Q9MN3xR7R4+kkAFCFe/z8abh0pSsDcjHKCy7dD7HDnBzZ4txVxBD47Bab7hQ
        QuoeacsC7vMr3o6S6fRu6l9FyH+o/W/nF9247ElXjEA+6KVjS3j1L8PsCdu5Fd3hEPKONg6gShivx
        fgBMwDa3sG2hdD+4SHe3JPJuBmU08XGxUyodHvOrxurSCf8bEbVyJtI07iUPQhjq2oTlb+D5xWweT
        gu5PRU5w==;
Received: from [2001:4bb8:105:4a81:4ef5:9f24:cda4:103f] (helo=localhost)
        by casper.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jx3ee-0000Q9-BW; Sun, 19 Jul 2020 07:22:36 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     Vlad Yasevich <vyasevich@gmail.com>,
        Neil Horman <nhorman@tuxdriver.com>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        David Laight <David.Laight@ACULAB.COM>,
        linux-sctp@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH 05/51] sctp: pass a kernel pointer to sctp_setsockopt_events
Date:   Sun, 19 Jul 2020 09:21:42 +0200
Message-Id: <20200719072228.112645-6-hch@lst.de>
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
 net/sctp/socket.c | 9 ++-------
 1 file changed, 2 insertions(+), 7 deletions(-)

diff --git a/net/sctp/socket.c b/net/sctp/socket.c
index b259ea94aeddef..bc37174bd71af0 100644
--- a/net/sctp/socket.c
+++ b/net/sctp/socket.c
@@ -2193,11 +2193,9 @@ static int sctp_setsockopt_disable_fragments(struct sock *sk, int *val,
 	return 0;
 }
 
-static int sctp_setsockopt_events(struct sock *sk, char __user *optval,
+static int sctp_setsockopt_events(struct sock *sk, __u8 *sn_type,
 				  unsigned int optlen)
 {
-	struct sctp_event_subscribe subscribe;
-	__u8 *sn_type = (__u8 *)&subscribe;
 	struct sctp_sock *sp = sctp_sk(sk);
 	struct sctp_association *asoc;
 	int i;
@@ -2205,9 +2203,6 @@ static int sctp_setsockopt_events(struct sock *sk, char __user *optval,
 	if (optlen > sizeof(struct sctp_event_subscribe))
 		return -EINVAL;
 
-	if (copy_from_user(&subscribe, optval, optlen))
-		return -EFAULT;
-
 	for (i = 0; i < optlen; i++)
 		sctp_ulpevent_type_set(&sp->subscribe, SCTP_SN_TYPE_BASE + i,
 				       sn_type[i]);
@@ -4697,7 +4692,7 @@ static int sctp_setsockopt(struct sock *sk, int level, int optname,
 		break;
 
 	case SCTP_EVENTS:
-		retval = sctp_setsockopt_events(sk, optval, optlen);
+		retval = sctp_setsockopt_events(sk, kopt, optlen);
 		break;
 
 	case SCTP_AUTOCLOSE:
-- 
2.27.0

