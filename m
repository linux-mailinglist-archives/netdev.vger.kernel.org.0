Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B8BDF6C1C19
	for <lists+netdev@lfdr.de>; Mon, 20 Mar 2023 17:40:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231365AbjCTQkP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Mar 2023 12:40:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54242 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232199AbjCTQjU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Mar 2023 12:39:20 -0400
Received: from mail-yw1-x1149.google.com (mail-yw1-x1149.google.com [IPv6:2607:f8b0:4864:20::1149])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 95F79DBFC
        for <netdev@vger.kernel.org>; Mon, 20 Mar 2023 09:34:30 -0700 (PDT)
Received: by mail-yw1-x1149.google.com with SMTP id 00721157ae682-536d63d17dbso129032617b3.22
        for <netdev@vger.kernel.org>; Mon, 20 Mar 2023 09:34:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1679330069;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=WhwQb3FqbB+GNntG4m3i6zBlG0QQdRZQm0S93SY2ywY=;
        b=ILJZoDNtUCg317SY/gpRdynZYPnVyzJXJ2+/yoRcw8b+nrOIHe32xvPhHCDbFXh4wb
         RYq8jJLdYDvmg5YmjnwxFl+vCND2wB0BFSWbTQg0xI6SUlPkHQqfmgM74vepuooAnHlb
         1lIptfal5Q3S54TgU+Q7LMG9qqj8aOkzlejGhbj/Rynyf+W7kHBOGXSNFP1t+ZYOiW52
         /ITGOx/q1EXRTOP2MyN/mtsxjRlnga4UYoygautmVEoIfmfMwcP65s+ezUPOOBm1wTsB
         Rikk1jF6FNKsMbioosaiCc2UD5nC8REo33d3jrZazlm0Tn/w/5XiW6hCPaQ3TUOm90Aj
         XqxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679330069;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=WhwQb3FqbB+GNntG4m3i6zBlG0QQdRZQm0S93SY2ywY=;
        b=lsvlovYYuERCYreZhELbEC3cP5NfzEoIod4LyauuTKIdSZZMSz/kWKGKMjlb2dfhi7
         Cl9xp+d5YzWqLq3983YRhHH15DzxfSStV14szal6VYKaYIccWLSBO+Dvj8BfGYrKp0PS
         8STA2MRlGjcqtBl/zOJEHjUvxClIgEGPvxdGfTv9BQ/OqdpVz9/GbFRGBVw2HlQNpd7I
         c2QbrhqPMfp2wHOreeqV9T6sfWzoz/TdTF3DznG7buA0ZXVGway5taOU9vYgyJvfUhmc
         onRjsLzocVvOFCEZgMSqoCrvSao7Sn8L58VMrf6/te+nAf+CGp1QfXD/+mHX+0/Y7qoA
         CazA==
X-Gm-Message-State: AO0yUKXOKCeSecJ52TDPv8yIxMXQvRaD2rmb/aXzoJYf7BM2vrmuSM6m
        SkA2+UFHe8q0mOR9X+li97OnF2OdvC3THw==
X-Google-Smtp-Source: AK7set+8/LqTQFaGBQ+s9HN2vww+0R+XCxiymGLIUye8k/SQAnmESaXkObJM38ezV6rEFrPqivhK7v+qqmUXlw==
X-Received: from edumazet1.c.googlers.com ([fda3:e722:ac3:cc00:2b:7d90:c0a8:395a])
 (user=edumazet job=sendgmr) by 2002:a05:6902:1249:b0:b6c:f26c:e5ab with SMTP
 id t9-20020a056902124900b00b6cf26ce5abmr2063477ybu.3.1679330069647; Mon, 20
 Mar 2023 09:34:29 -0700 (PDT)
Date:   Mon, 20 Mar 2023 16:34:27 +0000
Mime-Version: 1.0
X-Mailer: git-send-email 2.40.0.rc2.332.ga46443480c-goog
Message-ID: <20230320163427.8096-1-edumazet@google.com>
Subject: [PATCH net] erspan: do not use skb_mac_header() in ndo_start_xmit()
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

Drivers should not assume skb_mac_header(skb) == skb->data in their
ndo_start_xmit().

Use skb_network_offset() and skb_transport_offset() which
better describe what is needed in erspan_fb_xmit() and
ip6erspan_tunnel_xmit()

syzbot reported:
WARNING: CPU: 0 PID: 5083 at include/linux/skbuff.h:2873 skb_mac_header include/linux/skbuff.h:2873 [inline]
WARNING: CPU: 0 PID: 5083 at include/linux/skbuff.h:2873 ip6erspan_tunnel_xmit+0x1d9c/0x2d90 net/ipv6/ip6_gre.c:962
Modules linked in:
CPU: 0 PID: 5083 Comm: syz-executor406 Not tainted 6.3.0-rc2-syzkaller-00866-gd4671cb96fa3 #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 03/02/2023
RIP: 0010:skb_mac_header include/linux/skbuff.h:2873 [inline]
RIP: 0010:ip6erspan_tunnel_xmit+0x1d9c/0x2d90 net/ipv6/ip6_gre.c:962
Code: 04 02 41 01 de 84 c0 74 08 3c 03 0f 8e 1c 0a 00 00 45 89 b4 24 c8 00 00 00 c6 85 77 fe ff ff 01 e9 33 e7 ff ff e8 b4 27 a1 f8 <0f> 0b e9 b6 e7 ff ff e8 a8 27 a1 f8 49 8d bf f0 0c 00 00 48 b8 00
RSP: 0018:ffffc90003b2f830 EFLAGS: 00010293
RAX: 0000000000000000 RBX: 000000000000ffff RCX: 0000000000000000
RDX: ffff888021273a80 RSI: ffffffff88e1bd4c RDI: 0000000000000003
RBP: ffffc90003b2f9d8 R08: 0000000000000003 R09: 000000000000ffff
R10: 000000000000ffff R11: 0000000000000000 R12: ffff88802b28da00
R13: 00000000000000d0 R14: ffff88807e25b6d0 R15: ffff888023408000
FS: 0000555556a61300(0000) GS:ffff8880b9800000(0000) knlGS:0000000000000000
CS: 0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 000055e5b11eb6e8 CR3: 0000000027c1b000 CR4: 00000000003506f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
<TASK>
__netdev_start_xmit include/linux/netdevice.h:4900 [inline]
netdev_start_xmit include/linux/netdevice.h:4914 [inline]
__dev_direct_xmit+0x504/0x730 net/core/dev.c:4300
dev_direct_xmit include/linux/netdevice.h:3088 [inline]
packet_xmit+0x20a/0x390 net/packet/af_packet.c:285
packet_snd net/packet/af_packet.c:3075 [inline]
packet_sendmsg+0x31a0/0x5150 net/packet/af_packet.c:3107
sock_sendmsg_nosec net/socket.c:724 [inline]
sock_sendmsg+0xde/0x190 net/socket.c:747
__sys_sendto+0x23a/0x340 net/socket.c:2142
__do_sys_sendto net/socket.c:2154 [inline]
__se_sys_sendto net/socket.c:2150 [inline]
__x64_sys_sendto+0xe1/0x1b0 net/socket.c:2150
do_syscall_x64 arch/x86/entry/common.c:50 [inline]
do_syscall_64+0x39/0xb0 arch/x86/entry/common.c:80
entry_SYSCALL_64_after_hwframe+0x63/0xcd
RIP: 0033:0x7f123aaa1039
Code: 28 00 00 00 75 05 48 83 c4 28 c3 e8 b1 14 00 00 90 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 c0 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007ffc15d12058 EFLAGS: 00000246 ORIG_RAX: 000000000000002c
RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 00007f123aaa1039
RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000003
RBP: 0000000000000000 R08: 0000000020000040 R09: 0000000000000014
R10: 0000000000000000 R11: 0000000000000246 R12: 00007f123aa648c0
R13: 431bde82d7b634db R14: 0000000000000000 R15: 0000000000000000

Fixes: 1baf5ebf8954 ("erspan: auto detect truncated packets.")
Reported-by: syzbot <syzkaller@googlegroups.com>
Signed-off-by: Eric Dumazet <edumazet@google.com>
---
 net/ipv4/ip_gre.c  | 4 ++--
 net/ipv6/ip6_gre.c | 4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/net/ipv4/ip_gre.c b/net/ipv4/ip_gre.c
index ffff46cdcb58f9b5b4c210a548d685d8f0c7716a..e55a202649608f6f3c814e143581d631ce0467e6 100644
--- a/net/ipv4/ip_gre.c
+++ b/net/ipv4/ip_gre.c
@@ -552,7 +552,7 @@ static void erspan_fb_xmit(struct sk_buff *skb, struct net_device *dev)
 		truncate = true;
 	}
 
-	nhoff = skb_network_header(skb) - skb_mac_header(skb);
+	nhoff = skb_network_offset(skb);
 	if (skb->protocol == htons(ETH_P_IP) &&
 	    (ntohs(ip_hdr(skb)->tot_len) > skb->len - nhoff))
 		truncate = true;
@@ -561,7 +561,7 @@ static void erspan_fb_xmit(struct sk_buff *skb, struct net_device *dev)
 		int thoff;
 
 		if (skb_transport_header_was_set(skb))
-			thoff = skb_transport_header(skb) - skb_mac_header(skb);
+			thoff = skb_transport_offset(skb);
 		else
 			thoff = nhoff + sizeof(struct ipv6hdr);
 		if (ntohs(ipv6_hdr(skb)->payload_len) > skb->len - thoff)
diff --git a/net/ipv6/ip6_gre.c b/net/ipv6/ip6_gre.c
index 89f5f0f3f5d65b6aac0dae2302d8a5607a492155..a4ecfc9d25930967a6af7bd9de9aa52bfd08730d 100644
--- a/net/ipv6/ip6_gre.c
+++ b/net/ipv6/ip6_gre.c
@@ -959,7 +959,7 @@ static netdev_tx_t ip6erspan_tunnel_xmit(struct sk_buff *skb,
 		truncate = true;
 	}
 
-	nhoff = skb_network_header(skb) - skb_mac_header(skb);
+	nhoff = skb_network_offset(skb);
 	if (skb->protocol == htons(ETH_P_IP) &&
 	    (ntohs(ip_hdr(skb)->tot_len) > skb->len - nhoff))
 		truncate = true;
@@ -968,7 +968,7 @@ static netdev_tx_t ip6erspan_tunnel_xmit(struct sk_buff *skb,
 		int thoff;
 
 		if (skb_transport_header_was_set(skb))
-			thoff = skb_transport_header(skb) - skb_mac_header(skb);
+			thoff = skb_transport_offset(skb);
 		else
 			thoff = nhoff + sizeof(struct ipv6hdr);
 		if (ntohs(ipv6_hdr(skb)->payload_len) > skb->len - thoff)
-- 
2.40.0.rc2.332.ga46443480c-goog

