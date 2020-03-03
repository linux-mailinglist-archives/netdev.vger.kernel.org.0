Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DEE8A176987
	for <lists+netdev@lfdr.de>; Tue,  3 Mar 2020 01:51:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727389AbgCCAvR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Mar 2020 19:51:17 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:62714 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726773AbgCCAvQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 Mar 2020 19:51:16 -0500
Received: from pps.filterd (m0044010.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0230jcCA016533
        for <netdev@vger.kernel.org>; Mon, 2 Mar 2020 16:51:15 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-type; s=facebook; bh=XLXUW6pekFzYWGa8ULzqlp834uTk6p9ChappR8YhPAU=;
 b=HW2gzLsShjnEvH2iwEh1P2U4NhYP2beHOLIyyX033zHQOZksr1yT3q4AZenLXEVy0Cv3
 0SZRrcCAfjJP9hAA8qVeN7quNg6s3DttE+zAAPWoNjKoWyBUw3wGhipAZ177tnGS4SSI
 aH0spuSR3WPVl6K3lYQZbNGVlJ7yCjVdug4= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2yg8du7ute-4
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Mon, 02 Mar 2020 16:51:15 -0800
Received: from intmgw003.03.ash8.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:82::e) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1779.2; Mon, 2 Mar 2020 16:51:12 -0800
Received: by devbig012.ftw2.facebook.com (Postfix, from userid 137359)
        id 86A672EC2E79; Mon,  2 Mar 2020 16:51:11 -0800 (PST)
Smtp-Origin-Hostprefix: devbig
From:   Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Hostname: devbig012.ftw2.facebook.com
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>
CC:     <andrii.nakryiko@gmail.com>, <kernel-team@fb.com>,
        Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH v3 bpf-next 1/3] bpf: switch BPF UAPI #define constants used from BPF program side to enums
Date:   Mon, 2 Mar 2020 16:32:31 -0800
Message-ID: <20200303003233.3496043-2-andriin@fb.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200303003233.3496043-1-andriin@fb.com>
References: <20200303003233.3496043-1-andriin@fb.com>
X-FB-Internal: Safe
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-03-02_09:2020-03-02,2020-03-02 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 impostorscore=0
 suspectscore=25 phishscore=0 adultscore=0 lowpriorityscore=0
 malwarescore=0 bulkscore=0 spamscore=0 mlxlogscore=999 priorityscore=1501
 clxscore=1015 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2001150001 definitions=main-2003030002
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Switch BPF UAPI constants, previously defined as #define macro, to anonymous
enum values. This preserves constants values and behavior in expressions, but
has added advantaged of being captured as part of DWARF and, subsequently, BTF
type info. Which, in turn, greatly improves usefulness of generated vmlinux.h
for BPF applications, as it will not require BPF users to copy/paste various
flags and constants, which are frequently used with BPF helpers. Only those
constants that are used/useful from BPF program side are converted.

Signed-off-by: Andrii Nakryiko <andriin@fb.com>
---
 include/uapi/linux/bpf.h       | 175 ++++++++++++++++++++------------
 tools/include/uapi/linux/bpf.h | 177 ++++++++++++++++++++-------------
 2 files changed, 219 insertions(+), 133 deletions(-)

diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
index 8e98ced0963b..3ce4e8759661 100644
--- a/include/uapi/linux/bpf.h
+++ b/include/uapi/linux/bpf.h
@@ -325,44 +325,46 @@ enum bpf_attach_type {
 #define BPF_PSEUDO_CALL		1
 
 /* flags for BPF_MAP_UPDATE_ELEM command */
-#define BPF_ANY		0 /* create new element or update existing */
-#define BPF_NOEXIST	1 /* create new element if it didn't exist */
-#define BPF_EXIST	2 /* update existing element */
-#define BPF_F_LOCK	4 /* spin_lock-ed map_lookup/map_update */
+enum {
+	BPF_ANY		= 0, /* create new element or update existing */
+	BPF_NOEXIST	= 1, /* create new element if it didn't exist */
+	BPF_EXIST	= 2, /* update existing element */
+	BPF_F_LOCK	= 4, /* spin_lock-ed map_lookup/map_update */
+};
 
 /* flags for BPF_MAP_CREATE command */
-#define BPF_F_NO_PREALLOC	(1U << 0)
+enum {
+	BPF_F_NO_PREALLOC	= (1U << 0),
 /* Instead of having one common LRU list in the
  * BPF_MAP_TYPE_LRU_[PERCPU_]HASH map, use a percpu LRU list
  * which can scale and perform better.
  * Note, the LRU nodes (including free nodes) cannot be moved
  * across different LRU lists.
  */
-#define BPF_F_NO_COMMON_LRU	(1U << 1)
+	BPF_F_NO_COMMON_LRU	= (1U << 1),
 /* Specify numa node during map creation */
-#define BPF_F_NUMA_NODE		(1U << 2)
-
-#define BPF_OBJ_NAME_LEN 16U
+	BPF_F_NUMA_NODE		= (1U << 2),
 
 /* Flags for accessing BPF object from syscall side. */
-#define BPF_F_RDONLY		(1U << 3)
-#define BPF_F_WRONLY		(1U << 4)
+	BPF_F_RDONLY		= (1U << 3),
+	BPF_F_WRONLY		= (1U << 4),
 
 /* Flag for stack_map, store build_id+offset instead of pointer */
-#define BPF_F_STACK_BUILD_ID	(1U << 5)
+	BPF_F_STACK_BUILD_ID	= (1U << 5),
 
 /* Zero-initialize hash function seed. This should only be used for testing. */
-#define BPF_F_ZERO_SEED		(1U << 6)
+	BPF_F_ZERO_SEED		= (1U << 6),
 
 /* Flags for accessing BPF object from program side. */
-#define BPF_F_RDONLY_PROG	(1U << 7)
-#define BPF_F_WRONLY_PROG	(1U << 8)
+	BPF_F_RDONLY_PROG	= (1U << 7),
+	BPF_F_WRONLY_PROG	= (1U << 8),
 
 /* Clone map from listener for newly accepted socket */
-#define BPF_F_CLONE		(1U << 9)
+	BPF_F_CLONE		= (1U << 9),
 
 /* Enable memory-mapping BPF map */
-#define BPF_F_MMAPABLE		(1U << 10)
+	BPF_F_MMAPABLE		= (1U << 10),
+};
 
 /* Flags for BPF_PROG_QUERY. */
 
@@ -391,6 +393,8 @@ struct bpf_stack_build_id {
 	};
 };
 
+#define BPF_OBJ_NAME_LEN 16U
+
 union bpf_attr {
 	struct { /* anonymous struct used by BPF_MAP_CREATE command */
 		__u32	map_type;	/* one of enum bpf_map_type */
@@ -3045,72 +3049,100 @@ enum bpf_func_id {
 /* All flags used by eBPF helper functions, placed here. */
 
 /* BPF_FUNC_skb_store_bytes flags. */
-#define BPF_F_RECOMPUTE_CSUM		(1ULL << 0)
-#define BPF_F_INVALIDATE_HASH		(1ULL << 1)
+enum {
+	BPF_F_RECOMPUTE_CSUM		= (1ULL << 0),
+	BPF_F_INVALIDATE_HASH		= (1ULL << 1),
+};
 
 /* BPF_FUNC_l3_csum_replace and BPF_FUNC_l4_csum_replace flags.
  * First 4 bits are for passing the header field size.
  */
-#define BPF_F_HDR_FIELD_MASK		0xfULL
+enum {
+	BPF_F_HDR_FIELD_MASK		= 0xfULL,
+};
 
 /* BPF_FUNC_l4_csum_replace flags. */
-#define BPF_F_PSEUDO_HDR		(1ULL << 4)
-#define BPF_F_MARK_MANGLED_0		(1ULL << 5)
-#define BPF_F_MARK_ENFORCE		(1ULL << 6)
+enum {
+	BPF_F_PSEUDO_HDR		= (1ULL << 4),
+	BPF_F_MARK_MANGLED_0		= (1ULL << 5),
+	BPF_F_MARK_ENFORCE		= (1ULL << 6),
+};
 
 /* BPF_FUNC_clone_redirect and BPF_FUNC_redirect flags. */
-#define BPF_F_INGRESS			(1ULL << 0)
+enum {
+	BPF_F_INGRESS			= (1ULL << 0),
+};
 
 /* BPF_FUNC_skb_set_tunnel_key and BPF_FUNC_skb_get_tunnel_key flags. */
-#define BPF_F_TUNINFO_IPV6		(1ULL << 0)
+enum {
+	BPF_F_TUNINFO_IPV6		= (1ULL << 0),
+};
 
 /* flags for both BPF_FUNC_get_stackid and BPF_FUNC_get_stack. */
-#define BPF_F_SKIP_FIELD_MASK		0xffULL
-#define BPF_F_USER_STACK		(1ULL << 8)
+enum {
+	BPF_F_SKIP_FIELD_MASK		= 0xffULL,
+	BPF_F_USER_STACK		= (1ULL << 8),
 /* flags used by BPF_FUNC_get_stackid only. */
-#define BPF_F_FAST_STACK_CMP		(1ULL << 9)
-#define BPF_F_REUSE_STACKID		(1ULL << 10)
+	BPF_F_FAST_STACK_CMP		= (1ULL << 9),
+	BPF_F_REUSE_STACKID		= (1ULL << 10),
 /* flags used by BPF_FUNC_get_stack only. */
-#define BPF_F_USER_BUILD_ID		(1ULL << 11)
+	BPF_F_USER_BUILD_ID		= (1ULL << 11),
+};
 
 /* BPF_FUNC_skb_set_tunnel_key flags. */
-#define BPF_F_ZERO_CSUM_TX		(1ULL << 1)
-#define BPF_F_DONT_FRAGMENT		(1ULL << 2)
-#define BPF_F_SEQ_NUMBER		(1ULL << 3)
+enum {
+	BPF_F_ZERO_CSUM_TX		= (1ULL << 1),
+	BPF_F_DONT_FRAGMENT		= (1ULL << 2),
+	BPF_F_SEQ_NUMBER		= (1ULL << 3),
+};
 
 /* BPF_FUNC_perf_event_output, BPF_FUNC_perf_event_read and
  * BPF_FUNC_perf_event_read_value flags.
  */
-#define BPF_F_INDEX_MASK		0xffffffffULL
-#define BPF_F_CURRENT_CPU		BPF_F_INDEX_MASK
+enum {
+	BPF_F_INDEX_MASK		= 0xffffffffULL,
+	BPF_F_CURRENT_CPU		= BPF_F_INDEX_MASK,
 /* BPF_FUNC_perf_event_output for sk_buff input context. */
-#define BPF_F_CTXLEN_MASK		(0xfffffULL << 32)
+	BPF_F_CTXLEN_MASK		= (0xfffffULL << 32),
+};
 
 /* Current network namespace */
-#define BPF_F_CURRENT_NETNS		(-1L)
+enum {
+	BPF_F_CURRENT_NETNS		= (-1L),
+};
 
 /* BPF_FUNC_skb_adjust_room flags. */
-#define BPF_F_ADJ_ROOM_FIXED_GSO	(1ULL << 0)
+enum {
+	BPF_F_ADJ_ROOM_FIXED_GSO	= (1ULL << 0),
+	BPF_F_ADJ_ROOM_ENCAP_L3_IPV4	= (1ULL << 1),
+	BPF_F_ADJ_ROOM_ENCAP_L3_IPV6	= (1ULL << 2),
+	BPF_F_ADJ_ROOM_ENCAP_L4_GRE	= (1ULL << 3),
+	BPF_F_ADJ_ROOM_ENCAP_L4_UDP	= (1ULL << 4),
+};
 
-#define BPF_ADJ_ROOM_ENCAP_L2_MASK	0xff
-#define BPF_ADJ_ROOM_ENCAP_L2_SHIFT	56
+enum {
+	BPF_ADJ_ROOM_ENCAP_L2_MASK	= 0xff,
+	BPF_ADJ_ROOM_ENCAP_L2_SHIFT	= 56,
+};
 
-#define BPF_F_ADJ_ROOM_ENCAP_L3_IPV4	(1ULL << 1)
-#define BPF_F_ADJ_ROOM_ENCAP_L3_IPV6	(1ULL << 2)
-#define BPF_F_ADJ_ROOM_ENCAP_L4_GRE	(1ULL << 3)
-#define BPF_F_ADJ_ROOM_ENCAP_L4_UDP	(1ULL << 4)
 #define BPF_F_ADJ_ROOM_ENCAP_L2(len)	(((__u64)len & \
 					  BPF_ADJ_ROOM_ENCAP_L2_MASK) \
 					 << BPF_ADJ_ROOM_ENCAP_L2_SHIFT)
 
 /* BPF_FUNC_sysctl_get_name flags. */
-#define BPF_F_SYSCTL_BASE_NAME		(1ULL << 0)
+enum {
+	BPF_F_SYSCTL_BASE_NAME		= (1ULL << 0),
+};
 
 /* BPF_FUNC_sk_storage_get flags */
-#define BPF_SK_STORAGE_GET_F_CREATE	(1ULL << 0)
+enum {
+	BPF_SK_STORAGE_GET_F_CREATE	= (1ULL << 0),
+};
 
 /* BPF_FUNC_read_branch_records flags. */
-#define BPF_F_GET_BRANCH_RECORDS_SIZE	(1ULL << 0)
+enum {
+	BPF_F_GET_BRANCH_RECORDS_SIZE	= (1ULL << 0),
+};
 
 /* Mode for BPF_FUNC_skb_adjust_room helper. */
 enum bpf_adj_room_mode {
@@ -3528,13 +3560,14 @@ struct bpf_sock_ops {
 };
 
 /* Definitions for bpf_sock_ops_cb_flags */
-#define BPF_SOCK_OPS_RTO_CB_FLAG	(1<<0)
-#define BPF_SOCK_OPS_RETRANS_CB_FLAG	(1<<1)
-#define BPF_SOCK_OPS_STATE_CB_FLAG	(1<<2)
-#define BPF_SOCK_OPS_RTT_CB_FLAG	(1<<3)
-#define BPF_SOCK_OPS_ALL_CB_FLAGS       0xF		/* Mask of all currently
-							 * supported cb flags
-							 */
+enum {
+	BPF_SOCK_OPS_RTO_CB_FLAG	= (1<<0),
+	BPF_SOCK_OPS_RETRANS_CB_FLAG	= (1<<1),
+	BPF_SOCK_OPS_STATE_CB_FLAG	= (1<<2),
+	BPF_SOCK_OPS_RTT_CB_FLAG	= (1<<3),
+/* Mask of all currently supported cb flags */
+	BPF_SOCK_OPS_ALL_CB_FLAGS       = 0xF,
+};
 
 /* List of known BPF sock_ops operators.
  * New entries can only be added at the end
@@ -3613,8 +3646,10 @@ enum {
 	BPF_TCP_MAX_STATES	/* Leave at the end! */
 };
 
-#define TCP_BPF_IW		1001	/* Set TCP initial congestion window */
-#define TCP_BPF_SNDCWND_CLAMP	1002	/* Set sndcwnd_clamp */
+enum {
+	TCP_BPF_IW		= 1001,	/* Set TCP initial congestion window */
+	TCP_BPF_SNDCWND_CLAMP	= 1002,	/* Set sndcwnd_clamp */
+};
 
 struct bpf_perf_event_value {
 	__u64 counter;
@@ -3622,12 +3657,16 @@ struct bpf_perf_event_value {
 	__u64 running;
 };
 
-#define BPF_DEVCG_ACC_MKNOD	(1ULL << 0)
-#define BPF_DEVCG_ACC_READ	(1ULL << 1)
-#define BPF_DEVCG_ACC_WRITE	(1ULL << 2)
+enum {
+	BPF_DEVCG_ACC_MKNOD	= (1ULL << 0),
+	BPF_DEVCG_ACC_READ	= (1ULL << 1),
+	BPF_DEVCG_ACC_WRITE	= (1ULL << 2),
+};
 
-#define BPF_DEVCG_DEV_BLOCK	(1ULL << 0)
-#define BPF_DEVCG_DEV_CHAR	(1ULL << 1)
+enum {
+	BPF_DEVCG_DEV_BLOCK	= (1ULL << 0),
+	BPF_DEVCG_DEV_CHAR	= (1ULL << 1),
+};
 
 struct bpf_cgroup_dev_ctx {
 	/* access_type encoded as (BPF_DEVCG_ACC_* << 16) | BPF_DEVCG_DEV_* */
@@ -3643,8 +3682,10 @@ struct bpf_raw_tracepoint_args {
 /* DIRECT:  Skip the FIB rules and go to FIB table associated with device
  * OUTPUT:  Do lookup from egress perspective; default is ingress
  */
-#define BPF_FIB_LOOKUP_DIRECT  (1U << 0)
-#define BPF_FIB_LOOKUP_OUTPUT  (1U << 1)
+enum {
+	BPF_FIB_LOOKUP_DIRECT  = (1U << 0),
+	BPF_FIB_LOOKUP_OUTPUT  = (1U << 1),
+};
 
 enum {
 	BPF_FIB_LKUP_RET_SUCCESS,      /* lookup successful */
@@ -3716,9 +3757,11 @@ enum bpf_task_fd_type {
 	BPF_FD_TYPE_URETPROBE,		/* filename + offset */
 };
 
-#define BPF_FLOW_DISSECTOR_F_PARSE_1ST_FRAG		(1U << 0)
-#define BPF_FLOW_DISSECTOR_F_STOP_AT_FLOW_LABEL		(1U << 1)
-#define BPF_FLOW_DISSECTOR_F_STOP_AT_ENCAP		(1U << 2)
+enum {
+	BPF_FLOW_DISSECTOR_F_PARSE_1ST_FRAG		= (1U << 0),
+	BPF_FLOW_DISSECTOR_F_STOP_AT_FLOW_LABEL		= (1U << 1),
+	BPF_FLOW_DISSECTOR_F_STOP_AT_ENCAP		= (1U << 2),
+};
 
 struct bpf_flow_keys {
 	__u16	nhoff;
diff --git a/tools/include/uapi/linux/bpf.h b/tools/include/uapi/linux/bpf.h
index 906e9f2752db..3ce4e8759661 100644
--- a/tools/include/uapi/linux/bpf.h
+++ b/tools/include/uapi/linux/bpf.h
@@ -73,7 +73,7 @@ struct bpf_insn {
 /* Key of an a BPF_MAP_TYPE_LPM_TRIE entry */
 struct bpf_lpm_trie_key {
 	__u32	prefixlen;	/* up to 32 for AF_INET, 128 for AF_INET6 */
-	__u8	data[0];	/* Arbitrary size */
+	__u8	data[];	/* Arbitrary size */
 };
 
 struct bpf_cgroup_storage_key {
@@ -325,44 +325,46 @@ enum bpf_attach_type {
 #define BPF_PSEUDO_CALL		1
 
 /* flags for BPF_MAP_UPDATE_ELEM command */
-#define BPF_ANY		0 /* create new element or update existing */
-#define BPF_NOEXIST	1 /* create new element if it didn't exist */
-#define BPF_EXIST	2 /* update existing element */
-#define BPF_F_LOCK	4 /* spin_lock-ed map_lookup/map_update */
+enum {
+	BPF_ANY		= 0, /* create new element or update existing */
+	BPF_NOEXIST	= 1, /* create new element if it didn't exist */
+	BPF_EXIST	= 2, /* update existing element */
+	BPF_F_LOCK	= 4, /* spin_lock-ed map_lookup/map_update */
+};
 
 /* flags for BPF_MAP_CREATE command */
-#define BPF_F_NO_PREALLOC	(1U << 0)
+enum {
+	BPF_F_NO_PREALLOC	= (1U << 0),
 /* Instead of having one common LRU list in the
  * BPF_MAP_TYPE_LRU_[PERCPU_]HASH map, use a percpu LRU list
  * which can scale and perform better.
  * Note, the LRU nodes (including free nodes) cannot be moved
  * across different LRU lists.
  */
-#define BPF_F_NO_COMMON_LRU	(1U << 1)
+	BPF_F_NO_COMMON_LRU	= (1U << 1),
 /* Specify numa node during map creation */
-#define BPF_F_NUMA_NODE		(1U << 2)
-
-#define BPF_OBJ_NAME_LEN 16U
+	BPF_F_NUMA_NODE		= (1U << 2),
 
 /* Flags for accessing BPF object from syscall side. */
-#define BPF_F_RDONLY		(1U << 3)
-#define BPF_F_WRONLY		(1U << 4)
+	BPF_F_RDONLY		= (1U << 3),
+	BPF_F_WRONLY		= (1U << 4),
 
 /* Flag for stack_map, store build_id+offset instead of pointer */
-#define BPF_F_STACK_BUILD_ID	(1U << 5)
+	BPF_F_STACK_BUILD_ID	= (1U << 5),
 
 /* Zero-initialize hash function seed. This should only be used for testing. */
-#define BPF_F_ZERO_SEED		(1U << 6)
+	BPF_F_ZERO_SEED		= (1U << 6),
 
 /* Flags for accessing BPF object from program side. */
-#define BPF_F_RDONLY_PROG	(1U << 7)
-#define BPF_F_WRONLY_PROG	(1U << 8)
+	BPF_F_RDONLY_PROG	= (1U << 7),
+	BPF_F_WRONLY_PROG	= (1U << 8),
 
 /* Clone map from listener for newly accepted socket */
-#define BPF_F_CLONE		(1U << 9)
+	BPF_F_CLONE		= (1U << 9),
 
 /* Enable memory-mapping BPF map */
-#define BPF_F_MMAPABLE		(1U << 10)
+	BPF_F_MMAPABLE		= (1U << 10),
+};
 
 /* Flags for BPF_PROG_QUERY. */
 
@@ -391,6 +393,8 @@ struct bpf_stack_build_id {
 	};
 };
 
+#define BPF_OBJ_NAME_LEN 16U
+
 union bpf_attr {
 	struct { /* anonymous struct used by BPF_MAP_CREATE command */
 		__u32	map_type;	/* one of enum bpf_map_type */
@@ -3045,72 +3049,100 @@ enum bpf_func_id {
 /* All flags used by eBPF helper functions, placed here. */
 
 /* BPF_FUNC_skb_store_bytes flags. */
-#define BPF_F_RECOMPUTE_CSUM		(1ULL << 0)
-#define BPF_F_INVALIDATE_HASH		(1ULL << 1)
+enum {
+	BPF_F_RECOMPUTE_CSUM		= (1ULL << 0),
+	BPF_F_INVALIDATE_HASH		= (1ULL << 1),
+};
 
 /* BPF_FUNC_l3_csum_replace and BPF_FUNC_l4_csum_replace flags.
  * First 4 bits are for passing the header field size.
  */
-#define BPF_F_HDR_FIELD_MASK		0xfULL
+enum {
+	BPF_F_HDR_FIELD_MASK		= 0xfULL,
+};
 
 /* BPF_FUNC_l4_csum_replace flags. */
-#define BPF_F_PSEUDO_HDR		(1ULL << 4)
-#define BPF_F_MARK_MANGLED_0		(1ULL << 5)
-#define BPF_F_MARK_ENFORCE		(1ULL << 6)
+enum {
+	BPF_F_PSEUDO_HDR		= (1ULL << 4),
+	BPF_F_MARK_MANGLED_0		= (1ULL << 5),
+	BPF_F_MARK_ENFORCE		= (1ULL << 6),
+};
 
 /* BPF_FUNC_clone_redirect and BPF_FUNC_redirect flags. */
-#define BPF_F_INGRESS			(1ULL << 0)
+enum {
+	BPF_F_INGRESS			= (1ULL << 0),
+};
 
 /* BPF_FUNC_skb_set_tunnel_key and BPF_FUNC_skb_get_tunnel_key flags. */
-#define BPF_F_TUNINFO_IPV6		(1ULL << 0)
+enum {
+	BPF_F_TUNINFO_IPV6		= (1ULL << 0),
+};
 
 /* flags for both BPF_FUNC_get_stackid and BPF_FUNC_get_stack. */
-#define BPF_F_SKIP_FIELD_MASK		0xffULL
-#define BPF_F_USER_STACK		(1ULL << 8)
+enum {
+	BPF_F_SKIP_FIELD_MASK		= 0xffULL,
+	BPF_F_USER_STACK		= (1ULL << 8),
 /* flags used by BPF_FUNC_get_stackid only. */
-#define BPF_F_FAST_STACK_CMP		(1ULL << 9)
-#define BPF_F_REUSE_STACKID		(1ULL << 10)
+	BPF_F_FAST_STACK_CMP		= (1ULL << 9),
+	BPF_F_REUSE_STACKID		= (1ULL << 10),
 /* flags used by BPF_FUNC_get_stack only. */
-#define BPF_F_USER_BUILD_ID		(1ULL << 11)
+	BPF_F_USER_BUILD_ID		= (1ULL << 11),
+};
 
 /* BPF_FUNC_skb_set_tunnel_key flags. */
-#define BPF_F_ZERO_CSUM_TX		(1ULL << 1)
-#define BPF_F_DONT_FRAGMENT		(1ULL << 2)
-#define BPF_F_SEQ_NUMBER		(1ULL << 3)
+enum {
+	BPF_F_ZERO_CSUM_TX		= (1ULL << 1),
+	BPF_F_DONT_FRAGMENT		= (1ULL << 2),
+	BPF_F_SEQ_NUMBER		= (1ULL << 3),
+};
 
 /* BPF_FUNC_perf_event_output, BPF_FUNC_perf_event_read and
  * BPF_FUNC_perf_event_read_value flags.
  */
-#define BPF_F_INDEX_MASK		0xffffffffULL
-#define BPF_F_CURRENT_CPU		BPF_F_INDEX_MASK
+enum {
+	BPF_F_INDEX_MASK		= 0xffffffffULL,
+	BPF_F_CURRENT_CPU		= BPF_F_INDEX_MASK,
 /* BPF_FUNC_perf_event_output for sk_buff input context. */
-#define BPF_F_CTXLEN_MASK		(0xfffffULL << 32)
+	BPF_F_CTXLEN_MASK		= (0xfffffULL << 32),
+};
 
 /* Current network namespace */
-#define BPF_F_CURRENT_NETNS		(-1L)
+enum {
+	BPF_F_CURRENT_NETNS		= (-1L),
+};
 
 /* BPF_FUNC_skb_adjust_room flags. */
-#define BPF_F_ADJ_ROOM_FIXED_GSO	(1ULL << 0)
+enum {
+	BPF_F_ADJ_ROOM_FIXED_GSO	= (1ULL << 0),
+	BPF_F_ADJ_ROOM_ENCAP_L3_IPV4	= (1ULL << 1),
+	BPF_F_ADJ_ROOM_ENCAP_L3_IPV6	= (1ULL << 2),
+	BPF_F_ADJ_ROOM_ENCAP_L4_GRE	= (1ULL << 3),
+	BPF_F_ADJ_ROOM_ENCAP_L4_UDP	= (1ULL << 4),
+};
 
-#define BPF_ADJ_ROOM_ENCAP_L2_MASK	0xff
-#define BPF_ADJ_ROOM_ENCAP_L2_SHIFT	56
+enum {
+	BPF_ADJ_ROOM_ENCAP_L2_MASK	= 0xff,
+	BPF_ADJ_ROOM_ENCAP_L2_SHIFT	= 56,
+};
 
-#define BPF_F_ADJ_ROOM_ENCAP_L3_IPV4	(1ULL << 1)
-#define BPF_F_ADJ_ROOM_ENCAP_L3_IPV6	(1ULL << 2)
-#define BPF_F_ADJ_ROOM_ENCAP_L4_GRE	(1ULL << 3)
-#define BPF_F_ADJ_ROOM_ENCAP_L4_UDP	(1ULL << 4)
 #define BPF_F_ADJ_ROOM_ENCAP_L2(len)	(((__u64)len & \
 					  BPF_ADJ_ROOM_ENCAP_L2_MASK) \
 					 << BPF_ADJ_ROOM_ENCAP_L2_SHIFT)
 
 /* BPF_FUNC_sysctl_get_name flags. */
-#define BPF_F_SYSCTL_BASE_NAME		(1ULL << 0)
+enum {
+	BPF_F_SYSCTL_BASE_NAME		= (1ULL << 0),
+};
 
 /* BPF_FUNC_sk_storage_get flags */
-#define BPF_SK_STORAGE_GET_F_CREATE	(1ULL << 0)
+enum {
+	BPF_SK_STORAGE_GET_F_CREATE	= (1ULL << 0),
+};
 
 /* BPF_FUNC_read_branch_records flags. */
-#define BPF_F_GET_BRANCH_RECORDS_SIZE	(1ULL << 0)
+enum {
+	BPF_F_GET_BRANCH_RECORDS_SIZE	= (1ULL << 0),
+};
 
 /* Mode for BPF_FUNC_skb_adjust_room helper. */
 enum bpf_adj_room_mode {
@@ -3528,13 +3560,14 @@ struct bpf_sock_ops {
 };
 
 /* Definitions for bpf_sock_ops_cb_flags */
-#define BPF_SOCK_OPS_RTO_CB_FLAG	(1<<0)
-#define BPF_SOCK_OPS_RETRANS_CB_FLAG	(1<<1)
-#define BPF_SOCK_OPS_STATE_CB_FLAG	(1<<2)
-#define BPF_SOCK_OPS_RTT_CB_FLAG	(1<<3)
-#define BPF_SOCK_OPS_ALL_CB_FLAGS       0xF		/* Mask of all currently
-							 * supported cb flags
-							 */
+enum {
+	BPF_SOCK_OPS_RTO_CB_FLAG	= (1<<0),
+	BPF_SOCK_OPS_RETRANS_CB_FLAG	= (1<<1),
+	BPF_SOCK_OPS_STATE_CB_FLAG	= (1<<2),
+	BPF_SOCK_OPS_RTT_CB_FLAG	= (1<<3),
+/* Mask of all currently supported cb flags */
+	BPF_SOCK_OPS_ALL_CB_FLAGS       = 0xF,
+};
 
 /* List of known BPF sock_ops operators.
  * New entries can only be added at the end
@@ -3613,8 +3646,10 @@ enum {
 	BPF_TCP_MAX_STATES	/* Leave at the end! */
 };
 
-#define TCP_BPF_IW		1001	/* Set TCP initial congestion window */
-#define TCP_BPF_SNDCWND_CLAMP	1002	/* Set sndcwnd_clamp */
+enum {
+	TCP_BPF_IW		= 1001,	/* Set TCP initial congestion window */
+	TCP_BPF_SNDCWND_CLAMP	= 1002,	/* Set sndcwnd_clamp */
+};
 
 struct bpf_perf_event_value {
 	__u64 counter;
@@ -3622,12 +3657,16 @@ struct bpf_perf_event_value {
 	__u64 running;
 };
 
-#define BPF_DEVCG_ACC_MKNOD	(1ULL << 0)
-#define BPF_DEVCG_ACC_READ	(1ULL << 1)
-#define BPF_DEVCG_ACC_WRITE	(1ULL << 2)
+enum {
+	BPF_DEVCG_ACC_MKNOD	= (1ULL << 0),
+	BPF_DEVCG_ACC_READ	= (1ULL << 1),
+	BPF_DEVCG_ACC_WRITE	= (1ULL << 2),
+};
 
-#define BPF_DEVCG_DEV_BLOCK	(1ULL << 0)
-#define BPF_DEVCG_DEV_CHAR	(1ULL << 1)
+enum {
+	BPF_DEVCG_DEV_BLOCK	= (1ULL << 0),
+	BPF_DEVCG_DEV_CHAR	= (1ULL << 1),
+};
 
 struct bpf_cgroup_dev_ctx {
 	/* access_type encoded as (BPF_DEVCG_ACC_* << 16) | BPF_DEVCG_DEV_* */
@@ -3643,8 +3682,10 @@ struct bpf_raw_tracepoint_args {
 /* DIRECT:  Skip the FIB rules and go to FIB table associated with device
  * OUTPUT:  Do lookup from egress perspective; default is ingress
  */
-#define BPF_FIB_LOOKUP_DIRECT  (1U << 0)
-#define BPF_FIB_LOOKUP_OUTPUT  (1U << 1)
+enum {
+	BPF_FIB_LOOKUP_DIRECT  = (1U << 0),
+	BPF_FIB_LOOKUP_OUTPUT  = (1U << 1),
+};
 
 enum {
 	BPF_FIB_LKUP_RET_SUCCESS,      /* lookup successful */
@@ -3716,9 +3757,11 @@ enum bpf_task_fd_type {
 	BPF_FD_TYPE_URETPROBE,		/* filename + offset */
 };
 
-#define BPF_FLOW_DISSECTOR_F_PARSE_1ST_FRAG		(1U << 0)
-#define BPF_FLOW_DISSECTOR_F_STOP_AT_FLOW_LABEL		(1U << 1)
-#define BPF_FLOW_DISSECTOR_F_STOP_AT_ENCAP		(1U << 2)
+enum {
+	BPF_FLOW_DISSECTOR_F_PARSE_1ST_FRAG		= (1U << 0),
+	BPF_FLOW_DISSECTOR_F_STOP_AT_FLOW_LABEL		= (1U << 1),
+	BPF_FLOW_DISSECTOR_F_STOP_AT_ENCAP		= (1U << 2),
+};
 
 struct bpf_flow_keys {
 	__u16	nhoff;
-- 
2.17.1

