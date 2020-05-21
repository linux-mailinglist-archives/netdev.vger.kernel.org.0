Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ABCD61DD508
	for <lists+netdev@lfdr.de>; Thu, 21 May 2020 19:50:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728542AbgEURtB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 May 2020 13:49:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57996 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730393AbgEURs5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 May 2020 13:48:57 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D870DC061A0E;
        Thu, 21 May 2020 10:48:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=KNivEakB+nugKR6+0we8T8D7rWmcHfakL46Zfe35QV4=; b=uYj2KcX5HiiYWTrHblh7zLSXwC
        /oDoqrf0tjUZRD2KqragWLU4w9odZ9eXHYmystbLtUxEDRNctG4bqZV+Q/pwLJ6Mdo3jp5Jcyhle4
        jbyctX0k/5YxvYGFhgyMVH2L2mhYHyDdpNLxaNFHbY60CEMcEO9l1p4PDgMMRtDLHpGX5XX9hYbrb
        TnZ9GkTDe5e7O+9muNa0pEQjsqsXYcIT7PtTGCsE30m5I3W2sb8zNRyjT44uX3g7y+9HuuzaZsayr
        5EHbONXhWhNJjIFcIk4O2FDtlkQoxCRJGqxTAakeDKXz4aPpngiFsqdGdBmjwMvgc6eNfFjZEL1D+
        m8dEgzoQ==;
Received: from [2001:4bb8:18c:5da7:c70:4a89:bc61:2] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jbpJQ-0003Me-BR; Thu, 21 May 2020 17:48:56 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     Vlad Yasevich <vyasevich@gmail.com>,
        Neil Horman <nhorman@tuxdriver.com>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        David Laight <David.Laight@ACULAB.COM>,
        linux-sctp@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH 33/49] sctp: pass a kernel pointer to sctp_setsockopt_recvnxtinfo
Date:   Thu, 21 May 2020 19:47:08 +0200
Message-Id: <20200521174724.2635475-34-hch@lst.de>
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
index e4b537e6d61da..fe8d1ea7d9c35 100644
--- a/net/sctp/socket.c
+++ b/net/sctp/socket.c
@@ -3909,18 +3909,13 @@ static int sctp_setsockopt_recvrcvinfo(struct sock *sk, int *val,
 	return 0;
 }
 
-static int sctp_setsockopt_recvnxtinfo(struct sock *sk,
-				       char __user *optval,
+static int sctp_setsockopt_recvnxtinfo(struct sock *sk, int *val,
 				       unsigned int optlen)
 {
-	int val;
-
 	if (optlen < sizeof(int))
 		return -EINVAL;
-	if (get_user(val, (int __user *) optval))
-		return -EFAULT;
 
-	sctp_sk(sk)->recvnxtinfo = (val == 0) ? 0 : 1;
+	sctp_sk(sk)->recvnxtinfo = (*val == 0) ? 0 : 1;
 
 	return 0;
 }
@@ -4689,7 +4684,7 @@ static int sctp_setsockopt(struct sock *sk, int level, int optname,
 		retval = sctp_setsockopt_recvrcvinfo(sk, kopt, optlen);
 		break;
 	case SCTP_RECVNXTINFO:
-		retval = sctp_setsockopt_recvnxtinfo(sk, optval, optlen);
+		retval = sctp_setsockopt_recvnxtinfo(sk, kopt, optlen);
 		break;
 	case SCTP_PR_SUPPORTED:
 		retval = sctp_setsockopt_pr_supported(sk, optval, optlen);
-- 
2.26.2

