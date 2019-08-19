Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3D7EE94A53
	for <lists+netdev@lfdr.de>; Mon, 19 Aug 2019 18:34:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728105AbfHSQd6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Aug 2019 12:33:58 -0400
Received: from mx2.suse.de ([195.135.220.15]:55350 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727681AbfHSQcG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 19 Aug 2019 12:32:06 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 5737CB0E5;
        Mon, 19 Aug 2019 16:32:02 +0000 (UTC)
From:   Thomas Bogendoerfer <tbogendoerfer@suse.de>
To:     Jonathan Corbet <corbet@lwn.net>,
        Ralf Baechle <ralf@linux-mips.org>,
        Paul Burton <paul.burton@mips.com>,
        James Hogan <jhogan@kernel.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Lee Jones <lee.jones@linaro.org>,
        "David S. Miller" <davem@davemloft.net>,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
        Alessandro Zummo <a.zummo@towertech.it>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.com>,
        Evgeniy Polyakov <zbr@ioremap.net>, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-mips@vger.kernel.org,
        linux-input@vger.kernel.org, netdev@vger.kernel.org,
        linux-rtc@vger.kernel.org, linux-serial@vger.kernel.org
Subject: [PATCH v5 04/17] MIPS: PCI: refactor ioc3 special handling
Date:   Mon, 19 Aug 2019 18:31:27 +0200
Message-Id: <20190819163144.3478-5-tbogendoerfer@suse.de>
X-Mailer: git-send-email 2.13.7
In-Reply-To: <20190819163144.3478-1-tbogendoerfer@suse.de>
References: <20190819163144.3478-1-tbogendoerfer@suse.de>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Refactored code to only have one ioc3 special handling for read
access and one for write access.

Signed-off-by: Thomas Bogendoerfer <tbogendoerfer@suse.de>
---
 arch/mips/pci/pci-xtalk-bridge.c | 167 +++++++++++++++------------------------
 1 file changed, 62 insertions(+), 105 deletions(-)

diff --git a/arch/mips/pci/pci-xtalk-bridge.c b/arch/mips/pci/pci-xtalk-bridge.c
index bcf7f559789a..7b4d40354ee7 100644
--- a/arch/mips/pci/pci-xtalk-bridge.c
+++ b/arch/mips/pci/pci-xtalk-bridge.c
@@ -20,16 +20,50 @@
  * Most of the IOC3 PCI config register aren't present
  * we emulate what is needed for a normal PCI enumeration
  */
-static u32 emulate_ioc3_cfg(int where, int size)
+static int ioc3_cfg_rd(void *addr, int where, int size, u32 *value)
 {
-	if (size == 1 && where == 0x3d)
-		return 0x01;
-	else if (size == 2 && where == 0x3c)
-		return 0x0100;
-	else if (size == 4 && where == 0x3c)
-		return 0x00000100;
+	u32 cf, shift, mask;
 
-	return 0;
+	switch (where & ~3) {
+	case 0x00 ... 0x10:
+	case 0x40 ... 0x44:
+		if (get_dbe(cf, (u32 *)addr))
+			return PCIBIOS_DEVICE_NOT_FOUND;
+		break;
+	case 0x3c:
+		/* emulate sane interrupt pin value */
+		cf = 0x00000100;
+		break;
+	default:
+		cf = 0;
+		break;
+	}
+	shift = (where & 3) << 3;
+	mask = 0xffffffffU >> ((4 - size) << 3);
+	*value = (cf >> shift) & mask;
+
+	return PCIBIOS_SUCCESSFUL;
+}
+
+static int ioc3_cfg_wr(void *addr, int where, int size, u32 value)
+{
+	u32 cf, shift, mask, smask;
+
+	if ((where >= 0x14 && where < 0x40) || (where >= 0x48))
+		return PCIBIOS_SUCCESSFUL;
+
+	if (get_dbe(cf, (u32 *)addr))
+		return PCIBIOS_DEVICE_NOT_FOUND;
+
+	shift = ((where & 3) << 3);
+	mask = (0xffffffffU >> ((4 - size) << 3));
+	smask = mask << shift;
+
+	cf = (cf & ~smask) | ((value & mask) << shift);
+	if (put_dbe(cf, (u32 *)addr))
+		return PCIBIOS_DEVICE_NOT_FOUND;
+
+	return PCIBIOS_SUCCESSFUL;
 }
 
 static void bridge_disable_swapping(struct pci_dev *dev)
@@ -64,7 +98,7 @@ static int pci_conf0_read_config(struct pci_bus *bus, unsigned int devfn,
 	int slot = PCI_SLOT(devfn);
 	int fn = PCI_FUNC(devfn);
 	void *addr;
-	u32 cf, shift, mask;
+	u32 cf;
 	int res;
 
 	addr = &bridge->b_type0_cfg_dev[slot].f[fn].c[PCI_VENDOR_ID];
@@ -75,8 +109,10 @@ static int pci_conf0_read_config(struct pci_bus *bus, unsigned int devfn,
 	 * IOC3 is broken beyond belief ...  Don't even give the
 	 * generic PCI code a chance to look at it for real ...
 	 */
-	if (cf == (PCI_VENDOR_ID_SGI | (PCI_DEVICE_ID_SGI_IOC3 << 16)))
-		goto is_ioc3;
+	if (cf == (PCI_VENDOR_ID_SGI | (PCI_DEVICE_ID_SGI_IOC3 << 16))) {
+		addr = &bridge->b_type0_cfg_dev[slot].f[fn].l[where >> 2];
+		return ioc3_cfg_rd(addr, where, size, value);
+	}
 
 	addr = &bridge->b_type0_cfg_dev[slot].f[fn].c[where ^ (4 - size)];
 
@@ -88,26 +124,6 @@ static int pci_conf0_read_config(struct pci_bus *bus, unsigned int devfn,
 		res = get_dbe(*value, (u32 *)addr);
 
 	return res ? PCIBIOS_DEVICE_NOT_FOUND : PCIBIOS_SUCCESSFUL;
-
-is_ioc3:
-
-	/*
-	 * IOC3 special handling
-	 */
-	if ((where >= 0x14 && where < 0x40) || (where >= 0x48)) {
-		*value = emulate_ioc3_cfg(where, size);
-		return PCIBIOS_SUCCESSFUL;
-	}
-
-	addr = &bridge->b_type0_cfg_dev[slot].f[fn].l[where >> 2];
-	if (get_dbe(cf, (u32 *)addr))
-		return PCIBIOS_DEVICE_NOT_FOUND;
-
-	shift = ((where & 3) << 3);
-	mask = (0xffffffffU >> ((4 - size) << 3));
-	*value = (cf >> shift) & mask;
-
-	return PCIBIOS_SUCCESSFUL;
 }
 
 static int pci_conf1_read_config(struct pci_bus *bus, unsigned int devfn,
@@ -119,7 +135,7 @@ static int pci_conf1_read_config(struct pci_bus *bus, unsigned int devfn,
 	int slot = PCI_SLOT(devfn);
 	int fn = PCI_FUNC(devfn);
 	void *addr;
-	u32 cf, shift, mask;
+	u32 cf;
 	int res;
 
 	bridge_write(bc, b_pci_cfg, (busno << 16) | (slot << 11));
@@ -131,8 +147,10 @@ static int pci_conf1_read_config(struct pci_bus *bus, unsigned int devfn,
 	 * IOC3 is broken beyond belief ...  Don't even give the
 	 * generic PCI code a chance to look at it for real ...
 	 */
-	if (cf == (PCI_VENDOR_ID_SGI | (PCI_DEVICE_ID_SGI_IOC3 << 16)))
-		goto is_ioc3;
+	if (cf == (PCI_VENDOR_ID_SGI | (PCI_DEVICE_ID_SGI_IOC3 << 16))) {
+		addr = &bridge->b_type1_cfg.c[(fn << 8) | (where & ~3)];
+		return ioc3_cfg_rd(addr, where, size, value);
+	}
 
 	addr = &bridge->b_type1_cfg.c[(fn << 8) | (where ^ (4 - size))];
 
@@ -144,26 +162,6 @@ static int pci_conf1_read_config(struct pci_bus *bus, unsigned int devfn,
 		res = get_dbe(*value, (u32 *)addr);
 
 	return res ? PCIBIOS_DEVICE_NOT_FOUND : PCIBIOS_SUCCESSFUL;
-
-is_ioc3:
-
-	/*
-	 * IOC3 special handling
-	 */
-	if ((where >= 0x14 && where < 0x40) || (where >= 0x48)) {
-		*value = emulate_ioc3_cfg(where, size);
-		return PCIBIOS_SUCCESSFUL;
-	}
-
-	addr = &bridge->b_type1_cfg.c[(fn << 8) | where];
-	if (get_dbe(cf, (u32 *)addr))
-		return PCIBIOS_DEVICE_NOT_FOUND;
-
-	shift = ((where & 3) << 3);
-	mask = (0xffffffffU >> ((4 - size) << 3));
-	*value = (cf >> shift) & mask;
-
-	return PCIBIOS_SUCCESSFUL;
 }
 
 static int pci_read_config(struct pci_bus *bus, unsigned int devfn,
@@ -183,7 +181,7 @@ static int pci_conf0_write_config(struct pci_bus *bus, unsigned int devfn,
 	int slot = PCI_SLOT(devfn);
 	int fn = PCI_FUNC(devfn);
 	void *addr;
-	u32 cf, shift, mask, smask;
+	u32 cf;
 	int res;
 
 	addr = &bridge->b_type0_cfg_dev[slot].f[fn].c[PCI_VENDOR_ID];
@@ -194,8 +192,10 @@ static int pci_conf0_write_config(struct pci_bus *bus, unsigned int devfn,
 	 * IOC3 is broken beyond belief ...  Don't even give the
 	 * generic PCI code a chance to look at it for real ...
 	 */
-	if (cf == (PCI_VENDOR_ID_SGI | (PCI_DEVICE_ID_SGI_IOC3 << 16)))
-		goto is_ioc3;
+	if (cf == (PCI_VENDOR_ID_SGI | (PCI_DEVICE_ID_SGI_IOC3 << 16))) {
+		addr = &bridge->b_type0_cfg_dev[slot].f[fn].l[where >> 2];
+		return ioc3_cfg_wr(addr, where, size, value);
+	}
 
 	addr = &bridge->b_type0_cfg_dev[slot].f[fn].c[where ^ (4 - size)];
 
@@ -210,29 +210,6 @@ static int pci_conf0_write_config(struct pci_bus *bus, unsigned int devfn,
 		return PCIBIOS_DEVICE_NOT_FOUND;
 
 	return PCIBIOS_SUCCESSFUL;
-
-is_ioc3:
-
-	/*
-	 * IOC3 special handling
-	 */
-	if ((where >= 0x14 && where < 0x40) || (where >= 0x48))
-		return PCIBIOS_SUCCESSFUL;
-
-	addr = &bridge->b_type0_cfg_dev[slot].f[fn].l[where >> 2];
-
-	if (get_dbe(cf, (u32 *)addr))
-		return PCIBIOS_DEVICE_NOT_FOUND;
-
-	shift = ((where & 3) << 3);
-	mask = (0xffffffffU >> ((4 - size) << 3));
-	smask = mask << shift;
-
-	cf = (cf & ~smask) | ((value & mask) << shift);
-	if (put_dbe(cf, (u32 *)addr))
-		return PCIBIOS_DEVICE_NOT_FOUND;
-
-	return PCIBIOS_SUCCESSFUL;
 }
 
 static int pci_conf1_write_config(struct pci_bus *bus, unsigned int devfn,
@@ -244,7 +221,7 @@ static int pci_conf1_write_config(struct pci_bus *bus, unsigned int devfn,
 	int fn = PCI_FUNC(devfn);
 	int busno = bus->number;
 	void *addr;
-	u32 cf, shift, mask, smask;
+	u32 cf;
 	int res;
 
 	bridge_write(bc, b_pci_cfg, (busno << 16) | (slot << 11));
@@ -256,8 +233,10 @@ static int pci_conf1_write_config(struct pci_bus *bus, unsigned int devfn,
 	 * IOC3 is broken beyond belief ...  Don't even give the
 	 * generic PCI code a chance to look at it for real ...
 	 */
-	if (cf == (PCI_VENDOR_ID_SGI | (PCI_DEVICE_ID_SGI_IOC3 << 16)))
-		goto is_ioc3;
+	if (cf == (PCI_VENDOR_ID_SGI | (PCI_DEVICE_ID_SGI_IOC3 << 16))) {
+		addr = &bridge->b_type0_cfg_dev[slot].f[fn].l[where >> 2];
+		return ioc3_cfg_wr(addr, where, size, value);
+	}
 
 	addr = &bridge->b_type1_cfg.c[(fn << 8) | (where ^ (4 - size))];
 
@@ -272,28 +251,6 @@ static int pci_conf1_write_config(struct pci_bus *bus, unsigned int devfn,
 		return PCIBIOS_DEVICE_NOT_FOUND;
 
 	return PCIBIOS_SUCCESSFUL;
-
-is_ioc3:
-
-	/*
-	 * IOC3 special handling
-	 */
-	if ((where >= 0x14 && where < 0x40) || (where >= 0x48))
-		return PCIBIOS_SUCCESSFUL;
-
-	addr = &bridge->b_type0_cfg_dev[slot].f[fn].l[where >> 2];
-	if (get_dbe(cf, (u32 *)addr))
-		return PCIBIOS_DEVICE_NOT_FOUND;
-
-	shift = ((where & 3) << 3);
-	mask = (0xffffffffU >> ((4 - size) << 3));
-	smask = mask << shift;
-
-	cf = (cf & ~smask) | ((value & mask) << shift);
-	if (put_dbe(cf, (u32 *)addr))
-		return PCIBIOS_DEVICE_NOT_FOUND;
-
-	return PCIBIOS_SUCCESSFUL;
 }
 
 static int pci_write_config(struct pci_bus *bus, unsigned int devfn,
-- 
2.13.7

