Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D2CEB4E35F1
	for <lists+netdev@lfdr.de>; Tue, 22 Mar 2022 02:23:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234645AbiCVBYq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Mar 2022 21:24:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45884 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234637AbiCVBYo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Mar 2022 21:24:44 -0400
Received: from mail-pg1-x530.google.com (mail-pg1-x530.google.com [IPv6:2607:f8b0:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3CC961D304
        for <netdev@vger.kernel.org>; Mon, 21 Mar 2022 18:23:18 -0700 (PDT)
Received: by mail-pg1-x530.google.com with SMTP id o8so11542934pgf.9
        for <netdev@vger.kernel.org>; Mon, 21 Mar 2022 18:23:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=3Y7ec+/h7vUoYmFdBhoG1C0bH4Hy2QCVwyckaQbcbkU=;
        b=AMD2ae2evQXUl5kDr4SIqtYULFvsOYMH2IKajcL6jke668JbWufk1l0T+G1SGeQ4qk
         qdz8G6e2NhHLxLy7D+DRoyYeHhCk+sfGgjKvpg/g5CNX4B+iOXuHoqLNuMFdqwGB6tCj
         hclS/Gs86fsdf2f0VBnRmE00hqTiPiDXleiSZw8CHRELlZjOfOo0nAMWo/gLbTkFN+Vp
         4P/2D88LliiBGnF2i1NIRT/je/1gd1ZtpUDBpJ0B+alfHRpozlUhJA4jKlByb/cxIZHa
         a/ZtiMdRTy2iIVBmndJqnSizup4eoizWv0c487JH4qhVNJ/CN1kJKCKzMtbMwNa8lt/u
         X7cA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=3Y7ec+/h7vUoYmFdBhoG1C0bH4Hy2QCVwyckaQbcbkU=;
        b=5tPKheUmog/KDyD5EIURwqzxYEjUBlrmhGeOzmoQcT9pJTMeaXdMtcW1Nzc0LiROep
         RJ89irOngbpmiMvgUWcgJaX+51WV5+6PrfsfXZlhuJ1xWr+FOtuwSXsbBobigjurGzfo
         ktSQ6LVDzjAMhTEUu+JbqM9H/okIiR0hWSyrcq93Jc/DqqiRr/kknO2maqxpfvfteyMB
         udH5crgWbt9oahZRKaiObBOHYGWNk+Ok2NdxDfXAuvzRjPYKzBY5eDAiaIBC/HZLWC1S
         JDV2RAzFmg7Mh9Kub176ii4kZueARLrebqf2xxuuQkFkPXlGtvFJN6USys9QrnzR060x
         FPDw==
X-Gm-Message-State: AOAM531m4h9mprojaLdgjEOj+xoYvDnjEYpz2Q49vwZaYOpd6wrSeIjP
        tw+oWNI7kyAGzfblsO3hosk=
X-Google-Smtp-Source: ABdhPJy4nm5eflIBoMWShDsJccpilHiDHIVDSr2CLziMP2mDNG5mZVMCZKHXTbT8T76nn+9zWYjHjA==
X-Received: by 2002:aa7:8c0a:0:b0:4fa:686f:96ff with SMTP id c10-20020aa78c0a000000b004fa686f96ffmr22218526pfd.15.1647912197748;
        Mon, 21 Mar 2022 18:23:17 -0700 (PDT)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:c6c2:7860:be83:7d4f])
        by smtp.gmail.com with ESMTPSA id u62-20020a638541000000b00382791c89efsm4934624pgd.13.2022.03.21.18.23.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Mar 2022 18:23:17 -0700 (PDT)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        syzbot <syzkaller@googlegroups.com>,
        Tobias Waldekranz <tobias@waldekranz.com>,
        Nikolay Aleksandrov <razor@blackwall.org>
Subject: [PATCH net-next] net: bridge: mst: prevent NULL deref in br_mst_info_size()
Date:   Mon, 21 Mar 2022 18:23:14 -0700
Message-Id: <20220322012314.795187-1-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.35.1.894.gb6a874cedc-goog
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

Call br_mst_info_size() only if vg pointer is not NULL.

general protection fault, probably for non-canonical address 0xdffffc0000000058: 0000 [#1] PREEMPT SMP KASAN
KASAN: null-ptr-deref in range [0x00000000000002c0-0x00000000000002c7]
CPU: 0 PID: 975 Comm: syz-executor.0 Tainted: G        W         5.17.0-next-20220321-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
RIP: 0010:br_mst_info_size+0x97/0x270 net/bridge/br_mst.c:242
Code: 00 00 31 c0 e8 ba 10 53 f9 31 c0 b9 40 00 00 00 4c 8d 6c 24 30 4c 89 ef f3 48 ab 48 8d 83 c0 02 00 00 48 89 04 24 48 c1 e8 03 <80> 3c 28 00 0f 85 ae 01 00 00 48 8b 83 c0 02 00 00 41 bf 04 00 00
RSP: 0018:ffffc900153770a8 EFLAGS: 00010202
RAX: 0000000000000058 RBX: 0000000000000000 RCX: 0000000000000000
RDX: 0000000000040000 RSI: ffffffff88259876 RDI: ffffc900153772d8
RBP: dffffc0000000000 R08: 0000000000000000 R09: ffffffff8db68957
R10: ffffffff881f737b R11: 0000000000000000 R12: 0000000000000000
R13: ffffc900153770d8 R14: 00000000000002a0 R15: 00000000ffffffff
FS:  00007f18bbb6f700(0000) GS:ffff8880b9c00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000020001a80 CR3: 000000001a7d9000 CR4: 00000000003506f0
DR0: 0000000000000000 DR1: 00000000000000d8 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 <TASK>
 br_get_link_af_size_filtered+0x6e9/0xc00 net/bridge/br_netlink.c:123
 rtnl_link_get_af_size net/core/rtnetlink.c:598 [inline]
 if_nlmsg_size+0x40c/0xa50 net/core/rtnetlink.c:1040
 rtnl_calcit.isra.0+0x25f/0x460 net/core/rtnetlink.c:3780
 rtnetlink_rcv_msg+0xa65/0xb80 net/core/rtnetlink.c:5937
 netlink_rcv_skb+0x153/0x420 net/netlink/af_netlink.c:2496
 netlink_unicast_kernel net/netlink/af_netlink.c:1319 [inline]
 netlink_unicast+0x543/0x7f0 net/netlink/af_netlink.c:1345
 netlink_sendmsg+0x904/0xe00 net/netlink/af_netlink.c:1921
 sock_sendmsg_nosec net/socket.c:705 [inline]
 sock_sendmsg+0xcf/0x120 net/socket.c:725
 ____sys_sendmsg+0x6e8/0x810 net/socket.c:2413
 ___sys_sendmsg+0xf3/0x170 net/socket.c:2467
 __sys_sendmsg+0xe5/0x1b0 net/socket.c:2496
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x35/0x80 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x44/0xae
RIP: 0033:0x7f18baa89049
Code: ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 b8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007f18bbb6f168 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
RAX: ffffffffffffffda RBX: 00007f18bab9bf60 RCX: 00007f18baa89049
RDX: 0000000000000000 RSI: 0000000020001a80 RDI: 0000000000000004
RBP: 00007f18baae308d R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 00007ffeedb2be2f R14: 00007f18bbb6f300 R15: 0000000000022000
 </TASK>
Modules linked in:
---[ end trace 0000000000000000 ]---
RIP: 0010:br_mst_info_size+0x97/0x270 net/bridge/br_mst.c:242
Code: 00 00 31 c0 e8 ba 10 53 f9 31 c0 b9 40 00 00 00 4c 8d 6c 24 30 4c 89 ef f3 48 ab 48 8d 83 c0 02 00 00 48 89 04 24 48 c1 e8 03 <80> 3c 28 00 0f 85 ae 01 00 00 48 8b 83 c0 02 00 00 41 bf 04 00 00
RSP: 0018:ffffc900153770a8 EFLAGS: 00010202
RAX: 0000000000000058 RBX: 0000000000000000 RCX: 0000000000000000
RDX: 0000000000040000 RSI: ffffffff88259876 RDI: ffffc900153772d8
RBP: dffffc0000000000 R08: 0000000000000000 R09: ffffffff8db68957
R10: ffffffff881f737b R11: 0000000000000000 R12: 0000000000000000
R13: ffffc900153770d8 R14: 00000000000002a0 R15: 00000000ffffffff
FS:  00007f18bbb6f700(0000) GS:ffff8880b9c00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000001b2ca22000 CR3: 000000001a7d9000 CR4: 00000000003506f0
DR0: 0000000000000000 DR1: 00000000000000d8 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400

Fixes: 122c29486e1f ("net: bridge: mst: Support setting and reporting MST port states")
Reported-by: syzbot <syzkaller@googlegroups.com>
Signed-off-by: Eric Dumazet <edumazet@google.com>
Cc: Tobias Waldekranz <tobias@waldekranz.com>
Cc: Nikolay Aleksandrov <razor@blackwall.org>
---
 net/bridge/br_netlink.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/bridge/br_netlink.c b/net/bridge/br_netlink.c
index a8d90fa8621e2dd7b74b16ce527984f40b563ea0..204472449ec9323cedc19326ff600a61d8f510f5 100644
--- a/net/bridge/br_netlink.c
+++ b/net/bridge/br_netlink.c
@@ -119,7 +119,7 @@ static size_t br_get_link_af_size_filtered(const struct net_device *dev,
 	/* Each VLAN is returned in bridge_vlan_info along with flags */
 	vinfo_sz += num_vlan_infos * nla_total_size(sizeof(struct bridge_vlan_info));
 
-	if (filter_mask & RTEXT_FILTER_MST)
+	if (vg && (filter_mask & RTEXT_FILTER_MST))
 		vinfo_sz += br_mst_info_size(vg);
 
 	if (!(filter_mask & RTEXT_FILTER_CFM_STATUS))
-- 
2.35.1.894.gb6a874cedc-goog

