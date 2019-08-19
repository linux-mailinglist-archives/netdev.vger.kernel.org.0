Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C321994BB6
	for <lists+netdev@lfdr.de>; Mon, 19 Aug 2019 19:30:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728093AbfHSR2o (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Aug 2019 13:28:44 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:43179 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727819AbfHSR2m (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Aug 2019 13:28:42 -0400
Received: by mail-wr1-f68.google.com with SMTP id y8so9544427wrn.10;
        Mon, 19 Aug 2019 10:28:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Aqe8ssO7vbcAbN8euP3FTsvyBcUk74KyUbdkeYdhPr8=;
        b=DTTOm8ZDNwuED6B/oQ05QNZWibeJ8s5kZMTNjf+jZm2+NKbZjjL7L0rANqI/Ylp26T
         Gi3QLyH3vuRlgpgJmpI0We7HphuMrIelqmGHBc22svtKLoUX3hgdXEMlHIjH7va1cefi
         5vp6YM7Fjlvcg14SV4jpX1u/sQy4yDJlLcR+2Y49SIlZ7CkzDzZahHycjHatW+g4JDbY
         Cv6z5L0d4ES5oMelM/Cb1C+h5Jp1zz/uEOFSJ8XC7RriaIVixU0LsmAZShaoQQoyhrHs
         N65IuCllObV8f2mNpiTZihW0oHoFMmvQsc7eXNgimInccu2WXSPJgfy6a+zwFv5HWlc2
         3fnA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Aqe8ssO7vbcAbN8euP3FTsvyBcUk74KyUbdkeYdhPr8=;
        b=OSr+7/2uA61lkQht4/66mOo72crCmLX8A74aZu7CgOpSUmA0mUxr9dXlgVAlvCpiMr
         uHCkHhuTYbyGSIWAccL1mvmpmMLBFf5SOOXDOIhkmMwEYOiyZ7eu8qj12Z4Pt/fYIp8K
         4hg3BVo8zokKpYjicE2OdWqBYW2AXA2TmfZtwKJUfExc6KLh9zo5vKutC5BzWFvteTQD
         RzmHJadzAmlA+HGQyRIXctcovBtFZMV21+iP/TzBE05gNoIccmhHhSHy01CaKlWRReRL
         DbKRAtED2z20+wXwwnsNSiO1tW8g99mRGGp2pbgwe94iAkXZ/IoPezrPfPgsOJzciatJ
         xMEA==
X-Gm-Message-State: APjAAAXpeApv2YRo+5h9XGnYn59liPvFAB0P4Nm7LBj/0vJtxs5LIp24
        ECpxziQZ7v4x9p3aYOgphamQQU/1DYQ=
X-Google-Smtp-Source: APXvYqzHxSGNq9aOHNj7xQJvStXQinB6s6d5+l0bsK7KbJvqQrc7e6fFkWTzUHp1B8FjTqI5kyUwoQ==
X-Received: by 2002:adf:f286:: with SMTP id k6mr15314522wro.320.1566235719544;
        Mon, 19 Aug 2019 10:28:39 -0700 (PDT)
Received: from vd-lxpc-hfe.ad.vahle.at ([80.110.31.209])
        by smtp.gmail.com with ESMTPSA id c15sm41983879wrb.80.2019.08.19.10.28.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Aug 2019 10:28:39 -0700 (PDT)
From:   Hubert Feurstein <h.feurstein@gmail.com>
X-Google-Original-From: Hubert Feurstein <hubert.feurstein@vahle.at>
To:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Hubert Feurstein <h.feurstein@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Richard Cochran <richardcochran@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH net-next v2 1/4] net: mdio: add support for passing a PTP system timestamp to the mii_bus driver
Date:   Mon, 19 Aug 2019 19:28:24 +0200
Message-Id: <20190819172827.9550-2-hubert.feurstein@vahle.at>
X-Mailer: git-send-email 2.22.1
In-Reply-To: <20190819172827.9550-1-hubert.feurstein@vahle.at>
References: <20190819172827.9550-1-hubert.feurstein@vahle.at>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Hubert Feurstein <h.feurstein@gmail.com>

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
Changes in v2:
 - Removed mdiobus_write_sts as there was no user
 - Removed ptp_sts_supported-boolean and introduced flags instead

 drivers/net/phy/mdio_bus.c | 76 ++++++++++++++++++++++++++++++++++++++
 include/linux/mdio.h       |  5 +++
 include/linux/phy.h        | 34 +++++++++++++++++
 3 files changed, 115 insertions(+)

diff --git a/drivers/net/phy/mdio_bus.c b/drivers/net/phy/mdio_bus.c
index bd04fe762056..4dba2714495e 100644
--- a/drivers/net/phy/mdio_bus.c
+++ b/drivers/net/phy/mdio_bus.c
@@ -34,6 +34,7 @@
 #include <linux/phy.h>
 #include <linux/io.h>
 #include <linux/uaccess.h>
+#include <linux/ptp_clock_kernel.h>
 
 #define CREATE_TRACE_POINTS
 #include <trace/events/mdio.h>
@@ -697,6 +698,81 @@ int mdiobus_write(struct mii_bus *bus, int addr, u32 regnum, u16 val)
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
+	if (!(bus->flags & MII_BUS_F_PTP_STS_SUPPORTED))
+		ptp_read_system_prets(sts);
+
+	bus->ptp_sts = sts;
+	retval = __mdiobus_write(bus, addr, regnum, val);
+	bus->ptp_sts = NULL;
+
+	if (!(bus->flags & MII_BUS_F_PTP_STS_SUPPORTED))
+		ptp_read_system_postts(sts);
+
+	return retval;
+}
+EXPORT_SYMBOL(__mdiobus_write_sts);
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
index e8242ad88c81..482388341c7b 100644
--- a/include/linux/mdio.h
+++ b/include/linux/mdio.h
@@ -9,6 +9,7 @@
 #include <uapi/linux/mdio.h>
 #include <linux/mod_devicetable.h>
 
+struct ptp_system_timestamp;
 struct gpio_desc;
 struct mii_bus;
 
@@ -305,11 +306,15 @@ static inline void mii_10gbt_stat_mod_linkmode_lpa_t(unsigned long *advertising,
 
 int __mdiobus_read(struct mii_bus *bus, int addr, u32 regnum);
 int __mdiobus_write(struct mii_bus *bus, int addr, u32 regnum, u16 val);
+int __mdiobus_write_sts(struct mii_bus *bus, int addr, u32 regnum, u16 val,
+			struct ptp_system_timestamp *sts);
 
 int mdiobus_read(struct mii_bus *bus, int addr, u32 regnum);
 int mdiobus_read_nested(struct mii_bus *bus, int addr, u32 regnum);
 int mdiobus_write(struct mii_bus *bus, int addr, u32 regnum, u16 val);
 int mdiobus_write_nested(struct mii_bus *bus, int addr, u32 regnum, u16 val);
+int mdiobus_write_sts_nested(struct mii_bus *bus, int addr, u32 regnum, u16 val,
+			     struct ptp_system_timestamp *sts);
 
 int mdiobus_register_device(struct mdio_device *mdiodev);
 int mdiobus_unregister_device(struct mdio_device *mdiodev);
diff --git a/include/linux/phy.h b/include/linux/phy.h
index d26779f1fb6b..0b33662e0320 100644
--- a/include/linux/phy.h
+++ b/include/linux/phy.h
@@ -205,6 +205,13 @@ struct device;
 struct phylink;
 struct sk_buff;
 
+/* MII-bus flags:
+ * @MII_BUS_F_PTP_STS_SUPPORTED: The driver supports PTP system timestamping
+ */
+enum mii_bus_flags {
+	MII_BUS_F_PTP_STS_SUPPORTED = BIT(0)
+};
+
 /*
  * The Bus class for PHYs.  Devices which provide access to
  * PHYs should register using this structure
@@ -252,7 +259,34 @@ struct mii_bus {
 	int reset_delay_us;
 	/* RESET GPIO descriptor pointer */
 	struct gpio_desc *reset_gpiod;
+
+	/* Feature flags */
+	u32 flags;
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
+	 * The MII_BUS_F_PTP_STS_SUPPORTED-bit must be set in flags, when the
+	 * MDIO bus driver takes the timestamps as described above.
+	 */
+	struct ptp_system_timestamp *ptp_sts;
 };
+
 #define to_mii_bus(d) container_of(d, struct mii_bus, dev)
 
 struct mii_bus *mdiobus_alloc_size(size_t);
-- 
2.22.1

