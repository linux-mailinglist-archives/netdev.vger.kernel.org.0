Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E01BE225069
	for <lists+netdev@lfdr.de>; Sun, 19 Jul 2020 09:25:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727093AbgGSHYU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 Jul 2020 03:24:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52460 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726097AbgGSHWv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 19 Jul 2020 03:22:51 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A8494C0619D4;
        Sun, 19 Jul 2020 00:22:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=vzo71p01veUQIdhrF9Cnk1k0g6SqCvlgBeiOaxKGIOM=; b=J+6dVXADbscR5HyF0HNFG3V5ik
        GwQoeal+VUSpF1MtkP1ZbYA2WWMFOY9SOyqA6WMAb5lwyArdlBBwMDwdEGaRhUXp0CedjvMMRu5vP
        x6jkrpDO8zFCjE1eF5K9er1Z2TjRk48kS8O5ac8mOR0B9p/mhJj84bVUDwECy58okhjoY8nt3sT7v
        +cFHxnilJTlCLD7SATEMwi5occBC8BFo9CmDbxs5xVjCoTYpog/nwmRKmohINKE02tkKCft1pmCrX
        w6c5aBlxy7RddsekQR3MgRTW1GSVTBrKqhi4d0o2prCFgFINIfaEmj/yEciJ8t4zbqWm8FLZlMtXi
        mxLw+Hag==;
Received: from [2001:4bb8:105:4a81:4ef5:9f24:cda4:103f] (helo=localhost)
        by casper.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jx3em-0000Rr-Ky; Sun, 19 Jul 2020 07:22:45 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     Vlad Yasevich <vyasevich@gmail.com>,
        Neil Horman <nhorman@tuxdriver.com>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        David Laight <David.Laight@ACULAB.COM>,
        linux-sctp@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH 11/51] sctp: pass a kernel pointer to sctp_setsockopt_default_send_param
Date:   Sun, 19 Jul 2020 09:21:48 +0200
Message-Id: <20200719072228.112645-12-hch@lst.de>
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
 net/sctp/socket.c | 56 ++++++++++++++++++++++-------------------------
 1 file changed, 26 insertions(+), 30 deletions(-)

diff --git a/net/sctp/socket.c b/net/sctp/socket.c
index d62c02d0b79346..9bcbb065cf9e1f 100644
--- a/net/sctp/socket.c
+++ b/net/sctp/socket.c
@@ -2867,57 +2867,54 @@ static int sctp_setsockopt_initmsg(struct sock *sk, struct sctp_initmsg *sinit,
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
 
-	if (optlen != sizeof(info))
+	if (optlen != sizeof(*info))
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
 
@@ -4695,8 +4692,7 @@ static int sctp_setsockopt(struct sock *sk, int level, int optname,
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
2.27.0

