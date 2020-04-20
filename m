Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 962841B1877
	for <lists+netdev@lfdr.de>; Mon, 20 Apr 2020 23:30:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726679AbgDTVaD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Apr 2020 17:30:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59888 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726017AbgDTVaD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Apr 2020 17:30:03 -0400
Received: from mail-wr1-x444.google.com (mail-wr1-x444.google.com [IPv6:2a00:1450:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D9EF4C061A0C
        for <netdev@vger.kernel.org>; Mon, 20 Apr 2020 14:30:01 -0700 (PDT)
Received: by mail-wr1-x444.google.com with SMTP id u13so14041360wrp.3
        for <netdev@vger.kernel.org>; Mon, 20 Apr 2020 14:30:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=QdHpGUAL8RwiD5RDXG+jB/gLFUGiEc9a1TWH4G+ztzs=;
        b=vhGUNVYpED0EJlfXfunGGVmRP6SURn9vX80kIwNYteAGzoY1un9hlJjyVhYY0OTIrp
         p0BgOA4QjAcG+jS/OY0RPu7TT3RPIzzTCljslJ42krKrl31S8AdBOjSbQpuf9Ypkkevr
         jGuZEaieHYBax4/NWomHWvVqMDUSqBL15EefyLcR2McwhG1BFDrPG3gtsgIJNuXXYhMA
         ShhXN5Iw7/KEe04NOj4pgAatiYfcwf2Vv7uHjicn5CLPwAa8E0A/Q1N2O/kqVfIMZJW4
         dnlbyIVcr7DQlSqhAIZunPKmg43u5YN6dDbhNDynu8pzFFgn0obcbGNv6/Yn9fCQRi4S
         8HuA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=QdHpGUAL8RwiD5RDXG+jB/gLFUGiEc9a1TWH4G+ztzs=;
        b=nHq6BgpcDZ691eoU+nFs1MGwd4g4NZQMhKdjbHBPdgDYkdH991jqze+K/F3p4g/piN
         o9bFc3t0sVx2iRZmoXvmLsOOnYennPZXPBkzlvnaKX7n6zJ7vNsV3pGWy7m5H5qa7WMy
         XIbG+TNOd9ozg/VzbX+y9da16IfKhNknvYc+9WvOXUxDXo1ozlsEXj8KGvDVTypio9Sa
         +/x0ZJP6UEhvpIcEbn00nSHB2RSuHTDSuCOti7zWMM5JRWdXWNMQyp4pJUMCaBlvH5lT
         ywpKXbBw1s4VmSfvi/g2jM7c792xNrd42/Ea6BAHHnCyZ4wexPyqR4ZupB12T95sq8Ck
         DK2g==
X-Gm-Message-State: AGi0PuZdq8XHNxM1uG+Ln6rvXXH8BY1ou1ncTXCXPJeBoyKLFGUK4dwr
        B7NyKC/t25ySHA+V2irz1/tIUuHj
X-Google-Smtp-Source: APiQypIgc+aQ6EqQ7YRM8T1i2zaa40+HtXH121JXS2PdXFRnFByGdBodfmeeBSKAdfVVM+7k+Eo+Dw==
X-Received: by 2002:adf:e3c2:: with SMTP id k2mr20073071wrm.287.1587418200396;
        Mon, 20 Apr 2020 14:30:00 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f29:6000:7101:507:3ef2:1ef1? (p200300EA8F296000710105073EF21EF1.dip0.t-ipconnect.de. [2003:ea:8f29:6000:7101:507:3ef2:1ef1])
        by smtp.googlemail.com with ESMTPSA id l19sm845133wmj.14.2020.04.20.14.29.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 20 Apr 2020 14:29:59 -0700 (PDT)
Subject: [PATCH net-next 1/2] net: phy: add device-managed
 devm_mdiobus_register
From:   Heiner Kallweit <hkallweit1@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        David Miller <davem@davemloft.net>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <9b83837d-d246-ffb0-0c52-8d4c5064e7e4@gmail.com>
Message-ID: <1b4d4d38-4bb3-af3d-76d0-7526d67a2a9d@gmail.com>
Date:   Mon, 20 Apr 2020 23:29:05 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <9b83837d-d246-ffb0-0c52-8d4c5064e7e4@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If there's no special ordering requirement for mdiobus_unregister(),
then driver code can be simplified by using a device-managed version
of mdiobus_register(). Prerequisite is that bus allocation has been
done device-managed too. Else mdiobus_free() may be called whilst
bus is still registered, resulting in a BUG_ON(). Therefore let
devm_mdiobus_register() return -EPERM if bus was allocated
non-managed.

Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
 drivers/net/phy/mdio_bus.c |  8 +++++++-
 include/linux/phy.h        | 17 +++++++++++++++++
 2 files changed, 24 insertions(+), 1 deletion(-)

diff --git a/drivers/net/phy/mdio_bus.c b/drivers/net/phy/mdio_bus.c
index 7a4eb3f2c..77f647873 100644
--- a/drivers/net/phy/mdio_bus.c
+++ b/drivers/net/phy/mdio_bus.c
@@ -170,7 +170,12 @@ EXPORT_SYMBOL(mdiobus_alloc_size);
 
 static void _devm_mdiobus_free(struct device *dev, void *res)
 {
-	mdiobus_free(*(struct mii_bus **)res);
+	struct mii_bus *bus = *(struct mii_bus **)res;
+
+	if (bus->is_managed_registered && bus->state == MDIOBUS_REGISTERED)
+		mdiobus_unregister(bus);
+
+	mdiobus_free(bus);
 }
 
 static int devm_mdiobus_match(struct device *dev, void *res, void *data)
@@ -210,6 +215,7 @@ struct mii_bus *devm_mdiobus_alloc_size(struct device *dev, int sizeof_priv)
 	if (bus) {
 		*ptr = bus;
 		devres_add(dev, ptr);
+		bus->is_managed = 1;
 	} else {
 		devres_free(ptr);
 	}
diff --git a/include/linux/phy.h b/include/linux/phy.h
index 2432ca463..3941a6bcb 100644
--- a/include/linux/phy.h
+++ b/include/linux/phy.h
@@ -241,6 +241,9 @@ struct mii_bus {
 	int (*reset)(struct mii_bus *bus);
 	struct mdio_bus_stats stats[PHY_MAX_ADDR];
 
+	unsigned int is_managed:1;	/* is device-managed */
+	unsigned int is_managed_registered:1;
+
 	/*
 	 * A lock to ensure that only one thing can read/write
 	 * the MDIO bus at a time
@@ -286,6 +289,20 @@ static inline struct mii_bus *mdiobus_alloc(void)
 
 int __mdiobus_register(struct mii_bus *bus, struct module *owner);
 #define mdiobus_register(bus) __mdiobus_register(bus, THIS_MODULE)
+static inline int devm_mdiobus_register(struct mii_bus *bus)
+{
+	int ret;
+
+	if (!bus->is_managed)
+		return -EPERM;
+
+	ret = mdiobus_register(bus);
+	if (!ret)
+		bus->is_managed_registered = 1;
+
+	return ret;
+}
+
 void mdiobus_unregister(struct mii_bus *bus);
 void mdiobus_free(struct mii_bus *bus);
 struct mii_bus *devm_mdiobus_alloc_size(struct device *dev, int sizeof_priv);
-- 
2.26.1


