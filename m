Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6A1C92944E2
	for <lists+netdev@lfdr.de>; Wed, 21 Oct 2020 00:03:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393547AbgJTWDa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Oct 2020 18:03:30 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:39726 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2392433AbgJTWDa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Oct 2020 18:03:30 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1603231408;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=Hit0A3zU+BLs5Zn3mD9VZrgVkzbagQuBiVegcEx1zq8=;
        b=HVXyIxEqBdgA3p9IMo7gHHBWCGLMwzMDI0uvC1eZbVFUlpE3//iAKmlEZG4Xl4KQF9J+hm
        5141dlK0qJkYsfTjlgoyT9fNUz1dJRTiDp692MRoGrClJy4jPIsZRgecOd+pXqN8aEMh+i
        GCLMS7hy/QtqXMEywPD3j9RDmhECWwA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-471-QkHrJi94Nv27XsNnTbNnog-1; Tue, 20 Oct 2020 18:03:24 -0400
X-MC-Unique: QkHrJi94Nv27XsNnTbNnog-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id AD9861084D61;
        Tue, 20 Oct 2020 22:03:22 +0000 (UTC)
Received: from new-host-6.redhat.com (unknown [10.40.193.216])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 066306266E;
        Tue, 20 Oct 2020 22:03:19 +0000 (UTC)
From:   Davide Caratti <dcaratti@redhat.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jiri Pirko <jiri@resnulli.us>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>
Cc:     Simon Horman <simon.horman@netronome.com>,
        Shuang Li <shuali@redhat.com>, netdev@vger.kernel.org
Subject: [PATCH net] net/sched: act_tunnel_key: fix OOB write in case of IPv6 ERSPAN tunnels
Date:   Wed, 21 Oct 2020 00:02:40 +0200
Message-Id: <36ebe969f6d13ff59912d6464a4356fe6f103766.1603231100.git.dcaratti@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

the following command

 # tc action add action tunnel_key \
 > set src_ip 2001:db8::1 dst_ip 2001:db8::2 id 10 erspan_opts 1:6789:0:0

generates the following splat:

 BUG: KASAN: slab-out-of-bounds in tunnel_key_copy_opts+0xcc9/0x1010 [act_tunnel_key]
 Write of size 4 at addr ffff88813f5f1cc8 by task tc/873

 CPU: 2 PID: 873 Comm: tc Not tainted 5.9.0+ #282
 Hardware name: Red Hat KVM, BIOS 1.11.1-4.module+el8.1.0+4066+0f1aadab 04/01/2014
 Call Trace:
  dump_stack+0x99/0xcb
  print_address_description.constprop.7+0x1e/0x230
  kasan_report.cold.13+0x37/0x7c
  tunnel_key_copy_opts+0xcc9/0x1010 [act_tunnel_key]
  tunnel_key_init+0x160c/0x1f40 [act_tunnel_key]
  tcf_action_init_1+0x5b5/0x850
  tcf_action_init+0x15d/0x370
  tcf_action_add+0xd9/0x2f0
  tc_ctl_action+0x29b/0x3a0
  rtnetlink_rcv_msg+0x341/0x8d0
  netlink_rcv_skb+0x120/0x380
  netlink_unicast+0x439/0x630
  netlink_sendmsg+0x719/0xbf0
  sock_sendmsg+0xe2/0x110
  ____sys_sendmsg+0x5ba/0x890
  ___sys_sendmsg+0xe9/0x160
  __sys_sendmsg+0xd3/0x170
  do_syscall_64+0x33/0x40
  entry_SYSCALL_64_after_hwframe+0x44/0xa9
 RIP: 0033:0x7f872a96b338
 Code: 89 02 48 c7 c0 ff ff ff ff eb b5 0f 1f 80 00 00 00 00 f3 0f 1e fa 48 8d 05 25 43 2c 00 8b 00 85 c0 75 17 b8 2e 00 00 00 0f 05 <48> 3d 00 f0 ff ff 77 58 c3 0f 1f 80 00 00 00 00 41 54 41 89 d4 55
 RSP: 002b:00007ffffe367518 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
 RAX: ffffffffffffffda RBX: 000000005f8f5aed RCX: 00007f872a96b338
 RDX: 0000000000000000 RSI: 00007ffffe367580 RDI: 0000000000000003
 RBP: 0000000000000000 R08: 0000000000000001 R09: 000000000000001c
 R10: 000000000000000b R11: 0000000000000246 R12: 0000000000000001
 R13: 0000000000686760 R14: 0000000000000601 R15: 0000000000000000

 Allocated by task 873:
  kasan_save_stack+0x19/0x40
  __kasan_kmalloc.constprop.7+0xc1/0xd0
  __kmalloc+0x151/0x310
  metadata_dst_alloc+0x20/0x40
  tunnel_key_init+0xfff/0x1f40 [act_tunnel_key]
  tcf_action_init_1+0x5b5/0x850
  tcf_action_init+0x15d/0x370
  tcf_action_add+0xd9/0x2f0
  tc_ctl_action+0x29b/0x3a0
  rtnetlink_rcv_msg+0x341/0x8d0
  netlink_rcv_skb+0x120/0x380
  netlink_unicast+0x439/0x630
  netlink_sendmsg+0x719/0xbf0
  sock_sendmsg+0xe2/0x110
  ____sys_sendmsg+0x5ba/0x890
  ___sys_sendmsg+0xe9/0x160
  __sys_sendmsg+0xd3/0x170
  do_syscall_64+0x33/0x40
  entry_SYSCALL_64_after_hwframe+0x44/0xa9

 The buggy address belongs to the object at ffff88813f5f1c00
  which belongs to the cache kmalloc-256 of size 256
 The buggy address is located 200 bytes inside of
  256-byte region [ffff88813f5f1c00, ffff88813f5f1d00)
 The buggy address belongs to the page:
 page:0000000011b48a19 refcount:1 mapcount:0 mapping:0000000000000000 index:0x0 pfn:0x13f5f0
 head:0000000011b48a19 order:1 compound_mapcount:0
 flags: 0x17ffffc0010200(slab|head)
 raw: 0017ffffc0010200 0000000000000000 0000000d00000001 ffff888107c43400
 raw: 0000000000000000 0000000080100010 00000001ffffffff 0000000000000000
 page dumped because: kasan: bad access detected

 Memory state around the buggy address:
  ffff88813f5f1b80: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
  ffff88813f5f1c00: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
 >ffff88813f5f1c80: 00 00 00 00 00 00 00 00 00 fc fc fc fc fc fc fc
                                               ^
  ffff88813f5f1d00: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
  ffff88813f5f1d80: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc

using IPv6 tunnels, act_tunnel_key allocates a fixed amount of memory for
the tunnel metadata, but then it expects additional bytes to store tunnel
specific metadata with tunnel_key_copy_opts().

Fix the arguments of __ipv6_tun_set_dst(), so that 'md_size' contains the
size previously computed by tunnel_key_get_opts_len(), like it's done for
IPv4 tunnels.

Fixes: 0ed5269f9e41 ("net/sched: add tunnel option support to act_tunnel_key")
Reported-by: Shuang Li <shuali@redhat.com>
Signed-off-by: Davide Caratti <dcaratti@redhat.com>
---
 net/sched/act_tunnel_key.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/sched/act_tunnel_key.c b/net/sched/act_tunnel_key.c
index a229751ee8c4..85c0d0d5b9da 100644
--- a/net/sched/act_tunnel_key.c
+++ b/net/sched/act_tunnel_key.c
@@ -459,7 +459,7 @@ static int tunnel_key_init(struct net *net, struct nlattr *nla,
 
 			metadata = __ipv6_tun_set_dst(&saddr, &daddr, tos, ttl, dst_port,
 						      0, flags,
-						      key_id, 0);
+						      key_id, opts_len);
 		} else {
 			NL_SET_ERR_MSG(extack, "Missing either ipv4 or ipv6 src and dst");
 			ret = -EINVAL;
-- 
2.26.2

