Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 00BFC214B3B
	for <lists+netdev@lfdr.de>; Sun,  5 Jul 2020 11:00:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726519AbgGEJAi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 5 Jul 2020 05:00:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38806 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726454AbgGEJAi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 5 Jul 2020 05:00:38 -0400
Received: from mail-pg1-x541.google.com (mail-pg1-x541.google.com [IPv6:2607:f8b0:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 59F27C061794
        for <netdev@vger.kernel.org>; Sun,  5 Jul 2020 02:00:38 -0700 (PDT)
Received: by mail-pg1-x541.google.com with SMTP id d4so17029286pgk.4
        for <netdev@vger.kernel.org>; Sun, 05 Jul 2020 02:00:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=iW1/48prtKZUq6hzpZ/jGk7pFd5OGHLu3+kzlPpIss8=;
        b=ZDTB3R5u/BJBb6jOuX65C5GR9L0ReY5bNBptkVxacyxZ+JVf6y/Iqp4GaXtL55XVuK
         TKeFYAkkjWm16LW+WRwpYIsZgNg7DHb/KmXh2m6yQ5in5ZXIEfAeebF1KYADofqdd3wd
         DsTMhF+6KJtkOufr+z2tmPNA3uUZR6fM0DVARoH/h0piYv/W7d+9MpNUK1HKqx4DdBTw
         UgAwNdXh0jeHCIq4U8FPhJN1Au+MrIwREFbZ++EnqO3B6DB6nSNpoLUIMCLxsuwF066y
         /P9kijNVUDCHy1xLKqrxRDHdy74EekqiqV1H8L0W9bVGy3NNvuw7CCDp2R8TFAYRGt6l
         u1BA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=iW1/48prtKZUq6hzpZ/jGk7pFd5OGHLu3+kzlPpIss8=;
        b=t+oVCImJQDe0o/KBoxYZFkGlt7Nq0qb5DT4iq7r9oNz2sRTWN/6HEzQcqiVTdBJhri
         x0XLzhj+NgkznpL1zmCWeqLuOYs7YYgs5kccRz+nFjOolGgqB5OV7ehYH1ChkW25z1Z+
         SDTdh5VGIwVOTW8QezF2FRGfhWiB6iShBFMFr9jLWYj2KOcykfIbbj5VH2hwR04Z8geC
         laGGrm9X4eQvcx6HpdmcrBj/Wb90SLn6ZtZads+cjqLz+TStOUxJCQm1yOgklKNHHuzu
         bPxbPPC8puT5+Izn69HkOG8EIW5a4V4porF5xE8pp00ybCjikxpserjCOuiQMNPTyFLt
         QaZA==
X-Gm-Message-State: AOAM531gSZfNIEDOpBg6FVVozYx5LS75hyCm/rKVbomYoESmKyU91LFv
        x91IL5K/gj4lyfSJwTvrgCd1L4U2
X-Google-Smtp-Source: ABdhPJyZNT0S8jPrjFO/Eo6qpJLiZ4n7h0GgVEa0IiZe9spJz2p32PAYpHxGCmIc0Mx2+4JUPRHVog==
X-Received: by 2002:a05:6a00:15c7:: with SMTP id o7mr38684032pfu.51.1593939637511;
        Sun, 05 Jul 2020 02:00:37 -0700 (PDT)
Received: from martin-VirtualBox.vpn.alcatel-lucent.com ([117.202.89.119])
        by smtp.gmail.com with ESMTPSA id q22sm16128812pgn.91.2020.07.05.02.00.35
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 05 Jul 2020 02:00:36 -0700 (PDT)
From:   Martin Varghese <martinvarghesenokia@gmail.com>
To:     netdev@vger.kernel.org, davem@davemloft.net
Cc:     Martin Varghese <martin.varghese@nokia.com>
Subject: [PATCH net] net: Added pointer check for dst->ops->neigh_lookup in dst_neigh_lookup_skb
Date:   Sun,  5 Jul 2020 14:23:49 +0530
Message-Id: <1593939229-8191-1-git-send-email-martinvarghesenokia@gmail.com>
X-Mailer: git-send-email 1.9.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Martin Varghese <martin.varghese@nokia.com>

The packets from tunnel devices (eg bareudp) may have only
metadata in the dst pointer of skb. Hence a pointer check of
neigh_lookup is needed in dst_neigh_lookup_skb

Kernel crashes when packets from bareudp device is processed in
the kernel neighbour subsytem.

[  133.384484] BUG: kernel NULL pointer dereference, address: 0000000000000000
[  133.385240] #PF: supervisor instruction fetch in kernel mode
[  133.385828] #PF: error_code(0x0010) - not-present page
[  133.386603] PGD 0 P4D 0
[  133.386875] Oops: 0010 [#1] SMP PTI
[  133.387275] CPU: 0 PID: 5045 Comm: ping Tainted: G        W         5.8.0-rc2+ #15
[  133.388052] Hardware name: Red Hat KVM, BIOS 0.5.1 01/01/2011
[  133.391076] RIP: 0010:0x0
[  133.392401] Code: Bad RIP value.
[  133.394029] RSP: 0018:ffffb79980003d50 EFLAGS: 00010246
[  133.396656] RAX: 0000000080000102 RBX: ffff9de2fe0d6600 RCX: ffff9de2fe5e9d00
[  133.399018] RDX: 0000000000000000 RSI: ffff9de2fe5e9d00 RDI: ffff9de2fc21b400
[  133.399685] RBP: ffff9de2fe5e9d00 R08: 0000000000000000 R09: 0000000000000000
[  133.400350] R10: ffff9de2fbc6be22 R11: ffff9de2fe0d6600 R12: ffff9de2fc21b400
[  133.401010] R13: ffff9de2fe0d6628 R14: 0000000000000001 R15: 0000000000000003
[  133.401667] FS:  00007fe014918740(0000) GS:ffff9de2fec00000(0000) knlGS:0000000000000000
[  133.402412] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  133.402948] CR2: ffffffffffffffd6 CR3: 000000003bb72000 CR4: 00000000000006f0
[  133.403611] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[  133.404270] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
[  133.404933] Call Trace:
[  133.405169]  <IRQ>
[  133.405367]  __neigh_update+0x5a4/0x8f0
[  133.405734]  arp_process+0x294/0x820
[  133.406076]  ? __netif_receive_skb_core+0x866/0xe70
[  133.406557]  arp_rcv+0x129/0x1c0
[  133.406882]  __netif_receive_skb_one_core+0x95/0xb0
[  133.407340]  process_backlog+0xa7/0x150
[  133.407705]  net_rx_action+0x2af/0x420
[  133.408457]  __do_softirq+0xda/0x2a8
[  133.408813]  asm_call_on_stack+0x12/0x20
[  133.409290]  </IRQ>
[  133.409519]  do_softirq_own_stack+0x39/0x50
[  133.410036]  do_softirq+0x50/0x60
[  133.410401]  __local_bh_enable_ip+0x50/0x60
[  133.410871]  ip_finish_output2+0x195/0x530
[  133.411288]  ip_output+0x72/0xf0
[  133.411673]  ? __ip_finish_output+0x1f0/0x1f0
[  133.412122]  ip_send_skb+0x15/0x40
[  133.412471]  raw_sendmsg+0x853/0xab0
[  133.412855]  ? insert_pfn+0xfe/0x270
[  133.413827]  ? vvar_fault+0xec/0x190
[  133.414772]  sock_sendmsg+0x57/0x80
[  133.415685]  __sys_sendto+0xdc/0x160
[  133.416605]  ? syscall_trace_enter+0x1d4/0x2b0
[  133.417679]  ? __audit_syscall_exit+0x1d9/0x280
[  133.418753]  ? __prepare_exit_to_usermode+0x5d/0x1a0
[  133.419819]  __x64_sys_sendto+0x24/0x30
[  133.420848]  do_syscall_64+0x4d/0x90
[  133.421768]  entry_SYSCALL_64_after_hwframe+0x44/0xa9
[  133.422833] RIP: 0033:0x7fe013689c03
[  133.423749] Code: Bad RIP value.
[  133.424624] RSP: 002b:00007ffc7288f418 EFLAGS: 00000246 ORIG_RAX: 000000000000002c
[  133.425940] RAX: ffffffffffffffda RBX: 000056151fc63720 RCX: 00007fe013689c03
[  133.427225] RDX: 0000000000000040 RSI: 000056151fc63720 RDI: 0000000000000003
[  133.428481] RBP: 00007ffc72890b30 R08: 000056151fc60500 R09: 0000000000000010
[  133.429757] R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000040
[  133.431041] R13: 000056151fc636e0 R14: 000056151fc616bc R15: 0000000000000080
[  133.432481] Modules linked in: mpls_iptunnel act_mirred act_tunnel_key cls_flower sch_ingress veth mpls_router ip_tunnel bareudp ip6_udp_tunnel udp_tunnel macsec udp_diag inet_diag unix_diag af_packet_diag netlink_diag binfmt_misc xt_MASQUERADE iptable_nat xt_addrtype xt_conntrack nf_nat nf_conntrack nf_defrag_ipv6 nf_defrag_ipv4 br_netfilter bridge stp llc ebtable_filter ebtables overlay ip6table_filter ip6_tables iptable_filter sunrpc ext4 mbcache jbd2 pcspkr i2c_piix4 virtio_balloon joydev ip_tables xfs libcrc32c ata_generic qxl pata_acpi drm_ttm_helper ttm drm_kms_helper syscopyarea sysfillrect sysimgblt fb_sys_fops drm ata_piix libata virtio_net net_failover virtio_console failover virtio_blk i2c_core virtio_pci virtio_ring serio_raw floppy virtio dm_mirror dm_region_hash dm_log dm_mod
[  133.444045] CR2: 0000000000000000
[  133.445082] ---[ end trace f4aeee1958fd1638 ]---
[  133.446236] RIP: 0010:0x0
[  133.447180] Code: Bad RIP value.
[  133.448152] RSP: 0018:ffffb79980003d50 EFLAGS: 00010246
[  133.449363] RAX: 0000000080000102 RBX: ffff9de2fe0d6600 RCX: ffff9de2fe5e9d00
[  133.450835] RDX: 0000000000000000 RSI: ffff9de2fe5e9d00 RDI: ffff9de2fc21b400
[  133.452237] RBP: ffff9de2fe5e9d00 R08: 0000000000000000 R09: 0000000000000000
[  133.453722] R10: ffff9de2fbc6be22 R11: ffff9de2fe0d6600 R12: ffff9de2fc21b400
[  133.455149] R13: ffff9de2fe0d6628 R14: 0000000000000001 R15: 0000000000000003
[  133.456520] FS:  00007fe014918740(0000) GS:ffff9de2fec00000(0000) knlGS:0000000000000000
[  133.458046] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  133.459342] CR2: ffffffffffffffd6 CR3: 000000003bb72000 CR4: 00000000000006f0
[  133.460782] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[  133.462240] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
[  133.463697] Kernel panic - not syncing: Fatal exception in interrupt
[  133.465226] Kernel Offset: 0xfa00000 from 0xffffffff81000000 (relocation range: 0xffffffff80000000-0xffffffffbfffffff)
[  133.467025] ---[ end Kernel panic - not syncing: Fatal exception in interrupt ]---

Fixes: aaa0c23cb901 ("Fix dst_neigh_lookup/dst_neigh_lookup_skb return value handling bug")
Signed-off-by: Martin Varghese <martin.varghese@nokia.com>
---
 include/net/dst.h | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/include/net/dst.h b/include/net/dst.h
index 07adfac..852d8fb 100644
--- a/include/net/dst.h
+++ b/include/net/dst.h
@@ -400,7 +400,15 @@ static inline struct neighbour *dst_neigh_lookup(const struct dst_entry *dst, co
 static inline struct neighbour *dst_neigh_lookup_skb(const struct dst_entry *dst,
 						     struct sk_buff *skb)
 {
-	struct neighbour *n =  dst->ops->neigh_lookup(dst, skb, NULL);
+	struct neighbour *n = NULL;
+
+	/* The packets from tunnel devices (eg bareudp) may have only
+	 * metadata in the dst pointer of skb. Hence a pointer check of
+	 * neigh_lookup is needed.
+	 */
+	if (dst->ops->neigh_lookup)
+		n = dst->ops->neigh_lookup(dst, skb, NULL);
+
 	return IS_ERR(n) ? NULL : n;
 }
 
-- 
1.8.3.1

