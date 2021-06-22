Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DA6713AFAEE
	for <lists+netdev@lfdr.de>; Tue, 22 Jun 2021 04:13:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231138AbhFVCPv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Jun 2021 22:15:51 -0400
Received: from szxga01-in.huawei.com ([45.249.212.187]:5062 "EHLO
        szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229663AbhFVCPt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Jun 2021 22:15:49 -0400
Received: from dggemv703-chm.china.huawei.com (unknown [172.30.72.55])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4G88vC0r76zXfNK;
        Tue, 22 Jun 2021 10:08:23 +0800 (CST)
Received: from dggpemm500001.china.huawei.com (7.185.36.107) by
 dggemv703-chm.china.huawei.com (10.3.19.46) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Tue, 22 Jun 2021 10:13:31 +0800
Received: from localhost.localdomain.localdomain (10.175.113.25) by
 dggpemm500001.china.huawei.com (7.185.36.107) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Tue, 22 Jun 2021 10:13:31 +0800
From:   Kefeng Wang <wangkefeng.wang@huawei.com>
To:     <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>
CC:     Kefeng Wang <wangkefeng.wang@huawei.com>,
        Hannes Frederic Sowa <hannes@stressinduktion.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        "Minmin chen" <chenmingmin@huawei.com>
Subject: [PATCH] once: Fix panic when module unload
Date:   Tue, 22 Jun 2021 10:21:38 +0800
Message-ID: <20210622022138.23048-1-wangkefeng.wang@huawei.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.113.25]
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
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
                                                   //*the key is destroy*
process_one_work
  once_deferred
    BUG_ON(!static_key_enabled(work->key));
       static_key_count((struct static_key *)x)    //*access key, crash*

When module uses DO_ONCE mechanism, it could crash due to the above
concurrency problem, we could reproduce it with link[1].

Fix it by add/put module refcount in the once work process.

[1]
https://lore.kernel.org/netdev/eaa6c371-465e-57eb-6be9-f4b16b9d7cbf@huawei.com/

Cc: Hannes Frederic Sowa <hannes@stressinduktion.org>
Cc: Daniel Borkmann <daniel@iogearbox.net>
Cc: David S. Miller <davem@davemloft.net>
Cc: Eric Dumazet <edumazet@google.com>
Reported-by: Minmin chen <chenmingmin@huawei.com>
Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
---
 lib/once.c | 17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff --git a/lib/once.c b/lib/once.c
index 8b7d6235217e..959f8db41ccf 100644
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
@@ -16,11 +18,24 @@ static void once_deferred(struct work_struct *w)
 	work = container_of(w, struct once_work, work);
 	BUG_ON(!static_key_enabled(work->key));
 	static_branch_disable(work->key);
+	module_put(work->module);
 	kfree(work);
 }
 
+static struct module *find_module_by_key(struct static_key_true *key)
+{
+	struct module *mod;
+
+	preempt_disable();
+	mod = __module_address((unsigned long)key);
+	preempt_enable();
+
+	return mod;
+}
+
 static void once_disable_jump(struct static_key_true *key)
 {
+	struct module *mod = find_module_by_key(key);
 	struct once_work *w;
 
 	w = kmalloc(sizeof(*w), GFP_ATOMIC);
@@ -29,6 +44,8 @@ static void once_disable_jump(struct static_key_true *key)
 
 	INIT_WORK(&w->work, once_deferred);
 	w->key = key;
+	w->module = mod;
+	__module_get(mod);
 	schedule_work(&w->work);
 }
 
-- 
2.26.2

