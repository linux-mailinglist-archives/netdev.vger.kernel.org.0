Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BA18936295B
	for <lists+netdev@lfdr.de>; Fri, 16 Apr 2021 22:30:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343509AbhDPUam (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Apr 2021 16:30:42 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:43214 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S245407AbhDPUak (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 16 Apr 2021 16:30:40 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1618605014;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=83+7AZM6FnWnkxRrASgOmmCVLw0kjDM4ZRNjRXY4LOM=;
        b=APcPt1eLWhcnJ0/Fl6Lu2E5F7tNi0Idrl0BhnC8DliUGWb7QeyJHSUaXna/qdlh8hTam4X
        6TCKrRdhBa3Xno81lmSouXOBvxlplnrTibkj8L4KsMb8KzUI8CGWI3RCNWOk89dYQwbXz/
        O0bxe3x1+PNW9FdnvmR/ZA9FeoZQBmk=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-543-gmD2P8ufNQuZxsTVOzToww-1; Fri, 16 Apr 2021 16:30:12 -0400
X-MC-Unique: gmD2P8ufNQuZxsTVOzToww-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A5B716D4E6;
        Fri, 16 Apr 2021 20:30:09 +0000 (UTC)
Received: from computer-6.station (unknown [10.40.194.114])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 1C9725C3F8;
        Fri, 16 Apr 2021 20:30:05 +0000 (UTC)
From:   Davide Caratti <dcaratti@redhat.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Jakub Kicinski <kuba@kernel.org>, wenxu <wenxu@ucloud.cn>,
        Shuang Li <shuali@redhat.com>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        netdev@vger.kernel.org
Subject: [PATCH net] net/sched: sch_frag: fix OOB read while processing IPv4 fragments
Date:   Fri, 16 Apr 2021 22:29:21 +0200
Message-Id: <29c95029f83aa44bcbdb5a314cb700e077df2291.1618604533.git.dcaratti@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

when the Linux kernel fragments a packet that was previously re-assembled
by the 'act_ct' action, the following splat can be seen on KASAN kernels:

 BUG: KASAN: stack-out-of-bounds in ip_do_fragment+0x1b03/0x1f60
 Read of size 1 at addr ffff88887f209574 by task ping/5640

 CPU: 29 PID: 5640 Comm: ping Tainted: G S                5.12.0-rc6+ #413
 Hardware name: Supermicro SYS-6027R-72RF/X9DRH-7TF/7F/iTF/iF, BIOS 3.0  07/26/2013
 Call Trace:
  <IRQ>
  dump_stack+0x92/0xc1
  print_address_description.constprop.7+0x1a/0x150
  kasan_report.cold.17+0x7f/0x111
  ip_do_fragment+0x1b03/0x1f60
  sch_fragment+0x4bf/0xe40
  tcf_mirred_act+0xc3d/0x11a0 [act_mirred]
  tcf_action_exec+0x104/0x3e0
  fl_classify+0x49a/0x5e0 [cls_flower]

for IPv4 packets, sch_fragment() uses a temporary struct dst_entry. Then,
in the following call graph:

  ip_fragment()
    ip_do_fragment()
      ip_skb_dst_mtu()
        ip_dst_mtu_maybe_forward()
          ip_mtu_locked()

a pointer to that struct is casted as pointer to struct rtable, hence the
OOB stack access. Fix this, changing the temporary variable used for IPv4
packets in sch_fragment(), similarly to what is done for IPv6 in the same
function.

Fixes: c129412f74e9 ("net/sched: sch_frag: add generic packet fragment support.")
Reported-by: Shuang Li <shuali@redhat.com>
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

