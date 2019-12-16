Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E9F33120EF5
	for <lists+netdev@lfdr.de>; Mon, 16 Dec 2019 17:14:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726637AbfLPQNg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Dec 2019 11:13:36 -0500
Received: from mail-pl1-f193.google.com ([209.85.214.193]:36620 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725805AbfLPQNb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Dec 2019 11:13:31 -0500
Received: by mail-pl1-f193.google.com with SMTP id d15so4674551pll.3;
        Mon, 16 Dec 2019 08:13:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=gDY4jEFGJ9H7V2r9z4CnsZu5TcOGMUSykJmuesqXvp0=;
        b=KaZBIWJT3JJ/4Bhz6HxeE3e6wso/zKd+VCvepjFk7IR2R3EldpDy+EnYgPdm/L6heF
         vRHnW8CKlW8Y6IJcp5aNfwqOa+bfosO2nLsoF3Jkan2MvOLKN/QghluFbanGijeXI0Lw
         UIACFmNdF6JjLFBQV13L/uL9Z8jvT2FITa/SSByk+n7B6K93H1vJJdOG/O5KbodgXiue
         0ZJxOINyaZSow/NbaYAet6pR+HXs67wkuU7SdcETttstg2NHMG5tk5XZzFSsY3ZwiXvd
         H3qgBROaUziZ+sRPPNOnCXXMBm3GPDqTlbhn/JrjcgMO+J05fYCkKX/PUM3G4jnfVqzJ
         teXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=gDY4jEFGJ9H7V2r9z4CnsZu5TcOGMUSykJmuesqXvp0=;
        b=PS0EaSYN2Ddjq6/pCHNBifHSCq4DXT6IQLDt+qMsbjxffEpJ4Wl/K5g6wjDFAw/xHl
         LExEB9JRleS6GILAYfdHmMBG9/v/ClZE9DJowrn8HW4Zwr/kWxfWO3zUjjmuZ1IYEvK3
         4HC5jDej+xIykK3vGKvLojTdjWWODvbuD0lSuLhfYRAiNPRKZQzO9KUWSkbwmqq19XKs
         rRgsnUZwFt4HQJbGt6IGlc04fSFH3qCoY5J3SZS8KrBqcgnD0R7kRuDS41pwWYMZDUxy
         OhLDjZQ1tjWY0OkfyBPCP3cPfMovPCX892U3idZBanAR7gReHTu44QHQ7cRnR7kG8Vny
         j0Bw==
X-Gm-Message-State: APjAAAVICWF5n0eUNSowvQvu5IVFdyw5ceCI1aZJejF7cmOiGoTjFsru
        iGYXi0yAKxL75AJ5tt/kjDZqB08y
X-Google-Smtp-Source: APXvYqyq+Ik+IgBGQx2AGkfrShrPsw9p78XvtEWGA23K6U+u0iMt/0g8VCH++ATfNtQDUtRaBLIkWg==
X-Received: by 2002:a17:902:968f:: with SMTP id n15mr16971115plp.12.1576512809945;
        Mon, 16 Dec 2019 08:13:29 -0800 (PST)
Received: from localhost.localdomain (c-73-241-114-122.hsd1.ca.comcast.net. [73.241.114.122])
        by smtp.gmail.com with ESMTPSA id 83sm23478433pgh.12.2019.12.16.08.13.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Dec 2019 08:13:29 -0800 (PST)
From:   Richard Cochran <richardcochran@gmail.com>
To:     netdev@vger.kernel.org
Cc:     David Miller <davem@davemloft.net>, devicetree@vger.kernel.org,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Jacob Keller <jacob.e.keller@intel.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Miroslav Lichvar <mlichvar@redhat.com>,
        Murali Karicheri <m-karicheri2@ti.com>,
        Rob Herring <robh+dt@kernel.org>,
        Willem de Bruijn <willemb@google.com>,
        Wingman Kwok <w-kwok2@ti.com>
Subject: [PATCH V6 net-next 01/11] net: phy: Introduce helper functions for time stamping support.
Date:   Mon, 16 Dec 2019 08:13:16 -0800
Message-Id: <153343b4ae5dd92dff803127c467dcce58a5933f.1576511937.git.richardcochran@gmail.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <cover.1576511937.git.richardcochran@gmail.com>
References: <cover.1576511937.git.richardcochran@gmail.com>
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

