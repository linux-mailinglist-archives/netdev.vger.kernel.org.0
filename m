Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5F0E2195A74
	for <lists+netdev@lfdr.de>; Fri, 27 Mar 2020 16:59:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727740AbgC0P7U (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Mar 2020 11:59:20 -0400
Received: from www62.your-server.de ([213.133.104.62]:50938 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727600AbgC0P7R (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Mar 2020 11:59:17 -0400
Received: from 98.186.195.178.dynamic.wline.res.cust.swisscom.ch ([178.195.186.98] helo=localhost)
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1jHrO6-0007nY-3w; Fri, 27 Mar 2020 16:59:14 +0100
From:   Daniel Borkmann <daniel@iogearbox.net>
To:     alexei.starovoitov@gmail.com
Cc:     m@lambda.lt, joe@wand.net.nz, bpf@vger.kernel.org,
        netdev@vger.kernel.org, Daniel Borkmann <daniel@iogearbox.net>
Subject: [PATCH bpf-next 5/7] bpf: enable bpf cgroup hooks to retrieve cgroup v2 and ancestor id
Date:   Fri, 27 Mar 2020 16:58:54 +0100
Message-Id: <d2a7ef42530ad299e3cbb245e6c12374b72145ef.1585323121.git.daniel@iogearbox.net>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <cover.1585323121.git.daniel@iogearbox.net>
References: <cover.1585323121.git.daniel@iogearbox.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.102.2/25764/Fri Mar 27 14:11:26 2020)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Enable the bpf_get_current_cgroup_id() helper for connect(), sendmsg(),
recvmsg() and bind-related hooks in order to retrieve the cgroup v2
context which can then be used as part of the key for BPF map lookups,
for example. Given these hooks operate in process context 'current' is
always valid and pointing to the app that is performing mentioned
syscalls if it's subject to a v2 cgroup. Also with same motivation of
commit 7723628101aa ("bpf: Introduce bpf_skb_ancestor_cgroup_id helper")
enable retrieval of ancestor from current so the cgroup id can be used
for policy lookups which can then forbid connect() / bind(), for example.

Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
---
 include/linux/bpf.h            |  1 +
 include/uapi/linux/bpf.h       | 21 ++++++++++++++++++++-
 kernel/bpf/core.c              |  1 +
 kernel/bpf/helpers.c           | 18 ++++++++++++++++++
 net/core/filter.c              | 12 ++++++++++++
 tools/include/uapi/linux/bpf.h | 21 ++++++++++++++++++++-
 6 files changed, 72 insertions(+), 2 deletions(-)

diff --git a/include/linux/bpf.h b/include/linux/bpf.h
index 78046c570596..372708eeaecd 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -1501,6 +1501,7 @@ extern const struct bpf_func_proto bpf_get_stack_proto;
 extern const struct bpf_func_proto bpf_sock_map_update_proto;
 extern const struct bpf_func_proto bpf_sock_hash_update_proto;
 extern const struct bpf_func_proto bpf_get_current_cgroup_id_proto;
+extern const struct bpf_func_proto bpf_get_current_ancestor_cgroup_id_proto;
 extern const struct bpf_func_proto bpf_msg_redirect_hash_proto;
 extern const struct bpf_func_proto bpf_msg_redirect_map_proto;
 extern const struct bpf_func_proto bpf_sk_redirect_hash_proto;
diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
index bd81c4555206..222ba11966e3 100644
--- a/include/uapi/linux/bpf.h
+++ b/include/uapi/linux/bpf.h
@@ -2963,6 +2963,24 @@ union bpf_attr {
  * 		instead of sockets.
  * 	Return
  * 		A 8-byte long opaque number.
+ *
+ * u64 bpf_get_current_ancestor_cgroup_id(int ancestor_level)
+ * 	Description
+ * 		Return id of cgroup v2 that is ancestor of the cgroup associated
+ * 		with the current task at the *ancestor_level*. The root cgroup
+ * 		is at *ancestor_level* zero and each step down the hierarchy
+ * 		increments the level. If *ancestor_level* == level of cgroup
+ * 		associated with the current task, then return value will be the
+ * 		same as that of **bpf_get_current_cgroup_id**\ ().
+ *
+ * 		The helper is useful to implement policies based on cgroups
+ * 		that are upper in hierarchy than immediate cgroup associated
+ * 		with the current task.
+ *
+ * 		The format of returned id and helper limitations are same as in
+ * 		**bpf_get_current_cgroup_id**\ ().
+ * 	Return
+ * 		The id is returned or 0 in case the id could not be retrieved.
  */
 #define __BPF_FUNC_MAPPER(FN)		\
 	FN(unspec),			\
@@ -3087,7 +3105,8 @@ union bpf_attr {
 	FN(read_branch_records),	\
 	FN(get_ns_current_pid_tgid),	\
 	FN(xdp_output),			\
-	FN(get_netns_cookie),
+	FN(get_netns_cookie),		\
+	FN(get_current_ancestor_cgroup_id),
 
 /* integer value in 'imm' field of BPF_CALL instruction selects which helper
  * function eBPF program intends to call
diff --git a/kernel/bpf/core.c b/kernel/bpf/core.c
index 914f3463aa41..916f5132a984 100644
--- a/kernel/bpf/core.c
+++ b/kernel/bpf/core.c
@@ -2156,6 +2156,7 @@ const struct bpf_func_proto bpf_get_current_pid_tgid_proto __weak;
 const struct bpf_func_proto bpf_get_current_uid_gid_proto __weak;
 const struct bpf_func_proto bpf_get_current_comm_proto __weak;
 const struct bpf_func_proto bpf_get_current_cgroup_id_proto __weak;
+const struct bpf_func_proto bpf_get_current_ancestor_cgroup_id_proto __weak;
 const struct bpf_func_proto bpf_get_local_storage_proto __weak;
 const struct bpf_func_proto bpf_get_ns_current_pid_tgid_proto __weak;
 
diff --git a/kernel/bpf/helpers.c b/kernel/bpf/helpers.c
index 01878db15eaf..bafc53ddd350 100644
--- a/kernel/bpf/helpers.c
+++ b/kernel/bpf/helpers.c
@@ -340,6 +340,24 @@ const struct bpf_func_proto bpf_get_current_cgroup_id_proto = {
 	.ret_type	= RET_INTEGER,
 };
 
+BPF_CALL_1(bpf_get_current_ancestor_cgroup_id, int, ancestor_level)
+{
+	struct cgroup *cgrp = task_dfl_cgroup(current);
+	struct cgroup *ancestor;
+
+	ancestor = cgroup_ancestor(cgrp, ancestor_level);
+	if (!ancestor)
+		return 0;
+	return cgroup_id(ancestor);
+}
+
+const struct bpf_func_proto bpf_get_current_ancestor_cgroup_id_proto = {
+	.func		= bpf_get_current_ancestor_cgroup_id,
+	.gpl_only	= false,
+	.ret_type	= RET_INTEGER,
+	.arg1_type	= ARG_ANYTHING,
+};
+
 #ifdef CONFIG_CGROUP_BPF
 DECLARE_PER_CPU(struct bpf_cgroup_storage*,
 		bpf_cgroup_storage[MAX_BPF_CGROUP_STORAGE_TYPE]);
diff --git a/net/core/filter.c b/net/core/filter.c
index 3083c7746ee0..5cec3ac9e3dd 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -6018,6 +6018,12 @@ sock_filter_func_proto(enum bpf_func_id func_id, const struct bpf_prog *prog)
 		return &bpf_get_netns_cookie_sock_proto;
 	case BPF_FUNC_perf_event_output:
 		return &bpf_event_output_data_proto;
+#ifdef CONFIG_CGROUPS
+	case BPF_FUNC_get_current_cgroup_id:
+		return &bpf_get_current_cgroup_id_proto;
+	case BPF_FUNC_get_current_ancestor_cgroup_id:
+		return &bpf_get_current_ancestor_cgroup_id_proto;
+#endif
 #ifdef CONFIG_CGROUP_NET_CLASSID
 	case BPF_FUNC_get_cgroup_classid:
 		return &bpf_get_cgroup_classid_curr_proto;
@@ -6052,6 +6058,12 @@ sock_addr_func_proto(enum bpf_func_id func_id, const struct bpf_prog *prog)
 		return &bpf_get_local_storage_proto;
 	case BPF_FUNC_perf_event_output:
 		return &bpf_event_output_data_proto;
+#ifdef CONFIG_CGROUPS
+	case BPF_FUNC_get_current_cgroup_id:
+		return &bpf_get_current_cgroup_id_proto;
+	case BPF_FUNC_get_current_ancestor_cgroup_id:
+		return &bpf_get_current_ancestor_cgroup_id_proto;
+#endif
 #ifdef CONFIG_CGROUP_NET_CLASSID
 	case BPF_FUNC_get_cgroup_classid:
 		return &bpf_get_cgroup_classid_curr_proto;
diff --git a/tools/include/uapi/linux/bpf.h b/tools/include/uapi/linux/bpf.h
index bd81c4555206..222ba11966e3 100644
--- a/tools/include/uapi/linux/bpf.h
+++ b/tools/include/uapi/linux/bpf.h
@@ -2963,6 +2963,24 @@ union bpf_attr {
  * 		instead of sockets.
  * 	Return
  * 		A 8-byte long opaque number.
+ *
+ * u64 bpf_get_current_ancestor_cgroup_id(int ancestor_level)
+ * 	Description
+ * 		Return id of cgroup v2 that is ancestor of the cgroup associated
+ * 		with the current task at the *ancestor_level*. The root cgroup
+ * 		is at *ancestor_level* zero and each step down the hierarchy
+ * 		increments the level. If *ancestor_level* == level of cgroup
+ * 		associated with the current task, then return value will be the
+ * 		same as that of **bpf_get_current_cgroup_id**\ ().
+ *
+ * 		The helper is useful to implement policies based on cgroups
+ * 		that are upper in hierarchy than immediate cgroup associated
+ * 		with the current task.
+ *
+ * 		The format of returned id and helper limitations are same as in
+ * 		**bpf_get_current_cgroup_id**\ ().
+ * 	Return
+ * 		The id is returned or 0 in case the id could not be retrieved.
  */
 #define __BPF_FUNC_MAPPER(FN)		\
 	FN(unspec),			\
@@ -3087,7 +3105,8 @@ union bpf_attr {
 	FN(read_branch_records),	\
 	FN(get_ns_current_pid_tgid),	\
 	FN(xdp_output),			\
-	FN(get_netns_cookie),
+	FN(get_netns_cookie),		\
+	FN(get_current_ancestor_cgroup_id),
 
 /* integer value in 'imm' field of BPF_CALL instruction selects which helper
  * function eBPF program intends to call
-- 
2.21.0

