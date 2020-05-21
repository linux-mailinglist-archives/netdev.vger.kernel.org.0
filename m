Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1BE281DD4DF
	for <lists+netdev@lfdr.de>; Thu, 21 May 2020 19:50:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730123AbgEURsP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 May 2020 13:48:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57836 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730104AbgEURsL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 May 2020 13:48:11 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 76E7AC061A0E;
        Thu, 21 May 2020 10:48:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=qrLUQyaeJYthY29m3jqWphySEvOPt3fDowQiG2CAWq8=; b=AlU39C63nzkXuMED6VWrJqLdVb
        lEWdvMLQv3dXg04djzGXTYkeq7b9wocSP9nwz12Af1vcXbhAd4NQGNBaG3/k/gmqAJwtvwJAQyxKK
        4btbxfD8DiwnHjY8RV9n+QLuaOskABFyeqPuqLzp2+3rU6HmwhtyveKuRcW0K+nEuKJyeq8rjkNmC
        zstAkUs+UbPWtpyy0Q5zdSNsCEQX2ai1/mArhqsifKlRnfJUxbfg0cBBIp9gmmPadosJzkWU7wrpR
        XTKY0bne2MyECCn4xn+IDK9b5t80OszxYXw8TWpbdZrZH61x6H1YAgA1ngWaq0Uwy7ydAWx7v7lY+
        qS8xvzeQ==;
Received: from [2001:4bb8:18c:5da7:c70:4a89:bc61:2] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jbpIX-0003Cg-8T; Thu, 21 May 2020 17:48:01 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     Vlad Yasevich <vyasevich@gmail.com>,
        Neil Horman <nhorman@tuxdriver.com>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        David Laight <David.Laight@ACULAB.COM>,
        linux-sctp@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH 12/49] sctp: pass a kernel pointer to sctp_setsockopt_default_sndinfo
Date:   Thu, 21 May 2020 19:46:47 +0200
Message-Id: <20200521174724.2635475-13-hch@lst.de>
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
 net/sctp/socket.c | 47 ++++++++++++++++++++++-------------------------
 1 file changed, 22 insertions(+), 25 deletions(-)

diff --git a/net/sctp/socket.c b/net/sctp/socket.c
index acf1484cd62a1..53bd58a5cc954 100644
--- a/net/sctp/socket.c
+++ b/net/sctp/socket.c
@@ -2922,54 +2922,51 @@ static int sctp_setsockopt_default_send_param(struct sock *sk,
  * (SCTP_DEFAULT_SNDINFO)
  */
 static int sctp_setsockopt_default_sndinfo(struct sock *sk,
-					   char __user *optval,
+					   struct sctp_sndinfo *info,
 					   unsigned int optlen)
 {
 	struct sctp_sock *sp = sctp_sk(sk);
 	struct sctp_association *asoc;
-	struct sctp_sndinfo info;
 
 	if (optlen != sizeof(info))
 		return -EINVAL;
-	if (copy_from_user(&info, optval, optlen))
-		return -EFAULT;
-	if (info.snd_flags &
+	if (info->snd_flags &
 	    ~(SCTP_UNORDERED | SCTP_ADDR_OVER |
 	      SCTP_ABORT | SCTP_EOF))
 		return -EINVAL;
 
-	asoc = sctp_id2assoc(sk, info.snd_assoc_id);
-	if (!asoc && info.snd_assoc_id > SCTP_ALL_ASSOC &&
+	asoc = sctp_id2assoc(sk, info->snd_assoc_id);
+	if (!asoc && info->snd_assoc_id > SCTP_ALL_ASSOC &&
 	    sctp_style(sk, UDP))
 		return -EINVAL;
 
 	if (asoc) {
-		asoc->default_stream = info.snd_sid;
-		asoc->default_flags = info.snd_flags;
-		asoc->default_ppid = info.snd_ppid;
-		asoc->default_context = info.snd_context;
+		asoc->default_stream = info->snd_sid;
+		asoc->default_flags = info->snd_flags;
+		asoc->default_ppid = info->snd_ppid;
+		asoc->default_context = info->snd_context;
 
 		return 0;
 	}
 
 	if (sctp_style(sk, TCP))
-		info.snd_assoc_id = SCTP_FUTURE_ASSOC;
+		info->snd_assoc_id = SCTP_FUTURE_ASSOC;
 
-	if (info.snd_assoc_id == SCTP_FUTURE_ASSOC ||
-	    info.snd_assoc_id == SCTP_ALL_ASSOC) {
-		sp->default_stream = info.snd_sid;
-		sp->default_flags = info.snd_flags;
-		sp->default_ppid = info.snd_ppid;
-		sp->default_context = info.snd_context;
+	if (info->snd_assoc_id == SCTP_FUTURE_ASSOC ||
+	    info->snd_assoc_id == SCTP_ALL_ASSOC) {
+		sp->default_stream = info->snd_sid;
+		sp->default_flags = info->snd_flags;
+		sp->default_ppid = info->snd_ppid;
+		sp->default_context = info->snd_context;
 	}
 
-	if (info.snd_assoc_id == SCTP_CURRENT_ASSOC ||
-	    info.snd_assoc_id == SCTP_ALL_ASSOC) {
+	if (info->snd_assoc_id == SCTP_CURRENT_ASSOC ||
+	    info->snd_assoc_id == SCTP_ALL_ASSOC) {
 		list_for_each_entry(asoc, &sp->ep->asocs, asocs) {
-			asoc->default_stream = info.snd_sid;
-			asoc->default_flags = info.snd_flags;
-			asoc->default_ppid = info.snd_ppid;
-			asoc->default_context = info.snd_context;
+			asoc->default_stream = info->snd_sid;
+			asoc->default_flags = info->snd_flags;
+			asoc->default_ppid = info->snd_ppid;
+			asoc->default_context = info->snd_context;
 		}
 	}
 
@@ -4692,7 +4689,7 @@ static int sctp_setsockopt(struct sock *sk, int level, int optname,
 		retval = sctp_setsockopt_default_send_param(sk, kopt, optlen);
 		break;
 	case SCTP_DEFAULT_SNDINFO:
-		retval = sctp_setsockopt_default_sndinfo(sk, optval, optlen);
+		retval = sctp_setsockopt_default_sndinfo(sk, kopt, optlen);
 		break;
 	case SCTP_PRIMARY_ADDR:
 		retval = sctp_setsockopt_primary_addr(sk, optval, optlen);
-- 
2.26.2

