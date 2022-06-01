Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3786653AC62
	for <lists+netdev@lfdr.de>; Wed,  1 Jun 2022 19:58:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356569AbiFAR6a convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Wed, 1 Jun 2022 13:58:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51956 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356492AbiFAR6W (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Jun 2022 13:58:22 -0400
Received: from mx0a-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 26FCA9C2F9
        for <netdev@vger.kernel.org>; Wed,  1 Jun 2022 10:58:20 -0700 (PDT)
Received: from pps.filterd (m0001303.ppops.net [127.0.0.1])
        by m0001303.ppops.net (8.17.1.5/8.17.1.5) with ESMTP id 251GuTjD005392
        for <netdev@vger.kernel.org>; Wed, 1 Jun 2022 10:58:19 -0700
Received: from maileast.thefacebook.com ([163.114.130.16])
        by m0001303.ppops.net (PPS) with ESMTPS id 3gdv755es1-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Wed, 01 Jun 2022 10:58:19 -0700
Received: from twshared10560.18.frc3.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:83::5) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.28; Wed, 1 Jun 2022 10:58:17 -0700
Received: by devbig932.frc1.facebook.com (Postfix, from userid 4523)
        id 4CFD68603CCB; Wed,  1 Jun 2022 10:58:07 -0700 (PDT)
From:   Song Liu <song@kernel.org>
To:     <netdev@vger.kernel.org>, <bpf@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
CC:     <ast@kernel.org>, <daniel@iogearbox.net>, <andrii@kernel.org>,
        <kernel-team@fb.com>, <rostedt@goodmis.org>, <jolsa@kernel.org>,
        Song Liu <song@kernel.org>
Subject: [PATCH bpf-next 3/5] ftrace: introduce FTRACE_OPS_FL_SHARE_IPMODIFY
Date:   Wed, 1 Jun 2022 10:57:47 -0700
Message-ID: <20220601175749.3071572-4-song@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220601175749.3071572-1-song@kernel.org>
References: <20220601175749.3071572-1-song@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: Td5elq4OZn4tBX_4WuobZHuqSOM4SB44
X-Proofpoint-GUID: Td5elq4OZn4tBX_4WuobZHuqSOM4SB44
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.874,Hydra:6.0.517,FMLib:17.11.64.514
 definitions=2022-06-01_06,2022-06-01_01,2022-02-23_01
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H3,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

live patch and BPF trampoline (kfunc/kretfunc in bpftrace) are important
features for modern systems. Currently, it is not possible to use live
patch and BPF trampoline on the same kernel function at the same time.
This is because of the resitriction that only one ftrace_ops with flag
FTRACE_OPS_FL_IPMODIFY on the same kernel function.

BPF trampoline uses direct ftrace_ops, which assumes IPMODIFY. However,
not all direct ftrace_ops would overwrite the actual function. This means
it is possible to have a non-IPMODIFY direct ftrace_ops to share the same
kernel function with an IPMODIFY ftrace_ops.

Introduce FTRACE_OPS_FL_SHARE_IPMODIFY, which allows the direct ftrace_ops
to share with IPMODIFY ftrace_ops. With FTRACE_OPS_FL_SHARE_IPMODIFY flag
set, the direct ftrace_ops would call the target function picked by the
IPMODIFY ftrace_ops.

Comment "IPMODIFY, DIRECT, and SHARE_IPMODIFY" in include/linux/ftrace.h
contains more information about how SHARE_IPMODIFY interacts with IPMODIFY
and DIRECT flags.

Signed-off-by: Song Liu <song@kernel.org>
---
 include/linux/ftrace.h |  74 +++++++++++++++++
 kernel/trace/ftrace.c  | 179 ++++++++++++++++++++++++++++++++++++++---
 2 files changed, 242 insertions(+), 11 deletions(-)

diff --git a/include/linux/ftrace.h b/include/linux/ftrace.h
index 9023bf69f675..ec8e18e53515 100644
--- a/include/linux/ftrace.h
+++ b/include/linux/ftrace.h
@@ -189,6 +189,9 @@ ftrace_func_t ftrace_ops_get_func(struct ftrace_ops *ops);
  *             ftrace_enabled.
  * DIRECT - Used by the direct ftrace_ops helper for direct functions
  *            (internal ftrace only, should not be used by others)
+ * SHARE_IPMODIFY - For direct ftrace_ops only. Set when the direct function
+ *            is ready to share same kernel function with IPMODIFY function
+ *            (live patch, etc.).
  */
 enum {
 	FTRACE_OPS_FL_ENABLED			= BIT(0),
@@ -209,8 +212,78 @@ enum {
 	FTRACE_OPS_FL_TRACE_ARRAY		= BIT(15),
 	FTRACE_OPS_FL_PERMANENT                 = BIT(16),
 	FTRACE_OPS_FL_DIRECT			= BIT(17),
+	FTRACE_OPS_FL_SHARE_IPMODIFY		= BIT(18),
 };
 
+/*
+ * IPMODIFY, DIRECT, and SHARE_IPMODIFY.
+ *
+ * ftrace provides IPMODIFY flag for users to replace existing kernel
+ * function with a different version. This is achieved by setting regs->ip.
+ * The top user of IPMODIFY is live patch.
+ *
+ * DIRECT allows user to load custom trampoline on top of ftrace. DIRECT
+ * ftrace does not overwrite regs->ip. Instead, the custom trampoline is
+ * saved separately (for example, orig_ax on x86). The top user of DIRECT
+ * is bpf trampoline.
+ *
+ * It is not super rare to have both live patch and bpf trampoline on the
+ * same kernel function. Therefore, it is necessary to allow the two work
+ * with each other. Given that IPMODIFY and DIRECT target addressese are
+ * saved separately, this is feasible, but we need to be careful.
+ *
+ * The policy between IPMODIFY and DIRECT is:
+ *
+ *  1. Each kernel function can only have one IPMODIFY ftrace_ops;
+ *  2. Each kernel function can only have one DIRECT ftrace_ops;
+ *  3. DIRECT ftrace_ops may have IPMODIFY or not;
+ *  4. Each kernel function may have one non-DIRECT IPMODIFY ftrace_ops,
+ *     and one non-IPMODIFY DIRECT ftrace_ops at the same time. This
+ *     requires support from the DIRECT ftrace_ops. Specifically, the
+ *     DIRECT trampoline should call the kernel function at regs->ip.
+ *     If the DIRECT ftrace_ops supports sharing a function with ftrace_ops
+ *     with IPMODIFY, it should set flag SHARE_IPMODIFY.
+ *
+ * Some DIRECT ftrace_ops has an option to enable SHARE_IPMODIFY or not.
+ * Usually, the non-SHARE_IPMODIFY option gives better performance. To take
+ * advantage of this performance benefit, is necessary to only enable
+ * SHARE_IPMODIFY only when it is on the same function as an IPMODIFY
+ * ftrace_ops. There are two cases to consider:
+ *
+ *  1. IPMODIFY ftrace_ops is registered first. When the (non-IPMODIFY, and
+ *     non-SHARE_IPMODIFY) DIRECT ftrace_ops is registered later,
+ *     register_ftrace_direct_multi() returns -EAGAIN. If the user of
+ *     the DIRECT ftrace_ops can support SHARE_IPMODIFY, it should enable
+ *     SHARE_IPMODIFY and retry.
+ *  2. (non-IPMODIFY, and non-SHARE_IPMODIFY) DIRECT ftrace_ops is
+ *     registered first. When the IPMODIFY ftrace_ops is registered later,
+ *     it is necessary to ask the direct ftrace_ops to enable
+ *     SHARE_IPMODIFY support. This is achieved via ftrace_ops->ops_func
+ *     cmd=FTRACE_OPS_CMD_ENABLE_SHARE_IPMODIFY. For more details on this
+ *     condition, check out prepare_direct_functions_for_ipmodify().
+ */
+
+/*
+ * FTRACE_OPS_CMD_* commands allow the ftrace core logic to request changes
+ * to a ftrace_ops.
+ *
+ * ENABLE_SHARE_IPMODIFY - enable FTRACE_OPS_FL_SHARE_IPMODIFY.
+ * DISABLE_SHARE_IPMODIFY - disable FTRACE_OPS_FL_SHARE_IPMODIFY.
+ */
+enum ftrace_ops_cmd {
+	FTRACE_OPS_CMD_ENABLE_SHARE_IPMODIFY,
+	FTRACE_OPS_CMD_DISABLE_SHARE_IPMODIFY,
+};
+
+/*
+ * For most ftrace_ops_cmd,
+ * Returns:
+ *        0 - Success.
+ *        -EBUSY - The operation cannot process
+ *        -EAGAIN - The operation cannot process tempoorarily.
+ */
+typedef int (*ftrace_ops_func_t)(struct ftrace_ops *op, enum ftrace_ops_cmd cmd);
+
 #ifdef CONFIG_DYNAMIC_FTRACE
 /* The hash used to know what functions callbacks trace */
 struct ftrace_ops_hash {
@@ -253,6 +326,7 @@ struct ftrace_ops {
 	unsigned long			trampoline;
 	unsigned long			trampoline_size;
 	struct list_head		list;
+	ftrace_ops_func_t		ops_func;
 #endif
 };
 
diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index 6a419f6bbbf0..868bbc753803 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -1865,7 +1865,8 @@ static void ftrace_hash_rec_enable_modify(struct ftrace_ops *ops,
 /*
  * Try to update IPMODIFY flag on each ftrace_rec. Return 0 if it is OK
  * or no-needed to update, -EBUSY if it detects a conflict of the flag
- * on a ftrace_rec, and -EINVAL if the new_hash tries to trace all recs.
+ * on a ftrace_rec, -EINVAL if the new_hash tries to trace all recs, and
+ * -EAGAIN if the ftrace_ops need to enable SHARE_IPMODIFY.
  * Note that old_hash and new_hash has below meanings
  *  - If the hash is NULL, it hits all recs (if IPMODIFY is set, this is rejected)
  *  - If the hash is EMPTY_HASH, it hits nothing
@@ -1875,6 +1876,7 @@ static int __ftrace_hash_update_ipmodify(struct ftrace_ops *ops,
 					 struct ftrace_hash *old_hash,
 					 struct ftrace_hash *new_hash)
 {
+	bool is_ipmodify, is_direct, share_ipmodify;
 	struct ftrace_page *pg;
 	struct dyn_ftrace *rec, *end = NULL;
 	int in_old, in_new;
@@ -1883,7 +1885,24 @@ static int __ftrace_hash_update_ipmodify(struct ftrace_ops *ops,
 	if (!(ops->flags & FTRACE_OPS_FL_ENABLED))
 		return 0;
 
-	if (!(ops->flags & FTRACE_OPS_FL_IPMODIFY))
+	/*
+	 * The following are all the valid combinations of is_ipmodify,
+	 * is_direct, and share_ipmodify
+	 *
+	 *             is_ipmodify     is_direct     share_ipmodify
+	 *  #1              0               0                0
+	 *  #2              1               0                0
+	 *  #3              1               1                0
+	 *  #4              0               1                0
+	 *  #5              0               1                1
+	 */
+
+
+	is_ipmodify = ops->flags & FTRACE_OPS_FL_IPMODIFY;
+	is_direct = ops->flags & FTRACE_OPS_FL_DIRECT;
+
+	/* either ipmodify nor direct, skip */
+	if (!is_ipmodify && !is_direct)   /* combinations #1 */
 		return 0;
 
 	/*
@@ -1893,6 +1912,30 @@ static int __ftrace_hash_update_ipmodify(struct ftrace_ops *ops,
 	if (!new_hash || !old_hash)
 		return -EINVAL;
 
+	share_ipmodify = ops->flags & FTRACE_OPS_FL_SHARE_IPMODIFY;
+
+	/*
+	 * This ops itself doesn't do ip_modify and it can share a fentry
+	 * with other ops with ipmodify, nothing to do.
+	 */
+	if (!is_ipmodify && share_ipmodify)   /* combinations #5 */
+		return 0;
+
+	/*
+	 * Only three combinations of is_ipmodify, is_direct, and
+	 * share_ipmodify for the logic below:
+	 * #2 live patch
+	 * #3 direct with ipmodify
+	 * #4 direct without ipmodify
+	 *
+	 *             is_ipmodify     is_direct     share_ipmodify
+	 *  #2              1               0                0
+	 *  #3              1               1                0
+	 *  #4              0               1                0
+	 *
+	 * Only update/rollback rec->flags for is_ipmodify == 1 (#2 and #3)
+	 */
+
 	/* Update rec->flags */
 	do_for_each_ftrace_rec(pg, rec) {
 
@@ -1906,12 +1949,18 @@ static int __ftrace_hash_update_ipmodify(struct ftrace_ops *ops,
 			continue;
 
 		if (in_new) {
-			/* New entries must ensure no others are using it */
-			if (rec->flags & FTRACE_FL_IPMODIFY)
-				goto rollback;
-			rec->flags |= FTRACE_FL_IPMODIFY;
-		} else /* Removed entry */
+			if (rec->flags & FTRACE_FL_IPMODIFY) {
+				/* cannot have two ipmodify on same rec */
+				if (is_ipmodify)  /* combination #2 and #3 */
+					goto rollback;
+				/* let user enable share_ipmodify and retry */
+				return  -EAGAIN;  /* combination #4 */
+			} else if (is_ipmodify) {
+				rec->flags |= FTRACE_FL_IPMODIFY;
+			}
+		} else if (is_ipmodify) {/* Removed entry */
 			rec->flags &= ~FTRACE_FL_IPMODIFY;
+		}
 	} while_for_each_ftrace_rec();
 
 	return 0;
@@ -3115,14 +3164,14 @@ static inline int ops_traces_mod(struct ftrace_ops *ops)
 }
 
 /*
- * Check if the current ops references the record.
+ * Check if the current ops references the given ip.
  *
  * If the ops traces all functions, then it was already accounted for.
  * If the ops does not trace the current record function, skip it.
  * If the ops ignores the function via notrace filter, skip it.
  */
 static inline bool
-ops_references_rec(struct ftrace_ops *ops, struct dyn_ftrace *rec)
+ops_references_ip(struct ftrace_ops *ops, unsigned long ip)
 {
 	/* If ops isn't enabled, ignore it */
 	if (!(ops->flags & FTRACE_OPS_FL_ENABLED))
@@ -3134,16 +3183,29 @@ ops_references_rec(struct ftrace_ops *ops, struct dyn_ftrace *rec)
 
 	/* The function must be in the filter */
 	if (!ftrace_hash_empty(ops->func_hash->filter_hash) &&
-	    !__ftrace_lookup_ip(ops->func_hash->filter_hash, rec->ip))
+	    !__ftrace_lookup_ip(ops->func_hash->filter_hash, ip))
 		return false;
 
 	/* If in notrace hash, we ignore it too */
-	if (ftrace_lookup_ip(ops->func_hash->notrace_hash, rec->ip))
+	if (ftrace_lookup_ip(ops->func_hash->notrace_hash, ip))
 		return false;
 
 	return true;
 }
 
+/*
+ * Check if the current ops references the record.
+ *
+ * If the ops traces all functions, then it was already accounted for.
+ * If the ops does not trace the current record function, skip it.
+ * If the ops ignores the function via notrace filter, skip it.
+ */
+static inline bool
+ops_references_rec(struct ftrace_ops *ops, struct dyn_ftrace *rec)
+{
+	return ops_references_ip(ops, rec->ip);
+}
+
 static int ftrace_update_code(struct module *mod, struct ftrace_page *new_pgs)
 {
 	bool init_nop = ftrace_need_init_nop();
@@ -5519,6 +5581,14 @@ int register_ftrace_direct_multi(struct ftrace_ops *ops, unsigned long addr)
 	if (ops->flags & FTRACE_OPS_FL_ENABLED)
 		return -EINVAL;
 
+	/*
+	 * if the ops does ipmodify, it cannot share the same fentry with
+	 * other functions with ipmodify.
+	 */
+	if ((ops->flags & FTRACE_OPS_FL_IPMODIFY) &&
+	    (ops->flags & FTRACE_OPS_FL_SHARE_IPMODIFY))
+		return -EINVAL;
+
 	hash = ops->func_hash->filter_hash;
 	if (ftrace_hash_empty(hash))
 		return -EINVAL;
@@ -7901,6 +7971,83 @@ int ftrace_is_dead(void)
 	return ftrace_disabled;
 }
 
+/*
+ * When registering ftrace_ops with IPMODIFY (not direct), it is necessary
+ * to make sure it doesn't conflict with any direct ftrace_ops. If there is
+ * existing direct ftrace_ops on a kernel function being patched, call
+ * FTRACE_OPS_CMD_ENABLE_SHARE_IPMODIFY on it to enable sharing.
+ *
+ * @ops:     ftrace_ops being registered.
+ *
+ * Returns:
+ *         0 - @ops does have IPMODIFY or @ops itself is DIRECT, no change
+ *             needed;
+ *         1 - @ops has IPMODIFY, hold direct_mutex;
+ *         -EBUSY - currently registered DIRECT ftrace_ops does not support
+ *                  SHARE_IPMODIFY, we need to abort the register.
+ *         -EAGAIN - cannot make changes to currently registered DIRECT
+ *                   ftrace_ops at the moment, but we can retry later. This
+ *                   is needed to avoid potential deadlocks.
+ */
+static int prepare_direct_functions_for_ipmodify(struct ftrace_ops *ops)
+	__acquires(&direct_mutex)
+{
+	struct ftrace_func_entry *entry;
+	struct ftrace_hash *hash;
+	struct ftrace_ops *op;
+	int size, i, ret;
+
+	if (!(ops->flags & FTRACE_OPS_FL_IPMODIFY) ||
+	    (ops->flags & FTRACE_OPS_FL_DIRECT))
+		return 0;
+
+	mutex_lock(&direct_mutex);
+
+	hash = ops->func_hash->filter_hash;
+	size = 1 << hash->size_bits;
+	for (i = 0; i < size; i++) {
+		hlist_for_each_entry(entry, &hash->buckets[i], hlist) {
+			unsigned long ip = entry->ip;
+			bool found_op = false;
+
+			mutex_lock(&ftrace_lock);
+			do_for_each_ftrace_op(op, ftrace_ops_list) {
+				if (!(op->flags & FTRACE_OPS_FL_DIRECT))
+					continue;
+				if (op->flags & FTRACE_OPS_FL_SHARE_IPMODIFY)
+					break;
+				if (ops_references_ip(op, ip)) {
+					found_op = true;
+					break;
+				}
+			} while_for_each_ftrace_op(op);
+			mutex_unlock(&ftrace_lock);
+
+			if (found_op) {
+				if (!op->ops_func) {
+					ret = -EBUSY;
+					goto err_out;
+				}
+				ret = op->ops_func(op, FTRACE_OPS_CMD_ENABLE_SHARE_IPMODIFY);
+				if (ret)
+					goto err_out;
+			}
+		}
+	}
+
+	/*
+	 * Didn't find any overlap with any direct function, or the direct
+	 * function can share with ipmodify. Hold direct_mutex to make sure
+	 * this doesn't change until we are done.
+	 */
+	return 1;
+
+err_out:
+	mutex_unlock(&direct_mutex);
+	return ret;
+
+}
+
 /**
  * register_ftrace_function - register a function for profiling
  * @ops:	ops structure that holds the function for profiling.
@@ -7913,17 +8060,27 @@ int ftrace_is_dead(void)
  *       recursive loop.
  */
 int register_ftrace_function(struct ftrace_ops *ops)
+	__releases(&direct_mutex)
 {
+	bool direct_mutex_locked;
 	int ret;
 
 	ftrace_ops_init(ops);
 
+	ret = prepare_direct_functions_for_ipmodify(ops);
+	if (ret < 0)
+		return ret;
+
+	direct_mutex_locked = ret == 1;
+
 	mutex_lock(&ftrace_lock);
 
 	ret = ftrace_startup(ops, 0);
 
 	mutex_unlock(&ftrace_lock);
 
+	if (direct_mutex_locked)
+		mutex_unlock(&direct_mutex);
 	return ret;
 }
 EXPORT_SYMBOL_GPL(register_ftrace_function);
-- 
2.30.2

