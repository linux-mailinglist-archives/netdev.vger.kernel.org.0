Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E3E3D55A792
	for <lists+netdev@lfdr.de>; Sat, 25 Jun 2022 08:49:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232148AbiFYGr0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 25 Jun 2022 02:47:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52152 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232147AbiFYGrZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 25 Jun 2022 02:47:25 -0400
Received: from mail-qv1-xf4a.google.com (mail-qv1-xf4a.google.com [IPv6:2607:f8b0:4864:20::f4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C4C2542EC2
        for <netdev@vger.kernel.org>; Fri, 24 Jun 2022 23:47:24 -0700 (PDT)
Received: by mail-qv1-xf4a.google.com with SMTP id g7-20020a0ce747000000b0047079ec462dso4619583qvn.20
        for <netdev@vger.kernel.org>; Fri, 24 Jun 2022 23:47:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=aFuw+d2nCSuOZd/mw7kDFnDj0ODQ6UgWqBH+ZbF/xX8=;
        b=aWm+kWpU74ZiccOT11I4BcLG4h+utI7VecLRNuPo8d1hdHY8kiFpnfqJi4wvMZ2TIv
         2I+rtPQEu5EU25q21smGniE6aX2Iu64vgRRiTCfDsK7CDbBhB16HuA3VzRskzN6+dE4o
         vM7B21SKkBVgEp/KV0p+qfZFT+JBa0qYt8nvPL/BgKNEegy5ucwCeVV63Evky09ZbnHn
         hOcyCkngMwoRDLoGu3ae6Xh3KkFCELiwOyLYaRykDWiWfiwMbQRRO+WLV5vXp8B2Tgu/
         aD14IuYOfxMSMR8SPyQiZbvIJWZ8E2OT4TP46Wo3+AZnr/FIbulBSfBgpxiWrgfGmqrV
         znlQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=aFuw+d2nCSuOZd/mw7kDFnDj0ODQ6UgWqBH+ZbF/xX8=;
        b=Dq5Qd+oKWHO5rK4GcZ0A0hVehzP9b+MHpQzDAYIIkAh1ybwY3B/YUKYrkOknHZVI/k
         UFLR3ZcRCATTCs42zgiFzzysH1JkQNFE5+B9F4on+Ty4ag1P1iNuQksTypimg5Vmk7xk
         ek9ujsfB39srccgE7K/PG+Yh7eTjqnwckwA91soG32ecfUmVUeA3+x1SoIW/1aX01/9u
         INeoRSf4FZJM2NJlD4c70RXkvKyl18s6MhNkxmgNm6W5EYGyjsBACwo9HgLcdPxPlXiL
         5uaU0RnfwUNlj8DxoNQYNX6Q1PBsvtzxWPKqQ8S88J0aGiShnNOya5K6jiBdsM5os5M1
         jMfw==
X-Gm-Message-State: AJIora/8U8xJNO/9CH1d0uzVySDsO7maVG7E6bEC1FkacJWBV1AFnGLD
        6tL2mcYjtUl/CfoqNx5ADeSxOp+OqXPzhQ==
X-Google-Smtp-Source: AGRyM1u/BOTj5k/UzH41LRm2PeSu5E0zY/0e/f1FF4aMyI6DPS2Puht+NSSdDmttD1CqD+/2tE8pQ3v3Tyu23w==
X-Received: from edumazet1.c.googlers.com ([fda3:e722:ac3:cc00:2b:7d90:c0a8:395a])
 (user=edumazet job=sendgmr) by 2002:a05:620a:2411:b0:6a7:26bb:f9f8 with SMTP
 id d17-20020a05620a241100b006a726bbf9f8mr1903319qkn.197.1656139644010; Fri,
 24 Jun 2022 23:47:24 -0700 (PDT)
Date:   Sat, 25 Jun 2022 06:47:22 +0000
Message-Id: <20220625064722.3722045-1-edumazet@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.37.0.rc0.161.g10f37bed90-goog
Subject: [PATCH net-next] ipmr: fix a lockdep splat in ipmr_rtm_dumplink()
From:   Eric Dumazet <edumazet@google.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev@vger.kernel.org, eric.dumazet@gmail.com,
        Eric Dumazet <edumazet@google.com>,
        syzbot <syzkaller@googlegroups.com>
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

vif_dev_read() should be used from RCU protected sections only.

ipmr_rtm_dumplink() is holding RTNL, so the data structures
can not be changed.

syzbot reported:

net/ipv4/ipmr.c:84 suspicious rcu_dereference_check() usage!

other info that might help us debug this:

rcu_scheduler_active = 2, debug_locks = 1
1 lock held by syz-executor.4/3068:

stack backtrace:
CPU: 1 PID: 3068 Comm: syz-executor.4 Not tainted 5.19.0-rc3-syzkaller-00565-g5d04b0b634bb #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
<TASK>
__dump_stack lib/dump_stack.c:88 [inline]
dump_stack_lvl+0xcd/0x134 lib/dump_stack.c:106
vif_dev_read net/ipv4/ipmr.c:84 [inline]
vif_dev_read net/ipv4/ipmr.c:82 [inline]
ipmr_fill_vif net/ipv4/ipmr.c:2756 [inline]
ipmr_rtm_dumplink+0x1343/0x18c0 net/ipv4/ipmr.c:2866
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
____sys_sendmsg+0x334/0x810 net/socket.c:2489
___sys_sendmsg+0xf3/0x170 net/socket.c:2543
__sys_sendmmsg+0x195/0x470 net/socket.c:2629
__do_sys_sendmmsg net/socket.c:2658 [inline]
__se_sys_sendmmsg net/socket.c:2655 [inline]
__x64_sys_sendmmsg+0x99/0x100 net/socket.c:2655
do_syscall_x64 arch/x86/entry/common.c:50 [inline]
do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
entry_SYSCALL_64_after_hwframe+0x46/0xb0
RIP: 0033:0x7fefd8a89109
Code: ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 b8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007fefd9ca6168 EFLAGS: 00000246 ORIG_RAX: 0000000000000133
RAX: ffffffffffffffda RBX: 00007fefd8b9bf60 RCX: 00007fefd8a89109
RDX: 0000000004924b68 RSI: 0000000020000140 RDI: 0000000000000003
RBP: 00007fefd8ae305d R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 00007ffc346febaf R14: 00007fefd9ca6300 R15: 0000000000022000
</TASK>

Fixes: ebc3197963fc ("ipmr: add rcu protection over (struct vif_device)->dev")
Reported-by: syzbot <syzkaller@googlegroups.com>
Signed-off-by: Eric Dumazet <edumazet@google.com>
---
 net/ipv4/ipmr.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/ipv4/ipmr.c b/net/ipv4/ipmr.c
index f095b6c8100bd24262c949390b68865b8b3987c3..73651d17e51f31c8755da6ac3c1c2763a99b1117 100644
--- a/net/ipv4/ipmr.c
+++ b/net/ipv4/ipmr.c
@@ -2753,7 +2753,7 @@ static bool ipmr_fill_vif(struct mr_table *mrt, u32 vifid, struct sk_buff *skb)
 	struct vif_device *vif;
 
 	vif = &mrt->vif_table[vifid];
-	vif_dev = vif_dev_read(vif);
+	vif_dev = rtnl_dereference(vif->dev);
 	/* if the VIF doesn't exist just continue */
 	if (!vif_dev)
 		return true;
-- 
2.37.0.rc0.161.g10f37bed90-goog

