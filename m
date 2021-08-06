Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C014D3E251F
	for <lists+netdev@lfdr.de>; Fri,  6 Aug 2021 10:17:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242387AbhHFIRq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Aug 2021 04:17:46 -0400
Received: from szxga01-in.huawei.com ([45.249.212.187]:7796 "EHLO
        szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243591AbhHFIQG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Aug 2021 04:16:06 -0400
Received: from dggemv704-chm.china.huawei.com (unknown [172.30.72.53])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4GgywD3GwRzYkqc;
        Fri,  6 Aug 2021 16:15:40 +0800 (CST)
Received: from dggpemm500001.china.huawei.com (7.185.36.107) by
 dggemv704-chm.china.huawei.com (10.3.19.47) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Fri, 6 Aug 2021 16:15:48 +0800
Received: from localhost.localdomain.localdomain (10.175.113.25) by
 dggpemm500001.china.huawei.com (7.185.36.107) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Fri, 6 Aug 2021 16:15:48 +0800
From:   Kefeng Wang <wangkefeng.wang@huawei.com>
To:     <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        <hannes@stressinduktion.org>, <davem@davemloft.net>
CC:     <akpm@linux-foundation.org>, <gregkh@linuxfoundation.org>,
        Kefeng Wang <wangkefeng.wang@huawei.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "Eric Dumazet" <edumazet@google.com>,
        Minmin chen <chenmingmin@huawei.com>
Subject: [PATCH v2] once: Fix panic when module unload
Date:   Fri, 6 Aug 2021 16:21:24 +0800
Message-ID: <20210806082124.96607-1-wangkefeng.wang@huawei.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.113.25]
X-ClientProxiedBy: dggems705-chm.china.huawei.com (10.3.19.182) To
 dggpemm500001.china.huawei.com (7.185.36.107)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DO_ONCE
DEFINE_STATIC_KEY_TRUE(___once_key);
__do_once_done
  once_disable_jump(once_key);
    INIT_WORK(&w->work, once_deferred);
    struct once_work *w;
    w->key = key;
    schedule_work(&w->work);                     module unload
                                                   //*the key is
destroy*
process_one_work
  once_deferred
    BUG_ON(!static_key_enabled(work->key));
       static_key_count((struct static_key *)x)    //*access key, crash*

When module uses DO_ONCE mechanism, it could crash due to the above
concurrency problem, we could reproduce it with link[1].

Fix it by add/put module refcount in the once work process.

[1] https://lore.kernel.org/netdev/eaa6c371-465e-57eb-6be9-f4b16b9d7cbf@huawei.com/

Cc: Hannes Frederic Sowa <hannes@stressinduktion.org>
Cc: Daniel Borkmann <daniel@iogearbox.net>
Cc: David S. Miller <davem@davemloft.net>
Cc: Eric Dumazet <edumazet@google.com>
Reported-by: Minmin chen <chenmingmin@huawei.com>
Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
---
v2: always pass THIS_MODULE to macro DO_ONCE(), suggested by hannes

 include/linux/once.h |  4 ++--
 lib/once.c           | 11 ++++++++---
 2 files changed, 10 insertions(+), 5 deletions(-)

diff --git a/include/linux/once.h b/include/linux/once.h
index 9225ee6d96c7..ae6f4eb41cbe 100644
--- a/include/linux/once.h
+++ b/include/linux/once.h
@@ -7,7 +7,7 @@
 
 bool __do_once_start(bool *done, unsigned long *flags);
 void __do_once_done(bool *done, struct static_key_true *once_key,
-		    unsigned long *flags);
+		    unsigned long *flags, struct module *mod);
 
 /* Call a function exactly once. The idea of DO_ONCE() is to perform
  * a function call such as initialization of random seeds, etc, only
@@ -46,7 +46,7 @@ void __do_once_done(bool *done, struct static_key_true *once_key,
 			if (unlikely(___ret)) {				     \
 				func(__VA_ARGS__);			     \
 				__do_once_done(&___done, &___once_key,	     \
-					       &___flags);		     \
+					       &___flags, THIS_MODULE);	     \
 			}						     \
 		}							     \
 		___ret;							     \
diff --git a/lib/once.c b/lib/once.c
index 8b7d6235217e..59149bf3bfb4 100644
--- a/lib/once.c
+++ b/lib/once.c
@@ -3,10 +3,12 @@
 #include <linux/spinlock.h>
 #include <linux/once.h>
 #include <linux/random.h>
+#include <linux/module.h>
 
 struct once_work {
 	struct work_struct work;
 	struct static_key_true *key;
+	struct module *module;
 };
 
 static void once_deferred(struct work_struct *w)
@@ -16,10 +18,11 @@ static void once_deferred(struct work_struct *w)
 	work = container_of(w, struct once_work, work);
 	BUG_ON(!static_key_enabled(work->key));
 	static_branch_disable(work->key);
+	module_put(work->module);
 	kfree(work);
 }
 
-static void once_disable_jump(struct static_key_true *key)
+static void once_disable_jump(struct static_key_true *key, struct module *mod)
 {
 	struct once_work *w;
 
@@ -29,6 +32,8 @@ static void once_disable_jump(struct static_key_true *key)
 
 	INIT_WORK(&w->work, once_deferred);
 	w->key = key;
+	w->module = mod;
+	__module_get(mod);
 	schedule_work(&w->work);
 }
 
@@ -53,11 +58,11 @@ bool __do_once_start(bool *done, unsigned long *flags)
 EXPORT_SYMBOL(__do_once_start);
 
 void __do_once_done(bool *done, struct static_key_true *once_key,
-		    unsigned long *flags)
+		    unsigned long *flags, struct module *mod)
 	__releases(once_lock)
 {
 	*done = true;
 	spin_unlock_irqrestore(&once_lock, *flags);
-	once_disable_jump(once_key);
+	once_disable_jump(once_key, mod);
 }
 EXPORT_SYMBOL(__do_once_done);
-- 
2.26.2

