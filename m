Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 95CAD4D9449
	for <lists+netdev@lfdr.de>; Tue, 15 Mar 2022 07:00:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345047AbiCOGBa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Mar 2022 02:01:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38532 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239309AbiCOGB2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Mar 2022 02:01:28 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9940749F2C
        for <netdev@vger.kernel.org>; Mon, 14 Mar 2022 23:00:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3622B612D3
        for <netdev@vger.kernel.org>; Tue, 15 Mar 2022 06:00:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4383CC36AE7;
        Tue, 15 Mar 2022 06:00:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1647324016;
        bh=1HWsJbS+ubdgGphGk7e/vp48kRPwQGrsMBQBZrKV1as=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JvzH+ypUambY/zZ3cUFMrWjMgXTIebP7UxDxwOVPE0gFjBE2SPPh8r6VMoa9hB/9T
         zGO7y1Ksd9YN9CbRJfYHkCUK8PrLow0WuiMJcCwBpY05k+L/U8C9hvoFxWPhDTg/EJ
         yIhzrU5nDVD8WGyBunGiKDvbrupTckRfueTG9sknzZppsZyIY/MWZ7CNZZoqD38W/K
         d46k1fb8RANj50wTyWKyIjhTOcbjIV51MwBXPKT3FYtIr+UR03VbTzdGZr1FsUW8zC
         ucaK8ddnXybkKcqM3Q0LlwyzXPma3xHlXwiXc4N+faTHPte6m0kjpzaJNfyMzuYxOO
         9qsH4XOns98Kw==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, jiri@nvidia.com, idosch@nvidia.com,
        petrm@nvidia.com, simon.horman@corigine.com,
        louis.peens@corigine.com, leon@kernel.org,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next 2/6] eth: nfp: wrap locking assertions in helpers
Date:   Mon, 14 Mar 2022 23:00:05 -0700
Message-Id: <20220315060009.1028519-3-kuba@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220315060009.1028519-1-kuba@kernel.org>
References: <20220315060009.1028519-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We can replace the PF lock with devlink instance lock in subsequent
changes. To make the patches easier to comprehend and limit line
lengths - factor out the existing locking assertions.

No functional changes.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 drivers/net/ethernet/netronome/nfp/flower/main.c  | 4 ++--
 drivers/net/ethernet/netronome/nfp/nfp_app.c      | 2 +-
 drivers/net/ethernet/netronome/nfp/nfp_app.h      | 9 +++++++++
 drivers/net/ethernet/netronome/nfp/nfp_net_repr.c | 4 ++--
 4 files changed, 14 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/netronome/nfp/flower/main.c b/drivers/net/ethernet/netronome/nfp/flower/main.c
index ac1dcfa1d179..4d960a9641b3 100644
--- a/drivers/net/ethernet/netronome/nfp/flower/main.c
+++ b/drivers/net/ethernet/netronome/nfp/flower/main.c
@@ -266,7 +266,7 @@ nfp_flower_reprs_reify(struct nfp_app *app, enum nfp_repr_type type,
 	int i, err, count = 0;
 
 	reprs = rcu_dereference_protected(app->reprs[type],
-					  lockdep_is_held(&app->pf->lock));
+					  nfp_app_is_locked(app));
 	if (!reprs)
 		return 0;
 
@@ -295,7 +295,7 @@ nfp_flower_wait_repr_reify(struct nfp_app *app, atomic_t *replies, int tot_repl)
 	if (!tot_repl)
 		return 0;
 
-	lockdep_assert_held(&app->pf->lock);
+	assert_nfp_app_locked(app);
 	if (!wait_event_timeout(priv->reify_wait_queue,
 				atomic_read(replies) >= tot_repl,
 				NFP_FL_REPLY_TIMEOUT)) {
diff --git a/drivers/net/ethernet/netronome/nfp/nfp_app.c b/drivers/net/ethernet/netronome/nfp/nfp_app.c
index 3a973282b2bb..09f250e74dfa 100644
--- a/drivers/net/ethernet/netronome/nfp/nfp_app.c
+++ b/drivers/net/ethernet/netronome/nfp/nfp_app.c
@@ -121,7 +121,7 @@ struct nfp_reprs *
 nfp_reprs_get_locked(struct nfp_app *app, enum nfp_repr_type type)
 {
 	return rcu_dereference_protected(app->reprs[type],
-					 lockdep_is_held(&app->pf->lock));
+					 nfp_app_is_locked(app));
 }
 
 struct nfp_reprs *
diff --git a/drivers/net/ethernet/netronome/nfp/nfp_app.h b/drivers/net/ethernet/netronome/nfp/nfp_app.h
index 3e9baff07100..60cb8a71e02d 100644
--- a/drivers/net/ethernet/netronome/nfp/nfp_app.h
+++ b/drivers/net/ethernet/netronome/nfp/nfp_app.h
@@ -4,10 +4,12 @@
 #ifndef _NFP_APP_H
 #define _NFP_APP_H 1
 
+#include <linux/lockdep.h>
 #include <net/devlink.h>
 
 #include <trace/events/devlink.h>
 
+#include "nfp_main.h"
 #include "nfp_net_repr.h"
 
 #define NFP_APP_CTRL_MTU_MAX	U32_MAX
@@ -174,6 +176,13 @@ struct nfp_app {
 	void *priv;
 };
 
+static inline void assert_nfp_app_locked(struct nfp_app *app)
+{
+	lockdep_assert_held(&app->pf->lock);
+}
+
+#define nfp_app_is_locked(app)	lockdep_is_held(&(app)->pf->lock)
+
 void nfp_check_rhashtable_empty(void *ptr, void *arg);
 bool __nfp_ctrl_tx(struct nfp_net *nn, struct sk_buff *skb);
 bool nfp_ctrl_tx(struct nfp_net *nn, struct sk_buff *skb);
diff --git a/drivers/net/ethernet/netronome/nfp/nfp_net_repr.c b/drivers/net/ethernet/netronome/nfp/nfp_net_repr.c
index 181ac8e789a3..ba3fa7eac98d 100644
--- a/drivers/net/ethernet/netronome/nfp/nfp_net_repr.c
+++ b/drivers/net/ethernet/netronome/nfp/nfp_net_repr.c
@@ -20,7 +20,7 @@ struct net_device *
 nfp_repr_get_locked(struct nfp_app *app, struct nfp_reprs *set, unsigned int id)
 {
 	return rcu_dereference_protected(set->reprs[id],
-					 lockdep_is_held(&app->pf->lock));
+					 nfp_app_is_locked(app));
 }
 
 static void
@@ -476,7 +476,7 @@ nfp_reprs_clean_and_free_by_type(struct nfp_app *app, enum nfp_repr_type type)
 	int i;
 
 	reprs = rcu_dereference_protected(app->reprs[type],
-					  lockdep_is_held(&app->pf->lock));
+					  nfp_app_is_locked(app));
 	if (!reprs)
 		return;
 
-- 
2.34.1

