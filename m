Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 246C21DD4D8
	for <lists+netdev@lfdr.de>; Thu, 21 May 2020 19:50:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729129AbgEURsI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 May 2020 13:48:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57774 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729844AbgEURrw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 May 2020 13:47:52 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 18A1BC061A0E;
        Thu, 21 May 2020 10:47:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=YXyPnqvk9m+Tq45lS2l1W+4eb0eHRkvX5n+PUsJrrPs=; b=D1WjVfCBjFk7PcZraBpDoEBib5
        JZE8KCmz5+jTpx9Zyi42v2LJVMeVXBQoSuYz5RGNP0U0RJQZFEZhsZSdu72mA23V9uHJm6RhU3pFJ
        uwHMlsnhitP+PV13a4TZX7e+/CvvwScwWz9UbRwjCRLurnXskFnW7mamH0Dpb47W7UH1Jnf/EYknL
        LqJVbVFN40/3Rai4zl/cDCVZdvux1sriEL9D7k64SqAXLw/Vd+x91VeeyjuwAJZq12Zejf+lVBARx
        bdCEqjGbal3424tq6E3ZrlqqVJbrYPRnrsDX09g0BTHDlkFf/13pg5xjNFHeSvgBAotYkWRW+vd5a
        ZMbcOp2w==;
Received: from [2001:4bb8:18c:5da7:c70:4a89:bc61:2] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jbpID-00034H-Eu; Thu, 21 May 2020 17:47:41 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     Vlad Yasevich <vyasevich@gmail.com>,
        Neil Horman <nhorman@tuxdriver.com>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        David Laight <David.Laight@ACULAB.COM>,
        linux-sctp@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH 05/49] sctp: pass a kernel pointer to sctp_setsockopt_events
Date:   Thu, 21 May 2020 19:46:40 +0200
Message-Id: <20200521174724.2635475-6-hch@lst.de>
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
 net/sctp/socket.c | 9 ++-------
 1 file changed, 2 insertions(+), 7 deletions(-)

diff --git a/net/sctp/socket.c b/net/sctp/socket.c
index 0ca8001acfd50..34bd2ce2ddf66 100644
--- a/net/sctp/socket.c
+++ b/net/sctp/socket.c
@@ -2189,11 +2189,9 @@ static int sctp_setsockopt_disable_fragments(struct sock *sk, int *val,
 	return 0;
 }
 
-static int sctp_setsockopt_events(struct sock *sk, char __user *optval,
+static int sctp_setsockopt_events(struct sock *sk, __u8 *sn_type,
 				  unsigned int optlen)
 {
-	struct sctp_event_subscribe subscribe;
-	__u8 *sn_type = (__u8 *)&subscribe;
 	struct sctp_sock *sp = sctp_sk(sk);
 	struct sctp_association *asoc;
 	int i;
@@ -2201,9 +2199,6 @@ static int sctp_setsockopt_events(struct sock *sk, char __user *optval,
 	if (optlen > sizeof(struct sctp_event_subscribe))
 		return -EINVAL;
 
-	if (copy_from_user(&subscribe, optval, optlen))
-		return -EFAULT;
-
 	for (i = 0; i < optlen; i++)
 		sctp_ulpevent_type_set(&sp->subscribe, SCTP_SN_TYPE_BASE + i,
 				       sn_type[i]);
@@ -4693,7 +4688,7 @@ static int sctp_setsockopt(struct sock *sk, int level, int optname,
 		break;
 
 	case SCTP_EVENTS:
-		retval = sctp_setsockopt_events(sk, optval, optlen);
+		retval = sctp_setsockopt_events(sk, kopt, optlen);
 		break;
 
 	case SCTP_AUTOCLOSE:
-- 
2.26.2

