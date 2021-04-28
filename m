Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 30EE136D83B
	for <lists+netdev@lfdr.de>; Wed, 28 Apr 2021 15:25:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239799AbhD1NZl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Apr 2021 09:25:41 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:33276 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S239634AbhD1NZk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Apr 2021 09:25:40 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1619616295;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=5y+u+DMwsxghcVFfoTlTHZRzG366gEvkNWymgFCMpkE=;
        b=feR/rXT+E2gmVPhP48vZBwJAwpnLozuuzxaPVTwYsGfRqZEkhv3TiLdrrXcEY8djoFQT6V
        xoYJQq8M5RSvgpfbzASuC5p17Fq9Z/cm6s2mZPBtIOO/6gsJ5aIfXQf8Uo6zY1E+pyMG34
        9C8jnbuiwBCmNOf9MO8gDfqAYM4RM9M=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-145-W0ysoADzORaCFUSnq0Z78A-1; Wed, 28 Apr 2021 09:24:51 -0400
X-MC-Unique: W0ysoADzORaCFUSnq0Z78A-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 16CF61856EE3;
        Wed, 28 Apr 2021 13:24:50 +0000 (UTC)
Received: from computer-6.station (unknown [10.40.192.86])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 3B2A6E159;
        Wed, 28 Apr 2021 13:24:45 +0000 (UTC)
From:   Davide Caratti <dcaratti@redhat.com>
To:     Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, wenxu <wenxu@ucloud.cn>,
        netdev@vger.kernel.org
Cc:     Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        shuali@redhat.com
Subject: [PATCH net resend 2/2] net/sched: sch_frag: fix stack OOB read while fragmenting IPv4 packets
Date:   Wed, 28 Apr 2021 15:23:14 +0200
Message-Id: <64e05d9132a7290b8b79c497ba945c4b5b6b5e8d.1619615320.git.dcaratti@redhat.com>
In-Reply-To: <cover.1619615320.git.dcaratti@redhat.com>
References: <cover.1619615320.git.dcaratti@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

when 'act_mirred' tries to fragment IPv4 packets that had been previously
re-assembled using 'act_ct', splats like the following can be observed on
kernels built with KASAN:

 BUG: KASAN: stack-out-of-bounds in ip_do_fragment+0x1b03/0x1f60
 Read of size 1 at addr ffff888147009574 by task ping/947

 CPU: 0 PID: 947 Comm: ping Not tainted 5.12.0-rc6+ #418
 Hardware name: Red Hat KVM, BIOS 1.11.1-4.module+el8.1.0+4066+0f1aadab 04/01/2014
 Call Trace:
  <IRQ>
  dump_stack+0x92/0xc1
  print_address_description.constprop.7+0x1a/0x150
  kasan_report.cold.13+0x7f/0x111
  ip_do_fragment+0x1b03/0x1f60
  sch_fragment+0x4bf/0xe40
  tcf_mirred_act+0xc3d/0x11a0 [act_mirred]
  tcf_action_exec+0x104/0x3e0
  fl_classify+0x49a/0x5e0 [cls_flower]
  tcf_classify_ingress+0x18a/0x820
  __netif_receive_skb_core+0xae7/0x3340
  __netif_receive_skb_one_core+0xb6/0x1b0
  process_backlog+0x1ef/0x6c0
  __napi_poll+0xaa/0x500
  net_rx_action+0x702/0xac0
  __do_softirq+0x1e4/0x97f
  do_softirq+0x71/0x90
  </IRQ>
  __local_bh_enable_ip+0xdb/0xf0
  ip_finish_output2+0x760/0x2120
  ip_do_fragment+0x15a5/0x1f60
  __ip_finish_output+0x4c2/0xea0
  ip_output+0x1ca/0x4d0
  ip_send_skb+0x37/0xa0
  raw_sendmsg+0x1c4b/0x2d00
  sock_sendmsg+0xdb/0x110
  __sys_sendto+0x1d7/0x2b0
  __x64_sys_sendto+0xdd/0x1b0
  do_syscall_64+0x33/0x40
  entry_SYSCALL_64_after_hwframe+0x44/0xae
 RIP: 0033:0x7f82e13853eb
 Code: 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 f3 0f 1e fa 48 8d 05 75 42 2c 00 41 89 ca 8b 00 85 c0 75 14 b8 2c 00 00 00 0f 05 <48> 3d 00 f0 ff ff 77 75 c3 0f 1f 40 00 41 57 4d 89 c7 41 56 41 89
 RSP: 002b:00007ffe01fad888 EFLAGS: 00000246 ORIG_RAX: 000000000000002c
 RAX: ffffffffffffffda RBX: 00005571aac13700 RCX: 00007f82e13853eb
 RDX: 0000000000002330 RSI: 00005571aac13700 RDI: 0000000000000003
 RBP: 0000000000002330 R08: 00005571aac10500 R09: 0000000000000010
 R10: 0000000000000000 R11: 0000000000000246 R12: 00007ffe01faefb0
 R13: 00007ffe01fad890 R14: 00007ffe01fad980 R15: 00005571aac0f0a0

 The buggy address belongs to the page:
 page:000000001dff2e03 refcount:1 mapcount:0 mapping:0000000000000000 index:0x0 pfn:0x147009
 flags: 0x17ffffc0001000(reserved)
 raw: 0017ffffc0001000 ffffea00051c0248 ffffea00051c0248 0000000000000000
 raw: 0000000000000000 0000000000000000 00000001ffffffff 0000000000000000
 page dumped because: kasan: bad access detected

 Memory state around the buggy address:
  ffff888147009400: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  ffff888147009480: f1 f1 f1 f1 04 f2 f2 f2 f2 f2 f2 f2 00 00 00 00
 >ffff888147009500: 00 00 00 00 00 00 00 00 00 00 f2 f2 f2 f2 f2 f2
                                                              ^
  ffff888147009580: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  ffff888147009600: 00 00 00 00 00 00 00 00 00 00 00 00 00 f2 f2 f2

for IPv4 packets, sch_fragment() uses a temporary struct dst_entry. Then,
in the following call graph:

  ip_do_fragment()
    ip_skb_dst_mtu()
      ip_dst_mtu_maybe_forward()
        ip_mtu_locked()

the pointer to struct dst_entry is used as pointer to struct rtable: this
turns the access to struct members like rt_mtu_locked into an OOB read in
the stack. Fix this changing the temporary variable used for IPv4 packets
in sch_fragment(), similarly to what is done for IPv6 few lines below.

Fixes: c129412f74e9 ("net/sched: sch_frag: add generic packet fragment support.")
Cc: <stable@vger.kernel.org> # 5.11
Reported-by: Shuang Li <shuali@redhat.com>
Acked-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Acked-by: Cong Wang <cong.wang@bytedance.com>
Signed-off-by: Davide Caratti <dcaratti@redhat.com>
---
 net/sched/sch_frag.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/net/sched/sch_frag.c b/net/sched/sch_frag.c
index e1e77d3fb6c0..8c06381391d6 100644
--- a/net/sched/sch_frag.c
+++ b/net/sched/sch_frag.c
@@ -90,16 +90,16 @@ static int sch_fragment(struct net *net, struct sk_buff *skb,
 	}
 
 	if (skb_protocol(skb, true) == htons(ETH_P_IP)) {
-		struct dst_entry sch_frag_dst;
+		struct rtable sch_frag_rt = { 0 };
 		unsigned long orig_dst;
 
 		sch_frag_prepare_frag(skb, xmit);
-		dst_init(&sch_frag_dst, &sch_frag_dst_ops, NULL, 1,
+		dst_init(&sch_frag_rt.dst, &sch_frag_dst_ops, NULL, 1,
 			 DST_OBSOLETE_NONE, DST_NOCOUNT);
-		sch_frag_dst.dev = skb->dev;
+		sch_frag_rt.dst.dev = skb->dev;
 
 		orig_dst = skb->_skb_refdst;
-		skb_dst_set_noref(skb, &sch_frag_dst);
+		skb_dst_set_noref(skb, &sch_frag_rt.dst);
 		IPCB(skb)->frag_max_size = mru;
 
 		ret = ip_do_fragment(net, skb->sk, skb, sch_frag_xmit);
-- 
2.30.2

