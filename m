Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A2E256472B
	for <lists+netdev@lfdr.de>; Wed, 10 Jul 2019 15:40:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727627AbfGJNkV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Jul 2019 09:40:21 -0400
Received: from mail-vk1-f202.google.com ([209.85.221.202]:49144 "EHLO
        mail-vk1-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726080AbfGJNkV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Jul 2019 09:40:21 -0400
Received: by mail-vk1-f202.google.com with SMTP id f184so1037312vkd.15
        for <netdev@vger.kernel.org>; Wed, 10 Jul 2019 06:40:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=sWNQV8EzHYlsVIIy/bLdc0fwuJnJIg+j+AHcE+ofiXw=;
        b=Td7S4Xt8u8zPgolaIIniLnTVLTo3DTiaI34mpKqZac51fybarT8G0wT7WbpCeZyWRN
         fvQY1/BjexABXPWxBPh/F58OzdmKBUFE3+SbSQLrEgn1LfsYi7Eg5Xqr4TJ3XVTXzyge
         KRMxpDRD8S8zhJiKeQZq2LyY4TQaFoCUfeJcWYcIpZ8TGFAnNcU7AaEUce9kpd5T6OS6
         XIBG9Ydx4HkLd2F8BnTmzdpUObwwkIl/D7n/Hja/JyV8NRQ8DFXBFyQTXphYxaciaAHA
         rGUNI4SntsSTZzSwEm16bdpogpaeuThuwpqpOtib4eUMXtcOUaHhejtwV3BiLJRjWSGz
         CU8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=sWNQV8EzHYlsVIIy/bLdc0fwuJnJIg+j+AHcE+ofiXw=;
        b=QPNtR6h8G/ZzIV24KwHJMtv64+l5sNr0ELL13VRA1ZV47KHLiP9tXwQQ0Yi3Rdw1tD
         WE08sUtCxKg6yjKz/PQHJdY0MczhoKDSw1K8Xm4J3gIQUyXiRdj/K2fH1k964Zp+Nc4v
         M5i0ZYGLJHgCds+ZhH7dyNFopCDJPe4zYToOdhcyt+NqjOh8WCwZA04cm+AksT/KUUSM
         aB5+XSfjGDbRwsF3r4Z7I7dkhqhtTxL6CZHU96Ua+uDTpibC1BtViNMoCAxyAPhb6AEb
         H8i4asNHGmazoWA2wmpi8wuU8aA6brmuSNBNj9JVS8efreHUCAmQZr+c+LsWs/90GM0z
         R23w==
X-Gm-Message-State: APjAAAU6ORjXgxC8Eb1buXek4nNrd3kFLCoUsQEpzMCjuh/MnfeYuJ4y
        9YGxWhzhVw48DKQWqY67elsaOvbC+1dDCQ==
X-Google-Smtp-Source: APXvYqwCKnlmSFD7gAokfkPT+8aNqk1ZpzCJUNyajGPAhzZXWpkTophW2sY2UK1Rxp0qwv6Uj5tVFh6e4bjP3g==
X-Received: by 2002:ab0:2650:: with SMTP id q16mr17608714uao.7.1562766019866;
 Wed, 10 Jul 2019 06:40:19 -0700 (PDT)
Date:   Wed, 10 Jul 2019 06:40:10 -0700
In-Reply-To: <20190710134011.221210-1-edumazet@google.com>
Message-Id: <20190710134011.221210-2-edumazet@google.com>
Mime-Version: 1.0
References: <20190710134011.221210-1-edumazet@google.com>
X-Mailer: git-send-email 2.22.0.410.gd8fdbe21b5-goog
Subject: [PATCH net] ipv6: fix potential crash in ip6_datagram_dst_update()
From:   Eric Dumazet <edumazet@google.com>
To:     "David S . Miller" <davem@davemloft.net>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Willem de Bruijn <willemb@google.com>,
        syzbot <syzkaller@googlegroups.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Willem forgot to change one of the calls to fl6_sock_lookup(),
which can now return an error or NULL.

syzbot reported :

kasan: CONFIG_KASAN_INLINE enabled
kasan: GPF could be caused by NULL-ptr deref or user memory access
general protection fault: 0000 [#1] PREEMPT SMP KASAN
CPU: 1 PID: 31763 Comm: syz-executor.0 Not tainted 5.2.0-rc6+ #63
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
RIP: 0010:ip6_datagram_dst_update+0x559/0xc30 net/ipv6/datagram.c:83
Code: 00 00 e8 ea 29 3f fb 4d 85 f6 0f 84 96 04 00 00 e8 dc 29 3f fb 49 8d 7e 20 48 b8 00 00 00 00 00 fc ff df 48 89 fa 48 c1 ea 03 <80> 3c 02 00 0f 85 16 06 00 00 4d 8b 6e 20 e8 b4 29 3f fb 4c 89 ee
RSP: 0018:ffff88809ba97ae0 EFLAGS: 00010207
RAX: dffffc0000000000 RBX: ffff8880a81254b0 RCX: ffffc90008118000
RDX: 0000000000000003 RSI: ffffffff86319a84 RDI: 000000000000001e
RBP: ffff88809ba97c10 R08: ffff888065e9e700 R09: ffffed1015d26c80
R10: ffffed1015d26c7f R11: ffff8880ae9363fb R12: ffff8880a8124f40
R13: 0000000000000001 R14: fffffffffffffffe R15: ffff88809ba97b40
FS:  00007f38e606a700(0000) GS:ffff8880ae900000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00000000202c0140 CR3: 00000000a026a000 CR4: 00000000001406e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 __ip6_datagram_connect+0x5e9/0x1390 net/ipv6/datagram.c:246
 ip6_datagram_connect+0x30/0x50 net/ipv6/datagram.c:269
 ip6_datagram_connect_v6_only+0x69/0x90 net/ipv6/datagram.c:281
 inet_dgram_connect+0x14a/0x2d0 net/ipv4/af_inet.c:571
 __sys_connect+0x264/0x330 net/socket.c:1824
 __do_sys_connect net/socket.c:1835 [inline]
 __se_sys_connect net/socket.c:1832 [inline]
 __x64_sys_connect+0x73/0xb0 net/socket.c:1832
 do_syscall_64+0xfd/0x680 arch/x86/entry/common.c:301
 entry_SYSCALL_64_after_hwframe+0x49/0xbe
RIP: 0033:0x4597c9
Code: fd b7 fb ff c3 66 2e 0f 1f 84 00 00 00 00 00 66 90 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 0f 83 cb b7 fb ff c3 66 2e 0f 1f 84 00 00 00 00
RSP: 002b:00007f38e6069c78 EFLAGS: 00000246 ORIG_RAX: 000000000000002a
RAX: ffffffffffffffda RBX: 0000000000000003 RCX: 00000000004597c9
RDX: 000000000000001c RSI: 0000000020000040 RDI: 0000000000000003
RBP: 000000000075bf20 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 00007f38e606a6d4
R13: 00000000004bfd07 R14: 00000000004d1838 R15: 00000000ffffffff
Modules linked in:
RIP: 0010:ip6_datagram_dst_update+0x559/0xc30 net/ipv6/datagram.c:83
Code: 00 00 e8 ea 29 3f fb 4d 85 f6 0f 84 96 04 00 00 e8 dc 29 3f fb 49 8d 7e 20 48 b8 00 00 00 00 00 fc ff df 48 89 fa 48 c1 ea 03 <80> 3c 02 00 0f 85 16 06 00 00 4d 8b 6e 20 e8 b4 29 3f fb 4c 89 ee

Fixes: 59c820b2317f ("ipv6: elide flowlabel check if no exclusive leases exist")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Acked-by: Willem de Bruijn <willemb@google.com>
Reported-by: syzbot <syzkaller@googlegroups.com>
---
 net/ipv6/datagram.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/ipv6/datagram.c b/net/ipv6/datagram.c
index 9d78c907b918a98cbb9e80154a038e31b6bddd11..9ab897ded4df52d882cda1414ef0159f3eb1765a 100644
--- a/net/ipv6/datagram.c
+++ b/net/ipv6/datagram.c
@@ -74,7 +74,7 @@ int ip6_datagram_dst_update(struct sock *sk, bool fix_sk_saddr)
 
 	if (np->sndflow && (np->flow_label & IPV6_FLOWLABEL_MASK)) {
 		flowlabel = fl6_sock_lookup(sk, np->flow_label);
-		if (!flowlabel)
+		if (IS_ERR(flowlabel))
 			return -EINVAL;
 	}
 	ip6_datagram_flow_key_init(&fl6, sk);
-- 
2.22.0.410.gd8fdbe21b5-goog

