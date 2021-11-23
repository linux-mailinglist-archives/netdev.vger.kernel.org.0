Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 986F245A424
	for <lists+netdev@lfdr.de>; Tue, 23 Nov 2021 14:54:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235664AbhKWN5S (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Nov 2021 08:57:18 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:25410 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231603AbhKWN5S (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Nov 2021 08:57:18 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1637675649;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=JP8Re+jIvMpfoWAMXdw0V2c+OJtx9iqdfujHiteatgM=;
        b=XdKRGWAP0DbDC3YxLQws+dQZVdRXk4QX7JF/Z7TkIeMaqEaZFC9GGFj/oQ+dMqyKORJAG8
        XKFuMSuUhVh2WiUqwQ0OvCTwdF7NDezzc39O8WU9yPnf1br9HRBj0fUSW/nYwSgrH6x3Ih
        mVoVwJOQWNOBHCvtOyx3h4TXBffOKhk=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-389-6ExzGYT5M2WwEpxFU8klXw-1; Tue, 23 Nov 2021 08:54:06 -0500
X-MC-Unique: 6ExzGYT5M2WwEpxFU8klXw-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 706001006AA0;
        Tue, 23 Nov 2021 13:54:04 +0000 (UTC)
Received: from dcaratti.station (unknown [10.40.194.151])
        by smtp.corp.redhat.com (Postfix) with ESMTP id DE6FC418E;
        Tue, 23 Nov 2021 13:54:01 +0000 (UTC)
From:   Davide Caratti <dcaratti@redhat.com>
To:     Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Petr Machata <petrm@mellanox.com>
Cc:     netdev@vger.kernel.org, Hangbin Liu <liuhangbin@gmail.com>
Subject: [PATCH net v2] net/sched: sch_ets: don't peek at classes beyond 'nbands'
Date:   Tue, 23 Nov 2021 14:53:38 +0100
Message-Id: <ed47959b3abc0d03cb98d65581ac2541fa27b16e.1637674769.git.dcaratti@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

when the number of DRR classes decreases, the round-robin active list can
contain elements that have already been freed in ets_qdisc_change(). As a
consequence, it's possible to see a NULL dereference crash, caused by the
attempt to call cl->qdisc->ops->peek(cl->qdisc) when cl->qdisc is NULL:

 BUG: kernel NULL pointer dereference, address: 0000000000000018
 #PF: supervisor read access in kernel mode
 #PF: error_code(0x0000) - not-present page
 PGD 0 P4D 0
 Oops: 0000 [#1] PREEMPT SMP NOPTI
 CPU: 1 PID: 910 Comm: mausezahn Not tainted 5.16.0-rc1+ #475
 Hardware name: Red Hat KVM, BIOS 1.11.1-4.module+el8.1.0+4066+0f1aadab 04/01/2014
 RIP: 0010:ets_qdisc_dequeue+0x129/0x2c0 [sch_ets]
 Code: c5 01 41 39 ad e4 02 00 00 0f 87 18 ff ff ff 49 8b 85 c0 02 00 00 49 39 c4 0f 84 ba 00 00 00 49 8b ad c0 02 00 00 48 8b 7d 10 <48> 8b 47 18 48 8b 40 38 0f ae e8 ff d0 48 89 c3 48 85 c0 0f 84 9d
 RSP: 0000:ffffbb36c0b5fdd8 EFLAGS: 00010287
 RAX: ffff956678efed30 RBX: 0000000000000000 RCX: 0000000000000000
 RDX: 0000000000000002 RSI: ffffffff9b938dc9 RDI: 0000000000000000
 RBP: ffff956678efed30 R08: e2f3207fe360129c R09: 0000000000000000
 R10: 0000000000000001 R11: 0000000000000001 R12: ffff956678efeac0
 R13: ffff956678efe800 R14: ffff956611545000 R15: ffff95667ac8f100
 FS:  00007f2aa9120740(0000) GS:ffff95667b800000(0000) knlGS:0000000000000000
 CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
 CR2: 0000000000000018 CR3: 000000011070c000 CR4: 0000000000350ee0
 Call Trace:
  <TASK>
  qdisc_peek_dequeued+0x29/0x70 [sch_ets]
  tbf_dequeue+0x22/0x260 [sch_tbf]
  __qdisc_run+0x7f/0x630
  net_tx_action+0x290/0x4c0
  __do_softirq+0xee/0x4f8
  irq_exit_rcu+0xf4/0x130
  sysvec_apic_timer_interrupt+0x52/0xc0
  asm_sysvec_apic_timer_interrupt+0x12/0x20
 RIP: 0033:0x7f2aa7fc9ad4
 Code: b9 ff ff 48 8b 54 24 18 48 83 c4 08 48 89 ee 48 89 df 5b 5d e9 ed fc ff ff 0f 1f 00 66 2e 0f 1f 84 00 00 00 00 00 f3 0f 1e fa <53> 48 83 ec 10 48 8b 05 10 64 33 00 48 8b 00 48 85 c0 0f 85 84 00
 RSP: 002b:00007ffe5d33fab8 EFLAGS: 00000202
 RAX: 0000000000000002 RBX: 0000561f72c31460 RCX: 0000561f72c31720
 RDX: 0000000000000002 RSI: 0000561f72c31722 RDI: 0000561f72c31720
 RBP: 000000000000002a R08: 00007ffe5d33fa40 R09: 0000000000000014
 R10: 0000000000000000 R11: 0000000000000246 R12: 0000561f7187e380
 R13: 0000000000000000 R14: 0000000000000000 R15: 0000561f72c31460
  </TASK>
 Modules linked in: sch_ets sch_tbf dummy rfkill iTCO_wdt intel_rapl_msr iTCO_vendor_support intel_rapl_common joydev virtio_balloon lpc_ich i2c_i801 i2c_smbus pcspkr ip_tables xfs libcrc32c crct10dif_pclmul crc32_pclmul crc32c_intel ahci libahci ghash_clmulni_intel serio_raw libata virtio_blk virtio_console virtio_net net_failover failover sunrpc dm_mirror dm_region_hash dm_log dm_mod
 CR2: 0000000000000018

Ensuring that 'alist' was never zeroed [1] was not sufficient, we need to
check also for possible NULL 'qdisc' pointers in the leaf class.

[1] https://lore.kernel.org/netdev/60d274838bf09777f0371253416e8af71360bc08.1633609148.git.dcaratti@redhat.com/

v2: when a NULL qdisc is found in the DRR active list, try to dequeue skb
    from the next list item.

Reported-by: Hangbin Liu <liuhangbin@gmail.com>
Fixes: dcc68b4d8084 ("net: sch_ets: Add a new Qdisc")
Signed-off-by: Davide Caratti <dcaratti@redhat.com>
---
 net/sched/sch_ets.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/net/sched/sch_ets.c b/net/sched/sch_ets.c
index 0eae9ff5edf6..ecb569ffb3f1 100644
--- a/net/sched/sch_ets.c
+++ b/net/sched/sch_ets.c
@@ -476,10 +476,15 @@ static struct sk_buff *ets_qdisc_dequeue(struct Qdisc *sch)
 				return ets_qdisc_dequeue_skb(sch, skb);
 		}
 
+drr_dequeue:
 		if (list_empty(&q->active))
 			goto out;
 
 		cl = list_first_entry(&q->active, struct ets_class, alist);
+		if (!cl->qdisc) {
+			list_del(&cl->alist);
+			goto drr_dequeue;
+		}
 		skb = cl->qdisc->ops->peek(cl->qdisc);
 		if (!skb) {
 			qdisc_warn_nonwc(__func__, cl->qdisc);
-- 
2.31.1

