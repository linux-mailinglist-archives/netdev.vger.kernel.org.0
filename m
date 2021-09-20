Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5D79A41145A
	for <lists+netdev@lfdr.de>; Mon, 20 Sep 2021 14:26:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237977AbhITM2I (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Sep 2021 08:28:08 -0400
Received: from fllv0015.ext.ti.com ([198.47.19.141]:55066 "EHLO
        fllv0015.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237874AbhITM2H (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Sep 2021 08:28:07 -0400
Received: from fllv0034.itg.ti.com ([10.64.40.246])
        by fllv0015.ext.ti.com (8.15.2/8.15.2) with ESMTP id 18KCQI7q054664;
        Mon, 20 Sep 2021 07:26:18 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1632140778;
        bh=uoLqJWA/mbkEh22Zl2N2FiNXqHqq0zWF36kfTH7wEtE=;
        h=From:To:CC:Subject:Date;
        b=VpE5AdCk0JSdEevVu+bslIysvGd3sQgBP4WegOoreDkliBgwM7XV9cNDTWFEdWIHx
         uvLWqfZEKNJ2s6yVNPU81g2IIqKVzwKCB8jLc43xNmhiVfQ69s4it/aZe7ApQubPqt
         x2tvk802WtLR1aFjpUy3yMXeRTRnsBceG+HCLvCc=
Received: from DFLE105.ent.ti.com (dfle105.ent.ti.com [10.64.6.26])
        by fllv0034.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 18KCQIed003862
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Mon, 20 Sep 2021 07:26:18 -0500
Received: from DFLE108.ent.ti.com (10.64.6.29) by DFLE105.ent.ti.com
 (10.64.6.26) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2308.14; Mon, 20
 Sep 2021 07:26:17 -0500
Received: from fllv0040.itg.ti.com (10.64.41.20) by DFLE108.ent.ti.com
 (10.64.6.29) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2308.14 via
 Frontend Transport; Mon, 20 Sep 2021 07:26:18 -0500
Received: from gsaswath-HP-ProBook-640-G5.dal.design.ti.com (ileax41-snat.itg.ti.com [10.172.224.153])
        by fllv0040.itg.ti.com (8.15.2/8.15.2) with ESMTP id 18KCQDhr003602;
        Mon, 20 Sep 2021 07:26:14 -0500
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
Date:   Mon, 20 Sep 2021 17:56:10 +0530
Message-ID: <20210920122610.570-1-a-govindraju@ti.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
To:     unlisted-recipients:; (no To-header on input)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The read an writes from the fifo are from a buffer with various fields and
data at predefined offsets. So, they reads and writes should not be done to
the same address(or port) in case of val_count greater than 1. Therefore,
fix this by using iowrite32/ioread32 instead of ioread32_rep/iowrite32_rep.

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

