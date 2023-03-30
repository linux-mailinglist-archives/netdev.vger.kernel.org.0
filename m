Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 28BC36D0D08
	for <lists+netdev@lfdr.de>; Thu, 30 Mar 2023 19:45:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231590AbjC3RpH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Mar 2023 13:45:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50170 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230152AbjC3RpG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Mar 2023 13:45:06 -0400
Received: from mail-yw1-x1149.google.com (mail-yw1-x1149.google.com [IPv6:2607:f8b0:4864:20::1149])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D6CC2D538
        for <netdev@vger.kernel.org>; Thu, 30 Mar 2023 10:45:04 -0700 (PDT)
Received: by mail-yw1-x1149.google.com with SMTP id 00721157ae682-545dd1a1e31so143256117b3.22
        for <netdev@vger.kernel.org>; Thu, 30 Mar 2023 10:45:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1680198304;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=w5I1Hqe9W5MhHhDJ3kyAmjkrV8YMFLZ7d+lz7YNW/Eo=;
        b=dTpv9Q2wcQIkw8oI395AvguZx5FEKJoIMFf0Gcr7R4uEhTfUXUl6to4YRGiJZ3AVP2
         0TRQPM3yA9zL4759IWw2LNJEFhoLsJTsaI7ddlhb6LBLp7hP3TsB58CLl0H9fUHRu8e+
         Sfv5LK6PrYPduRdtz3CnW08eDokZUsUseOlWdgFUgJxxmi28STMyhmJFy7oREoIKuAEi
         KQzQcAfKFo51TDrQ+ZeP59yTDET42l+q+2n8rnYX3h7rxH/nylrXIIcjinm9kCjcY8Vk
         EP3l7VOAJl9wpPRip7vefzTEcEjGXQl8jkkf8t3iMatEGtL1saHMpY95RwFJbhc5m7+0
         8qhw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680198304;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=w5I1Hqe9W5MhHhDJ3kyAmjkrV8YMFLZ7d+lz7YNW/Eo=;
        b=h6HGBM5Cv60LOb9W3ZN7sINsnBiuUfOhWmZkzoorMzyjEjHTVlP9pJYYbSC2xTYCHu
         FaJDvY+trUA9HATm9wp7pPdfhqB8URZoEuyilp+Cj2EW1nqG11iB4JgUY5h+XW7ub9p8
         RML3f3U7ft0bITb+0Ca4/x0HrmtrduJWuTOzTakO+Y4to3RTLU+fr/TO5GxBz9QpDHJr
         HcaLoRWQtAPx8Em8jBm6CVtWo60FFphMFdiW6BaWftd5I12HLzpHCLWPRSEVpuxdSHsm
         dKEcmGcDQFr7t0hgfKF+Gvm5VqzRcluuBPzLaO8UxdqtzoG6Y/HOmBvPzogpEqMAXvJC
         elPw==
X-Gm-Message-State: AAQBX9fNlwJsyHvz+OBo5hhTqJw4PbVDJrDl+2wX6ON17MT9QFafKp+Y
        j6HwWoCOvGoehYxn+fNfwjYbIDYKJxar6Q==
X-Google-Smtp-Source: AKy350Zgebmec5ecEQ9ZtanmyHbAWNQ4rg64Wb17plFa1SL5bwS8Po4BwHH+YRJkOna0YAE+jHjr/bT1CBI54w==
X-Received: from edumazet1.c.googlers.com ([fda3:e722:ac3:cc00:2b:7d90:c0a8:395a])
 (user=edumazet job=sendgmr) by 2002:a05:6902:168d:b0:b7b:f02a:919d with SMTP
 id bx13-20020a056902168d00b00b7bf02a919dmr8123553ybb.8.1680198304126; Thu, 30
 Mar 2023 10:45:04 -0700 (PDT)
Date:   Thu, 30 Mar 2023 17:45:02 +0000
Mime-Version: 1.0
X-Mailer: git-send-email 2.40.0.348.gf938b09366-goog
Message-ID: <20230330174502.1915328-1-edumazet@google.com>
Subject: [PATCH net] icmp: guard against too small mtu
From:   Eric Dumazet <edumazet@google.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     David Ahern <dsahern@kernel.org>, netdev@vger.kernel.org,
        eric.dumazet@gmail.com, Eric Dumazet <edumazet@google.com>,
        syzbot+d373d60fddbdc915e666@syzkaller.appspotmail.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-7.7 required=5.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

syzbot was able to trigger a panic [1] in icmp_glue_bits(), or
more exactly in skb_copy_and_csum_bits()

There is no repro yet, but I think the issue is that syzbot
manages to lower device mtu to a small value, fooling __icmp_send()

__icmp_send() must make sure there is enough room for the
packet to include at least the headers.

We might in the future refactor skb_copy_and_csum_bits() and its
callers to no longer crash when something bad happens.

[1] 
kernel BUG at net/core/skbuff.c:3343 !
invalid opcode: 0000 [#1] PREEMPT SMP KASAN
CPU: 0 PID: 15766 Comm: syz-executor.0 Not tainted 6.3.0-rc4-syzkaller-00039-gffe78bbd5121 #0
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.14.0-2 04/01/2014
RIP: 0010:skb_copy_and_csum_bits+0x798/0x860 net/core/skbuff.c:3343
Code: f0 c1 c8 08 41 89 c6 e9 73 ff ff ff e8 61 48 d4 f9 e9 41 fd ff ff 48 8b 7c 24 48 e8 52 48 d4 f9 e9 c3 fc ff ff e8 c8 27 84 f9 <0f> 0b 48 89 44 24 28 e8 3c 48 d4 f9 48 8b 44 24 28 e9 9d fb ff ff
RSP: 0018:ffffc90000007620 EFLAGS: 00010246
RAX: 0000000000000000 RBX: 00000000000001e8 RCX: 0000000000000100
RDX: ffff8880276f6280 RSI: ffffffff87fdd138 RDI: 0000000000000005
RBP: 0000000000000000 R08: 0000000000000005 R09: 0000000000000000
R10: 00000000000001e8 R11: 0000000000000001 R12: 000000000000003c
R13: 0000000000000000 R14: ffff888028244868 R15: 0000000000000b0e
FS: 00007fbc81f1c700(0000) GS:ffff88802ca00000(0000) knlGS:0000000000000000
CS: 0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000001b2df43000 CR3: 00000000744db000 CR4: 0000000000150ef0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
<IRQ>
icmp_glue_bits+0x7b/0x210 net/ipv4/icmp.c:353
__ip_append_data+0x1d1b/0x39f0 net/ipv4/ip_output.c:1161
ip_append_data net/ipv4/ip_output.c:1343 [inline]
ip_append_data+0x115/0x1a0 net/ipv4/ip_output.c:1322
icmp_push_reply+0xa8/0x440 net/ipv4/icmp.c:370
__icmp_send+0xb80/0x1430 net/ipv4/icmp.c:765
ipv4_send_dest_unreach net/ipv4/route.c:1239 [inline]
ipv4_link_failure+0x5a9/0x9e0 net/ipv4/route.c:1246
dst_link_failure include/net/dst.h:423 [inline]
arp_error_report+0xcb/0x1c0 net/ipv4/arp.c:296
neigh_invalidate+0x20d/0x560 net/core/neighbour.c:1079
neigh_timer_handler+0xc77/0xff0 net/core/neighbour.c:1166
call_timer_fn+0x1a0/0x580 kernel/time/timer.c:1700
expire_timers+0x29b/0x4b0 kernel/time/timer.c:1751
__run_timers kernel/time/timer.c:2022 [inline]

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Reported-by: syzbot+d373d60fddbdc915e666@syzkaller.appspotmail.com
Signed-off-by: Eric Dumazet <edumazet@google.com>
---
 net/ipv4/icmp.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/net/ipv4/icmp.c b/net/ipv4/icmp.c
index 8cebb476b3ab1833b4efe073efc57dbdfeffd21d..b8607763d113a5878181ffd17a36a3ea4261ca55 100644
--- a/net/ipv4/icmp.c
+++ b/net/ipv4/icmp.c
@@ -749,6 +749,11 @@ void __icmp_send(struct sk_buff *skb_in, int type, int code, __be32 info,
 		room = 576;
 	room -= sizeof(struct iphdr) + icmp_param.replyopts.opt.opt.optlen;
 	room -= sizeof(struct icmphdr);
+	/* Guard against tiny mtu. We need to include at least one
+	 * IP network header for this message to make any sense.
+	 */
+	if (room <= (int)sizeof(struct iphdr))
+		goto ende;
 
 	icmp_param.data_len = skb_in->len - icmp_param.offset;
 	if (icmp_param.data_len > room)
-- 
2.40.0.348.gf938b09366-goog

