Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7085989844
	for <lists+netdev@lfdr.de>; Mon, 12 Aug 2019 09:50:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726799AbfHLHu3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Aug 2019 03:50:29 -0400
Received: from mail1.windriver.com ([147.11.146.13]:45943 "EHLO
        mail1.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726655AbfHLHu3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Aug 2019 03:50:29 -0400
Received: from ALA-HCA.corp.ad.wrs.com ([147.11.189.40])
        by mail1.windriver.com (8.15.2/8.15.1) with ESMTPS id x7C7ilYt025200
        (version=TLSv1 cipher=AES128-SHA bits=128 verify=FAIL);
        Mon, 12 Aug 2019 00:44:47 -0700 (PDT)
Received: from pek-yxue-d1.wrs.com (128.224.155.90) by ALA-HCA.corp.ad.wrs.com
 (147.11.189.40) with Microsoft SMTP Server id 14.3.468.0; Mon, 12 Aug 2019
 00:44:47 -0700
From:   Ying Xue <ying.xue@windriver.com>
To:     <davem@davemloft.net>, <netdev@vger.kernel.org>
CC:     <jon.maloy@ericsson.com>, <hdanton@sina.com>,
        <tipc-discussion@lists.sourceforge.net>,
        <syzkaller-bugs@googlegroups.com>, <jakub.kicinski@netronome.com>
Subject: [PATCH v2 3/3] tipc: fix issue of calling smp_processor_id() in preemptible
Date:   Mon, 12 Aug 2019 15:32:42 +0800
Message-ID: <1565595162-1383-4-git-send-email-ying.xue@windriver.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1565595162-1383-1-git-send-email-ying.xue@windriver.com>
References: <1565595162-1383-1-git-send-email-ying.xue@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

syzbot found the following issue:

[   81.119772][ T8612] BUG: using smp_processor_id() in preemptible [00000000] code: syz-executor834/8612
[   81.136212][ T8612] caller is dst_cache_get+0x3d/0xb0
[   81.141450][ T8612] CPU: 0 PID: 8612 Comm: syz-executor834 Not tainted 5.2.0-rc6+ #48
[   81.149435][ T8612] Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
[   81.159480][ T8612] Call Trace:
[   81.162789][ T8612]  dump_stack+0x172/0x1f0
[   81.167123][ T8612]  debug_smp_processor_id+0x251/0x280
[   81.172479][ T8612]  dst_cache_get+0x3d/0xb0
[   81.176928][ T8612]  tipc_udp_xmit.isra.0+0xc4/0xb80
[   81.182046][ T8612]  ? kasan_kmalloc+0x9/0x10
[   81.186531][ T8612]  ? tipc_udp_addr2str+0x170/0x170
[   81.191641][ T8612]  ? __copy_skb_header+0x2e8/0x560
[   81.196750][ T8612]  ? __skb_checksum_complete+0x3f0/0x3f0
[   81.202364][ T8612]  ? netdev_alloc_frag+0x1b0/0x1b0
[   81.207452][ T8612]  ? skb_copy_header+0x21/0x2b0
[   81.212282][ T8612]  ? __pskb_copy_fclone+0x516/0xc90
[   81.217470][ T8612]  tipc_udp_send_msg+0x29a/0x4b0
[   81.222400][ T8612]  tipc_bearer_xmit_skb+0x16c/0x360
[   81.227585][ T8612]  tipc_enable_bearer+0xabe/0xd20
[   81.232606][ T8612]  ? __nla_validate_parse+0x2d0/0x1ee0
[   81.238048][ T8612]  ? tipc_bearer_xmit_skb+0x360/0x360
[   81.243401][ T8612]  ? nla_memcpy+0xb0/0xb0
[   81.247710][ T8612]  ? nla_memcpy+0xb0/0xb0
[   81.252020][ T8612]  ? __nla_parse+0x43/0x60
[   81.256417][ T8612]  __tipc_nl_bearer_enable+0x2de/0x3a0
[   81.261856][ T8612]  ? __tipc_nl_bearer_enable+0x2de/0x3a0
[   81.267467][ T8612]  ? tipc_nl_bearer_disable+0x40/0x40
[   81.272848][ T8612]  ? unwind_get_return_address+0x58/0xa0
[   81.278501][ T8612]  ? lock_acquire+0x16f/0x3f0
[   81.283190][ T8612]  tipc_nl_bearer_enable+0x23/0x40
[   81.288300][ T8612]  genl_family_rcv_msg+0x74b/0xf90
[   81.293404][ T8612]  ? genl_unregister_family+0x790/0x790
[   81.298935][ T8612]  ? __lock_acquire+0x54f/0x5490
[   81.303852][ T8612]  ? __netlink_lookup+0x3fa/0x7b0
[   81.308865][ T8612]  genl_rcv_msg+0xca/0x16c
[   81.313266][ T8612]  netlink_rcv_skb+0x177/0x450
[   81.318043][ T8612]  ? genl_family_rcv_msg+0xf90/0xf90
[   81.323311][ T8612]  ? netlink_ack+0xb50/0xb50
[   81.327906][ T8612]  ? lock_acquire+0x16f/0x3f0
[   81.332589][ T8612]  ? kasan_check_write+0x14/0x20
[   81.337511][ T8612]  genl_rcv+0x29/0x40
[   81.341485][ T8612]  netlink_unicast+0x531/0x710
[   81.346268][ T8612]  ? netlink_attachskb+0x770/0x770
[   81.351374][ T8612]  ? _copy_from_iter_full+0x25d/0x8c0
[   81.356765][ T8612]  ? __sanitizer_cov_trace_cmp8+0x18/0x20
[   81.362479][ T8612]  ? __check_object_size+0x3d/0x42f
[   81.367667][ T8612]  netlink_sendmsg+0x8ae/0xd70
[   81.372415][ T8612]  ? netlink_unicast+0x710/0x710
[   81.377520][ T8612]  ? aa_sock_msg_perm.isra.0+0xba/0x170
[   81.383051][ T8612]  ? apparmor_socket_sendmsg+0x2a/0x30
[   81.388530][ T8612]  ? __sanitizer_cov_trace_const_cmp4+0x16/0x20
[   81.394775][ T8612]  ? security_socket_sendmsg+0x8d/0xc0
[   81.400240][ T8612]  ? netlink_unicast+0x710/0x710
[   81.405161][ T8612]  sock_sendmsg+0xd7/0x130
[   81.409561][ T8612]  ___sys_sendmsg+0x803/0x920
[   81.414220][ T8612]  ? copy_msghdr_from_user+0x430/0x430
[   81.419667][ T8612]  ? _raw_spin_unlock_irqrestore+0x6b/0xe0
[   81.425461][ T8612]  ? debug_object_active_state+0x25d/0x380
[   81.431255][ T8612]  ? __lock_acquire+0x54f/0x5490
[   81.436174][ T8612]  ? kasan_check_read+0x11/0x20
[   81.441208][ T8612]  ? _raw_spin_unlock_irqrestore+0xa4/0xe0
[   81.447008][ T8612]  ? mark_held_locks+0xf0/0xf0
[   81.451768][ T8612]  ? __call_rcu.constprop.0+0x28b/0x720
[   81.457298][ T8612]  ? call_rcu+0xb/0x10
[   81.461353][ T8612]  ? __sanitizer_cov_trace_const_cmp4+0x16/0x20
[   81.467589][ T8612]  ? __fget_light+0x1a9/0x230
[   81.472249][ T8612]  ? __fdget+0x1b/0x20
[   81.476301][ T8612]  ? __sanitizer_cov_trace_const_cmp8+0x18/0x20
[   81.482545][ T8612]  __sys_sendmsg+0x105/0x1d0
[   81.487115][ T8612]  ? __ia32_sys_shutdown+0x80/0x80
[   81.492208][ T8612]  ? blkcg_maybe_throttle_current+0x5e2/0xfb0
[   81.498272][ T8612]  ? trace_hardirqs_on_thunk+0x1a/0x1c
[   81.503726][ T8612]  ? do_syscall_64+0x26/0x680
[   81.508385][ T8612]  ? entry_SYSCALL_64_after_hwframe+0x49/0xbe
[   81.514444][ T8612]  ? do_syscall_64+0x26/0x680
[   81.519110][ T8612]  __x64_sys_sendmsg+0x78/0xb0
[   81.523862][ T8612]  do_syscall_64+0xfd/0x680
[   81.528352][ T8612]  entry_SYSCALL_64_after_hwframe+0x49/0xbe
[   81.534234][ T8612] RIP: 0033:0x444679
[   81.538114][ T8612] Code: 18 89 d0 c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 0f 83 1b d8 fb ff c3 66 2e 0f 1f 84 00 00 00 00
[   81.557709][ T8612] RSP: 002b:00007fff0201a8b8 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
[   81.566147][ T8612] RAX: ffffffffffffffda RBX: 00000000004002e0 RCX: 0000000000444679
[   81.574108][ T8612] RDX: 0000000000000000 RSI: 0000000020000580 RDI: 0000000000000003
[   81.582152][ T8612] RBP: 00000000006cf018 R08: 0000000000000001 R09: 00000000004002e0
[   81.590113][ T8612] R10: 0000000000000008 R11: 0000000000000246 R12: 0000000000402320
[   81.598089][ T8612] R13: 00000000004023b0 R14: 0000000000000000 R15: 0000000000

In commit e9c1a793210f ("tipc: add dst_cache support for udp media")
dst_cache_get() was introduced to be called in tipc_udp_xmit(). But
smp_processor_id() called by dst_cache_get() cannot be invoked in
preemptible context, as a result, the complaint above was reported.

Fixes: e9c1a793210f ("tipc: add dst_cache support for udp media")
Reported-by: syzbot+1a68504d96cd17b33a05@syzkaller.appspotmail.com
Signed-off-by: Hillf Danton <hdanton@sina.com>
Signed-off-by: Ying Xue <ying.xue@windriver.com>
---
 net/tipc/udp_media.c | 12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/net/tipc/udp_media.c b/net/tipc/udp_media.c
index 287df687..ca3ae2e 100644
--- a/net/tipc/udp_media.c
+++ b/net/tipc/udp_media.c
@@ -224,6 +224,8 @@ static int tipc_udp_send_msg(struct net *net, struct sk_buff *skb,
 	struct udp_bearer *ub;
 	int err = 0;
 
+	local_bh_disable();
+
 	if (skb_headroom(skb) < UDP_MIN_HEADROOM) {
 		err = pskb_expand_head(skb, UDP_MIN_HEADROOM, 0, GFP_ATOMIC);
 		if (err)
@@ -237,9 +239,12 @@ static int tipc_udp_send_msg(struct net *net, struct sk_buff *skb,
 		goto out;
 	}
 
-	if (addr->broadcast != TIPC_REPLICAST_SUPPORT)
-		return tipc_udp_xmit(net, skb, ub, src, dst,
-				     &ub->rcast.dst_cache);
+	if (addr->broadcast != TIPC_REPLICAST_SUPPORT) {
+		err = tipc_udp_xmit(net, skb, ub, src, dst,
+				    &ub->rcast.dst_cache);
+		local_bh_enable();
+		return err;
+	}
 
 	/* Replicast, send an skb to each configured IP address */
 	list_for_each_entry_rcu(rcast, &ub->rcast.list, list) {
@@ -259,6 +264,7 @@ static int tipc_udp_send_msg(struct net *net, struct sk_buff *skb,
 	err = 0;
 out:
 	kfree_skb(skb);
+	local_bh_enable();
 	return err;
 }
 
-- 
2.7.4

