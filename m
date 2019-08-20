Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 477D896C61
	for <lists+netdev@lfdr.de>; Wed, 21 Aug 2019 00:33:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731197AbfHTWdw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Aug 2019 18:33:52 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:36984 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730975AbfHTWdC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Aug 2019 18:33:02 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description:Resent-Date:Resent-From
        :Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=hpAHsO1eAQW8oJVPu7RS9TlFJ/oXbXdMYzhwcQSATiU=; b=OS+Xl92jhBg6JL25jhcw0/sTYZ
        IfxP215izLHR9Vj6pHUGh/CQTpwx5BiWnY8tzXPMef0ovpeMmVkIxJynd+EBBrCYdyOaoU3raT9Yo
        ty1ud2NMRzKVHigjeTj0uw7MzboxL9b+g0WH5JeT1FLzMdavDdnmSg2RSW6LxihHIPkFrW4ycYIYi
        jaab+dnOvfDlZR9hxi6PgmduVAMRE62S3pmelb/xoctjqZo366eHxhO9/BbGbACrlIZvZBHoc2+e3
        Pn3JT0CGY9kVW5I2V+k28e0vwP9X9PB7tbzFCmHuTHCTOm1ucZQDej6r4NmlCy7kJsyLhBVU/zIlM
        xSyPq4Bg==;
Received: from willy by bombadil.infradead.org with local (Exim 4.92 #3 (Red Hat Linux))
        id 1i0CgY-0005ql-BB; Tue, 20 Aug 2019 22:33:02 +0000
From:   Matthew Wilcox <willy@infradead.org>
To:     netdev@vger.kernel.org
Cc:     "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: [PATCH 13/38] ppp: Convert units_idr to XArray
Date:   Tue, 20 Aug 2019 15:32:34 -0700
Message-Id: <20190820223259.22348-14-willy@infradead.org>
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

Remove the unit_* wrappers around the IDR code; using the XArray API
directly is more clear.  I suspect the all_ppp_mutex could probably be
removed, but it probably isn't a scalability bottleneck.

Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
---
 drivers/net/ppp/ppp_generic.c | 73 ++++++++---------------------------
 1 file changed, 16 insertions(+), 57 deletions(-)

diff --git a/drivers/net/ppp/ppp_generic.c b/drivers/net/ppp/ppp_generic.c
index a30e41a56085..1a12f30de30f 100644
--- a/drivers/net/ppp/ppp_generic.c
+++ b/drivers/net/ppp/ppp_generic.c
@@ -24,7 +24,6 @@
 #include <linux/kmod.h>
 #include <linux/init.h>
 #include <linux/list.h>
-#include <linux/idr.h>
 #include <linux/netdevice.h>
 #include <linux/poll.h>
 #include <linux/ppp_defs.h>
@@ -48,6 +47,7 @@
 #include <net/slhc_vj.h>
 #include <linux/atomic.h>
 #include <linux/refcount.h>
+#include <linux/xarray.h>
 
 #include <linux/nsproxy.h>
 #include <net/net_namespace.h>
@@ -206,7 +206,7 @@ static atomic_t channel_count = ATOMIC_INIT(0);
 static unsigned int ppp_net_id __read_mostly;
 struct ppp_net {
 	/* units to ppp mapping */
-	struct idr units_idr;
+	struct xarray units;
 
 	/*
 	 * all_ppp_mutex protects the units_idr mapping.
@@ -283,10 +283,6 @@ static struct channel *ppp_find_channel(struct ppp_net *pn, int unit);
 static int ppp_connect_channel(struct channel *pch, int unit);
 static int ppp_disconnect_channel(struct channel *pch);
 static void ppp_destroy_channel(struct channel *pch);
-static int unit_get(struct idr *p, void *ptr);
-static int unit_set(struct idr *p, void *ptr, int n);
-static void unit_put(struct idr *p, int n);
-static void *unit_find(struct idr *p, int n);
 static void ppp_setup(struct net_device *dev);
 
 static const struct net_device_ops ppp_netdev_ops;
@@ -904,7 +900,7 @@ static __net_init int ppp_init_net(struct net *net)
 {
 	struct ppp_net *pn = net_generic(net, ppp_net_id);
 
-	idr_init(&pn->units_idr);
+	xa_init_flags(&pn->units, XA_FLAGS_ALLOC);
 	mutex_init(&pn->all_ppp_mutex);
 
 	INIT_LIST_HEAD(&pn->all_channels);
@@ -922,7 +918,7 @@ static __net_exit void ppp_exit_net(struct net *net)
 	struct net_device *aux;
 	struct ppp *ppp;
 	LIST_HEAD(list);
-	int id;
+	unsigned long id;
 
 	rtnl_lock();
 	for_each_netdev_safe(net, dev, aux) {
@@ -930,7 +926,7 @@ static __net_exit void ppp_exit_net(struct net *net)
 			unregister_netdevice_queue(dev, &list);
 	}
 
-	idr_for_each_entry(&pn->units_idr, ppp, id)
+	xa_for_each(&pn->units, id, ppp)
 		/* Skip devices already unregistered by previous loop */
 		if (!net_eq(dev_net(ppp->dev), net))
 			unregister_netdevice_queue(ppp->dev, &list);
@@ -939,7 +935,6 @@ static __net_exit void ppp_exit_net(struct net *net)
 	rtnl_unlock();
 
 	mutex_destroy(&pn->all_ppp_mutex);
-	idr_destroy(&pn->units_idr);
 	WARN_ON_ONCE(!list_empty(&pn->all_channels));
 	WARN_ON_ONCE(!list_empty(&pn->new_channels));
 }
@@ -959,27 +954,25 @@ static int ppp_unit_register(struct ppp *ppp, int unit, bool ifname_is_set)
 	mutex_lock(&pn->all_ppp_mutex);
 
 	if (unit < 0) {
-		ret = unit_get(&pn->units_idr, ppp);
+		ret = xa_alloc(&pn->units, &ppp->file.index, ppp,
+				xa_limit_31b, GFP_KERNEL);
 		if (ret < 0)
 			goto err;
 	} else {
-		/* Caller asked for a specific unit number. Fail with -EEXIST
+		/*
+		 * Caller asked for a specific unit number. Fail with -EEXIST
 		 * if unavailable. For backward compatibility, return -EEXIST
-		 * too if idr allocation fails; this makes pppd retry without
-		 * requesting a specific unit number.
+		 * too if memory allocation fails; this makes pppd retry
+		 * without requesting a specific unit number.
 		 */
-		if (unit_find(&pn->units_idr, unit)) {
-			ret = -EEXIST;
-			goto err;
-		}
-		ret = unit_set(&pn->units_idr, ppp, unit);
+		ret = xa_insert(&pn->units, unit, ppp, GFP_KERNEL);
 		if (ret < 0) {
 			/* Rewrite error for backward compatibility */
 			ret = -EEXIST;
 			goto err;
 		}
+		ppp->file.index = unit;
 	}
-	ppp->file.index = ret;
 
 	if (!ifname_is_set)
 		snprintf(ppp->dev->name, IFNAMSIZ, "ppp%i", ppp->file.index);
@@ -996,7 +989,7 @@ static int ppp_unit_register(struct ppp *ppp, int unit, bool ifname_is_set)
 
 err_unit:
 	mutex_lock(&pn->all_ppp_mutex);
-	unit_put(&pn->units_idr, ppp->file.index);
+	xa_erase(&pn->units, ppp->file.index);
 err:
 	mutex_unlock(&pn->all_ppp_mutex);
 
@@ -1346,7 +1339,7 @@ static void ppp_dev_uninit(struct net_device *dev)
 	ppp_unlock(ppp);
 
 	mutex_lock(&pn->all_ppp_mutex);
-	unit_put(&pn->units_idr, ppp->file.index);
+	xa_erase(&pn->units, ppp->file.index);
 	mutex_unlock(&pn->all_ppp_mutex);
 
 	ppp->owner = NULL;
@@ -3136,7 +3129,7 @@ static void ppp_destroy_interface(struct ppp *ppp)
 static struct ppp *
 ppp_find_unit(struct ppp_net *pn, int unit)
 {
-	return unit_find(&pn->units_idr, unit);
+	return xa_load(&pn->units, unit);
 }
 
 /*
@@ -3277,40 +3270,6 @@ static void __exit ppp_cleanup(void)
 	unregister_pernet_device(&ppp_net_ops);
 }
 
-/*
- * Units handling. Caller must protect concurrent access
- * by holding all_ppp_mutex
- */
-
-/* associate pointer with specified number */
-static int unit_set(struct idr *p, void *ptr, int n)
-{
-	int unit;
-
-	unit = idr_alloc(p, ptr, n, n + 1, GFP_KERNEL);
-	if (unit == -ENOSPC)
-		unit = -EINVAL;
-	return unit;
-}
-
-/* get new free unit number and associate pointer with it */
-static int unit_get(struct idr *p, void *ptr)
-{
-	return idr_alloc(p, ptr, 0, 0, GFP_KERNEL);
-}
-
-/* put unit number back to a pool */
-static void unit_put(struct idr *p, int n)
-{
-	idr_remove(p, n);
-}
-
-/* get pointer associated with the number */
-static void *unit_find(struct idr *p, int n)
-{
-	return idr_find(p, n);
-}
-
 /* Module/initialization stuff */
 
 module_init(ppp_init);
-- 
2.23.0.rc1

