Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 25AB522500D
	for <lists+netdev@lfdr.de>; Sun, 19 Jul 2020 09:22:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726235AbgGSHWs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 Jul 2020 03:22:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52434 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726024AbgGSHWq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 19 Jul 2020 03:22:46 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E1713C0619D7;
        Sun, 19 Jul 2020 00:22:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=G3n593tVFP0vc7Yzvr5B85eN0uFZ6ZmT9mj4Ax1sOoc=; b=u5j6/ApLZOJtap9h0IVvpoAtXi
        AyEIiRpUp2HACyBqkqMn4gKZSKYiOanTujXBjuguToInjMEiWmNF8rNo/fm7xoUI21Mjam9eu3D2m
        kcRqBstgJqJF+ciTnsi3jHYC3LlX4SL9ngDdzZ7ZSADAXyiBBkJpwGZNV36bffMo8FFqnmQN5/V3o
        1PSSEe4xbqbJAO9vHFDUsReT7ay1K2aqj7KFY258GXFfvI2Ez9Ekq0RdyVPjtlIGrBzq5ml6Zjd73
        9XJVdhVySrX7XNgdSVFWidNYb06tk+SKpB+ZhdhSQCYhThYHgqLFlss2FPc4ZYZ6r55s5BbaYVYmt
        G56F7cGA==;
Received: from [2001:4bb8:105:4a81:4ef5:9f24:cda4:103f] (helo=localhost)
        by casper.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jx3ef-0000QK-Is; Sun, 19 Jul 2020 07:22:37 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     Vlad Yasevich <vyasevich@gmail.com>,
        Neil Horman <nhorman@tuxdriver.com>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        David Laight <David.Laight@ACULAB.COM>,
        linux-sctp@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH 06/51] sctp: pass a kernel pointer to sctp_setsockopt_autoclose
Date:   Sun, 19 Jul 2020 09:21:43 +0200
Message-Id: <20200719072228.112645-7-hch@lst.de>
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
 net/sctp/socket.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/net/sctp/socket.c b/net/sctp/socket.c
index bc37174bd71af0..d7ed8c6ea3754f 100644
--- a/net/sctp/socket.c
+++ b/net/sctp/socket.c
@@ -2242,7 +2242,7 @@ static int sctp_setsockopt_events(struct sock *sk, __u8 *sn_type,
  * integer defining the number of seconds of idle time before an
  * association is closed.
  */
-static int sctp_setsockopt_autoclose(struct sock *sk, char __user *optval,
+static int sctp_setsockopt_autoclose(struct sock *sk, u32 *optval,
 				     unsigned int optlen)
 {
 	struct sctp_sock *sp = sctp_sk(sk);
@@ -2253,9 +2253,8 @@ static int sctp_setsockopt_autoclose(struct sock *sk, char __user *optval,
 		return -EOPNOTSUPP;
 	if (optlen != sizeof(int))
 		return -EINVAL;
-	if (copy_from_user(&sp->autoclose, optval, optlen))
-		return -EFAULT;
 
+	sp->autoclose = *optval;
 	if (sp->autoclose > net->sctp.max_autoclose)
 		sp->autoclose = net->sctp.max_autoclose;
 
@@ -4696,7 +4695,7 @@ static int sctp_setsockopt(struct sock *sk, int level, int optname,
 		break;
 
 	case SCTP_AUTOCLOSE:
-		retval = sctp_setsockopt_autoclose(sk, optval, optlen);
+		retval = sctp_setsockopt_autoclose(sk, kopt, optlen);
 		break;
 
 	case SCTP_PEER_ADDR_PARAMS:
-- 
2.27.0

