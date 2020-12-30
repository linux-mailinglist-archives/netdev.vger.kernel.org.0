Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B6B732E7AA6
	for <lists+netdev@lfdr.de>; Wed, 30 Dec 2020 16:49:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726662AbgL3PtB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Dec 2020 10:49:01 -0500
Received: from mail.kernel.org ([198.145.29.99]:46658 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726230AbgL3PtA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 30 Dec 2020 10:49:00 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5E13E221F8;
        Wed, 30 Dec 2020 15:48:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1609343299;
        bh=2RIclngu6AIneWlw5MfU5187I27yfRJRGgk2OOJIbsQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NGrs9Aie3e9CKBhqII1iEsp1j/6AYVzPjRZfXt0EgCCE9IVaPf8pe5/Sfj/qt3KlU
         ZVfZVcfBccZayp+AcfnLEk6MaWwbebkisab+UckGUQFFsJDB464alGW4dF02TZgLXF
         O+9xSQ+VuSm+a8o+ydZyAPXyNW0vxAn2GeAYWcHChjRdaeR/pjZzKoxKhuz8DhUXRW
         zjpUUpiuP2Berp6vC50WPBZrUKnnx6jRBDXyyY91+pq8wGn5OtY46Hb1QQKC3eOtJZ
         z3EfRk383A69nwu+CDyXfWAce3ojL0AKMecG3SO6zlrfjvXUWBn22Wbe1rE1T2i3XN
         78WN7IfRiJmsg==
Received: by pali.im (Postfix)
        id BAC009F8; Wed, 30 Dec 2020 16:48:17 +0100 (CET)
From:   =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>
To:     Russell King <linux@armlinux.org.uk>, Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 1/4] net: sfp: add workaround for Realtek RTL8672 and RTL9601C chips
Date:   Wed, 30 Dec 2020 16:47:52 +0100
Message-Id: <20201230154755.14746-2-pali@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20201230154755.14746-1-pali@kernel.org>
References: <20201230154755.14746-1-pali@kernel.org>
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

This patch fixes reading EEPROM content from SFP modules based on Realtek
RTL8672 and RTL9601C chips.

Fixes: 0d035bed2a4a ("net: sfp: VSOL V2801F / CarlitoxxPro CPGOS03-0490 v2.0 workaround")
Co-developed-by: Russell King <rmk+kernel@armlinux.org.uk>
Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
Signed-off-by: Pali Rohár <pali@kernel.org>
---
 drivers/net/phy/sfp.c | 78 ++++++++++++++++++++++++-------------------
 1 file changed, 44 insertions(+), 34 deletions(-)

diff --git a/drivers/net/phy/sfp.c b/drivers/net/phy/sfp.c
index 91d74c1a920a..490e78a72dd6 100644
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
@@ -1642,26 +1634,30 @@ static int sfp_sm_mod_hpower(struct sfp *sfp, bool enable)
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
@@ -1705,11 +1701,7 @@ static int sfp_sm_mod_probe(struct sfp *sfp, bool report)
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
@@ -1723,6 +1715,27 @@ static int sfp_sm_mod_probe(struct sfp *sfp, bool report)
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
@@ -1757,9 +1770,6 @@ static int sfp_sm_mod_probe(struct sfp *sfp, bool report)
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

