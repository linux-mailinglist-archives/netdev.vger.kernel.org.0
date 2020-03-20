Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 408DE18D4FB
	for <lists+netdev@lfdr.de>; Fri, 20 Mar 2020 17:53:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727804AbgCTQxt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Mar 2020 12:53:49 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:45363 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727628AbgCTQxM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Mar 2020 12:53:12 -0400
Received: by mail-wr1-f66.google.com with SMTP id t7so3663593wrw.12
        for <netdev@vger.kernel.org>; Fri, 20 Mar 2020 09:53:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=/Dd7H5jExRoT+3OTpYunFvkFx9GlJoY2lj7OoQn/UL0=;
        b=coUiRT+OGkB+A+t8H2n1+wc2xKzuhcVfbl3XMbV9gjXjWfR4a9u+lk7scqSbbM6Gkw
         8iQMaa6eCnjTIEAscPK4NzpofVbLBawI+ZBLALVsk/lOxlluJfoTUa7oremdYISc/eHu
         98v7KMQmHb2GwDThbpf+qvAc3llyUdhTj3VNVhkdPGWDKZnOh0d14BbQIMNwu4W8CXrY
         DaQm6pT54/a+kXzG1nzV2qqFIIgeiTLj8bkf0jvPWTE7So0PFkFpNFB7+idubPCEKL1y
         ymk5nmkHl+WKzNj4991kJ3jbQOViO8D+Y3r3cH3/K+SR0PtwDGdtASCs0pU7USMdg3wx
         oZSQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=/Dd7H5jExRoT+3OTpYunFvkFx9GlJoY2lj7OoQn/UL0=;
        b=e+dmpuyce0rHZf+IT2uKKN8lll326Y4fhw1eucoFatQtsaJoYK5SHh6geHgNXZ9NYa
         c1gENz3VU6wUOWibEgQhnEB+UV8FfhvKW16AOduWeKbJz75xOD5BBHzLAxP8TK6GN52f
         TJVaj729XNtU1L8og9xpYXJLEBddSsCjwLBa5j0Cgkwrl9nuSeASlEx5YkvrXMFOlZsT
         FfIabBPtn0434wA6W5sOr1SKGwdsxUk1MVLAq1nDBkUhlRPlg2AL+4BtjHzqXgVRyTtF
         Z2sJIjksJT/VzeIE2XCzNWZH7nfV50faw/SGTwttTsPZgzeb8rSpV4q8mUP8IMwcEw2O
         RfGA==
X-Gm-Message-State: ANhLgQ1g1BXjF/SaaGpuBm0kb24+AnkMQTouaz4/uqgS5Y8Tb7Coz87K
        OxWWpJNb3SitK+kLR1gMfqDHFjA9
X-Google-Smtp-Source: ADFU+vv6u2JwQGwI4alzsdyGS6BrLs9+w1UHKkqq1NusShHLxt+KeIDCeDfEz3wCBC+uuW/j6VjAdg==
X-Received: by 2002:a5d:5710:: with SMTP id a16mr12507733wrv.5.1584723190357;
        Fri, 20 Mar 2020 09:53:10 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f29:6000:b52a:38f:362f:3e41? (p200300EA8F296000B52A038F362F3E41.dip0.t-ipconnect.de. [2003:ea:8f29:6000:b52a:38f:362f:3e41])
        by smtp.googlemail.com with ESMTPSA id t193sm8775978wmt.14.2020.03.20.09.53.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 20 Mar 2020 09:53:09 -0700 (PDT)
Subject: [PATCH net-next v2 1/3] net: phy: add and use phy_check_downshift
From:   Heiner Kallweit <hkallweit1@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Russell King - ARM Linux <linux@armlinux.org.uk>,
        David Miller <davem@davemloft.net>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <6e451e53-803f-d277-800a-ff042fb8a858@gmail.com>
Message-ID: <004895b0-10d4-8412-1941-900ea5a72d37@gmail.com>
Date:   Fri, 20 Mar 2020 17:51:38 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <6e451e53-803f-d277-800a-ff042fb8a858@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

So far PHY drivers have to check whether a downshift occurred to be
able to notify the user. To make life of drivers authors a little bit
easier move the downshift notification to phylib. phy_check_downshift()
compares the highest mutually advertised speed with the actual value
of phydev->speed (typically read by the PHY driver from a
vendor-specific register) to detect a downshift.

v2:
- Add downshift hint to phy_print_status

Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
 drivers/net/phy/phy-core.c | 38 ++++++++++++++++++++++++++++++++++++++
 drivers/net/phy/phy.c      |  4 +++-
 include/linux/phy.h        |  3 +++
 3 files changed, 44 insertions(+), 1 deletion(-)

diff --git a/drivers/net/phy/phy-core.c b/drivers/net/phy/phy-core.c
index e083e7a76..9b16ed90d 100644
--- a/drivers/net/phy/phy-core.c
+++ b/drivers/net/phy/phy-core.c
@@ -329,6 +329,44 @@ void phy_resolve_aneg_linkmode(struct phy_device *phydev)
 }
 EXPORT_SYMBOL_GPL(phy_resolve_aneg_linkmode);
 
+/**
+ * phy_check_downshift - check whether downshift occurred
+ * @phydev: The phy_device struct
+ *
+ * Check whether a downshift to a lower speed occurred. If this should be the
+ * case warn the user.
+ * Prerequisite for detecting downshift is that PHY driver implements the
+ * read_status callback and sets phydev->speed to the actual link speed.
+ */
+void phy_check_downshift(struct phy_device *phydev)
+{
+	__ETHTOOL_DECLARE_LINK_MODE_MASK(common);
+	int i, speed = SPEED_UNKNOWN;
+
+	phydev->downshifted_rate = 0;
+
+	if (phydev->autoneg == AUTONEG_DISABLE ||
+	    phydev->speed == SPEED_UNKNOWN)
+		return;
+
+	linkmode_and(common, phydev->lp_advertising, phydev->advertising);
+
+	for (i = 0; i < ARRAY_SIZE(settings); i++)
+		if (test_bit(settings[i].bit, common)) {
+			speed = settings[i].speed;
+			break;
+		}
+
+	if (speed == SPEED_UNKNOWN || phydev->speed >= speed)
+		return;
+
+	phydev_warn(phydev, "Downshift occurred from negotiated speed %s to actual speed %s, check cabling!\n",
+		    phy_speed_to_str(speed), phy_speed_to_str(phydev->speed));
+
+	phydev->downshifted_rate = 1;
+}
+EXPORT_SYMBOL_GPL(phy_check_downshift);
+
 static int phy_resolve_min_speed(struct phy_device *phydev, bool fdx_only)
 {
 	__ETHTOOL_DECLARE_LINK_MODE_MASK(common);
diff --git a/drivers/net/phy/phy.c b/drivers/net/phy/phy.c
index d71212a41..72c69a9c8 100644
--- a/drivers/net/phy/phy.c
+++ b/drivers/net/phy/phy.c
@@ -96,9 +96,10 @@ void phy_print_status(struct phy_device *phydev)
 {
 	if (phydev->link) {
 		netdev_info(phydev->attached_dev,
-			"Link is Up - %s/%s - flow control %s\n",
+			"Link is Up - %s/%s %s- flow control %s\n",
 			phy_speed_to_str(phydev->speed),
 			phy_duplex_to_str(phydev->duplex),
+			phydev->downshifted_rate ? "(downshifted) " : "",
 			phy_pause_str(phydev));
 	} else	{
 		netdev_info(phydev->attached_dev, "Link is Down\n");
@@ -507,6 +508,7 @@ static int phy_check_link_status(struct phy_device *phydev)
 		return err;
 
 	if (phydev->link && phydev->state != PHY_RUNNING) {
+		phy_check_downshift(phydev);
 		phydev->state = PHY_RUNNING;
 		phy_link_up(phydev);
 	} else if (!phydev->link && phydev->state != PHY_NOLINK) {
diff --git a/include/linux/phy.h b/include/linux/phy.h
index cb5a2182b..1fc061e33 100644
--- a/include/linux/phy.h
+++ b/include/linux/phy.h
@@ -365,6 +365,7 @@ struct macsec_ops;
  * suspended_by_mdio_bus: Set to true if this phy was suspended by MDIO bus.
  * sysfs_links: Internal boolean tracking sysfs symbolic links setup/removal.
  * loopback_enabled: Set true if this phy has been loopbacked successfully.
+ * downshifted_rate: Set true if link speed has been downshifted.
  * state: state of the PHY for management purposes
  * dev_flags: Device-specific flags used by the PHY driver.
  * irq: IRQ number of the PHY's interrupt (-1 if none)
@@ -405,6 +406,7 @@ struct phy_device {
 	unsigned suspended_by_mdio_bus:1;
 	unsigned sysfs_links:1;
 	unsigned loopback_enabled:1;
+	unsigned downshifted_rate:1;
 
 	unsigned autoneg:1;
 	/* The most recently read link state */
@@ -698,6 +700,7 @@ static inline bool phy_is_started(struct phy_device *phydev)
 
 void phy_resolve_aneg_pause(struct phy_device *phydev);
 void phy_resolve_aneg_linkmode(struct phy_device *phydev);
+void phy_check_downshift(struct phy_device *phydev);
 
 /**
  * phy_read - Convenience function for reading a given PHY register
-- 
2.25.2


