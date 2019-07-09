Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DDA1663517
	for <lists+netdev@lfdr.de>; Tue,  9 Jul 2019 13:43:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726002AbfGILnX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Jul 2019 07:43:23 -0400
Received: from mail-ed1-f65.google.com ([209.85.208.65]:44872 "EHLO
        mail-ed1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726030AbfGILnW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Jul 2019 07:43:22 -0400
Received: by mail-ed1-f65.google.com with SMTP id k8so17426735edr.11
        for <netdev@vger.kernel.org>; Tue, 09 Jul 2019 04:43:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-powerpc-org.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id;
        bh=w6qkRdFWo1m+2kjAVkUW2xAjUrNP1RfMr/8PVdMgFZQ=;
        b=Yb86hqxS083UxGLB2HtEiuIagXH8l1erkM6OdRVVR1whdjwSWq5J9k8I3aUIaICmid
         Op81AX+HTh08KSF50g5bBeWjeJlF8YrnBxKuLDydX3Ix8XjtAmiJvN5PX++4liUvNWKk
         nG+mQD7YgvQ9LHKn2n++Vnn0ljzOL3+bDY8iSPa9F7yzY5WfAlYha/MM9rhn2fnkOyXP
         tk1OuZktVC2tCXCPq2hDzitNAn7cM5PZM6XjUZ7pU6oKgKeMo1bcfPjyFsQNZV1ZxCQ0
         8SEVJcdjqsmqvDBJidYsKXLmahMqqRmAP+EQERdme/RzC81hHooXJbniI/mGeZZYnR9M
         4QTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=w6qkRdFWo1m+2kjAVkUW2xAjUrNP1RfMr/8PVdMgFZQ=;
        b=IZgiT8lkVHH/NILP/MVLeEP6DP9vDqGi9SYB/W2dgbVXrOp8FZtuPRw9CirTM0sBQ/
         TwSpkszjkyCut/Sg9FPQ1rb0OBhYv6kxH1ZzBD63GA6NMGCQQ6e/gtjR3jhe8inSuioz
         Am7pOOMEy06wquJyf5lYqr4b1LqulvpaDksLythvZLcqijjp+g26yjfLFQoiVPVeH4yu
         d2AXDcWCcyXPFzmnWDzKtZihVq9P2JwHdLPkIb8vUKxm/S/nnT6u19pKNJgWuDiIU4cw
         0Ewfnnb/QhmuB8sNef7C7sN5kN47I12CtPf1+Jo767O07vyDed7TcZYlb/BS5DWbUvYi
         ZpOg==
X-Gm-Message-State: APjAAAVuIRPNDE/jM2Vd2NfHWPNjoFJ0hxCj6ZsSzeiY/XlC3R29zUGV
        WXboODiLZBTDrYvoFfQkn/K1bg==
X-Google-Smtp-Source: APXvYqz19DyVmsh25IQV9BuwYu4QLIOLLb7y1C5AueJeXlPb0ih1z7kcomjwkNHJmLL575Q24+PlAg==
X-Received: by 2002:a05:6402:6d0:: with SMTP id n16mr25037140edy.168.1562672600296;
        Tue, 09 Jul 2019 04:43:20 -0700 (PDT)
Received: from tegmen.arch.suse.de (nat.nue.novell.com. [195.135.221.2])
        by smtp.gmail.com with ESMTPSA id 43sm6423325edz.87.2019.07.09.04.43.19
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 09 Jul 2019 04:43:19 -0700 (PDT)
From:   Denis Kirjanov <kda@linux-powerpc.org>
X-Google-Original-From: Denis Kirjanov <dkirjanov@suse.com>
To:     mst@redhat.com, jasowang@redhat.com
Cc:     kvm@vger.kernel.org, netdev@vger.kernel.org,
        Denis Kirjanov <kda@linux-powerpc.org>
Subject: [PATCH] vhost: fix null pointer dereference in vhost_del_umem_range
Date:   Tue,  9 Jul 2019 13:42:51 +0200
Message-Id: <20190709114251.24662-1-dkirjanov@suse.com>
X-Mailer: git-send-email 2.12.3
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> UBSAN: Undefined behaviour in ../drivers/vhost/vhost.c:52:1
> member access within null pointer of type 'struct rb_root'
> CPU: 2 PID: 1450 Comm: syz-executor493 Not tainted
> 4.12.14-525.g4d6309b-default #1 SLE15 (unreleased)
> Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS
> 1.0.0-prebuilt.qemu-project.org 04/01/2014
> Call Trace:
>  __dump_stack lib/dump_stack.c:16 [inline]
>  dump_stack+0xc6/0x159 lib/dump_stack.c:52
>  ubsan_epilogue+0xe/0x81 lib/ubsan.c:164
>  handle_missaligned_access lib/ubsan.c:299 [inline]
>  __ubsan_handle_type_mismatch+0x2ed/0x44e lib/ubsan.c:325
>  vhost_chr_write_iter+0x103e/0x1330 [vhost]
>  call_write_iter include/linux/fs.h:1764 [inline]
>  new_sync_write fs/read_write.c:497 [inline]
>  __vfs_write+0x67c/0x9b0 fs/read_write.c:510
>  vfs_write+0x1a2/0x610 fs/read_write.c:558
>  SYSC_write fs/read_write.c:605 [inline]
>  SyS_write+0xd8/0x1f0 fs/read_write.c:597
>  do_syscall_64+0x26b/0x6e0 arch/x86/entry/common.c:284
>  entry_SYSCALL_64_after_hwframe+0x3d/0xa2
> RIP: 0033:0x7fdb7687a739
> RSP: 002b:00007ffd48719f38 EFLAGS: 00000213 ORIG_RAX: 0000000000000001
> RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 00007fdb7687a739
> RDX: 0000000000000068 RSI: 0000000020000300 RDI: 0000000000000003
> RBP: 00000000004006f0 R08: 0000000000000000 R09: 0000000000000000
> R10: 0000000000000000 R11: 0000000000000213 R12: 00000000004004a0
> R13: 00007ffd4871a020 R14: 0000000000000000 R15: 0000000000000000
> ================================================================================
> kasan: CONFIG_KASAN_INLINE enabled
> kasan: GPF could be caused by NULL-ptr deref or user memory access
> general protection fault: 0000 [#1] SMP KASAN PTI
> Modules linked in: vhost_net tun vhost tap af_packet iscsi_ibft
> iscsi_boot_sysfs bochs_drm ttm ppdev drm_kms_helper drm
> drm_panel_orientation_quirks joydev e1000 syscopyarea sysfillrect
> pcspkr sysimgblt fb_sys_fops i2c_piix4 parport_pc parport qemu_fw_cfg
> button ext4 crc16 jbd2 mbcache sr_mod cdrom sd_mod ata_generic
> ata_piix ahci libahci libata serio_raw floppy sg dm_multipath dm_mod
> scsi_dh_rdac scsi_dh_emc scsi_dh_alua scsi_mod autofs4
> Supported: No, Unreleased kernel
> CPU: 2 PID: 1450 Comm: syz-executor493 Not tainted
> 4.12.14-525.g4d6309b-default #1 SLE15 (unreleased)
> Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS
> 1.0.0-prebuilt.qemu-project.org 04/01/2014
> task: ffff88004b858040 task.stack: ffff88004a820000
> RIP: 0010:vhost_chr_write_iter+0x525/0x1330 [vhost]
> RSP: 0018:ffff88004a827a38 EFLAGS: 00010246
> RAX: dffffc0000000000 RBX: 1ffff10009504f51 RCX: 0000000000000000
> RDX: 0000000000000000 RSI: 0000000000000202 RDI: ffffed0009504f40
> RBP: 0000000000000000 R08: 0000000000000000 R09: 0000000000000000
> R10: 1ffff10009504ec1 R11: 0000000000000000 R12: 0000000020000040
> R13: dffffc0000000000 R14: ffff8800352f0000 R15: ffffed0006a5e005
> FS:  00007fdb76f79740(0000) GS:ffff880060d00000(0000)
> knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 000055b42161d980 CR3: 000000003422c000 CR4: 00000000000006e0
> Call Trace:
>  call_write_iter include/linux/fs.h:1764 [inline]
>  new_sync_write fs/read_write.c:497 [inline]
>  __vfs_write+0x67c/0x9b0 fs/read_write.c:510
>  vfs_write+0x1a2/0x610 fs/read_write.c:558
>  SYSC_write fs/read_write.c:605 [inline]
>  SyS_write+0xd8/0x1f0 fs/read_write.c:597
>  do_syscall_64+0x26b/0x6e0 arch/x86/entry/common.c:284
>  entry_SYSCALL_64_after_hwframe+0x3d/0xa2
> RIP: 0033:0x7fdb7687a739
> RSP: 002b:00007ffd48719f38 EFLAGS: 00000213 ORIG_RAX: 0000000000000001
> RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 00007fdb7687a739
> RDX: 0000000000000068 RSI: 0000000020000300 RDI: 0000000000000003
> RBP: 00000000004006f0 R08: 0000000000000000 R09: 0000000000000000
> R10: 0000000000000000 R11: 0000000000000213 R12: 00000000004004a0
> R13: 00007ffd4871a020 R14: 0000000000000000 R15: 0000000000000000
> Code: fc ff df 80 3c 02 00 0f 85 3c 0b 00 00 49 8b 6e 60 48 85 ed 0f
> 84 1c 0b 00 00 48 89 ea 48 b8 00 00 00 00 00 fc ff df 48 c1 ea 03 <80>
> 3c 02 00 0f 85 f4 0a 00 00 4c 8b 7d 00 4d 85 ff 0f 84 e7 06
> RIP: vhost_chr_write_iter+0x525/0x1330 [vhost] RSP: ffff88004a827a38
> ---[ end trace 49849730b5255f76 ]---

Fixes: 6b1e6cc7855b ("vhost: new device IOTLB API")

Signed-off-by: Denis Kirjanov <kda@linux-powerpc.org>
---
 drivers/vhost/vhost.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/vhost/vhost.c b/drivers/vhost/vhost.c
index e995c12d8e24..026123a6fc7b 100644
--- a/drivers/vhost/vhost.c
+++ b/drivers/vhost/vhost.c
@@ -962,7 +962,8 @@ static void vhost_del_umem_range(struct vhost_umem *umem,
 
 	while ((node = vhost_umem_interval_tree_iter_first(&umem->umem_tree,
 							   start, end)))
-		vhost_umem_free(umem, node);
+		if (node)
+			vhost_umem_free(umem, node);
 }
 
 static void vhost_iotlb_notify_vq(struct vhost_dev *d,
-- 
2.12.3

