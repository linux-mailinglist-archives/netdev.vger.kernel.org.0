Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A0E771DD4DE
	for <lists+netdev@lfdr.de>; Thu, 21 May 2020 19:50:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730116AbgEURsN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 May 2020 13:48:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57838 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727966AbgEURsL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 May 2020 13:48:11 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B3CAAC061A0F;
        Thu, 21 May 2020 10:48:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=Z7RbDYkZIOX3BWW1JsywM+XdLoWhaiJndKpZl+rGF9c=; b=dqZYEA0HKv3QFYMxBupennh82H
        qPS8+E/EvhmTEoIqJxIWVzamQNQeXjsmOR5Qcn76AG7zjvIvsjxMbMzoK2JISSVZHNVLPKP8IDJe9
        5KTLYu1WaF5RXqpwfCSfG1bKBnXVeFQ1gwmqGfVMq3hyrnLnT4UGwujcXWCv40cFl+nHjQDyC8fig
        z9ascJcbGSi+3Y+sOAeYB97UODmba+ZFLjxfasHCxWikA7kNDWWmpCQrWUZAN24JxXP0McmxDHmMG
        ug/Hs6l70k4sAc6Wd8af8N8EYUALZU7zWLabUu3m0F1izPLXCDTZDRNxQJMw1HsWjQFIoY0sk+c9l
        gQUztrtw==;
Received: from [2001:4bb8:18c:5da7:c70:4a89:bc61:2] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jbpIU-0003Bz-6N; Thu, 21 May 2020 17:47:59 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     Vlad Yasevich <vyasevich@gmail.com>,
        Neil Horman <nhorman@tuxdriver.com>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        David Laight <David.Laight@ACULAB.COM>,
        linux-sctp@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH 11/49] sctp: pass a kernel pointer to sctp_setsockopt_default_send_param
Date:   Thu, 21 May 2020 19:46:46 +0200
Message-Id: <20200521174724.2635475-12-hch@lst.de>
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
 net/sctp/socket.c | 54 ++++++++++++++++++++++-------------------------
 1 file changed, 25 insertions(+), 29 deletions(-)

diff --git a/net/sctp/socket.c b/net/sctp/socket.c
index 0180b22087c0b..acf1484cd62a1 100644
--- a/net/sctp/socket.c
+++ b/net/sctp/socket.c
@@ -2864,57 +2864,54 @@ static int sctp_setsockopt_initmsg(struct sock *sk, struct sctp_initmsg *sinit,
  *   to this call if the caller is using the UDP model.
  */
 static int sctp_setsockopt_default_send_param(struct sock *sk,
-					      char __user *optval,
+					      struct sctp_sndrcvinfo *info,
 					      unsigned int optlen)
 {
 	struct sctp_sock *sp = sctp_sk(sk);
 	struct sctp_association *asoc;
-	struct sctp_sndrcvinfo info;
 
 	if (optlen != sizeof(info))
 		return -EINVAL;
-	if (copy_from_user(&info, optval, optlen))
-		return -EFAULT;
-	if (info.sinfo_flags &
+	if (info->sinfo_flags &
 	    ~(SCTP_UNORDERED | SCTP_ADDR_OVER |
 	      SCTP_ABORT | SCTP_EOF))
 		return -EINVAL;
 
-	asoc = sctp_id2assoc(sk, info.sinfo_assoc_id);
-	if (!asoc && info.sinfo_assoc_id > SCTP_ALL_ASSOC &&
+	asoc = sctp_id2assoc(sk, info->sinfo_assoc_id);
+	if (!asoc && info->sinfo_assoc_id > SCTP_ALL_ASSOC &&
 	    sctp_style(sk, UDP))
 		return -EINVAL;
 
 	if (asoc) {
-		asoc->default_stream = info.sinfo_stream;
-		asoc->default_flags = info.sinfo_flags;
-		asoc->default_ppid = info.sinfo_ppid;
-		asoc->default_context = info.sinfo_context;
-		asoc->default_timetolive = info.sinfo_timetolive;
+		asoc->default_stream = info->sinfo_stream;
+		asoc->default_flags = info->sinfo_flags;
+		asoc->default_ppid = info->sinfo_ppid;
+		asoc->default_context = info->sinfo_context;
+		asoc->default_timetolive = info->sinfo_timetolive;
 
 		return 0;
 	}
 
 	if (sctp_style(sk, TCP))
-		info.sinfo_assoc_id = SCTP_FUTURE_ASSOC;
+		info->sinfo_assoc_id = SCTP_FUTURE_ASSOC;
 
-	if (info.sinfo_assoc_id == SCTP_FUTURE_ASSOC ||
-	    info.sinfo_assoc_id == SCTP_ALL_ASSOC) {
-		sp->default_stream = info.sinfo_stream;
-		sp->default_flags = info.sinfo_flags;
-		sp->default_ppid = info.sinfo_ppid;
-		sp->default_context = info.sinfo_context;
-		sp->default_timetolive = info.sinfo_timetolive;
+	if (info->sinfo_assoc_id == SCTP_FUTURE_ASSOC ||
+	    info->sinfo_assoc_id == SCTP_ALL_ASSOC) {
+		sp->default_stream = info->sinfo_stream;
+		sp->default_flags = info->sinfo_flags;
+		sp->default_ppid = info->sinfo_ppid;
+		sp->default_context = info->sinfo_context;
+		sp->default_timetolive = info->sinfo_timetolive;
 	}
 
-	if (info.sinfo_assoc_id == SCTP_CURRENT_ASSOC ||
-	    info.sinfo_assoc_id == SCTP_ALL_ASSOC) {
+	if (info->sinfo_assoc_id == SCTP_CURRENT_ASSOC ||
+	    info->sinfo_assoc_id == SCTP_ALL_ASSOC) {
 		list_for_each_entry(asoc, &sp->ep->asocs, asocs) {
-			asoc->default_stream = info.sinfo_stream;
-			asoc->default_flags = info.sinfo_flags;
-			asoc->default_ppid = info.sinfo_ppid;
-			asoc->default_context = info.sinfo_context;
-			asoc->default_timetolive = info.sinfo_timetolive;
+			asoc->default_stream = info->sinfo_stream;
+			asoc->default_flags = info->sinfo_flags;
+			asoc->default_ppid = info->sinfo_ppid;
+			asoc->default_context = info->sinfo_context;
+			asoc->default_timetolive = info->sinfo_timetolive;
 		}
 	}
 
@@ -4692,8 +4689,7 @@ static int sctp_setsockopt(struct sock *sk, int level, int optname,
 		retval = sctp_setsockopt_initmsg(sk, kopt, optlen);
 		break;
 	case SCTP_DEFAULT_SEND_PARAM:
-		retval = sctp_setsockopt_default_send_param(sk, optval,
-							    optlen);
+		retval = sctp_setsockopt_default_send_param(sk, kopt, optlen);
 		break;
 	case SCTP_DEFAULT_SNDINFO:
 		retval = sctp_setsockopt_default_sndinfo(sk, optval, optlen);
-- 
2.26.2

