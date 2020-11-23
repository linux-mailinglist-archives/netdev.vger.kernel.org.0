Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D2D072C1808
	for <lists+netdev@lfdr.de>; Mon, 23 Nov 2020 22:59:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732207AbgKWVxW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Nov 2020 16:53:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58532 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731457AbgKWVxV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Nov 2020 16:53:21 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B1FABC0613CF
        for <netdev@vger.kernel.org>; Mon, 23 Nov 2020 13:53:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Date:Sender:Message-Id:Content-Type:
        Content-Transfer-Encoding:MIME-Version:Subject:Cc:To:From:Reply-To:Content-ID
        :Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:
        Resent-Cc:Resent-Message-ID:In-Reply-To:References:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=QCDjaww1fu8gKe/zfQYZP3kGx+QYtVWj/YwKriJyTFE=; b=ADcCL/Esi90uv3efczJNlVt9Bz
        ExnM7Rbppg4HqwPwmwePppzKhnTaAV9fehCeLh5CzH20PYVuPcoxrMKLZ/TKyUF/4THf1K9fmO4ck
        OUDMRGSbaj4eVveTyW9CxcT1d356TXfbKSSxCldrj2erGPZzJSeT3uT1dLVTfZZQBxSn6FGagJILA
        x21iNWv/Ymx04majeO0aIIiXv8g7FIZ+MHQJ0E67TH7cNthY5tCiaDKlBLzweL7db209UcliVZ/d7
        dkDUlE4Fbnk8Vt0vyr+z6mcY+5QniW2KsXmfCHtpCnED2QtqUS5fKGChhSlTt0NohalNZE0Epb91T
        8L5BOXsg==;
Received: from e0022681537dd.dyn.armlinux.org.uk ([fd8f:7570:feb6:1:222:68ff:fe15:37dd]:43622 helo=rmk-PC.armlinux.org.uk)
        by pandora.armlinux.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1khJlv-0006ih-Ma; Mon, 23 Nov 2020 21:53:19 +0000
Received: from rmk by rmk-PC.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1khJlv-0003Jq-ET; Mon, 23 Nov 2020 21:53:19 +0000
From:   Russell King <rmk+kernel@armlinux.org.uk>
To:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next] net: sfp: VSOL V2801F / CarlitoxxPro CPGOS03-0490
 v2.0 workaround
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <E1khJlv-0003Jq-ET@rmk-PC.armlinux.org.uk>
Sender: "Russell King,,," <rmk@armlinux.org.uk>
Date:   Mon, 23 Nov 2020 21:53:19 +0000
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add a workaround for the VSOL V2801F / CarlitoxxPro CPGOS03-0490 v2.0
GPON module which the manufacturer states needs single byte I2C reads
to the EEPROM.

Reported-by: Thomas Schreiber <tschreibe@gmail.com>
Tested-by: Thomas Schreiber <tschreibe@gmail.com>
Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
---
 drivers/net/phy/sfp.c | 45 ++++++++++++++++++++++++++++++++++++++-----
 1 file changed, 40 insertions(+), 5 deletions(-)

diff --git a/drivers/net/phy/sfp.c b/drivers/net/phy/sfp.c
index debf91412a72..1e347afa951e 100644
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
+		if (this_len > sfp->i2c_block_size)
+			this_len = sfp->i2c_block_size;
 
 		msgs[1].len = this_len;
 
@@ -1673,14 +1683,20 @@ static int sfp_sm_mod_probe(struct sfp *sfp, bool report)
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
@@ -1719,6 +1735,25 @@ static int sfp_sm_mod_probe(struct sfp *sfp, bool report)
 		}
 	}
 
+	/* Some modules (Nokia 3FE46541AA) lock up if byte 0x51 is read as a
+	 * single read. Switch back to reading 16 byte blocks unless we have
+	 * a CarlitoxxPro module (rebranded VSOL V2801F).
+	 */
+	if (memcmp(id.base.vendor_name, "VSOL            ", 16))
+		sfp->i2c_block_size = 16;
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

