Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2854755C4C3
	for <lists+netdev@lfdr.de>; Tue, 28 Jun 2022 14:50:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345624AbiF1MMv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jun 2022 08:12:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43086 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345413AbiF1MMv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Jun 2022 08:12:51 -0400
Received: from mail-yw1-x114a.google.com (mail-yw1-x114a.google.com [IPv6:2607:f8b0:4864:20::114a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4FB7035866
        for <netdev@vger.kernel.org>; Tue, 28 Jun 2022 05:12:50 -0700 (PDT)
Received: by mail-yw1-x114a.google.com with SMTP id 00721157ae682-317ae1236feso100980567b3.11
        for <netdev@vger.kernel.org>; Tue, 28 Jun 2022 05:12:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=d7231hMu7KJHbAI4t+zhdhY7L5Sftvut0xUVuh9aNvM=;
        b=gdvvDjOkW4JDa27CHi2yZ3TQrGhDQnXJlvU5VmAaStzXH584DGagcbr8M7HJb2EpZP
         Fpxj5M+pjrPA78Inhj5ODNCfEpASa377IhRQXoYCyTpGEabwVCfynRvf/uE54HlJ98hL
         8VB/yDZUBztb1eIO6vIcEr/XQiDsd2Kyap2ScSGBhxjvgJvuv6kckvsJlo6wQaHtrWwl
         ksVdWSFq6pTWbDn0Lkz2EIjSY/eQLi6AqBayXYnYI1TVCsK/fcIdLkJjVPa63P0NDkUk
         Hl60pgKDohSMy3RDP2y5FvFFdxZa2S2eFzoKW/33DoBAuHErylFpd0P6I04ScUgWvqRG
         pTyg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=d7231hMu7KJHbAI4t+zhdhY7L5Sftvut0xUVuh9aNvM=;
        b=ZJ16eGbEPm+Wm/Z5ysC+/1lh0h4nf44K8jNA4g92d+XqFBMmqQallv6ugnrW1W8MIX
         /LjVX/AHH1Hf1xJZTKqgpIuiiSivlAFaBH6+oFAkzeGpGhf5Y8RB/MdmWX9KdpulME//
         IwEF0XQtBybZ++YHTo/BvHeMXFGHTIrZEzAzRYrt1+VThAo7t7VBmYzhFef++qAUaz3T
         BJe32suw/Ur1ZGPXhNH+Z/slF+iks31gNTE6w5FelG/YZfYJW5rQZnA9yUQkRrXGdfOp
         3T9hDh2CwWILCgKB29yiTXXVgH/wOguh0oejcIKbPBtK3tPaAZZj3ItQw6D51WzExTBS
         mIhw==
X-Gm-Message-State: AJIora+c7M9mVp/3oMRM3q1mvytnOaIYpXvSd+Zd5c5b4o9h++0zZJ9R
        +NjN2NfiGmwTyLGURurBPr1ZDTklbzL1oQ==
X-Google-Smtp-Source: AGRyM1uisLvCCOE5+yMfgAwNPHbNqX9F+LjLbrX8kZ3MXYKr1JXatYQLt3D0O75hmUkKAWjqFhmT7TeF5JDguw==
X-Received: from edumazet1.c.googlers.com ([fda3:e722:ac3:cc00:2b:7d90:c0a8:395a])
 (user=edumazet job=sendgmr) by 2002:a25:28a:0:b0:66c:8fc0:27f7 with SMTP id
 132-20020a25028a000000b0066c8fc027f7mr16400619ybc.312.1656418369600; Tue, 28
 Jun 2022 05:12:49 -0700 (PDT)
Date:   Tue, 28 Jun 2022 12:12:48 +0000
Message-Id: <20220628121248.858695-1-edumazet@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.37.0.rc0.161.g10f37bed90-goog
Subject: [PATCH] ipv6: fix lockdep splat in in6_dump_addrs()
From:   Eric Dumazet <edumazet@google.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev@vger.kernel.org, eric.dumazet@gmail.com,
        Eric Dumazet <edumazet@google.com>,
        syzbot <syzkaller@googlegroups.com>,
        Taehee Yoo <ap420073@gmail.com>
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

As reported by syzbot, we should not use rcu_dereference()
when rcu_read_lock() is not held.

WARNING: suspicious RCU usage
5.19.0-rc2-syzkaller #0 Not tainted

net/ipv6/addrconf.c:5175 suspicious rcu_dereference_check() usage!

other info that might help us debug this:

rcu_scheduler_active = 2, debug_locks = 1
1 lock held by syz-executor326/3617:
 #0: ffffffff8d5848e8 (rtnl_mutex){+.+.}-{3:3}, at: netlink_dump+0xae/0xc20 net/netlink/af_netlink.c:2223

stack backtrace:
CPU: 0 PID: 3617 Comm: syz-executor326 Not tainted 5.19.0-rc2-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 <TASK>
 __dump_stack lib/dump_stack.c:88 [inline]
 dump_stack_lvl+0xcd/0x134 lib/dump_stack.c:106
 in6_dump_addrs+0x12d1/0x1790 net/ipv6/addrconf.c:5175
 inet6_dump_addr+0x9c1/0xb50 net/ipv6/addrconf.c:5300
 netlink_dump+0x541/0xc20 net/netlink/af_netlink.c:2275
 __netlink_dump_start+0x647/0x900 net/netlink/af_netlink.c:2380
 netlink_dump_start include/linux/netlink.h:245 [inline]
 rtnetlink_rcv_msg+0x73e/0xc90 net/core/rtnetlink.c:6046
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

Fixes: 88e2ca308094 ("mld: convert ifmcaddr6 to RCU")
Reported-by: syzbot <syzkaller@googlegroups.com>
Signed-off-by: Eric Dumazet <edumazet@google.com>
Cc: Taehee Yoo <ap420073@gmail.com>
---
 net/ipv6/addrconf.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/ipv6/addrconf.c b/net/ipv6/addrconf.c
index 5864cbc30db69bc61483b2557fdc201e1a20f0a0..49cc6587dd771ac0bb17fbc31402785bcdd8ff18 100644
--- a/net/ipv6/addrconf.c
+++ b/net/ipv6/addrconf.c
@@ -5168,9 +5168,9 @@ static int in6_dump_addrs(struct inet6_dev *idev, struct sk_buff *skb,
 		fillargs->event = RTM_GETMULTICAST;
 
 		/* multicast address */
-		for (ifmca = rcu_dereference(idev->mc_list);
+		for (ifmca = rtnl_dereference(idev->mc_list);
 		     ifmca;
-		     ifmca = rcu_dereference(ifmca->next), ip_idx++) {
+		     ifmca = rtnl_dereference(ifmca->next), ip_idx++) {
 			if (ip_idx < s_ip_idx)
 				continue;
 			err = inet6_fill_ifmcaddr(skb, ifmca, fillargs);
-- 
2.37.0.rc0.161.g10f37bed90-goog

