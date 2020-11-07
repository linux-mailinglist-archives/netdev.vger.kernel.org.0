Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8CF782AA254
	for <lists+netdev@lfdr.de>; Sat,  7 Nov 2020 04:39:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727525AbgKGDi5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Nov 2020 22:38:57 -0500
Received: from m176115.mail.qiye.163.com ([59.111.176.115]:48927 "EHLO
        m176115.mail.qiye.163.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726880AbgKGDi5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Nov 2020 22:38:57 -0500
Received: from vivo-HP-ProDesk-680-G4-PCI-MT.vivo.xyz (unknown [58.251.74.231])
        by m176115.mail.qiye.163.com (Hmail) with ESMTPA id 1750D6665A0;
        Sat,  7 Nov 2020 11:38:54 +0800 (CST)
From:   Wang Qing <wangqing@vivo.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Samuel Zou <zou_wei@huawei.com>,
        Murali Karicheri <m-karicheri2@ti.com>,
        Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>,
        Wang Qing <wangqing@vivo.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [V2] [PATCH] net/ethernet: update ret when ptp_clock is ERROR
Date:   Sat,  7 Nov 2020 11:38:38 +0800
Message-Id: <1604720323-3586-1-git-send-email-wangqing@vivo.com>
X-Mailer: git-send-email 2.7.4
X-HM-Spam-Status: e1kfGhgUHx5ZQUtXWQgYFAkeWUFZS1VLWVdZKFlBSE83V1ktWUFJV1kPCR
        oVCBIfWUFZT0keSk0YTBhISkwYVkpNS09MSUtISE9OSEhVEwETFhoSFyQUDg9ZV1kWGg8SFR0UWU
        FZT0tIVUpKS09ISVVLWQY+
X-HM-Sender-Digest: e1kMHhlZQR0aFwgeV1kSHx4VD1lBWUc6Kww6Fhw5FT8jDRwyT04*ME0a
        PAwaFD5VSlVKTUtPTElLSEhPQkhNVTMWGhIXVQwaFRwKEhUcOw0SDRRVGBQWRVlXWRILWUFZTkNV
        SU5KVUxPVUlISllXWQgBWUFJSEtJNwY+
X-HM-Tid: 0a75a0c916569373kuws1750d6665a0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We always have to update the value of ret, otherwise the error value
 may be the previous one. And ptp_clock_register() never return NULL
 when PTP_1588_CLOCK enable, so we use IS_ERR here.

Signed-off-by: Wang Qing <wangqing@vivo.com>
---
 drivers/net/ethernet/ti/am65-cpts.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/ti/am65-cpts.c b/drivers/net/ethernet/ti/am65-cpts.c
index 75056c1..ec8e56d
--- a/drivers/net/ethernet/ti/am65-cpts.c
+++ b/drivers/net/ethernet/ti/am65-cpts.c
@@ -998,11 +998,10 @@ struct am65_cpts *am65_cpts_create(struct device *dev, void __iomem *regs,
 	am65_cpts_settime(cpts, ktime_to_ns(ktime_get_real()));
 
 	cpts->ptp_clock = ptp_clock_register(&cpts->ptp_info, cpts->dev);
-	if (IS_ERR_OR_NULL(cpts->ptp_clock)) {
+	if (IS_ERR(cpts->ptp_clock)) {
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

