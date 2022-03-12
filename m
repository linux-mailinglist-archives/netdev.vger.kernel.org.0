Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E70154D7191
	for <lists+netdev@lfdr.de>; Sun, 13 Mar 2022 00:31:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232696AbiCLXbK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 12 Mar 2022 18:31:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53038 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231414AbiCLXbK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 12 Mar 2022 18:31:10 -0500
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DBF841107F5
        for <netdev@vger.kernel.org>; Sat, 12 Mar 2022 15:30:03 -0800 (PST)
Received: by mail-pj1-x102b.google.com with SMTP id bx5so11254168pjb.3
        for <netdev@vger.kernel.org>; Sat, 12 Mar 2022 15:30:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=5d7DXLW3IXogIpgE/AkI/kqyxrtjXvyUzCAPkSQyof8=;
        b=BtrnyRzGbfSkQdCBGoK+hjLqS76Usxk7SYGa0Xdc12F+anlO0a4r8oWyZ8WeK0lLbO
         bCv3763UiKGo82uxoq8O8tvqGa7scSTCd5huZmnkGzENmxLXatgjGkx/ZQT864yg+cx6
         NeNtX7SN2UHGmdTtGqc2qPmWhQuJIlhLMGGqU2coS9qAyunzhgUphHPCSPvE1A6ss5S+
         uJLO/ZdVqtKlj7cmwgwBBqiWvVVgdA5JCV5KYI2yK7qNaXXjLlvaO80LPGlOAai/ImUH
         rsZgM/4//N37J2c2EiAY0sKuUyEdQfKOkcqG1djVA8+Bt+fSZ4py45kBT9X29DG6gEnu
         X45g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=5d7DXLW3IXogIpgE/AkI/kqyxrtjXvyUzCAPkSQyof8=;
        b=mBQPYuRY1MXjWjXt8UBWM/jTJRj6p+y8G73w8yW3VnCTFpoBOHl6ZMFImlGTwm+5md
         UrmfL1q53CFeYfLM5QzFfG4RAT2IO2Z51A6HBgWdwpeEsbR6RPsIOSJh+CAVubEEQa1b
         uERzSL5/27obpSIgTs1dcvF49v4WS5Mw/V8/4RG2+yMd5yvmTGHC/vPoJ6uYubG2muJU
         G5/B5ebfGeSx2uJfmQEVP4JG5weeFTruHcfQkcg2NLqkpraX5tack9Ok8IXyR9DkBVxC
         BRNyuNpsuQxb50l5CEZh5wOdmhIKnHQJfajAXkrdeENx2ue+uLEpkzPuypLsCcyB6cfh
         qF8Q==
X-Gm-Message-State: AOAM532encYTOhTH+ErSD+dFXNgy6DfCVj/+NZ+GBmCtmsOKUl95mbyb
        yW/yWxryaySFqBZyY0Htj7I=
X-Google-Smtp-Source: ABdhPJxET7FMca1LjaSX92aGmKRX7fde09XSa4QcFq49L1CHRyXi1tIWza5Ap55KzLKThDRRTPnKDg==
X-Received: by 2002:a17:903:291:b0:14d:522c:fe3d with SMTP id j17-20020a170903029100b0014d522cfe3dmr17217287plr.100.1647127803342;
        Sat, 12 Mar 2022 15:30:03 -0800 (PST)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:7661:178d:4650:697])
        by smtp.gmail.com with ESMTPSA id t9-20020a056a0021c900b004f7b425211bsm1817513pfj.36.2022.03.12.15.30.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 12 Mar 2022 15:30:03 -0800 (PST)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        syzbot <syzkaller@googlegroups.com>
Subject: [PATCH net] net/packet: fix slab-out-of-bounds access in packet_recvmsg()
Date:   Sat, 12 Mar 2022 15:29:58 -0800
Message-Id: <20220312232958.3535620-1-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.35.1.723.g4982287a31-goog
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

syzbot found that when an AF_PACKET socket is using PACKET_COPY_THRESH
and mmap operations, tpacket_rcv() is queueing skbs with
garbage in skb->cb[], triggering a too big copy [1]

Presumably, users of af_packet using mmap() already gets correct
metadata from the mapped buffer, we can simply make sure
to clear 12 bytes that might be copied to user space later.

BUG: KASAN: stack-out-of-bounds in memcpy include/linux/fortify-string.h:225 [inline]
BUG: KASAN: stack-out-of-bounds in packet_recvmsg+0x56c/0x1150 net/packet/af_packet.c:3489
Write of size 165 at addr ffffc9000385fb78 by task syz-executor233/3631

CPU: 0 PID: 3631 Comm: syz-executor233 Not tainted 5.17.0-rc7-syzkaller-02396-g0b3660695e80 #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 <TASK>
 __dump_stack lib/dump_stack.c:88 [inline]
 dump_stack_lvl+0xcd/0x134 lib/dump_stack.c:106
 print_address_description.constprop.0.cold+0xf/0x336 mm/kasan/report.c:255
 __kasan_report mm/kasan/report.c:442 [inline]
 kasan_report.cold+0x83/0xdf mm/kasan/report.c:459
 check_region_inline mm/kasan/generic.c:183 [inline]
 kasan_check_range+0x13d/0x180 mm/kasan/generic.c:189
 memcpy+0x39/0x60 mm/kasan/shadow.c:66
 memcpy include/linux/fortify-string.h:225 [inline]
 packet_recvmsg+0x56c/0x1150 net/packet/af_packet.c:3489
 sock_recvmsg_nosec net/socket.c:948 [inline]
 sock_recvmsg net/socket.c:966 [inline]
 sock_recvmsg net/socket.c:962 [inline]
 ____sys_recvmsg+0x2c4/0x600 net/socket.c:2632
 ___sys_recvmsg+0x127/0x200 net/socket.c:2674
 __sys_recvmsg+0xe2/0x1a0 net/socket.c:2704
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x44/0xae
RIP: 0033:0x7fdfd5954c29
Code: 28 00 00 00 75 05 48 83 c4 28 c3 e8 41 15 00 00 90 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 c0 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007ffcf8e71e48 EFLAGS: 00000246 ORIG_RAX: 000000000000002f
RAX: ffffffffffffffda RBX: 0000000000000003 RCX: 00007fdfd5954c29
RDX: 0000000000000000 RSI: 0000000020000500 RDI: 0000000000000005
RBP: 0000000000000000 R08: 000000000000000d R09: 000000000000000d
R10: 0000000000000000 R11: 0000000000000246 R12: 00007ffcf8e71e60
R13: 00000000000f4240 R14: 000000000000c1ff R15: 00007ffcf8e71e54
 </TASK>

addr ffffc9000385fb78 is located in stack of task syz-executor233/3631 at offset 32 in frame:
 ____sys_recvmsg+0x0/0x600 include/linux/uio.h:246

this frame has 1 object:
 [32, 160) 'addr'

Memory state around the buggy address:
 ffffc9000385fa80: 00 04 f3 f3 f3 f3 f3 00 00 00 00 00 00 00 00 00
 ffffc9000385fb00: 00 00 00 00 00 00 00 00 00 00 00 f1 f1 f1 f1 00
>ffffc9000385fb80: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 f3
                                                                ^
 ffffc9000385fc00: f3 f3 f3 00 00 00 00 00 00 00 00 00 00 00 00 f1
 ffffc9000385fc80: f1 f1 f1 00 f2 f2 f2 00 f2 f2 f2 00 00 00 00 00
==================================================================

Fixes: 0fb375fb9b93 ("[AF_PACKET]: Allow for > 8 byte hardware addresses.")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Reported-by: syzbot <syzkaller@googlegroups.com>
---
 net/packet/af_packet.c | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/net/packet/af_packet.c b/net/packet/af_packet.c
index 1b93ce1a5600d73284ccb2a2de6c6dbdd9e8dd3c..c39c09899fd0e1c5e7572eda554752e76c481aff 100644
--- a/net/packet/af_packet.c
+++ b/net/packet/af_packet.c
@@ -2318,8 +2318,11 @@ static int tpacket_rcv(struct sk_buff *skb, struct net_device *dev,
 					copy_skb = skb_get(skb);
 					skb_head = skb->data;
 				}
-				if (copy_skb)
+				if (copy_skb) {
+					memset(&PACKET_SKB_CB(copy_skb)->sa.ll, 0,
+					       sizeof(PACKET_SKB_CB(copy_skb)->sa.ll));
 					skb_set_owner_r(copy_skb, sk);
+				}
 			}
 			snaplen = po->rx_ring.frame_size - macoff;
 			if ((int)snaplen < 0) {
@@ -3464,6 +3467,8 @@ static int packet_recvmsg(struct socket *sock, struct msghdr *msg, size_t len,
 	sock_recv_ts_and_drops(msg, sk, skb);
 
 	if (msg->msg_name) {
+		const size_t max_len = min(sizeof(skb->cb),
+					   sizeof(struct sockaddr_storage));
 		int copy_len;
 
 		/* If the address length field is there to be filled
@@ -3486,6 +3491,10 @@ static int packet_recvmsg(struct socket *sock, struct msghdr *msg, size_t len,
 				msg->msg_namelen = sizeof(struct sockaddr_ll);
 			}
 		}
+		if (WARN_ON_ONCE(copy_len > max_len)) {
+			copy_len = max_len;
+			msg->msg_namelen = copy_len;
+		}
 		memcpy(msg->msg_name, &PACKET_SKB_CB(skb)->sa, copy_len);
 	}
 
-- 
2.35.1.723.g4982287a31-goog

