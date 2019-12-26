Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B20DA12A996
	for <lists+netdev@lfdr.de>; Thu, 26 Dec 2019 03:16:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726935AbfLZCQZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Dec 2019 21:16:25 -0500
Received: from mail-pf1-f195.google.com ([209.85.210.195]:45427 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726885AbfLZCQZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Dec 2019 21:16:25 -0500
Received: by mail-pf1-f195.google.com with SMTP id 2so12522300pfg.12;
        Wed, 25 Dec 2019 18:16:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=+LgVazWFqvVcdctdDKHy4vuxqcL6YZfeaQzb1I4YFjU=;
        b=lN0rTupdZuTpJNHgczfAkLMZVL4lPqIn4DXhjNmQqfA/T2yrErlwiww1GwThz1mirx
         spLO/9IeZCF2G91Uo3jBSHAMp7GwH9Bu/cVnJUMWjb9oH86KC0soJiknW8lMpcsKeZ2W
         FUDdIzOBYdFx4a5ez3u+dsCrJGVgPrZ89HpTg3nfWYRoI0v+VpSGE2SKabvo/U7Mwf7w
         GoLgMQW4oEJBgK80MqpnGwZ5/lNJOPM1s+eSCp98oAG6dK1Pt7+P9WVaU2TGV2oiw4ZW
         pFxpmhySHfL3HySbfsnrJZTkNuSddbDMeJOruBaLLY2oV1vyA7yetzbZtpsU1oJKqt33
         NXAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=+LgVazWFqvVcdctdDKHy4vuxqcL6YZfeaQzb1I4YFjU=;
        b=J0rdVBzvuE56cJJr5xctVrQmnBBfu2SGVWnPh0tQs3EWAFlZ/ab55InSO9t2CNJuBs
         KbBnYW0eHNgPV8vnLfB9uHz04Oh0tXa80IiN377M0VAg+q8f3yCxlBLMCjNRna2mCvqG
         uOdNhpn4VsuEtiVzQRJoLbYNdwibAYPeSnN005YlEqClO7ADiHey2zeKNxL7sIURL2tR
         bacEDz6tr99xRuTGuuAQ/pdmTi8VZ+7HCNrJ3S302/8bvgVYa2JiY2pGcIc3CsM936qV
         clSX0BN7GBmoN9O3Ry9i/5BuXZy3oG1aYPng/965azHviomXRDWsDHP5EKZ1ycN8TaBU
         MmiA==
X-Gm-Message-State: APjAAAXk7KbvRto5iZcp++O9CMeM5H+IfRbMEPtvjbJLMiROM/DLig6N
        16IPhgUJ9mwzTy3gGe7AKzs9tHHB
X-Google-Smtp-Source: APXvYqyPD3yUao+q2yblpPk9IJ3VG4rB4Y/Ln2i+CZ+yrRZ6/icOWfwB9Csr2ao3n75xIq1KzCxPIw==
X-Received: by 2002:a63:111e:: with SMTP id g30mr47229584pgl.251.1577326583813;
        Wed, 25 Dec 2019 18:16:23 -0800 (PST)
Received: from localhost.localdomain (c-73-241-114-122.hsd1.ca.comcast.net. [73.241.114.122])
        by smtp.gmail.com with ESMTPSA id b65sm31880723pgc.18.2019.12.25.18.16.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Dec 2019 18:16:23 -0800 (PST)
From:   Richard Cochran <richardcochran@gmail.com>
To:     netdev@vger.kernel.org
Cc:     David Miller <davem@davemloft.net>, devicetree@vger.kernel.org,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Jacob Keller <jacob.e.keller@intel.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Miroslav Lichvar <mlichvar@redhat.com>,
        Murali Karicheri <m-karicheri2@ti.com>,
        Rob Herring <robh+dt@kernel.org>,
        Willem de Bruijn <willemb@google.com>,
        Wingman Kwok <w-kwok2@ti.com>
Subject: [PATCH V9 net-next 01/12] net: phy: Introduce helper functions for time stamping support.
Date:   Wed, 25 Dec 2019 18:16:09 -0800
Message-Id: <5d7df80cc0dfce0204124f7dc4283c7126f24c33.1577326042.git.richardcochran@gmail.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <cover.1577326042.git.richardcochran@gmail.com>
References: <cover.1577326042.git.richardcochran@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Some parts of the networking stack and at least one driver test fields
within the 'struct phy_device' in order to query time stamping
capabilities and to invoke time stamping methods.  This patch adds a
functional interface around the time stamping fields.  This will allow
insulating the callers from future changes to the details of the time
stamping implemenation.

Signed-off-by: Richard Cochran <richardcochran@gmail.com>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
---
 include/linux/phy.h | 60 +++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 60 insertions(+)

diff --git a/include/linux/phy.h b/include/linux/phy.h
index 5032d453ac66..fc51aacb03a7 100644
--- a/include/linux/phy.h
+++ b/include/linux/phy.h
@@ -936,6 +936,66 @@ static inline bool phy_polling_mode(struct phy_device *phydev)
 	return phydev->irq == PHY_POLL;
 }
 
+/**
+ * phy_has_hwtstamp - Tests whether a PHY time stamp configuration.
+ * @phydev: the phy_device struct
+ */
+static inline bool phy_has_hwtstamp(struct phy_device *phydev)
+{
+	return phydev && phydev->drv && phydev->drv->hwtstamp;
+}
+
+/**
+ * phy_has_rxtstamp - Tests whether a PHY supports receive time stamping.
+ * @phydev: the phy_device struct
+ */
+static inline bool phy_has_rxtstamp(struct phy_device *phydev)
+{
+	return phydev && phydev->drv && phydev->drv->rxtstamp;
+}
+
+/**
+ * phy_has_tsinfo - Tests whether a PHY reports time stamping and/or
+ * PTP hardware clock capabilities.
+ * @phydev: the phy_device struct
+ */
+static inline bool phy_has_tsinfo(struct phy_device *phydev)
+{
+	return phydev && phydev->drv && phydev->drv->ts_info;
+}
+
+/**
+ * phy_has_txtstamp - Tests whether a PHY supports transmit time stamping.
+ * @phydev: the phy_device struct
+ */
+static inline bool phy_has_txtstamp(struct phy_device *phydev)
+{
+	return phydev && phydev->drv && phydev->drv->txtstamp;
+}
+
+static inline int phy_hwtstamp(struct phy_device *phydev, struct ifreq *ifr)
+{
+	return phydev->drv->hwtstamp(phydev, ifr);
+}
+
+static inline bool phy_rxtstamp(struct phy_device *phydev, struct sk_buff *skb,
+				int type)
+{
+	return phydev->drv->rxtstamp(phydev, skb, type);
+}
+
+static inline int phy_ts_info(struct phy_device *phydev,
+			      struct ethtool_ts_info *tsinfo)
+{
+	return phydev->drv->ts_info(phydev, tsinfo);
+}
+
+static inline void phy_txtstamp(struct phy_device *phydev, struct sk_buff *skb,
+				int type)
+{
+	phydev->drv->txtstamp(phydev, skb, type);
+}
+
 /**
  * phy_is_internal - Convenience function for testing if a PHY is internal
  * @phydev: the phy_device struct
-- 
2.20.1

