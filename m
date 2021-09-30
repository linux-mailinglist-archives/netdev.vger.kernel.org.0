Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 749F441E349
	for <lists+netdev@lfdr.de>; Thu, 30 Sep 2021 23:22:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349642AbhI3VY1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Sep 2021 17:24:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47340 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344091AbhI3VY0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Sep 2021 17:24:26 -0400
Received: from mail-pg1-x533.google.com (mail-pg1-x533.google.com [IPv6:2607:f8b0:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A34EC06176A
        for <netdev@vger.kernel.org>; Thu, 30 Sep 2021 14:22:44 -0700 (PDT)
Received: by mail-pg1-x533.google.com with SMTP id 66so7101054pgc.9
        for <netdev@vger.kernel.org>; Thu, 30 Sep 2021 14:22:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=ef1S8P9SYHQi0VpWqC/16AQLOhghzhbK5pp2Nc+43C4=;
        b=BbU0y5Qu9orLNsYIEPm6zncOPJnW0a8EWp2ut5FEveBmdtQ3RgFsAnijTcD0eRrLda
         HeAAygh+oBfRhQ0vnBHRTUlAq5ex2K/Wfuw5ZZ7dF03LOBIBgsk7e9NgAyWStYjXDIb9
         VTb8KHCxp9+E3uv8uQ0fqu892sVjfbtJh2bgxEjnsaStw4YAgUwws2zjJUObK7fxC21k
         UsxJ/Ck7xcwKNI/OBLGTZSV9+n7HqBTWtklY0SEtItMXow690yJiza69yTnZ5hEr5wM0
         0R1V+N95wM5tmUaHTwnhbzWLcliQSXv8MzdiQhPdoq8Mly7XUH7xxmnyUXJs/3G16p0e
         yCyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=ef1S8P9SYHQi0VpWqC/16AQLOhghzhbK5pp2Nc+43C4=;
        b=NXggTGQAqCqUn+uYhyZtLV4LocqdTI1CV/tl4ZseITIgga0/DLNmuvDWftBZTCtztX
         TXKc0VCNLmDr+zynDNEgPeyWbhzAeUZ7eA0sg0X4Y7IF9YnJ9PxVGyQBusPzkDWw6Y4m
         AIVn2J7mbJwXegYpU285hrGn/F91iXbfPh4hFBnTRPVSA4FhULAQoWgzPMMAGwd0dvfa
         tTLdQ5q/5vI6eQ3TL2xUT5M8+nHl/prWArLsLx1jh+YsZcLeiGx2aqTrX516wB3y+owj
         n9mGpPOw38uGXcbHzzObJ0nEi6eY92E99mlQ+QxQItVSyiB8+BKki9quu7ObWjtkybLF
         ajRw==
X-Gm-Message-State: AOAM531kcCd/f7XLT5wU/KV5TG2LyogOCPY7KskNHf5XkPIXdqDhyCDH
        GkqQ6+pZSixyH6m7kLH8Yc4=
X-Google-Smtp-Source: ABdhPJxBFVn4rpdVTOGFiCnzwX6BT3ZWlF0ePKDO3vu6/KduJctOejC/XfketNoRkZ97t7Gunxo7Zw==
X-Received: by 2002:a05:6a00:c81:b029:30e:21bf:4c15 with SMTP id a1-20020a056a000c81b029030e21bf4c15mr6392861pfv.70.1633036963511;
        Thu, 30 Sep 2021 14:22:43 -0700 (PDT)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:b59b:abc0:171:fe0e])
        by smtp.gmail.com with ESMTPSA id v2sm3482604pje.15.2021.09.30.14.22.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 Sep 2021 14:22:43 -0700 (PDT)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        syzbot <syzkaller@googlegroups.com>
Subject: [PATCH net] net_sched: fix NULL deref in fifo_set_limit()
Date:   Thu, 30 Sep 2021 14:22:39 -0700
Message-Id: <20210930212239.3430364-1-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.33.0.800.g4c38ced690-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

syzbot reported another NULL deref in fifo_set_limit() [1]

I could repro the issue with :

unshare -n
tc qd add dev lo root handle 1:0 tbf limit 200000 burst 70000 rate 100Mbit
tc qd replace dev lo parent 1:0 pfifo_fast
tc qd change dev lo root handle 1:0 tbf limit 300000 burst 70000 rate 100Mbit

pfifo_fast does not have a change() operation.
Make fifo_set_limit() more robust about this.

[1]
BUG: kernel NULL pointer dereference, address: 0000000000000000
PGD 1cf99067 P4D 1cf99067 PUD 7ca49067 PMD 0
Oops: 0010 [#1] PREEMPT SMP KASAN
CPU: 1 PID: 14443 Comm: syz-executor959 Not tainted 5.15.0-rc3-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
RIP: 0010:0x0
Code: Unable to access opcode bytes at RIP 0xffffffffffffffd6.
RSP: 0018:ffffc9000e2f7310 EFLAGS: 00010246
RAX: dffffc0000000000 RBX: ffffffff8d6ecc00 RCX: 0000000000000000
RDX: 0000000000000000 RSI: ffff888024c27910 RDI: ffff888071e34000
RBP: ffff888071e34000 R08: 0000000000000001 R09: ffffffff8fcfb947
R10: 0000000000000001 R11: 0000000000000000 R12: ffff888024c27910
R13: ffff888071e34018 R14: 0000000000000000 R15: ffff88801ef74800
FS:  00007f321d897700(0000) GS:ffff8880b9d00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: ffffffffffffffd6 CR3: 00000000722c3000 CR4: 00000000003506e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 fifo_set_limit net/sched/sch_fifo.c:242 [inline]
 fifo_set_limit+0x198/0x210 net/sched/sch_fifo.c:227
 tbf_change+0x6ec/0x16d0 net/sched/sch_tbf.c:418
 qdisc_change net/sched/sch_api.c:1332 [inline]
 tc_modify_qdisc+0xd9a/0x1a60 net/sched/sch_api.c:1634
 rtnetlink_rcv_msg+0x413/0xb80 net/core/rtnetlink.c:5572
 netlink_rcv_skb+0x153/0x420 net/netlink/af_netlink.c:2504
 netlink_unicast_kernel net/netlink/af_netlink.c:1314 [inline]
 netlink_unicast+0x533/0x7d0 net/netlink/af_netlink.c:1340
 netlink_sendmsg+0x86d/0xdb0 net/netlink/af_netlink.c:1929
 sock_sendmsg_nosec net/socket.c:704 [inline]
 sock_sendmsg+0xcf/0x120 net/socket.c:724
 ____sys_sendmsg+0x6e8/0x810 net/socket.c:2409
 ___sys_sendmsg+0xf3/0x170 net/socket.c:2463
 __sys_sendmsg+0xe5/0x1b0 net/socket.c:2492
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x44/0xae

Fixes: fb0305ce1b03 ("net-sched: consolidate default fifo qdisc setup")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Reported-by: syzbot <syzkaller@googlegroups.com>
---
 net/sched/sch_fifo.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/sched/sch_fifo.c b/net/sched/sch_fifo.c
index a579a4131d22d771c9766f5ad6cdb16ece3034c0..e1040421b79797fefaa26b8d7d3f44b91896e1de 100644
--- a/net/sched/sch_fifo.c
+++ b/net/sched/sch_fifo.c
@@ -233,6 +233,9 @@ int fifo_set_limit(struct Qdisc *q, unsigned int limit)
 	if (strncmp(q->ops->id + 1, "fifo", 4) != 0)
 		return 0;
 
+	if (!q->ops->change)
+		return 0;
+
 	nla = kmalloc(nla_attr_size(sizeof(struct tc_fifo_qopt)), GFP_KERNEL);
 	if (nla) {
 		nla->nla_type = RTM_NEWQDISC;
-- 
2.33.0.800.g4c38ced690-goog

