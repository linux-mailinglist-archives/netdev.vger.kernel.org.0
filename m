Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AAA531DD4FF
	for <lists+netdev@lfdr.de>; Thu, 21 May 2020 19:50:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730364AbgEURsw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 May 2020 13:48:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57964 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730357AbgEURst (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 May 2020 13:48:49 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC5D0C061A0F;
        Thu, 21 May 2020 10:48:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=gM6y0Fs0opQzXquIVwkWoZa9s9AjgwaxY2IZTBk9C0U=; b=LCm4CqYRghUAe5awDIKZgS3XYU
        VKnqjdJ+vpcPWr1LxoCSfWTR6/kYNx0WrckdGTRlx6EJk4tes9GoI+JyNmu7HOIbjbTWz3oaLWUDx
        R3IN8seq+oNID+9TQYfwEzx+1ZxUoCs/+eqRntlaIs0buush9YU9CjI3RbNOZC7tcYRI9SW/Ynttf
        lw5k7jTFW8WwIrM/u+23jfSXyiprKqdIM6YVMlQRRYUabp0u4DMPBt8RQKhDBw3FLrxxuCCvIXBRy
        DBK9t2dNZJS5x/Fp3LLF7G1b3VEvJYy8qxbJZfklNrvr/ceiS+8P+wyz3GHS2YHNa4a+RxDW2/moQ
        SHDySgEg==;
Received: from [2001:4bb8:18c:5da7:c70:4a89:bc61:2] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jbpJD-0003Jx-3H; Thu, 21 May 2020 17:48:43 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     Vlad Yasevich <vyasevich@gmail.com>,
        Neil Horman <nhorman@tuxdriver.com>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        David Laight <David.Laight@ACULAB.COM>,
        linux-sctp@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH 28/49] sctp: pass a kernel pointer to sctp_setsockopt_del_key
Date:   Thu, 21 May 2020 19:47:03 +0200
Message-Id: <20200521174724.2635475-29-hch@lst.de>
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
 net/sctp/socket.c | 27 ++++++++++++---------------
 1 file changed, 12 insertions(+), 15 deletions(-)

diff --git a/net/sctp/socket.c b/net/sctp/socket.c
index 88514a17654a7..a664e9eb323fb 100644
--- a/net/sctp/socket.c
+++ b/net/sctp/socket.c
@@ -3699,42 +3699,39 @@ static int sctp_setsockopt_active_key(struct sock *sk,
  * This set option will delete a shared secret key from use.
  */
 static int sctp_setsockopt_del_key(struct sock *sk,
-				   char __user *optval,
+				   struct sctp_authkeyid *val,
 				   unsigned int optlen)
 {
 	struct sctp_endpoint *ep = sctp_sk(sk)->ep;
 	struct sctp_association *asoc;
-	struct sctp_authkeyid val;
 	int ret = 0;
 
 	if (optlen != sizeof(struct sctp_authkeyid))
 		return -EINVAL;
-	if (copy_from_user(&val, optval, optlen))
-		return -EFAULT;
 
-	asoc = sctp_id2assoc(sk, val.scact_assoc_id);
-	if (!asoc && val.scact_assoc_id > SCTP_ALL_ASSOC &&
+	asoc = sctp_id2assoc(sk, val->scact_assoc_id);
+	if (!asoc && val->scact_assoc_id > SCTP_ALL_ASSOC &&
 	    sctp_style(sk, UDP))
 		return -EINVAL;
 
 	if (asoc)
-		return sctp_auth_del_key_id(ep, asoc, val.scact_keynumber);
+		return sctp_auth_del_key_id(ep, asoc, val->scact_keynumber);
 
 	if (sctp_style(sk, TCP))
-		val.scact_assoc_id = SCTP_FUTURE_ASSOC;
+		val->scact_assoc_id = SCTP_FUTURE_ASSOC;
 
-	if (val.scact_assoc_id == SCTP_FUTURE_ASSOC ||
-	    val.scact_assoc_id == SCTP_ALL_ASSOC) {
-		ret = sctp_auth_del_key_id(ep, asoc, val.scact_keynumber);
+	if (val->scact_assoc_id == SCTP_FUTURE_ASSOC ||
+	    val->scact_assoc_id == SCTP_ALL_ASSOC) {
+		ret = sctp_auth_del_key_id(ep, asoc, val->scact_keynumber);
 		if (ret)
 			return ret;
 	}
 
-	if (val.scact_assoc_id == SCTP_CURRENT_ASSOC ||
-	    val.scact_assoc_id == SCTP_ALL_ASSOC) {
+	if (val->scact_assoc_id == SCTP_CURRENT_ASSOC ||
+	    val->scact_assoc_id == SCTP_ALL_ASSOC) {
 		list_for_each_entry(asoc, &ep->asocs, asocs) {
 			int res = sctp_auth_del_key_id(ep, asoc,
-						       val.scact_keynumber);
+						       val->scact_keynumber);
 
 			if (res && !ret)
 				ret = res;
@@ -4685,7 +4682,7 @@ static int sctp_setsockopt(struct sock *sk, int level, int optname,
 		retval = sctp_setsockopt_active_key(sk, kopt, optlen);
 		break;
 	case SCTP_AUTH_DELETE_KEY:
-		retval = sctp_setsockopt_del_key(sk, optval, optlen);
+		retval = sctp_setsockopt_del_key(sk, kopt, optlen);
 		break;
 	case SCTP_AUTH_DEACTIVATE_KEY:
 		retval = sctp_setsockopt_deactivate_key(sk, optval, optlen);
-- 
2.26.2

