Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3DC432A90D1
	for <lists+netdev@lfdr.de>; Fri,  6 Nov 2020 08:57:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726558AbgKFH5A (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Nov 2020 02:57:00 -0500
Received: from m176115.mail.qiye.163.com ([59.111.176.115]:34733 "EHLO
        m176115.mail.qiye.163.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725830AbgKFH5A (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Nov 2020 02:57:00 -0500
X-Greylist: delayed 384 seconds by postgrey-1.27 at vger.kernel.org; Fri, 06 Nov 2020 02:56:59 EST
Received: from vivo-HP-ProDesk-680-G4-PCI-MT.vivo.xyz (unknown [58.251.74.231])
        by m176115.mail.qiye.163.com (Hmail) with ESMTPA id 2488966734C;
        Fri,  6 Nov 2020 15:56:56 +0800 (CST)
From:   Wang Qing <wangqing@vivo.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Samuel Zou <zou_wei@huawei.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Wang Qing <wangqing@vivo.com>,
        Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] net/ethernet: update ret when ptp_clock is ERROR
Date:   Fri,  6 Nov 2020 15:56:45 +0800
Message-Id: <1604649411-24886-1-git-send-email-wangqing@vivo.com>
X-Mailer: git-send-email 2.7.4
X-HM-Spam-Status: e1kfGhgUHx5ZQUtXWQgYFAkeWUFZS1VLWVdZKFlBSE83V1ktWUFJV1kPCR
        oVCBIfWUFZHhlIQxgaHxhPQ0hDVkpNS09NT0JPSk1MSExVEwETFhoSFyQUDg9ZV1kWGg8SFR0UWU
        FZT0tIVUpKS09ISVVLWQY+
X-HM-Sender-Digest: e1kMHhlZQR0aFwgeV1kSHx4VD1lBWUc6MBg6NRw*GD8oPx0wNCpMSj5R
        TyhPChhVSlVKTUtPTU9CT0pMSkpDVTMWGhIXVQwaFRwKEhUcOw0SDRRVGBQWRVlXWRILWUFZTkNV
        SU5KVUxPVUlISllXWQgBWUFKQk1CNwY+
X-HM-Tid: 0a759c8ef7869373kuws2488966734c
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We always have to update the value of ret, otherwise the
 error value may be the previous one.

Signed-off-by: Wang Qing <wangqing@vivo.com>
---
 drivers/net/ethernet/ti/am65-cpts.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/ti/am65-cpts.c b/drivers/net/ethernet/ti/am65-cpts.c
index 75056c1..b77ff61
--- a/drivers/net/ethernet/ti/am65-cpts.c
+++ b/drivers/net/ethernet/ti/am65-cpts.c
@@ -1001,8 +1001,7 @@ struct am65_cpts *am65_cpts_create(struct device *dev, void __iomem *regs,
 	if (IS_ERR_OR_NULL(cpts->ptp_clock)) {
 		dev_err(dev, "Failed to register ptp clk %ld\n",
 			PTR_ERR(cpts->ptp_clock));
-		if (!cpts->ptp_clock)
-			ret = -ENODEV;
+		ret = cpts->ptp_clock ? cpts->ptp_clock : (-ENODEV);
 		goto refclk_disable;
 	}
 	cpts->phc_index = ptp_clock_index(cpts->ptp_clock);
-- 
2.7.4

