Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E5D72161C58
	for <lists+netdev@lfdr.de>; Mon, 17 Feb 2020 21:36:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729704AbgBQUgQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Feb 2020 15:36:16 -0500
Received: from mail-wr1-f65.google.com ([209.85.221.65]:33760 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726704AbgBQUgQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Feb 2020 15:36:16 -0500
Received: by mail-wr1-f65.google.com with SMTP id u6so21387750wrt.0
        for <netdev@vger.kernel.org>; Mon, 17 Feb 2020 12:36:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=DM8gQ16zXxjcv78bLeMiohi1JWfYnCm2aXL229wXgVI=;
        b=ulJyPbH8hq5M+K3uKfT5JMOUDj1oFCk3jXgbzX9CbCjl4qH8Cc8vHAcCcXFzrCDAmn
         aYWrDpTMH6cw8HGo6FiYz5FQP/SvBS7fim+9QbylWpj+VM2lmMJ7BwOVyvN99r2lIaCD
         PSHItWm6OxBaCsLWmWqXABnqKh9zt31anphVW9esoVfBFgSW55yZbeejjFys1XUEWqd0
         dtUTU6oLzadb/kWBqXROYr+zcOTkhslkknMUD4t6TRv0XVpYMx0KJuoha593ygSJrFa6
         oKGYInsHCkChw2h6JcjozOYokNzuXp28CDT07bL3HXnj+o+yFdsG64r4W8JAucqJIAxM
         dyPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=DM8gQ16zXxjcv78bLeMiohi1JWfYnCm2aXL229wXgVI=;
        b=sxdoEkGBgVouIIZcLvRY7n5j4/DrlHRcc1wrBUYaaRw4PJ5g6S7ad6eX0PIQjFt717
         MHGjWJSlKL5Fl1j5A1GMQdz4pUFsqMFs84neyEz+R/nKBtA5cZ2RleOqrQmM1AZRSw4O
         D9c7JM0+v6zZewRjwDCoxe7wEVJ3eH7/6YIw+RP489FzSV6gnJR/raOXPBgD7Cnn6xcn
         NfAo2EnBT/KdxBZfetBR5FanyeB9o6UJYG9nzkpDbQ16LUTvIFowBYo4yRA3LNRrgPAG
         sxT+kP5ZUjkFhR+GIgkWI3xKYTIuHJ+DGqHAmU0dlG9N2DRw45igKZ+qZ+PlMd/dhh3G
         mUxw==
X-Gm-Message-State: APjAAAXCserLDR89MV48Uaa1KFnUM9Cl/6kx4KhjizyRp/O/LTVYWaj0
        BkPzwDLbBtlsOiiL7PxBSxos10iv
X-Google-Smtp-Source: APXvYqwpsemn27x8QlPQYdG7sMVzusNs8m6bEHy0//Ra/piLkiE7fWf+aY3YV1UUzrH+rBRSOKBa+g==
X-Received: by 2002:adf:dd8a:: with SMTP id x10mr25108182wrl.117.1581971774507;
        Mon, 17 Feb 2020 12:36:14 -0800 (PST)
Received: from ?IPv6:2003:ea:8f29:6000:41c6:31a6:d880:888? (p200300EA8F29600041C631A6D8800888.dip0.t-ipconnect.de. [2003:ea:8f29:6000:41c6:31a6:d880:888])
        by smtp.googlemail.com with ESMTPSA id l2sm740869wme.1.2020.02.17.12.36.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 17 Feb 2020 12:36:14 -0800 (PST)
Subject: [PATCH net-next 1/2] net: phy: unregister MDIO bus in
 _devm_mdiobus_free if needed
From:   Heiner Kallweit <hkallweit1@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Russell King - ARM Linux <linux@armlinux.org.uk>,
        David Miller <davem@davemloft.net>,
        Realtek linux nic maintainers <nic_swsd@realtek.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <15ee7621-0e74-a3c1-0778-ca4fa6c2e3c6@gmail.com>
Message-ID: <913abdae-0617-b411-7eaa-599588f95e32@gmail.com>
Date:   Mon, 17 Feb 2020 21:34:57 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <15ee7621-0e74-a3c1-0778-ca4fa6c2e3c6@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If using managed MDIO bus handling (devm_mdiobus_alloc et al) we still
have to manually unregister the MDIO bus. For drivers that don't depend
on unregistering the MDIO bus at a specific, earlier point in time we
can make driver author's life easier by automagically unregistering
the MDIO bus. This extension is transparent to existing drivers.

Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
 drivers/net/phy/mdio_bus.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/net/phy/mdio_bus.c b/drivers/net/phy/mdio_bus.c
index 9bb9f37f2..6af51cbdb 100644
--- a/drivers/net/phy/mdio_bus.c
+++ b/drivers/net/phy/mdio_bus.c
@@ -170,7 +170,12 @@ EXPORT_SYMBOL(mdiobus_alloc_size);
 
 static void _devm_mdiobus_free(struct device *dev, void *res)
 {
-	mdiobus_free(*(struct mii_bus **)res);
+	struct mii_bus *bus = *(struct mii_bus **)res;
+
+	if (bus->state == MDIOBUS_REGISTERED)
+		mdiobus_unregister(bus);
+
+	mdiobus_free(bus);
 }
 
 static int devm_mdiobus_match(struct device *dev, void *res, void *data)
-- 
2.25.0


