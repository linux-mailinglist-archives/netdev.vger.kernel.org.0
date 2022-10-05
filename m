Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 78EDE5F58FD
	for <lists+netdev@lfdr.de>; Wed,  5 Oct 2022 19:18:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230286AbiJERSU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Oct 2022 13:18:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58464 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229681AbiJERSQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Oct 2022 13:18:16 -0400
Received: from mail-qk1-x734.google.com (mail-qk1-x734.google.com [IPv6:2607:f8b0:4864:20::734])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF8B943E66;
        Wed,  5 Oct 2022 10:18:11 -0700 (PDT)
Received: by mail-qk1-x734.google.com with SMTP id 27so2563586qkc.8;
        Wed, 05 Oct 2022 10:18:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date;
        bh=fTW6wSX6OhM/JpjmLL4Y+GywGzcuwm93dYTCYEcWEt0=;
        b=dazamK/d1Rz/XDe8b+uqeGyq+PsLmJejIFx2ZHkg+/DFhJqYUx69ShGqr8vBXpIYAD
         bHcaziiD+K0L2Uh6MMvEUb4iW42dxI2LZOvzR2Bmp5Gbi899gSRfQG1HZoxrvNFGOG00
         bSk+geavYTw5nGVgytasxPfQFk+ZdpN0zwsZD4BeRa5lfBtNgXuq7p/ItkufX1jLgUhq
         AKSMsasFvxu6U292y0C5erxAdkMpJhACDSDOLCgaO++jnxIIjjQ564rqZEtmVlCCZY4e
         ItnSbxmXKytsiBbQjccLEA6jhEEvtLaAD2k4bPvx5aaMQIrZzxA6orGP9Dsk5ML7AscW
         i/4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date;
        bh=fTW6wSX6OhM/JpjmLL4Y+GywGzcuwm93dYTCYEcWEt0=;
        b=Uu3flDFmY9/grhC3EHeRDK3sXJaJNvqew8ypcif9qPC9jBIZBiAjrnHl2XdKN/10U9
         4RgJ+7xSGTD4mx/Ai7F8rOnEwimUAbeOEIzgP5TiVkLQBxnIT77lApI3O9wELNkLdHgO
         BEnnrWbl93eXguT968W9af2dBEYDUrnirIRPqNxKjTwq1SPymguHo0XSXgIydw3pbWWQ
         qjChBpy3ZXe/xqFiRcc3odBY9RE4m0P4QBArsdQTmFEt0I8WArY3p8FcEysImF6ENnkU
         ODJda3JNiRHUw/Xckyz4TfX5zBEIVPxg8sfiirB9uiJwsgCT4IHgULg0EXAHsTot/heM
         hP1w==
X-Gm-Message-State: ACrzQf2M+IxPkLbaWztLQhqgcKR8KQoHaDpbHT2libOmJ+uUnMunEUaX
        tYFHaEt82vCKFeil1dGweCNGUl4Tn4Q=
X-Google-Smtp-Source: AMsMyM7HKTOsoiHBEziUUpIs5OyGTkLPwbon+B6vCAQel56A3rjqzKBJvldoHMILKp9aops2eNuQSw==
X-Received: by 2002:ac8:5992:0:b0:35c:c83a:740f with SMTP id e18-20020ac85992000000b0035cc83a740fmr471153qte.503.1664990263131;
        Wed, 05 Oct 2022 10:17:43 -0700 (PDT)
Received: from pop-os.attlocal.net ([2600:1700:65a0:ab60:2bd1:c1af:4b3b:4384])
        by smtp.gmail.com with ESMTPSA id m13-20020ac85b0d000000b003913996dce3sm1764552qtw.6.2022.10.05.10.17.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 Oct 2022 10:17:42 -0700 (PDT)
From:   Cong Wang <xiyou.wangcong@gmail.com>
To:     netdev@vger.kernel.org
Cc:     yangpeihao@sjtu.edu.cn, toke@redhat.com, jhs@mojatatu.com,
        jiri@resnulli.us, bpf@vger.kernel.org, sdf@google.com,
        Cong Wang <cong.wang@bytedance.com>
Subject: [RFC Patch v6 2/5] bpf: Add map in map support to rbtree
Date:   Wed,  5 Oct 2022 10:17:06 -0700
Message-Id: <20221005171709.150520-3-xiyou.wangcong@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221005171709.150520-1-xiyou.wangcong@gmail.com>
References: <20221005171709.150520-1-xiyou.wangcong@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Cong Wang <cong.wang@bytedance.com>

Signed-off-by: Cong Wang <cong.wang@bytedance.com>
---
 include/linux/bpf.h       |   4 +
 include/linux/bpf_types.h |   1 +
 include/uapi/linux/bpf.h  |   1 +
 kernel/bpf/rbtree.c       | 158 ++++++++++++++++++++++++++++++++++++++
 kernel/bpf/syscall.c      |   7 ++
 5 files changed, 171 insertions(+)

diff --git a/include/linux/bpf.h b/include/linux/bpf.h
index 9e7d46d16032..d4d85df1e8ea 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -1913,6 +1913,10 @@ int bpf_fd_array_map_lookup_elem(struct bpf_map *map, void *key, u32 *value);
 int bpf_fd_htab_map_update_elem(struct bpf_map *map, struct file *map_file,
 				void *key, void *value, u64 map_flags);
 int bpf_fd_htab_map_lookup_elem(struct bpf_map *map, void *key, u32 *value);
+int bpf_fd_rbtree_map_update_elem(struct bpf_map *map, struct file *map_file,
+				  void *key, void *value, u64 map_flags);
+int bpf_fd_rbtree_map_lookup_elem(struct bpf_map *map, void *key, u32 *value);
+int bpf_fd_rbtree_map_pop_elem(struct bpf_map *map, void *value);
 
 int bpf_get_file_flag(int flags);
 int bpf_check_uarg_tail_zero(bpfptr_t uaddr, size_t expected_size,
diff --git a/include/linux/bpf_types.h b/include/linux/bpf_types.h
index c53ba6de1613..d1ef13b08e28 100644
--- a/include/linux/bpf_types.h
+++ b/include/linux/bpf_types.h
@@ -128,6 +128,7 @@ BPF_MAP_TYPE(BPF_MAP_TYPE_RINGBUF, ringbuf_map_ops)
 BPF_MAP_TYPE(BPF_MAP_TYPE_BLOOM_FILTER, bloom_filter_map_ops)
 BPF_MAP_TYPE(BPF_MAP_TYPE_USER_RINGBUF, user_ringbuf_map_ops)
 BPF_MAP_TYPE(BPF_MAP_TYPE_RBTREE, rbtree_map_ops)
+BPF_MAP_TYPE(BPF_MAP_TYPE_RBTREE_OF_MAPS, rbtree_map_in_map_ops)
 
 BPF_LINK_TYPE(BPF_LINK_TYPE_RAW_TRACEPOINT, raw_tracepoint)
 BPF_LINK_TYPE(BPF_LINK_TYPE_TRACING, tracing)
diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
index 9492cd3af701..994a3e42a4fa 100644
--- a/include/uapi/linux/bpf.h
+++ b/include/uapi/linux/bpf.h
@@ -936,6 +936,7 @@ enum bpf_map_type {
 	BPF_MAP_TYPE_BLOOM_FILTER,
 	BPF_MAP_TYPE_USER_RINGBUF,
 	BPF_MAP_TYPE_RBTREE,
+	BPF_MAP_TYPE_RBTREE_OF_MAPS,
 };
 
 /* Note that tracing related programs such as
diff --git a/kernel/bpf/rbtree.c b/kernel/bpf/rbtree.c
index f1a9b1c40b8b..43d3d4193ce4 100644
--- a/kernel/bpf/rbtree.c
+++ b/kernel/bpf/rbtree.c
@@ -12,6 +12,7 @@
 #include <linux/bpf_mem_alloc.h>
 #include <linux/math.h>
 #include <linux/seq_file.h>
+#include "map_in_map.h"
 
 #define RBTREE_CREATE_FLAG_MASK \
 	(BPF_F_NUMA_NODE | BPF_F_ACCESS_MASK)
@@ -443,3 +444,160 @@ const struct bpf_map_ops rbtree_map_ops = {
 	.iter_seq_info = &rbtree_map_iter_seq_info,
 };
 
+static struct bpf_map *rbtree_map_in_map_alloc(union bpf_attr *attr)
+{
+	struct bpf_map *map, *inner_map_meta;
+
+	inner_map_meta = bpf_map_meta_alloc(attr->inner_map_fd);
+	if (IS_ERR(inner_map_meta))
+		return inner_map_meta;
+
+	map = rbtree_map_alloc(attr);
+	if (IS_ERR(map)) {
+		bpf_map_meta_free(inner_map_meta);
+		return map;
+	}
+
+	map->inner_map_meta = inner_map_meta;
+	return map;
+}
+
+static void *fd_rbtree_map_get_ptr(const struct bpf_map *map, struct rbtree_elem *e)
+{
+	return *(void **)(e->key + roundup(map->key_size, 8));
+}
+
+static void rbtree_map_in_map_purge(struct bpf_map *map)
+{
+	struct rbtree_map *rb = rbtree_map(map);
+	struct rbtree_elem *e, *tmp;
+
+	rbtree_walk_safe(e, tmp, &rb->root) {
+		void *ptr = fd_rbtree_map_get_ptr(map, e);
+
+		map->ops->map_fd_put_ptr(ptr);
+	}
+}
+
+static void rbtree_map_in_map_free(struct bpf_map *map)
+{
+	struct rbtree_map *rb = rbtree_map(map);
+
+	bpf_map_meta_free(map->inner_map_meta);
+	rbtree_map_in_map_purge(map);
+	bpf_map_area_free(rb);
+}
+
+/* Called from eBPF program */
+static void *rbtree_map_in_map_lookup_elem(struct bpf_map *map, void *key)
+{
+	struct bpf_map **inner_map = rbtree_map_lookup_elem(map, key);
+
+	if (!inner_map)
+		return NULL;
+
+	return READ_ONCE(*inner_map);
+}
+
+static int rbtree_map_in_map_alloc_check(union bpf_attr *attr)
+{
+	if (attr->value_size != sizeof(u32))
+		return -EINVAL;
+	return rbtree_map_alloc_check(attr);
+}
+
+/* Called from eBPF program */
+static int rbtree_map_in_map_pop_elem(struct bpf_map *map, void *value)
+{
+	struct rbtree_map *rb = rbtree_map(map);
+	struct rbtree_elem *e = elem_rb_first(&rb->root);
+	struct bpf_map **inner_map;
+	unsigned long flags;
+
+	if (!e)
+		return -ENOENT;
+	raw_spin_lock_irqsave(&rb->lock, flags);
+	rb_erase(&e->rbnode, &rb->root);
+	raw_spin_unlock_irqrestore(&rb->lock, flags);
+	inner_map = fd_rbtree_map_get_ptr(map, e);
+	*(void **)value = *inner_map;
+	bpf_mem_cache_free(&rb->ma, e);
+	atomic_dec(&rb->nr_entries);
+	return 0;
+}
+
+/* only called from syscall */
+int bpf_fd_rbtree_map_pop_elem(struct bpf_map *map, void *value)
+{
+	struct bpf_map *ptr;
+	int ret = 0;
+
+	if (!map->ops->map_fd_sys_lookup_elem)
+		return -ENOTSUPP;
+
+	rcu_read_lock();
+	ret = rbtree_map_in_map_pop_elem(map, &ptr);
+	if (!ret)
+		*(u32 *)value = map->ops->map_fd_sys_lookup_elem(ptr);
+	else
+		ret = -ENOENT;
+	rcu_read_unlock();
+
+	return ret;
+}
+
+/* only called from syscall */
+int bpf_fd_rbtree_map_lookup_elem(struct bpf_map *map, void *key, u32 *value)
+{
+	void **ptr;
+	int ret = 0;
+
+	if (!map->ops->map_fd_sys_lookup_elem)
+		return -ENOTSUPP;
+
+	rcu_read_lock();
+	ptr = rbtree_map_lookup_elem(map, key);
+	if (ptr)
+		*value = map->ops->map_fd_sys_lookup_elem(READ_ONCE(*ptr));
+	else
+		ret = -ENOENT;
+	rcu_read_unlock();
+
+	return ret;
+}
+
+/* only called from syscall */
+int bpf_fd_rbtree_map_update_elem(struct bpf_map *map, struct file *map_file,
+				  void *key, void *value, u64 map_flags)
+{
+	void *ptr;
+	int ret;
+	u32 ufd = *(u32 *)value;
+
+	ptr = map->ops->map_fd_get_ptr(map, map_file, ufd);
+	if (IS_ERR(ptr))
+		return PTR_ERR(ptr);
+
+	ret = rbtree_map_update_elem(map, key, &ptr, map_flags);
+	if (ret)
+		map->ops->map_fd_put_ptr(ptr);
+
+	return ret;
+}
+
+const struct bpf_map_ops rbtree_map_in_map_ops = {
+	.map_alloc_check = rbtree_map_in_map_alloc_check,
+	.map_alloc = rbtree_map_in_map_alloc,
+	.map_free = rbtree_map_in_map_free,
+	.map_get_next_key = rbtree_map_get_next_key,
+	.map_lookup_elem = rbtree_map_in_map_lookup_elem,
+	.map_update_elem = rbtree_map_update_elem,
+	.map_pop_elem = rbtree_map_in_map_pop_elem,
+	.map_delete_elem = rbtree_map_delete_elem,
+	.map_fd_get_ptr = bpf_map_fd_get_ptr,
+	.map_fd_put_ptr = bpf_map_fd_put_ptr,
+	.map_fd_sys_lookup_elem = bpf_map_fd_sys_lookup_elem,
+	.map_check_btf = map_check_no_btf,
+	.map_btf_id = &rbtree_map_btf_ids[0],
+};
+
diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
index 7b373a5e861f..1b968dc38500 100644
--- a/kernel/bpf/syscall.c
+++ b/kernel/bpf/syscall.c
@@ -213,6 +213,11 @@ static int bpf_map_update_value(struct bpf_map *map, struct fd f, void *key,
 		err = bpf_fd_htab_map_update_elem(map, f.file, key, value,
 						  flags);
 		rcu_read_unlock();
+	} else if (map->map_type == BPF_MAP_TYPE_RBTREE_OF_MAPS) {
+		rcu_read_lock();
+		err = bpf_fd_rbtree_map_update_elem(map, f.file, key, value,
+						    flags);
+		rcu_read_unlock();
 	} else if (map->map_type == BPF_MAP_TYPE_REUSEPORT_SOCKARRAY) {
 		/* rcu_read_lock() is not needed */
 		err = bpf_fd_reuseport_array_update_elem(map, key, value,
@@ -1832,6 +1837,8 @@ static int map_lookup_and_delete_elem(union bpf_attr *attr)
 	if (map->map_type == BPF_MAP_TYPE_QUEUE ||
 	    map->map_type == BPF_MAP_TYPE_STACK) {
 		err = map->ops->map_pop_elem(map, value);
+	} else if (map->map_type == BPF_MAP_TYPE_RBTREE_OF_MAPS) {
+		bpf_fd_rbtree_map_pop_elem(map, value);
 	} else if (map->map_type == BPF_MAP_TYPE_HASH ||
 		   map->map_type == BPF_MAP_TYPE_PERCPU_HASH ||
 		   map->map_type == BPF_MAP_TYPE_LRU_HASH ||
-- 
2.34.1

