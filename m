Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B94BA304DA6
	for <lists+netdev@lfdr.de>; Wed, 27 Jan 2021 01:47:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387546AbhAZXNO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Jan 2021 18:13:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58188 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727029AbhAZWAk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Jan 2021 17:00:40 -0500
X-Greylist: delayed 178 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Tue, 26 Jan 2021 13:59:52 PST
Received: from forwardcorp1o.mail.yandex.net (forwardcorp1o.mail.yandex.net [IPv6:2a02:6b8:0:1a2d::193])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C3B4DC061573
        for <netdev@vger.kernel.org>; Tue, 26 Jan 2021 13:59:52 -0800 (PST)
Received: from sas1-ec30c78b6c5b.qloud-c.yandex.net (sas1-ec30c78b6c5b.qloud-c.yandex.net [IPv6:2a02:6b8:c14:2704:0:640:ec30:c78b])
        by forwardcorp1o.mail.yandex.net (Yandex) with ESMTP id 9C2AD2E1AB1
        for <netdev@vger.kernel.org>; Wed, 27 Jan 2021 00:56:50 +0300 (MSK)
Received: from sas2-d40aa8807eff.qloud-c.yandex.net (sas2-d40aa8807eff.qloud-c.yandex.net [2a02:6b8:c08:b921:0:640:d40a:a880])
        by sas1-ec30c78b6c5b.qloud-c.yandex.net (mxbackcorp/Yandex) with ESMTP id BHkKYaeIGd-uo0i8omP;
        Wed, 27 Jan 2021 00:56:50 +0300
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yandex-team.ru; s=default;
        t=1611698210; bh=Js0xUHhxgLmPrOAHMW9415JqAK80+mCgb63F8ssAlIM=;
        h=Message-Id:Date:Subject:To:From:Cc;
        b=xjGSofP7vKdd6DJW3Bb65JVKrMfeZxscgIWo9skfP62a3P2GX41/XB2i6hC7PWMqE
         PQTyOnx0qNEW4arYKWzyl+Xl2R5FsT8xNE1zDDe6vFMwEOAts4ItuQ4BiWA1hnZCR2
         +9jh87G+Q/DuWpQ8vy/dc3nbbmPZGe6zrNulwSnk=
Authentication-Results: sas1-ec30c78b6c5b.qloud-c.yandex.net; dkim=pass header.i=@yandex-team.ru
Received: from ov.sas.yp-c.yandex.net (ov.sas.yp-c.yandex.net [2a02:6b8:c1b:2921:0:696:dfec:0])
        by sas2-d40aa8807eff.qloud-c.yandex.net (smtpcorp/Yandex) with ESMTPSA id ye81QVSqgY-uon8RppL;
        Wed, 27 Jan 2021 00:56:50 +0300
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (Client certificate not present)
From:   Alexander Ovechkin <ovov@yandex-team.ru>
To:     netdev@vger.kernel.org
Cc:     zeil@yandex-team.ru, dmtrmonakhov@yandex-team.ru
Subject: [PATCH net] net: sched: replaced invalid qdisc tree flush helper in qdisc_replace
Date:   Wed, 27 Jan 2021 00:56:41 +0300
Message-Id: <20210126215641.545645-1-ovov@yandex-team.ru>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Commit e5f0e8f8e456 ("net: sched: introduce and use qdisc tree flush/purge helpers")
introduced qdisc tree flush/purge helpers, but erroneously used flush helper
instead of purge helper in qdisc_replace function.
This issue was found in our CI, that tests various qdisc setups by configuring
qdisc and sending data through it. Call of invalid helper sporadically leads
to corruption of vt_tree/cf_tree of hfsc_class that causes kernel oops:

 Oops: 0000 [#1] SMP PTI
 CPU: 1 PID: 0 Comm: swapper/1 Not tainted 5.11.0-8f6859df #1
 Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS rel-1.10.2-0-g5f4c7b1-prebuilt.qemu-project.org 04/01/2014
 RIP: 0010:rb_insert_color+0x18/0x190
 Code: c3 31 c0 c3 0f 1f 40 00 66 2e 0f 1f 84 00 00 00 00 00 48 8b 07 48 85 c0 0f 84 05 01 00 00 48 8b 10 f6 c2 01 0f 85 34 01 00 00 <48> 8b 4a 08 49 89 d0 48 39 c1 74 7d 48 85 c9 74 32 f6 01 01 75 2d
 RSP: 0018:ffffc900000b8bb0 EFLAGS: 00010246
 RAX: ffff8881ef4c38b0 RBX: ffff8881d956e400 RCX: ffff8881ef4c38b0
 RDX: 0000000000000000 RSI: ffff8881d956f0a8 RDI: ffff8881d956e4b0
 RBP: 0000000000000000 R08: 000000d5c4e249da R09: 1600000000000000
 R10: ffffc900000b8be0 R11: ffffc900000b8b28 R12: 0000000000000001
 R13: 000000000000005a R14: ffff8881f0905000 R15: ffff8881f0387d00
 FS:  0000000000000000(0000) GS:ffff8881f8b00000(0000) knlGS:0000000000000000
 CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
 CR2: 0000000000000008 CR3: 00000001f4796004 CR4: 0000000000060ee0
 Call Trace:
  <IRQ>
  init_vf.isra.19+0xec/0x250 [sch_hfsc]
  hfsc_enqueue+0x245/0x300 [sch_hfsc]
  ? fib_rules_lookup+0x12a/0x1d0
  ? __dev_queue_xmit+0x4b6/0x930
  ? hfsc_delete_class+0x250/0x250 [sch_hfsc]
  __dev_queue_xmit+0x4b6/0x930
  ? ip6_finish_output2+0x24d/0x590
  ip6_finish_output2+0x24d/0x590
  ? ip6_output+0x6c/0x130
  ip6_output+0x6c/0x130
  ? __ip6_finish_output+0x110/0x110
  mld_sendpack+0x224/0x230
  mld_ifc_timer_expire+0x186/0x2c0
  ? igmp6_group_dropped+0x200/0x200
  call_timer_fn+0x2d/0x150
  run_timer_softirq+0x20c/0x480
  ? tick_sched_do_timer+0x60/0x60
  ? tick_sched_timer+0x37/0x70
  __do_softirq+0xf7/0x2cb
  irq_exit+0xa0/0xb0
  smp_apic_timer_interrupt+0x74/0x150
  apic_timer_interrupt+0xf/0x20
  </IRQ>

Fixes: e5f0e8f8e456 ("net: sched: introduce and use qdisc tree flush/purge
helpers")
Signed-off-by: Alexander Ovechkin <ovov@yandex-team.ru>
Reported-by: Alexander Kuznetsov <wwfq@yandex-team.ru>
Acked-by: Dmitry Monakhov <dmtrmonakhov@yandex-team.ru>
Acked-by: Dmitry Yakunin <zeil@yandex-team.ru>
---
 include/net/sch_generic.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/net/sch_generic.h b/include/net/sch_generic.h
index 639e465a108f..5b490b5591df 100644
--- a/include/net/sch_generic.h
+++ b/include/net/sch_generic.h
@@ -1143,7 +1143,7 @@ static inline struct Qdisc *qdisc_replace(struct Qdisc *sch, struct Qdisc *new,
 	old = *pold;
 	*pold = new;
 	if (old != NULL)
-		qdisc_tree_flush_backlog(old);
+		qdisc_purge_queue(old);
 	sch_tree_unlock(sch);
 
 	return old;
-- 
2.17.1

