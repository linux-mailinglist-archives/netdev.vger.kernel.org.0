Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 00738DEC32
	for <lists+netdev@lfdr.de>; Mon, 21 Oct 2019 14:29:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728554AbfJUM3D (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Oct 2019 08:29:03 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:4697 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727985AbfJUM3C (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 21 Oct 2019 08:29:02 -0400
Received: from DGGEMS413-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id 54A23144C352E7C2A96E;
        Mon, 21 Oct 2019 20:28:58 +0800 (CST)
Received: from localhost.localdomain (10.69.192.58) by
 DGGEMS413-HUB.china.huawei.com (10.3.19.213) with Microsoft SMTP Server id
 14.3.439.0; Mon, 21 Oct 2019 20:28:54 +0800
From:   Yunsheng Lin <linyunsheng@huawei.com>
To:     <davem@davemloft.net>
CC:     <dsahern@gmail.com>, <jiri@mellanox.com>, <allison@lohutok.net>,
        <mmanning@vyatta.att-mail.com>, <petrm@mellanox.com>,
        <dcaratti@redhat.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH RFC] net: vlan: reverse 4 bytes of vlan header when setting initial MTU
Date:   Mon, 21 Oct 2019 20:26:03 +0800
Message-ID: <1571660763-117936-1-git-send-email-linyunsheng@huawei.com>
X-Mailer: git-send-email 2.8.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.58]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently the MTU of vlan netdevice is set to the same MTU
of the lower device, which requires the underlying device
to handle it as the comment has indicated:

	/* need 4 bytes for extra VLAN header info,
	 * hope the underlying device can handle it.
	 */
	new_dev->mtu = real_dev->mtu;

Currently most of the physical netdevs seems to handle above
by reversing 2 * VLAN_HLEN for L2 packet len.

But for vlan netdev over vxlan netdev case, the vxlan does not
seems to reverse the vlan header for vlan device, which may cause
performance degradation because vxlan may emit a packet that
exceed the MTU of the physical netdev, and cause the software
TSO to happen in ip_finish_output_gso(), software TSO call stack
as below:

 => ftrace_graph_call
 => tcp_gso_segment
 => tcp4_gso_segment
 => inet_gso_segment
 => skb_mac_gso_segment
 => skb_udp_tunnel_segment
 => udp4_ufo_fragment
 => inet_gso_segment
 => skb_mac_gso_segment
 => __skb_gso_segment
 => __ip_finish_output
 => ip_output
 => ip_local_out
 => iptunnel_xmit
 => udp_tunnel_xmit_skb
 => vxlan_xmit_one
 => vxlan_xmit
 => dev_hard_start_xmit
 => __dev_queue_xmit
 => dev_queue_xmit
 => vlan_dev_hard_start_xmit
 => dev_hard_start_xmit
 => __dev_queue_xmit
 => dev_queue_xmit
 => neigh_resolve_output
 => ip_finish_output2
 => __ip_finish_output
 => ip_output
 => ip_local_out
 => __ip_queue_xmit
 => ip_queue_xmit
 => __tcp_transmit_skb
 => tcp_write_xmit
 => __tcp_push_pending_frames
 => tcp_push
 => tcp_sendmsg_locked
 => tcp_sendmsg
 => inet_sendmsg
 => sock_sendmsg
 => sock_write_iter
 => new_sync_write
 => __vfs_write
 => vfs_write
 => ksys_write
 => __arm64_sys_write
 => el0_svc_common.constprop.0
 => el0_svc_handler
 => el0_svc

This patch set initial MTU of the vlan device to the MTU of the
lower device minus vlan header to handle the above case.

Signed-off-by: Yunsheng Lin <linyunsheng@huawei.com>
---
 net/8021q/vlan.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/net/8021q/vlan.c b/net/8021q/vlan.c
index 54728d2..0c26b92 100644
--- a/net/8021q/vlan.c
+++ b/net/8021q/vlan.c
@@ -261,10 +261,9 @@ static int register_vlan_device(struct net_device *real_dev, u16 vlan_id)
 		return -ENOBUFS;
 
 	dev_net_set(new_dev, net);
-	/* need 4 bytes for extra VLAN header info,
-	 * hope the underlying device can handle it.
-	 */
-	new_dev->mtu = real_dev->mtu;
+	new_dev->mtu = real_dev->mtu - VLAN_HLEN;
+	if (new_dev->mtu < ETH_MIN_MTU)
+		new_dev->mtu = ETH_MIN_MTU;
 
 	vlan = vlan_dev_priv(new_dev);
 	vlan->vlan_proto = htons(ETH_P_8021Q);
-- 
2.8.1

