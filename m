Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C25141DD4E5
	for <lists+netdev@lfdr.de>; Thu, 21 May 2020 19:50:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730171AbgEURsW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 May 2020 13:48:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57864 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727966AbgEURsU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 May 2020 13:48:20 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 35E67C061A0E;
        Thu, 21 May 2020 10:48:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=UijWnm5eSd4PckpUS4Tjc81iEuS4R7Ony9OCzxMc32s=; b=n9+DIAwski1au5E155UrPL9GNd
        8tCvRPE3bjsqn2TiUFNyzw8AWHinKaSsYQ9iEVfU3Tc57D3589eOcrhAcTU05AAE2/0ZDuJUA9026
        2Anfis4VL28nq8Kwm5vCGiUznSzWLdYfl/Pv1d+0GamUao7dxLjsXgFjEghgL4bUD3YX84fxQ0ocP
        7VRSng56nIL9EoStL5y75zBIbDVB4YL638zXiK7Nt995PK6Lelphgq/cVJy+ylGl21ZcOsv09KFiv
        YP6Rjiq4soQkmoLBhtyOk2OyzkPrKWITAX7qDmsnfhMaCDNUKJsSS98GAahmYaynqqSqxlQynWK50
        3bUdb2AQ==;
Received: from [2001:4bb8:18c:5da7:c70:4a89:bc61:2] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jbpIf-0003Ec-81; Thu, 21 May 2020 17:48:09 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     Vlad Yasevich <vyasevich@gmail.com>,
        Neil Horman <nhorman@tuxdriver.com>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        David Laight <David.Laight@ACULAB.COM>,
        linux-sctp@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH 15/49] sctp: pass a kernel pointer to sctp_setsockopt_nodelay
Date:   Thu, 21 May 2020 19:46:50 +0200
Message-Id: <20200521174724.2635475-16-hch@lst.de>
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
 net/sctp/socket.c | 11 +++--------
 1 file changed, 3 insertions(+), 8 deletions(-)

diff --git a/net/sctp/socket.c b/net/sctp/socket.c
index eb01992da7949..99df37bbcb903 100644
--- a/net/sctp/socket.c
+++ b/net/sctp/socket.c
@@ -3017,17 +3017,12 @@ static int sctp_setsockopt_primary_addr(struct sock *sk, struct sctp_prim *prim,
  * introduced, at the cost of more packets in the network.  Expects an
  *  integer boolean flag.
  */
-static int sctp_setsockopt_nodelay(struct sock *sk, char __user *optval,
+static int sctp_setsockopt_nodelay(struct sock *sk, int *val,
 				   unsigned int optlen)
 {
-	int val;
-
 	if (optlen < sizeof(int))
 		return -EINVAL;
-	if (get_user(val, (int __user *)optval))
-		return -EFAULT;
-
-	sctp_sk(sk)->nodelay = (val == 0) ? 0 : 1;
+	sctp_sk(sk)->nodelay = (*val == 0) ? 0 : 1;
 	return 0;
 }
 
@@ -4691,7 +4686,7 @@ static int sctp_setsockopt(struct sock *sk, int level, int optname,
 		retval = sctp_setsockopt_peer_primary_addr(sk, kopt, optlen);
 		break;
 	case SCTP_NODELAY:
-		retval = sctp_setsockopt_nodelay(sk, optval, optlen);
+		retval = sctp_setsockopt_nodelay(sk, kopt, optlen);
 		break;
 	case SCTP_RTOINFO:
 		retval = sctp_setsockopt_rtoinfo(sk, optval, optlen);
-- 
2.26.2

