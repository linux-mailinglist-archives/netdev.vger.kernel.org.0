Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DDC0A1DD518
	for <lists+netdev@lfdr.de>; Thu, 21 May 2020 19:50:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730461AbgEURtV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 May 2020 13:49:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58070 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730453AbgEURtS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 May 2020 13:49:18 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 71469C061A0E;
        Thu, 21 May 2020 10:49:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=s3gD0819KQCrpERuq0qizqQ0CMwfWxxI1J5RSREMmE4=; b=PCDv2fn0t6Zi3cceXHVsNmEtLU
        AvIwDV6YcnBugT/iCYkYBm3br6z/pGg2xEPP379uO+IMSM/1JOtpg0dbvKtnGnUVv15Ye33gg4TSu
        /6W5OKj7/crW3We5s4bI/ZNUg/dKpH2pYDhdniFjGgimKBWaiAqVkcrqyWSMSu6TMoO90jiKxPASk
        LotMAq4jXg+7F1yAc/Ss6+HI1gs5E57e3TkGYDWKv/oS+Qasq5hIY23wl0LrA0JQuG2fkVRgQV+jA
        SgYwjkFxQjbpiaBGGCfj+IYJdRR/aWf6AzeCm4CJfR5ACAjzQ9Hvr1z6e9duJoGAf0Aoyg6/YqVH8
        q+mccsSg==;
Received: from [2001:4bb8:18c:5da7:c70:4a89:bc61:2] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jbpJk-0003Pu-Un; Thu, 21 May 2020 17:49:17 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     Vlad Yasevich <vyasevich@gmail.com>,
        Neil Horman <nhorman@tuxdriver.com>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        David Laight <David.Laight@ACULAB.COM>,
        linux-sctp@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH 41/49] sctp: pass a kernel pointer to sctp_setsockopt_scheduler
Date:   Thu, 21 May 2020 19:47:16 +0200
Message-Id: <20200521174724.2635475-42-hch@lst.de>
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
 net/sctp/socket.c | 33 ++++++++++++++-------------------
 1 file changed, 14 insertions(+), 19 deletions(-)

diff --git a/net/sctp/socket.c b/net/sctp/socket.c
index 84881913dbc7f..122e6b95a8f0d 100644
--- a/net/sctp/socket.c
+++ b/net/sctp/socket.c
@@ -4111,44 +4111,39 @@ static int sctp_setsockopt_add_streams(struct sock *sk,
 }
 
 static int sctp_setsockopt_scheduler(struct sock *sk,
-				     char __user *optval,
+				     struct sctp_assoc_value *params,
 				     unsigned int optlen)
 {
 	struct sctp_sock *sp = sctp_sk(sk);
 	struct sctp_association *asoc;
-	struct sctp_assoc_value params;
 	int retval = 0;
 
-	if (optlen < sizeof(params))
+	if (optlen < sizeof(*params))
 		return -EINVAL;
 
-	optlen = sizeof(params);
-	if (copy_from_user(&params, optval, optlen))
-		return -EFAULT;
-
-	if (params.assoc_value > SCTP_SS_MAX)
+	if (params->assoc_value > SCTP_SS_MAX)
 		return -EINVAL;
 
-	asoc = sctp_id2assoc(sk, params.assoc_id);
-	if (!asoc && params.assoc_id > SCTP_ALL_ASSOC &&
+	asoc = sctp_id2assoc(sk, params->assoc_id);
+	if (!asoc && params->assoc_id > SCTP_ALL_ASSOC &&
 	    sctp_style(sk, UDP))
 		return -EINVAL;
 
 	if (asoc)
-		return sctp_sched_set_sched(asoc, params.assoc_value);
+		return sctp_sched_set_sched(asoc, params->assoc_value);
 
 	if (sctp_style(sk, TCP))
-		params.assoc_id = SCTP_FUTURE_ASSOC;
+		params->assoc_id = SCTP_FUTURE_ASSOC;
 
-	if (params.assoc_id == SCTP_FUTURE_ASSOC ||
-	    params.assoc_id == SCTP_ALL_ASSOC)
-		sp->default_ss = params.assoc_value;
+	if (params->assoc_id == SCTP_FUTURE_ASSOC ||
+	    params->assoc_id == SCTP_ALL_ASSOC)
+		sp->default_ss = params->assoc_value;
 
-	if (params.assoc_id == SCTP_CURRENT_ASSOC ||
-	    params.assoc_id == SCTP_ALL_ASSOC) {
+	if (params->assoc_id == SCTP_CURRENT_ASSOC ||
+	    params->assoc_id == SCTP_ALL_ASSOC) {
 		list_for_each_entry(asoc, &sp->ep->asocs, asocs) {
 			int ret = sctp_sched_set_sched(asoc,
-						       params.assoc_value);
+						       params->assoc_value);
 
 			if (ret && !retval)
 				retval = ret;
@@ -4656,7 +4651,7 @@ static int sctp_setsockopt(struct sock *sk, int level, int optname,
 		retval = sctp_setsockopt_add_streams(sk, kopt, optlen);
 		break;
 	case SCTP_STREAM_SCHEDULER:
-		retval = sctp_setsockopt_scheduler(sk, optval, optlen);
+		retval = sctp_setsockopt_scheduler(sk, kopt, optlen);
 		break;
 	case SCTP_STREAM_SCHEDULER_VALUE:
 		retval = sctp_setsockopt_scheduler_value(sk, optval, optlen);
-- 
2.26.2

