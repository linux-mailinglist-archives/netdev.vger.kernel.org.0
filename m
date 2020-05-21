Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 56D9F1DD522
	for <lists+netdev@lfdr.de>; Thu, 21 May 2020 19:50:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730499AbgEURth (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 May 2020 13:49:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58126 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730488AbgEURte (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 May 2020 13:49:34 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C74FC061A0E;
        Thu, 21 May 2020 10:49:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=6e1szokp+5sGjFPI9p84mi3A9SxRIVAJpz4ADIBp7w8=; b=Nw49TnXd2ec332ZuZsUIWMrDcL
        P8/x2szFNKUSiQLdiJYiqyMyGqam43vUVrlk/V5nVUR4A0YpuL1Fvh3SI05cJbyQ9x0hPTvv6KaWR
        ROR6CmczjR+fiwyqExKVs+C4HGo1X5iLnJ+kEDoKj2ileErG1rsF+0ekQedlnvYzU9cK8guBhL0Tb
        3tqb4vxjJLmfDwq6ALClKmaBWZzntkK4QIfSIyLa7dE6H21St3GbSUdFWow1+B2o2Vg8z0Gu2aHam
        qFGCTiwJXn8ZBYWl0cUGl8h2L+U1JNgYp+d8Fxf+/g+gqnTalra3eJmk8TN+7OCFlvcsJf8QVMEly
        lpdKZkxw==;
Received: from [2001:4bb8:18c:5da7:c70:4a89:bc61:2] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jbpK0-0003Sr-Hj; Thu, 21 May 2020 17:49:32 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     Vlad Yasevich <vyasevich@gmail.com>,
        Neil Horman <nhorman@tuxdriver.com>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        David Laight <David.Laight@ACULAB.COM>,
        linux-sctp@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH 47/49] sctp: pass a kernel pointer to sctp_setsockopt_auth_supported
Date:   Thu, 21 May 2020 19:47:22 +0200
Message-Id: <20200521174724.2635475-48-hch@lst.de>
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
 net/sctp/socket.c | 20 +++++++-------------
 1 file changed, 7 insertions(+), 13 deletions(-)

diff --git a/net/sctp/socket.c b/net/sctp/socket.c
index 0aa7265c9c9a0..755bb23ffa3c9 100644
--- a/net/sctp/socket.c
+++ b/net/sctp/socket.c
@@ -4322,29 +4322,23 @@ static int sctp_setsockopt_asconf_supported(struct sock *sk,
 }
 
 static int sctp_setsockopt_auth_supported(struct sock *sk,
-					  char __user *optval,
+					  struct sctp_assoc_value *params,
 					  unsigned int optlen)
 {
-	struct sctp_assoc_value params;
 	struct sctp_association *asoc;
 	struct sctp_endpoint *ep;
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
 
 	ep = sctp_sk(sk)->ep;
-	if (params.assoc_value) {
+	if (params->assoc_value) {
 		retval = sctp_auth_init(ep, GFP_KERNEL);
 		if (retval)
 			goto out;
@@ -4354,7 +4348,7 @@ static int sctp_setsockopt_auth_supported(struct sock *sk,
 		}
 	}
 
-	ep->auth_enable = !!params.assoc_value;
+	ep->auth_enable = !!params->assoc_value;
 	retval = 0;
 
 out:
@@ -4634,7 +4628,7 @@ static int sctp_setsockopt(struct sock *sk, int level, int optname,
 		retval = sctp_setsockopt_asconf_supported(sk, kopt, optlen);
 		break;
 	case SCTP_AUTH_SUPPORTED:
-		retval = sctp_setsockopt_auth_supported(sk, optval, optlen);
+		retval = sctp_setsockopt_auth_supported(sk, kopt, optlen);
 		break;
 	case SCTP_ECN_SUPPORTED:
 		retval = sctp_setsockopt_ecn_supported(sk, optval, optlen);
-- 
2.26.2

