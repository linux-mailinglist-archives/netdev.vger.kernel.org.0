Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 488161DD4EF
	for <lists+netdev@lfdr.de>; Thu, 21 May 2020 19:50:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730234AbgEURsg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 May 2020 13:48:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57910 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730202AbgEURsc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 May 2020 13:48:32 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BFB83C061A0F;
        Thu, 21 May 2020 10:48:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=cdPcM43kwhnzu08nHbdkuXhzmXPI/qw9gFRQ/Nm5qbE=; b=jXGgIc9HSnfo3M1GnmmAxDihM0
        shfTrk6tQrwiAzQgqQ4JeChpVJ766U9DyIhni6s9nhcvL+uSL7izUAPPOtYjy5YhQEW0kUFXstqRW
        voU3pxRMgsvag6BEB7Th0xqQhpCyVoKill/Cqb64t2kSzfYQGhVfvxSZLwVVeUIwvW+sJJ60VmE28
        Rqa7m5HJQJWz+Qt2gM/P0t8X2NYdPwPwbmDKb5mns14FJeI0g9E6ncC4+3aay0FSq1UzZc5JW+h9Q
        64OcORXB9zm1CwzkbF0mqlhacM0dSZzWkuz6qlmvGRfrMC3+X24TS23MUQV20X97VOnRCy2NcFI41
        cNtiutxg==;
Received: from [2001:4bb8:18c:5da7:c70:4a89:bc61:2] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jbpIz-0003Hr-MQ; Thu, 21 May 2020 17:48:30 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     Vlad Yasevich <vyasevich@gmail.com>,
        Neil Horman <nhorman@tuxdriver.com>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        David Laight <David.Laight@ACULAB.COM>,
        linux-sctp@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH 23/49] sctp: pass a kernel pointer to sctp_setsockopt_maxburst
Date:   Thu, 21 May 2020 19:46:58 +0200
Message-Id: <20200521174724.2635475-24-hch@lst.de>
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
 net/sctp/socket.c | 35 ++++++++++++++++-------------------
 1 file changed, 16 insertions(+), 19 deletions(-)

diff --git a/net/sctp/socket.c b/net/sctp/socket.c
index 249a87014e879..e62e8dbe961ec 100644
--- a/net/sctp/socket.c
+++ b/net/sctp/socket.c
@@ -3479,12 +3479,13 @@ static int sctp_setsockopt_partial_delivery_point(struct sock *sk, u32 *val,
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
@@ -3492,37 +3493,33 @@ static int sctp_setsockopt_maxburst(struct sock *sk,
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
@@ -4696,7 +4693,7 @@ static int sctp_setsockopt(struct sock *sk, int level, int optname,
 		retval = sctp_setsockopt_fragment_interleave(sk, kopt, optlen);
 		break;
 	case SCTP_MAX_BURST:
-		retval = sctp_setsockopt_maxburst(sk, optval, optlen);
+		retval = sctp_setsockopt_maxburst(sk, kopt, optlen);
 		break;
 	case SCTP_AUTH_CHUNK:
 		retval = sctp_setsockopt_auth_chunk(sk, optval, optlen);
-- 
2.26.2

