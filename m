Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AB9D2307159
	for <lists+netdev@lfdr.de>; Thu, 28 Jan 2021 09:23:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231509AbhA1IWz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Jan 2021 03:22:55 -0500
Received: from szxga05-in.huawei.com ([45.249.212.191]:11525 "EHLO
        szxga05-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231408AbhA1IWx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Jan 2021 03:22:53 -0500
Received: from DGGEMS411-HUB.china.huawei.com (unknown [172.30.72.60])
        by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4DRD210N4WzjFSF;
        Thu, 28 Jan 2021 16:20:57 +0800 (CST)
Received: from huawei.com (10.137.17.51) by DGGEMS411-HUB.china.huawei.com
 (10.3.19.211) with Microsoft SMTP Server id 14.3.498.0; Thu, 28 Jan 2021
 16:22:01 +0800
From:   Aichun Li <liaichun@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <j.vosburgh@gmail.com>,
        <vfalico@gmail.com>, <andy@greyhouse.net>
CC:     <netdev@vger.kernel.org>, <rose.chen@huawei.com>,
        <liaichun@huawei.com>
Subject: [PATCH net v2]bonding: check port and aggregator when select
Date:   Thu, 28 Jan 2021 16:20:34 +0800
Message-ID: <20210128082034.866-1-liaichun@huawei.com>
X-Mailer: git-send-email 2.19.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.137.17.51]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When the network service is repeatedly restarted in 802.3ad, there is a low
 probability that oops occurs.
Test commands:systemctl restart network

1.crash: __enable_port():port->slave is NULL
crash> bt
PID: 2508692  TASK: ffff803e72a7ec80  CPU: 29  COMMAND: "kworker/u192:0"
 #0 [ffff0000b13cb5c0] machine_kexec at ffff0000800a3964
 #1 [ffff0000b13cb620] __crash_kexec at ffff0000801bf054
 #2 [ffff0000b13cb7b0] panic at ffff0000800f350c
 #3 [ffff0000b13cb890] die at ffff00008008f940
 #4 [ffff0000b13cb8e0] die_kernel_fault at ffff0000800abbc0
 #5 [ffff0000b13cb910] __do_kernel_fault at ffff0000800ab8c4
 #6 [ffff0000b13cb940] do_page_fault at ffff000080a3eb44
 #7 [ffff0000b13cba40] do_translation_fault at ffff000080a3f064
 #8 [ffff0000b13cba70] do_mem_abort at ffff0000800812cc
 #9 [ffff0000b13cbc70] el1_ia at ffff00008008320c
     PC: ffff000000e2fcd0  [ad_agg_selection_logic+328]
     LR: ffff000000e2fcb0  [ad_agg_selection_logic+296]
     SP: ffff0000b13cbc80  PSTATE: 40c00009
    X29: ffff0000b13cbc90  X28: ffff803e71c31438  X27: ffff000000e41eb8
    X26: ffff0000b13cbd97  X25: ffff000000e4c0b8  X24: ffff803e71c31400
    X23: ffff000081229000  X22: 0000000000000000  X21: ffff803e71c31400
    X20: ffff0000b13cbcf0  X19: ffff803f4c772ac0  X18: ffffffffffffffff
    X17: 0000000000000000  X16: ffff0000808acc70  X15: ffff000081229708
    X14: 7361772074756220  X13: 353335353620726f  X12: 7461676572676761
    X11: 206f742064657461  X10: 0000000000000000   X9: ffff00008122baf0
     X8: 00000000000e97a8   X7: ffff000081408080   X6: ffff805f7fa27448
     X5: ffff805f7fa27448   X4: 0000000000000000   X3: 0000000000000006
     X2: 0000000000000004   X1: 0000000000000000   X0: ffff803e739bea38
crash> struct port ffff803e739bea38
struct port {
  actor_port_number = 2,
  actor_port_priority = 255,
  actor_system = {
    mac_addr_value = "\254\215\064\037\016y"
  },
  actor_system_priority = 65535,
  actor_port_aggregator_identifier = 2094,
  ntt = false,
  actor_admin_port_key = 0,
  actor_oper_port_key = 0,
  actor_admin_port_state = 5 '\005',
  actor_oper_port_state = 3 '\003',
  partner_admin = {
    system = {
      mac_addr_value = "\000\000\000\000\000"
    },
    system_priority = 65535,
    key = 1,
    port_number = 1,
    port_priority = 255,
    port_state = 1
  },
  partner_oper = {
    system = {
      mac_addr_value = "\254\263\265\367b!"
    },
    system_priority = 32768,
    key = 1089,
    port_number = 8,
    port_priority = 32768,
    port_state = 61
  },
  is_enabled = false,
  sm_vars = 304,
  sm_rx_state = AD_RX_PORT_DISABLED,
  sm_rx_timer_counter = 26,
  sm_periodic_state = AD_NO_PERIODIC,
  sm_periodic_timer_counter = 0,
  sm_mux_state = AD_MUX_COLLECTING_DISTRIBUTING,
  sm_mux_timer_counter = 0,
  sm_tx_state = AD_TX_DUMMY,
  sm_tx_timer_counter = 1,
  sm_churn_actor_timer_counter = 0,
  sm_churn_partner_timer_counter = 0,
  churn_actor_count = 0,
  churn_partner_count = 0,
  lacpdu_send_success_count = 10,
  lacpdu_send_failure_count = 0,
  lacpdu_recv_count = 150,
  marker_info_recv_count = 0,
  marker_resp_recv_count = 0,
  marker_unkown_recv_count = 0,
  sm_churn_actor_state = AD_NO_CHURN,
  sm_churn_partner_state = AD_NO_CHURN,
  slave = 0x0,
  aggregator = 0xffff803e739bea00,
  next_port_in_aggregator = 0x0,
  transaction_id = 0,
 -- MORE --

2.I also have another call stack, same as in another person's post:
https://lore.kernel.org/netdev/52630cba-cc60-a024-8dd0-8319e5245044@huawei.com/

Signed-off-by: Aichun Li <liaichun@huawei.com>
---
 drivers/net/bonding/bond_3ad.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/bonding/bond_3ad.c b/drivers/net/bonding/bond_3ad.c
index aa001b16765a..9c8894631bdd 100644
--- a/drivers/net/bonding/bond_3ad.c
+++ b/drivers/net/bonding/bond_3ad.c
@@ -183,7 +183,7 @@ static inline void __enable_port(struct port *port)
 {
 	struct slave *slave = port->slave;
 
-	if ((slave->link == BOND_LINK_UP) && bond_slave_is_up(slave))
+	if (slave && (slave->link == BOND_LINK_UP) && bond_slave_is_up(slave))
 		bond_set_slave_active_flags(slave, BOND_SLAVE_NOTIFY_LATER);
 }
 
@@ -1516,6 +1516,7 @@ static void ad_port_selection_logic(struct port *port, bool *update_slave_arr)
 				  port->actor_port_number,
 				  port->aggregator->aggregator_identifier);
 		} else {
+			port->aggregator = &(SLAVE_AD_INFO(slave)->aggregator);
 			slave_err(bond->dev, port->slave->dev,
 				  "Port %d did not find a suitable aggregator\n",
 				  port->actor_port_number);
-- 
2.19.1

