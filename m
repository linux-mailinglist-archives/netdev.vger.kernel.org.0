Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1090F1DD528
	for <lists+netdev@lfdr.de>; Thu, 21 May 2020 19:50:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730520AbgEURtq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 May 2020 13:49:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58152 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730508AbgEURtn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 May 2020 13:49:43 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 42D8DC061A0E;
        Thu, 21 May 2020 10:49:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=hlg9PhtMq4qIvbnOvkvQOtSSajyIqeX7z/RthfY2owo=; b=T3WARM4mmcg3ZRBQOB5go26p1v
        +OmSgw7E3eADgfitkfZx3szj6tofbpGmVbt7keJ8Po8okMMKzHDAaFCjlrunfy/2d1a264iOR8P+3
        eFZifa133Qend0A0ayxlok0TOwWfdBdiBZTQW1o3/MOfGCCXBIsy3VNtDJYgRoDUR5LFhBrSHNpce
        2Gpti01hYsbU4WRfgqtGK/tUSXET88X+fM909WC/pYTYHjWby+MWdE3FQ0ClEOgDaixeDJxnGllh/
        3nxFHGJiJfRYJLttyFiLP9d/Kl7GNdr1FbMgd3oJZ1Av7+AI2hn/Rp+BISPvTu6ZrmDXoyU/m/vku
        2IQTXV/Q==;
Received: from [2001:4bb8:18c:5da7:c70:4a89:bc61:2] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jbpK6-0003UX-DF; Thu, 21 May 2020 17:49:38 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     Vlad Yasevich <vyasevich@gmail.com>,
        Neil Horman <nhorman@tuxdriver.com>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        David Laight <David.Laight@ACULAB.COM>,
        linux-sctp@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH 49/49] sctp: pass a kernel pointer to sctp_setsockopt_pf_expose
Date:   Thu, 21 May 2020 19:47:24 +0200
Message-Id: <20200521174724.2635475-50-hch@lst.de>
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
 net/sctp/socket.c | 22 ++++++++--------------
 1 file changed, 8 insertions(+), 14 deletions(-)

diff --git a/net/sctp/socket.c b/net/sctp/socket.c
index f9f4776b0bbfd..ec87ac9965a01 100644
--- a/net/sctp/socket.c
+++ b/net/sctp/socket.c
@@ -4378,33 +4378,27 @@ static int sctp_setsockopt_ecn_supported(struct sock *sk,
 }
 
 static int sctp_setsockopt_pf_expose(struct sock *sk,
-				     char __user *optval,
+				     struct sctp_assoc_value *params,
 				     unsigned int optlen)
 {
-	struct sctp_assoc_value params;
 	struct sctp_association *asoc;
 	int retval = -EINVAL;
 
-	if (optlen != sizeof(params))
-		goto out;
-
-	if (copy_from_user(&params, optval, optlen)) {
-		retval = -EFAULT;
+	if (optlen != sizeof(*params))
 		goto out;
-	}
 
-	if (params.assoc_value > SCTP_PF_EXPOSE_MAX)
+	if (params->assoc_value > SCTP_PF_EXPOSE_MAX)
 		goto out;
 
-	asoc = sctp_id2assoc(sk, params.assoc_id);
-	if (!asoc && params.assoc_id != SCTP_FUTURE_ASSOC &&
+	asoc = sctp_id2assoc(sk, params->assoc_id);
+	if (!asoc && params->assoc_id != SCTP_FUTURE_ASSOC &&
 	    sctp_style(sk, UDP))
 		goto out;
 
 	if (asoc)
-		asoc->pf_expose = params.assoc_value;
+		asoc->pf_expose = params->assoc_value;
 	else
-		sctp_sk(sk)->pf_expose = params.assoc_value;
+		sctp_sk(sk)->pf_expose = params->assoc_value;
 	retval = 0;
 
 out:
@@ -4628,7 +4622,7 @@ static int sctp_setsockopt(struct sock *sk, int level, int optname,
 		retval = sctp_setsockopt_ecn_supported(sk, kopt, optlen);
 		break;
 	case SCTP_EXPOSE_POTENTIALLY_FAILED_STATE:
-		retval = sctp_setsockopt_pf_expose(sk, optval, optlen);
+		retval = sctp_setsockopt_pf_expose(sk, kopt, optlen);
 		break;
 	default:
 		retval = -ENOPROTOOPT;
-- 
2.26.2

