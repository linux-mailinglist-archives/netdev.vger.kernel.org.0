Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C4B33225027
	for <lists+netdev@lfdr.de>; Sun, 19 Jul 2020 09:23:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726740AbgGSHX0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 Jul 2020 03:23:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52588 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726658AbgGSHXW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 19 Jul 2020 03:23:22 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C19B2C0619D2;
        Sun, 19 Jul 2020 00:23:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=ORSZPxap1HBmONI89ZgzA1uPYGeemObvL4jgu15FMJI=; b=KzBXPeIGbH/gxzMHixSJRZ0t+y
        2syv9A+oDfLNFiTAMZamyNqsvRFni/k4x887qRvw19nq1DlJeADtp2372vwnJ7suCvGU4sEUfTVyG
        ckPtE6bSbzucg0rWFG5MwVkCrvrwZk0/R/5VuV5MpXRuRIdP0y49ZdBUXBV9gRrwPg6X+NMslM852
        j0WZavHgRoSrTjj6z8E5Z9fiNjLh04EnyekL/YbRBf55+PVRDKZFvVpy47ehr3A9LC+EEtyf8DRaR
        3wSCgADTtZMfe6qV3yeOwO25I0pqd8Mgl3IsmiYBovdNK2lcnw1jCB5fc1irX3TMOcenR/haftJrY
        GeXYBDrw==;
Received: from [2001:4bb8:105:4a81:4ef5:9f24:cda4:103f] (helo=localhost)
        by casper.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jx3fK-0000WV-Ko; Sun, 19 Jul 2020 07:23:19 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     Vlad Yasevich <vyasevich@gmail.com>,
        Neil Horman <nhorman@tuxdriver.com>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        David Laight <David.Laight@ACULAB.COM>,
        linux-sctp@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH 37/51] sctp: pass a kernel pointer to sctp_setsockopt_reconfig_supported
Date:   Sun, 19 Jul 2020 09:22:14 +0200
Message-Id: <20200719072228.112645-38-hch@lst.de>
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
 net/sctp/socket.c | 18 ++++++------------
 1 file changed, 6 insertions(+), 12 deletions(-)

diff --git a/net/sctp/socket.c b/net/sctp/socket.c
index 0eeb6e6162ad61..270c5d53fbf7c3 100644
--- a/net/sctp/socket.c
+++ b/net/sctp/socket.c
@@ -3996,27 +3996,21 @@ static int sctp_setsockopt_default_prinfo(struct sock *sk,
 }
 
 static int sctp_setsockopt_reconfig_supported(struct sock *sk,
-					      char __user *optval,
+					      struct sctp_assoc_value *params,
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
 
-	asoc = sctp_id2assoc(sk, params.assoc_id);
-	if (!asoc && params.assoc_id != SCTP_FUTURE_ASSOC &&
+	asoc = sctp_id2assoc(sk, params->assoc_id);
+	if (!asoc && params->assoc_id != SCTP_FUTURE_ASSOC &&
 	    sctp_style(sk, UDP))
 		goto out;
 
-	sctp_sk(sk)->ep->reconf_enable = !!params.assoc_value;
+	sctp_sk(sk)->ep->reconf_enable = !!params->assoc_value;
 
 	retval = 0;
 
@@ -4688,7 +4682,7 @@ static int sctp_setsockopt(struct sock *sk, int level, int optname,
 		retval = sctp_setsockopt_default_prinfo(sk, kopt, optlen);
 		break;
 	case SCTP_RECONFIG_SUPPORTED:
-		retval = sctp_setsockopt_reconfig_supported(sk, optval, optlen);
+		retval = sctp_setsockopt_reconfig_supported(sk, kopt, optlen);
 		break;
 	case SCTP_ENABLE_STREAM_RESET:
 		retval = sctp_setsockopt_enable_strreset(sk, optval, optlen);
-- 
2.27.0

