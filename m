Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5D2B52634C5
	for <lists+netdev@lfdr.de>; Wed,  9 Sep 2020 19:38:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730030AbgIIRiX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Sep 2020 13:38:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:43690 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726440AbgIIRh7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 9 Sep 2020 13:37:59 -0400
Received: from kicinski-fedora-PC1C0HJN.thefacebook.com (unknown [163.114.132.7])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4639C21D7E;
        Wed,  9 Sep 2020 17:37:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599673078;
        bh=VtFZZeYa4rVzy+FSFUA8Sue4t0QyL3L68yCjOpY2sSM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZdbNl7SKd+9hKgwcoHZ9ykywqUolFKkOO7Yftcc1G7MPJV/QcHSR3JfIDTfCuwRvB
         Xm/4eqUlmhOetcnGwFot6Gx9coj+9XDM2QC+MduHcvFFz3e7gkl4Gp6Mxzac5C7eM2
         XSM0SYO2m/uyppFXA4bnnopV8QC4zsJUE4pj0tQg=
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, eric.dumazet@gmail.com, kernel-team@fb.com,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next 2/3] net: manage napi add/del idempotence explicitly
Date:   Wed,  9 Sep 2020 10:37:52 -0700
Message-Id: <20200909173753.229124-3-kuba@kernel.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200909173753.229124-1-kuba@kernel.org>
References: <20200909173753.229124-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

To RCUify napi->dev_list we need to replace list_del_init()
with list_del_rcu(). There is no _init() version for RCU for
obvious reasons. Up until now netif_napi_del() was idempotent
so to make sure it remains such add a bit which is set when
NAPI is listed, and cleared when it removed. Since we don't
expect multiple calls to netif_napi_add() to be correct,
add a warning on that side.

Now that napi_hash_add / napi_hash_del are only called by
napi_add / del we can actually steal its bit. We just need
to make sure hash node is initialized correctly.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 include/linux/netdevice.h |  4 ++--
 net/core/dev.c            | 13 +++++++++----
 2 files changed, 11 insertions(+), 6 deletions(-)

diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index 74ed95215091..157e0242e9ee 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -355,7 +355,7 @@ enum {
 	NAPI_STATE_MISSED,	/* reschedule a napi */
 	NAPI_STATE_DISABLE,	/* Disable pending */
 	NAPI_STATE_NPSVC,	/* Netpoll - don't dequeue from poll_list */
-	NAPI_STATE_HASHED,	/* In NAPI hash (busy polling possible) */
+	NAPI_STATE_LISTED,	/* NAPI added to system lists */
 	NAPI_STATE_NO_BUSY_POLL,/* Do not add in napi_hash, no busy polling */
 	NAPI_STATE_IN_BUSY_POLL,/* sk_busy_loop() owns this NAPI */
 };
@@ -365,7 +365,7 @@ enum {
 	NAPIF_STATE_MISSED	 = BIT(NAPI_STATE_MISSED),
 	NAPIF_STATE_DISABLE	 = BIT(NAPI_STATE_DISABLE),
 	NAPIF_STATE_NPSVC	 = BIT(NAPI_STATE_NPSVC),
-	NAPIF_STATE_HASHED	 = BIT(NAPI_STATE_HASHED),
+	NAPIF_STATE_LISTED	 = BIT(NAPI_STATE_LISTED),
 	NAPIF_STATE_NO_BUSY_POLL = BIT(NAPI_STATE_NO_BUSY_POLL),
 	NAPIF_STATE_IN_BUSY_POLL = BIT(NAPI_STATE_IN_BUSY_POLL),
 };
diff --git a/net/core/dev.c b/net/core/dev.c
index 205b7339d4ae..e0a1be986824 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -6533,8 +6533,7 @@ EXPORT_SYMBOL(napi_busy_loop);
 
 static void napi_hash_add(struct napi_struct *napi)
 {
-	if (test_bit(NAPI_STATE_NO_BUSY_POLL, &napi->state) ||
-	    test_and_set_bit(NAPI_STATE_HASHED, &napi->state))
+	if (test_bit(NAPI_STATE_NO_BUSY_POLL, &napi->state))
 		return;
 
 	spin_lock(&napi_hash_lock);
@@ -6559,8 +6558,7 @@ static void napi_hash_del(struct napi_struct *napi)
 {
 	spin_lock(&napi_hash_lock);
 
-	if (test_and_clear_bit(NAPI_STATE_HASHED, &napi->state))
-		hlist_del_rcu(&napi->napi_hash_node);
+	hlist_del_init_rcu(&napi->napi_hash_node);
 
 	spin_unlock(&napi_hash_lock);
 }
@@ -6595,7 +6593,11 @@ static void init_gro_hash(struct napi_struct *napi)
 void netif_napi_add(struct net_device *dev, struct napi_struct *napi,
 		    int (*poll)(struct napi_struct *, int), int weight)
 {
+	if (WARN_ON(test_and_set_bit(NAPI_STATE_LISTED, &napi->state)))
+		return;
+
 	INIT_LIST_HEAD(&napi->poll_list);
+	INIT_HLIST_NODE(&napi->napi_hash_node);
 	hrtimer_init(&napi->timer, CLOCK_MONOTONIC, HRTIMER_MODE_REL_PINNED);
 	napi->timer.function = napi_watchdog;
 	init_gro_hash(napi);
@@ -6650,6 +6652,9 @@ static void flush_gro_hash(struct napi_struct *napi)
 /* Must be called in process context */
 void __netif_napi_del(struct napi_struct *napi)
 {
+	if (!test_and_clear_bit(NAPI_STATE_LISTED, &napi->state))
+		return;
+
 	napi_hash_del(napi);
 	list_del_init(&napi->dev_list);
 	napi_free_frags(napi);
-- 
2.26.2

