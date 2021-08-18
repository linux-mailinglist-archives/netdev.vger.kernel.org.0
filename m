Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 98B313EF8A7
	for <lists+netdev@lfdr.de>; Wed, 18 Aug 2021 05:33:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237392AbhHRDe2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Aug 2021 23:34:28 -0400
Received: from szxga01-in.huawei.com ([45.249.212.187]:8034 "EHLO
        szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237149AbhHRDeW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Aug 2021 23:34:22 -0400
Received: from dggemv704-chm.china.huawei.com (unknown [172.30.72.54])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4GqD4y3XslzYqht;
        Wed, 18 Aug 2021 11:33:22 +0800 (CST)
Received: from dggpemm500005.china.huawei.com (7.185.36.74) by
 dggemv704-chm.china.huawei.com (10.3.19.47) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Wed, 18 Aug 2021 11:33:28 +0800
Received: from localhost.localdomain (10.69.192.56) by
 dggpemm500005.china.huawei.com (7.185.36.74) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Wed, 18 Aug 2021 11:33:28 +0800
From:   Yunsheng Lin <linyunsheng@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>
CC:     <alexander.duyck@gmail.com>, <linux@armlinux.org.uk>,
        <mw@semihalf.com>, <linuxarm@openeuler.org>,
        <yisen.zhuang@huawei.com>, <salil.mehta@huawei.com>,
        <thomas.petazzoni@bootlin.com>, <hawk@kernel.org>,
        <ilias.apalodimas@linaro.org>, <ast@kernel.org>,
        <daniel@iogearbox.net>, <john.fastabend@gmail.com>,
        <akpm@linux-foundation.org>, <peterz@infradead.org>,
        <will@kernel.org>, <willy@infradead.org>, <vbabka@suse.cz>,
        <fenghua.yu@intel.com>, <guro@fb.com>, <peterx@redhat.com>,
        <feng.tang@intel.com>, <jgg@ziepe.ca>, <mcroce@microsoft.com>,
        <hughd@google.com>, <jonathan.lemon@gmail.com>, <alobakin@pm.me>,
        <willemb@google.com>, <wenxu@ucloud.cn>, <cong.wang@bytedance.com>,
        <haokexin@gmail.com>, <nogikh@google.com>, <elver@google.com>,
        <yhs@fb.com>, <kpsingh@kernel.org>, <andrii@kernel.org>,
        <kafai@fb.com>, <songliubraving@fb.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <bpf@vger.kernel.org>,
        <chenhao288@hisilicon.com>, <edumazet@google.com>,
        <yoshfuji@linux-ipv6.org>, <dsahern@kernel.org>,
        <memxor@gmail.com>, <linux@rempel-privat.de>, <atenart@kernel.org>,
        <weiwan@google.com>, <ap420073@gmail.com>, <arnd@arndb.de>,
        <mathew.j.martineau@linux.intel.com>, <aahringo@redhat.com>,
        <ceggers@arri.de>, <yangbo.lu@nxp.com>, <fw@strlen.de>,
        <xiangxia.m.yue@gmail.com>, <linmiaohe@huawei.com>
Subject: [PATCH RFC 4/7] net: pfrag_pool: add pfrag pool support based on page pool
Date:   Wed, 18 Aug 2021 11:32:20 +0800
Message-ID: <1629257542-36145-5-git-send-email-linyunsheng@huawei.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1629257542-36145-1-git-send-email-linyunsheng@huawei.com>
References: <1629257542-36145-1-git-send-email-linyunsheng@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.56]
X-ClientProxiedBy: dggems704-chm.china.huawei.com (10.3.19.181) To
 dggpemm500005.china.huawei.com (7.185.36.74)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch add the pfrag pool support based on page pool.
Caller need to call pfrag_pool_updata_napi() to connect the
pfrag pool to the page pool through napi.

Signed-off-by: Yunsheng Lin <linyunsheng@huawei.com>
---
 include/net/pfrag_pool.h | 24 +++++++++++++
 net/core/Makefile        |  1 +
 net/core/pfrag_pool.c    | 92 ++++++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 117 insertions(+)
 create mode 100644 include/net/pfrag_pool.h
 create mode 100644 net/core/pfrag_pool.c

diff --git a/include/net/pfrag_pool.h b/include/net/pfrag_pool.h
new file mode 100644
index 0000000..2abea26
--- /dev/null
+++ b/include/net/pfrag_pool.h
@@ -0,0 +1,24 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef _PAGE_FRAG_H
+#define _PAGE_FRAG_H
+
+#include <linux/gfp.h>
+#include <linux/llist.h>
+#include <linux/mm_types_task.h>
+#include <net/page_pool.h>
+
+struct pfrag_pool {
+	struct page_frag frag;
+	long frag_users;
+	unsigned int napi_id;
+	struct page_pool *pp;
+	struct pp_alloc_cache alloc;
+};
+
+void pfrag_pool_updata_napi(struct pfrag_pool *pool,
+			    unsigned int napi_id);
+struct page_frag *pfrag_pool_refill(struct pfrag_pool *pool, gfp_t gfp);
+void pfrag_pool_commit(struct pfrag_pool *pool, unsigned int sz,
+		      bool merge);
+void pfrag_pool_flush(struct pfrag_pool *pool);
+#endif
diff --git a/net/core/Makefile b/net/core/Makefile
index 35ced62..171f839 100644
--- a/net/core/Makefile
+++ b/net/core/Makefile
@@ -14,6 +14,7 @@ obj-y		     += dev.o dev_addr_lists.o dst.o netevent.o \
 			fib_notifier.o xdp.o flow_offload.o
 
 obj-y += net-sysfs.o
+obj-y += pfrag_pool.o
 obj-$(CONFIG_PAGE_POOL) += page_pool.o
 obj-$(CONFIG_PROC_FS) += net-procfs.o
 obj-$(CONFIG_NET_PKTGEN) += pktgen.o
diff --git a/net/core/pfrag_pool.c b/net/core/pfrag_pool.c
new file mode 100644
index 0000000..6ad1383
--- /dev/null
+++ b/net/core/pfrag_pool.c
@@ -0,0 +1,92 @@
+// SPDX-License-Identifier: GPL-2.0
+
+#include <linux/align.h>
+#include <linux/dma-mapping.h>
+#include <linux/mm.h>
+#include <linux/netdevice.h>
+#include <net/pfrag_pool.h>
+
+#define BAIS_MAX	(LONG_MAX / 2)
+
+void pfrag_pool_updata_napi(struct pfrag_pool *pool,
+			    unsigned int napi_id)
+{
+	struct page_pool *pp;
+
+	if (!pool || pool->napi_id == napi_id)
+		return;
+
+	pr_info("frag pool %pK's napi id changed from %u to %u\n",
+		pool, pool->napi_id, napi_id);
+
+	rcu_read_lock();
+	pp = page_pool_get_by_napi_id(napi_id);
+	if (!pp) {
+		rcu_read_unlock();
+		return;
+	}
+
+	pool->napi_id = napi_id;
+	pool->pp = pp;
+	rcu_read_unlock();
+}
+EXPORT_SYMBOL(pfrag_pool_updata_napi);
+
+struct page_frag *pfrag_pool_refill(struct pfrag_pool *pool, gfp_t gfp)
+{
+	struct page_frag *pfrag = &pool->frag;
+
+	if (!pool || !pool->pp)
+		return NULL;
+
+	if (pfrag->page) {
+		long drain_users;
+
+		if (pfrag->offset < pfrag->size)
+			return pfrag;
+
+		drain_users = BAIS_MAX - pool->frag_users;
+		if (page_pool_drain_frag(pool->pp, pfrag->page, drain_users))
+			goto out;
+	}
+
+	pfrag->page = __page_pool_alloc_pages(pool->pp, &pool->alloc, gfp);
+	if (unlikely(!pfrag->page))
+		return NULL;
+
+out:
+	page_pool_set_frag_count(pfrag->page, BAIS_MAX);
+	pfrag->size = page_size(pfrag->page);
+	pool->frag_users = 0;
+	pfrag->offset = 0;
+	return pfrag;
+}
+EXPORT_SYMBOL(pfrag_pool_refill);
+
+void pfrag_pool_commit(struct pfrag_pool *pool, unsigned int sz,
+		       bool merge)
+{
+	struct page_frag *pfrag = &pool->frag;
+
+	pfrag->offset += ALIGN(sz, dma_get_cache_alignment());
+	WARN_ON(pfrag->offset > pfrag->size);
+
+	if (!merge)
+		pool->frag_users++;
+}
+EXPORT_SYMBOL(pfrag_pool_commit);
+
+void pfrag_pool_flush(struct pfrag_pool *pool)
+{
+	struct page_frag *pfrag = &pool->frag;
+
+	page_pool_empty_alloc_cache_once(pool->pp, &pool->alloc);
+
+	if (!pfrag->page)
+		return;
+
+	page_pool_free_frag(pool->pp, pfrag->page,
+			    BAIS_MAX - pool->frag_users);
+	pfrag->page = NULL;
+}
+EXPORT_SYMBOL(pfrag_pool_flush);
-- 
2.7.4

