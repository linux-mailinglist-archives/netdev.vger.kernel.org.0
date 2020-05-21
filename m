Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2F7ED1DD4F1
	for <lists+netdev@lfdr.de>; Thu, 21 May 2020 19:50:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730243AbgEURsj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 May 2020 13:48:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57908 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730199AbgEURsc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 May 2020 13:48:32 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D453C061A0E;
        Thu, 21 May 2020 10:48:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=1bjbzbcVhHMPlQGEvEog0coBv4aadRPsOd8JywRQ2Mo=; b=R/lfl1/D6cxge1zYoG6vGZAh9q
        k8y+fKvIU0cDAznBt0j/19gxckD5HMdk/EfCbZF6M4gWYPwrSsmCvqnwYJq2rl1lEOVDaBVBq28f9
        iGg3IUVUcy8UlyqRCr7kXps+Lnya79+D0K7yO24Bwvu0fFPv00QRT/3KzwUtglseWZs1MpZROuDAD
        kpjZ+tQi/FE4idUSZv/AIsAvlxgkcTlAAqGZ2esQlpQwACiW8VSJom1NZK0EohBkRFhUqHFgjtZcg
        cbsWsDBr+seXWlbq07zBBxSO/EOzDMsJM53vzmYbNWt67500Gf4nDsbC8nI5GeiJsxkkRzCJKibX5
        msTVw13g==;
Received: from [2001:4bb8:18c:5da7:c70:4a89:bc61:2] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jbpIu-0003HA-KV; Thu, 21 May 2020 17:48:25 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     Vlad Yasevich <vyasevich@gmail.com>,
        Neil Horman <nhorman@tuxdriver.com>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        David Laight <David.Laight@ACULAB.COM>,
        linux-sctp@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH 21/49] sctp: pass a kernel pointer to sctp_setsockopt_context
Date:   Thu, 21 May 2020 19:46:56 +0200
Message-Id: <20200521174724.2635475-22-hch@lst.de>
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
 net/sctp/socket.c | 28 +++++++++++++---------------
 1 file changed, 13 insertions(+), 15 deletions(-)

diff --git a/net/sctp/socket.c b/net/sctp/socket.c
index b7bf09f86a5e7..03577684be65f 100644
--- a/net/sctp/socket.c
+++ b/net/sctp/socket.c
@@ -3359,40 +3359,38 @@ static int sctp_setsockopt_adaptation_layer(struct sock *sk,
  * received messages from the peer and does not effect the value that is
  * saved with outbound messages.
  */
-static int sctp_setsockopt_context(struct sock *sk, char __user *optval,
+static int sctp_setsockopt_context(struct sock *sk,
+				   struct sctp_assoc_value *params,
 				   unsigned int optlen)
 {
 	struct sctp_sock *sp = sctp_sk(sk);
-	struct sctp_assoc_value params;
 	struct sctp_association *asoc;
 
 	if (optlen != sizeof(struct sctp_assoc_value))
 		return -EINVAL;
-	if (copy_from_user(&params, optval, optlen))
-		return -EFAULT;
 
-	asoc = sctp_id2assoc(sk, params.assoc_id);
-	if (!asoc && params.assoc_id > SCTP_ALL_ASSOC &&
+	asoc = sctp_id2assoc(sk, params->assoc_id);
+	if (!asoc && params->assoc_id > SCTP_ALL_ASSOC &&
 	    sctp_style(sk, UDP))
 		return -EINVAL;
 
 	if (asoc) {
-		asoc->default_rcv_context = params.assoc_value;
+		asoc->default_rcv_context = params->assoc_value;
 
 		return 0;
 	}
 
 	if (sctp_style(sk, TCP))
-		params.assoc_id = SCTP_FUTURE_ASSOC;
+		params->assoc_id = SCTP_FUTURE_ASSOC;
 
-	if (params.assoc_id == SCTP_FUTURE_ASSOC ||
-	    params.assoc_id == SCTP_ALL_ASSOC)
-		sp->default_rcv_context = params.assoc_value;
+	if (params->assoc_id == SCTP_FUTURE_ASSOC ||
+	    params->assoc_id == SCTP_ALL_ASSOC)
+		sp->default_rcv_context = params->assoc_value;
 
-	if (params.assoc_id == SCTP_CURRENT_ASSOC ||
-	    params.assoc_id == SCTP_ALL_ASSOC)
+	if (params->assoc_id == SCTP_CURRENT_ASSOC ||
+	    params->assoc_id == SCTP_ALL_ASSOC)
 		list_for_each_entry(asoc, &sp->ep->asocs, asocs)
-			asoc->default_rcv_context = params.assoc_value;
+			asoc->default_rcv_context = params->assoc_value;
 
 	return 0;
 }
@@ -4697,7 +4695,7 @@ static int sctp_setsockopt(struct sock *sk, int level, int optname,
 		retval = sctp_setsockopt_adaptation_layer(sk, kopt, optlen);
 		break;
 	case SCTP_CONTEXT:
-		retval = sctp_setsockopt_context(sk, optval, optlen);
+		retval = sctp_setsockopt_context(sk, kopt, optlen);
 		break;
 	case SCTP_FRAGMENT_INTERLEAVE:
 		retval = sctp_setsockopt_fragment_interleave(sk, optval, optlen);
-- 
2.26.2

