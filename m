Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5E9AE135D54
	for <lists+netdev@lfdr.de>; Thu,  9 Jan 2020 17:00:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732760AbgAIQAF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Jan 2020 11:00:05 -0500
Received: from mga09.intel.com ([134.134.136.24]:6694 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730796AbgAIQAE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 9 Jan 2020 11:00:04 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga102.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 09 Jan 2020 08:00:03 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.69,414,1571727600"; 
   d="scan'208";a="218399237"
Received: from mjmartin-nuc02.mjmartin-nuc02 (HELO mjmartin-nuc02.sea.intel.com) ([10.251.4.119])
  by fmsmga008.fm.intel.com with ESMTP; 09 Jan 2020 08:00:03 -0800
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     netdev@vger.kernel.org, mptcp@lists.01.org
Cc:     Mat Martineau <mathew.j.martineau@linux.intel.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>, bpf@vger.kernel.org,
        Paolo Abeni <pabeni@redhat.com>,
        Matthieu Baerts <matthieu.baerts@tessares.net>
Subject: [PATCH net-next v7 02/11] sock: Make sk_protocol a 16-bit value
Date:   Thu,  9 Jan 2020 07:59:15 -0800
Message-Id: <20200109155924.30122-3-mathew.j.martineau@linux.intel.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200109155924.30122-1-mathew.j.martineau@linux.intel.com>
References: <20200109155924.30122-1-mathew.j.martineau@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Match the 16-bit width of skbuff->protocol. Fills an 8-bit hole so
sizeof(struct sock) does not change.

Also take care of BPF field access for sk_type/sk_protocol. Both of them
are now outside the bitfield, so we can use load instructions without
further shifting/masking.

v5 -> v6:
 - update eBPF accessors, too (Intel's kbuild test robot)
v2 -> v3:
 - keep 'sk_type' 2 bytes aligned (Eric)
v1 -> v2:
 - preserve sk_pacing_shift as bit field (Eric)

Cc: Alexei Starovoitov <ast@kernel.org>
Cc: Daniel Borkmann <daniel@iogearbox.net>
Cc: bpf@vger.kernel.org
Co-developed-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Co-developed-by: Matthieu Baerts <matthieu.baerts@tessares.net>
Signed-off-by: Matthieu Baerts <matthieu.baerts@tessares.net>
Signed-off-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
---
 include/net/sock.h          | 25 ++++------------
 include/trace/events/sock.h |  2 +-
 net/core/filter.c           | 60 ++++++++++++++-----------------------
 3 files changed, 28 insertions(+), 59 deletions(-)

diff --git a/include/net/sock.h b/include/net/sock.h
index 091e55428415..8766f9bc3e70 100644
--- a/include/net/sock.h
+++ b/include/net/sock.h
@@ -436,30 +436,15 @@ struct sock {
 	 * Because of non atomicity rules, all
 	 * changes are protected by socket lock.
 	 */
-	unsigned int		__sk_flags_offset[0];
-#ifdef __BIG_ENDIAN_BITFIELD
-#define SK_FL_PROTO_SHIFT  16
-#define SK_FL_PROTO_MASK   0x00ff0000
-
-#define SK_FL_TYPE_SHIFT   0
-#define SK_FL_TYPE_MASK    0x0000ffff
-#else
-#define SK_FL_PROTO_SHIFT  8
-#define SK_FL_PROTO_MASK   0x0000ff00
-
-#define SK_FL_TYPE_SHIFT   16
-#define SK_FL_TYPE_MASK    0xffff0000
-#endif
-
-	unsigned int		sk_padding : 1,
+	u8			sk_padding : 1,
 				sk_kern_sock : 1,
 				sk_no_check_tx : 1,
 				sk_no_check_rx : 1,
-				sk_userlocks : 4,
-				sk_protocol  : 8,
-				sk_type      : 16;
-	u16			sk_gso_max_segs;
+				sk_userlocks : 4;
 	u8			sk_pacing_shift;
+	u16			sk_type;
+	u16			sk_protocol;
+	u16			sk_gso_max_segs;
 	unsigned long	        sk_lingertime;
 	struct proto		*sk_prot_creator;
 	rwlock_t		sk_callback_lock;
diff --git a/include/trace/events/sock.h b/include/trace/events/sock.h
index 51fe9f6719eb..3ff12b90048d 100644
--- a/include/trace/events/sock.h
+++ b/include/trace/events/sock.h
@@ -147,7 +147,7 @@ TRACE_EVENT(inet_sock_set_state,
 		__field(__u16, sport)
 		__field(__u16, dport)
 		__field(__u16, family)
-		__field(__u8, protocol)
+		__field(__u16, protocol)
 		__array(__u8, saddr, 4)
 		__array(__u8, daddr, 4)
 		__array(__u8, saddr_v6, 16)
diff --git a/net/core/filter.c b/net/core/filter.c
index 42fd17c48c5f..ef01c5599501 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -7607,21 +7607,21 @@ u32 bpf_sock_convert_ctx_access(enum bpf_access_type type,
 		break;
 
 	case offsetof(struct bpf_sock, type):
-		BUILD_BUG_ON(HWEIGHT32(SK_FL_TYPE_MASK) != BITS_PER_BYTE * 2);
-		*insn++ = BPF_LDX_MEM(BPF_W, si->dst_reg, si->src_reg,
-				      offsetof(struct sock, __sk_flags_offset));
-		*insn++ = BPF_ALU32_IMM(BPF_AND, si->dst_reg, SK_FL_TYPE_MASK);
-		*insn++ = BPF_ALU32_IMM(BPF_RSH, si->dst_reg, SK_FL_TYPE_SHIFT);
-		*target_size = 2;
+		*insn++ = BPF_LDX_MEM(
+			BPF_FIELD_SIZEOF(struct sock, sk_type),
+			si->dst_reg, si->src_reg,
+			bpf_target_off(struct sock, sk_type,
+				       sizeof_field(struct sock, sk_type),
+				       target_size));
 		break;
 
 	case offsetof(struct bpf_sock, protocol):
-		BUILD_BUG_ON(HWEIGHT32(SK_FL_PROTO_MASK) != BITS_PER_BYTE);
-		*insn++ = BPF_LDX_MEM(BPF_W, si->dst_reg, si->src_reg,
-				      offsetof(struct sock, __sk_flags_offset));
-		*insn++ = BPF_ALU32_IMM(BPF_AND, si->dst_reg, SK_FL_PROTO_MASK);
-		*insn++ = BPF_ALU32_IMM(BPF_RSH, si->dst_reg, SK_FL_PROTO_SHIFT);
-		*target_size = 1;
+		*insn++ = BPF_LDX_MEM(
+			BPF_FIELD_SIZEOF(struct sock, sk_protocol),
+			si->dst_reg, si->src_reg,
+			bpf_target_off(struct sock, sk_protocol,
+				       sizeof_field(struct sock, sk_protocol),
+				       target_size));
 		break;
 
 	case offsetof(struct bpf_sock, src_ip4):
@@ -7903,20 +7903,13 @@ static u32 sock_addr_convert_ctx_access(enum bpf_access_type type,
 		break;
 
 	case offsetof(struct bpf_sock_addr, type):
-		SOCK_ADDR_LOAD_NESTED_FIELD_SIZE_OFF(
-			struct bpf_sock_addr_kern, struct sock, sk,
-			__sk_flags_offset, BPF_W, 0);
-		*insn++ = BPF_ALU32_IMM(BPF_AND, si->dst_reg, SK_FL_TYPE_MASK);
-		*insn++ = BPF_ALU32_IMM(BPF_RSH, si->dst_reg, SK_FL_TYPE_SHIFT);
+		SOCK_ADDR_LOAD_NESTED_FIELD(struct bpf_sock_addr_kern,
+					    struct sock, sk, sk_type);
 		break;
 
 	case offsetof(struct bpf_sock_addr, protocol):
-		SOCK_ADDR_LOAD_NESTED_FIELD_SIZE_OFF(
-			struct bpf_sock_addr_kern, struct sock, sk,
-			__sk_flags_offset, BPF_W, 0);
-		*insn++ = BPF_ALU32_IMM(BPF_AND, si->dst_reg, SK_FL_PROTO_MASK);
-		*insn++ = BPF_ALU32_IMM(BPF_RSH, si->dst_reg,
-					SK_FL_PROTO_SHIFT);
+		SOCK_ADDR_LOAD_NESTED_FIELD(struct bpf_sock_addr_kern,
+					    struct sock, sk, sk_protocol);
 		break;
 
 	case offsetof(struct bpf_sock_addr, msg_src_ip4):
@@ -8835,11 +8828,11 @@ sk_reuseport_is_valid_access(int off, int size,
 				    skb,				\
 				    SKB_FIELD)
 
-#define SK_REUSEPORT_LOAD_SK_FIELD_SIZE_OFF(SK_FIELD, BPF_SIZE, EXTRA_OFF) \
-	SOCK_ADDR_LOAD_NESTED_FIELD_SIZE_OFF(struct sk_reuseport_kern,	\
-					     struct sock,		\
-					     sk,			\
-					     SK_FIELD, BPF_SIZE, EXTRA_OFF)
+#define SK_REUSEPORT_LOAD_SK_FIELD(SK_FIELD)				\
+	SOCK_ADDR_LOAD_NESTED_FIELD(struct sk_reuseport_kern,		\
+				    struct sock,			\
+				    sk,					\
+				    SK_FIELD)
 
 static u32 sk_reuseport_convert_ctx_access(enum bpf_access_type type,
 					   const struct bpf_insn *si,
@@ -8863,16 +8856,7 @@ static u32 sk_reuseport_convert_ctx_access(enum bpf_access_type type,
 		break;
 
 	case offsetof(struct sk_reuseport_md, ip_protocol):
-		BUILD_BUG_ON(HWEIGHT32(SK_FL_PROTO_MASK) != BITS_PER_BYTE);
-		SK_REUSEPORT_LOAD_SK_FIELD_SIZE_OFF(__sk_flags_offset,
-						    BPF_W, 0);
-		*insn++ = BPF_ALU32_IMM(BPF_AND, si->dst_reg, SK_FL_PROTO_MASK);
-		*insn++ = BPF_ALU32_IMM(BPF_RSH, si->dst_reg,
-					SK_FL_PROTO_SHIFT);
-		/* SK_FL_PROTO_MASK and SK_FL_PROTO_SHIFT are endian
-		 * aware.  No further narrowing or masking is needed.
-		 */
-		*target_size = 1;
+		SK_REUSEPORT_LOAD_SK_FIELD(sk_protocol);
 		break;
 
 	case offsetof(struct sk_reuseport_md, data_end):
-- 
2.24.1

