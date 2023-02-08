Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6343E68F6D8
	for <lists+netdev@lfdr.de>; Wed,  8 Feb 2023 19:21:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230480AbjBHSVe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Feb 2023 13:21:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57156 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231387AbjBHSVa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Feb 2023 13:21:30 -0500
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B2FE64B773
        for <netdev@vger.kernel.org>; Wed,  8 Feb 2023 10:21:25 -0800 (PST)
Received: by mail-yb1-xb4a.google.com with SMTP id z129-20020a256587000000b0089da1e9b65cso8719351ybb.22
        for <netdev@vger.kernel.org>; Wed, 08 Feb 2023 10:21:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=rlKekk1ZsObfj6Uw3TqeoHX5u4g0jk+3UdUH8PtwFRc=;
        b=lFGOCxY0fcWPl1/z3sp/yQ9JXeXF2DJ+fZaVrawyswSkC5awogKCcvdU7cGSducgzg
         dB+6tWhWwVlU7ysOFZTrOFg1WM5tF+KT2TpqYZpZLNTHEFxPxfXtqLNCCMGijFdLO95V
         dAlYqfovVikC53h2RX7CbUD066UhFe0M1JWOW4r9t0IrRVuUaQUcij0x88E5Pmwt9BeN
         CpqEXr3CYhg4Lcr8HdtUTfbdH2QvSlsVUZvzvYpo3oLSbqzK3mBzi0ogLpHgdut3PdOt
         9PkdMiydhInhgaombjIAnJOlXLzQtUihIcc9FHFeTPlDHhrXy4sIdcJPW2Y8Td9B/gtm
         e6ZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=rlKekk1ZsObfj6Uw3TqeoHX5u4g0jk+3UdUH8PtwFRc=;
        b=eNrN26dwLaKe9YwLtCUAQJIJ8F8IQ8kDlh1t41csbNIcu32PstRTwvA0rX/bwZqE+2
         /beV3eh7i3IDNo+ndQJiUvQcLtzyD1eP3AhmRC7qrCJ7AmqcnBYH56rX/lFem60l3Fm/
         7vB/PxnWFRVtuSpwTqMJILxypci4/Ae7tcejv+gk0J5ZBWfB48o5EW32Ie3yuYiguedD
         RTio3QBrHxZXphh2qZ9UiBeq0Gh1yt7dURye6NC5LG4+Vf6KesJxeKETzryASkMS3oXv
         TA2OPL1XtsjBuR2T8+6x+R7ljU+D6kNR9yUcrq/iRwHk5Aku0vJHCOvpiCWVsjY8D1J/
         TffQ==
X-Gm-Message-State: AO0yUKWD9HDvYI/aDA7YoZJ0rjmpOcX8lMSZzO/TfQ7q1vIwJAOAKNSv
        BSYl87apDHq4M4VqmZiU+7OMh/CcjM1wCw==
X-Google-Smtp-Source: AK7set8itaZOMyoENDhvqqQzUViYZEIc8HnzLpy89AP8bownLDlMLPySA4iJ8RdOLQyLKfGjJXsmkeC4sSridA==
X-Received: from edumazet1.c.googlers.com ([fda3:e722:ac3:cc00:2b:7d90:c0a8:395a])
 (user=edumazet job=sendgmr) by 2002:a0d:ff06:0:b0:52b:c7a5:10b3 with SMTP id
 p6-20020a0dff06000000b0052bc7a510b3mr533787ywf.311.1675880484911; Wed, 08 Feb
 2023 10:21:24 -0800 (PST)
Date:   Wed,  8 Feb 2023 18:21:23 +0000
Mime-Version: 1.0
X-Mailer: git-send-email 2.39.1.519.gcb327c4b5f-goog
Message-ID: <20230208182123.3821604-1-edumazet@google.com>
Subject: [PATCH net] net: initialize net->notrefcnt_tracker earlier
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
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

syzbot was able to trigger a warning [1] from net_free()
calling ref_tracker_dir_exit(&net->notrefcnt_tracker)
while the corresponding ref_tracker_dir_init() has not been
done yet.

copy_net_ns() can indeed bypass the call to setup_net()
in some error conditions.

Note:

We might factorize/move more code in preinit_net() in the future.

[1]
INFO: trying to register non-static key.
The code is fine but needs lockdep annotation, or maybe
you didn't initialize this object before use?
turning off the locking correctness validator.
CPU: 0 PID: 5817 Comm: syz-executor.3 Not tainted 6.2.0-rc7-next-20230208-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/12/2023
Call Trace:
<TASK>
__dump_stack lib/dump_stack.c:88 [inline]
dump_stack_lvl+0xd9/0x150 lib/dump_stack.c:106
assign_lock_key kernel/locking/lockdep.c:982 [inline]
register_lock_class+0xdb6/0x1120 kernel/locking/lockdep.c:1295
__lock_acquire+0x10a/0x5df0 kernel/locking/lockdep.c:4951
lock_acquire.part.0+0x11c/0x370 kernel/locking/lockdep.c:5691
__raw_spin_lock_irqsave include/linux/spinlock_api_smp.h:110 [inline]
_raw_spin_lock_irqsave+0x3d/0x60 kernel/locking/spinlock.c:162
ref_tracker_dir_exit+0x52/0x600 lib/ref_tracker.c:24
net_free net/core/net_namespace.c:442 [inline]
net_free+0x98/0xd0 net/core/net_namespace.c:436
copy_net_ns+0x4f3/0x6b0 net/core/net_namespace.c:493
create_new_namespaces+0x3f6/0xb20 kernel/nsproxy.c:110
unshare_nsproxy_namespaces+0xc1/0x1f0 kernel/nsproxy.c:228
ksys_unshare+0x449/0x920 kernel/fork.c:3205
__do_sys_unshare kernel/fork.c:3276 [inline]
__se_sys_unshare kernel/fork.c:3274 [inline]
__x64_sys_unshare+0x31/0x40 kernel/fork.c:3274
do_syscall_x64 arch/x86/entry/common.c:50 [inline]
do_syscall_64+0x39/0xb0 arch/x86/entry/common.c:80

Fixes: 0cafd77dcd03 ("net: add a refcount tracker for kernel sockets")
Reported-by: syzbot <syzkaller@googlegroups.com>
Signed-off-by: Eric Dumazet <edumazet@google.com>
---
 net/core/net_namespace.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/net/core/net_namespace.c b/net/core/net_namespace.c
index 078a0a420c8a7a7c3b5c4f3c2e752c5db1519540..7b69cf882b8efd901be57217013ebb155b616787 100644
--- a/net/core/net_namespace.c
+++ b/net/core/net_namespace.c
@@ -304,6 +304,12 @@ struct net *get_net_ns_by_id(const struct net *net, int id)
 }
 EXPORT_SYMBOL_GPL(get_net_ns_by_id);
 
+/* init code that must occur even if setup_net() is not called. */
+static __net_init void preinit_net(struct net *net)
+{
+	ref_tracker_dir_init(&net->notrefcnt_tracker, 128);
+}
+
 /*
  * setup_net runs the initializers for the network namespace object.
  */
@@ -316,7 +322,6 @@ static __net_init int setup_net(struct net *net, struct user_namespace *user_ns)
 
 	refcount_set(&net->ns.count, 1);
 	ref_tracker_dir_init(&net->refcnt_tracker, 128);
-	ref_tracker_dir_init(&net->notrefcnt_tracker, 128);
 
 	refcount_set(&net->passive, 1);
 	get_random_bytes(&net->hash_mix, sizeof(u32));
@@ -472,6 +477,8 @@ struct net *copy_net_ns(unsigned long flags,
 		rv = -ENOMEM;
 		goto dec_ucounts;
 	}
+
+	preinit_net(net);
 	refcount_set(&net->passive, 1);
 	net->ucounts = ucounts;
 	get_user_ns(user_ns);
@@ -1118,6 +1125,7 @@ void __init net_ns_init(void)
 	init_net.key_domain = &init_net_key_domain;
 #endif
 	down_write(&pernet_ops_rwsem);
+	preinit_net(&init_net);
 	if (setup_net(&init_net, &init_user_ns))
 		panic("Could not setup the initial network namespace");
 
-- 
2.39.1.519.gcb327c4b5f-goog

