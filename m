Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1A4172BA26
	for <lists+netdev@lfdr.de>; Mon, 27 May 2019 20:30:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727289AbfE0SaD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 May 2019 14:30:03 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:35009 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727274AbfE0SaD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 May 2019 14:30:03 -0400
Received: by mail-wm1-f67.google.com with SMTP id w9so329087wmi.0
        for <netdev@vger.kernel.org>; Mon, 27 May 2019 11:30:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=6GD8C8d1YYIughSi/qa9hCA+csQvXSQDkcz7sRnKREk=;
        b=Bs+160TiVPsqoYW5SR8942nHhK3s/VdTTU3LrHUIJGqPbWbJ5DhlKpfEIox/jjvoPW
         YiMCRvPHJXRDK6rZWlcNUsloNmGb+Wk6SR/F1jBys1PXB4Nr4axZhzX2MEBxgV4EZ0LE
         iz6mGYMJfS+v4132kR6s2oGQCCJUMMsCdpFZKl9PRNvKoYGaFW3sMWitSTANIWHvHU3Y
         IOsMnowvBupezNJ2qXjMVIFQSzcxgsCk242nUr+vmZ07Ts23JR62CjTVuOo7aFPvHpq6
         MEznFsyHOassQ606dHkuavqazk1azYvcD+4OeN7FdmB+UyFc2iuKt9wT+YebZWa1XjUF
         CIlA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=6GD8C8d1YYIughSi/qa9hCA+csQvXSQDkcz7sRnKREk=;
        b=R8TGYyf/+gxLnBRj82ZDp5UjKnccoSXPGuDDa0BSvKFZOxZQdhO+nRik1QcaGYKah4
         Sn67+mrmXBThDia+AmFAeGwOjfoTXxDdVBC+QSUezaMf7bN6RKhlnPvWCxm0e0RfK7j4
         0hcR5OoFHaCch9pcQHCogiuKqWgs1KJ+NeM5LvLkM20tw/jhjFdcVngkHrHuTAW0rWov
         I9aqslGs+cdlsii+4dLQRhQq1pVsUc4DAvvGF/L9FN9RNCJPMIRCwJcRu830YZaXZUxL
         1UD4MwqmtzXT9/O4U4G1YwxW1u03DKBAd+lMm9EWd6wvKgi5uWwbM4u1gOojYqdKh/66
         9x/w==
X-Gm-Message-State: APjAAAVoMvPd7XnPVBwN+cipq6lIAm7q9Zr8oLKUN+EJVcYbiY9uDI8y
        YnhfyW/4A8LSD6K7Vqtc3T2jLOtC
X-Google-Smtp-Source: APXvYqxTiC9vJJ/c5Z8geUT2nPJMLkya0lecpAXtx71laYleI12suAE89K5JzPgh+4/mIDlzNv7APg==
X-Received: by 2002:a7b:c442:: with SMTP id l2mr281833wmi.50.1558981800639;
        Mon, 27 May 2019 11:30:00 -0700 (PDT)
Received: from ?IPv6:2003:ea:8be9:7a00:485f:6c34:28a2:1d35? (p200300EA8BE97A00485F6C3428A21D35.dip0.t-ipconnect.de. [2003:ea:8be9:7a00:485f:6c34:28a2:1d35])
        by smtp.googlemail.com with ESMTPSA id s10sm10177597wrt.66.2019.05.27.11.29.59
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 27 May 2019 11:30:00 -0700 (PDT)
Subject: [PATCH net-next 3/3] net: phy: move handling latched link-down to
 phylib state machine
From:   Heiner Kallweit <hkallweit1@gmail.com>
To:     Russell King - ARM Linux <linux@armlinux.org.uk>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        David Miller <davem@davemloft.net>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <e3ce708d-d841-bd7e-30bb-bff37f3b89ac@gmail.com>
Message-ID: <b79f49f8-a42b-11c1-f83e-c198fee49dab@gmail.com>
Date:   Mon, 27 May 2019 20:29:45 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <e3ce708d-d841-bd7e-30bb-bff37f3b89ac@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Especially with fibre links there may be very short link drops. And if
interrupt handling is slow we may miss such a link drop. To deal with
this we remove the double link status read from the generic link status
read functions, and call the state machine twice instead.
The flag for double-reading link status can be set by phy_mac_interrupt
from hard irq context, therefore we have to use an atomic operation.

Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
Suggested-by: Russell King - ARM Linux admin <linux@armlinux.org.uk>
---
 drivers/net/phy/phy-c45.c    | 12 ------------
 drivers/net/phy/phy.c        | 11 +++++++++++
 drivers/net/phy/phy_device.c | 14 +-------------
 include/linux/phy.h          |  8 ++++++++
 4 files changed, 20 insertions(+), 25 deletions(-)

diff --git a/drivers/net/phy/phy-c45.c b/drivers/net/phy/phy-c45.c
index b9d414578..63d9e8483 100644
--- a/drivers/net/phy/phy-c45.c
+++ b/drivers/net/phy/phy-c45.c
@@ -223,18 +223,6 @@ int genphy_c45_read_link(struct phy_device *phydev)
 		devad = __ffs(mmd_mask);
 		mmd_mask &= ~BIT(devad);
 
-		/* The link state is latched low so that momentary link
-		 * drops can be detected. Do not double-read the status
-		 * in polling mode to detect such short link drops.
-		 */
-		if (!phy_polling_mode(phydev)) {
-			val = phy_read_mmd(phydev, devad, MDIO_STAT1);
-			if (val < 0)
-				return val;
-			else if (val & MDIO_STAT1_LSTATUS)
-				continue;
-		}
-
 		val = phy_read_mmd(phydev, devad, MDIO_STAT1);
 		if (val < 0)
 			return val;
diff --git a/drivers/net/phy/phy.c b/drivers/net/phy/phy.c
index 8030d0a97..575412ff5 100644
--- a/drivers/net/phy/phy.c
+++ b/drivers/net/phy/phy.c
@@ -778,6 +778,7 @@ static irqreturn_t phy_interrupt(int irq, void *phy_dat)
 		if (phydev->drv->handle_interrupt(phydev))
 			goto phy_err;
 	} else {
+		set_bit(PHY_LINK_DOUBLE_READ, &phydev->atomic_flags);
 		/* reschedule state queue work to run as soon as possible */
 		phy_trigger_machine(phydev);
 	}
@@ -969,6 +970,15 @@ void phy_state_machine(struct work_struct *work)
 			phydev->drv->link_change_notify(phydev);
 	}
 
+	/* link-down is latched, in order not to lose a link-up event we have
+	 * to read the link status twice
+	 */
+	if (test_and_clear_bit(PHY_LINK_DOUBLE_READ, &phydev->atomic_flags)) {
+		if (!phydev->link)
+			phy_trigger_machine(phydev);
+		return;
+	}
+
 	/* Only re-schedule a PHY state machine change if we are polling the
 	 * PHY, if PHY_IGNORE_INTERRUPT is set, then we will be moving
 	 * between states from phy_mac_interrupt().
@@ -992,6 +1002,7 @@ void phy_state_machine(struct work_struct *work)
  */
 void phy_mac_interrupt(struct phy_device *phydev)
 {
+	set_bit(PHY_LINK_DOUBLE_READ, &phydev->atomic_flags);
 	/* Trigger a state machine change */
 	phy_trigger_machine(phydev);
 }
diff --git a/drivers/net/phy/phy_device.c b/drivers/net/phy/phy_device.c
index dcc93a873..f2a78baa8 100644
--- a/drivers/net/phy/phy_device.c
+++ b/drivers/net/phy/phy_device.c
@@ -1704,23 +1704,11 @@ int genphy_update_link(struct phy_device *phydev)
 {
 	int status;
 
-	/* The link state is latched low so that momentary link
-	 * drops can be detected. Do not double-read the status
-	 * in polling mode to detect such short link drops.
-	 */
-	if (!phy_polling_mode(phydev)) {
-		status = phy_read(phydev, MII_BMSR);
-		if (status < 0)
-			return status;
-		else if (status & BMSR_LSTATUS)
-			goto done;
-	}
-
 	/* Read link and autonegotiation status */
 	status = phy_read(phydev, MII_BMSR);
 	if (status < 0)
 		return status;
-done:
+
 	phydev->link = status & BMSR_LSTATUS ? 1 : 0;
 	phydev->autoneg_complete = status & BMSR_ANEGCOMPLETE ? 1 : 0;
 
diff --git a/include/linux/phy.h b/include/linux/phy.h
index f90158c67..1d1dcfa90 100644
--- a/include/linux/phy.h
+++ b/include/linux/phy.h
@@ -332,6 +332,10 @@ struct phy_c45_device_ids {
 	u32 device_ids[8];
 };
 
+enum phy_atomic_flags {
+	PHY_LINK_DOUBLE_READ,
+};
+
 /* phy_device: An instance of a PHY
  *
  * drv: Pointer to the driver for this PHY instance
@@ -346,6 +350,7 @@ struct phy_c45_device_ids {
  * sysfs_links: Internal boolean tracking sysfs symbolic links setup/removal.
  * loopback_enabled: Set true if this phy has been loopbacked successfully.
  * state: state of the PHY for management purposes
+ * atomic_flags: flags accessed in atomic context
  * dev_flags: Device-specific flags used by the PHY driver.
  * link_timeout: The number of timer firings to wait before the
  * giving up on the current attempt at acquiring a link
@@ -394,6 +399,9 @@ struct phy_device {
 
 	enum phy_state state;
 
+	/* flags used in atomic context */
+	unsigned long atomic_flags;
+
 	u32 dev_flags;
 
 	phy_interface_t interface;
-- 
2.21.0


