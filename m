Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2FD4AC110E
	for <lists+netdev@lfdr.de>; Sat, 28 Sep 2019 16:31:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728396AbfI1ObE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 28 Sep 2019 10:31:04 -0400
Received: from out30-43.freemail.mail.aliyun.com ([115.124.30.43]:46942 "EHLO
        out30-43.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725876AbfI1ObE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 28 Sep 2019 10:31:04 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R111e4;CH=green;DM=||false|;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e01451;MF=wenyang@linux.alibaba.com;NM=1;PH=DS;RN=9;SR=0;TI=SMTPD_---0TdeNtUM_1569681047;
Received: from localhost(mailfrom:wenyang@linux.alibaba.com fp:SMTPD_---0TdeNtUM_1569681047)
          by smtp.aliyun-inc.com(127.0.0.1);
          Sat, 28 Sep 2019 22:30:59 +0800
From:   Wen Yang <wenyang@linux.alibaba.com>
To:     Wolfgang Grandegger <wg@grandegger.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Cc:     xlpang@linux.alibaba.com, Wen Yang <wenyang@linux.alibaba.com>,
        "David S. Miller" <davem@davemloft.net>,
        Franklin S Cooper Jr <fcooper@ti.com>,
        linux-can@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] can: dev: add missing of_node_put after calling of_get_child_by_name
Date:   Sat, 28 Sep 2019 22:29:05 +0800
Message-Id: <20190928142905.34832-1-wenyang@linux.alibaba.com>
X-Mailer: git-send-email 2.23.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

of_node_put needs to be called when the device node which is got
from of_get_child_by_name finished using.

fixes: 2290aefa2e90 ("can: dev: Add support for limiting configured bitrate")
Signed-off-by: Wen Yang <wenyang@linux.alibaba.com>
Cc: Wolfgang Grandegger <wg@grandegger.com>
Cc: Marc Kleine-Budde <mkl@pengutronix.de>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Franklin S Cooper Jr <fcooper@ti.com>
Cc: linux-can@vger.kernel.org
Cc: netdev@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
---
 drivers/net/can/dev.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/can/dev.c b/drivers/net/can/dev.c
index ac86be5..1c88c36 100644
--- a/drivers/net/can/dev.c
+++ b/drivers/net/can/dev.c
@@ -848,6 +848,7 @@ void of_can_transceiver(struct net_device *dev)
 		return;
 
 	ret = of_property_read_u32(dn, "max-bitrate", &priv->bitrate_max);
+	of_node_put(dn);
 	if ((ret && ret != -EINVAL) || (!ret && !priv->bitrate_max))
 		netdev_warn(dev, "Invalid value for transceiver max bitrate. Ignoring bitrate limit.\n");
 }
-- 
1.8.3.1

