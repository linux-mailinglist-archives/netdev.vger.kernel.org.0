Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D00ACB2733
	for <lists+netdev@lfdr.de>; Fri, 13 Sep 2019 23:26:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389839AbfIMV0Y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Sep 2019 17:26:24 -0400
Received: from ma1-aaemail-dr-lapp01.apple.com ([17.171.2.60]:36862 "EHLO
        ma1-aaemail-dr-lapp01.apple.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2387554AbfIMV0Y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Sep 2019 17:26:24 -0400
Received: from pps.filterd (ma1-aaemail-dr-lapp01.apple.com [127.0.0.1])
        by ma1-aaemail-dr-lapp01.apple.com (8.16.0.27/8.16.0.27) with SMTP id x8DK7UGB025494;
        Fri, 13 Sep 2019 13:08:48 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=apple.com; h=sender : from : to :
 cc : subject : date : message-id : in-reply-to : references : mime-version
 : content-transfer-encoding; s=20180706;
 bh=Cl0/9BEwqVTznNJHDXEMlsE95OlDBDfy6yu6tW5YZZo=;
 b=PNkESUiZQd87Ss40VDO1l2do63+ZAN4MImExSevsqLUAzj0TVneCkoGU8QZ7o+xPoJg6
 ji7iaKSO3nuzQ+GZgzznFbh3Ey22DGBwSWdp7wKU+mtOo/rW1TB4azcEiZlVxbqVjdsG
 eCkw58a98PcMajddqE9eH7HqwVKaBrgRXISyww15wviObvkgG0KyZI28iwcfSuNsUpRt
 fvJrfzAeo8sCJEMnNpDsfvDXPj4wzL9r2ApKW3LnpYxZQ9lOsXaNs7u6Sg/z4RqjC+uY
 fD/zbp3B3xm8XSsKKEvCBB7ejqbk+5Np97AL43IoqoKIQl0fh3WcThmb0dudeYDqU98e 1Q== 
Received: from mr2-mtap-s01.rno.apple.com (mr2-mtap-s01.rno.apple.com [17.179.226.133])
        by ma1-aaemail-dr-lapp01.apple.com with ESMTP id 2uytc96atb-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO);
        Fri, 13 Sep 2019 13:08:48 -0700
Received: from nwk-mmpp-sz11.apple.com
 (nwk-mmpp-sz11.apple.com [17.128.115.155]) by mr2-mtap-s01.rno.apple.com
 (Oracle Communications Messaging Server 8.0.2.4.20190507 64bit (built May  7
 2019)) with ESMTPS id <0PXS007IXDAMKT60@mr2-mtap-s01.rno.apple.com>; Fri,
 13 Sep 2019 13:08:47 -0700 (PDT)
Received: from process_milters-daemon.nwk-mmpp-sz11.apple.com by
 nwk-mmpp-sz11.apple.com
 (Oracle Communications Messaging Server 8.0.2.4.20190507 64bit (built May  7
 2019)) id <0PXS00600BUJM500@nwk-mmpp-sz11.apple.com>; Fri,
 13 Sep 2019 13:08:46 -0700 (PDT)
X-Va-A: 
X-Va-T-CD: cef315c09824b9b3685831d03331f616
X-Va-E-CD: e7f83a7b098f4522f40c6449b31c3dc4
X-Va-R-CD: c332049a6b862975672135a329fd601c
X-Va-CD: 0
X-Va-ID: d15336aa-db7c-4fcb-8f36-5c1bffb1fe84
X-V-A:  
X-V-T-CD: cef315c09824b9b3685831d03331f616
X-V-E-CD: e7f83a7b098f4522f40c6449b31c3dc4
X-V-R-CD: c332049a6b862975672135a329fd601c
X-V-CD: 0
X-V-ID: f0affeb1-3a2d-4a91-91ba-87ce63d08ef4
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,,
 definitions=2019-09-13_09:,, signatures=0
Received: from localhost ([17.192.155.217]) by nwk-mmpp-sz11.apple.com
 (Oracle Communications Messaging Server 8.0.2.4.20190507 64bit (built May  7
 2019)) with ESMTPSA id <0PXS007SUDAMTY50@nwk-mmpp-sz11.apple.com>; Fri,
 13 Sep 2019 13:08:46 -0700 (PDT)
From:   Christoph Paasch <cpaasch@apple.com>
To:     stable@vger.kernel.org, netdev@vger.kernel.org,
        gregkh@linuxfoundation.org, Sasha Levin <sashal@kernel.org>
Cc:     David Miller <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jason Baron <jbaron@akamai.com>,
        Vladimir Rutsky <rutsky@google.com>,
        Soheil Hassas Yeganeh <soheil@google.com>,
        Neal Cardwell <ncardwell@google.com>
Subject: [PATCH v4.14-stable 2/2] tcp: Don't dequeue SYN/FIN-segments from
 write-queue
Date:   Fri, 13 Sep 2019 13:08:19 -0700
Message-id: <20190913200819.32686-3-cpaasch@apple.com>
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

If a SYN/FIN-segment is on the write-queue, skb->len is 0, but the
segment actually has been transmitted. end_seq and seq of the tcp_skb_cb
in that case will indicate this difference.

We should not remove such segments from the write-queue as we might be
in SYN_SENT-state and a retransmission-timer is running. When that one
fires, packets_out will be 1, but the write-queue would be empty,
resulting in:

[   61.280214] ------------[ cut here ]------------
[   61.281307] WARNING: CPU: 0 PID: 0 at net/ipv4/tcp_timer.c:429 tcp_retransmit_timer+0x18f9/0x2660
[   61.283498] Modules linked in:
[   61.284084] CPU: 0 PID: 0 Comm: swapper/0 Not tainted 4.14.142 #58
[   61.285214] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 0.5.1 01/01/2011
[   61.286644] task: ffffffff8401e1c0 task.stack: ffffffff84000000
[   61.287758] RIP: 0010:tcp_retransmit_timer+0x18f9/0x2660
[   61.288715] RSP: 0018:ffff88806ce07cb8 EFLAGS: 00010206
[   61.289669] RAX: ffffffff8401e1c0 RBX: ffff88805c998b00 RCX: 0000000000000006
[   61.290968] RDX: 0000000000000100 RSI: 0000000000000000 RDI: ffff88805c9994d8
[   61.292314] RBP: ffff88805c99919a R08: ffff88807fff901c R09: ffff88807fff9008
[   61.293547] R10: ffff88807fff9017 R11: ffff88807fff9010 R12: ffff88805c998b30
[   61.294834] R13: ffffffff844b9380 R14: 0000000000000000 R15: ffff88805c99930c
[   61.296086] FS:  0000000000000000(0000) GS:ffff88806ce00000(0000) knlGS:0000000000000000
[   61.297523] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   61.298646] CR2: 00007f721da50ff8 CR3: 0000000004014002 CR4: 00000000001606f0
[   61.299944] Call Trace:
[   61.300403]  <IRQ>
[   61.300806]  ? kvm_sched_clock_read+0x21/0x30
[   61.301689]  ? sched_clock+0x5/0x10
[   61.302433]  ? sched_clock_cpu+0x18/0x170
[   61.303173]  tcp_write_timer_handler+0x2c1/0x7a0
[   61.304038]  tcp_write_timer+0x13e/0x160
[   61.304794]  call_timer_fn+0x14a/0x5f0
[   61.305480]  ? tcp_write_timer_handler+0x7a0/0x7a0
[   61.306364]  ? __next_timer_interrupt+0x140/0x140
[   61.307229]  ? _raw_spin_unlock_irq+0x24/0x40
[   61.308033]  ? tcp_write_timer_handler+0x7a0/0x7a0
[   61.308887]  ? tcp_write_timer_handler+0x7a0/0x7a0
[   61.309760]  run_timer_softirq+0xc41/0x1080
[   61.310539]  ? trigger_dyntick_cpu.isra.33+0x180/0x180
[   61.311506]  ? ktime_get+0x13f/0x1c0
[   61.312232]  ? clockevents_program_event+0x10d/0x2f0
[   61.313158]  __do_softirq+0x20b/0x96b
[   61.313889]  irq_exit+0x1a7/0x1e0
[   61.314513]  smp_apic_timer_interrupt+0xfc/0x4d0
[   61.315386]  apic_timer_interrupt+0x8f/0xa0
[   61.316129]  </IRQ>

Followed by a panic.

So, before removing an skb with skb->len == 0, let's make sure that the
skb is really empty by checking the end_seq and seq.

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
 net/ipv4/tcp.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
index efe767e20d01..c1f59a53f68f 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -922,7 +922,8 @@ static int tcp_send_mss(struct sock *sk, int *size_goal, int flags)
  */
 static void tcp_remove_empty_skb(struct sock *sk, struct sk_buff *skb)
 {
-	if (skb && !skb->len) {
+	if (skb && !skb->len &&
+	    TCP_SKB_CB(skb)->end_seq == TCP_SKB_CB(skb)->seq) {
 		tcp_unlink_write_queue(skb, sk);
 		tcp_check_send_head(sk, skb);
 		sk_wmem_free_skb(sk, skb);
-- 
2.21.0

