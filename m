Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C13FF308C46
	for <lists+netdev@lfdr.de>; Fri, 29 Jan 2021 19:20:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232645AbhA2ST3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Jan 2021 13:19:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33660 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232392AbhA2SS4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 Jan 2021 13:18:56 -0500
Received: from mail-pj1-x104a.google.com (mail-pj1-x104a.google.com [IPv6:2607:f8b0:4864:20::104a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C99A7C061756
        for <netdev@vger.kernel.org>; Fri, 29 Jan 2021 10:18:16 -0800 (PST)
Received: by mail-pj1-x104a.google.com with SMTP id t13so6220033pje.9
        for <netdev@vger.kernel.org>; Fri, 29 Jan 2021 10:18:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:in-reply-to:message-id:mime-version:references:subject
         :from:to:cc;
        bh=zduKzB4SHHg86ETK7TMU+wxErJA55bou44JDWAquHc4=;
        b=jPLOwoyrpkj67SfbVJNlwQwWM4Jhu+6h3pZELqlgF4lzgSB2/yXIb0mIJrT0wFhNUn
         1q1iZf34Ik1vU6htlhYv7ekLtbIzDQ6Ie0xH+4KNzxo6pG2IwaJLoXcx5K5bichaixeQ
         Ypiy6T5RsZf+Sli7zGlvPhhpHK9KfdyQfChITkpKDkntyfySItlvO9InYm8NracTd1Il
         /0Ve889ruSaA4+E3FPePLDZSThBdVz8J7mnp9SapCOroRN3C3PEuf26KTazBmf2hLRbg
         Dka2hcoONFb05YKdLaYLdHmmiVHyESNN/WrQT97qYuB9YKal6wWnzKl3cI6efYppmSoE
         1XLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=zduKzB4SHHg86ETK7TMU+wxErJA55bou44JDWAquHc4=;
        b=MTjNj0Kj0/7L8BNb6fuSLnQ8wWUF18vocTx++omH8yR2jZDvnvxY3hH/5QtwrOPGvo
         24p8Pg4fzdtAWKPquqAwaia0fsd+kjXagPQ+nsPkb87uS3MNZ+sUOhPwbTiBdCyLEcSw
         I8ipeDbynxmKc9KjtcMK3mZWsfXUXGz746ORvRuO0/UIBU0Vjb1E+ZWtubc6oSevkFPc
         ZofriMUBOgh2wOuQKQDFBYc3sO8A3faOxV7mQQl0RvPjEiiOx61xusS+oYf2O2FGm9u5
         a6Mjt1HW/Pvol2fVWVe9hT/O5aPyU67kTNWHRxp+aLxUOLFx/TIkKcdm287xcqa0BZTz
         UHjw==
X-Gm-Message-State: AOAM533py+Zzy0cyCC2u7xvi5dv2UoKe8TH2SXUauXStcvc9UZEyaB29
        a69cCDBZD2KB1g+dorR5GER0oDXXwUs=
X-Google-Smtp-Source: ABdhPJziGSZ2rrQBEf6MPLhBdKpAAtQV9RW/KUiP973p4Kj2NHmlSehECnJ9D8cNi0nBWJPwF4dtOKcJI7M=
Sender: "weiwan via sendgmr" <weiwan@weiwan.svl.corp.google.com>
X-Received: from weiwan.svl.corp.google.com ([2620:15c:2c4:201:69ee:ceb1:90eb:1722])
 (user=weiwan job=sendgmr) by 2002:a17:90a:4a90:: with SMTP id
 f16mr5586509pjh.100.1611944296174; Fri, 29 Jan 2021 10:18:16 -0800 (PST)
Date:   Fri, 29 Jan 2021 10:18:10 -0800
In-Reply-To: <20210129181812.256216-1-weiwan@google.com>
Message-Id: <20210129181812.256216-2-weiwan@google.com>
Mime-Version: 1.0
References: <20210129181812.256216-1-weiwan@google.com>
X-Mailer: git-send-email 2.30.0.365.g02bc693789-goog
Subject: [PATCH net-next v9 1/3] net: extract napi poll functionality to __napi_poll()
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
index 0332f2e8f7da..7d23bff03864 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -6768,15 +6768,10 @@ void __netif_napi_del(struct napi_struct *napi)
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
@@ -6796,7 +6791,7 @@ static int napi_poll(struct napi_struct *n, struct list_head *repoll)
 			    n->poll, work, weight);
 
 	if (likely(work < weight))
-		goto out_unlock;
+		return work;
 
 	/* Drivers must not modify the NAPI state if they
 	 * consume the entire weight.  In such cases this code
@@ -6805,7 +6800,7 @@ static int napi_poll(struct napi_struct *n, struct list_head *repoll)
 	 */
 	if (unlikely(napi_disable_pending(n))) {
 		napi_complete(n);
-		goto out_unlock;
+		return work;
 	}
 
 	/* The NAPI context has more processing work, but busy-polling
@@ -6818,7 +6813,7 @@ static int napi_poll(struct napi_struct *n, struct list_head *repoll)
 			 */
 			napi_schedule(n);
 		}
-		goto out_unlock;
+		return work;
 	}
 
 	if (n->gro_bitmask) {
@@ -6836,9 +6831,29 @@ static int napi_poll(struct napi_struct *n, struct list_head *repoll)
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
2.30.0.365.g02bc693789-goog

