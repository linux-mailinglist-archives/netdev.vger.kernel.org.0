Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E951E32D349
	for <lists+netdev@lfdr.de>; Thu,  4 Mar 2021 13:36:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240976AbhCDMe7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Mar 2021 07:34:59 -0500
Received: from mga05.intel.com ([192.55.52.43]:28648 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240994AbhCDMeh (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 4 Mar 2021 07:34:37 -0500
IronPort-SDR: m95GBbiwC0W0gHdcBPoWxGphA/IvLfb8Vds3UV5EEbNyLp6wCAToRuxRdvc50NmE6qGRryBjtx
 SdsNX+5cbkyw==
X-IronPort-AV: E=McAfee;i="6000,8403,9912"; a="272407045"
X-IronPort-AV: E=Sophos;i="5.81,222,1610438400"; 
   d="scan'208";a="272407045"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Mar 2021 04:31:35 -0800
IronPort-SDR: xCTp1s/OrcjpiNBQkt4NjSf5kzeKZ40lCf2WTpjO9Oix4ZjW88x69RMC43EUkofohO1j4DkNQ5
 mNvPCyOAyI1Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.81,222,1610438400"; 
   d="scan'208";a="600508115"
Received: from black.fi.intel.com ([10.237.72.28])
  by fmsmga005.fm.intel.com with ESMTP; 04 Mar 2021 04:31:32 -0800
Received: by black.fi.intel.com (Postfix, from userid 1001)
        id EA9B676E; Thu,  4 Mar 2021 14:31:26 +0200 (EET)
From:   Mika Westerberg <mika.westerberg@linux.intel.com>
To:     linux-usb@vger.kernel.org
Cc:     Michael Jamet <michael.jamet@intel.com>,
        Yehezkel Bernat <YehezkelShB@gmail.com>,
        Andreas Noever <andreas.noever@gmail.com>,
        Isaac Hazan <isaac.hazan@intel.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Lukas Wunner <lukas@wunner.de>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH 18/18] thunderbolt: Add support for USB4 DROM
Date:   Thu,  4 Mar 2021 15:31:25 +0300
Message-Id: <20210304123125.43630-19-mika.westerberg@linux.intel.com>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210304123125.43630-1-mika.westerberg@linux.intel.com>
References: <20210304123125.43630-1-mika.westerberg@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

USB4 router DROM differs sligthly from Thunderbolt 1-3 DROM. For
instance it does not include UID and CRC8 in the header section, and it
has product descriptor genereric entry to describe the product IDs and
related information. If the "Version" field in the DROM header section
reads 3 it means the router only has USB4 DROM and if it reads 1 it
means the router supports TBT3 compatible DROM.

For this reason, update the DROM parsing code to support "pure" USB4
DROMs too.

While there drop the extra empty line at the end of tb_drom_read().

Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
---
 drivers/thunderbolt/eeprom.c | 104 +++++++++++++++++++++++++++--------
 1 file changed, 80 insertions(+), 24 deletions(-)

diff --git a/drivers/thunderbolt/eeprom.c b/drivers/thunderbolt/eeprom.c
index aecb0b9f0c75..46d0906a3070 100644
--- a/drivers/thunderbolt/eeprom.c
+++ b/drivers/thunderbolt/eeprom.c
@@ -277,6 +277,16 @@ struct tb_drom_entry_port {
 	u8 unknown4:2;
 } __packed;
 
+/* USB4 product descriptor */
+struct tb_drom_entry_desc {
+	struct tb_drom_entry_header header;
+	u16 bcdUSBSpec;
+	u16 idVendor;
+	u16 idProduct;
+	u16 bcdProductFWRevision;
+	u32 TID;
+	u8 productHWRevision;
+};
 
 /**
  * tb_drom_read_uid_only() - Read UID directly from DROM
@@ -329,6 +339,16 @@ static int tb_drom_parse_entry_generic(struct tb_switch *sw,
 		if (!sw->device_name)
 			return -ENOMEM;
 		break;
+	case 9: {
+		const struct tb_drom_entry_desc *desc =
+			(const struct tb_drom_entry_desc *)entry;
+
+		if (!sw->vendor && !sw->device) {
+			sw->vendor = desc->idVendor;
+			sw->device = desc->idProduct;
+		}
+		break;
+	}
 	}
 
 	return 0;
@@ -521,6 +541,51 @@ static int tb_drom_read_n(struct tb_switch *sw, u16 offset, u8 *val,
 	return tb_eeprom_read_n(sw, offset, val, count);
 }
 
+static int tb_drom_parse(struct tb_switch *sw)
+{
+	const struct tb_drom_header *header =
+		(const struct tb_drom_header *)sw->drom;
+	u32 crc;
+
+	crc = tb_crc8((u8 *) &header->uid, 8);
+	if (crc != header->uid_crc8) {
+		tb_sw_warn(sw,
+			"DROM UID CRC8 mismatch (expected: %#x, got: %#x), aborting\n",
+			header->uid_crc8, crc);
+		return -EINVAL;
+	}
+	if (!sw->uid)
+		sw->uid = header->uid;
+	sw->vendor = header->vendor_id;
+	sw->device = header->model_id;
+
+	crc = tb_crc32(sw->drom + TB_DROM_DATA_START, header->data_len);
+	if (crc != header->data_crc32) {
+		tb_sw_warn(sw,
+			"DROM data CRC32 mismatch (expected: %#x, got: %#x), continuing\n",
+			header->data_crc32, crc);
+	}
+
+	return tb_drom_parse_entries(sw);
+}
+
+static int usb4_drom_parse(struct tb_switch *sw)
+{
+	const struct tb_drom_header *header =
+		(const struct tb_drom_header *)sw->drom;
+	u32 crc;
+
+	crc = tb_crc32(sw->drom + TB_DROM_DATA_START, header->data_len);
+	if (crc != header->data_crc32) {
+		tb_sw_warn(sw,
+			   "DROM data CRC32 mismatch (expected: %#x, got: %#x), aborting\n",
+			   header->data_crc32, crc);
+		return -EINVAL;
+	}
+
+	return tb_drom_parse_entries(sw);
+}
+
 /**
  * tb_drom_read() - Copy DROM to sw->drom and parse it
  * @sw: Router whose DROM to read and parse
@@ -534,7 +599,6 @@ static int tb_drom_read_n(struct tb_switch *sw, u16 offset, u8 *val,
 int tb_drom_read(struct tb_switch *sw)
 {
 	u16 size;
-	u32 crc;
 	struct tb_drom_header *header;
 	int res, retries = 1;
 
@@ -599,30 +663,21 @@ int tb_drom_read(struct tb_switch *sw)
 		goto err;
 	}
 
-	crc = tb_crc8((u8 *) &header->uid, 8);
-	if (crc != header->uid_crc8) {
-		tb_sw_warn(sw,
-			"drom uid crc8 mismatch (expected: %#x, got: %#x), aborting\n",
-			header->uid_crc8, crc);
-		goto err;
-	}
-	if (!sw->uid)
-		sw->uid = header->uid;
-	sw->vendor = header->vendor_id;
-	sw->device = header->model_id;
+	tb_sw_dbg(sw, "DROM version: %d\n", header->device_rom_revision);
 
-	crc = tb_crc32(sw->drom + TB_DROM_DATA_START, header->data_len);
-	if (crc != header->data_crc32) {
-		tb_sw_warn(sw,
-			"drom data crc32 mismatch (expected: %#x, got: %#x), continuing\n",
-			header->data_crc32, crc);
+	switch (header->device_rom_revision) {
+	case 3:
+		res = usb4_drom_parse(sw);
+		break;
+	default:
+		tb_sw_warn(sw, "DROM device_rom_revision %#x unknown\n",
+			   header->device_rom_revision);
+		fallthrough;
+	case 1:
+		res = tb_drom_parse(sw);
+		break;
 	}
 
-	if (header->device_rom_revision > 2)
-		tb_sw_warn(sw, "drom device_rom_revision %#x unknown\n",
-			header->device_rom_revision);
-
-	res = tb_drom_parse_entries(sw);
 	/* If the DROM parsing fails, wait a moment and retry once */
 	if (res == -EILSEQ && retries--) {
 		tb_sw_warn(sw, "parsing DROM failed, retrying\n");
@@ -632,10 +687,11 @@ int tb_drom_read(struct tb_switch *sw)
 			goto parse;
 	}
 
-	return res;
+	if (!res)
+		return 0;
+
 err:
 	kfree(sw->drom);
 	sw->drom = NULL;
 	return -EIO;
-
 }
-- 
2.30.1

