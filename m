Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ECB5140D874
	for <lists+netdev@lfdr.de>; Thu, 16 Sep 2021 13:22:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237588AbhIPLXr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Sep 2021 07:23:47 -0400
Received: from fllv0015.ext.ti.com ([198.47.19.141]:33086 "EHLO
        fllv0015.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235650AbhIPLXq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Sep 2021 07:23:46 -0400
Received: from fllv0034.itg.ti.com ([10.64.40.246])
        by fllv0015.ext.ti.com (8.15.2/8.15.2) with ESMTP id 18GBLvRN072416;
        Thu, 16 Sep 2021 06:21:58 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1631791318;
        bh=loyLdB1v5vUHIjEAh9kEXRTLBkdeLjMQwiy6qnyLWbk=;
        h=From:To:CC:Subject:Date;
        b=k30se4MwmAsqGZMdtXmRWPETKgNKMf8Mp06nzefr2D14KYzSycfFUU5zlWGNri28e
         y7O5aMlslYSzV06wWD8+7BvcS24p+1GGh9ixAwjmg3NHk1tGeMUlt/zpDKthCzypOH
         8NpZVJbg1slVtHbNLIjFAqCJ5YrGFb48sKANZdcE=
Received: from DLEE104.ent.ti.com (dlee104.ent.ti.com [157.170.170.34])
        by fllv0034.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 18GBLvlJ017550
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 16 Sep 2021 06:21:57 -0500
Received: from DLEE108.ent.ti.com (157.170.170.38) by DLEE104.ent.ti.com
 (157.170.170.34) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2308.14; Thu, 16
 Sep 2021 06:21:57 -0500
Received: from lelv0327.itg.ti.com (10.180.67.183) by DLEE108.ent.ti.com
 (157.170.170.38) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2308.14 via
 Frontend Transport; Thu, 16 Sep 2021 06:21:57 -0500
Received: from gsaswath-HP-ProBook-640-G5.dal.design.ti.com (ileax41-snat.itg.ti.com [10.172.224.153])
        by lelv0327.itg.ti.com (8.15.2/8.15.2) with ESMTP id 18GBLrV2074899;
        Thu, 16 Sep 2021 06:21:53 -0500
From:   Aswath Govindraju <a-govindraju@ti.com>
CC:     Lokesh Vutla <lokeshvutla@ti.com>,
        Kishon Vijay Abraham I <kishon@ti.com>,
        Aswath Govindraju <a-govindraju@ti.com>,
        Chandrasekar Ramakrishnan <rcsekar@samsung.com>,
        Wolfgang Grandegger <wg@grandegger.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Matt Kline <matt@bitbashing.io>, <linux-can@vger.kernel.org>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH] can: m_can: m_can_platform: Fix the base address in iomap_write_fifo()
Date:   Thu, 16 Sep 2021 16:51:51 +0530
Message-ID: <20210916112151.26494-1-a-govindraju@ti.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
To:     unlisted-recipients:; (no To-header on input)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The write into fifo must be performed with an offset from the message ram
base address. Therefore, fix the base address to mram_base.

Fixes: e39381770ec9 ("can: m_can: Disable IRQs on FIFO bus errors")
Signed-off-by: Aswath Govindraju <a-govindraju@ti.com>
---
 drivers/net/can/m_can/m_can_platform.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/can/m_can/m_can_platform.c b/drivers/net/can/m_can/m_can_platform.c
index 308d4f2fff00..08eac03ebf2a 100644
--- a/drivers/net/can/m_can/m_can_platform.c
+++ b/drivers/net/can/m_can/m_can_platform.c
@@ -52,7 +52,7 @@ static int iomap_write_fifo(struct m_can_classdev *cdev, int offset,
 {
 	struct m_can_plat_priv *priv = cdev_to_priv(cdev);
 
-	iowrite32_rep(priv->base + offset, val, val_count);
+	iowrite32_rep(priv->mram_base + offset, val, val_count);
 
 	return 0;
 }
-- 
2.17.1

