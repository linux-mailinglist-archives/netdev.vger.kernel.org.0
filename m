Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ED4961DD516
	for <lists+netdev@lfdr.de>; Thu, 21 May 2020 19:50:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730455AbgEURtS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 May 2020 13:49:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58060 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728455AbgEURtQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 May 2020 13:49:16 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3EC9BC061A0E;
        Thu, 21 May 2020 10:49:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=H+5x+DixtPFUc8G/CM8QavdCywZMjYxsxgqxbqm03D8=; b=hYB1AfNtPSgqoflB2UqnbRaGjJ
        xJPkSER5Qu4DaCF5lXsjRwBGXc+E5QS8syVahTe/fw42csfqB3mZzGNofFMDjJ/L9YOem+LRngKJP
        JIu8v+deR7jEniuE8GLI001evZMMKiH5CNj2nVT92e/dsW4unJFVP56oqZHfk+85f6mW/XLoZEk8P
        58KoDxVcx4df87NUpzsWWM9W7P2zrlx4w96DlL1eKX98smT5jwzCeTJT9f095L+xE3+kopdizXhBt
        2SMQYZvYOdC2pFc9/hYBFKLvzxYEAHUmPB/L745s6aVreksO+s/MsdD5VWrAyur0+w84FzB9tgG95
        WLYsDUzw==;
Received: from [2001:4bb8:18c:5da7:c70:4a89:bc61:2] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jbpJi-0003PR-Gv; Thu, 21 May 2020 17:49:14 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     Vlad Yasevich <vyasevich@gmail.com>,
        Neil Horman <nhorman@tuxdriver.com>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        David Laight <David.Laight@ACULAB.COM>,
        linux-sctp@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH 40/49] sctp: pass a kernel pointer to sctp_setsockopt_add_streams
Date:   Thu, 21 May 2020 19:47:15 +0200
Message-Id: <20200521174724.2635475-41-hch@lst.de>
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
 net/sctp/socket.c | 24 +++++++-----------------
 1 file changed, 7 insertions(+), 17 deletions(-)

diff --git a/net/sctp/socket.c b/net/sctp/socket.c
index 185c07916281c..84881913dbc7f 100644
--- a/net/sctp/socket.c
+++ b/net/sctp/socket.c
@@ -4095,29 +4095,19 @@ static int sctp_setsockopt_reset_assoc(struct sock *sk, sctp_assoc_t *associd,
 }
 
 static int sctp_setsockopt_add_streams(struct sock *sk,
-				       char __user *optval,
+				       struct sctp_add_streams *params,
 				       unsigned int optlen)
 {
 	struct sctp_association *asoc;
-	struct sctp_add_streams params;
-	int retval = -EINVAL;
-
-	if (optlen != sizeof(params))
-		goto out;
 
-	if (copy_from_user(&params, optval, optlen)) {
-		retval = -EFAULT;
-		goto out;
-	}
+	if (optlen != sizeof(*params))
+		return -EINVAL;
 
-	asoc = sctp_id2assoc(sk, params.sas_assoc_id);
+	asoc = sctp_id2assoc(sk, params->sas_assoc_id);
 	if (!asoc)
-		goto out;
-
-	retval = sctp_send_add_streams(asoc, &params);
+		return -EINVAL;
 
-out:
-	return retval;
+	return sctp_send_add_streams(asoc, params);
 }
 
 static int sctp_setsockopt_scheduler(struct sock *sk,
@@ -4663,7 +4653,7 @@ static int sctp_setsockopt(struct sock *sk, int level, int optname,
 		retval = sctp_setsockopt_reset_assoc(sk, kopt, optlen);
 		break;
 	case SCTP_ADD_STREAMS:
-		retval = sctp_setsockopt_add_streams(sk, optval, optlen);
+		retval = sctp_setsockopt_add_streams(sk, kopt, optlen);
 		break;
 	case SCTP_STREAM_SCHEDULER:
 		retval = sctp_setsockopt_scheduler(sk, optval, optlen);
-- 
2.26.2

