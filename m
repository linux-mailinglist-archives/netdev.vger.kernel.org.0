Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2722A3339FB
	for <lists+netdev@lfdr.de>; Wed, 10 Mar 2021 11:29:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232415AbhCJK3V (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Mar 2021 05:29:21 -0500
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:59405 "EHLO
        out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229657AbhCJK24 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Mar 2021 05:28:56 -0500
Received: from compute5.internal (compute5.nyi.internal [10.202.2.45])
        by mailout.nyi.internal (Postfix) with ESMTP id 760875C018B;
        Wed, 10 Mar 2021 05:28:56 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute5.internal (MEProxy); Wed, 10 Mar 2021 05:28:56 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :message-id:mime-version:subject:to:x-me-proxy:x-me-proxy
        :x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=fManwoLDr3y0vO9fK
        hZN4h9KRdH4YTHrMgHqaRWoheI=; b=E6JadYMDY7M2CnXUOssu41qYPVsvEKklz
        dHiBIomUrHG+ZE+PZU8zdpRlX2j8t0u1jlgkKrgjrBL9yp7WcctNzdylhe/IkKGh
        CMSXwH7EFBr6PoL5Txs8umoNUjs+7mYRgvLdWMrcj4cIX+RWhfXlIqbIOtnRRUw4
        afPyetPTUIJynrBqrGfNLStbIskSZAklzugemZ1zLPJ+69HUd8CuFJlCs4ccQ9KO
        O9z1LNnggQDVRjx6hHQWCJRzpg/ZSnsrquiogUHgtCSwAxwgZ5Ot+Kf+HcGdBHq1
        OFOsVBuHs6n3iNX6PM4imuv0jOTav9zsP/MiqptYeilw8P6F0++dw==
X-ME-Sender: <xms:aJ9IYPF9SdNwcFLr9XKhEITUgHQvWcwfkyM3sIEp-xvWcsnWrrlEQA>
    <xme:aJ9IYBkvnCQA0TNEkmRnW71ywzVnqdBuFPQtw_-0S339D-hLJxQ6kmO2tH55Mc_aH
    4hskj7TNDh6TaY>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledruddukedgudeiucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgggfestdekredtre
    dttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiughoshgt
    hhdrohhrgheqnecuggftrfgrthhtvghrnhepteevgefhvefggfffkeeuffeuvdfhueehhe
    etffeikeegheevfedvgeelvdffudfhnecukfhppeekgedrvddvledrudehfedrgeegnecu
    vehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepihguohhstg
    hhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:aJ9IYC0jcNoJ08HP58pG2ZBPs49U4HvwYX6CRfkkWYiiZqAeFDtgPw>
    <xmx:aJ9IYFReHmnltbGw1bQHaapshb2EnMFCR21Vzef1MeB_XNT6ID0kuQ>
    <xmx:aJ9IYMvq9__se0TUF_QVG7UL8OqW7PG92d1C19G3MZ-lcl8U58I9qg>
    <xmx:aJ9IYOqCgghlzx-k-wm0WwLxbIIwXUfflSHDMB7ZG6hYCnJQIN9WUQ>
Received: from shredder.mellanox.com (igld-84-229-153-44.inter.net.il [84.229.153.44])
        by mail.messagingengine.com (Postfix) with ESMTPA id 48D191080063;
        Wed, 10 Mar 2021 05:28:54 -0500 (EST)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, nhorman@tuxdriver.com,
        jiri@nvidia.com, mlxsw@nvidia.com, Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net] drop_monitor: Perform cleanup upon probe registration failure
Date:   Wed, 10 Mar 2021 12:28:01 +0200
Message-Id: <20210310102801.2531062-1-idosch@idosch.org>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@nvidia.com>

In the rare case that drop_monitor fails to register its probe on the
'napi_poll' tracepoint, it will not deactivate its hysteresis timer as
part of the error path. If the hysteresis timer was armed by the shortly
lived 'kfree_skb' probe and user space retries to initiate tracing, a
warning will be emitted for trying to initialize an active object [1].

Fix this by properly undoing all the operations that were done prior to
probe registration, in both software and hardware code paths.

Note that syzkaller managed to fail probe registration by injecting a
slab allocation failure [2].

[1]
ODEBUG: init active (active state 0) object type: timer_list hint: sched_send_work+0x0/0x60 include/linux/list.h:135
WARNING: CPU: 1 PID: 8649 at lib/debugobjects.c:505 debug_print_object+0x16e/0x250 lib/debugobjects.c:505
Modules linked in:
CPU: 1 PID: 8649 Comm: syz-executor.0 Not tainted 5.11.0-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
RIP: 0010:debug_print_object+0x16e/0x250 lib/debugobjects.c:505
[...]
Call Trace:
 __debug_object_init+0x524/0xd10 lib/debugobjects.c:588
 debug_timer_init kernel/time/timer.c:722 [inline]
 debug_init kernel/time/timer.c:770 [inline]
 init_timer_key+0x2d/0x340 kernel/time/timer.c:814
 net_dm_trace_on_set net/core/drop_monitor.c:1111 [inline]
 set_all_monitor_traces net/core/drop_monitor.c:1188 [inline]
 net_dm_monitor_start net/core/drop_monitor.c:1295 [inline]
 net_dm_cmd_trace+0x720/0x1220 net/core/drop_monitor.c:1339
 genl_family_rcv_msg_doit+0x228/0x320 net/netlink/genetlink.c:739
 genl_family_rcv_msg net/netlink/genetlink.c:783 [inline]
 genl_rcv_msg+0x328/0x580 net/netlink/genetlink.c:800
 netlink_rcv_skb+0x153/0x420 net/netlink/af_netlink.c:2502
 genl_rcv+0x24/0x40 net/netlink/genetlink.c:811
 netlink_unicast_kernel net/netlink/af_netlink.c:1312 [inline]
 netlink_unicast+0x533/0x7d0 net/netlink/af_netlink.c:1338
 netlink_sendmsg+0x856/0xd90 net/netlink/af_netlink.c:1927
 sock_sendmsg_nosec net/socket.c:652 [inline]
 sock_sendmsg+0xcf/0x120 net/socket.c:672
 ____sys_sendmsg+0x6e8/0x810 net/socket.c:2348
 ___sys_sendmsg+0xf3/0x170 net/socket.c:2402
 __sys_sendmsg+0xe5/0x1b0 net/socket.c:2435
 do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
 entry_SYSCALL_64_after_hwframe+0x44/0xae

[2]
 FAULT_INJECTION: forcing a failure.
 name failslab, interval 1, probability 0, space 0, times 1
 CPU: 1 PID: 8645 Comm: syz-executor.0 Not tainted 5.11.0-syzkaller #0
 Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
 Call Trace:
  dump_stack+0xfa/0x151
  should_fail.cold+0x5/0xa
  should_failslab+0x5/0x10
  __kmalloc+0x72/0x3f0
  tracepoint_add_func+0x378/0x990
  tracepoint_probe_register+0x9c/0xe0
  net_dm_cmd_trace+0x7fc/0x1220
  genl_family_rcv_msg_doit+0x228/0x320
  genl_rcv_msg+0x328/0x580
  netlink_rcv_skb+0x153/0x420
  genl_rcv+0x24/0x40
  netlink_unicast+0x533/0x7d0
  netlink_sendmsg+0x856/0xd90
  sock_sendmsg+0xcf/0x120
  ____sys_sendmsg+0x6e8/0x810
  ___sys_sendmsg+0xf3/0x170
  __sys_sendmsg+0xe5/0x1b0
  do_syscall_64+0x2d/0x70
  entry_SYSCALL_64_after_hwframe+0x44/0xae

Fixes: 70c69274f354 ("drop_monitor: Initialize timer and work item upon tracing enable")
Fixes: 8ee2267ad33e ("drop_monitor: Convert to using devlink tracepoint")
Reported-by: syzbot+779559d6503f3a56213d@syzkaller.appspotmail.com
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
Reviewed-by: Jiri Pirko <jiri@nvidia.com>
---
I asked syzbot to test it yesterday, but didn't get a reply. Anyway, I
managed to reproduce it locally by patching the code and verified the
issue does not reproduce with the fix.
---
 net/core/drop_monitor.c | 23 +++++++++++++++++++++++
 1 file changed, 23 insertions(+)

diff --git a/net/core/drop_monitor.c b/net/core/drop_monitor.c
index 571f191c06d9..db65ce62b625 100644
--- a/net/core/drop_monitor.c
+++ b/net/core/drop_monitor.c
@@ -1053,6 +1053,20 @@ static int net_dm_hw_monitor_start(struct netlink_ext_ack *extack)
 	return 0;
 
 err_module_put:
+	for_each_possible_cpu(cpu) {
+		struct per_cpu_dm_data *hw_data = &per_cpu(dm_hw_cpu_data, cpu);
+		struct sk_buff *skb;
+
+		del_timer_sync(&hw_data->send_timer);
+		cancel_work_sync(&hw_data->dm_alert_work);
+		while ((skb = __skb_dequeue(&hw_data->drop_queue))) {
+			struct devlink_trap_metadata *hw_metadata;
+
+			hw_metadata = NET_DM_SKB_CB(skb)->hw_metadata;
+			net_dm_hw_metadata_free(hw_metadata);
+			consume_skb(skb);
+		}
+	}
 	module_put(THIS_MODULE);
 	return rc;
 }
@@ -1134,6 +1148,15 @@ static int net_dm_trace_on_set(struct netlink_ext_ack *extack)
 err_unregister_trace:
 	unregister_trace_kfree_skb(ops->kfree_skb_probe, NULL);
 err_module_put:
+	for_each_possible_cpu(cpu) {
+		struct per_cpu_dm_data *data = &per_cpu(dm_cpu_data, cpu);
+		struct sk_buff *skb;
+
+		del_timer_sync(&data->send_timer);
+		cancel_work_sync(&data->dm_alert_work);
+		while ((skb = __skb_dequeue(&data->drop_queue)))
+			consume_skb(skb);
+	}
 	module_put(THIS_MODULE);
 	return rc;
 }
-- 
2.29.2

