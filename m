Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D7E1B3E5755
	for <lists+netdev@lfdr.de>; Tue, 10 Aug 2021 11:46:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238702AbhHJJqP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Aug 2021 05:46:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54028 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238986AbhHJJqN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Aug 2021 05:46:13 -0400
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1418BC0613D3
        for <netdev@vger.kernel.org>; Tue, 10 Aug 2021 02:45:52 -0700 (PDT)
Received: by mail-pj1-x1034.google.com with SMTP id j1so32241023pjv.3
        for <netdev@vger.kernel.org>; Tue, 10 Aug 2021 02:45:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=ZoExr4s0DzsdIP7b3nHIgMomiRci/zO9PFPWjsVToZo=;
        b=o0VDM5Qet1hQLq/zelBsjLII5obgXwe05GKzLjBirw/GLF32Xb7eANRH45wDB293a9
         ZTLxmVY2Yn5bKPcUin03aF4zMejd+EA6mI6c9Uezv+2tjdS7XrH/3sbHc7FidfSDOf80
         BzLI7dt7zXNhPfIx26qeSdxGPlp01vc7HuoYshJ3TmcRUSOOhTIr2h1YSjxn4lnnGtIX
         7Oujux/kICGighopJB7MShtiR64CRKoFHc1eK7IJbTu19am/es/TTWC+DW6KyEDo2D7T
         3H3IFqzSh4H+Qr6vtq7JGhEZAGv1rksDKYl3ehe/6VYkPmsdAwrA8Pz2y5r2COXSrE77
         PsxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=ZoExr4s0DzsdIP7b3nHIgMomiRci/zO9PFPWjsVToZo=;
        b=e2FUYg9E8ivwtXVaEkWwPWJPAFYj6+pcwD1eaYXk1DF6AwQ9ciK/JjkA6YCYEglSyI
         WGsV39w1V9TbEOnkvjbta70vXA+BJpZkIuyfPTLmkDNn0SgimJdgX/TIBZknZ7SHsOJF
         X5U03FDr89y6bcdeRv0n7kgQHXyRTwkU7E8eFg1TTxpTsj/MJK/fCLNxVUOhlHuDu12w
         xXa6e992pOe2BgogkHRtPoQPKnp7GS2ZgQh60xLKjg57X23fkNfaXvDWqH8SZN8cHkjF
         XSZzrBKQMADVTYZkEIzfGbZ7gHoOxVW+ikISdZM1ZQvf8aDHpcRfaca9P1V1hkkJXBYo
         XDlA==
X-Gm-Message-State: AOAM5321iuJdxwexjqOkUOz3ERZFd7xHCWAEfGHMkZLwQg81YknasDiK
        bxpk5CniQINaP8YOkCLL39k=
X-Google-Smtp-Source: ABdhPJzzoPnS77HwdArYaa77kxGaKuJ342J9rk25NkhzCLswfRIYAgPl3geFeywMTVSV09ij1H+7dg==
X-Received: by 2002:a17:902:850a:b029:12c:8da9:8bd2 with SMTP id bj10-20020a170902850ab029012c8da98bd2mr1410432plb.58.1628588751632;
        Tue, 10 Aug 2021 02:45:51 -0700 (PDT)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:1d32:5dbb:6288:4f01])
        by smtp.gmail.com with ESMTPSA id f15sm21571044pjt.3.2021.08.10.02.45.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Aug 2021 02:45:51 -0700 (PDT)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        syzbot <syzkaller@googlegroups.com>
Subject: [PATCH net] net: igmp: fix data-race in igmp_ifc_timer_expire()
Date:   Tue, 10 Aug 2021 02:45:47 -0700
Message-Id: <20210810094547.1851947-1-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.32.0.605.g8dce9f2422-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

Fix the data-race reported by syzbot [1]
Issue here is that igmp_ifc_timer_expire() can update in_dev->mr_ifc_count
while another change just occured from another context.

in_dev->mr_ifc_count is only 8bit wide, so the race had little
consequences.

[1]
BUG: KCSAN: data-race in igmp_ifc_event / igmp_ifc_timer_expire

write to 0xffff8881051e3062 of 1 bytes by task 12547 on cpu 0:
 igmp_ifc_event+0x1d5/0x290 net/ipv4/igmp.c:821
 igmp_group_added+0x462/0x490 net/ipv4/igmp.c:1356
 ____ip_mc_inc_group+0x3ff/0x500 net/ipv4/igmp.c:1461
 __ip_mc_join_group+0x24d/0x2c0 net/ipv4/igmp.c:2199
 ip_mc_join_group_ssm+0x20/0x30 net/ipv4/igmp.c:2218
 do_ip_setsockopt net/ipv4/ip_sockglue.c:1285 [inline]
 ip_setsockopt+0x1827/0x2a80 net/ipv4/ip_sockglue.c:1423
 tcp_setsockopt+0x8c/0xa0 net/ipv4/tcp.c:3657
 sock_common_setsockopt+0x5d/0x70 net/core/sock.c:3362
 __sys_setsockopt+0x18f/0x200 net/socket.c:2159
 __do_sys_setsockopt net/socket.c:2170 [inline]
 __se_sys_setsockopt net/socket.c:2167 [inline]
 __x64_sys_setsockopt+0x62/0x70 net/socket.c:2167
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x3d/0x90 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x44/0xae

read to 0xffff8881051e3062 of 1 bytes by interrupt on cpu 1:
 igmp_ifc_timer_expire+0x706/0xa30 net/ipv4/igmp.c:808
 call_timer_fn+0x2e/0x1d0 kernel/time/timer.c:1419
 expire_timers+0x135/0x250 kernel/time/timer.c:1464
 __run_timers+0x358/0x420 kernel/time/timer.c:1732
 run_timer_softirq+0x19/0x30 kernel/time/timer.c:1745
 __do_softirq+0x12c/0x26e kernel/softirq.c:558
 invoke_softirq kernel/softirq.c:432 [inline]
 __irq_exit_rcu+0x9a/0xb0 kernel/softirq.c:636
 sysvec_apic_timer_interrupt+0x69/0x80 arch/x86/kernel/apic/apic.c:1100
 asm_sysvec_apic_timer_interrupt+0x12/0x20 arch/x86/include/asm/idtentry.h:638
 console_unlock+0x8e8/0xb30 kernel/printk/printk.c:2646
 vprintk_emit+0x125/0x3d0 kernel/printk/printk.c:2174
 vprintk_default+0x22/0x30 kernel/printk/printk.c:2185
 vprintk+0x15a/0x170 kernel/printk/printk_safe.c:392
 printk+0x62/0x87 kernel/printk/printk.c:2216
 selinux_netlink_send+0x399/0x400 security/selinux/hooks.c:6041
 security_netlink_send+0x42/0x90 security/security.c:2070
 netlink_sendmsg+0x59e/0x7c0 net/netlink/af_netlink.c:1919
 sock_sendmsg_nosec net/socket.c:703 [inline]
 sock_sendmsg net/socket.c:723 [inline]
 ____sys_sendmsg+0x360/0x4d0 net/socket.c:2392
 ___sys_sendmsg net/socket.c:2446 [inline]
 __sys_sendmsg+0x1ed/0x270 net/socket.c:2475
 __do_sys_sendmsg net/socket.c:2484 [inline]
 __se_sys_sendmsg net/socket.c:2482 [inline]
 __x64_sys_sendmsg+0x42/0x50 net/socket.c:2482
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x3d/0x90 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x44/0xae

value changed: 0x01 -> 0x02

Reported by Kernel Concurrency Sanitizer on:
CPU: 1 PID: 12539 Comm: syz-executor.1 Not tainted 5.14.0-rc4-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Reported-by: syzbot <syzkaller@googlegroups.com>
---
 net/ipv4/igmp.c | 21 ++++++++++++++-------
 1 file changed, 14 insertions(+), 7 deletions(-)

diff --git a/net/ipv4/igmp.c b/net/ipv4/igmp.c
index 6b3c558a4f232652b97a078d48f302864e60a866..a51360087b19845a28408c827032e08dabf99838 100644
--- a/net/ipv4/igmp.c
+++ b/net/ipv4/igmp.c
@@ -803,10 +803,17 @@ static void igmp_gq_timer_expire(struct timer_list *t)
 static void igmp_ifc_timer_expire(struct timer_list *t)
 {
 	struct in_device *in_dev = from_timer(in_dev, t, mr_ifc_timer);
+	u8 mr_ifc_count;
 
 	igmpv3_send_cr(in_dev);
-	if (in_dev->mr_ifc_count) {
-		in_dev->mr_ifc_count--;
+restart:
+	mr_ifc_count = READ_ONCE(in_dev->mr_ifc_count);
+
+	if (mr_ifc_count) {
+		if (cmpxchg(&in_dev->mr_ifc_count,
+			    mr_ifc_count,
+			    mr_ifc_count - 1) != mr_ifc_count)
+			goto restart;
 		igmp_ifc_start_timer(in_dev,
 				     unsolicited_report_interval(in_dev));
 	}
@@ -818,7 +825,7 @@ static void igmp_ifc_event(struct in_device *in_dev)
 	struct net *net = dev_net(in_dev->dev);
 	if (IGMP_V1_SEEN(in_dev) || IGMP_V2_SEEN(in_dev))
 		return;
-	in_dev->mr_ifc_count = in_dev->mr_qrv ?: net->ipv4.sysctl_igmp_qrv;
+	WRITE_ONCE(in_dev->mr_ifc_count, in_dev->mr_qrv ?: net->ipv4.sysctl_igmp_qrv);
 	igmp_ifc_start_timer(in_dev, 1);
 }
 
@@ -957,7 +964,7 @@ static bool igmp_heard_query(struct in_device *in_dev, struct sk_buff *skb,
 				in_dev->mr_qri;
 		}
 		/* cancel the interface change timer */
-		in_dev->mr_ifc_count = 0;
+		WRITE_ONCE(in_dev->mr_ifc_count, 0);
 		if (del_timer(&in_dev->mr_ifc_timer))
 			__in_dev_put(in_dev);
 		/* clear deleted report items */
@@ -1724,7 +1731,7 @@ void ip_mc_down(struct in_device *in_dev)
 		igmp_group_dropped(pmc);
 
 #ifdef CONFIG_IP_MULTICAST
-	in_dev->mr_ifc_count = 0;
+	WRITE_ONCE(in_dev->mr_ifc_count, 0);
 	if (del_timer(&in_dev->mr_ifc_timer))
 		__in_dev_put(in_dev);
 	in_dev->mr_gq_running = 0;
@@ -1941,7 +1948,7 @@ static int ip_mc_del_src(struct in_device *in_dev, __be32 *pmca, int sfmode,
 		pmc->sfmode = MCAST_INCLUDE;
 #ifdef CONFIG_IP_MULTICAST
 		pmc->crcount = in_dev->mr_qrv ?: net->ipv4.sysctl_igmp_qrv;
-		in_dev->mr_ifc_count = pmc->crcount;
+		WRITE_ONCE(in_dev->mr_ifc_count, pmc->crcount);
 		for (psf = pmc->sources; psf; psf = psf->sf_next)
 			psf->sf_crcount = 0;
 		igmp_ifc_event(pmc->interface);
@@ -2120,7 +2127,7 @@ static int ip_mc_add_src(struct in_device *in_dev, __be32 *pmca, int sfmode,
 		/* else no filters; keep old mode for reports */
 
 		pmc->crcount = in_dev->mr_qrv ?: net->ipv4.sysctl_igmp_qrv;
-		in_dev->mr_ifc_count = pmc->crcount;
+		WRITE_ONCE(in_dev->mr_ifc_count, pmc->crcount);
 		for (psf = pmc->sources; psf; psf = psf->sf_next)
 			psf->sf_crcount = 0;
 		igmp_ifc_event(in_dev);
-- 
2.32.0.605.g8dce9f2422-goog

