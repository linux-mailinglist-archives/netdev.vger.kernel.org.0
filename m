Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E329E41148E
	for <lists+netdev@lfdr.de>; Mon, 20 Sep 2021 14:34:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238383AbhITMfb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Sep 2021 08:35:31 -0400
Received: from fllv0016.ext.ti.com ([198.47.19.142]:35062 "EHLO
        fllv0016.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233066AbhITMfa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Sep 2021 08:35:30 -0400
Received: from lelv0266.itg.ti.com ([10.180.67.225])
        by fllv0016.ext.ti.com (8.15.2/8.15.2) with ESMTP id 18KCXqMP098780;
        Mon, 20 Sep 2021 07:33:52 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1632141232;
        bh=0qDxJRZQTjlN4ImylXnG13bIrn2pKRdM3+BUIaf+tN0=;
        h=From:To:CC:Subject:Date;
        b=cTAq1l4BEjbIH6si+3oGNsExaUAyd47Gjs/rqW/TsahJjzeJUhMi1Fi/tK7i4U+Ud
         IR/WG6Om2lsT0VxC5fRpYjpT3C22oWgjd7C8qp0Mn9HU1irBYlZzx9dizVRP4dCKN0
         NppnjLT8dBML+8tZeraH441DkNTWNxeXEAx7t/A8=
Received: from DFLE115.ent.ti.com (dfle115.ent.ti.com [10.64.6.36])
        by lelv0266.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 18KCXqfl125518
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Mon, 20 Sep 2021 07:33:52 -0500
Received: from DFLE106.ent.ti.com (10.64.6.27) by DFLE115.ent.ti.com
 (10.64.6.36) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2308.14; Mon, 20
 Sep 2021 07:33:51 -0500
Received: from fllv0039.itg.ti.com (10.64.41.19) by DFLE106.ent.ti.com
 (10.64.6.27) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2308.14 via
 Frontend Transport; Mon, 20 Sep 2021 07:33:51 -0500
Received: from gsaswath-HP-ProBook-640-G5.dal.design.ti.com (ileax41-snat.itg.ti.com [10.172.224.153])
        by fllv0039.itg.ti.com (8.15.2/8.15.2) with ESMTP id 18KCXl5l085969;
        Mon, 20 Sep 2021 07:33:48 -0500
From:   Aswath Govindraju <a-govindraju@ti.com>
CC:     Lokesh Vutla <lokeshvutla@ti.com>,
        Aswath Govindraju <a-govindraju@ti.com>,
        Chandrasekar Ramakrishnan <rcsekar@samsung.com>,
        Wolfgang Grandegger <wg@grandegger.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Matt Kline <matt@bitbashing.io>, <linux-can@vger.kernel.org>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH] can: m_can: m_can_platform: Fix iomap_read_fifo() and iomap_write_fifo()
Date:   Mon, 20 Sep 2021 18:03:43 +0530
Message-ID: <20210920123344.2320-1-a-govindraju@ti.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
To:     unlisted-recipients:; (no To-header on input)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The read and writes from the fifo are from a buffer, with various fields
and data at predefined offsets. So, they should not be done to the same
address(or port) in case of val_count greater than 1. Therefore, fix this
by using iowrite32/ioread32 instead of ioread32_rep/iowrite32_rep.

Also, the write into fifo must be performed with an offset from the message
ram base address. Therefore, fix the base address to mram_base.

Fixes: e39381770ec9 ("can: m_can: Disable IRQs on FIFO bus errors")
Signed-off-by: Aswath Govindraju <a-govindraju@ti.com>
---
 drivers/net/can/m_can/m_can_platform.c | 14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

diff --git a/drivers/net/can/m_can/m_can_platform.c b/drivers/net/can/m_can/m_can_platform.c
index 308d4f2fff00..eee47bad0592 100644
--- a/drivers/net/can/m_can/m_can_platform.c
+++ b/drivers/net/can/m_can/m_can_platform.c
@@ -32,8 +32,13 @@ static u32 iomap_read_reg(struct m_can_classdev *cdev, int reg)
 static int iomap_read_fifo(struct m_can_classdev *cdev, int offset, void *val, size_t val_count)
 {
 	struct m_can_plat_priv *priv = cdev_to_priv(cdev);
+	void __iomem *src = priv->mram_base + offset;
 
-	ioread32_rep(priv->mram_base + offset, val, val_count);
+	while (val_count--) {
+		*(unsigned int *)val = ioread32(src);
+		val += 4;
+		src += 4;
+	}
 
 	return 0;
 }
@@ -51,8 +56,13 @@ static int iomap_write_fifo(struct m_can_classdev *cdev, int offset,
 			    const void *val, size_t val_count)
 {
 	struct m_can_plat_priv *priv = cdev_to_priv(cdev);
+	void __iomem *dst = priv->mram_base + offset;
 
-	iowrite32_rep(priv->base + offset, val, val_count);
+	while (val_count--) {
+		iowrite32(*(unsigned int *)val, dst);
+		val += 4;
+		dst += 4;
+	}
 
 	return 0;
 }
-- 
2.17.1

