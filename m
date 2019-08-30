Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2AD34A39AE
	for <lists+netdev@lfdr.de>; Fri, 30 Aug 2019 16:57:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727859AbfH3O5Z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Aug 2019 10:57:25 -0400
Received: from mail-qk1-f196.google.com ([209.85.222.196]:43412 "EHLO
        mail-qk1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727603AbfH3O5Z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Aug 2019 10:57:25 -0400
Received: by mail-qk1-f196.google.com with SMTP id m2so6340786qkd.10
        for <netdev@vger.kernel.org>; Fri, 30 Aug 2019 07:57:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=lca.pw; s=google;
        h=from:to:cc:subject:date:message-id;
        bh=VdU4IqIQzFHxd+M6em7DlzdJoaPdlqgzf47U8Wo/UZY=;
        b=SxtANCrQGcj5MVFqjiRM80K8nFsdfP0XQkmVLkSZaGYju+3XCHqMTDoxWdS0m+HWp7
         ghqB+tnB8cqMAdgoSNIfD5yCNX4O09Hd7c/JzCTtzk5c6tlAhSIiqtbCpEqClrQtMJHZ
         HT8Ppu2+J96acsckDryUozSGx0QavgQgtJx3Ifa7Spv0Thp296veLzJ4rUEH9tWOR1XV
         bnho9j8kNqRc17iAroF1a9EUlnPTGHD2tn44mkOOiM83IxNHTJfHG03kAeOHpOgzzpRW
         ECevlQ/tF0ECPpTLoruzER3CprFVRpSXZ6kLDfnmiVz3x761o/p+QItaReDmXDCU8dr1
         YJKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=VdU4IqIQzFHxd+M6em7DlzdJoaPdlqgzf47U8Wo/UZY=;
        b=ZJi1g7rbzs2oJLiv6ytcvH+NzHZQ1eLZpvYPD5X745A840bX+nyMXO3RNQO2Jy4tdn
         v2+gYeLfxldGFpchXimfQIgC7oP/qO5SCbP/25W8fZsx9DDJslkB128YiMf7m5vfjbsy
         M+vkomREo5jAGKJxHs3rg5MlUf2dKtwblnWsFjTCYvl3bh/PUqPgPW+RPWQfI9fjvtNG
         4Y4krAnpfCnx1is3UX3uJwkAEVqgBMKrzvA7nxcrHOxl0X+xd0IaqyeGMBy4DNJa7R2P
         jRElfKYugghON5opyfERQMsB2336DKy6yM8H+3J/6Ngox9XzLC3lvfA68qFjGJqyJcsb
         gIGQ==
X-Gm-Message-State: APjAAAUHlScxMPpQEkGter2VMgQXR9YuYbjQBm2v9eg6xMTr/ZcCEKbD
        BbjzwqFIOqdnIQm/jzPjJQNFWg==
X-Google-Smtp-Source: APXvYqzRogG5eVXU3g/T5CrzUOOO+WHGUX1BRnSwQvEQtDl0AfM6xqZ4iw2zSRiF0cP2PWHtu/IaTA==
X-Received: by 2002:a37:6003:: with SMTP id u3mr16046845qkb.166.1567177044407;
        Fri, 30 Aug 2019 07:57:24 -0700 (PDT)
Received: from qcai.nay.com (nat-pool-bos-t.redhat.com. [66.187.233.206])
        by smtp.gmail.com with ESMTPSA id y23sm2668473qki.118.2019.08.30.07.57.22
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 30 Aug 2019 07:57:23 -0700 (PDT)
From:   Qian Cai <cai@lca.pw>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Qian Cai <cai@lca.pw>
Subject: [PATCH] net/skbuff: silence warnings under memory pressure
Date:   Fri, 30 Aug 2019 10:57:05 -0400
Message-Id: <1567177025-11016-1-git-send-email-cai@lca.pw>
X-Mailer: git-send-email 1.8.3.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When running heavy memory pressure workloads, the system is throwing
endless warnings below due to the allocation could fail from
__build_skb(), and the volume of this call could be huge which may
generate a lot of serial console output and cosumes all CPUs as
warn_alloc() could be expensive by calling dump_stack() and then
show_mem().

Fix it by silencing the warning in this call site. Also, it seems
unnecessary to even print a warning at all if the allocation failed in
__build_skb(), as it may just retransmit the packet and retry.

NMI watchdog: Watchdog detected hard LOCKUP on cpu 7
Hardware name: HP ProLiant XL420 Gen9/ProLiant XL420 Gen9, BIOS U19
12/27/2015
RIP: 0010:dump_stack+0xd/0x9a
Code: 5d c3 48 c7 c2 c0 ce aa bb 4c 89 ee 48 c7 c7 60 32 e3 ae e8 b3 3e
81 ff e9 ab ff ff ff 55 48 89 e5 41 55 41 83 cd ff 41 54 53 <9c> 41 5c
fa be 04 00 00 00 48 c7 c7 80 42 63 af 65 8b 1d f6 7c 8c
RSP: 0018:ffff888452389670 EFLAGS: 00000086
RAX: 000000000000000b RBX: 0000000000000007 RCX: ffffffffae75143f
RDX: 0000000000000001 RSI: 0000000000000004 RDI: ffffffffaf634280
RBP: ffff888452389688 R08: 0000000000000004 R09: fffffbfff5ec6850
R10: fffffbfff5ec6850 R11: 0000000000000003 R12: 0000000000000086
R13: 00000000ffffffff R14: ffff88820547c040 R15: ffffffffaecc86a0
FS:  0000000000000000(0000) GS:ffff888452380000(0000)
knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f94f0537000 CR3: 00000005c8012006 CR4: 00000000001606a0
Call Trace:
 <IRQ>
 warn_alloc.cold.43+0x8a/0x148
 __alloc_pages_nodemask+0x1a5c/0x1bb0
 alloc_pages_current+0x9c/0x110
 allocate_slab+0x34a/0x11f0
 new_slab+0x46/0x70
 ___slab_alloc+0x604/0x950
 __slab_alloc+0x12/0x20
 kmem_cache_alloc+0x32a/0x400
 __build_skb+0x23/0x60
 build_skb+0x1a/0xb0
 igb_clean_rx_irq+0xafc/0x1010 [igb]
 igb_poll+0x4bb/0xe30 [igb]
 net_rx_action+0x244/0x7a0
 __do_softirq+0x1a0/0x60a
 irq_exit+0xb5/0xd0
 do_IRQ+0x81/0x170
 common_interrupt+0xf/0xf
 </IRQ>
RIP: 0010:cpuidle_enter_state+0x151/0x8d0
Code: 64 af e8 62 22 c2 ff 8b 05 04 f6 0b 01 85 c0 0f 8f 18 04 00 00 31
ff e8 9d 9e 97 ff 80 7d d0 00 0f 85 06 02 00 00 fb 45 85 ed <0f> 88 2d
02 00 00 4d 63 fd 49 83 ff 09 0f 87 8c 06 00 00 4b 8d 04
RSP: 0018:ffff888205487cf8 EFLAGS: 00000202 ORIG_RAX: ffffffffffffffdc
RAX: 0000000000000000 RBX: ffffe8fc09596f98 RCX: ffffffffadf093da
RDX: dffffc0000000000 RSI: dffffc0000000000 RDI: ffff8884523c2128
RBP: ffff888205487d48 R08: fffffbfff5ec9d62 R09: fffffbfff5ec9d62
R10: fffffbfff5ec9d61 R11: ffffffffaf64eb0b R12: ffffffffaf459580
R13: 0000000000000004 R14: 0000101fb3d64a9b R15: ffffe8fc09596f9c
 cpuidle_enter+0x41/0x70
 call_cpuidle+0x5e/0x90
 do_idle+0x313/0x340
 cpu_startup_entry+0x1d/0x1f
 start_secondary+0x28b/0x330
 secondary_startup_64+0xb6/0xc0

Signed-off-by: Qian Cai <cai@lca.pw>
---
 net/core/skbuff.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/net/core/skbuff.c b/net/core/skbuff.c
index 0338820ee0ec..9cc4148deddd 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -307,7 +307,9 @@ struct sk_buff *__build_skb(void *data, unsigned int frag_size)
 {
 	struct sk_buff *skb;
 
-	skb = kmem_cache_alloc(skbuff_head_cache, GFP_ATOMIC);
+	skb = kmem_cache_alloc(skbuff_head_cache,
+			       GFP_ATOMIC | __GFP_NOWARN);
+
 	if (unlikely(!skb))
 		return NULL;
 
-- 
1.8.3.1

