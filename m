Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 172EA2EC083
	for <lists+netdev@lfdr.de>; Wed,  6 Jan 2021 16:39:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727116AbhAFPjP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Jan 2021 10:39:15 -0500
Received: from mail.kernel.org ([198.145.29.99]:41864 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726165AbhAFPjO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 6 Jan 2021 10:39:14 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 06F312311F;
        Wed,  6 Jan 2021 15:38:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1609947513;
        bh=tTXW9P3rcKP3VUEBm73HnImvJlwOVAEbYmMaU0CJwM8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nYiWf9hLUw3cYUKl3VMsgTKtqRs9rn3/ARWoSYcyzCnOKEMaxwJSe4jaKRZMXxB+P
         0WsMv04t5OWX8y4O0E3/eLg2hfu89EM4ubafoDoiRTZQh1zwkmzTyscA35UN2ECaBw
         IRoDSoZlIrsTxUbNCN7atm3ydIfLGvf70zcoIILqBI49IK6HEwlXr1WgtcD5+5mPIW
         wqdPCEnzN/ZL1bdnisShiwC16Q2UU0Elq3snHsrR+SzLbi2OZYpda98+rKVBQ5mzfC
         5qX2yAMjjMNdQALY06TMmKnpdkLVjfS1FEKMZfOB1nHqlUCVecTiYWDWW+qoaauMh/
         SaFa4eEpfMVkA==
Received: by pali.im (Postfix)
        id 3317F44E; Wed,  6 Jan 2021 16:38:31 +0100 (CET)
From:   =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>
To:     Russell King - ARM Linux admin <linux@armlinux.org.uk>,
        Andrew Lunn <andrew@lunn.ch>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Thomas Schreiber <tschreibe@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2 1/3] net: sfp: add workaround for Realtek RTL8672 and RTL9601C chips
Date:   Wed,  6 Jan 2021 16:37:47 +0100
Message-Id: <20210106153749.6748-2-pali@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20210106153749.6748-1-pali@kernel.org>
References: <20201230154755.14746-1-pali@kernel.org>
 <20210106153749.6748-1-pali@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Workaround for GPON SFP modules based on VSOL V2801F brand was added in
commit 0d035bed2a4a ("net: sfp: VSOL V2801F / CarlitoxxPro CPGOS03-0490
v2.0 workaround"). But it works only for ids explicitly added to the list.
As there are more rebraded VSOL V2801F modules and OEM vendors are putting
into vendor name random strings we cannot build workaround based on ids.

Moreover issue which that commit tried to workaround is generic not only to
VSOL based modules, but rather to all GPON modules based on Realtek RTL8672
and RTL9601C chips.

They can be found for example in following GPON modules:
* V-SOL V2801F
* C-Data FD511GX-RM0
* OPTON GP801R
* BAUDCOM BD-1234-SFM
* CPGOS03-0490 v2.0
* Ubiquiti U-Fiber Instant
* EXOT EGS1

Those Realtek chips have broken EEPROM emulator which for N-byte read
operation returns just one byte of EEPROM data followed by N-1 zeros.

So introduce a new function sfp_id_needs_byte_io() which detects SFP
modules with these Realtek chips which have broken EEPROM emulator based on
N-1 zeros and switch to 1 byte EEPROM reading operation which workaround
this issue.

Function sfp_i2c_read() now always use single byte reading when it is
required and when function sfp_hwmon_probe() detects single byte access
then it disable registration of hwmon device. As in this case we cannot
reliable and atomically read 2 bytes as it is required for retrieving some
values from diagnostic area.

These Realtek chips are broken in a way that violate SFP standards for
diagnostic interface. Kernel in this case cannot do anything, only skipping
registration of hwmon interface.

This patch fixes reading of EEPROM content from SFP modules based on
Realtek RTL8672 and RTL9601C chips. Diagnostic interface of EEPROM stay
broken and cannot be fixed.

Fixes: 0d035bed2a4a ("net: sfp: VSOL V2801F / CarlitoxxPro CPGOS03-0490 v2.0 workaround")
Co-developed-by: Russell King <rmk+kernel@armlinux.org.uk>
Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
Signed-off-by: Pali Rohár <pali@kernel.org>

---
Changes in v2:
* Add explanation why also for second address is used one byte read op
* Skip hwmon registration when eeprom does not support atomic 16bit read op
---
 drivers/net/phy/sfp.c | 92 +++++++++++++++++++++++++++----------------
 1 file changed, 58 insertions(+), 34 deletions(-)

diff --git a/drivers/net/phy/sfp.c b/drivers/net/phy/sfp.c
index 91d74c1a920a..c0a891cdcd73 100644
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
+		dev_info(sfp->dev, "skipping hwmon device registration "
+				   "due to broken EEPROM\n");
+		dev_info(sfp->dev, "diagnostic EEPROM area cannot be read "
+				   "atomically to guarantee data coherency\n");
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
+		if (memchr_inv(buf + i, '\0', block_size - 1))
+			return false;
+	}
+	return true;
 }
 
 static int sfp_cotsworks_fixup_check(struct sfp *sfp, struct sfp_eeprom_id *id)
@@ -1705,11 +1715,7 @@ static int sfp_sm_mod_probe(struct sfp *sfp, bool report)
 	u8 check;
 	int ret;
 
-	/* Some modules (CarlitoxxPro CPGOS03-0490) do not support multibyte
-	 * reads from the EEPROM, so start by reading the base identifying
-	 * information one byte at a time.
-	 */
-	sfp->i2c_block_size = 1;
+	sfp->i2c_block_size = 16;
 
 	ret = sfp_read(sfp, false, 0, &id.base, sizeof(id.base));
 	if (ret < 0) {
@@ -1723,6 +1729,27 @@ static int sfp_sm_mod_probe(struct sfp *sfp, bool report)
 		return -EAGAIN;
 	}
 
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
@@ -1757,9 +1784,6 @@ static int sfp_sm_mod_probe(struct sfp *sfp, bool report)
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

