Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0690F2D0DC
	for <lists+netdev@lfdr.de>; Tue, 28 May 2019 23:14:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727614AbfE1VOr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 May 2019 17:14:47 -0400
Received: from mail-pf1-f201.google.com ([209.85.210.201]:35030 "EHLO
        mail-pf1-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727144AbfE1VOr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 May 2019 17:14:47 -0400
Received: by mail-pf1-f201.google.com with SMTP id 205so175026pfx.2
        for <netdev@vger.kernel.org>; Tue, 28 May 2019 14:14:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=U6e64xE+rTHulW/tYv5wSEUbYGHDGKFeoF3hS9TOHXY=;
        b=nMqYSHtiwOBO9O8ATcedv0h++nQCysfT93Y7tSJeXiZ66CGF+qgZEdLi3Xl7OexBCB
         svlNdWVGBBi3HUbN4vi+99YhjuTn8K6kpxLDZKoRi5qzNPMJKqxLMuGzj7vstmfx2yTB
         2QuVKV2Uincm11DzTcwOl4T0cOdZfOwIgduiZsugcj1wZat+h1BkQQSKoWN123AR0VR9
         rD0Q3ZqTfJGP6+rHRhP8PbV0up4Cs5RBJD1Q0wMK2HcbZqyemLJjq3r+328N/IAqW9N3
         nWMYHNfyPwj4ZuHkvo/0EFIlN5WUTnSv4brugKfhLJ/8BURM4atbQs+oCzRszFgbY+7n
         +lIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=U6e64xE+rTHulW/tYv5wSEUbYGHDGKFeoF3hS9TOHXY=;
        b=VXneBZFHZ3XHhrx2J8jwUcNtqvB1jsu+DEJVWci26Vxo+RzxNYcD703q40xLq4Ooqc
         raTnQKyMPwqGQgfJK0/wATTz+OPOkdlYixQNH+bfujn0+qQJsUFBxA0bmX+ZJO/Amk3s
         UZ2DHukDsewTLTBOY+UV88BLhsxq98lJvh9UY1M57nXkrP2GL3zsE58vPtUCTNVKHcy4
         w7D8dBF4auBNXVYva5UaWaAThOHhcVIx4sGk/shs13jCoU0rW4+PYSsO7lPpA36JjDPL
         wHxIsR8m+QOx8W9PRpfuh/FSDULjF2CmkaHUYd8jg3iL2ZudOOCBYtNQIHPcs8tl0tVs
         tr0Q==
X-Gm-Message-State: APjAAAXXEFU9NqLWaWe6O9EHGJnAh3FXsDpi9X1rKr+ZS/xM5/dOo1X0
        XIo2Vh/1AwUEHlibgID6yvZmUb4zGvcSrbsBQoXSrhyUSW+S2TWh6hik2lJAqUiozlXIIo015JP
        /CW9XIdCIJKp/JdLwk0MkeLQG0EajxhPPh1Jwx6qYvyAPybFVqsxtkQ==
X-Google-Smtp-Source: APXvYqxnNRNqojML7ODSNpdU88VFIDwA2w+rYLcpWvbI4xpIYmEpkNnMU/gD22CRzN+4NNkgCoM1liY=
X-Received: by 2002:a63:2d41:: with SMTP id t62mr136131434pgt.113.1559078086420;
 Tue, 28 May 2019 14:14:46 -0700 (PDT)
Date:   Tue, 28 May 2019 14:14:41 -0700
Message-Id: <20190528211444.166437-1-sdf@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.22.0.rc1.257.g3120a18244-goog
Subject: [PATCH bpf-next v4 1/4] bpf: remove __rcu annotations from bpf_prog_array
From:   Stanislav Fomichev <sdf@google.com>
To:     netdev@vger.kernel.org, bpf@vger.kernel.org
Cc:     davem@davemloft.net, ast@kernel.org, daniel@iogearbox.net,
        Stanislav Fomichev <sdf@google.com>,
        Roman Gushchin <guro@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Drop __rcu annotations and rcu read sections from bpf_prog_array
helper functions. They are not needed since all existing callers
call those helpers from the rcu update side while holding a mutex.
This guarantees that use-after-free could not happen.

In the next patches I'll fix the callers with missing
rcu_dereference_protected to make sparse/lockdep happy, the proper
way to use these helpers is:

	struct bpf_prog_array __rcu *progs = ...;
	struct bpf_prog_array *p;

	mutex_lock(&mtx);
	p = rcu_dereference_protected(progs, lockdep_is_held(&mtx));
	bpf_prog_array_length(p);
	bpf_prog_array_copy_to_user(p, ...);
	bpf_prog_array_delete_safe(p, ...);
	bpf_prog_array_copy_info(p, ...);
	bpf_prog_array_copy(p, ...);
	bpf_prog_array_free(p);
	mutex_unlock(&mtx);

No functional changes! rcu_dereference_protected with lockdep_is_held
should catch any cases where we update prog array without a mutex
(I've looked at existing call sites and I think we hold a mutex
everywhere).

Motivation is to fix sparse warnings:
kernel/bpf/core.c:1803:9: warning: incorrect type in argument 1 (different address spaces)
kernel/bpf/core.c:1803:9:    expected struct callback_head *head
kernel/bpf/core.c:1803:9:    got struct callback_head [noderef] <asn:4> *
kernel/bpf/core.c:1877:44: warning: incorrect type in initializer (different address spaces)
kernel/bpf/core.c:1877:44:    expected struct bpf_prog_array_item *item
kernel/bpf/core.c:1877:44:    got struct bpf_prog_array_item [noderef] <asn:4> *
kernel/bpf/core.c:1901:26: warning: incorrect type in assignment (different address spaces)
kernel/bpf/core.c:1901:26:    expected struct bpf_prog_array_item *existing
kernel/bpf/core.c:1901:26:    got struct bpf_prog_array_item [noderef] <asn:4> *
kernel/bpf/core.c:1935:26: warning: incorrect type in assignment (different address spaces)
kernel/bpf/core.c:1935:26:    expected struct bpf_prog_array_item *[assigned] existing
kernel/bpf/core.c:1935:26:    got struct bpf_prog_array_item [noderef] <asn:4> *

v2:
* remove comment about potential race; that can't happen
  because all callers are in rcu-update section

Cc: Roman Gushchin <guro@fb.com>
Acked-by: Roman Gushchin <guro@fb.com>
Signed-off-by: Stanislav Fomichev <sdf@google.com>
---
 include/linux/bpf.h | 12 ++++++------
 kernel/bpf/core.c   | 37 +++++++++++++------------------------
 2 files changed, 19 insertions(+), 30 deletions(-)

diff --git a/include/linux/bpf.h b/include/linux/bpf.h
index d98141edb74b..ff3e00ff84d2 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -514,17 +514,17 @@ struct bpf_prog_array {
 };
 
 struct bpf_prog_array *bpf_prog_array_alloc(u32 prog_cnt, gfp_t flags);
-void bpf_prog_array_free(struct bpf_prog_array __rcu *progs);
-int bpf_prog_array_length(struct bpf_prog_array __rcu *progs);
-int bpf_prog_array_copy_to_user(struct bpf_prog_array __rcu *progs,
+void bpf_prog_array_free(struct bpf_prog_array *progs);
+int bpf_prog_array_length(struct bpf_prog_array *progs);
+int bpf_prog_array_copy_to_user(struct bpf_prog_array *progs,
 				__u32 __user *prog_ids, u32 cnt);
 
-void bpf_prog_array_delete_safe(struct bpf_prog_array __rcu *progs,
+void bpf_prog_array_delete_safe(struct bpf_prog_array *progs,
 				struct bpf_prog *old_prog);
-int bpf_prog_array_copy_info(struct bpf_prog_array __rcu *array,
+int bpf_prog_array_copy_info(struct bpf_prog_array *array,
 			     u32 *prog_ids, u32 request_cnt,
 			     u32 *prog_cnt);
-int bpf_prog_array_copy(struct bpf_prog_array __rcu *old_array,
+int bpf_prog_array_copy(struct bpf_prog_array *old_array,
 			struct bpf_prog *exclude_prog,
 			struct bpf_prog *include_prog,
 			struct bpf_prog_array **new_array);
diff --git a/kernel/bpf/core.c b/kernel/bpf/core.c
index 3675b19ecb90..33fb292f2e30 100644
--- a/kernel/bpf/core.c
+++ b/kernel/bpf/core.c
@@ -1795,38 +1795,33 @@ struct bpf_prog_array *bpf_prog_array_alloc(u32 prog_cnt, gfp_t flags)
 	return &empty_prog_array.hdr;
 }
 
-void bpf_prog_array_free(struct bpf_prog_array __rcu *progs)
+void bpf_prog_array_free(struct bpf_prog_array *progs)
 {
-	if (!progs ||
-	    progs == (struct bpf_prog_array __rcu *)&empty_prog_array.hdr)
+	if (!progs || progs == &empty_prog_array.hdr)
 		return;
 	kfree_rcu(progs, rcu);
 }
 
-int bpf_prog_array_length(struct bpf_prog_array __rcu *array)
+int bpf_prog_array_length(struct bpf_prog_array *array)
 {
 	struct bpf_prog_array_item *item;
 	u32 cnt = 0;
 
-	rcu_read_lock();
-	item = rcu_dereference(array)->items;
-	for (; item->prog; item++)
+	for (item = array->items; item->prog; item++)
 		if (item->prog != &dummy_bpf_prog.prog)
 			cnt++;
-	rcu_read_unlock();
 	return cnt;
 }
 
 
-static bool bpf_prog_array_copy_core(struct bpf_prog_array __rcu *array,
+static bool bpf_prog_array_copy_core(struct bpf_prog_array *array,
 				     u32 *prog_ids,
 				     u32 request_cnt)
 {
 	struct bpf_prog_array_item *item;
 	int i = 0;
 
-	item = rcu_dereference_check(array, 1)->items;
-	for (; item->prog; item++) {
+	for (item = array->items; item->prog; item++) {
 		if (item->prog == &dummy_bpf_prog.prog)
 			continue;
 		prog_ids[i] = item->prog->aux->id;
@@ -1839,7 +1834,7 @@ static bool bpf_prog_array_copy_core(struct bpf_prog_array __rcu *array,
 	return !!(item->prog);
 }
 
-int bpf_prog_array_copy_to_user(struct bpf_prog_array __rcu *array,
+int bpf_prog_array_copy_to_user(struct bpf_prog_array *array,
 				__u32 __user *prog_ids, u32 cnt)
 {
 	unsigned long err = 0;
@@ -1850,18 +1845,12 @@ int bpf_prog_array_copy_to_user(struct bpf_prog_array __rcu *array,
 	 * cnt = bpf_prog_array_length();
 	 * if (cnt > 0)
 	 *     bpf_prog_array_copy_to_user(..., cnt);
-	 * so below kcalloc doesn't need extra cnt > 0 check, but
-	 * bpf_prog_array_length() releases rcu lock and
-	 * prog array could have been swapped with empty or larger array,
-	 * so always copy 'cnt' prog_ids to the user.
-	 * In a rare race the user will see zero prog_ids
+	 * so below kcalloc doesn't need extra cnt > 0 check.
 	 */
 	ids = kcalloc(cnt, sizeof(u32), GFP_USER | __GFP_NOWARN);
 	if (!ids)
 		return -ENOMEM;
-	rcu_read_lock();
 	nospc = bpf_prog_array_copy_core(array, ids, cnt);
-	rcu_read_unlock();
 	err = copy_to_user(prog_ids, ids, cnt * sizeof(u32));
 	kfree(ids);
 	if (err)
@@ -1871,19 +1860,19 @@ int bpf_prog_array_copy_to_user(struct bpf_prog_array __rcu *array,
 	return 0;
 }
 
-void bpf_prog_array_delete_safe(struct bpf_prog_array __rcu *array,
+void bpf_prog_array_delete_safe(struct bpf_prog_array *array,
 				struct bpf_prog *old_prog)
 {
-	struct bpf_prog_array_item *item = array->items;
+	struct bpf_prog_array_item *item;
 
-	for (; item->prog; item++)
+	for (item = array->items; item->prog; item++)
 		if (item->prog == old_prog) {
 			WRITE_ONCE(item->prog, &dummy_bpf_prog.prog);
 			break;
 		}
 }
 
-int bpf_prog_array_copy(struct bpf_prog_array __rcu *old_array,
+int bpf_prog_array_copy(struct bpf_prog_array *old_array,
 			struct bpf_prog *exclude_prog,
 			struct bpf_prog *include_prog,
 			struct bpf_prog_array **new_array)
@@ -1947,7 +1936,7 @@ int bpf_prog_array_copy(struct bpf_prog_array __rcu *old_array,
 	return 0;
 }
 
-int bpf_prog_array_copy_info(struct bpf_prog_array __rcu *array,
+int bpf_prog_array_copy_info(struct bpf_prog_array *array,
 			     u32 *prog_ids, u32 request_cnt,
 			     u32 *prog_cnt)
 {
-- 
2.22.0.rc1.257.g3120a18244-goog

