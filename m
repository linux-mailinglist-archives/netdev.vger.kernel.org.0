Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ED78715C3E
	for <lists+netdev@lfdr.de>; Tue,  7 May 2019 08:02:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727881AbfEGFfs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 May 2019 01:35:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:55736 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727357AbfEGFfp (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 7 May 2019 01:35:45 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 862E620989;
        Tue,  7 May 2019 05:35:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557207344;
        bh=To6ntoFPkk+7s1H59Tx1g2okEXT3UKCDKafe5bRRc3k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xI6kGt/V77e2f4im+fnYM32aEqZ5pJSTbNy/szYMHZIsDO2DtRZT412tVUBBwv3Qo
         Izwzvpd18q7CoCp8vdZSuYvwkrnIMX1UzSGi1YBzwmfTHpbXF/bgrJcdQSOcUeg/2t
         bqpBAEPdGlRtQrDknltbwawxN0LgUBRQw0coEmgY=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Willem de Bruijn <willemb@google.com>, Yonghong Song <yhs@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Sasha Levin <alexander.levin@microsoft.com>,
        netdev@vger.kernel.org, bpf@vger.kernel.org
Subject: [PATCH AUTOSEL 5.0 96/99] bpf: only test gso type on gso packets
Date:   Tue,  7 May 2019 01:32:30 -0400
Message-Id: <20190507053235.29900-96-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190507053235.29900-1-sashal@kernel.org>
References: <20190507053235.29900-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Willem de Bruijn <willemb@google.com>

[ Upstream commit 4c3024debf62de4c6ac6d3cb4c0063be21d4f652 ]

BPF can adjust gso only for tcp bytestreams. Fail on other gso types.

But only on gso packets. It does not touch this field if !gso_size.

Fixes: b90efd225874 ("bpf: only adjust gso_size on bytestream protocols")
Signed-off-by: Willem de Bruijn <willemb@google.com>
Acked-by: Yonghong Song <yhs@fb.com>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Signed-off-by: Sasha Levin <alexander.levin@microsoft.com>
---
 include/linux/skbuff.h | 4 ++--
 net/core/filter.c      | 8 ++++----
 2 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
index bdb9563c64a0..b8679dcba96f 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -4212,10 +4212,10 @@ static inline bool skb_is_gso_sctp(const struct sk_buff *skb)
 	return skb_shinfo(skb)->gso_type & SKB_GSO_SCTP;
 }
 
+/* Note: Should be called only if skb_is_gso(skb) is true */
 static inline bool skb_is_gso_tcp(const struct sk_buff *skb)
 {
-	return skb_is_gso(skb) &&
-	       skb_shinfo(skb)->gso_type & (SKB_GSO_TCPV4 | SKB_GSO_TCPV6);
+	return skb_shinfo(skb)->gso_type & (SKB_GSO_TCPV4 | SKB_GSO_TCPV6);
 }
 
 static inline void skb_gso_reset(struct sk_buff *skb)
diff --git a/net/core/filter.c b/net/core/filter.c
index f7d0004fc160..ff07996515f2 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -2789,7 +2789,7 @@ static int bpf_skb_proto_4_to_6(struct sk_buff *skb)
 	u32 off = skb_mac_header_len(skb);
 	int ret;
 
-	if (!skb_is_gso_tcp(skb))
+	if (skb_is_gso(skb) && !skb_is_gso_tcp(skb))
 		return -ENOTSUPP;
 
 	ret = skb_cow(skb, len_diff);
@@ -2830,7 +2830,7 @@ static int bpf_skb_proto_6_to_4(struct sk_buff *skb)
 	u32 off = skb_mac_header_len(skb);
 	int ret;
 
-	if (!skb_is_gso_tcp(skb))
+	if (skb_is_gso(skb) && !skb_is_gso_tcp(skb))
 		return -ENOTSUPP;
 
 	ret = skb_unclone(skb, GFP_ATOMIC);
@@ -2955,7 +2955,7 @@ static int bpf_skb_net_grow(struct sk_buff *skb, u32 len_diff)
 	u32 off = skb_mac_header_len(skb) + bpf_skb_net_base_len(skb);
 	int ret;
 
-	if (!skb_is_gso_tcp(skb))
+	if (skb_is_gso(skb) && !skb_is_gso_tcp(skb))
 		return -ENOTSUPP;
 
 	ret = skb_cow(skb, len_diff);
@@ -2984,7 +2984,7 @@ static int bpf_skb_net_shrink(struct sk_buff *skb, u32 len_diff)
 	u32 off = skb_mac_header_len(skb) + bpf_skb_net_base_len(skb);
 	int ret;
 
-	if (!skb_is_gso_tcp(skb))
+	if (skb_is_gso(skb) && !skb_is_gso_tcp(skb))
 		return -ENOTSUPP;
 
 	ret = skb_unclone(skb, GFP_ATOMIC);
-- 
2.20.1

