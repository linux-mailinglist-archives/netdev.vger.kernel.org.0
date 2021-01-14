Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EF78F2F6A33
	for <lists+netdev@lfdr.de>; Thu, 14 Jan 2021 19:57:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729551AbhANS4g (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Jan 2021 13:56:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38026 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727134AbhANS4f (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Jan 2021 13:56:35 -0500
Received: from mail-pg1-x531.google.com (mail-pg1-x531.google.com [IPv6:2607:f8b0:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 57A00C0613C1
        for <netdev@vger.kernel.org>; Thu, 14 Jan 2021 10:55:55 -0800 (PST)
Received: by mail-pg1-x531.google.com with SMTP id g15so4379624pgu.9
        for <netdev@vger.kernel.org>; Thu, 14 Jan 2021 10:55:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=UuJZ7b4I8I2BhJ3rTZek3mieIiGlG3aAA1BcP9TCOYU=;
        b=m2RMx5xmmGjJq+xIpuPGUwc0z0RaOVMUx8PDkgmfnbdQ4lTjrSCzCT93X+XWNetzkY
         SnpFa6F3Y04eGbXxcRN5LiWRzIcwvD75v4Wu5aSUq1gdtIgnoDVgMJD1IItxTkOFh4NR
         +q87mKjq1SaLaDIttxyduCCyJaAjwkB03ukyTA+ZY4Y/oezhzDzp9QNYuDUTFYBeskpF
         ragDk9NkIXP7GjO7jkYUE/UkcHEG8ND9qWf8r4vg6rMR0m1x7dx9mIh1cSqsM+Bui4ki
         USMCg0XU/Ea0urvbFzI3PRQYjJ1+cl6lFDM2NP9ncYBVxQVz+sv1xUcJVQgdRz9DDS1R
         22NQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=UuJZ7b4I8I2BhJ3rTZek3mieIiGlG3aAA1BcP9TCOYU=;
        b=c56h9Uay6hfSc1vdGM4gzDindlUwvQhQwc1gIEpWYbOv9RhWbH6giZl/+nR3Rp8mlr
         63XQNS6QJolsdfxJbIhm47WzdREqZaaCUZNQ+kTBRBeLjIH+kTyGHFV9bm+xXCtEsS/2
         aBxNmGwokziujkdFjvM0ESEsgHAaeLshn3Z7NFXlV1C+a3EAHcTyq9rUhiln10byGN7z
         9zTKXOlJikWfzh1HoJxwVHVFQMcoidUApuAo38ybq7ZFSxXzbwJ287c8G6nwrRiwcKag
         NwaELJbf/twKHaMF/7Sm8rE6jg7+bMlw1Gk43UJpMSP2gCRaBta3ehQ3UGoSOVB9FPih
         Hrmw==
X-Gm-Message-State: AOAM530XFckmxIW3DR9wZRs+7dKnQBtScN0avy/nb9uybytS4vmL1GAV
        cvCexUsJHTJqkuDTLVYM667S5RHVjyE=
X-Google-Smtp-Source: ABdhPJxkQ8JzxbV4xaHSefN/E+EsFwxIGNiqB8XHKDZZMQJNhwvDMRyGy7o/tOea+yiq6dYkbnwUEA==
X-Received: by 2002:a05:6a00:88b:b029:19c:780e:1cd with SMTP id q11-20020a056a00088bb029019c780e01cdmr8648647pfj.64.1610650554864;
        Thu, 14 Jan 2021 10:55:54 -0800 (PST)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:7220:84ff:fe09:1424])
        by smtp.gmail.com with ESMTPSA id j17sm5671509pfh.183.2021.01.14.10.55.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 Jan 2021 10:55:54 -0800 (PST)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        syzbot <syzkaller@googlegroups.com>
Subject: [PATCH net] net_sched: avoid shift-out-of-bounds in tcindex_set_parms()
Date:   Thu, 14 Jan 2021 10:52:29 -0800
Message-Id: <20210114185229.1742255-1-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.30.0.284.gd98b1dd5eaa7-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

tc_index being 16bit wide, we need to check that TCA_TCINDEX_SHIFT
attribute is not silly.

UBSAN: shift-out-of-bounds in net/sched/cls_tcindex.c:260:29
shift exponent 255 is too large for 32-bit type 'int'
CPU: 0 PID: 8516 Comm: syz-executor228 Not tainted 5.10.0-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 __dump_stack lib/dump_stack.c:79 [inline]
 dump_stack+0x107/0x163 lib/dump_stack.c:120
 ubsan_epilogue+0xb/0x5a lib/ubsan.c:148
 __ubsan_handle_shift_out_of_bounds.cold+0xb1/0x181 lib/ubsan.c:395
 valid_perfect_hash net/sched/cls_tcindex.c:260 [inline]
 tcindex_set_parms.cold+0x1b/0x215 net/sched/cls_tcindex.c:425
 tcindex_change+0x232/0x340 net/sched/cls_tcindex.c:546
 tc_new_tfilter+0x13fb/0x21b0 net/sched/cls_api.c:2127
 rtnetlink_rcv_msg+0x8b6/0xb80 net/core/rtnetlink.c:5555
 netlink_rcv_skb+0x153/0x420 net/netlink/af_netlink.c:2494
 netlink_unicast_kernel net/netlink/af_netlink.c:1304 [inline]
 netlink_unicast+0x533/0x7d0 net/netlink/af_netlink.c:1330
 netlink_sendmsg+0x907/0xe40 net/netlink/af_netlink.c:1919
 sock_sendmsg_nosec net/socket.c:652 [inline]
 sock_sendmsg+0xcf/0x120 net/socket.c:672
 ____sys_sendmsg+0x6e8/0x810 net/socket.c:2336
 ___sys_sendmsg+0xf3/0x170 net/socket.c:2390
 __sys_sendmsg+0xe5/0x1b0 net/socket.c:2423
 do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
 entry_SYSCALL_64_after_hwframe+0x44/0xa9

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Reported-by: syzbot <syzkaller@googlegroups.com>
---
 net/sched/cls_tcindex.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/net/sched/cls_tcindex.c b/net/sched/cls_tcindex.c
index 78bec347b8b66f660e620dd715d0eb68f9bcd2d3..c4007b9cd16d6a200d943e3e0536d6b20022ba77 100644
--- a/net/sched/cls_tcindex.c
+++ b/net/sched/cls_tcindex.c
@@ -366,9 +366,13 @@ tcindex_set_parms(struct net *net, struct tcf_proto *tp, unsigned long base,
 	if (tb[TCA_TCINDEX_MASK])
 		cp->mask = nla_get_u16(tb[TCA_TCINDEX_MASK]);
 
-	if (tb[TCA_TCINDEX_SHIFT])
+	if (tb[TCA_TCINDEX_SHIFT]) {
 		cp->shift = nla_get_u32(tb[TCA_TCINDEX_SHIFT]);
-
+		if (cp->shift > 16) {
+			err = -EINVAL;
+			goto errout;
+		}
+	}
 	if (!cp->hash) {
 		/* Hash not specified, use perfect hash if the upper limit
 		 * of the hashing index is below the threshold.
-- 
2.30.0.284.gd98b1dd5eaa7-goog

