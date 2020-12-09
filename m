Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 64EA52D4105
	for <lists+netdev@lfdr.de>; Wed,  9 Dec 2020 12:25:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730636AbgLILXq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Dec 2020 06:23:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35944 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730632AbgLILXq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Dec 2020 06:23:46 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D6B35C0613CF
        for <netdev@vger.kernel.org>; Wed,  9 Dec 2020 03:22:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Date:Sender:Message-Id:Content-Type:
        Content-Transfer-Encoding:MIME-Version:Subject:Cc:To:From:References:
        In-Reply-To:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=+B4cFN3FlgVMFy6Czw8DG/Up4/75wVsdNfIhC7oCzks=; b=wH/dvjK4948iKw6lGGlQ/+ul2k
        hEl2zbX3ggFAqIvmGp7pq7tCCo02L1hnT1PTv9ljc7F7SAfbhtKm98JVPX4yukRj7/mYr5RSpOHh0
        uBc2FJCFMo6Xaj/aFR29kamXZ/MezgamQkmt7K3WglxjdZu28eFLLlcfLmkvNffRa5K3SVVvTKDq0
        nYvIG/MaoQy8pCQ3cShmgWYep0jFDybqoXUecTJEttCAHVz83DWTR8FXnm72yoSO4XsFcgijs44Uv
        VrQkKknd1Ws5Ioc+Qpjh/+5LrhjKnVsNQXykaKJ0Baxb2ZnzfNm4zk3KtRYC1ezG5qCANJNXisbz/
        1r7osCiw==;
Received: from e0022681537dd.dyn.armlinux.org.uk ([fd8f:7570:feb6:1:222:68ff:fe15:37dd]:52476 helo=rmk-PC.armlinux.org.uk)
        by pandora.armlinux.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1kmxYX-0002JP-Fs; Wed, 09 Dec 2020 11:22:49 +0000
Received: from rmk by rmk-PC.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1kmxYX-0001cP-6b; Wed, 09 Dec 2020 11:22:49 +0000
In-Reply-To: <20201209112152.GT1551@shell.armlinux.org.uk>
References: <20201209112152.GT1551@shell.armlinux.org.uk>
From:   Russell King <rmk+kernel@armlinux.org.uk>
To:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>
Cc:     Pali Rohar <pali@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH net-next 1/2] net: sfp: VSOL V2801F / CarlitoxxPro
 CPGOS03-0490 v2.0 workaround
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <E1kmxYX-0001cP-6b@rmk-PC.armlinux.org.uk>
Sender: "Russell King,,," <rmk@armlinux.org.uk>
Date:   Wed, 09 Dec 2020 11:22:49 +0000
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add a workaround for the detection of VSOL V2801F / CarlitoxxPro
CPGOS03-0490 v2.0 GPON module which CarlitoxxPro states needs single
byte I2C reads to the EEPROM.

Pali Rohár reports that he also has a CarlitoxxPro-based V2801F module,
which reports a manufacturer of "OEM". This manufacturer can't be
matched as it appears in many different modules, so also match the part
number too.

Reported-by: Thomas Schreiber <tschreibe@gmail.com>
Reported-by: Pali Rohár <pali@kernel.org>
Tested-by: Pali Rohár <pali@kernel.org>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
---
 drivers/net/phy/sfp.c | 63 +++++++++++++++++++++++++++++++++++++++----
 1 file changed, 58 insertions(+), 5 deletions(-)

diff --git a/drivers/net/phy/sfp.c b/drivers/net/phy/sfp.c
index 34aa196b7465..91d74c1a920a 100644
--- a/drivers/net/phy/sfp.c
+++ b/drivers/net/phy/sfp.c
@@ -219,6 +219,7 @@ struct sfp {
 	struct sfp_bus *sfp_bus;
 	struct phy_device *mod_phy;
 	const struct sff_data *type;
+	size_t i2c_block_size;
 	u32 max_power_mW;
 
 	unsigned int (*get_state)(struct sfp *);
@@ -335,10 +336,19 @@ static int sfp_i2c_read(struct sfp *sfp, bool a2, u8 dev_addr, void *buf,
 			size_t len)
 {
 	struct i2c_msg msgs[2];
-	u8 bus_addr = a2 ? 0x51 : 0x50;
+	size_t block_size;
 	size_t this_len;
+	u8 bus_addr;
 	int ret;
 
+	if (a2) {
+		block_size = 16;
+		bus_addr = 0x51;
+	} else {
+		block_size = sfp->i2c_block_size;
+		bus_addr = 0x50;
+	}
+
 	msgs[0].addr = bus_addr;
 	msgs[0].flags = 0;
 	msgs[0].len = 1;
@@ -350,8 +360,8 @@ static int sfp_i2c_read(struct sfp *sfp, bool a2, u8 dev_addr, void *buf,
 
 	while (len) {
 		this_len = len;
-		if (this_len > 16)
-			this_len = 16;
+		if (this_len > block_size)
+			this_len = block_size;
 
 		msgs[1].len = this_len;
 
@@ -1632,6 +1642,28 @@ static int sfp_sm_mod_hpower(struct sfp *sfp, bool enable)
 	return 0;
 }
 
+/* Some modules (Nokia 3FE46541AA) lock up if byte 0x51 is read as a
+ * single read. Switch back to reading 16 byte blocks unless we have
+ * a CarlitoxxPro module (rebranded VSOL V2801F). Even more annoyingly,
+ * some VSOL V2801F have the vendor name changed to OEM.
+ */
+static int sfp_quirk_i2c_block_size(const struct sfp_eeprom_base *base)
+{
+	if (!memcmp(base->vendor_name, "VSOL            ", 16))
+		return 1;
+	if (!memcmp(base->vendor_name, "OEM             ", 16) &&
+	    !memcmp(base->vendor_pn,   "V2801F          ", 16))
+		return 1;
+
+	/* Some modules can't cope with long reads */
+	return 16;
+}
+
+static void sfp_quirks_base(struct sfp *sfp, const struct sfp_eeprom_base *base)
+{
+	sfp->i2c_block_size = sfp_quirk_i2c_block_size(base);
+}
+
 static int sfp_cotsworks_fixup_check(struct sfp *sfp, struct sfp_eeprom_id *id)
 {
 	u8 check;
@@ -1673,14 +1705,20 @@ static int sfp_sm_mod_probe(struct sfp *sfp, bool report)
 	u8 check;
 	int ret;
 
-	ret = sfp_read(sfp, false, 0, &id, sizeof(id));
+	/* Some modules (CarlitoxxPro CPGOS03-0490) do not support multibyte
+	 * reads from the EEPROM, so start by reading the base identifying
+	 * information one byte at a time.
+	 */
+	sfp->i2c_block_size = 1;
+
+	ret = sfp_read(sfp, false, 0, &id.base, sizeof(id.base));
 	if (ret < 0) {
 		if (report)
 			dev_err(sfp->dev, "failed to read EEPROM: %d\n", ret);
 		return -EAGAIN;
 	}
 
-	if (ret != sizeof(id)) {
+	if (ret != sizeof(id.base)) {
 		dev_err(sfp->dev, "EEPROM short read: %d\n", ret);
 		return -EAGAIN;
 	}
@@ -1719,6 +1757,21 @@ static int sfp_sm_mod_probe(struct sfp *sfp, bool report)
 		}
 	}
 
+	/* Apply any early module-specific quirks */
+	sfp_quirks_base(sfp, &id.base);
+
+	ret = sfp_read(sfp, false, SFP_CC_BASE + 1, &id.ext, sizeof(id.ext));
+	if (ret < 0) {
+		if (report)
+			dev_err(sfp->dev, "failed to read EEPROM: %d\n", ret);
+		return -EAGAIN;
+	}
+
+	if (ret != sizeof(id.ext)) {
+		dev_err(sfp->dev, "EEPROM short read: %d\n", ret);
+		return -EAGAIN;
+	}
+
 	check = sfp_check(&id.ext, sizeof(id.ext) - 1);
 	if (check != id.ext.cc_ext) {
 		if (cotsworks) {
-- 
2.20.1

