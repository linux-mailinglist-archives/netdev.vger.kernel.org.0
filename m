Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AB6643074D3
	for <lists+netdev@lfdr.de>; Thu, 28 Jan 2021 12:32:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231320AbhA1LaB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Jan 2021 06:30:01 -0500
Received: from szxga04-in.huawei.com ([45.249.212.190]:11211 "EHLO
        szxga04-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231210AbhA1L32 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Jan 2021 06:29:28 -0500
Received: from DGGEMS407-HUB.china.huawei.com (unknown [172.30.72.58])
        by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4DRJ8n6DgtzlBxV;
        Thu, 28 Jan 2021 19:27:05 +0800 (CST)
Received: from huawei.com (10.175.113.133) by DGGEMS407-HUB.china.huawei.com
 (10.3.19.207) with Microsoft SMTP Server id 14.3.498.0; Thu, 28 Jan 2021
 19:28:33 +0800
From:   Wang Hai <wanghai38@huawei.com>
To:     <torvalds@linux-foundation.org>, <cl@linux.com>,
        <penberg@kernel.org>, <rientjes@google.com>,
        <iamjoonsoo.kim@lge.com>, <akpm@linux-foundation.org>,
        <vbabka@suse.cz>
CC:     <asmadeus@codewreck.org>, <davem@davemloft.net>,
        <ericvh@gmail.com>, <kuba@kernel.org>, <lucho@ionkov.net>,
        <netdev@vger.kernel.org>, <syzkaller-bugs@googlegroups.com>,
        <v9fs-developer@lists.sourceforge.net>, <linux-mm@kvack.org>,
        <linux-kernel@vger.kernel.org>,
        <syzbot+d0bd96b4696c1ef67991@syzkaller.appspotmail.com>
Subject: [PATCH] Revert "mm/slub: fix a memory leak in sysfs_slab_add()"
Date:   Thu, 28 Jan 2021 19:32:50 +0800
Message-ID: <20210128113250.60078-1-wanghai38@huawei.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.175.113.133]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This reverts commit dde3c6b72a16c2db826f54b2d49bdea26c3534a2.

syzbot report a double-free bug. The following case can cause this bug.
 - mm/slab_common.c: create_cache(): if the __kmem_cache_create()
fails, it does:

	out_free_cache:
		kmem_cache_free(kmem_cache, s);

 - but __kmem_cache_create() - at least for slub() - will have done

	sysfs_slab_add(s)
		-> sysfs_create_group() .. fails ..
		-> kobject_del(&s->kobj); .. which frees s ...

We can't remove the kmem_cache_free() in create_cache(), because
other error cases of __kmem_cache_create() do not free this.

So, revert the commit dde3c6b72a16 ("mm/slub: fix a memory leak in
sysfs_slab_add()") to fix this.

Reported-by: syzbot+d0bd96b4696c1ef67991@syzkaller.appspotmail.com
Fixes: dde3c6b72a16 ("mm/slub: fix a memory leak in sysfs_slab_add()")
Signed-off-by: Wang Hai <wanghai38@huawei.com>
---
 mm/slub.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/mm/slub.c b/mm/slub.c
index 69742ab9a21d..7ecbbbe5bc0c 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -5625,10 +5625,8 @@ static int sysfs_slab_add(struct kmem_cache *s)
 
 	s->kobj.kset = kset;
 	err = kobject_init_and_add(&s->kobj, &slab_ktype, NULL, "%s", name);
-	if (err) {
-		kobject_put(&s->kobj);
+	if (err)
 		goto out;
-	}
 
 	err = sysfs_create_group(&s->kobj, &slab_attr_group);
 	if (err)
-- 
2.17.1

