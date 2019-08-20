Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9808E96C4A
	for <lists+netdev@lfdr.de>; Wed, 21 Aug 2019 00:33:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731100AbfHTWdJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Aug 2019 18:33:09 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:37024 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731055AbfHTWdD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Aug 2019 18:33:03 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description:Resent-Date:Resent-From
        :Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=1v5FVq7XmA1v1uwB+eRs0Znh1nlaacDaYbnE8xGTjYg=; b=MwXGU1p+IOItpu2bo1/iKbVDLe
        lWIABkcDahs/hxDldWKT0wjCL9rAsuYdLEgiTavcju13j0XYvUHtm98mi8fOTr3fGfhcZxL4MU27q
        wROjJC0wiJLfoyaPyV0o+gwTZhCP0BKlt6UTW/2odlSoClEUjdUU+cDd2eu7yg/zEmn34XRfuegnJ
        ZxFOhW8sYUEYzufS7ECn+tYl5FmON1h9qY7WQLn3u//xHZiPMVlsXyIYep6frWUsusEOCGtPA0KfR
        fItmYUVbZ4aHjx3hHkCPBDJgaz3AwPa9PpTrCt2O6C61JSUJ8uDhneborAWDbr/1k5wc57trKn7mo
        +O+M1uig==;
Received: from willy by bombadil.infradead.org with local (Exim 4.92 #3 (Red Hat Linux))
        id 1i0CgZ-0005si-Ee; Tue, 20 Aug 2019 22:33:03 +0000
From:   Matthew Wilcox <willy@infradead.org>
To:     netdev@vger.kernel.org
Cc:     "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: [PATCH 33/38] act_api: Convert action_idr to XArray
Date:   Tue, 20 Aug 2019 15:32:54 -0700
Message-Id: <20190820223259.22348-34-willy@infradead.org>
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

Replace the mutex protecting the IDR with the XArray spinlock.

Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
---
 include/net/act_api.h |   6 +-
 net/sched/act_api.c   | 127 +++++++++++++++++-------------------------
 2 files changed, 53 insertions(+), 80 deletions(-)

diff --git a/include/net/act_api.h b/include/net/act_api.h
index c61a1bf4e3de..da1a515fd94d 100644
--- a/include/net/act_api.h
+++ b/include/net/act_api.h
@@ -13,8 +13,7 @@
 #include <net/netns/generic.h>
 
 struct tcf_idrinfo {
-	struct mutex	lock;
-	struct idr	action_idr;
+	struct xarray	actions;
 };
 
 struct tc_action_ops;
@@ -117,8 +116,7 @@ int tc_action_net_init(struct tc_action_net *tn,
 	if (!tn->idrinfo)
 		return -ENOMEM;
 	tn->ops = ops;
-	mutex_init(&tn->idrinfo->lock);
-	idr_init(&tn->idrinfo->action_idr);
+	xa_init_flags(&tn->idrinfo->actions, XA_FLAGS_ALLOC1);
 	return err;
 }
 
diff --git a/net/sched/act_api.c b/net/sched/act_api.c
index 339712296164..4039ad8c686c 100644
--- a/net/sched/act_api.c
+++ b/net/sched/act_api.c
@@ -126,11 +126,12 @@ static int __tcf_action_put(struct tc_action *p, bool bind)
 {
 	struct tcf_idrinfo *idrinfo = p->idrinfo;
 
-	if (refcount_dec_and_mutex_lock(&p->tcfa_refcnt, &idrinfo->lock)) {
+	if (refcount_dec_and_lock(&p->tcfa_refcnt,
+				&idrinfo->actions.xa_lock)) {
 		if (bind)
 			atomic_dec(&p->tcfa_bindcnt);
-		idr_remove(&idrinfo->action_idr, p->tcfa_index);
-		mutex_unlock(&idrinfo->lock);
+		__xa_erase(&idrinfo->actions, p->tcfa_index);
+		xa_unlock(&idrinfo->actions);
 
 		tcf_action_cleanup(p);
 		return 1;
@@ -214,24 +215,17 @@ static size_t tcf_action_fill_size(const struct tc_action *act)
 static int tcf_dump_walker(struct tcf_idrinfo *idrinfo, struct sk_buff *skb,
 			   struct netlink_callback *cb)
 {
-	int err = 0, index = -1, s_i = 0, n_i = 0;
+	int err = 0, n_i = 0;
 	u32 act_flags = cb->args[2];
 	unsigned long jiffy_since = cb->args[3];
 	struct nlattr *nest;
-	struct idr *idr = &idrinfo->action_idr;
+	struct xarray *xa = &idrinfo->actions;
 	struct tc_action *p;
-	unsigned long id = 1;
-	unsigned long tmp;
+	unsigned long index;
 
-	mutex_lock(&idrinfo->lock);
-
-	s_i = cb->args[0];
-
-	idr_for_each_entry_ul(idr, p, tmp, id) {
-		index++;
-		if (index < s_i)
-			continue;
+	xa_lock(xa);
 
+	xa_for_each_start(&idrinfo->actions, index, p, cb->args[0]) {
 		if (jiffy_since &&
 		    time_after(jiffy_since,
 			       (unsigned long)p->tcfa_tm.lastuse))
@@ -255,10 +249,9 @@ static int tcf_dump_walker(struct tcf_idrinfo *idrinfo, struct sk_buff *skb,
 			goto done;
 	}
 done:
-	if (index >= 0)
-		cb->args[0] = index + 1;
+	cb->args[0] = index + 1;
+	xa_unlock(xa);
 
-	mutex_unlock(&idrinfo->lock);
 	if (n_i) {
 		if (act_flags & TCA_FLAG_LARGE_DUMP_ON)
 			cb->args[1] = n_i;
@@ -276,7 +269,7 @@ static int tcf_idr_release_unsafe(struct tc_action *p)
 		return -EPERM;
 
 	if (refcount_dec_and_test(&p->tcfa_refcnt)) {
-		idr_remove(&p->idrinfo->action_idr, p->tcfa_index);
+		xa_erase(&p->idrinfo->actions, p->tcfa_index);
 		tcf_action_cleanup(p);
 		return ACT_P_DELETED;
 	}
@@ -290,10 +283,8 @@ static int tcf_del_walker(struct tcf_idrinfo *idrinfo, struct sk_buff *skb,
 	struct nlattr *nest;
 	int n_i = 0;
 	int ret = -EINVAL;
-	struct idr *idr = &idrinfo->action_idr;
 	struct tc_action *p;
-	unsigned long id = 1;
-	unsigned long tmp;
+	unsigned long index;
 
 	nest = nla_nest_start_noflag(skb, 0);
 	if (nest == NULL)
@@ -301,18 +292,18 @@ static int tcf_del_walker(struct tcf_idrinfo *idrinfo, struct sk_buff *skb,
 	if (nla_put_string(skb, TCA_KIND, ops->kind))
 		goto nla_put_failure;
 
-	mutex_lock(&idrinfo->lock);
-	idr_for_each_entry_ul(idr, p, tmp, id) {
+	xa_lock(&idrinfo->actions);
+	xa_for_each(&idrinfo->actions, index, p) {
 		ret = tcf_idr_release_unsafe(p);
 		if (ret == ACT_P_DELETED) {
 			module_put(ops->owner);
 			n_i++;
 		} else if (ret < 0) {
-			mutex_unlock(&idrinfo->lock);
+			xa_unlock(&idrinfo->actions);
 			goto nla_put_failure;
 		}
 	}
-	mutex_unlock(&idrinfo->lock);
+	xa_unlock(&idrinfo->actions);
 
 	if (nla_put_u32(skb, TCA_FCNT, n_i))
 		goto nla_put_failure;
@@ -348,13 +339,11 @@ int tcf_idr_search(struct tc_action_net *tn, struct tc_action **a, u32 index)
 	struct tcf_idrinfo *idrinfo = tn->idrinfo;
 	struct tc_action *p;
 
-	mutex_lock(&idrinfo->lock);
-	p = idr_find(&idrinfo->action_idr, index);
-	if (IS_ERR(p))
-		p = NULL;
-	else if (p)
+	xa_lock(&idrinfo->actions);
+	p = xa_load(&idrinfo->actions, index);
+	if (p)
 		refcount_inc(&p->tcfa_refcnt);
-	mutex_unlock(&idrinfo->lock);
+	xa_unlock(&idrinfo->actions);
 
 	if (p) {
 		*a = p;
@@ -369,10 +358,10 @@ static int tcf_idr_delete_index(struct tcf_idrinfo *idrinfo, u32 index)
 	struct tc_action *p;
 	int ret = 0;
 
-	mutex_lock(&idrinfo->lock);
-	p = idr_find(&idrinfo->action_idr, index);
+	xa_lock(&idrinfo->actions);
+	p = xa_load(&idrinfo->actions, index);
 	if (!p) {
-		mutex_unlock(&idrinfo->lock);
+		xa_unlock(&idrinfo->actions);
 		return -ENOENT;
 	}
 
@@ -380,9 +369,8 @@ static int tcf_idr_delete_index(struct tcf_idrinfo *idrinfo, u32 index)
 		if (refcount_dec_and_test(&p->tcfa_refcnt)) {
 			struct module *owner = p->ops->owner;
 
-			WARN_ON(p != idr_remove(&idrinfo->action_idr,
-						p->tcfa_index));
-			mutex_unlock(&idrinfo->lock);
+			__xa_erase(&idrinfo->actions, p->tcfa_index);
+			xa_unlock(&idrinfo->actions);
 
 			tcf_action_cleanup(p);
 			module_put(owner);
@@ -393,7 +381,7 @@ static int tcf_idr_delete_index(struct tcf_idrinfo *idrinfo, u32 index)
 		ret = -EPERM;
 	}
 
-	mutex_unlock(&idrinfo->lock);
+	xa_unlock(&idrinfo->actions);
 	return ret;
 }
 
@@ -455,10 +443,7 @@ void tcf_idr_insert(struct tc_action_net *tn, struct tc_action *a)
 {
 	struct tcf_idrinfo *idrinfo = tn->idrinfo;
 
-	mutex_lock(&idrinfo->lock);
-	/* Replace ERR_PTR(-EBUSY) allocated by tcf_idr_check_alloc */
-	WARN_ON(!IS_ERR(idr_replace(&idrinfo->action_idr, a, a->tcfa_index)));
-	mutex_unlock(&idrinfo->lock);
+	xa_store(&idrinfo->actions, a->tcfa_index, a, GFP_KERNEL);
 }
 EXPORT_SYMBOL(tcf_idr_insert);
 
@@ -468,10 +453,7 @@ void tcf_idr_cleanup(struct tc_action_net *tn, u32 index)
 {
 	struct tcf_idrinfo *idrinfo = tn->idrinfo;
 
-	mutex_lock(&idrinfo->lock);
-	/* Remove ERR_PTR(-EBUSY) allocated by tcf_idr_check_alloc */
-	WARN_ON(!IS_ERR(idr_remove(&idrinfo->action_idr, index)));
-	mutex_unlock(&idrinfo->lock);
+	xa_erase(&idrinfo->actions, index);
 }
 EXPORT_SYMBOL(tcf_idr_cleanup);
 
@@ -489,41 +471,36 @@ int tcf_idr_check_alloc(struct tc_action_net *tn, u32 *index,
 	int ret;
 
 again:
-	mutex_lock(&idrinfo->lock);
+	xa_lock(&idrinfo->actions);
 	if (*index) {
-		p = idr_find(&idrinfo->action_idr, *index);
-		if (IS_ERR(p)) {
-			/* This means that another process allocated
-			 * index but did not assign the pointer yet.
-			 */
-			mutex_unlock(&idrinfo->lock);
-			goto again;
-		}
-
+		p = xa_load(&idrinfo->actions, *index);
 		if (p) {
 			refcount_inc(&p->tcfa_refcnt);
 			if (bind)
 				atomic_inc(&p->tcfa_bindcnt);
-			*a = p;
 			ret = 1;
 		} else {
 			*a = NULL;
-			ret = idr_alloc_u32(&idrinfo->action_idr, NULL, index,
-					    *index, GFP_KERNEL);
-			if (!ret)
-				idr_replace(&idrinfo->action_idr,
-					    ERR_PTR(-EBUSY), *index);
+			ret = __xa_insert(&idrinfo->actions, *index, NULL,
+					    GFP_KERNEL);
+			if (ret == -EBUSY) {
+				/*
+				 * Another process has allocated this index,
+				 * but has not yet assigned a pointer.
+				 */
+				xa_unlock(&idrinfo->actions);
+				cpu_relax();
+				goto again;
+			}
 		}
 	} else {
-		*index = 1;
-		*a = NULL;
-		ret = idr_alloc_u32(&idrinfo->action_idr, NULL, index,
-				    UINT_MAX, GFP_KERNEL);
-		if (!ret)
-			idr_replace(&idrinfo->action_idr, ERR_PTR(-EBUSY),
-				    *index);
+		ret = __xa_alloc(&idrinfo->actions, index, NULL, xa_limit_32b,
+				GFP_KERNEL);
+		p = NULL;
 	}
-	mutex_unlock(&idrinfo->lock);
+
+	*a = p;
+	xa_unlock(&idrinfo->actions);
 	return ret;
 }
 EXPORT_SYMBOL(tcf_idr_check_alloc);
@@ -531,20 +508,18 @@ EXPORT_SYMBOL(tcf_idr_check_alloc);
 void tcf_idrinfo_destroy(const struct tc_action_ops *ops,
 			 struct tcf_idrinfo *idrinfo)
 {
-	struct idr *idr = &idrinfo->action_idr;
 	struct tc_action *p;
 	int ret;
-	unsigned long id = 1;
-	unsigned long tmp;
+	unsigned long index;
 
-	idr_for_each_entry_ul(idr, p, tmp, id) {
+	xa_for_each(&idrinfo->actions, index, p) {
 		ret = __tcf_idr_release(p, false, true);
 		if (ret == ACT_P_DELETED)
 			module_put(ops->owner);
 		else if (ret < 0)
 			return;
 	}
-	idr_destroy(&idrinfo->action_idr);
+	xa_destroy(&idrinfo->actions);
 }
 EXPORT_SYMBOL(tcf_idrinfo_destroy);
 
-- 
2.23.0.rc1

