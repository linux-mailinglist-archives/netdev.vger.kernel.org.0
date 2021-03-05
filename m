Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E8CAD32EBC6
	for <lists+netdev@lfdr.de>; Fri,  5 Mar 2021 14:02:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229899AbhCENCB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Mar 2021 08:02:01 -0500
Received: from szxga04-in.huawei.com ([45.249.212.190]:12697 "EHLO
        szxga04-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229749AbhCENBi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 5 Mar 2021 08:01:38 -0500
Received: from DGGEMS404-HUB.china.huawei.com (unknown [172.30.72.60])
        by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4DsSVk1gvqzlT6v;
        Fri,  5 Mar 2021 20:59:26 +0800 (CST)
Received: from DESKTOP-9883QJJ.china.huawei.com (10.136.114.155) by
 DGGEMS404-HUB.china.huawei.com (10.3.19.204) with Microsoft SMTP Server id
 14.3.498.0; Fri, 5 Mar 2021 21:01:26 +0800
From:   zhudi <zhudi21@huawei.com>
To:     <j.vosburgh@gmail.com>, <davem@davemloft.net>, <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <zhudi21@huawei.com>,
        <rose.chen@huawei.com>
Subject: [PATCH] bonding: 3ad: fix a use-after-free in bond_3ad_state_machine_handle
Date:   Fri, 5 Mar 2021 21:01:20 +0800
Message-ID: <20210305130120.4128-1-zhudi21@huawei.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.136.114.155]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Di Zhu <zhudi21@huawei.com>

I use the similar test method described in link below with KASAN enabled:
https://lore.kernel.org/netdev/4c5e467e07fb410ab4135b391d663ec1@huawei.com/
soon after, KASAN reports:
[ 9041.977110] ==================================================================
[ 9041.977151] BUG: KASAN: use-after-free in bond_3ad_state_machine_handler+0x1c34/0x20b0 [bonding]
[ 9041.977156] Read of size 2 at addr ffff80394b8d70b0 by task kworker/u192:2/78492

[ 9041.977187] Workqueue: bond0 bond_3ad_state_machine_handler [bonding]
[ 9041.977190] Call trace:
[ 9041.977197]  dump_backtrace+0x0/0x310
[ 9041.977201]  show_stack+0x28/0x38
[ 9041.977207]  dump_stack+0xec/0x15c
[ 9041.977213]  print_address_description+0x68/0x2d0
[ 9041.977217]  kasan_report+0x130/0x2f0
[ 9041.977221]  __asan_load2+0x80/0xa8
[ 9041.977238]  bond_3ad_state_machine_handler+0x1c34/0x20b0 [bonding]

[ 9041.977261] Allocated by task 138336:
[ 9041.977266]  kasan_kmalloc+0xe0/0x190
[ 9041.977271]  kmem_cache_alloc_trace+0x1d8/0x468
[ 9041.977288]  bond_enslave+0x514/0x2160 [bonding]
[ 9041.977305]  bond_option_slaves_set+0x188/0x2c8 [bonding]
[ 9041.977323]  __bond_opt_set+0x1b0/0x740 [bonding]

[ 9041.977420] Freed by task 105873:
[ 9041.977425]  __kasan_slab_free+0x120/0x228
[ 9041.977429]  kasan_slab_free+0x10/0x18
[ 9041.977432]  kfree+0x90/0x468
[ 9041.977448]  slave_kobj_release+0x7c/0x98 [bonding]
[ 9041.977452]  kobject_put+0x118/0x328
[ 9041.977468]  __bond_release_one+0x688/0xa08 [bonding]
[ 9041.977660]  pci_device_remove+0x80/0x198

The root cause is that in bond_3ad_unbind_slave() the last step is
detach the port from aggregator including it. if find this aggregator
and it has not any active ports, it will call ad_clear_agg() to do clear
things, especially set aggregator->lag_ports = NULL.

But ports in aggregator->lag_ports list which is set to NULL previously
still has pointer to this aggregator through  port->aggregator, event after
this aggregator has released.

The use-after-free problem will cause some puzzling situactions,
i am not sure whether fix this problem can solve all the problems mentioned
by the link described earlier, but it did solve all problems i encountered.

Signed-off-by: Di Zhu <zhudi21@huawei.com>
---
 drivers/net/bonding/bond_3ad.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/net/bonding/bond_3ad.c b/drivers/net/bonding/bond_3ad.c
index 6908822d9773..5d5a903e899c 100644
--- a/drivers/net/bonding/bond_3ad.c
+++ b/drivers/net/bonding/bond_3ad.c
@@ -1793,6 +1793,8 @@ static void ad_agg_selection_logic(struct aggregator *agg,
 static void ad_clear_agg(struct aggregator *aggregator)
 {
 	if (aggregator) {
+		struct port *port;
+
 		aggregator->is_individual = false;
 		aggregator->actor_admin_aggregator_key = 0;
 		aggregator->actor_oper_aggregator_key = 0;
@@ -1801,6 +1803,10 @@ static void ad_clear_agg(struct aggregator *aggregator)
 		aggregator->partner_oper_aggregator_key = 0;
 		aggregator->receive_state = 0;
 		aggregator->transmit_state = 0;
+		for (port = aggregator->lag_ports; port;
+				port = port->next_port_in_aggregator)
+			if (port->aggregator == aggregator)
+				port->aggregator = NULL;
 		aggregator->lag_ports = NULL;
 		aggregator->is_active = 0;
 		aggregator->num_of_ports = 0;
-- 
2.23.0

