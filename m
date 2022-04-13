Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C855F4FFCE6
	for <lists+netdev@lfdr.de>; Wed, 13 Apr 2022 19:35:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237399AbiDMRiQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Apr 2022 13:38:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45376 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237395AbiDMRiP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Apr 2022 13:38:15 -0400
Received: from mail-pg1-x52d.google.com (mail-pg1-x52d.google.com [IPv6:2607:f8b0:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E3026B0BA
        for <netdev@vger.kernel.org>; Wed, 13 Apr 2022 10:35:53 -0700 (PDT)
Received: by mail-pg1-x52d.google.com with SMTP id k29so2402151pgm.12
        for <netdev@vger.kernel.org>; Wed, 13 Apr 2022 10:35:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=kH/2gslwAWyj/eaQedcfnUx/ZHfdYjUgC9W6mfQggtU=;
        b=LhivkmiTFrUmW7W6abxojVLy9HEMi7jBl8gZpFVAxXlgEAmIDZXC5DQ9daZWIDYX6y
         OACLLxorwSG0l11JF+Sr/eGWAkBz5+r2chIboXkD0Xaigzl63YQ3dPODSz3fV+T5Gqcd
         6aLMEiPFpZk1PgcJIs5xsk2S9KwrHcgI1KI60qHp2z3ZSC7sXssq/Th75ViNdTXh5ZQ4
         nhi3POJRsU2kMfPzSP00S9+Kj1NUqRhEUq8ZWfm0rw+FrSaVr8XmJQBgNccIK4vxtdkY
         ZaKa5k2nH4RGudwySquDslDfAw2PRXubOSrZ8A0HXJVDUnexbW84zpPdtifxl3z0CTCi
         4grg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=kH/2gslwAWyj/eaQedcfnUx/ZHfdYjUgC9W6mfQggtU=;
        b=kY9D3UxYLENd0FiQqHjfY2W3+t1C7JqIUQXGMJK6eM+ornmg76LCQeD0MX7TK8Av2T
         DA2uOGcHbg1VASw83xJdO1iVDe7ypqRi5ujBjIDqZlwW4lCBZM4HNQScw/xZ3Un+Xi46
         lSBr4mA8szi5iaJAe8Jt5tX4Q7INIQgT3J80w9XMdwCnP4yNi/fiaQvE0bN8B5zcKQ53
         arDVGAGiEk6C1mFooGbdKihNrIyVuiaXtQaxhmlNdROn/q5WI4rLoaJWsysVTCPAUQMP
         Hz/KxRtTNOOvr8STWKkLmq4CkFdeyqXgQlN660IOXGY9r8T4F3hmQ/ey/vj5LlN4U7Lx
         3p7w==
X-Gm-Message-State: AOAM533wJ42e1prqePDnrpG4j9lRwMkzGkZFc9TyGol2BebMeN4bHSer
        dEuJ1dAnVD8tiLCK+Acv20I=
X-Google-Smtp-Source: ABdhPJyWV3a0JnrUhrpXxzjEhwZ0qIm043JoBLKSKnsPiOSqyMEUs2xoaNAUN6eT9RD7VTddtPBZYQ==
X-Received: by 2002:a05:6a00:890:b0:4f6:686e:a8a9 with SMTP id q16-20020a056a00089000b004f6686ea8a9mr44216434pfj.83.1649871352848;
        Wed, 13 Apr 2022 10:35:52 -0700 (PDT)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:bfb5:153b:b727:ea])
        by smtp.gmail.com with ESMTPSA id s3-20020a056a00194300b004f6da3a1a3bsm48546402pfk.8.2022.04.13.10.35.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 Apr 2022 10:35:52 -0700 (PDT)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>, netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        syzbot <syzkaller@googlegroups.com>
Subject: [PATCH net 1/2] net/sched: cls_u32: fix netns refcount changes in u32_change()
Date:   Wed, 13 Apr 2022 10:35:41 -0700
Message-Id: <20220413173542.533060-2-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.35.1.1178.g4f1659d476-goog
In-Reply-To: <20220413173542.533060-1-eric.dumazet@gmail.com>
References: <20220413173542.533060-1-eric.dumazet@gmail.com>
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

We are now able to detect extra put_net() at the moment
they happen, instead of much later in correct code paths.

u32_init_knode() / tcf_exts_init() populates the ->exts.net
pointer, but as mentioned in tcf_exts_init(),
the refcount on netns has not been elevated yet.

The refcount is taken only once tcf_exts_get_net()
is called.

So the two u32_destroy_key() calls from u32_change()
are attempting to release an invalid reference on the netns.

syzbot report:

refcount_t: decrement hit 0; leaking memory.
WARNING: CPU: 0 PID: 21708 at lib/refcount.c:31 refcount_warn_saturate+0xbf/0x1e0 lib/refcount.c:31
Modules linked in:
CPU: 0 PID: 21708 Comm: syz-executor.5 Not tainted 5.18.0-rc2-next-20220412-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
RIP: 0010:refcount_warn_saturate+0xbf/0x1e0 lib/refcount.c:31
Code: 1d 14 b6 b2 09 31 ff 89 de e8 6d e9 89 fd 84 db 75 e0 e8 84 e5 89 fd 48 c7 c7 40 aa 26 8a c6 05 f4 b5 b2 09 01 e8 e5 81 2e 05 <0f> 0b eb c4 e8 68 e5 89 fd 0f b6 1d e3 b5 b2 09 31 ff 89 de e8 38
RSP: 0018:ffffc900051af1b0 EFLAGS: 00010286
RAX: 0000000000000000 RBX: 0000000000000000 RCX: 0000000000000000
RDX: 0000000000040000 RSI: ffffffff8160a0c8 RDI: fffff52000a35e28
RBP: 0000000000000004 R08: 0000000000000000 R09: 0000000000000000
R10: ffffffff81604a9e R11: 0000000000000000 R12: 1ffff92000a35e3b
R13: 00000000ffffffef R14: ffff8880211a0194 R15: ffff8880577d0a00
FS:  00007f25d183e700(0000) GS:ffff8880b9c00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f19c859c028 CR3: 0000000051009000 CR4: 00000000003506f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 <TASK>
 __refcount_dec include/linux/refcount.h:344 [inline]
 refcount_dec include/linux/refcount.h:359 [inline]
 ref_tracker_free+0x535/0x6b0 lib/ref_tracker.c:118
 netns_tracker_free include/net/net_namespace.h:327 [inline]
 put_net_track include/net/net_namespace.h:341 [inline]
 tcf_exts_put_net include/net/pkt_cls.h:255 [inline]
 u32_destroy_key.isra.0+0xa7/0x2b0 net/sched/cls_u32.c:394
 u32_change+0xe01/0x3140 net/sched/cls_u32.c:909
 tc_new_tfilter+0x98d/0x2200 net/sched/cls_api.c:2148
 rtnetlink_rcv_msg+0x80d/0xb80 net/core/rtnetlink.c:6016
 netlink_rcv_skb+0x153/0x420 net/netlink/af_netlink.c:2495
 netlink_unicast_kernel net/netlink/af_netlink.c:1319 [inline]
 netlink_unicast+0x543/0x7f0 net/netlink/af_netlink.c:1345
 netlink_sendmsg+0x904/0xe00 net/netlink/af_netlink.c:1921
 sock_sendmsg_nosec net/socket.c:705 [inline]
 sock_sendmsg+0xcf/0x120 net/socket.c:725
 ____sys_sendmsg+0x6e2/0x800 net/socket.c:2413
 ___sys_sendmsg+0xf3/0x170 net/socket.c:2467
 __sys_sendmsg+0xe5/0x1b0 net/socket.c:2496
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x44/0xae
RIP: 0033:0x7f25d0689049
Code: ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 b8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007f25d183e168 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
RAX: ffffffffffffffda RBX: 00007f25d079c030 RCX: 00007f25d0689049
RDX: 0000000000000000 RSI: 0000000020000340 RDI: 0000000000000005
RBP: 00007f25d06e308d R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 00007ffd0b752e3f R14: 00007f25d183e300 R15: 0000000000022000
 </TASK>

Fixes: 35c55fc156d8 ("cls_u32: use tcf_exts_get_net() before call_rcu()")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Reported-by: syzbot <syzkaller@googlegroups.com>
Cc: Jamal Hadi Salim <jhs@mojatatu.com>
Cc: Cong Wang <xiyou.wangcong@gmail.com>
Cc: Jiri Pirko <jiri@resnulli.us>
---
 net/sched/cls_u32.c | 16 ++++++++++------
 1 file changed, 10 insertions(+), 6 deletions(-)

diff --git a/net/sched/cls_u32.c b/net/sched/cls_u32.c
index cf5649292ee00941e5c4a4d5b11b1c3dc98cce3f..fcba6c43ba509a069c593d525daf2943b4079538 100644
--- a/net/sched/cls_u32.c
+++ b/net/sched/cls_u32.c
@@ -386,14 +386,19 @@ static int u32_init(struct tcf_proto *tp)
 	return 0;
 }
 
-static int u32_destroy_key(struct tc_u_knode *n, bool free_pf)
+static void __u32_destroy_key(struct tc_u_knode *n)
 {
 	struct tc_u_hnode *ht = rtnl_dereference(n->ht_down);
 
 	tcf_exts_destroy(&n->exts);
-	tcf_exts_put_net(&n->exts);
 	if (ht && --ht->refcnt == 0)
 		kfree(ht);
+	kfree(n);
+}
+
+static void u32_destroy_key(struct tc_u_knode *n, bool free_pf)
+{
+	tcf_exts_put_net(&n->exts);
 #ifdef CONFIG_CLS_U32_PERF
 	if (free_pf)
 		free_percpu(n->pf);
@@ -402,8 +407,7 @@ static int u32_destroy_key(struct tc_u_knode *n, bool free_pf)
 	if (free_pf)
 		free_percpu(n->pcpu_success);
 #endif
-	kfree(n);
-	return 0;
+	__u32_destroy_key(n);
 }
 
 /* u32_delete_key_rcu should be called when free'ing a copied
@@ -900,13 +904,13 @@ static int u32_change(struct net *net, struct sk_buff *in_skb,
 				    extack);
 
 		if (err) {
-			u32_destroy_key(new, false);
+			__u32_destroy_key(new);
 			return err;
 		}
 
 		err = u32_replace_hw_knode(tp, new, flags, extack);
 		if (err) {
-			u32_destroy_key(new, false);
+			__u32_destroy_key(new);
 			return err;
 		}
 
-- 
2.35.1.1178.g4f1659d476-goog

