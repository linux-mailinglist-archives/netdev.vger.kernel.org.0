Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8B89F601421
	for <lists+netdev@lfdr.de>; Mon, 17 Oct 2022 18:59:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229978AbiJQQ7f (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Oct 2022 12:59:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47454 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229972AbiJQQ7d (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Oct 2022 12:59:33 -0400
Received: from mail-yw1-x1149.google.com (mail-yw1-x1149.google.com [IPv6:2607:f8b0:4864:20::1149])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D4A5B7FE
        for <netdev@vger.kernel.org>; Mon, 17 Oct 2022 09:59:31 -0700 (PDT)
Received: by mail-yw1-x1149.google.com with SMTP id 00721157ae682-355ae0f4d3dso115418557b3.14
        for <netdev@vger.kernel.org>; Mon, 17 Oct 2022 09:59:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=4QxOkCt8UevmI0RXOll26ojyMZpWAwRNJgGHeYRjXi8=;
        b=EpFOy6FzaXx/0+8yMdWXzldiWnbMmnpN03Xo+lcd/s1oJ1R9vnvQxOOWIM9ZSs052b
         ny9Ugy7xMUvWEqWTJfFzMIEUW/A4+p6rJwfiiNw0braoiGFAHKQUCVELiax7X0DjqkXR
         xAvKmB5vUn/8B0fERxQAm0n2HTFx1aTF07ZEp0SRCZ0e0QIgsZJ0cRLZ8oA8cgPEGAqi
         W2hPAy+YBs6ZEEC3M04/vV3uDua3NBAiLoT4vF15932nCdhmpILZQlOBIu3jvQL8p+aK
         +huZQlv+AYf28HnMpca4iOrL2zfHw/Ol/dm0BRD8fB7WEndBMbV+5U5+rmJXqHiSW7fd
         hrLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=4QxOkCt8UevmI0RXOll26ojyMZpWAwRNJgGHeYRjXi8=;
        b=l8oBKVohSuA38M7RUH1qCF6VIXQJks2YqSYiY2n723zViR15arA+whEzfid1jNK+lH
         K+qg150uLg3eUt8gJKA9LbmHuuB2lpKyFm/bHTAqIjvn1ah+qnXfMFE0RxvBG5nU9EgS
         54fmVH4zDs0ZsWsLYQQ0M2KkEmUPlWyQyks8W/qIXTV5v7+LVM1AlcufP+3sxg2wOg/u
         b4NkaflxY6oXlCnuLBNJ9zfmQmmi9t4wR8y0ZPwRQX17fYzBcGWzr/Eo3nXIUvXhq8if
         Uksmu256ETsT9t9FRiCtBXUAULa7yZ27qICETACraPMPUe+yl544OXEIzaB11OStP9T2
         YnoQ==
X-Gm-Message-State: ACrzQf2JIpBnSrG6OX/EZs/NlMUaSUXuL1Vw7pBP0AmSD4T/0hxWquXY
        pZLhbbhf/crmxIHPyjitqUUB2lXZibNdcA==
X-Google-Smtp-Source: AMsMyM7cP1zUenCttMWecOVYMcddpGSKDOdRf2vrQWE8i7hAnDwfyCUEsjpNZwVZ7dPEEYyV9KLwjdAff5Qx5w==
X-Received: from edumazet1.c.googlers.com ([fda3:e722:ac3:cc00:2b:7d90:c0a8:395a])
 (user=edumazet job=sendgmr) by 2002:a81:be02:0:b0:355:c386:5ff1 with SMTP id
 i2-20020a81be02000000b00355c3865ff1mr9661832ywn.285.1666025970772; Mon, 17
 Oct 2022 09:59:30 -0700 (PDT)
Date:   Mon, 17 Oct 2022 16:59:28 +0000
Mime-Version: 1.0
X-Mailer: git-send-email 2.38.0.413.g74048e4d9e-goog
Message-ID: <20221017165928.2150130-1-edumazet@google.com>
Subject: [PATCH net] net: hsr: avoid possible NULL deref in skb_clone()
From:   Eric Dumazet <edumazet@google.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     Andreas Oetken <ennoerlangen@gmail.com>,
        Juhee Kang <claudiajkang@gmail.com>,
        George McCollister <george.mccollister@gmail.com>,
        netdev@vger.kernel.org, eric.dumazet@gmail.com,
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

syzbot got a crash [1] in skb_clone(), caused by a bug
in hsr_get_untagged_frame().

When/if create_stripped_skb_hsr() returns NULL, we must
not attempt to call skb_clone().

While we are at it, replace a WARN_ONCE() by netdev_warn_once().

[1]
general protection fault, probably for non-canonical address 0xdffffc000000000f: 0000 [#1] PREEMPT SMP KASAN
KASAN: null-ptr-deref in range [0x0000000000000078-0x000000000000007f]
CPU: 1 PID: 754 Comm: syz-executor.0 Not tainted 6.0.0-syzkaller-02734-g0326074ff465 #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 09/22/2022
RIP: 0010:skb_clone+0x108/0x3c0 net/core/skbuff.c:1641
Code: 93 02 00 00 49 83 7c 24 28 00 0f 85 e9 00 00 00 e8 5d 4a 29 fa 4c 8d 75 7e 48 b8 00 00 00 00 00 fc ff df 4c 89 f2 48 c1 ea 03 <0f> b6 04 02 4c 89 f2 83 e2 07 38 d0 7f 08 84 c0 0f 85 9e 01 00 00
RSP: 0018:ffffc90003ccf4e0 EFLAGS: 00010207

RAX: dffffc0000000000 RBX: ffffc90003ccf5f8 RCX: ffffc9000c24b000
RDX: 000000000000000f RSI: ffffffff8751cb13 RDI: 0000000000000000
RBP: 0000000000000000 R08: 00000000000000f0 R09: 0000000000000140
R10: fffffbfff181d972 R11: 0000000000000000 R12: ffff888161fc3640
R13: 0000000000000a20 R14: 000000000000007e R15: ffffffff8dc5f620
FS: 00007feb621e4700(0000) GS:ffff8880b9b00000(0000) knlGS:0000000000000000
CS: 0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007feb621e3ff8 CR3: 00000001643a9000 CR4: 00000000003506e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
<TASK>
hsr_get_untagged_frame+0x4e/0x610 net/hsr/hsr_forward.c:164
hsr_forward_do net/hsr/hsr_forward.c:461 [inline]
hsr_forward_skb+0xcca/0x1d50 net/hsr/hsr_forward.c:623
hsr_handle_frame+0x588/0x7c0 net/hsr/hsr_slave.c:69
__netif_receive_skb_core+0x9fe/0x38f0 net/core/dev.c:5379
__netif_receive_skb_one_core+0xae/0x180 net/core/dev.c:5483
__netif_receive_skb+0x1f/0x1c0 net/core/dev.c:5599
netif_receive_skb_internal net/core/dev.c:5685 [inline]
netif_receive_skb+0x12f/0x8d0 net/core/dev.c:5744
tun_rx_batched+0x4ab/0x7a0 drivers/net/tun.c:1544
tun_get_user+0x2686/0x3a00 drivers/net/tun.c:1995
tun_chr_write_iter+0xdb/0x200 drivers/net/tun.c:2025
call_write_iter include/linux/fs.h:2187 [inline]
new_sync_write fs/read_write.c:491 [inline]
vfs_write+0x9e9/0xdd0 fs/read_write.c:584
ksys_write+0x127/0x250 fs/read_write.c:637
do_syscall_x64 arch/x86/entry/common.c:50 [inline]
do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
entry_SYSCALL_64_after_hwframe+0x63/0xcd

Fixes: f266a683a480 ("net/hsr: Better frame dispatch")
Reported-by: syzbot <syzkaller@googlegroups.com>
Signed-off-by: Eric Dumazet <edumazet@google.com>
---
 net/hsr/hsr_forward.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/net/hsr/hsr_forward.c b/net/hsr/hsr_forward.c
index 5bf357734b113085a3602aa53bd753d7c8140c0d..a50429a62f7442e99e6c101f9caf33df16c69faf 100644
--- a/net/hsr/hsr_forward.c
+++ b/net/hsr/hsr_forward.c
@@ -150,15 +150,15 @@ struct sk_buff *hsr_get_untagged_frame(struct hsr_frame_info *frame,
 				       struct hsr_port *port)
 {
 	if (!frame->skb_std) {
-		if (frame->skb_hsr) {
+		if (frame->skb_hsr)
 			frame->skb_std =
 				create_stripped_skb_hsr(frame->skb_hsr, frame);
-		} else {
-			/* Unexpected */
-			WARN_ONCE(1, "%s:%d: Unexpected frame received (port_src %s)\n",
-				  __FILE__, __LINE__, port->dev->name);
+		else
+			netdev_warn_once(port->dev,
+					 "Unexpected frame received in hsr_get_untagged_frame()\n");
+
+		if (!frame->skb_std)
 			return NULL;
-		}
 	}
 
 	return skb_clone(frame->skb_std, GFP_ATOMIC);
-- 
2.38.0.413.g74048e4d9e-goog

