Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 72C8922FE0F
	for <lists+netdev@lfdr.de>; Tue, 28 Jul 2020 01:34:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727932AbgG0Xej (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Jul 2020 19:34:39 -0400
Received: from mga03.intel.com ([134.134.136.65]:2661 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726196AbgG0Xej (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 27 Jul 2020 19:34:39 -0400
IronPort-SDR: V5nYvnDaDS4M34mI8xtTzVL37UgigvQDqkb5zHZvgUUbNl5WD4x4povFiQPUnzpeiWz4puVeAn
 D349fKNwug9w==
X-IronPort-AV: E=McAfee;i="6000,8403,9695"; a="151110405"
X-IronPort-AV: E=Sophos;i="5.75,404,1589266800"; 
   d="scan'208";a="151110405"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Jul 2020 16:34:38 -0700
IronPort-SDR: Go9d5qre4tCQcaCT99xQA/F4xyr9dL0gUxdm28/kxTA8BxoKSWnvJ+RWhyuEbOBtI8tfbGpeip
 OX4xpl6G8I8w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,404,1589266800"; 
   d="scan'208";a="289974188"
Received: from bpujari-bxdsw.sc.intel.com ([10.232.14.242])
  by orsmga006.jf.intel.com with ESMTP; 27 Jul 2020 16:34:38 -0700
From:   bimmy.pujari@intel.com
To:     bpf@vger.kernel.org
Cc:     netdev@vger.kernel.org, mchehab@kernel.org, ast@kernel.org,
        daniel@iogearbox.net, kafai@fb.com, maze@google.com,
        bimmy.pujari@intel.com, ashkan.nikravesh@intel.com
Subject: [PATCH] bpf: Add bpf_ktime_get_real_ns
Date:   Mon, 27 Jul 2020 16:34:31 -0700
Message-Id: <20200727233431.4103-1-bimmy.pujari@intel.com>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ashkan Nikravesh <ashkan.nikravesh@intel.com>

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
 include/uapi/linux/bpf.h       |  7 +++++++
 kernel/bpf/core.c              |  1 +
 kernel/bpf/helpers.c           | 14 ++++++++++++++
 kernel/trace/bpf_trace.c       |  2 ++
 tools/include/uapi/linux/bpf.h |  7 +++++++
 7 files changed, 34 insertions(+)

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
index 72221aea1c60..9c00ad932f08 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -1639,6 +1639,7 @@ extern const struct bpf_func_proto bpf_get_numa_node_id_proto;
 extern const struct bpf_func_proto bpf_tail_call_proto;
 extern const struct bpf_func_proto bpf_ktime_get_ns_proto;
 extern const struct bpf_func_proto bpf_ktime_get_boot_ns_proto;
+extern const struct bpf_func_proto bpf_ktime_get_real_ns_proto;
 extern const struct bpf_func_proto bpf_get_current_pid_tgid_proto;
 extern const struct bpf_func_proto bpf_get_current_uid_gid_proto;
 extern const struct bpf_func_proto bpf_get_current_comm_proto;
diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
index 54d0c886e3ba..7742c10fbc95 100644
--- a/include/uapi/linux/bpf.h
+++ b/include/uapi/linux/bpf.h
@@ -3377,6 +3377,12 @@ union bpf_attr {
  *		A non-negative value equal to or less than *size* on success,
  *		or a negative error in case of failure.
  *
+ * u64 bpf_ktime_get_real_ns(void)
+ *      Description
+ *              Return the real time in nanoseconds.
+ *              See: **clock_gettime**\ (**CLOCK_REALTIME**)
+ *      Return
+ *              Current *ktime*.
  */
 #define __BPF_FUNC_MAPPER(FN)		\
 	FN(unspec),			\
@@ -3521,6 +3527,7 @@ union bpf_attr {
 	FN(skc_to_tcp_request_sock),	\
 	FN(skc_to_udp6_sock),		\
 	FN(get_task_stack),		\
+	FN(ktime_get_real_ns),		\
 	/* */
 
 /* integer value in 'imm' field of BPF_CALL instruction selects which helper
diff --git a/kernel/bpf/core.c b/kernel/bpf/core.c
index 7be02e555ab9..0f25f3413208 100644
--- a/kernel/bpf/core.c
+++ b/kernel/bpf/core.c
@@ -2211,6 +2211,7 @@ const struct bpf_func_proto bpf_get_prandom_u32_proto __weak;
 const struct bpf_func_proto bpf_get_smp_processor_id_proto __weak;
 const struct bpf_func_proto bpf_get_numa_node_id_proto __weak;
 const struct bpf_func_proto bpf_ktime_get_ns_proto __weak;
+const struct bpf_func_proto bpf_ktime_get_real_ns_proto __weak;
 const struct bpf_func_proto bpf_ktime_get_boot_ns_proto __weak;
 
 const struct bpf_func_proto bpf_get_current_pid_tgid_proto __weak;
diff --git a/kernel/bpf/helpers.c b/kernel/bpf/helpers.c
index be43ab3e619f..b726fd077698 100644
--- a/kernel/bpf/helpers.c
+++ b/kernel/bpf/helpers.c
@@ -155,6 +155,18 @@ const struct bpf_func_proto bpf_ktime_get_ns_proto = {
 	.ret_type	= RET_INTEGER,
 };
 
+BPF_CALL_0(bpf_ktime_get_real_ns)
+{
+	/* NMI safe access to clock realtime */
+	return ktime_get_real_fast_ns();
+}
+
+const struct bpf_func_proto bpf_ktime_get_real_ns_proto = {
+	.func           = bpf_ktime_get_real_ns,
+	.gpl_only       = true,
+	.ret_type       = RET_INTEGER,
+};
+
 BPF_CALL_0(bpf_ktime_get_boot_ns)
 {
 	/* NMI safe access to clock boottime */
@@ -633,6 +645,8 @@ bpf_base_func_proto(enum bpf_func_id func_id)
 		return &bpf_tail_call_proto;
 	case BPF_FUNC_ktime_get_ns:
 		return &bpf_ktime_get_ns_proto;
+	case BPF_FUNC_ktime_get_real_ns:
+		return &bpf_ktime_get_real_ns_proto;
 	case BPF_FUNC_ktime_get_boot_ns:
 		return &bpf_ktime_get_boot_ns_proto;
 	case BPF_FUNC_ringbuf_output:
diff --git a/kernel/trace/bpf_trace.c b/kernel/trace/bpf_trace.c
index 3cc0dcb60ca2..4e048dfb527b 100644
--- a/kernel/trace/bpf_trace.c
+++ b/kernel/trace/bpf_trace.c
@@ -1116,6 +1116,8 @@ bpf_tracing_func_proto(enum bpf_func_id func_id, const struct bpf_prog *prog)
 		return &bpf_map_peek_elem_proto;
 	case BPF_FUNC_ktime_get_ns:
 		return &bpf_ktime_get_ns_proto;
+	case BPF_FUNC_ktime_get_real_ns:
+		return &bpf_ktime_get_real_ns_proto;
 	case BPF_FUNC_ktime_get_boot_ns:
 		return &bpf_ktime_get_boot_ns_proto;
 	case BPF_FUNC_tail_call:
diff --git a/tools/include/uapi/linux/bpf.h b/tools/include/uapi/linux/bpf.h
index 54d0c886e3ba..9ca51f82dd35 100644
--- a/tools/include/uapi/linux/bpf.h
+++ b/tools/include/uapi/linux/bpf.h
@@ -3377,6 +3377,12 @@ union bpf_attr {
  *		A non-negative value equal to or less than *size* on success,
  *		or a negative error in case of failure.
  *
+ * u64 bpf_ktime_get_real_ns(void)
+ *	Description
+ *		Return the real time in nanoseconds.
+ *		See: **clock_gettime**\ (**CLOCK_REALTIME**)
+ *	Return
+ *		Current *ktime*.
  */
 #define __BPF_FUNC_MAPPER(FN)		\
 	FN(unspec),			\
@@ -3521,6 +3527,7 @@ union bpf_attr {
 	FN(skc_to_tcp_request_sock),	\
 	FN(skc_to_udp6_sock),		\
 	FN(get_task_stack),		\
+	FN(ktime_get_real_ns),		\
 	/* */
 
 /* integer value in 'imm' field of BPF_CALL instruction selects which helper
-- 
2.17.1

