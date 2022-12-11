Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7EDAE64943D
	for <lists+netdev@lfdr.de>; Sun, 11 Dec 2022 13:49:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230131AbiLKMtx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 11 Dec 2022 07:49:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49906 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229777AbiLKMtv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 11 Dec 2022 07:49:51 -0500
Received: from mail-wm1-x333.google.com (mail-wm1-x333.google.com [IPv6:2a00:1450:4864:20::333])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BCC09DF86
        for <netdev@vger.kernel.org>; Sun, 11 Dec 2022 04:49:49 -0800 (PST)
Received: by mail-wm1-x333.google.com with SMTP id 206-20020a1c02d7000000b003d21f02fbaaso552936wmc.4
        for <netdev@vger.kernel.org>; Sun, 11 Dec 2022 04:49:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=vVqzA/58l8MMO1vr9ms+6AubZC158aKBhObI1OGiZ98=;
        b=OKAP4ajMJms/DqTYRcYDxPK3fO3tpPZ65vSxzKiPxQ/mgpSyjyvTWbSsiyE4g2IrK/
         sesfh0OAVm2ATbtMdYQsejIfYKR3J42tc9rJnOeeYyGCdIie1gXaOiInmtYZTW7iTfUa
         jx6PO0lscY721ahP+d+on1BK80XWihQyhvoY0lJp9+jtF1R3WGz2ZTUmeQNTSm16z60H
         vJte/OBrHkBNisnHu6mQTz69X7kOYffY1ivdAjyeNM93G3JFY7sFN5Is6owyhd3xZ0N2
         y3lRjO6Mm8wpv/nbEX10gmGvrRFrFKWQeim9V769MG6c3cdcK6nXlwg+YXSOo2PdC9vR
         1kbw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=vVqzA/58l8MMO1vr9ms+6AubZC158aKBhObI1OGiZ98=;
        b=3mu56O5A8+KXT+cP8utix/CSIhUNZeqkL1W7K03x4bz0x80vquSqmmfAcvJwIi72Gf
         xiRj/F9TrpVi6olvvod14sfA4Rx7Gf2LJFh84TcS3rA7afr0sta7p3SMHjDNyjGqyePO
         18jAiXrsKmKEpBS09h6jeUbyd0MuG8fzAuEgeXfGUj3Tc5yLnLy5UgM0wXaRGryGNjWO
         Qa/G9f2+Ce+Czh2/XaIo8HUUDcOTZzP/8MXcwvcsgmSA6wyVscc8Az26CltgX9fXDwHW
         BFXy7DfSHUsTrWefvvjTS+II//WnDVZIt/skZ3rFdOSJ+omjmx7dLxwIvnCHGUvv6INg
         x9ag==
X-Gm-Message-State: ANoB5pkqW7iy170xwfnZS0seZjo1WEv1Uok3b5RLik0pzFIFit/iqNiR
        EXgfIlqWiW4yYx8KY/AksvI=
X-Google-Smtp-Source: AA0mqf5X9B0oBzvVXEcTN4e/XEXRYKnrk4yqEfGgDxaAOmL351kFcKON0kwUedBuxXimxwZDjuKd+g==
X-Received: by 2002:a05:600c:3b89:b0:3d0:7d89:2273 with SMTP id n9-20020a05600c3b8900b003d07d892273mr9863064wms.27.1670762988013;
        Sun, 11 Dec 2022 04:49:48 -0800 (PST)
Received: from niros.localdomain ([176.231.147.83])
        by smtp.gmail.com with ESMTPSA id p25-20020a05600c205900b003a6125562e1sm5624727wmg.46.2022.12.11.04.49.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 11 Dec 2022 04:49:47 -0800 (PST)
From:   Nir Levy <bhr166@gmail.com>
To:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, linux-atm-general@lists.sourceforge.net,
        netdev@vger.kernel.org, leon@kernel.org
Cc:     bhr166@gmail.com
Subject: [PATCH net v2] net: atm: Fix use-after-free bug in atm_dev_register()
Date:   Sun, 11 Dec 2022 14:49:43 +0200
Message-Id: <20221211124943.3004-1-bhr166@gmail.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Failure of device_register() in atm_register_sysfs causes to error
unwind in atm_dev_register. The last function will kfree the device,
while the comment above device_register() says that put_device() needs
to be used to give up the reference in the error path.

The use of kfree instead triggers a UAF, as shown by the following KASAN report,
obtained by trying to access adev->class_dev.

KASAN report details as below:

[   94.341664] BUG: KASAN: use-after-free in sysfs_kf_seq_show+0x306/0x440
[   94.341674] Read of size 8 at addr ffff88819a8a30e8 by task systemd-udevd/484

[   94.341680] CPU: 3 PID: 484 Comm: systemd-udevd Tainted: G            E      6.1.0-rc1+ #1
[   94.341684] Hardware name: VMware, Inc. VMware Virtual Platform/440BX Desktop Reference Platform, BIOS 6.00 02/27/2020
[   94.341703] Call Trace:
[   94.341705]  <TASK>
[   94.341707]  dump_stack_lvl+0x49/0x63
[   94.341713]  print_report+0x177/0x46e
[   94.341717]  ? kasan_complete_mode_report_info+0x7c/0x210
[   94.341720]  ? sysfs_kf_seq_show+0x306/0x440
[   94.341753]  kasan_report+0xb0/0x140
[   94.341757]  ? sysfs_kf_seq_show+0x306/0x440
[   94.341760]  __asan_report_load8_noabort+0x14/0x20
[   94.341763]  sysfs_kf_seq_show+0x306/0x440
[   94.341766]  kernfs_seq_show+0x145/0x1b0
[   94.341769]  seq_read_iter+0x408/0x1080
[   94.341774]  kernfs_fop_read_iter+0x3d5/0x540
[   94.341794]  vfs_read+0x542/0x800
[   94.341797]  ? kernel_read+0x130/0x130
[   94.341800]  ? __kasan_check_read+0x11/0x20
[   94.341824]  ? get_nth_filter.part.0+0x200/0x200
[   94.341828]  ksys_read+0x116/0x220
[   94.341831]  ? __ia32_sys_pwrite64+0x1f0/0x1f0
[   94.341849]  ? __secure_computing+0x17c/0x2d0
[   94.341852]  __x64_sys_read+0x72/0xb0
[   94.341875]  do_syscall_64+0x59/0x90
[   94.341878]  ? exc_page_fault+0x72/0xf0
[   94.341881]  entry_SYSCALL_64_after_hwframe+0x63/0xcd
[   94.341885] RIP: 0033:0x7fc391f14992
[   94.341888] Code: c0 e9 b2 fe ff ff 50 48 8d 3d fa b2 0c 00 e8 c5 1d 02 00 0f 1f 44 00 00 f3 0f 1e fa 64 8b 04 25 18 00 00 00 85 c0 75 10 0f 05 <48> 3d 00 f0 ff ff 77 56 c3 0f 1f 44 00 00 48 83 ec 28 48 89 54 24
[   94.341891] RSP: 002b:00007ffe33fed818 EFLAGS: 00000246 ORIG_RAX: 0000000000000000
[   94.341896] RAX: ffffffffffffffda RBX: 0000000000001018 RCX: 00007fc391f14992
[   94.341898] RDX: 0000000000001018 RSI: 0000558a696b0880 RDI: 000000000000000e
[   94.341900] RBP: 0000558a696b0880 R08: 0000000000000000 R09: 0000558a696b0880
[   94.341902] R10: 00007fc39201a300 R11: 0000000000000246 R12: 000000000000000e
[   94.341904] R13: 0000000000001017 R14: 0000000000000002 R15: 00007ffe33fed840
[   94.341908]  </TASK>

[   94.341911] Allocated by task 2613:
[   94.341914]  kasan_save_stack+0x26/0x50
[   94.341932]  kasan_set_track+0x25/0x40
[   94.341934]  kasan_save_alloc_info+0x1e/0x30
[   94.341936]  __kasan_kmalloc+0xb4/0xc0
[   94.341938]  kmalloc_trace+0x4a/0xb0
[   94.341941]  atm_dev_register+0x5d/0x700 [atm]
[   94.341949]  atmtcp_create+0x77/0x1f0 [atmtcp]
[   94.341953]  atmtcp_ioctl+0x12d/0xb9f [atmtcp]
[   94.341957]  do_vcc_ioctl+0xfe/0x640 [atm]
[   94.341962]  vcc_ioctl+0x10/0x20 [atm]
[   94.341968]  svc_ioctl+0x587/0x6c0 [atm]
[   94.341973]  sock_do_ioctl+0xd7/0x1e0
[   94.341977]  sock_ioctl+0x1b5/0x560
[   94.341979]  __x64_sys_ioctl+0x132/0x1b0
[   94.341981]  do_syscall_64+0x59/0x90
[   94.341983]  entry_SYSCALL_64_after_hwframe+0x63/0xcd

[   94.341986] Freed by task 2613:
[   94.341988]  kasan_save_stack+0x26/0x50
[   94.341991]  kasan_set_track+0x25/0x40
[   94.341993]  kasan_save_free_info+0x2e/0x50
[   94.341995]  ____kasan_slab_free+0x174/0x1e0
[   94.341997]  __kasan_slab_free+0x12/0x20
[   94.342000]  slab_free_freelist_hook+0xd0/0x1a0
[   94.342002]  __kmem_cache_free+0x193/0x2c0
[   94.342005]  kfree+0x79/0x120
[   94.342007]  atm_dev_register.cold+0x46/0x64 [atm]
[   94.342013]  atmtcp_create+0x77/0x1f0 [atmtcp]
[   94.342016]  atmtcp_ioctl+0x12d/0xb9f [atmtcp]
[   94.342020]  do_vcc_ioctl+0xfe/0x640 [atm]
[   94.342077]  vcc_ioctl+0x10/0x20 [atm]
[   94.342083]  svc_ioctl+0x587/0x6c0 [atm]
[   94.342088]  sock_do_ioctl+0xd7/0x1e0
[   94.342091]  sock_ioctl+0x1b5/0x560
[   94.342093]  __x64_sys_ioctl+0x132/0x1b0
[   94.342095]  do_syscall_64+0x59/0x90
[   94.342098]  entry_SYSCALL_64_after_hwframe+0x63/0xcd

[   94.342102] The buggy address belongs to the object at ffff88819a8a3000 which belongs to the cache kmalloc-1k of size 1024
[   94.342105] The buggy address is located 232 bytes inside of 1024-byte region [ffff88819a8a3000, ffff88819a8a3400)

[   94.342109] The buggy address belongs to the physical page:
[   94.342111] page:0000000099993f0a refcount:1 mapcount:0 mapping:0000000000000000 index:0x0 pfn:0x19a8a0
[   94.342114] head:0000000099993f0a order:3 compound_mapcount:0 compound_pincount:0
[   94.342116] flags: 0x17ffffc0010200(slab|head|node=0|zone=2|lastcpupid=0x1fffff)
[   94.342136] raw: 0017ffffc0010200 dead000000000100 dead000000000122 ffff888100042dc0
[   94.342138] raw: 0000000000000000 0000000080100010 00000001ffffffff 0000000000000000
[   94.342139] page dumped because: kasan: bad access detected

[   94.342141] Memory state around the buggy address:
[   94.342143]  ffff88819a8a2f80: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
[   94.342145]  ffff88819a8a3000: fa fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
[   94.342147] >ffff88819a8a3080: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
[   94.342148]                                                           ^
[   94.342150]  ffff88819a8a3100: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
[   94.342152]  ffff88819a8a3180: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb

Fixes: 656d98b09d57 ([ATM]: basic sysfs support for ATM devices)
Signed-off-by: Nir Levy <bhr166@gmail.com>
---
v2: Call put_device in atm_register_sysfs instead of atm_dev_register.
---
 net/atm/atm_sysfs.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/net/atm/atm_sysfs.c b/net/atm/atm_sysfs.c
index 0fdbdfd19474..04f6f9f277c1 100644
--- a/net/atm/atm_sysfs.c
+++ b/net/atm/atm_sysfs.c
@@ -149,8 +149,10 @@ int atm_register_sysfs(struct atm_dev *adev, struct device *parent)
 
 	dev_set_name(cdev, "%s%d", adev->type, adev->number);
 	err = device_register(cdev);
-	if (err < 0)
+	if (err < 0) {
+		put_device(cdev);
 		return err;
+	}
 
 	for (i = 0; atm_attrs[i]; i++) {
 		err = device_create_file(cdev, atm_attrs[i]);
@@ -163,7 +165,7 @@ int atm_register_sysfs(struct atm_dev *adev, struct device *parent)
 err_out:
 	for (j = 0; j < i; j++)
 		device_remove_file(cdev, atm_attrs[j]);
-	device_del(cdev);
+	device_unregister(cdev);
 	return err;
 }
 
-- 
2.34.1

