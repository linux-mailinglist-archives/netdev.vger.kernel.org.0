Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D7BAD12BB58
	for <lists+netdev@lfdr.de>; Fri, 27 Dec 2019 22:37:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726812AbfL0VhM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Dec 2019 16:37:12 -0500
Received: from mail-wm1-f66.google.com ([209.85.128.66]:39041 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726509AbfL0Vg6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Dec 2019 16:36:58 -0500
Received: by mail-wm1-f66.google.com with SMTP id 20so9299370wmj.4
        for <netdev@vger.kernel.org>; Fri, 27 Dec 2019 13:36:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=7V5fBkcvHjU8SacvQbqTer+Jpx5oyXeJlKJjN0LLnos=;
        b=rfDOBMQQ4BoFHPI0zQvR1Hms0QkpBbCKBI+F/5uUziflwr3T1HEFjTVzeML0g4KcDz
         HpuURUTdITnQ1+Zr+6AU/fQ98dWAbPOVrTzaK5tzrNeOvNYyy8VvDJRMTVWgkiWgitjC
         nNXQl1B7/NouY7wecqjCqhXLGXO46PBezFIWslqkE6fU8UJtUZF7uoaLUViyyEl+tPDv
         5WHdQbmG/yjfjUuUQtqT51kQUNmdqu/ew5X6vblrf5QpJGG9EX+OmwGnqhQILInqAgjo
         zrR3r5wsPPmv3uGV1EY8c+pJwf9UX5xYXmL4LZ0gvap0Rzxy8ixHVWPy1m9JcG/uBx59
         lk8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=7V5fBkcvHjU8SacvQbqTer+Jpx5oyXeJlKJjN0LLnos=;
        b=t5FsFGAwAMlJd+BYY3QoLWiskITjUVmmDGRhL4nOBuoKYu1UC26F5/CwOPYlp4OiU1
         fhpUzgMgAEN5rX7AevqU9z6L51qj+lDEDPkfG1jcgCGx68kFSe+qN7MTFxupxJOSWQ0k
         z3Dw3PIZgPOTFzF5sfAlcJICswJ/IAZ89D6OQadrhO/rsAq12gtf01AV4d4jIEVc6QC7
         F2rNbXtG3Fx7bGSAhhAWEPPMXbpIzkuN7QSSIIyOz8cIe2S/e32PnYGuMIqB1ca9xVjc
         OSWb6ZFwwebYw8uBaBAtUOTtqx8MV9+zalmiSMexHRGd142gFOQr0t7+q7q2aTURXks2
         US9g==
X-Gm-Message-State: APjAAAUWGJFhvAoJ3kfbOPmIAMBd1IZoSyoueIN0+Uu7pWRV284GV0J7
        wr1mN9x0lAct4LTuhjN4NOc=
X-Google-Smtp-Source: APXvYqzyiUuqrCfMx9gkZ4inV0SIP/0jWgm9vfb8vpy/GEYXJcQKCpkdiBnFCuOLQfB8aHh4Vhfw9A==
X-Received: by 2002:a05:600c:21c6:: with SMTP id x6mr19964502wmj.177.1577482617006;
        Fri, 27 Dec 2019 13:36:57 -0800 (PST)
Received: from localhost.localdomain ([188.25.254.226])
        by smtp.gmail.com with ESMTPSA id v3sm36330504wru.32.2019.12.27.13.36.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 27 Dec 2019 13:36:56 -0800 (PST)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     davem@davemloft.net, jakub.kicinski@netronome.com,
        linux@armlinux.org.uk, andrew@lunn.ch, f.fainelli@gmail.com,
        vivien.didelot@gmail.com
Cc:     alexandru.marginean@nxp.com, claudiu.manoil@nxp.com,
        xiaoliang.yang_1@nxp.com, yangbo.lu@nxp.com,
        netdev@vger.kernel.org, alexandre.belloni@bootlin.com,
        horatiu.vultur@microchip.com, UNGLinuxDriver@microchip.com,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: [PATCH v3 net-next 06/11] net: phy: vsc8514: configure explicit in-band SGMII auto-negotiation settings
Date:   Fri, 27 Dec 2019 23:36:21 +0200
Message-Id: <20191227213626.4404-7-olteanv@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20191227213626.4404-1-olteanv@gmail.com>
References: <20191227213626.4404-1-olteanv@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Alex Marginean <alexandru.marginean@nxp.com>

The IN_BAND_AN_DEFAULT setting for the VSC8514 PHY is not very reliable:
its out-of-reset state is with SerDes AN disabled, but certain boot
firmware (such as U-Boot) enables it during the boot process.

So its final state as seen by Linux depends on whether the U-Boot PHY
driver has run or not.

If SGMII auto-negotiation is enabled but not acknowledged by the MAC,
the PHY does not pass traffic.

But otherwise, it is able to pass traffic both with AN disabled, and
with AN enabled. So make it explicitly configurable.

Signed-off-by: Alex Marginean <alexandru.marginean@nxp.com>
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
Changes in v3:
- Patch is new.

 drivers/net/phy/mscc.c | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/drivers/net/phy/mscc.c b/drivers/net/phy/mscc.c
index 50214c081164..b9a22474a715 100644
--- a/drivers/net/phy/mscc.c
+++ b/drivers/net/phy/mscc.c
@@ -176,6 +176,8 @@ enum rgmii_rx_clock_delay {
 #define SECURE_ON_PASSWD_LEN_4		  0x4000
 
 /* Extended Page 3 Registers */
+#define MSCC_PHY_SERDES_CON		  16
+#define MSCC_PHY_SERDES_ANEG		  BIT(7)
 #define MSCC_PHY_SERDES_TX_VALID_CNT	  21
 #define MSCC_PHY_SERDES_TX_CRC_ERR_CNT	  22
 #define MSCC_PHY_SERDES_RX_VALID_CNT	  28
@@ -2157,6 +2159,19 @@ static int vsc8514_config_init(struct phy_device *phydev)
 
 	mutex_unlock(&phydev->mdio.bus->mdio_lock);
 
+	ret = phy_write(phydev, MSCC_EXT_PAGE_ACCESS, MSCC_PHY_PAGE_EXTENDED_3);
+	if (ret)
+		return ret;
+
+	if (phydev->in_band_autoneg == IN_BAND_AN_ENABLED)
+		ret = phy_set_bits(phydev, MSCC_PHY_SERDES_CON,
+				   MSCC_PHY_SERDES_ANEG);
+	else if (phydev->in_band_autoneg == IN_BAND_AN_DISABLED)
+		ret = phy_clear_bits(phydev, MSCC_PHY_SERDES_CON,
+				     MSCC_PHY_SERDES_ANEG);
+	if (ret)
+		return ret;
+
 	ret = phy_write(phydev, MSCC_EXT_PAGE_ACCESS, MSCC_PHY_PAGE_STANDARD);
 
 	if (ret)
-- 
2.17.1

