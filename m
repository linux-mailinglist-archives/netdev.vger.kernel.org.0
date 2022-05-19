Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3E96152DF22
	for <lists+netdev@lfdr.de>; Thu, 19 May 2022 23:22:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245134AbiESVWH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 May 2022 17:22:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54710 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245129AbiESVWD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 May 2022 17:22:03 -0400
Received: from smtp1.emailarray.com (smtp1.emailarray.com [65.39.216.14])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 10616ED7B3
        for <netdev@vger.kernel.org>; Thu, 19 May 2022 14:22:00 -0700 (PDT)
Received: (qmail 59060 invoked by uid 89); 19 May 2022 21:21:59 -0000
Received: from unknown (HELO localhost) (amxlbW9uQGZsdWdzdmFtcC5jb21AMTc0LjIxLjE0NC4yOQ==) (POLARISLOCAL)  
  by smtp1.emailarray.com with SMTP; 19 May 2022 21:21:59 -0000
From:   Jonathan Lemon <jonathan.lemon@gmail.com>
To:     netdev@vger.kernel.org
Cc:     richardcochran@gmail.com, kernel-team@fb.com, davem@davemloft.net,
        kuba@kernel.org, pabeni@redhat.com, edumazet@google.com
Subject: [PATCH net-next v4 04/10] ptp: ocp: revise firmware display
Date:   Thu, 19 May 2022 14:21:47 -0700
Message-Id: <20220519212153.450437-5-jonathan.lemon@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20220519212153.450437-1-jonathan.lemon@gmail.com>
References: <20220519212153.450437-1-jonathan.lemon@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=0.5 required=5.0 tests=BAYES_00,DKIM_ADSP_CUSTOM_MED,
        FORGED_GMAIL_RCVD,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,NML_ADSP_CUSTOM_MED,RCVD_IN_MSPIKE_H2,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,UNPARSEABLE_RELAY
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Preparse the firmware image information into loader/tag/version,
and set the fw capabilities based on the tag/version.

Signed-off-by: Jonathan Lemon <jonathan.lemon@gmail.com>
---
 drivers/ptp/ptp_ocp.c | 64 +++++++++++++++++++++++++++----------------
 1 file changed, 41 insertions(+), 23 deletions(-)

diff --git a/drivers/ptp/ptp_ocp.c b/drivers/ptp/ptp_ocp.c
index b5f2b7769028..f44269e3d3c8 100644
--- a/drivers/ptp/ptp_ocp.c
+++ b/drivers/ptp/ptp_ocp.c
@@ -308,7 +308,9 @@ struct ptp_ocp {
 	int			gnss2_port;
 	int			mac_port;	/* miniature atomic clock */
 	int			nmea_port;
-	u32			fw_version;
+	bool			fw_loader;
+	u8			fw_tag;
+	u16			fw_version;
 	u8			board_id[OCP_BOARD_ID_LEN];
 	u8			serial[OCP_SERIAL_LEN];
 	bool			has_eeprom_data;
@@ -1359,6 +1361,7 @@ ptp_ocp_devlink_info_get(struct devlink *devlink, struct devlink_info_req *req,
 			 struct netlink_ext_ack *extack)
 {
 	struct ptp_ocp *bp = devlink_priv(devlink);
+	const char *fw_image;
 	char buf[32];
 	int err;
 
@@ -1366,13 +1369,9 @@ ptp_ocp_devlink_info_get(struct devlink *devlink, struct devlink_info_req *req,
 	if (err)
 		return err;
 
-	if (bp->fw_version & 0xffff) {
-		sprintf(buf, "%d", bp->fw_version);
-		err = devlink_info_version_running_put(req, "fw", buf);
-	} else {
-		sprintf(buf, "%d", bp->fw_version >> 16);
-		err = devlink_info_version_running_put(req, "loader", buf);
-	}
+	fw_image = bp->fw_loader ? "loader" : "fw";
+	sprintf(buf, "%d.%d", bp->fw_tag, bp->fw_version);
+	err = devlink_info_version_running_put(req, fw_image, buf);
 	if (err)
 		return err;
 
@@ -1931,22 +1930,49 @@ ptp_ocp_fb_set_pins(struct ptp_ocp *bp)
 	return 0;
 }
 
+static void
+ptp_ocp_fb_set_version(struct ptp_ocp *bp)
+{
+	u64 cap = OCP_CAP_BASIC;
+	u32 version;
+
+	version = ioread32(&bp->image->version);
+
+	/* if lower 16 bits are empty, this is the fw loader. */
+	if ((version & 0xffff) == 0) {
+		version = version >> 16;
+		bp->fw_loader = true;
+	}
+
+	bp->fw_tag = version >> 15;
+	bp->fw_version = version & 0x7fff;
+
+	if (bp->fw_tag) {
+		/* FPGA firmware */
+		if (version >= 5)
+			cap |= OCP_CAP_SIGNAL | OCP_CAP_FREQ;
+	} else {
+		/* SOM firmware */
+		if (version >= 19)
+			cap |= OCP_CAP_SIGNAL;
+		if (version >= 20)
+			cap |= OCP_CAP_FREQ;
+	}
+
+	bp->fw_cap = cap;
+}
+
 /* FB specific board initializers; last "resource" registered. */
 static int
 ptp_ocp_fb_board_init(struct ptp_ocp *bp, struct ocp_resource *r)
 {
-	int ver, err;
+	int err;
 
 	bp->flash_start = 1024 * 4096;
 	bp->eeprom_map = fb_eeprom_map;
 	bp->fw_version = ioread32(&bp->image->version);
-	bp->fw_cap = OCP_CAP_BASIC;
 
-	ver = bp->fw_version & 0xffff;
-	if (ver >= 19)
-		bp->fw_cap |= OCP_CAP_SIGNAL;
-	if (ver >= 20)
-		bp->fw_cap |= OCP_CAP_FREQ;
+	ptp_ocp_fb_set_version(bp);
 
 	ptp_ocp_tod_init(bp);
 	ptp_ocp_nmea_out_init(bp);
@@ -3497,14 +3523,6 @@ ptp_ocp_info(struct ptp_ocp *bp)
 
 	ptp_ocp_phc_info(bp);
 
-	dev_info(dev, "version %x\n", bp->fw_version);
-	if (bp->fw_version & 0xffff)
-		dev_info(dev, "regular image, version %d\n",
-			 bp->fw_version & 0xffff);
-	else
-		dev_info(dev, "golden image, version %d\n",
-			 bp->fw_version >> 16);
-
 	ptp_ocp_serial_info(dev, "GNSS", bp->gnss_port, 115200);
 	ptp_ocp_serial_info(dev, "GNSS2", bp->gnss2_port, 115200);
 	ptp_ocp_serial_info(dev, "MAC", bp->mac_port, 57600);
-- 
2.31.1

