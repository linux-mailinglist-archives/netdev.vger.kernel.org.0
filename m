Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9C57A1DD4F2
	for <lists+netdev@lfdr.de>; Thu, 21 May 2020 19:50:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730271AbgEURsl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 May 2020 13:48:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57918 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730224AbgEURse (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 May 2020 13:48:34 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C9E84C061A0E;
        Thu, 21 May 2020 10:48:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=SW4zrtaax2oBpLv7+mSGjQ4Ld1p3hEQ1pAFLffPUzFs=; b=iJgbnokpTiiXjBvU5WBhUjGsed
        w5ECNtswdSCUHZAzAWEGH3TMEcrKK2knFi5NdL3obgoWZjDabhjYd1aDMxfnMHJi5kyjAStI17R0P
        GPAaJ3AW9cQnqLLWyvasi1pIZXfwDhbwxtM9a5I89WXCIIJJ4GyomC6PPnjXuscPb+iG9RVsXWinH
        moNLlU0g2BdQipsPFJCl7oQWAnuI/wslWHtRCHhzejybV37NLKW+v/O3iqDuYLm5q/INM0BWzO2tQ
        epIgMrc6vLJQhTLvmv4d/Ii6IlzuhqNXarxI3KCnyy/fQJ5SZIZR86kMKyHiA7n+Bgi3Kj4e88gHG
        Cz9MzNQw==;
Received: from [2001:4bb8:18c:5da7:c70:4a89:bc61:2] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jbpIx-0003HV-8O; Thu, 21 May 2020 17:48:27 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     Vlad Yasevich <vyasevich@gmail.com>,
        Neil Horman <nhorman@tuxdriver.com>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        David Laight <David.Laight@ACULAB.COM>,
        linux-sctp@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH 22/49] sctp: pass a kernel pointer to sctp_setsockopt_fragment_interleave
Date:   Thu, 21 May 2020 19:46:57 +0200
Message-Id: <20200521174724.2635475-23-hch@lst.de>
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
index 03577684be65f..249a87014e879 100644
--- a/net/sctp/socket.c
+++ b/net/sctp/socket.c
@@ -3419,18 +3419,13 @@ static int sctp_setsockopt_context(struct sock *sk,
  * application using the one to many model may become confused and act
  * incorrectly.
  */
-static int sctp_setsockopt_fragment_interleave(struct sock *sk,
-					       char __user *optval,
+static int sctp_setsockopt_fragment_interleave(struct sock *sk, int *val,
 					       unsigned int optlen)
 {
-	int val;
-
 	if (optlen != sizeof(int))
 		return -EINVAL;
-	if (get_user(val, (int __user *)optval))
-		return -EFAULT;
 
-	sctp_sk(sk)->frag_interleave = !!val;
+	sctp_sk(sk)->frag_interleave = !!*val;
 
 	if (!sctp_sk(sk)->frag_interleave)
 		sctp_sk(sk)->ep->intl_enable = 0;
@@ -4698,7 +4693,7 @@ static int sctp_setsockopt(struct sock *sk, int level, int optname,
 		retval = sctp_setsockopt_context(sk, kopt, optlen);
 		break;
 	case SCTP_FRAGMENT_INTERLEAVE:
-		retval = sctp_setsockopt_fragment_interleave(sk, optval, optlen);
+		retval = sctp_setsockopt_fragment_interleave(sk, kopt, optlen);
 		break;
 	case SCTP_MAX_BURST:
 		retval = sctp_setsockopt_maxburst(sk, optval, optlen);
-- 
2.26.2

