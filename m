Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C11E394A09
	for <lists+netdev@lfdr.de>; Mon, 19 Aug 2019 18:33:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728049AbfHSQcJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Aug 2019 12:32:09 -0400
Received: from mx2.suse.de ([195.135.220.15]:55432 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727893AbfHSQcG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 19 Aug 2019 12:32:06 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id D10D7B128;
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
Subject: [PATCH v5 05/17] MIPS: PCI: use information from 1-wire PROM for IOC3 detection
Date:   Mon, 19 Aug 2019 18:31:28 +0200
Message-Id: <20190819163144.3478-6-tbogendoerfer@suse.de>
X-Mailer: git-send-email 2.13.7
In-Reply-To: <20190819163144.3478-1-tbogendoerfer@suse.de>
References: <20190819163144.3478-1-tbogendoerfer@suse.de>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

IOC3 chips in SGI system are conntected to a bridge ASIC, which has
a 1-wire prom attached with part number information. This changeset
uses this information to create PCI subsystem information, which
the MFD driver uses for further platform device setup.

Signed-off-by: Thomas Bogendoerfer <tbogendoerfer@suse.de>
---
 arch/mips/include/asm/pci/bridge.h |   1 +
 arch/mips/include/asm/sn/ioc3.h    |   9 +++
 arch/mips/pci/pci-xtalk-bridge.c   | 135 ++++++++++++++++++++++++++++++++++++-
 arch/mips/sgi-ip27/ip27-xtalk.c    |  38 +++++++++--
 4 files changed, 175 insertions(+), 8 deletions(-)

diff --git a/arch/mips/include/asm/pci/bridge.h b/arch/mips/include/asm/pci/bridge.h
index a92cd30b48c9..3bc630ff9ad4 100644
--- a/arch/mips/include/asm/pci/bridge.h
+++ b/arch/mips/include/asm/pci/bridge.h
@@ -807,6 +807,7 @@ struct bridge_controller {
 	unsigned long		intr_addr;
 	struct irq_domain	*domain;
 	unsigned int		pci_int[8];
+	u32			ioc3_sid[8];
 	nasid_t			nasid;
 };
 
diff --git a/arch/mips/include/asm/sn/ioc3.h b/arch/mips/include/asm/sn/ioc3.h
index 25c8dccab51f..5022b0ab2074 100644
--- a/arch/mips/include/asm/sn/ioc3.h
+++ b/arch/mips/include/asm/sn/ioc3.h
@@ -661,4 +661,13 @@ typedef enum ioc3_subdevs_e {
 #define IOC3_INTA_SUBDEVS	IOC3_SDB_ETHER
 #define IOC3_INTB_SUBDEVS	(IOC3_SDB_GENERIC|IOC3_SDB_KBMS|IOC3_SDB_SERIAL|IOC3_SDB_ECPP|IOC3_SDB_RT)
 
+/* subsystem IDs supplied by card detection in pci-xtalk-bridge */
+#define	IOC3_SUBSYS_IP27_BASEIO6G	0xc300
+#define	IOC3_SUBSYS_IP27_MIO		0xc301
+#define	IOC3_SUBSYS_IP27_BASEIO		0xc302
+#define	IOC3_SUBSYS_IP29_SYSBOARD	0xc303
+#define	IOC3_SUBSYS_IP30_SYSBOARD	0xc304
+#define	IOC3_SUBSYS_MENET		0xc305
+#define	IOC3_SUBSYS_MENET4		0xc306
+
 #endif /* _IOC3_H */
diff --git a/arch/mips/pci/pci-xtalk-bridge.c b/arch/mips/pci/pci-xtalk-bridge.c
index 7b4d40354ee7..dcf6117a17c3 100644
--- a/arch/mips/pci/pci-xtalk-bridge.c
+++ b/arch/mips/pci/pci-xtalk-bridge.c
@@ -11,16 +11,22 @@
 #include <linux/dma-direct.h>
 #include <linux/platform_device.h>
 #include <linux/platform_data/xtalk-bridge.h>
+#include <linux/nvmem-consumer.h>
+#include <linux/crc16.h>
 
 #include <asm/pci/bridge.h>
 #include <asm/paccess.h>
 #include <asm/sn/irq_alloc.h>
+#include <asm/sn/ioc3.h>
+
+#define CRC16_INIT	0
+#define CRC16_VALID	0xb001
 
 /*
  * Most of the IOC3 PCI config register aren't present
  * we emulate what is needed for a normal PCI enumeration
  */
-static int ioc3_cfg_rd(void *addr, int where, int size, u32 *value)
+static int ioc3_cfg_rd(void *addr, int where, int size, u32 *value, u32 sid)
 {
 	u32 cf, shift, mask;
 
@@ -30,6 +36,9 @@ static int ioc3_cfg_rd(void *addr, int where, int size, u32 *value)
 		if (get_dbe(cf, (u32 *)addr))
 			return PCIBIOS_DEVICE_NOT_FOUND;
 		break;
+	case 0x2c:
+		cf = sid;
+		break;
 	case 0x3c:
 		/* emulate sane interrupt pin value */
 		cf = 0x00000100;
@@ -111,7 +120,8 @@ static int pci_conf0_read_config(struct pci_bus *bus, unsigned int devfn,
 	 */
 	if (cf == (PCI_VENDOR_ID_SGI | (PCI_DEVICE_ID_SGI_IOC3 << 16))) {
 		addr = &bridge->b_type0_cfg_dev[slot].f[fn].l[where >> 2];
-		return ioc3_cfg_rd(addr, where, size, value);
+		return ioc3_cfg_rd(addr, where, size, value,
+				   bc->ioc3_sid[slot]);
 	}
 
 	addr = &bridge->b_type0_cfg_dev[slot].f[fn].c[where ^ (4 - size)];
@@ -149,7 +159,8 @@ static int pci_conf1_read_config(struct pci_bus *bus, unsigned int devfn,
 	 */
 	if (cf == (PCI_VENDOR_ID_SGI | (PCI_DEVICE_ID_SGI_IOC3 << 16))) {
 		addr = &bridge->b_type1_cfg.c[(fn << 8) | (where & ~3)];
-		return ioc3_cfg_rd(addr, where, size, value);
+		return ioc3_cfg_rd(addr, where, size, value,
+				   bc->ioc3_sid[slot]);
 	}
 
 	addr = &bridge->b_type1_cfg.c[(fn << 8) | (where ^ (4 - size))];
@@ -426,6 +437,117 @@ static int bridge_map_irq(const struct pci_dev *dev, u8 slot, u8 pin)
 	return irq;
 }
 
+#define IOC3_SID(sid)	(PCI_VENDOR_ID_SGI << 16 | (sid))
+
+static void bridge_setup_ip27_baseio6g(struct bridge_controller *bc)
+{
+	bc->ioc3_sid[2] = IOC3_SID(IOC3_SUBSYS_IP27_BASEIO6G);
+	bc->ioc3_sid[6] = IOC3_SID(IOC3_SUBSYS_IP27_MIO);
+}
+
+static void bridge_setup_ip27_baseio(struct bridge_controller *bc)
+{
+	bc->ioc3_sid[2] = IOC3_SID(IOC3_SUBSYS_IP27_BASEIO);
+}
+
+static void bridge_setup_ip29_baseio(struct bridge_controller *bc)
+{
+	bc->ioc3_sid[2] = IOC3_SID(IOC3_SUBSYS_IP29_SYSBOARD);
+}
+
+static void bridge_setup_ip30_sysboard(struct bridge_controller *bc)
+{
+	bc->ioc3_sid[2] = IOC3_SID(IOC3_SUBSYS_IP30_SYSBOARD);
+}
+
+static void bridge_setup_menet(struct bridge_controller *bc)
+{
+	bc->ioc3_sid[0] = IOC3_SID(IOC3_SUBSYS_MENET);
+	bc->ioc3_sid[1] = IOC3_SID(IOC3_SUBSYS_MENET);
+	bc->ioc3_sid[2] = IOC3_SID(IOC3_SUBSYS_MENET);
+	bc->ioc3_sid[3] = IOC3_SID(IOC3_SUBSYS_MENET4);
+}
+
+#define BRIDGE_BOARD_SETUP(_partno, _setup)	\
+	{ .match = _partno, .setup = _setup }
+
+static const struct {
+	char *match;
+	void (*setup)(struct bridge_controller *bc);
+} bridge_ioc3_devid[] = {
+	BRIDGE_BOARD_SETUP("030-0734-", bridge_setup_ip27_baseio6g),
+	BRIDGE_BOARD_SETUP("030-0880-", bridge_setup_ip27_baseio6g),
+	BRIDGE_BOARD_SETUP("030-1023-", bridge_setup_ip27_baseio),
+	BRIDGE_BOARD_SETUP("030-1124-", bridge_setup_ip27_baseio),
+	BRIDGE_BOARD_SETUP("030-1025-", bridge_setup_ip29_baseio),
+	BRIDGE_BOARD_SETUP("030-1244-", bridge_setup_ip29_baseio),
+	BRIDGE_BOARD_SETUP("030-1389-", bridge_setup_ip29_baseio),
+	BRIDGE_BOARD_SETUP("030-0887-", bridge_setup_ip30_sysboard),
+	BRIDGE_BOARD_SETUP("030-1467-", bridge_setup_ip30_sysboard),
+	BRIDGE_BOARD_SETUP("030-0873-", bridge_setup_menet),
+};
+
+static void bridge_setup_board(struct bridge_controller *bc, char *partnum)
+{
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(bridge_ioc3_devid); i++)
+		if (!strncmp(partnum, bridge_ioc3_devid[i].match,
+			     strlen(bridge_ioc3_devid[i].match))) {
+			bridge_ioc3_devid[i].setup(bc);
+		}
+}
+
+static int bridge_nvmem_match(struct device *dev, const void *data)
+{
+	const char *name = dev_name(dev);
+	const char *prefix = data;
+
+	if (strlen(name) < strlen(prefix))
+		return 0;
+
+	return memcmp(prefix, dev_name(dev), strlen(prefix)) == 0;
+}
+
+static int bridge_get_partnum(u64 baddr, char *partnum)
+{
+	struct nvmem_device *nvmem;
+	char prefix[24];
+	u8 prom[64];
+	int i, j;
+	int ret;
+
+	snprintf(prefix, sizeof(prefix), "bridge-%012llx-0b-", baddr);
+
+	nvmem = nvmem_device_find(prefix, bridge_nvmem_match);
+	if (IS_ERR(nvmem))
+		return PTR_ERR(nvmem);
+
+	ret = nvmem_device_read(nvmem, 0, 64, prom);
+	nvmem_device_put(nvmem);
+
+	if (ret != 64)
+		return ret;
+
+	if (crc16(CRC16_INIT, prom, 32) != CRC16_VALID ||
+	    crc16(CRC16_INIT, prom + 32, 32) != CRC16_VALID)
+		return -EINVAL;
+
+	/* Assemble part number */
+	j = 0;
+	for (i = 0; i < 19; i++)
+		if (prom[i + 11] != ' ')
+			partnum[j++] = prom[i + 11];
+
+	for (i = 0; i < 6; i++)
+		if (prom[i + 32] != ' ')
+			partnum[j++] = prom[i + 32];
+
+	partnum[j] = 0;
+
+	return 0;
+}
+
 static int bridge_probe(struct platform_device *pdev)
 {
 	struct xtalk_bridge_platform_data *bd = dev_get_platdata(&pdev->dev);
@@ -434,9 +556,14 @@ static int bridge_probe(struct platform_device *pdev)
 	struct pci_host_bridge *host;
 	struct irq_domain *domain, *parent;
 	struct fwnode_handle *fn;
+	char partnum[26];
 	int slot;
 	int err;
 
+	/* get part number from one wire prom */
+	if (bridge_get_partnum(virt_to_phys((void *)bd->bridge_addr), partnum))
+		return -EPROBE_DEFER; /* not available yet */
+
 	parent = irq_get_default_host();
 	if (!parent)
 		return -ENODEV;
@@ -517,6 +644,8 @@ static int bridge_probe(struct platform_device *pdev)
 	}
 	bridge_read(bc, b_wid_tflush);	  /* wait until Bridge PIO complete */
 
+	bridge_setup_board(bc, partnum);
+
 	host->dev.parent = dev;
 	host->sysdata = bc;
 	host->busnr = 0;
diff --git a/arch/mips/sgi-ip27/ip27-xtalk.c b/arch/mips/sgi-ip27/ip27-xtalk.c
index 4a1f0b0c29e2..9b7524362a11 100644
--- a/arch/mips/sgi-ip27/ip27-xtalk.c
+++ b/arch/mips/sgi-ip27/ip27-xtalk.c
@@ -10,6 +10,7 @@
 #include <linux/kernel.h>
 #include <linux/smp.h>
 #include <linux/platform_device.h>
+#include <linux/platform_data/sgi-w1.h>
 #include <linux/platform_data/xtalk-bridge.h>
 #include <asm/sn/addrs.h>
 #include <asm/sn/types.h>
@@ -26,9 +27,35 @@
 static void bridge_platform_create(nasid_t nasid, int widget, int masterwid)
 {
 	struct xtalk_bridge_platform_data *bd;
+	struct sgi_w1_platform_data *wd;
 	struct platform_device *pdev;
+	struct resource w1_res;
 	unsigned long offset;
 
+	offset = NODE_OFFSET(nasid);
+
+	wd = kzalloc(sizeof(*wd), GFP_KERNEL);
+	if (!wd)
+		goto no_mem;
+
+	snprintf(wd->dev_id, sizeof(wd->dev_id), "bridge-%012lx",
+		 offset + (widget << SWIN_SIZE_BITS));
+
+	memset(&w1_res, 0, sizeof(w1_res));
+	w1_res.start = offset + (widget << SWIN_SIZE_BITS) +
+				offsetof(struct bridge_regs, b_nic);
+	w1_res.end = w1_res.start + 3;
+	w1_res.flags = IORESOURCE_MEM;
+
+	pdev = platform_device_alloc("sgi_w1", PLATFORM_DEVID_AUTO);
+	if (!pdev) {
+		kfree(wd);
+		goto no_mem;
+	}
+	platform_device_add_resources(pdev, &w1_res, 1);
+	platform_device_add_data(pdev, wd, sizeof(*wd));
+	platform_device_add(pdev);
+
 	bd = kzalloc(sizeof(*bd), GFP_KERNEL);
 	if (!bd)
 		goto no_mem;
@@ -38,7 +65,6 @@ static void bridge_platform_create(nasid_t nasid, int widget, int masterwid)
 		goto no_mem;
 	}
 
-	offset = NODE_OFFSET(nasid);
 
 	bd->bridge_addr = RAW_NODE_SWIN_BASE(nasid, widget);
 	bd->intr_addr	= BIT_ULL(47) + 0x01800000 + PI_INT_PEND_MOD;
@@ -46,14 +72,14 @@ static void bridge_platform_create(nasid_t nasid, int widget, int masterwid)
 	bd->masterwid	= masterwid;
 
 	bd->mem.name	= "Bridge PCI MEM";
-	bd->mem.start	= offset + (widget << SWIN_SIZE_BITS);
-	bd->mem.end	= bd->mem.start + SWIN_SIZE - 1;
+	bd->mem.start	= offset + (widget << SWIN_SIZE_BITS) + BRIDGE_DEVIO0;
+	bd->mem.end	= offset + (widget << SWIN_SIZE_BITS) + SWIN_SIZE - 1;
 	bd->mem.flags	= IORESOURCE_MEM;
 	bd->mem_offset	= offset;
 
 	bd->io.name	= "Bridge PCI IO";
-	bd->io.start	= offset + (widget << SWIN_SIZE_BITS);
-	bd->io.end	= bd->io.start + SWIN_SIZE - 1;
+	bd->io.start	= offset + (widget << SWIN_SIZE_BITS) + BRIDGE_DEVIO0;
+	bd->io.end	= offset + (widget << SWIN_SIZE_BITS) + SWIN_SIZE - 1;
 	bd->io.flags	= IORESOURCE_IO;
 	bd->io_offset	= offset;
 
@@ -81,6 +107,8 @@ static int probe_one_port(nasid_t nasid, int widget, int masterwid)
 		bridge_platform_create(nasid, widget, masterwid);
 		break;
 	default:
+		pr_info("xtalk:n%d/%d unknown widget (0x%x)\n",
+			nasid, widget, partnum);
 		break;
 	}
 
-- 
2.13.7

