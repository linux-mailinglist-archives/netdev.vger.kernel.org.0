Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 57EDD364703
	for <lists+netdev@lfdr.de>; Mon, 19 Apr 2021 17:23:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233733AbhDSPXt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Apr 2021 11:23:49 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:57452 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234050AbhDSPXq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Apr 2021 11:23:46 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1618845796;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=8RCftbQ7lzLtp4y9Ldjpt7kP4gbAszARP64tdO1ah7A=;
        b=SojXyqQOA6UuvlEPFQzETbR9YWy82Dkh9vgrIReio8K6yaM8BPDSlPmVoBjsu5HbB8EKnJ
        H4I93BTDiSHjtryTdMyl0WBCdEEh+o8qBad6b2KlEloLkCQmvqUzu/Ibz9XAqIFBTw2siT
        iAsWRUdc7LFTYXukqfO0gxYJD9kqojo=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-482-DP1S6dM8PvuRJGubYx0mhg-1; Mon, 19 Apr 2021 11:23:14 -0400
X-MC-Unique: DP1S6dM8PvuRJGubYx0mhg-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D0D4C107ACCD;
        Mon, 19 Apr 2021 15:23:12 +0000 (UTC)
Received: from computer-6.station (unknown [10.40.195.0])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 2DACD5D9C0;
        Mon, 19 Apr 2021 15:23:10 +0000 (UTC)
From:   Davide Caratti <dcaratti@redhat.com>
To:     Pravin B Shelar <pshelar@ovn.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Sabrina Dubroca <sd@queasysnail.net>, netdev@vger.kernel.org
Cc:     echaudro@redhat.com
Subject: [PATCH net 1/2] openvswitch: fix stack OOB read while fragmenting IPv4 packets
Date:   Mon, 19 Apr 2021 17:23:05 +0200
Message-Id: <94839fa9e7995afa6139b4f65c12ac15c1a8dc2f.1618844973.git.dcaratti@redhat.com>
In-Reply-To: <cover.1618844973.git.dcaratti@redhat.com>
References: <cover.1618844973.git.dcaratti@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

running openvswitch on kernels built with KASAN, it's possible to see the
following splat while testing fragmentation of IPv4 packets:

 BUG: KASAN: stack-out-of-bounds in ip_do_fragment+0x1b03/0x1f60
 Read of size 1 at addr ffff888112fc713c by task handler2/1367

 CPU: 0 PID: 1367 Comm: handler2 Not tainted 5.12.0-rc6+ #418
 Hardware name: Red Hat KVM, BIOS 1.11.1-4.module+el8.1.0+4066+0f1aadab 04/01/2014
 Call Trace:
  dump_stack+0x92/0xc1
  print_address_description.constprop.7+0x1a/0x150
  kasan_report.cold.13+0x7f/0x111
  ip_do_fragment+0x1b03/0x1f60
  ovs_fragment+0x5bf/0x840 [openvswitch]
  do_execute_actions+0x1bd5/0x2400 [openvswitch]
  ovs_execute_actions+0xc8/0x3d0 [openvswitch]
  ovs_packet_cmd_execute+0xa39/0x1150 [openvswitch]
  genl_family_rcv_msg_doit.isra.15+0x227/0x2d0
  genl_rcv_msg+0x287/0x490
  netlink_rcv_skb+0x120/0x380
  genl_rcv+0x24/0x40
  netlink_unicast+0x439/0x630
  netlink_sendmsg+0x719/0xbf0
  sock_sendmsg+0xe2/0x110
  ____sys_sendmsg+0x5ba/0x890
  ___sys_sendmsg+0xe9/0x160
  __sys_sendmsg+0xd3/0x170
  do_syscall_64+0x33/0x40
  entry_SYSCALL_64_after_hwframe+0x44/0xae
 RIP: 0033:0x7f957079db07
 Code: c3 66 90 41 54 41 89 d4 55 48 89 f5 53 89 fb 48 83 ec 10 e8 eb ec ff ff 44 89 e2 48 89 ee 89 df 41 89 c0 b8 2e 00 00 00 0f 05 <48> 3d 00 f0 ff ff 77 35 44 89 c7 48 89 44 24 08 e8 24 ed ff ff 48
 RSP: 002b:00007f956ce35a50 EFLAGS: 00000293 ORIG_RAX: 000000000000002e
 RAX: ffffffffffffffda RBX: 0000000000000019 RCX: 00007f957079db07
 RDX: 0000000000000000 RSI: 00007f956ce35ae0 RDI: 0000000000000019
 RBP: 00007f956ce35ae0 R08: 0000000000000000 R09: 00007f9558006730
 R10: 0000000000000000 R11: 0000000000000293 R12: 0000000000000000
 R13: 00007f956ce37308 R14: 00007f956ce35f80 R15: 00007f956ce35ae0

 The buggy address belongs to the page:
 page:00000000af2a1d93 refcount:0 mapcount:0 mapping:0000000000000000 index:0x0 pfn:0x112fc7
 flags: 0x17ffffc0000000()
 raw: 0017ffffc0000000 0000000000000000 dead000000000122 0000000000000000
 raw: 0000000000000000 0000000000000000 00000000ffffffff 0000000000000000
 page dumped because: kasan: bad access detected

 addr ffff888112fc713c is located in stack of task handler2/1367 at offset 180 in frame:
  ovs_fragment+0x0/0x840 [openvswitch]

 this frame has 2 objects:
  [32, 144) 'ovs_dst'
  [192, 424) 'ovs_rt'

 Memory state around the buggy address:
  ffff888112fc7000: f3 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  ffff888112fc7080: 00 f1 f1 f1 f1 00 00 00 00 00 00 00 00 00 00 00
 >ffff888112fc7100: 00 00 00 f2 f2 f2 f2 f2 f2 00 00 00 00 00 00 00
                                         ^
  ffff888112fc7180: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  ffff888112fc7200: 00 00 00 00 00 00 f2 f2 f2 00 00 00 00 00 00 00

for IPv4 packets, ovs_fragment() uses a temporary struct dst_entry. Then,
in the following call graph:

  ip_do_fragment()
    ip_skb_dst_mtu()
      ip_dst_mtu_maybe_forward()
        ip_mtu_locked()

the pointer to struct dst_entry is used as pointer to struct rtable: this
turns the access to struct members like rt_mtu_locked into an OOB read in
the stack. Fix this changing the temporary variable used for IPv4 packets
in ovs_fragment(), similarly to what is done for IPv6 few lines below.

Fixes: d52e5a7e7ca4 ("ipv4: lock mtu in fnhe when received PMTU < net.ipv4.route.min_pmt")
Cc: <stable@vger.kernel.org>
Signed-off-by: Davide Caratti <dcaratti@redhat.com>
---
 net/openvswitch/actions.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/net/openvswitch/actions.c b/net/openvswitch/actions.c
index 92a0b67b2728..77d924ab8cdb 100644
--- a/net/openvswitch/actions.c
+++ b/net/openvswitch/actions.c
@@ -827,17 +827,17 @@ static void ovs_fragment(struct net *net, struct vport *vport,
 	}
 
 	if (key->eth.type == htons(ETH_P_IP)) {
-		struct dst_entry ovs_dst;
+		struct rtable ovs_rt = { 0 };
 		unsigned long orig_dst;
 
 		prepare_frag(vport, skb, orig_network_offset,
 			     ovs_key_mac_proto(key));
-		dst_init(&ovs_dst, &ovs_dst_ops, NULL, 1,
+		dst_init(&ovs_rt.dst, &ovs_dst_ops, NULL, 1,
 			 DST_OBSOLETE_NONE, DST_NOCOUNT);
-		ovs_dst.dev = vport->dev;
+		ovs_rt.dst.dev = vport->dev;
 
 		orig_dst = skb->_skb_refdst;
-		skb_dst_set_noref(skb, &ovs_dst);
+		skb_dst_set_noref(skb, &ovs_rt.dst);
 		IPCB(skb)->frag_max_size = mru;
 
 		ip_do_fragment(net, skb->sk, skb, ovs_vport_output);
-- 
2.30.2

