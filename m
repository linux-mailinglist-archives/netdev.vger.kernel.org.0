Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 63225125B4D
	for <lists+netdev@lfdr.de>; Thu, 19 Dec 2019 07:10:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726855AbfLSGKm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Dec 2019 01:10:42 -0500
Received: from mail-pj1-f66.google.com ([209.85.216.66]:53551 "EHLO
        mail-pj1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725821AbfLSGKl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Dec 2019 01:10:41 -0500
Received: by mail-pj1-f66.google.com with SMTP id n96so1990635pjc.3;
        Wed, 18 Dec 2019 22:10:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=IwWd16qrLebRkrBZgWKlA2mgtaHvdjRxS9SE17qY/xQ=;
        b=l0KZUrR+7MiFKxZWum8jdjuMavhdkY9qsGo/YJqZOrKqETeRtnhm6E2SaBEg8Fl8ti
         yc97ZmSX6wqUwfRb9aUXtlT23vRr9pUDtZLAQNq2vB0hazTgCppvYwmrRVIm1/Nn6x/e
         ChuDllW4twicJHoHfs5evUSphh0N8pGBIJfJsteFQe3mAbAwMvR7yB1XZTExMXb22sjC
         Yr0ew+1hOvk9yS1HfLYgaIBgKpv48Zzqjn8D9mNrd16aMtAHBFFfKaUc/r6GCc8cV1AQ
         /JjTUSmetdacxgtHjGVmMYC8PuOTmmkmOtHiOROBo5ZMSHC+cuGPvmD5m9nccxoRs1KE
         hsnA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=IwWd16qrLebRkrBZgWKlA2mgtaHvdjRxS9SE17qY/xQ=;
        b=srGO/cOeMZz3nl4iIQu4QKa2GlAEfSPEQGfBo2bJ91oBtO0K44XFrB/ksIsCArUALN
         L8xevv58F492/lZ255b+v/zXabQF6mc67nlJkbGu3vH44Cx8M1UOYQ+u5MU0TUXuQYFV
         EmHcSzz6gM7D1K+nUzMw+GEy/cgiOGN64CJGTa4mR3a/MqGevELGwUsArUvgMwXDoLlS
         fKuXgKgONezu9ymMFLk1S4KhXUVxgYZ3OBRROSe7sJhr5FerW6ILT40mP7K+JlZSwiih
         0WmpqOrRI7Z6Tf7kT++PWZCRSbSLWic8fZHYTabN36Y+MWQrvhtmNIKj6JqaF47SRU20
         FKpw==
X-Gm-Message-State: APjAAAVvw8bUHdxrJ8DyEmKwNng3wqKhWHDOH3cj7lp4oaGmHMRMPNNM
        X+B4PFNsK2g2SNDHr7+UQcwEaBv4LNNUXg==
X-Google-Smtp-Source: APXvYqyGeu2/zbRzxWdXLaQTJ3w6i6p9+cVx2TzETGGOSiKMl8EmfQr3sbAe972nZK4DVNdaHu+jRA==
X-Received: by 2002:a17:90a:2486:: with SMTP id i6mr8015270pje.9.1576735840641;
        Wed, 18 Dec 2019 22:10:40 -0800 (PST)
Received: from btopel-mobl.ger.intel.com (fmdmzpr04-ext.fm.intel.com. [192.55.55.39])
        by smtp.gmail.com with ESMTPSA id t23sm6465062pfq.106.2019.12.18.22.10.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Dec 2019 22:10:40 -0800 (PST)
From:   =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@gmail.com>
To:     netdev@vger.kernel.org, ast@kernel.org, daniel@iogearbox.net
Cc:     =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@intel.com>,
        bpf@vger.kernel.org, davem@davemloft.net,
        jakub.kicinski@netronome.com, hawk@kernel.org,
        john.fastabend@gmail.com, magnus.karlsson@intel.com,
        jonathan.lemon@gmail.com,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
Subject: [PATCH bpf-next v2 5/8] xdp: make devmap flush_list common for all map instances
Date:   Thu, 19 Dec 2019 07:10:03 +0100
Message-Id: <20191219061006.21980-6-bjorn.topel@gmail.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191219061006.21980-1-bjorn.topel@gmail.com>
References: <20191219061006.21980-1-bjorn.topel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Björn Töpel <bjorn.topel@intel.com>

The devmap flush list is used to track entries that need to flushed
from via the xdp_do_flush_map() function. This list used to be
per-map, but there is really no reason for that. Instead make the
flush list global for all devmaps, which simplifies __dev_map_flush()
and dev_map_init_map().

Acked-by: Toke Høiland-Jørgensen <toke@redhat.com>
Signed-off-by: Björn Töpel <bjorn.topel@intel.com>
---
 include/linux/bpf.h |  4 ++--
 kernel/bpf/devmap.c | 35 +++++++++++++----------------------
 net/core/filter.c   |  2 +-
 3 files changed, 16 insertions(+), 25 deletions(-)

diff --git a/include/linux/bpf.h b/include/linux/bpf.h
index d467983e61bb..31191804ca09 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -959,7 +959,7 @@ struct sk_buff;
 
 struct bpf_dtab_netdev *__dev_map_lookup_elem(struct bpf_map *map, u32 key);
 struct bpf_dtab_netdev *__dev_map_hash_lookup_elem(struct bpf_map *map, u32 key);
-void __dev_map_flush(struct bpf_map *map);
+void __dev_map_flush(void);
 int dev_map_enqueue(struct bpf_dtab_netdev *dst, struct xdp_buff *xdp,
 		    struct net_device *dev_rx);
 int dev_map_generic_redirect(struct bpf_dtab_netdev *dst, struct sk_buff *skb,
@@ -1068,7 +1068,7 @@ static inline struct net_device  *__dev_map_hash_lookup_elem(struct bpf_map *map
 	return NULL;
 }
 
-static inline void __dev_map_flush(struct bpf_map *map)
+static inline void __dev_map_flush(void)
 {
 }
 
diff --git a/kernel/bpf/devmap.c b/kernel/bpf/devmap.c
index b7595de6a91a..da9c832fc5c8 100644
--- a/kernel/bpf/devmap.c
+++ b/kernel/bpf/devmap.c
@@ -75,7 +75,6 @@ struct bpf_dtab_netdev {
 struct bpf_dtab {
 	struct bpf_map map;
 	struct bpf_dtab_netdev **netdev_map; /* DEVMAP type only */
-	struct list_head __percpu *flush_list;
 	struct list_head list;
 
 	/* these are only used for DEVMAP_HASH type maps */
@@ -85,6 +84,7 @@ struct bpf_dtab {
 	u32 n_buckets;
 };
 
+static DEFINE_PER_CPU(struct list_head, dev_map_flush_list);
 static DEFINE_SPINLOCK(dev_map_lock);
 static LIST_HEAD(dev_map_list);
 
@@ -109,8 +109,8 @@ static inline struct hlist_head *dev_map_index_hash(struct bpf_dtab *dtab,
 
 static int dev_map_init_map(struct bpf_dtab *dtab, union bpf_attr *attr)
 {
-	int err, cpu;
-	u64 cost;
+	u64 cost = 0;
+	int err;
 
 	/* check sanity of attributes */
 	if (attr->max_entries == 0 || attr->key_size != 4 ||
@@ -125,9 +125,6 @@ static int dev_map_init_map(struct bpf_dtab *dtab, union bpf_attr *attr)
 
 	bpf_map_init_from_attr(&dtab->map, attr);
 
-	/* make sure page count doesn't overflow */
-	cost = (u64) sizeof(struct list_head) * num_possible_cpus();
-
 	if (attr->map_type == BPF_MAP_TYPE_DEVMAP_HASH) {
 		dtab->n_buckets = roundup_pow_of_two(dtab->map.max_entries);
 
@@ -143,17 +140,10 @@ static int dev_map_init_map(struct bpf_dtab *dtab, union bpf_attr *attr)
 	if (err)
 		return -EINVAL;
 
-	dtab->flush_list = alloc_percpu(struct list_head);
-	if (!dtab->flush_list)
-		goto free_charge;
-
-	for_each_possible_cpu(cpu)
-		INIT_LIST_HEAD(per_cpu_ptr(dtab->flush_list, cpu));
-
 	if (attr->map_type == BPF_MAP_TYPE_DEVMAP_HASH) {
 		dtab->dev_index_head = dev_map_create_hash(dtab->n_buckets);
 		if (!dtab->dev_index_head)
-			goto free_percpu;
+			goto free_charge;
 
 		spin_lock_init(&dtab->index_lock);
 	} else {
@@ -161,13 +151,11 @@ static int dev_map_init_map(struct bpf_dtab *dtab, union bpf_attr *attr)
 						      sizeof(struct bpf_dtab_netdev *),
 						      dtab->map.numa_node);
 		if (!dtab->netdev_map)
-			goto free_percpu;
+			goto free_charge;
 	}
 
 	return 0;
 
-free_percpu:
-	free_percpu(dtab->flush_list);
 free_charge:
 	bpf_map_charge_finish(&dtab->map.memory);
 	return -ENOMEM;
@@ -254,7 +242,6 @@ static void dev_map_free(struct bpf_map *map)
 		bpf_map_area_free(dtab->netdev_map);
 	}
 
-	free_percpu(dtab->flush_list);
 	kfree(dtab);
 }
 
@@ -384,10 +371,9 @@ static int bq_xmit_all(struct xdp_bulk_queue *bq, u32 flags)
  * net device can be torn down. On devmap tear down we ensure the flush list
  * is empty before completing to ensure all flush operations have completed.
  */
-void __dev_map_flush(struct bpf_map *map)
+void __dev_map_flush(void)
 {
-	struct bpf_dtab *dtab = container_of(map, struct bpf_dtab, map);
-	struct list_head *flush_list = this_cpu_ptr(dtab->flush_list);
+	struct list_head *flush_list = this_cpu_ptr(&dev_map_flush_list);
 	struct xdp_bulk_queue *bq, *tmp;
 
 	rcu_read_lock();
@@ -419,7 +405,7 @@ static int bq_enqueue(struct bpf_dtab_netdev *obj, struct xdp_frame *xdpf,
 		      struct net_device *dev_rx)
 
 {
-	struct list_head *flush_list = this_cpu_ptr(obj->dtab->flush_list);
+	struct list_head *flush_list = this_cpu_ptr(&dev_map_flush_list);
 	struct xdp_bulk_queue *bq = this_cpu_ptr(obj->bulkq);
 
 	if (unlikely(bq->count == DEV_MAP_BULK_SIZE))
@@ -777,10 +763,15 @@ static struct notifier_block dev_map_notifier = {
 
 static int __init dev_map_init(void)
 {
+	int cpu;
+
 	/* Assure tracepoint shadow struct _bpf_dtab_netdev is in sync */
 	BUILD_BUG_ON(offsetof(struct bpf_dtab_netdev, dev) !=
 		     offsetof(struct _bpf_dtab_netdev, dev));
 	register_netdevice_notifier(&dev_map_notifier);
+
+	for_each_possible_cpu(cpu)
+		INIT_LIST_HEAD(&per_cpu(dev_map_flush_list, cpu));
 	return 0;
 }
 
diff --git a/net/core/filter.c b/net/core/filter.c
index c51678c473c5..b7570cb84902 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -3555,7 +3555,7 @@ void xdp_do_flush_map(void)
 		switch (map->map_type) {
 		case BPF_MAP_TYPE_DEVMAP:
 		case BPF_MAP_TYPE_DEVMAP_HASH:
-			__dev_map_flush(map);
+			__dev_map_flush();
 			break;
 		case BPF_MAP_TYPE_CPUMAP:
 			__cpu_map_flush(map);
-- 
2.20.1

