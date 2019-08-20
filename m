Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8BC3F96042
	for <lists+netdev@lfdr.de>; Tue, 20 Aug 2019 15:38:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729929AbfHTNij (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Aug 2019 09:38:39 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:39258 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728947AbfHTNii (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 20 Aug 2019 09:38:38 -0400
Received: from DGGEMS403-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id 9E7C1243BF4AA7F1792B;
        Tue, 20 Aug 2019 21:38:29 +0800 (CST)
Received: from localhost (10.177.220.209) by DGGEMS403-HUB.china.huawei.com
 (10.3.19.203) with Microsoft SMTP Server id 14.3.439.0; Tue, 20 Aug 2019
 21:38:23 +0800
From:   <zhangsha.zhang@huawei.com>
To:     <j.vosburgh@gmail.com>, <vfalico@gmail.com>, <andy@greyhouse.net>,
        <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <zhangsha.zhang@huawei.com>, <yuehaibing@huawei.com>,
        <hunongda@huawei.com>, <alex.chen@huawei.com>
Subject: [PATCH] bonding: force enable lacp port after link state recovery for 802.3ad
Date:   Tue, 20 Aug 2019 21:38:22 +0800
Message-ID: <20190820133822.2508-1-zhangsha.zhang@huawei.com>
X-Mailer: git-send-email 2.17.0.windows.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.177.220.209]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Sha Zhang <zhangsha.zhang@huawei.com>

After the commit 334031219a84 ("bonding/802.3ad: fix slave link
initialization transition states") merged,
the slave's link status will be changed to BOND_LINK_FAIL
from BOND_LINK_DOWN in the following scenario:
- Driver reports loss of carrier and
  bonding driver receives NETDEV_CHANGE notifier
- slave's duplex and speed is zerod and
  its port->is_enabled is cleard to 'false';
- Driver reports link recovery and
  bonding driver receives NETDEV_UP notifier;
- If speed/duplex getting failed here, the link status
  will be changed to BOND_LINK_FAIL;
- The MII monotor later recover the slave's speed/duplex
  and set link status to BOND_LINK_UP, but remains
  the 'port->is_enabled' to 'false'.

In this scenario, the lacp port will not be enabled even its speed
and duplex are valid. The bond will not send LACPDU's, and its
state is 'AD_STATE_DEFAULTED' forever. The simplest fix I think
is to force enable lacp after port slave speed check in
bond_miimon_commit. As enabled, the lacp port can run its state machine
normally after link recovery.

Signed-off-by: Sha Zhang <zhangsha.zhang@huawei.com>
---
 drivers/net/bonding/bond_main.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/net/bonding/bond_main.c b/drivers/net/bonding/bond_main.c
index 931d9d9..379253a 100644
--- a/drivers/net/bonding/bond_main.c
+++ b/drivers/net/bonding/bond_main.c
@@ -2194,6 +2194,7 @@ static void bond_miimon_commit(struct bonding *bond)
 {
 	struct list_head *iter;
 	struct slave *slave, *primary;
+	struct port *port;
 
 	bond_for_each_slave(bond, slave, iter) {
 		switch (slave->new_link) {
@@ -2205,8 +2206,13 @@ static void bond_miimon_commit(struct bonding *bond)
 			 * link status
 			 */
 			if (BOND_MODE(bond) == BOND_MODE_8023AD &&
-			    slave->link == BOND_LINK_UP)
+			    slave->link == BOND_LINK_UP) {
 				bond_3ad_adapter_speed_duplex_changed(slave);
+				if (slave->duplex == DUPLEX_FULL) {
+					port = &(SLAVE_AD_INFO(slave)->port);
+					port->is_enabled = true;
+				}
+			}
 			continue;
 
 		case BOND_LINK_UP:
-- 
1.8.3.1

