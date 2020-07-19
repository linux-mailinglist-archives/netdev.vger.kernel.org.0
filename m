Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2F6EC225052
	for <lists+netdev@lfdr.de>; Sun, 19 Jul 2020 09:24:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727042AbgGSHYI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 Jul 2020 03:24:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52542 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726620AbgGSHXL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 19 Jul 2020 03:23:11 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B02DC0619D2;
        Sun, 19 Jul 2020 00:23:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=KhreG9nwoT7dAW0fB0NKyfsZVEBqelF4yR7Eq7WY9tE=; b=CG9JIINe+kv0+wUxJ4XHD4FZED
        L5PP55+sMSNWI/2G7BoQNvAr9YCCW6/2Jb3qeOIKkCI9OIuv3EFuHpJmhIx1SOWhGloZrw3YfA6vO
        /g7ZvCJqYYBHa7mXS5EUb50SphMxtB9MRE78h2n0Bbl+/glnuOdHdvVQXRo5ukVplZNuMNub9fO5b
        I2suaF+OIeXF9nmScRax9KqOm7KUXcxaSJ1tk+NwNh/dIelOg0BKjiyr8x5cQr1cd6Uj7HMaiPkK0
        G1eEqDnpMiOamJtjXqptcyfq1PyZ9FpycGBIpBK11L7pUfMqxrbMhjtMK9IoWvPclKi7vkVHeSddY
        fFhp8MSA==;
Received: from [2001:4bb8:105:4a81:4ef5:9f24:cda4:103f] (helo=localhost)
        by casper.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jx3f8-0000Ur-A3; Sun, 19 Jul 2020 07:23:07 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     Vlad Yasevich <vyasevich@gmail.com>,
        Neil Horman <nhorman@tuxdriver.com>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        David Laight <David.Laight@ACULAB.COM>,
        linux-sctp@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH 28/51] sctp: pass a kernel pointer to sctp_setsockopt_active_key
Date:   Sun, 19 Jul 2020 09:22:05 +0200
Message-Id: <20200719072228.112645-29-hch@lst.de>
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
 net/sctp/socket.c | 27 ++++++++++++---------------
 1 file changed, 12 insertions(+), 15 deletions(-)

diff --git a/net/sctp/socket.c b/net/sctp/socket.c
index b4dcccba5787e3..02153f243683ea 100644
--- a/net/sctp/socket.c
+++ b/net/sctp/socket.c
@@ -3655,42 +3655,39 @@ static int sctp_setsockopt_auth_key(struct sock *sk,
  * the association shared key.
  */
 static int sctp_setsockopt_active_key(struct sock *sk,
-				      char __user *optval,
+				      struct sctp_authkeyid *val,
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
-		return sctp_auth_set_active_key(ep, asoc, val.scact_keynumber);
+		return sctp_auth_set_active_key(ep, asoc, val->scact_keynumber);
 
 	if (sctp_style(sk, TCP))
-		val.scact_assoc_id = SCTP_FUTURE_ASSOC;
+		val->scact_assoc_id = SCTP_FUTURE_ASSOC;
 
-	if (val.scact_assoc_id == SCTP_FUTURE_ASSOC ||
-	    val.scact_assoc_id == SCTP_ALL_ASSOC) {
-		ret = sctp_auth_set_active_key(ep, asoc, val.scact_keynumber);
+	if (val->scact_assoc_id == SCTP_FUTURE_ASSOC ||
+	    val->scact_assoc_id == SCTP_ALL_ASSOC) {
+		ret = sctp_auth_set_active_key(ep, asoc, val->scact_keynumber);
 		if (ret)
 			return ret;
 	}
 
-	if (val.scact_assoc_id == SCTP_CURRENT_ASSOC ||
-	    val.scact_assoc_id == SCTP_ALL_ASSOC) {
+	if (val->scact_assoc_id == SCTP_CURRENT_ASSOC ||
+	    val->scact_assoc_id == SCTP_ALL_ASSOC) {
 		list_for_each_entry(asoc, &ep->asocs, asocs) {
 			int res = sctp_auth_set_active_key(ep, asoc,
-							   val.scact_keynumber);
+							   val->scact_keynumber);
 
 			if (res && !ret)
 				ret = res;
@@ -4689,7 +4686,7 @@ static int sctp_setsockopt(struct sock *sk, int level, int optname,
 		retval = sctp_setsockopt_auth_key(sk, kopt, optlen);
 		break;
 	case SCTP_AUTH_ACTIVE_KEY:
-		retval = sctp_setsockopt_active_key(sk, optval, optlen);
+		retval = sctp_setsockopt_active_key(sk, kopt, optlen);
 		break;
 	case SCTP_AUTH_DELETE_KEY:
 		retval = sctp_setsockopt_del_key(sk, optval, optlen);
-- 
2.27.0

