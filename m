Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 70CCB22501F
	for <lists+netdev@lfdr.de>; Sun, 19 Jul 2020 09:23:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726648AbgGSHXN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 Jul 2020 03:23:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52524 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726592AbgGSHXH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 19 Jul 2020 03:23:07 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 03EECC0619D2;
        Sun, 19 Jul 2020 00:23:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=RGOoBH1xzJ6sSOcr4+aoFXpjMnHo+XMPiaPfkmB8v2M=; b=ljH+NhhQK2O+y0kDaYHYP7w+ms
        BmTgt3JC/nvfkzcCFRplsaI038CBo/TZU7rVlOV7pZJrX+PEl9Sd6zZazxQNL60jfM5wD4ImOgMGb
        T3+eqfKMhSUKmQ61A4wL9qYx242KV6qfRtIZPzXvzI64z7OM6x7yJWHkVaO88L7oNlX7J0lCNOMzj
        3iX1XYwocsoqIByPJwBjxlD6Eo5+P7FaptIr+OutrJ2Q8b9GErYsHEymCIz78Kj/afodXPutgrjBa
        S8tKqbGUIwG4uHERhaqF2LqZNRGGfkSMS+NI4CBXpuJnTdCzbDbX9VkumencGSREwkWEfTwyQN0H3
        j5T980xQ==;
Received: from [2001:4bb8:105:4a81:4ef5:9f24:cda4:103f] (helo=localhost)
        by casper.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jx3f1-0000U0-Q3; Sun, 19 Jul 2020 07:23:00 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     Vlad Yasevich <vyasevich@gmail.com>,
        Neil Horman <nhorman@tuxdriver.com>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        David Laight <David.Laight@ACULAB.COM>,
        linux-sctp@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH 23/51] sctp: pass a kernel pointer to sctp_setsockopt_maxburst
Date:   Sun, 19 Jul 2020 09:22:00 +0200
Message-Id: <20200719072228.112645-24-hch@lst.de>
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
 net/sctp/socket.c | 35 ++++++++++++++++-------------------
 1 file changed, 16 insertions(+), 19 deletions(-)

diff --git a/net/sctp/socket.c b/net/sctp/socket.c
index 874cec73153052..ac7dff849290dc 100644
--- a/net/sctp/socket.c
+++ b/net/sctp/socket.c
@@ -3482,12 +3482,13 @@ static int sctp_setsockopt_partial_delivery_point(struct sock *sk, u32 *val,
  * future associations inheriting the socket value.
  */
 static int sctp_setsockopt_maxburst(struct sock *sk,
-				    char __user *optval,
+				    struct sctp_assoc_value *params,
 				    unsigned int optlen)
 {
 	struct sctp_sock *sp = sctp_sk(sk);
-	struct sctp_assoc_value params;
 	struct sctp_association *asoc;
+	sctp_assoc_t assoc_id;
+	u32 assoc_value;
 
 	if (optlen == sizeof(int)) {
 		pr_warn_ratelimited(DEPRECATED
@@ -3495,37 +3496,33 @@ static int sctp_setsockopt_maxburst(struct sock *sk,
 				    "Use of int in max_burst socket option deprecated.\n"
 				    "Use struct sctp_assoc_value instead\n",
 				    current->comm, task_pid_nr(current));
-		if (copy_from_user(&params.assoc_value, optval, optlen))
-			return -EFAULT;
-		params.assoc_id = SCTP_FUTURE_ASSOC;
+		assoc_id = SCTP_FUTURE_ASSOC;
+		assoc_value = *((int *)params);
 	} else if (optlen == sizeof(struct sctp_assoc_value)) {
-		if (copy_from_user(&params, optval, optlen))
-			return -EFAULT;
+		assoc_id = params->assoc_id;
+		assoc_value = params->assoc_value;
 	} else
 		return -EINVAL;
 
-	asoc = sctp_id2assoc(sk, params.assoc_id);
-	if (!asoc && params.assoc_id > SCTP_ALL_ASSOC &&
-	    sctp_style(sk, UDP))
+	asoc = sctp_id2assoc(sk, assoc_id);
+	if (!asoc && assoc_id > SCTP_ALL_ASSOC && sctp_style(sk, UDP))
 		return -EINVAL;
 
 	if (asoc) {
-		asoc->max_burst = params.assoc_value;
+		asoc->max_burst = assoc_value;
 
 		return 0;
 	}
 
 	if (sctp_style(sk, TCP))
-		params.assoc_id = SCTP_FUTURE_ASSOC;
+		assoc_id = SCTP_FUTURE_ASSOC;
 
-	if (params.assoc_id == SCTP_FUTURE_ASSOC ||
-	    params.assoc_id == SCTP_ALL_ASSOC)
-		sp->max_burst = params.assoc_value;
+	if (assoc_id == SCTP_FUTURE_ASSOC || assoc_id == SCTP_ALL_ASSOC)
+		sp->max_burst = assoc_value;
 
-	if (params.assoc_id == SCTP_CURRENT_ASSOC ||
-	    params.assoc_id == SCTP_ALL_ASSOC)
+	if (assoc_id == SCTP_CURRENT_ASSOC || assoc_id == SCTP_ALL_ASSOC)
 		list_for_each_entry(asoc, &sp->ep->asocs, asocs)
-			asoc->max_burst = params.assoc_value;
+			asoc->max_burst = assoc_value;
 
 	return 0;
 }
@@ -4699,7 +4696,7 @@ static int sctp_setsockopt(struct sock *sk, int level, int optname,
 		retval = sctp_setsockopt_fragment_interleave(sk, kopt, optlen);
 		break;
 	case SCTP_MAX_BURST:
-		retval = sctp_setsockopt_maxburst(sk, optval, optlen);
+		retval = sctp_setsockopt_maxburst(sk, kopt, optlen);
 		break;
 	case SCTP_AUTH_CHUNK:
 		retval = sctp_setsockopt_auth_chunk(sk, optval, optlen);
-- 
2.27.0

