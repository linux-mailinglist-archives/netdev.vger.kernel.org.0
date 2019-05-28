Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 48DD92CEAB
	for <lists+netdev@lfdr.de>; Tue, 28 May 2019 20:29:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728148AbfE1S3v (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 May 2019 14:29:51 -0400
Received: from mail-qk1-f201.google.com ([209.85.222.201]:56785 "EHLO
        mail-qk1-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728014AbfE1S3u (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 May 2019 14:29:50 -0400
Received: by mail-qk1-f201.google.com with SMTP id q17so29117483qkc.23
        for <netdev@vger.kernel.org>; Tue, 28 May 2019 11:29:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=Vvfcwr72bSznDRWDW9C8kPGBzuOHzue8v6sDrXmyPUo=;
        b=tuHckHYG3/skabF1hc7zemawXEEPQIYN7R89X6wsX70HkoxJyTmzcxnXb/6PqnB1NS
         rW1T0YJvL2P0jt49kQfSXUdxWe28BR6qpF0cQvMB92Fc0lO+GqQf+FWExTLPmcn/k+Hc
         jdtXwNcjIXwJaJjz1UEVmWKYh36fhMfe+xMyITnPuXICt8/f+7tLfDd6HjaQLMcciwiU
         83NJzBloY7EEYg/UnTBNP6yNJ/iPCvf+gTGL0321Bv+vI/274w95GEEQAgucWObwfpPG
         kgYTu4mIIcHCMRJTmiCgqNX+gq3K6xAsInX3yCh2eWUiAZwy/Mddf3cGDzYY/nHecrHl
         NDow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=Vvfcwr72bSznDRWDW9C8kPGBzuOHzue8v6sDrXmyPUo=;
        b=eI5x7P1LF5EeJeJo3zE4GEPLuqbBCDgqCuQMSU04Ed2Kfmrc9Nz1PBFi+6b+uQdylY
         rTrWN1A8Gimd9+VUg56jh9yYReLcX7NVTai+a/zJz5Gh+lMvQKMrrd3cF25pqrgLPSfK
         hwLDzpT0/3WxqyrBhiJB1v5F0k57CTpB22qFDTuFjxsWprS+INRNdnYwpffaIkEy9OTl
         i7Vlzy7V6IrM5E6DyOfGJnGtFUnmNUIvXgSxhdzCTsg3u6Ri7jUvmy5j7Y0+zVM2t9UQ
         /4Jw1sssnrkfDqZPZZvHR0DR0ZuYxQro3oVzpyRGelNGVISjTU94plB01fAko9w5M4DW
         2awg==
X-Gm-Message-State: APjAAAXN0ARKoxA+P7lOw8hn1DrxrbQsNZJ4A2qlZemjnHEaBvWvfBYz
        aLq3RG2X8V06l6bQ5GJm0RrCZ/Zvar9F6PRezVc83SyE5uUaBiNboyuNP+vaGlBU6TSXE8JqJaR
        gN+L8wj0V+CsxZLz2TWg85OLANLJiMsn+64ZOCyr0Q9qFJogTWvY0uA==
X-Google-Smtp-Source: APXvYqyh9d/cYnS/xEznpxdQ+BmKNPzrWR9rGYSSTgMknr1Fm9WB+ReMnIKxY7IY7DO4dIg8owSIE9k=
X-Received: by 2002:a0c:e849:: with SMTP id l9mr3306819qvo.3.1559068189383;
 Tue, 28 May 2019 11:29:49 -0700 (PDT)
Date:   Tue, 28 May 2019 11:29:43 -0700
Message-Id: <20190528182946.3633-1-sdf@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.22.0.rc1.257.g3120a18244-goog
Subject: [PATCH bpf-next v3 1/4] bpf: remove __rcu annotations from bpf_prog_array
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

