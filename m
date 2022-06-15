Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E272654C645
	for <lists+netdev@lfdr.de>; Wed, 15 Jun 2022 12:33:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344550AbiFOKdf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jun 2022 06:33:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54674 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348127AbiFOKdK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Jun 2022 06:33:10 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F0021140A0;
        Wed, 15 Jun 2022 03:33:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1655289182; x=1686825182;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=qBjejZP6Y0A8PHLrRCNs4qJ+moG8mbBa+3CpsvYfDQc=;
  b=wYwJm1EQHwPu4JNkS8D8WZepHLUIFA9Pg9BBFPnGCWajFwZwfq7dcaRG
   sEMe61JSM8D6a/+HBooJX6/7gTbKxrr/kjpdc3twGa3ogZ9TrREkuyQxo
   HuY3ML5+4EKIkNQOXQGKTWix+smDzoFJbLjtMPL2u9dAqa85gWhbKvzPO
   BoTsLTJRbXMIAtRMmNB6kx19ZzFtX+F8yBT6EEr60UgY6ZArwkvodNIJB
   nmMhArPbMcKZ7SUbmsgwB9Z2AogJduhwPujRLmMrFANj21g5de7/GlxYk
   /mj2ePqtL8a2wvJXL418HwzJq7KWGV+oVukU68P7vI7KceNDw3oaEQnqF
   A==;
X-IronPort-AV: E=Sophos;i="5.91,300,1647327600"; 
   d="scan'208";a="100117745"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa6.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 15 Jun 2022 03:33:02 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.87.72) by
 chn-vm-ex02.mchp-main.com (10.10.87.72) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Wed, 15 Jun 2022 03:33:02 -0700
Received: from localhost.localdomain (10.10.115.15) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server id
 15.1.2375.17 via Frontend Transport; Wed, 15 Jun 2022 03:32:58 -0700
From:   Raju Lakkaraju <Raju.Lakkaraju@microchip.com>
To:     <netdev@vger.kernel.org>
CC:     <davem@davemloft.net>, <kuba@kernel.org>,
        <linux-kernel@vger.kernel.org>, <bryan.whitehead@microchip.com>,
        <lxu@maxlinear.com>, <richardcochran@gmail.com>,
        <UNGLinuxDriver@microchip.com>, <Ian.Saturley@microchip.com>
Subject: [PATCH net-next V1 5/5] net: phy: add support to get Master-Slave configuration
Date:   Wed, 15 Jun 2022 16:02:37 +0530
Message-ID: <20220615103237.3331-6-Raju.Lakkaraju@microchip.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220615103237.3331-1-Raju.Lakkaraju@microchip.com>
References: <20220615103237.3331-1-Raju.Lakkaraju@microchip.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Spam-Status: No, score=-5.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add support to Master-Slave configuration and state

Signed-off-by: Raju Lakkaraju <Raju.Lakkaraju@microchip.com>
---
Changes:
V0 -> V1: 
  1. Remove the gpy_master_slave_cfg_get() function and use the
genphy_read_master_slave() funtion.

 drivers/net/phy/mxl-gpy.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/phy/mxl-gpy.c b/drivers/net/phy/mxl-gpy.c
index 5ce1bf03bbd7..6c4da2f9e90a 100644
--- a/drivers/net/phy/mxl-gpy.c
+++ b/drivers/net/phy/mxl-gpy.c
@@ -295,6 +295,9 @@ static void gpy_update_interface(struct phy_device *phydev)
 				   ret);
 		break;
 	}
+
+	if (phydev->speed == SPEED_2500 || phydev->speed == SPEED_1000)
+		genphy_read_master_slave(phydev);
 }
 
 static int gpy_read_status(struct phy_device *phydev)
-- 
2.25.1

