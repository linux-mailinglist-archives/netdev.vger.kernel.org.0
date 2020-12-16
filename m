Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EFC8F2DB868
	for <lists+netdev@lfdr.de>; Wed, 16 Dec 2020 02:26:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726196AbgLPB0A (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Dec 2020 20:26:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60662 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725275AbgLPBZ7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Dec 2020 20:25:59 -0500
Received: from mail-pj1-x1049.google.com (mail-pj1-x1049.google.com [IPv6:2607:f8b0:4864:20::1049])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 91E4BC061794
        for <netdev@vger.kernel.org>; Tue, 15 Dec 2020 17:25:19 -0800 (PST)
Received: by mail-pj1-x1049.google.com with SMTP id z21so656665pjq.2
        for <netdev@vger.kernel.org>; Tue, 15 Dec 2020 17:25:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:in-reply-to:message-id:mime-version:references:subject
         :from:to:cc;
        bh=FWLZEuLYB982KnNGc9xHkM2zERMjxUiTaVFRk9jyAaI=;
        b=aGITe6Flf4FMG5NUkIrERkwo/YTE5rUNI0fcle+4/Vxv4OA6VDIwboBH7SXZGAGbD0
         iaH7rJo8YzXjm3vCr1Ku/3Upa6V58uNC/917U8+gmdgcsHaFy69r9Wgw/aIUbxPaHKFg
         lORtSGI2x/ttAy4+P40UT87sC0RbTiPIlDJKhUN8rWyjvKcoWkNCijzT2zdW91q5CC18
         HUHmVjkr7U6cLwEM/F4vaNLUEH85P3IopEXIkyAq2djjS/P6VF89ibv08xpuv/Pc1sue
         EZe7LIZzrQRpt4fnDWEbdROVpkKi9kMxR9Wiv9r7T1s+wjR3FOwPZQirEX4nnM0HFtnr
         uedA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=FWLZEuLYB982KnNGc9xHkM2zERMjxUiTaVFRk9jyAaI=;
        b=JtV7BAyyjTwLaIdGCYl/U46jX/QJY4TByNSGlY7Rf/8+A61S4m283xAgyvfRWWPd3j
         3GozgCWPpb700X82WiCvjtCpxCtld4SLch3Mw7ALnG0WSdZP9Z7bDFbcihO2zYBa0GFv
         yutAkRWldbtEW4TgUoCZwPjATnaKO9C0oY3567MukzJ3crfGbGHGbwPa2WCG7KcdpOPv
         L2ie40iJlTZTJamwiyKpRVmmDy6zxaXcxiivkGEPoTiTTSeMwr47c4eiyGkPko8uaGz6
         +1SEqw87HC8w+Gpt2V8nNjEMYo/goE/KRAatHU4/sIQBNYsRWinjinuYRVvGski730yq
         LMMA==
X-Gm-Message-State: AOAM531wRmoBAlPZMLyXKfYLMynaWomOGUToMpT+GuAcqxe5T5xuR+/M
        tdNLxtuBTFYNibo9Uv4KnNYDvpqm9KI=
X-Google-Smtp-Source: ABdhPJx9fIKUYW7dY75eceT4w9jdxd/USJSdzhg0a305NznHO4kpu1q2CtDEo5mba2NUup2tuHCGMvDQj1E=
Sender: "weiwan via sendgmr" <weiwan@weiwan.svl.corp.google.com>
X-Received: from weiwan.svl.corp.google.com ([2620:15c:2c4:201:1ea0:b8ff:fe75:cf08])
 (user=weiwan job=sendgmr) by 2002:a05:6a00:2302:b029:198:4459:e6c9 with SMTP
 id h2-20020a056a002302b02901984459e6c9mr29969080pfh.33.1608081919079; Tue, 15
 Dec 2020 17:25:19 -0800 (PST)
Date:   Tue, 15 Dec 2020 17:25:13 -0800
In-Reply-To: <20201216012515.560026-1-weiwan@google.com>
Message-Id: <20201216012515.560026-2-weiwan@google.com>
Mime-Version: 1.0
References: <20201216012515.560026-1-weiwan@google.com>
X-Mailer: git-send-email 2.29.2.684.gfbc64c5ab5-goog
Subject: [PATCH net-next v5 1/3] net: extract napi poll functionality to __napi_poll()
From:   Wei Wang <weiwan@google.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>, netdev@vger.kernel.org
Cc:     Paolo Abeni <pabeni@redhat.com>,
        Hannes Frederic Sowa <hannes@stressinduktion.org>,
        Felix Fietkau <nbd@nbd.name>,
        Eric Dumazet <edumazet@google.com>
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
---
 net/core/dev.c | 35 +++++++++++++++++++++++++----------
 1 file changed, 25 insertions(+), 10 deletions(-)

diff --git a/net/core/dev.c b/net/core/dev.c
index 0fd0d4eb678c..adf74573f51c 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -6765,15 +6765,10 @@ void __netif_napi_del(struct napi_struct *napi)
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
@@ -6793,7 +6788,7 @@ static int napi_poll(struct napi_struct *n, struct list_head *repoll)
 			    n->poll, work, weight);
 
 	if (likely(work < weight))
-		goto out_unlock;
+		return work;
 
 	/* Drivers must not modify the NAPI state if they
 	 * consume the entire weight.  In such cases this code
@@ -6802,7 +6797,7 @@ static int napi_poll(struct napi_struct *n, struct list_head *repoll)
 	 */
 	if (unlikely(napi_disable_pending(n))) {
 		napi_complete(n);
-		goto out_unlock;
+		return work;
 	}
 
 	/* The NAPI context has more processing work, but busy-polling
@@ -6815,7 +6810,7 @@ static int napi_poll(struct napi_struct *n, struct list_head *repoll)
 			 */
 			napi_schedule(n);
 		}
-		goto out_unlock;
+		return work;
 	}
 
 	if (n->gro_bitmask) {
@@ -6833,9 +6828,29 @@ static int napi_poll(struct napi_struct *n, struct list_head *repoll)
 	if (unlikely(!list_empty(&n->poll_list))) {
 		pr_warn_once("%s: Budget exhausted after napi rescheduled\n",
 			     n->dev ? n->dev->name : "backlog");
-		goto out_unlock;
+		return work;
 	}
 
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
 	list_add_tail(&n->poll_list, repoll);
 
 out_unlock:
-- 
2.29.2.684.gfbc64c5ab5-goog

