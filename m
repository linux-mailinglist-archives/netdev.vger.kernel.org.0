Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C812D2F6F89
	for <lists+netdev@lfdr.de>; Fri, 15 Jan 2021 01:36:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731316AbhAOAcK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Jan 2021 19:32:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53780 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731311AbhAOAcI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Jan 2021 19:32:08 -0500
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 22CB2C061757
        for <netdev@vger.kernel.org>; Thu, 14 Jan 2021 16:31:28 -0800 (PST)
Received: by mail-yb1-xb49.google.com with SMTP id w17so3560873ybl.15
        for <netdev@vger.kernel.org>; Thu, 14 Jan 2021 16:31:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:in-reply-to:message-id:mime-version:references:subject
         :from:to:cc;
        bh=cx6sA6453BDvYfDMX3ic0zEk85EsNsUlntKHeCUyUVY=;
        b=vPqtSCPJoZszAfaszVU3lCsA8wec4AqzW3jJ+t8QXgevOhsJ57M+V0eMMm1i/4QABz
         4pTFcpz4flPEgAlrKIoYV7+X13PbsyVyTbdkHjWqeK4qpHs1rM8ctHgv5gfCNOksVpst
         ULAEBuwYGV24DHiMZGODutNpPjGSDyL8bxxv24GkDpp9QycdNB08Mqs0Qk95OijFbzbi
         KydTa6WK60QrJrOHhjoEEykQEfaZcu8Y3V99KmLIasTjy7ba+MD9Sy2+x8gPe2GGJal+
         r7B9SKp1Hjd7EYDWK3LE68Z0mVVJll6zFQLpL3rtX4CF3mCgGfFAVapazMzz0oUSfjcg
         l0Xg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=cx6sA6453BDvYfDMX3ic0zEk85EsNsUlntKHeCUyUVY=;
        b=igSiQAJH/6+gh+KF4WTMiDAE3VB9EXVsFolUszgDuH7hmkjVKWN3FqOyf5pWj6Iev3
         rJgu5IxRwKGU23BBpOKi9WFPBWHF0kSqidfQTCJ58wBzJ8zDD9pe1rn01NyAv8Wfiyau
         KcTQ+GAdF9YGa0m7vqn+uhyXqVxPlgWteNuTZoEOiFvmKH7RUJRI1AkH38L4p9dOhsx5
         s3+zwPHok5EzdmbeGuMVihsQxfDx178hdYfB2RkKOdCTX24b+4VrGlBHoxo6xB8mV8DU
         2SodZWZpZ10erbnIP6beIvZY5vK4p2K2DNjvXviuzbOHTc1sh447RzHTUCO6s1EJVCUF
         dU3A==
X-Gm-Message-State: AOAM530iooOvpBXX6GFdIUbDeX1XiDn3yBztL662OdDOqD+rCwb7ryAT
        lcz/8ksjOvuieSZiJ6c30pUgXEBjgEY=
X-Google-Smtp-Source: ABdhPJynV+wBiZqFptRUg+z7DWLHqk3/fZJEzlURgrULsPA3PMiCCSIZNPFVKh1G9ZE1ZVekPAWiv1MnAlg=
Sender: "weiwan via sendgmr" <weiwan@weiwan.svl.corp.google.com>
X-Received: from weiwan.svl.corp.google.com ([2620:15c:2c4:201:1ea0:b8ff:fe75:cf08])
 (user=weiwan job=sendgmr) by 2002:a25:4155:: with SMTP id o82mr14769773yba.206.1610670687389;
 Thu, 14 Jan 2021 16:31:27 -0800 (PST)
Date:   Thu, 14 Jan 2021 16:31:21 -0800
In-Reply-To: <20210115003123.1254314-1-weiwan@google.com>
Message-Id: <20210115003123.1254314-2-weiwan@google.com>
Mime-Version: 1.0
References: <20210115003123.1254314-1-weiwan@google.com>
X-Mailer: git-send-email 2.30.0.284.gd98b1dd5eaa7-goog
Subject: [PATCH net-next v6 1/3] net: extract napi poll functionality to __napi_poll()
From:   Wei Wang <weiwan@google.com>
To:     David Miller <davem@davemloft.net>, netdev@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Hannes Frederic Sowa <hannes@stressinduktion.org>,
        Felix Fietkau <nbd@nbd.name>
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
index e4d77c8abe76..83b59e4c0f37 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -6772,15 +6772,10 @@ void __netif_napi_del(struct napi_struct *napi)
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
@@ -6800,7 +6795,7 @@ static int napi_poll(struct napi_struct *n, struct list_head *repoll)
 			    n->poll, work, weight);
 
 	if (likely(work < weight))
-		goto out_unlock;
+		return work;
 
 	/* Drivers must not modify the NAPI state if they
 	 * consume the entire weight.  In such cases this code
@@ -6809,7 +6804,7 @@ static int napi_poll(struct napi_struct *n, struct list_head *repoll)
 	 */
 	if (unlikely(napi_disable_pending(n))) {
 		napi_complete(n);
-		goto out_unlock;
+		return work;
 	}
 
 	/* The NAPI context has more processing work, but busy-polling
@@ -6822,7 +6817,7 @@ static int napi_poll(struct napi_struct *n, struct list_head *repoll)
 			 */
 			napi_schedule(n);
 		}
-		goto out_unlock;
+		return work;
 	}
 
 	if (n->gro_bitmask) {
@@ -6840,9 +6835,29 @@ static int napi_poll(struct napi_struct *n, struct list_head *repoll)
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
2.30.0.284.gd98b1dd5eaa7-goog

