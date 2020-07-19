Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 52F3D225015
	for <lists+netdev@lfdr.de>; Sun, 19 Jul 2020 09:23:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726535AbgGSHXB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 Jul 2020 03:23:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52482 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726436AbgGSHW4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 19 Jul 2020 03:22:56 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A3BDC0619D4;
        Sun, 19 Jul 2020 00:22:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=qNgKoiXXxsI1xLfTOg6ZqMCh8RNW0WdDRM9SqZnOLzM=; b=dHi+xFo5RbV7I69KQrtmnsBlL8
        hutFCqQ/9ZljxDACBna5m6I/bEEJvQXBzmtq8MgcjsZKnIgDOh1aLv757oJPJMhd4bgLE1Ipz1GgU
        z530Il7RE85LAr41c4FSBWd8vu+j69+boxJYxhP9Y3oxRPE5KWO1hGtDe4/omdFVlhTzEMivx7ijG
        G/jXOfETv3u9iOXfBvzlKT1zDbZKVJUzBLFOwRY9gTprw0TCFAYVhmkoRDJlPeJXjYC648MHPCAsI
        VbhamqFc8ligXIsrxsmPgtENxrGjhjXBjf+oIh8DYbwKbRALzeHqrbqlSs4A2cBwQh7xSeGbiPase
        c5l/6M3g==;
Received: from [2001:4bb8:105:4a81:4ef5:9f24:cda4:103f] (helo=localhost)
        by casper.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jx3er-0000Sc-M8; Sun, 19 Jul 2020 07:22:50 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     Vlad Yasevich <vyasevich@gmail.com>,
        Neil Horman <nhorman@tuxdriver.com>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        David Laight <David.Laight@ACULAB.COM>,
        linux-sctp@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH 15/51] sctp: pass a kernel pointer to sctp_setsockopt_nodelay
Date:   Sun, 19 Jul 2020 09:21:52 +0200
Message-Id: <20200719072228.112645-16-hch@lst.de>
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
index ff3b720eab0aa2..f9fe93e865b970 100644
--- a/net/sctp/socket.c
+++ b/net/sctp/socket.c
@@ -3020,17 +3020,12 @@ static int sctp_setsockopt_primary_addr(struct sock *sk, struct sctp_prim *prim,
  * introduced, at the cost of more packets in the network.  Expects an
  *  integer boolean flag.
  */
-static int sctp_setsockopt_nodelay(struct sock *sk, char __user *optval,
+static int sctp_setsockopt_nodelay(struct sock *sk, int *val,
 				   unsigned int optlen)
 {
-	int val;
-
 	if (optlen < sizeof(int))
 		return -EINVAL;
-	if (get_user(val, (int __user *)optval))
-		return -EFAULT;
-
-	sctp_sk(sk)->nodelay = (val == 0) ? 0 : 1;
+	sctp_sk(sk)->nodelay = (*val == 0) ? 0 : 1;
 	return 0;
 }
 
@@ -4694,7 +4689,7 @@ static int sctp_setsockopt(struct sock *sk, int level, int optname,
 		retval = sctp_setsockopt_peer_primary_addr(sk, kopt, optlen);
 		break;
 	case SCTP_NODELAY:
-		retval = sctp_setsockopt_nodelay(sk, optval, optlen);
+		retval = sctp_setsockopt_nodelay(sk, kopt, optlen);
 		break;
 	case SCTP_RTOINFO:
 		retval = sctp_setsockopt_rtoinfo(sk, optval, optlen);
-- 
2.27.0

