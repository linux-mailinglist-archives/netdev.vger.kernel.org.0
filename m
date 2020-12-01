Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 47B402C9D84
	for <lists+netdev@lfdr.de>; Tue,  1 Dec 2020 10:40:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390764AbgLAJY1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Dec 2020 04:24:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51550 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388364AbgLAJF7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Dec 2020 04:05:59 -0500
Received: from mail-pf1-x442.google.com (mail-pf1-x442.google.com [IPv6:2607:f8b0:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 783F5C0613CF
        for <netdev@vger.kernel.org>; Tue,  1 Dec 2020 01:05:12 -0800 (PST)
Received: by mail-pf1-x442.google.com with SMTP id q22so419806pfk.12
        for <netdev@vger.kernel.org>; Tue, 01 Dec 2020 01:05:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=mSqVg8bR87JikjFPYDz01J5hgIlBUC3pa9G/hQQx+P0=;
        b=JXCtGHGL2cquj7dcaSdSOYudNyxlbtyQRsVwdsmaBdrZ5J+9VUUOiR7rJhBCbnD7oU
         bik6gjRtMRoahjrKBHRPLM+fO76UZDP2yuMyJEB5l7lm/pds8eNy61I5gvXkdJ3a7NHz
         nPQi26PAcaNrU3hmxLth8y/PUe/m7ThRspp42nT1R5nJHCnDJyKFz+19i8Jlwf/NIbYb
         FiDl2uUTDotgME/kIcYamjTxf0yOgOqUH27EatVKQ2+qljhO+2chH5UjAIrtNEzFBSYr
         T0hTzIwJM5nENx6bCu1msPwfStR6AJW+DQ70T0uCEb+vLbyLXL47eit6YfgFMdBOL0KN
         cncg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=mSqVg8bR87JikjFPYDz01J5hgIlBUC3pa9G/hQQx+P0=;
        b=Fw/V+bbgytpDXryIOT+pCF/Xzvxy6WCY7VycEcGQ+nKX96907coM8KKjMhzDNego4L
         t03x99muAAKrBQK+W6Sm9LA3fzFPFe+SpHOpaAsWFpR6tih/8WHk/F5FVJy9OP+XbOjx
         xmxLsyU9FX77epQoXSKEJNSaQAfxctb/f5Jo3gtFaVu9dghEGENP14diFY91Z4kvYRBY
         flYXBDmH6sj1PpB4gInTTm283DW7oHLLHxFsXfY6u8h09wCs1ZaVIxUZymvGBv1vVezG
         nBcHO+RNKKZdd4PM/jmd0BvW6ir9AZR4IHZ03uPo+T6W9aYPl7ULCgMVYjPuf44rk2QG
         6pyg==
X-Gm-Message-State: AOAM532oKan0pgrAM6xEv5OYt4+TvJGkS8bof1b6lAGmofcJHuwzxMg/
        v/EDPKOR0N3palYaipYBZsw=
X-Google-Smtp-Source: ABdhPJxrOCDIxO3QfJ3VldYXZ47uP4OYJ/HH4/9PRe2Z5EFMZg968N/FLNvkO6YGyw1gzUNslRXyqw==
X-Received: by 2002:a62:1455:0:b029:18b:83a2:768b with SMTP id 82-20020a6214550000b029018b83a2768bmr1814022pfu.3.1606813512082;
        Tue, 01 Dec 2020 01:05:12 -0800 (PST)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:7220:84ff:fe09:1424])
        by smtp.gmail.com with ESMTPSA id j10sm1734432pji.29.2020.12.01.01.05.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Dec 2020 01:05:11 -0800 (PST)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        syzbot <syzkaller@googlegroups.com>
Subject: [PATCH net] geneve: pull IP header before ECN decapsulation
Date:   Tue,  1 Dec 2020 01:05:07 -0800
Message-Id: <20201201090507.4137906-1-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.29.2.454.gaff20da3a2-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

IP_ECN_decapsulate() and IP6_ECN_decapsulate() assume
IP header is already pulled.

geneve does not ensure this yet.

Fixing this generically in IP_ECN_decapsulate() and
IP6_ECN_decapsulate() is not possible, since callers
pass a pointer that might be freed by pskb_may_pull()

syzbot reported :

BUG: KMSAN: uninit-value in __INET_ECN_decapsulate include/net/inet_ecn.h:238 [inline]
BUG: KMSAN: uninit-value in INET_ECN_decapsulate+0x345/0x1db0 include/net/inet_ecn.h:260
CPU: 1 PID: 8941 Comm: syz-executor.0 Not tainted 5.10.0-rc4-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 <IRQ>
 __dump_stack lib/dump_stack.c:77 [inline]
 dump_stack+0x21c/0x280 lib/dump_stack.c:118
 kmsan_report+0xf7/0x1e0 mm/kmsan/kmsan_report.c:118
 __msan_warning+0x5f/0xa0 mm/kmsan/kmsan_instr.c:197
 __INET_ECN_decapsulate include/net/inet_ecn.h:238 [inline]
 INET_ECN_decapsulate+0x345/0x1db0 include/net/inet_ecn.h:260
 geneve_rx+0x2103/0x2980 include/net/inet_ecn.h:306
 geneve_udp_encap_recv+0x105c/0x1340 drivers/net/geneve.c:377
 udp_queue_rcv_one_skb+0x193a/0x1af0 net/ipv4/udp.c:2093
 udp_queue_rcv_skb+0x282/0x1050 net/ipv4/udp.c:2167
 udp_unicast_rcv_skb net/ipv4/udp.c:2325 [inline]
 __udp4_lib_rcv+0x399d/0x5880 net/ipv4/udp.c:2394
 udp_rcv+0x5c/0x70 net/ipv4/udp.c:2564
 ip_protocol_deliver_rcu+0x572/0xc50 net/ipv4/ip_input.c:204
 ip_local_deliver_finish net/ipv4/ip_input.c:231 [inline]
 NF_HOOK include/linux/netfilter.h:301 [inline]
 ip_local_deliver+0x583/0x8d0 net/ipv4/ip_input.c:252
 dst_input include/net/dst.h:449 [inline]
 ip_rcv_finish net/ipv4/ip_input.c:428 [inline]
 NF_HOOK include/linux/netfilter.h:301 [inline]
 ip_rcv+0x5c3/0x840 net/ipv4/ip_input.c:539
 __netif_receive_skb_one_core net/core/dev.c:5315 [inline]
 __netif_receive_skb+0x1ec/0x640 net/core/dev.c:5429
 process_backlog+0x523/0xc10 net/core/dev.c:6319
 napi_poll+0x420/0x1010 net/core/dev.c:6763
 net_rx_action+0x35c/0xd40 net/core/dev.c:6833
 __do_softirq+0x1a9/0x6fa kernel/softirq.c:298
 asm_call_irq_on_stack+0xf/0x20
 </IRQ>
 __run_on_irqstack arch/x86/include/asm/irq_stack.h:26 [inline]
 run_on_irqstack_cond arch/x86/include/asm/irq_stack.h:77 [inline]
 do_softirq_own_stack+0x6e/0x90 arch/x86/kernel/irq_64.c:77
 do_softirq kernel/softirq.c:343 [inline]
 __local_bh_enable_ip+0x184/0x1d0 kernel/softirq.c:195
 local_bh_enable+0x36/0x40 include/linux/bottom_half.h:32
 rcu_read_unlock_bh include/linux/rcupdate.h:730 [inline]
 __dev_queue_xmit+0x3a9b/0x4520 net/core/dev.c:4167
 dev_queue_xmit+0x4b/0x60 net/core/dev.c:4173
 packet_snd net/packet/af_packet.c:2992 [inline]
 packet_sendmsg+0x86f9/0x99d0 net/packet/af_packet.c:3017
 sock_sendmsg_nosec net/socket.c:651 [inline]
 sock_sendmsg net/socket.c:671 [inline]
 __sys_sendto+0x9dc/0xc80 net/socket.c:1992
 __do_sys_sendto net/socket.c:2004 [inline]
 __se_sys_sendto+0x107/0x130 net/socket.c:2000
 __x64_sys_sendto+0x6e/0x90 net/socket.c:2000
 do_syscall_64+0x9f/0x140 arch/x86/entry/common.c:48
 entry_SYSCALL_64_after_hwframe+0x44/0xa9

Fixes: 2d07dc79fe04 ("geneve: add initial netdev driver for GENEVE tunnels")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Reported-by: syzbot <syzkaller@googlegroups.com>
---
 drivers/net/geneve.c | 20 ++++++++++++++++----
 1 file changed, 16 insertions(+), 4 deletions(-)

diff --git a/drivers/net/geneve.c b/drivers/net/geneve.c
index 1426bfc009bc39a61e2cf039c57b56e48abc3fdc..8ae9ce2014a4a3ba7b962a209e28d1f65d4a83bd 100644
--- a/drivers/net/geneve.c
+++ b/drivers/net/geneve.c
@@ -257,11 +257,21 @@ static void geneve_rx(struct geneve_dev *geneve, struct geneve_sock *gs,
 		skb_dst_set(skb, &tun_dst->dst);
 
 	/* Ignore packet loops (and multicast echo) */
-	if (ether_addr_equal(eth_hdr(skb)->h_source, geneve->dev->dev_addr)) {
-		geneve->dev->stats.rx_errors++;
-		goto drop;
-	}
+	if (ether_addr_equal(eth_hdr(skb)->h_source, geneve->dev->dev_addr))
+		goto rx_error;
 
+	switch (skb_protocol(skb, true)) {
+	case htons(ETH_P_IP):
+		if (pskb_may_pull(skb, sizeof(struct iphdr)))
+			goto rx_error;
+		break;
+	case htons(ETH_P_IPV6):
+		if (pskb_may_pull(skb, sizeof(struct ipv6hdr)))
+			goto rx_error;
+		break;
+	default:
+		goto rx_error;
+	}
 	oiph = skb_network_header(skb);
 	skb_reset_network_header(skb);
 
@@ -298,6 +308,8 @@ static void geneve_rx(struct geneve_dev *geneve, struct geneve_sock *gs,
 		dev_sw_netstats_rx_add(geneve->dev, len);
 
 	return;
+rx_error:
+	geneve->dev->stats.rx_errors++;
 drop:
 	/* Consume bad packet */
 	kfree_skb(skb);
-- 
2.29.2.454.gaff20da3a2-goog

