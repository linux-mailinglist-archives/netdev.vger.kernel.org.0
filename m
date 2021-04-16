Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E073A361740
	for <lists+netdev@lfdr.de>; Fri, 16 Apr 2021 03:54:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237946AbhDPByn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Apr 2021 21:54:43 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:16927 "EHLO
        szxga06-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235043AbhDPBym (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Apr 2021 21:54:42 -0400
Received: from DGGEMS412-HUB.china.huawei.com (unknown [172.30.72.58])
        by szxga06-in.huawei.com (SkyGuard) with ESMTP id 4FLzjh0lxCzkkW7;
        Fri, 16 Apr 2021 09:52:24 +0800 (CST)
Received: from huawei.com (10.175.112.154) by DGGEMS412-HUB.china.huawei.com
 (10.3.19.212) with Microsoft SMTP Server id 14.3.498.0; Fri, 16 Apr 2021
 09:54:07 +0800
From:   jinyiting <jinyiting@huawei.com>
To:     <j.vosburgh@gmail.com>, <vfalico@gmail.com>, <andy@greyhouse.net>,
        <davem@davemloft.net>, <kuba@kernel.org>, <netdev@vger.kernel.org>,
        <security@kernel.org>, <linux-kernel@vger.kernel.org>
CC:     <xuhanbing@huawei.com>, <wangxiaogang3@huawei.com>
Subject: [PATCH] bonding: 3ad: update slave arr after initialize
Date:   Fri, 16 Apr 2021 09:53:02 +0800
Message-ID: <1618537982-454-1-git-send-email-jinyiting@huawei.com>
X-Mailer: git-send-email 1.7.12.4
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.175.112.154]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: jin yiting <jinyiting@huawei.com>

The bond works in mode 4, and performs down/up operations on the bond
that is normally negotiated. The probability of bond-> slave_arr is NULL

Test commands:
    ifconfig bond1 down
    ifconfig bond1 up

The conflict occurs in the following process：

__dev_open (CPU A)
 --bond_open
   --queue_delayed_work(bond->wq,&bond->ad_work,0);
   --bond_update_slave_arr
     --bond_3ad_get_active_agg_info

ad_work(CPU B)
 --bond_3ad_state_machine_handler
   --ad_agg_selection_logic

ad_work runs on cpu B. In the function ad_agg_selection_logic, all
agg->is_active will be cleared. Before the new active aggregator is
selected on CPU B, bond_3ad_get_active_agg_info failed on CPU A,
bond->slave_arr will be set to NULL. The best aggregator in
ad_agg_selection_logic has not changed, no need to update slave arr.

Signed-off-by: jin yiting <jinyiting@huawei.com>
---
 drivers/net/bonding/bond_3ad.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/net/bonding/bond_3ad.c b/drivers/net/bonding/bond_3ad.c
index 6908822..d100079 100644
--- a/drivers/net/bonding/bond_3ad.c
+++ b/drivers/net/bonding/bond_3ad.c
@@ -2327,6 +2327,12 @@ void bond_3ad_state_machine_handler(struct work_struct *work)
 
 			aggregator = __get_first_agg(port);
 			ad_agg_selection_logic(aggregator, &update_slave_arr);
+			if (!update_slave_arr) {
+				struct aggregator *active = __get_active_agg(aggregator);
+
+				if (active && active->is_active)
+					update_slave_arr = true;
+			}
 		}
 		bond_3ad_set_carrier(bond);
 	}
-- 
1.7.12.4

