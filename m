Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 73AF8368AB6
	for <lists+netdev@lfdr.de>; Fri, 23 Apr 2021 04:09:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240299AbhDWBtm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Apr 2021 21:49:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44666 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240296AbhDWBtC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Apr 2021 21:49:02 -0400
Received: from mail-ej1-x634.google.com (mail-ej1-x634.google.com [IPv6:2a00:1450:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 88582C06134E;
        Thu, 22 Apr 2021 18:48:08 -0700 (PDT)
Received: by mail-ej1-x634.google.com with SMTP id sd23so62961764ejb.12;
        Thu, 22 Apr 2021 18:48:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=45/h3np2XdosMRdyfP66Wi+ituKDQEn8bMrDLXmNq0g=;
        b=rc7ijcAbQO9NO1vJmxagYi6OfZ2wRxmgu9EnIDU5lIdVpVmrTnG/0xCDOf73b66D3K
         UplIdazdm4iZuO4AG2bqOcS0mnSbIGrLIepm+pHar+3dA+64wfZ5UrleelORW1ixKCle
         GZ0anjRgXTHjjUXylpbdju61u4krYfli7DNDvmqwM7qB/TdOS4EHOb5ip69wbgP+QTMs
         ubb6619BbyivziZcPKZg1c/2Qbv26/4Oc1gzMsJXnBS5ecNHA4AECzl/WUXwTzuOPBYn
         2J6p+Gxv2Lu0UjZnZ/Bc5VWHcwubV9pD9es+aDYv2pFmlD8t1WNTWRys70qvI8Klot3k
         ydBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=45/h3np2XdosMRdyfP66Wi+ituKDQEn8bMrDLXmNq0g=;
        b=Op9l9YDzTZa/1eKzf8qhe1H5S/Z8VUFCxidLaZ1H0YOtY2UStDUgUEcyIUbu5YDTBy
         IO8OHdEebp+hKumts8Fhej++7CKvVwrUt0T7rEgSXPw9baw4Bzf4HQ1W8ezRgakFZI/G
         +J+8F+W3W0SBNc+aZtUyycl1PKdr8y7SAJFC/z5cR1ijeqT24uJ88RBP3trvvMS/yIbn
         v19Hu+06kzRFkbOHoFetyQOUFhNzWG5WHTfZ6O24/cXWNa2JW5Rk8muG+cYo/FZwV463
         KShXQIADfzzfD0fRqVcqY7of86n4TGs8WUlKp5Erl5jdc+SuvDZC+ltjk7xUPoM5kSYY
         zKOA==
X-Gm-Message-State: AOAM531XXVZNgs2fj5E38WEHXqstUjoHxtHeJyLG6+clXJHSHsB7Nlch
        1jKDxlfbS7JfxB9OS7zIito=
X-Google-Smtp-Source: ABdhPJx/rZege13ZdgX3GLanO7xwOucQ9ydaRXt0nu7Ywjrz+rDvEBeotHwCmoIjii9TpAw4d+kpqQ==
X-Received: by 2002:a17:906:c34d:: with SMTP id ci13mr1541319ejb.430.1619142487237;
        Thu, 22 Apr 2021 18:48:07 -0700 (PDT)
Received: from Ansuel-xps.localdomain (93-35-189-2.ip56.fastwebnet.it. [93.35.189.2])
        by smtp.googlemail.com with ESMTPSA id t4sm3408635edd.6.2021.04.22.18.48.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 Apr 2021 18:48:06 -0700 (PDT)
From:   Ansuel Smith <ansuelsmth@gmail.com>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     Ansuel Smith <ansuelsmth@gmail.com>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 10/14] drivers: net: dsa: qca8k: add support for specific QCA access function
Date:   Fri, 23 Apr 2021 03:47:36 +0200
Message-Id: <20210423014741.11858-11-ansuelsmth@gmail.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210423014741.11858-1-ansuelsmth@gmail.com>
References: <20210423014741.11858-1-ansuelsmth@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Some qca8k switch revision require some special dbg value to be set
based on the revision number. Add required function to write and read in
these specific registers.

Signed-off-by: Ansuel Smith <ansuelsmth@gmail.com>
---
 drivers/net/dsa/qca8k.c | 51 +++++++++++++++++++++++++++++++++++++++++
 drivers/net/dsa/qca8k.h |  2 ++
 2 files changed, 53 insertions(+)

diff --git a/drivers/net/dsa/qca8k.c b/drivers/net/dsa/qca8k.c
index 20b507a35191..193c269d8ed3 100644
--- a/drivers/net/dsa/qca8k.c
+++ b/drivers/net/dsa/qca8k.c
@@ -69,6 +69,57 @@ static const struct qca8k_mib_desc ar8327_mib[] = {
 	MIB_DESC(1, 0xa4, "TxLateCol"),
 };
 
+/* QCA specific MII registers access function */
+void qca8k_phy_dbg_read(struct qca8k_priv *priv, int phy_addr, u16 dbg_addr, u16 *dbg_data)
+{
+	struct mii_bus *bus = priv->bus;
+
+	mutex_lock_nested(&bus->mdio_lock, MDIO_MUTEX_NESTED);
+	bus->write(bus, phy_addr, MII_ATH_DBG_ADDR, dbg_addr);
+	*dbg_data = bus->read(bus, phy_addr, MII_ATH_DBG_DATA);
+	mutex_unlock(&bus->mdio_lock);
+}
+
+void qca8k_phy_dbg_write(struct qca8k_priv *priv, int phy_addr, u16 dbg_addr, u16 dbg_data)
+{
+	struct mii_bus *bus = priv->bus;
+
+	mutex_lock_nested(&bus->mdio_lock, MDIO_MUTEX_NESTED);
+	bus->write(bus, phy_addr, MII_ATH_DBG_ADDR, dbg_addr);
+	bus->write(bus, phy_addr, MII_ATH_DBG_DATA, dbg_data);
+	mutex_unlock(&bus->mdio_lock);
+}
+
+static inline void qca8k_phy_mmd_prep(struct mii_bus *bus, int phy_addr, u16 addr, u16 reg)
+{
+	bus->write(bus, phy_addr, MII_ATH_MMD_ADDR, addr);
+	bus->write(bus, phy_addr, MII_ATH_MMD_DATA, reg);
+	bus->write(bus, phy_addr, MII_ATH_MMD_ADDR, addr | 0x4000);
+}
+
+void qca8k_phy_mmd_write(struct qca8k_priv *priv, int phy_addr, u16 addr, u16 reg, u16 data)
+{
+	struct mii_bus *bus = priv->bus;
+
+	mutex_lock_nested(&bus->mdio_lock, MDIO_MUTEX_NESTED);
+	qca8k_phy_mmd_prep(bus, phy_addr, addr, reg);
+	bus->write(bus, phy_addr, MII_ATH_MMD_DATA, data);
+	mutex_unlock(&bus->mdio_lock);
+}
+
+u16 qca8k_phy_mmd_read(struct qca8k_priv *priv, int phy_addr, u16 addr, u16 reg)
+{
+	struct mii_bus *bus = priv->bus;
+	u16 data;
+
+	mutex_lock_nested(&bus->mdio_lock, MDIO_MUTEX_NESTED);
+	qca8k_phy_mmd_prep(bus, phy_addr, addr, reg);
+	data = bus->read(bus, phy_addr, MII_ATH_MMD_DATA);
+	mutex_unlock(&bus->mdio_lock);
+
+	return data;
+}
+
 /* The 32bit switch registers are accessed indirectly. To achieve this we need
  * to set the page of the register. Track the last page that was set to reduce
  * mdio writes
diff --git a/drivers/net/dsa/qca8k.h b/drivers/net/dsa/qca8k.h
index dbd54d870a30..de00aa74868b 100644
--- a/drivers/net/dsa/qca8k.h
+++ b/drivers/net/dsa/qca8k.h
@@ -215,6 +215,8 @@
 /* QCA specific MII registers */
 #define MII_ATH_MMD_ADDR				0x0d
 #define MII_ATH_MMD_DATA				0x0e
+#define MII_ATH_DBG_ADDR				0x1d
+#define MII_ATH_DBG_DATA				0x1e
 
 enum {
 	QCA8K_PORT_SPEED_10M = 0,
-- 
2.30.2

