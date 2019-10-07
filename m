Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1D240CDA8F
	for <lists+netdev@lfdr.de>; Mon,  7 Oct 2019 05:07:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727010AbfJGDHw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 6 Oct 2019 23:07:52 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:21356 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726852AbfJGDHu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 6 Oct 2019 23:07:50 -0400
Received: from pps.filterd (m0148460.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id x97341NJ031716
        for <netdev@vger.kernel.org>; Sun, 6 Oct 2019 20:07:49 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-type; s=facebook; bh=Cm0IHDcGDbPewOuygHHepSr/u81lwK49OY8qA2UEy6Y=;
 b=a2j9Gfa41KQLKqcnKHSX1oZuD/a+Sm/youhGkXNzSXC8g5q0IRsHUtVRtHZ990GHY5ZQ
 x8d5Dox0U800tON5whpdU3Xey72DQp7fFQVQTUQ/6rZsGpULT8WPGEfOt+PQUjR4EzcH
 0F8mYa65q6nJo8uzo9lI3t1eaY/cSk7Z0Go= 
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by mx0a-00082601.pphosted.com with ESMTP id 2verpnx5as-4
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Sun, 06 Oct 2019 20:07:49 -0700
Received: from 2401:db00:30:600c:face:0:39:0 (2620:10d:c081:10::13) by
 mail.thefacebook.com (2620:10d:c081:35::127) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA) id 15.1.1713.5;
 Sun, 6 Oct 2019 20:07:46 -0700
Received: by dev101.prn2.facebook.com (Postfix, from userid 137359)
        id 436E186190E; Sun,  6 Oct 2019 20:07:46 -0700 (PDT)
Smtp-Origin-Hostprefix: dev
From:   Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Hostname: dev101.prn2.facebook.com
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>, <quentin.monnet@netronome.com>
CC:     <andrii.nakryiko@gmail.com>, <kernel-team@fb.com>,
        Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Cluster: prn2c23
Subject: [PATCH v4 bpf-next 3/3] libbpf: auto-generate list of BPF helper definitions
Date:   Sun, 6 Oct 2019 20:07:38 -0700
Message-ID: <20191007030738.2627420-4-andriin@fb.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20191007030738.2627420-1-andriin@fb.com>
References: <20191007030738.2627420-1-andriin@fb.com>
X-FB-Internal: Safe
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,1.0.8
 definitions=2019-10-06_11:2019-10-03,2019-10-06 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 phishscore=0
 suspectscore=9 clxscore=1015 impostorscore=0 priorityscore=1501
 lowpriorityscore=0 malwarescore=0 spamscore=0 adultscore=0 bulkscore=0
 mlxscore=0 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1908290000 definitions=main-1910070032
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Get rid of list of BPF helpers in bpf_helpers.h (irony...) and
auto-generate it into bpf_helpers_defs.h, which is now included from
bpf_helpers.h.

Suggested-by: Alexei Starovoitov <ast@fb.com>
Signed-off-by: Andrii Nakryiko <andriin@fb.com>
---
 tools/testing/selftests/bpf/.gitignore    |   1 +
 tools/testing/selftests/bpf/Makefile      |   8 +-
 tools/testing/selftests/bpf/bpf_helpers.h | 264 +---------------------
 3 files changed, 9 insertions(+), 264 deletions(-)

diff --git a/tools/testing/selftests/bpf/.gitignore b/tools/testing/selftests/bpf/.gitignore
index 7470327edcfe..50063f66539d 100644
--- a/tools/testing/selftests/bpf/.gitignore
+++ b/tools/testing/selftests/bpf/.gitignore
@@ -39,3 +39,4 @@ libbpf.so.*
 test_hashmap
 test_btf_dump
 xdping
+/bpf_helper_defs.h
diff --git a/tools/testing/selftests/bpf/Makefile b/tools/testing/selftests/bpf/Makefile
index 294d7472dad7..b59fb4e8afaf 100644
--- a/tools/testing/selftests/bpf/Makefile
+++ b/tools/testing/selftests/bpf/Makefile
@@ -90,6 +90,10 @@ include ../lib.mk
 TEST_CUSTOM_PROGS = $(OUTPUT)/urandom_read
 all: $(TEST_CUSTOM_PROGS)
 
+bpf_helper_defs.h: $(APIDIR)/linux/bpf.h
+	$(BPFDIR)/../../../scripts/bpf_helpers_doc.py --header 		\
+		--file $(APIDIR)/linux/bpf.h > bpf_helper_defs.h
+
 $(OUTPUT)/urandom_read: $(OUTPUT)/%: %.c
 	$(CC) -o $@ $< -Wl,--build-id
 
@@ -123,7 +127,7 @@ $(OUTPUT)/test_cgroup_attach: cgroup_helpers.c
 # force a rebuild of BPFOBJ when its dependencies are updated
 force:
 
-$(BPFOBJ): force
+$(BPFOBJ): force bpf_helper_defs.h
 	$(MAKE) -C $(BPFDIR) OUTPUT=$(OUTPUT)/
 
 PROBE := $(shell $(LLC) -march=bpf -mcpu=probe -filetype=null /dev/null 2>&1)
@@ -319,4 +323,4 @@ $(VERIFIER_TESTS_H): $(VERIFIER_TEST_FILES) | $(VERIFIER_TESTS_DIR)
 
 EXTRA_CLEAN := $(TEST_CUSTOM_PROGS) $(ALU32_BUILD_DIR) $(BPF_GCC_BUILD_DIR) \
 	$(VERIFIER_TESTS_H) $(PROG_TESTS_H) $(MAP_TESTS_H) \
-	feature
+	feature bpf_helper_defs.h
diff --git a/tools/testing/selftests/bpf/bpf_helpers.h b/tools/testing/selftests/bpf/bpf_helpers.h
index 9f77cbaac01c..15152280db6f 100644
--- a/tools/testing/selftests/bpf/bpf_helpers.h
+++ b/tools/testing/selftests/bpf/bpf_helpers.h
@@ -2,6 +2,8 @@
 #ifndef __BPF_HELPERS__
 #define __BPF_HELPERS__
 
+#include "bpf_helper_defs.h"
+
 #define __uint(name, val) int (*name)[val]
 #define __type(name, val) typeof(val) *name
 
@@ -21,219 +23,6 @@
  */
 #define SEC(NAME) __attribute__((section(NAME), used))
 
-/* helper functions called from eBPF programs written in C */
-static void *(*bpf_map_lookup_elem)(void *map, const void *key) =
-	(void *) BPF_FUNC_map_lookup_elem;
-static int (*bpf_map_update_elem)(void *map, const void *key, const void *value,
-				  unsigned long long flags) =
-	(void *) BPF_FUNC_map_update_elem;
-static int (*bpf_map_delete_elem)(void *map, const void *key) =
-	(void *) BPF_FUNC_map_delete_elem;
-static int (*bpf_map_push_elem)(void *map, const void *value,
-				unsigned long long flags) =
-	(void *) BPF_FUNC_map_push_elem;
-static int (*bpf_map_pop_elem)(void *map, void *value) =
-	(void *) BPF_FUNC_map_pop_elem;
-static int (*bpf_map_peek_elem)(void *map, void *value) =
-	(void *) BPF_FUNC_map_peek_elem;
-static int (*bpf_probe_read)(void *dst, int size, const void *unsafe_ptr) =
-	(void *) BPF_FUNC_probe_read;
-static unsigned long long (*bpf_ktime_get_ns)(void) =
-	(void *) BPF_FUNC_ktime_get_ns;
-static int (*bpf_trace_printk)(const char *fmt, int fmt_size, ...) =
-	(void *) BPF_FUNC_trace_printk;
-static void (*bpf_tail_call)(void *ctx, void *map, int index) =
-	(void *) BPF_FUNC_tail_call;
-static unsigned long long (*bpf_get_smp_processor_id)(void) =
-	(void *) BPF_FUNC_get_smp_processor_id;
-static unsigned long long (*bpf_get_current_pid_tgid)(void) =
-	(void *) BPF_FUNC_get_current_pid_tgid;
-static unsigned long long (*bpf_get_current_uid_gid)(void) =
-	(void *) BPF_FUNC_get_current_uid_gid;
-static int (*bpf_get_current_comm)(void *buf, int buf_size) =
-	(void *) BPF_FUNC_get_current_comm;
-static unsigned long long (*bpf_perf_event_read)(void *map,
-						 unsigned long long flags) =
-	(void *) BPF_FUNC_perf_event_read;
-static int (*bpf_clone_redirect)(void *ctx, int ifindex, int flags) =
-	(void *) BPF_FUNC_clone_redirect;
-static int (*bpf_redirect)(int ifindex, int flags) =
-	(void *) BPF_FUNC_redirect;
-static int (*bpf_redirect_map)(void *map, int key, int flags) =
-	(void *) BPF_FUNC_redirect_map;
-static int (*bpf_perf_event_output)(void *ctx, void *map,
-				    unsigned long long flags, void *data,
-				    int size) =
-	(void *) BPF_FUNC_perf_event_output;
-static int (*bpf_get_stackid)(void *ctx, void *map, int flags) =
-	(void *) BPF_FUNC_get_stackid;
-static int (*bpf_probe_write_user)(void *dst, const void *src, int size) =
-	(void *) BPF_FUNC_probe_write_user;
-static int (*bpf_current_task_under_cgroup)(void *map, int index) =
-	(void *) BPF_FUNC_current_task_under_cgroup;
-static int (*bpf_skb_get_tunnel_key)(void *ctx, void *key, int size, int flags) =
-	(void *) BPF_FUNC_skb_get_tunnel_key;
-static int (*bpf_skb_set_tunnel_key)(void *ctx, void *key, int size, int flags) =
-	(void *) BPF_FUNC_skb_set_tunnel_key;
-static int (*bpf_skb_get_tunnel_opt)(void *ctx, void *md, int size) =
-	(void *) BPF_FUNC_skb_get_tunnel_opt;
-static int (*bpf_skb_set_tunnel_opt)(void *ctx, void *md, int size) =
-	(void *) BPF_FUNC_skb_set_tunnel_opt;
-static unsigned long long (*bpf_get_prandom_u32)(void) =
-	(void *) BPF_FUNC_get_prandom_u32;
-static int (*bpf_xdp_adjust_head)(void *ctx, int offset) =
-	(void *) BPF_FUNC_xdp_adjust_head;
-static int (*bpf_xdp_adjust_meta)(void *ctx, int offset) =
-	(void *) BPF_FUNC_xdp_adjust_meta;
-static int (*bpf_get_socket_cookie)(void *ctx) =
-	(void *) BPF_FUNC_get_socket_cookie;
-static int (*bpf_setsockopt)(void *ctx, int level, int optname, void *optval,
-			     int optlen) =
-	(void *) BPF_FUNC_setsockopt;
-static int (*bpf_getsockopt)(void *ctx, int level, int optname, void *optval,
-			     int optlen) =
-	(void *) BPF_FUNC_getsockopt;
-static int (*bpf_sock_ops_cb_flags_set)(void *ctx, int flags) =
-	(void *) BPF_FUNC_sock_ops_cb_flags_set;
-static int (*bpf_sk_redirect_map)(void *ctx, void *map, int key, int flags) =
-	(void *) BPF_FUNC_sk_redirect_map;
-static int (*bpf_sk_redirect_hash)(void *ctx, void *map, void *key, int flags) =
-	(void *) BPF_FUNC_sk_redirect_hash;
-static int (*bpf_sock_map_update)(void *map, void *key, void *value,
-				  unsigned long long flags) =
-	(void *) BPF_FUNC_sock_map_update;
-static int (*bpf_sock_hash_update)(void *map, void *key, void *value,
-				   unsigned long long flags) =
-	(void *) BPF_FUNC_sock_hash_update;
-static int (*bpf_perf_event_read_value)(void *map, unsigned long long flags,
-					void *buf, unsigned int buf_size) =
-	(void *) BPF_FUNC_perf_event_read_value;
-static int (*bpf_perf_prog_read_value)(void *ctx, void *buf,
-				       unsigned int buf_size) =
-	(void *) BPF_FUNC_perf_prog_read_value;
-static int (*bpf_override_return)(void *ctx, unsigned long rc) =
-	(void *) BPF_FUNC_override_return;
-static int (*bpf_msg_redirect_map)(void *ctx, void *map, int key, int flags) =
-	(void *) BPF_FUNC_msg_redirect_map;
-static int (*bpf_msg_redirect_hash)(void *ctx,
-				    void *map, void *key, int flags) =
-	(void *) BPF_FUNC_msg_redirect_hash;
-static int (*bpf_msg_apply_bytes)(void *ctx, int len) =
-	(void *) BPF_FUNC_msg_apply_bytes;
-static int (*bpf_msg_cork_bytes)(void *ctx, int len) =
-	(void *) BPF_FUNC_msg_cork_bytes;
-static int (*bpf_msg_pull_data)(void *ctx, int start, int end, int flags) =
-	(void *) BPF_FUNC_msg_pull_data;
-static int (*bpf_msg_push_data)(void *ctx, int start, int end, int flags) =
-	(void *) BPF_FUNC_msg_push_data;
-static int (*bpf_msg_pop_data)(void *ctx, int start, int cut, int flags) =
-	(void *) BPF_FUNC_msg_pop_data;
-static int (*bpf_bind)(void *ctx, void *addr, int addr_len) =
-	(void *) BPF_FUNC_bind;
-static int (*bpf_xdp_adjust_tail)(void *ctx, int offset) =
-	(void *) BPF_FUNC_xdp_adjust_tail;
-static int (*bpf_skb_get_xfrm_state)(void *ctx, int index, void *state,
-				     int size, int flags) =
-	(void *) BPF_FUNC_skb_get_xfrm_state;
-static int (*bpf_sk_select_reuseport)(void *ctx, void *map, void *key, __u32 flags) =
-	(void *) BPF_FUNC_sk_select_reuseport;
-static int (*bpf_get_stack)(void *ctx, void *buf, int size, int flags) =
-	(void *) BPF_FUNC_get_stack;
-static int (*bpf_fib_lookup)(void *ctx, struct bpf_fib_lookup *params,
-			     int plen, __u32 flags) =
-	(void *) BPF_FUNC_fib_lookup;
-static int (*bpf_lwt_push_encap)(void *ctx, unsigned int type, void *hdr,
-				 unsigned int len) =
-	(void *) BPF_FUNC_lwt_push_encap;
-static int (*bpf_lwt_seg6_store_bytes)(void *ctx, unsigned int offset,
-				       void *from, unsigned int len) =
-	(void *) BPF_FUNC_lwt_seg6_store_bytes;
-static int (*bpf_lwt_seg6_action)(void *ctx, unsigned int action, void *param,
-				  unsigned int param_len) =
-	(void *) BPF_FUNC_lwt_seg6_action;
-static int (*bpf_lwt_seg6_adjust_srh)(void *ctx, unsigned int offset,
-				      unsigned int len) =
-	(void *) BPF_FUNC_lwt_seg6_adjust_srh;
-static int (*bpf_rc_repeat)(void *ctx) =
-	(void *) BPF_FUNC_rc_repeat;
-static int (*bpf_rc_keydown)(void *ctx, unsigned int protocol,
-			     unsigned long long scancode, unsigned int toggle) =
-	(void *) BPF_FUNC_rc_keydown;
-static unsigned long long (*bpf_get_current_cgroup_id)(void) =
-	(void *) BPF_FUNC_get_current_cgroup_id;
-static void *(*bpf_get_local_storage)(void *map, unsigned long long flags) =
-	(void *) BPF_FUNC_get_local_storage;
-static unsigned long long (*bpf_skb_cgroup_id)(void *ctx) =
-	(void *) BPF_FUNC_skb_cgroup_id;
-static unsigned long long (*bpf_skb_ancestor_cgroup_id)(void *ctx, int level) =
-	(void *) BPF_FUNC_skb_ancestor_cgroup_id;
-static struct bpf_sock *(*bpf_sk_lookup_tcp)(void *ctx,
-					     struct bpf_sock_tuple *tuple,
-					     int size, unsigned long long netns_id,
-					     unsigned long long flags) =
-	(void *) BPF_FUNC_sk_lookup_tcp;
-static struct bpf_sock *(*bpf_skc_lookup_tcp)(void *ctx,
-					     struct bpf_sock_tuple *tuple,
-					     int size, unsigned long long netns_id,
-					     unsigned long long flags) =
-	(void *) BPF_FUNC_skc_lookup_tcp;
-static struct bpf_sock *(*bpf_sk_lookup_udp)(void *ctx,
-					     struct bpf_sock_tuple *tuple,
-					     int size, unsigned long long netns_id,
-					     unsigned long long flags) =
-	(void *) BPF_FUNC_sk_lookup_udp;
-static int (*bpf_sk_release)(struct bpf_sock *sk) =
-	(void *) BPF_FUNC_sk_release;
-static int (*bpf_skb_vlan_push)(void *ctx, __be16 vlan_proto, __u16 vlan_tci) =
-	(void *) BPF_FUNC_skb_vlan_push;
-static int (*bpf_skb_vlan_pop)(void *ctx) =
-	(void *) BPF_FUNC_skb_vlan_pop;
-static int (*bpf_rc_pointer_rel)(void *ctx, int rel_x, int rel_y) =
-	(void *) BPF_FUNC_rc_pointer_rel;
-static void (*bpf_spin_lock)(struct bpf_spin_lock *lock) =
-	(void *) BPF_FUNC_spin_lock;
-static void (*bpf_spin_unlock)(struct bpf_spin_lock *lock) =
-	(void *) BPF_FUNC_spin_unlock;
-static struct bpf_sock *(*bpf_sk_fullsock)(struct bpf_sock *sk) =
-	(void *) BPF_FUNC_sk_fullsock;
-static struct bpf_tcp_sock *(*bpf_tcp_sock)(struct bpf_sock *sk) =
-	(void *) BPF_FUNC_tcp_sock;
-static struct bpf_sock *(*bpf_get_listener_sock)(struct bpf_sock *sk) =
-	(void *) BPF_FUNC_get_listener_sock;
-static int (*bpf_skb_ecn_set_ce)(void *ctx) =
-	(void *) BPF_FUNC_skb_ecn_set_ce;
-static int (*bpf_tcp_check_syncookie)(struct bpf_sock *sk,
-	    void *ip, int ip_len, void *tcp, int tcp_len) =
-	(void *) BPF_FUNC_tcp_check_syncookie;
-static int (*bpf_sysctl_get_name)(void *ctx, char *buf,
-				  unsigned long long buf_len,
-				  unsigned long long flags) =
-	(void *) BPF_FUNC_sysctl_get_name;
-static int (*bpf_sysctl_get_current_value)(void *ctx, char *buf,
-					   unsigned long long buf_len) =
-	(void *) BPF_FUNC_sysctl_get_current_value;
-static int (*bpf_sysctl_get_new_value)(void *ctx, char *buf,
-				       unsigned long long buf_len) =
-	(void *) BPF_FUNC_sysctl_get_new_value;
-static int (*bpf_sysctl_set_new_value)(void *ctx, const char *buf,
-				       unsigned long long buf_len) =
-	(void *) BPF_FUNC_sysctl_set_new_value;
-static int (*bpf_strtol)(const char *buf, unsigned long long buf_len,
-			 unsigned long long flags, long *res) =
-	(void *) BPF_FUNC_strtol;
-static int (*bpf_strtoul)(const char *buf, unsigned long long buf_len,
-			  unsigned long long flags, unsigned long *res) =
-	(void *) BPF_FUNC_strtoul;
-static void *(*bpf_sk_storage_get)(void *map, struct bpf_sock *sk,
-				   void *value, __u64 flags) =
-	(void *) BPF_FUNC_sk_storage_get;
-static int (*bpf_sk_storage_delete)(void *map, struct bpf_sock *sk) =
-	(void *)BPF_FUNC_sk_storage_delete;
-static int (*bpf_send_signal)(unsigned sig) = (void *)BPF_FUNC_send_signal;
-static long long (*bpf_tcp_gen_syncookie)(struct bpf_sock *sk, void *ip,
-					  int ip_len, void *tcp, int tcp_len) =
-	(void *) BPF_FUNC_tcp_gen_syncookie;
-
 /* llvm builtin functions that eBPF C program may use to
  * emit BPF_LD_ABS and BPF_LD_IND instructions
  */
@@ -273,55 +62,6 @@ struct bpf_map_def {
 	__attribute__ ((section(".maps." #name), used))		\
 		____btf_map_##name = { }
 
-static int (*bpf_skb_load_bytes)(void *ctx, int off, void *to, int len) =
-	(void *) BPF_FUNC_skb_load_bytes;
-static int (*bpf_skb_load_bytes_relative)(void *ctx, int off, void *to, int len, __u32 start_header) =
-	(void *) BPF_FUNC_skb_load_bytes_relative;
-static int (*bpf_skb_store_bytes)(void *ctx, int off, void *from, int len, int flags) =
-	(void *) BPF_FUNC_skb_store_bytes;
-static int (*bpf_l3_csum_replace)(void *ctx, int off, int from, int to, int flags) =
-	(void *) BPF_FUNC_l3_csum_replace;
-static int (*bpf_l4_csum_replace)(void *ctx, int off, int from, int to, int flags) =
-	(void *) BPF_FUNC_l4_csum_replace;
-static int (*bpf_csum_diff)(void *from, int from_size, void *to, int to_size, int seed) =
-	(void *) BPF_FUNC_csum_diff;
-static int (*bpf_skb_under_cgroup)(void *ctx, void *map, int index) =
-	(void *) BPF_FUNC_skb_under_cgroup;
-static int (*bpf_skb_change_head)(void *, int len, int flags) =
-	(void *) BPF_FUNC_skb_change_head;
-static int (*bpf_skb_pull_data)(void *, int len) =
-	(void *) BPF_FUNC_skb_pull_data;
-static unsigned int (*bpf_get_cgroup_classid)(void *ctx) =
-	(void *) BPF_FUNC_get_cgroup_classid;
-static unsigned int (*bpf_get_route_realm)(void *ctx) =
-	(void *) BPF_FUNC_get_route_realm;
-static int (*bpf_skb_change_proto)(void *ctx, __be16 proto, __u64 flags) =
-	(void *) BPF_FUNC_skb_change_proto;
-static int (*bpf_skb_change_type)(void *ctx, __u32 type) =
-	(void *) BPF_FUNC_skb_change_type;
-static unsigned int (*bpf_get_hash_recalc)(void *ctx) =
-	(void *) BPF_FUNC_get_hash_recalc;
-static unsigned long long (*bpf_get_current_task)(void) =
-	(void *) BPF_FUNC_get_current_task;
-static int (*bpf_skb_change_tail)(void *ctx, __u32 len, __u64 flags) =
-	(void *) BPF_FUNC_skb_change_tail;
-static long long (*bpf_csum_update)(void *ctx, __u32 csum) =
-	(void *) BPF_FUNC_csum_update;
-static void (*bpf_set_hash_invalid)(void *ctx) =
-	(void *) BPF_FUNC_set_hash_invalid;
-static int (*bpf_get_numa_node_id)(void) =
-	(void *) BPF_FUNC_get_numa_node_id;
-static int (*bpf_probe_read_str)(void *ctx, __u32 size,
-				 const void *unsafe_ptr) =
-	(void *) BPF_FUNC_probe_read_str;
-static unsigned int (*bpf_get_socket_uid)(void *ctx) =
-	(void *) BPF_FUNC_get_socket_uid;
-static unsigned int (*bpf_set_hash)(void *ctx, __u32 hash) =
-	(void *) BPF_FUNC_set_hash;
-static int (*bpf_skb_adjust_room)(void *ctx, __s32 len_diff, __u32 mode,
-				  unsigned long long flags) =
-	(void *) BPF_FUNC_skb_adjust_room;
-
 /* Scan the ARCH passed in from ARCH env variable (see Makefile) */
 #if defined(__TARGET_ARCH_x86)
 	#define bpf_target_x86
-- 
2.17.1

