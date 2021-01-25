Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 74BCE304A13
	for <lists+netdev@lfdr.de>; Tue, 26 Jan 2021 21:27:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731489AbhAZFQ6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Jan 2021 00:16:58 -0500
Received: from mail.kernel.org ([198.145.29.99]:39118 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729990AbhAYPfl (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 25 Jan 2021 10:35:41 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 93B2922AEC;
        Mon, 25 Jan 2021 15:03:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611586985;
        bh=SodW2Aczw/r/73KdEsUNqxJZauoAZ8zM0tz655NEihw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EvWBCUK9WbcCLfDZTxN6UDnYKWWr6BzWrtVzWpiw0z+jU0n+txU0VchGWb9oUI0oq
         Tmco66BvVplbmChiXfiV0JbJ/oWVLX4o1nFFS8Bu48a3qlaXQBal+fGqp6Ii9E2uqq
         NweohJ+7Qz+gbHC8FogQOyrtHFDbALYxSpKv1Pp0XYLDyibVuRjCdpW49TWBauJJe9
         iWJr4x4Bp+fNYWzFG0c/5mdM4gy3bhJRT/VQCwBvb8wWAqCMLLi6a0A3wQ70Q/0/pr
         VZhfoXJEZ3HCXqf7++3Ms89Wom5E/HN7OxGvR8YbLPvVPu7ciEg8+8pH9bGeBtPZmn
         i0aqlZDx3k9Zw==
Received: by pali.im (Postfix)
        id CBA9C768; Mon, 25 Jan 2021 16:03:03 +0100 (CET)
From:   =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>
To:     Russell King - ARM Linux admin <linux@armlinux.org.uk>,
        Andrew Lunn <andrew@lunn.ch>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Thomas Schreiber <tschreibe@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v4 1/2] net: sfp: add workaround for Realtek RTL8672 and RTL9601C chips
Date:   Mon, 25 Jan 2021 16:02:27 +0100
Message-Id: <20210125150228.8523-2-pali@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20210125150228.8523-1-pali@kernel.org>
References: <20201230154755.14746-1-pali@kernel.org>
 <20210125150228.8523-1-pali@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The workaround for VSOL V2801F brand based GPON SFP modules added in commit
0d035bed2a4a ("net: sfp: VSOL V2801F / CarlitoxxPro CPGOS03-0490 v2.0
workaround") works only for IDs added explicitly to the list. Since there
are rebranded modules where OEM vendors put different strings into the
vendor name field, we cannot base workaround on IDs only.

Moreover the issue which the above mentioned commit tried to work around is
generic not only to VSOL based modules, but rather to all GPON modules
based on Realtek RTL8672 and RTL9601C chips.

These include at least the following GPON modules:
* V-SOL V2801F
* C-Data FD511GX-RM0
* OPTON GP801R
* BAUDCOM BD-1234-SFM
* CPGOS03-0490 v2.0
* Ubiquiti U-Fiber Instant
* EXOT EGS1

These Realtek chips have broken EEPROM emulator which for N-byte read
operation returns just the first byte of EEPROM data, followed by N-1
zeros.

Introduce a new function, sfp_id_needs_byte_io(), which detects SFP modules
with broken EEPROM emulator based on N-1 zeros and switch to 1 byte EEPROM
reading operation.

Function sfp_i2c_read() now always uses single byte reading when it is
required and when function sfp_hwmon_probe() detects single byte access,
it disables registration of hwmon device, because in this case we cannot
reliably and atomically read 2 bytes as is required by the standard for
retrieving values from diagnostic area.

(These Realtek chips are broken in a way that violates SFP standards for
diagnostic interface. Kernel in this case simply cannot do anything less
of skipping registration of the hwmon interface.)

This patch fixes reading of EEPROM content from SFP modules based on
Realtek RTL8672 and RTL9601C chips. Diagnostic interface of EEPROM stays
broken and cannot be fixed.

Fixes: 0d035bed2a4a ("net: sfp: VSOL V2801F / CarlitoxxPro CPGOS03-0490 v2.0 workaround")
Co-developed-by: Russell King <rmk+kernel@armlinux.org.uk>
Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
Signed-off-by: Pali Rohár <pali@kernel.org>

---
Changes in v4:
* Rewritten the commit message by Marek's suggestion

Changes in v3:
* Do not break longer info messages
* Do not read memory after the end of buffer in sfp_id_needs_byte_io()
* Add comments for default i2c_block_size and Nokia 3FE46541AA module

Changes in v2:
* Add explanation why also for second address is used one byte read op
* Skip hwmon registration when eeprom does not support atomic 16bit read op
---
 drivers/net/phy/sfp.c | 100 ++++++++++++++++++++++++++++--------------
 1 file changed, 67 insertions(+), 33 deletions(-)

diff --git a/drivers/net/phy/sfp.c b/drivers/net/phy/sfp.c
index 91d74c1a920a..f2b5e467a800 100644
--- a/drivers/net/phy/sfp.c
+++ b/drivers/net/phy/sfp.c
@@ -336,19 +336,11 @@ static int sfp_i2c_read(struct sfp *sfp, bool a2, u8 dev_addr, void *buf,
 			size_t len)
 {
 	struct i2c_msg msgs[2];
-	size_t block_size;
+	u8 bus_addr = a2 ? 0x51 : 0x50;
+	size_t block_size = sfp->i2c_block_size;
 	size_t this_len;
-	u8 bus_addr;
 	int ret;
 
-	if (a2) {
-		block_size = 16;
-		bus_addr = 0x51;
-	} else {
-		block_size = sfp->i2c_block_size;
-		bus_addr = 0x50;
-	}
-
 	msgs[0].addr = bus_addr;
 	msgs[0].flags = 0;
 	msgs[0].len = 1;
@@ -1282,6 +1274,20 @@ static void sfp_hwmon_probe(struct work_struct *work)
 	struct sfp *sfp = container_of(work, struct sfp, hwmon_probe.work);
 	int err, i;
 
+	/* hwmon interface needs to access 16bit registers in atomic way to
+	 * guarantee coherency of the diagnostic monitoring data. If it is not
+	 * possible to guarantee coherency because EEPROM is broken in such way
+	 * that does not support atomic 16bit read operation then we have to
+	 * skip registration of hwmon device.
+	 */
+	if (sfp->i2c_block_size < 2) {
+		dev_info(sfp->dev,
+			 "skipping hwmon device registration due to broken EEPROM\n");
+		dev_info(sfp->dev,
+			 "diagnostic EEPROM area cannot be read atomically to guarantee data coherency\n");
+		return;
+	}
+
 	err = sfp_read(sfp, true, 0, &sfp->diag, sizeof(sfp->diag));
 	if (err < 0) {
 		if (sfp->hwmon_tries--) {
@@ -1642,26 +1648,30 @@ static int sfp_sm_mod_hpower(struct sfp *sfp, bool enable)
 	return 0;
 }
 
-/* Some modules (Nokia 3FE46541AA) lock up if byte 0x51 is read as a
- * single read. Switch back to reading 16 byte blocks unless we have
- * a CarlitoxxPro module (rebranded VSOL V2801F). Even more annoyingly,
- * some VSOL V2801F have the vendor name changed to OEM.
+/* GPON modules based on Realtek RTL8672 and RTL9601C chips (e.g. V-SOL
+ * V2801F, CarlitoxxPro CPGOS03-0490, Ubiquiti U-Fiber Instant, ...) do
+ * not support multibyte reads from the EEPROM. Each multi-byte read
+ * operation returns just one byte of EEPROM followed by zeros. There is
+ * no way to identify which modules are using Realtek RTL8672 and RTL9601C
+ * chips. Moreover every OEM of V-SOL V2801F module puts its own vendor
+ * name and vendor id into EEPROM, so there is even no way to detect if
+ * module is V-SOL V2801F. Therefore check for those zeros in the read
+ * data and then based on check switch to reading EEPROM to one byte
+ * at a time.
  */
-static int sfp_quirk_i2c_block_size(const struct sfp_eeprom_base *base)
+static bool sfp_id_needs_byte_io(struct sfp *sfp, void *buf, size_t len)
 {
-	if (!memcmp(base->vendor_name, "VSOL            ", 16))
-		return 1;
-	if (!memcmp(base->vendor_name, "OEM             ", 16) &&
-	    !memcmp(base->vendor_pn,   "V2801F          ", 16))
-		return 1;
+	size_t i, block_size = sfp->i2c_block_size;
 
-	/* Some modules can't cope with long reads */
-	return 16;
-}
+	/* Already using byte IO */
+	if (block_size == 1)
+		return false;
 
-static void sfp_quirks_base(struct sfp *sfp, const struct sfp_eeprom_base *base)
-{
-	sfp->i2c_block_size = sfp_quirk_i2c_block_size(base);
+	for (i = 1; i < len; i += block_size) {
+		if (memchr_inv(buf + i, '\0', min(block_size - 1, len - i)))
+			return false;
+	}
+	return true;
 }
 
 static int sfp_cotsworks_fixup_check(struct sfp *sfp, struct sfp_eeprom_id *id)
@@ -1705,11 +1715,11 @@ static int sfp_sm_mod_probe(struct sfp *sfp, bool report)
 	u8 check;
 	int ret;
 
-	/* Some modules (CarlitoxxPro CPGOS03-0490) do not support multibyte
-	 * reads from the EEPROM, so start by reading the base identifying
-	 * information one byte at a time.
+	/* Some SFP modules and also some Linux I2C drivers do not like reads
+	 * longer than 16 bytes, so read the EEPROM in chunks of 16 bytes at
+	 * a time.
 	 */
-	sfp->i2c_block_size = 1;
+	sfp->i2c_block_size = 16;
 
 	ret = sfp_read(sfp, false, 0, &id.base, sizeof(id.base));
 	if (ret < 0) {
@@ -1723,6 +1733,33 @@ static int sfp_sm_mod_probe(struct sfp *sfp, bool report)
 		return -EAGAIN;
 	}
 
+	/* Some SFP modules (e.g. Nokia 3FE46541AA) lock up if read from
+	 * address 0x51 is just one byte at a time. Also SFF-8472 requires
+	 * that EEPROM supports atomic 16bit read operation for diagnostic
+	 * fields, so do not switch to one byte reading at a time unless it
+	 * is really required and we have no other option.
+	 */
+	if (sfp_id_needs_byte_io(sfp, &id.base, sizeof(id.base))) {
+		dev_info(sfp->dev,
+			 "Detected broken RTL8672/RTL9601C emulated EEPROM\n");
+		dev_info(sfp->dev,
+			 "Switching to reading EEPROM to one byte at a time\n");
+		sfp->i2c_block_size = 1;
+
+		ret = sfp_read(sfp, false, 0, &id.base, sizeof(id.base));
+		if (ret < 0) {
+			if (report)
+				dev_err(sfp->dev, "failed to read EEPROM: %d\n",
+					ret);
+			return -EAGAIN;
+		}
+
+		if (ret != sizeof(id.base)) {
+			dev_err(sfp->dev, "EEPROM short read: %d\n", ret);
+			return -EAGAIN;
+		}
+	}
+
 	/* Cotsworks do not seem to update the checksums when they
 	 * do the final programming with the final module part number,
 	 * serial number and date code.
@@ -1757,9 +1794,6 @@ static int sfp_sm_mod_probe(struct sfp *sfp, bool report)
 		}
 	}
 
-	/* Apply any early module-specific quirks */
-	sfp_quirks_base(sfp, &id.base);
-
 	ret = sfp_read(sfp, false, SFP_CC_BASE + 1, &id.ext, sizeof(id.ext));
 	if (ret < 0) {
 		if (report)
-- 
2.20.1

