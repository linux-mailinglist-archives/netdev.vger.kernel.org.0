Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 23F5E22502A
	for <lists+netdev@lfdr.de>; Sun, 19 Jul 2020 09:23:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726777AbgGSHX3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 Jul 2020 03:23:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52604 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726755AbgGSHX0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 19 Jul 2020 03:23:26 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 91AE0C0619D5;
        Sun, 19 Jul 2020 00:23:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=lNXMC/EFP4cwjdc+4WgcnjytaCSkJ/HdBQj+wGAkKkU=; b=IdmObs+ywQPCaUDXx20QeJHxRq
        adKq6dYoqGcIiLzCGuYBQ/Vmfo6NLwsqSDv4ztMHd5W7pF66kf3iymbuKkPPfgVhtBp1Q5pDqwuLS
        l1yDO/N0F9u+MSl97sR/P0GyeSNL0W4JTpvsiNZdbEs2Xkgd/tUown4UuUajFU9RJmg9LzHTBpv5d
        aEyVI5TW5SDswj427hHHqDoFC1LS3e38Cexdtt3tMkZysij/izD+wBUqv1aeqijO/Jtpi6Mtte4V6
        X+Qtkyw3l76sIdVsfJm+9D5wLFPSd8plA0jslBDo4U3WgpBv8o25iOe8qXXM0Vndu6LJpjWEx6DIX
        iA50JxZQ==;
Received: from [2001:4bb8:105:4a81:4ef5:9f24:cda4:103f] (helo=localhost)
        by casper.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jx3fO-0000Wx-K7; Sun, 19 Jul 2020 07:23:22 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     Vlad Yasevich <vyasevich@gmail.com>,
        Neil Horman <nhorman@tuxdriver.com>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        David Laight <David.Laight@ACULAB.COM>,
        linux-sctp@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH 40/51] sctp: pass a kernel pointer to sctp_setsockopt_reset_assoc
Date:   Sun, 19 Jul 2020 09:22:17 +0200
Message-Id: <20200719072228.112645-41-hch@lst.de>
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
 net/sctp/socket.c | 25 +++++++------------------
 1 file changed, 7 insertions(+), 18 deletions(-)

diff --git a/net/sctp/socket.c b/net/sctp/socket.c
index 1365351fd2c86a..f190f59f29595a 100644
--- a/net/sctp/socket.c
+++ b/net/sctp/socket.c
@@ -4083,30 +4083,19 @@ static int sctp_setsockopt_reset_streams(struct sock *sk,
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
@@ -4675,7 +4664,7 @@ static int sctp_setsockopt(struct sock *sk, int level, int optname,
 		retval = sctp_setsockopt_reset_streams(sk, kopt, optlen);
 		break;
 	case SCTP_RESET_ASSOC:
-		retval = sctp_setsockopt_reset_assoc(sk, optval, optlen);
+		retval = sctp_setsockopt_reset_assoc(sk, kopt, optlen);
 		break;
 	case SCTP_ADD_STREAMS:
 		retval = sctp_setsockopt_add_streams(sk, optval, optlen);
-- 
2.27.0

