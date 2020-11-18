Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 69C552B854F
	for <lists+netdev@lfdr.de>; Wed, 18 Nov 2020 21:07:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726663AbgKRUHW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Nov 2020 15:07:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35120 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725710AbgKRUHW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Nov 2020 15:07:22 -0500
Received: from mail-pf1-x44a.google.com (mail-pf1-x44a.google.com [IPv6:2607:f8b0:4864:20::44a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 74DEBC0613D4
        for <netdev@vger.kernel.org>; Wed, 18 Nov 2020 12:07:22 -0800 (PST)
Received: by mail-pf1-x44a.google.com with SMTP id b23so778294pfp.15
        for <netdev@vger.kernel.org>; Wed, 18 Nov 2020 12:07:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:in-reply-to:message-id:mime-version:references:subject
         :from:to:cc;
        bh=G8hWwIw1O/XzD0iRvl1/p1SRPUAAJsJjTcuCciOramk=;
        b=A8+WD7+BtZ8SbsLMQx7Jh+1fj5CcExfRR7Cnsgzf1qVs22/JdwDcTjy3a+qtNyiYoY
         IxK4WEa25XLoIAXeBirZ6q8zZpFiMOBPTLcKSDLUcJ6EyBJIz8NSxorqvzZOV+556ItT
         Pds29Lvww9JpznXCFGwiyKncDra/kr+fWUUgHexNnfwdZ2gYzULiMGeSQA2UTuyI+t4c
         46eQUcKvVp8dLMYXudrFCjY+J6Vv5Ch0xRN688srGxExHnxUOuUSNXkwO+zEwV5DavF0
         FVs33KAPXFpy6KZOQfMfEOqgNP5xtA+P7b4yIKJqUw/64g0+2269xfeiviIrtMWO0sCI
         vUmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=G8hWwIw1O/XzD0iRvl1/p1SRPUAAJsJjTcuCciOramk=;
        b=O8AziAlLAkiY8fXrarafkZq67uFkMDVLW2UgkyQSxsUM6iLq7Toh1aycMpsyeZHWGd
         HaBeYe3gnwa4jWxEWpwXntJObjIeyMMBFiUf9mLbseZM+dxb4miEBsVlKb1ZiGah82ox
         Fjg7xWQPyRmfzJ61y3jBRUKubYUc6L/G75X3jO1h17Ew9+4k2m6oOYuEixTz1yncQvnA
         VAPwFCFsnq80Y6hp/TwL6QW2q955a0Hy+CToKamm8tyzqk9Jw5Vz2ibcpHi4SUW703c9
         byZ/wHJ8qL2Vl0W+kCkeXZEgBWyO1YJLpykgWSv/sOlJElpsr+QTxbbTrMRJq6kjRnsx
         rq/A==
X-Gm-Message-State: AOAM5300h3nzqalz4VY7RcjC8/RoZ0ambR9nZLOVt3inBxY/HcNNJRgd
        71hkS5dbraqQsA33BZISVg9rywuxvqU=
X-Google-Smtp-Source: ABdhPJwFOsWTpz6B34ulUjf/ehkr2SMyf7j6gm/sG+o056BIux0otfP4p2XCBnM7g1G2SR6DXJLCmM2Cyvc=
Sender: "weiwan via sendgmr" <weiwan@weiwan.svl.corp.google.com>
X-Received: from weiwan.svl.corp.google.com ([2620:15c:2c4:201:1ea0:b8ff:fe75:cf08])
 (user=weiwan job=sendgmr) by 2002:a62:2ec3:0:b029:197:6ca1:2498 with SMTP id
 u186-20020a622ec30000b02901976ca12498mr6027294pfu.32.1605730042013; Wed, 18
 Nov 2020 12:07:22 -0800 (PST)
Date:   Wed, 18 Nov 2020 11:10:07 -0800
In-Reply-To: <20201118191009.3406652-1-weiwan@google.com>
Message-Id: <20201118191009.3406652-4-weiwan@google.com>
Mime-Version: 1.0
References: <20201118191009.3406652-1-weiwan@google.com>
X-Mailer: git-send-email 2.29.2.454.gaff20da3a2-goog
Subject: [PATCH net-next v3 3/5] net: extract napi poll functionality to __napi_poll()
From:   Wei Wang <weiwan@google.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Cc:     Eric Dumazet <edumazet@google.com>, Felix Fietkau <nbd@nbd.name>,
        Paolo Abeni <pabeni@redhat.com>,
        Hannes Frederic Sowa <hannes@stressinduktion.org>,
        Hillf Danton <hdanton@sina.com>, Wei Wang <weiwan@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Felix Fietkau <nbd@nbd.name> 

This commit introduces a new function __napi_poll() which does the main
logic of the existing napi_poll() function, and will be called by other
functions in later commits.
This idea and implementation is done by Felix Fietkau <nbd@nbd.name> and
is proposed as part of the patch to move napi work to work_queue
context.
This commit by itself is a code restructure.

Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Wei Wang <weiwan@google.com>
Reviewed-by: Eric Dumazet <edumazet@google.com>
---
 net/core/dev.c | 31 +++++++++++++++++++++++--------
 1 file changed, 23 insertions(+), 8 deletions(-)

diff --git a/net/core/dev.c b/net/core/dev.c
index a5d2ead8be78..a739dbbe4d89 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -6796,15 +6796,10 @@ void __netif_napi_del(struct napi_struct *napi)
 }
 EXPORT_SYMBOL(__netif_napi_del);
 
-static int napi_poll(struct napi_struct *n, struct list_head *repoll)
+static int __napi_poll(struct napi_struct *n, bool *repoll)
 {
-	void *have;
 	int work, weight;
 
-	list_del_init(&n->poll_list);
-
-	have = netpoll_poll_lock(n);
-
 	weight = n->weight;
 
 	/* This NAPI_STATE_SCHED test is for avoiding a race
@@ -6824,7 +6819,7 @@ static int napi_poll(struct napi_struct *n, struct list_head *repoll)
 			    n->poll, work, weight);
 
 	if (likely(work < weight))
-		goto out_unlock;
+		return work;
 
 	/* Drivers must not modify the NAPI state if they
 	 * consume the entire weight.  In such cases this code
@@ -6833,7 +6828,7 @@ static int napi_poll(struct napi_struct *n, struct list_head *repoll)
 	 */
 	if (unlikely(napi_disable_pending(n))) {
 		napi_complete(n);
-		goto out_unlock;
+		return work;
 	}
 
 	if (n->gro_bitmask) {
@@ -6845,6 +6840,26 @@ static int napi_poll(struct napi_struct *n, struct list_head *repoll)
 
 	gro_normal_list(n);
 
+	*repoll = true;
+
+	return work;
+}
+
+static int napi_poll(struct napi_struct *n, struct list_head *repoll)
+{
+	bool do_repoll = false;
+	void *have;
+	int work;
+
+	list_del_init(&n->poll_list);
+
+	have = netpoll_poll_lock(n);
+
+	work = __napi_poll(n, &do_repoll);
+
+	if (!do_repoll)
+		goto out_unlock;
+
 	/* Some drivers may have called napi_schedule
 	 * prior to exhausting their budget.
 	 */
-- 
2.29.2.454.gaff20da3a2-goog

