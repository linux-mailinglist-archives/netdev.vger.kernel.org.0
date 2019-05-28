Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3C3DE2CEEE
	for <lists+netdev@lfdr.de>; Tue, 28 May 2019 20:47:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728241AbfE1Srx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 May 2019 14:47:53 -0400
Received: from mail-pg1-f193.google.com ([209.85.215.193]:43823 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728236AbfE1Srv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 May 2019 14:47:51 -0400
Received: by mail-pg1-f193.google.com with SMTP id f25so11502950pgv.10
        for <netdev@vger.kernel.org>; Tue, 28 May 2019 11:47:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=nbZG+yLKOwlBvMbOmsqIs2xj+EqotYcIlN/hsV/1azU=;
        b=sWZsOoyzCYCbIQ2EMpR3gdhZPoTT/zd3GtXX9eJbB+UeN9gYVMnutQ5VSIQhj9gM78
         lNOgFIUOzW5S8rwLjNJwn7je6vl/etniW/a1kDn0+XFcfyTfAqMrGWX30/gsK+5L94Bu
         ZQz7543xx8UjgJYo1jgg3XhjaRs8R0Sg75A9jWrQgkEA7ogcjjc0AMRVcpIg1KNvm8JA
         qlQbQrm634RaeOHDId/84rdpRXXbm4YpaI8Wg//vEF0u6NPEssppLcLh82g23/QKhj+8
         97hC6/AHemU2JIE17MQ4mE44kjQTvbbMLv31CS2pIQvqeT/hq/6ybFp7E3+0+dBn2dbW
         m8AA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=nbZG+yLKOwlBvMbOmsqIs2xj+EqotYcIlN/hsV/1azU=;
        b=MzbQke6KyMwKhX9zvvlHU+Y3rrUp5XAZjnBkiIYmtGpdBf0o78uWTO1ScgGtXSXZnt
         30l4ZdIQ6SldqnW95y1ANWUYvxdiUBgAKUU4daFcYDpIQC3kKw+lUdfuGsS3c1Qx9JgO
         LDtJK/omPTh57GPB0bxUC3Gt/L1ZeXK5P1IHfXFLRzdcNnmsu6qupeAr+1mJ9oF93LC7
         ADt1HI993gIMmS+B1kddrLtR6Kf6+mmU42l2evNlpJfPjP7r4R0UTYZRnK5Zn0jv1Wkq
         ro8FTCyX6Gr98KUibSgLSgMlbEwBjKQJf+ZRRUpxg33jvPGBhpHir6SnMG2zT+acke44
         aG3w==
X-Gm-Message-State: APjAAAXUpYLtyH00mXohaXh0htaTXqMwBQchm9co7zHawwgXqmhFzx2Y
        0oJ5d1ZtALZoRsVmjRYvwaC4qw==
X-Google-Smtp-Source: APXvYqyOw+Srdt5vojqAJuQBqi9dURZxNalbsFo0RPXUC9Az/qNRpOFmjCC5HJOCVZ+Rq+vwtfXC5A==
X-Received: by 2002:a63:ff23:: with SMTP id k35mr103274000pgi.139.1559069270528;
        Tue, 28 May 2019 11:47:50 -0700 (PDT)
Received: from hermes.lan (204-195-22-127.wavecable.com. [204.195.22.127])
        by smtp.gmail.com with ESMTPSA id n12sm14213608pgq.54.2019.05.28.11.47.49
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 28 May 2019 11:47:49 -0700 (PDT)
From:   Stephen Hemminger <stephen@networkplumber.org>
X-Google-Original-From: Stephen Hemminger <sthemmin@microsoft.com>
To:     davem@davemloft.net, saeedm@mellanox.com, jasowang@redhat.com,
        brouer@redhat.com
Cc:     netdev@vger.kernel.org, xdp-newbies@vger.kernel.org,
        Stephen Hemminger <sthemmin@microsoft.com>
Subject: [PATCH PATCH v4 2/2] net: core: support XDP generic on stacked devices.
Date:   Tue, 28 May 2019 11:47:31 -0700
Message-Id: <20190528184731.7464-3-sthemmin@microsoft.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190528184731.7464-1-sthemmin@microsoft.com>
References: <20190528184731.7464-1-sthemmin@microsoft.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When a device is stacked like (team, bonding, failsafe or netvsc) the
XDP generic program for the parent device was not called.

Move the call to XDP generic inside __netif_receive_skb_core where
it can be done multiple times for stacked case.

Fixes: d445516966dc ("net: xdp: support xdp generic on virtual devices")
Signed-off-by: Stephen Hemminger <sthemmin@microsoft.com>
---
v1 - call xdp_generic in netvsc handler
v2 - do xdp_generic in generic rx handler processing
v3 - move xdp_generic call inside the another pass loop
v4 - reset skb mac_len after xdp is called

 net/core/dev.c | 58 +++++++++++---------------------------------------
 1 file changed, 12 insertions(+), 46 deletions(-)

diff --git a/net/core/dev.c b/net/core/dev.c
index b6b8505cfb3e..cc2a4e257324 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -4502,23 +4502,6 @@ static int netif_rx_internal(struct sk_buff *skb)
 
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
 	if (static_branch_unlikely(&rps_needed)) {
 		struct rps_dev_flow voidflow, *rflow = &voidflow;
@@ -4858,6 +4841,18 @@ static int __netif_receive_skb_core(struct sk_buff *skb, bool pfmemalloc,
 
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
@@ -5178,19 +5173,6 @@ static int netif_receive_skb_internal(struct sk_buff *skb)
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
 	if (static_branch_unlikely(&rps_needed)) {
@@ -5211,7 +5193,6 @@ static int netif_receive_skb_internal(struct sk_buff *skb)
 
 static void netif_receive_skb_list_internal(struct list_head *head)
 {
-	struct bpf_prog *xdp_prog = NULL;
 	struct sk_buff *skb, *next;
 	struct list_head sublist;
 
@@ -5224,21 +5205,6 @@ static void netif_receive_skb_list_internal(struct list_head *head)
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
 	if (static_branch_unlikely(&rps_needed)) {
-- 
2.20.1

