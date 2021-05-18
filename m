Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F139538773D
	for <lists+netdev@lfdr.de>; Tue, 18 May 2021 13:15:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348436AbhERLQV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 May 2021 07:16:21 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:4659 "EHLO
        szxga04-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348757AbhERLQR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 May 2021 07:16:17 -0400
Received: from dggems701-chm.china.huawei.com (unknown [172.30.72.60])
        by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4Fktcr2szPz16QMq;
        Tue, 18 May 2021 19:12:12 +0800 (CST)
Received: from dggeml759-chm.china.huawei.com (10.1.199.138) by
 dggems701-chm.china.huawei.com (10.3.19.178) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id
 15.1.2176.2; Tue, 18 May 2021 19:14:57 +0800
Received: from localhost.localdomain (10.175.102.38) by
 dggeml759-chm.china.huawei.com (10.1.199.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2176.2; Tue, 18 May 2021 19:14:56 +0800
From:   Wei Yongjun <weiyongjun1@huawei.com>
To:     <weiyongjun1@huawei.com>, Ansuel Smith <ansuelsmth@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Russell King <linux@armlinux.org.uk>
CC:     <netdev@vger.kernel.org>, <kernel-janitors@vger.kernel.org>,
        Hulk Robot <hulkci@huawei.com>
Subject: [PATCH net-next] net: dsa: qca8k: fix missing unlock on error in qca8k_vlan_(add|del)
Date:   Tue, 18 May 2021 11:24:13 +0000
Message-ID: <20210518112413.622913-1-weiyongjun1@huawei.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Type:   text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Originating-IP: [10.175.102.38]
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
 dggeml759-chm.china.huawei.com (10.1.199.138)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add the missing unlock before return from function qca8k_vlan_add()
and qca8k_vlan_del() in the error handling case.

Fixes: 028f5f8ef44f ("net: dsa: qca8k: handle error with qca8k_read operation")
Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Wei Yongjun <weiyongjun1@huawei.com>
---
 drivers/net/dsa/qca8k.c | 16 ++++++++++------
 1 file changed, 10 insertions(+), 6 deletions(-)

diff --git a/drivers/net/dsa/qca8k.c b/drivers/net/dsa/qca8k.c
index 4753228f02b3..1f1b7c4dda13 100644
--- a/drivers/net/dsa/qca8k.c
+++ b/drivers/net/dsa/qca8k.c
@@ -506,8 +506,10 @@ qca8k_vlan_add(struct qca8k_priv *priv, u8 port, u16 vid, bool untagged)
 		goto out;
 
 	reg = qca8k_read(priv, QCA8K_REG_VTU_FUNC0);
-	if (reg < 0)
-		return reg;
+	if (reg < 0) {
+		ret = reg;
+		goto out;
+	}
 	reg |= QCA8K_VTU_FUNC0_VALID | QCA8K_VTU_FUNC0_IVL_EN;
 	reg &= ~(QCA8K_VTU_FUNC0_EG_MODE_MASK << QCA8K_VTU_FUNC0_EG_MODE_S(port));
 	if (untagged)
@@ -519,7 +521,7 @@ qca8k_vlan_add(struct qca8k_priv *priv, u8 port, u16 vid, bool untagged)
 
 	ret = qca8k_write(priv, QCA8K_REG_VTU_FUNC0, reg);
 	if (ret)
-		return ret;
+		goto out;
 	ret = qca8k_vlan_access(priv, QCA8K_VLAN_LOAD, vid);
 
 out:
@@ -541,8 +543,10 @@ qca8k_vlan_del(struct qca8k_priv *priv, u8 port, u16 vid)
 		goto out;
 
 	reg = qca8k_read(priv, QCA8K_REG_VTU_FUNC0);
-	if (reg < 0)
-		return reg;
+	if (reg < 0) {
+		ret = reg;
+		goto out;
+	}
 	reg &= ~(3 << QCA8K_VTU_FUNC0_EG_MODE_S(port));
 	reg |= QCA8K_VTU_FUNC0_EG_MODE_NOT <<
 			QCA8K_VTU_FUNC0_EG_MODE_S(port);
@@ -564,7 +568,7 @@ qca8k_vlan_del(struct qca8k_priv *priv, u8 port, u16 vid)
 	} else {
 		ret = qca8k_write(priv, QCA8K_REG_VTU_FUNC0, reg);
 		if (ret)
-			return ret;
+			goto out;
 		ret = qca8k_vlan_access(priv, QCA8K_VLAN_LOAD, vid);
 	}
 

