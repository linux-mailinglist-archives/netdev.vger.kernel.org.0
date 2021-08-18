Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9044C3F0ED7
	for <lists+netdev@lfdr.de>; Thu, 19 Aug 2021 01:52:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235102AbhHRXw4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Aug 2021 19:52:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39464 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235064AbhHRXwy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Aug 2021 19:52:54 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9638FC0613CF
        for <netdev@vger.kernel.org>; Wed, 18 Aug 2021 16:52:19 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id p71-20020a25424a0000b029056092741626so4622505yba.19
        for <netdev@vger.kernel.org>; Wed, 18 Aug 2021 16:52:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=u0j+ACVINI5xe3P0ek73QrWfPnNxV4g8NgRpnGbWpfs=;
        b=Wy4STULLtVajrdLOnlpq/PE5xQWKsl8nS+pXJEnCYp5N8MjL4tAaBBNhvUgfEv1g3i
         2ZiExlTmi1eKUQ2lG9TQa8NzX3J8Lqg+2X0UKSTXoZHmxI4OoO7hcIy+xnkt7YH9IqSw
         AyIzhtXbIWBfa0yNNYy59nqi3DsSu0gtXHIogGgJrwFkPGU5iWgrHHy5oEZOclH7eMaP
         xb/+j26DYr21RVm1ldNhrgPZCYsyAdP9/UIZ/y5p2+SqN2YmbNRYhzu8CQU4hAJetiSH
         r5GHRbr17ClLTWr6fbaF4wzOpUbhYdV+2K4ah15yAkZzhMELlTsBMauyUGkbrZG5Xrxb
         sCSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=u0j+ACVINI5xe3P0ek73QrWfPnNxV4g8NgRpnGbWpfs=;
        b=q8Scd3jf5WkI3yLAOU927j1lLH8cul7MbzbBm2IgnuuEDXbKcsMpaCgnuBmkGwdS/v
         uVV850ZnhUEkqdq8E35tgA8XAxhzwj70fa4IK09NhjR2qIHWtbQEHQGe52EwWjTlOy27
         VCDAmWNeDjN3WN3qhpMuWxd538ua5Rz8fG6B00618mPxK33lp1HrRPLk/RJcMnoCIbqc
         ZtDHewjtqwNILPjR/HNzBLPJuN/NZhyQYhDcM0FE9n6u6hO6wPsxIsd1vzUB4gwPaZiQ
         2tKvMol8jnAegTfI9EntEKjsEuNCil8QWfaGdP3gdCGE1qz6czjIjAL0ZbnzLXEN2Qw4
         4NIg==
X-Gm-Message-State: AOAM5332IEqW+DD/39M7TmoZawBPjh8m8fxgrs4AKMnfLcgPoaWwz6pF
        fb7MXVrX7oRuE0A4opdbyO8KstClZbeo7eYdEBbPGk0XLKVXpohwsN9zp/24bFx2g4+xIPAc9pY
        UXJINDkKnyq4x5g0lNn8e20h4qYPnLy5sYAARSwn0/38EmvMnhBKIHQ==
X-Google-Smtp-Source: ABdhPJwSq9Q050723AUzv+Aid3+xmwYFXnRVUE9mBI0RtJtjb4VO0e7+elxW9Cw2lN5a6JluTFlXH0Y=
X-Received: from sdf2.svl.corp.google.com ([2620:15c:2c4:201:7401:ef23:e119:5cbc])
 (user=sdf job=sendgmr) by 2002:a25:a163:: with SMTP id z90mr15484065ybh.378.1629330738819;
 Wed, 18 Aug 2021 16:52:18 -0700 (PDT)
Date:   Wed, 18 Aug 2021 16:52:15 -0700
Message-Id: <20210818235216.1159202-1-sdf@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.33.0.rc2.250.ged5fa647cd-goog
Subject: [PATCH bpf-next v3 1/2] bpf: use kvmalloc for map values in syscall
From:   Stanislav Fomichev <sdf@google.com>
To:     netdev@vger.kernel.org, bpf@vger.kernel.org
Cc:     ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        Stanislav Fomichev <sdf@google.com>,
        Song Liu <songliubraving@fb.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use kvmalloc/kvfree for temporary value when manipulating a map via
syscall. kmalloc might not be sufficient for percpu maps where the value
is big (and further multiplied by hundreds of CPUs).

Can be reproduced with netcnt test on qemu with "-smp 255".

Signed-off-by: Stanislav Fomichev <sdf@google.com>
Acked-by: Song Liu <songliubraving@fb.com>
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
2.33.0.rc2.250.ged5fa647cd-goog

