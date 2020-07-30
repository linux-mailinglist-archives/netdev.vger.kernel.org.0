Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2717A232C9E
	for <lists+netdev@lfdr.de>; Thu, 30 Jul 2020 09:31:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728937AbgG3Hbo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Jul 2020 03:31:44 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:34790 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725892AbgG3Hbo (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 30 Jul 2020 03:31:44 -0400
Received: from DGGEMS410-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id 03203F4AF1BFB6FA8F89;
        Thu, 30 Jul 2020 15:31:42 +0800 (CST)
Received: from huawei.com (10.175.113.133) by DGGEMS410-HUB.china.huawei.com
 (10.3.19.210) with Microsoft SMTP Server id 14.3.487.0; Thu, 30 Jul 2020
 15:31:40 +0800
From:   Wang Hai <wanghai38@huawei.com>
To:     <ulli.kroll@googlemail.com>, <linus.walleij@linaro.org>,
        <davem@davemloft.net>, <kuba@kernel.org>, <mirq-linux@rere.qmqm.pl>
CC:     <linux-arm-kernel@lists.infradead.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH net] net: gemini: Fix missing clk_disable_unprepare() in error path of gemini_ethernet_port_probe()
Date:   Thu, 30 Jul 2020 15:30:00 +0800
Message-ID: <20200730073000.59797-1-wanghai38@huawei.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.175.113.133]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix the missing clk_disable_unprepare() before return
from gemini_ethernet_port_probe() in the error handling case.

Fixes: 4d5ae32f5e1e ("net: ethernet: Add a driver for Gemini gigabit ethernet")
Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Wang Hai <wanghai38@huawei.com>
---
 drivers/net/ethernet/cortina/gemini.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/cortina/gemini.c b/drivers/net/ethernet/cortina/gemini.c
index 8d13ea370db1..66e67b24a887 100644
--- a/drivers/net/ethernet/cortina/gemini.c
+++ b/drivers/net/ethernet/cortina/gemini.c
@@ -2446,6 +2446,7 @@ static int gemini_ethernet_port_probe(struct platform_device *pdev)
 	port->reset = devm_reset_control_get_exclusive(dev, NULL);
 	if (IS_ERR(port->reset)) {
 		dev_err(dev, "no reset\n");
+		clk_disable_unprepare(port->pclk);
 		return PTR_ERR(port->reset);
 	}
 	reset_control_reset(port->reset);
@@ -2501,8 +2502,10 @@ static int gemini_ethernet_port_probe(struct platform_device *pdev)
 					IRQF_SHARED,
 					port_names[port->id],
 					port);
-	if (ret)
+	if (ret) {
+		clk_disable_unprepare(port->pclk);
 		return ret;
+	}
 
 	ret = register_netdev(netdev);
 	if (!ret) {
-- 
2.17.1

