Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EDECD22501E
	for <lists+netdev@lfdr.de>; Sun, 19 Jul 2020 09:23:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726633AbgGSHXL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 Jul 2020 03:23:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52518 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726570AbgGSHXF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 19 Jul 2020 03:23:05 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 52912C0619D4;
        Sun, 19 Jul 2020 00:23:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=pxv+SuwQ//RwmeJDozlPUAYAB19xAfOJRsnRcI/PMj4=; b=QBXcyIBqbwDt4ZpvCHWQvxCh3M
        tdTi0VHzlNJ5WA0FF/96MhQsgPoHEO2jq5VrgR11DoN8d8dVMGh3nZ3CVXaTqlWQiQQx96+lMo4Hh
        ePA7yPawmXWcmOq+DWJT3dobIqD///tTIa2ib+Y3qM9JXacwJAK2C7Kh1ONCvvgIPNzio9ZtdXKFR
        ZMEkBXozLAIX0eLe+0xyE7foeIJvt2UhGKAEfYiYC2DjgEy23T1enzedPd/RXTV83uQHghLmycpOu
        LQ+hoK5dwnLgqAH7E+d/wd2fWLpO0IY1s8UoAa9ia+BGC786N0VZOBRXK29+W9XLId9l6PHSOF713
        F3nnPnGg==;
Received: from [2001:4bb8:105:4a81:4ef5:9f24:cda4:103f] (helo=localhost)
        by casper.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jx3f0-0000Tq-Fb; Sun, 19 Jul 2020 07:22:58 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     Vlad Yasevich <vyasevich@gmail.com>,
        Neil Horman <nhorman@tuxdriver.com>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        David Laight <David.Laight@ACULAB.COM>,
        linux-sctp@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH 22/51] sctp: pass a kernel pointer to sctp_setsockopt_fragment_interleave
Date:   Sun, 19 Jul 2020 09:21:59 +0200
Message-Id: <20200719072228.112645-23-hch@lst.de>
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
index 2862047054d55a..874cec73153052 100644
--- a/net/sctp/socket.c
+++ b/net/sctp/socket.c
@@ -3422,18 +3422,13 @@ static int sctp_setsockopt_context(struct sock *sk,
  * application using the one to many model may become confused and act
  * incorrectly.
  */
-static int sctp_setsockopt_fragment_interleave(struct sock *sk,
-					       char __user *optval,
+static int sctp_setsockopt_fragment_interleave(struct sock *sk, int *val,
 					       unsigned int optlen)
 {
-	int val;
-
 	if (optlen != sizeof(int))
 		return -EINVAL;
-	if (get_user(val, (int __user *)optval))
-		return -EFAULT;
 
-	sctp_sk(sk)->frag_interleave = !!val;
+	sctp_sk(sk)->frag_interleave = !!*val;
 
 	if (!sctp_sk(sk)->frag_interleave)
 		sctp_sk(sk)->ep->intl_enable = 0;
@@ -4701,7 +4696,7 @@ static int sctp_setsockopt(struct sock *sk, int level, int optname,
 		retval = sctp_setsockopt_context(sk, kopt, optlen);
 		break;
 	case SCTP_FRAGMENT_INTERLEAVE:
-		retval = sctp_setsockopt_fragment_interleave(sk, optval, optlen);
+		retval = sctp_setsockopt_fragment_interleave(sk, kopt, optlen);
 		break;
 	case SCTP_MAX_BURST:
 		retval = sctp_setsockopt_maxburst(sk, optval, optlen);
-- 
2.27.0

