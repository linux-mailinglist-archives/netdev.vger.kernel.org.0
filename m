Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DDFFD1F2EB4
	for <lists+netdev@lfdr.de>; Tue,  9 Jun 2020 02:44:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730494AbgFIAob (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Jun 2020 20:44:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:59188 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729032AbgFHXMB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 8 Jun 2020 19:12:01 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2FB86208C3;
        Mon,  8 Jun 2020 23:12:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591657921;
        bh=Ji3Ox8FfuSJgnHkUYYxbKSP0jPzbzb+GuNsWy1ZFsTQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lF9uCPl4VZGcjcIUNMsQGPFj1GK7/bFfC9CJNRZsSc3bmrFb6CrsMoHkn/Ek9u3uN
         U6/faWMX6ukpwWWmIf0t0m6HPYRCQlE3KKA8m0TJLDrCdKdfQ6b+suiC85jZcrGGNX
         ips2/TnqJjEl1SLqKv37Uon8DwzcWP/mRlGTvo4Q=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Daniel Borkmann <daniel@iogearbox.net>,
        Lorenz Bauer <lmb@cloudflare.com>,
        Alan Maguire <alan.maguire@oracle.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Subject: [PATCH AUTOSEL 5.7 270/274] bpf: Fix up bpf_skb_adjust_room helper's skb csum setting
Date:   Mon,  8 Jun 2020 19:06:03 -0400
Message-Id: <20200608230607.3361041-270-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200608230607.3361041-1-sashal@kernel.org>
References: <20200608230607.3361041-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Daniel Borkmann <daniel@iogearbox.net>

[ Upstream commit 836e66c218f355ec01ba57671c85abf32961dcea ]

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
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Reviewed-by: Alan Maguire <alan.maguire@oracle.com>
Link: https://lore.kernel.org/bpf/CACAyw9-uU_52esMd1JjuA80fRPHJv5vsSg8GnfW3t_qDU4aVKQ@mail.gmail.com/
Link: https://lore.kernel.org/bpf/11a90472e7cce83e76ddbfce81fdfce7bfc68808.1591108731.git.daniel@iogearbox.net
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/skbuff.h         | 8 ++++++++
 include/uapi/linux/bpf.h       | 8 ++++++++
 net/core/filter.c              | 8 ++++++--
 tools/include/uapi/linux/bpf.h | 8 ++++++++
 4 files changed, 30 insertions(+), 2 deletions(-)

diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
index 3000c526f552..7e737a94bc63 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -3945,6 +3945,14 @@ static inline void __skb_incr_checksum_unnecessary(struct sk_buff *skb)
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
index f9b7fdd951e4..c01de7924e97 100644
--- a/include/uapi/linux/bpf.h
+++ b/include/uapi/linux/bpf.h
@@ -1589,6 +1589,13 @@ union bpf_attr {
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
@@ -3235,6 +3242,7 @@ enum {
 	BPF_F_ADJ_ROOM_ENCAP_L3_IPV6	= (1ULL << 2),
 	BPF_F_ADJ_ROOM_ENCAP_L4_GRE	= (1ULL << 3),
 	BPF_F_ADJ_ROOM_ENCAP_L4_UDP	= (1ULL << 4),
+	BPF_F_ADJ_ROOM_NO_CSUM_RESET	= (1ULL << 5),
 };
 
 enum {
diff --git a/net/core/filter.c b/net/core/filter.c
index 5cc9276f1023..11b97c31bca5 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -3124,7 +3124,8 @@ static int bpf_skb_net_shrink(struct sk_buff *skb, u32 off, u32 len_diff,
 {
 	int ret;
 
-	if (flags & ~BPF_F_ADJ_ROOM_FIXED_GSO)
+	if (unlikely(flags & ~(BPF_F_ADJ_ROOM_FIXED_GSO |
+			       BPF_F_ADJ_ROOM_NO_CSUM_RESET)))
 		return -EINVAL;
 
 	if (skb_is_gso(skb) && !skb_is_gso_tcp(skb)) {
@@ -3174,7 +3175,8 @@ BPF_CALL_4(bpf_skb_adjust_room, struct sk_buff *, skb, s32, len_diff,
 	u32 off;
 	int ret;
 
-	if (unlikely(flags & ~BPF_F_ADJ_ROOM_MASK))
+	if (unlikely(flags & ~(BPF_F_ADJ_ROOM_MASK |
+			       BPF_F_ADJ_ROOM_NO_CSUM_RESET)))
 		return -EINVAL;
 	if (unlikely(len_diff_abs > 0xfffU))
 		return -EFAULT;
@@ -3202,6 +3204,8 @@ BPF_CALL_4(bpf_skb_adjust_room, struct sk_buff *, skb, s32, len_diff,
 
 	ret = shrink ? bpf_skb_net_shrink(skb, off, len_diff_abs, flags) :
 		       bpf_skb_net_grow(skb, off, len_diff_abs, flags);
+	if (!ret && !(flags & BPF_F_ADJ_ROOM_NO_CSUM_RESET))
+		__skb_reset_checksum_unnecessary(skb);
 
 	bpf_compute_data_pointers(skb);
 	return ret;
diff --git a/tools/include/uapi/linux/bpf.h b/tools/include/uapi/linux/bpf.h
index 7bbf1b65be10..ad77cf9bb37e 100644
--- a/tools/include/uapi/linux/bpf.h
+++ b/tools/include/uapi/linux/bpf.h
@@ -1589,6 +1589,13 @@ union bpf_attr {
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
@@ -3235,6 +3242,7 @@ enum {
 	BPF_F_ADJ_ROOM_ENCAP_L3_IPV6	= (1ULL << 2),
 	BPF_F_ADJ_ROOM_ENCAP_L4_GRE	= (1ULL << 3),
 	BPF_F_ADJ_ROOM_ENCAP_L4_UDP	= (1ULL << 4),
+	BPF_F_ADJ_ROOM_NO_CSUM_RESET	= (1ULL << 5),
 };
 
 enum {
-- 
2.25.1

