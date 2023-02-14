Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 68035695617
	for <lists+netdev@lfdr.de>; Tue, 14 Feb 2023 02:47:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230116AbjBNBrm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Feb 2023 20:47:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51434 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230335AbjBNBrm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Feb 2023 20:47:42 -0500
Received: from mail-oi1-x230.google.com (mail-oi1-x230.google.com [IPv6:2607:f8b0:4864:20::230])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6FADD1A49A
        for <netdev@vger.kernel.org>; Mon, 13 Feb 2023 17:47:38 -0800 (PST)
Received: by mail-oi1-x230.google.com with SMTP id bi19so11897697oib.2
        for <netdev@vger.kernel.org>; Mon, 13 Feb 2023 17:47:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=vlbaXzzRLMywgJ8lBL9RokzO1A5O5vNJELYHrJhuGLM=;
        b=m2Zgh30LcZz6f0mgweVfxRj3f4GVcuc8UxlToz7GylZoRaXKxOeFquAq9dAXrUJlxx
         V4nEve6T6zay0CoiB0z/5ePKlAWb6CJ4EmBQBoqip0eJAqE9vrNLKC6JsMzdBTGiwfqn
         BABq9jRGwme882wn2VffEnzGq/WPEPKeNssmbTDqLVheDwudAeP6Esi08wNmez8vrbyo
         ZEggJzpcW7Os3ygllEiXwoWXrmQeKWzVAvMNmS25yE212IB0R4HUtDHbYBqv9TwRb4gI
         E+xjajx26D5eGM3vKhWTaJEOQhKgeNkawoAnRwiBXL1iEzMexAJr5Omp1ENWdoATtAzb
         jrnw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=vlbaXzzRLMywgJ8lBL9RokzO1A5O5vNJELYHrJhuGLM=;
        b=NneDBZVTm1sQp6ZvcVH0G4WC/uiv/3E9Q1zblviEubrrmUx+I0cmU5QLMa+7orfSL3
         vi/ugNjd9AeZ2raIvFZm1D7PKGReMdvsKI28gc+F11yBJaOS6jVhkBvnZHkZ/poSLKsQ
         DeDNrTbLkBha6kuKwPUrn2ZezspUcJO0FQifQ1tYszNun3woalQ9BiqOCYE5JVf9gPUV
         +YcygodoAOJ+2gwyE6v5frJ5bfmjb5EUSK1cM6heDfAfVtj/n2TmdHmX+pc4EQ2GIz3E
         wR4QRbQHXCr/zqEbeb6PL+FdNsFKSMUjTZHrvOQV5hasjlsp5lTUI+GeeVKKZwF5yTec
         koLw==
X-Gm-Message-State: AO0yUKV8MDijPGJqd67UJ2GqjXvDkvfE9B2qfInS4l9SSTlASjymqQOP
        5jwKTfANVa5LYXptPoo1R5B1nC6OqvgXQPIK
X-Google-Smtp-Source: AK7set9BIZCZw+Uk0mmIIjTT3pJvu9sXgWkY4bAq5i5szUmNzkreGHI8GKmWgUJ35Clt7CzLv5ugTg==
X-Received: by 2002:a05:6808:b39:b0:364:9f7e:3024 with SMTP id t25-20020a0568080b3900b003649f7e3024mr389131oij.39.1676339257664;
        Mon, 13 Feb 2023 17:47:37 -0800 (PST)
Received: from localhost.localdomain ([2804:14d:5c5e:4698:edb8:9be4:f6de:8d2])
        by smtp.gmail.com with ESMTPSA id p129-20020acabf87000000b0037841fb9a65sm5739886oif.5.2023.02.13.17.47.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Feb 2023 17:47:37 -0800 (PST)
From:   Pedro Tammela <pctammela@mojatatu.com>
To:     netdev@vger.kernel.org
Cc:     jhs@mojatatu.com, xiyou.wangcong@gmail.com, jiri@resnulli.us,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, Pedro Tammela <pctammela@mojatatu.com>
Subject: [PATCH net] net/sched: tcindex: search key must be 16 bits
Date:   Mon, 13 Feb 2023 22:47:29 -0300
Message-Id: <20230214014729.648564-1-pctammela@mojatatu.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Syzkaller found an issue where a handle greater than 16 bits would trigger
a null-ptr-deref in the imperfect hash area update.

general protection fault, probably for non-canonical address
0xdffffc0000000015: 0000 [#1] PREEMPT SMP KASAN
KASAN: null-ptr-deref in range [0x00000000000000a8-0x00000000000000af]
CPU: 0 PID: 5070 Comm: syz-executor456 Not tainted
6.2.0-rc7-syzkaller-00112-gc68f345b7c42 #0
Hardware name: Google Google Compute Engine/Google Compute Engine,
BIOS Google 01/21/2023
RIP: 0010:tcindex_set_parms+0x1a6a/0x2990 net/sched/cls_tcindex.c:509
Code: 01 e9 e9 fe ff ff 4c 8b bd 28 fe ff ff e8 0e 57 7d f9 48 8d bb
a8 00 00 00 48 b8 00 00 00 00 00 fc ff df 48 89 fa 48 c1 ea 03 <80> 3c
02 00 0f 85 94 0c 00 00 48 8b 85 f8 fd ff ff 48 8b 9b a8 00
RSP: 0018:ffffc90003d3ef88 EFLAGS: 00010202
RAX: dffffc0000000000 RBX: 0000000000000000 RCX: 0000000000000000
RDX: 0000000000000015 RSI: ffffffff8803a102 RDI: 00000000000000a8
RBP: ffffc90003d3f1d8 R08: 0000000000000001 R09: 0000000000000000
R10: 0000000000000001 R11: 0000000000000000 R12: ffff88801e2b10a8
R13: dffffc0000000000 R14: 0000000000030000 R15: ffff888017b3be00
FS: 00005555569af300(0000) GS:ffff8880b9800000(0000) knlGS:0000000000000000
CS: 0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 000056041c6d2000 CR3: 000000002bfca000 CR4: 00000000003506f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
<TASK>
tcindex_change+0x1ea/0x320 net/sched/cls_tcindex.c:572
tc_new_tfilter+0x96e/0x2220 net/sched/cls_api.c:2155
rtnetlink_rcv_msg+0x959/0xca0 net/core/rtnetlink.c:6132
netlink_rcv_skb+0x165/0x440 net/netlink/af_netlink.c:2574
netlink_unicast_kernel net/netlink/af_netlink.c:1339 [inline]
netlink_unicast+0x547/0x7f0 net/netlink/af_netlink.c:1365
netlink_sendmsg+0x91b/0xe10 net/netlink/af_netlink.c:1942
sock_sendmsg_nosec net/socket.c:714 [inline]
sock_sendmsg+0xd3/0x120 net/socket.c:734
____sys_sendmsg+0x334/0x8c0 net/socket.c:2476
___sys_sendmsg+0x110/0x1b0 net/socket.c:2530
__sys_sendmmsg+0x18f/0x460 net/socket.c:2616
__do_sys_sendmmsg net/socket.c:2645 [inline]
__se_sys_sendmmsg net/socket.c:2642 [inline]
__x64_sys_sendmmsg+0x9d/0x100 net/socket.c:2642
do_syscall_x64 arch/x86/entry/common.c:50 [inline]
do_syscall_64+0x39/0xb0 arch/x86/entry/common.c:80

Fixes: ee059170b1f7 ("net/sched: tcindex: update imperfect hash filters respecting rcu")
Signed-off-by: Jamal Hadi Salim <jhs@mojatatu.com>
Signed-off-by: Pedro Tammela <pctammela@mojatatu.com>
---
 net/sched/cls_tcindex.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/sched/cls_tcindex.c b/net/sched/cls_tcindex.c
index ba7f22a49..6640e75ea 100644
--- a/net/sched/cls_tcindex.c
+++ b/net/sched/cls_tcindex.c
@@ -503,7 +503,7 @@ tcindex_set_parms(struct net *net, struct tcf_proto *tp, unsigned long base,
 		/* lookup the filter, guaranteed to exist */
 		for (cf = rcu_dereference_bh_rtnl(*fp); cf;
 		     fp = &cf->next, cf = rcu_dereference_bh_rtnl(*fp))
-			if (cf->key == handle)
+			if (cf->key == (u16)handle)
 				break;
 
 		f->next = cf->next;
-- 
2.34.1

