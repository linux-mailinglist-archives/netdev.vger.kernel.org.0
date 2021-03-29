Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 60B6034DB3F
	for <lists+netdev@lfdr.de>; Tue, 30 Mar 2021 00:27:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232424AbhC2W0x (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Mar 2021 18:26:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:47358 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232468AbhC2WYK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 29 Mar 2021 18:24:10 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6222F619AB;
        Mon, 29 Mar 2021 22:23:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617056613;
        bh=BsIwY5IKGdHhI2dBt8A0l/YE5IZ7IPpB9p4NRfJSA1c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ngyPko9s3SBQK3hZNX9PvB2tHpjFYhfaFsf/ZQL2QTR5LFXXQRk9ALtklkOExcb8J
         Vs48KlusqpY6qpy05IWhgRSap4hyHatvP4jSMS2CKIvja8R59lAaLH0Wt0lBUrIZxR
         yh+ASyJL1JoGt5OUUBXW/mkX4vOqlMAyXI2Y8ci5wAI46nkbYy0bNwy7V61XX41BPw
         QWuM2lgH+JHe6jMebc3ENgUKheaiMiv85IhvfA/Mp5rzjmbS5A4Op++M25z8icH4Vy
         SjiFPSGl1o2tNS1TLOFfmfTey/Ik/Sdtb2IZn7kKhGV+2ehLKlvpqnOJ9K4vw2M8AL
         tSnHeyHXZA+oQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Tong Zhang <ztong0001@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 05/15] mISDN: fix crash in fritzpci
Date:   Mon, 29 Mar 2021 18:23:16 -0400
Message-Id: <20210329222327.2383533-5-sashal@kernel.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210329222327.2383533-1-sashal@kernel.org>
References: <20210329222327.2383533-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tong Zhang <ztong0001@gmail.com>

[ Upstream commit a9f81244d2e33e6dfcef120fefd30c96b3f7cdb0 ]

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
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/isdn/hardware/mISDN/mISDNipac.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/isdn/hardware/mISDN/mISDNipac.c b/drivers/isdn/hardware/mISDN/mISDNipac.c
index 4d78f870435e..71e635d6c64a 100644
--- a/drivers/isdn/hardware/mISDN/mISDNipac.c
+++ b/drivers/isdn/hardware/mISDN/mISDNipac.c
@@ -710,7 +710,7 @@ isac_release(struct isac_hw *isac)
 {
 	if (isac->type & IPAC_TYPE_ISACX)
 		WriteISAC(isac, ISACX_MASK, 0xff);
-	else
+	else if (isac->type != 0)
 		WriteISAC(isac, ISAC_MASK, 0xff);
 	if (isac->dch.timer.function != NULL) {
 		del_timer(&isac->dch.timer);
-- 
2.30.1

