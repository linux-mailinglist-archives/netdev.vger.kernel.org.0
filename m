Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B0E8D22506D
	for <lists+netdev@lfdr.de>; Sun, 19 Jul 2020 09:25:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727112AbgGSHYc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 Jul 2020 03:24:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52440 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726109AbgGSHWq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 19 Jul 2020 03:22:46 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8DE86C0619D4;
        Sun, 19 Jul 2020 00:22:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=nPaXfX/MyeqGLqLcmHNjFY7YTJVViKyrPdfCPkMIHUs=; b=ftIIG8Gx54kjVxrLcaFxyb/Wnz
        /KAnE15g04yLbZq8sLnqgIpFOsN10jq7Zb8cB12BIPVE0LbeIZgdcSyqZg1U4zkCxiPqDpj/A3JQc
        0kIJMO/AmP7YsLpdXC7wt1xyAOghgQnpcwlgs06ywUa0XREU9iFTLjqfsyinuc6fmpUwZwh4gX3aN
        xU/azRRULpL0B2/rtXVu0akK6gO+GbsT45R0B+XDCE4HtIp5gqswMA6G8CVhsJ6qFE3PEuikrta//
        U+jCwoUjblfLMZcg5NGLncIAeRpFahy2CWDdrsst3o2ErL9doEH7nle78UGrScWZCZzfRkuWbEbT3
        HlB86VJw==;
Received: from [2001:4bb8:105:4a81:4ef5:9f24:cda4:103f] (helo=localhost)
        by casper.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jx3eg-0000QX-VU; Sun, 19 Jul 2020 07:22:39 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     Vlad Yasevich <vyasevich@gmail.com>,
        Neil Horman <nhorman@tuxdriver.com>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        David Laight <David.Laight@ACULAB.COM>,
        linux-sctp@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH 07/51] sctp: pass a kernel pointer to sctp_setsockopt_peer_addr_params
Date:   Sun, 19 Jul 2020 09:21:44 +0200
Message-Id: <20200719072228.112645-8-hch@lst.de>
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
 net/sctp/socket.c | 44 +++++++++++++++++++-------------------------
 1 file changed, 19 insertions(+), 25 deletions(-)

diff --git a/net/sctp/socket.c b/net/sctp/socket.c
index d7ed8c6ea3754f..19308c327b6d2f 100644
--- a/net/sctp/socket.c
+++ b/net/sctp/socket.c
@@ -2589,48 +2589,42 @@ static int sctp_apply_peer_addr_params(struct sctp_paddrparams *params,
 }
 
 static int sctp_setsockopt_peer_addr_params(struct sock *sk,
-					    char __user *optval,
+					    struct sctp_paddrparams *params,
 					    unsigned int optlen)
 {
-	struct sctp_paddrparams  params;
 	struct sctp_transport   *trans = NULL;
 	struct sctp_association *asoc = NULL;
 	struct sctp_sock        *sp = sctp_sk(sk);
 	int error;
 	int hb_change, pmtud_change, sackdelay_change;
 
-	if (optlen == sizeof(params)) {
-		if (copy_from_user(&params, optval, optlen))
-			return -EFAULT;
-	} else if (optlen == ALIGN(offsetof(struct sctp_paddrparams,
+	if (optlen == ALIGN(offsetof(struct sctp_paddrparams,
 					    spp_ipv6_flowlabel), 4)) {
-		if (copy_from_user(&params, optval, optlen))
-			return -EFAULT;
-		if (params.spp_flags & (SPP_DSCP | SPP_IPV6_FLOWLABEL))
+		if (params->spp_flags & (SPP_DSCP | SPP_IPV6_FLOWLABEL))
 			return -EINVAL;
-	} else {
+	} else if (optlen != sizeof(*params)) {
 		return -EINVAL;
 	}
 
 	/* Validate flags and value parameters. */
-	hb_change        = params.spp_flags & SPP_HB;
-	pmtud_change     = params.spp_flags & SPP_PMTUD;
-	sackdelay_change = params.spp_flags & SPP_SACKDELAY;
+	hb_change        = params->spp_flags & SPP_HB;
+	pmtud_change     = params->spp_flags & SPP_PMTUD;
+	sackdelay_change = params->spp_flags & SPP_SACKDELAY;
 
 	if (hb_change        == SPP_HB ||
 	    pmtud_change     == SPP_PMTUD ||
 	    sackdelay_change == SPP_SACKDELAY ||
-	    params.spp_sackdelay > 500 ||
-	    (params.spp_pathmtu &&
-	     params.spp_pathmtu < SCTP_DEFAULT_MINSEGMENT))
+	    params->spp_sackdelay > 500 ||
+	    (params->spp_pathmtu &&
+	     params->spp_pathmtu < SCTP_DEFAULT_MINSEGMENT))
 		return -EINVAL;
 
 	/* If an address other than INADDR_ANY is specified, and
 	 * no transport is found, then the request is invalid.
 	 */
-	if (!sctp_is_any(sk, (union sctp_addr *)&params.spp_address)) {
-		trans = sctp_addr_id2transport(sk, &params.spp_address,
-					       params.spp_assoc_id);
+	if (!sctp_is_any(sk, (union sctp_addr *)&params->spp_address)) {
+		trans = sctp_addr_id2transport(sk, &params->spp_address,
+					       params->spp_assoc_id);
 		if (!trans)
 			return -EINVAL;
 	}
@@ -2639,19 +2633,19 @@ static int sctp_setsockopt_peer_addr_params(struct sock *sk,
 	 * socket is a one to many style socket, and an association
 	 * was not found, then the id was invalid.
 	 */
-	asoc = sctp_id2assoc(sk, params.spp_assoc_id);
-	if (!asoc && params.spp_assoc_id != SCTP_FUTURE_ASSOC &&
+	asoc = sctp_id2assoc(sk, params->spp_assoc_id);
+	if (!asoc && params->spp_assoc_id != SCTP_FUTURE_ASSOC &&
 	    sctp_style(sk, UDP))
 		return -EINVAL;
 
 	/* Heartbeat demand can only be sent on a transport or
 	 * association, but not a socket.
 	 */
-	if (params.spp_flags & SPP_HB_DEMAND && !trans && !asoc)
+	if (params->spp_flags & SPP_HB_DEMAND && !trans && !asoc)
 		return -EINVAL;
 
 	/* Process parameters. */
-	error = sctp_apply_peer_addr_params(&params, trans, asoc, sp,
+	error = sctp_apply_peer_addr_params(params, trans, asoc, sp,
 					    hb_change, pmtud_change,
 					    sackdelay_change);
 
@@ -2664,7 +2658,7 @@ static int sctp_setsockopt_peer_addr_params(struct sock *sk,
 	if (!trans && asoc) {
 		list_for_each_entry(trans, &asoc->peer.transport_addr_list,
 				transports) {
-			sctp_apply_peer_addr_params(&params, trans, asoc, sp,
+			sctp_apply_peer_addr_params(params, trans, asoc, sp,
 						    hb_change, pmtud_change,
 						    sackdelay_change);
 		}
@@ -4699,7 +4693,7 @@ static int sctp_setsockopt(struct sock *sk, int level, int optname,
 		break;
 
 	case SCTP_PEER_ADDR_PARAMS:
-		retval = sctp_setsockopt_peer_addr_params(sk, optval, optlen);
+		retval = sctp_setsockopt_peer_addr_params(sk, kopt, optlen);
 		break;
 
 	case SCTP_DELAYED_SACK:
-- 
2.27.0

