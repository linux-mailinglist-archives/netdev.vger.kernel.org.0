Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0547E27F7A7
	for <lists+netdev@lfdr.de>; Thu,  1 Oct 2020 04:04:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730090AbgJACEw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Sep 2020 22:04:52 -0400
Received: from mga09.intel.com ([134.134.136.24]:64120 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725823AbgJACEw (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 30 Sep 2020 22:04:52 -0400
IronPort-SDR: n9147HOjfISB/5txvCnJvdaGLW75SaaqGsisggtJC07VV9Mzn/+d5U+6yOqWpUBhfq26yUpzQj
 qiJumA9n/xcw==
X-IronPort-AV: E=McAfee;i="6000,8403,9760"; a="163461335"
X-IronPort-AV: E=Sophos;i="5.77,323,1596524400"; 
   d="scan'208";a="163461335"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Sep 2020 19:04:40 -0700
IronPort-SDR: 6aZfDcUBxvGhUSgydplh2rjZtBEZ+gZZIG9wx/1wUgg1f6Pvt1TbSdE/a3r6r3sDfhFLCj/iCF
 VjLsbtfbi/Lg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.77,323,1596524400"; 
   d="scan'208";a="351758851"
Received: from bpujari-bxdsw.sc.intel.com ([10.232.14.242])
  by orsmga007.jf.intel.com with ESMTP; 30 Sep 2020 19:04:39 -0700
From:   bimmy.pujari@intel.com
To:     bpf@vger.kernel.org
Cc:     netdev@vger.kernel.org, mchehab@kernel.org, ast@kernel.org,
        daniel@iogearbox.net, kafai@fb.com, maze@google.com,
        bimmy.pujari@intel.com, ashkan.nikravesh@intel.com,
        Daniel.A.Alvarez@intel.com
Subject: [PATCH bpf-next v7 1/2] bpf: Add bpf_ktime_get_real_ns
Date:   Wed, 30 Sep 2020 19:05:03 -0700
Message-Id: <20201001020504.18151-1-bimmy.pujari@intel.com>
X-Mailer: git-send-email 2.17.1
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Bimmy Pujari <bimmy.pujari@intel.com>

The existing bpf helper functions to get timestamp return the time
elapsed since system boot. This timestamp is not particularly useful
where epoch timestamp is required or more than one server is involved
and time sync is required. Instead, you want to use CLOCK_REALTIME,
which provides epoch timestamp. Hence adding a new helper
bfp_ktime_get_real_ns() based around CLOCK_REALTIME.

Signed-off-by: Ashkan Nikravesh <ashkan.nikravesh@intel.com>
Signed-off-by: Bimmy Pujari <bimmy.pujari@intel.com>
---
 drivers/media/rc/bpf-lirc.c    |  2 ++
 include/linux/bpf.h            |  1 +
 include/uapi/linux/bpf.h       | 11 +++++++++++
 kernel/bpf/core.c              |  1 +
 kernel/bpf/helpers.c           | 14 ++++++++++++++
 kernel/trace/bpf_trace.c       |  2 ++
 tools/include/uapi/linux/bpf.h | 11 +++++++++++
 7 files changed, 42 insertions(+)

diff --git a/drivers/media/rc/bpf-lirc.c b/drivers/media/rc/bpf-lirc.c
index 3fe3edd80876..fe0fd07a473f 100644
--- a/drivers/media/rc/bpf-lirc.c
+++ b/drivers/media/rc/bpf-lirc.c
@@ -105,6 +105,8 @@ lirc_mode2_func_proto(enum bpf_func_id func_id, const struct bpf_prog *prog)
 		return &bpf_ktime_get_ns_proto;
 	case BPF_FUNC_ktime_get_boot_ns:
 		return &bpf_ktime_get_boot_ns_proto;
+	case BPF_FUNC_ktime_get_real_ns:
+		return &bpf_ktime_get_real_ns_proto;
 	case BPF_FUNC_tail_call:
 		return &bpf_tail_call_proto;
 	case BPF_FUNC_get_prandom_u32:
diff --git a/include/linux/bpf.h b/include/linux/bpf.h
index 50e5c4b52bd1..01866d714438 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -1791,6 +1791,7 @@ extern const struct bpf_func_proto bpf_get_numa_node_id_proto;
 extern const struct bpf_func_proto bpf_tail_call_proto;
 extern const struct bpf_func_proto bpf_ktime_get_ns_proto;
 extern const struct bpf_func_proto bpf_ktime_get_boot_ns_proto;
+extern const struct bpf_func_proto bpf_ktime_get_real_ns_proto;
 extern const struct bpf_func_proto bpf_get_current_pid_tgid_proto;
 extern const struct bpf_func_proto bpf_get_current_uid_gid_proto;
 extern const struct bpf_func_proto bpf_get_current_comm_proto;
diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
index 1f17c6752deb..f944d9a14137 100644
--- a/include/uapi/linux/bpf.h
+++ b/include/uapi/linux/bpf.h
@@ -3665,6 +3665,16 @@ union bpf_attr {
  * 	Return
  * 		The helper returns **TC_ACT_REDIRECT** on success or
  * 		**TC_ACT_SHOT** on error.
+ *
+ * u64 bpf_ktime_get_real_ns(void)
+ *	Description
+ *		Return the real time since epoch in nanoseconds.
+ *		See: **clock_gettime**\ (**CLOCK_REALTIME**)
+ *
+ *		As REALCLOCK can jump around, this helper should not be used to
+ *		measure passage of time.
+ *	Return
+ *		Current *ktime*.
  */
 #define __BPF_FUNC_MAPPER(FN)		\
 	FN(unspec),			\
@@ -3820,6 +3830,7 @@ union bpf_attr {
 	FN(seq_printf_btf),		\
 	FN(skb_cgroup_classid),		\
 	FN(redirect_neigh),		\
+	FN(ktime_get_real_ns),		\
 	/* */
 
 /* integer value in 'imm' field of BPF_CALL instruction selects which helper
diff --git a/kernel/bpf/core.c b/kernel/bpf/core.c
index cda674f1392f..7fb353ccb8ae 100644
--- a/kernel/bpf/core.c
+++ b/kernel/bpf/core.c
@@ -2211,6 +2211,7 @@ const struct bpf_func_proto bpf_get_smp_processor_id_proto __weak;
 const struct bpf_func_proto bpf_get_numa_node_id_proto __weak;
 const struct bpf_func_proto bpf_ktime_get_ns_proto __weak;
 const struct bpf_func_proto bpf_ktime_get_boot_ns_proto __weak;
+const struct bpf_func_proto bpf_ktime_get_real_ns_proto __weak;
 
 const struct bpf_func_proto bpf_get_current_pid_tgid_proto __weak;
 const struct bpf_func_proto bpf_get_current_uid_gid_proto __weak;
diff --git a/kernel/bpf/helpers.c b/kernel/bpf/helpers.c
index e825441781ab..0fefcd076d7b 100644
--- a/kernel/bpf/helpers.c
+++ b/kernel/bpf/helpers.c
@@ -167,6 +167,18 @@ const struct bpf_func_proto bpf_ktime_get_boot_ns_proto = {
 	.ret_type	= RET_INTEGER,
 };
 
+BPF_CALL_0(bpf_ktime_get_real_ns)
+{
+	/* NMI safe access to clock realtime */
+	return ktime_get_real_fast_ns();
+}
+
+const struct bpf_func_proto bpf_ktime_get_real_ns_proto = {
+	.func		= bpf_ktime_get_real_ns,
+	.gpl_only	= false,
+	.ret_type	= RET_INTEGER,
+};
+
 BPF_CALL_0(bpf_get_current_pid_tgid)
 {
 	struct task_struct *task = current;
@@ -657,6 +669,8 @@ bpf_base_func_proto(enum bpf_func_id func_id)
 		return &bpf_ktime_get_ns_proto;
 	case BPF_FUNC_ktime_get_boot_ns:
 		return &bpf_ktime_get_boot_ns_proto;
+	case BPF_FUNC_ktime_get_real_ns:
+		return &bpf_ktime_get_real_ns_proto;
 	case BPF_FUNC_ringbuf_output:
 		return &bpf_ringbuf_output_proto;
 	case BPF_FUNC_ringbuf_reserve:
diff --git a/kernel/trace/bpf_trace.c b/kernel/trace/bpf_trace.c
index e118a83439c3..1ee1c29cb711 100644
--- a/kernel/trace/bpf_trace.c
+++ b/kernel/trace/bpf_trace.c
@@ -1259,6 +1259,8 @@ bpf_tracing_func_proto(enum bpf_func_id func_id, const struct bpf_prog *prog)
 		return &bpf_ktime_get_ns_proto;
 	case BPF_FUNC_ktime_get_boot_ns:
 		return &bpf_ktime_get_boot_ns_proto;
+	case BPF_FUNC_ktime_get_real_ns:
+		return &bpf_ktime_get_real_ns_proto;
 	case BPF_FUNC_tail_call:
 		return &bpf_tail_call_proto;
 	case BPF_FUNC_get_current_pid_tgid:
diff --git a/tools/include/uapi/linux/bpf.h b/tools/include/uapi/linux/bpf.h
index 1f17c6752deb..f944d9a14137 100644
--- a/tools/include/uapi/linux/bpf.h
+++ b/tools/include/uapi/linux/bpf.h
@@ -3665,6 +3665,16 @@ union bpf_attr {
  * 	Return
  * 		The helper returns **TC_ACT_REDIRECT** on success or
  * 		**TC_ACT_SHOT** on error.
+ *
+ * u64 bpf_ktime_get_real_ns(void)
+ *	Description
+ *		Return the real time since epoch in nanoseconds.
+ *		See: **clock_gettime**\ (**CLOCK_REALTIME**)
+ *
+ *		As REALCLOCK can jump around, this helper should not be used to
+ *		measure passage of time.
+ *	Return
+ *		Current *ktime*.
  */
 #define __BPF_FUNC_MAPPER(FN)		\
 	FN(unspec),			\
@@ -3820,6 +3830,7 @@ union bpf_attr {
 	FN(seq_printf_btf),		\
 	FN(skb_cgroup_classid),		\
 	FN(redirect_neigh),		\
+	FN(ktime_get_real_ns),		\
 	/* */
 
 /* integer value in 'imm' field of BPF_CALL instruction selects which helper
-- 
2.17.1

