Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A8493EF37
	for <lists+netdev@lfdr.de>; Tue, 30 Apr 2019 05:36:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730019AbfD3Dgp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Apr 2019 23:36:45 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:51286 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729933AbfD3Dgp (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 29 Apr 2019 23:36:45 -0400
Received: from DGGEMS414-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id 89612B9477FDCEFFFD37;
        Tue, 30 Apr 2019 11:36:43 +0800 (CST)
Received: from localhost (10.177.31.96) by DGGEMS414-HUB.china.huawei.com
 (10.3.19.214) with Microsoft SMTP Server id 14.3.439.0; Tue, 30 Apr 2019
 11:36:35 +0800
From:   YueHaibing <yuehaibing@huawei.com>
To:     <steffen.klassert@secunet.com>, <herbert@gondor.apana.org.au>,
        <davem@davemloft.net>, <kuznet@ms2.inr.ac.ru>,
        <yoshfuji@linux-ipv6.org>
CC:     <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        YueHaibing <yuehaibing@huawei.com>
Subject: [PATCH] vti4: Fix error path in vti_init and vti_fini
Date:   Tue, 30 Apr 2019 11:36:30 +0800
Message-ID: <20190430033630.27240-1-yuehaibing@huawei.com>
X-Mailer: git-send-email 2.10.2.windows.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.177.31.96]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

KASAN report this:

BUG: unable to handle kernel paging request at fffffbfff8280cc7
PGD 237fe4067 P4D 237fe4067 PUD 237e60067 PMD 1ebfd0067 PTE 0
Oops: 0000 [#1] SMP KASAN PTI
CPU: 0 PID: 8156 Comm: syz-executor.0 Tainted: G         C        5.1.0-rc3+ #8
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.10.2-1ubuntu1 04/01/2014
RIP: 0010:xfrm4_tunnel_register+0xb3/0x1f0 [tunnel4]
Code: e8 03 42 80 3c 28 00 0f 85 25 01 00 00 48 8b 5d 00 48 85 db 0f 84 a8 00 00 00 e8 08 cd b3 f3 48 8d 7b 18 48 89 f8 48 c1 e8 03 <42> 0f b6 04 28 84 c0 74 08 3c 03 0f 8e 04 01 00 00 44 8b 63 18 45
RSP: 0018:ffff8881b65bf9a0 EFLAGS: 00010a02
RAX: 1ffffffff8280cc7 RBX: ffffffffc1406620 RCX: ffffffff8d8880a8
RDX: 0000000000031712 RSI: ffffc900014bf000 RDI: ffffffffc1406638
RBP: ffffffffc108a4a0 R08: fffffbfff8211401 R09: fffffbfff8211401
R10: ffff8881b65bf9a0 R11: fffffbfff8211400 R12: ffffffffc1c08000
R13: dffffc0000000000 R14: 0000000000000000 R15: ffffffffc1bfe620
FS:  00007f5f07be3700(0000) GS:ffff8881f7200000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: fffffbfff8280cc7 CR3: 00000001e8d00004 CR4: 00000000007606f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
PKRU: 55555554
Call Trace:
 ? 0xffffffffc1c08000
 vti_init+0x9d/0x1000 [ip_vti]
 do_one_initcall+0xbc/0x47d init/main.c:901
 do_init_module+0x1b5/0x547 kernel/module.c:3456
 load_module+0x6405/0x8c10 kernel/module.c:3804
 __do_sys_finit_module+0x162/0x190 kernel/module.c:3898
 do_syscall_64+0x9f/0x450 arch/x86/entry/common.c:290
 entry_SYSCALL_64_after_hwframe+0x49/0xbe

commit dd9ee3444014 ("vti4: Fix a ipip packet processing bug
in 'IPCOMP' virtual tunnel") misplace xfrm4_tunnel_deregister in
vti_init and forgot to add cleanup in vti_fini.

Reported-by: Hulk Robot <hulkci@huawei.com>
Fixes: dd9ee3444014 ("vti4: Fix a ipip packet processing bug in 'IPCOMP' virtual tunnel")
Signed-off-by: YueHaibing <yuehaibing@huawei.com>
---
 net/ipv4/ip_vti.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/net/ipv4/ip_vti.c b/net/ipv4/ip_vti.c
index 68a21bf..b6235ca 100644
--- a/net/ipv4/ip_vti.c
+++ b/net/ipv4/ip_vti.c
@@ -659,9 +659,9 @@ static int __init vti_init(void)
 	return err;
 
 rtnl_link_failed:
-	xfrm4_protocol_deregister(&vti_ipcomp4_protocol, IPPROTO_COMP);
-xfrm_tunnel_failed:
 	xfrm4_tunnel_deregister(&ipip_handler, AF_INET);
+xfrm_tunnel_failed:
+	xfrm4_protocol_deregister(&vti_ipcomp4_protocol, IPPROTO_COMP);
 xfrm_proto_comp_failed:
 	xfrm4_protocol_deregister(&vti_ah4_protocol, IPPROTO_AH);
 xfrm_proto_ah_failed:
@@ -676,6 +676,7 @@ static int __init vti_init(void)
 static void __exit vti_fini(void)
 {
 	rtnl_link_unregister(&vti_link_ops);
+	xfrm4_tunnel_deregister(&ipip_handler, AF_INET);
 	xfrm4_protocol_deregister(&vti_ipcomp4_protocol, IPPROTO_COMP);
 	xfrm4_protocol_deregister(&vti_ah4_protocol, IPPROTO_AH);
 	xfrm4_protocol_deregister(&vti_esp4_protocol, IPPROTO_ESP);
-- 
2.7.0


