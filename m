Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8DC0C1DD4E9
	for <lists+netdev@lfdr.de>; Thu, 21 May 2020 19:50:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730190AbgEURs2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 May 2020 13:48:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57884 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730180AbgEURsZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 May 2020 13:48:25 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 439FAC061A0E;
        Thu, 21 May 2020 10:48:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=IbAxHvXeQq8TGrR00szbPu8WdNCV+tocb8h6szetRZk=; b=pdRB3wk7XauQ5xNozg7x0ajlns
        ONf5SxlTbtvOeqRE1W1GQnKPpb46zeuuGJRCsZwQBQeqR11uIZssMR3wJmGIB6a/itOrh9qkHb7TI
        8l6MXleoAmIQz4KSLSjVQdBdQ6C1Qw/Y2CythTWMtwY9Zr+cxZWxM6xqK6o/zl82YcCrXxcJd5LLf
        0CV3rzcCT9/XwggmwSjcmXssmg4vWChKV71fKgF1gHy+6r6zYWI/GY8vwEAvJpDilcsHgcJPVrEus
        wh33GSNsKVS6vPysyHK23aCWGEBwPGh/DEW9SMKLBXbAkz+rmvMSkx4ekIUICqh7+2KnqUyTmARs9
        0nuGsACQ==;
Received: from [2001:4bb8:18c:5da7:c70:4a89:bc61:2] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jbpIk-0003FH-IR; Thu, 21 May 2020 17:48:15 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     Vlad Yasevich <vyasevich@gmail.com>,
        Neil Horman <nhorman@tuxdriver.com>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        David Laight <David.Laight@ACULAB.COM>,
        linux-sctp@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH 17/49] sctp: pass a kernel pointer to sctp_setsockopt_associnfo
Date:   Thu, 21 May 2020 19:46:52 +0200
Message-Id: <20200521174724.2635475-18-hch@lst.de>
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
 net/sctp/socket.c | 32 ++++++++++++++++----------------
 1 file changed, 16 insertions(+), 16 deletions(-)

diff --git a/net/sctp/socket.c b/net/sctp/socket.c
index 7998b25a8a271..161acd6253e06 100644
--- a/net/sctp/socket.c
+++ b/net/sctp/socket.c
@@ -3102,26 +3102,25 @@ static int sctp_setsockopt_rtoinfo(struct sock *sk,
  * See [SCTP] for more information.
  *
  */
-static int sctp_setsockopt_associnfo(struct sock *sk, char __user *optval, unsigned int optlen)
+static int sctp_setsockopt_associnfo(struct sock *sk,
+				     struct sctp_assocparams *assocparams,
+				     unsigned int optlen)
 {
 
-	struct sctp_assocparams assocparams;
 	struct sctp_association *asoc;
 
 	if (optlen != sizeof(struct sctp_assocparams))
 		return -EINVAL;
-	if (copy_from_user(&assocparams, optval, optlen))
-		return -EFAULT;
 
-	asoc = sctp_id2assoc(sk, assocparams.sasoc_assoc_id);
+	asoc = sctp_id2assoc(sk, assocparams->sasoc_assoc_id);
 
-	if (!asoc && assocparams.sasoc_assoc_id != SCTP_FUTURE_ASSOC &&
+	if (!asoc && assocparams->sasoc_assoc_id != SCTP_FUTURE_ASSOC &&
 	    sctp_style(sk, UDP))
 		return -EINVAL;
 
 	/* Set the values to the specific association */
 	if (asoc) {
-		if (assocparams.sasoc_asocmaxrxt != 0) {
+		if (assocparams->sasoc_asocmaxrxt != 0) {
 			__u32 path_sum = 0;
 			int   paths = 0;
 			struct sctp_transport *peer_addr;
@@ -3138,24 +3137,25 @@ static int sctp_setsockopt_associnfo(struct sock *sk, char __user *optval, unsig
 			 * then one path.
 			 */
 			if (paths > 1 &&
-			    assocparams.sasoc_asocmaxrxt > path_sum)
+			    assocparams->sasoc_asocmaxrxt > path_sum)
 				return -EINVAL;
 
-			asoc->max_retrans = assocparams.sasoc_asocmaxrxt;
+			asoc->max_retrans = assocparams->sasoc_asocmaxrxt;
 		}
 
-		if (assocparams.sasoc_cookie_life != 0)
-			asoc->cookie_life = ms_to_ktime(assocparams.sasoc_cookie_life);
+		if (assocparams->sasoc_cookie_life != 0)
+			asoc->cookie_life =
+				ms_to_ktime(assocparams->sasoc_cookie_life);
 	} else {
 		/* Set the values to the endpoint */
 		struct sctp_sock *sp = sctp_sk(sk);
 
-		if (assocparams.sasoc_asocmaxrxt != 0)
+		if (assocparams->sasoc_asocmaxrxt != 0)
 			sp->assocparams.sasoc_asocmaxrxt =
-						assocparams.sasoc_asocmaxrxt;
-		if (assocparams.sasoc_cookie_life != 0)
+						assocparams->sasoc_asocmaxrxt;
+		if (assocparams->sasoc_cookie_life != 0)
 			sp->assocparams.sasoc_cookie_life =
-						assocparams.sasoc_cookie_life;
+						assocparams->sasoc_cookie_life;
 	}
 	return 0;
 }
@@ -4690,7 +4690,7 @@ static int sctp_setsockopt(struct sock *sk, int level, int optname,
 		retval = sctp_setsockopt_rtoinfo(sk, kopt, optlen);
 		break;
 	case SCTP_ASSOCINFO:
-		retval = sctp_setsockopt_associnfo(sk, optval, optlen);
+		retval = sctp_setsockopt_associnfo(sk, kopt, optlen);
 		break;
 	case SCTP_I_WANT_MAPPED_V4_ADDR:
 		retval = sctp_setsockopt_mappedv4(sk, optval, optlen);
-- 
2.26.2

