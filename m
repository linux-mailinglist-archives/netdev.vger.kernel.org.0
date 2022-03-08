Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9DC874D0C6E
	for <lists+netdev@lfdr.de>; Tue,  8 Mar 2022 01:05:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243924AbiCHAGq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Mar 2022 19:06:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44454 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243897AbiCHAGg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Mar 2022 19:06:36 -0500
Received: from smtp3.emailarray.com (smtp3.emailarray.com [65.39.216.17])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 24BDD2C65A
        for <netdev@vger.kernel.org>; Mon,  7 Mar 2022 16:05:41 -0800 (PST)
Received: (qmail 56688 invoked by uid 89); 8 Mar 2022 00:05:39 -0000
Received: from unknown (HELO localhost) (amxlbW9uQGZsdWdzdmFtcC5jb21AMTc0LjIxLjgzLjg3) (POLARISLOCAL)  
  by smtp3.emailarray.com with SMTP; 8 Mar 2022 00:05:39 -0000
From:   Jonathan Lemon <jonathan.lemon@gmail.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, richardcochran@gmail.com,
        kernel-team@fb.com
Subject: [PATCH net-next v2 2/2] ptp: ocp: Update devlink firmware display path.
Date:   Mon,  7 Mar 2022 16:05:35 -0800
Message-Id: <20220308000536.2278-3-jonathan.lemon@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20220308000536.2278-1-jonathan.lemon@gmail.com>
References: <20220308000536.2278-1-jonathan.lemon@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=0.5 required=5.0 tests=BAYES_00,DKIM_ADSP_CUSTOM_MED,
        FORGED_GMAIL_RCVD,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,NML_ADSP_CUSTOM_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,UNPARSEABLE_RELAY autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Cache the firmware version when the card is initialized,
and use this field to populate the devlink firmware information.

The cached firmware version will be used for feature gating in
upcoming patches.

Signed-off-by: Jonathan Lemon <jonathan.lemon@gmail.com>
---
 drivers/ptp/ptp_ocp.c | 43 +++++++++++++++++--------------------------
 1 file changed, 17 insertions(+), 26 deletions(-)

diff --git a/drivers/ptp/ptp_ocp.c b/drivers/ptp/ptp_ocp.c
index db805e3ce9a3..8e23d563a577 100644
--- a/drivers/ptp/ptp_ocp.c
+++ b/drivers/ptp/ptp_ocp.c
@@ -244,6 +244,7 @@ struct ptp_ocp {
 	int			gnss2_port;
 	int			mac_port;	/* miniature atomic clock */
 	int			nmea_port;
+	u32			fw_version;
 	u8			board_id[OCP_BOARD_ID_LEN];
 	u8			serial[OCP_SERIAL_LEN];
 	bool			has_eeprom_data;
@@ -1139,23 +1140,15 @@ ptp_ocp_devlink_info_get(struct devlink *devlink, struct devlink_info_req *req,
 	if (err)
 		return err;
 
-	if (bp->image) {
-		u32 ver = ioread32(&bp->image->version);
-
-		if (ver & 0xffff) {
-			sprintf(buf, "%d", ver);
-			err = devlink_info_version_running_put(req,
-							       "fw",
-							       buf);
-		} else {
-			sprintf(buf, "%d", ver >> 16);
-			err = devlink_info_version_running_put(req,
-							       "loader",
-							       buf);
-		}
-		if (err)
-			return err;
+	if (bp->fw_version & 0xffff) {
+		sprintf(buf, "%d", bp->fw_version);
+		err = devlink_info_version_running_put(req, "fw", buf);
+	} else {
+		sprintf(buf, "%d", bp->fw_version >> 16);
+		err = devlink_info_version_running_put(req, "loader", buf);
 	}
+	if (err)
+		return err;
 
 	if (!bp->has_eeprom_data) {
 		ptp_ocp_read_eeprom(bp);
@@ -1468,6 +1461,7 @@ ptp_ocp_fb_board_init(struct ptp_ocp *bp, struct ocp_resource *r)
 {
 	bp->flash_start = 1024 * 4096;
 	bp->eeprom_map = fb_eeprom_map;
+	bp->fw_version = ioread32(&bp->image->version);
 
 	ptp_ocp_tod_init(bp);
 	ptp_ocp_nmea_out_init(bp);
@@ -2576,17 +2570,14 @@ ptp_ocp_info(struct ptp_ocp *bp)
 
 	ptp_ocp_phc_info(bp);
 
-	if (bp->image) {
-		u32 ver = ioread32(&bp->image->version);
+	dev_info(dev, "version %x\n", bp->fw_version);
+	if (bp->fw_version & 0xffff)
+		dev_info(dev, "regular image, version %d\n",
+			 bp->fw_version & 0xffff);
+	else
+		dev_info(dev, "golden image, version %d\n",
+			 bp->fw_version >> 16);
 
-		dev_info(dev, "version %x\n", ver);
-		if (ver & 0xffff)
-			dev_info(dev, "regular image, version %d\n",
-				 ver & 0xffff);
-		else
-			dev_info(dev, "golden image, version %d\n",
-				 ver >> 16);
-	}
 	ptp_ocp_serial_info(dev, "GNSS", bp->gnss_port, 115200);
 	ptp_ocp_serial_info(dev, "GNSS2", bp->gnss2_port, 115200);
 	ptp_ocp_serial_info(dev, "MAC", bp->mac_port, 57600);
-- 
2.31.1

