Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5720B3F6BBA
	for <lists+netdev@lfdr.de>; Wed, 25 Aug 2021 00:34:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229840AbhHXWev (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Aug 2021 18:34:51 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:60214 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229482AbhHXWet (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Aug 2021 18:34:49 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1629844444;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=jt1zNkU7gCS/+8lgX/64PDH+zFbi4WLY4VobnLbd7D4=;
        b=czcynR+U26nNEY3W8ZyKNYqrcgDAOKgK1BOJgXcPOQf8DTnf5bi1//X38IAD01s9Z3EryP
        vgHjMFoOkmz+GEuEVpwTMS4yZI2t/7270LWEasD/8b8bl5GqcPNKyXove6FUOXPp4y+2yS
        APNAd88iErv9F8qn0EFao9PQ7Wm1CZg=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-378-qM2wyDFYPxqxsy3M2itjFw-1; Tue, 24 Aug 2021 18:34:00 -0400
X-MC-Unique: qM2wyDFYPxqxsy3M2itjFw-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A2DB81008065;
        Tue, 24 Aug 2021 22:33:58 +0000 (UTC)
Received: from dcaratti.station (unknown [10.40.193.68])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 2AA3E1ABDF;
        Tue, 24 Aug 2021 22:33:55 +0000 (UTC)
From:   Davide Caratti <dcaratti@redhat.com>
To:     Hangbin Liu <liuhangbin@gmail.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Petr Machata <petrm@mellanox.com>, netdev@vger.kernel.org
Subject: [PATH net] net/sched: ets: fix crash when flipping from 'strict' to 'quantum'
Date:   Wed, 25 Aug 2021 00:33:48 +0200
Message-Id: <2fdc7b4e11c3283cd65c7cf77c81bd6687a32c20.1629844159.git.dcaratti@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

While running kselftests, Hangbin observed that sch_ets.sh often crashes,
and splats like the following one are seen in the output of 'dmesg':

 BUG: kernel NULL pointer dereference, address: 0000000000000000
 #PF: supervisor read access in kernel mode
 #PF: error_code(0x0000) - not-present page
 PGD 159f12067 P4D 159f12067 PUD 159f13067 PMD 0
 Oops: 0000 [#1] SMP NOPTI
 CPU: 2 PID: 921 Comm: tc Not tainted 5.14.0-rc6+ #458
 Hardware name: Red Hat KVM, BIOS 1.11.1-4.module+el8.1.0+4066+0f1aadab 04/01/2014
 RIP: 0010:__list_del_entry_valid+0x2d/0x50
 Code: 48 8b 57 08 48 b9 00 01 00 00 00 00 ad de 48 39 c8 0f 84 ac 6e 5b 00 48 b9 22 01 00 00 00 00 ad de 48 39 ca 0f 84 cf 6e 5b 00 <48> 8b 32 48 39 fe 0f 85 af 6e 5b 00 48 8b 50 08 48 39 f2 0f 85 94
 RSP: 0018:ffffb2da005c3890 EFLAGS: 00010217
 RAX: 0000000000000000 RBX: ffff9073ba23f800 RCX: dead000000000122
 RDX: 0000000000000000 RSI: 0000000000000008 RDI: ffff9073ba23fbc8
 RBP: ffff9073ba23f890 R08: 0000000000000001 R09: 0000000000000001
 R10: 0000000000000001 R11: 0000000000000001 R12: dead000000000100
 R13: ffff9073ba23fb00 R14: 0000000000000002 R15: 0000000000000002
 FS:  00007f93e5564e40(0000) GS:ffff9073bba00000(0000) knlGS:0000000000000000
 CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
 CR2: 0000000000000000 CR3: 000000014ad34000 CR4: 0000000000350ee0
 Call Trace:
  ets_qdisc_reset+0x6e/0x100 [sch_ets]
  qdisc_reset+0x49/0x1d0
  tbf_reset+0x15/0x60 [sch_tbf]
  qdisc_reset+0x49/0x1d0
  dev_reset_queue.constprop.42+0x2f/0x90
  dev_deactivate_many+0x1d3/0x3d0
  dev_deactivate+0x56/0x90
  qdisc_graft+0x47e/0x5a0
  tc_get_qdisc+0x1db/0x3e0
  rtnetlink_rcv_msg+0x164/0x4c0
  netlink_rcv_skb+0x50/0x100
  netlink_unicast+0x1a5/0x280
  netlink_sendmsg+0x242/0x480
  sock_sendmsg+0x5b/0x60
  ____sys_sendmsg+0x1f2/0x260
  ___sys_sendmsg+0x7c/0xc0
  __sys_sendmsg+0x57/0xa0
  do_syscall_64+0x3a/0x80
  entry_SYSCALL_64_after_hwframe+0x44/0xae
 RIP: 0033:0x7f93e44b8338
 Code: 89 02 48 c7 c0 ff ff ff ff eb b5 0f 1f 80 00 00 00 00 f3 0f 1e fa 48 8d 05 25 43 2c 00 8b 00 85 c0 75 17 b8 2e 00 00 00 0f 05 <48> 3d 00 f0 ff ff 77 58 c3 0f 1f 80 00 00 00 00 41 54 41 89 d4 55
 RSP: 002b:00007ffc0db737a8 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
 RAX: ffffffffffffffda RBX: 0000000061255c06 RCX: 00007f93e44b8338
 RDX: 0000000000000000 RSI: 00007ffc0db73810 RDI: 0000000000000003
 RBP: 0000000000000000 R08: 0000000000000001 R09: 0000000000000000
 R10: 000000000000000b R11: 0000000000000246 R12: 0000000000000001
 R13: 0000000000687880 R14: 0000000000000000 R15: 0000000000000000
 Modules linked in: sch_ets sch_tbf dummy rfkill iTCO_wdt iTCO_vendor_support intel_rapl_msr intel_rapl_common joydev i2c_i801 pcspkr i2c_smbus lpc_ich virtio_balloon ip_tables xfs libcrc32c crct10dif_pclmul crc32_pclmul crc32c_intel ahci libahci ghash_clmulni_intel libata serio_raw virtio_blk virtio_console virtio_net net_failover failover sunrpc dm_mirror dm_region_hash dm_log dm_mod
 CR2: 0000000000000000

When the change() function decreases the value of 'nstrict', we must take
into account that packets might be already enqueued on a class that flips
from 'strict' to 'quantum': otherwise that class will not be added to the
bandwidth-sharing list. Then, a call to ets_qdisc_reset() will attempt to
do list_del(&alist) with 'alist' filled with zero, hence the NULL pointer
dereference.
For classes flipping from 'strict' to 'quantum', initialize an empty list
and eventually add it to the bandwidth-sharing list, if there are packets
already enqueued. In this way, the kernel will:
 a) prevent crashing as described above.
 b) avoid retaining the backlog packets (for an arbitrarily long time) in
    case no packet is enqueued after a change from 'strict' to 'quantum'.

Reported-by: Hangbin Liu <liuhangbin@gmail.com>
Fixes: dcc68b4d8084 ("net: sch_ets: Add a new Qdisc")
Signed-off-by: Davide Caratti <dcaratti@redhat.com>
---
 net/sched/sch_ets.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/net/sched/sch_ets.c b/net/sched/sch_ets.c
index c1e84d1eeaba..c76701ac35ab 100644
--- a/net/sched/sch_ets.c
+++ b/net/sched/sch_ets.c
@@ -660,6 +660,13 @@ static int ets_qdisc_change(struct Qdisc *sch, struct nlattr *opt,
 	sch_tree_lock(sch);
 
 	q->nbands = nbands;
+	for (i = nstrict; i < q->nstrict; i++) {
+		INIT_LIST_HEAD(&q->classes[i].alist);
+		if (q->classes[i].qdisc->q.qlen) {
+			list_add_tail(&q->classes[i].alist, &q->active);
+			q->classes[i].deficit = quanta[i];
+		}
+	}
 	q->nstrict = nstrict;
 	memcpy(q->prio2band, priomap, sizeof(priomap));
 
-- 
2.31.1

