Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1120D1DD514
	for <lists+netdev@lfdr.de>; Thu, 21 May 2020 19:50:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730447AbgEURtR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 May 2020 13:49:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58054 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730439AbgEURtN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 May 2020 13:49:13 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C992C061A0E;
        Thu, 21 May 2020 10:49:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=wiD0WShrYOD87iLosvX9fYQjk3GatmYnZLZDdq4klqc=; b=sN28EjQBzYZkOVH/EZBMe9bV7l
        mxq9s6NUx7FHPqUBE9PfL8uImhxxfNeqHl8/jF/Kh2hceiIFCnt0VY2EkN3fMMivbS4hjRI1TNkkm
        vv8dW9n/4pU3UYtMAv5QqUlkLLnCglTWO61uoGP3QmlkMyecODduoDXs2ZumKkoCFUvUxfT4Bpc56
        XhHM8gBu3TfkhFaQnEo/yCBv4D8MkI3n0jFVQChcrO0ljPYsMqIigch1qJUORwJQifZniouToRJxd
        /Nkp3TMIuIeqbh2JvAZWtTF1ORdzL7TCN1r2Sn2+P16STrOMah0YRHzmgRsYUJdp0Q/nyjOHpj7gC
        wpFxtQDg==;
Received: from [2001:4bb8:18c:5da7:c70:4a89:bc61:2] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jbpJf-0003P7-W5; Thu, 21 May 2020 17:49:12 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     Vlad Yasevich <vyasevich@gmail.com>,
        Neil Horman <nhorman@tuxdriver.com>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        David Laight <David.Laight@ACULAB.COM>,
        linux-sctp@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH 39/49] sctp: pass a kernel pointer to sctp_setsockopt_reset_assoc
Date:   Thu, 21 May 2020 19:47:14 +0200
Message-Id: <20200521174724.2635475-40-hch@lst.de>
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
 net/sctp/socket.c | 25 +++++++------------------
 1 file changed, 7 insertions(+), 18 deletions(-)

diff --git a/net/sctp/socket.c b/net/sctp/socket.c
index 70451a9177407..185c07916281c 100644
--- a/net/sctp/socket.c
+++ b/net/sctp/socket.c
@@ -4079,30 +4079,19 @@ static int sctp_setsockopt_reset_streams(struct sock *sk,
 	return sctp_send_reset_streams(asoc, params);
 }
 
-static int sctp_setsockopt_reset_assoc(struct sock *sk,
-				       char __user *optval,
+static int sctp_setsockopt_reset_assoc(struct sock *sk, sctp_assoc_t *associd,
 				       unsigned int optlen)
 {
 	struct sctp_association *asoc;
-	sctp_assoc_t associd;
-	int retval = -EINVAL;
-
-	if (optlen != sizeof(associd))
-		goto out;
 
-	if (copy_from_user(&associd, optval, optlen)) {
-		retval = -EFAULT;
-		goto out;
-	}
+	if (optlen != sizeof(*associd))
+		return -EINVAL;
 
-	asoc = sctp_id2assoc(sk, associd);
+	asoc = sctp_id2assoc(sk, *associd);
 	if (!asoc)
-		goto out;
-
-	retval = sctp_send_reset_assoc(asoc);
+		return -EINVAL;
 
-out:
-	return retval;
+	return sctp_send_reset_assoc(asoc);
 }
 
 static int sctp_setsockopt_add_streams(struct sock *sk,
@@ -4671,7 +4660,7 @@ static int sctp_setsockopt(struct sock *sk, int level, int optname,
 		retval = sctp_setsockopt_reset_streams(sk, kopt, optlen);
 		break;
 	case SCTP_RESET_ASSOC:
-		retval = sctp_setsockopt_reset_assoc(sk, optval, optlen);
+		retval = sctp_setsockopt_reset_assoc(sk, kopt, optlen);
 		break;
 	case SCTP_ADD_STREAMS:
 		retval = sctp_setsockopt_add_streams(sk, optval, optlen);
-- 
2.26.2

