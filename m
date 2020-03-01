Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3F2F8174C08
	for <lists+netdev@lfdr.de>; Sun,  1 Mar 2020 07:25:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726366AbgCAGY5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 1 Mar 2020 01:24:57 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:14976 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726050AbgCAGY4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 1 Mar 2020 01:24:56 -0500
Received: from pps.filterd (m0001303.ppops.net [127.0.0.1])
        by m0001303.ppops.net (8.16.0.42/8.16.0.42) with SMTP id 0216OouZ005073
        for <netdev@vger.kernel.org>; Sat, 29 Feb 2020 22:24:52 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-type; s=facebook; bh=KJNUsKFKvXIuWzYaCOume/2l6nZagEf933h9FS0Hm3M=;
 b=Per0vWyc9eGbd6CPQbFpC50w7BbL7MvKzFSbgVBIfFJONtTOkNvc9HsjPyMihvRtn2k+
 4YW1V7StOpVjVHPqjjoswUdLs9fBaKPlFzF7Zbp+1pICwAL7bnj7IGVjVo28DKJNcVo+
 MvEkFELHi5KDhlm2gv0CygGEGzwovxqGaHQ= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by m0001303.ppops.net with ESMTP id 2yfmguk7vn-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Sat, 29 Feb 2020 22:24:51 -0800
Received: from intmgw001.03.ash8.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:83::6) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1779.2; Sat, 29 Feb 2020 22:24:14 -0800
Received: by devbig012.ftw2.facebook.com (Postfix, from userid 137359)
        id BB3522EC2CFD; Sat, 29 Feb 2020 22:24:10 -0800 (PST)
Smtp-Origin-Hostprefix: devbig
From:   Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Hostname: devbig012.ftw2.facebook.com
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>
CC:     <andrii.nakryiko@gmail.com>, <kernel-team@fb.com>,
        Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH v2 bpf-next 1/3] bpf: switch BPF UAPI #define constants to enums
Date:   Sat, 29 Feb 2020 22:24:03 -0800
Message-ID: <20200301062405.2850114-2-andriin@fb.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200301062405.2850114-1-andriin@fb.com>
References: <20200301062405.2850114-1-andriin@fb.com>
X-FB-Internal: Safe
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-03-01_01:2020-02-28,2020-03-01 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 clxscore=1015 malwarescore=0 suspectscore=25 impostorscore=0
 mlxlogscore=999 mlxscore=0 bulkscore=0 adultscore=0 lowpriorityscore=0
 phishscore=0 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2001150001 definitions=main-2003010050
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
flags and constants, which are frequently used with BPF helpers.

Signed-off-by: Andrii Nakryiko <andriin@fb.com>
---
 include/uapi/linux/bpf.h              | 272 +++++++++++++++----------
 include/uapi/linux/bpf_common.h       |  86 ++++----
 include/uapi/linux/btf.h              |  60 +++---
 tools/include/uapi/linux/bpf.h        | 274 ++++++++++++++++----------
 tools/include/uapi/linux/bpf_common.h |  86 ++++----
 tools/include/uapi/linux/btf.h        |  60 +++---
 6 files changed, 497 insertions(+), 341 deletions(-)

diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
index 8e98ced0963b..03e08f256bd1 100644
--- a/include/uapi/linux/bpf.h
+++ b/include/uapi/linux/bpf.h
@@ -14,34 +14,36 @@
 /* Extended instruction set based on top of classic BPF */
 
 /* instruction classes */
-#define BPF_JMP32	0x06	/* jmp mode in word width */
-#define BPF_ALU64	0x07	/* alu mode in double word width */
+enum {
+	BPF_JMP32	= 0x06,	/* jmp mode in word width */
+	BPF_ALU64	= 0x07,	/* alu mode in double word width */
 
 /* ld/ldx fields */
-#define BPF_DW		0x18	/* double word (64-bit) */
-#define BPF_XADD	0xc0	/* exclusive add */
+	BPF_DW		= 0x18,	/* double word (64-bit) */
+	BPF_XADD	= 0xc0,	/* exclusive add */
 
 /* alu/jmp fields */
-#define BPF_MOV		0xb0	/* mov reg to reg */
-#define BPF_ARSH	0xc0	/* sign extending arithmetic shift right */
+	BPF_MOV		= 0xb0,	/* mov reg to reg */
+	BPF_ARSH	= 0xc0,	/* sign extending arithmetic shift right */
 
 /* change endianness of a register */
-#define BPF_END		0xd0	/* flags for endianness conversion: */
-#define BPF_TO_LE	0x00	/* convert to little-endian */
-#define BPF_TO_BE	0x08	/* convert to big-endian */
-#define BPF_FROM_LE	BPF_TO_LE
-#define BPF_FROM_BE	BPF_TO_BE
+	BPF_END		= 0xd0,	/* flags for endianness conversion: */
+	BPF_TO_LE	= 0x00,	/* convert to little-endian */
+	BPF_TO_BE	= 0x08,	/* convert to big-endian */
+	BPF_FROM_LE	= BPF_TO_LE,
+	BPF_FROM_BE	= BPF_TO_BE,
 
 /* jmp encodings */
-#define BPF_JNE		0x50	/* jump != */
-#define BPF_JLT		0xa0	/* LT is unsigned, '<' */
-#define BPF_JLE		0xb0	/* LE is unsigned, '<=' */
-#define BPF_JSGT	0x60	/* SGT is signed '>', GT in x86 */
-#define BPF_JSGE	0x70	/* SGE is signed '>=', GE in x86 */
-#define BPF_JSLT	0xc0	/* SLT is signed, '<' */
-#define BPF_JSLE	0xd0	/* SLE is signed, '<=' */
-#define BPF_CALL	0x80	/* function call */
-#define BPF_EXIT	0x90	/* function return */
+	BPF_JNE		= 0x50,	/* jump != */
+	BPF_JLT		= 0xa0,	/* LT is unsigned, '<' */
+	BPF_JLE		= 0xb0,	/* LE is unsigned, '<=' */
+	BPF_JSGT	= 0x60,	/* SGT is signed '>', GT in x86 */
+	BPF_JSGE	= 0x70,	/* SGE is signed '>=', GE in x86 */
+	BPF_JSLT	= 0xc0,	/* SLT is signed, '<' */
+	BPF_JSLE	= 0xd0,	/* SLE is signed, '<=' */
+	BPF_CALL	= 0x80,	/* function call */
+	BPF_EXIT	= 0x90,	/* function return */
+};
 
 /* Register numbers */
 enum {
@@ -57,10 +59,9 @@ enum {
 	BPF_REG_9,
 	BPF_REG_10,
 	__MAX_BPF_REG,
-};
-
 /* BPF has 10 general purpose 64-bit registers and stack frame. */
-#define MAX_BPF_REG	__MAX_BPF_REG
+	MAX_BPF_REG = __MAX_BPF_REG,
+};
 
 struct bpf_insn {
 	__u8	code;		/* opcode */
@@ -210,11 +211,10 @@ enum bpf_attach_type {
 	BPF_TRACE_RAW_TP,
 	BPF_TRACE_FENTRY,
 	BPF_TRACE_FEXIT,
-	__MAX_BPF_ATTACH_TYPE
+	__MAX_BPF_ATTACH_TYPE,
+	MAX_BPF_ATTACH_TYPE = __MAX_BPF_ATTACH_TYPE,
 };
 
-#define MAX_BPF_ATTACH_TYPE __MAX_BPF_ATTACH_TYPE
-
 /* cgroup-bpf attach flags used in BPF_PROG_ATTACH command
  *
  * NONE(default): No further bpf programs allowed in the subtree.
@@ -259,16 +259,19 @@ enum bpf_attach_type {
  * All eligible programs are executed regardless of return code from
  * earlier programs.
  */
-#define BPF_F_ALLOW_OVERRIDE	(1U << 0)
-#define BPF_F_ALLOW_MULTI	(1U << 1)
-#define BPF_F_REPLACE		(1U << 2)
+enum {
+	BPF_F_ALLOW_OVERRIDE	= (1U << 0),
+	BPF_F_ALLOW_MULTI	= (1U << 1),
+	BPF_F_REPLACE		= (1U << 2),
+};
 
+enum {
 /* If BPF_F_STRICT_ALIGNMENT is used in BPF_PROG_LOAD command, the
  * verifier will perform strict alignment checking as if the kernel
  * has been built with CONFIG_EFFICIENT_UNALIGNED_ACCESS not set,
  * and NET_IP_ALIGN defined to 2.
  */
-#define BPF_F_STRICT_ALIGNMENT	(1U << 0)
+	BPF_F_STRICT_ALIGNMENT	= (1U << 0),
 
 /* If BPF_F_ANY_ALIGNMENT is used in BPF_PROF_LOAD command, the
  * verifier will allow any alignment whatsoever.  On platforms
@@ -282,7 +285,7 @@ enum bpf_attach_type {
  * of an unaligned access the alignment check would trigger before
  * the one we are interested in.
  */
-#define BPF_F_ANY_ALIGNMENT	(1U << 1)
+	BPF_F_ANY_ALIGNMENT	= (1U << 1),
 
 /* BPF_F_TEST_RND_HI32 is used in BPF_PROG_LOAD command for testing purpose.
  * Verifier does sub-register def/use analysis and identifies instructions whose
@@ -300,10 +303,11 @@ enum bpf_attach_type {
  * Then, if verifier is not doing correct analysis, such randomization will
  * regress tests to expose bugs.
  */
-#define BPF_F_TEST_RND_HI32	(1U << 2)
+	BPF_F_TEST_RND_HI32	= (1U << 2),
 
 /* The verifier internal test flag. Behavior is undefined */
-#define BPF_F_TEST_STATE_FREQ	(1U << 3)
+	BPF_F_TEST_STATE_FREQ	= (1U << 3),
+};
 
 /* When BPF ldimm64's insn[0].src_reg != 0 then this can have
  * two extensions:
@@ -316,61 +320,68 @@ enum bpf_attach_type {
  * ldimm64 rewrite:  address of map      address of map[0]+offset
  * verifier type:    CONST_PTR_TO_MAP    PTR_TO_MAP_VALUE
  */
-#define BPF_PSEUDO_MAP_FD	1
-#define BPF_PSEUDO_MAP_VALUE	2
+enum {
+	BPF_PSEUDO_MAP_FD	= 1,
+	BPF_PSEUDO_MAP_VALUE	= 2,
+};
 
 /* when bpf_call->src_reg == BPF_PSEUDO_CALL, bpf_call->imm == pc-relative
  * offset to another bpf function
  */
-#define BPF_PSEUDO_CALL		1
+enum {
+	BPF_PSEUDO_CALL		= 1,
+};
 
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
-
+enum {
 /* Query effective (directly attached + inherited from ancestor cgroups)
  * programs that will be executed for events within a cgroup.
  * attach_flags with this flag are returned only for directly attached programs.
  */
-#define BPF_F_QUERY_EFFECTIVE	(1U << 0)
+	BPF_F_QUERY_EFFECTIVE	= (1U << 0),
+};
 
 enum bpf_stack_build_id_status {
 	/* user space need an empty entry to identify end of a trace */
@@ -381,7 +392,11 @@ enum bpf_stack_build_id_status {
 	BPF_STACK_BUILD_ID_IP = 2,
 };
 
-#define BPF_BUILD_ID_SIZE 20
+enum {
+	BPF_OBJ_NAME_LEN	= 16,
+	BPF_BUILD_ID_SIZE	= 20,
+};
+
 struct bpf_stack_build_id {
 	__s32		status;
 	unsigned char	build_id[BPF_BUILD_ID_SIZE];
@@ -3045,72 +3060,100 @@ enum bpf_func_id {
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
@@ -3311,7 +3354,9 @@ struct bpf_xdp_sock {
 	__u32 queue_id;
 };
 
-#define XDP_PACKET_HEADROOM 256
+enum {
+	XDP_PACKET_HEADROOM = 256,
+};
 
 /* User return codes for XDP prog type.
  * A valid XDP program must return one of these defined values. All other
@@ -3385,7 +3430,9 @@ struct sk_reuseport_md {
 	__u32 hash;		/* A hash of the packet 4 tuples */
 };
 
-#define BPF_TAG_SIZE	8
+enum {
+	BPF_TAG_SIZE	= 8,
+};
 
 struct bpf_prog_info {
 	__u32 type;
@@ -3528,13 +3575,14 @@ struct bpf_sock_ops {
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
@@ -3613,8 +3661,10 @@ enum {
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
@@ -3622,12 +3672,16 @@ struct bpf_perf_event_value {
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
@@ -3643,8 +3697,10 @@ struct bpf_raw_tracepoint_args {
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
@@ -3716,9 +3772,11 @@ enum bpf_task_fd_type {
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
diff --git a/include/uapi/linux/bpf_common.h b/include/uapi/linux/bpf_common.h
index ee97668bdadb..9e8171689dd9 100644
--- a/include/uapi/linux/bpf_common.h
+++ b/include/uapi/linux/bpf_common.h
@@ -4,51 +4,63 @@
 
 /* Instruction classes */
 #define BPF_CLASS(code) ((code) & 0x07)
-#define		BPF_LD		0x00
-#define		BPF_LDX		0x01
-#define		BPF_ST		0x02
-#define		BPF_STX		0x03
-#define		BPF_ALU		0x04
-#define		BPF_JMP		0x05
-#define		BPF_RET		0x06
-#define		BPF_MISC        0x07
+enum {
+	BPF_LD		= 0x00,
+	BPF_LDX		= 0x01,
+	BPF_ST		= 0x02,
+	BPF_STX		= 0x03,
+	BPF_ALU		= 0x04,
+	BPF_JMP		= 0x05,
+	BPF_RET		= 0x06,
+	BPF_MISC	= 0x07,
+};
 
 /* ld/ldx fields */
 #define BPF_SIZE(code)  ((code) & 0x18)
-#define		BPF_W		0x00 /* 32-bit */
-#define		BPF_H		0x08 /* 16-bit */
-#define		BPF_B		0x10 /*  8-bit */
-/* eBPF		BPF_DW		0x18    64-bit */
+enum {
+	BPF_W		= 0x00, /* 32-bit */
+	BPF_H		= 0x08, /* 16-bit */
+	BPF_B		= 0x10, /*  8-bit */
+/* eBPF		BPF_DW		0x18,    64-bit */
+};
+
 #define BPF_MODE(code)  ((code) & 0xe0)
-#define		BPF_IMM		0x00
-#define		BPF_ABS		0x20
-#define		BPF_IND		0x40
-#define		BPF_MEM		0x60
-#define		BPF_LEN		0x80
-#define		BPF_MSH		0xa0
+enum {
+	BPF_IMM		= 0x00,
+	BPF_ABS		= 0x20,
+	BPF_IND		= 0x40,
+	BPF_MEM		= 0x60,
+	BPF_LEN		= 0x80,
+	BPF_MSH		= 0xa0,
+};
 
 /* alu/jmp fields */
 #define BPF_OP(code)    ((code) & 0xf0)
-#define		BPF_ADD		0x00
-#define		BPF_SUB		0x10
-#define		BPF_MUL		0x20
-#define		BPF_DIV		0x30
-#define		BPF_OR		0x40
-#define		BPF_AND		0x50
-#define		BPF_LSH		0x60
-#define		BPF_RSH		0x70
-#define		BPF_NEG		0x80
-#define		BPF_MOD		0x90
-#define		BPF_XOR		0xa0
-
-#define		BPF_JA		0x00
-#define		BPF_JEQ		0x10
-#define		BPF_JGT		0x20
-#define		BPF_JGE		0x30
-#define		BPF_JSET        0x40
+enum {
+	BPF_ADD		= 0x00,
+	BPF_SUB		= 0x10,
+	BPF_MUL		= 0x20,
+	BPF_DIV		= 0x30,
+	BPF_OR		= 0x40,
+	BPF_AND		= 0x50,
+	BPF_LSH		= 0x60,
+	BPF_RSH		= 0x70,
+	BPF_NEG		= 0x80,
+	BPF_MOD		= 0x90,
+	BPF_XOR		= 0xa0,
+
+	BPF_JA		= 0x00,
+	BPF_JEQ		= 0x10,
+	BPF_JGT		= 0x20,
+	BPF_JGE		= 0x30,
+	BPF_JSET        = 0x40,
+};
+
 #define BPF_SRC(code)   ((code) & 0x08)
-#define		BPF_K		0x00
-#define		BPF_X		0x08
+enum {
+	BPF_K		= 0x00,
+	BPF_X		= 0x08,
+};
 
 #ifndef BPF_MAXINSNS
 #define BPF_MAXINSNS 4096
diff --git a/include/uapi/linux/btf.h b/include/uapi/linux/btf.h
index 5a667107ad2c..e4f88eafb2a3 100644
--- a/include/uapi/linux/btf.h
+++ b/include/uapi/linux/btf.h
@@ -5,8 +5,10 @@
 
 #include <linux/types.h>
 
-#define BTF_MAGIC	0xeB9F
-#define BTF_VERSION	1
+enum {
+	BTF_MAGIC	= 0xeB9F,
+	BTF_VERSION	= 1,
+};
 
 struct btf_header {
 	__u16	magic;
@@ -21,12 +23,14 @@ struct btf_header {
 	__u32	str_len;	/* length of string section	*/
 };
 
+enum {
 /* Max # of type identifier */
-#define BTF_MAX_TYPE	0x000fffff
+	BTF_MAX_TYPE		= 0x000fffff,
 /* Max offset into the string section */
-#define BTF_MAX_NAME_OFFSET	0x00ffffff
+	BTF_MAX_NAME_OFFSET	= 0x00ffffff,
 /* Max # of struct/union/enum members or func args */
-#define BTF_MAX_VLEN	0xffff
+	BTF_MAX_VLEN		= 0xffff,
+};
 
 struct btf_type {
 	__u32 name_off;
@@ -56,24 +60,26 @@ struct btf_type {
 #define BTF_INFO_VLEN(info)	((info) & 0xffff)
 #define BTF_INFO_KFLAG(info)	((info) >> 31)
 
-#define BTF_KIND_UNKN		0	/* Unknown	*/
-#define BTF_KIND_INT		1	/* Integer	*/
-#define BTF_KIND_PTR		2	/* Pointer	*/
-#define BTF_KIND_ARRAY		3	/* Array	*/
-#define BTF_KIND_STRUCT		4	/* Struct	*/
-#define BTF_KIND_UNION		5	/* Union	*/
-#define BTF_KIND_ENUM		6	/* Enumeration	*/
-#define BTF_KIND_FWD		7	/* Forward	*/
-#define BTF_KIND_TYPEDEF	8	/* Typedef	*/
-#define BTF_KIND_VOLATILE	9	/* Volatile	*/
-#define BTF_KIND_CONST		10	/* Const	*/
-#define BTF_KIND_RESTRICT	11	/* Restrict	*/
-#define BTF_KIND_FUNC		12	/* Function	*/
-#define BTF_KIND_FUNC_PROTO	13	/* Function Proto	*/
-#define BTF_KIND_VAR		14	/* Variable	*/
-#define BTF_KIND_DATASEC	15	/* Section	*/
-#define BTF_KIND_MAX		BTF_KIND_DATASEC
-#define NR_BTF_KINDS		(BTF_KIND_MAX + 1)
+enum {
+	BTF_KIND_UNKN		= 0,	/* Unknown	*/
+	BTF_KIND_INT		= 1,	/* Integer	*/
+	BTF_KIND_PTR		= 2,	/* Pointer	*/
+	BTF_KIND_ARRAY		= 3,	/* Array	*/
+	BTF_KIND_STRUCT		= 4,	/* Struct	*/
+	BTF_KIND_UNION		= 5,	/* Union	*/
+	BTF_KIND_ENUM		= 6,	/* Enumeration	*/
+	BTF_KIND_FWD		= 7,	/* Forward	*/
+	BTF_KIND_TYPEDEF	= 8,	/* Typedef	*/
+	BTF_KIND_VOLATILE	= 9,	/* Volatile	*/
+	BTF_KIND_CONST		= 10,	/* Const	*/
+	BTF_KIND_RESTRICT	= 11,	/* Restrict	*/
+	BTF_KIND_FUNC		= 12,	/* Function	*/
+	BTF_KIND_FUNC_PROTO	= 13,	/* Function Proto	*/
+	BTF_KIND_VAR		= 14,	/* Variable	*/
+	BTF_KIND_DATASEC	= 15,	/* Section	*/
+	BTF_KIND_MAX		= BTF_KIND_DATASEC,
+	NR_BTF_KINDS		= BTF_KIND_MAX + 1,
+};
 
 /* For some specific BTF_KIND, "struct btf_type" is immediately
  * followed by extra data.
@@ -87,9 +93,11 @@ struct btf_type {
 #define BTF_INT_BITS(VAL)	((VAL)  & 0x000000ff)
 
 /* Attributes stored in the BTF_INT_ENCODING */
-#define BTF_INT_SIGNED	(1 << 0)
-#define BTF_INT_CHAR	(1 << 1)
-#define BTF_INT_BOOL	(1 << 2)
+enum {
+	BTF_INT_SIGNED	= (1 << 0),
+	BTF_INT_CHAR	= (1 << 1),
+	BTF_INT_BOOL	= (1 << 2),
+};
 
 /* BTF_KIND_ENUM is followed by multiple "struct btf_enum".
  * The exact number of btf_enum is stored in the vlen (of the
diff --git a/tools/include/uapi/linux/bpf.h b/tools/include/uapi/linux/bpf.h
index 906e9f2752db..03e08f256bd1 100644
--- a/tools/include/uapi/linux/bpf.h
+++ b/tools/include/uapi/linux/bpf.h
@@ -14,34 +14,36 @@
 /* Extended instruction set based on top of classic BPF */
 
 /* instruction classes */
-#define BPF_JMP32	0x06	/* jmp mode in word width */
-#define BPF_ALU64	0x07	/* alu mode in double word width */
+enum {
+	BPF_JMP32	= 0x06,	/* jmp mode in word width */
+	BPF_ALU64	= 0x07,	/* alu mode in double word width */
 
 /* ld/ldx fields */
-#define BPF_DW		0x18	/* double word (64-bit) */
-#define BPF_XADD	0xc0	/* exclusive add */
+	BPF_DW		= 0x18,	/* double word (64-bit) */
+	BPF_XADD	= 0xc0,	/* exclusive add */
 
 /* alu/jmp fields */
-#define BPF_MOV		0xb0	/* mov reg to reg */
-#define BPF_ARSH	0xc0	/* sign extending arithmetic shift right */
+	BPF_MOV		= 0xb0,	/* mov reg to reg */
+	BPF_ARSH	= 0xc0,	/* sign extending arithmetic shift right */
 
 /* change endianness of a register */
-#define BPF_END		0xd0	/* flags for endianness conversion: */
-#define BPF_TO_LE	0x00	/* convert to little-endian */
-#define BPF_TO_BE	0x08	/* convert to big-endian */
-#define BPF_FROM_LE	BPF_TO_LE
-#define BPF_FROM_BE	BPF_TO_BE
+	BPF_END		= 0xd0,	/* flags for endianness conversion: */
+	BPF_TO_LE	= 0x00,	/* convert to little-endian */
+	BPF_TO_BE	= 0x08,	/* convert to big-endian */
+	BPF_FROM_LE	= BPF_TO_LE,
+	BPF_FROM_BE	= BPF_TO_BE,
 
 /* jmp encodings */
-#define BPF_JNE		0x50	/* jump != */
-#define BPF_JLT		0xa0	/* LT is unsigned, '<' */
-#define BPF_JLE		0xb0	/* LE is unsigned, '<=' */
-#define BPF_JSGT	0x60	/* SGT is signed '>', GT in x86 */
-#define BPF_JSGE	0x70	/* SGE is signed '>=', GE in x86 */
-#define BPF_JSLT	0xc0	/* SLT is signed, '<' */
-#define BPF_JSLE	0xd0	/* SLE is signed, '<=' */
-#define BPF_CALL	0x80	/* function call */
-#define BPF_EXIT	0x90	/* function return */
+	BPF_JNE		= 0x50,	/* jump != */
+	BPF_JLT		= 0xa0,	/* LT is unsigned, '<' */
+	BPF_JLE		= 0xb0,	/* LE is unsigned, '<=' */
+	BPF_JSGT	= 0x60,	/* SGT is signed '>', GT in x86 */
+	BPF_JSGE	= 0x70,	/* SGE is signed '>=', GE in x86 */
+	BPF_JSLT	= 0xc0,	/* SLT is signed, '<' */
+	BPF_JSLE	= 0xd0,	/* SLE is signed, '<=' */
+	BPF_CALL	= 0x80,	/* function call */
+	BPF_EXIT	= 0x90,	/* function return */
+};
 
 /* Register numbers */
 enum {
@@ -57,10 +59,9 @@ enum {
 	BPF_REG_9,
 	BPF_REG_10,
 	__MAX_BPF_REG,
-};
-
 /* BPF has 10 general purpose 64-bit registers and stack frame. */
-#define MAX_BPF_REG	__MAX_BPF_REG
+	MAX_BPF_REG = __MAX_BPF_REG,
+};
 
 struct bpf_insn {
 	__u8	code;		/* opcode */
@@ -73,7 +74,7 @@ struct bpf_insn {
 /* Key of an a BPF_MAP_TYPE_LPM_TRIE entry */
 struct bpf_lpm_trie_key {
 	__u32	prefixlen;	/* up to 32 for AF_INET, 128 for AF_INET6 */
-	__u8	data[0];	/* Arbitrary size */
+	__u8	data[];	/* Arbitrary size */
 };
 
 struct bpf_cgroup_storage_key {
@@ -210,11 +211,10 @@ enum bpf_attach_type {
 	BPF_TRACE_RAW_TP,
 	BPF_TRACE_FENTRY,
 	BPF_TRACE_FEXIT,
-	__MAX_BPF_ATTACH_TYPE
+	__MAX_BPF_ATTACH_TYPE,
+	MAX_BPF_ATTACH_TYPE = __MAX_BPF_ATTACH_TYPE,
 };
 
-#define MAX_BPF_ATTACH_TYPE __MAX_BPF_ATTACH_TYPE
-
 /* cgroup-bpf attach flags used in BPF_PROG_ATTACH command
  *
  * NONE(default): No further bpf programs allowed in the subtree.
@@ -259,16 +259,19 @@ enum bpf_attach_type {
  * All eligible programs are executed regardless of return code from
  * earlier programs.
  */
-#define BPF_F_ALLOW_OVERRIDE	(1U << 0)
-#define BPF_F_ALLOW_MULTI	(1U << 1)
-#define BPF_F_REPLACE		(1U << 2)
+enum {
+	BPF_F_ALLOW_OVERRIDE	= (1U << 0),
+	BPF_F_ALLOW_MULTI	= (1U << 1),
+	BPF_F_REPLACE		= (1U << 2),
+};
 
+enum {
 /* If BPF_F_STRICT_ALIGNMENT is used in BPF_PROG_LOAD command, the
  * verifier will perform strict alignment checking as if the kernel
  * has been built with CONFIG_EFFICIENT_UNALIGNED_ACCESS not set,
  * and NET_IP_ALIGN defined to 2.
  */
-#define BPF_F_STRICT_ALIGNMENT	(1U << 0)
+	BPF_F_STRICT_ALIGNMENT	= (1U << 0),
 
 /* If BPF_F_ANY_ALIGNMENT is used in BPF_PROF_LOAD command, the
  * verifier will allow any alignment whatsoever.  On platforms
@@ -282,7 +285,7 @@ enum bpf_attach_type {
  * of an unaligned access the alignment check would trigger before
  * the one we are interested in.
  */
-#define BPF_F_ANY_ALIGNMENT	(1U << 1)
+	BPF_F_ANY_ALIGNMENT	= (1U << 1),
 
 /* BPF_F_TEST_RND_HI32 is used in BPF_PROG_LOAD command for testing purpose.
  * Verifier does sub-register def/use analysis and identifies instructions whose
@@ -300,10 +303,11 @@ enum bpf_attach_type {
  * Then, if verifier is not doing correct analysis, such randomization will
  * regress tests to expose bugs.
  */
-#define BPF_F_TEST_RND_HI32	(1U << 2)
+	BPF_F_TEST_RND_HI32	= (1U << 2),
 
 /* The verifier internal test flag. Behavior is undefined */
-#define BPF_F_TEST_STATE_FREQ	(1U << 3)
+	BPF_F_TEST_STATE_FREQ	= (1U << 3),
+};
 
 /* When BPF ldimm64's insn[0].src_reg != 0 then this can have
  * two extensions:
@@ -316,61 +320,68 @@ enum bpf_attach_type {
  * ldimm64 rewrite:  address of map      address of map[0]+offset
  * verifier type:    CONST_PTR_TO_MAP    PTR_TO_MAP_VALUE
  */
-#define BPF_PSEUDO_MAP_FD	1
-#define BPF_PSEUDO_MAP_VALUE	2
+enum {
+	BPF_PSEUDO_MAP_FD	= 1,
+	BPF_PSEUDO_MAP_VALUE	= 2,
+};
 
 /* when bpf_call->src_reg == BPF_PSEUDO_CALL, bpf_call->imm == pc-relative
  * offset to another bpf function
  */
-#define BPF_PSEUDO_CALL		1
+enum {
+	BPF_PSEUDO_CALL		= 1,
+};
 
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
-
+enum {
 /* Query effective (directly attached + inherited from ancestor cgroups)
  * programs that will be executed for events within a cgroup.
  * attach_flags with this flag are returned only for directly attached programs.
  */
-#define BPF_F_QUERY_EFFECTIVE	(1U << 0)
+	BPF_F_QUERY_EFFECTIVE	= (1U << 0),
+};
 
 enum bpf_stack_build_id_status {
 	/* user space need an empty entry to identify end of a trace */
@@ -381,7 +392,11 @@ enum bpf_stack_build_id_status {
 	BPF_STACK_BUILD_ID_IP = 2,
 };
 
-#define BPF_BUILD_ID_SIZE 20
+enum {
+	BPF_OBJ_NAME_LEN	= 16,
+	BPF_BUILD_ID_SIZE	= 20,
+};
+
 struct bpf_stack_build_id {
 	__s32		status;
 	unsigned char	build_id[BPF_BUILD_ID_SIZE];
@@ -3045,72 +3060,100 @@ enum bpf_func_id {
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
@@ -3311,7 +3354,9 @@ struct bpf_xdp_sock {
 	__u32 queue_id;
 };
 
-#define XDP_PACKET_HEADROOM 256
+enum {
+	XDP_PACKET_HEADROOM = 256,
+};
 
 /* User return codes for XDP prog type.
  * A valid XDP program must return one of these defined values. All other
@@ -3385,7 +3430,9 @@ struct sk_reuseport_md {
 	__u32 hash;		/* A hash of the packet 4 tuples */
 };
 
-#define BPF_TAG_SIZE	8
+enum {
+	BPF_TAG_SIZE	= 8,
+};
 
 struct bpf_prog_info {
 	__u32 type;
@@ -3528,13 +3575,14 @@ struct bpf_sock_ops {
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
@@ -3613,8 +3661,10 @@ enum {
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
@@ -3622,12 +3672,16 @@ struct bpf_perf_event_value {
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
@@ -3643,8 +3697,10 @@ struct bpf_raw_tracepoint_args {
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
@@ -3716,9 +3772,11 @@ enum bpf_task_fd_type {
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
diff --git a/tools/include/uapi/linux/bpf_common.h b/tools/include/uapi/linux/bpf_common.h
index ee97668bdadb..9e8171689dd9 100644
--- a/tools/include/uapi/linux/bpf_common.h
+++ b/tools/include/uapi/linux/bpf_common.h
@@ -4,51 +4,63 @@
 
 /* Instruction classes */
 #define BPF_CLASS(code) ((code) & 0x07)
-#define		BPF_LD		0x00
-#define		BPF_LDX		0x01
-#define		BPF_ST		0x02
-#define		BPF_STX		0x03
-#define		BPF_ALU		0x04
-#define		BPF_JMP		0x05
-#define		BPF_RET		0x06
-#define		BPF_MISC        0x07
+enum {
+	BPF_LD		= 0x00,
+	BPF_LDX		= 0x01,
+	BPF_ST		= 0x02,
+	BPF_STX		= 0x03,
+	BPF_ALU		= 0x04,
+	BPF_JMP		= 0x05,
+	BPF_RET		= 0x06,
+	BPF_MISC	= 0x07,
+};
 
 /* ld/ldx fields */
 #define BPF_SIZE(code)  ((code) & 0x18)
-#define		BPF_W		0x00 /* 32-bit */
-#define		BPF_H		0x08 /* 16-bit */
-#define		BPF_B		0x10 /*  8-bit */
-/* eBPF		BPF_DW		0x18    64-bit */
+enum {
+	BPF_W		= 0x00, /* 32-bit */
+	BPF_H		= 0x08, /* 16-bit */
+	BPF_B		= 0x10, /*  8-bit */
+/* eBPF		BPF_DW		0x18,    64-bit */
+};
+
 #define BPF_MODE(code)  ((code) & 0xe0)
-#define		BPF_IMM		0x00
-#define		BPF_ABS		0x20
-#define		BPF_IND		0x40
-#define		BPF_MEM		0x60
-#define		BPF_LEN		0x80
-#define		BPF_MSH		0xa0
+enum {
+	BPF_IMM		= 0x00,
+	BPF_ABS		= 0x20,
+	BPF_IND		= 0x40,
+	BPF_MEM		= 0x60,
+	BPF_LEN		= 0x80,
+	BPF_MSH		= 0xa0,
+};
 
 /* alu/jmp fields */
 #define BPF_OP(code)    ((code) & 0xf0)
-#define		BPF_ADD		0x00
-#define		BPF_SUB		0x10
-#define		BPF_MUL		0x20
-#define		BPF_DIV		0x30
-#define		BPF_OR		0x40
-#define		BPF_AND		0x50
-#define		BPF_LSH		0x60
-#define		BPF_RSH		0x70
-#define		BPF_NEG		0x80
-#define		BPF_MOD		0x90
-#define		BPF_XOR		0xa0
-
-#define		BPF_JA		0x00
-#define		BPF_JEQ		0x10
-#define		BPF_JGT		0x20
-#define		BPF_JGE		0x30
-#define		BPF_JSET        0x40
+enum {
+	BPF_ADD		= 0x00,
+	BPF_SUB		= 0x10,
+	BPF_MUL		= 0x20,
+	BPF_DIV		= 0x30,
+	BPF_OR		= 0x40,
+	BPF_AND		= 0x50,
+	BPF_LSH		= 0x60,
+	BPF_RSH		= 0x70,
+	BPF_NEG		= 0x80,
+	BPF_MOD		= 0x90,
+	BPF_XOR		= 0xa0,
+
+	BPF_JA		= 0x00,
+	BPF_JEQ		= 0x10,
+	BPF_JGT		= 0x20,
+	BPF_JGE		= 0x30,
+	BPF_JSET        = 0x40,
+};
+
 #define BPF_SRC(code)   ((code) & 0x08)
-#define		BPF_K		0x00
-#define		BPF_X		0x08
+enum {
+	BPF_K		= 0x00,
+	BPF_X		= 0x08,
+};
 
 #ifndef BPF_MAXINSNS
 #define BPF_MAXINSNS 4096
diff --git a/tools/include/uapi/linux/btf.h b/tools/include/uapi/linux/btf.h
index 5a667107ad2c..e4f88eafb2a3 100644
--- a/tools/include/uapi/linux/btf.h
+++ b/tools/include/uapi/linux/btf.h
@@ -5,8 +5,10 @@
 
 #include <linux/types.h>
 
-#define BTF_MAGIC	0xeB9F
-#define BTF_VERSION	1
+enum {
+	BTF_MAGIC	= 0xeB9F,
+	BTF_VERSION	= 1,
+};
 
 struct btf_header {
 	__u16	magic;
@@ -21,12 +23,14 @@ struct btf_header {
 	__u32	str_len;	/* length of string section	*/
 };
 
+enum {
 /* Max # of type identifier */
-#define BTF_MAX_TYPE	0x000fffff
+	BTF_MAX_TYPE		= 0x000fffff,
 /* Max offset into the string section */
-#define BTF_MAX_NAME_OFFSET	0x00ffffff
+	BTF_MAX_NAME_OFFSET	= 0x00ffffff,
 /* Max # of struct/union/enum members or func args */
-#define BTF_MAX_VLEN	0xffff
+	BTF_MAX_VLEN		= 0xffff,
+};
 
 struct btf_type {
 	__u32 name_off;
@@ -56,24 +60,26 @@ struct btf_type {
 #define BTF_INFO_VLEN(info)	((info) & 0xffff)
 #define BTF_INFO_KFLAG(info)	((info) >> 31)
 
-#define BTF_KIND_UNKN		0	/* Unknown	*/
-#define BTF_KIND_INT		1	/* Integer	*/
-#define BTF_KIND_PTR		2	/* Pointer	*/
-#define BTF_KIND_ARRAY		3	/* Array	*/
-#define BTF_KIND_STRUCT		4	/* Struct	*/
-#define BTF_KIND_UNION		5	/* Union	*/
-#define BTF_KIND_ENUM		6	/* Enumeration	*/
-#define BTF_KIND_FWD		7	/* Forward	*/
-#define BTF_KIND_TYPEDEF	8	/* Typedef	*/
-#define BTF_KIND_VOLATILE	9	/* Volatile	*/
-#define BTF_KIND_CONST		10	/* Const	*/
-#define BTF_KIND_RESTRICT	11	/* Restrict	*/
-#define BTF_KIND_FUNC		12	/* Function	*/
-#define BTF_KIND_FUNC_PROTO	13	/* Function Proto	*/
-#define BTF_KIND_VAR		14	/* Variable	*/
-#define BTF_KIND_DATASEC	15	/* Section	*/
-#define BTF_KIND_MAX		BTF_KIND_DATASEC
-#define NR_BTF_KINDS		(BTF_KIND_MAX + 1)
+enum {
+	BTF_KIND_UNKN		= 0,	/* Unknown	*/
+	BTF_KIND_INT		= 1,	/* Integer	*/
+	BTF_KIND_PTR		= 2,	/* Pointer	*/
+	BTF_KIND_ARRAY		= 3,	/* Array	*/
+	BTF_KIND_STRUCT		= 4,	/* Struct	*/
+	BTF_KIND_UNION		= 5,	/* Union	*/
+	BTF_KIND_ENUM		= 6,	/* Enumeration	*/
+	BTF_KIND_FWD		= 7,	/* Forward	*/
+	BTF_KIND_TYPEDEF	= 8,	/* Typedef	*/
+	BTF_KIND_VOLATILE	= 9,	/* Volatile	*/
+	BTF_KIND_CONST		= 10,	/* Const	*/
+	BTF_KIND_RESTRICT	= 11,	/* Restrict	*/
+	BTF_KIND_FUNC		= 12,	/* Function	*/
+	BTF_KIND_FUNC_PROTO	= 13,	/* Function Proto	*/
+	BTF_KIND_VAR		= 14,	/* Variable	*/
+	BTF_KIND_DATASEC	= 15,	/* Section	*/
+	BTF_KIND_MAX		= BTF_KIND_DATASEC,
+	NR_BTF_KINDS		= BTF_KIND_MAX + 1,
+};
 
 /* For some specific BTF_KIND, "struct btf_type" is immediately
  * followed by extra data.
@@ -87,9 +93,11 @@ struct btf_type {
 #define BTF_INT_BITS(VAL)	((VAL)  & 0x000000ff)
 
 /* Attributes stored in the BTF_INT_ENCODING */
-#define BTF_INT_SIGNED	(1 << 0)
-#define BTF_INT_CHAR	(1 << 1)
-#define BTF_INT_BOOL	(1 << 2)
+enum {
+	BTF_INT_SIGNED	= (1 << 0),
+	BTF_INT_CHAR	= (1 << 1),
+	BTF_INT_BOOL	= (1 << 2),
+};
 
 /* BTF_KIND_ENUM is followed by multiple "struct btf_enum".
  * The exact number of btf_enum is stored in the vlen (of the
-- 
2.17.1

