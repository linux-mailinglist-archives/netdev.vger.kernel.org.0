Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9756B905E2
	for <lists+netdev@lfdr.de>; Fri, 16 Aug 2019 18:33:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727200AbfHPQc0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Aug 2019 12:32:26 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:35851 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725971AbfHPQc0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 16 Aug 2019 12:32:26 -0400
Received: by mail-wr1-f67.google.com with SMTP id r3so2117358wrt.3;
        Fri, 16 Aug 2019 09:32:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=uQYPrIW+PkLuxFJC+jWmtXibV5EXo8mo5nblOSBDmH4=;
        b=MwIuGcM1odQG1PF5fwughPKy1YHKEbeFTkVwVDUfyas7hUvbF5oOzs6wNEp6mF8ge+
         SZGT4+kLtWp985Vpq6Pnikt/fI3yWR6Bx80e7zUK+uudipNBUVtxemBkM/xz0+OO+4Kt
         jYuC8NTDaFt7iPKlQ34OwqheiltzoJdcWMoTsvMgNx/sp4AHwUf+marsg5xoMw9rz4k9
         J58we2AFaglDdYZysx0L4BGZyFYdYre7U8I0qlgqtsKYEy7/ONg5IOcCcwiJlj4C6Gel
         z7mjJzoIAL2iqqKXZb7aRdB6yOmGnyNqBPwy2SPfq6sMI5R60oVdHiKCe5SO38iUGntC
         YORA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=uQYPrIW+PkLuxFJC+jWmtXibV5EXo8mo5nblOSBDmH4=;
        b=soQp1ap2Fu8PyNvS1gy5srql/ziFs4pS1SffSI4Ib//0o+vnqYNYfpxEh2xtllThD6
         BIl8XLGs5iWL7wAxzgY3d1Jn8T6GbA/kOBP1d2b7Jq2i4rlnXvzv84cKLcIKcyL/BinW
         i/W3umS8JmuOn2hD3JBfj5JDDKZ4kBj/dsXtTN6Ur6YNLgM8u7qj+GRu/uwwcSTowCzD
         iEBwjhbaEK2U83jZ6R3WEXdaa9JSFt9XpAwdOkEwGHCGVTHBTmAXEF4YpmHw4GXNBRmR
         izpMaY0hx0wWzE9+4uxrVk0vSSstbI18VjETbu6Fefy5z5trnMaYT3ickrbLOAB+TOzS
         pRbQ==
X-Gm-Message-State: APjAAAWVkircd/59Hik8oeLWeVP44hMEUV5KqEspuhqNp5Ttug1i+UgT
        oVWAJMXIofqQSfuRJfwynJ5bQ0MmcC0=
X-Google-Smtp-Source: APXvYqwecj+b1sl01cEpmYBjUbSrszoev2kH+NR5fRAneKWRqIuUrYaiobh0C8PVWHFDntzxC2bvqw==
X-Received: by 2002:a5d:4dc6:: with SMTP id f6mr11990065wru.209.1565973143811;
        Fri, 16 Aug 2019 09:32:23 -0700 (PDT)
Received: from vd-lxpc-hfe.ad.vahle.at ([80.110.31.209])
        by smtp.gmail.com with ESMTPSA id d19sm11031677wrb.7.2019.08.16.09.32.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 16 Aug 2019 09:32:23 -0700 (PDT)
From:   Hubert Feurstein <h.feurstein@gmail.com>
To:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Hubert Feurstein <h.feurstein@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Richard Cochran <richardcochran@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH net-next 1/3] net: mdio: add support for passing a PTP system timestamp to the mii_bus driver
Date:   Fri, 16 Aug 2019 18:31:55 +0200
Message-Id: <20190816163157.25314-2-h.feurstein@gmail.com>
X-Mailer: git-send-email 2.22.1
In-Reply-To: <20190816163157.25314-1-h.feurstein@gmail.com>
References: <20190816163157.25314-1-h.feurstein@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In order to improve the synchronisation precision of phc2sys (from
the linuxptp project) for devices like switches which are attached
to the MDIO bus, it is necessary the get the system timestamps as
close as possible to the access which causes the PTP timestamp
register to be snapshotted in the switch hardware. Usually this is
triggered by an MDIO write access, the snapshotted timestamp is then
transferred by several MDIO reads.

This patch adds the required infrastructure to solve the problem described
above.

Signed-off-by: Hubert Feurstein <h.feurstein@gmail.com>
---
 drivers/net/phy/mdio_bus.c | 105 +++++++++++++++++++++++++++++++++++++
 include/linux/mdio.h       |   7 +++
 include/linux/phy.h        |  25 +++++++++
 3 files changed, 137 insertions(+)

diff --git a/drivers/net/phy/mdio_bus.c b/drivers/net/phy/mdio_bus.c
index bd04fe762056..167a21f267fa 100644
--- a/drivers/net/phy/mdio_bus.c
+++ b/drivers/net/phy/mdio_bus.c
@@ -34,6 +34,7 @@
 #include <linux/phy.h>
 #include <linux/io.h>
 #include <linux/uaccess.h>
+#include <linux/ptp_clock_kernel.h>
 
 #define CREATE_TRACE_POINTS
 #include <trace/events/mdio.h>
@@ -697,6 +698,110 @@ int mdiobus_write(struct mii_bus *bus, int addr, u32 regnum, u16 val)
 }
 EXPORT_SYMBOL(mdiobus_write);
 
+/**
+ * __mdiobus_write_sts - Unlocked version of the mdiobus_write_sts function
+ * @bus: the mii_bus struct
+ * @addr: the phy address
+ * @regnum: register number to write
+ * @val: value to write to @regnum
+ * @sts: the ptp system timestamp
+ *
+ * Write a MDIO bus register and request the MDIO bus driver to take the
+ * system timestamps when sts-pointer is valid. When the bus driver doesn't
+ * support this, the timestamps are taken in this function instead.
+ *
+ * In order to improve the synchronisation precision of phc2sys (from
+ * the linuxptp project) for devices like switches which are attached
+ * to the MDIO bus, it is necessary the get the system timestamps as
+ * close as possible to the access which causes the PTP timestamp
+ * register to be snapshotted in the switch hardware. Usually this is
+ * triggered by an MDIO write access, the snapshotted timestamp is then
+ * transferred by several MDIO reads.
+ *
+ * Caller must hold the mdio bus lock.
+ *
+ * NOTE: MUST NOT be called from interrupt context.
+ */
+int __mdiobus_write_sts(struct mii_bus *bus, int addr, u32 regnum, u16 val,
+			struct ptp_system_timestamp *sts)
+{
+	int retval;
+
+	WARN_ON_ONCE(!mutex_is_locked(&bus->mdio_lock));
+
+	if (!bus->ptp_sts_supported)
+		ptp_read_system_prets(sts);
+
+	bus->ptp_sts = sts;
+	retval = __mdiobus_write(bus, addr, regnum, val);
+	bus->ptp_sts = NULL;
+
+	if (!bus->ptp_sts_supported)
+		ptp_read_system_postts(sts);
+
+	return retval;
+}
+EXPORT_SYMBOL(__mdiobus_write_sts);
+
+/**
+ * mdiobus_write_sts - Convenience function for writing a given MII mgmt
+ * register
+ *
+ * @bus: the mii_bus struct
+ * @addr: the phy address
+ * @regnum: register number to write
+ * @val: value to write to @regnum
+ * @sts: the ptp system timestamp
+ *
+ * NOTE: MUST NOT be called from interrupt context,
+ * because the bus read/write functions may wait for an interrupt
+ * to conclude the operation.
+ */
+int mdiobus_write_sts(struct mii_bus *bus, int addr, u32 regnum, u16 val,
+		      struct ptp_system_timestamp *sts)
+{
+	int retval;
+
+	BUG_ON(in_interrupt());
+
+	mutex_lock(&bus->mdio_lock);
+	retval = __mdiobus_write_sts(bus, addr, regnum, val, sts);
+	mutex_unlock(&bus->mdio_lock);
+
+	return retval;
+}
+EXPORT_SYMBOL(mdiobus_write_sts);
+
+/**
+ * mdiobus_write_sts_nested - Nested version of the mdiobus_write_sts function
+ * @bus: the mii_bus struct
+ * @addr: the phy address
+ * @regnum: register number to write
+ * @val: value to write to @regnum
+ * @sts: the ptp system timestamp
+ *
+ * In case of nested MDIO bus access avoid lockdep false positives by
+ * using mutex_lock_nested().
+ *
+ * NOTE: MUST NOT be called from interrupt context,
+ * because the bus read/write functions may wait for an interrupt
+ * to conclude the operation.
+ */
+int mdiobus_write_sts_nested(struct mii_bus *bus, int addr, u32 regnum, u16 val,
+			     struct ptp_system_timestamp *sts)
+{
+	int retval;
+
+	BUG_ON(in_interrupt());
+
+	mutex_lock_nested(&bus->mdio_lock, MDIO_MUTEX_NESTED);
+	retval = __mdiobus_write_sts(bus, addr, regnum, val, sts);
+	mutex_unlock(&bus->mdio_lock);
+
+	return retval;
+}
+EXPORT_SYMBOL(mdiobus_write_sts_nested);
+
 /**
  * mdio_bus_match - determine if given MDIO driver supports the given
  *		    MDIO device
diff --git a/include/linux/mdio.h b/include/linux/mdio.h
index e8242ad88c81..d65625c75b15 100644
--- a/include/linux/mdio.h
+++ b/include/linux/mdio.h
@@ -9,6 +9,7 @@
 #include <uapi/linux/mdio.h>
 #include <linux/mod_devicetable.h>
 
+struct ptp_system_timestamp;
 struct gpio_desc;
 struct mii_bus;
 
@@ -305,11 +306,17 @@ static inline void mii_10gbt_stat_mod_linkmode_lpa_t(unsigned long *advertising,
 
 int __mdiobus_read(struct mii_bus *bus, int addr, u32 regnum);
 int __mdiobus_write(struct mii_bus *bus, int addr, u32 regnum, u16 val);
+int __mdiobus_write_sts(struct mii_bus *bus, int addr, u32 regnum, u16 val,
+			struct ptp_system_timestamp *sts);
 
 int mdiobus_read(struct mii_bus *bus, int addr, u32 regnum);
 int mdiobus_read_nested(struct mii_bus *bus, int addr, u32 regnum);
 int mdiobus_write(struct mii_bus *bus, int addr, u32 regnum, u16 val);
 int mdiobus_write_nested(struct mii_bus *bus, int addr, u32 regnum, u16 val);
+int mdiobus_write_sts(struct mii_bus *bus, int addr, u32 regnum, u16 val,
+		      struct ptp_system_timestamp *sts);
+int mdiobus_write_sts_nested(struct mii_bus *bus, int addr, u32 regnum, u16 val,
+			     struct ptp_system_timestamp *sts);
 
 int mdiobus_register_device(struct mdio_device *mdiodev);
 int mdiobus_unregister_device(struct mdio_device *mdiodev);
diff --git a/include/linux/phy.h b/include/linux/phy.h
index 462b90b73f93..15afe9c5256b 100644
--- a/include/linux/phy.h
+++ b/include/linux/phy.h
@@ -252,6 +252,31 @@ struct mii_bus {
 	int reset_delay_us;
 	/* RESET GPIO descriptor pointer */
 	struct gpio_desc *reset_gpiod;
+
+	/* PTP system timestamping support
+	 *
+	 * In order to improve the synchronisation precision of phc2sys (from
+	 * the linuxptp project) for devices like switches which are attached
+	 * to the MDIO bus, it is necessary the get the system timestamps as
+	 * close as possible to the access which causes the PTP timestamp
+	 * register to be snapshotted in the switch hardware. Usually this is
+	 * triggered by an MDIO write access, the snapshotted timestamp is then
+	 * transferred by several MDIO reads.
+	 *
+	 * The switch driver can use mdio_write_sts*() to pass through the
+	 * system timestamp pointer @ptp_sts to the MDIO bus driver. The bus
+	 * driver simply has to do the following calls in its write handler:
+	 *	ptp_read_system_prets(bus->ptp_sts);
+	 *	writel(value, mdio-register)
+	 *	ptp_read_system_postts(bus->ptp_sts);
+	 *
+	 * The ptp_read_system_*ts functions already check the ptp_sts pointer.
+	 *
+	 * @ptp_sts_supported: Must be set to true when the MDIO bus driver
+	 * takes the timestamps as described above.
+	 */
+	struct ptp_system_timestamp *ptp_sts;
+	bool ptp_sts_supported;
 };
 #define to_mii_bus(d) container_of(d, struct mii_bus, dev)
 
-- 
2.22.1

