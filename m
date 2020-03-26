Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 10CAA194A28
	for <lists+netdev@lfdr.de>; Thu, 26 Mar 2020 22:12:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728213AbgCZVMC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Mar 2020 17:12:02 -0400
Received: from sauhun.de ([88.99.104.3]:54372 "EHLO pokefinder.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727865AbgCZVKD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 26 Mar 2020 17:10:03 -0400
Received: from localhost (p54B3331F.dip0.t-ipconnect.de [84.179.51.31])
        by pokefinder.org (Postfix) with ESMTPSA id BECFA2C1F89;
        Thu, 26 Mar 2020 22:10:01 +0100 (CET)
From:   Wolfram Sang <wsa+renesas@sang-engineering.com>
To:     linux-i2c@vger.kernel.org
Cc:     Wolfram Sang <wsa+renesas@sang-engineering.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        intel-wired-lan@lists.osuosl.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] igb: convert to use i2c_new_client_device()
Date:   Thu, 26 Mar 2020 22:09:59 +0100
Message-Id: <20200326211001.13171-2-wsa+renesas@sang-engineering.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200326211001.13171-1-wsa+renesas@sang-engineering.com>
References: <20200326211001.13171-1-wsa+renesas@sang-engineering.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Move away from the deprecated API and return the shiny new ERRPTR where
useful.

Signed-off-by: Wolfram Sang <wsa+renesas@sang-engineering.com>
---
 drivers/net/ethernet/intel/igb/igb_hwmon.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/intel/igb/igb_hwmon.c b/drivers/net/ethernet/intel/igb/igb_hwmon.c
index 3b83747b2700..21a29a0ca7f4 100644
--- a/drivers/net/ethernet/intel/igb/igb_hwmon.c
+++ b/drivers/net/ethernet/intel/igb/igb_hwmon.c
@@ -198,11 +198,11 @@ int igb_sysfs_init(struct igb_adapter *adapter)
 	}
 
 	/* init i2c_client */
-	client = i2c_new_device(&adapter->i2c_adap, &i350_sensor_info);
-	if (client == NULL) {
+	client = i2c_new_client_device(&adapter->i2c_adap, &i350_sensor_info);
+	if (IS_ERR(client)) {
 		dev_info(&adapter->pdev->dev,
 			 "Failed to create new i2c device.\n");
-		rc = -ENODEV;
+		rc = PTR_ERR(client);
 		goto exit;
 	}
 	adapter->i2c_client = client;
-- 
2.20.1

