Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8D5233EF8A9
	for <lists+netdev@lfdr.de>; Wed, 18 Aug 2021 05:34:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237168AbhHRDeV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Aug 2021 23:34:21 -0400
Received: from szxga02-in.huawei.com ([45.249.212.188]:8871 "EHLO
        szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237076AbhHRDeU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Aug 2021 23:34:20 -0400
Received: from dggemv711-chm.china.huawei.com (unknown [172.30.72.55])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4GqD0h3NJVz8sZW;
        Wed, 18 Aug 2021 11:29:40 +0800 (CST)
Received: from dggpemm500005.china.huawei.com (7.185.36.74) by
 dggemv711-chm.china.huawei.com (10.1.198.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Wed, 18 Aug 2021 11:33:28 +0800
Received: from localhost.localdomain (10.69.192.56) by
 dggpemm500005.china.huawei.com (7.185.36.74) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Wed, 18 Aug 2021 11:33:27 +0800
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
Subject: [PATCH RFC 3/7] net: add NAPI api to register and retrieve the page pool ptr
Date:   Wed, 18 Aug 2021 11:32:19 +0800
Message-ID: <1629257542-36145-4-git-send-email-linyunsheng@huawei.com>
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

As tx recycling is built upon the busy polling infrastructure,
and busy polling is based on napi_id, so add a api for driver
to register a page pool to a NAPI instance and api for socket
layer to retrieve the page pool corresponding to a NAPI.

Signed-off-by: Yunsheng Lin <linyunsheng@huawei.com>
---
 include/linux/netdevice.h |  9 +++++++++
 net/core/dev.c            | 34 +++++++++++++++++++++++++++++++---
 2 files changed, 40 insertions(+), 3 deletions(-)

diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index 2f03cd9..51a1169 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -40,6 +40,7 @@
 #endif
 #include <net/netprio_cgroup.h>
 #include <net/xdp.h>
+#include <net/page_pool.h>
 
 #include <linux/netdev_features.h>
 #include <linux/neighbour.h>
@@ -336,6 +337,7 @@ struct napi_struct {
 	struct hlist_node	napi_hash_node;
 	unsigned int		napi_id;
 	struct task_struct	*thread;
+	struct page_pool        *pp;
 };
 
 enum {
@@ -349,6 +351,7 @@ enum {
 	NAPI_STATE_PREFER_BUSY_POLL,	/* prefer busy-polling over softirq processing*/
 	NAPI_STATE_THREADED,		/* The poll is performed inside its own thread*/
 	NAPI_STATE_SCHED_THREADED,	/* Napi is currently scheduled in threaded mode */
+	NAPI_STATE_RECYCLABLE,          /* Support tx page recycling */
 };
 
 enum {
@@ -362,6 +365,7 @@ enum {
 	NAPIF_STATE_PREFER_BUSY_POLL	= BIT(NAPI_STATE_PREFER_BUSY_POLL),
 	NAPIF_STATE_THREADED		= BIT(NAPI_STATE_THREADED),
 	NAPIF_STATE_SCHED_THREADED	= BIT(NAPI_STATE_SCHED_THREADED),
+	NAPIF_STATE_RECYCLABLE          = BIT(NAPI_STATE_RECYCLABLE),
 };
 
 enum gro_result {
@@ -2473,6 +2477,10 @@ static inline void *netdev_priv(const struct net_device *dev)
 void netif_napi_add(struct net_device *dev, struct napi_struct *napi,
 		    int (*poll)(struct napi_struct *, int), int weight);
 
+void netif_recyclable_napi_add(struct net_device *dev, struct napi_struct *napi,
+			       int (*poll)(struct napi_struct *, int),
+			       int weight, struct page_pool *pool);
+
 /**
  *	netif_tx_napi_add - initialize a NAPI context
  *	@dev:  network device
@@ -2997,6 +3005,7 @@ struct net_device *dev_get_by_index(struct net *net, int ifindex);
 struct net_device *__dev_get_by_index(struct net *net, int ifindex);
 struct net_device *dev_get_by_index_rcu(struct net *net, int ifindex);
 struct net_device *dev_get_by_napi_id(unsigned int napi_id);
+struct page_pool *page_pool_get_by_napi_id(unsigned int napi_id);
 int netdev_get_name(struct net *net, char *name, int ifindex);
 int dev_restart(struct net_device *dev);
 int skb_gro_receive(struct sk_buff *p, struct sk_buff *skb);
diff --git a/net/core/dev.c b/net/core/dev.c
index 74fd402..d6b905b 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -935,6 +935,19 @@ struct net_device *dev_get_by_napi_id(unsigned int napi_id)
 }
 EXPORT_SYMBOL(dev_get_by_napi_id);
 
+struct page_pool *page_pool_get_by_napi_id(unsigned int napi_id)
+{
+	struct napi_struct *napi;
+	struct page_pool *pp = NULL;
+
+	napi = napi_by_id(napi_id);
+	if (napi)
+		pp = napi->pp;
+
+	return pp;
+}
+EXPORT_SYMBOL(page_pool_get_by_napi_id);
+
 /**
  *	netdev_get_name - get a netdevice name, knowing its ifindex.
  *	@net: network namespace
@@ -6757,7 +6770,8 @@ EXPORT_SYMBOL(napi_busy_loop);
 
 static void napi_hash_add(struct napi_struct *napi)
 {
-	if (test_bit(NAPI_STATE_NO_BUSY_POLL, &napi->state))
+	if (test_bit(NAPI_STATE_NO_BUSY_POLL, &napi->state) ||
+	    !test_bit(NAPI_STATE_RECYCLABLE, &napi->state))
 		return;
 
 	spin_lock(&napi_hash_lock);
@@ -6860,8 +6874,10 @@ int dev_set_threaded(struct net_device *dev, bool threaded)
 }
 EXPORT_SYMBOL(dev_set_threaded);
 
-void netif_napi_add(struct net_device *dev, struct napi_struct *napi,
-		    int (*poll)(struct napi_struct *, int), int weight)
+void netif_recyclable_napi_add(struct net_device *dev,
+			       struct napi_struct *napi,
+			       int (*poll)(struct napi_struct *, int),
+			       int weight, struct page_pool *pool)
 {
 	if (WARN_ON(test_and_set_bit(NAPI_STATE_LISTED, &napi->state)))
 		return;
@@ -6886,6 +6902,11 @@ void netif_napi_add(struct net_device *dev, struct napi_struct *napi,
 	set_bit(NAPI_STATE_SCHED, &napi->state);
 	set_bit(NAPI_STATE_NPSVC, &napi->state);
 	list_add_rcu(&napi->dev_list, &dev->napi_list);
+	if (pool) {
+		napi->pp = pool;
+		set_bit(NAPI_STATE_RECYCLABLE, &napi->state);
+	}
+
 	napi_hash_add(napi);
 	/* Create kthread for this napi if dev->threaded is set.
 	 * Clear dev->threaded if kthread creation failed so that
@@ -6894,6 +6915,13 @@ void netif_napi_add(struct net_device *dev, struct napi_struct *napi,
 	if (dev->threaded && napi_kthread_create(napi))
 		dev->threaded = 0;
 }
+EXPORT_SYMBOL(netif_recyclable_napi_add);
+
+void netif_napi_add(struct net_device *dev, struct napi_struct *napi,
+		    int (*poll)(struct napi_struct *, int), int weight)
+{
+	netif_recyclable_napi_add(dev, napi, poll, weight, NULL);
+}
 EXPORT_SYMBOL(netif_napi_add);
 
 void napi_disable(struct napi_struct *n)
-- 
2.7.4

