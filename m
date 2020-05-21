Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 233681DD500
	for <lists+netdev@lfdr.de>; Thu, 21 May 2020 19:50:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730375AbgEURsx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 May 2020 13:48:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57970 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730360AbgEURsv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 May 2020 13:48:51 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E77B6C061A0E;
        Thu, 21 May 2020 10:48:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=EyTh8jKUVz6ibAoFQVaOKMX2G5rzIm9lLEOHyYe+u7M=; b=eiWMfLQgmSHxlvYb9s9NSxEiW2
        +4xFlgU3zeAlawEcFJRStCq0wSMtBs0xKOKzmUFOJQHzSNxhhJ0ii6FbdHFjvNvvi+YUxsu2Opy3s
        p9hW7lgSHskGvJJH22ualQBxSXuvKiQJN1TXc0b9G1PWerGbMVdtm/4sVysGL/v3LQUe3TE1qItQW
        w1yn0H+vW1gk5VSn2QhtfFZ36l7Du8VOR0qYPCxJs/3j/86OFSKV1rpotOQvxqzMlawILtJvaxXaD
        ScSlg73ijZ7C4joijdBQvqNjArfyzJuE4woUNjYFu8MzCHAgK/XY60G5adG/yW0HVADF/Z4WFO3GN
        9Q2u7Qdg==;
Received: from [2001:4bb8:18c:5da7:c70:4a89:bc61:2] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jbpJF-0003KF-JT; Thu, 21 May 2020 17:48:46 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     Vlad Yasevich <vyasevich@gmail.com>,
        Neil Horman <nhorman@tuxdriver.com>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        David Laight <David.Laight@ACULAB.COM>,
        linux-sctp@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH 29/49] sctp: pass a kernel pointer to sctp_setsockopt_deactivate_key
Date:   Thu, 21 May 2020 19:47:04 +0200
Message-Id: <20200521174724.2635475-30-hch@lst.de>
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
index a664e9eb323fb..1631760e4b0af 100644
--- a/net/sctp/socket.c
+++ b/net/sctp/socket.c
@@ -3746,42 +3746,40 @@ static int sctp_setsockopt_del_key(struct sock *sk,
  *
  * This set option will deactivate a shared secret key.
  */
-static int sctp_setsockopt_deactivate_key(struct sock *sk, char __user *optval,
+static int sctp_setsockopt_deactivate_key(struct sock *sk,
+					  struct sctp_authkeyid *val,
 					  unsigned int optlen)
 {
 	struct sctp_endpoint *ep = sctp_sk(sk)->ep;
 	struct sctp_association *asoc;
-	struct sctp_authkeyid val;
 	int ret = 0;
 
 	if (optlen != sizeof(struct sctp_authkeyid))
 		return -EINVAL;
-	if (copy_from_user(&val, optval, optlen))
-		return -EFAULT;
 
-	asoc = sctp_id2assoc(sk, val.scact_assoc_id);
-	if (!asoc && val.scact_assoc_id > SCTP_ALL_ASSOC &&
+	asoc = sctp_id2assoc(sk, val->scact_assoc_id);
+	if (!asoc && val->scact_assoc_id > SCTP_ALL_ASSOC &&
 	    sctp_style(sk, UDP))
 		return -EINVAL;
 
 	if (asoc)
-		return sctp_auth_deact_key_id(ep, asoc, val.scact_keynumber);
+		return sctp_auth_deact_key_id(ep, asoc, val->scact_keynumber);
 
 	if (sctp_style(sk, TCP))
-		val.scact_assoc_id = SCTP_FUTURE_ASSOC;
+		val->scact_assoc_id = SCTP_FUTURE_ASSOC;
 
-	if (val.scact_assoc_id == SCTP_FUTURE_ASSOC ||
-	    val.scact_assoc_id == SCTP_ALL_ASSOC) {
-		ret = sctp_auth_deact_key_id(ep, asoc, val.scact_keynumber);
+	if (val->scact_assoc_id == SCTP_FUTURE_ASSOC ||
+	    val->scact_assoc_id == SCTP_ALL_ASSOC) {
+		ret = sctp_auth_deact_key_id(ep, asoc, val->scact_keynumber);
 		if (ret)
 			return ret;
 	}
 
-	if (val.scact_assoc_id == SCTP_CURRENT_ASSOC ||
-	    val.scact_assoc_id == SCTP_ALL_ASSOC) {
+	if (val->scact_assoc_id == SCTP_CURRENT_ASSOC ||
+	    val->scact_assoc_id == SCTP_ALL_ASSOC) {
 		list_for_each_entry(asoc, &ep->asocs, asocs) {
 			int res = sctp_auth_deact_key_id(ep, asoc,
-							 val.scact_keynumber);
+							 val->scact_keynumber);
 
 			if (res && !ret)
 				ret = res;
@@ -4685,7 +4683,7 @@ static int sctp_setsockopt(struct sock *sk, int level, int optname,
 		retval = sctp_setsockopt_del_key(sk, kopt, optlen);
 		break;
 	case SCTP_AUTH_DEACTIVATE_KEY:
-		retval = sctp_setsockopt_deactivate_key(sk, optval, optlen);
+		retval = sctp_setsockopt_deactivate_key(sk, kopt, optlen);
 		break;
 	case SCTP_AUTO_ASCONF:
 		retval = sctp_setsockopt_auto_asconf(sk, optval, optlen);
-- 
2.26.2

