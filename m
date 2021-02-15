Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DDD9C31C25B
	for <lists+netdev@lfdr.de>; Mon, 15 Feb 2021 20:20:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230182AbhBOTSu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Feb 2021 14:18:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59320 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229764AbhBOTSn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Feb 2021 14:18:43 -0500
Received: from mail-qk1-x730.google.com (mail-qk1-x730.google.com [IPv6:2607:f8b0:4864:20::730])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F44EC061574;
        Mon, 15 Feb 2021 11:18:03 -0800 (PST)
Received: by mail-qk1-x730.google.com with SMTP id 81so7370708qkf.4;
        Mon, 15 Feb 2021 11:18:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=VGma3cguk2dBfaMy3vFuZ0Dx/qhsJ60el9vSPNdGNtM=;
        b=uSAQVPHZB3PCLiIBnJrA6dWjhv+H3Z5CEG4iRCV6UbvEyHeG26LjhrsT8oIXVlL7+7
         i20bH8ZoKs6iqeIov809LoLY6XbfkWCwRGtpFRCF/LZXd9uMZkhTg4nb6KxI2XY/wdgO
         Dl0nSfWlyH0lshwpo1MA24GBrzonxdamUvb9RKSWjFXNoubzoebTChgqW6OUeWP8NJgB
         ig1YT61qNC4PkKfsqzU0/S3GFk7ObDjGsEWf/fdZ9GP1nSnrJzA596t0OLQQivuob8m6
         VwMUs2NP3ck3KpQokIHBK6viPFSQQQrCXuHCObJsiMHPN6Gr3AsAgvPuTxou3CWhP+LK
         XVmg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=VGma3cguk2dBfaMy3vFuZ0Dx/qhsJ60el9vSPNdGNtM=;
        b=R7Z1NHGXB5Cfl1Nj87d2WtMMQkX13UNvyig/wVJab9ErFgXLTTPcV0sYvqB/bGPmFe
         csnTrer3exuScZOlO1r4gMbjqQclnMTd6warP8kzvdzeJiJxx/hdSJuaa3Gu+NM/gSzX
         rJnKY23Cn7SSqWrIpuAC1ZuljAJumsrvQTH7DR1Sc8ZKbTwEHXCDoBSJfmOWActj62yT
         Uj6jHI49BDNYiTvJ3hFbTUQh+zZk6ke/aM7B/HcbLc5VCWh6WJTxdhtyv/itd4KKi1d2
         nn2+0SGjWyMKSyv+g+4Bbq8GWAcMRGYBYAOhsD20g1kzzY9b1PS2CdSlRykL2gL4f/Vt
         6Oog==
X-Gm-Message-State: AOAM533cMOJgifOFh2vEFRUkPDkc8luKPoNvY4ELkpH2wy1j0l9Bvuxl
        AFSx35QFRvaa/Umq3XTGcYc=
X-Google-Smtp-Source: ABdhPJyoMbW/WlsIJV8Mbzwk5xiQIVh1zOiC+waNTNSZLh/Rb1XNgHzhDy4vTOjp/J69zT2dQo5qjw==
X-Received: by 2002:a37:6f06:: with SMTP id k6mr16420513qkc.458.1613416682305;
        Mon, 15 Feb 2021 11:18:02 -0800 (PST)
Received: from tong-desktop.local ([2601:5c0:c200:27c6:48a6:eef1:8ac9:fd76])
        by smtp.googlemail.com with ESMTPSA id d14sm11986642qtc.25.2021.02.15.11.18.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Feb 2021 11:18:02 -0800 (PST)
From:   Tong Zhang <ztong0001@gmail.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Tong Zhang <ztong0001@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>,
        Andrew Lunn <andrew@lunn.ch>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] net: wan/lmc: unregister device when no matching device is found
Date:   Mon, 15 Feb 2021 14:17:56 -0500
Message-Id: <20210215191757.2667925-1-ztong0001@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

lmc set sc->lmc_media pointer when there is a matching device.
However, when no matching device is found, this pointer is NULL
and the following dereference will result in a null-ptr-deref.

To fix this issue, unregister the hdlc device and return an error.

[    4.569359] BUG: KASAN: null-ptr-deref in lmc_init_one.cold+0x2b6/0x55d [lmc]
[    4.569748] Read of size 8 at addr 0000000000000008 by task modprobe/95
[    4.570102]
[    4.570187] CPU: 0 PID: 95 Comm: modprobe Not tainted 5.11.0-rc7 #94
[    4.570527] Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS rel-1.13.0-48-gd9c812dda519-preb4
[    4.571125] Call Trace:
[    4.571261]  dump_stack+0x7d/0xa3
[    4.571445]  kasan_report.cold+0x10c/0x10e
[    4.571667]  ? lmc_init_one.cold+0x2b6/0x55d [lmc]
[    4.571932]  lmc_init_one.cold+0x2b6/0x55d [lmc]
[    4.572186]  ? lmc_mii_readreg+0xa0/0xa0 [lmc]
[    4.572432]  local_pci_probe+0x6f/0xb0
[    4.572639]  pci_device_probe+0x171/0x240
[    4.572857]  ? pci_device_remove+0xe0/0xe0
[    4.573080]  ? kernfs_create_link+0xb6/0x110
[    4.573315]  ? sysfs_do_create_link_sd.isra.0+0x76/0xe0
[    4.573598]  really_probe+0x161/0x420
[    4.573799]  driver_probe_device+0x6d/0xd0
[    4.574022]  device_driver_attach+0x82/0x90
[    4.574249]  ? device_driver_attach+0x90/0x90
[    4.574485]  __driver_attach+0x60/0x100
[    4.574694]  ? device_driver_attach+0x90/0x90
[    4.574931]  bus_for_each_dev+0xe1/0x140
[    4.575146]  ? subsys_dev_iter_exit+0x10/0x10
[    4.575387]  ? klist_node_init+0x61/0x80
[    4.575602]  bus_add_driver+0x254/0x2a0
[    4.575812]  driver_register+0xd3/0x150
[    4.576021]  ? 0xffffffffc0018000
[    4.576202]  do_one_initcall+0x84/0x250
[    4.576411]  ? trace_event_raw_event_initcall_finish+0x150/0x150
[    4.576733]  ? unpoison_range+0xf/0x30
[    4.576938]  ? ____kasan_kmalloc.constprop.0+0x84/0xa0
[    4.577219]  ? unpoison_range+0xf/0x30
[    4.577423]  ? unpoison_range+0xf/0x30
[    4.577628]  do_init_module+0xf8/0x350
[    4.577833]  load_module+0x3fe6/0x4340
[    4.578038]  ? vm_unmap_ram+0x1d0/0x1d0
[    4.578247]  ? ____kasan_kmalloc.constprop.0+0x84/0xa0
[    4.578526]  ? module_frob_arch_sections+0x20/0x20
[    4.578787]  ? __do_sys_finit_module+0x108/0x170
[    4.579037]  __do_sys_finit_module+0x108/0x170
[    4.579278]  ? __ia32_sys_init_module+0x40/0x40
[    4.579523]  ? file_open_root+0x200/0x200
[    4.579742]  ? do_sys_open+0x85/0xe0
[    4.579938]  ? filp_open+0x50/0x50
[    4.580125]  ? exit_to_user_mode_prepare+0xfc/0x130
[    4.580390]  do_syscall_64+0x33/0x40
[    4.580586]  entry_SYSCALL_64_after_hwframe+0x44/0xa9
[    4.580859] RIP: 0033:0x7f1a724c3cf7
[    4.581054] Code: 48 89 57 30 48 8b 04 24 48 89 47 38 e9 1d a0 02 00 48 89 f8 48 89 f7 48 89 d6 48 891
[    4.582043] RSP: 002b:00007fff44941c68 EFLAGS: 00000246 ORIG_RAX: 0000000000000139
[    4.582447] RAX: ffffffffffffffda RBX: 00000000012ada70 RCX: 00007f1a724c3cf7
[    4.582827] RDX: 0000000000000000 RSI: 00000000012ac9e0 RDI: 0000000000000003
[    4.583207] RBP: 0000000000000003 R08: 0000000000000000 R09: 0000000000000001
[    4.583587] R10: 00007f1a72527300 R11: 0000000000000246 R12: 00000000012ac9e0
[    4.583968] R13: 0000000000000000 R14: 00000000012acc90 R15: 0000000000000001
[    4.584349] ==================================================================

Signed-off-by: Tong Zhang <ztong0001@gmail.com>
---
 drivers/net/wan/lmc/lmc_main.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/wan/lmc/lmc_main.c b/drivers/net/wan/lmc/lmc_main.c
index 93c7e8502845..ebb568f9bc66 100644
--- a/drivers/net/wan/lmc/lmc_main.c
+++ b/drivers/net/wan/lmc/lmc_main.c
@@ -899,6 +899,8 @@ static int lmc_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
         break;
     default:
 	printk(KERN_WARNING "%s: LMC UNKNOWN CARD!\n", dev->name);
+	unregister_hdlc_device(dev);
+	return -EIO;
         break;
     }
 
-- 
2.25.1

