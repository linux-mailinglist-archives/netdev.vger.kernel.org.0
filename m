Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5792D55E25B
	for <lists+netdev@lfdr.de>; Tue, 28 Jun 2022 15:35:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233786AbiF0K2S (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Jun 2022 06:28:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36316 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229531AbiF0K2R (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Jun 2022 06:28:17 -0400
Received: from mail-yw1-x114a.google.com (mail-yw1-x114a.google.com [IPv6:2607:f8b0:4864:20::114a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C1032D5C
        for <netdev@vger.kernel.org>; Mon, 27 Jun 2022 03:28:16 -0700 (PDT)
Received: by mail-yw1-x114a.google.com with SMTP id 00721157ae682-31838c41186so75025357b3.23
        for <netdev@vger.kernel.org>; Mon, 27 Jun 2022 03:28:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=MbVn4mLGeppuzV1Rbz7OWevtPpZKJbcrmkqSi9xTgLw=;
        b=ElwOhyw5YwWdlU+CU54NPnN2SBrnttWx5FocaxvD67ndt4jHysZ8WBqPbd/SFgzkKi
         ondXZM4EXewEfySzALaDVlNtVp/ToVAOChtsDDjUzUBH3756mBedLlNzrnexlXqR73mO
         +TWsPpdHBp5QIxc5H6uQ/otx6utFfZjEfGSN6qmWT5zL2oiQwBoIgjjHSAcFDvKPqSXB
         SUvTNNorOlQKAJhqaV1JfmndBNBBpaMVeRBVMDdglx/tBe/oj1dqnv0A2+CN9av7K9v2
         z72l9b4brDe/qa9PqntAmAV8Z78QdMC8i4wO06yIOH4wVePKwsmG9S/Xl5TVOApv9j6J
         RPkQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=MbVn4mLGeppuzV1Rbz7OWevtPpZKJbcrmkqSi9xTgLw=;
        b=gL4Y1c2lwdeVto5KmVidAbqiTkXN6K6ADJkbKBGf3mntRCf/HJhxUV5ndSWhnjMoup
         F6Z5UqGoH8favCOnkczu6fynb99BdC6S/GvicTlMfG+6Mpx7rU2JkmY3ntZgaNw3YLIf
         hpbgHy9zrA6e0k+XsAvq/RK7Gi0jo1Uqd6nMzGgKqGRrhVIv4Hen+QrzeiaSFZMswEej
         ReVcFqEZTfqiEU+aja8BoQu3CJkDssrMFaNeQC3sCYZI1QY4z2JZ09v98Zap1KFP2DUH
         ofjLO44kJTrBNpkSkmzoS0puzUX0X+9JTC7oI+b8ZkS7Mftwzv3wJj6tKVdu0LddbGVy
         qqlw==
X-Gm-Message-State: AJIora8CHR3CZmjxOuGJUL6ERBc/S6eDd8zMA1FdE0W4Yq8B+Io68whY
        7aNXxomZ6ErNPtB1Z2V0bkPCZ91HwctzyQ==
X-Google-Smtp-Source: AGRyM1tSXwhREZvZ9xJU1yX12InYH7TP/8vSSeDErUEQz5EGJtfWr8uwxflj5jotMfKf8gw73R6DoFaiBGe9ZA==
X-Received: from edumazet1.c.googlers.com ([fda3:e722:ac3:cc00:2b:7d90:c0a8:395a])
 (user=edumazet job=sendgmr) by 2002:a81:4ac6:0:b0:31b:b4b0:89d2 with SMTP id
 x189-20020a814ac6000000b0031bb4b089d2mr6193422ywa.66.1656325696088; Mon, 27
 Jun 2022 03:28:16 -0700 (PDT)
Date:   Mon, 27 Jun 2022 10:28:13 +0000
Message-Id: <20220627102813.126264-1-edumazet@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.37.0.rc0.161.g10f37bed90-goog
Subject: [PATCH net] net: bonding: fix possible NULL deref in rlb code
From:   Eric Dumazet <edumazet@google.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev@vger.kernel.org, eric.dumazet@gmail.com,
        Eric Dumazet <edumazet@google.com>,
        syzbot <syzkaller@googlegroups.com>,
        Jay Vosburgh <j.vosburgh@gmail.com>,
        Veaceslav Falico <vfalico@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

syzbot has two reports involving the same root cause.

bond_alb_initialize() must not set bond->alb_info.rlb_enabled
if a memory allocation error is detected.

Report 1:

general protection fault, probably for non-canonical address 0xdffffc0000000002: 0000 [#1] PREEMPT SMP KASAN
KASAN: null-ptr-deref in range [0x0000000000000010-0x0000000000000017]
CPU: 0 PID: 12276 Comm: kworker/u4:10 Not tainted 5.19.0-rc3-syzkaller-00132-g3b89b511ea0c #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Workqueue: netns cleanup_net
RIP: 0010:rlb_clear_slave+0x10e/0x690 drivers/net/bonding/bond_alb.c:393
Code: 8e fc 83 fb ff 0f 84 74 02 00 00 e8 cc 2a 8e fc 48 8b 44 24 08 89 dd 48 c1 e5 06 4c 8d 34 28 49 8d 7e 14 48 89 f8 48 c1 e8 03 <42> 0f b6 14 20 48 89 f8 83 e0 07 83 c0 03 38 d0 7c 08 84 d2 0f 85
RSP: 0018:ffffc90018a8f678 EFLAGS: 00010203
RAX: 0000000000000002 RBX: 0000000000000000 RCX: 0000000000000000
RDX: ffff88803375bb00 RSI: ffffffff84ec4ac4 RDI: 0000000000000014
RBP: 0000000000000000 R08: 0000000000000005 R09: 00000000ffffffff
R10: 0000000000000000 R11: 0000000000000000 R12: dffffc0000000000
R13: ffff8880ac889000 R14: 0000000000000000 R15: ffff88815a668c80
FS: 0000000000000000(0000) GS:ffff8880b9a00000(0000) knlGS:0000000000000000
CS: 0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00005597077e10b0 CR3: 0000000026668000 CR4: 00000000003506f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
<TASK>
bond_alb_deinit_slave+0x43c/0x6b0 drivers/net/bonding/bond_alb.c:1663
__bond_release_one.cold+0x383/0xd53 drivers/net/bonding/bond_main.c:2370
bond_slave_netdev_event drivers/net/bonding/bond_main.c:3778 [inline]
bond_netdev_event+0x993/0xad0 drivers/net/bonding/bond_main.c:3889
notifier_call_chain+0xb5/0x200 kernel/notifier.c:87
call_netdevice_notifiers_info+0xb5/0x130 net/core/dev.c:1945
call_netdevice_notifiers_extack net/core/dev.c:1983 [inline]
call_netdevice_notifiers net/core/dev.c:1997 [inline]
unregister_netdevice_many+0x948/0x18b0 net/core/dev.c:10839
default_device_exit_batch+0x449/0x590 net/core/dev.c:11333
ops_exit_list+0x125/0x170 net/core/net_namespace.c:167
cleanup_net+0x4ea/0xb00 net/core/net_namespace.c:594
process_one_work+0x996/0x1610 kernel/workqueue.c:2289
worker_thread+0x665/0x1080 kernel/workqueue.c:2436
kthread+0x2e9/0x3a0 kernel/kthread.c:376
ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:302
</TASK>

Report 2:

general protection fault, probably for non-canonical address 0xdffffc0000000006: 0000 [#1] PREEMPT SMP KASAN
KASAN: null-ptr-deref in range [0x0000000000000030-0x0000000000000037]
CPU: 1 PID: 5206 Comm: syz-executor.1 Not tainted 5.18.0-syzkaller-12108-g58f9d52ff689 #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
RIP: 0010:rlb_req_update_slave_clients+0x109/0x2f0 drivers/net/bonding/bond_alb.c:502
Code: 5d 18 8f fc 41 80 3e 00 0f 85 a5 01 00 00 89 d8 48 c1 e0 06 49 03 84 24 68 01 00 00 48 8d 78 30 49 89 c7 48 89 fa 48 c1 ea 03 <80> 3c 2a 00 0f 85 98 01 00 00 4d 39 6f 30 75 83 e8 22 18 8f fc 49
RSP: 0018:ffffc9000300ee80 EFLAGS: 00010206
RAX: 0000000000000000 RBX: 0000000000000000 RCX: ffffc90016c11000
RDX: 0000000000000006 RSI: ffffffff84eb6bf3 RDI: 0000000000000030
RBP: dffffc0000000000 R08: 0000000000000005 R09: 00000000ffffffff
R10: 0000000000000000 R11: 0000000000000000 R12: ffff888027c80c80
R13: ffff88807d7ff800 R14: ffffed1004f901bd R15: 0000000000000000
FS:  00007f6f46c58700(0000) GS:ffff8880b9b00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000020010000 CR3: 00000000516cc000 CR4: 00000000003506e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 <TASK>
 alb_fasten_mac_swap+0x886/0xa80 drivers/net/bonding/bond_alb.c:1070
 bond_alb_handle_active_change+0x624/0x1050 drivers/net/bonding/bond_alb.c:1765
 bond_change_active_slave+0xfa1/0x29b0 drivers/net/bonding/bond_main.c:1173
 bond_select_active_slave+0x23f/0xa50 drivers/net/bonding/bond_main.c:1253
 bond_enslave+0x3b34/0x53b0 drivers/net/bonding/bond_main.c:2159
 do_set_master+0x1c8/0x220 net/core/rtnetlink.c:2577
 rtnl_newlink_create net/core/rtnetlink.c:3380 [inline]
 __rtnl_newlink+0x13ac/0x17e0 net/core/rtnetlink.c:3580
 rtnl_newlink+0x64/0xa0 net/core/rtnetlink.c:3593
 rtnetlink_rcv_msg+0x43a/0xc90 net/core/rtnetlink.c:6089
 netlink_rcv_skb+0x153/0x420 net/netlink/af_netlink.c:2501
 netlink_unicast_kernel net/netlink/af_netlink.c:1319 [inline]
 netlink_unicast+0x543/0x7f0 net/netlink/af_netlink.c:1345
 netlink_sendmsg+0x917/0xe10 net/netlink/af_netlink.c:1921
 sock_sendmsg_nosec net/socket.c:714 [inline]
 sock_sendmsg+0xcf/0x120 net/socket.c:734
 ____sys_sendmsg+0x6eb/0x810 net/socket.c:2492
 ___sys_sendmsg+0xf3/0x170 net/socket.c:2546
 __sys_sendmsg net/socket.c:2575 [inline]
 __do_sys_sendmsg net/socket.c:2584 [inline]
 __se_sys_sendmsg net/socket.c:2582 [inline]
 __x64_sys_sendmsg+0x132/0x220 net/socket.c:2582
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x46/0xb0
RIP: 0033:0x7f6f45a89109
Code: ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 b8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007f6f46c58168 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
RAX: ffffffffffffffda RBX: 00007f6f45b9c030 RCX: 00007f6f45a89109
RDX: 0000000000000000 RSI: 0000000020000080 RDI: 0000000000000006
RBP: 00007f6f45ae308d R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 00007ffed99029af R14: 00007f6f46c58300 R15: 0000000000022000
 </TASK>

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Reported-by: syzbot <syzkaller@googlegroups.com>
Signed-off-by: Eric Dumazet <edumazet@google.com>
Cc: Jay Vosburgh <j.vosburgh@gmail.com>
Cc: Veaceslav Falico <vfalico@gmail.com>
Cc: Andy Gospodarek <andy@greyhouse.net>
---
 drivers/net/bonding/bond_alb.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/bonding/bond_alb.c b/drivers/net/bonding/bond_alb.c
index 303c8d32d451e24345222ec105a1986d53a94eb4..007d43e46dcb0cb1cee1f23623bd161a6c32a45c 100644
--- a/drivers/net/bonding/bond_alb.c
+++ b/drivers/net/bonding/bond_alb.c
@@ -1302,12 +1302,12 @@ int bond_alb_initialize(struct bonding *bond, int rlb_enabled)
 		return res;
 
 	if (rlb_enabled) {
-		bond->alb_info.rlb_enabled = 1;
 		res = rlb_initialize(bond);
 		if (res) {
 			tlb_deinitialize(bond);
 			return res;
 		}
+		bond->alb_info.rlb_enabled = 1;
 	} else {
 		bond->alb_info.rlb_enabled = 0;
 	}
-- 
2.37.0.rc0.161.g10f37bed90-goog

