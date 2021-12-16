Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 324DB477D17
	for <lists+netdev@lfdr.de>; Thu, 16 Dec 2021 21:08:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234368AbhLPUHy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Dec 2021 15:07:54 -0500
Received: from smtp7.emailarray.com ([65.39.216.66]:15476 "EHLO
        smtp7.emailarray.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234059AbhLPUHu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Dec 2021 15:07:50 -0500
Received: (qmail 61165 invoked by uid 89); 16 Dec 2021 20:01:09 -0000
Received: from unknown (HELO localhost) (amxlbW9uQGZsdWdzdmFtcC5jb21ANzEuMjEyLjEzOC4zOQ==) (POLARISLOCAL)  
  by smtp7.emailarray.com with SMTP; 16 Dec 2021 20:01:09 -0000
From:   Jonathan Lemon <jonathan.lemon@gmail.com>
To:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org
Cc:     kernel-team@fb.com
Subject: [PATCH 5/5] ptp: ocp: export board info via devlink
Date:   Thu, 16 Dec 2021 12:01:04 -0800
Message-Id: <20211216200104.266433-5-jonathan.lemon@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211216200104.266433-1-jonathan.lemon@gmail.com>
References: <20211216200104.266433-1-jonathan.lemon@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

TimeCard has eeprom with manufacturer pre-defined information.
Export this via devlink interface.

Co-developed-by: Vadim Fedorenko <vadfed@fb.com>
Signed-off-by: Jonathan Lemon <jonathan.lemon@gmail.com>
---
 drivers/ptp/ptp_ocp.c | 71 +++++++++++++++++++++++++++++++------------
 1 file changed, 52 insertions(+), 19 deletions(-)

diff --git a/drivers/ptp/ptp_ocp.c b/drivers/ptp/ptp_ocp.c
index dc4d07b04320..8f235eef7521 100644
--- a/drivers/ptp/ptp_ocp.c
+++ b/drivers/ptp/ptp_ocp.c
@@ -203,6 +203,10 @@ struct ptp_ocp_ext_src {
 	int			irq_vec;
 };
 
+#define OCP_BOARD_MFR_LEN		8
+#define OCP_BOARD_ID_LEN		12
+#define OCP_SERIAL_LEN			6
+
 struct ptp_ocp {
 	struct pci_dev		*pdev;
 	struct device		dev;
@@ -237,8 +241,10 @@ struct ptp_ocp {
 	int			gnss2_port;
 	int			mac_port;	/* miniature atomic clock */
 	int			nmea_port;
-	u8			serial[6];
-	bool			has_serial;
+	u8			board_mfr[OCP_BOARD_MFR_LEN];
+	u8			board_id[OCP_BOARD_ID_LEN];
+	u8			serial[OCP_SERIAL_LEN];
+	bool			has_eeprom_data;
 	u32			pps_req_map;
 	int			flash_start;
 	u32			utc_tai_offset;
@@ -977,7 +983,7 @@ ptp_ocp_read_i2c(struct i2c_adapter *adap, u8 addr, u8 reg, u8 sz, u8 *data)
 }
 
 static void
-ptp_ocp_get_serial_number(struct ptp_ocp *bp)
+ptp_ocp_read_eeprom(struct ptp_ocp *bp)
 {
 	struct i2c_adapter *adap;
 	struct device *dev;
@@ -999,16 +1005,30 @@ ptp_ocp_get_serial_number(struct ptp_ocp *bp)
 		goto out;
 	}
 
-	err = ptp_ocp_read_i2c(adap, 0x58, 0x9A, 6, bp->serial);
-	if (err) {
-		dev_err(&bp->pdev->dev, "could not read eeprom: %d\n", err);
-		goto out;
-	}
+	err = ptp_ocp_read_i2c(adap, 0x50, 0x7A,
+			       sizeof(bp->board_mfr), bp->board_mfr);
+	if (err)
+		goto read_fail;
 
-	bp->has_serial = true;
+	err = ptp_ocp_read_i2c(adap, 0x50, 0x44,
+			       sizeof(bp->board_id), bp->board_id);
+	if (err)
+		goto read_fail;
+
+	err = ptp_ocp_read_i2c(adap, 0x58, 0x9A,
+			       sizeof(bp->serial), bp->serial);
+	if (err)
+		goto read_fail;
+
+	bp->has_eeprom_data = true;
 
 out:
 	put_device(dev);
+	return;
+
+read_fail:
+	dev_err(&bp->pdev->dev, "could not read eeprom: %d\n", err);
+	goto out;
 }
 
 static struct device *
@@ -1127,16 +1147,29 @@ ptp_ocp_devlink_info_get(struct devlink *devlink, struct devlink_info_req *req,
 			return err;
 	}
 
-	if (!bp->has_serial)
-		ptp_ocp_get_serial_number(bp);
-
-	if (bp->has_serial) {
-		sprintf(buf, "%pM", bp->serial);
-		err = devlink_info_serial_number_put(req, buf);
-		if (err)
-			return err;
+	if (!bp->has_eeprom_data) {
+		ptp_ocp_read_eeprom(bp);
+		if (!bp->has_eeprom_data)
+			return 0;
 	}
 
+	sprintf(buf, "%pM", bp->serial);
+	err = devlink_info_serial_number_put(req, buf);
+	if (err)
+		return err;
+
+	err = devlink_info_version_fixed_put(req,
+			DEVLINK_INFO_VERSION_GENERIC_BOARD_MANUFACTURE,
+			bp->board_mfr);
+	if (err)
+		return err;
+
+	err = devlink_info_version_fixed_put(req,
+			DEVLINK_INFO_VERSION_GENERIC_BOARD_ID,
+			bp->board_id);
+	if (err)
+		return err;
+
 	return 0;
 }
 
@@ -1828,8 +1861,8 @@ serialnum_show(struct device *dev, struct device_attribute *attr, char *buf)
 {
 	struct ptp_ocp *bp = dev_get_drvdata(dev);
 
-	if (!bp->has_serial)
-		ptp_ocp_get_serial_number(bp);
+	if (!bp->has_eeprom_data)
+		ptp_ocp_read_eeprom(bp);
 
 	return sysfs_emit(buf, "%pM\n", bp->serial);
 }
-- 
2.31.1

