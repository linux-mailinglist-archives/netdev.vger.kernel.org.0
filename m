Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5BEBB1A4444
	for <lists+netdev@lfdr.de>; Fri, 10 Apr 2020 11:10:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726595AbgDJJKa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Apr 2020 05:10:30 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:12710 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725897AbgDJJK3 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 10 Apr 2020 05:10:29 -0400
Received: from DGGEMS410-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id 60B0593A56FBF5BABBF2;
        Fri, 10 Apr 2020 17:10:28 +0800 (CST)
Received: from huawei.com (10.175.124.28) by DGGEMS410-HUB.china.huawei.com
 (10.3.19.210) with Microsoft SMTP Server id 14.3.487.0; Fri, 10 Apr 2020
 17:10:18 +0800
From:   Jason Yan <yanaijie@huawei.com>
To:     <stas.yakovlev@gmail.com>, <kvalo@codeaurora.org>,
        <davem@davemloft.net>, <linux-wireless@vger.kernel.org>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC:     Jason Yan <yanaijie@huawei.com>
Subject: [PATCH] ipw2x00: make ipw_qos_association_resp() void
Date:   Fri, 10 Apr 2020 17:08:50 +0800
Message-ID: <20200410090850.27025-1-yanaijie@huawei.com>
X-Mailer: git-send-email 2.17.2
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.175.124.28]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix the following coccicheck warning:

drivers/net/wireless/intel/ipw2x00/ipw2200.c:7048:5-8: Unneeded
variable: "ret". Return "0" on line 7055

Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Jason Yan <yanaijie@huawei.com>
---
 drivers/net/wireless/intel/ipw2x00/ipw2200.c | 11 ++++-------
 1 file changed, 4 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/intel/ipw2x00/ipw2200.c b/drivers/net/wireless/intel/ipw2x00/ipw2200.c
index 60b5e08dd6df..201a1eb0e2f6 100644
--- a/drivers/net/wireless/intel/ipw2x00/ipw2200.c
+++ b/drivers/net/wireless/intel/ipw2x00/ipw2200.c
@@ -7042,23 +7042,22 @@ static int ipw_qos_association(struct ipw_priv *priv,
 * off the network from the associated setting, adjust the QoS
 * setting
 */
-static int ipw_qos_association_resp(struct ipw_priv *priv,
+static void ipw_qos_association_resp(struct ipw_priv *priv,
 				    struct libipw_network *network)
 {
-	int ret = 0;
 	unsigned long flags;
 	u32 size = sizeof(struct libipw_qos_parameters);
 	int set_qos_param = 0;
 
 	if ((priv == NULL) || (network == NULL) ||
 	    (priv->assoc_network == NULL))
-		return ret;
+		return;
 
 	if (!(priv->status & STATUS_ASSOCIATED))
-		return ret;
+		return;
 
 	if ((priv->ieee->iw_mode != IW_MODE_INFRA))
-		return ret;
+		return;
 
 	spin_lock_irqsave(&priv->ieee->lock, flags);
 	if (network->flags & NETWORK_HAS_QOS_PARAMETERS) {
@@ -7088,8 +7087,6 @@ static int ipw_qos_association_resp(struct ipw_priv *priv,
 
 	if (set_qos_param == 1)
 		schedule_work(&priv->qos_activate);
-
-	return ret;
 }
 
 static u32 ipw_qos_get_burst_duration(struct ipw_priv *priv)
-- 
2.17.2

