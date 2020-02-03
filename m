Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CE622150F30
	for <lists+netdev@lfdr.de>; Mon,  3 Feb 2020 19:15:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729375AbgBCSPN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Feb 2020 13:15:13 -0500
Received: from mail-ua1-f74.google.com ([209.85.222.74]:47031 "EHLO
        mail-ua1-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728923AbgBCSPN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Feb 2020 13:15:13 -0500
Received: by mail-ua1-f74.google.com with SMTP id 107so3943040uau.13
        for <netdev@vger.kernel.org>; Mon, 03 Feb 2020 10:15:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=q3aD/Xq2fYX0I9tp9vw3bOTGIF5QWmR3CNqHi6+91lA=;
        b=LzFXpOjbrlPlpqogsEGbx1YB+Y1zXaGPRBaoc6JXcywS9tVwPOGKr8Ij42xgDgKXXZ
         IB07K9GX5rS2c+B4tddP2YSECqPNrnvY3Or0e53e/ThUxu0/KlLIr6ymODM18PRaV1Lw
         PfsJis6zAfWdyc8THT6sR6SqXYL3HnD/wdJHcX11VSaOdcj2Qxxxz9nsvzW/OIMHTy/4
         sUwIsQNwzuPWkKLc9SXwtyKlmNVqpqLfGJqDj/5BtCXnieSoNHj8jG2WjckY8bmAbPAy
         sggjwqUGLkw8hjVErabOA1rE+r/DvQjtl0PrT4BU5q375DP0hCx/SDD8FDvFOOn01aG7
         Fjkg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=q3aD/Xq2fYX0I9tp9vw3bOTGIF5QWmR3CNqHi6+91lA=;
        b=TAs7Zpxqs7yfgPcBL6sCTrDfp4ZFMgFOehWOMQMamFXbUkszVL9tLCyVwLdoB/nqqO
         Ccp9NYaAqGm9nkqGrBSeiCY/a4t0uSXaTzIAzubt8kSZrTRitPqn1UocEDXJwhfuH2uX
         4U1+VHAHh8QB27c7Rn37y9cN9ObPpdETnNPP0gpNqPBxFdyAJ30IU3t3180DDQGt2+Lv
         11MoXqQGMcySSdR4Nd6BmsHzRgoZQII23/NYubgc/YnoTEYu1vMDGADSDPwLfrBt609n
         bVu1P1+2H1Rx9aWToY7JJw6FMKES+0a2A7+ZmvcrrbvKROQAh3tI7bGrM+pcnRezlRj0
         iuiw==
X-Gm-Message-State: APjAAAXjjoxAKVNIe8MBaG/uurpCdNSJvz4UOJjbu9kJMZkQI0AFPkcG
        63GQZ16eTWdQWfxmW5lHnwCCK53qN5gWaw==
X-Google-Smtp-Source: APXvYqwcE0PXhSmLqA97tcFscXsoq+mxBH1u5iombiRnu+dtFM7zTRh4Rg3/uFNuDVkCSqHJGc62Fh06qxAIGg==
X-Received: by 2002:a1f:3fc1:: with SMTP id m184mr14533551vka.63.1580753710585;
 Mon, 03 Feb 2020 10:15:10 -0800 (PST)
Date:   Mon,  3 Feb 2020 10:15:07 -0800
Message-Id: <20200203181507.257696-1-edumazet@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.25.0.341.g760bfbb309-goog
Subject: [PATCH net] net: hsr: fix possible NULL deref in hsr_handle_frame()
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

hsr_port_get_rcu() can return NULL, so we need to be careful.

general protection fault, probably for non-canonical address 0xdffffc0000000006: 0000 [#1] PREEMPT SMP KASAN
KASAN: null-ptr-deref in range [0x0000000000000030-0x0000000000000037]
CPU: 1 PID: 10249 Comm: syz-executor.5 Not tainted 5.5.0-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
RIP: 0010:__read_once_size include/linux/compiler.h:199 [inline]
RIP: 0010:hsr_addr_is_self+0x86/0x330 net/hsr/hsr_framereg.c:44
Code: 04 00 f3 f3 f3 65 48 8b 04 25 28 00 00 00 48 89 45 d0 31 c0 e8 6b ff 94 f9 4c 89 f2 48 b8 00 00 00 00 00 fc ff df 48 c1 ea 03 <80> 3c 02 00 0f 85 75 02 00 00 48 8b 43 30 49 39 c6 49 89 47 c0 0f
RSP: 0018:ffffc90000da8a90 EFLAGS: 00010206
RAX: dffffc0000000000 RBX: 0000000000000000 RCX: ffffffff87e0cc33
RDX: 0000000000000006 RSI: ffffffff87e035d5 RDI: 0000000000000000
RBP: ffffc90000da8b20 R08: ffff88808e7de040 R09: ffffed1015d2707c
R10: ffffed1015d2707b R11: ffff8880ae9383db R12: ffff8880a689bc5e
R13: 1ffff920001b5153 R14: 0000000000000030 R15: ffffc90000da8af8
FS:  00007fd7a42be700(0000) GS:ffff8880ae900000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000001b32338000 CR3: 00000000a928c000 CR4: 00000000001406e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 <IRQ>
 hsr_handle_frame+0x1c5/0x630 net/hsr/hsr_slave.c:31
 __netif_receive_skb_core+0xfbc/0x30b0 net/core/dev.c:5099
 __netif_receive_skb_one_core+0xa8/0x1a0 net/core/dev.c:5196
 __netif_receive_skb+0x2c/0x1d0 net/core/dev.c:5312
 process_backlog+0x206/0x750 net/core/dev.c:6144
 napi_poll net/core/dev.c:6582 [inline]
 net_rx_action+0x508/0x1120 net/core/dev.c:6650
 __do_softirq+0x262/0x98c kernel/softirq.c:292
 do_softirq_own_stack+0x2a/0x40 arch/x86/entry/entry_64.S:1082
 </IRQ>

Fixes: c5a759117210 ("net/hsr: Use list_head (and rcu) instead of array for slave devices.")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Reported-by: syzbot <syzkaller@googlegroups.com>
---
 net/hsr/hsr_slave.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/hsr/hsr_slave.c b/net/hsr/hsr_slave.c
index ee561297d8a760dfd6496ea34b63e3a14c9390c4..fbfd0db182b775bffb24eb26e8390f8e5a23c4fc 100644
--- a/net/hsr/hsr_slave.c
+++ b/net/hsr/hsr_slave.c
@@ -27,6 +27,8 @@ static rx_handler_result_t hsr_handle_frame(struct sk_buff **pskb)
 
 	rcu_read_lock(); /* hsr->node_db, hsr->ports */
 	port = hsr_port_get_rcu(skb->dev);
+	if (!port)
+		goto finish_pass;
 
 	if (hsr_addr_is_self(port->hsr, eth_hdr(skb)->h_source)) {
 		/* Directly kill frames sent by ourselves */
-- 
2.25.0.341.g760bfbb309-goog

