Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 386DE2AED81
	for <lists+netdev@lfdr.de>; Wed, 11 Nov 2020 10:25:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726592AbgKKJZF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Nov 2020 04:25:05 -0500
Received: from mail-m1271.qiye.163.com ([115.236.127.1]:62822 "EHLO
        mail-m1271.qiye.163.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725960AbgKKJZE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Nov 2020 04:25:04 -0500
Received: from vivo-HP-ProDesk-680-G4-PCI-MT.vivo.xyz (unknown [58.251.74.231])
        by mail-m1271.qiye.163.com (Hmail) with ESMTPA id 9896A582895;
        Wed, 11 Nov 2020 17:25:01 +0800 (CST)
From:   Wang Qing <wangqing@vivo.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Samuel Zou <zou_wei@huawei.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Murali Karicheri <m-karicheri2@ti.com>,
        Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     richardcochran@gmail.com, Wang Qing <wangqing@vivo.com>
Subject: [PATCH V4 net-bugfixs] net/ethernet: Update ret when ptp_clock is ERROR
Date:   Wed, 11 Nov 2020 17:24:41 +0800
Message-Id: <1605086686-5140-1-git-send-email-wangqing@vivo.com>
X-Mailer: git-send-email 2.7.4
X-HM-Spam-Status: e1kfGhgUHx5ZQUtXWQgYFAkeWUFZS1VLWVdZKFlBSE83V1ktWUFJV1kPCR
        oVCBIfWUFZTx0dGBhJQ0tPT0pIVkpNS05LQ01MS0lJSEpVEwETFhoSFyQUDg9ZV1kWGg8SFR0UWU
        FZT0tIVUpKS09ISVVLWQY+
X-HM-Sender-Digest: e1kMHhlZQR0aFwgeV1kSHx4VD1lBWUc6NxA6Dzo6Sz8qHRcSIhlIHD8W
        NzZPCTJVSlVKTUtOS0NNTEtJTUxKVTMWGhIXVQwaFRwKEhUcOw0SDRRVGBQWRVlXWRILWUFZTkNV
        SU5KVUxPVUlISllXWQgBWUFJSkNONwY+
X-HM-Tid: 0a75b69f69f898b6kuuu9896a582895
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

