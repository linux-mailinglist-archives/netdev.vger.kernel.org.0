Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A5A272712D
	for <lists+netdev@lfdr.de>; Wed, 22 May 2019 22:53:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730272AbfEVUx4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 May 2019 16:53:56 -0400
Received: from mail-yw1-f74.google.com ([209.85.161.74]:49400 "EHLO
        mail-yw1-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729728AbfEVUx4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 May 2019 16:53:56 -0400
Received: by mail-yw1-f74.google.com with SMTP id y144so3216571ywg.16
        for <netdev@vger.kernel.org>; Wed, 22 May 2019 13:53:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=DVGoSBbuSpH+e3WLjrm4JCzo4XlQbDlgH+gaP+mOUGk=;
        b=jDf21bghdvPavpAiB4qncBrzG9xXbKDUDUzNd491r/2RCa54zMKJJTUB3hXKAsqL0E
         g/+3l4encMEoH12bkPQAEuxCr5F9d0Gm0l/oKx0PNXfmt65ui40V16HSJA/6ZB5X6Adr
         Uv+eyVxBtYEjA1TLJ01ULFtqZ4cP/ZWZDDxFDwCAcmt+mJMqEhq6wXTXxq3aRLXfGBDe
         MJdh+mV5Y8KzTB9SwgdYbqzjzz0RWhFUeV+qy5Qh5/EIhfqkh+efQIIsKgYqzmrxTpQn
         iOybtSUFdlMRf93zir0N8pYk4si2cXzx6HpNK2OfOjgHLKXXxCpxHm7hZ6pyg2uMtoLi
         1Z4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=DVGoSBbuSpH+e3WLjrm4JCzo4XlQbDlgH+gaP+mOUGk=;
        b=gcysS5dEIG/e0fSG636pHZbpLHpm5k662Iyg2si4oTP4woIZlMhkRxODfq1Vw3DxIN
         4BzZ8ORFpZ/Ez11dD+TbD3wM0+bIdVM3J3XpBc4deC3x3yG6r+Zqbq8n0isTcGXFvbNq
         4xLwrxCj0OVmXNlWMThcGQcn4bqTW78yIwETM6BkTXVCyLm/5tkZZQvDQm9k0ExppcdB
         fRRynzPFNDJmZL0FQ1ad2UT/D3gdEQZeen4jja30Lr4uIq0+N3K8wieORdyf2j+0x1GE
         KUWXuRlxYtIV4bECaBXExbW5JGdrxA8mC6H/OgLPbGcfXqTa7UzdfXFGB5cPyCyNKl0r
         OvYg==
X-Gm-Message-State: APjAAAVVDdy735kkUbXat06oLNL9UsocMz+0CoRho0pXX/CxQXxMYyKe
        iQx22k0t0XqEImntu+Q75YgIEPm75hjSyPvGkJ08eshzbmOcxvMsLTPa5PBu4+/2JCGnL5wcQ2v
        saHpsJAg0T88UKrSXNIEiBAhj9Or+4Laa93dDMcfjeBe7CoJEX9GqKw==
X-Google-Smtp-Source: APXvYqxYwfzjHrzGCfYPGAiIhIGShiyO8nmp/97NXlJv1XT2CANUkMzwfeUS2Rp+R2kyiIUNrSaJtv8=
X-Received: by 2002:a81:980b:: with SMTP id p11mr10645808ywg.48.1558558435637;
 Wed, 22 May 2019 13:53:55 -0700 (PDT)
Date:   Wed, 22 May 2019 13:53:50 -0700
Message-Id: <20190522205353.140648-1-sdf@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.21.0.1020.gf2820cf01a-goog
Subject: [PATCH bpf-next v2 1/4] bpf: remove __rcu annotations from bpf_prog_array
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

One possible complication might be with Roman's set of patches
to decouple cgroup_bpf lifetime from the cgroup. In that case
we can use rcu_dereference_check(..., 1) since we know that there
should not be any existing users when we dismantle the cgroup.

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
index 4fb3aa2dc975..88ea32358593 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -513,17 +513,17 @@ struct bpf_prog_array {
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
index 242a643af82f..aad86c8a0d61 100644
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
2.21.0.1020.gf2820cf01a-goog

