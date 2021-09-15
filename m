Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F252140BD94
	for <lists+netdev@lfdr.de>; Wed, 15 Sep 2021 04:16:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234559AbhIOCSA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Sep 2021 22:18:00 -0400
Received: from smtp1.emailarray.com ([65.39.216.14]:48107 "EHLO
        smtp1.emailarray.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234174AbhIOCR7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Sep 2021 22:17:59 -0400
Received: (qmail 54672 invoked by uid 89); 15 Sep 2021 02:16:40 -0000
Received: from unknown (HELO localhost) (amxlbW9uQGZsdWdzdmFtcC5jb21ANzEuMjEyLjEzOC4zOQ==) (POLARISLOCAL)  
  by smtp1.emailarray.com with SMTP; 15 Sep 2021 02:16:40 -0000
From:   Jonathan Lemon <jonathan.lemon@gmail.com>
To:     kuba@kernel.org, davem@davemloft.net, richardcochran@gmail.com
Cc:     netdev@vger.kernel.org, kernel-team@fb.com
Subject: [PATCH net-next 03/18] ptp: ocp: Skip I2C flash read when there is no controller.
Date:   Tue, 14 Sep 2021 19:16:21 -0700
Message-Id: <20210915021636.153754-4-jonathan.lemon@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210915021636.153754-1-jonathan.lemon@gmail.com>
References: <20210915021636.153754-1-jonathan.lemon@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If an I2C controller isn't present, don't try and read the I2C flash.

Signed-off-by: Jonathan Lemon <jonathan.lemon@gmail.com>
---
 drivers/ptp/ptp_ocp.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/ptp/ptp_ocp.c b/drivers/ptp/ptp_ocp.c
index 2a6cc762c60e..196a457929f0 100644
--- a/drivers/ptp/ptp_ocp.c
+++ b/drivers/ptp/ptp_ocp.c
@@ -228,8 +228,8 @@ static int ptp_ocp_ts_enable(void *priv, bool enable);
  * 3: GPS
  * 4: GPS2 (n/c)
  * 5: MAC
- * 6: SPI IMU (inertial measurement unit)
- * 7: I2C oscillator
+ * 6: N/C
+ * 7: I2C controller
  * 8: HWICAP
  * 9: SPI Flash
  */
@@ -706,6 +706,9 @@ ptp_ocp_get_serial_number(struct ptp_ocp *bp)
 	struct device *dev;
 	int err;
 
+	if (!bp->i2c_ctrl)
+		return;
+
 	dev = device_find_child(&bp->i2c_ctrl->dev, NULL, ptp_ocp_firstchild);
 	if (!dev) {
 		dev_err(&bp->pdev->dev, "Can't find I2C adapter\n");
-- 
2.31.1

