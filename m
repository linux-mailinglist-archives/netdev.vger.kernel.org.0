Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6CDF06B85E7
	for <lists+netdev@lfdr.de>; Tue, 14 Mar 2023 00:09:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230140AbjCMXJ1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Mar 2023 19:09:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32952 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229823AbjCMXJS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Mar 2023 19:09:18 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E2C3943B6
        for <netdev@vger.kernel.org>; Mon, 13 Mar 2023 16:08:55 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AF6BB6154A
        for <netdev@vger.kernel.org>; Mon, 13 Mar 2023 23:08:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C44F4C433EF;
        Mon, 13 Mar 2023 23:08:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678748934;
        bh=YyygAdHUQ/k+BqKL9zV01XhQu0cJ5Ncp+ZoL8WbYToo=;
        h=From:To:Cc:Subject:Date:From;
        b=bbaR3gYevTGeR1hZN0YigqE3R9O/DPyHYp+NnWuzqF6gIiSxe4Nashu6K7Vm84O/v
         6bhZubGL+QqL+155j2J531acejBGMG+OYhp2w7bnsHas9TXzsBukM7aKhvvmch+/kq
         /WDKEP1EYQ/hnVBLMsoZhwKQBb0g5KKEwVjZJL03rvwCASH8PEOn4wWB3Lk0erZikM
         v1kkQWVfsB+BcBQidZMPYs+IqFzF9Es9kXLNwg0J5t9mozXdET2MfCZKEJKsxumqoZ
         HDpjnOPNzxhP9cPHqIrh0fz5qPvjRjnIHgtiyYmPprIHo5wPUTqHAHTADzfHyzbiAA
         3PT9RTfUsbVRw==
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, lorenzo.bianconi@redhat.com,
        matthieu.baerts@tessares.net
Subject: [PATCH net] veth: rely on rtnl_dereference() instead of on rcu_dereference() in veth_set_xdp_features()
Date:   Tue, 14 Mar 2023 00:08:40 +0100
Message-Id: <dfd6a9a7d85e9113063165e1f47b466b90ad7b8a.1678748579.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.39.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix the following kernel warning in veth_set_xdp_features routine
relying on rtnl_dereference() instead of on rcu_dereference():

=============================
WARNING: suspicious RCU usage
6.3.0-rc1-00144-g064d70527aaa #149 Not tainted
-----------------------------
drivers/net/veth.c:1265 suspicious rcu_dereference_check() usage!

other info that might help us debug this:

rcu_scheduler_active = 2, debug_locks = 1
1 lock held by ip/135:
(net/core/rtnetlink.c:6172)

stack backtrace:
CPU: 1 PID: 135 Comm: ip Not tainted 6.3.0-rc1-00144-g064d70527aaa #149
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.15.0-1
04/01/2014
Call Trace:
 <TASK>
dump_stack_lvl (lib/dump_stack.c:107)
lockdep_rcu_suspicious (include/linux/context_tracking.h:152)
veth_set_xdp_features (drivers/net/veth.c:1265 (discriminator 9))
veth_newlink (drivers/net/veth.c:1892)
? veth_set_features (drivers/net/veth.c:1774)
? kasan_save_stack (mm/kasan/common.c:47)
? kasan_save_stack (mm/kasan/common.c:46)
? kasan_set_track (mm/kasan/common.c:52)
? alloc_netdev_mqs (include/linux/slab.h:737)
? rcu_read_lock_sched_held (kernel/rcu/update.c:125)
? trace_kmalloc (include/trace/events/kmem.h:54)
? __xdp_rxq_info_reg (net/core/xdp.c:188)
? alloc_netdev_mqs (net/core/dev.c:10657)
? rtnl_create_link (net/core/rtnetlink.c:3312)
rtnl_newlink_create (net/core/rtnetlink.c:3440)
? rtnl_link_get_net_capable.constprop.0 (net/core/rtnetlink.c:3391)
__rtnl_newlink (net/core/rtnetlink.c:3657)
? lock_downgrade (kernel/locking/lockdep.c:5321)
? rtnl_link_unregister (net/core/rtnetlink.c:3487)
rtnl_newlink (net/core/rtnetlink.c:3671)
rtnetlink_rcv_msg (net/core/rtnetlink.c:6174)
? rtnl_link_fill (net/core/rtnetlink.c:6070)
? mark_usage (kernel/locking/lockdep.c:4914)
? mark_usage (kernel/locking/lockdep.c:4914)
netlink_rcv_skb (net/netlink/af_netlink.c:2574)
? rtnl_link_fill (net/core/rtnetlink.c:6070)
? netlink_ack (net/netlink/af_netlink.c:2551)
? lock_acquire (kernel/locking/lockdep.c:467)
? net_generic (include/linux/rcupdate.h:805)
? netlink_deliver_tap (include/linux/rcupdate.h:805)
netlink_unicast (net/netlink/af_netlink.c:1340)
? netlink_attachskb (net/netlink/af_netlink.c:1350)
netlink_sendmsg (net/netlink/af_netlink.c:1942)
? netlink_unicast (net/netlink/af_netlink.c:1861)
? netlink_unicast (net/netlink/af_netlink.c:1861)
sock_sendmsg (net/socket.c:727)
____sys_sendmsg (net/socket.c:2501)
? kernel_sendmsg (net/socket.c:2448)
? __copy_msghdr (net/socket.c:2428)
___sys_sendmsg (net/socket.c:2557)
? mark_usage (kernel/locking/lockdep.c:4914)
? do_recvmmsg (net/socket.c:2544)
? lock_acquire (kernel/locking/lockdep.c:467)
? find_held_lock (kernel/locking/lockdep.c:5159)
? __lock_release (kernel/locking/lockdep.c:5345)
? __might_fault (mm/memory.c:5625)
? lock_downgrade (kernel/locking/lockdep.c:5321)
? __fget_light (include/linux/atomic/atomic-arch-fallback.h:227)
__sys_sendmsg (include/linux/file.h:31)
? __sys_sendmsg_sock (net/socket.c:2572)
? rseq_get_rseq_cs (kernel/rseq.c:275)
? lockdep_hardirqs_on_prepare.part.0 (kernel/locking/lockdep.c:4263)
do_syscall_64 (arch/x86/entry/common.c:50)
entry_SYSCALL_64_after_hwframe (arch/x86/entry/entry_64.S:120)
RIP: 0033:0x7f0d1aadeb17
Code: 0f 00 f7 d8 64 89 02 48 c7 c0 ff ff ff ff eb b9 0f 1f 00 f3 0f 1e
fa 64 8b 04 25 18 00 00 00 85 c0 75 10 b8 2e 00 00 00 0f 05 <48> 3d 00
f0 ff ff 77 51 c3 48 83 ec 28 89 54 24 1c 48 89 74 24 10

Fixes: fccca038f300 ("veth: take into account device reconfiguration for xdp_features flag")
Suggested-by: Eric Dumazet <edumazet@google.com>
Reported-by: Matthieu Baerts <matthieu.baerts@tessares.net>
Link: https://lore.kernel.org/netdev/cover.1678364612.git.lorenzo@kernel.org/T/#me4c9d8e985ec7ebee981cfdb5bc5ec651ef4035d
Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
---
 drivers/net/veth.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/veth.c b/drivers/net/veth.c
index 293dc3b2c84a..4da74ac27f9a 100644
--- a/drivers/net/veth.c
+++ b/drivers/net/veth.c
@@ -1262,7 +1262,7 @@ static void veth_set_xdp_features(struct net_device *dev)
 	struct veth_priv *priv = netdev_priv(dev);
 	struct net_device *peer;
 
-	peer = rcu_dereference(priv->peer);
+	peer = rtnl_dereference(priv->peer);
 	if (peer && peer->real_num_tx_queues <= dev->real_num_rx_queues) {
 		xdp_features_t val = NETDEV_XDP_ACT_BASIC |
 				     NETDEV_XDP_ACT_REDIRECT |
-- 
2.39.2

