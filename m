Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 788186A4A11
	for <lists+netdev@lfdr.de>; Mon, 27 Feb 2023 19:44:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230083AbjB0Sok (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Feb 2023 13:44:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53554 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229900AbjB0Soj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Feb 2023 13:44:39 -0500
Received: from mail-yw1-x114a.google.com (mail-yw1-x114a.google.com [IPv6:2607:f8b0:4864:20::114a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6454512591
        for <netdev@vger.kernel.org>; Mon, 27 Feb 2023 10:44:38 -0800 (PST)
Received: by mail-yw1-x114a.google.com with SMTP id 00721157ae682-536d63d17dbso158571777b3.22
        for <netdev@vger.kernel.org>; Mon, 27 Feb 2023 10:44:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=TlXgrolZnHWtaYjVv8047AvkWv+di3WxnoasDyNs4Fw=;
        b=kppfsG53RTDF8+P5RSVPGIRz8HPbITYDO3lh19+uv1o122dp44wqxHu7pCdokhlOF8
         6yAPiukfuwIhRCAsB8I9B+XlrTUiV2b9KCLJTrnSjeIP+uGwwzYTcc4UjyJcLStRgN+S
         uatphoym8hUjkPpKteOkdIn21uqTw0rc/++PvjPzCTv0a0E94lLZVF7KqEbnVgZA95Uf
         zRMetDlnkMMjQUMQVkNjztY0Usly0owjB/7XdgE/nOOphuV4O+Y3YwgvUUJu7mj0swlD
         sKxsj8jmtlkM0CE0ac57wMSTBUuFUeP5dOb/CQtaaFFRcwKH0OdmT3qBxc45v+rva69Y
         lRdg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=TlXgrolZnHWtaYjVv8047AvkWv+di3WxnoasDyNs4Fw=;
        b=eBTZCahO7dBrZAMeoEbi+pndPhKArmFi+nLmgeycvFEUbYtJT9oSFt9VnHd0AwadGM
         SBemW1MSu0g1FaUIHh2f7Phu9/hLXoytmIth64YnAI0HSf/h1GpqoQV0Fqkwp2EBfFw0
         jDlwoDvLH33pRj9XvAZ6YM3MuV1i6j5dH2UxQTQmaHS3S6zzdPG4j5zb2QbEqWNDh5E3
         rVEymV1On6Gy8+9WrOWJxIM6meBkcPYg4ksNUTBMWAcWAhKQ3zqQXv3/IVENI7PdL7lc
         gADotHP5xJD03+GXYtcqOceP8Dh+nAfbXNmmyjBo6hZZT+wz1acZdD+UdCwK9M+L7qEM
         AwTw==
X-Gm-Message-State: AO0yUKV9NE9cKTmTd+aJZj3t3sKRlgove5cpeGzUDYusAgrn/68hn0Q7
        Rnm8dDfTA46OfNFZZnwBcMGu6rXyhENDDA==
X-Google-Smtp-Source: AK7set8mORO610AM7mSHBIiAv+4c7NXFqnPVrbcDLYXm/w9kGBFC0PrWj8aYZEmXtmaAx95CHBeHL/yyd9i81w==
X-Received: from edumazet1.c.googlers.com ([fda3:e722:ac3:cc00:2b:7d90:c0a8:395a])
 (user=edumazet job=sendgmr) by 2002:a5b:c0a:0:b0:a6f:b653:9f18 with SMTP id
 f10-20020a5b0c0a000000b00a6fb6539f18mr2994966ybq.2.1677523477618; Mon, 27 Feb
 2023 10:44:37 -0800 (PST)
Date:   Mon, 27 Feb 2023 18:44:36 +0000
Mime-Version: 1.0
X-Mailer: git-send-email 2.39.2.722.g9855ee24e9-goog
Message-ID: <20230227184436.554874-1-edumazet@google.com>
Subject: [PATCH net] net/sched: flower: fix fl_change() error recovery path
From:   Eric Dumazet <edumazet@google.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev@vger.kernel.org, eric.dumazet@gmail.com,
        Eric Dumazet <edumazet@google.com>,
        syzbot+baabf3efa7c1e57d28b2@syzkaller.appspotmail.com,
        syzbot <syzkaller@googlegroups.com>,
        Paul Blakey <paulb@nvidia.com>
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

The two "goto errout;" paths in fl_change() became wrong
after cited commit.

Indeed we only must not call __fl_put() until the net pointer
has been set in tcf_exts_init_ex()

This is a minimal fix. We might in the future validate TCA_FLOWER_FLAGS
before we allocate @fnew.

BUG: KASAN: null-ptr-deref in instrument_atomic_read include/linux/instrumented.h:72 [inline]
BUG: KASAN: null-ptr-deref in atomic_read include/linux/atomic/atomic-instrumented.h:27 [inline]
BUG: KASAN: null-ptr-deref in refcount_read include/linux/refcount.h:147 [inline]
BUG: KASAN: null-ptr-deref in __refcount_add_not_zero include/linux/refcount.h:152 [inline]
BUG: KASAN: null-ptr-deref in __refcount_inc_not_zero include/linux/refcount.h:227 [inline]
BUG: KASAN: null-ptr-deref in refcount_inc_not_zero include/linux/refcount.h:245 [inline]
BUG: KASAN: null-ptr-deref in maybe_get_net include/net/net_namespace.h:269 [inline]
BUG: KASAN: null-ptr-deref in tcf_exts_get_net include/net/pkt_cls.h:260 [inline]
BUG: KASAN: null-ptr-deref in __fl_put net/sched/cls_flower.c:513 [inline]
BUG: KASAN: null-ptr-deref in __fl_put+0x13e/0x3b0 net/sched/cls_flower.c:508
Read of size 4 at addr 000000000000014c by task syz-executor548/5082

CPU: 0 PID: 5082 Comm: syz-executor548 Not tainted 6.2.0-syzkaller-05251-g5b7c4cabbb65 #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/21/2023
Call Trace:
<TASK>
__dump_stack lib/dump_stack.c:88 [inline]
dump_stack_lvl+0xd9/0x150 lib/dump_stack.c:106
print_report mm/kasan/report.c:420 [inline]
kasan_report+0xec/0x130 mm/kasan/report.c:517
check_region_inline mm/kasan/generic.c:183 [inline]
kasan_check_range+0x141/0x190 mm/kasan/generic.c:189
instrument_atomic_read include/linux/instrumented.h:72 [inline]
atomic_read include/linux/atomic/atomic-instrumented.h:27 [inline]
refcount_read include/linux/refcount.h:147 [inline]
__refcount_add_not_zero include/linux/refcount.h:152 [inline]
__refcount_inc_not_zero include/linux/refcount.h:227 [inline]
refcount_inc_not_zero include/linux/refcount.h:245 [inline]
maybe_get_net include/net/net_namespace.h:269 [inline]
tcf_exts_get_net include/net/pkt_cls.h:260 [inline]
__fl_put net/sched/cls_flower.c:513 [inline]
__fl_put+0x13e/0x3b0 net/sched/cls_flower.c:508
fl_change+0x101b/0x4ab0 net/sched/cls_flower.c:2341
tc_new_tfilter+0x97c/0x2290 net/sched/cls_api.c:2310
rtnetlink_rcv_msg+0x996/0xd50 net/core/rtnetlink.c:6165
netlink_rcv_skb+0x165/0x440 net/netlink/af_netlink.c:2574
netlink_unicast_kernel net/netlink/af_netlink.c:1339 [inline]
netlink_unicast+0x547/0x7f0 net/netlink/af_netlink.c:1365
netlink_sendmsg+0x925/0xe30 net/netlink/af_netlink.c:1942
sock_sendmsg_nosec net/socket.c:722 [inline]
sock_sendmsg+0xde/0x190 net/socket.c:745
____sys_sendmsg+0x334/0x900 net/socket.c:2504
___sys_sendmsg+0x110/0x1b0 net/socket.c:2558
__sys_sendmmsg+0x18f/0x460 net/socket.c:2644
__do_sys_sendmmsg net/socket.c:2673 [inline]
__se_sys_sendmmsg net/socket.c:2670 [inline]
__x64_sys_sendmmsg+0x9d/0x100 net/socket.c:2670

Fixes: 08a0063df3ae ("net/sched: flower: Move filter handle initialization earlier")
Reported-by: syzbot+baabf3efa7c1e57d28b2@syzkaller.appspotmail.com
Reported-by: syzbot <syzkaller@googlegroups.com>
Signed-off-by: Eric Dumazet <edumazet@google.com>
Cc: Paul Blakey <paulb@nvidia.com>
---
 net/sched/cls_flower.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/net/sched/cls_flower.c b/net/sched/cls_flower.c
index e960a46b05205bb0bca7dc0d21531e4d6a3853e3..475fe222a85566639bac75fc4a95bf649a10357d 100644
--- a/net/sched/cls_flower.c
+++ b/net/sched/cls_flower.c
@@ -2200,8 +2200,9 @@ static int fl_change(struct net *net, struct sk_buff *in_skb,
 		fnew->flags = nla_get_u32(tb[TCA_FLOWER_FLAGS]);
 
 		if (!tc_flags_valid(fnew->flags)) {
+			kfree(fnew);
 			err = -EINVAL;
-			goto errout;
+			goto errout_tb;
 		}
 	}
 
@@ -2226,8 +2227,10 @@ static int fl_change(struct net *net, struct sk_buff *in_skb,
 		}
 		spin_unlock(&tp->lock);
 
-		if (err)
-			goto errout;
+		if (err) {
+			kfree(fnew);
+			goto errout_tb;
+		}
 	}
 	fnew->handle = handle;
 
@@ -2337,7 +2340,6 @@ static int fl_change(struct net *net, struct sk_buff *in_skb,
 	fl_mask_put(head, fnew->mask);
 errout_idr:
 	idr_remove(&head->handle_idr, fnew->handle);
-errout:
 	__fl_put(fnew);
 errout_tb:
 	kfree(tb);
-- 
2.39.2.722.g9855ee24e9-goog

