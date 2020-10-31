Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E22942A13C1
	for <lists+netdev@lfdr.de>; Sat, 31 Oct 2020 07:02:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726308AbgJaGCE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 31 Oct 2020 02:02:04 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:7121 "EHLO
        szxga05-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725800AbgJaGCD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 31 Oct 2020 02:02:03 -0400
Received: from DGGEMS413-HUB.china.huawei.com (unknown [172.30.72.60])
        by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4CNT8m5wmlzLrxZ;
        Sat, 31 Oct 2020 14:02:00 +0800 (CST)
Received: from localhost (10.174.176.180) by DGGEMS413-HUB.china.huawei.com
 (10.3.19.213) with Microsoft SMTP Server id 14.3.487.0; Sat, 31 Oct 2020
 14:01:55 +0800
From:   YueHaibing <yuehaibing@huawei.com>
To:     <pshelar@ovn.org>, <davem@davemloft.net>, <kuba@kernel.org>,
        <xiangxia.m.yue@gmail.com>
CC:     <netdev@vger.kernel.org>, <dev@openvswitch.org>,
        <linux-kernel@vger.kernel.org>, YueHaibing <yuehaibing@huawei.com>
Subject: [PATCH net-next] openvswitch: Use IS_ERR instead of IS_ERR_OR_NULL
Date:   Sat, 31 Oct 2020 14:01:53 +0800
Message-ID: <20201031060153.39912-1-yuehaibing@huawei.com>
X-Mailer: git-send-email 2.10.2.windows.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.174.176.180]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix smatch warning:

net/openvswitch/meter.c:427 ovs_meter_cmd_set() warn: passing zero to 'PTR_ERR'

dp_meter_create() never returns NULL, use IS_ERR
instead of IS_ERR_OR_NULL to fix this.

Signed-off-by: YueHaibing <yuehaibing@huawei.com>
---
 net/openvswitch/meter.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/openvswitch/meter.c b/net/openvswitch/meter.c
index 8fbefd52af7f..15424d26e85d 100644
--- a/net/openvswitch/meter.c
+++ b/net/openvswitch/meter.c
@@ -423,7 +423,7 @@ static int ovs_meter_cmd_set(struct sk_buff *skb, struct genl_info *info)
 		return -EINVAL;
 
 	meter = dp_meter_create(a);
-	if (IS_ERR_OR_NULL(meter))
+	if (IS_ERR(meter))
 		return PTR_ERR(meter);
 
 	reply = ovs_meter_cmd_reply_start(info, OVS_METER_CMD_SET,
-- 
2.17.1

