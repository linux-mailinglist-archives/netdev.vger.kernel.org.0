Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E414512F476
	for <lists+netdev@lfdr.de>; Fri,  3 Jan 2020 07:02:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726077AbgACGCt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Jan 2020 01:02:49 -0500
Received: from mx140-tc.baidu.com ([61.135.168.140]:49720 "EHLO
        tc-sys-mailedm02.tc.baidu.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725916AbgACGCs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Jan 2020 01:02:48 -0500
Received: from localhost (cp01-cos-dev01.cp01.baidu.com [10.92.119.46])
        by tc-sys-mailedm02.tc.baidu.com (Postfix) with ESMTP id 9B55611C0049;
        Fri,  3 Jan 2020 14:02:33 +0800 (CST)
From:   Li RongQing <lirongqing@baidu.com>
To:     netdev@vger.kernel.org, bpf@vger.kernel.org
Subject: [PATCH][bpf-next] bpf: change bpf_skb_generic_push type as void
Date:   Fri,  3 Jan 2020 14:02:33 +0800
Message-Id: <1578031353-27654-1-git-send-email-lirongqing@baidu.com>
X-Mailer: git-send-email 1.7.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

bpf_skb_generic_push always returns 0, not need to check
its return, so change its type as void

Signed-off-by: Li RongQing <lirongqing@baidu.com>
---
 net/core/filter.c | 30 ++++++++++--------------------
 1 file changed, 10 insertions(+), 20 deletions(-)

diff --git a/net/core/filter.c b/net/core/filter.c
index 42fd17c48c5f..1cbac34a4e11 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -2761,7 +2761,7 @@ static const struct bpf_func_proto bpf_skb_vlan_pop_proto = {
 	.arg1_type      = ARG_PTR_TO_CTX,
 };
 
-static int bpf_skb_generic_push(struct sk_buff *skb, u32 off, u32 len)
+static void bpf_skb_generic_push(struct sk_buff *skb, u32 off, u32 len)
 {
 	/* Caller already did skb_cow() with len as headroom,
 	 * so no need to do it here.
@@ -2775,7 +2775,6 @@ static int bpf_skb_generic_push(struct sk_buff *skb, u32 off, u32 len)
 	 * result for checksum complete when summing over
 	 * zeroed blocks.
 	 */
-	return 0;
 }
 
 static int bpf_skb_generic_pop(struct sk_buff *skb, u32 off, u32 len)
@@ -2793,24 +2792,19 @@ static int bpf_skb_generic_pop(struct sk_buff *skb, u32 off, u32 len)
 	return 0;
 }
 
-static int bpf_skb_net_hdr_push(struct sk_buff *skb, u32 off, u32 len)
+static void bpf_skb_net_hdr_push(struct sk_buff *skb, u32 off, u32 len)
 {
 	bool trans_same = skb->transport_header == skb->network_header;
-	int ret;
 
 	/* There's no need for __skb_push()/__skb_pull() pair to
 	 * get to the start of the mac header as we're guaranteed
 	 * to always start from here under eBPF.
 	 */
-	ret = bpf_skb_generic_push(skb, off, len);
-	if (likely(!ret)) {
-		skb->mac_header -= len;
-		skb->network_header -= len;
-		if (trans_same)
-			skb->transport_header = skb->network_header;
-	}
-
-	return ret;
+	bpf_skb_generic_push(skb, off, len);
+	skb->mac_header -= len;
+	skb->network_header -= len;
+	if (trans_same)
+		skb->transport_header = skb->network_header;
 }
 
 static int bpf_skb_net_hdr_pop(struct sk_buff *skb, u32 off, u32 len)
@@ -2843,9 +2837,7 @@ static int bpf_skb_proto_4_to_6(struct sk_buff *skb)
 	if (unlikely(ret < 0))
 		return ret;
 
-	ret = bpf_skb_net_hdr_push(skb, off, len_diff);
-	if (unlikely(ret < 0))
-		return ret;
+	bpf_skb_net_hdr_push(skb, off, len_diff);
 
 	if (skb_is_gso(skb)) {
 		struct skb_shared_info *shinfo = skb_shinfo(skb);
@@ -3050,9 +3042,7 @@ static int bpf_skb_net_grow(struct sk_buff *skb, u32 off, u32 len_diff,
 		inner_trans = skb->transport_header;
 	}
 
-	ret = bpf_skb_net_hdr_push(skb, off, len_diff);
-	if (unlikely(ret < 0))
-		return ret;
+	bpf_skb_net_hdr_push(skb, off, len_diff);
 
 	if (encap) {
 		skb->inner_mac_header = inner_net - inner_mac_len;
@@ -5144,7 +5134,7 @@ BPF_CALL_3(bpf_lwt_seg6_adjust_srh, struct sk_buff *, skb, u32, offset,
 		if (unlikely(ret < 0))
 			return ret;
 
-		ret = bpf_skb_net_hdr_push(skb, offset, len);
+		bpf_skb_net_hdr_push(skb, offset, len);
 	} else {
 		ret = bpf_skb_net_hdr_pop(skb, offset, -1 * len);
 	}
-- 
2.16.2

