Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1B41322501B
	for <lists+netdev@lfdr.de>; Sun, 19 Jul 2020 09:23:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726607AbgGSHXI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 Jul 2020 03:23:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52500 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726021AbgGSHXB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 19 Jul 2020 03:23:01 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB084C0619D5;
        Sun, 19 Jul 2020 00:23:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=OUSJ+xjBQEDiu/OkwNHbKNeYc7RfL+fj3EOZiT8lVcE=; b=b1VMDxW2Sg3Ab6uhucZ0SX94vJ
        JY7rL4S/Dh0i6BBfDSULXTlrRfrJ2ueOyXHTPyhyljD+ik/oNf2XqOrxvIJBzobi2DUUAqrWKrnZO
        jg9rj3Rf2Qio+DJ22adLyzDe/nRi/cc1xgZo4vY5cfAJxRpgl/MPNbJBHiMNqB38gl1FF5m65kasF
        SOfVWEe83TMznZeiL9D1DhA+PF2YfGg5MNYCIykEuGAwCfy7JLwKGjZpZxyfGeRn0G18Bsgj1cFFc
        oI3OudYNM45hFMHTDNdsKRSMJJPYI/QQUuqyFBoqPIrtfLV/41vUnDLDQMkcPC6vGyKrQ3OVutF/C
        RY5vGHuA==;
Received: from [2001:4bb8:105:4a81:4ef5:9f24:cda4:103f] (helo=localhost)
        by casper.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jx3ev-0000TD-OG; Sun, 19 Jul 2020 07:22:54 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     Vlad Yasevich <vyasevich@gmail.com>,
        Neil Horman <nhorman@tuxdriver.com>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        David Laight <David.Laight@ACULAB.COM>,
        linux-sctp@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH 18/51] sctp: pass a kernel pointer to sctp_setsockopt_mappedv4
Date:   Sun, 19 Jul 2020 09:21:55 +0200
Message-Id: <20200719072228.112645-19-hch@lst.de>
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
 net/sctp/socket.c | 10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

diff --git a/net/sctp/socket.c b/net/sctp/socket.c
index 2a655c65e2943d..5007af318e134e 100644
--- a/net/sctp/socket.c
+++ b/net/sctp/socket.c
@@ -3173,16 +3173,14 @@ static int sctp_setsockopt_associnfo(struct sock *sk,
  * addresses and a user will receive both PF_INET6 and PF_INET type
  * addresses on the socket.
  */
-static int sctp_setsockopt_mappedv4(struct sock *sk, char __user *optval, unsigned int optlen)
+static int sctp_setsockopt_mappedv4(struct sock *sk, int *val,
+				    unsigned int optlen)
 {
-	int val;
 	struct sctp_sock *sp = sctp_sk(sk);
 
 	if (optlen < sizeof(int))
 		return -EINVAL;
-	if (get_user(val, (int __user *)optval))
-		return -EFAULT;
-	if (val)
+	if (*val)
 		sp->v4mapped = 1;
 	else
 		sp->v4mapped = 0;
@@ -4696,7 +4694,7 @@ static int sctp_setsockopt(struct sock *sk, int level, int optname,
 		retval = sctp_setsockopt_associnfo(sk, kopt, optlen);
 		break;
 	case SCTP_I_WANT_MAPPED_V4_ADDR:
-		retval = sctp_setsockopt_mappedv4(sk, optval, optlen);
+		retval = sctp_setsockopt_mappedv4(sk, kopt, optlen);
 		break;
 	case SCTP_MAXSEG:
 		retval = sctp_setsockopt_maxseg(sk, optval, optlen);
-- 
2.27.0

