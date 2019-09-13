Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 30805B2712
	for <lists+netdev@lfdr.de>; Fri, 13 Sep 2019 23:13:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389691AbfIMVNU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Sep 2019 17:13:20 -0400
Received: from ma1-aaemail-dr-lapp01.apple.com ([17.171.2.60]:56592 "EHLO
        ma1-aaemail-dr-lapp01.apple.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2388067AbfIMVNU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Sep 2019 17:13:20 -0400
X-Greylist: delayed 3864 seconds by postgrey-1.27 at vger.kernel.org; Fri, 13 Sep 2019 17:13:18 EDT
Received: from pps.filterd (ma1-aaemail-dr-lapp01.apple.com [127.0.0.1])
        by ma1-aaemail-dr-lapp01.apple.com (8.16.0.27/8.16.0.27) with SMTP id x8DK7UGA025494;
        Fri, 13 Sep 2019 13:08:47 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=apple.com; h=sender : from : to :
 cc : subject : date : message-id : in-reply-to : references : mime-version
 : content-transfer-encoding; s=20180706;
 bh=fmGciNFPXcHGE8BB8nZtj7nofklsFY8j4wWpROMqVf8=;
 b=r+6ckrthrHbbZMwygVwuYs0Yj1ZJN24JtbN0JhkUTK9MAlVWUQCjgNIkJAPMaipyM+sC
 HKIHNqNFEL2DRv66/vT5CecDFoCSbhlDo8cU6GsPVAbIjQ9hEG4DcR7EvXbuEvTWgeFA
 RAhbwhK6I4yxj43JoKRG3jlkqDht4vCsGgAHcoXSwNBT2fOtDh6z6Rxo349obAne/EVy
 S8EPze1/GLhSztYuU6braIFKwbCl4JbtFRCwtK4Lqeevw5EjasfhtSdjtiZ6NE4oNk94
 fBveKKB9FtfByki0ewOV4BBGD2a5G+UdUB2ZSPG3UUfPsASjL127ama5GR06mz+HB7e+ ag== 
Received: from mr2-mtap-s01.rno.apple.com (mr2-mtap-s01.rno.apple.com [17.179.226.133])
        by ma1-aaemail-dr-lapp01.apple.com with ESMTP id 2uytc96atb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO);
        Fri, 13 Sep 2019 13:08:47 -0700
Received: from nwk-mmpp-sz11.apple.com
 (nwk-mmpp-sz11.apple.com [17.128.115.155]) by mr2-mtap-s01.rno.apple.com
 (Oracle Communications Messaging Server 8.0.2.4.20190507 64bit (built May  7
 2019)) with ESMTPS id <0PXS007IXDAMKT60@mr2-mtap-s01.rno.apple.com>; Fri,
 13 Sep 2019 13:08:47 -0700 (PDT)
Received: from process_milters-daemon.nwk-mmpp-sz11.apple.com by
 nwk-mmpp-sz11.apple.com
 (Oracle Communications Messaging Server 8.0.2.4.20190507 64bit (built May  7
 2019)) id <0PXS00600BUJM500@nwk-mmpp-sz11.apple.com>; Fri,
 13 Sep 2019 13:08:45 -0700 (PDT)
X-Va-A: 
X-Va-T-CD: cef315c09824b9b3685831d03331f616
X-Va-E-CD: d8561ddf52739a1990d7af6350dcaa40
X-Va-R-CD: 7946abf6a727bfb48788ab678c68e53f
X-Va-CD: 0
X-Va-ID: 5a35d23a-51ce-4d0d-90dd-2561279704f5
X-V-A:  
X-V-T-CD: cef315c09824b9b3685831d03331f616
X-V-E-CD: d8561ddf52739a1990d7af6350dcaa40
X-V-R-CD: 7946abf6a727bfb48788ab678c68e53f
X-V-CD: 0
X-V-ID: f4f72e15-46fd-4c25-9c70-a5cd3ece9712
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,,
 definitions=2019-09-13_09:,, signatures=0
Received: from localhost ([17.192.155.217]) by nwk-mmpp-sz11.apple.com
 (Oracle Communications Messaging Server 8.0.2.4.20190507 64bit (built May  7
 2019)) with ESMTPSA id <0PXS007SRDAKTY50@nwk-mmpp-sz11.apple.com>; Fri,
 13 Sep 2019 13:08:44 -0700 (PDT)
From:   Christoph Paasch <cpaasch@apple.com>
To:     stable@vger.kernel.org, netdev@vger.kernel.org,
        gregkh@linuxfoundation.org, Sasha Levin <sashal@kernel.org>
Cc:     David Miller <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jason Baron <jbaron@akamai.com>,
        Vladimir Rutsky <rutsky@google.com>,
        Soheil Hassas Yeganeh <soheil@google.com>,
        Neal Cardwell <ncardwell@google.com>
Subject: [PATCH v4.14-stable 1/2] tcp: Reset send_head when removing skb from
 write-queue
Date:   Fri, 13 Sep 2019 13:08:18 -0700
Message-id: <20190913200819.32686-2-cpaasch@apple.com>
X-Mailer: git-send-email 2.21.0
In-reply-to: <20190913200819.32686-1-cpaasch@apple.com>
References: <20190913200819.32686-1-cpaasch@apple.com>
MIME-version: 1.0
Content-transfer-encoding: 8bit
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-09-13_09:,,
 signatures=0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

syzkaller is not happy since commit fdfc5c8594c2 ("tcp: remove empty skb
from write queue in error cases"):

CPU: 1 PID: 13814 Comm: syz-executor.4 Not tainted 4.14.143 #5
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 0.5.1 01/01/2011
task: ffff888040105c00 task.stack: ffff8880649c0000
RIP: 0010:tcp_sendmsg_locked+0x6b4/0x4390 net/ipv4/tcp.c:1350
RSP: 0018:ffff8880649cf718 EFLAGS: 00010206
RAX: 0000000000000014 RBX: 000000000000001e RCX: ffffc90000717000
RDX: 0000000000000077 RSI: ffffffff82e760f7 RDI: 00000000000000a0
RBP: ffff8880649cfaa8 R08: 1ffff1100c939e7a R09: ffff8880401063c8
R10: 0000000000000003 R11: 0000000000000001 R12: dffffc0000000000
R13: ffff888043d74750 R14: ffff888043d74500 R15: 000000000000001e
FS:  00007f0afcb6d700(0000) GS:ffff88806cf00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000001b2ca22000 CR3: 0000000040496004 CR4: 00000000003606e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 tcp_sendmsg+0x2a/0x40 net/ipv4/tcp.c:1533
 inet_sendmsg+0x173/0x4e0 net/ipv4/af_inet.c:784
 sock_sendmsg_nosec net/socket.c:646 [inline]
 sock_sendmsg+0xc3/0x100 net/socket.c:656
 SYSC_sendto+0x35d/0x5e0 net/socket.c:1766
 do_syscall_64+0x241/0x680 arch/x86/entry/common.c:292
 entry_SYSCALL_64_after_hwframe+0x42/0xb7

The problem is that we are removing an skb from the write-queue that
could have been referenced by the sk_send_head. Thus, we need to check
for the send_head's sanity after removing it.

This patch needs to be backported only to 4.14 and older (among those
that applied the backport of fdfc5c8594c2).

Fixes: fdfc5c8594c2 ("tcp: remove empty skb from write queue in error cases")
Cc: Eric Dumazet <edumazet@google.com>
Cc: Jason Baron <jbaron@akamai.com>
Cc: Vladimir Rutsky <rutsky@google.com>
Cc: Soheil Hassas Yeganeh <soheil@google.com>
Cc: Neal Cardwell <ncardwell@google.com>
Signed-off-by: Christoph Paasch <cpaasch@apple.com>
---
 net/ipv4/tcp.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
index 5ce069ce2a97..efe767e20d01 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -924,8 +924,7 @@ static void tcp_remove_empty_skb(struct sock *sk, struct sk_buff *skb)
 {
 	if (skb && !skb->len) {
 		tcp_unlink_write_queue(skb, sk);
-		if (tcp_write_queue_empty(sk))
-			tcp_chrono_stop(sk, TCP_CHRONO_BUSY);
+		tcp_check_send_head(sk, skb);
 		sk_wmem_free_skb(sk, skb);
 	}
 }
-- 
2.21.0

