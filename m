Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 72D41225010
	for <lists+netdev@lfdr.de>; Sun, 19 Jul 2020 09:22:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726424AbgGSHWy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 Jul 2020 03:22:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52442 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726021AbgGSHWr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 19 Jul 2020 03:22:47 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9FD41C0619D2;
        Sun, 19 Jul 2020 00:22:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=SEVj7OZZKd3KsEhYcBdAGAIPgTxmoqF3ugXprQd2fT4=; b=fclP+OSLei4jIIY7vPJsu4cS0N
        yHI6ztvlyRpXcidawUAIvuZnwzmHXGBbb5S2VKseLx2FJgopzA3OZotzw9v4wzqYLg8BEUXNc138Q
        z+MmATFtPJPVNf5GFYBrEPTGvbeE0BKw/YZx4RMuRDvE7oiW2IOMVBU2oFSUFgHIg1Uz/hRXAYwsf
        sUrY2xOaa7Y3tHiyxHvUBgnC9GwoMOZTdKN1YRgWQcQfGfL+B8Be7Ai7pnnP6quNIWABYs3C498EA
        41v73lEghOtqk6W5C9niVJmUMq6SLRq5PCFrmGnyoVNx6VjrV6kQ+nSol2rvQCuc4+gOE6e9kwfo1
        fCkXZXsw==;
Received: from [2001:4bb8:105:4a81:4ef5:9f24:cda4:103f] (helo=localhost)
        by casper.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jx3ei-0000RG-P9; Sun, 19 Jul 2020 07:22:41 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     Vlad Yasevich <vyasevich@gmail.com>,
        Neil Horman <nhorman@tuxdriver.com>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        David Laight <David.Laight@ACULAB.COM>,
        linux-sctp@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH 08/51] sctp: pass a kernel pointer to sctp_setsockopt_delayed_ack
Date:   Sun, 19 Jul 2020 09:21:45 +0200
Message-Id: <20200719072228.112645-9-hch@lst.de>
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
 net/sctp/socket.c | 49 +++++++++++++++++++++--------------------------
 1 file changed, 22 insertions(+), 27 deletions(-)

diff --git a/net/sctp/socket.c b/net/sctp/socket.c
index 19308c327b6d2f..2dfbd7f8799114 100644
--- a/net/sctp/socket.c
+++ b/net/sctp/socket.c
@@ -2751,17 +2751,14 @@ static void sctp_apply_asoc_delayed_ack(struct sctp_sack_info *params,
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
@@ -2769,59 +2766,57 @@ static int sctp_setsockopt_delayed_ack(struct sock *sk,
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
@@ -4697,7 +4692,7 @@ static int sctp_setsockopt(struct sock *sk, int level, int optname,
 		break;
 
 	case SCTP_DELAYED_SACK:
-		retval = sctp_setsockopt_delayed_ack(sk, optval, optlen);
+		retval = sctp_setsockopt_delayed_ack(sk, kopt, optlen);
 		break;
 	case SCTP_PARTIAL_DELIVERY_POINT:
 		retval = sctp_setsockopt_partial_delivery_point(sk, optval, optlen);
-- 
2.27.0

