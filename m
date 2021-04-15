Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7EDB03602E4
	for <lists+netdev@lfdr.de>; Thu, 15 Apr 2021 09:00:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231260AbhDOHAi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Apr 2021 03:00:38 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:16593 "EHLO
        szxga04-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231217AbhDOHAf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Apr 2021 03:00:35 -0400
Received: from DGGEMS406-HUB.china.huawei.com (unknown [172.30.72.58])
        by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4FLVXc3LMpz18JTV;
        Thu, 15 Apr 2021 14:57:52 +0800 (CST)
Received: from [10.174.177.26] (10.174.177.26) by
 DGGEMS406-HUB.china.huawei.com (10.3.19.206) with Microsoft SMTP Server id
 14.3.498.0; Thu, 15 Apr 2021 15:00:02 +0800
From:   jin yiting <jinyiting@huawei.com>
To:     Jay Vosburgh <j.vosburgh@gmail.com>,
        Veaceslav Falico <vfalico@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, <netdev@vger.kernel.org>,
        <security@kernel.org>, <linux-kernel@vger.kernel.org>
Subject: bonding: 3ad: update slave arr after initialize
CC:     Xuhanbing <xuhanbing@huawei.com>,
        "wangxiaogang (F)" <wangxiaogang3@huawei.com>
Message-ID: <0647a502-f54c-30ad-5b5f-c94948f092c8@huawei.com>
Date:   Thu, 15 Apr 2021 14:59:49 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.9.0
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.174.177.26]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

 From 71e63af579edd15ad7f7395760a19f67d9a1d7d3 Mon Sep 17 00:00:00 2001
From: jin yiting <jinyiting@huawei.com>
Date: Wed, 31 Mar 2021 20:38:40 +0800
Subject: [PATCH] bonding: 3ad: update slave arr after initialize
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

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
@@ -2327,6 +2327,12 @@ void bond_3ad_state_machine_handler(struct 
work_struct *work)

             aggregator = __get_first_agg(port);
             ad_agg_selection_logic(aggregator, &update_slave_arr);
+           if (!update_slave_arr) {
+               struct aggregator *active = __get_active_agg(aggregator);
+
+               if (active && active->is_active)
+                   update_slave_arr = true;
+           }
         }
         bond_3ad_set_carrier(bond);
     }
-- 
1.7.12.4


