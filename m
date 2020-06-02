Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9A9BF1EBE8F
	for <lists+netdev@lfdr.de>; Tue,  2 Jun 2020 16:59:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726223AbgFBO6r (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Jun 2020 10:58:47 -0400
Received: from www62.your-server.de ([213.133.104.62]:37384 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726429AbgFBO6o (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Jun 2020 10:58:44 -0400
Received: from 75.57.196.178.dynamic.wline.res.cust.swisscom.ch ([178.196.57.75] helo=localhost)
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1jg8NF-0007bx-1s; Tue, 02 Jun 2020 16:58:41 +0200
From:   Daniel Borkmann <daniel@iogearbox.net>
To:     alexei.starovoitov@gmail.com
Cc:     lmb@cloudflare.com, alan.maguire@oracle.com, bpf@vger.kernel.org,
        netdev@vger.kernel.org, Daniel Borkmann <daniel@iogearbox.net>
Subject: [PATCH bpf 2/3] bpf: Add csum_level helper for fixing up csum levels
Date:   Tue,  2 Jun 2020 16:58:33 +0200
Message-Id: <279ae3717cb3d03c0ffeb511493c93c450a01e1a.1591108731.git.daniel@iogearbox.net>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <cover.1591108731.git.daniel@iogearbox.net>
References: <cover.1591108731.git.daniel@iogearbox.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.102.2/25831/Tue Jun  2 14:41:03 2020)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add a bpf_csum_level() helper which BPF programs can use in combination
with bpf_skb_adjust_room() when they pass in BPF_F_ADJ_ROOM_NO_CSUM_RESET
flag to the latter to avoid falling back to CHECKSUM_NONE.

The bpf_csum_level() allows to adjust CHECKSUM_UNNECESSARY skb->csum_levels
via BPF_CSUM_LEVEL_{INC,DEC} which calls __skb_{incr,decr}_checksum_unnecessary()
on the skb. The helper also allows a BPF_CSUM_LEVEL_RESET which sets the skb's
csum to CHECKSUM_NONE as well as a BPF_CSUM_LEVEL_QUERY to just return the
current level. Without this helper, there is no way to otherwise adjust the
skb->csum_level. I did not add an extra dummy flags as there is plenty of free
bitspace in level argument itself iff ever needed in future.

Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
---
 include/uapi/linux/bpf.h       | 43 +++++++++++++++++++++++++++++++++-
 net/core/filter.c              | 38 ++++++++++++++++++++++++++++++
 tools/include/uapi/linux/bpf.h | 43 +++++++++++++++++++++++++++++++++-
 3 files changed, 122 insertions(+), 2 deletions(-)

diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
index 3ba2bbbed80c..46622901cba7 100644
--- a/include/uapi/linux/bpf.h
+++ b/include/uapi/linux/bpf.h
@@ -3220,6 +3220,38 @@ union bpf_attr {
  *		calculation.
  *	Return
  *		Requested value, or 0, if flags are not recognized.
+ *
+ * int bpf_csum_level(struct sk_buff *skb, u64 level)
+ * 	Description
+ * 		Change the skbs checksum level by one layer up or down, or
+ * 		reset it entirely to none in order to have the stack perform
+ * 		checksum validation. The level is applicable to the following
+ * 		protocols: TCP, UDP, GRE, SCTP, FCOE. For example, a decap of
+ * 		| ETH | IP | UDP | GUE | IP | TCP | into | ETH | IP | TCP |
+ * 		through **bpf_skb_adjust_room**\ () helper with passing in
+ * 		**BPF_F_ADJ_ROOM_NO_CSUM_RESET** flag would require one	call
+ * 		to **bpf_csum_level**\ () with **BPF_CSUM_LEVEL_DEC** since
+ * 		the UDP header is removed. Similarly, an encap of the latter
+ * 		into the former could be accompanied by a helper call to
+ * 		**bpf_csum_level**\ () with **BPF_CSUM_LEVEL_INC** if the
+ * 		skb is still intended to be processed in higher layers of the
+ * 		stack instead of just egressing at tc.
+ *
+ * 		There are three supported level settings at this time:
+ *
+ * 		* **BPF_CSUM_LEVEL_INC**: Increases skb->csum_level for skbs
+ * 		  with CHECKSUM_UNNECESSARY.
+ * 		* **BPF_CSUM_LEVEL_DEC**: Decreases skb->csum_level for skbs
+ * 		  with CHECKSUM_UNNECESSARY.
+ * 		* **BPF_CSUM_LEVEL_RESET**: Resets skb->csum_level to 0 and
+ * 		  sets CHECKSUM_NONE to force checksum validation by the stack.
+ * 		* **BPF_CSUM_LEVEL_QUERY**: No-op, returns the current
+ * 		  skb->csum_level.
+ * 	Return
+ * 		0 on success, or a negative error in case of failure. In the
+ * 		case of **BPF_CSUM_LEVEL_QUERY**, the current skb->csum_level
+ * 		is returned or the error code -EACCES in case the skb is not
+ * 		subject to CHECKSUM_UNNECESSARY.
  */
 #define __BPF_FUNC_MAPPER(FN)		\
 	FN(unspec),			\
@@ -3356,7 +3388,8 @@ union bpf_attr {
 	FN(ringbuf_reserve),		\
 	FN(ringbuf_submit),		\
 	FN(ringbuf_discard),		\
-	FN(ringbuf_query),
+	FN(ringbuf_query),		\
+	FN(csum_level),
 
 /* integer value in 'imm' field of BPF_CALL instruction selects which helper
  * function eBPF program intends to call
@@ -3433,6 +3466,14 @@ enum {
 	BPF_F_CURRENT_NETNS		= (-1L),
 };
 
+/* BPF_FUNC_csum_level level values. */
+enum {
+	BPF_CSUM_LEVEL_QUERY,
+	BPF_CSUM_LEVEL_INC,
+	BPF_CSUM_LEVEL_DEC,
+	BPF_CSUM_LEVEL_RESET,
+};
+
 /* BPF_FUNC_skb_adjust_room flags. */
 enum {
 	BPF_F_ADJ_ROOM_FIXED_GSO	= (1ULL << 0),
diff --git a/net/core/filter.c b/net/core/filter.c
index 278dcc0af961..d01a244b5087 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -2015,6 +2015,40 @@ static const struct bpf_func_proto bpf_csum_update_proto = {
 	.arg2_type	= ARG_ANYTHING,
 };
 
+BPF_CALL_2(bpf_csum_level, struct sk_buff *, skb, u64, level)
+{
+	/* The interface is to be used in combination with bpf_skb_adjust_room()
+	 * for encap/decap of packet headers when BPF_F_ADJ_ROOM_NO_CSUM_RESET
+	 * is passed as flags, for example.
+	 */
+	switch (level) {
+	case BPF_CSUM_LEVEL_INC:
+		__skb_incr_checksum_unnecessary(skb);
+		break;
+	case BPF_CSUM_LEVEL_DEC:
+		__skb_decr_checksum_unnecessary(skb);
+		break;
+	case BPF_CSUM_LEVEL_RESET:
+		__skb_reset_checksum_unnecessary(skb);
+		break;
+	case BPF_CSUM_LEVEL_QUERY:
+		return skb->ip_summed == CHECKSUM_UNNECESSARY ?
+		       skb->csum_level : -EACCES;
+	default:
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
+static const struct bpf_func_proto bpf_csum_level_proto = {
+	.func		= bpf_csum_level,
+	.gpl_only	= false,
+	.ret_type	= RET_INTEGER,
+	.arg1_type	= ARG_PTR_TO_CTX,
+	.arg2_type	= ARG_ANYTHING,
+};
+
 static inline int __bpf_rx_skb(struct net_device *dev, struct sk_buff *skb)
 {
 	return dev_forward_skb(dev, skb);
@@ -6280,6 +6314,8 @@ tc_cls_act_func_proto(enum bpf_func_id func_id, const struct bpf_prog *prog)
 		return &bpf_csum_diff_proto;
 	case BPF_FUNC_csum_update:
 		return &bpf_csum_update_proto;
+	case BPF_FUNC_csum_level:
+		return &bpf_csum_level_proto;
 	case BPF_FUNC_l3_csum_replace:
 		return &bpf_l3_csum_replace_proto;
 	case BPF_FUNC_l4_csum_replace:
@@ -6613,6 +6649,8 @@ lwt_xmit_func_proto(enum bpf_func_id func_id, const struct bpf_prog *prog)
 		return &bpf_skb_store_bytes_proto;
 	case BPF_FUNC_csum_update:
 		return &bpf_csum_update_proto;
+	case BPF_FUNC_csum_level:
+		return &bpf_csum_level_proto;
 	case BPF_FUNC_l3_csum_replace:
 		return &bpf_l3_csum_replace_proto;
 	case BPF_FUNC_l4_csum_replace:
diff --git a/tools/include/uapi/linux/bpf.h b/tools/include/uapi/linux/bpf.h
index 3ba2bbbed80c..46622901cba7 100644
--- a/tools/include/uapi/linux/bpf.h
+++ b/tools/include/uapi/linux/bpf.h
@@ -3220,6 +3220,38 @@ union bpf_attr {
  *		calculation.
  *	Return
  *		Requested value, or 0, if flags are not recognized.
+ *
+ * int bpf_csum_level(struct sk_buff *skb, u64 level)
+ * 	Description
+ * 		Change the skbs checksum level by one layer up or down, or
+ * 		reset it entirely to none in order to have the stack perform
+ * 		checksum validation. The level is applicable to the following
+ * 		protocols: TCP, UDP, GRE, SCTP, FCOE. For example, a decap of
+ * 		| ETH | IP | UDP | GUE | IP | TCP | into | ETH | IP | TCP |
+ * 		through **bpf_skb_adjust_room**\ () helper with passing in
+ * 		**BPF_F_ADJ_ROOM_NO_CSUM_RESET** flag would require one	call
+ * 		to **bpf_csum_level**\ () with **BPF_CSUM_LEVEL_DEC** since
+ * 		the UDP header is removed. Similarly, an encap of the latter
+ * 		into the former could be accompanied by a helper call to
+ * 		**bpf_csum_level**\ () with **BPF_CSUM_LEVEL_INC** if the
+ * 		skb is still intended to be processed in higher layers of the
+ * 		stack instead of just egressing at tc.
+ *
+ * 		There are three supported level settings at this time:
+ *
+ * 		* **BPF_CSUM_LEVEL_INC**: Increases skb->csum_level for skbs
+ * 		  with CHECKSUM_UNNECESSARY.
+ * 		* **BPF_CSUM_LEVEL_DEC**: Decreases skb->csum_level for skbs
+ * 		  with CHECKSUM_UNNECESSARY.
+ * 		* **BPF_CSUM_LEVEL_RESET**: Resets skb->csum_level to 0 and
+ * 		  sets CHECKSUM_NONE to force checksum validation by the stack.
+ * 		* **BPF_CSUM_LEVEL_QUERY**: No-op, returns the current
+ * 		  skb->csum_level.
+ * 	Return
+ * 		0 on success, or a negative error in case of failure. In the
+ * 		case of **BPF_CSUM_LEVEL_QUERY**, the current skb->csum_level
+ * 		is returned or the error code -EACCES in case the skb is not
+ * 		subject to CHECKSUM_UNNECESSARY.
  */
 #define __BPF_FUNC_MAPPER(FN)		\
 	FN(unspec),			\
@@ -3356,7 +3388,8 @@ union bpf_attr {
 	FN(ringbuf_reserve),		\
 	FN(ringbuf_submit),		\
 	FN(ringbuf_discard),		\
-	FN(ringbuf_query),
+	FN(ringbuf_query),		\
+	FN(csum_level),
 
 /* integer value in 'imm' field of BPF_CALL instruction selects which helper
  * function eBPF program intends to call
@@ -3433,6 +3466,14 @@ enum {
 	BPF_F_CURRENT_NETNS		= (-1L),
 };
 
+/* BPF_FUNC_csum_level level values. */
+enum {
+	BPF_CSUM_LEVEL_QUERY,
+	BPF_CSUM_LEVEL_INC,
+	BPF_CSUM_LEVEL_DEC,
+	BPF_CSUM_LEVEL_RESET,
+};
+
 /* BPF_FUNC_skb_adjust_room flags. */
 enum {
 	BPF_F_ADJ_ROOM_FIXED_GSO	= (1ULL << 0),
-- 
2.21.0

