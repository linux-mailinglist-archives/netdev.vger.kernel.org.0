Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7EC53D0C8A
	for <lists+netdev@lfdr.de>; Wed,  9 Oct 2019 12:19:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730902AbfJIKRg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Oct 2019 06:17:36 -0400
Received: from mx2.suse.de ([195.135.220.15]:32892 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1730734AbfJIKRd (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 9 Oct 2019 06:17:33 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 18FC8AE48;
        Wed,  9 Oct 2019 10:17:29 +0000 (UTC)
From:   Thomas Bogendoerfer <tbogendoerfer@suse.de>
To:     Jakub Kicinski <jakub.kicinski@netronome.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Ralf Baechle <ralf@linux-mips.org>,
        Paul Burton <paul.burton@mips.com>,
        James Hogan <jhogan@kernel.org>,
        Lee Jones <lee.jones@linaro.org>,
        "David S. Miller" <davem@davemloft.net>,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
        Alessandro Zummo <a.zummo@towertech.it>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.com>, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-mips@vger.kernel.org,
        netdev@vger.kernel.org, linux-rtc@vger.kernel.org,
        linux-serial@vger.kernel.org
Subject: [PATCH v8 5/5] MIPS: SGI-IP27: Enable ethernet phy on second Origin 200 module
Date:   Wed,  9 Oct 2019 12:17:12 +0200
Message-Id: <20191009101713.12238-6-tbogendoerfer@suse.de>
X-Mailer: git-send-email 2.16.4
In-Reply-To: <20191009101713.12238-1-tbogendoerfer@suse.de>
References: <20191009101713.12238-1-tbogendoerfer@suse.de>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

PROM only enables ethernet PHY on first Origin 200 module, so we must
do it ourselves for the second module.

Signed-off-by: Thomas Bogendoerfer <tbogendoerfer@suse.de>
---
 arch/mips/pci/pci-ip27.c | 22 ++++++++++++++++++++++
 1 file changed, 22 insertions(+)

diff --git a/arch/mips/pci/pci-ip27.c b/arch/mips/pci/pci-ip27.c
index 441eb9383b20..7cc784cb299b 100644
--- a/arch/mips/pci/pci-ip27.c
+++ b/arch/mips/pci/pci-ip27.c
@@ -7,6 +7,11 @@
  * Copyright (C) 1999, 2000, 04 Ralf Baechle (ralf@linux-mips.org)
  * Copyright (C) 1999, 2000 Silicon Graphics, Inc.
  */
+#include <asm/sn/addrs.h>
+#include <asm/sn/types.h>
+#include <asm/sn/klconfig.h>
+#include <asm/sn/hub.h>
+#include <asm/sn/ioc3.h>
 #include <asm/pci/bridge.h>
 
 dma_addr_t __phys_to_dma(struct device *dev, phys_addr_t paddr)
@@ -31,3 +36,20 @@ int pcibus_to_node(struct pci_bus *bus)
 }
 EXPORT_SYMBOL(pcibus_to_node);
 #endif /* CONFIG_NUMA */
+
+static void ip29_fixup_phy(struct pci_dev *dev)
+{
+	int nasid = pcibus_to_node(dev->bus);
+	u32 sid;
+
+	if (nasid != 1)
+		return; /* only needed on second module */
+
+	/* enable ethernet PHY on IP29 systemboard */
+	pci_read_config_dword(dev, PCI_SUBSYSTEM_VENDOR_ID, &sid);
+	if (sid == ((PCI_VENDOR_ID_SGI << 16) | IOC3_SUBSYS_IP29_SYSBOARD))
+		REMOTE_HUB_S(nasid, MD_LED0, 0x09);
+}
+
+DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_SGI, PCI_DEVICE_ID_SGI_IOC3,
+			ip29_fixup_phy);
-- 
2.16.4

