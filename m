Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 926DE13E5C2
	for <lists+netdev@lfdr.de>; Thu, 16 Jan 2020 18:16:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391158AbgAPRQq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jan 2020 12:16:46 -0500
Received: from mail.kernel.org ([198.145.29.99]:60498 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390910AbgAPROD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 16 Jan 2020 12:14:03 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C1E91246A7;
        Thu, 16 Jan 2020 17:14:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579194842;
        bh=SIPvOhkrh0Uqq2mkf88Ur+Rb6uvk1us0TY9itmGqFcY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ceLBOvGttc2YHHBA1NXXXMNUoIJzS+h13O2gwtdGga1tZEoigIHlnNu8TucYTBVgd
         7eWETDLpSPbBIB64yWdWrnHbUW6s7loTyiHdjvEEK/U/cfpy3R6qcoglOmvedQdiVm
         Yvn2SpSVcFMXAaTMtYBNf9nuQMdKyW0lx1xXxIs0=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Eric Dumazet <edumazet@google.com>,
        Willem de Bruijn <willemb@google.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 641/671] packet: fix data-race in fanout_flow_is_huge()
Date:   Thu, 16 Jan 2020 12:04:39 -0500
Message-Id: <20200116170509.12787-378-sashal@kernel.org>
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

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit b756ad928d98e5ef0b74af7546a6a31a8dadde00 ]

KCSAN reported the following data-race [1]

Adding a couple of READ_ONCE()/WRITE_ONCE() should silence it.

Since the report hinted about multiple cpus using the history
concurrently, I added a test avoiding writing on it if the
victim slot already contains the desired value.

[1]

BUG: KCSAN: data-race in fanout_demux_rollover / fanout_demux_rollover

read to 0xffff8880b01786cc of 4 bytes by task 18921 on cpu 1:
 fanout_flow_is_huge net/packet/af_packet.c:1303 [inline]
 fanout_demux_rollover+0x33e/0x3f0 net/packet/af_packet.c:1353
 packet_rcv_fanout+0x34e/0x490 net/packet/af_packet.c:1453
 deliver_skb net/core/dev.c:1888 [inline]
 dev_queue_xmit_nit+0x15b/0x540 net/core/dev.c:1958
 xmit_one net/core/dev.c:3195 [inline]
 dev_hard_start_xmit+0x3f5/0x430 net/core/dev.c:3215
 __dev_queue_xmit+0x14ab/0x1b40 net/core/dev.c:3792
 dev_queue_xmit+0x21/0x30 net/core/dev.c:3825
 neigh_direct_output+0x1f/0x30 net/core/neighbour.c:1530
 neigh_output include/net/neighbour.h:511 [inline]
 ip6_finish_output2+0x7a2/0xec0 net/ipv6/ip6_output.c:116
 __ip6_finish_output net/ipv6/ip6_output.c:142 [inline]
 __ip6_finish_output+0x2d7/0x330 net/ipv6/ip6_output.c:127
 ip6_finish_output+0x41/0x160 net/ipv6/ip6_output.c:152
 NF_HOOK_COND include/linux/netfilter.h:294 [inline]
 ip6_output+0xf2/0x280 net/ipv6/ip6_output.c:175
 dst_output include/net/dst.h:436 [inline]
 ip6_local_out+0x74/0x90 net/ipv6/output_core.c:179
 ip6_send_skb+0x53/0x110 net/ipv6/ip6_output.c:1795
 udp_v6_send_skb.isra.0+0x3ec/0xa70 net/ipv6/udp.c:1173
 udpv6_sendmsg+0x1906/0x1c20 net/ipv6/udp.c:1471
 inet6_sendmsg+0x6d/0x90 net/ipv6/af_inet6.c:576
 sock_sendmsg_nosec net/socket.c:637 [inline]
 sock_sendmsg+0x9f/0xc0 net/socket.c:657
 ___sys_sendmsg+0x2b7/0x5d0 net/socket.c:2311
 __sys_sendmmsg+0x123/0x350 net/socket.c:2413
 __do_sys_sendmmsg net/socket.c:2442 [inline]
 __se_sys_sendmmsg net/socket.c:2439 [inline]
 __x64_sys_sendmmsg+0x64/0x80 net/socket.c:2439
 do_syscall_64+0xcc/0x370 arch/x86/entry/common.c:290
 entry_SYSCALL_64_after_hwframe+0x44/0xa9

write to 0xffff8880b01786cc of 4 bytes by task 18922 on cpu 0:
 fanout_flow_is_huge net/packet/af_packet.c:1306 [inline]
 fanout_demux_rollover+0x3a4/0x3f0 net/packet/af_packet.c:1353
 packet_rcv_fanout+0x34e/0x490 net/packet/af_packet.c:1453
 deliver_skb net/core/dev.c:1888 [inline]
 dev_queue_xmit_nit+0x15b/0x540 net/core/dev.c:1958
 xmit_one net/core/dev.c:3195 [inline]
 dev_hard_start_xmit+0x3f5/0x430 net/core/dev.c:3215
 __dev_queue_xmit+0x14ab/0x1b40 net/core/dev.c:3792
 dev_queue_xmit+0x21/0x30 net/core/dev.c:3825
 neigh_direct_output+0x1f/0x30 net/core/neighbour.c:1530
 neigh_output include/net/neighbour.h:511 [inline]
 ip6_finish_output2+0x7a2/0xec0 net/ipv6/ip6_output.c:116
 __ip6_finish_output net/ipv6/ip6_output.c:142 [inline]
 __ip6_finish_output+0x2d7/0x330 net/ipv6/ip6_output.c:127
 ip6_finish_output+0x41/0x160 net/ipv6/ip6_output.c:152
 NF_HOOK_COND include/linux/netfilter.h:294 [inline]
 ip6_output+0xf2/0x280 net/ipv6/ip6_output.c:175
 dst_output include/net/dst.h:436 [inline]
 ip6_local_out+0x74/0x90 net/ipv6/output_core.c:179
 ip6_send_skb+0x53/0x110 net/ipv6/ip6_output.c:1795
 udp_v6_send_skb.isra.0+0x3ec/0xa70 net/ipv6/udp.c:1173
 udpv6_sendmsg+0x1906/0x1c20 net/ipv6/udp.c:1471
 inet6_sendmsg+0x6d/0x90 net/ipv6/af_inet6.c:576
 sock_sendmsg_nosec net/socket.c:637 [inline]
 sock_sendmsg+0x9f/0xc0 net/socket.c:657
 ___sys_sendmsg+0x2b7/0x5d0 net/socket.c:2311
 __sys_sendmmsg+0x123/0x350 net/socket.c:2413
 __do_sys_sendmmsg net/socket.c:2442 [inline]
 __se_sys_sendmmsg net/socket.c:2439 [inline]
 __x64_sys_sendmmsg+0x64/0x80 net/socket.c:2439
 do_syscall_64+0xcc/0x370 arch/x86/entry/common.c:290
 entry_SYSCALL_64_after_hwframe+0x44/0xa9

Reported by Kernel Concurrency Sanitizer on:
CPU: 0 PID: 18922 Comm: syz-executor.3 Not tainted 5.4.0-rc6+ #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011

Fixes: 3b3a5b0aab5b ("packet: rollover huge flows before small flows")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Cc: Willem de Bruijn <willemb@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/packet/af_packet.c | 12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/net/packet/af_packet.c b/net/packet/af_packet.c
index 60ba18a4bb0f..ddf90e6fac51 100644
--- a/net/packet/af_packet.c
+++ b/net/packet/af_packet.c
@@ -1297,15 +1297,21 @@ static void packet_sock_destruct(struct sock *sk)
 
 static bool fanout_flow_is_huge(struct packet_sock *po, struct sk_buff *skb)
 {
-	u32 rxhash;
+	u32 *history = po->rollover->history;
+	u32 victim, rxhash;
 	int i, count = 0;
 
 	rxhash = skb_get_hash(skb);
 	for (i = 0; i < ROLLOVER_HLEN; i++)
-		if (po->rollover->history[i] == rxhash)
+		if (READ_ONCE(history[i]) == rxhash)
 			count++;
 
-	po->rollover->history[prandom_u32() % ROLLOVER_HLEN] = rxhash;
+	victim = prandom_u32() % ROLLOVER_HLEN;
+
+	/* Avoid dirtying the cache line if possible */
+	if (READ_ONCE(history[victim]) != rxhash)
+		WRITE_ONCE(history[victim], rxhash);
+
 	return count > (ROLLOVER_HLEN >> 1);
 }
 
-- 
2.20.1

