Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 799AE225022
	for <lists+netdev@lfdr.de>; Sun, 19 Jul 2020 09:23:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726689AbgGSHXT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 Jul 2020 03:23:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52562 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726658AbgGSHXQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 19 Jul 2020 03:23:16 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 14A91C0619D2;
        Sun, 19 Jul 2020 00:23:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=iQ+WHA+RXig33PqfpoVbaK0Yfvo0UB1rJqOFOo8QfsY=; b=Uc3H3cV2AuZhiOD1zUoGYvIEC7
        YT+IcgboDOZjPYxfpYiMkGMqvt4Cj6BFNSQAwHODvYeblK+X8LukSkct1oq5geTGF7TjCaSpUIyD5
        DS5cCjtc6jgqQ4fk5Ek0L6zyiCIwo8XqiYHzloteL7VL2m3xa9b3ceYiFItCaIk0QVKp+dk8JnV2R
        2Qnr8WYRW+8YOTwvEngdjA0vMX/qrHkmbL8vVdukJLnRRm38a3qWlx52D3G4+sJ8+a3DX4B+OP/TY
        Ux/rVtiVs1HQOc3h8r5FzDsP7OgU9NE2UM4rQQ92s8Dwla35HGPKSJoQ6tNrccZnusrU06InEXpIJ
        DdIBmXkQ==;
Received: from [2001:4bb8:105:4a81:4ef5:9f24:cda4:103f] (helo=localhost)
        by casper.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jx3fE-0000Vc-5D; Sun, 19 Jul 2020 07:23:12 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     Vlad Yasevich <vyasevich@gmail.com>,
        Neil Horman <nhorman@tuxdriver.com>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        David Laight <David.Laight@ACULAB.COM>,
        linux-sctp@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH 32/51] sctp: pass a kernel pointer to sctp_setsockopt_paddr_thresholds
Date:   Sun, 19 Jul 2020 09:22:09 +0200
Message-Id: <20200719072228.112645-33-hch@lst.de>
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
 net/sctp/socket.c | 55 ++++++++++++++++++++++-------------------------
 1 file changed, 26 insertions(+), 29 deletions(-)

diff --git a/net/sctp/socket.c b/net/sctp/socket.c
index 64f2a967ddf5d3..ea027ea74ba557 100644
--- a/net/sctp/socket.c
+++ b/net/sctp/socket.c
@@ -3840,66 +3840,63 @@ static int sctp_setsockopt_auto_asconf(struct sock *sk, int *val,
  * http://www.ietf.org/id/draft-nishida-tsvwg-sctp-failover-05.txt
  */
 static int sctp_setsockopt_paddr_thresholds(struct sock *sk,
-					    char __user *optval,
+					    struct sctp_paddrthlds_v2 *val,
 					    unsigned int optlen, bool v2)
 {
-	struct sctp_paddrthlds_v2 val;
 	struct sctp_transport *trans;
 	struct sctp_association *asoc;
 	int len;
 
-	len = v2 ? sizeof(val) : sizeof(struct sctp_paddrthlds);
+	len = v2 ? sizeof(*val) : sizeof(struct sctp_paddrthlds);
 	if (optlen < len)
 		return -EINVAL;
-	if (copy_from_user(&val, optval, len))
-		return -EFAULT;
 
-	if (v2 && val.spt_pathpfthld > val.spt_pathcpthld)
+	if (v2 && val->spt_pathpfthld > val->spt_pathcpthld)
 		return -EINVAL;
 
-	if (!sctp_is_any(sk, (const union sctp_addr *)&val.spt_address)) {
-		trans = sctp_addr_id2transport(sk, &val.spt_address,
-					       val.spt_assoc_id);
+	if (!sctp_is_any(sk, (const union sctp_addr *)&val->spt_address)) {
+		trans = sctp_addr_id2transport(sk, &val->spt_address,
+					       val->spt_assoc_id);
 		if (!trans)
 			return -ENOENT;
 
-		if (val.spt_pathmaxrxt)
-			trans->pathmaxrxt = val.spt_pathmaxrxt;
+		if (val->spt_pathmaxrxt)
+			trans->pathmaxrxt = val->spt_pathmaxrxt;
 		if (v2)
-			trans->ps_retrans = val.spt_pathcpthld;
-		trans->pf_retrans = val.spt_pathpfthld;
+			trans->ps_retrans = val->spt_pathcpthld;
+		trans->pf_retrans = val->spt_pathpfthld;
 
 		return 0;
 	}
 
-	asoc = sctp_id2assoc(sk, val.spt_assoc_id);
-	if (!asoc && val.spt_assoc_id != SCTP_FUTURE_ASSOC &&
+	asoc = sctp_id2assoc(sk, val->spt_assoc_id);
+	if (!asoc && val->spt_assoc_id != SCTP_FUTURE_ASSOC &&
 	    sctp_style(sk, UDP))
 		return -EINVAL;
 
 	if (asoc) {
 		list_for_each_entry(trans, &asoc->peer.transport_addr_list,
 				    transports) {
-			if (val.spt_pathmaxrxt)
-				trans->pathmaxrxt = val.spt_pathmaxrxt;
+			if (val->spt_pathmaxrxt)
+				trans->pathmaxrxt = val->spt_pathmaxrxt;
 			if (v2)
-				trans->ps_retrans = val.spt_pathcpthld;
-			trans->pf_retrans = val.spt_pathpfthld;
+				trans->ps_retrans = val->spt_pathcpthld;
+			trans->pf_retrans = val->spt_pathpfthld;
 		}
 
-		if (val.spt_pathmaxrxt)
-			asoc->pathmaxrxt = val.spt_pathmaxrxt;
+		if (val->spt_pathmaxrxt)
+			asoc->pathmaxrxt = val->spt_pathmaxrxt;
 		if (v2)
-			asoc->ps_retrans = val.spt_pathcpthld;
-		asoc->pf_retrans = val.spt_pathpfthld;
+			asoc->ps_retrans = val->spt_pathcpthld;
+		asoc->pf_retrans = val->spt_pathpfthld;
 	} else {
 		struct sctp_sock *sp = sctp_sk(sk);
 
-		if (val.spt_pathmaxrxt)
-			sp->pathmaxrxt = val.spt_pathmaxrxt;
+		if (val->spt_pathmaxrxt)
+			sp->pathmaxrxt = val->spt_pathmaxrxt;
 		if (v2)
-			sp->ps_retrans = val.spt_pathcpthld;
-		sp->pf_retrans = val.spt_pathpfthld;
+			sp->ps_retrans = val->spt_pathcpthld;
+		sp->pf_retrans = val->spt_pathpfthld;
 	}
 
 	return 0;
@@ -4690,11 +4687,11 @@ static int sctp_setsockopt(struct sock *sk, int level, int optname,
 		retval = sctp_setsockopt_auto_asconf(sk, kopt, optlen);
 		break;
 	case SCTP_PEER_ADDR_THLDS:
-		retval = sctp_setsockopt_paddr_thresholds(sk, optval, optlen,
+		retval = sctp_setsockopt_paddr_thresholds(sk, kopt, optlen,
 							  false);
 		break;
 	case SCTP_PEER_ADDR_THLDS_V2:
-		retval = sctp_setsockopt_paddr_thresholds(sk, optval, optlen,
+		retval = sctp_setsockopt_paddr_thresholds(sk, kopt, optlen,
 							  true);
 		break;
 	case SCTP_RECVRCVINFO:
-- 
2.27.0

