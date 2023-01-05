Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8D23965F590
	for <lists+netdev@lfdr.de>; Thu,  5 Jan 2023 22:17:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235469AbjAEVRQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Jan 2023 16:17:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44056 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235077AbjAEVRP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Jan 2023 16:17:15 -0500
Received: from mail.ispras.ru (mail.ispras.ru [83.149.199.84])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 221505599;
        Thu,  5 Jan 2023 13:17:12 -0800 (PST)
Received: from fedcomp.intra.ispras.ru (unknown [46.242.14.200])
        by mail.ispras.ru (Postfix) with ESMTPSA id 44389419E9F7;
        Thu,  5 Jan 2023 21:17:09 +0000 (UTC)
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.ispras.ru 44389419E9F7
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ispras.ru;
        s=default; t=1672953429;
        bh=vzbXbak2Ksmuo1Te5qcCy/hoQ6s/KxtX46PycqZ76cI=;
        h=From:To:Cc:Subject:Date:From;
        b=pbpax9avnoTocrwocV0Y5ooccF6kCceLY/Bi+u1OwtvfrrKwcCfsXHOuprjRr8b4e
         xG3e2NFFq+l0j3Sq0s1pNJRl6W9PslUJ5DVB4KVsar9ukb7XeWrn8WZzdVzATe2ho0
         mU/69TbXSCpasxJCYmSiL21uM7LQLt0zWQ5mfI0E=
From:   Fedor Pchelkin <pchelkin@ispras.ru>
To:     Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Fedor Pchelkin <pchelkin@ispras.ru>,
        Paolo Abeni <pabeni@redhat.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Alexey Khoroshilov <khoroshilov@ispras.ru>,
        lvc-project@linuxtesting.org, Willem de Bruijn <willemb@google.com>
Subject: kernel BUG in __ip_make_skb()
Date:   Fri,  6 Jan 2023 00:16:35 +0300
Message-Id: <20230105211636.40616-1-pchelkin@ispras.ru>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Syzkaller reports the following crash:

kernel BUG at include/linux/skbuff.h:2311!
invalid opcode: 0000 [#1] PREEMPT SMP KASAN NOPTI
CPU: 2 PID: 4615 Comm: syz-executor260 Not tainted 5.10.152-syzkaller #0
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.12.0-1 04/01/2014
RIP: 0010:__skb_pull include/linux/skbuff.h:2311 [inline]
RIP: 0010:__ip_make_skb.cold+0x5b/0x5d net/ipv4/ip_output.c:1507
Code: 79 a2 f9 8b 44 24 3c 89 ee 48 c7 c7 00 2e de 88 41 89 45 70 e8 d1 84 de ff 31 d2 4c 89 ee 48 c7 c7 40 2e de 88 e8 a1 26 ff ff <0f> 0b e8 63 79 a2 f9 e8 4e f7 e2 f9 48 c7 c7 40 39 de 88 e8 5e c1
RSP: 0018:ffff88801e0af698 EFLAGS: 00010293
RAX: 0000000000000000 RBX: ffff88814c408288 RCX: ffffffff87ce00ec
RDX: ffff888024a11ac0 RSI: ffffffff87ceccc6 RDI: 0000000000000001
RBP: 0000000000000028 R08: 000000000000003b R09: ffff8880b8438ba7
R10: 0000000000000000 R11: 0000000000000001 R12: ffff8881436a9cc0
R13: ffff8881436a9cc0 R14: ffff8881436a9e00 R15: dffffc0000000000
FS:  00007f2750eb7700(0000) GS:ffff8880b8500000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f4438a29010 CR3: 0000000021f58000 CR4: 0000000000350ee0
Call Trace:
 ip_finish_skb include/net/ip.h:241 [inline]
 udp_push_pending_frames net/ipv4/udp.c:979 [inline]
 udp_sendpage+0x36e/0x570 net/ipv4/udp.c:1354
 inet_sendpage+0xd3/0x140 net/ipv4/af_inet.c:831
 kernel_sendpage.part.0+0x13c/0x280 net/socket.c:3514
 kernel_sendpage net/socket.c:3511 [inline]
 sock_sendpage+0xe5/0x140 net/socket.c:944
 pipe_to_sendpage+0x2af/0x380 fs/splice.c:364
 splice_from_pipe_feed fs/splice.c:418 [inline]
 __splice_from_pipe+0x3e5/0x840 fs/splice.c:562
 splice_from_pipe fs/splice.c:597 [inline]
 generic_splice_sendpage+0xd4/0x140 fs/splice.c:743
 do_splice_from fs/splice.c:764 [inline]
 direct_splice_actor+0x10f/0x170 fs/splice.c:933
 splice_direct_to_actor+0x38f/0x990 fs/splice.c:888
 do_splice_direct+0x1b3/0x280 fs/splice.c:976
 do_sendfile+0x553/0x10a0 fs/read_write.c:1257
 __do_sys_sendfile64 fs/read_write.c:1318 [inline]
 __se_sys_sendfile64 fs/read_write.c:1304 [inline]
 __x64_sys_sendfile64+0x1d0/0x210 fs/read_write.c:1304
 do_syscall_64+0x33/0x40 arch/x86/entry/common.c:46
 entry_SYSCALL_64_after_hwframe+0x61/0xc6

It was actually found on a 5.10 kernel instance but I didn't find any
upstream commit referencing something of that kind so this bug is likely
to be in upstream, too. The reproducers unfortunately do not work on my
machine, but I'll add one in the next email for additional info.

From here the terminology is used as from the fragment of __ip_make_skb():
---
if (skb->data < skb_network_header(skb))
      __skb_pull(skb, skb_network_offset(skb));
while ((tmp_skb = __skb_dequeue(queue)) != NULL) {
      __skb_pull(tmp_skb, skb_network_header_len(skb)); <-- BUG is here
---

We get the first fragment (called 'skb') from the queue and then start
getting another fragments ('tmp_skb') from the queue and combine them to
the first fragment.

The problem is that the difference between tmp_skb->len and
tmp_skb->data_len is smaller than the length of skb network (IP) header
and while doing __skb_pull(), tmp_skb->len becomes smaller than
tmp_skb->data_len causing a bug.

Something is probably wrong with IP header layout of the first fragment
(the SKB to which we are combining another ones). It is 40 bytes long, and
the tmp_skb IP header's length is 20 bytes (have a look at debug info
lower). The first fragment, however, can contain some specific IP options
which are stored only in this fragment and are not included into the
following ones. On the other hand, the problem can be with tmp_skb where
something casued its data_len be incorrect.

Maybe there is some sanity check missing while constructing an IP datagram
in ip_append_page()? Additional check of extra IP headers or MTU
values...?

We managed to get some debug info about the failing SKBs.

tmp_skb info:
skb len=1476 headroom=160 headlen=20 tailroom=0
mac=(-1,-1) net=(160,20) trans=180
shinfo(txflags=0 nr_frags=1 gso(size=0 type=0 segs=0))
csum(0x0 ip_summed=0 complete_sw=0 valid=0 level=0)
hash(0xe62f05e3 sw=0 l4=1) proto=0x0000 pkttype=0 iif=0
sk family=2 type=2 proto=17
skb linear:   00000000: 00 00 00 00 00 00 00 00 30 06 a9 86 ff ff ff ff
skb linear:   00000010: 02 00 00 00
skb frag:     00000000: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
skb frag:     00000010: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
skb frag:     00000020: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
skb frag:     00000030: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
skb frag:     00000040: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
skb frag:     00000050: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
skb frag:     00000060: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
skb frag:     00000070: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
skb frag:     00000080: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
skb frag:     00000090: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
skb frag:     000000a0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
skb frag:     000000b0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
skb frag:     000000c0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
skb frag:     000000d0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
skb frag:     000000e0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
skb frag:     000000f0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
skb frag:     00000100: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
skb frag:     00000110: 00 00 00 00 00 00 00 00 00 00 00 00

skb info:
skb len=1476 headroom=168 headlen=241 tailroom=0
mac=(-1,-1) net=(168,40) trans=208
shinfo(txflags=0 nr_frags=1 gso(size=0 type=0 segs=0))
csum(0x3f886391 ip_summed=0 complete_sw=0 valid=0 level=0)
hash(0xe62f05e3 sw=0 l4=1) proto=0x86dd pkttype=0 iif=0
sk family=2 type=2 proto=17
skb linear:   00000000: 00 00 00 00 00 00 00 00 28 00 00 00 00 00 00 00
skb linear:   00000010: 80 44 f9 8a ff ff ff ff 00 00 00 00 00 00 00 00
skb linear:   00000020: 00 00 00 00 00 00 00 00 fe ff ff ff 00 00 00 00
skb linear:   00000030: f3 57 61 ad ca 6f 38 25 00 62 d5 b1 7d e1 d0 94
skb linear:   00000040: 04 ae 20 57 20 1a 06 db 10 92 76 4f 8d 2e af 83
skb linear:   00000050: 91 0c c3 cd b5 d1 96 9e c8 7e c8 e5 90 a9 be aa
skb linear:   00000060: ae f8 7d 1d bb af 99 62 36 3f c9 a3 44 4e 18 fa
skb linear:   00000070: 0e 5f 40 32 59 ad 8b 90 89 df 79 63 13 80 da 2b
skb linear:   00000080: de 47 62 24 61 fd 47 d8 89 4a 74 8a 91 32 aa c6
skb linear:   00000090: ad 59 30 2f 2c 2e 94 9f 83 00 46 5b f9 11 98 a9
skb linear:   000000a0: cb ed ca cb 8d 70 d8 78 4c 95 b6 12 af 8b 81 33
skb linear:   000000b0: 13 58 9d 74 ef 30 91 1d 10 bd 55 22 67 6b b9 43
skb linear:   000000c0: 97 72 5c a2 c7 24 df f4 2c 3f b8 5e cb 3a 10 f6
skb linear:   000000d0: 10 5f 3a 11 32 2a d5 22 b2 14 73 c0 1a df b0 6f
skb linear:   000000e0: 3c 98 91 df bf d2 b6 99 ee 3c fe 91 98 f6 55 20
skb linear:   000000f0: 45
skb frag:     00000000: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
skb frag:     00000010: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
skb frag:     00000020: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
skb frag:     00000030: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00

More info:
tmp_skb->len = 1476; tmp_skb->data_len = 1456
skb->len     = 1476; skb->data_len     = 1235

I actually found some commits with resembling call trace but they don't help
me that much to solve the issue:
10b8a3de603d ("ipv6: the entire IPv6 header chain must fit the first fragment")
e9d3f80935b6 ("net/af_packet: make sure to pull mac header")
501a90c94510 ("inet: protect against too small mtu values.")

Fedor
