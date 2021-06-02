Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 98E223989F0
	for <lists+netdev@lfdr.de>; Wed,  2 Jun 2021 14:45:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230122AbhFBMqu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Jun 2021 08:46:50 -0400
Received: from szxga01-in.huawei.com ([45.249.212.187]:2852 "EHLO
        szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230121AbhFBMqq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Jun 2021 08:46:46 -0400
Received: from dggemv704-chm.china.huawei.com (unknown [172.30.72.55])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4Fw7sY5RRwzWr04;
        Wed,  2 Jun 2021 20:40:17 +0800 (CST)
Received: from dggpemm500021.china.huawei.com (7.185.36.109) by
 dggemv704-chm.china.huawei.com (10.3.19.47) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Wed, 2 Jun 2021 20:45:00 +0800
Received: from DESKTOP-9883QJJ.china.huawei.com (10.136.114.155) by
 dggpemm500021.china.huawei.com (7.185.36.109) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Wed, 2 Jun 2021 20:45:00 +0800
From:   zhudi <zhudi21@huawei.com>
To:     <j.vosburgh@gmail.com>, <vfalico@gmail.com>, <kuba@kernel.org>,
        <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <zhudi21@huawei.com>,
        <rose.chen@huawei.com>
Subject: [PATCH] bonding: 3ad: fix a crash in agg_device_up()
Date:   Wed, 2 Jun 2021 20:44:48 +0800
Message-ID: <20210602124448.49828-1-zhudi21@huawei.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.136.114.155]
X-ClientProxiedBy: dggems705-chm.china.huawei.com (10.3.19.182) To
 dggpemm500021.china.huawei.com (7.185.36.109)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Di Zhu <zhudi21@huawei.com>

When doing the test of restarting the network card, the system is
broken because the port->slave is null pointer in agg_device_up().
After in-depth investigation, we found the real cause: in
bond_3ad_unbind_slave()  if there are no active ports in the
aggregator to be deleted, the ad_clear_agg() will be called to
set "aggregator->lag_ports = NULL", but the ports originally
belonging to the aggregator are still linked together.

Before bond_3ad_unbind_slave():
	aggregator4->lag_ports = port1->port2->port3
After bond_3ad_unbind_slave():
	aggregator4->lag_ports = NULL
	port1->port2->port3

After the port2 is deleted, the port is still  remain in the linked
list: because the port does not belong to any agg, so unbind do
nothing for this port.

After a while, bond_3ad_state_machine_handler() will run and
traverse each existing port, trying to bind each port to the
newly selected agg, such as:
	if (!found) {
		if (free_aggregator) {
			...
			port->aggregator->lag_ports = port;
			...
		}
	}
After this operation, the link list looks like this:
	 aggregator1->lag_ports = port1->port2(has been deleted)->port3

After that, just traverse the linked list of agg1 and access the
port2->slave, the crash will happen.

The easiest way to fix it is: if a port does not belong to any agg, delete
it from the list and wait for the state machine to select the agg again

Signed-off-by: Di Zhu <zhudi21@huawei.com>
---
 drivers/net/bonding/bond_3ad.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/net/bonding/bond_3ad.c b/drivers/net/bonding/bond_3ad.c
index 6908822d9773..1d6ff4e1ed28 100644
--- a/drivers/net/bonding/bond_3ad.c
+++ b/drivers/net/bonding/bond_3ad.c
@@ -1793,6 +1793,8 @@ static void ad_agg_selection_logic(struct aggregator *agg,
 static void ad_clear_agg(struct aggregator *aggregator)
 {
 	if (aggregator) {
+		struct port *port, *next;
+
 		aggregator->is_individual = false;
 		aggregator->actor_admin_aggregator_key = 0;
 		aggregator->actor_oper_aggregator_key = 0;
@@ -1801,6 +1803,11 @@ static void ad_clear_agg(struct aggregator *aggregator)
 		aggregator->partner_oper_aggregator_key = 0;
 		aggregator->receive_state = 0;
 		aggregator->transmit_state = 0;
+		for (port = aggregator->lag_ports; port; port = next) {
+			next = port->next_port_in_aggregator;
+			if (port->aggregator == aggregator)
+				port->next_port_in_aggregator = NULL;
+		}
 		aggregator->lag_ports = NULL;
 		aggregator->is_active = 0;
 		aggregator->num_of_ports = 0;
-- 
2.23.0

