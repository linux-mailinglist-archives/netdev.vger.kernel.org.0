Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 21CC626C8E
	for <lists+netdev@lfdr.de>; Wed, 22 May 2019 21:36:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387602AbfEVTfj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 May 2019 15:35:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:54456 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732693AbfEVTa6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 22 May 2019 15:30:58 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B2181204FD;
        Wed, 22 May 2019 19:30:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1558553457;
        bh=q2qb3sRVdb6Cya9L6mQ6nTwhob2ur/tHhlpcd1WQC7E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PayTXhcsWAX/jmNPT2ANC8+ythRNeoCCM+6pktE8A3q1qE8PrvzTc5QYTNGkJDy5R
         dvRMSZ9RSNntmGGeXzXLE4rb0lzvXJyYtD/H8erHOHUTbNnT67HOno14UbxkDMSqhj
         kwBJ4jtP1dLPRdDa3AI8I7lvLoaHPyU28KUbPQy4=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     YueHaibing <yuehaibing@huawei.com>, Hulk Robot <hulkci@huawei.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.9 025/114] at76c50x-usb: Don't register led_trigger if usb_register_driver failed
Date:   Wed, 22 May 2019 15:28:48 -0400
Message-Id: <20190522193017.26567-25-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190522193017.26567-1-sashal@kernel.org>
References: <20190522193017.26567-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: YueHaibing <yuehaibing@huawei.com>

[ Upstream commit 09ac2694b0475f96be895848687ebcbba97eeecf ]

Syzkaller report this:

[ 1213.468581] BUG: unable to handle kernel paging request at fffffbfff83bf338
[ 1213.469530] #PF error: [normal kernel read fault]
[ 1213.469530] PGD 237fe4067 P4D 237fe4067 PUD 237e60067 PMD 1c868b067 PTE 0
[ 1213.473514] Oops: 0000 [#1] SMP KASAN PTI
[ 1213.473514] CPU: 0 PID: 6321 Comm: syz-executor.0 Tainted: G         C        5.1.0-rc3+ #8
[ 1213.473514] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.10.2-1ubuntu1 04/01/2014
[ 1213.473514] RIP: 0010:strcmp+0x31/0xa0
[ 1213.473514] Code: 00 00 00 00 fc ff df 55 53 48 83 ec 08 eb 0a 84 db 48 89 ef 74 5a 4c 89 e6 48 89 f8 48 89 fa 48 8d 6f 01 48 c1 e8 03 83 e2 07 <42> 0f b6 04 28 38 d0 7f 04 84 c0 75 50 48 89 f0 48 89 f2 0f b6 5d
[ 1213.473514] RSP: 0018:ffff8881f2b7f950 EFLAGS: 00010246
[ 1213.473514] RAX: 1ffffffff83bf338 RBX: ffff8881ea6f7240 RCX: ffffffff825350c6
[ 1213.473514] RDX: 0000000000000000 RSI: ffffffffc1ee19c0 RDI: ffffffffc1df99c0
[ 1213.473514] RBP: ffffffffc1df99c1 R08: 0000000000000001 R09: 0000000000000004
[ 1213.473514] R10: 0000000000000000 R11: ffff8881de353f00 R12: ffff8881ee727900
[ 1213.473514] R13: dffffc0000000000 R14: 0000000000000001 R15: ffffffffc1eeaaf0
[ 1213.473514] FS:  00007fa66fa01700(0000) GS:ffff8881f7200000(0000) knlGS:0000000000000000
[ 1213.473514] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 1213.473514] CR2: fffffbfff83bf338 CR3: 00000001ebb9e005 CR4: 00000000007606f0
[ 1213.473514] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[ 1213.473514] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
[ 1213.473514] PKRU: 55555554
[ 1213.473514] Call Trace:
[ 1213.473514]  led_trigger_register+0x112/0x3f0
[ 1213.473514]  led_trigger_register_simple+0x7a/0x110
[ 1213.473514]  ? 0xffffffffc1c10000
[ 1213.473514]  at76_mod_init+0x77/0x1000 [at76c50x_usb]
[ 1213.473514]  do_one_initcall+0xbc/0x47d
[ 1213.473514]  ? perf_trace_initcall_level+0x3a0/0x3a0
[ 1213.473514]  ? kasan_unpoison_shadow+0x30/0x40
[ 1213.473514]  ? kasan_unpoison_shadow+0x30/0x40
[ 1213.473514]  do_init_module+0x1b5/0x547
[ 1213.473514]  load_module+0x6405/0x8c10
[ 1213.473514]  ? module_frob_arch_sections+0x20/0x20
[ 1213.473514]  ? kernel_read_file+0x1e6/0x5d0
[ 1213.473514]  ? find_held_lock+0x32/0x1c0
[ 1213.473514]  ? cap_capable+0x1ae/0x210
[ 1213.473514]  ? __do_sys_finit_module+0x162/0x190
[ 1213.473514]  __do_sys_finit_module+0x162/0x190
[ 1213.473514]  ? __ia32_sys_init_module+0xa0/0xa0
[ 1213.473514]  ? __mutex_unlock_slowpath+0xdc/0x690
[ 1213.473514]  ? wait_for_completion+0x370/0x370
[ 1213.473514]  ? vfs_write+0x204/0x4a0
[ 1213.473514]  ? do_syscall_64+0x18/0x450
[ 1213.473514]  do_syscall_64+0x9f/0x450
[ 1213.473514]  entry_SYSCALL_64_after_hwframe+0x49/0xbe
[ 1213.473514] RIP: 0033:0x462e99
[ 1213.473514] Code: f7 d8 64 89 02 b8 ff ff ff ff c3 66 0f 1f 44 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 bc ff ff ff f7 d8 64 89 01 48
[ 1213.473514] RSP: 002b:00007fa66fa00c58 EFLAGS: 00000246 ORIG_RAX: 0000000000000139
[ 1213.473514] RAX: ffffffffffffffda RBX: 000000000073bf00 RCX: 0000000000462e99
[ 1213.473514] RDX: 0000000000000000 RSI: 0000000020000300 RDI: 0000000000000003
[ 1213.473514] RBP: 00007fa66fa00c70 R08: 0000000000000000 R09: 0000000000000000
[ 1213.473514] R10: 0000000000000000 R11: 0000000000000246 R12: 00007fa66fa016bc
[ 1213.473514] R13: 00000000004bcefa R14: 00000000006f6fb0 R15: 0000000000000004

If usb_register failed, no need to call led_trigger_register_simple.

Reported-by: Hulk Robot <hulkci@huawei.com>
Fixes: 1264b951463a ("at76c50x-usb: add driver")
Signed-off-by: YueHaibing <yuehaibing@huawei.com>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/atmel/at76c50x-usb.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/atmel/at76c50x-usb.c b/drivers/net/wireless/atmel/at76c50x-usb.c
index 0e180677c7fc5..09dbab464fe19 100644
--- a/drivers/net/wireless/atmel/at76c50x-usb.c
+++ b/drivers/net/wireless/atmel/at76c50x-usb.c
@@ -2583,8 +2583,8 @@ static int __init at76_mod_init(void)
 	if (result < 0)
 		printk(KERN_ERR DRIVER_NAME
 		       ": usb_register failed (status %d)\n", result);
-
-	led_trigger_register_simple("at76_usb-tx", &ledtrig_tx);
+	else
+		led_trigger_register_simple("at76_usb-tx", &ledtrig_tx);
 	return result;
 }
 
-- 
2.20.1

