Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9550C4D0C6D
	for <lists+netdev@lfdr.de>; Tue,  8 Mar 2022 01:05:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243159AbiCHAGf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Mar 2022 19:06:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44422 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233412AbiCHAGf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Mar 2022 19:06:35 -0500
Received: from smtp1.emailarray.com (smtp1.emailarray.com [65.39.216.14])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ACD4A13FBD
        for <netdev@vger.kernel.org>; Mon,  7 Mar 2022 16:05:39 -0800 (PST)
Received: (qmail 88142 invoked by uid 89); 8 Mar 2022 00:05:38 -0000
Received: from unknown (HELO localhost) (amxlbW9uQGZsdWdzdmFtcC5jb21AMTc0LjIxLjgzLjg3) (POLARISLOCAL)  
  by smtp1.emailarray.com with SMTP; 8 Mar 2022 00:05:38 -0000
From:   Jonathan Lemon <jonathan.lemon@gmail.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, richardcochran@gmail.com,
        kernel-team@fb.com
Subject: [PATCH net-next v2 1/2] ptp: ocp: add nvmem interface for accessing eeprom
Date:   Mon,  7 Mar 2022 16:05:34 -0800
Message-Id: <20220308000536.2278-2-jonathan.lemon@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20220308000536.2278-1-jonathan.lemon@gmail.com>
References: <20220308000536.2278-1-jonathan.lemon@gmail.com>
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

Add the at24 drivers for the eeprom, and use the accessors
via the nvmem API instead of direct i2c accesses.  This makes
things cleaner.

Add an eeprom map table which specifies where the pre-defined
information is located.  Retrieve the information and and export
it via the devlink interface.

Signed-off-by: Jonathan Lemon <jonathan.lemon@gmail.com>
---
 drivers/ptp/ptp_ocp.c | 192 +++++++++++++++++++++++++++---------------
 1 file changed, 124 insertions(+), 68 deletions(-)

diff --git a/drivers/ptp/ptp_ocp.c b/drivers/ptp/ptp_ocp.c
index 5e3e06acaf87..db805e3ce9a3 100644
--- a/drivers/ptp/ptp_ocp.c
+++ b/drivers/ptp/ptp_ocp.c
@@ -11,12 +11,14 @@
 #include <linux/clkdev.h>
 #include <linux/clk-provider.h>
 #include <linux/platform_device.h>
+#include <linux/platform_data/i2c-xiic.h>
 #include <linux/ptp_clock_kernel.h>
 #include <linux/spi/spi.h>
 #include <linux/spi/xilinx_spi.h>
 #include <net/devlink.h>
 #include <linux/i2c.h>
 #include <linux/mtd/mtd.h>
+#include <linux/nvmem-consumer.h>
 
 #ifndef PCI_VENDOR_ID_FACEBOOK
 #define PCI_VENDOR_ID_FACEBOOK 0x1d9b
@@ -204,6 +206,9 @@ struct ptp_ocp_ext_src {
 	int			irq_vec;
 };
 
+#define OCP_BOARD_ID_LEN		13
+#define OCP_SERIAL_LEN			6
+
 struct ptp_ocp {
 	struct pci_dev		*pdev;
 	struct device		dev;
@@ -230,6 +235,7 @@ struct ptp_ocp {
 	struct platform_device	*spi_flash;
 	struct clk_hw		*i2c_clk;
 	struct timer_list	watchdog;
+	const struct ptp_ocp_eeprom_map *eeprom_map;
 	struct dentry		*debug_root;
 	time64_t		gnss_lost;
 	int			id;
@@ -238,8 +244,9 @@ struct ptp_ocp {
 	int			gnss2_port;
 	int			mac_port;	/* miniature atomic clock */
 	int			nmea_port;
-	u8			serial[6];
-	bool			has_serial;
+	u8			board_id[OCP_BOARD_ID_LEN];
+	u8			serial[OCP_SERIAL_LEN];
+	bool			has_eeprom_data;
 	u32			pps_req_map;
 	int			flash_start;
 	u32			utc_tai_offset;
@@ -268,6 +275,28 @@ static int ptp_ocp_fb_board_init(struct ptp_ocp *bp, struct ocp_resource *r);
 static irqreturn_t ptp_ocp_ts_irq(int irq, void *priv);
 static int ptp_ocp_ts_enable(void *priv, u32 req, bool enable);
 
+struct ptp_ocp_eeprom_map {
+	u16	off;
+	u16	len;
+	u32	bp_offset;
+	const void * const tag;
+};
+
+#define EEPROM_ENTRY(addr, member)				\
+	.off = addr,						\
+	.len = sizeof_field(struct ptp_ocp, member),		\
+	.bp_offset = offsetof(struct ptp_ocp, member)
+
+#define BP_MAP_ENTRY_ADDR(bp, map) ({				\
+	(void *)((uintptr_t)(bp) + (map)->bp_offset);		\
+})
+
+static struct ptp_ocp_eeprom_map fb_eeprom_map[] = {
+	{ EEPROM_ENTRY(0x43, board_id) },
+	{ EEPROM_ENTRY(0x00, serial), .tag = "mac" },
+	{ }
+};
+
 #define bp_assign_entry(bp, res, val) ({				\
 	uintptr_t addr = (uintptr_t)(bp) + (res)->bp_offset;		\
 	*(typeof(val) *)addr = val;					\
@@ -396,6 +425,15 @@ static struct ocp_resource ocp_fb_resource[] = {
 		.extra = &(struct ptp_ocp_i2c_info) {
 			.name = "xiic-i2c",
 			.fixed_rate = 50000000,
+			.data_size = sizeof(struct xiic_i2c_platform_data),
+			.data = &(struct xiic_i2c_platform_data) {
+				.num_devices = 2,
+				.devices = (struct i2c_board_info[]) {
+					{ I2C_BOARD_INFO("24c02", 0x50) },
+					{ I2C_BOARD_INFO("24mac402", 0x58),
+					  .platform_data = "mac" },
+				},
+			},
 		},
 	},
 	{
@@ -919,78 +957,88 @@ ptp_ocp_tod_gnss_name(int idx)
 	return gnss_name[idx];
 }
 
-static int
-ptp_ocp_firstchild(struct device *dev, void *data)
-{
-	return 1;
-}
+struct ptp_ocp_nvmem_match_info {
+	struct ptp_ocp *bp;
+	const void * const tag;
+};
 
 static int
-ptp_ocp_read_i2c(struct i2c_adapter *adap, u8 addr, u8 reg, u8 sz, u8 *data)
+ptp_ocp_nvmem_match(struct device *dev, const void *data)
 {
-	struct i2c_msg msgs[2] = {
-		{
-			.addr = addr,
-			.len = 1,
-			.buf = &reg,
-		},
-		{
-			.addr = addr,
-			.flags = I2C_M_RD,
-			.len = 2,
-			.buf = data,
-		},
-	};
-	int err;
-	u8 len;
+	const struct ptp_ocp_nvmem_match_info *info = data;
 
-	/* xiic-i2c for some stupid reason only does 2 byte reads. */
-	while (sz) {
-		len = min_t(u8, sz, 2);
-		msgs[1].len = len;
-		err = i2c_transfer(adap, msgs, 2);
-		if (err != msgs[1].len)
-			return err;
-		msgs[1].buf += len;
-		reg += len;
-		sz -= len;
-	}
+	dev = dev->parent;
+	if (!i2c_verify_client(dev) || info->tag != dev->platform_data)
+		return 0;
+
+	while ((dev = dev->parent))
+		if (dev->driver && !strcmp(dev->driver->name, KBUILD_MODNAME))
+			return info->bp == dev_get_drvdata(dev);
 	return 0;
 }
 
-static void
-ptp_ocp_get_serial_number(struct ptp_ocp *bp)
+static inline struct nvmem_device *
+ptp_ocp_nvmem_device_get(struct ptp_ocp *bp, const void * const tag)
 {
-	struct i2c_adapter *adap;
-	struct device *dev;
-	int err;
+	struct ptp_ocp_nvmem_match_info info = { .bp = bp, .tag = tag };
+
+	return nvmem_device_find(&info, ptp_ocp_nvmem_match);
+}
+
+static inline void
+ptp_ocp_nvmem_device_put(struct nvmem_device **nvmemp)
+{
+	if (*nvmemp != NULL) {
+		nvmem_device_put(*nvmemp);
+		*nvmemp = NULL;
+	}
+}
+
+static void
+ptp_ocp_read_eeprom(struct ptp_ocp *bp)
+{
+	const struct ptp_ocp_eeprom_map *map;
+	struct nvmem_device *nvmem;
+	const void *tag;
+	int ret;
 
 	if (!bp->i2c_ctrl)
 		return;
 
-	dev = device_find_child(&bp->i2c_ctrl->dev, NULL, ptp_ocp_firstchild);
-	if (!dev) {
-		dev_err(&bp->pdev->dev, "Can't find I2C adapter\n");
-		return;
+	tag = NULL;
+	nvmem = NULL;
+
+	for (map = bp->eeprom_map; map->len; map++) {
+		if (map->tag != tag) {
+			tag = map->tag;
+			ptp_ocp_nvmem_device_put(&nvmem);
+		}
+		if (!nvmem) {
+			nvmem = ptp_ocp_nvmem_device_get(bp, tag);
+			if (!nvmem)
+				goto out;
+		}
+		ret = nvmem_device_read(nvmem, map->off, map->len,
+					BP_MAP_ENTRY_ADDR(bp, map));
+		if (ret != map->len)
+			goto read_fail;
 	}
 
-	adap = i2c_verify_adapter(dev);
-	if (!adap) {
-		dev_err(&bp->pdev->dev, "device '%s' isn't an I2C adapter\n",
-			dev_name(dev));
-		goto out;
-	}
-
-	err = ptp_ocp_read_i2c(adap, 0x58, 0x9A, 6, bp->serial);
-	if (err) {
-		dev_err(&bp->pdev->dev, "could not read eeprom: %d\n", err);
-		goto out;
-	}
-
-	bp->has_serial = true;
+	bp->has_eeprom_data = true;
 
 out:
-	put_device(dev);
+	ptp_ocp_nvmem_device_put(&nvmem);
+	return;
+
+read_fail:
+	dev_err(&bp->pdev->dev, "could not read eeprom: %d\n", ret);
+	goto out;
+}
+
+static int
+ptp_ocp_firstchild(struct device *dev, void *data)
+{
+	return 1;
 }
 
 static struct device *
@@ -1109,16 +1157,23 @@ ptp_ocp_devlink_info_get(struct devlink *devlink, struct devlink_info_req *req,
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
+			DEVLINK_INFO_VERSION_GENERIC_BOARD_ID,
+			bp->board_id);
+	if (err)
+		return err;
+
 	return 0;
 }
 
@@ -1412,6 +1467,7 @@ static int
 ptp_ocp_fb_board_init(struct ptp_ocp *bp, struct ocp_resource *r)
 {
 	bp->flash_start = 1024 * 4096;
+	bp->eeprom_map = fb_eeprom_map;
 
 	ptp_ocp_tod_init(bp);
 	ptp_ocp_nmea_out_init(bp);
@@ -1810,8 +1866,8 @@ serialnum_show(struct device *dev, struct device_attribute *attr, char *buf)
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

