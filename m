Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BBCBA3D7631
	for <lists+netdev@lfdr.de>; Tue, 27 Jul 2021 15:24:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236848AbhG0NYt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Jul 2021 09:24:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:56508 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237050AbhG0NWe (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 27 Jul 2021 09:22:34 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3651061AAD;
        Tue, 27 Jul 2021 13:20:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1627392035;
        bh=lRH3ZJEzy7Ok8b2XgvXIowhje5ZHe/MDQkvbr++q7s8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Lv0mNuQogCmAOVtWoMgtUqraNfE1fzc4HhIcnMsmDwLwjtJ9NI3r3kzS5M4etNv+O
         srdJGt1++RtZQDHpt+3n8Puu3ceEdn5qsH24+upl7YjuYISdk6hTz9QQoQNSWYnbaL
         mgZhIh6OlJmpZX8OEydOHhwHZo2XB+UJzBLZF0qHouCZJCYD1E/pcwkITGbe3hAlkE
         8tw6WEYAH1xkjJOZpHqE3aDpgGoh+SH6Vkt0LMLAoo0qHkX1HyEtjlkHCCPbAR4PSp
         eA0uh+5wlcNAyDJASCjhAprvs/MMkvJDCkcUnmMczyYS2TSJvOBQQ1fkYGWRXJ5wh2
         0Z9aDxW9vXDag==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Pravin B Shelar <pshelar@ovn.org>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.9 3/3] net: Fix zero-copy head len calculation.
Date:   Tue, 27 Jul 2021 09:20:31 -0400
Message-Id: <20210727132031.835904-3-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210727132031.835904-1-sashal@kernel.org>
References: <20210727132031.835904-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Pravin B Shelar <pshelar@ovn.org>

[ Upstream commit a17ad0961706244dce48ec941f7e476a38c0e727 ]

In some cases skb head could be locked and entire header
data is pulled from skb. When skb_zerocopy() called in such cases,
following BUG is triggered. This patch fixes it by copying entire
skb in such cases.
This could be optimized incase this is performance bottleneck.

---8<---
kernel BUG at net/core/skbuff.c:2961!
invalid opcode: 0000 [#1] SMP PTI
CPU: 2 PID: 0 Comm: swapper/2 Tainted: G           OE     5.4.0-77-generic #86-Ubuntu
Hardware name: OpenStack Foundation OpenStack Nova, BIOS 1.13.0-1ubuntu1.1 04/01/2014
RIP: 0010:skb_zerocopy+0x37a/0x3a0
RSP: 0018:ffffbcc70013ca38 EFLAGS: 00010246
Call Trace:
 <IRQ>
 queue_userspace_packet+0x2af/0x5e0 [openvswitch]
 ovs_dp_upcall+0x3d/0x60 [openvswitch]
 ovs_dp_process_packet+0x125/0x150 [openvswitch]
 ovs_vport_receive+0x77/0xd0 [openvswitch]
 netdev_port_receive+0x87/0x130 [openvswitch]
 netdev_frame_hook+0x4b/0x60 [openvswitch]
 __netif_receive_skb_core+0x2b4/0xc90
 __netif_receive_skb_one_core+0x3f/0xa0
 __netif_receive_skb+0x18/0x60
 process_backlog+0xa9/0x160
 net_rx_action+0x142/0x390
 __do_softirq+0xe1/0x2d6
 irq_exit+0xae/0xb0
 do_IRQ+0x5a/0xf0
 common_interrupt+0xf/0xf

Code that triggered BUG:
int
skb_zerocopy(struct sk_buff *to, struct sk_buff *from, int len, int hlen)
{
        int i, j = 0;
        int plen = 0; /* length of skb->head fragment */
        int ret;
        struct page *page;
        unsigned int offset;

        BUG_ON(!from->head_frag && !hlen);

Signed-off-by: Pravin B Shelar <pshelar@ovn.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/skbuff.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/net/core/skbuff.c b/net/core/skbuff.c
index 076444dac96d..0e34f5ad6216 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -2288,8 +2288,11 @@ skb_zerocopy_headlen(const struct sk_buff *from)
 
 	if (!from->head_frag ||
 	    skb_headlen(from) < L1_CACHE_BYTES ||
-	    skb_shinfo(from)->nr_frags >= MAX_SKB_FRAGS)
+	    skb_shinfo(from)->nr_frags >= MAX_SKB_FRAGS) {
 		hlen = skb_headlen(from);
+		if (!hlen)
+			hlen = from->len;
+	}
 
 	if (skb_has_frag_list(from))
 		hlen = from->len;
-- 
2.30.2

