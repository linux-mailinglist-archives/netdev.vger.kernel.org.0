Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B9BE932778F
	for <lists+netdev@lfdr.de>; Mon,  1 Mar 2021 07:28:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231899AbhCAG0z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Mar 2021 01:26:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48234 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231933AbhCAGZx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Mar 2021 01:25:53 -0500
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 55595C061793
        for <netdev@vger.kernel.org>; Sun, 28 Feb 2021 22:24:47 -0800 (PST)
Received: by mail-pj1-x102f.google.com with SMTP id u12so10803141pjr.2
        for <netdev@vger.kernel.org>; Sun, 28 Feb 2021 22:24:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=o7QhLv5gQurpL6BkSCLndHABMXsANOfSdd3xoUJITvQ=;
        b=Yar2qzoSxku0EoB9WmsR/XSu1T9sO9Fx49sg1/60AwPq3qbgiP/Y8Ck4ZCrh4R6OXA
         KoZDdJzIOuO7ltFFb5kUO55IP9PwiOYtJ+QNaGTS1h7GkKdxO+01SNIzhVbNvIi/8loz
         sinz/+KSOoHEo03bdgot6IzvHDT///+t45el89jQmqGASFqmWSAo6netSHf9+g3SDwWY
         xHx4D99m4+YRf6zSAEYFB5A9ay2HO7ONkgea70W3E5xLJkikMgIJgq4cSS80xRGJvPh/
         yOFpm7UI9g2P2XOF49h4yRPoNYA7oLRwBKLB+mCzEuDssMTYf8H1xy38Duov3x/OhCEJ
         iodg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=o7QhLv5gQurpL6BkSCLndHABMXsANOfSdd3xoUJITvQ=;
        b=IzAvYFzwY+7IQhUqB4Mo5l2E8qBQMpZPl+L8JiLHinroi5Rn1kPTk+PrHTcaRcj+MR
         PuuB2juGBy/sRH7pro3ItqjGMMmDLy0ID454OvLD2N5HGJ7J72j+9WnZOnmjvTxt3lXw
         quuQS0w8eGEEDIB4YqRGla3L5p3wdukBzOE1pnBlQe02HNG8rT39XJi90YbyuUTLxPoM
         Fkjkz4HEQJ1/jBrjZ+UCAw9Ctb/f4EdYNJQIJ4P0BTSuYn4UX020BST44DKF6iZrFDSU
         8rCAy/ZhnUVhbA3QPMZFWgS5WhI5ZABiuTepKcMlIogIN5soPtrSBCIVLEr0TiKnFSbD
         42GA==
X-Gm-Message-State: AOAM533Lo0TRaZEJLYB+8RiXNix/VbF+1VlkGMRJKGLJw1c90ehD2AvH
        7nVBnxrfgK8dWYtM6iWwvD25cg==
X-Google-Smtp-Source: ABdhPJwG2x6S0WoOhSbLApU+6gZ68jAo9FncXvx14C+W9F4m8AqCqBOXVN9iwo2ZJyMz0HrV1Ek8wQ==
X-Received: by 2002:a17:90a:8c84:: with SMTP id b4mr15827997pjo.21.1614579886895;
        Sun, 28 Feb 2021 22:24:46 -0800 (PST)
Received: from localhost.localdomain ([139.177.225.227])
        by smtp.gmail.com with ESMTPSA id x6sm14304626pfd.12.2021.02.28.22.24.28
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 28 Feb 2021 22:24:46 -0800 (PST)
From:   Muchun Song <songmuchun@bytedance.com>
To:     viro@zeniv.linux.org.uk, jack@suse.cz, amir73il@gmail.com,
        ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org, mingo@redhat.com,
        peterz@infradead.org, juri.lelli@redhat.com,
        vincent.guittot@linaro.org, dietmar.eggemann@arm.com,
        rostedt@goodmis.org, bsegall@google.com, mgorman@suse.de,
        bristot@redhat.com, hannes@cmpxchg.org, mhocko@kernel.org,
        vdavydov.dev@gmail.com, akpm@linux-foundation.org,
        shakeelb@google.com, guro@fb.com, songmuchun@bytedance.com,
        alex.shi@linux.alibaba.com, alexander.h.duyck@linux.intel.com,
        chris@chrisdown.name, richard.weiyang@gmail.com, vbabka@suse.cz,
        mathieu.desnoyers@efficios.com, posk@google.com, jannh@google.com,
        iamjoonsoo.kim@lge.com, daniel.vetter@ffwll.ch, longman@redhat.com,
        walken@google.com, christian.brauner@ubuntu.com,
        ebiederm@xmission.com, keescook@chromium.org,
        krisman@collabora.com, esyr@redhat.com, surenb@google.com,
        elver@google.com
Cc:     linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        cgroups@vger.kernel.org, linux-mm@kvack.org,
        duanxiongchun@bytedance.com
Subject: [PATCH 1/5] mm: memcontrol: introduce obj_cgroup_{un}charge_page
Date:   Mon,  1 Mar 2021 14:22:23 +0800
Message-Id: <20210301062227.59292-2-songmuchun@bytedance.com>
X-Mailer: git-send-email 2.21.0 (Apple Git-122)
In-Reply-To: <20210301062227.59292-1-songmuchun@bytedance.com>
References: <20210301062227.59292-1-songmuchun@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We know that the unit of charging slab object is bytes, the unit of
charging kmem page is PAGE_SIZE. So If we want to reuse obj_cgroup
APIs to charge the kmem pages, we should pass PAGE_SIZE (as third
parameter) to obj_cgroup_charge(). Because the charing size is page
size, we always need to refill objcg stock. This is pointless. As we
already know the charing size. So we can directly skip touch the
objcg stock and introduce obj_cgroup_{un}charge_page() to charge or
uncharge a kmem page.

In the later patch, we can reuse those helpers to charge/uncharge
the kmem pages. This is just code movement without any functional
change.

Signed-off-by: Muchun Song <songmuchun@bytedance.com>
---
 mm/memcontrol.c | 46 +++++++++++++++++++++++++++++++---------------
 1 file changed, 31 insertions(+), 15 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 2db2aeac8a9e..2eafbae504ac 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -3060,6 +3060,34 @@ static void memcg_free_cache_id(int id)
 	ida_simple_remove(&memcg_cache_ida, id);
 }
 
+static inline void obj_cgroup_uncharge_page(struct obj_cgroup *objcg,
+					    unsigned int nr_pages)
+{
+	rcu_read_lock();
+	__memcg_kmem_uncharge(obj_cgroup_memcg(objcg), nr_pages);
+	rcu_read_unlock();
+}
+
+static int obj_cgroup_charge_page(struct obj_cgroup *objcg, gfp_t gfp,
+				  unsigned int nr_pages)
+{
+	struct mem_cgroup *memcg;
+	int ret;
+
+	rcu_read_lock();
+retry:
+	memcg = obj_cgroup_memcg(objcg);
+	if (unlikely(!css_tryget(&memcg->css)))
+		goto retry;
+	rcu_read_unlock();
+
+	ret = __memcg_kmem_charge(memcg, gfp, nr_pages);
+
+	css_put(&memcg->css);
+
+	return ret;
+}
+
 /**
  * __memcg_kmem_charge: charge a number of kernel pages to a memcg
  * @memcg: memory cgroup to charge
@@ -3184,11 +3212,8 @@ static void drain_obj_stock(struct memcg_stock_pcp *stock)
 		unsigned int nr_pages = stock->nr_bytes >> PAGE_SHIFT;
 		unsigned int nr_bytes = stock->nr_bytes & (PAGE_SIZE - 1);
 
-		if (nr_pages) {
-			rcu_read_lock();
-			__memcg_kmem_uncharge(obj_cgroup_memcg(old), nr_pages);
-			rcu_read_unlock();
-		}
+		if (nr_pages)
+			obj_cgroup_uncharge_page(old, nr_pages);
 
 		/*
 		 * The leftover is flushed to the centralized per-memcg value.
@@ -3246,7 +3271,6 @@ static void refill_obj_stock(struct obj_cgroup *objcg, unsigned int nr_bytes)
 
 int obj_cgroup_charge(struct obj_cgroup *objcg, gfp_t gfp, size_t size)
 {
-	struct mem_cgroup *memcg;
 	unsigned int nr_pages, nr_bytes;
 	int ret;
 
@@ -3263,24 +3287,16 @@ int obj_cgroup_charge(struct obj_cgroup *objcg, gfp_t gfp, size_t size)
 	 * refill_obj_stock(), called from this function or
 	 * independently later.
 	 */
-	rcu_read_lock();
-retry:
-	memcg = obj_cgroup_memcg(objcg);
-	if (unlikely(!css_tryget(&memcg->css)))
-		goto retry;
-	rcu_read_unlock();
-
 	nr_pages = size >> PAGE_SHIFT;
 	nr_bytes = size & (PAGE_SIZE - 1);
 
 	if (nr_bytes)
 		nr_pages += 1;
 
-	ret = __memcg_kmem_charge(memcg, gfp, nr_pages);
+	ret = obj_cgroup_charge_page(objcg, gfp, nr_pages);
 	if (!ret && nr_bytes)
 		refill_obj_stock(objcg, PAGE_SIZE - nr_bytes);
 
-	css_put(&memcg->css);
 	return ret;
 }
 
-- 
2.11.0

