Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 085FA1DD502
	for <lists+netdev@lfdr.de>; Thu, 21 May 2020 19:50:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730384AbgEURsz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 May 2020 13:48:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57978 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730369AbgEURsx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 May 2020 13:48:53 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EEB49C061A0E;
        Thu, 21 May 2020 10:48:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=QhjTnbbyAWJatFw6lxgPgg1rL8J0LDpK4JJ9WUs6mlw=; b=tPw7joQYNFOl1IE9VVpOM6J4aB
        g+G70+YSHIFPKU9i5jI4YprBPklUbTWmbQ8+k1l1l0oJjD8Cj7QHggbng4E4hZ/MyKoePrGhCYNSl
        ggTER/BHsa2Mr2LJEK0NG37HssNCzY/dtSfNW63U7gQXbFX9/nahxBG3OGAs8NyTDcbIj6QXXeDS2
        jaYMHGwKhc+tTUlEO5rCax0TbZsyoht9d/dQA1gW0X7ZuXPZUU1m80rqrXgXg0mmbA8Dx2KdAnOTT
        HcxNmvK5bNJ82bwZYkx9VP7M4YZebAKMoRBj0HJXIe2dqCcQ6gaH6KnS80LoZrHhjVmjIN3UWnrgW
        Rlk83bzg==;
Received: from [2001:4bb8:18c:5da7:c70:4a89:bc61:2] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jbpJL-0003LV-Cy; Thu, 21 May 2020 17:48:51 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     Vlad Yasevich <vyasevich@gmail.com>,
        Neil Horman <nhorman@tuxdriver.com>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        David Laight <David.Laight@ACULAB.COM>,
        linux-sctp@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH 31/49] sctp: pass a kernel pointer to sctp_setsockopt_paddr_thresholds
Date:   Thu, 21 May 2020 19:47:06 +0200
Message-Id: <20200521174724.2635475-32-hch@lst.de>
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
 net/sctp/socket.c | 53 ++++++++++++++++++++++-------------------------
 1 file changed, 25 insertions(+), 28 deletions(-)

diff --git a/net/sctp/socket.c b/net/sctp/socket.c
index 04eac086831f0..a2aa1e309d595 100644
--- a/net/sctp/socket.c
+++ b/net/sctp/socket.c
@@ -3836,10 +3836,9 @@ static int sctp_setsockopt_auto_asconf(struct sock *sk, int *val,
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
@@ -3847,55 +3846,53 @@ static int sctp_setsockopt_paddr_thresholds(struct sock *sk,
 	len = v2 ? sizeof(val) : sizeof(struct sctp_paddrthlds);
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
@@ -4686,11 +4683,11 @@ static int sctp_setsockopt(struct sock *sk, int level, int optname,
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
2.26.2

