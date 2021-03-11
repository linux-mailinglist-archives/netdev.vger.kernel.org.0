Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CD675336B20
	for <lists+netdev@lfdr.de>; Thu, 11 Mar 2021 05:28:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231184AbhCKE1x (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Mar 2021 23:27:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43336 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230478AbhCKE1p (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Mar 2021 23:27:45 -0500
Received: from mail-qk1-x72f.google.com (mail-qk1-x72f.google.com [IPv6:2607:f8b0:4864:20::72f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D77DC061574;
        Wed, 10 Mar 2021 20:27:45 -0800 (PST)
Received: by mail-qk1-x72f.google.com with SMTP id m186so2774592qke.12;
        Wed, 10 Mar 2021 20:27:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=d6iBVzrjOzFpEF0cG78Un10rIfazNsS3Fh2uaF87QxU=;
        b=j4npnM4WL8qJ1FgEEu4rOuu+0EZux8DdDc93T94se8KlSegD3O5FbINAzQi13QKsI/
         uYx/CvX03l3TPIyCgGI0y+j2fCjyAkRn6Cg0ytZhiWCGwPWyOvF1K8BgXddPG/YV/hGY
         o+ruVLKS8R2NF1m14vdUOuQ+FuT5yzNOlvTLrAfpgZnDwFc4QyHVVDVhikPcYujf5ZWY
         g3UoLYX1PvVN//azrX8U3tj58xdE3OMmT+QvZKaSKvoD20o9HMeP4SiI9wKCOFmp+4bs
         sNjF2b/GRuPFhhDeaMsaYQFlfIL8NyIrVTdoVrluAxj7BQIFyqVf4qYMU11HI4/OA3Ub
         9BeA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=d6iBVzrjOzFpEF0cG78Un10rIfazNsS3Fh2uaF87QxU=;
        b=ZJOqqs1ppECK3Yx71i9cB4aHjPUJvD6eXBVZPGi3IomRvYIa+EDHZePlZVLLdedn5g
         C0K5C3dmZm2ynmIf+VTpVE3/Kv2DJ47zBe9mn7Je+z3H0b9pCYUQtorOm81QgosVtoRV
         INmttRVLv/p8OxMIL04bAXtMjfepzWPMSYiQb7iRxb8rf3ptKXp/726yfg12BluTke8A
         2WNgFS4hxNJKf6NgxiwG1WhscK5OGiDN6HIrRbwOF+LzeH12P/YoWauw/muDhzd6DqRS
         T5qMqg9ghPkPwsPhT9H7azxffkRq3X2bn8P0Ub1dMdkvplW6yr8U31P1wmz05xsB006r
         s7kA==
X-Gm-Message-State: AOAM532y5W1TA18uFgMFaIISZ1Ud5fc/LBnZkD5wAYdq0IFLtZ3oqdUx
        FZCj1d1P/5zRHw0H7o6uLmgLFE1C/uyJ9A==
X-Google-Smtp-Source: ABdhPJy0TepP3fhAEpP4MGDYWPc5CLcqC9g7XmQO8dT8PNc95n61QX5/TwUegzKdaIJbtpnANhByag==
X-Received: by 2002:a37:a08e:: with SMTP id j136mr6050037qke.266.1615436864500;
        Wed, 10 Mar 2021 20:27:44 -0800 (PST)
Received: from tong-desktop.local ([2601:5c0:c200:27c6:615f:1cdf:698f:e42f])
        by smtp.googlemail.com with ESMTPSA id b10sm953626qtb.92.2021.03.10.20.27.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Mar 2021 20:27:44 -0800 (PST)
From:   Tong Zhang <ztong0001@gmail.com>
To:     Karsten Keil <isdn@linux-pingi.de>,
        Tong Zhang <ztong0001@gmail.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] mISDN: fix crash in fritzpci
Date:   Wed, 10 Mar 2021 23:27:35 -0500
Message-Id: <20210311042736.2062228-1-ztong0001@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

setup_fritz() in avmfritz.c might fail with -EIO and in this case the
isac.type and isac.write_reg is not initialized and remains 0(NULL).
A subsequent call to isac_release() will dereference isac->write_reg and
crash.

[    1.737444] BUG: kernel NULL pointer dereference, address: 0000000000000000
[    1.737809] #PF: supervisor instruction fetch in kernel mode
[    1.738106] #PF: error_code(0x0010) - not-present page
[    1.738378] PGD 0 P4D 0
[    1.738515] Oops: 0010 [#1] SMP NOPTI
[    1.738711] CPU: 0 PID: 180 Comm: systemd-udevd Not tainted 5.12.0-rc2+ #78
[    1.739077] Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS rel-1.13.0-48-gd9c812dda519-p
rebuilt.qemu.org 04/01/2014
[    1.739664] RIP: 0010:0x0
[    1.739807] Code: Unable to access opcode bytes at RIP 0xffffffffffffffd6.
[    1.740200] RSP: 0018:ffffc9000027ba10 EFLAGS: 00010202
[    1.740478] RAX: 0000000000000000 RBX: ffff888102f41840 RCX: 0000000000000027
[    1.740853] RDX: 00000000000000ff RSI: 0000000000000020 RDI: ffff888102f41800
[    1.741226] RBP: ffffc9000027ba20 R08: ffff88817bc18440 R09: ffffc9000027b808
[    1.741600] R10: 0000000000000001 R11: 0000000000000001 R12: ffff888102f41840
[    1.741976] R13: 00000000fffffffb R14: ffff888102f41800 R15: ffff8881008b0000
[    1.742351] FS:  00007fda3a38a8c0(0000) GS:ffff88817bc00000(0000) knlGS:0000000000000000
[    1.742774] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[    1.743076] CR2: ffffffffffffffd6 CR3: 00000001021ec000 CR4: 00000000000006f0
[    1.743452] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[    1.743828] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
[    1.744206] Call Trace:
[    1.744339]  isac_release+0xcc/0xe0 [mISDNipac]
[    1.744582]  fritzpci_probe.cold+0x282/0x739 [avmfritz]
[    1.744861]  local_pci_probe+0x48/0x80
[    1.745063]  pci_device_probe+0x10f/0x1c0
[    1.745278]  really_probe+0xfb/0x420
[    1.745471]  driver_probe_device+0xe9/0x160
[    1.745693]  device_driver_attach+0x5d/0x70
[    1.745917]  __driver_attach+0x8f/0x150
[    1.746123]  ? device_driver_attach+0x70/0x70
[    1.746354]  bus_for_each_dev+0x7e/0xc0
[    1.746560]  driver_attach+0x1e/0x20
[    1.746751]  bus_add_driver+0x152/0x1f0
[    1.746957]  driver_register+0x74/0xd0
[    1.747157]  ? 0xffffffffc00d8000
[    1.747334]  __pci_register_driver+0x54/0x60
[    1.747562]  AVM_init+0x36/0x1000 [avmfritz]
[    1.747791]  do_one_initcall+0x48/0x1d0
[    1.747997]  ? __cond_resched+0x19/0x30
[    1.748206]  ? kmem_cache_alloc_trace+0x390/0x440
[    1.748458]  ? do_init_module+0x28/0x250
[    1.748669]  do_init_module+0x62/0x250
[    1.748870]  load_module+0x23ee/0x26a0
[    1.749073]  __do_sys_finit_module+0xc2/0x120
[    1.749307]  ? __do_sys_finit_module+0xc2/0x120
[    1.749549]  __x64_sys_finit_module+0x1a/0x20
[    1.749782]  do_syscall_64+0x38/0x90

Signed-off-by: Tong Zhang <ztong0001@gmail.com>
---
 drivers/isdn/hardware/mISDN/mISDNipac.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/isdn/hardware/mISDN/mISDNipac.c b/drivers/isdn/hardware/mISDN/mISDNipac.c
index ec475087fbf9..39f841b42488 100644
--- a/drivers/isdn/hardware/mISDN/mISDNipac.c
+++ b/drivers/isdn/hardware/mISDN/mISDNipac.c
@@ -694,7 +694,7 @@ isac_release(struct isac_hw *isac)
 {
 	if (isac->type & IPAC_TYPE_ISACX)
 		WriteISAC(isac, ISACX_MASK, 0xff);
-	else
+	else if (isac->type != 0)
 		WriteISAC(isac, ISAC_MASK, 0xff);
 	if (isac->dch.timer.function != NULL) {
 		del_timer(&isac->dch.timer);
-- 
2.25.1

