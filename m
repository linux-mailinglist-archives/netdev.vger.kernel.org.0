Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 724431DD520
	for <lists+netdev@lfdr.de>; Thu, 21 May 2020 19:50:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730493AbgEURte (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 May 2020 13:49:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58114 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730483AbgEURtb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 May 2020 13:49:31 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B788FC061A0E;
        Thu, 21 May 2020 10:49:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=BMkYyDLsRin/OZpBF9efei87s7wdgpDG1Mh/8tA9vhQ=; b=bn+SDjG9aZIrlZNPTXCCaBR8b1
        poYVwRL3+OYg7w9+6h/Z7O8dd8Ep6/HpOl2ELAm6I85Ra75IIBKqFUEtxsX3mIyf2a78cTKhRRILG
        3sR0CiuO2rA+Lq5wodQNjBMvcI0NnYmghVTKxV++dkOLB/9CYi/1IX/rKa8ge1yw8MTqXVN1ERXlC
        lwZ9XiyhmoOk2rMit2sJUiG1bpmDQwJqV6BOBpKAMYpBndR2ABzVpaWefVqUa6iVpodS7+srvk4Zr
        W0UgVe/5PSRmLKYY6nH+fewkhNlPQUmm9QRRvy4N7lmXxsPp3sp7hAOWszDjbwkzCZzDWvyJ/ZV3m
        NN0StxRw==;
Received: from [2001:4bb8:18c:5da7:c70:4a89:bc61:2] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jbpJy-0003SY-4A; Thu, 21 May 2020 17:49:30 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     Vlad Yasevich <vyasevich@gmail.com>,
        Neil Horman <nhorman@tuxdriver.com>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        David Laight <David.Laight@ACULAB.COM>,
        linux-sctp@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH 46/49] sctp: pass a kernel pointer to sctp_setsockopt_event
Date:   Thu, 21 May 2020 19:47:21 +0200
Message-Id: <20200521174724.2635475-47-hch@lst.de>
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
 net/sctp/socket.c | 18 ++++++------------
 1 file changed, 6 insertions(+), 12 deletions(-)

diff --git a/net/sctp/socket.c b/net/sctp/socket.c
index 9b22bb4817830..0aa7265c9c9a0 100644
--- a/net/sctp/socket.c
+++ b/net/sctp/socket.c
@@ -4292,29 +4292,23 @@ static int sctp_setsockopt_event(struct sock *sk, struct sctp_event *param,
 }
 
 static int sctp_setsockopt_asconf_supported(struct sock *sk,
-					    char __user *optval,
+					    struct sctp_assoc_value *params,
 					    unsigned int optlen)
 {
-	struct sctp_assoc_value params;
 	struct sctp_association *asoc;
 	struct sctp_endpoint *ep;
 	int retval = -EINVAL;
 
-	if (optlen != sizeof(params))
-		goto out;
-
-	if (copy_from_user(&params, optval, optlen)) {
-		retval = -EFAULT;
+	if (optlen != sizeof(*params))
 		goto out;
-	}
 
-	asoc = sctp_id2assoc(sk, params.assoc_id);
-	if (!asoc && params.assoc_id != SCTP_FUTURE_ASSOC &&
+	asoc = sctp_id2assoc(sk, params->assoc_id);
+	if (!asoc && params->assoc_id != SCTP_FUTURE_ASSOC &&
 	    sctp_style(sk, UDP))
 		goto out;
 
 	ep = sctp_sk(sk)->ep;
-	ep->asconf_enable = !!params.assoc_value;
+	ep->asconf_enable = !!params->assoc_value;
 
 	if (ep->asconf_enable && ep->auth_enable) {
 		sctp_auth_ep_add_chunkid(ep, SCTP_CID_ASCONF);
@@ -4637,7 +4631,7 @@ static int sctp_setsockopt(struct sock *sk, int level, int optname,
 		retval = sctp_setsockopt_event(sk, kopt, optlen);
 		break;
 	case SCTP_ASCONF_SUPPORTED:
-		retval = sctp_setsockopt_asconf_supported(sk, optval, optlen);
+		retval = sctp_setsockopt_asconf_supported(sk, kopt, optlen);
 		break;
 	case SCTP_AUTH_SUPPORTED:
 		retval = sctp_setsockopt_auth_supported(sk, optval, optlen);
-- 
2.26.2

