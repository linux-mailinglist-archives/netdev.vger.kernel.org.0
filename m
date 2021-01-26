Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CB2D9304942
	for <lists+netdev@lfdr.de>; Tue, 26 Jan 2021 20:56:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726867AbhAZFbq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Jan 2021 00:31:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47074 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727700AbhAZBbd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Jan 2021 20:31:33 -0500
Received: from mail-pg1-x549.google.com (mail-pg1-x549.google.com [IPv6:2607:f8b0:4864:20::549])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B3B2C061A31
        for <netdev@vger.kernel.org>; Mon, 25 Jan 2021 17:11:13 -0800 (PST)
Received: by mail-pg1-x549.google.com with SMTP id f16so1970691pgh.3
        for <netdev@vger.kernel.org>; Mon, 25 Jan 2021 17:11:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:in-reply-to:message-id:mime-version:references:subject
         :from:to:cc;
        bh=8vibuuj1dKsMOvwlhBBf+nTr0uc0591aLFH4MSVjWJs=;
        b=vylLPnbqG6mOcGEHqzPYtqA7BjxA2mni15PJJ+Z795mgss1XnvQMYmGWhQWMA4vLHW
         S88EPl1wzL2fYB0mT+Ajt8uhgN7zEgpkkHuj8jz7HR5OnqmtrqE13rYCw0XDGVyaIRS6
         6roBpcjMjdRaI+XAiM3oK4XdFTHzgqzpt6rC5WxjE9uDEnLf6bLdY1ZyMs0ErazXTFPv
         +gBmGQxwxa7A3o71AHmrjyjYYP8+zUViRQCTsWRYSHo2pj12gxPGbebF4IUttuTv+Ffh
         xvo6vp8VH426PiY7bgxI1kF16sgO5wCpvw/avvYIu4d8MdOBesBfDaF8C2PMhyqwaO1z
         1WVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=8vibuuj1dKsMOvwlhBBf+nTr0uc0591aLFH4MSVjWJs=;
        b=EtBc/d8ZhCny0z+Sa+nmbAN43OtvwZ8WJb1ZkavdQQxhwig0dh8KMeCGmknv5/nzWY
         GqHEJgP91x871Dh94o/yiS+VTOoWGbLtHBxKgMzWXrzyJBTHAPNBtRKhKaNAA1Wz4979
         e9To6mUL4f4fWScPlgf8dcepg90x7wC9wxrRl/L9NsgmZKWRMelS4urv//nagkeOqzuh
         9mfT3ieK9zPOkW1kvpPytV2OG68tK2pQu49zFhByd16tbVuNE2uXMdrc53GGMtAtk2KX
         efPZDtBJ8fbf9fGGRuW9BOEi4RWFr5ZaPg68OtJJ6vSqZLzfhNDjRi5VhSDm7jCB5I49
         ghWA==
X-Gm-Message-State: AOAM533KCoxUgbnWfNsCwYU+vFuXtAr+ZMfVf1BckeWGZv10oqRn+fv/
        hneavM409wH5FQnbiOLH7U6H053DsVc=
X-Google-Smtp-Source: ABdhPJxUP2LYKoYaBIZWWk2MDu1iHgNaWZO8QvbsMzZ52Jan8Z6soHKg4n/V3y3sAjDGm4RjwKj6/ufefLI=
Sender: "weiwan via sendgmr" <weiwan@weiwan.svl.corp.google.com>
X-Received: from weiwan.svl.corp.google.com ([2620:15c:2c4:201:1ea0:b8ff:fe75:cf08])
 (user=weiwan job=sendgmr) by 2002:a63:da17:: with SMTP id c23mr3178197pgh.348.1611623473076;
 Mon, 25 Jan 2021 17:11:13 -0800 (PST)
Date:   Mon, 25 Jan 2021 17:11:07 -0800
In-Reply-To: <20210126011109.2425966-1-weiwan@google.com>
Message-Id: <20210126011109.2425966-2-weiwan@google.com>
Mime-Version: 1.0
References: <20210126011109.2425966-1-weiwan@google.com>
X-Mailer: git-send-email 2.30.0.280.ga3ce27912f-goog
Subject: [PATCH net-next v8 1/3] net: extract napi poll functionality to __napi_poll()
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
2.30.0.280.ga3ce27912f-goog

