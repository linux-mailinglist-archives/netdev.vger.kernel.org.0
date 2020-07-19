Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 72191225068
	for <lists+netdev@lfdr.de>; Sun, 19 Jul 2020 09:25:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727086AbgGSHYT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 Jul 2020 03:24:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52468 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726012AbgGSHWx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 19 Jul 2020 03:22:53 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D9E13C0619D5;
        Sun, 19 Jul 2020 00:22:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=BXeCgawf/uemQJZ5Kw+kOxWUnxAn/ZAI7ty+uHDyUUk=; b=oTAnqrBymLVCCEenokKhjbJ8IW
        BqzeRyYi/51CxpHgljygiHGDTnfuFtT09RlSRGQH/rIQN37lBhjKbcjTYl44NC38KogR3gVnPVP9K
        Ayr6KWcCrzHLkFtbtk/9CPyQeRz3BR1jQL/rM683Wt4fZ3XLtQYoPWPFQr+0qFs+5U7pw/uOKs5a9
        vQgpFMb8rvmDjV0RiaBQBs9tYM3/OmIh3G3svTikghwbJTyolCBL00dD5gfHkJ3YctMV+BvNCdJfm
        N9ifDTS8pqcp+RqGlxj2tx5Q7IYTpToHFaObLHZC1K3W7UUwO/Of0w/5af5C9a7RxMyckmNsbZRX0
        4xxV+b1A==;
Received: from [2001:4bb8:105:4a81:4ef5:9f24:cda4:103f] (helo=localhost)
        by casper.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jx3eo-0000S8-1T; Sun, 19 Jul 2020 07:22:46 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     Vlad Yasevich <vyasevich@gmail.com>,
        Neil Horman <nhorman@tuxdriver.com>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        David Laight <David.Laight@ACULAB.COM>,
        linux-sctp@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH 12/51] sctp: pass a kernel pointer to sctp_setsockopt_default_sndinfo
Date:   Sun, 19 Jul 2020 09:21:49 +0200
Message-Id: <20200719072228.112645-13-hch@lst.de>
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
 net/sctp/socket.c | 49 ++++++++++++++++++++++-------------------------
 1 file changed, 23 insertions(+), 26 deletions(-)

diff --git a/net/sctp/socket.c b/net/sctp/socket.c
index 9bcbb065cf9e1f..6695fa1cb0ca8f 100644
--- a/net/sctp/socket.c
+++ b/net/sctp/socket.c
@@ -2925,54 +2925,51 @@ static int sctp_setsockopt_default_send_param(struct sock *sk,
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
 
-	if (optlen != sizeof(info))
+	if (optlen != sizeof(*info))
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
 
@@ -4695,7 +4692,7 @@ static int sctp_setsockopt(struct sock *sk, int level, int optname,
 		retval = sctp_setsockopt_default_send_param(sk, kopt, optlen);
 		break;
 	case SCTP_DEFAULT_SNDINFO:
-		retval = sctp_setsockopt_default_sndinfo(sk, optval, optlen);
+		retval = sctp_setsockopt_default_sndinfo(sk, kopt, optlen);
 		break;
 	case SCTP_PRIMARY_ADDR:
 		retval = sctp_setsockopt_primary_addr(sk, optval, optlen);
-- 
2.27.0

