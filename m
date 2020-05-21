Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 63A261DD4D0
	for <lists+netdev@lfdr.de>; Thu, 21 May 2020 19:50:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729065AbgEURr6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 May 2020 13:47:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57784 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730051AbgEURrz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 May 2020 13:47:55 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2261EC061A0E;
        Thu, 21 May 2020 10:47:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=YCZ5wf21Nspo8LGOpsn2rT5PKw60xRefNKgawRaApUA=; b=CikR3sietmI/FOaXOv2Wq47Bre
        AAhj1pqMYSNC3fKT09GDhdjVdGHKxmdYkZQFjiyh5eek7jLXma1e+JU/r9Yayv7yX4KRx/kROFG0K
        d0M1Aw0b2I6IWWAhwQBVlPt2T9OsMoio1WFofAZ8htvg5UdbeceNTo8zb1RBiPpel/krGDjH0I6bZ
        Wuzup2fTVZ1CZrdDCN8aZO6E7RURnle9Nvi9c+UZ19v1zNOCaObB1Qg8NEdH1lIblQHCt2+JgF5BJ
        YOOq6xTWTGunZv4dIANYLcJjVnOjpVkknmTW4tFDnwfFTX08qpDdEEc/ofz+dN0GxLzl+wfSOSxd0
        VR66JpoQ==;
Received: from [2001:4bb8:18c:5da7:c70:4a89:bc61:2] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jbpIH-00037a-2P; Thu, 21 May 2020 17:47:45 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     Vlad Yasevich <vyasevich@gmail.com>,
        Neil Horman <nhorman@tuxdriver.com>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        David Laight <David.Laight@ACULAB.COM>,
        linux-sctp@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH 06/49] sctp: pass a kernel pointer to sctp_setsockopt_autoclose
Date:   Thu, 21 May 2020 19:46:41 +0200
Message-Id: <20200521174724.2635475-7-hch@lst.de>
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
 net/sctp/socket.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/net/sctp/socket.c b/net/sctp/socket.c
index 34bd2ce2ddf66..2fb3a5590a12e 100644
--- a/net/sctp/socket.c
+++ b/net/sctp/socket.c
@@ -2238,7 +2238,7 @@ static int sctp_setsockopt_events(struct sock *sk, __u8 *sn_type,
  * integer defining the number of seconds of idle time before an
  * association is closed.
  */
-static int sctp_setsockopt_autoclose(struct sock *sk, char __user *optval,
+static int sctp_setsockopt_autoclose(struct sock *sk, u32 *autoclose,
 				     unsigned int optlen)
 {
 	struct sctp_sock *sp = sctp_sk(sk);
@@ -2249,11 +2249,11 @@ static int sctp_setsockopt_autoclose(struct sock *sk, char __user *optval,
 		return -EOPNOTSUPP;
 	if (optlen != sizeof(int))
 		return -EINVAL;
-	if (copy_from_user(&sp->autoclose, optval, optlen))
-		return -EFAULT;
-
-	if (sp->autoclose > net->sctp.max_autoclose)
+	
+	if (*autoclose > net->sctp.max_autoclose)
 		sp->autoclose = net->sctp.max_autoclose;
+	else
+		sp->autoclose = *autoclose;
 
 	return 0;
 }
@@ -4692,7 +4692,7 @@ static int sctp_setsockopt(struct sock *sk, int level, int optname,
 		break;
 
 	case SCTP_AUTOCLOSE:
-		retval = sctp_setsockopt_autoclose(sk, optval, optlen);
+		retval = sctp_setsockopt_autoclose(sk, kopt, optlen);
 		break;
 
 	case SCTP_PEER_ADDR_PARAMS:
-- 
2.26.2

