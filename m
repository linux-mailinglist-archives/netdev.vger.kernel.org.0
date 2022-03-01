Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 37EAF4C85B5
	for <lists+netdev@lfdr.de>; Tue,  1 Mar 2022 08:59:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232487AbiCAIAA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Mar 2022 03:00:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49628 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233172AbiCAH74 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Mar 2022 02:59:56 -0500
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7420D80222;
        Mon, 28 Feb 2022 23:59:14 -0800 (PST)
Received: by mail-pj1-x102e.google.com with SMTP id ev16-20020a17090aead000b001bc3835fea8so1547244pjb.0;
        Mon, 28 Feb 2022 23:59:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=DH7q20NUg2fMsVec64lFAIumDGct4fZ105Sw3WAxbUA=;
        b=HLRBF069/um4dwnSHVDbI8dMFG7O4YOwO13iD6T3NtC46gVCf+cqdA32nJr444gw/e
         ZGXMD/+Sq19GBj7ri2stQfg2YRHBVyL1h3wjdYyUNAQFRvV/NO/yhTObYAjYR6yB4O1P
         R2gnrnnWh7bFxCGgXzrazITF3jtmnFfFzcl8cTwldg9M0evnPLez8C4LIY0MzmQU5Gr6
         WWooK8bKBefjGTEctbNTWyvit1VOWagfNoh+RIOqOTt7wVNiBBvqpSh0+CtHAwc2RXTL
         eiYUzqx5xKpj02Dnqcwx6p2YICPj+SXQrmhNW655CZVzyEClYIKvi+T8zCIx067+f19l
         ALgw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=DH7q20NUg2fMsVec64lFAIumDGct4fZ105Sw3WAxbUA=;
        b=5Pkw/d/qZhQba4OJro+F5IT5ZOnl1A5gWq3zMzDnr+Yp0mKQ2gvalj912bvKPqQJ4C
         ycL9Pgb+b7h6XxHVP79cAqkp7g5Vqh4o9bUJcxPwngNkh32QIdxfLrMN9W789h4x18zT
         ua7x5kmxl2/QLUNIwcHUlqvnbQ4zEb9exfDQ+caIundXC7lbXh6Sorcz0B+BJYHYDu+u
         QZtOo6o4vJ+e6T9cuUvq2VcVRKarToIvep6ap3xTvOxSLuh9yEa/4HBVAlM67dB17cyl
         Ocxcmi8CsIuR3X2xc0sXbdKI9clQFk1udTX+y9hWnQUTCKyqxdyBoRX3I5/Bfeii/oUI
         pvMg==
X-Gm-Message-State: AOAM533at2Taa5KzFzW4Q454H2w26qgaKNs8W/yBSocmyMxOQx9XqI94
        nNZZ4vzEm2Ogg3tQSGjB1ak=
X-Google-Smtp-Source: ABdhPJzfIGUgp26nNkeuQ+F6tXH5OU7cPOWBmYg0OuNdWuCuc04wHa/W/eDEP40nsuuNMSdEw+IExA==
X-Received: by 2002:a17:90a:788f:b0:1bd:59c5:748e with SMTP id x15-20020a17090a788f00b001bd59c5748emr7588034pjk.158.1646121554019;
        Mon, 28 Feb 2022 23:59:14 -0800 (PST)
Received: from ubuntu.huawei.com ([119.3.119.18])
        by smtp.googlemail.com with ESMTPSA id o12-20020a17090aac0c00b001b9e5286c90sm1662745pjq.0.2022.02.28.23.59.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Feb 2022 23:59:13 -0800 (PST)
From:   Xiaomeng Tong <xiam0nd.tong@gmail.com>
To:     torvalds@linux-foundation.org
Cc:     arnd@arndb.de, jakobkoschel@gmail.com,
        linux-kernel@vger.kernel.org, gregkh@linuxfoundation.org,
        keescook@chromium.org, jannh@google.com,
        linux-kbuild@vger.kernel.org, linux-mm@kvack.org,
        netdev@vger.kernel.org, Xiaomeng Tong <xiam0nd.tong@gmail.com>
Subject: [PATCH 4/6] mm: remove iterator use outside the loop
Date:   Tue,  1 Mar 2022 15:58:37 +0800
Message-Id: <20220301075839.4156-5-xiam0nd.tong@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20220301075839.4156-1-xiam0nd.tong@gmail.com>
References: <20220301075839.4156-1-xiam0nd.tong@gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Demonstrations for:
 - list_for_each_entry_inside
 - list_for_each_entry_reverse_inside
 - list_for_each_entry_safe_inside
 - list_for_each_entry_from_inside
 - list_for_each_entry_continue_reverse_inside

Signed-off-by: Xiaomeng Tong <xiam0nd.tong@gmail.com>
---
 mm/list_lru.c    | 10 ++++++----
 mm/slab_common.c |  7 ++-----
 mm/vmalloc.c     |  6 +++---
 3 files changed, 11 insertions(+), 12 deletions(-)

diff --git a/mm/list_lru.c b/mm/list_lru.c
index 0cd5e89ca..d8aab53a7 100644
--- a/mm/list_lru.c
+++ b/mm/list_lru.c
@@ -493,20 +493,22 @@ static void memcg_cancel_update_list_lru(struct list_lru *lru,
 int memcg_update_all_list_lrus(int new_size)
 {
 	int ret = 0;
-	struct list_lru *lru;
+	struct list_lru *ll = NULL;
 	int old_size = memcg_nr_cache_ids;
 
 	mutex_lock(&list_lrus_mutex);
-	list_for_each_entry(lru, &memcg_list_lrus, list) {
+	list_for_each_entry_inside(lru, struct list_lru, &memcg_list_lrus, list) {
 		ret = memcg_update_list_lru(lru, old_size, new_size);
-		if (ret)
+		if (ret) {
+			ll = lru;
 			goto fail;
+		}
 	}
 out:
 	mutex_unlock(&list_lrus_mutex);
 	return ret;
 fail:
-	list_for_each_entry_continue_reverse(lru, &memcg_list_lrus, list)
+	list_for_each_entry_continue_reverse_inside(lru, ll, &memcg_list_lrus, list)
 		memcg_cancel_update_list_lru(lru, old_size, new_size);
 	goto out;
 }
diff --git a/mm/slab_common.c b/mm/slab_common.c
index 23f2ab071..68a25d385 100644
--- a/mm/slab_common.c
+++ b/mm/slab_common.c
@@ -186,8 +186,6 @@ int slab_unmergeable(struct kmem_cache *s)
 struct kmem_cache *find_mergeable(unsigned int size, unsigned int align,
 		slab_flags_t flags, const char *name, void (*ctor)(void *))
 {
-	struct kmem_cache *s;
-
 	if (slab_nomerge)
 		return NULL;
 
@@ -202,7 +200,7 @@ struct kmem_cache *find_mergeable(unsigned int size, unsigned int align,
 	if (flags & SLAB_NEVER_MERGE)
 		return NULL;
 
-	list_for_each_entry_reverse(s, &slab_caches, list) {
+	list_for_each_entry_reverse_inside(s, struct kmem_cache, &slab_caches, list) {
 		if (slab_unmergeable(s))
 			continue;
 
@@ -419,7 +417,6 @@ EXPORT_SYMBOL(kmem_cache_create);
 static void slab_caches_to_rcu_destroy_workfn(struct work_struct *work)
 {
 	LIST_HEAD(to_destroy);
-	struct kmem_cache *s, *s2;
 
 	/*
 	 * On destruction, SLAB_TYPESAFE_BY_RCU kmem_caches are put on the
@@ -439,7 +436,7 @@ static void slab_caches_to_rcu_destroy_workfn(struct work_struct *work)
 
 	rcu_barrier();
 
-	list_for_each_entry_safe(s, s2, &to_destroy, list) {
+	list_for_each_entry_safe_inside(s, s2, struct kmem_cache, &to_destroy, list) {
 		debugfs_slab_release(s);
 		kfence_shutdown_cache(s);
 #ifdef SLAB_SUPPORTS_SYSFS
diff --git a/mm/vmalloc.c b/mm/vmalloc.c
index 4165304d3..65a9f1db7 100644
--- a/mm/vmalloc.c
+++ b/mm/vmalloc.c
@@ -3417,14 +3417,14 @@ long vread(char *buf, char *addr, unsigned long count)
 	if ((unsigned long)addr + count <= va->va_start)
 		goto finished;
 
-	list_for_each_entry_from(va, &vmap_area_list, list) {
+	list_for_each_entry_from_inside(iter, va, &vmap_area_list, list) {
 		if (!count)
 			break;
 
-		if (!va->vm)
+		if (!iter->vm)
 			continue;
 
-		vm = va->vm;
+		vm = iter->vm;
 		vaddr = (char *) vm->addr;
 		if (addr >= vaddr + get_vm_area_size(vm))
 			continue;
-- 
2.17.1

