Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F3D97394A07
	for <lists+netdev@lfdr.de>; Sat, 29 May 2021 05:14:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229708AbhE2DBw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 May 2021 23:01:52 -0400
Received: from szxga01-in.huawei.com ([45.249.212.187]:2084 "EHLO
        szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229674AbhE2DBs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 May 2021 23:01:48 -0400
Received: from dggemv703-chm.china.huawei.com (unknown [172.30.72.54])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4FsR4j5fsYzWjdW;
        Sat, 29 May 2021 10:55:33 +0800 (CST)
Received: from dggpeml500017.china.huawei.com (7.185.36.243) by
 dggemv703-chm.china.huawei.com (10.3.19.46) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Sat, 29 May 2021 11:00:11 +0800
Received: from huawei.com (10.175.103.91) by dggpeml500017.china.huawei.com
 (7.185.36.243) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2176.2; Sat, 29 May
 2021 11:00:08 +0800
From:   Yang Yingliang <yangyingliang@huawei.com>
To:     <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>
CC:     <andrew@lunn.ch>, <vivien.didelot@gmail.com>,
        <davem@davemloft.net>, <kuba@kernel.org>
Subject: [PATCH net-next v2 2/2] net: dsa: qca8k: add missing check return value in qca8k_phylink_mac_config()
Date:   Sat, 29 May 2021 11:04:39 +0800
Message-ID: <20210529030439.1723306-3-yangyingliang@huawei.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210529030439.1723306-1-yangyingliang@huawei.com>
References: <20210529030439.1723306-1-yangyingliang@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.103.91]
X-ClientProxiedBy: dggems704-chm.china.huawei.com (10.3.19.181) To
 dggpeml500017.china.huawei.com (7.185.36.243)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Now we can check qca8k_read() return value correctly, so if
it fails, we need return directly.

Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
---
 drivers/net/dsa/qca8k.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/net/dsa/qca8k.c b/drivers/net/dsa/qca8k.c
index d761c5947222..6fe963ba23e8 100644
--- a/drivers/net/dsa/qca8k.c
+++ b/drivers/net/dsa/qca8k.c
@@ -1128,6 +1128,7 @@ qca8k_phylink_mac_config(struct dsa_switch *ds, int port, unsigned int mode,
 {
 	struct qca8k_priv *priv = ds->priv;
 	u32 reg, val;
+	int ret;
 
 	switch (port) {
 	case 0: /* 1st CPU port */
@@ -1198,7 +1199,9 @@ qca8k_phylink_mac_config(struct dsa_switch *ds, int port, unsigned int mode,
 		qca8k_write(priv, reg, QCA8K_PORT_PAD_SGMII_EN);
 
 		/* Enable/disable SerDes auto-negotiation as necessary */
-		qca8k_read(priv, QCA8K_REG_PWS, &val);
+		ret = qca8k_read(priv, QCA8K_REG_PWS, &val);
+		if (ret)
+			return;
 		if (phylink_autoneg_inband(mode))
 			val &= ~QCA8K_PWS_SERDES_AEN_DIS;
 		else
@@ -1206,7 +1209,9 @@ qca8k_phylink_mac_config(struct dsa_switch *ds, int port, unsigned int mode,
 		qca8k_write(priv, QCA8K_REG_PWS, val);
 
 		/* Configure the SGMII parameters */
-		qca8k_read(priv, QCA8K_REG_SGMII_CTRL, &val);
+		ret = qca8k_read(priv, QCA8K_REG_SGMII_CTRL, &val);
+		if (ret)
+			return;
 
 		val |= QCA8K_SGMII_EN_PLL | QCA8K_SGMII_EN_RX |
 			QCA8K_SGMII_EN_TX | QCA8K_SGMII_EN_SD;
-- 
2.25.1

