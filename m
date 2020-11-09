Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 65EBF2AAF60
	for <lists+netdev@lfdr.de>; Mon,  9 Nov 2020 03:18:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729487AbgKICSG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 8 Nov 2020 21:18:06 -0500
Received: from m176115.mail.qiye.163.com ([59.111.176.115]:20444 "EHLO
        m176115.mail.qiye.163.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729432AbgKICSF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 8 Nov 2020 21:18:05 -0500
Received: from vivo-HP-ProDesk-680-G4-PCI-MT.vivo.xyz (unknown [58.251.74.231])
        by m176115.mail.qiye.163.com (Hmail) with ESMTPA id 391F9660D2A;
        Mon,  9 Nov 2020 10:18:02 +0800 (CST)
From:   Wang Qing <wangqing@vivo.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Samuel Zou <zou_wei@huawei.com>,
        Murali Karicheri <m-karicheri2@ti.com>,
        Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>,
        Wang Qing <wangqing@vivo.com>,
        Kurt Kanzenbach <kurt@linutronix.de>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH V3 net] net/ethernet: Fix error return when ptp_clock is ERROR
Date:   Mon,  9 Nov 2020 10:17:52 +0800
Message-Id: <1604888277-20400-1-git-send-email-wangqing@vivo.com>
X-Mailer: git-send-email 2.7.4
X-HM-Spam-Status: e1kfGhgUHx5ZQUtXWQgYFAkeWUFZS1VLWVdZKFlBSE83V1ktWUFJV1kPCR
        oVCBIfWUFZSkJMH05CThhPHRpDVkpNS09DQ0NJQ0lMSk5VEwETFhoSFyQUDg9ZV1kWGg8SFR0UWU
        FZT0tIVUpKS0hKQ1VLWQY+
X-HM-Sender-Digest: e1kMHhlZQR0aFwgeV1kSHx4VD1lBWUc6MxA6Pgw4UT8tShNONC0ePxNJ
        F08wCwtVSlVKTUtPQ0NDSUNISEtCVTMWGhIXVQwaFRwKEhUcOw0SDRRVGBQWRVlXWRILWUFZTkNV
        SU5KVUxPVUlISllXWQgBWUFJSklCNwY+
X-HM-Tid: 0a75aacbc5da9373kuws391f9660d2a
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We always have to update the value of ret, otherwise the error value
 may be the previous one. And ptp_clock_register() never return NULL
 when PTP_1588_CLOCK enable.

Signed-off-by: Wang Qing <wangqing@vivo.com>
---
 drivers/net/ethernet/ti/am65-cpts.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/ti/am65-cpts.c b/drivers/net/ethernet/ti/am65-cpts.c
index 75056c1..b319d45
--- a/drivers/net/ethernet/ti/am65-cpts.c
+++ b/drivers/net/ethernet/ti/am65-cpts.c
@@ -1001,8 +1001,7 @@ struct am65_cpts *am65_cpts_create(struct device *dev, void __iomem *regs,
 	if (IS_ERR_OR_NULL(cpts->ptp_clock)) {
 		dev_err(dev, "Failed to register ptp clk %ld\n",
 			PTR_ERR(cpts->ptp_clock));
-		if (!cpts->ptp_clock)
-			ret = -ENODEV;
+		ret = PTR_ERR(cpts->ptp_clock);
 		goto refclk_disable;
 	}
 	cpts->phc_index = ptp_clock_index(cpts->ptp_clock);
-- 
2.7.4

