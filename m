Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A78141DD51C
	for <lists+netdev@lfdr.de>; Thu, 21 May 2020 19:50:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730476AbgEURt3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 May 2020 13:49:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58096 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730465AbgEURt1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 May 2020 13:49:27 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 04AC7C061A0F;
        Thu, 21 May 2020 10:49:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=v+B4BV/xA6DjS0kW0boUkA4h0Xbsm1NPqVRDH6vp0+A=; b=cH16Phun8z1JM/mOEmAZdiDlhs
        w5wISreF4pJ6EiIY2hgZQ20Bk0uWoUQzHMKThpJnq+5uSUFsmPddHNST+L/32Eb+NjP4iUxE9NoTs
        kza7ynrTNY4sQWULliZNYFV0TRvRUBgmkSRxu/SXQMcnDXSaBw65BxPbAe0CyQCfXlsPuHy/RZmm9
        V/AxB5+lgvR3zomfAkXjcFCGDNMV+io4ocVyMzpnZU6Yzb/EOIc7f/ye9Pax5G/EzCTasP6LxntGL
        SjLEEchOX3gw6eG9oT5FgvTidJOEFOVSFQZlFoihLN4zIikHPgGpzPIWnUsNcI9BAgNOhHVZtUEVV
        yFa2eADQ==;
Received: from [2001:4bb8:18c:5da7:c70:4a89:bc61:2] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jbpJq-0003Qx-EW; Thu, 21 May 2020 17:49:22 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     Vlad Yasevich <vyasevich@gmail.com>,
        Neil Horman <nhorman@tuxdriver.com>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        David Laight <David.Laight@ACULAB.COM>,
        linux-sctp@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH 43/49] sctp: pass a kernel pointer to sctp_setsockopt_interleaving_supported
Date:   Thu, 21 May 2020 19:47:18 +0200
Message-Id: <20200521174724.2635475-44-hch@lst.de>
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
 net/sctp/socket.c | 34 ++++++++++------------------------
 1 file changed, 10 insertions(+), 24 deletions(-)

diff --git a/net/sctp/socket.c b/net/sctp/socket.c
index 4d61c2885f8f2..48229ffabbaee 100644
--- a/net/sctp/socket.c
+++ b/net/sctp/socket.c
@@ -4189,39 +4189,25 @@ static int sctp_setsockopt_scheduler_value(struct sock *sk,
 }
 
 static int sctp_setsockopt_interleaving_supported(struct sock *sk,
-						  char __user *optval,
+						  struct sctp_assoc_value *p,
 						  unsigned int optlen)
 {
 	struct sctp_sock *sp = sctp_sk(sk);
-	struct sctp_assoc_value params;
 	struct sctp_association *asoc;
-	int retval = -EINVAL;
 
-	if (optlen < sizeof(params))
-		goto out;
-
-	optlen = sizeof(params);
-	if (copy_from_user(&params, optval, optlen)) {
-		retval = -EFAULT;
-		goto out;
-	}
+	if (optlen < sizeof(*p))
+		return -EINVAL;
 
-	asoc = sctp_id2assoc(sk, params.assoc_id);
-	if (!asoc && params.assoc_id != SCTP_FUTURE_ASSOC &&
-	    sctp_style(sk, UDP))
-		goto out;
+	asoc = sctp_id2assoc(sk, p->assoc_id);
+	if (!asoc && p->assoc_id != SCTP_FUTURE_ASSOC && sctp_style(sk, UDP))
+		return -EINVAL;
 
 	if (!sock_net(sk)->sctp.intl_enable || !sp->frag_interleave) {
-		retval = -EPERM;
-		goto out;
+		return -EPERM;
 	}
 
-	sp->ep->intl_enable = !!params.assoc_value;
-
-	retval = 0;
-
-out:
-	return retval;
+	sp->ep->intl_enable = !!p->assoc_value;
+	return 0;
 }
 
 static int sctp_setsockopt_reuse_port(struct sock *sk, char __user *optval,
@@ -4651,7 +4637,7 @@ static int sctp_setsockopt(struct sock *sk, int level, int optname,
 		retval = sctp_setsockopt_scheduler_value(sk, kopt, optlen);
 		break;
 	case SCTP_INTERLEAVING_SUPPORTED:
-		retval = sctp_setsockopt_interleaving_supported(sk, optval,
+		retval = sctp_setsockopt_interleaving_supported(sk, kopt,
 								optlen);
 		break;
 	case SCTP_REUSE_PORT:
-- 
2.26.2

