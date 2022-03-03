Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B9F084CCA20
	for <lists+netdev@lfdr.de>; Fri,  4 Mar 2022 00:38:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237266AbiCCXi6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Mar 2022 18:38:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36768 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237253AbiCCXiz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Mar 2022 18:38:55 -0500
Received: from smtp7.emailarray.com (smtp7.emailarray.com [65.39.216.66])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E52A457B3D
        for <netdev@vger.kernel.org>; Thu,  3 Mar 2022 15:38:08 -0800 (PST)
Received: (qmail 42193 invoked by uid 89); 3 Mar 2022 23:38:07 -0000
Received: from unknown (HELO localhost) (amxlbW9uQGZsdWdzdmFtcC5jb21AMTc0LjIxLjgzLjg3) (POLARISLOCAL)  
  by smtp7.emailarray.com with SMTP; 3 Mar 2022 23:38:07 -0000
From:   Jonathan Lemon <jonathan.lemon@gmail.com>
To:     netdev@vger.kernel.org
Cc:     richardcochran@gmail.com, davem@davemloft.net, kuba@kernel.org,
        kernel-team@fb.com
Subject: [PATCH net-next 2/2] ptp: ocp: Update devlink firmware display path.
Date:   Thu,  3 Mar 2022 15:38:01 -0800
Message-Id: <20220303233801.242870-5-jonathan.lemon@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20220303233801.242870-1-jonathan.lemon@gmail.com>
References: <20220303233801.242870-1-jonathan.lemon@gmail.com>
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
index 330a85cda1bd..55f7e8a7e9b4 100644
--- a/drivers/ptp/ptp_ocp.c
+++ b/drivers/ptp/ptp_ocp.c
@@ -245,6 +245,7 @@ struct ptp_ocp {
 	int			gnss2_port;
 	int			mac_port;	/* miniature atomic clock */
 	int			nmea_port;
+	u32			fw_version;
 	u8			board_mfr[OCP_BOARD_MFR_LEN];
 	u8			board_id[OCP_BOARD_ID_LEN];
 	u8			serial[OCP_SERIAL_LEN];
@@ -1142,23 +1143,15 @@ ptp_ocp_devlink_info_get(struct devlink *devlink, struct devlink_info_req *req,
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
@@ -1477,6 +1470,7 @@ ptp_ocp_fb_board_init(struct ptp_ocp *bp, struct ocp_resource *r)
 {
 	bp->flash_start = 1024 * 4096;
 	bp->eeprom_map = fb_eeprom_map;
+	bp->fw_version = ioread32(&bp->image->version);
 
 	ptp_ocp_tod_init(bp);
 	ptp_ocp_nmea_out_init(bp);
@@ -2585,17 +2579,14 @@ ptp_ocp_info(struct ptp_ocp *bp)
 
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

