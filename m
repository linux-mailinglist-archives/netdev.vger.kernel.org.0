Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 426C72FC927
	for <lists+netdev@lfdr.de>; Wed, 20 Jan 2021 04:38:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731120AbhATDhK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Jan 2021 22:37:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53438 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729157AbhATDfj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Jan 2021 22:35:39 -0500
Received: from mail-qk1-x749.google.com (mail-qk1-x749.google.com [IPv6:2607:f8b0:4864:20::749])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 99946C061757
        for <netdev@vger.kernel.org>; Tue, 19 Jan 2021 19:34:59 -0800 (PST)
Received: by mail-qk1-x749.google.com with SMTP id v82so1587329qka.1
        for <netdev@vger.kernel.org>; Tue, 19 Jan 2021 19:34:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:in-reply-to:message-id:mime-version:references:subject
         :from:to:cc;
        bh=GEnbV0K9Jb+RKT48b6RuHWSBGAsU15uTC0ONIDUvdJU=;
        b=PVzgPCrivGArws4gjHNUd2OJiSaLIvJOxbkrXVMRInUekqmyymyDjWGXHhZVet3JfX
         staQ4GP0KOUjCyQ6NtOUKrGkV1EirKKLKbyXMmWm2QNB1GCi6loVi50/f7W2LlrHsN/l
         08jl5iblLRFHaZmQG/Yxh9vCoWvN3JSJA/kzqovpx3+mDKvi/17VUK3RWz1cHN59g1/h
         JdUVTzDGUjC9HE58x+FptM/uM0ehy/tZde9UydMcljv/1u2Jeip2qz2mEbcgcCa8DgXh
         hJTNfFAwj+0L1YTJUApQkMPUFZY9D01nBpWp/ntsiAkkoWyu6BHdyuL78bL6CJ6X/Go2
         gsAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=GEnbV0K9Jb+RKT48b6RuHWSBGAsU15uTC0ONIDUvdJU=;
        b=n/MUCNT4jhrOZ1RYzZWcGu3AGpHbyJXZZdq+w+blXhxBYS+Ov3/uQp0Rmk4AKy42sS
         9uZHYPJ7b/RHYhY35Qx30L+U678PiZcAH9SSPX/qA7BxUL9EPeKRDOdYpNe2LSuNviTY
         yGikvJLEoOpj7wyP/T7HcH8BWxO7aJnWSRczEf2L40AqUBFkAbBF+DZ8arld1Sf6c2fX
         5aIfFlZ3eoCDrrAo+r7cI3yCElSsqZbBIceCxc1J1p1jaFDu1uVv4gubc5axkyJqDnxr
         mwZs+iLpfSV13CZJWdSOF1HCwRlR3cF7kuzOu0sgHvo4oDjsVuYlKmKrfDMSLzu/MCCm
         Gj0w==
X-Gm-Message-State: AOAM533b7bC+KCfmuFMrUjBXQyYQwXX7BBVAAHDsWK+UFc0B7HlKzx5y
        AXTZdqnEyjuFda9Y82dZR49RUrrI+rk=
X-Google-Smtp-Source: ABdhPJw43h0z0ZLS/9VQdpIjYf0oqHaLX98oYnaaqHbI5/Kyx7lmgmbXEfCNvZavuFnMPM27El6Fd0X8IjQ=
Sender: "weiwan via sendgmr" <weiwan@weiwan.svl.corp.google.com>
X-Received: from weiwan.svl.corp.google.com ([2620:15c:2c4:201:1ea0:b8ff:fe75:cf08])
 (user=weiwan job=sendgmr) by 2002:a0c:b21e:: with SMTP id x30mr7779366qvd.21.1611113698764;
 Tue, 19 Jan 2021 19:34:58 -0800 (PST)
Date:   Tue, 19 Jan 2021 19:34:53 -0800
In-Reply-To: <20210120033455.4034611-1-weiwan@google.com>
Message-Id: <20210120033455.4034611-2-weiwan@google.com>
Mime-Version: 1.0
References: <20210120033455.4034611-1-weiwan@google.com>
X-Mailer: git-send-email 2.30.0.284.gd98b1dd5eaa7-goog
Subject: [PATCH net-next v7 1/3] net: extract napi poll functionality to __napi_poll()
From:   Wei Wang <weiwan@google.com>
To:     David Miller <davem@davemloft.net>, netdev@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Hannes Frederic Sowa <hannes@stressinduktion.org>,
        Felix Fietkau <nbd@nbd.name>,
        Alexander Duyck <alexander.duyck@gmail.com>
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
2.30.0.284.gd98b1dd5eaa7-goog

