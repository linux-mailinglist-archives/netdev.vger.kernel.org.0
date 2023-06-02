Return-Path: <netdev+bounces-7401-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id BC0C77200BD
	for <lists+netdev@lfdr.de>; Fri,  2 Jun 2023 13:49:47 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id ED1BA2817FE
	for <lists+netdev@lfdr.de>; Fri,  2 Jun 2023 11:49:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4952318B08;
	Fri,  2 Jun 2023 11:49:44 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34E31156FC
	for <netdev@vger.kernel.org>; Fri,  2 Jun 2023 11:49:44 +0000 (UTC)
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B62CE10C2;
	Fri,  2 Jun 2023 04:49:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1685706554; x=1717242554;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=i8q5tBCE9Tvk3bz/ntyQFinJphOO7qsaUk4tCQhQBX0=;
  b=AZDRAmVIKqpCeni0Z3J7CQXu8HAzscyaJy+OVLjGWO8sjPTsTnirHxnU
   ivhGUCgnJx3ZlkgsqxaAjno3SaiX8Ar/yNsMatad+Hpsx901A5pjl9l4l
   cOcaM29UR1ZObS3LfbOX6/RwwXuGjbRT2Fw++InWO8Z5cttQoLSVdN+96
   SJkketjcnTTCseH/F7qulT06AGAQMpISKPb6ojcWuZVaUCPWmEyCKTpzj
   hWGrWE7aip8uYOCOnQT3xMevpiEKqpIDa6MMMhsE2UFOKcGodPuF6ehr2
   U9QbkzosORy0qN/xMM5y5toGox6UoVZa/SLeXXzUZNoGZtyVdiZR5fjpQ
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10728"; a="358279705"
X-IronPort-AV: E=Sophos;i="6.00,212,1681196400"; 
   d="scan'208";a="358279705"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Jun 2023 04:48:44 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10728"; a="707819498"
X-IronPort-AV: E=Sophos;i="6.00,212,1681196400"; 
   d="scan'208";a="707819498"
Received: from rspatil-mobl3.gar.corp.intel.com (HELO ijarvine-MOBL2.ger.corp.intel.com) ([10.251.208.112])
  by orsmga002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Jun 2023 04:48:36 -0700
From: =?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>
To: linux-pci@vger.kernel.org,
	Bjorn Helgaas <helgaas@kernel.org>,
	Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
	Rob Herring <robh@kernel.org>,
	=?UTF-8?q?Krzysztof=20Wilczy=C5=84ski?= <kw@linux.com>,
	Lukas Wunner <lukas@wunner.de>,
	"Rafael J . Wysocki" <rafael@kernel.org>,
	Heiner Kallweit <hkallweit1@gmail.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	Felix Fietkau <nbd@nbd.name>,
	Lorenzo Bianconi <lorenzo@kernel.org>,
	Ryder Lee <ryder.lee@mediatek.com>,
	Shayne Chen <shayne.chen@mediatek.com>,
	Sean Wang <sean.wang@mediatek.com>,
	Kalle Valo <kvalo@kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Matthias Brugger <matthias.bgg@gmail.com>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	linux-kernel@vger.kernel.org,
	linux-wireless@vger.kernel.org,
	netdev@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-mediatek@lists.infradead.org
Cc: =?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>
Subject: [RFC PATCH v1 07/13] mt76: Remove unreliable pci_disable_link_state() workaround
Date: Fri,  2 Jun 2023 14:47:44 +0300
Message-Id: <20230602114751.19671-8-ilpo.jarvinen@linux.intel.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20230602114751.19671-1-ilpo.jarvinen@linux.intel.com>
References: <20230602114751.19671-1-ilpo.jarvinen@linux.intel.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
	RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
	T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

pci_disable_link_state() was made reliable regardless of ASPM CONFIG
and OS being disallowed to change ASPM states to allow drivers to rely
on pci_disable_link_state() working.

Remove driver working around unreliable pci_disable_link_state() from
mt76 driver and just call pci_disable_link_state() directly.

Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
---

It's a bit unclear which of these devices really need ASPM disabled.
Probably all 76xx given the commit messages that added their disabling
but 79xx seems a lot more uncertain and handwavy.

mt7915 was done without observing any issue in commit 03b3dedc5de1
("mt76: mt7915: disable ASPM").

mt7921 re-enabled aspm in bf3747ae2e25 ("mt76: mt7921: enable aspm by
default").

mt7996 was added with aspm disabled.

I didn't convert these to quirk due to how unclear the situation
currently is (but for 76xx quirk would seem justified as there is
actually some evidence to back aspm being harmful).
---
 drivers/net/wireless/mediatek/mt76/Makefile   |  1 -
 drivers/net/wireless/mediatek/mt76/mt76.h     |  1 -
 .../net/wireless/mediatek/mt76/mt7615/pci.c   |  2 +-
 .../net/wireless/mediatek/mt76/mt76x0/pci.c   |  2 +-
 .../net/wireless/mediatek/mt76/mt76x2/pci.c   |  2 +-
 .../net/wireless/mediatek/mt76/mt7915/pci.c   |  2 +-
 .../net/wireless/mediatek/mt76/mt7921/pci.c   |  2 +-
 .../net/wireless/mediatek/mt76/mt7996/pci.c   |  2 +-
 drivers/net/wireless/mediatek/mt76/pci.c      | 47 -------------------
 9 files changed, 6 insertions(+), 55 deletions(-)
 delete mode 100644 drivers/net/wireless/mediatek/mt76/pci.c

diff --git a/drivers/net/wireless/mediatek/mt76/Makefile b/drivers/net/wireless/mediatek/mt76/Makefile
index 84c99b7e57f9..220e711840d3 100644
--- a/drivers/net/wireless/mediatek/mt76/Makefile
+++ b/drivers/net/wireless/mediatek/mt76/Makefile
@@ -10,7 +10,6 @@ mt76-y := \
 	mmio.o util.o trace.o dma.o mac80211.o debugfs.o eeprom.o \
 	tx.o agg-rx.o mcu.o
 
-mt76-$(CONFIG_PCI) += pci.o
 mt76-$(CONFIG_NL80211_TESTMODE) += testmode.o
 
 mt76-usb-y := usb.o usb_trace.o
diff --git a/drivers/net/wireless/mediatek/mt76/mt76.h b/drivers/net/wireless/mediatek/mt76/mt76.h
index 6b07b8fafec2..9beee339782e 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76.h
@@ -933,7 +933,6 @@ bool ____mt76_poll_msec(struct mt76_dev *dev, u32 offset, u32 mask, u32 val,
 #define mt76_poll_msec_tick(dev, ...) ____mt76_poll_msec(&((dev)->mt76), __VA_ARGS__)
 
 void mt76_mmio_init(struct mt76_dev *dev, void __iomem *regs);
-void mt76_pci_disable_aspm(struct pci_dev *pdev);
 
 static inline u16 mt76_chip(struct mt76_dev *dev)
 {
diff --git a/drivers/net/wireless/mediatek/mt76/mt7615/pci.c b/drivers/net/wireless/mediatek/mt76/mt7615/pci.c
index 9f43e673518b..d43efe4bf9e3 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7615/pci.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7615/pci.c
@@ -43,7 +43,7 @@ static int mt7615_pci_probe(struct pci_dev *pdev,
 	if (ret)
 		goto error;
 
-	mt76_pci_disable_aspm(pdev);
+	pci_disable_link_state(pdev, PCIE_LINK_STATE_L0S | PCIE_LINK_STATE_L1);
 
 	map = id->device == 0x7663 ? mt7663e_reg_map : mt7615e_reg_map;
 	ret = mt7615_mmio_probe(&pdev->dev, pcim_iomap_table(pdev)[0],
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x0/pci.c b/drivers/net/wireless/mediatek/mt76/mt76x0/pci.c
index 9277ff38b7a2..49c7a63cb1f6 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x0/pci.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x0/pci.c
@@ -181,7 +181,7 @@ mt76x0e_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	if (ret)
 		return ret;
 
-	mt76_pci_disable_aspm(pdev);
+	pci_disable_link_state(pdev, PCIE_LINK_STATE_L0S | PCIE_LINK_STATE_L1);
 
 	mdev = mt76_alloc_device(&pdev->dev, sizeof(*dev), &mt76x0e_ops,
 				 &drv_ops);
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2/pci.c b/drivers/net/wireless/mediatek/mt76/mt76x2/pci.c
index df85ebc6e1df..de6eb593ab59 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2/pci.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2/pci.c
@@ -85,7 +85,7 @@ mt76x2e_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	/* RG_SSUSB_CDR_BR_PE1D = 0x3 */
 	mt76_rmw_field(dev, 0x15c58, 0x3 << 6, 0x3);
 
-	mt76_pci_disable_aspm(pdev);
+	pci_disable_link_state(pdev, PCIE_LINK_STATE_L0S | PCIE_LINK_STATE_L1);
 
 	return 0;
 
diff --git a/drivers/net/wireless/mediatek/mt76/mt7915/pci.c b/drivers/net/wireless/mediatek/mt76/mt7915/pci.c
index 39132894e8ea..8cf9a1a6d851 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7915/pci.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7915/pci.c
@@ -122,7 +122,7 @@ static int mt7915_pci_probe(struct pci_dev *pdev,
 	if (ret)
 		return ret;
 
-	mt76_pci_disable_aspm(pdev);
+	pci_disable_link_state(pdev, PCIE_LINK_STATE_L0S | PCIE_LINK_STATE_L1);
 
 	if (id->device == 0x7916 || id->device == 0x790a)
 		return mt7915_pci_hif2_probe(pdev);
diff --git a/drivers/net/wireless/mediatek/mt76/mt7921/pci.c b/drivers/net/wireless/mediatek/mt76/mt7921/pci.c
index ddb1fa4ee01d..c9862e808cbb 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7921/pci.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7921/pci.c
@@ -286,7 +286,7 @@ static int mt7921_pci_probe(struct pci_dev *pdev,
 		goto err_free_pci_vec;
 
 	if (mt7921_disable_aspm)
-		mt76_pci_disable_aspm(pdev);
+		pci_disable_link_state(pdev, PCIE_LINK_STATE_L0S | PCIE_LINK_STATE_L1);
 
 	ops = mt7921_get_mac80211_ops(&pdev->dev, (void *)id->driver_data,
 				      &features);
diff --git a/drivers/net/wireless/mediatek/mt76/mt7996/pci.c b/drivers/net/wireless/mediatek/mt76/mt7996/pci.c
index 64aee3fb5445..273b72c58878 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7996/pci.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7996/pci.c
@@ -111,7 +111,7 @@ static int mt7996_pci_probe(struct pci_dev *pdev,
 	if (ret)
 		return ret;
 
-	mt76_pci_disable_aspm(pdev);
+	pci_disable_link_state(pdev, PCIE_LINK_STATE_L0S | PCIE_LINK_STATE_L1);
 
 	if (id->device == 0x7991)
 		return mt7996_pci_hif2_probe(pdev);
diff --git a/drivers/net/wireless/mediatek/mt76/pci.c b/drivers/net/wireless/mediatek/mt76/pci.c
deleted file mode 100644
index 4c1c159fbb62..000000000000
--- a/drivers/net/wireless/mediatek/mt76/pci.c
+++ /dev/null
@@ -1,47 +0,0 @@
-// SPDX-License-Identifier: ISC
-/*
- * Copyright (C) 2019 Lorenzo Bianconi <lorenzo@kernel.org>
- */
-
-#include "mt76.h"
-#include <linux/pci.h>
-
-void mt76_pci_disable_aspm(struct pci_dev *pdev)
-{
-	struct pci_dev *parent = pdev->bus->self;
-	u16 aspm_conf, parent_aspm_conf = 0;
-
-	pcie_capability_read_word(pdev, PCI_EXP_LNKCTL, &aspm_conf);
-	aspm_conf &= PCI_EXP_LNKCTL_ASPMC;
-	if (parent) {
-		pcie_capability_read_word(parent, PCI_EXP_LNKCTL,
-					  &parent_aspm_conf);
-		parent_aspm_conf &= PCI_EXP_LNKCTL_ASPMC;
-	}
-
-	if (!aspm_conf && (!parent || !parent_aspm_conf)) {
-		/* aspm already disabled */
-		return;
-	}
-
-	dev_info(&pdev->dev, "disabling ASPM %s %s\n",
-		 (aspm_conf & PCI_EXP_LNKCTL_ASPM_L0S) ? "L0s" : "",
-		 (aspm_conf & PCI_EXP_LNKCTL_ASPM_L1) ? "L1" : "");
-
-	if (IS_ENABLED(CONFIG_PCIEASPM)) {
-		int err;
-
-		err = pci_disable_link_state(pdev, aspm_conf);
-		if (!err)
-			return;
-	}
-
-	/* both device and parent should have the same ASPM setting.
-	 * disable ASPM in downstream component first and then upstream.
-	 */
-	pcie_capability_clear_word(pdev, PCI_EXP_LNKCTL, aspm_conf);
-	if (parent)
-		pcie_capability_clear_word(parent, PCI_EXP_LNKCTL,
-					   aspm_conf);
-}
-EXPORT_SYMBOL_GPL(mt76_pci_disable_aspm);
-- 
2.30.2


