Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1BF7B6697C7
	for <lists+netdev@lfdr.de>; Fri, 13 Jan 2023 13:56:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240620AbjAMM4f (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Jan 2023 07:56:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35332 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241379AbjAMM4I (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Jan 2023 07:56:08 -0500
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1237336338
        for <netdev@vger.kernel.org>; Fri, 13 Jan 2023 04:43:29 -0800 (PST)
Received: by mail-yb1-xb49.google.com with SMTP id y66-20020a25c845000000b00733b5049b6fso22429796ybf.3
        for <netdev@vger.kernel.org>; Fri, 13 Jan 2023 04:43:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=5zAds6dJ80mrhRnoDvYbKky5GBmXWKQesPl/8EhCvZk=;
        b=h2Dut6VZC2FqtL7oy/fvWGe/VTIVL+k6LwYHLR2FkVFuVGXc3s0WV8eY31lqZDwWKh
         +GZLiPkAzcL+WRcGMcM7/MNA/W1MzNsqmHDTlcp2g95VFjPUv/130qntwrd++Hz7+n/0
         iZYxyp7+ZrspVHOMvxGO85TKD4Iznpe/vI3GpjvAvL9qLOVM9ZSXwFFWV+d8wHpoXbUO
         CZAzbLnoiWCQPxE0T5CqWFwGi1m1Ht81MH0GAUgOX5M5vAeX3Hh1+fxUUweQp2u1q/t9
         m1hzUZx3l+xCSQ+983nb8XM5F7kA7K7nZWbEQEKhZYTBpxIzVnvsg1dvyY+VU/IHQ7dV
         7B1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=5zAds6dJ80mrhRnoDvYbKky5GBmXWKQesPl/8EhCvZk=;
        b=Z5Ahex6jkNnkWe8ypz3br5uoXpxnChq2ZVq9UXk6dzssdrhg/5vgoEwROjQQzv1mbj
         AJM5c40xA1fPZ94gd+wffxVRACYWQKeoDV4EYlIcVVnEIOmCO+ytIDkvjj8e2kWEfh2P
         raChJN4t63b6Pi8f3wEVNNk+tKYQ1Q0bEj0R81dezWhFD793ej1O7GZt/dG69kpuk8eP
         hRyisBU7pIZUThbnFYLFC1aP90k0/Zlfyt7TCRd9KzPLJbXkGFtYSPO6Sx34SFLzZdD1
         BiW07Rq0v2m9Y00QqkXR0xmi6WnOKBUk/0eFQGET5XFmvCfTHPaT5INo3dvfBntFma0F
         LMDw==
X-Gm-Message-State: AFqh2kqXmP7P3atwjQM4KBvlW1q5S4thzvAoYde4GtKZb76l0fIMPWDf
        ygAHdAn7x36GNOMniqhbXv1zySfIi5fV6w==
X-Google-Smtp-Source: AMrXdXu04letNP3n73i7G20TfRIAC6TF031htVYWaFLgpui/0FS1FY93V0Q8WqhjcO0QluWLvFi3P5GqGgGR+Q==
X-Received: from edumazet1.c.googlers.com ([fda3:e722:ac3:cc00:2b:7d90:c0a8:395a])
 (user=edumazet job=sendgmr) by 2002:a25:da92:0:b0:7cb:aadd:68e2 with SMTP id
 n140-20020a25da92000000b007cbaadd68e2mr362884ybf.266.1673613808344; Fri, 13
 Jan 2023 04:43:28 -0800 (PST)
Date:   Fri, 13 Jan 2023 12:43:26 +0000
Mime-Version: 1.0
X-Mailer: git-send-email 2.39.0.314.g84b9a713c41-goog
Message-ID: <20230113124326.3533978-1-edumazet@google.com>
Subject: [PATCH net] Revert "wifi: mac80211: fix memory leak in ieee80211_if_add()"
From:   Eric Dumazet <edumazet@google.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Johannes Berg <johannes@sipsolutions.net>
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        eric.dumazet@gmail.com, Eric Dumazet <edumazet@google.com>,
        syzbot <syzkaller@googlegroups.com>,
        Zhengchao Shao <shaozhengchao@huawei.com>,
        Johannes Berg <johannes.berg@intel.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This reverts commit 13e5afd3d773c6fc6ca2b89027befaaaa1ea7293.

ieee80211_if_free() is already called from free_netdev(ndev)
because ndev->priv_destructor == ieee80211_if_free

syzbot reported:

general protection fault, probably for non-canonical address 0xdffffc0000000004: 0000 [#1] PREEMPT SMP KASAN
KASAN: null-ptr-deref in range [0x0000000000000020-0x0000000000000027]
CPU: 0 PID: 10041 Comm: syz-executor.0 Not tainted 6.2.0-rc2-syzkaller-00388-g55b98837e37d #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 10/26/2022
RIP: 0010:pcpu_get_page_chunk mm/percpu.c:262 [inline]
RIP: 0010:pcpu_chunk_addr_search mm/percpu.c:1619 [inline]
RIP: 0010:free_percpu mm/percpu.c:2271 [inline]
RIP: 0010:free_percpu+0x186/0x10f0 mm/percpu.c:2254
Code: 80 3c 02 00 0f 85 f5 0e 00 00 48 8b 3b 48 01 ef e8 cf b3 0b 00 48 ba 00 00 00 00 00 fc ff df 48 8d 78 20 48 89 f9 48 c1 e9 03 <80> 3c 11 00 0f 85 3b 0e 00 00 48 8b 58 20 48 b8 00 00 00 00 00 fc
RSP: 0018:ffffc90004ba7068 EFLAGS: 00010002
RAX: 0000000000000000 RBX: ffff88823ffe2b80 RCX: 0000000000000004
RDX: dffffc0000000000 RSI: ffffffff81c1f4e7 RDI: 0000000000000020
RBP: ffffe8fffe8fc220 R08: 0000000000000005 R09: 0000000000000000
R10: 0000000000000000 R11: 1ffffffff2179ab2 R12: ffff8880b983d000
R13: 0000000000000003 R14: 0000607f450fc220 R15: ffff88823ffe2988
FS: 00007fcb349de700(0000) GS:ffff8880b9800000(0000) knlGS:0000000000000000
CS: 0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000001b32220000 CR3: 000000004914f000 CR4: 00000000003506f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
<TASK>
netdev_run_todo+0x6bf/0x1100 net/core/dev.c:10352
ieee80211_register_hw+0x2663/0x4040 net/mac80211/main.c:1411
mac80211_hwsim_new_radio+0x2537/0x4d80 drivers/net/wireless/mac80211_hwsim.c:4583
hwsim_new_radio_nl+0xa09/0x10f0 drivers/net/wireless/mac80211_hwsim.c:5176
genl_family_rcv_msg_doit.isra.0+0x1e6/0x2d0 net/netlink/genetlink.c:968
genl_family_rcv_msg net/netlink/genetlink.c:1048 [inline]
genl_rcv_msg+0x4ff/0x7e0 net/netlink/genetlink.c:1065
netlink_rcv_skb+0x165/0x440 net/netlink/af_netlink.c:2564
genl_rcv+0x28/0x40 net/netlink/genetlink.c:1076
netlink_unicast_kernel net/netlink/af_netlink.c:1330 [inline]
netlink_unicast+0x547/0x7f0 net/netlink/af_netlink.c:1356
netlink_sendmsg+0x91b/0xe10 net/netlink/af_netlink.c:1932
sock_sendmsg_nosec net/socket.c:714 [inline]
sock_sendmsg+0xd3/0x120 net/socket.c:734
____sys_sendmsg+0x712/0x8c0 net/socket.c:2476
___sys_sendmsg+0x110/0x1b0 net/socket.c:2530
__sys_sendmsg+0xf7/0x1c0 net/socket.c:2559
do_syscall_x64 arch/x86/entry/common.c:50 [inline]
do_syscall_64+0x39/0xb0 arch/x86/entry/common.c:80
entry_SYSCALL_64_after_hwframe+0x63/0xcd

Reported-by: syzbot <syzkaller@googlegroups.com>
Fixes: 13e5afd3d773 ("wifi: mac80211: fix memory leak in ieee80211_if_add()")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Cc: Zhengchao Shao <shaozhengchao@huawei.com>
Cc: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/iface.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/net/mac80211/iface.c b/net/mac80211/iface.c
index e20c3fe9a0b19439794a5b6fb9f696ee6b87ce8d..23ed13f150675d1ffa869796c857f5905fb8dae8 100644
--- a/net/mac80211/iface.c
+++ b/net/mac80211/iface.c
@@ -2197,7 +2197,6 @@ int ieee80211_if_add(struct ieee80211_local *local, const char *name,
 
 		ret = cfg80211_register_netdevice(ndev);
 		if (ret) {
-			ieee80211_if_free(ndev);
 			free_netdev(ndev);
 			return ret;
 		}
-- 
2.39.0.314.g84b9a713c41-goog

