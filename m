Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8BC4D139D91
	for <lists+netdev@lfdr.de>; Tue, 14 Jan 2020 00:42:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729078AbgAMXmw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Jan 2020 18:42:52 -0500
Received: from frisell.zx2c4.com ([192.95.5.64]:55677 "EHLO frisell.zx2c4.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728794AbgAMXmw (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 13 Jan 2020 18:42:52 -0500
Received: by frisell.zx2c4.com (ZX2C4 Mail Server) with ESMTP id 4baae44e;
        Mon, 13 Jan 2020 22:42:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha1; c=relaxed; d=zx2c4.com; h=from:to:cc
        :subject:date:message-id:in-reply-to:references:mime-version
        :content-transfer-encoding; s=mail; bh=EhwLIUjBjeBtpZCJnF1+3OnHk
        5M=; b=nli/K1ummPBJq/sbGgAd2bXjGAx4/JxlzIvKgFb9jHkDwtE9hLDYaL4ew
        hA+2whDyH6Ntqo9/bfxcyiMFb31IqZFUDAOIz20rjbeLLKfdDIvKq5GXhI7DafGh
        sUcsGWPIU3KqRDhtyU6aKQV8nlakOCacSnIkd7CsSMphdLR/kkVBR2nfEVz3FHWY
        FVCm8plAt4X3UqIeAfSJNwjWLvsP69KGvVcXxrbWH11Wp6xOvT0IpC0gCUWbXZwA
        Tx6UZKFiSZdvtlCpbEERsnhm8xn7jLnsjJte6xJXkI549ZjULETD+EYuK+X9iGU4
        +VnG56FEECG/uXP/8KhXL0hEUUxWQ==
Received: by frisell.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id c91f5f4e (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256:NO);
        Mon, 13 Jan 2020 22:42:52 +0000 (UTC)
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
To:     davem@davemloft.net, johannes@sipsolutions.net,
        netdev@vger.kernel.org
Cc:     "Jason A. Donenfeld" <Jason@zx2c4.com>
Subject: [PATCH net-next 2/8] net: udp: use skb_list_walk_safe helper for gso segments
Date:   Mon, 13 Jan 2020 18:42:27 -0500
Message-Id: <20200113234233.33886-3-Jason@zx2c4.com>
In-Reply-To: <20200113234233.33886-1-Jason@zx2c4.com>
References: <20200113234233.33886-1-Jason@zx2c4.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is a straight-forward conversion case for the new function,
iterating over the return value from udp_rcv_segment, which actually is
a wrapper around skb_gso_segment.

Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
---
 net/ipv4/udp.c | 3 +--
 net/ipv6/udp.c | 3 +--
 2 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/net/ipv4/udp.c b/net/ipv4/udp.c
index 93a355b6b092..208da0917469 100644
--- a/net/ipv4/udp.c
+++ b/net/ipv4/udp.c
@@ -2104,8 +2104,7 @@ static int udp_queue_rcv_skb(struct sock *sk, struct sk_buff *skb)
 	BUILD_BUG_ON(sizeof(struct udp_skb_cb) > SKB_SGO_CB_OFFSET);
 	__skb_push(skb, -skb_mac_offset(skb));
 	segs = udp_rcv_segment(sk, skb, true);
-	for (skb = segs; skb; skb = next) {
-		next = skb->next;
+	skb_list_walk_safe(segs, skb, next) {
 		__skb_pull(skb, skb_transport_offset(skb));
 		ret = udp_queue_rcv_one_skb(sk, skb);
 		if (ret > 0)
diff --git a/net/ipv6/udp.c b/net/ipv6/udp.c
index 9fec580c968e..5dc439a391fe 100644
--- a/net/ipv6/udp.c
+++ b/net/ipv6/udp.c
@@ -690,8 +690,7 @@ static int udpv6_queue_rcv_skb(struct sock *sk, struct sk_buff *skb)
 
 	__skb_push(skb, -skb_mac_offset(skb));
 	segs = udp_rcv_segment(sk, skb, false);
-	for (skb = segs; skb; skb = next) {
-		next = skb->next;
+	skb_list_walk_safe(segs, skb, next) {
 		__skb_pull(skb, skb_transport_offset(skb));
 
 		ret = udpv6_queue_rcv_one_skb(sk, skb);
-- 
2.24.1

