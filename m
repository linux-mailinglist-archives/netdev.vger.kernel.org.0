Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C6CC953BC53
	for <lists+netdev@lfdr.de>; Thu,  2 Jun 2022 18:19:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236857AbiFBQTO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Jun 2022 12:19:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57940 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236933AbiFBQTN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Jun 2022 12:19:13 -0400
Received: from mail-pg1-x535.google.com (mail-pg1-x535.google.com [IPv6:2607:f8b0:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C49D92AD989
        for <netdev@vger.kernel.org>; Thu,  2 Jun 2022 09:19:08 -0700 (PDT)
Received: by mail-pg1-x535.google.com with SMTP id y187so5164806pgd.3
        for <netdev@vger.kernel.org>; Thu, 02 Jun 2022 09:19:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=+Dk/Dt5SZeV5tf4KA0Zng3rYDhsewVJ5+4RxLwbLLAY=;
        b=fd6B7b6Su7gUBL8c92Y6AhGbbDVknyetkbp/psQjp5KLTubOUKeiEBgDxQ4/QptKQt
         nGoS2qQSqhoZetX5nFmSKUxvkbv7kz7QcSvd4ed429K0KMwcrHOzVzAEwF6mXcwO4QpR
         SWr8IwULm7Rn5ulJkT0K4JoEvAwvay4szkl9RZ8AJWcL9n45M7TFh3fqW8xwzR3M+tx+
         nKzuSYwt39lxmvmi8Nu00dMFaqGsDMiVgUUZQUrKhW1TwtSKk96loESXz4T+kdN3zJKB
         gY+Sh28rM0QYvxXypD1Aa7bgbj9DfZGsWfTOclMEx2dcdiLjt8Q858yxlUJVP9wI0jqj
         fvvg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=+Dk/Dt5SZeV5tf4KA0Zng3rYDhsewVJ5+4RxLwbLLAY=;
        b=hoPvQ0RXsHQ4EBH8ZGu7kWAGYEvkMFBKmqmTuJSvTeZpf7ZO/fv8YtfXEJytf0Bc9k
         CnF7hWzwqOJ6mY+SRDBDYWn0jCWyLHaVGrdXYQmEqKLaTP2vJtB8yNNshzbJXZ+QW0dT
         xF80Jl9Uj0iqLc9dwG2O+nsYh+PDvEIRKDev0xDjG7s7clSlfNcEhl8ZnOgzaofgxa6U
         SW9t5n8BpV8iAs2ZCveGTPX+0oB1yeBArFBmumqzm6GzvhDA1A3KT4Mlm5dVfsMosv4o
         Gsyoua7P5kjkO+mXgEbWJoKNvyqoCVw4BqIOUwogVFskEo0C0GeqKh+7DhP3CMzOHBRf
         KvDw==
X-Gm-Message-State: AOAM531Y9v24p8yB0wPPRbCIR5FLWDAA+DIWv80BhvOkreYWf5PDt6NW
        5IY8n/L6WQ89JEKuuWzeigQ=
X-Google-Smtp-Source: ABdhPJwblayCL2HqA0ypV6hX9mzH9ntZq5KFP37TuyJnf8meQfNPF155zduslYvcpZ7gX1RPwYAzOw==
X-Received: by 2002:a05:6a00:1146:b0:4c9:ede0:725a with SMTP id b6-20020a056a00114600b004c9ede0725amr5887763pfm.35.1654186748185;
        Thu, 02 Jun 2022 09:19:08 -0700 (PDT)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:1ff3:6bf6:224:48f2])
        by smtp.gmail.com with ESMTPSA id u25-20020a62ed19000000b00518895f0dabsm3751072pfh.59.2022.06.02.09.19.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Jun 2022 09:19:07 -0700 (PDT)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev <netdev@vger.kernel.org>,
        Willem de Bruijn <willemb@google.com>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        syzbot <syzkaller@googlegroups.com>,
        Hangbin Liu <liuhangbin@gmail.com>,
        "Michael S . Tsirkin" <mst@redhat.com>
Subject: [PATCH v2 net 3/3] net/af_packet: make sure to pull mac header
Date:   Thu,  2 Jun 2022 09:18:59 -0700
Message-Id: <20220602161859.2546399-4-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.36.1.255.ge46751e96f-goog
In-Reply-To: <20220602161859.2546399-1-eric.dumazet@gmail.com>
References: <20220602161859.2546399-1-eric.dumazet@gmail.com>
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

GSO assumes skb->head contains link layer headers.

tun device in some case can provide base 14 bytes,
regardless of VLAN being used or not.

After blamed commit, we can end up setting a network
header offset of 18+, we better pull the missing
bytes to avoid a posible crash in GSO.

syzbot report was:
kernel BUG at include/linux/skbuff.h:2699!
invalid opcode: 0000 [#1] PREEMPT SMP KASAN
CPU: 1 PID: 3601 Comm: syz-executor210 Not tainted 5.18.0-syzkaller-11338-g2c5ca23f7414 #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
RIP: 0010:__skb_pull include/linux/skbuff.h:2699 [inline]
RIP: 0010:skb_mac_gso_segment+0x48f/0x530 net/core/gro.c:136
Code: 00 48 c7 c7 00 96 d4 8a c6 05 cb d3 45 06 01 e8 26 bb d0 01 e9 2f fd ff ff 49 c7 c4 ea ff ff ff e9 f1 fe ff ff e8 91 84 19 fa <0f> 0b 48 89 df e8 97 44 66 fa e9 7f fd ff ff e8 ad 44 66 fa e9 48
RSP: 0018:ffffc90002e2f4b8 EFLAGS: 00010293
RAX: 0000000000000000 RBX: 0000000000000012 RCX: 0000000000000000
RDX: ffff88805bb58000 RSI: ffffffff8760ed0f RDI: 0000000000000004
RBP: 0000000000005dbc R08: 0000000000000004 R09: 0000000000000fe0
R10: 0000000000000fe4 R11: 0000000000000000 R12: 0000000000000fe0
R13: ffff88807194d780 R14: 1ffff920005c5e9b R15: 0000000000000012
FS:  000055555730f300(0000) GS:ffff8880b9d00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00000000200015c0 CR3: 0000000071ff8000 CR4: 0000000000350ee0
Call Trace:
 <TASK>
 __skb_gso_segment+0x327/0x6e0 net/core/dev.c:3411
 skb_gso_segment include/linux/netdevice.h:4749 [inline]
 validate_xmit_skb+0x6bc/0xf10 net/core/dev.c:3669
 validate_xmit_skb_list+0xbc/0x120 net/core/dev.c:3719
 sch_direct_xmit+0x3d1/0xbe0 net/sched/sch_generic.c:327
 __dev_xmit_skb net/core/dev.c:3815 [inline]
 __dev_queue_xmit+0x14a1/0x3a00 net/core/dev.c:4219
 packet_snd net/packet/af_packet.c:3071 [inline]
 packet_sendmsg+0x21cb/0x5550 net/packet/af_packet.c:3102
 sock_sendmsg_nosec net/socket.c:714 [inline]
 sock_sendmsg+0xcf/0x120 net/socket.c:734
 ____sys_sendmsg+0x6eb/0x810 net/socket.c:2492
 ___sys_sendmsg+0xf3/0x170 net/socket.c:2546
 __sys_sendmsg net/socket.c:2575 [inline]
 __do_sys_sendmsg net/socket.c:2584 [inline]
 __se_sys_sendmsg net/socket.c:2582 [inline]
 __x64_sys_sendmsg+0x132/0x220 net/socket.c:2582
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x46/0xb0
RIP: 0033:0x7f4b95da06c9
Code: 28 c3 e8 4a 15 00 00 66 2e 0f 1f 84 00 00 00 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 c0 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007ffd7defc4c8 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
RAX: ffffffffffffffda RBX: 00007ffd7defc4f0 RCX: 00007f4b95da06c9
RDX: 0000000000000000 RSI: 0000000020000140 RDI: 0000000000000003
RBP: 0000000000000003 R08: bb1414ac00000050 R09: bb1414ac00000050
R10: 0000000000000004 R11: 0000000000000246 R12: 0000000000000000
R13: 00007ffd7defc4e0 R14: 00007ffd7defc4d8 R15: 00007ffd7defc4d4
 </TASK>

Fixes: dfed913e8b55 ("net/af_packet: add VLAN support for AF_PACKET SOCK_RAW GSO")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Reported-by: syzbot <syzkaller@googlegroups.com>
Acked-by: Hangbin Liu <liuhangbin@gmail.com>
Acked-by: Willem de Bruijn <willemb@google.com>
Cc: Michael S. Tsirkin <mst@redhat.com>
---
 net/packet/af_packet.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/net/packet/af_packet.c b/net/packet/af_packet.c
index 677f9cfa9660816a160a11bfa4c291431412005f..ca6e92a229239f9093900bf9249396cf0d410104 100644
--- a/net/packet/af_packet.c
+++ b/net/packet/af_packet.c
@@ -1935,8 +1935,10 @@ static void packet_parse_headers(struct sk_buff *skb, struct socket *sock)
 	/* Move network header to the right position for VLAN tagged packets */
 	if (likely(skb->dev->type == ARPHRD_ETHER) &&
 	    eth_type_vlan(skb->protocol) &&
-	    __vlan_get_protocol(skb, skb->protocol, &depth) != 0)
-		skb_set_network_header(skb, depth);
+	    __vlan_get_protocol(skb, skb->protocol, &depth) != 0) {
+		if (pskb_may_pull(skb, depth))
+			skb_set_network_header(skb, depth);
+	}
 
 	skb_probe_transport_header(skb);
 }
-- 
2.36.1.255.ge46751e96f-goog

