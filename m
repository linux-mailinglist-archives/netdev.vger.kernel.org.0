Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7C8D53935DA
	for <lists+netdev@lfdr.de>; Thu, 27 May 2021 21:01:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229849AbhE0TDI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 May 2021 15:03:08 -0400
Received: from mail.netfilter.org ([217.70.188.207]:38850 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234169AbhE0TDA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 May 2021 15:03:00 -0400
Received: from localhost.localdomain (unknown [90.77.255.23])
        by mail.netfilter.org (Postfix) with ESMTPSA id ED20D6450A;
        Thu, 27 May 2021 21:00:22 +0200 (CEST)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org
Subject: [PATCH net 5/5] ipvs: ignore IP_VS_SVC_F_HASHED flag when adding service
Date:   Thu, 27 May 2021 21:01:15 +0200
Message-Id: <20210527190115.98503-6-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210527190115.98503-1-pablo@netfilter.org>
References: <20210527190115.98503-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Julian Anastasov <ja@ssi.bg>

syzbot reported memory leak [1] when adding service with
HASHED flag. We should ignore this flag both from sockopt
and netlink provided data, otherwise the service is not
hashed and not visible while releasing resources.

[1]
BUG: memory leak
unreferenced object 0xffff888115227800 (size 512):
  comm "syz-executor263", pid 8658, jiffies 4294951882 (age 12.560s)
  hex dump (first 32 bytes):
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace:
    [<ffffffff83977188>] kmalloc include/linux/slab.h:556 [inline]
    [<ffffffff83977188>] kzalloc include/linux/slab.h:686 [inline]
    [<ffffffff83977188>] ip_vs_add_service+0x598/0x7c0 net/netfilter/ipvs/ip_vs_ctl.c:1343
    [<ffffffff8397d770>] do_ip_vs_set_ctl+0x810/0xa40 net/netfilter/ipvs/ip_vs_ctl.c:2570
    [<ffffffff838449a8>] nf_setsockopt+0x68/0xa0 net/netfilter/nf_sockopt.c:101
    [<ffffffff839ae4e9>] ip_setsockopt+0x259/0x1ff0 net/ipv4/ip_sockglue.c:1435
    [<ffffffff839fa03c>] raw_setsockopt+0x18c/0x1b0 net/ipv4/raw.c:857
    [<ffffffff83691f20>] __sys_setsockopt+0x1b0/0x360 net/socket.c:2117
    [<ffffffff836920f2>] __do_sys_setsockopt net/socket.c:2128 [inline]
    [<ffffffff836920f2>] __se_sys_setsockopt net/socket.c:2125 [inline]
    [<ffffffff836920f2>] __x64_sys_setsockopt+0x22/0x30 net/socket.c:2125
    [<ffffffff84350efa>] do_syscall_64+0x3a/0xb0 arch/x86/entry/common.c:47
    [<ffffffff84400068>] entry_SYSCALL_64_after_hwframe+0x44/0xae

Reported-and-tested-by: syzbot+e562383183e4b1766930@syzkaller.appspotmail.com
Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Julian Anastasov <ja@ssi.bg>
Reviewed-by: Simon Horman <horms@verge.net.au>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/ipvs/ip_vs_ctl.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/netfilter/ipvs/ip_vs_ctl.c b/net/netfilter/ipvs/ip_vs_ctl.c
index d45dbcba8b49..c25097092a06 100644
--- a/net/netfilter/ipvs/ip_vs_ctl.c
+++ b/net/netfilter/ipvs/ip_vs_ctl.c
@@ -1367,7 +1367,7 @@ ip_vs_add_service(struct netns_ipvs *ipvs, struct ip_vs_service_user_kern *u,
 	ip_vs_addr_copy(svc->af, &svc->addr, &u->addr);
 	svc->port = u->port;
 	svc->fwmark = u->fwmark;
-	svc->flags = u->flags;
+	svc->flags = u->flags & ~IP_VS_SVC_F_HASHED;
 	svc->timeout = u->timeout * HZ;
 	svc->netmask = u->netmask;
 	svc->ipvs = ipvs;
-- 
2.30.2

