Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B07C0E4E6A
	for <lists+netdev@lfdr.de>; Fri, 25 Oct 2019 16:07:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2505074AbfJYNza (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Oct 2019 09:55:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:49378 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2505056AbfJYNz2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 25 Oct 2019 09:55:28 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F233121D82;
        Fri, 25 Oct 2019 13:55:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572011727;
        bh=Y4a8nZRLPZyWJewIpXd7KkVvD4okkKWNtoDmdd8Yyx8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IduWuBUyf3I2mIkFgQYTow9XquYBsn4oR64N0PKdIt4tW94Xptv0xSILX9fCAoRSf
         eFb17qpPXIM1O635buGE10cWelzdBZx8t6vzrSuVM4gbEobO8f22I1X/AYIXeFCkxk
         /hZtOaGsGwUamMMY/7MTbw+LYIrq/tbYvEUGeG90=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Eric Dumazet <edumazet@google.com>,
        syzbot <syzkaller@googlegroups.com>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Sasha Levin <sashal@kernel.org>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.3 11/33] netfilter: conntrack: avoid possible false sharing
Date:   Fri, 25 Oct 2019 09:54:43 -0400
Message-Id: <20191025135505.24762-11-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191025135505.24762-1-sashal@kernel.org>
References: <20191025135505.24762-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit e37542ba111f3974dc622ae0a21c1787318de500 ]

As hinted by KCSAN, we need at least one READ_ONCE()
to prevent a compiler optimization.

More details on :
https://github.com/google/ktsan/wiki/READ_ONCE-and-WRITE_ONCE#it-may-improve-performance

sysbot report :
BUG: KCSAN: data-race in __nf_ct_refresh_acct / __nf_ct_refresh_acct

read to 0xffff888123eb4f08 of 4 bytes by interrupt on cpu 0:
 __nf_ct_refresh_acct+0xd4/0x1b0 net/netfilter/nf_conntrack_core.c:1796
 nf_ct_refresh_acct include/net/netfilter/nf_conntrack.h:201 [inline]
 nf_conntrack_tcp_packet+0xd40/0x3390 net/netfilter/nf_conntrack_proto_tcp.c:1161
 nf_conntrack_handle_packet net/netfilter/nf_conntrack_core.c:1633 [inline]
 nf_conntrack_in+0x410/0xaa0 net/netfilter/nf_conntrack_core.c:1727
 ipv4_conntrack_in+0x27/0x40 net/netfilter/nf_conntrack_proto.c:178
 nf_hook_entry_hookfn include/linux/netfilter.h:135 [inline]
 nf_hook_slow+0x83/0x160 net/netfilter/core.c:512
 nf_hook include/linux/netfilter.h:260 [inline]
 NF_HOOK include/linux/netfilter.h:303 [inline]
 ip_rcv+0x12f/0x1a0 net/ipv4/ip_input.c:523
 __netif_receive_skb_one_core+0xa7/0xe0 net/core/dev.c:5004
 __netif_receive_skb+0x37/0xf0 net/core/dev.c:5118
 netif_receive_skb_internal+0x59/0x190 net/core/dev.c:5208
 napi_skb_finish net/core/dev.c:5671 [inline]
 napi_gro_receive+0x28f/0x330 net/core/dev.c:5704
 receive_buf+0x284/0x30b0 drivers/net/virtio_net.c:1061
 virtnet_receive drivers/net/virtio_net.c:1323 [inline]
 virtnet_poll+0x436/0x7d0 drivers/net/virtio_net.c:1428
 napi_poll net/core/dev.c:6352 [inline]
 net_rx_action+0x3ae/0xa50 net/core/dev.c:6418
 __do_softirq+0x115/0x33f kernel/softirq.c:292

write to 0xffff888123eb4f08 of 4 bytes by task 7191 on cpu 1:
 __nf_ct_refresh_acct+0xfb/0x1b0 net/netfilter/nf_conntrack_core.c:1797
 nf_ct_refresh_acct include/net/netfilter/nf_conntrack.h:201 [inline]
 nf_conntrack_tcp_packet+0xd40/0x3390 net/netfilter/nf_conntrack_proto_tcp.c:1161
 nf_conntrack_handle_packet net/netfilter/nf_conntrack_core.c:1633 [inline]
 nf_conntrack_in+0x410/0xaa0 net/netfilter/nf_conntrack_core.c:1727
 ipv4_conntrack_local+0xbe/0x130 net/netfilter/nf_conntrack_proto.c:200
 nf_hook_entry_hookfn include/linux/netfilter.h:135 [inline]
 nf_hook_slow+0x83/0x160 net/netfilter/core.c:512
 nf_hook include/linux/netfilter.h:260 [inline]
 __ip_local_out+0x1f7/0x2b0 net/ipv4/ip_output.c:114
 ip_local_out+0x31/0x90 net/ipv4/ip_output.c:123
 __ip_queue_xmit+0x3a8/0xa40 net/ipv4/ip_output.c:532
 ip_queue_xmit+0x45/0x60 include/net/ip.h:236
 __tcp_transmit_skb+0xdeb/0x1cd0 net/ipv4/tcp_output.c:1158
 __tcp_send_ack+0x246/0x300 net/ipv4/tcp_output.c:3685
 tcp_send_ack+0x34/0x40 net/ipv4/tcp_output.c:3691
 tcp_cleanup_rbuf+0x130/0x360 net/ipv4/tcp.c:1575

Reported by Kernel Concurrency Sanitizer on:
CPU: 1 PID: 7191 Comm: syz-fuzzer Not tainted 5.3.0+ #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011

Fixes: cc16921351d8 ("netfilter: conntrack: avoid same-timeout update")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Reported-by: syzbot <syzkaller@googlegroups.com>
Cc: Jozsef Kadlecsik <kadlec@netfilter.org>
Cc: Florian Westphal <fw@strlen.de>
Acked-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Jakub Kicinski <jakub.kicinski@netronome.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nf_conntrack_core.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
index 81a8ef42b88d3..56b1cf82ed3aa 100644
--- a/net/netfilter/nf_conntrack_core.c
+++ b/net/netfilter/nf_conntrack_core.c
@@ -1793,8 +1793,8 @@ void __nf_ct_refresh_acct(struct nf_conn *ct,
 	if (nf_ct_is_confirmed(ct))
 		extra_jiffies += nfct_time_stamp;
 
-	if (ct->timeout != extra_jiffies)
-		ct->timeout = extra_jiffies;
+	if (READ_ONCE(ct->timeout) != extra_jiffies)
+		WRITE_ONCE(ct->timeout, extra_jiffies);
 acct:
 	if (do_acct)
 		nf_ct_acct_update(ct, ctinfo, skb->len);
-- 
2.20.1

