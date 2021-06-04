Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A75C339B9B3
	for <lists+netdev@lfdr.de>; Fri,  4 Jun 2021 15:19:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230250AbhFDNVG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Jun 2021 09:21:06 -0400
Received: from stargate.chelsio.com ([12.32.117.8]:51913 "EHLO
        stargate.chelsio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230004AbhFDNVF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Jun 2021 09:21:05 -0400
Received: from localhost (scalar.blr.asicdesigners.com [10.193.185.94])
        by stargate.chelsio.com (8.13.8/8.13.8) with ESMTP id 154DJB4N018327;
        Fri, 4 Jun 2021 06:19:12 -0700
From:   Rahul Lakkireddy <rahul.lakkireddy@chelsio.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, rajur@chelsio.com
Subject: [PATCH net] cxgb4: avoid link re-train during TC-MQPRIO configuration
Date:   Fri,  4 Jun 2021 16:48:18 +0530
Message-Id: <1622805498-26094-1-git-send-email-rahul.lakkireddy@chelsio.com>
X-Mailer: git-send-email 2.5.3
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When configuring TC-MQPRIO offload, only turn off netdev carrier and
don't bring physical link down in hardware. Otherwise, when the
physical link is brought up again after configuration, it gets
re-trained and stalls ongoing traffic.

Also, when firmware is no longer accessible or crashed, avoid sending
FLOWC and waiting for reply that will never come.

Fix following hung_task_timeout_secs trace seen in these cases.

INFO: task tc:20807 blocked for more than 122 seconds.
      Tainted: G S                5.13.0-rc3+ #122
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
task:tc   state:D stack:14768 pid:20807 ppid: 19366 flags:0x00000000
Call Trace:
 __schedule+0x27b/0x6a0
 schedule+0x37/0xa0
 schedule_preempt_disabled+0x5/0x10
 __mutex_lock.isra.14+0x2a0/0x4a0
 ? netlink_lookup+0x120/0x1a0
 ? rtnl_fill_ifinfo+0x10f0/0x10f0
 __netlink_dump_start+0x70/0x250
 rtnetlink_rcv_msg+0x28b/0x380
 ? rtnl_fill_ifinfo+0x10f0/0x10f0
 ? rtnl_calcit.isra.42+0x120/0x120
 netlink_rcv_skb+0x4b/0xf0
 netlink_unicast+0x1a0/0x280
 netlink_sendmsg+0x216/0x440
 sock_sendmsg+0x56/0x60
 __sys_sendto+0xe9/0x150
 ? handle_mm_fault+0x6d/0x1b0
 ? do_user_addr_fault+0x1c5/0x620
 __x64_sys_sendto+0x1f/0x30
 do_syscall_64+0x3c/0x80
 entry_SYSCALL_64_after_hwframe+0x44/0xae
RIP: 0033:0x7f7f73218321
RSP: 002b:00007ffd19626208 EFLAGS: 00000246 ORIG_RAX: 000000000000002c
RAX: ffffffffffffffda RBX: 000055b7c0a8b240 RCX: 00007f7f73218321
RDX: 0000000000000028 RSI: 00007ffd19626210 RDI: 0000000000000003
RBP: 000055b7c08680ff R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 000055b7c085f5f6
R13: 000055b7c085f60a R14: 00007ffd19636470 R15: 00007ffd196262a0

Fixes: b1396c2bd675 ("cxgb4: parse and configure TC-MQPRIO offload")
Signed-off-by: Rahul Lakkireddy <rahul.lakkireddy@chelsio.com>
---
 drivers/net/ethernet/chelsio/cxgb4/cxgb4.h           | 2 --
 drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c      | 4 ++--
 drivers/net/ethernet/chelsio/cxgb4/cxgb4_tc_mqprio.c | 9 ++++++---
 drivers/net/ethernet/chelsio/cxgb4/sge.c             | 6 ++++++
 4 files changed, 14 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/chelsio/cxgb4/cxgb4.h b/drivers/net/ethernet/chelsio/cxgb4/cxgb4.h
index 314f8d806723..9058f09f921e 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/cxgb4.h
+++ b/drivers/net/ethernet/chelsio/cxgb4/cxgb4.h
@@ -2177,8 +2177,6 @@ int cxgb4_update_mac_filt(struct port_info *pi, unsigned int viid,
 			  bool persistent, u8 *smt_idx);
 int cxgb4_get_msix_idx_from_bmap(struct adapter *adap);
 void cxgb4_free_msix_idx_in_bmap(struct adapter *adap, u32 msix_idx);
-int cxgb_open(struct net_device *dev);
-int cxgb_close(struct net_device *dev);
 void cxgb4_enable_rx(struct adapter *adap, struct sge_rspq *q);
 void cxgb4_quiesce_rx(struct sge_rspq *q);
 int cxgb4_port_mirror_alloc(struct net_device *dev);
diff --git a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c
index 421bd9b88028..1f601de02e70 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c
+++ b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c
@@ -2834,7 +2834,7 @@ static void cxgb_down(struct adapter *adapter)
 /*
  * net_device operations
  */
-int cxgb_open(struct net_device *dev)
+static int cxgb_open(struct net_device *dev)
 {
 	struct port_info *pi = netdev_priv(dev);
 	struct adapter *adapter = pi->adapter;
@@ -2882,7 +2882,7 @@ int cxgb_open(struct net_device *dev)
 	return err;
 }
 
-int cxgb_close(struct net_device *dev)
+static int cxgb_close(struct net_device *dev)
 {
 	struct port_info *pi = netdev_priv(dev);
 	struct adapter *adapter = pi->adapter;
diff --git a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_tc_mqprio.c b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_tc_mqprio.c
index 6c259de96f96..338b04f339b3 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_tc_mqprio.c
+++ b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_tc_mqprio.c
@@ -589,7 +589,8 @@ int cxgb4_setup_tc_mqprio(struct net_device *dev,
 	 * down before configuring tc params.
 	 */
 	if (netif_running(dev)) {
-		cxgb_close(dev);
+		netif_tx_stop_all_queues(dev);
+		netif_carrier_off(dev);
 		needs_bring_up = true;
 	}
 
@@ -615,8 +616,10 @@ int cxgb4_setup_tc_mqprio(struct net_device *dev,
 	}
 
 out:
-	if (needs_bring_up)
-		cxgb_open(dev);
+	if (needs_bring_up) {
+		netif_tx_start_all_queues(dev);
+		netif_carrier_on(dev);
+	}
 
 	mutex_unlock(&adap->tc_mqprio->mqprio_mutex);
 	return ret;
diff --git a/drivers/net/ethernet/chelsio/cxgb4/sge.c b/drivers/net/ethernet/chelsio/cxgb4/sge.c
index 1e5f2edb70cf..6a099cb34b12 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/sge.c
+++ b/drivers/net/ethernet/chelsio/cxgb4/sge.c
@@ -2556,6 +2556,12 @@ int cxgb4_ethofld_send_flowc(struct net_device *dev, u32 eotid, u32 tc)
 	if (!eosw_txq)
 		return -ENOMEM;
 
+	if (!(adap->flags & CXGB4_FW_OK)) {
+		/* Don't stall caller when access to FW is lost */
+		complete(&eosw_txq->completion);
+		return -EIO;
+	}
+
 	skb = alloc_skb(len, GFP_KERNEL);
 	if (!skb)
 		return -ENOMEM;
-- 
2.27.0

