Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C53C3140A5F
	for <lists+netdev@lfdr.de>; Fri, 17 Jan 2020 14:02:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726871AbgAQNCD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Jan 2020 08:02:03 -0500
Received: from stargate.chelsio.com ([12.32.117.8]:18049 "EHLO
        stargate.chelsio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726513AbgAQNCD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Jan 2020 08:02:03 -0500
Received: from localhost (scalar.blr.asicdesigners.com [10.193.185.94])
        by stargate.chelsio.com (8.13.8/8.13.8) with ESMTP id 00HD1MFj023775;
        Fri, 17 Jan 2020 05:01:23 -0800
From:   Rahul Lakkireddy <rahul.lakkireddy@chelsio.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, nirranjan@chelsio.com, vishal@chelsio.com,
        dt@chelsio.com
Subject: [PATCH net] cxgb4: reject overlapped queues in TC-MQPRIO offload
Date:   Fri, 17 Jan 2020 18:21:47 +0530
Message-Id: <1579265507-7729-1-git-send-email-rahul.lakkireddy@chelsio.com>
X-Mailer: git-send-email 2.5.3
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

A queue can't belong to multiple traffic classes. So, reject
any such configuration that results in overlapped queues for a
traffic class.

Fixes: b1396c2bd675 ("cxgb4: parse and configure TC-MQPRIO offload")
Signed-off-by: Rahul Lakkireddy <rahul.lakkireddy@chelsio.com>
---
 .../ethernet/chelsio/cxgb4/cxgb4_tc_mqprio.c  | 28 ++++++++++++++++++-
 1 file changed, 27 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_tc_mqprio.c b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_tc_mqprio.c
index 8971dddcdb7a..ec3eb45ee3b4 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_tc_mqprio.c
+++ b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_tc_mqprio.c
@@ -12,8 +12,9 @@ static int cxgb4_mqprio_validate(struct net_device *dev,
 	struct port_info *pi = netdev2pinfo(dev);
 	struct adapter *adap = netdev2adap(dev);
 	u32 speed, qcount = 0, qoffset = 0;
+	u32 start_a, start_b, end_a, end_b;
 	int ret;
-	u8 i;
+	u8 i, j;
 
 	if (!mqprio->qopt.num_tc)
 		return 0;
@@ -47,6 +48,31 @@ static int cxgb4_mqprio_validate(struct net_device *dev,
 		qoffset = max_t(u16, mqprio->qopt.offset[i], qoffset);
 		qcount += mqprio->qopt.count[i];
 
+		start_a = mqprio->qopt.offset[i];
+		end_a = start_a + mqprio->qopt.count[i] - 1;
+		for (j = i + 1; j < mqprio->qopt.num_tc; j++) {
+			start_b = mqprio->qopt.offset[j];
+			end_b = start_b + mqprio->qopt.count[j] - 1;
+
+			/* If queue count is 0, then the traffic
+			 * belonging to this class will not use
+			 * ETHOFLD queues. So, no need to validate
+			 * further.
+			 */
+			if (!mqprio->qopt.count[i])
+				break;
+
+			if (!mqprio->qopt.count[j])
+				continue;
+
+			if (max_t(u32, start_a, start_b) <=
+			    min_t(u32, end_a, end_b)) {
+				netdev_err(dev,
+					   "Queues can't overlap across tc\n");
+				return -EINVAL;
+			}
+		}
+
 		/* Convert byte per second to bits per second */
 		min_rate += (mqprio->min_rate[i] * 8);
 		max_rate += (mqprio->max_rate[i] * 8);
-- 
2.24.0

