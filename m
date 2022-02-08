Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 615CC4AD11E
	for <lists+netdev@lfdr.de>; Tue,  8 Feb 2022 06:39:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343551AbiBHFjI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Feb 2022 00:39:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44340 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242450AbiBHFij (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Feb 2022 00:38:39 -0500
Received: from mail-pl1-x631.google.com (mail-pl1-x631.google.com [IPv6:2607:f8b0:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E813C0045EC
        for <netdev@vger.kernel.org>; Mon,  7 Feb 2022 21:35:00 -0800 (PST)
Received: by mail-pl1-x631.google.com with SMTP id 10so5037367plj.1
        for <netdev@vger.kernel.org>; Mon, 07 Feb 2022 21:35:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=52vLvy/9Xreuv6iH3g1MZOFhc/L7BMG4RcZPViDE75I=;
        b=mDM5TLCGHK2eyAuPx54u2mLbZjDqBDb8/tphajhcRo3iSk5uR3FckiDjD0jpPuPuSZ
         AfxdTMbUz2FqcPcihOSoRXwbkKeBQcyodgPoKwfzbFSsDsGTNQB6V+6fT3iZtse3nPhQ
         0voTStO4IR9DEjltRhK7trGolrN4h3Som97WuHTzEtY0TGNzJzvoXsJsfQglcYviqxFB
         pA+9QYJSkad/2LNq7+lEdWtYpBGy1fGBI1uo2RToT9cl8h75f/Un/rKXi6ArcNBJkrZm
         aMzuOtTuejpKC5prACNk/x5+IxyjfJWwNEVQh4WHAizI033jPIZGwBysQJuv26drPknL
         jl2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=52vLvy/9Xreuv6iH3g1MZOFhc/L7BMG4RcZPViDE75I=;
        b=Qwm/Cj8BrXPWDE8NjpurVwjJow27pfi3B7YI7heygC0Rp1bEv4h6oXpV6wjyxRGJEc
         g1BHO+11OrcZpLXM+bwQO/XYFqdlVHRdWm6SBST2t0g+cDnZAHwvNiirYl6k5kBIZvjJ
         THEp9ru2VyeK7SAPSiP6Got6LjQOym04jj5i4FZux7ljWivNjjCaHOQ4uwXvWMZOvm5T
         M+kodsW0WldjJvXh0MR/4zEYwAMS6eVBJekxIgYDtypWOIkEHK9ljQM1E0SsJODisuIN
         fef1P22UBabnciZh/ATP0RdZO1Dc6WAi9/WAC4rlEPOAlucXFbNc/A7E4i6mQtUg3OiP
         XDYQ==
X-Gm-Message-State: AOAM531R81JtDPlZJBWIrx1Z17OlhCgwhBchiJKJMiTJF/4AY2UtetZS
        ek/ZgWsHpqnztWRf/rwXq7k=
X-Google-Smtp-Source: ABdhPJygxhnscZv/H+mFp2UfNmNR6bnNI9RRm7XCONuCJMDg7DZQktnvq6+iarjzWZdicraTlS6XSg==
X-Received: by 2002:a17:903:251:: with SMTP id j17mr2168545plh.2.1644298497595;
        Mon, 07 Feb 2022 21:34:57 -0800 (PST)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:8f56:515b:a442:2bd5])
        by smtp.gmail.com with ESMTPSA id mv17sm855496pjb.14.2022.02.07.21.34.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Feb 2022 21:34:57 -0800 (PST)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>, David Ahern <dsahern@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Cong Wang <cong.wang@bytedance.com>,
        syzbot <syzkaller@googlegroups.com>
Subject: [PATCH net] ipmr,ip6mr: acquire RTNL before calling ip[6]mr_free_table() on failure path
Date:   Mon,  7 Feb 2022 21:34:51 -0800
Message-Id: <20220208053451.2885398-1-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.35.0.263.gb82422642f-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

ip[6]mr_free_table() can only be called under RTNL lock.

RTNL: assertion failed at net/core/dev.c (10367)
WARNING: CPU: 1 PID: 5890 at net/core/dev.c:10367 unregister_netdevice_many+0x1246/0x1850 net/core/dev.c:10367
Modules linked in:
CPU: 1 PID: 5890 Comm: syz-executor.2 Not tainted 5.16.0-syzkaller-11627-g422ee58dc0ef #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
RIP: 0010:unregister_netdevice_many+0x1246/0x1850 net/core/dev.c:10367
Code: 0f 85 9b ee ff ff e8 69 07 4b fa ba 7f 28 00 00 48 c7 c6 00 90 ae 8a 48 c7 c7 40 90 ae 8a c6 05 6d b1 51 06 01 e8 8c 90 d8 01 <0f> 0b e9 70 ee ff ff e8 3e 07 4b fa 4c 89 e7 e8 86 2a 59 fa e9 ee
RSP: 0018:ffffc900046ff6e0 EFLAGS: 00010286
RAX: 0000000000000000 RBX: 0000000000000000 RCX: 0000000000000000
RDX: ffff888050f51d00 RSI: ffffffff815fa008 RDI: fffff520008dfece
RBP: 0000000000000000 R08: 0000000000000000 R09: 0000000000000000
R10: ffffffff815f3d6e R11: 0000000000000000 R12: 00000000fffffff4
R13: dffffc0000000000 R14: ffffc900046ff750 R15: ffff88807b7dc000
FS:  00007f4ab736e700(0000) GS:ffff8880b9d00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007fee0b4f8990 CR3: 000000001e7d2000 CR4: 00000000003506e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 <TASK>
 mroute_clean_tables+0x244/0xb40 net/ipv6/ip6mr.c:1509
 ip6mr_free_table net/ipv6/ip6mr.c:389 [inline]
 ip6mr_rules_init net/ipv6/ip6mr.c:246 [inline]
 ip6mr_net_init net/ipv6/ip6mr.c:1306 [inline]
 ip6mr_net_init+0x3f0/0x4e0 net/ipv6/ip6mr.c:1298
 ops_init+0xaf/0x470 net/core/net_namespace.c:140
 setup_net+0x54f/0xbb0 net/core/net_namespace.c:331
 copy_net_ns+0x318/0x760 net/core/net_namespace.c:475
 create_new_namespaces+0x3f6/0xb20 kernel/nsproxy.c:110
 copy_namespaces+0x391/0x450 kernel/nsproxy.c:178
 copy_process+0x2e0c/0x7300 kernel/fork.c:2167
 kernel_clone+0xe7/0xab0 kernel/fork.c:2555
 __do_sys_clone+0xc8/0x110 kernel/fork.c:2672
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x44/0xae
RIP: 0033:0x7f4ab89f9059
Code: Unable to access opcode bytes at RIP 0x7f4ab89f902f.
RSP: 002b:00007f4ab736e118 EFLAGS: 00000206 ORIG_RAX: 0000000000000038
RAX: ffffffffffffffda RBX: 00007f4ab8b0bf60 RCX: 00007f4ab89f9059
RDX: 0000000020000280 RSI: 0000000020000270 RDI: 0000000040200000
RBP: 00007f4ab8a5308d R08: 0000000020000300 R09: 0000000020000300
R10: 00000000200002c0 R11: 0000000000000206 R12: 0000000000000000
R13: 00007ffc3977cc1f R14: 00007f4ab736e300 R15: 0000000000022000
 </TASK>

Fixes: f243e5a7859a ("ipmr,ip6mr: call ip6mr_free_table() on failure path")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Cc: Cong Wang <cong.wang@bytedance.com>
Reported-by: syzbot <syzkaller@googlegroups.com>
---
 net/ipv4/ipmr.c  | 2 ++
 net/ipv6/ip6mr.c | 2 ++
 2 files changed, 4 insertions(+)

diff --git a/net/ipv4/ipmr.c b/net/ipv4/ipmr.c
index 07274619b9ea11837501f8fe812d616d20573ee0..29bbe2b08ae970e5accd7e1b01bcd5f502a66810 100644
--- a/net/ipv4/ipmr.c
+++ b/net/ipv4/ipmr.c
@@ -256,7 +256,9 @@ static int __net_init ipmr_rules_init(struct net *net)
 	return 0;
 
 err2:
+	rtnl_lock();
 	ipmr_free_table(mrt);
+	rtnl_unlock();
 err1:
 	fib_rules_unregister(ops);
 	return err;
diff --git a/net/ipv6/ip6mr.c b/net/ipv6/ip6mr.c
index 7cf73e60e619ba92ea1eccc90c181ba7150225dd..8a2db926b5eb6ab2e08691ad7244c504611540e6 100644
--- a/net/ipv6/ip6mr.c
+++ b/net/ipv6/ip6mr.c
@@ -243,7 +243,9 @@ static int __net_init ip6mr_rules_init(struct net *net)
 	return 0;
 
 err2:
+	rtnl_lock();
 	ip6mr_free_table(mrt);
+	rtnl_unlock();
 err1:
 	fib_rules_unregister(ops);
 	return err;
-- 
2.35.0.263.gb82422642f-goog

