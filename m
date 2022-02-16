Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3CF424B8F25
	for <lists+netdev@lfdr.de>; Wed, 16 Feb 2022 18:32:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237094AbiBPRcj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Feb 2022 12:32:39 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:33358 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229934AbiBPRci (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Feb 2022 12:32:38 -0500
Received: from mail-pl1-x634.google.com (mail-pl1-x634.google.com [IPv6:2607:f8b0:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B940E7ACE
        for <netdev@vger.kernel.org>; Wed, 16 Feb 2022 09:32:25 -0800 (PST)
Received: by mail-pl1-x634.google.com with SMTP id l9so2567152plg.0
        for <netdev@vger.kernel.org>; Wed, 16 Feb 2022 09:32:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=tTOmD23LclCq/vxT71DI1TIcpcHFmODvZlG2uQyELW4=;
        b=KiZow+Zywknd2TAbtUX0WGK7a5eJ4scvdSa4jAQKOqTc82EacDO0jCPbu4lp6ED4Ex
         YfHpiO+pRIr5CACfD+eg8UVItrTe+UgOxk28SFqsEyCx3ifQAifq0/m4HnuQ+Hbfi/Bt
         FN/PS4HtN5V0Tt8hI5ZGfSdGXq5qwihYIqeMCPEjWNHRhokj8Q3TdIehv3hlUjLXjHL/
         fpMAGIeSDRS6i+yjp1J5ABsHYbQHSqr3wjSe+s39apFEw0W6pROrvhMKfkdigI2+pHi5
         0Ry9VpPjyQXJrYcivLFhnQYYB/MjSmIwzskWHtN44ljsQdlJYWED+OqmzZH/rJrXBkKz
         XLKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=tTOmD23LclCq/vxT71DI1TIcpcHFmODvZlG2uQyELW4=;
        b=7y8f4rsXkOnDU8bjoiz3y9JNqpcYXkls4yjM1/rmYB3BBKoP9PKCmlNRF6RIgdlvSt
         c80Y/MXga+OEhGErme7s5CSDHyhnIs1k16jRmZgKGzCLN0dUmaiy5n/R+xRFxYSlnFlV
         b6uiDcUA/74q7R4GeegImMk/4zMvtF4gkF7w7rtxbVqHXvRJwIDqjnlHjBlcX4pghdcO
         pvTHCXBrg371yZ4tSXHQGFwKZqPoVzukaP6SRrc16s92zoDEcWazuzpxGjYWf4O6j+QN
         UiES+faCGqF0BPwW+Mau7rha6PQXT2h6BziIsEjAdryOXVMffyy22SbeeWhTip1tR/E3
         k3UA==
X-Gm-Message-State: AOAM531KaPl3CgmYJJUMcWgto2DmYzwFh3s7oetDS7V9Eno6RLbpHNDh
        o+jFWfwaNbq/0zrHDCkO6xo=
X-Google-Smtp-Source: ABdhPJxMuSVxphkqImEHMNaHQgObLm3xJDtZQPoOI+rzKlbwUZhNVJB2szHnnUavGHf4vkMshvMA/w==
X-Received: by 2002:a17:902:6941:b0:14c:b815:6d45 with SMTP id k1-20020a170902694100b0014cb8156d45mr3412909plt.49.1645032744736;
        Wed, 16 Feb 2022 09:32:24 -0800 (PST)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:b2d6:3f21:5f47:8e5a])
        by smtp.gmail.com with ESMTPSA id k4sm13794336pff.39.2022.02.16.09.32.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Feb 2022 09:32:24 -0800 (PST)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Ido Schimmel <idosch@nvidia.com>,
        syzbot <syzkaller@googlegroups.com>
Subject: [PATCH net 1/2] ipv4: fix data races in fib_alias_hw_flags_set
Date:   Wed, 16 Feb 2022 09:32:16 -0800
Message-Id: <20220216173217.3792411-1-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.35.1.265.g69c8d7142f-goog
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

fib_alias_hw_flags_set() can be used by concurrent threads,
and is only RCU protected.

We need to annotate accesses to following fields of struct fib_alias:

    offload, trap, offload_failed

Because of READ_ONCE()WRITE_ONCE() limitations, make these
field u8.

BUG: KCSAN: data-race in fib_alias_hw_flags_set / fib_alias_hw_flags_set

read to 0xffff888134224a6a of 1 bytes by task 2013 on cpu 1:
 fib_alias_hw_flags_set+0x28a/0x470 net/ipv4/fib_trie.c:1050
 nsim_fib4_rt_hw_flags_set drivers/net/netdevsim/fib.c:350 [inline]
 nsim_fib4_rt_add drivers/net/netdevsim/fib.c:367 [inline]
 nsim_fib4_rt_insert drivers/net/netdevsim/fib.c:429 [inline]
 nsim_fib4_event drivers/net/netdevsim/fib.c:461 [inline]
 nsim_fib_event drivers/net/netdevsim/fib.c:881 [inline]
 nsim_fib_event_work+0x1852/0x2cf0 drivers/net/netdevsim/fib.c:1477
 process_one_work+0x3f6/0x960 kernel/workqueue.c:2307
 process_scheduled_works kernel/workqueue.c:2370 [inline]
 worker_thread+0x7df/0xa70 kernel/workqueue.c:2456
 kthread+0x1bf/0x1e0 kernel/kthread.c:377
 ret_from_fork+0x1f/0x30

write to 0xffff888134224a6a of 1 bytes by task 4872 on cpu 0:
 fib_alias_hw_flags_set+0x2d5/0x470 net/ipv4/fib_trie.c:1054
 nsim_fib4_rt_hw_flags_set drivers/net/netdevsim/fib.c:350 [inline]
 nsim_fib4_rt_add drivers/net/netdevsim/fib.c:367 [inline]
 nsim_fib4_rt_insert drivers/net/netdevsim/fib.c:429 [inline]
 nsim_fib4_event drivers/net/netdevsim/fib.c:461 [inline]
 nsim_fib_event drivers/net/netdevsim/fib.c:881 [inline]
 nsim_fib_event_work+0x1852/0x2cf0 drivers/net/netdevsim/fib.c:1477
 process_one_work+0x3f6/0x960 kernel/workqueue.c:2307
 process_scheduled_works kernel/workqueue.c:2370 [inline]
 worker_thread+0x7df/0xa70 kernel/workqueue.c:2456
 kthread+0x1bf/0x1e0 kernel/kthread.c:377
 ret_from_fork+0x1f/0x30

value changed: 0x00 -> 0x02

Reported by Kernel Concurrency Sanitizer on:
CPU: 0 PID: 4872 Comm: kworker/0:0 Not tainted 5.17.0-rc3-syzkaller-00188-g1d41d2e82623-dirty #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Workqueue: events nsim_fib_event_work

Fixes: 90b93f1b31f8 ("ipv4: Add "offload" and "trap" indications to routes")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Cc: Ido Schimmel <idosch@nvidia.com>
Reported-by: syzbot <syzkaller@googlegroups.com>
---
 net/ipv4/fib_lookup.h    |  7 +++----
 net/ipv4/fib_semantics.c |  6 +++---
 net/ipv4/fib_trie.c      | 22 +++++++++++++---------
 net/ipv4/route.c         |  4 ++--
 4 files changed, 21 insertions(+), 18 deletions(-)

diff --git a/net/ipv4/fib_lookup.h b/net/ipv4/fib_lookup.h
index e184bcb1994343c00914e09ab728ae16c4d23dc8..78e40ea42e58d930b3439d497de2b9e15fe45706 100644
--- a/net/ipv4/fib_lookup.h
+++ b/net/ipv4/fib_lookup.h
@@ -16,10 +16,9 @@ struct fib_alias {
 	u8			fa_slen;
 	u32			tb_id;
 	s16			fa_default;
-	u8			offload:1,
-				trap:1,
-				offload_failed:1,
-				unused:5;
+	u8			offload;
+	u8			trap;
+	u8			offload_failed;
 	struct rcu_head		rcu;
 };
 
diff --git a/net/ipv4/fib_semantics.c b/net/ipv4/fib_semantics.c
index b4589861b84c6bc4daa7149e078ad63749c7622f..2dd375f7407b68b0ddd914237185671550d19b72 100644
--- a/net/ipv4/fib_semantics.c
+++ b/net/ipv4/fib_semantics.c
@@ -525,9 +525,9 @@ void rtmsg_fib(int event, __be32 key, struct fib_alias *fa,
 	fri.dst_len = dst_len;
 	fri.tos = fa->fa_tos;
 	fri.type = fa->fa_type;
-	fri.offload = fa->offload;
-	fri.trap = fa->trap;
-	fri.offload_failed = fa->offload_failed;
+	fri.offload = READ_ONCE(fa->offload);
+	fri.trap = READ_ONCE(fa->trap);
+	fri.offload_failed = READ_ONCE(fa->offload_failed);
 	err = fib_dump_info(skb, info->portid, seq, event, &fri, nlm_flags);
 	if (err < 0) {
 		/* -EMSGSIZE implies BUG in fib_nlmsg_size() */
diff --git a/net/ipv4/fib_trie.c b/net/ipv4/fib_trie.c
index 8060524f425667d008470c2826f2ac835c8e25d2..f7f74d5c14da663e067f4d09a620b263947bd2da 100644
--- a/net/ipv4/fib_trie.c
+++ b/net/ipv4/fib_trie.c
@@ -1047,19 +1047,23 @@ void fib_alias_hw_flags_set(struct net *net, const struct fib_rt_info *fri)
 	if (!fa_match)
 		goto out;
 
-	if (fa_match->offload == fri->offload && fa_match->trap == fri->trap &&
-	    fa_match->offload_failed == fri->offload_failed)
+	/* These are paired with the WRITE_ONCE() happening in this function.
+	 * The reason is that we are only protected by RCU at this point.
+	 */
+	if (READ_ONCE(fa_match->offload) == fri->offload &&
+	    READ_ONCE(fa_match->trap) == fri->trap &&
+	    READ_ONCE(fa_match->offload_failed) == fri->offload_failed)
 		goto out;
 
-	fa_match->offload = fri->offload;
-	fa_match->trap = fri->trap;
+	WRITE_ONCE(fa_match->offload, fri->offload);
+	WRITE_ONCE(fa_match->trap, fri->trap);
 
 	/* 2 means send notifications only if offload_failed was changed. */
 	if (net->ipv4.sysctl_fib_notify_on_flag_change == 2 &&
-	    fa_match->offload_failed == fri->offload_failed)
+	    READ_ONCE(fa_match->offload_failed) == fri->offload_failed)
 		goto out;
 
-	fa_match->offload_failed = fri->offload_failed;
+	WRITE_ONCE(fa_match->offload_failed, fri->offload_failed);
 
 	if (!net->ipv4.sysctl_fib_notify_on_flag_change)
 		goto out;
@@ -2297,9 +2301,9 @@ static int fn_trie_dump_leaf(struct key_vector *l, struct fib_table *tb,
 				fri.dst_len = KEYLENGTH - fa->fa_slen;
 				fri.tos = fa->fa_tos;
 				fri.type = fa->fa_type;
-				fri.offload = fa->offload;
-				fri.trap = fa->trap;
-				fri.offload_failed = fa->offload_failed;
+				fri.offload = READ_ONCE(fa->offload);
+				fri.trap = READ_ONCE(fa->trap);
+				fri.offload_failed = READ_ONCE(fa->offload_failed);
 				err = fib_dump_info(skb,
 						    NETLINK_CB(cb->skb).portid,
 						    cb->nlh->nlmsg_seq,
diff --git a/net/ipv4/route.c b/net/ipv4/route.c
index ff6f91cdb6c4db7a1d5d66e08c99acb2919df2ef..f33ad1f383b684ea4a64d74da0a9951651a4be22 100644
--- a/net/ipv4/route.c
+++ b/net/ipv4/route.c
@@ -3395,8 +3395,8 @@ static int inet_rtm_getroute(struct sk_buff *in_skb, struct nlmsghdr *nlh,
 				    fa->fa_tos == fri.tos &&
 				    fa->fa_info == res.fi &&
 				    fa->fa_type == fri.type) {
-					fri.offload = fa->offload;
-					fri.trap = fa->trap;
+					fri.offload = READ_ONCE(fa->offload);
+					fri.trap = READ_ONCE(fa->trap);
 					break;
 				}
 			}
-- 
2.35.1.265.g69c8d7142f-goog

