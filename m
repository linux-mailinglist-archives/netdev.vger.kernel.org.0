Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C94D8E0B75
	for <lists+netdev@lfdr.de>; Tue, 22 Oct 2019 20:31:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732548AbfJVSbp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Oct 2019 14:31:45 -0400
Received: from mail-pf1-f194.google.com ([209.85.210.194]:36547 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729696AbfJVSbp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Oct 2019 14:31:45 -0400
Received: by mail-pf1-f194.google.com with SMTP id y22so11176798pfr.3;
        Tue, 22 Oct 2019 11:31:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=vWaIJ7mJACYuUZWcgVyk29Ot7LMWvhaWUYWmlLLazNY=;
        b=n6c/fck6D5uQP9IBlnQADwqjS5dd2RiFKiRXiAMBaPQlal3nVeXCqtFQCe/4P7MtLU
         ZFeHzMYQBAOlUANLzxUgiY9i80u0a3IGdQZDrTzeJlqOsuGFVruTD0dD6y1sZxn7B7vf
         DvR6/8nmBYhaevIq3T+9aP83u+rB3STDi6eo82CXcA5fm1Cu7Y2fxrMiP6OjD4u1EkjN
         IKm2sY3PfrfNxjhye953IBkNXBTr3aKB07gCUkGDLbp2gxKUZUm54S+EWMlkNukggfPE
         v6Wyi+0nheA86bd5TBYwlSigl42G+VVAHOvY1TM6jIL+ybnCQjW1oIdQ7g2w0GlE4QJU
         t0ew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=vWaIJ7mJACYuUZWcgVyk29Ot7LMWvhaWUYWmlLLazNY=;
        b=ho3zW0XNC9cIoJmAikwm4YPwrYiL1QtWhsbIeKe+eAwoR2rbLGI2CWhpF18zS0BVoS
         CNvN7//zOZtMovi2KIXbku1sAtEZcHXGICNPpiz8gGT52SOHZ4l90D8yMOZd4pmbygSF
         vgpAu3KeVaXXeohWXbhtlhSQJ0gGUd1ESg/07A5gk5UErI/iGkOexfM8n46h8jBV7dHz
         TSHp0cABE4QtwwS9S0VsLksiKzD/yzP74i/3pGTNULqt+OTOVcxwFFaeKow1M0vzCEbi
         u7wfAPApI1Y1LmnHTE3lYIGEqqGMrSLKqBG9eWPYskknzlpy6sdsU/thesCYRkZVvTDT
         uJsw==
X-Gm-Message-State: APjAAAWnuHKcXf1T3/z2JsY7HV9twSquUodgF79FU/poh+MhsZGbH5mR
        ZIXJibJg8MzUrbyVDzydj3w=
X-Google-Smtp-Source: APXvYqze8zh8kfWLbKpniz3dVlUYK19lj6aPZsJq05GqAxGM2KnHA+7uV3v2Y8Bcr+oezkADhBTutQ==
X-Received: by 2002:a17:90a:9f8a:: with SMTP id o10mr6355889pjp.91.1571769103665;
        Tue, 22 Oct 2019 11:31:43 -0700 (PDT)
Received: from taoren-ubuntu-R90MNF91.thefacebook.com ([2620:10d:c090:200::2398])
        by smtp.gmail.com with ESMTPSA id m19sm16787947pjl.28.2019.10.22.11.31.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Oct 2019 11:31:43 -0700 (PDT)
From:   rentao.bupt@gmail.com
To:     "David S . Miller" <davem@davemloft.net>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Vladimir Oltean <olteanv@gmail.com>,
        Arun Parameswaran <arun.parameswaran@broadcom.com>,
        Justin Chen <justinpopo6@gmail.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, openbmc@lists.ozlabs.org
Cc:     Tao Ren <taoren@fb.com>
Subject: [PATCH net-next v10 2/3] net: phy: add support for clause 37 auto-negotiation
Date:   Tue, 22 Oct 2019 11:31:07 -0700
Message-Id: <20191022183108.14029-3-rentao.bupt@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20191022183108.14029-1-rentao.bupt@gmail.com>
References: <20191022183108.14029-1-rentao.bupt@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Heiner Kallweit <hkallweit1@gmail.com>

This patch adds support for clause 37 1000Base-X auto-negotiation.

Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
Signed-off-by: Tao Ren <taoren@fb.com>
Tested-by: René van Dorst <opensource@vdorst.com>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
---
 No change in v9/v10.
 Changes in v8:
  - Rebased the patch on top of net-next HEAD.
 Changes in v7:
  - Update "if (AUTONEG_ENABLE != phydev->autoneg)" to
    "if (phydev->autoneg != AUTONEG_ENABLE)" so checkpatch.pl is happy.
 Changes in v6:
  - add "Signed-off-by: Tao Ren <taoren@fb.com>"
 Changes in v1-v5:
  - nothing changed. It's given v5 just to align with the version of
    patch series.

 drivers/net/phy/phy_device.c | 139 +++++++++++++++++++++++++++++++++++
 include/linux/phy.h          |   4 +
 2 files changed, 143 insertions(+)

diff --git a/drivers/net/phy/phy_device.c b/drivers/net/phy/phy_device.c
index f1f60bd4865a..fa71998fea51 100644
--- a/drivers/net/phy/phy_device.c
+++ b/drivers/net/phy/phy_device.c
@@ -1607,6 +1607,40 @@ static int genphy_config_advert(struct phy_device *phydev)
 	return changed;
 }
 
+/**
+ * genphy_c37_config_advert - sanitize and advertise auto-negotiation parameters
+ * @phydev: target phy_device struct
+ *
+ * Description: Writes MII_ADVERTISE with the appropriate values,
+ *   after sanitizing the values to make sure we only advertise
+ *   what is supported.  Returns < 0 on error, 0 if the PHY's advertisement
+ *   hasn't changed, and > 0 if it has changed. This function is intended
+ *   for Clause 37 1000Base-X mode.
+ */
+static int genphy_c37_config_advert(struct phy_device *phydev)
+{
+	u16 adv = 0;
+
+	/* Only allow advertising what this PHY supports */
+	linkmode_and(phydev->advertising, phydev->advertising,
+		     phydev->supported);
+
+	if (linkmode_test_bit(ETHTOOL_LINK_MODE_1000baseX_Full_BIT,
+			      phydev->advertising))
+		adv |= ADVERTISE_1000XFULL;
+	if (linkmode_test_bit(ETHTOOL_LINK_MODE_Pause_BIT,
+			      phydev->advertising))
+		adv |= ADVERTISE_1000XPAUSE;
+	if (linkmode_test_bit(ETHTOOL_LINK_MODE_Asym_Pause_BIT,
+			      phydev->advertising))
+		adv |= ADVERTISE_1000XPSE_ASYM;
+
+	return phy_modify_changed(phydev, MII_ADVERTISE,
+				  ADVERTISE_1000XFULL | ADVERTISE_1000XPAUSE |
+				  ADVERTISE_1000XHALF | ADVERTISE_1000XPSE_ASYM,
+				  adv);
+}
+
 /**
  * genphy_config_eee_advert - disable unwanted eee mode advertisement
  * @phydev: target phy_device struct
@@ -1715,6 +1749,54 @@ int __genphy_config_aneg(struct phy_device *phydev, bool changed)
 }
 EXPORT_SYMBOL(__genphy_config_aneg);
 
+/**
+ * genphy_c37_config_aneg - restart auto-negotiation or write BMCR
+ * @phydev: target phy_device struct
+ *
+ * Description: If auto-negotiation is enabled, we configure the
+ *   advertising, and then restart auto-negotiation.  If it is not
+ *   enabled, then we write the BMCR. This function is intended
+ *   for use with Clause 37 1000Base-X mode.
+ */
+int genphy_c37_config_aneg(struct phy_device *phydev)
+{
+	int err, changed;
+
+	if (phydev->autoneg != AUTONEG_ENABLE)
+		return genphy_setup_forced(phydev);
+
+	err = phy_modify(phydev, MII_BMCR, BMCR_SPEED1000 | BMCR_SPEED100,
+			 BMCR_SPEED1000);
+	if (err)
+		return err;
+
+	changed = genphy_c37_config_advert(phydev);
+	if (changed < 0) /* error */
+		return changed;
+
+	if (!changed) {
+		/* Advertisement hasn't changed, but maybe aneg was never on to
+		 * begin with?  Or maybe phy was isolated?
+		 */
+		int ctl = phy_read(phydev, MII_BMCR);
+
+		if (ctl < 0)
+			return ctl;
+
+		if (!(ctl & BMCR_ANENABLE) || (ctl & BMCR_ISOLATE))
+			changed = 1; /* do restart aneg */
+	}
+
+	/* Only restart aneg if we are advertising something different
+	 * than we were before.
+	 */
+	if (changed > 0)
+		return genphy_restart_aneg(phydev);
+
+	return 0;
+}
+EXPORT_SYMBOL(genphy_c37_config_aneg);
+
 /**
  * genphy_aneg_done - return auto-negotiation status
  * @phydev: target phy_device struct
@@ -1886,6 +1968,63 @@ int genphy_read_status(struct phy_device *phydev)
 }
 EXPORT_SYMBOL(genphy_read_status);
 
+/**
+ * genphy_c37_read_status - check the link status and update current link state
+ * @phydev: target phy_device struct
+ *
+ * Description: Check the link, then figure out the current state
+ *   by comparing what we advertise with what the link partner
+ *   advertises. This function is for Clause 37 1000Base-X mode.
+ */
+int genphy_c37_read_status(struct phy_device *phydev)
+{
+	int lpa, err, old_link = phydev->link;
+
+	/* Update the link, but return if there was an error */
+	err = genphy_update_link(phydev);
+	if (err)
+		return err;
+
+	/* why bother the PHY if nothing can have changed */
+	if (phydev->autoneg == AUTONEG_ENABLE && old_link && phydev->link)
+		return 0;
+
+	phydev->duplex = DUPLEX_UNKNOWN;
+	phydev->pause = 0;
+	phydev->asym_pause = 0;
+
+	if (phydev->autoneg == AUTONEG_ENABLE && phydev->autoneg_complete) {
+		lpa = phy_read(phydev, MII_LPA);
+		if (lpa < 0)
+			return lpa;
+
+		linkmode_mod_bit(ETHTOOL_LINK_MODE_Autoneg_BIT,
+				 phydev->lp_advertising, lpa & LPA_LPACK);
+		linkmode_mod_bit(ETHTOOL_LINK_MODE_1000baseX_Full_BIT,
+				 phydev->lp_advertising, lpa & LPA_1000XFULL);
+		linkmode_mod_bit(ETHTOOL_LINK_MODE_Pause_BIT,
+				 phydev->lp_advertising, lpa & LPA_1000XPAUSE);
+		linkmode_mod_bit(ETHTOOL_LINK_MODE_Asym_Pause_BIT,
+				 phydev->lp_advertising,
+				 lpa & LPA_1000XPAUSE_ASYM);
+
+		phy_resolve_aneg_linkmode(phydev);
+	} else if (phydev->autoneg == AUTONEG_DISABLE) {
+		int bmcr = phy_read(phydev, MII_BMCR);
+
+		if (bmcr < 0)
+			return bmcr;
+
+		if (bmcr & BMCR_FULLDPLX)
+			phydev->duplex = DUPLEX_FULL;
+		else
+			phydev->duplex = DUPLEX_HALF;
+	}
+
+	return 0;
+}
+EXPORT_SYMBOL(genphy_c37_read_status);
+
 /**
  * genphy_soft_reset - software reset the PHY via BMCR_RESET bit
  * @phydev: target phy_device struct
diff --git a/include/linux/phy.h b/include/linux/phy.h
index 9a0e981df502..78436d58ce7c 100644
--- a/include/linux/phy.h
+++ b/include/linux/phy.h
@@ -1106,6 +1106,10 @@ int genphy_read_mmd_unsupported(struct phy_device *phdev, int devad,
 int genphy_write_mmd_unsupported(struct phy_device *phdev, int devnum,
 				 u16 regnum, u16 val);
 
+/* Clause 37 */
+int genphy_c37_config_aneg(struct phy_device *phydev);
+int genphy_c37_read_status(struct phy_device *phydev);
+
 /* Clause 45 PHY */
 int genphy_c45_restart_aneg(struct phy_device *phydev);
 int genphy_c45_check_and_restart_aneg(struct phy_device *phydev, bool restart);
-- 
2.17.1

