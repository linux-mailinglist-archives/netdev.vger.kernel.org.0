Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DAA1F3EEF58
	for <lists+netdev@lfdr.de>; Tue, 17 Aug 2021 17:46:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237423AbhHQPqd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Aug 2021 11:46:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45540 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231893AbhHQPqc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Aug 2021 11:46:32 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 67280C0613C1
        for <netdev@vger.kernel.org>; Tue, 17 Aug 2021 08:45:59 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id e75-20020a25374e000000b00597165a06d2so1065919yba.6
        for <netdev@vger.kernel.org>; Tue, 17 Aug 2021 08:45:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=BfhAh8rwBz608rvr8spcyMFyyewDU7pH/HrVKwG96Tk=;
        b=WXR3freRDToAp2xl4SDlN3yMdKCjUbEh05+DmAfMKENt527cAuH+l3btY/z5Bn73SS
         ldMfJ0Tycf9UoIbEbxLYSZyskgEVbhR1UUtrYuFStiBtfY0Y7zj63voOtao4rEQfl/EA
         7RwCzZf1S9lPQWFV6hZEdJ2FyqWf7CtA1v0yuWaqji8eyBKI+DlanGexREVxFOdujpVa
         uC+dDYemqb/3FDg9/wRAYzPPW2wLc/lvsyEa0bP1izBuFvFrsjCvwaLXASu4YKxSSkNY
         fyyDJgKkDIMrynCbwtrLMMMyMmQuos0jopxvFlz5eZYJc9hDdHVtndE5Okf4u8kxnB9l
         1KKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=BfhAh8rwBz608rvr8spcyMFyyewDU7pH/HrVKwG96Tk=;
        b=qG6HARwo/hki2E5KB0t8q3TaJCxkhjBsR2y2x1TIzrogw4MRzTdg/NdJv2M0Tuucfh
         mrVypAK+S3p/CRBBqkSGHWF5UCeV6iU1SmYKu4wXlwqNBALuApjLVTgUEg5d2Muenl61
         LF7sj+OYXKGsclLxQKwxwdFSqg3yWRKKO39dB0aNcWIpSYxDaPOQ49ERmUByyouscMDO
         Mp2P6+l4j9fdxj51bvbz1kaTeBfu2Qx0d6j6gfspLS02JW9KnsWC0NiyoIJo+xx51d88
         97spNQdrhXh4Phc7qRGO+Vl25/xejJU2tNuWZk0eMptdYQmVftEZCNV5oFqs39Rc7tAI
         yQMQ==
X-Gm-Message-State: AOAM530wvOD024PJWVGchXsM9YxeyqRJU22nOSg+hwWtNG0xql+tt64K
        JEaIUKAG2OZ2YiAQeX7EAfTSgooWtI9dRqlYHwJrHN9lUrku6QyRA1pBMU/jtb9rOEz/f8Jseqr
        uUwQJQ/koGyo25aPEJLq3TuDG+y5hkR/1Wgw4A5DcDwhS4C/D7bmKug==
X-Google-Smtp-Source: ABdhPJx8Q8iWeacjC/ya0q+3BeFDPPi/z3ckCkUuM9BSZQOrzxR8k32JGqQZoTpIM6zGLeaZfniQums=
X-Received: from sdf2.svl.corp.google.com ([2620:15c:2c4:201:e3f2:64ab:dda:c30f])
 (user=sdf job=sendgmr) by 2002:a25:b18e:: with SMTP id h14mr5290749ybj.441.1629215158605;
 Tue, 17 Aug 2021 08:45:58 -0700 (PDT)
Date:   Tue, 17 Aug 2021 08:45:55 -0700
Message-Id: <20210817154556.92901-1-sdf@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.33.0.rc1.237.g0d66db33f3-goog
Subject: [PATCH bpf-next v2 1/2] bpf: use kvmalloc for map values in syscall
From:   Stanislav Fomichev <sdf@google.com>
To:     netdev@vger.kernel.org, bpf@vger.kernel.org
Cc:     ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        Stanislav Fomichev <sdf@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use kvmalloc/kvfree for temporary value when manipulating a map via
syscall. kmalloc might not be sufficient for percpu maps where the value
is big (and further multiplied by hundreds of CPUs).

Can be reproduced with netcnt test on qemu with "-smp 255".

Signed-off-by: Stanislav Fomichev <sdf@google.com>
---
 kernel/bpf/syscall.c | 28 +++++++++++-----------------
 1 file changed, 11 insertions(+), 17 deletions(-)

diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
index 7420e1334ab2..075f650d297a 100644
--- a/kernel/bpf/syscall.c
+++ b/kernel/bpf/syscall.c
@@ -1076,7 +1076,7 @@ static int map_lookup_elem(union bpf_attr *attr)
 	value_size = bpf_map_value_size(map);
 
 	err = -ENOMEM;
-	value = kmalloc(value_size, GFP_USER | __GFP_NOWARN);
+	value = kvmalloc(value_size, GFP_USER | __GFP_NOWARN);
 	if (!value)
 		goto free_key;
 
@@ -1091,7 +1091,7 @@ static int map_lookup_elem(union bpf_attr *attr)
 	err = 0;
 
 free_value:
-	kfree(value);
+	kvfree(value);
 free_key:
 	kfree(key);
 err_put:
@@ -1137,16 +1137,10 @@ static int map_update_elem(union bpf_attr *attr, bpfptr_t uattr)
 		goto err_put;
 	}
 
-	if (map->map_type == BPF_MAP_TYPE_PERCPU_HASH ||
-	    map->map_type == BPF_MAP_TYPE_LRU_PERCPU_HASH ||
-	    map->map_type == BPF_MAP_TYPE_PERCPU_ARRAY ||
-	    map->map_type == BPF_MAP_TYPE_PERCPU_CGROUP_STORAGE)
-		value_size = round_up(map->value_size, 8) * num_possible_cpus();
-	else
-		value_size = map->value_size;
+	value_size = bpf_map_value_size(map);
 
 	err = -ENOMEM;
-	value = kmalloc(value_size, GFP_USER | __GFP_NOWARN);
+	value = kvmalloc(value_size, GFP_USER | __GFP_NOWARN);
 	if (!value)
 		goto free_key;
 
@@ -1157,7 +1151,7 @@ static int map_update_elem(union bpf_attr *attr, bpfptr_t uattr)
 	err = bpf_map_update_value(map, f, key, value, attr->flags);
 
 free_value:
-	kfree(value);
+	kvfree(value);
 free_key:
 	kfree(key);
 err_put:
@@ -1367,7 +1361,7 @@ int generic_map_update_batch(struct bpf_map *map,
 	if (!key)
 		return -ENOMEM;
 
-	value = kmalloc(value_size, GFP_USER | __GFP_NOWARN);
+	value = kvmalloc(value_size, GFP_USER | __GFP_NOWARN);
 	if (!value) {
 		kfree(key);
 		return -ENOMEM;
@@ -1390,7 +1384,7 @@ int generic_map_update_batch(struct bpf_map *map,
 	if (copy_to_user(&uattr->batch.count, &cp, sizeof(cp)))
 		err = -EFAULT;
 
-	kfree(value);
+	kvfree(value);
 	kfree(key);
 	return err;
 }
@@ -1429,7 +1423,7 @@ int generic_map_lookup_batch(struct bpf_map *map,
 	if (!buf_prevkey)
 		return -ENOMEM;
 
-	buf = kmalloc(map->key_size + value_size, GFP_USER | __GFP_NOWARN);
+	buf = kvmalloc(map->key_size + value_size, GFP_USER | __GFP_NOWARN);
 	if (!buf) {
 		kfree(buf_prevkey);
 		return -ENOMEM;
@@ -1492,7 +1486,7 @@ int generic_map_lookup_batch(struct bpf_map *map,
 
 free_buf:
 	kfree(buf_prevkey);
-	kfree(buf);
+	kvfree(buf);
 	return err;
 }
 
@@ -1547,7 +1541,7 @@ static int map_lookup_and_delete_elem(union bpf_attr *attr)
 	value_size = bpf_map_value_size(map);
 
 	err = -ENOMEM;
-	value = kmalloc(value_size, GFP_USER | __GFP_NOWARN);
+	value = kvmalloc(value_size, GFP_USER | __GFP_NOWARN);
 	if (!value)
 		goto free_key;
 
@@ -1579,7 +1573,7 @@ static int map_lookup_and_delete_elem(union bpf_attr *attr)
 	err = 0;
 
 free_value:
-	kfree(value);
+	kvfree(value);
 free_key:
 	kfree(key);
 err_put:
-- 
2.33.0.rc1.237.g0d66db33f3-goog

