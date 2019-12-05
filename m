Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0459C113C41
	for <lists+netdev@lfdr.de>; Thu,  5 Dec 2019 08:23:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726239AbfLEHXs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Dec 2019 02:23:48 -0500
Received: from mail-pj1-f65.google.com ([209.85.216.65]:33144 "EHLO
        mail-pj1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725963AbfLEHXr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Dec 2019 02:23:47 -0500
Received: by mail-pj1-f65.google.com with SMTP id r67so938082pjb.0
        for <netdev@vger.kernel.org>; Wed, 04 Dec 2019 23:23:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=TZaw7SeNr1TKOulLtq2xoXUEY3fkeVM/bmw+SQR8Uc8=;
        b=mC9sPPJ1GNUH0eyRvz9zljsEz6sS12V3bHIWCEy2uVDuwJvuyqoAAD23iN3LZsZUQt
         a7Olh1LFfpVdDTyfPwDtsDe17pbRbm1pqXL8F+H3jhsaGi/KDR9IPUSbe8OAy2zXp66L
         3UwzCo4h7RThKAkVVhOmVWA+Dd/ktCfbxp8V+Oj5t9jGve4BF0pFE3rb33nOOF5RGMvK
         tDorO4Bh3nam++Tf2CUu+WRBDUgg6lrAPEnwxBltUnMrHcvpb/hUTUuayMp0Leuuit0a
         16DNt66ETqiDlzX+4N9oWZsk+A8zqlii2ZBASXEw7zsYBaWKRD2xOEaKJEwfE4aGmNJS
         Gqxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=TZaw7SeNr1TKOulLtq2xoXUEY3fkeVM/bmw+SQR8Uc8=;
        b=geUH5my7gXGYfTpEstrjB01XAZ2Kdu+t9rmBDkk5WFBd5khyQFxJGhHnqH8lZrSvBj
         ykJP5aVU9g/1W9DJySZxKz6X+BQLCOqQKNhoieyoieMGa/qGw+hCwMCxXJhFStLVe77Y
         ZSHXaQfRqm53gQidhS+YGouKr+17bWpPbvK5jcBOenXSdx20GMXi7EozWdhPHxQs0JGc
         N43ndKlesgGVvy6QPs0Bz0ClI2oNR7D1LsU0QST/xS8V737OPstPF0tf/bFXkxoiqEbU
         KxY0Bb9Lkr8Ojlsc3p+XZ1xv2Lchx4pZxD9Gv+TVpXzx97hBEWeGEYLTqGBGCzgTbxfu
         LJqQ==
X-Gm-Message-State: APjAAAXkiIt841EldVgn6/V4TxnAlR9QE33BWMVkX3JPSy7oLHagUFdD
        NmKbu9c6+4vxxVCV5in+izSJlHTV
X-Google-Smtp-Source: APXvYqyr40RGOyqujBRfuTJT8H4HJHkuC+G9H/dQq2ifc9sQ6kAOSBCGY9wdDz65ihjlOUgtfqKrdg==
X-Received: by 2002:a17:902:b188:: with SMTP id s8mr7244427plr.206.1575530626800;
        Wed, 04 Dec 2019 23:23:46 -0800 (PST)
Received: from localhost.localdomain ([110.35.161.54])
        by smtp.gmail.com with ESMTPSA id f23sm9715226pgj.76.2019.12.04.23.23.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Dec 2019 23:23:45 -0800 (PST)
From:   Taehee Yoo <ap420073@gmail.com>
To:     davem@davemloft.net, xiyou.wangcong@gmail.com,
        netdev@vger.kernel.org
Cc:     ap420073@gmail.com, treeze.taeung@gmail.com
Subject: [PATCH v2 net] hsr: fix a NULL pointer dereference in hsr_dev_xmit()
Date:   Thu,  5 Dec 2019 07:23:39 +0000
Message-Id: <20191205072339.21906-1-ap420073@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

hsr_dev_xmit() calls hsr_port_get_hsr() to find master node and that would
return NULL if master node is not existing in the list.
But hsr_dev_xmit() doesn't check return pointer so a NULL dereference
could occur.

Test commands:
    ip netns add nst 
    ip link add veth0 type veth peer name veth1
    ip link add veth2 type veth peer name veth3
    ip link set veth1 netns nst
    ip link set veth3 netns nst
    ip link set veth0 up
    ip link set veth2 up
    ip link add hsr0 type hsr slave1 veth0 slave2 veth2
    ip a a 192.168.100.1/24 dev hsr0
    ip link set hsr0 up
    ip netns exec nst ip link set veth1 up
    ip netns exec nst ip link set veth3 up
    ip netns exec nst ip link add hsr1 type hsr slave1 veth1 slave2 veth3
    ip netns exec nst ip a a 192.168.100.2/24 dev hsr1
    ip netns exec nst ip link set hsr1 up
    hping3 192.168.100.2 -2 --flood &
    modprobe -rv hsr

Splat looks like:
[  217.351122][ T1635] kasan: CONFIG_KASAN_INLINE enabled
[  217.352969][ T1635] kasan: GPF could be caused by NULL-ptr deref or user memory access
[  217.354297][ T1635] general protection fault: 0000 [#1] SMP DEBUG_PAGEALLOC KASAN PTI
[  217.355507][ T1635] CPU: 1 PID: 1635 Comm: hping3 Not tainted 5.4.0+ #192
[  217.356472][ T1635] Hardware name: innotek GmbH VirtualBox/VirtualBox, BIOS VirtualBox 12/01/2006
[  217.357804][ T1635] RIP: 0010:hsr_dev_xmit+0x34/0x90 [hsr]
[  217.373010][ T1635] Code: 48 8d be 00 0c 00 00 be 04 00 00 00 48 83 ec 08 e8 21 be ff ff 48 8d 78 10 48 ba 00 b
[  217.376919][ T1635] RSP: 0018:ffff8880cd8af058 EFLAGS: 00010202
[  217.377571][ T1635] RAX: 0000000000000000 RBX: ffff8880acde6840 RCX: 0000000000000002
[  217.379465][ T1635] RDX: dffffc0000000000 RSI: 0000000000000004 RDI: 0000000000000010
[  217.380274][ T1635] RBP: ffff8880acde6840 R08: ffffed101b440d5d R09: 0000000000000001
[  217.381078][ T1635] R10: 0000000000000001 R11: ffffed101b440d5c R12: ffff8880bffcc000
[  217.382023][ T1635] R13: ffff8880bffcc088 R14: 0000000000000000 R15: ffff8880ca675c00
[  217.383094][ T1635] FS:  00007f060d9d1740(0000) GS:ffff8880da000000(0000) knlGS:0000000000000000
[  217.384289][ T1635] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  217.385009][ T1635] CR2: 00007faf15381dd0 CR3: 00000000d523c001 CR4: 00000000000606e0
[  217.385940][ T1635] Call Trace:
[  217.386544][ T1635]  dev_hard_start_xmit+0x160/0x740
[  217.387114][ T1635]  __dev_queue_xmit+0x1961/0x2e10
[  217.388118][ T1635]  ? check_object+0xaf/0x260
[  217.391466][ T1635]  ? __alloc_skb+0xb9/0x500
[  217.392017][ T1635]  ? init_object+0x6b/0x80
[  217.392629][ T1635]  ? netdev_core_pick_tx+0x2e0/0x2e0
[  217.393175][ T1635]  ? __alloc_skb+0xb9/0x500
[  217.393727][ T1635]  ? rcu_read_lock_sched_held+0x90/0xc0
[  217.394331][ T1635]  ? rcu_read_lock_bh_held+0xa0/0xa0
[  217.395013][ T1635]  ? kasan_unpoison_shadow+0x30/0x40
[  217.395668][ T1635]  ? __kasan_kmalloc.constprop.4+0xa0/0xd0
[  217.396280][ T1635]  ? __kmalloc_node_track_caller+0x3a8/0x3f0
[  217.399007][ T1635]  ? __kasan_kmalloc.constprop.4+0xa0/0xd0
[  217.400093][ T1635]  ? __kmalloc_reserve.isra.46+0x2e/0xb0
[  217.401118][ T1635]  ? memset+0x1f/0x40
[  217.402529][ T1635]  ? __alloc_skb+0x317/0x500
[  217.404915][ T1635]  ? arp_xmit+0xca/0x2c0
[ ... ]

Fixes: 311633b60406 ("hsr: switch ->dellink() to ->ndo_uninit()")
Acked-by: Cong Wang <xiyou.wangcong@gmail.com>
Signed-off-by: Taehee Yoo <ap420073@gmail.com>
---

v1 -> v2 : Do not add unnecessary rcu_read_lock()

 net/hsr/hsr_device.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/net/hsr/hsr_device.c b/net/hsr/hsr_device.c
index f509b495451a..b01e1bae4ddc 100644
--- a/net/hsr/hsr_device.c
+++ b/net/hsr/hsr_device.c
@@ -227,8 +227,13 @@ static int hsr_dev_xmit(struct sk_buff *skb, struct net_device *dev)
 	struct hsr_port *master;
 
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
 	return NETDEV_TX_OK;
 }
 
-- 
2.17.1

