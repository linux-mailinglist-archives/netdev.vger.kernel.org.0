Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B8CC913F4FF
	for <lists+netdev@lfdr.de>; Thu, 16 Jan 2020 19:53:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437133AbgAPSx3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jan 2020 13:53:29 -0500
Received: from mail.kernel.org ([198.145.29.99]:41432 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729262AbgAPRIN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 16 Jan 2020 12:08:13 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 47CC224687;
        Thu, 16 Jan 2020 17:08:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579194492;
        bh=t9t6gy9pWd6c2UzdRr7ngXWkrFc5wXb5Du/woiRoHnE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Yxht9JtTwu4QISo4JeeXgxgGWxHDirrq1B/18c8aq6BZfXmVkF/2V/p3fFrHj5gTU
         QKm2SRroZk3Vh05JNa8F7BiZMqeXafkMCkZ1P04vx0jzDMK12Rj6zgxNfcoDmKrcUU
         Ld2SdCDi2w9wWo90DvRNWlU3jvvytphPBwsmswug=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Stephen Hemminger <stephen@networkplumber.org>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 390/671] net: core: support XDP generic on stacked devices.
Date:   Thu, 16 Jan 2020 12:00:28 -0500
Message-Id: <20200116170509.12787-127-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200116170509.12787-1-sashal@kernel.org>
References: <20200116170509.12787-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Stephen Hemminger <stephen@networkplumber.org>

[ Upstream commit 458bf2f224f04a513b0be972f8708e78ee2c986e ]

When a device is stacked like (team, bonding, failsafe or netvsc) the
XDP generic program for the parent device was not called.

Move the call to XDP generic inside __netif_receive_skb_core where
it can be done multiple times for stacked case.

Fixes: d445516966dc ("net: xdp: support xdp generic on virtual devices")
Signed-off-by: Stephen Hemminger <sthemmin@microsoft.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/dev.c | 58 +++++++++++---------------------------------------
 1 file changed, 12 insertions(+), 46 deletions(-)

diff --git a/net/core/dev.c b/net/core/dev.c
index a26d87073f71..935fe158cfaf 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -4465,23 +4465,6 @@ static int netif_rx_internal(struct sk_buff *skb)
 
 	trace_netif_rx(skb);
 
-	if (static_branch_unlikely(&generic_xdp_needed_key)) {
-		int ret;
-
-		preempt_disable();
-		rcu_read_lock();
-		ret = do_xdp_generic(rcu_dereference(skb->dev->xdp_prog), skb);
-		rcu_read_unlock();
-		preempt_enable();
-
-		/* Consider XDP consuming the packet a success from
-		 * the netdev point of view we do not want to count
-		 * this as an error.
-		 */
-		if (ret != XDP_PASS)
-			return NET_RX_SUCCESS;
-	}
-
 #ifdef CONFIG_RPS
 	if (static_key_false(&rps_needed)) {
 		struct rps_dev_flow voidflow, *rflow = &voidflow;
@@ -4815,6 +4798,18 @@ static int __netif_receive_skb_core(struct sk_buff *skb, bool pfmemalloc,
 
 	__this_cpu_inc(softnet_data.processed);
 
+	if (static_branch_unlikely(&generic_xdp_needed_key)) {
+		int ret2;
+
+		preempt_disable();
+		ret2 = do_xdp_generic(rcu_dereference(skb->dev->xdp_prog), skb);
+		preempt_enable();
+
+		if (ret2 != XDP_PASS)
+			return NET_RX_DROP;
+		skb_reset_mac_len(skb);
+	}
+
 	if (skb->protocol == cpu_to_be16(ETH_P_8021Q) ||
 	    skb->protocol == cpu_to_be16(ETH_P_8021AD)) {
 		skb = skb_vlan_untag(skb);
@@ -5133,19 +5128,6 @@ static int netif_receive_skb_internal(struct sk_buff *skb)
 	if (skb_defer_rx_timestamp(skb))
 		return NET_RX_SUCCESS;
 
-	if (static_branch_unlikely(&generic_xdp_needed_key)) {
-		int ret;
-
-		preempt_disable();
-		rcu_read_lock();
-		ret = do_xdp_generic(rcu_dereference(skb->dev->xdp_prog), skb);
-		rcu_read_unlock();
-		preempt_enable();
-
-		if (ret != XDP_PASS)
-			return NET_RX_DROP;
-	}
-
 	rcu_read_lock();
 #ifdef CONFIG_RPS
 	if (static_key_false(&rps_needed)) {
@@ -5166,7 +5148,6 @@ static int netif_receive_skb_internal(struct sk_buff *skb)
 
 static void netif_receive_skb_list_internal(struct list_head *head)
 {
-	struct bpf_prog *xdp_prog = NULL;
 	struct sk_buff *skb, *next;
 	struct list_head sublist;
 
@@ -5179,21 +5160,6 @@ static void netif_receive_skb_list_internal(struct list_head *head)
 	}
 	list_splice_init(&sublist, head);
 
-	if (static_branch_unlikely(&generic_xdp_needed_key)) {
-		preempt_disable();
-		rcu_read_lock();
-		list_for_each_entry_safe(skb, next, head, list) {
-			xdp_prog = rcu_dereference(skb->dev->xdp_prog);
-			skb_list_del_init(skb);
-			if (do_xdp_generic(xdp_prog, skb) == XDP_PASS)
-				list_add_tail(&skb->list, &sublist);
-		}
-		rcu_read_unlock();
-		preempt_enable();
-		/* Put passed packets back on main list */
-		list_splice_init(&sublist, head);
-	}
-
 	rcu_read_lock();
 #ifdef CONFIG_RPS
 	if (static_key_false(&rps_needed)) {
-- 
2.20.1

