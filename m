Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B217D313F24
	for <lists+netdev@lfdr.de>; Mon,  8 Feb 2021 20:36:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229795AbhBHTgM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Feb 2021 14:36:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52214 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236225AbhBHTfG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Feb 2021 14:35:06 -0500
Received: from mail-qk1-x749.google.com (mail-qk1-x749.google.com [IPv6:2607:f8b0:4864:20::749])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 74F1FC061797
        for <netdev@vger.kernel.org>; Mon,  8 Feb 2021 11:34:14 -0800 (PST)
Received: by mail-qk1-x749.google.com with SMTP id s4so13784008qkj.18
        for <netdev@vger.kernel.org>; Mon, 08 Feb 2021 11:34:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:in-reply-to:message-id:mime-version:references:subject
         :from:to:cc;
        bh=pR6XhvPVVJZbG2r6oTAauYd5G+RXb6h+XcoJLS263As=;
        b=W1Pcx1grj05k7pLOYJS5TCZy5j905SOYQChMEndG7gczq9/hsiVZQi3Y9ktOAw+Iw7
         QgNmvaRqSevzKPMzpQeiPYMfmRQZMT9iL5fprmKJl31RolJQ2zTZj9+bQwNpuCB2J4tX
         8A1EFPVumD+VBkS/SyQAsQPIpx1oWunY1FrHlwA4gwJBn9MT1h1SF20NJpxVGdlD6HcJ
         8BIaymiUh6CusJSmQ4RbUNESOuLGRo2u+GMfxmgz2V6YrRJ5imn/zy/jJUcFSr+kMARP
         MRIa2qsP6+fsg556SSHc81a57VV2HsoJzEw2Q5dtPM8WbRxfHlWeKOSgP9C+fQjGx7YF
         sotA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=pR6XhvPVVJZbG2r6oTAauYd5G+RXb6h+XcoJLS263As=;
        b=GlL0KLj1D/HxIJSinuy8DGyLRyC8cejq3TUn9+UD6N8p1rxZM54AvJnGVVVDSsgsdX
         UPygOg4bhFJqOofEHAAfzSafZAptNY2LApa1Jr5QVp96ABXbmpYFlss8YRU9uVBwdLC5
         0fbXE0sHkPlX4quQt6SHrETGVpsp3UPwVzH1/JwkYL9RA1uHXd688D+0J80zmTirtQqe
         J2hnDogadQNcuypCRayaFV5iMDdrJboLPbS74xnlwkJz+k4uua85x2xYd2w4+f/B9PQM
         JT3avLcyUBu7eghc+o06A5cYAj/NTCE/JaIp8jKSW28N4uqasNfzq+V0DbFJl96ggblC
         orgg==
X-Gm-Message-State: AOAM530bdAoSUtQxJ+7zTXYbkTGM7OAb47Lk/O3bOtWlYCydpZaLhW+l
        Pbte0eO3JMGkhUl+zDvFGrn6U4eoemc=
X-Google-Smtp-Source: ABdhPJyunXHAkrNATtT+yRFYvgo9A4kBGei14c5J6+YeYleFAQhJIpgiAj/7LO+DGmV8wkW4Q4Riv0XantU=
Sender: "weiwan via sendgmr" <weiwan@weiwan.svl.corp.google.com>
X-Received: from weiwan.svl.corp.google.com ([2620:15c:2c4:201:35a9:bca1:5bb0:4132])
 (user=weiwan job=sendgmr) by 2002:a05:6214:20a1:: with SMTP id
 1mr17368467qvd.30.1612812853645; Mon, 08 Feb 2021 11:34:13 -0800 (PST)
Date:   Mon,  8 Feb 2021 11:34:08 -0800
In-Reply-To: <20210208193410.3859094-1-weiwan@google.com>
Message-Id: <20210208193410.3859094-2-weiwan@google.com>
Mime-Version: 1.0
References: <20210208193410.3859094-1-weiwan@google.com>
X-Mailer: git-send-email 2.30.0.478.g8a0d178c01-goog
Subject: [PATCH net-next v11 1/3] net: extract napi poll functionality to __napi_poll()
From:   Wei Wang <weiwan@google.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Cc:     Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Hannes Frederic Sowa <hannes@stressinduktion.org>,
        Alexander Duyck <alexanderduyck@fb.com>,
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
Reviewed-by: Alexander Duyck <alexanderduyck@fb.com>
---
 net/core/dev.c | 36 ++++++++++++++++++++++++------------
 1 file changed, 24 insertions(+), 12 deletions(-)

diff --git a/net/core/dev.c b/net/core/dev.c
index 21d74d30f5d7..59751a22d7c3 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -6776,15 +6776,10 @@ void __netif_napi_del(struct napi_struct *napi)
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
@@ -6804,7 +6799,7 @@ static int napi_poll(struct napi_struct *n, struct list_head *repoll)
 			    n->poll, work, weight);
 
 	if (likely(work < weight))
-		goto out_unlock;
+		return work;
 
 	/* Drivers must not modify the NAPI state if they
 	 * consume the entire weight.  In such cases this code
@@ -6813,7 +6808,7 @@ static int napi_poll(struct napi_struct *n, struct list_head *repoll)
 	 */
 	if (unlikely(napi_disable_pending(n))) {
 		napi_complete(n);
-		goto out_unlock;
+		return work;
 	}
 
 	/* The NAPI context has more processing work, but busy-polling
@@ -6826,7 +6821,7 @@ static int napi_poll(struct napi_struct *n, struct list_head *repoll)
 			 */
 			napi_schedule(n);
 		}
-		goto out_unlock;
+		return work;
 	}
 
 	if (n->gro_bitmask) {
@@ -6844,12 +6839,29 @@ static int napi_poll(struct napi_struct *n, struct list_head *repoll)
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
2.30.0.478.g8a0d178c01-goog

