Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 05DCB1DD51F
	for <lists+netdev@lfdr.de>; Thu, 21 May 2020 19:50:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730487AbgEURtd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 May 2020 13:49:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58104 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730472AbgEURt3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 May 2020 13:49:29 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3766DC061A0F;
        Thu, 21 May 2020 10:49:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=rUSbrMVj30HK0cbF9jT9qa+U4g29xoWaNghCLLVy4EU=; b=g+0ClOZpGH9KO1QtSK5ibauqlu
        +IwPmAZoCRb2m6fb5lNtMpixRmtWoOJWd9dbK9SHkl0z6bINkArKg0wdMad3ENWJ5sG8xxCXGzwrC
        vMIa7O/nSaS4tMN2kYS4bx1UIWOzdeMktYRb3RHf3tiiPWiPpfdgYzeSIU7HOjsXlf4hLEjCFR8yG
        VlQgR8fNWgMY6l38pfvy7olrG2gJ+eTNi2sIYVUZZjk9+Xxwi6plMHXa5TDy1kWfx9/7DZpvNweNz
        0WD7e/9i5bF2EQYqsFOvi0aXPNuMua1vOudRvDCgP7bNnwqXc2yg1kY8Z2U7YwhwVho6lE/Td0B6H
        wpp2m3fw==;
Received: from [2001:4bb8:18c:5da7:c70:4a89:bc61:2] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jbpJv-0003Rg-JX; Thu, 21 May 2020 17:49:27 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     Vlad Yasevich <vyasevich@gmail.com>,
        Neil Horman <nhorman@tuxdriver.com>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        David Laight <David.Laight@ACULAB.COM>,
        linux-sctp@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH 45/49] sctp: pass a kernel pointer to sctp_setsockopt_event
Date:   Thu, 21 May 2020 19:47:20 +0200
Message-Id: <20200521174724.2635475-46-hch@lst.de>
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
 net/sctp/socket.c | 35 +++++++++++++++--------------------
 1 file changed, 15 insertions(+), 20 deletions(-)

diff --git a/net/sctp/socket.c b/net/sctp/socket.c
index c2abf3ab544c3..9b22bb4817830 100644
--- a/net/sctp/socket.c
+++ b/net/sctp/socket.c
@@ -4248,45 +4248,40 @@ static int sctp_assoc_ulpevent_type_set(struct sctp_event *param,
 	return 0;
 }
 
-static int sctp_setsockopt_event(struct sock *sk, char __user *optval,
+static int sctp_setsockopt_event(struct sock *sk, struct sctp_event *param,
 				 unsigned int optlen)
 {
 	struct sctp_sock *sp = sctp_sk(sk);
 	struct sctp_association *asoc;
-	struct sctp_event param;
 	int retval = 0;
 
-	if (optlen < sizeof(param))
+	if (optlen < sizeof(*param))
 		return -EINVAL;
 
-	optlen = sizeof(param);
-	if (copy_from_user(&param, optval, optlen))
-		return -EFAULT;
-
-	if (param.se_type < SCTP_SN_TYPE_BASE ||
-	    param.se_type > SCTP_SN_TYPE_MAX)
+	if (param->se_type < SCTP_SN_TYPE_BASE ||
+	    param->se_type > SCTP_SN_TYPE_MAX)
 		return -EINVAL;
 
-	asoc = sctp_id2assoc(sk, param.se_assoc_id);
-	if (!asoc && param.se_assoc_id > SCTP_ALL_ASSOC &&
+	asoc = sctp_id2assoc(sk, param->se_assoc_id);
+	if (!asoc && param->se_assoc_id > SCTP_ALL_ASSOC &&
 	    sctp_style(sk, UDP))
 		return -EINVAL;
 
 	if (asoc)
-		return sctp_assoc_ulpevent_type_set(&param, asoc);
+		return sctp_assoc_ulpevent_type_set(param, asoc);
 
 	if (sctp_style(sk, TCP))
-		param.se_assoc_id = SCTP_FUTURE_ASSOC;
+		param->se_assoc_id = SCTP_FUTURE_ASSOC;
 
-	if (param.se_assoc_id == SCTP_FUTURE_ASSOC ||
-	    param.se_assoc_id == SCTP_ALL_ASSOC)
+	if (param->se_assoc_id == SCTP_FUTURE_ASSOC ||
+	    param->se_assoc_id == SCTP_ALL_ASSOC)
 		sctp_ulpevent_type_set(&sp->subscribe,
-				       param.se_type, param.se_on);
+				       param->se_type, param->se_on);
 
-	if (param.se_assoc_id == SCTP_CURRENT_ASSOC ||
-	    param.se_assoc_id == SCTP_ALL_ASSOC) {
+	if (param->se_assoc_id == SCTP_CURRENT_ASSOC ||
+	    param->se_assoc_id == SCTP_ALL_ASSOC) {
 		list_for_each_entry(asoc, &sp->ep->asocs, asocs) {
-			int ret = sctp_assoc_ulpevent_type_set(&param, asoc);
+			int ret = sctp_assoc_ulpevent_type_set(param, asoc);
 
 			if (ret && !retval)
 				retval = ret;
@@ -4639,7 +4634,7 @@ static int sctp_setsockopt(struct sock *sk, int level, int optname,
 		retval = sctp_setsockopt_reuse_port(sk, kopt, optlen);
 		break;
 	case SCTP_EVENT:
-		retval = sctp_setsockopt_event(sk, optval, optlen);
+		retval = sctp_setsockopt_event(sk, kopt, optlen);
 		break;
 	case SCTP_ASCONF_SUPPORTED:
 		retval = sctp_setsockopt_asconf_supported(sk, optval, optlen);
-- 
2.26.2

