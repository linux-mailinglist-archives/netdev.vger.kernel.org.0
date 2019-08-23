Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 20F7C9A626
	for <lists+netdev@lfdr.de>; Fri, 23 Aug 2019 05:42:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391618AbfHWDmY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Aug 2019 23:42:24 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:60332 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1732546AbfHWDmY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 22 Aug 2019 23:42:24 -0400
Received: from DGGEMS402-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id 8BC8A4FF4B98D984327F;
        Fri, 23 Aug 2019 11:42:19 +0800 (CST)
Received: from localhost (10.177.220.209) by DGGEMS402-HUB.china.huawei.com
 (10.3.19.202) with Microsoft SMTP Server id 14.3.439.0; Fri, 23 Aug 2019
 11:42:10 +0800
From:   <zhangsha.zhang@huawei.com>
To:     <j.vosburgh@gmail.com>, <vfalico@gmail.com>, <andy@greyhouse.net>,
        <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <zhangsha.zhang@huawei.com>, <yuehaibing@huawei.com>,
        <hunongda@huawei.com>, <alex.chen@huawei.com>
Subject: [PATCH v2] bonding: force enable lacp port after link state recovery for 802.3ad
Date:   Fri, 23 Aug 2019 11:42:09 +0800
Message-ID: <20190823034209.14596-1-zhangsha.zhang@huawei.com>
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
  bonding driver receives NETDEV_DOWN notifier
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
is to call bond_3ad_handle_link_change() in bond_miimon_commit,
this function can enable lacp after port slave speed check.
As enabled, the lacp port can run its state machine normally
after link recovery.

Signed-off-by: Sha Zhang <zhangsha.zhang@huawei.com>
---
 drivers/net/bonding/bond_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/bonding/bond_main.c b/drivers/net/bonding/bond_main.c
index 931d9d9..ef4ec99 100644
--- a/drivers/net/bonding/bond_main.c
+++ b/drivers/net/bonding/bond_main.c
@@ -2206,7 +2206,7 @@ static void bond_miimon_commit(struct bonding *bond)
 			 */
 			if (BOND_MODE(bond) == BOND_MODE_8023AD &&
 			    slave->link == BOND_LINK_UP)
-				bond_3ad_adapter_speed_duplex_changed(slave);
+				bond_3ad_handle_link_change(slave, BOND_LINK_UP);
 			continue;
 
 		case BOND_LINK_UP:
-- 
1.8.3.1

