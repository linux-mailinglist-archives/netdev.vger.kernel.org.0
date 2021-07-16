Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9348A3CB14D
	for <lists+netdev@lfdr.de>; Fri, 16 Jul 2021 06:06:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230163AbhGPEJg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Jul 2021 00:09:36 -0400
Received: from szxga02-in.huawei.com ([45.249.212.188]:11431 "EHLO
        szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229534AbhGPEJf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 16 Jul 2021 00:09:35 -0400
Received: from dggemv711-chm.china.huawei.com (unknown [172.30.72.57])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4GQyJl6s0ZzcdqY;
        Fri, 16 Jul 2021 12:03:19 +0800 (CST)
Received: from dggema772-chm.china.huawei.com (10.1.198.214) by
 dggemv711-chm.china.huawei.com (10.1.198.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id
 15.1.2176.2; Fri, 16 Jul 2021 12:06:33 +0800
Received: from huawei.com (10.175.101.6) by dggema772-chm.china.huawei.com
 (10.1.198.214) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2176.2; Fri, 16
 Jul 2021 12:06:32 +0800
From:   Liu Jian <liujian56@huawei.com>
To:     <davem@davemloft.net>, <yoshfuji@linux-ipv6.org>,
        <kuba@kernel.org>, <netdev@vger.kernel.org>, <liujian56@huawei.com>
Subject: [next] igmp: Add ip_mc_list lock in ip_check_mc_rcu
Date:   Fri, 16 Jul 2021 12:06:17 +0800
Message-ID: <20210716040617.160609-1-liujian56@huawei.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.175.101.6]
X-ClientProxiedBy: dggems702-chm.china.huawei.com (10.3.19.179) To
 dggema772-chm.china.huawei.com (10.1.198.214)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

I got below panic when doing fuzz test:

Kernel panic - not syncing: panic_on_warn set ...
CPU: 0 PID: 4056 Comm: syz-executor.3 Tainted: G    B             5.14.0-rc1-00195-gcff5c4254439-dirty #2
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS rel-1.12.0-59-gc9ba5276e321-prebuilt.qemu.org 04/01/2014
Call Trace:
dump_stack_lvl+0x7a/0x9b
panic+0x2cd/0x5af
end_report.cold+0x5a/0x5a
kasan_report+0xec/0x110
ip_check_mc_rcu+0x556/0x5d0
__mkroute_output+0x895/0x1740
ip_route_output_key_hash_rcu+0x2d0/0x1050
ip_route_output_key_hash+0x182/0x2e0
ip_route_output_flow+0x28/0x130
udp_sendmsg+0x165d/0x2280
udpv6_sendmsg+0x121e/0x24f0
inet6_sendmsg+0xf7/0x140
sock_sendmsg+0xe9/0x180
____sys_sendmsg+0x2b8/0x7a0
___sys_sendmsg+0xf0/0x160
__sys_sendmmsg+0x17e/0x3c0
__x64_sys_sendmmsg+0x9e/0x100
do_syscall_64+0x3b/0x90
entry_SYSCALL_64_after_hwframe+0x44/0xae
RIP: 0033:0x462eb9
Code: f7 d8 64 89 02 b8 ff ff ff ff c3 66 0f 1f 44 00 00 48 89 f8
 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48>
 3d 01 f0 ff ff 73 01 c3 48 c7 c1 bc ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007f3df5af1c58 EFLAGS: 00000246 ORIG_RAX: 0000000000000133
RAX: ffffffffffffffda RBX: 000000000073bf00 RCX: 0000000000462eb9
RDX: 0000000000000312 RSI: 0000000020001700 RDI: 0000000000000007
RBP: 0000000000000004 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 00007f3df5af26bc
R13: 00000000004c372d R14: 0000000000700b10 R15: 00000000ffffffff

It is one use-after-free in ip_check_mc_rcu.
In ip_mc_del_src, the ip_sf_list of pmc has been freed under pmc->lock protection.
But access to ip_sf_list in ip_check_mc_rcu is not protected by the lock.

Signed-off-by: Liu Jian <liujian56@huawei.com>
---
 net/ipv4/igmp.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/ipv4/igmp.c b/net/ipv4/igmp.c
index 6b3c558a4f23..03589a04f9aa 100644
--- a/net/ipv4/igmp.c
+++ b/net/ipv4/igmp.c
@@ -2713,6 +2713,7 @@ int ip_check_mc_rcu(struct in_device *in_dev, __be32 mc_addr, __be32 src_addr, u
 		rv = 1;
 	} else if (im) {
 		if (src_addr) {
+			spin_lock_bh(&im->lock);
 			for (psf = im->sources; psf; psf = psf->sf_next) {
 				if (psf->sf_inaddr == src_addr)
 					break;
@@ -2723,6 +2724,7 @@ int ip_check_mc_rcu(struct in_device *in_dev, __be32 mc_addr, __be32 src_addr, u
 					im->sfcount[MCAST_EXCLUDE];
 			else
 				rv = im->sfcount[MCAST_EXCLUDE] != 0;
+			spin_unlock_bh(&im->lock);
 		} else
 			rv = 1; /* unspecified source; tentatively allow */
 	}
-- 
2.17.1

