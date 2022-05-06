Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8674E51E1D6
	for <lists+netdev@lfdr.de>; Sat,  7 May 2022 01:40:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1444712AbiEFWTm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 May 2022 18:19:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59744 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1444713AbiEFWTa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 May 2022 18:19:30 -0400
Received: from smtp5.emailarray.com (smtp5.emailarray.com [65.39.216.39])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3DD7615FE0
        for <netdev@vger.kernel.org>; Fri,  6 May 2022 15:15:46 -0700 (PDT)
Received: (qmail 68703 invoked by uid 89); 6 May 2022 22:15:44 -0000
Received: from unknown (HELO localhost) (amxlbW9uQGZsdWdzdmFtcC5jb21AMTc0LjIxLjE0NC4yOQ==) (POLARISLOCAL)  
  by smtp5.emailarray.com with SMTP; 6 May 2022 22:15:44 -0000
From:   Jonathan Lemon <jonathan.lemon@gmail.com>
To:     netdev@vger.kernel.org
Cc:     richardcochran@gmail.com, kernel-team@fb.com, davem@davemloft.net,
        kuba@kernel.org, pabeni@redhat.com, edumazet@google.com
Subject: [PATCH net-next v2 09/10] ptp: ocp: Add firmware header checks
Date:   Fri,  6 May 2022 15:15:30 -0700
Message-Id: <20220506221531.1308-10-jonathan.lemon@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20220506221531.1308-1-jonathan.lemon@gmail.com>
References: <20220506221531.1308-1-jonathan.lemon@gmail.com>
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

From: Vadim Fedorenko <vadfed@fb.com>

Right now it's possible to flash any kind of binary via devlink and
break the card easily. This diff adds an optional header check when
installing the firmware.

Signed-off-by: Vadim Fedorenko <vadfed@fb.com>
Signed-off-by: Jonathan Lemon <jonathan.lemon@gmail.com>
---
 drivers/ptp/ptp_ocp.c | 77 ++++++++++++++++++++++++++++++++++++++++---
 1 file changed, 72 insertions(+), 5 deletions(-)

diff --git a/drivers/ptp/ptp_ocp.c b/drivers/ptp/ptp_ocp.c
index 787561be37da..e056ccaec80d 100644
--- a/drivers/ptp/ptp_ocp.c
+++ b/drivers/ptp/ptp_ocp.c
@@ -19,6 +19,7 @@
 #include <linux/i2c.h>
 #include <linux/mtd/mtd.h>
 #include <linux/nvmem-consumer.h>
+#include <linux/crc16.h>
 
 #ifndef PCI_VENDOR_ID_FACEBOOK
 #define PCI_VENDOR_ID_FACEBOOK 0x1d9b
@@ -223,6 +224,16 @@ struct ptp_ocp_flash_info {
 	void *data;
 };
 
+struct ptp_ocp_firmware_header {
+	char magic[4];
+	__be16 pci_vendor_id;
+	__be16 pci_device_id;
+	__be32 image_size;
+	__be16 hw_revision;
+	__be16 crc;
+};
+#define OCP_FIRMWARE_MAGIC_HEADER "OCPC"
+
 struct ptp_ocp_i2c_info {
 	const char *name;
 	unsigned long fixed_rate;
@@ -1334,25 +1345,81 @@ ptp_ocp_find_flash(struct ptp_ocp *bp)
 	return dev;
 }
 
+static int
+ptp_ocp_devlink_fw_image(struct devlink *devlink, const struct firmware *fw,
+			 const u8 **data, size_t *size)
+{
+	struct ptp_ocp *bp = devlink_priv(devlink);
+	const struct ptp_ocp_firmware_header *hdr;
+	size_t offset, length;
+	u16 crc;
+
+	hdr = (const struct ptp_ocp_firmware_header *)fw->data;
+	if (memcmp(hdr->magic, OCP_FIRMWARE_MAGIC_HEADER, 4)) {
+		devlink_flash_update_status_notify(devlink,
+			"No firmware header found, flashing raw image",
+			NULL, 0, 0);
+		offset = 0;
+		length = fw->size;
+		goto out;
+	}
+
+	if (be16_to_cpu(hdr->pci_vendor_id) != bp->pdev->vendor ||
+	    be16_to_cpu(hdr->pci_device_id) != bp->pdev->device) {
+		devlink_flash_update_status_notify(devlink,
+			"Firmware image compatibility check failed",
+			NULL, 0, 0);
+		return -EINVAL;
+	}
+
+	offset = sizeof(*hdr);
+	length = be32_to_cpu(hdr->image_size);
+	if (length != (fw->size - offset)) {
+		devlink_flash_update_status_notify(devlink,
+			"Firmware image size check failed",
+			NULL, 0, 0);
+		return -EINVAL;
+	}
+
+	crc = crc16(0xffff, &fw->data[offset], length);
+	if (be16_to_cpu(hdr->crc) != crc) {
+		devlink_flash_update_status_notify(devlink,
+			"Firmware image CRC check failed",
+			NULL, 0, 0);
+		return -EINVAL;
+	}
+
+out:
+	*data = &fw->data[offset];
+	*size = length;
+
+	return 0;
+}
+
 static int
 ptp_ocp_devlink_flash(struct devlink *devlink, struct device *dev,
 		      const struct firmware *fw)
 {
 	struct mtd_info *mtd = dev_get_drvdata(dev);
 	struct ptp_ocp *bp = devlink_priv(devlink);
-	size_t off, len, resid, wrote;
+	size_t off, len, size, resid, wrote;
 	struct erase_info erase;
 	size_t base, blksz;
-	int err = 0;
+	const u8 *data;
+	int err;
+
+	err = ptp_ocp_devlink_fw_image(devlink, fw, &data, &size);
+	if (err)
+		goto out;
 
 	off = 0;
 	base = bp->flash_start;
 	blksz = 4096;
-	resid = fw->size;
+	resid = size;
 
 	while (resid) {
 		devlink_flash_update_status_notify(devlink, "Flashing",
-						   NULL, off, fw->size);
+						   NULL, off, size);
 
 		len = min_t(size_t, resid, blksz);
 		erase.addr = base + off;
@@ -1362,7 +1429,7 @@ ptp_ocp_devlink_flash(struct devlink *devlink, struct device *dev,
 		if (err)
 			goto out;
 
-		err = mtd_write(mtd, base + off, len, &wrote, &fw->data[off]);
+		err = mtd_write(mtd, base + off, len, &wrote, data + off);
 		if (err)
 			goto out;
 
-- 
2.31.1

