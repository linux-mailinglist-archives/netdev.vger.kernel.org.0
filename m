Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 66683393E9F
	for <lists+netdev@lfdr.de>; Fri, 28 May 2021 10:18:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236284AbhE1ITr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 May 2021 04:19:47 -0400
Received: from szxga03-in.huawei.com ([45.249.212.189]:2388 "EHLO
        szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235827AbhE1ITp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 May 2021 04:19:45 -0400
Received: from dggeml704-chm.china.huawei.com (unknown [172.30.72.54])
        by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4FryCB3pCGz65ZB;
        Fri, 28 May 2021 16:14:30 +0800 (CST)
Received: from dggpeml500017.china.huawei.com (7.185.36.243) by
 dggeml704-chm.china.huawei.com (10.3.17.142) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2176.2; Fri, 28 May 2021 16:18:09 +0800
Received: from huawei.com (10.175.103.91) by dggpeml500017.china.huawei.com
 (7.185.36.243) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2176.2; Fri, 28 May
 2021 16:18:09 +0800
From:   Yang Yingliang <yangyingliang@huawei.com>
To:     <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>
CC:     <andrew@lunn.ch>, <vivien.didelot@gmail.com>, <davem@davemloft.net>
Subject: [PATCH -next 2/2] net: dsa: qca8k: add missing check return value in qca8k_phylink_mac_config()
Date:   Fri, 28 May 2021 16:22:40 +0800
Message-ID: <20210528082240.3863991-3-yangyingliang@huawei.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210528082240.3863991-1-yangyingliang@huawei.com>
References: <20210528082240.3863991-1-yangyingliang@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.103.91]
X-ClientProxiedBy: dggems705-chm.china.huawei.com (10.3.19.182) To
 dggpeml500017.china.huawei.com (7.185.36.243)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Now we can check qca8k_read() return value correctly, so if
it fails, we need return directly.

Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
---
 drivers/net/dsa/qca8k.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/dsa/qca8k.c b/drivers/net/dsa/qca8k.c
index a8c274227348..6fe963ba23e8 100644
--- a/drivers/net/dsa/qca8k.c
+++ b/drivers/net/dsa/qca8k.c
@@ -1200,6 +1200,8 @@ qca8k_phylink_mac_config(struct dsa_switch *ds, int port, unsigned int mode,
 
 		/* Enable/disable SerDes auto-negotiation as necessary */
 		ret = qca8k_read(priv, QCA8K_REG_PWS, &val);
+		if (ret)
+			return;
 		if (phylink_autoneg_inband(mode))
 			val &= ~QCA8K_PWS_SERDES_AEN_DIS;
 		else
@@ -1208,6 +1210,8 @@ qca8k_phylink_mac_config(struct dsa_switch *ds, int port, unsigned int mode,
 
 		/* Configure the SGMII parameters */
 		ret = qca8k_read(priv, QCA8K_REG_SGMII_CTRL, &val);
+		if (ret)
+			return;
 
 		val |= QCA8K_SGMII_EN_PLL | QCA8K_SGMII_EN_RX |
 			QCA8K_SGMII_EN_TX | QCA8K_SGMII_EN_SD;
-- 
2.25.1

