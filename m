Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A32232D3803
	for <lists+netdev@lfdr.de>; Wed,  9 Dec 2020 01:56:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725987AbgLIAz3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Dec 2020 19:55:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52550 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725768AbgLIAz3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Dec 2020 19:55:29 -0500
Received: from mail-qk1-x749.google.com (mail-qk1-x749.google.com [IPv6:2607:f8b0:4864:20::749])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 43936C061794
        for <netdev@vger.kernel.org>; Tue,  8 Dec 2020 16:54:49 -0800 (PST)
Received: by mail-qk1-x749.google.com with SMTP id o25so188911qkj.1
        for <netdev@vger.kernel.org>; Tue, 08 Dec 2020 16:54:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:in-reply-to:message-id:mime-version:references:subject
         :from:to:cc;
        bh=ui+mfxi8wpT8gvvNai/q/zsMOrHc18LzVuoveVRNu1Q=;
        b=NnHIj3G7v5EsquRDUm364Jl9AjatryYDJlL80FbRhhgTqBgJZPyIH2iPsjSdGt7YnB
         11oeVwE4oe/O9SincSiGGpyS74/Kt3ZauIXK4j74CHKoS0wKGmPec1sfiwvRMzxpiWrv
         k4BuNNNww4KBIag24TKWtN3JYU2jgRcGwM0LZ7iQcBlPJN+RJUZFd7kKCCcq7gmBm7OY
         aGK4IY9PHxPc8nZcWFbI65Jy1NJ0YHCWrxBbU9+SkF52h6cAUZxDbJ5xuW/x69DX1oGM
         ZVQ4SJ22Mk8Xj0JH3T3xnaVNOT1Mgw1BpF3ymE6z0B0HWpCAG9KaHFX4/hj7Gqj4muTJ
         bkGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=ui+mfxi8wpT8gvvNai/q/zsMOrHc18LzVuoveVRNu1Q=;
        b=L7mcS6HpnxwDdtg2u4VlqNkbrnt9nB8hOWNujMFUH6ZnOOC/uaSVQFYZMWQobjypCd
         OukJ0rdn52c+B+FicptgJTh7oALZzWj8uw2CO2ftFm5jdC8uD9+D9F37gEYs0CjO098P
         MikEPooFM9rcsY7QTuCSU45gZp8p2eQHsPzv+ZrMAVcpjVf3+1x17Nh34KZKPkD/hde5
         Mk/U1p0mW+wxI4hlsyfQjfnrNmu1o3saPeQSimPGhSySINPU2q6WqegXGTcsKILBn+ud
         ZWqOudOFi+qSJOZC/zWidaPjhEDiVNR/cQjplfcVJuKuxQQ4d2YrSdInpF4G2c+wPw5R
         2bpA==
X-Gm-Message-State: AOAM5330KZd/UhYHklcnW5N1aatLNg5U6nmwm/ZwyUBln2GaUB7BkidB
        EjBNOvwkDE/Q6YHzB6JkhT5+53BMyis=
X-Google-Smtp-Source: ABdhPJxJ4RJcDR2BCGqUW+jG7b96sn3GdysLrjWsXbw70kO32iGZRCRjSvXrSxF/w21lerZSjFadgVoZExo=
Sender: "weiwan via sendgmr" <weiwan@weiwan.svl.corp.google.com>
X-Received: from weiwan.svl.corp.google.com ([2620:15c:2c4:201:1ea0:b8ff:fe75:cf08])
 (user=weiwan job=sendgmr) by 2002:a0c:a987:: with SMTP id a7mr942498qvb.55.1607475288388;
 Tue, 08 Dec 2020 16:54:48 -0800 (PST)
Date:   Tue,  8 Dec 2020 16:54:42 -0800
In-Reply-To: <20201209005444.1949356-1-weiwan@google.com>
Message-Id: <20201209005444.1949356-2-weiwan@google.com>
Mime-Version: 1.0
References: <20201209005444.1949356-1-weiwan@google.com>
X-Mailer: git-send-email 2.29.2.576.ga3fc446d84-goog
Subject: [PATCH net-next v4 1/3] net: extract napi poll functionality to __napi_poll()
From:   Wei Wang <weiwan@google.com>
To:     David Miller <davem@davemloft.net>, netdev@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Paolo Abeni <pabeni@redhat.com>,
        Hannes Frederic Sowa <hannes@stressinduktion.org>,
        Eric Dumazet <edumazet@google.com>,
        Felix Fietkau <nbd@nbd.name>, Hillf Danton <hdanton@sina.com>
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
 net/core/dev.c | 35 +++++++++++++++++++++++++----------
 1 file changed, 25 insertions(+), 10 deletions(-)

diff --git a/net/core/dev.c b/net/core/dev.c
index ce8fea2e2788..8064af1dd03c 100644
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
2.29.2.576.ga3fc446d84-goog

