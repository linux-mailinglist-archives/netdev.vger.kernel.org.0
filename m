Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4C4E260B3F
	for <lists+netdev@lfdr.de>; Fri,  5 Jul 2019 19:56:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726977AbfGER4x (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Jul 2019 13:56:53 -0400
Received: from mail-ed1-f68.google.com ([209.85.208.68]:35471 "EHLO
        mail-ed1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725884AbfGER4w (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 5 Jul 2019 13:56:52 -0400
Received: by mail-ed1-f68.google.com with SMTP id w20so8592465edd.2
        for <netdev@vger.kernel.org>; Fri, 05 Jul 2019 10:56:50 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:date:message-id:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=D6twcxWZTGL7+3x4qBylDNwClcOjgk2IqfKZPOo7CbE=;
        b=N8fmQsQwGSMoSpeZ1gCqlw2LpYpyhHwGv5Jb9W8WlfAw/64Ea7JrHigYZYcf+CLAkL
         6b0jOKXZ3iZXklFv5NCc6BHmk3ohVL9JSQceBFlN16hHj36Pbmhl9ZfL7tn3ue/rHCFz
         6oL8CwfWj1lEx+GwAlljQ6GHJNh2S2H9V0SoEWAWPorTMSpbo9XVGTx2WcvuVB7lFMMh
         5bXr2KlWWkHTQJRJzundAJf8PkM5SomHM7DoZbGmMhEEVij56YdVmkrAJfLk9CehgDYz
         j/RRQVSGQmjbd7Asx8KVY0u6hhmpNacuSQXsDYRwXoQ735TaS+oPsIYHXsYxWSqczbWa
         j6AQ==
X-Gm-Message-State: APjAAAWidnvlR3N6uqJdGeJmGtSsOvSvJ6PKawapTgXEF4NxpBpu5jx2
        U64Js2JhMYkqF3BsDSkg2UwHog==
X-Google-Smtp-Source: APXvYqyHcRBkuHqjV74fRzzZ45IIXs+WDku1UCsfFl9FEfqQpcg6+RS4Wq+WzDey1K7f3lgVNSE95w==
X-Received: by 2002:a50:90c5:: with SMTP id d5mr4633212eda.28.1562349410254;
        Fri, 05 Jul 2019 10:56:50 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([2a00:7660:6da:443::2])
        by smtp.gmail.com with ESMTPSA id p43sm2922613edc.3.2019.07.05.10.56.48
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Fri, 05 Jul 2019 10:56:48 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 85CF7181CE8; Fri,  5 Jul 2019 19:56:48 +0200 (CEST)
Subject: [PATCH bpf-next 2/3] xdp: Refactor devmap allocation code for reuse
From:   =?utf-8?q?Toke_H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     Alexei Starovoitov <ast@kernel.org>, netdev@vger.kernel.org,
        David Miller <davem@davemloft.net>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        =?utf-8?b?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>
Date:   Fri, 05 Jul 2019 19:56:48 +0200
Message-ID: <156234940841.2378.6629890565300526702.stgit@alrua-x1>
In-Reply-To: <156234940798.2378.9008707939063611210.stgit@alrua-x1>
References: <156234940798.2378.9008707939063611210.stgit@alrua-x1>
User-Agent: StGit/0.19-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Toke Høiland-Jørgensen <toke@redhat.com>

The subsequent patch to add a new devmap sub-type can re-use much of the
initialisation and allocation code, so refactor it into separate functions.

Signed-off-by: Toke Høiland-Jørgensen <toke@redhat.com>
---
 kernel/bpf/devmap.c |  137 +++++++++++++++++++++++++++++++--------------------
 1 file changed, 84 insertions(+), 53 deletions(-)

diff --git a/kernel/bpf/devmap.c b/kernel/bpf/devmap.c
index d83cf8ccc872..a2fe16362129 100644
--- a/kernel/bpf/devmap.c
+++ b/kernel/bpf/devmap.c
@@ -60,7 +60,7 @@ struct xdp_bulk_queue {
 struct bpf_dtab_netdev {
 	struct net_device *dev; /* must be first member, due to tracepoint */
 	struct bpf_dtab *dtab;
-	unsigned int bit;
+	unsigned int idx; /* keep track of map index for tracepoint */
 	struct xdp_bulk_queue __percpu *bulkq;
 	struct rcu_head rcu;
 };
@@ -75,28 +75,22 @@ struct bpf_dtab {
 static DEFINE_SPINLOCK(dev_map_lock);
 static LIST_HEAD(dev_map_list);
 
-static struct bpf_map *dev_map_alloc(union bpf_attr *attr)
+static int dev_map_init_map(struct bpf_dtab *dtab, union bpf_attr *attr,
+			    bool check_memlock)
 {
-	struct bpf_dtab *dtab;
 	int err, cpu;
 	u64 cost;
 
-	if (!capable(CAP_NET_ADMIN))
-		return ERR_PTR(-EPERM);
-
 	/* check sanity of attributes */
 	if (attr->max_entries == 0 || attr->key_size != 4 ||
 	    attr->value_size != 4 || attr->map_flags & ~DEV_CREATE_FLAG_MASK)
-		return ERR_PTR(-EINVAL);
+		return -EINVAL;
 
 	/* Lookup returns a pointer straight to dev->ifindex, so make sure the
 	 * verifier prevents writes from the BPF side
 	 */
 	attr->map_flags |= BPF_F_RDONLY_PROG;
 
-	dtab = kzalloc(sizeof(*dtab), GFP_USER);
-	if (!dtab)
-		return ERR_PTR(-ENOMEM);
 
 	bpf_map_init_from_attr(&dtab->map, attr);
 
@@ -107,9 +101,7 @@ static struct bpf_map *dev_map_alloc(union bpf_attr *attr)
 	/* if map size is larger than memlock limit, reject it */
 	err = bpf_map_charge_init(&dtab->map.memory, cost);
 	if (err)
-		goto free_dtab;
-
-	err = -ENOMEM;
+		return -EINVAL;
 
 	dtab->flush_list = alloc_percpu(struct list_head);
 	if (!dtab->flush_list)
@@ -124,19 +116,38 @@ static struct bpf_map *dev_map_alloc(union bpf_attr *attr)
 	if (!dtab->netdev_map)
 		goto free_percpu;
 
-	spin_lock(&dev_map_lock);
-	list_add_tail_rcu(&dtab->list, &dev_map_list);
-	spin_unlock(&dev_map_lock);
-
-	return &dtab->map;
+	return 0;
 
 free_percpu:
 	free_percpu(dtab->flush_list);
 free_charge:
 	bpf_map_charge_finish(&dtab->map.memory);
-free_dtab:
-	kfree(dtab);
-	return ERR_PTR(err);
+	return -ENOMEM;
+}
+
+static struct bpf_map *dev_map_alloc(union bpf_attr *attr)
+{
+	struct bpf_dtab *dtab;
+	int err;
+
+	if (!capable(CAP_NET_ADMIN))
+		return ERR_PTR(-EPERM);
+
+	dtab = kzalloc(sizeof(*dtab), GFP_USER);
+	if (!dtab)
+		return ERR_PTR(-ENOMEM);
+
+	err = dev_map_init_map(dtab, attr, true);
+	if (err) {
+		kfree(dtab);
+		return ERR_PTR(err);
+	}
+
+	spin_lock(&dev_map_lock);
+	list_add_tail_rcu(&dtab->list, &dev_map_list);
+	spin_unlock(&dev_map_lock);
+
+	return &dtab->map;
 }
 
 static void dev_map_free(struct bpf_map *map)
@@ -235,7 +246,7 @@ static int bq_xmit_all(struct xdp_bulk_queue *bq, u32 flags,
 out:
 	bq->count = 0;
 
-	trace_xdp_devmap_xmit(&obj->dtab->map, obj->bit,
+	trace_xdp_devmap_xmit(&obj->dtab->map, obj->idx,
 			      sent, drops, bq->dev_rx, dev, err);
 	bq->dev_rx = NULL;
 	__list_del_clearprev(&bq->flush_node);
@@ -412,17 +423,52 @@ static int dev_map_delete_elem(struct bpf_map *map, void *key)
 	return 0;
 }
 
-static int dev_map_update_elem(struct bpf_map *map, void *key, void *value,
-				u64 map_flags)
+static struct bpf_dtab_netdev *__dev_map_alloc_node(struct net *net,
+						    struct bpf_dtab *dtab,
+						    u32 ifindex,
+						    unsigned int idx)
 {
-	struct bpf_dtab *dtab = container_of(map, struct bpf_dtab, map);
-	struct net *net = current->nsproxy->net_ns;
 	gfp_t gfp = GFP_ATOMIC | __GFP_NOWARN;
+	struct bpf_dtab_netdev *dev;
+	struct xdp_bulk_queue *bq;
+	int cpu;
+
+	dev = kmalloc_node(sizeof(*dev), gfp, dtab->map.numa_node);
+	if (!dev)
+		return ERR_PTR(-ENOMEM);
+
+	dev->bulkq = __alloc_percpu_gfp(sizeof(*dev->bulkq),
+					sizeof(void *), gfp);
+	if (!dev->bulkq) {
+		kfree(dev);
+		return ERR_PTR(-ENOMEM);
+	}
+
+	for_each_possible_cpu(cpu) {
+		bq = per_cpu_ptr(dev->bulkq, cpu);
+		bq->obj = dev;
+	}
+
+	dev->dev = dev_get_by_index(net, ifindex);
+	if (!dev->dev) {
+		free_percpu(dev->bulkq);
+		kfree(dev);
+		return ERR_PTR(-EINVAL);
+	}
+
+	dev->idx = idx;
+	dev->dtab = dtab;
+
+	return dev;
+}
+
+static int __dev_map_update_elem(struct net *net, struct bpf_map *map,
+				 void *key, void *value, u64 map_flags)
+{
+	struct bpf_dtab *dtab = container_of(map, struct bpf_dtab, map);
 	struct bpf_dtab_netdev *dev, *old_dev;
 	u32 ifindex = *(u32 *)value;
-	struct xdp_bulk_queue *bq;
 	u32 i = *(u32 *)key;
-	int cpu;
 
 	if (unlikely(map_flags > BPF_EXIST))
 		return -EINVAL;
@@ -434,31 +480,9 @@ static int dev_map_update_elem(struct bpf_map *map, void *key, void *value,
 	if (!ifindex) {
 		dev = NULL;
 	} else {
-		dev = kmalloc_node(sizeof(*dev), gfp, map->numa_node);
-		if (!dev)
-			return -ENOMEM;
-
-		dev->bulkq = __alloc_percpu_gfp(sizeof(*dev->bulkq),
-						sizeof(void *), gfp);
-		if (!dev->bulkq) {
-			kfree(dev);
-			return -ENOMEM;
-		}
-
-		for_each_possible_cpu(cpu) {
-			bq = per_cpu_ptr(dev->bulkq, cpu);
-			bq->obj = dev;
-		}
-
-		dev->dev = dev_get_by_index(net, ifindex);
-		if (!dev->dev) {
-			free_percpu(dev->bulkq);
-			kfree(dev);
-			return -EINVAL;
-		}
-
-		dev->bit = i;
-		dev->dtab = dtab;
+		dev = __dev_map_alloc_node(net, dtab, ifindex, i);
+		if (IS_ERR(dev))
+			return PTR_ERR(dev);
 	}
 
 	/* Use call_rcu() here to ensure rcu critical sections have completed
@@ -472,6 +496,13 @@ static int dev_map_update_elem(struct bpf_map *map, void *key, void *value,
 	return 0;
 }
 
+static int dev_map_update_elem(struct bpf_map *map, void *key, void *value,
+			       u64 map_flags)
+{
+	return __dev_map_update_elem(current->nsproxy->net_ns,
+				     map, key, value, map_flags);
+}
+
 const struct bpf_map_ops dev_map_ops = {
 	.map_alloc = dev_map_alloc,
 	.map_free = dev_map_free,

