Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 98BF12FC01
	for <lists+netdev@lfdr.de>; Thu, 30 May 2019 15:11:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726169AbfE3NLV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 May 2019 09:11:21 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:43120 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725919AbfE3NLV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 May 2019 09:11:21 -0400
Received: by mail-wr1-f66.google.com with SMTP id l17so4167545wrm.10
        for <netdev@vger.kernel.org>; Thu, 30 May 2019 06:11:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=scYQ0YPJ1/xbxQ2frmme5VZ7khF5LrWnZLb953uibc4=;
        b=i3b871214h7UHV+wurAiegDAhm6uq4FBUY3NnYr7jG1Z8ucNQOwoYjd5NBdKnhmpL6
         hi4qCmiAzlePbrdnfyQE5CYFcN1Dlx8A7Hk41usnifk4DnVnZ7NUnZKgjbQ8omNAFc0t
         En9/gbQkhHOVZ3UEX0HTOxWuSu7iDus2kn78sDNO76cEWlr6TMc++K/DeDw7UfSzbcn2
         fVhcYFyTBZQHP7e11QaYbJ2rHVN21STqgB5JqhA8vcQF5DCPt4DyNGlnzSee2WRaF/BL
         JyhOEFnRhDzlJYqxDY7DQ5XFi7hJYcQ2jtU9TJXBoBx5Ayb6uGw5X0a2HmzIoHoKc1g1
         pfkw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=scYQ0YPJ1/xbxQ2frmme5VZ7khF5LrWnZLb953uibc4=;
        b=uj/FBz4E3xcoBWuDnk40CEOREFQhhe4iz2oTwlES51g5Q78aQZ21IlXqXU4XiitDHB
         fTvuTzfw+oNZuRfBqbu8t1AUDWTG0eoGpxMSny4si95xW9JCXBuM+M8n6neP7hU6u1yw
         /SG9KSsndJkLrKYeS5MnDoVIRn/vCXsozTLH5ngwJlV/ATy/gtLD8mnym2FPd95cn0gQ
         9EMM/Fss3lC7GHmbYZEtiFBVTwCtI7CouDz7L7n99QDSwFrWKXTkjqPWQr+mrCeRcmcz
         Jc9gfo4q/oDZvZMkvK0b2TA91iSx9uqHy8IN0LR0iXtIXCjB26vovT1OfUcrjwwGCCVY
         Nbyw==
X-Gm-Message-State: APjAAAUb5/dK4mHxH0RDC9VmPbARE1KbWFdvygkzOExN5aQgo2yho+Bl
        iYaBGB92iOeBW0uayZFZjOIAx4dq
X-Google-Smtp-Source: APXvYqwq7nsntsMQpkfSmnn/lG/EIgQ2ACF/5lZL1qhZfOpSGsWGV9aUKJKHP9FVu4Vaeg84fDu1zA==
X-Received: by 2002:a5d:4f0a:: with SMTP id c10mr2596714wru.180.1559221878900;
        Thu, 30 May 2019 06:11:18 -0700 (PDT)
Received: from ?IPv6:2003:ea:8bf3:bd00:7d95:5542:24c5:5635? (p200300EA8BF3BD007D95554224C55635.dip0.t-ipconnect.de. [2003:ea:8bf3:bd00:7d95:5542:24c5:5635])
        by smtp.googlemail.com with ESMTPSA id u9sm7031947wme.48.2019.05.30.06.11.18
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 30 May 2019 06:11:18 -0700 (PDT)
Subject: [PATCH net-next v2 1/3] net: phy: enable interrupts when PHY is
 attached already
From:   Heiner Kallweit <hkallweit1@gmail.com>
To:     Russell King - ARM Linux <linux@armlinux.org.uk>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        David Miller <davem@davemloft.net>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <52f1a566-9c1d-2a3d-ce7b-e9284eed65cb@gmail.com>
Message-ID: <883a0161-0c16-d538-464e-ee35348c9970@gmail.com>
Date:   Thu, 30 May 2019 15:09:15 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <52f1a566-9c1d-2a3d-ce7b-e9284eed65cb@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch is a step towards allowing PHY drivers to handle more
interrupt sources than just link change. E.g. several PHY's have
built-in temperature monitoring and can raise an interrupt if a
temperature threshold is exceeded. We may be interested in such
interrupts also if the phylib state machine isn't started.
Therefore move enabling interrupts to phy_request_interrupt().

v2:
- patch added to series

Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
 drivers/net/phy/phy.c        | 36 ++++++++++++++++++++++--------------
 drivers/net/phy/phy_device.c |  2 +-
 include/linux/phy.h          |  1 +
 3 files changed, 24 insertions(+), 15 deletions(-)

diff --git a/drivers/net/phy/phy.c b/drivers/net/phy/phy.c
index e88854292..d90d9863e 100644
--- a/drivers/net/phy/phy.c
+++ b/drivers/net/phy/phy.c
@@ -799,10 +799,10 @@ static int phy_enable_interrupts(struct phy_device *phydev)
 }
 
 /**
- * phy_request_interrupt - request interrupt for a PHY device
+ * phy_request_interrupt - request and enable interrupt for a PHY device
  * @phydev: target phy_device struct
  *
- * Description: Request the interrupt for the given PHY.
+ * Description: Request and enable the interrupt for the given PHY.
  *   If this fails, then we set irq to PHY_POLL.
  *   This should only be called with a valid IRQ number.
  */
@@ -817,10 +817,30 @@ void phy_request_interrupt(struct phy_device *phydev)
 		phydev_warn(phydev, "Error %d requesting IRQ %d, falling back to polling\n",
 			    err, phydev->irq);
 		phydev->irq = PHY_POLL;
+	} else {
+		if (phy_enable_interrupts(phydev)) {
+			phydev_warn(phydev, "Can't enable interrupt, falling back to polling\n");
+			phy_free_interrupt(phydev);
+			phydev->irq = PHY_POLL;
+		}
 	}
 }
 EXPORT_SYMBOL(phy_request_interrupt);
 
+/**
+ * phy_free_interrupt - disable and free interrupt for a PHY device
+ * @phydev: target phy_device struct
+ *
+ * Description: Disable and free the interrupt for the given PHY.
+ *   This should only be called with a valid IRQ number.
+ */
+void phy_free_interrupt(struct phy_device *phydev)
+{
+	phy_disable_interrupts(phydev);
+	free_irq(phydev->irq, phydev);
+}
+EXPORT_SYMBOL(phy_free_interrupt);
+
 /**
  * phy_stop - Bring down the PHY link, and stop checking the status
  * @phydev: target phy_device struct
@@ -835,9 +855,6 @@ void phy_stop(struct phy_device *phydev)
 
 	mutex_lock(&phydev->lock);
 
-	if (phy_interrupt_is_valid(phydev))
-		phy_disable_interrupts(phydev);
-
 	phydev->state = PHY_HALTED;
 
 	mutex_unlock(&phydev->lock);
@@ -864,8 +881,6 @@ EXPORT_SYMBOL(phy_stop);
  */
 void phy_start(struct phy_device *phydev)
 {
-	int err;
-
 	mutex_lock(&phydev->lock);
 
 	if (phydev->state != PHY_READY && phydev->state != PHY_HALTED) {
@@ -877,13 +892,6 @@ void phy_start(struct phy_device *phydev)
 	/* if phy was suspended, bring the physical link up again */
 	__phy_resume(phydev);
 
-	/* make sure interrupts are enabled for the PHY */
-	if (phy_interrupt_is_valid(phydev)) {
-		err = phy_enable_interrupts(phydev);
-		if (err < 0)
-			goto out;
-	}
-
 	phydev->state = PHY_UP;
 
 	phy_start_machine(phydev);
diff --git a/drivers/net/phy/phy_device.c b/drivers/net/phy/phy_device.c
index 5d288da9a..d71b3ed52 100644
--- a/drivers/net/phy/phy_device.c
+++ b/drivers/net/phy/phy_device.c
@@ -1013,7 +1013,7 @@ void phy_disconnect(struct phy_device *phydev)
 		phy_stop(phydev);
 
 	if (phy_interrupt_is_valid(phydev))
-		free_irq(phydev->irq, phydev);
+		phy_free_interrupt(phydev);
 
 	phydev->adjust_link = NULL;
 
diff --git a/include/linux/phy.h b/include/linux/phy.h
index 7180b1d1e..72e1196f9 100644
--- a/include/linux/phy.h
+++ b/include/linux/phy.h
@@ -1147,6 +1147,7 @@ int phy_ethtool_ksettings_set(struct phy_device *phydev,
 			      const struct ethtool_link_ksettings *cmd);
 int phy_mii_ioctl(struct phy_device *phydev, struct ifreq *ifr, int cmd);
 void phy_request_interrupt(struct phy_device *phydev);
+void phy_free_interrupt(struct phy_device *phydev);
 void phy_print_status(struct phy_device *phydev);
 int phy_set_max_speed(struct phy_device *phydev, u32 max_speed);
 void phy_remove_link_mode(struct phy_device *phydev, u32 link_mode);
-- 
2.21.0


