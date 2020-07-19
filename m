Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B9BAB22503D
	for <lists+netdev@lfdr.de>; Sun, 19 Jul 2020 09:24:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726952AbgGSHXu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 Jul 2020 03:23:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52636 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726824AbgGSHXe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 19 Jul 2020 03:23:34 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E1F39C0619D2;
        Sun, 19 Jul 2020 00:23:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=1mc8Ew5HuGuSaC5GXoal6KCjPQmDaLuvrauJuPPoBKU=; b=Mt0hD5jLYKwb3cQVETMIsh22CN
        kiRNr+Ln2YbEAY6hHSn0mO9WAU6HiqOP3gTJzAs/Ik/G4KwKhPwRUImO4APKIlGNPBxI4C+sQMjq/
        oUzDoRScEEodfg6kUbKf9BHyYINvClpVFcNxAWgsWE1LX++T9akq6dJ9pMXE/IbwlnLlgDBWU7Wmu
        Yk/234X7Xen7UzhYHiR/KEfanU4OEioxg4nVqNCxUrKz/2E6fZngM2BSn7WmI9n1V7/Yp3BpOBKBH
        PK1DXJckfPpx10oVa6pac2BYmeFqvQXJlZt4+kX3EcUqtsTHR5YR8HAE0IwY1DKS1sFLZSTL/x7PR
        cLqCfZGA==;
Received: from [2001:4bb8:105:4a81:4ef5:9f24:cda4:103f] (helo=localhost)
        by casper.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jx3fW-0000Y5-20; Sun, 19 Jul 2020 07:23:30 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     Vlad Yasevich <vyasevich@gmail.com>,
        Neil Horman <nhorman@tuxdriver.com>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        David Laight <David.Laight@ACULAB.COM>,
        linux-sctp@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH 46/51] sctp: pass a kernel pointer to sctp_setsockopt_event
Date:   Sun, 19 Jul 2020 09:22:23 +0200
Message-Id: <20200719072228.112645-47-hch@lst.de>
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
 net/sctp/socket.c | 35 +++++++++++++++--------------------
 1 file changed, 15 insertions(+), 20 deletions(-)

diff --git a/net/sctp/socket.c b/net/sctp/socket.c
index a5b95e68cc129f..12a33fc42eeeb2 100644
--- a/net/sctp/socket.c
+++ b/net/sctp/socket.c
@@ -4252,45 +4252,40 @@ static int sctp_assoc_ulpevent_type_set(struct sctp_event *param,
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
@@ -4643,7 +4638,7 @@ static int sctp_setsockopt(struct sock *sk, int level, int optname,
 		retval = sctp_setsockopt_reuse_port(sk, kopt, optlen);
 		break;
 	case SCTP_EVENT:
-		retval = sctp_setsockopt_event(sk, optval, optlen);
+		retval = sctp_setsockopt_event(sk, kopt, optlen);
 		break;
 	case SCTP_ASCONF_SUPPORTED:
 		retval = sctp_setsockopt_asconf_supported(sk, optval, optlen);
-- 
2.27.0

