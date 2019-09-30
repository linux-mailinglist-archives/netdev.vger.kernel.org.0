Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BD6B9C26B6
	for <lists+netdev@lfdr.de>; Mon, 30 Sep 2019 22:40:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730827AbfI3Ujb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Sep 2019 16:39:31 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:5034 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729738AbfI3Ujb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Sep 2019 16:39:31 -0400
Received: from pps.filterd (m0089730.ppops.net [127.0.0.1])
        by m0089730.ppops.net (8.16.0.42/8.16.0.42) with SMTP id x8UIqkWu026612
        for <netdev@vger.kernel.org>; Mon, 30 Sep 2019 11:59:10 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-type; s=facebook; bh=QJi8gkYRQdUGM8yANELU4OGbdIwDb5ZvlIeUH4WRhXU=;
 b=jVbzclK3zlLlQREB03ex31k2mPc1lYeJC5Piw39vU+FQHXGPiNEIPVNfbkM8+ZiqQorK
 YD0juH3g56uUlB/bK4q+4EN0CUHghmGS5hvu81w3FqMDxvDCFjk2MYlCOUzd4seoVyxB
 enVYPUEOji5ANPR439CQt/zD47twXczSfXM= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by m0089730.ppops.net with ESMTP id 2vbq6g82g3-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Mon, 30 Sep 2019 11:59:10 -0700
Received: from mx-out.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:83::6) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Mon, 30 Sep 2019 11:59:08 -0700
Received: by dev101.prn2.facebook.com (Postfix, from userid 137359)
        id D4EFE86185A; Mon, 30 Sep 2019 11:59:04 -0700 (PDT)
Smtp-Origin-Hostprefix: dev
From:   Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Hostname: dev101.prn2.facebook.com
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>
CC:     <andrii.nakryiko@gmail.com>, <kernel-team@fb.com>,
        Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Cluster: prn2c23
Subject: [PATCH bpf-next 2/6] libbpf: move bpf_helpers.h, bpf_endian.h into libbpf
Date:   Mon, 30 Sep 2019 11:58:51 -0700
Message-ID: <20190930185855.4115372-3-andriin@fb.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190930185855.4115372-1-andriin@fb.com>
References: <20190930185855.4115372-1-andriin@fb.com>
X-FB-Internal: Safe
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,1.0.8
 definitions=2019-09-30_11:2019-09-30,2019-09-30 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 bulkscore=0 spamscore=0
 clxscore=1015 suspectscore=8 phishscore=0 adultscore=0 lowpriorityscore=0
 malwarescore=0 impostorscore=0 mlxscore=0 mlxlogscore=999
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1908290000 definitions=main-1909300167
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Make bpf_helpers.h and bpf_endian.h official part of libbpf. Ensure they
are installed along the other libbpf headers.

Signed-off-by: Andrii Nakryiko <andriin@fb.com>
---
 tools/lib/bpf/Makefile      |   4 +-
 tools/lib/bpf/bpf_endian.h  |  72 +++++
 tools/lib/bpf/bpf_helpers.h | 527 ++++++++++++++++++++++++++++++++++++
 3 files changed, 602 insertions(+), 1 deletion(-)
 create mode 100644 tools/lib/bpf/bpf_endian.h
 create mode 100644 tools/lib/bpf/bpf_helpers.h

diff --git a/tools/lib/bpf/Makefile b/tools/lib/bpf/Makefile
index c6f94cffe06e..2ff345981803 100644
--- a/tools/lib/bpf/Makefile
+++ b/tools/lib/bpf/Makefile
@@ -240,7 +240,9 @@ install_headers:
 		$(call do_install,libbpf.h,$(prefix)/include/bpf,644); \
 		$(call do_install,btf.h,$(prefix)/include/bpf,644); \
 		$(call do_install,libbpf_util.h,$(prefix)/include/bpf,644); \
-		$(call do_install,xsk.h,$(prefix)/include/bpf,644);
+		$(call do_install,xsk.h,$(prefix)/include/bpf,644); \
+		$(call do_install,bpf_helpers.h,$(prefix)/include/bpf,644); \
+		$(call do_install,bpf_endian.h,$(prefix)/include/bpf,644);
 
 install_pkgconfig: $(PC_FILE)
 	$(call QUIET_INSTALL, $(PC_FILE)) \
diff --git a/tools/lib/bpf/bpf_endian.h b/tools/lib/bpf/bpf_endian.h
new file mode 100644
index 000000000000..fbe28008450f
--- /dev/null
+++ b/tools/lib/bpf/bpf_endian.h
@@ -0,0 +1,72 @@
+/* SPDX-License-Identifier: (LGPL-2.1 OR BSD-2-Clause) */
+#ifndef __BPF_ENDIAN__
+#define __BPF_ENDIAN__
+
+#include <linux/stddef.h>
+#include <linux/swab.h>
+
+/* LLVM's BPF target selects the endianness of the CPU
+ * it compiles on, or the user specifies (bpfel/bpfeb),
+ * respectively. The used __BYTE_ORDER__ is defined by
+ * the compiler, we cannot rely on __BYTE_ORDER from
+ * libc headers, since it doesn't reflect the actual
+ * requested byte order.
+ *
+ * Note, LLVM's BPF target has different __builtin_bswapX()
+ * semantics. It does map to BPF_ALU | BPF_END | BPF_TO_BE
+ * in bpfel and bpfeb case, which means below, that we map
+ * to cpu_to_be16(). We could use it unconditionally in BPF
+ * case, but better not rely on it, so that this header here
+ * can be used from application and BPF program side, which
+ * use different targets.
+ */
+#if __BYTE_ORDER__ == __ORDER_LITTLE_ENDIAN__
+# define __bpf_ntohs(x)			__builtin_bswap16(x)
+# define __bpf_htons(x)			__builtin_bswap16(x)
+# define __bpf_constant_ntohs(x)	___constant_swab16(x)
+# define __bpf_constant_htons(x)	___constant_swab16(x)
+# define __bpf_ntohl(x)			__builtin_bswap32(x)
+# define __bpf_htonl(x)			__builtin_bswap32(x)
+# define __bpf_constant_ntohl(x)	___constant_swab32(x)
+# define __bpf_constant_htonl(x)	___constant_swab32(x)
+# define __bpf_be64_to_cpu(x)		__builtin_bswap64(x)
+# define __bpf_cpu_to_be64(x)		__builtin_bswap64(x)
+# define __bpf_constant_be64_to_cpu(x)	___constant_swab64(x)
+# define __bpf_constant_cpu_to_be64(x)	___constant_swab64(x)
+#elif __BYTE_ORDER__ == __ORDER_BIG_ENDIAN__
+# define __bpf_ntohs(x)			(x)
+# define __bpf_htons(x)			(x)
+# define __bpf_constant_ntohs(x)	(x)
+# define __bpf_constant_htons(x)	(x)
+# define __bpf_ntohl(x)			(x)
+# define __bpf_htonl(x)			(x)
+# define __bpf_constant_ntohl(x)	(x)
+# define __bpf_constant_htonl(x)	(x)
+# define __bpf_be64_to_cpu(x)		(x)
+# define __bpf_cpu_to_be64(x)		(x)
+# define __bpf_constant_be64_to_cpu(x)  (x)
+# define __bpf_constant_cpu_to_be64(x)  (x)
+#else
+# error "Fix your compiler's __BYTE_ORDER__?!"
+#endif
+
+#define bpf_htons(x)				\
+	(__builtin_constant_p(x) ?		\
+	 __bpf_constant_htons(x) : __bpf_htons(x))
+#define bpf_ntohs(x)				\
+	(__builtin_constant_p(x) ?		\
+	 __bpf_constant_ntohs(x) : __bpf_ntohs(x))
+#define bpf_htonl(x)				\
+	(__builtin_constant_p(x) ?		\
+	 __bpf_constant_htonl(x) : __bpf_htonl(x))
+#define bpf_ntohl(x)				\
+	(__builtin_constant_p(x) ?		\
+	 __bpf_constant_ntohl(x) : __bpf_ntohl(x))
+#define bpf_cpu_to_be64(x)			\
+	(__builtin_constant_p(x) ?		\
+	 __bpf_constant_cpu_to_be64(x) : __bpf_cpu_to_be64(x))
+#define bpf_be64_to_cpu(x)			\
+	(__builtin_constant_p(x) ?		\
+	 __bpf_constant_be64_to_cpu(x) : __bpf_be64_to_cpu(x))
+
+#endif /* __BPF_ENDIAN__ */
diff --git a/tools/lib/bpf/bpf_helpers.h b/tools/lib/bpf/bpf_helpers.h
new file mode 100644
index 000000000000..a1d9b97b8e15
--- /dev/null
+++ b/tools/lib/bpf/bpf_helpers.h
@@ -0,0 +1,527 @@
+/* SPDX-License-Identifier: (LGPL-2.1 OR BSD-2-Clause) */
+#ifndef __BPF_HELPERS__
+#define __BPF_HELPERS__
+
+#define __uint(name, val) int (*name)[val]
+#define __type(name, val) val *name
+
+/* helper macro to print out debug messages */
+#define bpf_printk(fmt, ...)				\
+({							\
+	char ____fmt[] = fmt;				\
+	bpf_trace_printk(____fmt, sizeof(____fmt),	\
+			 ##__VA_ARGS__);		\
+})
+
+/* helper macro to place programs, maps, license in
+ * different sections in elf_bpf file. Section names
+ * are interpreted by elf_bpf loader
+ */
+#define SEC(NAME) __attribute__((section(NAME), used))
+
+/* helper functions called from eBPF programs written in C */
+static void *(*bpf_map_lookup_elem)(void *map, const void *key) =
+	(void *) BPF_FUNC_map_lookup_elem;
+static int (*bpf_map_update_elem)(void *map, const void *key, const void *value,
+				  unsigned long long flags) =
+	(void *) BPF_FUNC_map_update_elem;
+static int (*bpf_map_delete_elem)(void *map, const void *key) =
+	(void *) BPF_FUNC_map_delete_elem;
+static int (*bpf_map_push_elem)(void *map, const void *value,
+				unsigned long long flags) =
+	(void *) BPF_FUNC_map_push_elem;
+static int (*bpf_map_pop_elem)(void *map, void *value) =
+	(void *) BPF_FUNC_map_pop_elem;
+static int (*bpf_map_peek_elem)(void *map, void *value) =
+	(void *) BPF_FUNC_map_peek_elem;
+static int (*bpf_probe_read)(void *dst, int size, const void *unsafe_ptr) =
+	(void *) BPF_FUNC_probe_read;
+static unsigned long long (*bpf_ktime_get_ns)(void) =
+	(void *) BPF_FUNC_ktime_get_ns;
+static int (*bpf_trace_printk)(const char *fmt, int fmt_size, ...) =
+	(void *) BPF_FUNC_trace_printk;
+static void (*bpf_tail_call)(void *ctx, void *map, int index) =
+	(void *) BPF_FUNC_tail_call;
+static unsigned long long (*bpf_get_smp_processor_id)(void) =
+	(void *) BPF_FUNC_get_smp_processor_id;
+static unsigned long long (*bpf_get_current_pid_tgid)(void) =
+	(void *) BPF_FUNC_get_current_pid_tgid;
+static unsigned long long (*bpf_get_current_uid_gid)(void) =
+	(void *) BPF_FUNC_get_current_uid_gid;
+static int (*bpf_get_current_comm)(void *buf, int buf_size) =
+	(void *) BPF_FUNC_get_current_comm;
+static unsigned long long (*bpf_perf_event_read)(void *map,
+						 unsigned long long flags) =
+	(void *) BPF_FUNC_perf_event_read;
+static int (*bpf_clone_redirect)(void *ctx, int ifindex, int flags) =
+	(void *) BPF_FUNC_clone_redirect;
+static int (*bpf_redirect)(int ifindex, int flags) =
+	(void *) BPF_FUNC_redirect;
+static int (*bpf_redirect_map)(void *map, int key, int flags) =
+	(void *) BPF_FUNC_redirect_map;
+static int (*bpf_perf_event_output)(void *ctx, void *map,
+				    unsigned long long flags, void *data,
+				    int size) =
+	(void *) BPF_FUNC_perf_event_output;
+static int (*bpf_get_stackid)(void *ctx, void *map, int flags) =
+	(void *) BPF_FUNC_get_stackid;
+static int (*bpf_probe_write_user)(void *dst, const void *src, int size) =
+	(void *) BPF_FUNC_probe_write_user;
+static int (*bpf_current_task_under_cgroup)(void *map, int index) =
+	(void *) BPF_FUNC_current_task_under_cgroup;
+static int (*bpf_skb_get_tunnel_key)(void *ctx, void *key, int size, int flags) =
+	(void *) BPF_FUNC_skb_get_tunnel_key;
+static int (*bpf_skb_set_tunnel_key)(void *ctx, void *key, int size, int flags) =
+	(void *) BPF_FUNC_skb_set_tunnel_key;
+static int (*bpf_skb_get_tunnel_opt)(void *ctx, void *md, int size) =
+	(void *) BPF_FUNC_skb_get_tunnel_opt;
+static int (*bpf_skb_set_tunnel_opt)(void *ctx, void *md, int size) =
+	(void *) BPF_FUNC_skb_set_tunnel_opt;
+static unsigned long long (*bpf_get_prandom_u32)(void) =
+	(void *) BPF_FUNC_get_prandom_u32;
+static int (*bpf_xdp_adjust_head)(void *ctx, int offset) =
+	(void *) BPF_FUNC_xdp_adjust_head;
+static int (*bpf_xdp_adjust_meta)(void *ctx, int offset) =
+	(void *) BPF_FUNC_xdp_adjust_meta;
+static int (*bpf_get_socket_cookie)(void *ctx) =
+	(void *) BPF_FUNC_get_socket_cookie;
+static int (*bpf_setsockopt)(void *ctx, int level, int optname, void *optval,
+			     int optlen) =
+	(void *) BPF_FUNC_setsockopt;
+static int (*bpf_getsockopt)(void *ctx, int level, int optname, void *optval,
+			     int optlen) =
+	(void *) BPF_FUNC_getsockopt;
+static int (*bpf_sock_ops_cb_flags_set)(void *ctx, int flags) =
+	(void *) BPF_FUNC_sock_ops_cb_flags_set;
+static int (*bpf_sk_redirect_map)(void *ctx, void *map, int key, int flags) =
+	(void *) BPF_FUNC_sk_redirect_map;
+static int (*bpf_sk_redirect_hash)(void *ctx, void *map, void *key, int flags) =
+	(void *) BPF_FUNC_sk_redirect_hash;
+static int (*bpf_sock_map_update)(void *map, void *key, void *value,
+				  unsigned long long flags) =
+	(void *) BPF_FUNC_sock_map_update;
+static int (*bpf_sock_hash_update)(void *map, void *key, void *value,
+				   unsigned long long flags) =
+	(void *) BPF_FUNC_sock_hash_update;
+static int (*bpf_perf_event_read_value)(void *map, unsigned long long flags,
+					void *buf, unsigned int buf_size) =
+	(void *) BPF_FUNC_perf_event_read_value;
+static int (*bpf_perf_prog_read_value)(void *ctx, void *buf,
+				       unsigned int buf_size) =
+	(void *) BPF_FUNC_perf_prog_read_value;
+static int (*bpf_override_return)(void *ctx, unsigned long rc) =
+	(void *) BPF_FUNC_override_return;
+static int (*bpf_msg_redirect_map)(void *ctx, void *map, int key, int flags) =
+	(void *) BPF_FUNC_msg_redirect_map;
+static int (*bpf_msg_redirect_hash)(void *ctx,
+				    void *map, void *key, int flags) =
+	(void *) BPF_FUNC_msg_redirect_hash;
+static int (*bpf_msg_apply_bytes)(void *ctx, int len) =
+	(void *) BPF_FUNC_msg_apply_bytes;
+static int (*bpf_msg_cork_bytes)(void *ctx, int len) =
+	(void *) BPF_FUNC_msg_cork_bytes;
+static int (*bpf_msg_pull_data)(void *ctx, int start, int end, int flags) =
+	(void *) BPF_FUNC_msg_pull_data;
+static int (*bpf_msg_push_data)(void *ctx, int start, int end, int flags) =
+	(void *) BPF_FUNC_msg_push_data;
+static int (*bpf_msg_pop_data)(void *ctx, int start, int cut, int flags) =
+	(void *) BPF_FUNC_msg_pop_data;
+static int (*bpf_bind)(void *ctx, void *addr, int addr_len) =
+	(void *) BPF_FUNC_bind;
+static int (*bpf_xdp_adjust_tail)(void *ctx, int offset) =
+	(void *) BPF_FUNC_xdp_adjust_tail;
+static int (*bpf_skb_get_xfrm_state)(void *ctx, int index, void *state,
+				     int size, int flags) =
+	(void *) BPF_FUNC_skb_get_xfrm_state;
+static int (*bpf_sk_select_reuseport)(void *ctx, void *map, void *key, __u32 flags) =
+	(void *) BPF_FUNC_sk_select_reuseport;
+static int (*bpf_get_stack)(void *ctx, void *buf, int size, int flags) =
+	(void *) BPF_FUNC_get_stack;
+static int (*bpf_fib_lookup)(void *ctx, struct bpf_fib_lookup *params,
+			     int plen, __u32 flags) =
+	(void *) BPF_FUNC_fib_lookup;
+static int (*bpf_lwt_push_encap)(void *ctx, unsigned int type, void *hdr,
+				 unsigned int len) =
+	(void *) BPF_FUNC_lwt_push_encap;
+static int (*bpf_lwt_seg6_store_bytes)(void *ctx, unsigned int offset,
+				       void *from, unsigned int len) =
+	(void *) BPF_FUNC_lwt_seg6_store_bytes;
+static int (*bpf_lwt_seg6_action)(void *ctx, unsigned int action, void *param,
+				  unsigned int param_len) =
+	(void *) BPF_FUNC_lwt_seg6_action;
+static int (*bpf_lwt_seg6_adjust_srh)(void *ctx, unsigned int offset,
+				      unsigned int len) =
+	(void *) BPF_FUNC_lwt_seg6_adjust_srh;
+static int (*bpf_rc_repeat)(void *ctx) =
+	(void *) BPF_FUNC_rc_repeat;
+static int (*bpf_rc_keydown)(void *ctx, unsigned int protocol,
+			     unsigned long long scancode, unsigned int toggle) =
+	(void *) BPF_FUNC_rc_keydown;
+static unsigned long long (*bpf_get_current_cgroup_id)(void) =
+	(void *) BPF_FUNC_get_current_cgroup_id;
+static void *(*bpf_get_local_storage)(void *map, unsigned long long flags) =
+	(void *) BPF_FUNC_get_local_storage;
+static unsigned long long (*bpf_skb_cgroup_id)(void *ctx) =
+	(void *) BPF_FUNC_skb_cgroup_id;
+static unsigned long long (*bpf_skb_ancestor_cgroup_id)(void *ctx, int level) =
+	(void *) BPF_FUNC_skb_ancestor_cgroup_id;
+static struct bpf_sock *(*bpf_sk_lookup_tcp)(void *ctx,
+					     struct bpf_sock_tuple *tuple,
+					     int size, unsigned long long netns_id,
+					     unsigned long long flags) =
+	(void *) BPF_FUNC_sk_lookup_tcp;
+static struct bpf_sock *(*bpf_skc_lookup_tcp)(void *ctx,
+					     struct bpf_sock_tuple *tuple,
+					     int size, unsigned long long netns_id,
+					     unsigned long long flags) =
+	(void *) BPF_FUNC_skc_lookup_tcp;
+static struct bpf_sock *(*bpf_sk_lookup_udp)(void *ctx,
+					     struct bpf_sock_tuple *tuple,
+					     int size, unsigned long long netns_id,
+					     unsigned long long flags) =
+	(void *) BPF_FUNC_sk_lookup_udp;
+static int (*bpf_sk_release)(struct bpf_sock *sk) =
+	(void *) BPF_FUNC_sk_release;
+static int (*bpf_skb_vlan_push)(void *ctx, __be16 vlan_proto, __u16 vlan_tci) =
+	(void *) BPF_FUNC_skb_vlan_push;
+static int (*bpf_skb_vlan_pop)(void *ctx) =
+	(void *) BPF_FUNC_skb_vlan_pop;
+static int (*bpf_rc_pointer_rel)(void *ctx, int rel_x, int rel_y) =
+	(void *) BPF_FUNC_rc_pointer_rel;
+static void (*bpf_spin_lock)(struct bpf_spin_lock *lock) =
+	(void *) BPF_FUNC_spin_lock;
+static void (*bpf_spin_unlock)(struct bpf_spin_lock *lock) =
+	(void *) BPF_FUNC_spin_unlock;
+static struct bpf_sock *(*bpf_sk_fullsock)(struct bpf_sock *sk) =
+	(void *) BPF_FUNC_sk_fullsock;
+static struct bpf_tcp_sock *(*bpf_tcp_sock)(struct bpf_sock *sk) =
+	(void *) BPF_FUNC_tcp_sock;
+static struct bpf_sock *(*bpf_get_listener_sock)(struct bpf_sock *sk) =
+	(void *) BPF_FUNC_get_listener_sock;
+static int (*bpf_skb_ecn_set_ce)(void *ctx) =
+	(void *) BPF_FUNC_skb_ecn_set_ce;
+static int (*bpf_tcp_check_syncookie)(struct bpf_sock *sk,
+	    void *ip, int ip_len, void *tcp, int tcp_len) =
+	(void *) BPF_FUNC_tcp_check_syncookie;
+static int (*bpf_sysctl_get_name)(void *ctx, char *buf,
+				  unsigned long long buf_len,
+				  unsigned long long flags) =
+	(void *) BPF_FUNC_sysctl_get_name;
+static int (*bpf_sysctl_get_current_value)(void *ctx, char *buf,
+					   unsigned long long buf_len) =
+	(void *) BPF_FUNC_sysctl_get_current_value;
+static int (*bpf_sysctl_get_new_value)(void *ctx, char *buf,
+				       unsigned long long buf_len) =
+	(void *) BPF_FUNC_sysctl_get_new_value;
+static int (*bpf_sysctl_set_new_value)(void *ctx, const char *buf,
+				       unsigned long long buf_len) =
+	(void *) BPF_FUNC_sysctl_set_new_value;
+static int (*bpf_strtol)(const char *buf, unsigned long long buf_len,
+			 unsigned long long flags, long *res) =
+	(void *) BPF_FUNC_strtol;
+static int (*bpf_strtoul)(const char *buf, unsigned long long buf_len,
+			  unsigned long long flags, unsigned long *res) =
+	(void *) BPF_FUNC_strtoul;
+static void *(*bpf_sk_storage_get)(void *map, struct bpf_sock *sk,
+				   void *value, __u64 flags) =
+	(void *) BPF_FUNC_sk_storage_get;
+static int (*bpf_sk_storage_delete)(void *map, struct bpf_sock *sk) =
+	(void *)BPF_FUNC_sk_storage_delete;
+static int (*bpf_send_signal)(unsigned sig) = (void *)BPF_FUNC_send_signal;
+static long long (*bpf_tcp_gen_syncookie)(struct bpf_sock *sk, void *ip,
+					  int ip_len, void *tcp, int tcp_len) =
+	(void *) BPF_FUNC_tcp_gen_syncookie;
+
+/* llvm builtin functions that eBPF C program may use to
+ * emit BPF_LD_ABS and BPF_LD_IND instructions
+ */
+struct sk_buff;
+unsigned long long load_byte(void *skb,
+			     unsigned long long off) asm("llvm.bpf.load.byte");
+unsigned long long load_half(void *skb,
+			     unsigned long long off) asm("llvm.bpf.load.half");
+unsigned long long load_word(void *skb,
+			     unsigned long long off) asm("llvm.bpf.load.word");
+
+/* a helper structure used by eBPF C program
+ * to describe map attributes to elf_bpf loader
+ */
+struct bpf_map_def {
+	unsigned int type;
+	unsigned int key_size;
+	unsigned int value_size;
+	unsigned int max_entries;
+	unsigned int map_flags;
+	unsigned int inner_map_idx;
+	unsigned int numa_node;
+};
+
+#define BPF_ANNOTATE_KV_PAIR(name, type_key, type_val)		\
+	struct ____btf_map_##name {				\
+		type_key key;					\
+		type_val value;					\
+	};							\
+	struct ____btf_map_##name				\
+	__attribute__ ((section(".maps." #name), used))		\
+		____btf_map_##name = { }
+
+static int (*bpf_skb_load_bytes)(void *ctx, int off, void *to, int len) =
+	(void *) BPF_FUNC_skb_load_bytes;
+static int (*bpf_skb_load_bytes_relative)(void *ctx, int off, void *to, int len, __u32 start_header) =
+	(void *) BPF_FUNC_skb_load_bytes_relative;
+static int (*bpf_skb_store_bytes)(void *ctx, int off, void *from, int len, int flags) =
+	(void *) BPF_FUNC_skb_store_bytes;
+static int (*bpf_l3_csum_replace)(void *ctx, int off, int from, int to, int flags) =
+	(void *) BPF_FUNC_l3_csum_replace;
+static int (*bpf_l4_csum_replace)(void *ctx, int off, int from, int to, int flags) =
+	(void *) BPF_FUNC_l4_csum_replace;
+static int (*bpf_csum_diff)(void *from, int from_size, void *to, int to_size, int seed) =
+	(void *) BPF_FUNC_csum_diff;
+static int (*bpf_skb_under_cgroup)(void *ctx, void *map, int index) =
+	(void *) BPF_FUNC_skb_under_cgroup;
+static int (*bpf_skb_change_head)(void *, int len, int flags) =
+	(void *) BPF_FUNC_skb_change_head;
+static int (*bpf_skb_pull_data)(void *, int len) =
+	(void *) BPF_FUNC_skb_pull_data;
+static unsigned int (*bpf_get_cgroup_classid)(void *ctx) =
+	(void *) BPF_FUNC_get_cgroup_classid;
+static unsigned int (*bpf_get_route_realm)(void *ctx) =
+	(void *) BPF_FUNC_get_route_realm;
+static int (*bpf_skb_change_proto)(void *ctx, __be16 proto, __u64 flags) =
+	(void *) BPF_FUNC_skb_change_proto;
+static int (*bpf_skb_change_type)(void *ctx, __u32 type) =
+	(void *) BPF_FUNC_skb_change_type;
+static unsigned int (*bpf_get_hash_recalc)(void *ctx) =
+	(void *) BPF_FUNC_get_hash_recalc;
+static unsigned long long (*bpf_get_current_task)(void) =
+	(void *) BPF_FUNC_get_current_task;
+static int (*bpf_skb_change_tail)(void *ctx, __u32 len, __u64 flags) =
+	(void *) BPF_FUNC_skb_change_tail;
+static long long (*bpf_csum_update)(void *ctx, __u32 csum) =
+	(void *) BPF_FUNC_csum_update;
+static void (*bpf_set_hash_invalid)(void *ctx) =
+	(void *) BPF_FUNC_set_hash_invalid;
+static int (*bpf_get_numa_node_id)(void) =
+	(void *) BPF_FUNC_get_numa_node_id;
+static int (*bpf_probe_read_str)(void *ctx, __u32 size,
+				 const void *unsafe_ptr) =
+	(void *) BPF_FUNC_probe_read_str;
+static unsigned int (*bpf_get_socket_uid)(void *ctx) =
+	(void *) BPF_FUNC_get_socket_uid;
+static unsigned int (*bpf_set_hash)(void *ctx, __u32 hash) =
+	(void *) BPF_FUNC_set_hash;
+static int (*bpf_skb_adjust_room)(void *ctx, __s32 len_diff, __u32 mode,
+				  unsigned long long flags) =
+	(void *) BPF_FUNC_skb_adjust_room;
+
+/* Scan the ARCH passed in from ARCH env variable (see Makefile) */
+#if defined(__TARGET_ARCH_x86)
+	#define bpf_target_x86
+	#define bpf_target_defined
+#elif defined(__TARGET_ARCH_s390)
+	#define bpf_target_s390
+	#define bpf_target_defined
+#elif defined(__TARGET_ARCH_arm)
+	#define bpf_target_arm
+	#define bpf_target_defined
+#elif defined(__TARGET_ARCH_arm64)
+	#define bpf_target_arm64
+	#define bpf_target_defined
+#elif defined(__TARGET_ARCH_mips)
+	#define bpf_target_mips
+	#define bpf_target_defined
+#elif defined(__TARGET_ARCH_powerpc)
+	#define bpf_target_powerpc
+	#define bpf_target_defined
+#elif defined(__TARGET_ARCH_sparc)
+	#define bpf_target_sparc
+	#define bpf_target_defined
+#else
+	#undef bpf_target_defined
+#endif
+
+/* Fall back to what the compiler says */
+#ifndef bpf_target_defined
+#if defined(__x86_64__)
+	#define bpf_target_x86
+#elif defined(__s390__)
+	#define bpf_target_s390
+#elif defined(__arm__)
+	#define bpf_target_arm
+#elif defined(__aarch64__)
+	#define bpf_target_arm64
+#elif defined(__mips__)
+	#define bpf_target_mips
+#elif defined(__powerpc__)
+	#define bpf_target_powerpc
+#elif defined(__sparc__)
+	#define bpf_target_sparc
+#endif
+#endif
+
+#if defined(bpf_target_x86)
+
+#ifdef __KERNEL__
+#define PT_REGS_PARM1(x) ((x)->di)
+#define PT_REGS_PARM2(x) ((x)->si)
+#define PT_REGS_PARM3(x) ((x)->dx)
+#define PT_REGS_PARM4(x) ((x)->cx)
+#define PT_REGS_PARM5(x) ((x)->r8)
+#define PT_REGS_RET(x) ((x)->sp)
+#define PT_REGS_FP(x) ((x)->bp)
+#define PT_REGS_RC(x) ((x)->ax)
+#define PT_REGS_SP(x) ((x)->sp)
+#define PT_REGS_IP(x) ((x)->ip)
+#else
+#ifdef __i386__
+/* i386 kernel is built with -mregparm=3 */
+#define PT_REGS_PARM1(x) ((x)->eax)
+#define PT_REGS_PARM2(x) ((x)->edx)
+#define PT_REGS_PARM3(x) ((x)->ecx)
+#define PT_REGS_PARM4(x) 0
+#define PT_REGS_PARM5(x) 0
+#define PT_REGS_RET(x) ((x)->esp)
+#define PT_REGS_FP(x) ((x)->ebp)
+#define PT_REGS_RC(x) ((x)->eax)
+#define PT_REGS_SP(x) ((x)->esp)
+#define PT_REGS_IP(x) ((x)->eip)
+#else
+#define PT_REGS_PARM1(x) ((x)->rdi)
+#define PT_REGS_PARM2(x) ((x)->rsi)
+#define PT_REGS_PARM3(x) ((x)->rdx)
+#define PT_REGS_PARM4(x) ((x)->rcx)
+#define PT_REGS_PARM5(x) ((x)->r8)
+#define PT_REGS_RET(x) ((x)->rsp)
+#define PT_REGS_FP(x) ((x)->rbp)
+#define PT_REGS_RC(x) ((x)->rax)
+#define PT_REGS_SP(x) ((x)->rsp)
+#define PT_REGS_IP(x) ((x)->rip)
+#endif
+#endif
+
+#elif defined(bpf_target_s390)
+
+/* s390 provides user_pt_regs instead of struct pt_regs to userspace */
+struct pt_regs;
+#define PT_REGS_S390 const volatile user_pt_regs
+#define PT_REGS_PARM1(x) (((PT_REGS_S390 *)(x))->gprs[2])
+#define PT_REGS_PARM2(x) (((PT_REGS_S390 *)(x))->gprs[3])
+#define PT_REGS_PARM3(x) (((PT_REGS_S390 *)(x))->gprs[4])
+#define PT_REGS_PARM4(x) (((PT_REGS_S390 *)(x))->gprs[5])
+#define PT_REGS_PARM5(x) (((PT_REGS_S390 *)(x))->gprs[6])
+#define PT_REGS_RET(x) (((PT_REGS_S390 *)(x))->gprs[14])
+/* Works only with CONFIG_FRAME_POINTER */
+#define PT_REGS_FP(x) (((PT_REGS_S390 *)(x))->gprs[11])
+#define PT_REGS_RC(x) (((PT_REGS_S390 *)(x))->gprs[2])
+#define PT_REGS_SP(x) (((PT_REGS_S390 *)(x))->gprs[15])
+#define PT_REGS_IP(x) (((PT_REGS_S390 *)(x))->psw.addr)
+
+#elif defined(bpf_target_arm)
+
+#define PT_REGS_PARM1(x) ((x)->uregs[0])
+#define PT_REGS_PARM2(x) ((x)->uregs[1])
+#define PT_REGS_PARM3(x) ((x)->uregs[2])
+#define PT_REGS_PARM4(x) ((x)->uregs[3])
+#define PT_REGS_PARM5(x) ((x)->uregs[4])
+#define PT_REGS_RET(x) ((x)->uregs[14])
+#define PT_REGS_FP(x) ((x)->uregs[11]) /* Works only with CONFIG_FRAME_POINTER */
+#define PT_REGS_RC(x) ((x)->uregs[0])
+#define PT_REGS_SP(x) ((x)->uregs[13])
+#define PT_REGS_IP(x) ((x)->uregs[12])
+
+#elif defined(bpf_target_arm64)
+
+/* arm64 provides struct user_pt_regs instead of struct pt_regs to userspace */
+struct pt_regs;
+#define PT_REGS_ARM64 const volatile struct user_pt_regs
+#define PT_REGS_PARM1(x) (((PT_REGS_ARM64 *)(x))->regs[0])
+#define PT_REGS_PARM2(x) (((PT_REGS_ARM64 *)(x))->regs[1])
+#define PT_REGS_PARM3(x) (((PT_REGS_ARM64 *)(x))->regs[2])
+#define PT_REGS_PARM4(x) (((PT_REGS_ARM64 *)(x))->regs[3])
+#define PT_REGS_PARM5(x) (((PT_REGS_ARM64 *)(x))->regs[4])
+#define PT_REGS_RET(x) (((PT_REGS_ARM64 *)(x))->regs[30])
+/* Works only with CONFIG_FRAME_POINTER */
+#define PT_REGS_FP(x) (((PT_REGS_ARM64 *)(x))->regs[29])
+#define PT_REGS_RC(x) (((PT_REGS_ARM64 *)(x))->regs[0])
+#define PT_REGS_SP(x) (((PT_REGS_ARM64 *)(x))->sp)
+#define PT_REGS_IP(x) (((PT_REGS_ARM64 *)(x))->pc)
+
+#elif defined(bpf_target_mips)
+
+#define PT_REGS_PARM1(x) ((x)->regs[4])
+#define PT_REGS_PARM2(x) ((x)->regs[5])
+#define PT_REGS_PARM3(x) ((x)->regs[6])
+#define PT_REGS_PARM4(x) ((x)->regs[7])
+#define PT_REGS_PARM5(x) ((x)->regs[8])
+#define PT_REGS_RET(x) ((x)->regs[31])
+#define PT_REGS_FP(x) ((x)->regs[30]) /* Works only with CONFIG_FRAME_POINTER */
+#define PT_REGS_RC(x) ((x)->regs[1])
+#define PT_REGS_SP(x) ((x)->regs[29])
+#define PT_REGS_IP(x) ((x)->cp0_epc)
+
+#elif defined(bpf_target_powerpc)
+
+#define PT_REGS_PARM1(x) ((x)->gpr[3])
+#define PT_REGS_PARM2(x) ((x)->gpr[4])
+#define PT_REGS_PARM3(x) ((x)->gpr[5])
+#define PT_REGS_PARM4(x) ((x)->gpr[6])
+#define PT_REGS_PARM5(x) ((x)->gpr[7])
+#define PT_REGS_RC(x) ((x)->gpr[3])
+#define PT_REGS_SP(x) ((x)->sp)
+#define PT_REGS_IP(x) ((x)->nip)
+
+#elif defined(bpf_target_sparc)
+
+#define PT_REGS_PARM1(x) ((x)->u_regs[UREG_I0])
+#define PT_REGS_PARM2(x) ((x)->u_regs[UREG_I1])
+#define PT_REGS_PARM3(x) ((x)->u_regs[UREG_I2])
+#define PT_REGS_PARM4(x) ((x)->u_regs[UREG_I3])
+#define PT_REGS_PARM5(x) ((x)->u_regs[UREG_I4])
+#define PT_REGS_RET(x) ((x)->u_regs[UREG_I7])
+#define PT_REGS_RC(x) ((x)->u_regs[UREG_I0])
+#define PT_REGS_SP(x) ((x)->u_regs[UREG_FP])
+
+/* Should this also be a bpf_target check for the sparc case? */
+#if defined(__arch64__)
+#define PT_REGS_IP(x) ((x)->tpc)
+#else
+#define PT_REGS_IP(x) ((x)->pc)
+#endif
+
+#endif
+
+#if defined(bpf_target_powerpc)
+#define BPF_KPROBE_READ_RET_IP(ip, ctx)		({ (ip) = (ctx)->link; })
+#define BPF_KRETPROBE_READ_RET_IP		BPF_KPROBE_READ_RET_IP
+#elif defined(bpf_target_sparc)
+#define BPF_KPROBE_READ_RET_IP(ip, ctx)		({ (ip) = PT_REGS_RET(ctx); })
+#define BPF_KRETPROBE_READ_RET_IP		BPF_KPROBE_READ_RET_IP
+#else
+#define BPF_KPROBE_READ_RET_IP(ip, ctx)		({				\
+		bpf_probe_read(&(ip), sizeof(ip), (void *)PT_REGS_RET(ctx)); })
+#define BPF_KRETPROBE_READ_RET_IP(ip, ctx)	({				\
+		bpf_probe_read(&(ip), sizeof(ip),				\
+				(void *)(PT_REGS_FP(ctx) + sizeof(ip))); })
+#endif
+
+/*
+ * BPF_CORE_READ abstracts away bpf_probe_read() call and captures offset
+ * relocation for source address using __builtin_preserve_access_index()
+ * built-in, provided by Clang.
+ *
+ * __builtin_preserve_access_index() takes as an argument an expression of
+ * taking an address of a field within struct/union. It makes compiler emit
+ * a relocation, which records BTF type ID describing root struct/union and an
+ * accessor string which describes exact embedded field that was used to take
+ * an address. See detailed description of this relocation format and
+ * semantics in comments to struct bpf_offset_reloc in libbpf_internal.h.
+ *
+ * This relocation allows libbpf to adjust BPF instruction to use correct
+ * actual field offset, based on target kernel BTF type that matches original
+ * (local) BTF, used to record relocation.
+ */
+#define BPF_CORE_READ(dst, src)						\
+	bpf_probe_read((dst), sizeof(*(src)),				\
+		       __builtin_preserve_access_index(src))
+
+#endif
-- 
2.17.1

