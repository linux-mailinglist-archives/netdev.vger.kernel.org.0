Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 246EB412AC4
	for <lists+netdev@lfdr.de>; Tue, 21 Sep 2021 03:56:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238621AbhIUB6A (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Sep 2021 21:58:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33352 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236284AbhIUBuB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Sep 2021 21:50:01 -0400
Received: from mail-pf1-x42b.google.com (mail-pf1-x42b.google.com [IPv6:2607:f8b0:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 03895C06AB02;
        Mon, 20 Sep 2021 14:54:27 -0700 (PDT)
Received: by mail-pf1-x42b.google.com with SMTP id c1so14596374pfp.10;
        Mon, 20 Sep 2021 14:54:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=6TMCz/8qfUOEgicgpBPK3RdO5hHecgbWReCsG7+anNY=;
        b=UNQEmIs1Aa91/moZj2DcUghmgKwBVBW42H8SeEnBmQC/pc2uOhPdfrEKtNZy5PpzXj
         xDy702hyWuaCgC7kbJ3yz2bxDAdb101DFIBNnyG3iV0r5iYbgX8gXIKq173QoKAmxF4W
         ME5ThgcbbZK10IDBn6nlHY3qGxMTTemKweq6nl5KhaB4bzRaikUf1ErR+m9wmpO16PpD
         +OzJtNlrSWJaHTO9xgODNzgYu+N0SMAqp/1fsdxrWI3rs2s3SeZL3Ua0bwRpwI/7yiFe
         LNrf9EeGiru+g6JGa6ce9UkJ+W8dlSrfeO3e6X7Od+1LIbF7weMaCm2Kr7dGq+eysmdK
         vsBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=6TMCz/8qfUOEgicgpBPK3RdO5hHecgbWReCsG7+anNY=;
        b=AMAc8VksIqNOgHI9PXuigR/CIJo7Pr2n8lRJteYsUqiF3pT6gqexwCaIUFyIFlVhWn
         3XfXd3ryE6wAkeievz3jRI71srk/ecPw2SI5AiDk6ZyQCtx1sydCb1J+bfMtFCXRUVzp
         Zm+fx7+/AK1bu/G5LaHiNNVgIFmrgvOCuO9I/Z6mAUpX5nfYJeKKG6R0vnzmAh9IU68u
         QPJIr/tqeUJ+4GjX59pU/q99pILg5yElFU1klVa0RcogZ9MFoW8148Yt/tXu4IE1VnBx
         vKaNWBVlbIV90joR5NWTpd4LdbrQdpTAcAsN1eCvBqAwVUSzEJYO2GbuMG/fzcRvebzg
         Ds3A==
X-Gm-Message-State: AOAM5301mIQHsQRMQDWyGzA7oybBkCF+pbZqnPpL/gPpb72kHGrM4N0P
        XwjzbmCSNrDHehBpKgwsbepqYh6jwVY=
X-Google-Smtp-Source: ABdhPJwKDeZi9C4lhsdHRJH5HdwNzyyPOIXxAt1BMDAsk8CBzk51gI5tL5AUiiC6Ez0NFFtb+J3EXQ==
X-Received: by 2002:a63:8ac4:: with SMTP id y187mr347862pgd.383.1632174866181;
        Mon, 20 Sep 2021 14:54:26 -0700 (PDT)
Received: from fainelli-desktop.igp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id m28sm16224297pgl.9.2021.09.20.14.54.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Sep 2021 14:54:25 -0700 (PDT)
From:   Florian Fainelli <f.fainelli@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH net-next 1/5] net: phy: broadcom: Add IDDQ-SR mode
Date:   Mon, 20 Sep 2021 14:54:14 -0700
Message-Id: <20210920215418.3247054-2-f.fainelli@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210920215418.3247054-1-f.fainelli@gmail.com>
References: <20210920215418.3247054-1-f.fainelli@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add support for putting the PHY into IDDQ Soft Recovery mode by setting
the TOP_MISC register bits accordingly. This requires us to implement a
custom bcm54xx_suspend() routine which diverges from genphy_suspend() in
order to configure the PHY to enter IDDQ with software recovery as well
as avoid doing a read/modify/write on the BMCR register.

Doing a read/modify/write on the BMCR register means that the
auto-negotation bit may remain which interferes with the ability to put
the PHY into IDDQ-SR mode. We do software reset upon suspend in order to
put the PHY back into its state prior to suspend as recommended by the
datasheet.

Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
---
 drivers/net/phy/broadcom.c | 51 ++++++++++++++++++++++++++++++++++++++
 include/linux/brcmphy.h    |  8 ++++++
 2 files changed, 59 insertions(+)

diff --git a/drivers/net/phy/broadcom.c b/drivers/net/phy/broadcom.c
index add0c4e33425..f5868a0dee4b 100644
--- a/drivers/net/phy/broadcom.c
+++ b/drivers/net/phy/broadcom.c
@@ -392,10 +392,50 @@ static int bcm54xx_config_init(struct phy_device *phydev)
 	return 0;
 }
 
+static int bcm54xx_iddq_set(struct phy_device *phydev, bool enable)
+{
+	int ret = 0;
+
+	if (!(phydev->dev_flags & PHY_BRCM_IDDQ_SUSPEND))
+		return ret;
+
+	ret = bcm_phy_read_exp(phydev, BCM54XX_TOP_MISC_IDDQ_CTRL);
+	if (ret < 0)
+		goto out;
+
+	if (enable)
+		ret |= BCM54XX_TOP_MISC_IDDQ_SR | BCM54XX_TOP_MISC_IDDQ_LP;
+	else
+		ret &= ~(BCM54XX_TOP_MISC_IDDQ_SR | BCM54XX_TOP_MISC_IDDQ_LP);
+
+	ret = bcm_phy_write_exp(phydev, BCM54XX_TOP_MISC_IDDQ_CTRL, ret);
+out:
+	return ret;
+}
+
+static int bcm54xx_suspend(struct phy_device *phydev)
+{
+	int ret;
+
+	/* We cannot use a read/modify/write here otherwise the PHY gets into
+	 * a bad state where its LEDs keep flashing, thus defeating the purpose
+	 * of low power mode.
+	 */
+	ret = phy_write(phydev, MII_BMCR, BMCR_PDOWN);
+	if (ret < 0)
+		return ret;
+
+	return bcm54xx_iddq_set(phydev, true);
+}
+
 static int bcm54xx_resume(struct phy_device *phydev)
 {
 	int ret;
 
+	ret = bcm54xx_iddq_set(phydev, false);
+	if (ret < 0)
+		return ret;
+
 	/* Writes to register other than BMCR would be ignored
 	 * unless we clear the PDOWN bit first
 	 */
@@ -408,6 +448,15 @@ static int bcm54xx_resume(struct phy_device *phydev)
 	 */
 	fsleep(40);
 
+	/* Issue a soft reset after clearing the power down bit
+	 * and before doing any other configuration.
+	 */
+	if (phydev->dev_flags & PHY_BRCM_IDDQ_SUSPEND) {
+		ret = genphy_soft_reset(phydev);
+		if (ret < 0)
+			return ret;
+	}
+
 	return bcm54xx_config_init(phydev);
 }
 
@@ -772,6 +821,8 @@ static struct phy_driver broadcom_drivers[] = {
 	.config_intr	= bcm_phy_config_intr,
 	.handle_interrupt = bcm_phy_handle_interrupt,
 	.link_change_notify	= bcm54xx_link_change_notify,
+	.suspend	= bcm54xx_suspend,
+	.resume		= bcm54xx_resume,
 }, {
 	.phy_id		= PHY_ID_BCM5461,
 	.phy_id_mask	= 0xfffffff0,
diff --git a/include/linux/brcmphy.h b/include/linux/brcmphy.h
index 07e1dfadbbdf..b119d6819d6c 100644
--- a/include/linux/brcmphy.h
+++ b/include/linux/brcmphy.h
@@ -67,6 +67,7 @@
 #define PHY_BRCM_CLEAR_RGMII_MODE	0x00000004
 #define PHY_BRCM_DIS_TXCRXC_NOENRGY	0x00000008
 #define PHY_BRCM_EN_MASTER_MODE		0x00000010
+#define PHY_BRCM_IDDQ_SUSPEND		0x000000220
 
 /* Broadcom BCM7xxx specific workarounds */
 #define PHY_BRCM_7XXX_REV(x)		(((x) >> 8) & 0xff)
@@ -84,6 +85,7 @@
 
 #define MII_BCM54XX_EXP_DATA	0x15	/* Expansion register data */
 #define MII_BCM54XX_EXP_SEL	0x17	/* Expansion register select */
+#define MII_BCM54XX_EXP_SEL_TOP	0x0d00	/* TOP_MISC expansion register select */
 #define MII_BCM54XX_EXP_SEL_SSD	0x0e00	/* Secondary SerDes select */
 #define MII_BCM54XX_EXP_SEL_ER	0x0f00	/* Expansion register select */
 #define MII_BCM54XX_EXP_SEL_ETC	0x0d00	/* Expansion register spare + 2k mem */
@@ -243,6 +245,12 @@
 #define MII_BCM54XX_EXP_EXP97			0x0f97
 #define  MII_BCM54XX_EXP_EXP97_MYST		0x0c0c
 
+/* Top-MISC expansion registers */
+#define BCM54XX_TOP_MISC_IDDQ_CTRL		(MII_BCM54XX_EXP_SEL_TOP + 0x06)
+#define BCM54XX_TOP_MISC_IDDQ_LP		(1 << 0)
+#define BCM54XX_TOP_MISC_IDDQ_SD		(1 << 2)
+#define BCM54XX_TOP_MISC_IDDQ_SR		(1 << 3)
+
 /*
  * BCM5482: Secondary SerDes registers
  */
-- 
2.25.1

