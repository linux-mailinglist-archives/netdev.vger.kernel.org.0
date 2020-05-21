Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 20F131DD526
	for <lists+netdev@lfdr.de>; Thu, 21 May 2020 19:50:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730515AbgEURto (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 May 2020 13:49:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58094 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728551AbgEURt0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 May 2020 13:49:26 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E6334C061A0E;
        Thu, 21 May 2020 10:49:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=5X42DXlpMmI8hWtS+txSKbPVzoglgqW6DiQuuhKPluo=; b=Am0a2qW1Q3cXJH1IW4OWp+rDao
        MPhX9ebl6vZb3m5ZazCf/yXymkfOF0hiSg29noWRtMqv3VVXoOgqw1Jj6AvOhPPoDpyKZoNhTfv/8
        bRv5SiekxwZ+SrdIiVwu8xGVNtL8xFeThe8UPV+KrqQCzWxNNbtHKNi5eCeSyaygQUhl5GYlqLQ0s
        hjn1C1VEie3XtOpAU7r2/JZDq0CHrlLAtYnRGzp69GFpbsX+vJn4g0bxcchMuitJudAs/j0up7rSG
        l8dfD8H7cw8rmRtZ9eoJ+ptrTJ+YpkvLMHPz2k4N2+L3RLM9KPpGFY3QIUz+1mal8kxAu7kU2Vhb1
        JcrjyEEw==;
Received: from [2001:4bb8:18c:5da7:c70:4a89:bc61:2] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jbpJt-0003RH-4N; Thu, 21 May 2020 17:49:25 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     Vlad Yasevich <vyasevich@gmail.com>,
        Neil Horman <nhorman@tuxdriver.com>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        David Laight <David.Laight@ACULAB.COM>,
        linux-sctp@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH 44/49] sctp: pass a kernel pointer to sctp_setsockopt_reuse_port
Date:   Thu, 21 May 2020 19:47:19 +0200
Message-Id: <20200521174724.2635475-45-hch@lst.de>
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
index 48229ffabbaee..c2abf3ab544c3 100644
--- a/net/sctp/socket.c
+++ b/net/sctp/socket.c
@@ -4210,11 +4210,9 @@ static int sctp_setsockopt_interleaving_supported(struct sock *sk,
 	return 0;
 }
 
-static int sctp_setsockopt_reuse_port(struct sock *sk, char __user *optval,
+static int sctp_setsockopt_reuse_port(struct sock *sk, int *val,
 				      unsigned int optlen)
 {
-	int val;
-
 	if (!sctp_style(sk, TCP))
 		return -EOPNOTSUPP;
 
@@ -4224,10 +4222,7 @@ static int sctp_setsockopt_reuse_port(struct sock *sk, char __user *optval,
 	if (optlen < sizeof(int))
 		return -EINVAL;
 
-	if (get_user(val, (int __user *)optval))
-		return -EFAULT;
-
-	sctp_sk(sk)->reuse = !!val;
+	sctp_sk(sk)->reuse = !!*val;
 
 	return 0;
 }
@@ -4641,7 +4636,7 @@ static int sctp_setsockopt(struct sock *sk, int level, int optname,
 								optlen);
 		break;
 	case SCTP_REUSE_PORT:
-		retval = sctp_setsockopt_reuse_port(sk, optval, optlen);
+		retval = sctp_setsockopt_reuse_port(sk, kopt, optlen);
 		break;
 	case SCTP_EVENT:
 		retval = sctp_setsockopt_event(sk, optval, optlen);
-- 
2.26.2

