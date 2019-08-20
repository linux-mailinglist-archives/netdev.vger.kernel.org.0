Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5071596C63
	for <lists+netdev@lfdr.de>; Wed, 21 Aug 2019 00:34:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731199AbfHTWd4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Aug 2019 18:33:56 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:36986 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730981AbfHTWdC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Aug 2019 18:33:02 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description:Resent-Date:Resent-From
        :Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=Zi03AHwAAmTpHDRqyNtFRC9dOLO7obHgqglUc3WJ1ZI=; b=hi64jpA4/bQxmlT+QeTiHbpikf
        ZZ3FtkRnyItYX1/hSxi94LL2ClLiSZ8cvPpuf3PpWtpjl2QAU4VDnONviPirKDmiZu/se7UKwA4zf
        JccXPoWQive1KWTqh1s0krVogn/3y+eYfEhMlrIr0TG1QcTZxPwiqD4vkZaPSBf4cPP3I6ltDtFtp
        vqTet0qD45vhzP96E2E/xkKLLOjyUS3J8iL5Y2zdJ/mpwJ2bjc7rS2SSHu2aqbC1P8HUalGMfYeCA
        OYfScgfcRRfQIzFRLPIdGVEN2wDKCwtoqAYTZYZymIzNxEzNXT8yoU5lYfyfZ/vEG8LnqFYEqPmoF
        SqYCM+gw==;
Received: from willy by bombadil.infradead.org with local (Exim 4.92 #3 (Red Hat Linux))
        id 1i0CgY-0005qr-DJ; Tue, 20 Aug 2019 22:33:02 +0000
From:   Matthew Wilcox <willy@infradead.org>
To:     netdev@vger.kernel.org
Cc:     "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: [PATCH 14/38] tap: Convert minor_idr to XArray
Date:   Tue, 20 Aug 2019 15:32:35 -0700
Message-Id: <20190820223259.22348-15-willy@infradead.org>
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

The minor_lock can be removed as the XArray contains its own spinlock.
I suspect the GFP_ATOMIC allocation could be GFP_KERNEL, but I couldn't
prove it.

Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
---
 drivers/net/tap.c | 32 +++++++++++++-------------------
 1 file changed, 13 insertions(+), 19 deletions(-)

diff --git a/drivers/net/tap.c b/drivers/net/tap.c
index dd614c2cd994..81b06a21d96c 100644
--- a/drivers/net/tap.c
+++ b/drivers/net/tap.c
@@ -14,9 +14,9 @@
 #include <linux/slab.h>
 #include <linux/wait.h>
 #include <linux/cdev.h>
-#include <linux/idr.h>
 #include <linux/fs.h>
 #include <linux/uio.h>
+#include <linux/xarray.h>
 
 #include <net/net_namespace.h>
 #include <net/rtnetlink.h>
@@ -106,8 +106,7 @@ static LIST_HEAD(major_list);
 struct major_info {
 	struct rcu_head rcu;
 	dev_t major;
-	struct idr minor_idr;
-	spinlock_t minor_lock;
+	struct xarray tap_devs;
 	const char *device_name;
 	struct list_head next;
 };
@@ -414,19 +413,16 @@ int tap_get_minor(dev_t major, struct tap_dev *tap)
 		goto unlock;
 	}
 
-	spin_lock(&tap_major->minor_lock);
-	retval = idr_alloc(&tap_major->minor_idr, tap, 1, TAP_NUM_DEVS, GFP_ATOMIC);
-	if (retval >= 0) {
-		tap->minor = retval;
-	} else if (retval == -ENOSPC) {
+	retval = xa_alloc(&tap_major->tap_devs, &tap->minor, tap,
+			XA_LIMIT(0, TAP_NUM_DEVS), GFP_ATOMIC);
+	if (retval == -EBUSY) {
 		netdev_err(tap->dev, "Too many tap devices\n");
 		retval = -EINVAL;
 	}
-	spin_unlock(&tap_major->minor_lock);
 
 unlock:
 	rcu_read_unlock();
-	return retval < 0 ? retval : 0;
+	return retval;
 }
 EXPORT_SYMBOL_GPL(tap_get_minor);
 
@@ -440,12 +436,12 @@ void tap_free_minor(dev_t major, struct tap_dev *tap)
 		goto unlock;
 	}
 
-	spin_lock(&tap_major->minor_lock);
+	xa_lock(&tap_major->tap_devs);
 	if (tap->minor) {
-		idr_remove(&tap_major->minor_idr, tap->minor);
+		__xa_erase(&tap_major->tap_devs, tap->minor);
 		tap->minor = 0;
 	}
-	spin_unlock(&tap_major->minor_lock);
+	xa_unlock(&tap_major->tap_devs);
 
 unlock:
 	rcu_read_unlock();
@@ -465,13 +461,13 @@ static struct tap_dev *dev_get_by_tap_file(int major, int minor)
 		goto unlock;
 	}
 
-	spin_lock(&tap_major->minor_lock);
-	tap = idr_find(&tap_major->minor_idr, minor);
+	xa_lock(&tap_major->tap_devs);
+	tap = xa_load(&tap_major->tap_devs, minor);
 	if (tap) {
 		dev = tap->dev;
 		dev_hold(dev);
 	}
-	spin_unlock(&tap_major->minor_lock);
+	xa_unlock(&tap_major->tap_devs);
 
 unlock:
 	rcu_read_unlock();
@@ -1322,8 +1318,7 @@ static int tap_list_add(dev_t major, const char *device_name)
 
 	tap_major->major = MAJOR(major);
 
-	idr_init(&tap_major->minor_idr);
-	spin_lock_init(&tap_major->minor_lock);
+	xa_init_flags(&tap_major->tap_devs, XA_FLAGS_ALLOC1);
 
 	tap_major->device_name = device_name;
 
@@ -1369,7 +1364,6 @@ void tap_destroy_cdev(dev_t major, struct cdev *tap_cdev)
 	unregister_chrdev_region(major, TAP_NUM_DEVS);
 	list_for_each_entry_safe(tap_major, tmp, &major_list, next) {
 		if (tap_major->major == MAJOR(major)) {
-			idr_destroy(&tap_major->minor_idr);
 			list_del_rcu(&tap_major->next);
 			kfree_rcu(tap_major, rcu);
 		}
-- 
2.23.0.rc1

