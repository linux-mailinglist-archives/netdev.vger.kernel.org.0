Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C9FFE10DDE0
	for <lists+netdev@lfdr.de>; Sat, 30 Nov 2019 15:34:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726645AbfK3OYL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 30 Nov 2019 09:24:11 -0500
Received: from mail-pl1-f195.google.com ([209.85.214.195]:43074 "EHLO
        mail-pl1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725985AbfK3OYL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 30 Nov 2019 09:24:11 -0500
Received: by mail-pl1-f195.google.com with SMTP id q16so9930669plr.10
        for <netdev@vger.kernel.org>; Sat, 30 Nov 2019 06:24:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=8Upik4dGhKP0XgksNaQ9izlZCzSo+n242tBRatuMSo0=;
        b=lkke2bBsxKN+pVbDs8rZJVZlaAllDpI3veCXpBJgFaG7f/DPS10KpzqyLrO2PlQRJV
         PCUSzztfBmidTacIJUbQMFFJiJQg82GgSwqO6hKpvZyjqippKpvXUtvbskGYDbMDiafY
         MCeiWYkPcxN8Kh+yg3ZsKner7x/98gQK1o3PNXbpUWXzbnmYdn2qtVxAwUdP+ktGZXU4
         93sK37ZvN1mnNtdbdC9T+U2v7NdspFVbL5uD6C2/KXJyZxkK+GN4EvpMw3scvCLWA5F5
         g/2QslhMvxE/pg5+goI2h0ZrJ7bFAi9VEp9j1VhqA7h5CZhrG1jGpeFeOc4JFl5PAOsF
         OZbw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=8Upik4dGhKP0XgksNaQ9izlZCzSo+n242tBRatuMSo0=;
        b=GThYSDlmDHFlexjOk3lrlNzsiD/rBKekhGeUd89+dDVZO7o9hkmkUXxiDfhKXw8f0C
         SiFXQHnPP7X3NOI0Xz7MtLG7N2sQ/TJTpbaDmLTAjp8Su4oZVtWg1M4D/Eo3rblWJu4h
         CWQgVSzGijcHXQUYikw5AuxAdQJJiVMB22WMLVoyhnhYrNARJbAMzLWqb2KKyGwcXk9j
         lVwGZs2lE5YxKlq6t4/LVmKGmVZ+CCUkXrrRIwVF3nGTkB1VIUK1zVvTx3FsqD0qOKRF
         Dhg+NoXpiw8CpCpYrXnNRxcaS17liybuEkGqqHhelocFJlEWZN1aG37gGuJpZZHL7z8w
         QHrA==
X-Gm-Message-State: APjAAAVD/4xau6Y3Z2pxUM2xMhl1tXW6cIew8vE4oXkqnDlDb8PSSEu4
        cOL1ArxlLM985fJY/vTxQwXxmEv6
X-Google-Smtp-Source: APXvYqzfgam2JClSdu/9A3JGXfv9woJqxGeCH/UhS2GXGiS6ap/HO0+9ZlPvXmCZr8zJ/MV5DU6AKA==
X-Received: by 2002:a17:902:868f:: with SMTP id g15mr18674480plo.294.1575123849858;
        Sat, 30 Nov 2019 06:24:09 -0800 (PST)
Received: from localhost.localdomain ([110.35.161.54])
        by smtp.gmail.com with ESMTPSA id 17sm14771879pfv.142.2019.11.30.06.24.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 30 Nov 2019 06:24:08 -0800 (PST)
From:   Taehee Yoo <ap420073@gmail.com>
To:     davem@davemloft.net, xiyou.wangcong@gmail.com,
        netdev@vger.kernel.org
Cc:     ap420073@gmail.com, treeze.taeung@gmail.com
Subject: [net PATCH] hsr: fix a NULL pointer dereference in hsr_dev_xmit()
Date:   Sat, 30 Nov 2019 14:24:00 +0000
Message-Id: <20191130142400.3930-1-ap420073@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

hsr_dev_xmit() calls hsr_port_get_hsr() to find master node and that would
return NULL if master node is not existing in the list.
But hsr_dev_xmit() doesn't check return pointer so a NULL dereference
could occur.

In the TX datapath, there is no rcu_read_lock() so this patch adds missing
rcu_read_lock() in the hsr_dev_xmit() too.

Test commands:
    ip netns add nst
    ip link add v0 type veth peer name v1
    ip link add v2 type veth peer name v3
    ip link set v1 netns nst
    ip link set v3 netns nst
    ip link add hsr0 type hsr slave1 v0 slave2 v2
    ip a a 192.168.100.1/24 dev hsr0
    ip link set v0 up
    ip link set v2 up
    ip link set hsr0 up
    ip netns exec nst ip link add hsr1 type hsr slave1 v1 slave2 v3
    ip netns exec nst ip a a 192.168.100.2/24 dev hsr1
    ip netns exec nst ip link set v1 up
    ip netns exec nst ip link set v3 up
    ip netns exec nst ip link set hsr1 up
    hping3 192.168.100.2 -2 --flood &
    modprobe -rv hsr

Splat looks like:
[  390.879740][ T1362] general protection fault: 0000 [#1] SMP DEBUG_PAGEALLOC KASAN PTI
[  390.880789][ T1362] CPU: 3 PID: 1362 Comm: hping3 Not tainted 5.4.0+ #183
[  390.881679][ T1362] Hardware name: innotek GmbH VirtualBox/VirtualBox, BIOS VirtualBox 12/01/2006
[  390.882804][ T1362] RIP: 0010:hsr_dev_xmit+0x34/0x90 [hsr]
[  390.883528][ T1362] Code: 48 8d be 00 0c 00 00 be 04 00 00 00 48 83 ec 08 e8 21 be ff ff 48 8d 78 10 48 ba 00 00 00 0b
[  390.887020][ T1362] RSP: 0018:ffff888045507058 EFLAGS: 00010202
[  390.888067][ T1362] RAX: 0000000000000000 RBX: ffff88804a5d0cc0 RCX: 0000000000000002
[  390.889390][ T1362] RDX: dffffc0000000000 RSI: 0000000000000004 RDI: 0000000000000010
[  390.890525][ T1362] RBP: ffff88804a5d0cc0 R08: ffffed100d9c0d5d R09: 0000000000000001
[  390.891527][ T1362] R10: 0000000000000001 R11: ffffed100d9c0d5c R12: ffff888063bac000
[  390.893637][ T1362] R13: ffff888063bac088 R14: 0000000000000000 R15: ffff88806428fa00
[  390.900829][ T1362] FS:  00007fa5a5f40740(0000) GS:ffff88806cc00000(0000) knlGS:0000000000000000
[  390.908566][ T1362] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  390.909280][ T1362] CR2: 0000555eaf8cef58 CR3: 000000005c8ec002 CR4: 00000000000606e0
[  390.910070][ T1362] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[  390.910899][ T1362] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
[  390.911722][ T1362] Call Trace:
[  390.912105][ T1362]  dev_hard_start_xmit+0x160/0x740
[  390.912640][ T1362]  __dev_queue_xmit+0x1961/0x2e10
[  390.913148][ T1362]  ? check_object+0xaf/0x260
[  390.913630][ T1362]  ? __alloc_skb+0xb9/0x500
[  390.914088][ T1362]  ? init_object+0x6b/0x80
[  390.914558][ T1362]  ? netdev_core_pick_tx+0x2e0/0x2e0
[  390.915085][ T1362]  ? __alloc_skb+0xb9/0x500
[  390.915588][ T1362]  ? rcu_read_lock_sched_held+0x90/0xc0
[  390.916182][ T1362]  ? rcu_read_lock_bh_held+0xa0/0xa0
[  390.916742][ T1362]  ? kasan_unpoison_shadow+0x30/0x40
[  390.917276][ T1362]  ? __kasan_kmalloc.constprop.4+0xa0/0xd0
[  390.924192][ T1362]  ? __kmalloc_node_track_caller+0x3a8/0x3f0
[  390.924902][ T1362]  ? __kasan_kmalloc.constprop.4+0xa0/0xd0
[  390.925662][ T1362]  ? __kmalloc_reserve.isra.46+0x2e/0xb0
[  390.926398][ T1362]  ? memset+0x1f/0x40
[  390.926904][ T1362]  ? __alloc_skb+0x317/0x500
[  390.927492][ T1362]  ? arp_xmit+0xca/0x2c0
[  390.928050][ T1362]  arp_xmit+0xca/0x2c0
[  390.928576][ T1362]  ? arp_error_report+0x150/0x150
[  390.929209][ T1362]  ? eth_header+0x1b5/0x200
[  390.929781][ T1362]  ? memset+0x1f/0x40
[  390.930288][ T1362]  ? arp_create+0x616/0x780
[  390.930857][ T1362]  arp_send_dst.part.16+0x124/0x180
[  390.931524][ T1362]  ? arp_xmit+0x2c0/0x2c0
[  390.932088][ T1362]  arp_solicit+0x8cf/0xfb0
[  390.932654][ T1362]  ? lock_downgrade+0x6e0/0x6e0
[  390.933269][ T1362]  ? arp_send+0x90/0x90
[  390.933803][ T1362]  neigh_probe+0xaf/0xf0
[ ... ]

Fixes: 311633b60406 ("hsr: switch ->dellink() to ->ndo_uninit()")
Signed-off-by: Taehee Yoo <ap420073@gmail.com>
---
 net/hsr/hsr_device.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/net/hsr/hsr_device.c b/net/hsr/hsr_device.c
index f509b495451a..e3871491960c 100644
--- a/net/hsr/hsr_device.c
+++ b/net/hsr/hsr_device.c
@@ -226,9 +226,16 @@ static int hsr_dev_xmit(struct sk_buff *skb, struct net_device *dev)
 	struct hsr_priv *hsr = netdev_priv(dev);
 	struct hsr_port *master;
 
+	rcu_read_lock();
 	master = hsr_port_get_hsr(hsr, HSR_PT_MASTER);
-	skb->dev = master->dev;
-	hsr_forward_skb(skb, master);
+	if (master) {
+		skb->dev = master->dev;
+		hsr_forward_skb(skb, master);
+	} else {
+		atomic_long_inc(&dev->tx_dropped);
+		dev_kfree_skb_any(skb);
+	}
+	rcu_read_unlock();
 	return NETDEV_TX_OK;
 }
 
-- 
2.17.1

