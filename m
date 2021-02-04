Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EEE3430FF56
	for <lists+netdev@lfdr.de>; Thu,  4 Feb 2021 22:32:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230050AbhBDVcH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Feb 2021 16:32:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60724 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230001AbhBDVcC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 4 Feb 2021 16:32:02 -0500
Received: from mail-pj1-x1049.google.com (mail-pj1-x1049.google.com [IPv6:2607:f8b0:4864:20::1049])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B038C06178A
        for <netdev@vger.kernel.org>; Thu,  4 Feb 2021 13:31:22 -0800 (PST)
Received: by mail-pj1-x1049.google.com with SMTP id t6so2962471pje.9
        for <netdev@vger.kernel.org>; Thu, 04 Feb 2021 13:31:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:in-reply-to:message-id:mime-version:references:subject
         :from:to:cc;
        bh=tjTS3kEeQ+IonJ+K5+N9UT8qiB72Ta632M9PwJCf/+k=;
        b=mFlWyWYSeFesdsXP5dNeu+BWgVM/+5hC4lSyDVpVlpbjkeNYRs8ZgSb0B2HqAttlpC
         hmBVjfSUuhSpMpFxU3hkKkJtzqJ/zoaL/rLqzx5AvflB9Z3myR6DysrtIIMNBecX9TzF
         nJnG7N5z1Go3bz6kSNtiFre4fk4sN6GePde1ZnmG1EoET1Tq+Zd6H+FYiF1v1/PKcUX4
         kEPdevRBPesgecI4KlQe6u5KykeqB6wRmZtcTBBy5HgzV8TKkRoXk25qRFjIyRu+4nN+
         R1SN7MAqlyc+eMpaTVASli54hnYH/ZKUNey+jsrnb1HiIIdIwmGJfCwxEFRx3OolFh18
         io2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=tjTS3kEeQ+IonJ+K5+N9UT8qiB72Ta632M9PwJCf/+k=;
        b=aloLUpCLNrBd8ttTiGNKeYid+MRXLclyhEAeJekTTsxhjrsK2AGNcqY8upEmPXNdDZ
         OjHNdsJQKsgHuQXN/Kne16IGxIf6kNPhWhHzgAOnbpfdOA0jCP7nOLkFCKbBF10V74j3
         O0b01mKn6vChD8AjAXjSYR5tMuebmUx+bZwqNFzbGQYSV95jkz7A8/ntZXfcb+nfkXZQ
         LrPEL1nb1OHjMDetq9N4D8ultAh+vYNQEeRqglWRRwBxRRYCmgfG+PK4k8Q74aiAelN9
         4pcfquWGz2On7XZkuQ6clewUSM/zCU95f4b0qicoDJR26h6pTE8Txz/vF55VlG796RPK
         TRRg==
X-Gm-Message-State: AOAM533Fagm0dsvIZan23D2khC17AnPhWkE+brUYU6ZIuxYrOv4qspTg
        amr+MdW7MUEVylMZ12j/QUls5jJg8Yo=
X-Google-Smtp-Source: ABdhPJy8BB5w9J49u7VaG4+MuLX6DJPgRVrgemrPqwL6ZEhS2VPwTaT7G3lcuLGg82KhGTG5s2AXMiO46m4=
Sender: "weiwan via sendgmr" <weiwan@weiwan.svl.corp.google.com>
X-Received: from weiwan.svl.corp.google.com ([2620:15c:2c4:201:819e:a51d:5f26:827c])
 (user=weiwan job=sendgmr) by 2002:a17:90a:8d83:: with SMTP id
 d3mr129584pjo.0.1612474281645; Thu, 04 Feb 2021 13:31:21 -0800 (PST)
Date:   Thu,  4 Feb 2021 13:31:15 -0800
In-Reply-To: <20210204213117.1736289-1-weiwan@google.com>
Message-Id: <20210204213117.1736289-2-weiwan@google.com>
Mime-Version: 1.0
References: <20210204213117.1736289-1-weiwan@google.com>
X-Mailer: git-send-email 2.30.0.365.g02bc693789-goog
Subject: [PATCH net-next v10 1/3] net: extract napi poll functionality to __napi_poll()
From:   Wei Wang <weiwan@google.com>
To:     David Miller <davem@davemloft.net>, netdev@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Paolo Abeni <pabeni@redhat.com>,
        Hannes Frederic Sowa <hannes@stressinduktion.org>,
        Eric Dumazet <edumazet@google.com>,
        Felix Fietkau <nbd@nbd.name>,
        Alexander Duyck <alexanderduyck@fb.com>
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
Reviewed-by: Alexander Duyck <alexanderduyck@fb.com>
---
 net/core/dev.c | 36 ++++++++++++++++++++++++------------
 1 file changed, 24 insertions(+), 12 deletions(-)

diff --git a/net/core/dev.c b/net/core/dev.c
index aae116d059da..0fd40b9847c3 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -6781,15 +6781,10 @@ void __netif_napi_del(struct napi_struct *napi)
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
@@ -6809,7 +6804,7 @@ static int napi_poll(struct napi_struct *n, struct list_head *repoll)
 			    n->poll, work, weight);
 
 	if (likely(work < weight))
-		goto out_unlock;
+		return work;
 
 	/* Drivers must not modify the NAPI state if they
 	 * consume the entire weight.  In such cases this code
@@ -6818,7 +6813,7 @@ static int napi_poll(struct napi_struct *n, struct list_head *repoll)
 	 */
 	if (unlikely(napi_disable_pending(n))) {
 		napi_complete(n);
-		goto out_unlock;
+		return work;
 	}
 
 	/* The NAPI context has more processing work, but busy-polling
@@ -6831,7 +6826,7 @@ static int napi_poll(struct napi_struct *n, struct list_head *repoll)
 			 */
 			napi_schedule(n);
 		}
-		goto out_unlock;
+		return work;
 	}
 
 	if (n->gro_bitmask) {
@@ -6849,12 +6844,29 @@ static int napi_poll(struct napi_struct *n, struct list_head *repoll)
 	if (unlikely(!list_empty(&n->poll_list))) {
 		pr_warn_once("%s: Budget exhausted after napi rescheduled\n",
 			     n->dev ? n->dev->name : "backlog");
-		goto out_unlock;
+		return work;
 	}
 
-	list_add_tail(&n->poll_list, repoll);
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
+	if (do_repoll)
+		list_add_tail(&n->poll_list, repoll);
 
-out_unlock:
 	netpoll_poll_unlock(have);
 
 	return work;
-- 
2.30.0.365.g02bc693789-goog

