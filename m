Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A54DE225013
	for <lists+netdev@lfdr.de>; Sun, 19 Jul 2020 09:22:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726492AbgGSHW6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 Jul 2020 03:22:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52474 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726419AbgGSHWy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 19 Jul 2020 03:22:54 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 29C6CC0619D6;
        Sun, 19 Jul 2020 00:22:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=EocU4PatEiZcQw9QG/xMA5XqMNtT3B2IIsEvr/owMXM=; b=JGqS1ajK6W6O+CHTncEVBWeQ6s
        SRuxcd+pBgPwNmc3BWcqdYcZObiR5exVAunPvml7Rl75aSD8C/xiY+u11HriLp6nDuozLRl7UH0/0
        jonFH7cy4C6Ca6DVZjzYUGntXdUBi3irm5bWeaKz4GatvCxtB4/Kl8XxUbAh2TA1o5uLiq6xS/M76
        zQENbqImnoaOcZZu8RDaFa+hjdxcnJblYUP+opoYeVaRIYZzVxlltULwJi9dpuKJBPUGjQfLtQz+2
        7TZjDtuehtyKfFkUK58WWRZRmO4WfBq8zes/AJU+8OFESmnSTKzQUwN05B72EQzWD2btO2ZbELiyu
        9wAYMKpA==;
Received: from [2001:4bb8:105:4a81:4ef5:9f24:cda4:103f] (helo=localhost)
        by casper.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jx3ep-0000SI-8J; Sun, 19 Jul 2020 07:22:47 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     Vlad Yasevich <vyasevich@gmail.com>,
        Neil Horman <nhorman@tuxdriver.com>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        David Laight <David.Laight@ACULAB.COM>,
        linux-sctp@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH 13/51] sctp: pass a kernel pointer to sctp_setsockopt_primary_addr
Date:   Sun, 19 Jul 2020 09:21:50 +0200
Message-Id: <20200719072228.112645-14-hch@lst.de>
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
 net/sctp/socket.c | 14 +++++---------
 1 file changed, 5 insertions(+), 9 deletions(-)

diff --git a/net/sctp/socket.c b/net/sctp/socket.c
index 6695fa1cb0ca8f..abdec7b412bcbc 100644
--- a/net/sctp/socket.c
+++ b/net/sctp/socket.c
@@ -2982,10 +2982,9 @@ static int sctp_setsockopt_default_sndinfo(struct sock *sk,
  * the association primary.  The enclosed address must be one of the
  * association peer's addresses.
  */
-static int sctp_setsockopt_primary_addr(struct sock *sk, char __user *optval,
+static int sctp_setsockopt_primary_addr(struct sock *sk, struct sctp_prim *prim,
 					unsigned int optlen)
 {
-	struct sctp_prim prim;
 	struct sctp_transport *trans;
 	struct sctp_af *af;
 	int err;
@@ -2993,21 +2992,18 @@ static int sctp_setsockopt_primary_addr(struct sock *sk, char __user *optval,
 	if (optlen != sizeof(struct sctp_prim))
 		return -EINVAL;
 
-	if (copy_from_user(&prim, optval, sizeof(struct sctp_prim)))
-		return -EFAULT;
-
 	/* Allow security module to validate address but need address len. */
-	af = sctp_get_af_specific(prim.ssp_addr.ss_family);
+	af = sctp_get_af_specific(prim->ssp_addr.ss_family);
 	if (!af)
 		return -EINVAL;
 
 	err = security_sctp_bind_connect(sk, SCTP_PRIMARY_ADDR,
-					 (struct sockaddr *)&prim.ssp_addr,
+					 (struct sockaddr *)&prim->ssp_addr,
 					 af->sockaddr_len);
 	if (err)
 		return err;
 
-	trans = sctp_addr_id2transport(sk, &prim.ssp_addr, prim.ssp_assoc_id);
+	trans = sctp_addr_id2transport(sk, &prim->ssp_addr, prim->ssp_assoc_id);
 	if (!trans)
 		return -EINVAL;
 
@@ -4695,7 +4691,7 @@ static int sctp_setsockopt(struct sock *sk, int level, int optname,
 		retval = sctp_setsockopt_default_sndinfo(sk, kopt, optlen);
 		break;
 	case SCTP_PRIMARY_ADDR:
-		retval = sctp_setsockopt_primary_addr(sk, optval, optlen);
+		retval = sctp_setsockopt_primary_addr(sk, kopt, optlen);
 		break;
 	case SCTP_SET_PEER_PRIMARY_ADDR:
 		retval = sctp_setsockopt_peer_primary_addr(sk, optval, optlen);
-- 
2.27.0

