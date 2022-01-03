Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 414A04835CC
	for <lists+netdev@lfdr.de>; Mon,  3 Jan 2022 18:30:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235563AbiACRaZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Jan 2022 12:30:25 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:60240 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233277AbiACRaI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Jan 2022 12:30:08 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5190B61169;
        Mon,  3 Jan 2022 17:30:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BBFC9C36AEE;
        Mon,  3 Jan 2022 17:30:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1641231007;
        bh=Ch0NtGZEkIqSBrM14f5tjhJhGFMmjni0sdxWta+UxUc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mO/OAfkSm5Cwcjerywz9FW+lXNdyLHduKyBIFdJhfLcsXsEtM1qTbDUpmV1XxDm60
         LJ9cKgZEA7+q+71EWw4MQa+/Yd06LNvpv0ApEbOCBOyUk4vPnK/DhL8lNeQB7+2sJF
         ZNjDEQsF4/f34LBUOflM5NRj1A2zggb5dF9h5eAjBHx6TNCvWeMmfgxgHQV/w1vajO
         qeiv574m3Kfr816GXKst4XEoQJtV1ssu8MQ9VeKv+fhui+vkJR0dLDol2jH88jKXJk
         zYKaNq7XoYTbXghVoJqMPPUeSVXt+Ip4Ji+7msa85x8zgmtxG9gJTcOvEJlzHNFN1g
         GJkTZo9dQt9bA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     William Zhao <wizhao@redhat.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, steffen.klassert@secunet.com,
        yoshfuji@linux-ipv6.org, dsahern@kernel.org, kuba@kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 3/8] ip6_vti: initialize __ip6_tnl_parm struct in vti6_siocdevprivate
Date:   Mon,  3 Jan 2022 12:29:56 -0500
Message-Id: <20220103173001.1613277-3-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220103173001.1613277-1-sashal@kernel.org>
References: <20220103173001.1613277-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: William Zhao <wizhao@redhat.com>

[ Upstream commit c1833c3964d5bd8c163bd4e01736a38bc473cb8a ]

The "__ip6_tnl_parm" struct was left uninitialized causing an invalid
load of random data when the "__ip6_tnl_parm" struct was used elsewhere.
As an example, in the function "ip6_tnl_xmit_ctl()", it tries to access
the "collect_md" member. With "__ip6_tnl_parm" being uninitialized and
containing random data, the UBSAN detected that "collect_md" held a
non-boolean value.

The UBSAN issue is as follows:
===============================================================
UBSAN: invalid-load in net/ipv6/ip6_tunnel.c:1025:14
load of value 30 is not a valid value for type '_Bool'
CPU: 1 PID: 228 Comm: kworker/1:3 Not tainted 5.16.0-rc4+ #8
Hardware name: Red Hat KVM, BIOS 0.5.1 01/01/2011
Workqueue: ipv6_addrconf addrconf_dad_work
Call Trace:
<TASK>
dump_stack_lvl+0x44/0x57
ubsan_epilogue+0x5/0x40
__ubsan_handle_load_invalid_value+0x66/0x70
? __cpuhp_setup_state+0x1d3/0x210
ip6_tnl_xmit_ctl.cold.52+0x2c/0x6f [ip6_tunnel]
vti6_tnl_xmit+0x79c/0x1e96 [ip6_vti]
? lock_is_held_type+0xd9/0x130
? vti6_rcv+0x100/0x100 [ip6_vti]
? lock_is_held_type+0xd9/0x130
? rcu_read_lock_bh_held+0xc0/0xc0
? lock_acquired+0x262/0xb10
dev_hard_start_xmit+0x1e6/0x820
__dev_queue_xmit+0x2079/0x3340
? mark_lock.part.52+0xf7/0x1050
? netdev_core_pick_tx+0x290/0x290
? kvm_clock_read+0x14/0x30
? kvm_sched_clock_read+0x5/0x10
? sched_clock_cpu+0x15/0x200
? find_held_lock+0x3a/0x1c0
? lock_release+0x42f/0xc90
? lock_downgrade+0x6b0/0x6b0
? mark_held_locks+0xb7/0x120
? neigh_connected_output+0x31f/0x470
? lockdep_hardirqs_on+0x79/0x100
? neigh_connected_output+0x31f/0x470
? ip6_finish_output2+0x9b0/0x1d90
? rcu_read_lock_bh_held+0x62/0xc0
? ip6_finish_output2+0x9b0/0x1d90
ip6_finish_output2+0x9b0/0x1d90
? ip6_append_data+0x330/0x330
? ip6_mtu+0x166/0x370
? __ip6_finish_output+0x1ad/0xfb0
? nf_hook_slow+0xa6/0x170
ip6_output+0x1fb/0x710
? nf_hook.constprop.32+0x317/0x430
? ip6_finish_output+0x180/0x180
? __ip6_finish_output+0xfb0/0xfb0
? lock_is_held_type+0xd9/0x130
ndisc_send_skb+0xb33/0x1590
? __sk_mem_raise_allocated+0x11cf/0x1560
? dst_output+0x4a0/0x4a0
? ndisc_send_rs+0x432/0x610
addrconf_dad_completed+0x30c/0xbb0
? addrconf_rs_timer+0x650/0x650
? addrconf_dad_work+0x73c/0x10e0
addrconf_dad_work+0x73c/0x10e0
? addrconf_dad_completed+0xbb0/0xbb0
? rcu_read_lock_sched_held+0xaf/0xe0
? rcu_read_lock_bh_held+0xc0/0xc0
process_one_work+0x97b/0x1740
? pwq_dec_nr_in_flight+0x270/0x270
worker_thread+0x87/0xbf0
? process_one_work+0x1740/0x1740
kthread+0x3ac/0x490
? set_kthread_struct+0x100/0x100
ret_from_fork+0x22/0x30
</TASK>
===============================================================

The solution is to initialize "__ip6_tnl_parm" struct to zeros in the
"vti6_siocdevprivate()" function.

Signed-off-by: William Zhao <wizhao@redhat.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv6/ip6_vti.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/ipv6/ip6_vti.c b/net/ipv6/ip6_vti.c
index 23aeeb46f99fc..99f2dc802e366 100644
--- a/net/ipv6/ip6_vti.c
+++ b/net/ipv6/ip6_vti.c
@@ -804,6 +804,8 @@ vti6_ioctl(struct net_device *dev, struct ifreq *ifr, int cmd)
 	struct net *net = dev_net(dev);
 	struct vti6_net *ip6n = net_generic(net, vti6_net_id);
 
+	memset(&p1, 0, sizeof(p1));
+
 	switch (cmd) {
 	case SIOCGETTUNNEL:
 		if (dev == ip6n->fb_tnl_dev) {
-- 
2.34.1

