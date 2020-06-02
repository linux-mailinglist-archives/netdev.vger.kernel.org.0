Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BD95F1EBE8B
	for <lists+netdev@lfdr.de>; Tue,  2 Jun 2020 16:59:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728087AbgFBO6o (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Jun 2020 10:58:44 -0400
Received: from www62.your-server.de ([213.133.104.62]:37380 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726311AbgFBO6n (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Jun 2020 10:58:43 -0400
Received: from 75.57.196.178.dynamic.wline.res.cust.swisscom.ch ([178.196.57.75] helo=localhost)
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1jg8NE-0007bm-Ii; Tue, 02 Jun 2020 16:58:40 +0200
From:   Daniel Borkmann <daniel@iogearbox.net>
To:     alexei.starovoitov@gmail.com
Cc:     lmb@cloudflare.com, alan.maguire@oracle.com, bpf@vger.kernel.org,
        netdev@vger.kernel.org, Daniel Borkmann <daniel@iogearbox.net>
Subject: [PATCH bpf 1/3] bpf: Fix up bpf_skb_adjust_room helper's skb csum setting
Date:   Tue,  2 Jun 2020 16:58:32 +0200
Message-Id: <11a90472e7cce83e76ddbfce81fdfce7bfc68808.1591108731.git.daniel@iogearbox.net>
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

Lorenz recently reported:

  In our TC classifier cls_redirect [0], we use the following sequence of
  helper calls to decapsulate a GUE (basically IP + UDP + custom header)
  encapsulated packet:

    bpf_skb_adjust_room(skb, -encap_len, BPF_ADJ_ROOM_MAC, BPF_F_ADJ_ROOM_FIXED_GSO)
    bpf_redirect(skb->ifindex, BPF_F_INGRESS)

  It seems like some checksums of the inner headers are not validated in
  this case. For example, a TCP SYN packet with invalid TCP checksum is
  still accepted by the network stack and elicits a SYN ACK. [...]

  That is, we receive the following packet from the driver:

    | ETH | IP | UDP | GUE | IP | TCP |
    skb->ip_summed == CHECKSUM_UNNECESSARY

  ip_summed is CHECKSUM_UNNECESSARY because our NICs do rx checksum offloading.
  On this packet we run skb_adjust_room_mac(-encap_len), and get the following:

    | ETH | IP | TCP |
    skb->ip_summed == CHECKSUM_UNNECESSARY

  Note that ip_summed is still CHECKSUM_UNNECESSARY. After bpf_redirect()'ing
  into the ingress, we end up in tcp_v4_rcv(). There, skb_checksum_init() is
  turned into a no-op due to CHECKSUM_UNNECESSARY.

The bpf_skb_adjust_room() helper is not aware of protocol specifics. Internally,
it handles the CHECKSUM_COMPLETE case via skb_postpull_rcsum(), but that does
not cover CHECKSUM_UNNECESSARY. In this case skb->csum_level of the original
skb prior to bpf_skb_adjust_room() call was 0, that is, covering UDP. Right now
there is no way to adjust the skb->csum_level. NICs that have checksum offload
disabled (CHECKSUM_NONE) or that support CHECKSUM_COMPLETE are not affected.

Use a safe default for CHECKSUM_UNNECESSARY by resetting to CHECKSUM_NONE and
add a flag to the helper called BPF_F_ADJ_ROOM_NO_CSUM_RESET that allows users
from opting out. Opting out is useful for the case where we don't remove/add
full protocol headers, or for the case where a user wants to adjust the csum
level manually e.g. through bpf_csum_level() helper that is added in subsequent
patch.

The bpf_skb_proto_{4_to_6,6_to_4}() for NAT64/46 translation from the BPF
bpf_skb_change_proto() helper uses bpf_skb_net_hdr_{push,pop}() pair internally
as well but doesn't change layers, only transitions between v4 to v6 and vice
versa, therefore no adoption is required there.

  [0] https://lore.kernel.org/bpf/20200424185556.7358-1-lmb@cloudflare.com/

Fixes: 2be7e212d541 ("bpf: add bpf_skb_adjust_room helper")
Reported-by: Lorenz Bauer <lmb@cloudflare.com>
Reported-by: Alan Maguire <alan.maguire@oracle.com>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Signed-off-by: Lorenz Bauer <lmb@cloudflare.com>
Reviewed-by: Alan Maguire <alan.maguire@oracle.com>
Link: https://lore.kernel.org/bpf/CACAyw9-uU_52esMd1JjuA80fRPHJv5vsSg8GnfW3t_qDU4aVKQ@mail.gmail.com/
---
 include/linux/skbuff.h         | 8 ++++++++
 include/uapi/linux/bpf.h       | 8 ++++++++
 net/core/filter.c              | 8 ++++++--
 tools/include/uapi/linux/bpf.h | 8 ++++++++
 4 files changed, 30 insertions(+), 2 deletions(-)

diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
index a0d5c2760103..0c0377fc00c2 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -3919,6 +3919,14 @@ static inline void __skb_incr_checksum_unnecessary(struct sk_buff *skb)
 	}
 }
 
+static inline void __skb_reset_checksum_unnecessary(struct sk_buff *skb)
+{
+	if (skb->ip_summed == CHECKSUM_UNNECESSARY) {
+		skb->ip_summed = CHECKSUM_NONE;
+		skb->csum_level = 0;
+	}
+}
+
 /* Check if we need to perform checksum complete validation.
  *
  * Returns true if checksum complete is needed, false otherwise
diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
index b9ed9f14f2a2..3ba2bbbed80c 100644
--- a/include/uapi/linux/bpf.h
+++ b/include/uapi/linux/bpf.h
@@ -1635,6 +1635,13 @@ union bpf_attr {
  * 		Grow or shrink the room for data in the packet associated to
  * 		*skb* by *len_diff*, and according to the selected *mode*.
  *
+ * 		By default, the helper will reset any offloaded checksum
+ * 		indicator of the skb to CHECKSUM_NONE. This can be avoided
+ * 		by the following flag:
+ *
+ * 		* **BPF_F_ADJ_ROOM_NO_CSUM_RESET**: Do not reset offloaded
+ * 		  checksum data of the skb to CHECKSUM_NONE.
+ *
  *		There are two supported modes at this time:
  *
  *		* **BPF_ADJ_ROOM_MAC**: Adjust room at the mac layer
@@ -3433,6 +3440,7 @@ enum {
 	BPF_F_ADJ_ROOM_ENCAP_L3_IPV6	= (1ULL << 2),
 	BPF_F_ADJ_ROOM_ENCAP_L4_GRE	= (1ULL << 3),
 	BPF_F_ADJ_ROOM_ENCAP_L4_UDP	= (1ULL << 4),
+	BPF_F_ADJ_ROOM_NO_CSUM_RESET	= (1ULL << 5),
 };
 
 enum {
diff --git a/net/core/filter.c b/net/core/filter.c
index ae82bcb03124..278dcc0af961 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -3113,7 +3113,8 @@ static int bpf_skb_net_shrink(struct sk_buff *skb, u32 off, u32 len_diff,
 {
 	int ret;
 
-	if (flags & ~BPF_F_ADJ_ROOM_FIXED_GSO)
+	if (unlikely(flags & ~(BPF_F_ADJ_ROOM_FIXED_GSO |
+			       BPF_F_ADJ_ROOM_NO_CSUM_RESET)))
 		return -EINVAL;
 
 	if (skb_is_gso(skb) && !skb_is_gso_tcp(skb)) {
@@ -3163,7 +3164,8 @@ BPF_CALL_4(bpf_skb_adjust_room, struct sk_buff *, skb, s32, len_diff,
 	u32 off;
 	int ret;
 
-	if (unlikely(flags & ~BPF_F_ADJ_ROOM_MASK))
+	if (unlikely(flags & ~(BPF_F_ADJ_ROOM_MASK |
+			       BPF_F_ADJ_ROOM_NO_CSUM_RESET)))
 		return -EINVAL;
 	if (unlikely(len_diff_abs > 0xfffU))
 		return -EFAULT;
@@ -3191,6 +3193,8 @@ BPF_CALL_4(bpf_skb_adjust_room, struct sk_buff *, skb, s32, len_diff,
 
 	ret = shrink ? bpf_skb_net_shrink(skb, off, len_diff_abs, flags) :
 		       bpf_skb_net_grow(skb, off, len_diff_abs, flags);
+	if (!ret && !(flags & BPF_F_ADJ_ROOM_NO_CSUM_RESET))
+		__skb_reset_checksum_unnecessary(skb);
 
 	bpf_compute_data_pointers(skb);
 	return ret;
diff --git a/tools/include/uapi/linux/bpf.h b/tools/include/uapi/linux/bpf.h
index b9ed9f14f2a2..3ba2bbbed80c 100644
--- a/tools/include/uapi/linux/bpf.h
+++ b/tools/include/uapi/linux/bpf.h
@@ -1635,6 +1635,13 @@ union bpf_attr {
  * 		Grow or shrink the room for data in the packet associated to
  * 		*skb* by *len_diff*, and according to the selected *mode*.
  *
+ * 		By default, the helper will reset any offloaded checksum
+ * 		indicator of the skb to CHECKSUM_NONE. This can be avoided
+ * 		by the following flag:
+ *
+ * 		* **BPF_F_ADJ_ROOM_NO_CSUM_RESET**: Do not reset offloaded
+ * 		  checksum data of the skb to CHECKSUM_NONE.
+ *
  *		There are two supported modes at this time:
  *
  *		* **BPF_ADJ_ROOM_MAC**: Adjust room at the mac layer
@@ -3433,6 +3440,7 @@ enum {
 	BPF_F_ADJ_ROOM_ENCAP_L3_IPV6	= (1ULL << 2),
 	BPF_F_ADJ_ROOM_ENCAP_L4_GRE	= (1ULL << 3),
 	BPF_F_ADJ_ROOM_ENCAP_L4_UDP	= (1ULL << 4),
+	BPF_F_ADJ_ROOM_NO_CSUM_RESET	= (1ULL << 5),
 };
 
 enum {
-- 
2.21.0

