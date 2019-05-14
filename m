Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2C5A71C462
	for <lists+netdev@lfdr.de>; Tue, 14 May 2019 10:08:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726303AbfENIIi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 May 2019 04:08:38 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:55536 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725899AbfENIIi (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 14 May 2019 04:08:38 -0400
Received: from DGGEMS411-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id 310FA79B1C67F328660D;
        Tue, 14 May 2019 16:08:35 +0800 (CST)
Received: from localhost (10.177.31.96) by DGGEMS411-HUB.china.huawei.com
 (10.3.19.211) with Microsoft SMTP Server id 14.3.439.0; Tue, 14 May 2019
 16:08:27 +0800
From:   YueHaibing <yuehaibing@huawei.com>
To:     <davem@davemloft.net>, <paulus@samba.org>
CC:     <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        YueHaibing <yuehaibing@huawei.com>
Subject: [PATCH] ppp: deflate: Fix possible crash in deflate_init
Date:   Tue, 14 May 2019 15:43:00 +0800
Message-ID: <20190514074300.42588-1-yuehaibing@huawei.com>
X-Mailer: git-send-email 2.10.2.windows.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.177.31.96]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

BUG: unable to handle kernel paging request at ffffffffa018f000
PGD 3270067 P4D 3270067 PUD 3271063 PMD 2307eb067 PTE 0
Oops: 0000 [#1] PREEMPT SMP
CPU: 0 PID: 4138 Comm: modprobe Not tainted 5.1.0-rc7+ #1
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS
rel-1.9.3-0-ge2fc41e-prebuilt.qemu-project.org 04/01/2014
RIP: 0010:ppp_register_compressor+0x3e/0xd0 [ppp_generic]
Code: 98 4a 3f e2 48 8b 15 c1 67 00 00 41 8b 0c 24 48 81 fa 40 f0 19 a0
75 0e eb 35 48 8b 12 48 81 fa 40 f0 19 a0 74
RSP: 0018:ffffc90000d93c68 EFLAGS: 00010287
RAX: ffffffffa018f000 RBX: ffffffffa01a3000 RCX: 000000000000001a
RDX: ffff888230c750a0 RSI: 0000000000000000 RDI: ffffffffa019f000
RBP: ffffc90000d93c80 R08: 0000000000000001 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000000 R12: ffffffffa0194080
R13: ffff88822ee1a700 R14: 0000000000000000 R15: ffffc90000d93e78
FS:  00007f2339557540(0000) GS:ffff888237a00000(0000)
knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: ffffffffa018f000 CR3: 000000022bde4000 CR4: 00000000000006f0
Call Trace:
 ? 0xffffffffa01a3000
 deflate_init+0x11/0x1000 [ppp_deflate]
 ? 0xffffffffa01a3000
 do_one_initcall+0x6c/0x3cc
 ? kmem_cache_alloc_trace+0x248/0x3b0
 do_init_module+0x5b/0x1f1
 load_module+0x1db1/0x2690
 ? m_show+0x1d0/0x1d0
 __do_sys_finit_module+0xc5/0xd0
 __x64_sys_finit_module+0x15/0x20
 do_syscall_64+0x6b/0x1d0
 entry_SYSCALL_64_after_hwframe+0x49/0xbe

If ppp_deflate fails to register in deflate_init,
module initialization failed out, however
ppp_deflate_draft may has been regiestred and not
unregistered before return.
Then the seconed modprobe will trigger crash like this.

Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: YueHaibing <yuehaibing@huawei.com>
---
 drivers/net/ppp/ppp_deflate.c | 14 +++++++++-----
 1 file changed, 9 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ppp/ppp_deflate.c b/drivers/net/ppp/ppp_deflate.c
index b5edc7f..2829efe 100644
--- a/drivers/net/ppp/ppp_deflate.c
+++ b/drivers/net/ppp/ppp_deflate.c
@@ -610,12 +610,16 @@ static void z_incomp(void *arg, unsigned char *ibuf, int icnt)
 
 static int __init deflate_init(void)
 {
-        int answer = ppp_register_compressor(&ppp_deflate);
-        if (answer == 0)
-                printk(KERN_INFO
-		       "PPP Deflate Compression module registered\n");
+	int answer;
+
+	answer = ppp_register_compressor(&ppp_deflate);
+	if (answer)
+		return answer;
+
+	pr_info("PPP Deflate Compression module registered\n");
 	ppp_register_compressor(&ppp_deflate_draft);
-        return answer;
+
+	return 0;
 }
 
 static void __exit deflate_cleanup(void)
-- 
1.8.3.1


