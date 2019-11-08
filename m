Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BE34BF3E16
	for <lists+netdev@lfdr.de>; Fri,  8 Nov 2019 03:29:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727024AbfKHC3Q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Nov 2019 21:29:16 -0500
Received: from mail-pl1-f201.google.com ([209.85.214.201]:37803 "EHLO
        mail-pl1-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725928AbfKHC3P (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Nov 2019 21:29:15 -0500
Received: by mail-pl1-f201.google.com with SMTP id w17so3172690plp.4
        for <netdev@vger.kernel.org>; Thu, 07 Nov 2019 18:29:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=uhNYCT5tq9XNW7wdKlfHS1WiZzIkM462yMlyniBQW90=;
        b=wTZndSUua4IoXS1LOYuj8aSbDqUpBYSnDFMo3POjLStDgjZalowZtanV5oHNynxy7W
         eefAqvsBQ0rxBIOkpTuRKZ71wbaAur0KH3r7aIepif5lrXHI9vBQgFfciMZSGuNhbHhx
         ODdpOwQkEMO/3OPdNB3ECZ76g1PBXqABYSV/1w0byl8NyNE/ECSp2LCe1l7TUFuBU3Rt
         4r3YpL+dh6LLyPo8CDO3NHmRKOfX/NUh32a7m3svS0KtuCL+O9RlnHPCZDKh4HkXqSye
         nAMpCmroOuXWOLeRXT1S4ZBK18k7+6ytGz5FPywNZOVaLMraC3NLLfPWgt62HILhI6bl
         vFEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=uhNYCT5tq9XNW7wdKlfHS1WiZzIkM462yMlyniBQW90=;
        b=VO4kJFhiTPt6o2QwllZxojcvu7ZlziUypKRfUXjNTLnxqUBV+saNr3cFSHzR2/a/Qp
         T9cJTAow5HSttM5hwNZy8lani/YdZkgMgbXTFE+saloPKT173h8g1y0BkzgBNuQdm1p0
         BfsKDW8jGLNPROeeQyvL+4zRM/ytE8Qke6bYyCHN8sagYGnatHdK1+s8KeqW7jonUAqh
         qmwP52WXnO5vWoOR2h/kZ/ceCUyJiL3EbDOyTdGbSuoajGJTqyaxVX2hz0mWCR167NZg
         kTvLBtFdhnrj5d/AWGZt7C7ohcIJNJFfG59fv3ICbTaDGfEgztI0vwu9FUoKw/ujRd1c
         Zhrw==
X-Gm-Message-State: APjAAAWN5VQtrKofj6lJVzrO8TOYYKJPhhYnVa9G9wlvFdUSc63k+L2a
        r7qeXPji1mXTl9wriJOmZQYOhOP2yr2ANA==
X-Google-Smtp-Source: APXvYqxjk0EmTeNYOJ0hHPfCEBM/0SLFBC640WtxSN6vCuP9ZeSyN7Y56WOmxZiK1v1DGBXeI0k4WNeIidK+Qw==
X-Received: by 2002:a63:cb4f:: with SMTP id m15mr8989350pgi.325.1573180154565;
 Thu, 07 Nov 2019 18:29:14 -0800 (PST)
Date:   Thu,  7 Nov 2019 18:29:11 -0800
Message-Id: <20191108022911.183563-1-edumazet@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.24.0.432.g9d3f5f5b63-goog
Subject: [PATCH net-next] net: add annotations on hh->hh_len lockless accesses
From:   Eric Dumazet <edumazet@google.com>
To:     "David S . Miller" <davem@davemloft.net>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        syzbot <syzkaller@googlegroups.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

KCSAN reported a data-race [1]

While we can use READ_ONCE() on the read sides,
we need to make sure hh->hh_len is written last.

[1]

BUG: KCSAN: data-race in eth_header_cache / neigh_resolve_output

write to 0xffff8880b9dedcb8 of 4 bytes by task 29760 on cpu 0:
 eth_header_cache+0xa9/0xd0 net/ethernet/eth.c:247
 neigh_hh_init net/core/neighbour.c:1463 [inline]
 neigh_resolve_output net/core/neighbour.c:1480 [inline]
 neigh_resolve_output+0x415/0x470 net/core/neighbour.c:1470
 neigh_output include/net/neighbour.h:511 [inline]
 ip6_finish_output2+0x7a2/0xec0 net/ipv6/ip6_output.c:116
 __ip6_finish_output net/ipv6/ip6_output.c:142 [inline]
 __ip6_finish_output+0x2d7/0x330 net/ipv6/ip6_output.c:127
 ip6_finish_output+0x41/0x160 net/ipv6/ip6_output.c:152
 NF_HOOK_COND include/linux/netfilter.h:294 [inline]
 ip6_output+0xf2/0x280 net/ipv6/ip6_output.c:175
 dst_output include/net/dst.h:436 [inline]
 NF_HOOK include/linux/netfilter.h:305 [inline]
 ndisc_send_skb+0x459/0x5f0 net/ipv6/ndisc.c:505
 ndisc_send_ns+0x207/0x430 net/ipv6/ndisc.c:647
 rt6_probe_deferred+0x98/0xf0 net/ipv6/route.c:615
 process_one_work+0x3d4/0x890 kernel/workqueue.c:2269
 worker_thread+0xa0/0x800 kernel/workqueue.c:2415
 kthread+0x1d4/0x200 drivers/block/aoe/aoecmd.c:1253
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:352

read to 0xffff8880b9dedcb8 of 4 bytes by task 29572 on cpu 1:
 neigh_resolve_output net/core/neighbour.c:1479 [inline]
 neigh_resolve_output+0x113/0x470 net/core/neighbour.c:1470
 neigh_output include/net/neighbour.h:511 [inline]
 ip6_finish_output2+0x7a2/0xec0 net/ipv6/ip6_output.c:116
 __ip6_finish_output net/ipv6/ip6_output.c:142 [inline]
 __ip6_finish_output+0x2d7/0x330 net/ipv6/ip6_output.c:127
 ip6_finish_output+0x41/0x160 net/ipv6/ip6_output.c:152
 NF_HOOK_COND include/linux/netfilter.h:294 [inline]
 ip6_output+0xf2/0x280 net/ipv6/ip6_output.c:175
 dst_output include/net/dst.h:436 [inline]
 NF_HOOK include/linux/netfilter.h:305 [inline]
 ndisc_send_skb+0x459/0x5f0 net/ipv6/ndisc.c:505
 ndisc_send_ns+0x207/0x430 net/ipv6/ndisc.c:647
 rt6_probe_deferred+0x98/0xf0 net/ipv6/route.c:615
 process_one_work+0x3d4/0x890 kernel/workqueue.c:2269
 worker_thread+0xa0/0x800 kernel/workqueue.c:2415
 kthread+0x1d4/0x200 drivers/block/aoe/aoecmd.c:1253
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:352

Reported by Kernel Concurrency Sanitizer on:
CPU: 1 PID: 29572 Comm: kworker/1:4 Not tainted 5.4.0-rc6+ #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Workqueue: events rt6_probe_deferred

Signed-off-by: Eric Dumazet <edumazet@google.com>
Reported-by: syzbot <syzkaller@googlegroups.com>
---
 drivers/firewire/net.c  | 6 +++++-
 include/net/neighbour.h | 2 +-
 net/core/neighbour.c    | 4 ++--
 net/ethernet/eth.c      | 7 ++++++-
 4 files changed, 14 insertions(+), 5 deletions(-)

diff --git a/drivers/firewire/net.c b/drivers/firewire/net.c
index b132ab9ad6078f5a9a3d57e3088387a9a0a05789..715e491dfbc333395aa5ba5f3861e7d65b10368c 100644
--- a/drivers/firewire/net.c
+++ b/drivers/firewire/net.c
@@ -250,7 +250,11 @@ static int fwnet_header_cache(const struct neighbour *neigh,
 	h = (struct fwnet_header *)((u8 *)hh->hh_data + HH_DATA_OFF(sizeof(*h)));
 	h->h_proto = type;
 	memcpy(h->h_dest, neigh->ha, net->addr_len);
-	hh->hh_len = FWNET_HLEN;
+
+	/* Pairs with the READ_ONCE() in neigh_resolve_output(),
+	 * neigh_hh_output() and neigh_update_hhs().
+	 */
+	smp_store_release(&hh->hh_len, FWNET_HLEN);
 
 	return 0;
 }
diff --git a/include/net/neighbour.h b/include/net/neighbour.h
index 50a67bd6a43413bf69e2ad7b7c27e8460b6fb152..6a86e49181db0f47cf8188ccf92fc7bd0553a4be 100644
--- a/include/net/neighbour.h
+++ b/include/net/neighbour.h
@@ -468,7 +468,7 @@ static inline int neigh_hh_output(const struct hh_cache *hh, struct sk_buff *skb
 
 	do {
 		seq = read_seqbegin(&hh->hh_lock);
-		hh_len = hh->hh_len;
+		hh_len = READ_ONCE(hh->hh_len);
 		if (likely(hh_len <= HH_DATA_MOD)) {
 			hh_alen = HH_DATA_MOD;
 
diff --git a/net/core/neighbour.c b/net/core/neighbour.c
index 8c82e95f75394cba3688bc2a960804b1f967f508..652da63690376b52d084a901310db39f4258aca3 100644
--- a/net/core/neighbour.c
+++ b/net/core/neighbour.c
@@ -1197,7 +1197,7 @@ static void neigh_update_hhs(struct neighbour *neigh)
 
 	if (update) {
 		hh = &neigh->hh;
-		if (hh->hh_len) {
+		if (READ_ONCE(hh->hh_len)) {
 			write_seqlock_bh(&hh->hh_lock);
 			update(hh, neigh->dev, neigh->ha);
 			write_sequnlock_bh(&hh->hh_lock);
@@ -1476,7 +1476,7 @@ int neigh_resolve_output(struct neighbour *neigh, struct sk_buff *skb)
 		struct net_device *dev = neigh->dev;
 		unsigned int seq;
 
-		if (dev->header_ops->cache && !neigh->hh.hh_len)
+		if (dev->header_ops->cache && !READ_ONCE(neigh->hh.hh_len))
 			neigh_hh_init(neigh);
 
 		do {
diff --git a/net/ethernet/eth.c b/net/ethernet/eth.c
index 17374afee28f815b4d312eb87edbfa61a41d7f44..9040fe55e0f5d33814d6489cf1e50d1c2aa89067 100644
--- a/net/ethernet/eth.c
+++ b/net/ethernet/eth.c
@@ -244,7 +244,12 @@ int eth_header_cache(const struct neighbour *neigh, struct hh_cache *hh, __be16
 	eth->h_proto = type;
 	memcpy(eth->h_source, dev->dev_addr, ETH_ALEN);
 	memcpy(eth->h_dest, neigh->ha, ETH_ALEN);
-	hh->hh_len = ETH_HLEN;
+
+	/* Pairs with READ_ONCE() in neigh_resolve_output(),
+	 * neigh_hh_output() and neigh_update_hhs().
+	 */
+	smp_store_release(&hh->hh_len, ETH_HLEN);
+
 	return 0;
 }
 EXPORT_SYMBOL(eth_header_cache);
-- 
2.24.0.432.g9d3f5f5b63-goog

