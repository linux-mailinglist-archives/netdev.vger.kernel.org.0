Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 28F8896C49
	for <lists+netdev@lfdr.de>; Wed, 21 Aug 2019 00:33:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731105AbfHTWdJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Aug 2019 18:33:09 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:37034 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731064AbfHTWdD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Aug 2019 18:33:03 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description:Resent-Date:Resent-From
        :Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=lh3Gb0orvgYCYAPy+IYq3bveS49lEcL5ZhZH0XstLHs=; b=bfDuK1zYIPdkPB0Trg6AROgoSE
        AE27CDiFsc6Rf9xQZ1t1Dx94CBr48IGLaXwoXSfULMGzjfFNGgvl6zMYJyMwghA1pMzNlj5B588Os
        /IFrZYS2mG9Bs3wLO9l2FvgYZo6mzwnTIEp/Km6gUth8cvgzNpcCWme/pYRjoaBZZr8mS1d725Wlo
        UZRHD+qrZQzwgW1t1u4THROcBc67vWSOdbiwWAWNx3P4GVeq5+47L/Cro0EBizxo2s5YM1N0cuGq0
        2CJzZYvlcq7SeNnWQyVNSU+Jnmp2IrM1f4ca7oeOXN4FBbGgZoMgHB7ZqpMdkpMsAS+7o+EuNCi92
        mhuvidkw==;
Received: from willy by bombadil.infradead.org with local (Exim 4.92 #3 (Red Hat Linux))
        id 1i0CgZ-0005tE-Mh; Tue, 20 Aug 2019 22:33:03 +0000
From:   Matthew Wilcox <willy@infradead.org>
To:     netdev@vger.kernel.org
Cc:     "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: [PATCH 38/38] mac80211: Convert function_inst_ids to XArray
Date:   Tue, 20 Aug 2019 15:32:59 -0700
Message-Id: <20190820223259.22348-39-willy@infradead.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190820223259.22348-1-willy@infradead.org>
References: <20190820223259.22348-1-willy@infradead.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: "Matthew Wilcox (Oracle)" <willy@infradead.org>

Replae the func_lock with the internal XArray spinlock.  Ensuring that
nan_func is fully initialised before dropping the lock allows us to
iterate the array while not holding the lock, avoiding the awkward dance
in ieee80211_reconfig_nan().

Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
---
 net/mac80211/cfg.c         | 57 ++++++++++++++------------------------
 net/mac80211/ieee80211_i.h |  9 ++----
 net/mac80211/iface.c       | 16 +++++------
 net/mac80211/util.c        | 30 ++++----------------
 4 files changed, 37 insertions(+), 75 deletions(-)

diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index 47d7670094a9..2ea45b7007db 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -266,7 +266,7 @@ static int ieee80211_add_nan_func(struct wiphy *wiphy,
 				  struct cfg80211_nan_func *nan_func)
 {
 	struct ieee80211_sub_if_data *sdata = IEEE80211_WDEV_TO_SUB_IF(wdev);
-	int ret;
+	int ret, id;
 
 	if (sdata->vif.type != NL80211_IFTYPE_NAN)
 		return -EOPNOTSUPP;
@@ -274,27 +274,22 @@ static int ieee80211_add_nan_func(struct wiphy *wiphy,
 	if (!ieee80211_sdata_running(sdata))
 		return -ENETDOWN;
 
-	spin_lock_bh(&sdata->u.nan.func_lock);
-
-	ret = idr_alloc(&sdata->u.nan.function_inst_ids,
-			nan_func, 1, sdata->local->hw.max_nan_de_entries + 1,
-			GFP_ATOMIC);
-	spin_unlock_bh(&sdata->u.nan.func_lock);
+	xa_lock_bh(&sdata->u.nan.functions);
+	ret = __xa_alloc(&sdata->u.nan.functions, &id, nan_func,
+			XA_LIMIT(0, sdata->local->hw.max_nan_de_entries),
+			GFP_KERNEL);
+	if (ret == 0)
+		nan_func->instance_id = id;
+	xa_unlock_bh(&sdata->u.nan.functions);
 
 	if (ret < 0)
 		return ret;
 
-	nan_func->instance_id = ret;
-
 	WARN_ON(nan_func->instance_id == 0);
 
 	ret = drv_add_nan_func(sdata->local, sdata, nan_func);
-	if (ret) {
-		spin_lock_bh(&sdata->u.nan.func_lock);
-		idr_remove(&sdata->u.nan.function_inst_ids,
-			   nan_func->instance_id);
-		spin_unlock_bh(&sdata->u.nan.func_lock);
-	}
+	if (ret)
+		xa_erase_bh(&sdata->u.nan.functions, nan_func->instance_id);
 
 	return ret;
 }
@@ -304,11 +299,11 @@ ieee80211_find_nan_func_by_cookie(struct ieee80211_sub_if_data *sdata,
 				  u64 cookie)
 {
 	struct cfg80211_nan_func *func;
-	int id;
+	unsigned long id;
 
-	lockdep_assert_held(&sdata->u.nan.func_lock);
+	lockdep_assert_held(&sdata->u.nan.functions.xa_lock);
 
-	idr_for_each_entry(&sdata->u.nan.function_inst_ids, func, id) {
+	xa_for_each(&sdata->u.nan.functions, id, func) {
 		if (func->cookie == cookie)
 			return func;
 	}
@@ -327,13 +322,13 @@ static void ieee80211_del_nan_func(struct wiphy *wiphy,
 	    !ieee80211_sdata_running(sdata))
 		return;
 
-	spin_lock_bh(&sdata->u.nan.func_lock);
+	xa_lock_bh(&sdata->u.nan.functions);
 
 	func = ieee80211_find_nan_func_by_cookie(sdata, cookie);
 	if (func)
 		instance_id = func->instance_id;
 
-	spin_unlock_bh(&sdata->u.nan.func_lock);
+	xa_unlock_bh(&sdata->u.nan.functions);
 
 	if (instance_id)
 		drv_del_nan_func(sdata->local, sdata, instance_id);
@@ -3766,19 +3761,11 @@ void ieee80211_nan_func_terminated(struct ieee80211_vif *vif,
 	if (WARN_ON(vif->type != NL80211_IFTYPE_NAN))
 		return;
 
-	spin_lock_bh(&sdata->u.nan.func_lock);
-
-	func = idr_find(&sdata->u.nan.function_inst_ids, inst_id);
-	if (WARN_ON(!func)) {
-		spin_unlock_bh(&sdata->u.nan.func_lock);
+	func = xa_erase_bh(&sdata->u.nan.functions, inst_id);
+	if (WARN_ON(!func))
 		return;
-	}
 
 	cookie = func->cookie;
-	idr_remove(&sdata->u.nan.function_inst_ids, inst_id);
-
-	spin_unlock_bh(&sdata->u.nan.func_lock);
-
 	cfg80211_free_nan_func(func);
 
 	cfg80211_nan_func_terminated(ieee80211_vif_to_wdev(vif), inst_id,
@@ -3796,16 +3783,14 @@ void ieee80211_nan_func_match(struct ieee80211_vif *vif,
 	if (WARN_ON(vif->type != NL80211_IFTYPE_NAN))
 		return;
 
-	spin_lock_bh(&sdata->u.nan.func_lock);
-
-	func = idr_find(&sdata->u.nan.function_inst_ids,  match->inst_id);
+	xa_lock_bh(&sdata->u.nan.functions);
+	func = xa_load(&sdata->u.nan.functions,  match->inst_id);
 	if (WARN_ON(!func)) {
-		spin_unlock_bh(&sdata->u.nan.func_lock);
+		xa_unlock_bh(&sdata->u.nan.functions);
 		return;
 	}
 	match->cookie = func->cookie;
-
-	spin_unlock_bh(&sdata->u.nan.func_lock);
+	xa_unlock_bh(&sdata->u.nan.functions);
 
 	cfg80211_nan_match(ieee80211_vif_to_wdev(vif), match, gfp);
 }
diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index ade005892099..7be25939a6bf 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -23,7 +23,7 @@
 #include <linux/spinlock.h>
 #include <linux/etherdevice.h>
 #include <linux/leds.h>
-#include <linux/idr.h>
+#include <linux/xarray.h>
 #include <linux/rhashtable.h>
 #include <net/ieee80211_radiotap.h>
 #include <net/cfg80211.h>
@@ -862,14 +862,11 @@ struct ieee80211_if_mntr {
  * struct ieee80211_if_nan - NAN state
  *
  * @conf: current NAN configuration
- * @func_ids: a bitmap of available instance_id's
+ * @functions: NAN function pointers
  */
 struct ieee80211_if_nan {
 	struct cfg80211_nan_conf conf;
-
-	/* protects function_inst_ids */
-	spinlock_t func_lock;
-	struct idr function_inst_ids;
+	struct xarray functions;
 };
 
 struct ieee80211_sub_if_data {
diff --git a/net/mac80211/iface.c b/net/mac80211/iface.c
index 8dc6580e1787..022e2eb6a46c 100644
--- a/net/mac80211/iface.c
+++ b/net/mac80211/iface.c
@@ -802,6 +802,7 @@ static void ieee80211_do_stop(struct ieee80211_sub_if_data *sdata,
 	struct cfg80211_chan_def chandef;
 	bool cancel_scan;
 	struct cfg80211_nan_func *func;
+	unsigned long index;
 
 	clear_bit(SDATA_STATE_RUNNING, &sdata->state);
 
@@ -961,15 +962,12 @@ static void ieee80211_do_stop(struct ieee80211_sub_if_data *sdata,
 		break;
 	case NL80211_IFTYPE_NAN:
 		/* clean all the functions */
-		spin_lock_bh(&sdata->u.nan.func_lock);
-
-		idr_for_each_entry(&sdata->u.nan.function_inst_ids, func, i) {
-			idr_remove(&sdata->u.nan.function_inst_ids, i);
+		xa_lock_bh(&sdata->u.nan.functions);
+		xa_for_each(&sdata->u.nan.functions, index, func) {
+			__xa_erase(&sdata->u.nan.functions, index);
 			cfg80211_free_nan_func(func);
 		}
-		idr_destroy(&sdata->u.nan.function_inst_ids);
-
-		spin_unlock_bh(&sdata->u.nan.func_lock);
+		xa_unlock_bh(&sdata->u.nan.functions);
 		break;
 	case NL80211_IFTYPE_P2P_DEVICE:
 		/* relies on synchronize_rcu() below */
@@ -1463,8 +1461,8 @@ static void ieee80211_setup_sdata(struct ieee80211_sub_if_data *sdata,
 		sdata->vif.bss_conf.bssid = NULL;
 		break;
 	case NL80211_IFTYPE_NAN:
-		idr_init(&sdata->u.nan.function_inst_ids);
-		spin_lock_init(&sdata->u.nan.func_lock);
+		xa_init_flags(&sdata->u.nan.functions,
+				XA_FLAGS_ALLOC1 | XA_FLAGS_LOCK_BH);
 		sdata->vif.bss_conf.bssid = sdata->vif.addr;
 		break;
 	case NL80211_IFTYPE_AP_VLAN:
diff --git a/net/mac80211/util.c b/net/mac80211/util.c
index 286c7ee35e63..4996a3c01205 100644
--- a/net/mac80211/util.c
+++ b/net/mac80211/util.c
@@ -2082,42 +2082,24 @@ static void ieee80211_reconfig_stations(struct ieee80211_sub_if_data *sdata)
 
 static int ieee80211_reconfig_nan(struct ieee80211_sub_if_data *sdata)
 {
-	struct cfg80211_nan_func *func, **funcs;
-	int res, id, i = 0;
+	struct cfg80211_nan_func *func;
+	unsigned long id;
+	int res;
 
 	res = drv_start_nan(sdata->local, sdata,
 			    &sdata->u.nan.conf);
 	if (WARN_ON(res))
 		return res;
 
-	funcs = kcalloc(sdata->local->hw.max_nan_de_entries + 1,
-			sizeof(*funcs),
-			GFP_KERNEL);
-	if (!funcs)
-		return -ENOMEM;
-
-	/* Add all the functions:
-	 * This is a little bit ugly. We need to call a potentially sleeping
-	 * callback for each NAN function, so we can't hold the spinlock.
-	 */
-	spin_lock_bh(&sdata->u.nan.func_lock);
-
-	idr_for_each_entry(&sdata->u.nan.function_inst_ids, func, id)
-		funcs[i++] = func;
-
-	spin_unlock_bh(&sdata->u.nan.func_lock);
-
-	for (i = 0; funcs[i]; i++) {
-		res = drv_add_nan_func(sdata->local, sdata, funcs[i]);
+	xa_for_each(&sdata->u.nan.functions, id, func) {
+		res = drv_add_nan_func(sdata->local, sdata, func);
 		if (WARN_ON(res))
 			ieee80211_nan_func_terminated(&sdata->vif,
-						      funcs[i]->instance_id,
+						      func->instance_id,
 						      NL80211_NAN_FUNC_TERM_REASON_ERROR,
 						      GFP_KERNEL);
 	}
 
-	kfree(funcs);
-
 	return 0;
 }
 
-- 
2.23.0.rc1

