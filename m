Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E0FCE2BA25
	for <lists+netdev@lfdr.de>; Mon, 27 May 2019 20:30:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727278AbfE0SaB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 May 2019 14:30:01 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:43144 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726817AbfE0SaB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 May 2019 14:30:01 -0400
Received: by mail-wr1-f66.google.com with SMTP id l17so9258565wrm.10
        for <netdev@vger.kernel.org>; Mon, 27 May 2019 11:30:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=L4qDQe0zYHM+VHmLAM9XhTqyI6nxDjIEUrJxqC86zJ8=;
        b=AwZiNJcwBUOwFwWJQYP369hUjGbKHM3RMBZcMpHsCe1jcc4kBkmWSCf29r4s0redEp
         USvwA5StwmoGjCjyK6FAX2QgfDVi3Fkacgne8RylOPeJdSnPefQ552Cp0IICeEGhQb3C
         ip0MhMdBmYf9yjoMVc9m9dyL4+eUE0tZF35GwMgMiB2gsbRfe+F6bTozXaarC10MPHb0
         Q0HkRVAyUuiI8RScsrJSFJN+nJOWDmcAtf5UnSOnJbChrOVFOtZ8T6LqGkg+3hkiDP5/
         4xctjbvAQNkwfF8s63hqpQlWaK84inhAHGCU3LpQMEcYQ+20CEY6Z7/4GSvSz0pvOKs1
         hRVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=L4qDQe0zYHM+VHmLAM9XhTqyI6nxDjIEUrJxqC86zJ8=;
        b=Bku0zrMSqaUSZsHh3GnTKyTcISX8xFYd/BDycVL6/0t+Vh45+67LbdLJ1GiVX1Wi0m
         m5SROwI6kP92S9ZY8bCq8HCG5QY8wLYCr8qXqQdcFXylWesYMxzbmOWYz7GBfCBAnVXE
         LJTAfuo88J22l1wZkbHKSvXJEgDpqmGIJye3efoT0zGXek7n9CwuxhDTtmRvXb+zKY3x
         AqF1c5jZAqaLi61/6RXlYrG8mUVKsonuNOtI1RkWOAY0XV14fxXC404sEHQvKLFh7gYW
         eWOlokTgm/1M2MXvUD1KfiVNzNncy66cN6n/IH4bYTYqBlOgXnToxm/JRGMFAZx4Lw0o
         iYdg==
X-Gm-Message-State: APjAAAXFnzxKTrRnWVjBxM32vn+qShAn68N7ZHoYeawgRr3TJJtA1eac
        uOxJwpjJxa0iQIM47CmUNddmG6p0
X-Google-Smtp-Source: APXvYqxBnZyrRqG/79khX0GPvSJ1fGdqGWb2iixS7qkY7mqIM+mV7l0oCBlbrH3AiKQxT4lXSnjdBg==
X-Received: by 2002:a5d:45c4:: with SMTP id b4mr11388480wrs.291.1558981799147;
        Mon, 27 May 2019 11:29:59 -0700 (PDT)
Received: from ?IPv6:2003:ea:8be9:7a00:485f:6c34:28a2:1d35? (p200300EA8BE97A00485F6C3428A21D35.dip0.t-ipconnect.de. [2003:ea:8be9:7a00:485f:6c34:28a2:1d35])
        by smtp.googlemail.com with ESMTPSA id x21sm742647wmi.1.2019.05.27.11.29.58
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 27 May 2019 11:29:58 -0700 (PDT)
Subject: [PATCH net-next 2/3] net: phy: add callback for custom interrupt
 handler to struct phy_driver
From:   Heiner Kallweit <hkallweit1@gmail.com>
To:     Russell King - ARM Linux <linux@armlinux.org.uk>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        David Miller <davem@davemloft.net>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <e3ce708d-d841-bd7e-30bb-bff37f3b89ac@gmail.com>
Message-ID: <9929ba89-5ca0-97bf-7547-72c193866051@gmail.com>
Date:   Mon, 27 May 2019 20:28:48 +0200
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

The phylib interrupt handler handles link change events only currently.
However PHY drivers may want to use other interrupt sources too,
e.g. to report temperature monitoring events. Therefore add a callback
to struct phy_driver allowing PHY drivers to implement a custom
interrupt handler.

Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
Suggested-by: Russell King - ARM Linux admin <linux@armlinux.org.uk>
---
 drivers/net/phy/phy.c | 9 +++++++--
 include/linux/phy.h   | 3 +++
 2 files changed, 10 insertions(+), 2 deletions(-)

diff --git a/drivers/net/phy/phy.c b/drivers/net/phy/phy.c
index 20955836c..8030d0a97 100644
--- a/drivers/net/phy/phy.c
+++ b/drivers/net/phy/phy.c
@@ -774,8 +774,13 @@ static irqreturn_t phy_interrupt(int irq, void *phy_dat)
 	if (phydev->drv->did_interrupt && !phydev->drv->did_interrupt(phydev))
 		return IRQ_NONE;
 
-	/* reschedule state queue work to run as soon as possible */
-	phy_trigger_machine(phydev);
+	if (phydev->drv->handle_interrupt) {
+		if (phydev->drv->handle_interrupt(phydev))
+			goto phy_err;
+	} else {
+		/* reschedule state queue work to run as soon as possible */
+		phy_trigger_machine(phydev);
+	}
 
 	if (phy_clear_interrupt(phydev))
 		goto phy_err;
diff --git a/include/linux/phy.h b/include/linux/phy.h
index b133d59f3..f90158c67 100644
--- a/include/linux/phy.h
+++ b/include/linux/phy.h
@@ -536,6 +536,9 @@ struct phy_driver {
 	 */
 	int (*did_interrupt)(struct phy_device *phydev);
 
+	/* Override default interrupt handling */
+	int (*handle_interrupt)(struct phy_device *phydev);
+
 	/* Clears up any memory if needed */
 	void (*remove)(struct phy_device *phydev);
 
-- 
2.21.0


