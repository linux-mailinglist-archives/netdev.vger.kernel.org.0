Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5FA501874C3
	for <lists+netdev@lfdr.de>; Mon, 16 Mar 2020 22:33:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732680AbgCPVdl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Mar 2020 17:33:41 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:35426 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732636AbgCPVdk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Mar 2020 17:33:40 -0400
Received: by mail-wr1-f65.google.com with SMTP id h4so2509202wru.2
        for <netdev@vger.kernel.org>; Mon, 16 Mar 2020 14:33:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=6EFTP0viKw0Gb0b+qTy6njKf3C+bRV41GZc1EYQxYXE=;
        b=PU6AuBmaeUS0FbpCLRe1d0OG32FHY1xu2xVKC4io0ib82/4g9ubMShig9gB6ZJmRUh
         dajzCp82m+l7HyrBTxUprHMBqp89/3+PRqVgxDME+/EJ6ji81VZltyMfOnfXLujc2RUj
         VDxKuXKw0ZcjxeC0FtgiqFS1Z03kUJdcLkPNp5lA0kCGflHSWcu4FaaEqM7UICir1XeM
         EkYiXRTF1dBlO+qFf2omphrl2H7XMY1oO3xF/9Kq6taoHRkV2UGtSjp4OjQlyePHfHPc
         /A2DoKOHXUumnyxczdKh1w3F1fufr+6P85H7xhJUjVMIOgT+M889ogFqnPJ9iarl/kTW
         sulw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=6EFTP0viKw0Gb0b+qTy6njKf3C+bRV41GZc1EYQxYXE=;
        b=D5B9H5djFOZdOqK8t35BMwnhTyNH0gb19S7LDILVRHMjc3odQQ0+zEGY77XDJnHa2A
         xVWULxkwzEB4AKxz+kei5YEobSaDhqSJwUgeaOtxg5h9r6V2BCFCR5pEOcEY/zeQQ1zy
         pz1ItZdM1/Qhgk9YneyRpe+e7UDqcAR2WE+9buN2j4twAIggxOagqe/fT2Sg07QUMF6h
         nSz1KfYzBT4gs6x1PmZ1kqAThotqXl0JZKnDsoDglsiLCJhkYQM0WtDHplbgFaAUdq9e
         +rY/FHVTOkGPUsehMvPctTnziXHNC+iQmwP0Ngm2vFljed6jtcZ3I/gNxmaMi/X8vy8m
         KuIw==
X-Gm-Message-State: ANhLgQ090nvRjc3qrGIW++dmPjaHU9caSw5mz7ErZIUBV0qQuAqFru+R
        z2pV1oATLbz/io4dsUuDK3tTkbEo
X-Google-Smtp-Source: ADFU+vu7Ax3a+NIaU8knyccyuS75YiitSK9/QMkvfYOXHkW7B7bSAUBsMlFesootWZngS82WKAqgtQ==
X-Received: by 2002:a05:6000:128a:: with SMTP id f10mr487103wrx.242.1584394417742;
        Mon, 16 Mar 2020 14:33:37 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f29:6000:1dfa:b5c5:6377:a256? (p200300EA8F2960001DFAB5C56377A256.dip0.t-ipconnect.de. [2003:ea:8f29:6000:1dfa:b5c5:6377:a256])
        by smtp.googlemail.com with ESMTPSA id l26sm1135502wmi.37.2020.03.16.14.33.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 16 Mar 2020 14:33:37 -0700 (PDT)
Subject: [PATCH net-next 1/2] net: phy: improve phy_driver callback
 handle_interrupt
From:   Heiner Kallweit <hkallweit1@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Russell King - ARM Linux <linux@armlinux.org.uk>,
        David Miller <davem@davemloft.net>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <49afbad9-317a-3eff-3692-441fae3c4f49@gmail.com>
Message-ID: <c5f54146-a9e3-7143-5df9-5f04738e37f9@gmail.com>
Date:   Mon, 16 Mar 2020 22:32:33 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <49afbad9-317a-3eff-3692-441fae3c4f49@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

did_interrupt() clears the interrupt, therefore handle_interrupt() can
not check which event triggered the interrupt. To overcome this
constraint and allow more flexibility for customer interrupt handlers,
let's decouple handle_interrupt() from parts of the phylib interrupt
handling. Custom interrupt handlers now have to implement the
did_interrupt() functionality in handle_interrupt() if needed.

Fortunately we have just one custom interrupt handler so far (in the
mscc PHY driver), convert it to the changed API.

Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
 drivers/net/phy/mscc/mscc_main.c | 11 +++++++++--
 drivers/net/phy/phy.c            | 26 ++++++++++++--------------
 include/linux/phy.h              |  3 ++-
 3 files changed, 23 insertions(+), 17 deletions(-)

diff --git a/drivers/net/phy/mscc/mscc_main.c b/drivers/net/phy/mscc/mscc_main.c
index cb4d65f81..4727aba8e 100644
--- a/drivers/net/phy/mscc/mscc_main.c
+++ b/drivers/net/phy/mscc/mscc_main.c
@@ -1429,11 +1429,18 @@ static int vsc8584_config_init(struct phy_device *phydev)
 	return ret;
 }
 
-static int vsc8584_handle_interrupt(struct phy_device *phydev)
+static irqreturn_t vsc8584_handle_interrupt(struct phy_device *phydev)
 {
+	int irq_status;
+
+	irq_status = phy_read(phydev, MII_VSC85XX_INT_STATUS);
+	if (irq_status < 0 || !(irq_status & MII_VSC85XX_INT_MASK_MASK))
+		return IRQ_NONE;
+
 	vsc8584_handle_macsec_interrupt(phydev);
 	phy_mac_interrupt(phydev);
-	return 0;
+
+	return IRQ_HANDLED;
 }
 
 static int vsc85xx_config_init(struct phy_device *phydev)
diff --git a/drivers/net/phy/phy.c b/drivers/net/phy/phy.c
index 355bfdef4..d71212a41 100644
--- a/drivers/net/phy/phy.c
+++ b/drivers/net/phy/phy.c
@@ -715,26 +715,24 @@ static int phy_disable_interrupts(struct phy_device *phydev)
 static irqreturn_t phy_interrupt(int irq, void *phy_dat)
 {
 	struct phy_device *phydev = phy_dat;
+	struct phy_driver *drv = phydev->drv;
 
-	if (phydev->drv->did_interrupt && !phydev->drv->did_interrupt(phydev))
+	if (drv->handle_interrupt)
+		return drv->handle_interrupt(phydev);
+
+	if (drv->did_interrupt && !drv->did_interrupt(phydev))
 		return IRQ_NONE;
 
-	if (phydev->drv->handle_interrupt) {
-		if (phydev->drv->handle_interrupt(phydev))
-			goto phy_err;
-	} else {
-		/* reschedule state queue work to run as soon as possible */
-		phy_trigger_machine(phydev);
-	}
+	/* reschedule state queue work to run as soon as possible */
+	phy_trigger_machine(phydev);
 
 	/* did_interrupt() may have cleared the interrupt already */
-	if (!phydev->drv->did_interrupt && phy_clear_interrupt(phydev))
-		goto phy_err;
-	return IRQ_HANDLED;
+	if (!drv->did_interrupt && phy_clear_interrupt(phydev)) {
+		phy_error(phydev);
+		return IRQ_NONE;
+	}
 
-phy_err:
-	phy_error(phydev);
-	return IRQ_NONE;
+	return IRQ_HANDLED;
 }
 
 /**
diff --git a/include/linux/phy.h b/include/linux/phy.h
index 6b872aed8..cb5a2182b 100644
--- a/include/linux/phy.h
+++ b/include/linux/phy.h
@@ -23,6 +23,7 @@
 #include <linux/workqueue.h>
 #include <linux/mod_devicetable.h>
 #include <linux/u64_stats_sync.h>
+#include <linux/irqreturn.h>
 
 #include <linux/atomic.h>
 
@@ -568,7 +569,7 @@ struct phy_driver {
 	int (*did_interrupt)(struct phy_device *phydev);
 
 	/* Override default interrupt handling */
-	int (*handle_interrupt)(struct phy_device *phydev);
+	irqreturn_t (*handle_interrupt)(struct phy_device *phydev);
 
 	/* Clears up any memory if needed */
 	void (*remove)(struct phy_device *phydev);
-- 
2.25.1


