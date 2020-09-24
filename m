Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 644B82764DD
	for <lists+netdev@lfdr.de>; Thu, 24 Sep 2020 02:03:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726702AbgIXADk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Sep 2020 20:03:40 -0400
Received: from mga02.intel.com ([134.134.136.20]:47251 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726562AbgIXADk (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 23 Sep 2020 20:03:40 -0400
IronPort-SDR: F8mTC3/gw7AHU+beyxyrA6QbpzTnDaZ1wKko4o2xHAORQZE7RXjYeQVEb/EPiSJ+RVGEUSoCr9
 v1/YgKbmLZIQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9753"; a="148711192"
X-IronPort-AV: E=Sophos;i="5.77,296,1596524400"; 
   d="scan'208";a="148711192"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Sep 2020 17:03:37 -0700
IronPort-SDR: LL/A74aNsp524OQpbBHnQ3TABX9ivWDJkKokLWHKONhnby/eL54DJilzBiV06BEm77nmT0X5et
 SQpJozP/a9/g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.77,296,1596524400"; 
   d="scan'208";a="455112184"
Received: from bpujari-bxdsw.sc.intel.com ([10.232.14.242])
  by orsmga004.jf.intel.com with ESMTP; 23 Sep 2020 17:03:31 -0700
From:   bimmy.pujari@intel.com
To:     bpf@vger.kernel.org
Cc:     netdev@vger.kernel.org, mchehab@kernel.org, ast@kernel.org,
        daniel@iogearbox.net, kafai@fb.com, maze@google.com,
        bimmy.pujari@intel.com, ashkan.nikravesh@intel.com
Subject: [PATCH bpf-next v2 1/2] bpf: Add bpf_ktime_get_real_ns
Date:   Wed, 23 Sep 2020 17:03:25 -0700
Message-Id: <20200924000326.8913-1-bimmy.pujari@intel.com>
X-Mailer: git-send-email 2.17.1
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Bimmy Pujari <bimmy.pujari@intel.com>

The existing bpf helper functions to get timestamp return the time
elapsed since system boot. This timestamp is not particularly useful
where epoch timestamp is required or more than one server is involved
and time sync is required. Instead, you want to use CLOCK_REALTIME,
which provides epoch timestamp.
Hence add bfp_ktime_get_real_ns() based around CLOCK_REALTIME.

Signed-off-by: Ashkan Nikravesh <ashkan.nikravesh@intel.com>
Signed-off-by: Bimmy Pujari <bimmy.pujari@intel.com>
---
 drivers/media/rc/bpf-lirc.c    |  2 ++
 include/linux/bpf.h            |  1 +
 include/uapi/linux/bpf.h       |  8 ++++++++
 kernel/bpf/core.c              |  1 +
 kernel/bpf/helpers.c           | 13 +++++++++++++
 kernel/trace/bpf_trace.c       |  2 ++
 tools/include/uapi/linux/bpf.h |  8 ++++++++
 7 files changed, 35 insertions(+)

diff --git a/drivers/media/rc/bpf-lirc.c b/drivers/media/rc/bpf-lirc.c
index 5bb144435c16..1cae0cfdcbaf 100644
--- a/drivers/media/rc/bpf-lirc.c
+++ b/drivers/media/rc/bpf-lirc.c
@@ -103,6 +103,8 @@ lirc_mode2_func_proto(enum bpf_func_id func_id, const struct bpf_prog *prog)
 		return &bpf_map_peek_elem_proto;
 	case BPF_FUNC_ktime_get_ns:
 		return &bpf_ktime_get_ns_proto;
+	case BPF_FUNC_ktime_get_real_ns:
+		return &bpf_ktime_get_real_ns_proto;
 	case BPF_FUNC_ktime_get_boot_ns:
 		return &bpf_ktime_get_boot_ns_proto;
 	case BPF_FUNC_tail_call:
diff --git a/include/linux/bpf.h b/include/linux/bpf.h
index fc5c901c7542..3179fcc4ef53 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -1756,6 +1756,7 @@ extern const struct bpf_func_proto bpf_get_smp_processor_id_proto;
 extern const struct bpf_func_proto bpf_get_numa_node_id_proto;
 extern const struct bpf_func_proto bpf_tail_call_proto;
 extern const struct bpf_func_proto bpf_ktime_get_ns_proto;
+extern const struct bpf_func_proto bpf_ktime_get_real_ns_proto;
 extern const struct bpf_func_proto bpf_ktime_get_boot_ns_proto;
 extern const struct bpf_func_proto bpf_get_current_pid_tgid_proto;
 extern const struct bpf_func_proto bpf_get_current_uid_gid_proto;
diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
index a22812561064..198e69a6508d 100644
--- a/include/uapi/linux/bpf.h
+++ b/include/uapi/linux/bpf.h
@@ -3586,6 +3586,13 @@ union bpf_attr {
  * 		the data in *dst*. This is a wrapper of **copy_from_user**\ ().
  * 	Return
  * 		0 on success, or a negative error in case of failure.
+ *
+ * u64 bpf_ktime_get_real_ns(void)
+ *	Description
+ *		Return the real time in nanoseconds.
+ *		See: **clock_gettime**\ (**CLOCK_REALTIME**)
+ *	Return
+ *		Current *ktime*.
  */
 #define __BPF_FUNC_MAPPER(FN)		\
 	FN(unspec),			\
@@ -3737,6 +3744,7 @@ union bpf_attr {
 	FN(inode_storage_delete),	\
 	FN(d_path),			\
 	FN(copy_from_user),		\
+	FN(ktime_get_real_ns),		\
 	/* */
 
 /* integer value in 'imm' field of BPF_CALL instruction selects which helper
diff --git a/kernel/bpf/core.c b/kernel/bpf/core.c
index c4811b139caa..af38af5ffc8b 100644
--- a/kernel/bpf/core.c
+++ b/kernel/bpf/core.c
@@ -2207,6 +2207,7 @@ const struct bpf_func_proto bpf_get_prandom_u32_proto __weak;
 const struct bpf_func_proto bpf_get_smp_processor_id_proto __weak;
 const struct bpf_func_proto bpf_get_numa_node_id_proto __weak;
 const struct bpf_func_proto bpf_ktime_get_ns_proto __weak;
+const struct bpf_func_proto bpf_ktime_get_real_ns_proto __weak;
 const struct bpf_func_proto bpf_ktime_get_boot_ns_proto __weak;
 
 const struct bpf_func_proto bpf_get_current_pid_tgid_proto __weak;
diff --git a/kernel/bpf/helpers.c b/kernel/bpf/helpers.c
index 5cc7425ee476..776ff58f969d 100644
--- a/kernel/bpf/helpers.c
+++ b/kernel/bpf/helpers.c
@@ -155,6 +155,17 @@ const struct bpf_func_proto bpf_ktime_get_ns_proto = {
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
+	.gpl_only	= true,
+	.ret_type	= RET_INTEGER,
+};
 BPF_CALL_0(bpf_ktime_get_boot_ns)
 {
 	/* NMI safe access to clock boottime */
@@ -655,6 +666,8 @@ bpf_base_func_proto(enum bpf_func_id func_id)
 		return &bpf_tail_call_proto;
 	case BPF_FUNC_ktime_get_ns:
 		return &bpf_ktime_get_ns_proto;
+	case BPF_FUNC_ktime_get_real_ns:
+		return &bpf_ktime_get_real_ns_proto;
 	case BPF_FUNC_ktime_get_boot_ns:
 		return &bpf_ktime_get_boot_ns_proto;
 	case BPF_FUNC_ringbuf_output:
diff --git a/kernel/trace/bpf_trace.c b/kernel/trace/bpf_trace.c
index 36508f46a8db..18b644fff0be 100644
--- a/kernel/trace/bpf_trace.c
+++ b/kernel/trace/bpf_trace.c
@@ -1165,6 +1165,8 @@ bpf_tracing_func_proto(enum bpf_func_id func_id, const struct bpf_prog *prog)
 		return &bpf_map_peek_elem_proto;
 	case BPF_FUNC_ktime_get_ns:
 		return &bpf_ktime_get_ns_proto;
+	case BPF_FUNC_ktime_get_real_ns:
+		return &bpf_ktime_get_real_ns_proto;
 	case BPF_FUNC_ktime_get_boot_ns:
 		return &bpf_ktime_get_boot_ns_proto;
 	case BPF_FUNC_tail_call:
diff --git a/tools/include/uapi/linux/bpf.h b/tools/include/uapi/linux/bpf.h
index a22812561064..198e69a6508d 100644
--- a/tools/include/uapi/linux/bpf.h
+++ b/tools/include/uapi/linux/bpf.h
@@ -3586,6 +3586,13 @@ union bpf_attr {
  * 		the data in *dst*. This is a wrapper of **copy_from_user**\ ().
  * 	Return
  * 		0 on success, or a negative error in case of failure.
+ *
+ * u64 bpf_ktime_get_real_ns(void)
+ *	Description
+ *		Return the real time in nanoseconds.
+ *		See: **clock_gettime**\ (**CLOCK_REALTIME**)
+ *	Return
+ *		Current *ktime*.
  */
 #define __BPF_FUNC_MAPPER(FN)		\
 	FN(unspec),			\
@@ -3737,6 +3744,7 @@ union bpf_attr {
 	FN(inode_storage_delete),	\
 	FN(d_path),			\
 	FN(copy_from_user),		\
+	FN(ktime_get_real_ns),		\
 	/* */
 
 /* integer value in 'imm' field of BPF_CALL instruction selects which helper
-- 
2.17.1

