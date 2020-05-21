Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 430031DD4D4
	for <lists+netdev@lfdr.de>; Thu, 21 May 2020 19:50:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728566AbgEURsC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 May 2020 13:48:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57804 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729029AbgEURsA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 May 2020 13:48:00 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D0FD6C061A0E;
        Thu, 21 May 2020 10:48:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=bS6Y+lXQ+27B/XDpjE1wmX5B7Q4+DMl5B1QNbp0AoGs=; b=axRM8KZNDR46W0eq1TQK1g97H1
        6gbg9uxS40NERa3ZW0ahQ4Qwp8C6sPxZprVXtKsM9iuttsm6gbzsba3JF2RDeEjGzYuZT15zPhWeT
        mU/pvBGBnMEwctGSlUXKhC42ISxZ5A/1QLdcx/NU7daPEqlvP5ufWHxKv8/mnvgSqbTPpgc0kuIq9
        92rb8hTvrJChU+ZygILwXVajSgVLic8d82S0EWLlyeYXJH99tTRbC4/QOhLVYCcwSnZl8lJVvlqbx
        KIz9lUSnvy2FWwKQnYKe9wHbMvBCzmzf1n83mkAC83RqJ0YQ0Wa5V57tpC3D4i+pdCzwfoJmnf2+V
        yEPkMbsA==;
Received: from [2001:4bb8:18c:5da7:c70:4a89:bc61:2] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jbpIM-00039P-Md; Thu, 21 May 2020 17:47:51 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     Vlad Yasevich <vyasevich@gmail.com>,
        Neil Horman <nhorman@tuxdriver.com>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        David Laight <David.Laight@ACULAB.COM>,
        linux-sctp@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH 08/49] sctp: pass a kernel pointer to sctp_setsockopt_delayed_ack
Date:   Thu, 21 May 2020 19:46:43 +0200
Message-Id: <20200521174724.2635475-9-hch@lst.de>
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
 net/sctp/socket.c | 49 +++++++++++++++++++++--------------------------
 1 file changed, 22 insertions(+), 27 deletions(-)

diff --git a/net/sctp/socket.c b/net/sctp/socket.c
index 0498cf21923e8..3763f124f9fea 100644
--- a/net/sctp/socket.c
+++ b/net/sctp/socket.c
@@ -2748,17 +2748,14 @@ static void sctp_apply_asoc_delayed_ack(struct sctp_sack_info *params,
  */
 
 static int sctp_setsockopt_delayed_ack(struct sock *sk,
-				       char __user *optval, unsigned int optlen)
+				       struct sctp_sack_info *params,
+				       unsigned int optlen)
 {
 	struct sctp_sock *sp = sctp_sk(sk);
 	struct sctp_association *asoc;
-	struct sctp_sack_info params;
 
 	if (optlen == sizeof(struct sctp_sack_info)) {
-		if (copy_from_user(&params, optval, optlen))
-			return -EFAULT;
-
-		if (params.sack_delay == 0 && params.sack_freq == 0)
+		if (params->sack_delay == 0 && params->sack_freq == 0)
 			return 0;
 	} else if (optlen == sizeof(struct sctp_assoc_value)) {
 		pr_warn_ratelimited(DEPRECATED
@@ -2766,59 +2763,57 @@ static int sctp_setsockopt_delayed_ack(struct sock *sk,
 				    "Use of struct sctp_assoc_value in delayed_ack socket option.\n"
 				    "Use struct sctp_sack_info instead\n",
 				    current->comm, task_pid_nr(current));
-		if (copy_from_user(&params, optval, optlen))
-			return -EFAULT;
 
-		if (params.sack_delay == 0)
-			params.sack_freq = 1;
+		if (params->sack_delay == 0)
+			params->sack_freq = 1;
 		else
-			params.sack_freq = 0;
+			params->sack_freq = 0;
 	} else
 		return -EINVAL;
 
 	/* Validate value parameter. */
-	if (params.sack_delay > 500)
+	if (params->sack_delay > 500)
 		return -EINVAL;
 
 	/* Get association, if sack_assoc_id != SCTP_FUTURE_ASSOC and the
 	 * socket is a one to many style socket, and an association
 	 * was not found, then the id was invalid.
 	 */
-	asoc = sctp_id2assoc(sk, params.sack_assoc_id);
-	if (!asoc && params.sack_assoc_id > SCTP_ALL_ASSOC &&
+	asoc = sctp_id2assoc(sk, params->sack_assoc_id);
+	if (!asoc && params->sack_assoc_id > SCTP_ALL_ASSOC &&
 	    sctp_style(sk, UDP))
 		return -EINVAL;
 
 	if (asoc) {
-		sctp_apply_asoc_delayed_ack(&params, asoc);
+		sctp_apply_asoc_delayed_ack(params, asoc);
 
 		return 0;
 	}
 
 	if (sctp_style(sk, TCP))
-		params.sack_assoc_id = SCTP_FUTURE_ASSOC;
+		params->sack_assoc_id = SCTP_FUTURE_ASSOC;
 
-	if (params.sack_assoc_id == SCTP_FUTURE_ASSOC ||
-	    params.sack_assoc_id == SCTP_ALL_ASSOC) {
-		if (params.sack_delay) {
-			sp->sackdelay = params.sack_delay;
+	if (params->sack_assoc_id == SCTP_FUTURE_ASSOC ||
+	    params->sack_assoc_id == SCTP_ALL_ASSOC) {
+		if (params->sack_delay) {
+			sp->sackdelay = params->sack_delay;
 			sp->param_flags =
 				sctp_spp_sackdelay_enable(sp->param_flags);
 		}
-		if (params.sack_freq == 1) {
+		if (params->sack_freq == 1) {
 			sp->param_flags =
 				sctp_spp_sackdelay_disable(sp->param_flags);
-		} else if (params.sack_freq > 1) {
-			sp->sackfreq = params.sack_freq;
+		} else if (params->sack_freq > 1) {
+			sp->sackfreq = params->sack_freq;
 			sp->param_flags =
 				sctp_spp_sackdelay_enable(sp->param_flags);
 		}
 	}
 
-	if (params.sack_assoc_id == SCTP_CURRENT_ASSOC ||
-	    params.sack_assoc_id == SCTP_ALL_ASSOC)
+	if (params->sack_assoc_id == SCTP_CURRENT_ASSOC ||
+	    params->sack_assoc_id == SCTP_ALL_ASSOC)
 		list_for_each_entry(asoc, &sp->ep->asocs, asocs)
-			sctp_apply_asoc_delayed_ack(&params, asoc);
+			sctp_apply_asoc_delayed_ack(params, asoc);
 
 	return 0;
 }
@@ -4694,7 +4689,7 @@ static int sctp_setsockopt(struct sock *sk, int level, int optname,
 		break;
 
 	case SCTP_DELAYED_SACK:
-		retval = sctp_setsockopt_delayed_ack(sk, optval, optlen);
+		retval = sctp_setsockopt_delayed_ack(sk, kopt, optlen);
 		break;
 	case SCTP_PARTIAL_DELIVERY_POINT:
 		retval = sctp_setsockopt_partial_delivery_point(sk, optval, optlen);
-- 
2.26.2

