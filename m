Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5A53A267B01
	for <lists+netdev@lfdr.de>; Sat, 12 Sep 2020 16:46:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725957AbgILOqg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 12 Sep 2020 10:46:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51126 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725899AbgILOmL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 12 Sep 2020 10:42:11 -0400
Received: from mail-ej1-x642.google.com (mail-ej1-x642.google.com [IPv6:2a00:1450:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 65A60C0617A0;
        Sat, 12 Sep 2020 07:41:46 -0700 (PDT)
Received: by mail-ej1-x642.google.com with SMTP id z23so17207138ejr.13;
        Sat, 12 Sep 2020 07:41:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=HcESE1FCoANLJRH2tfpBkk5s96E77M9A9Y/BCydk/Rc=;
        b=YDWVC28D5D0O9uogeOIYtKxrxYQkVMu26wWujTrziKvb46bKNmQX/2GwlyZEEijch9
         RfFUG9sang7QxRCnwmI/EaN6tnaKQ6jioFMMPy+pWfubNGbfoJUb8Y+Gjl+EhAyW0Ggq
         Us7y5Tzx8aOA4fpH1UDsyEWooD0PxZ8t62E0fu6A5zfvzh61hjgwh2USE5fSws83z+IY
         6m80poWLH1ihSx5czadbGtrbRO5EwHl+cF9CptQyJZy3Br42qetOlJ7HDF7wRQjlFJ/B
         ScHfw5Yi3EUe5y/veqn0tsunPM4yrf/tbFLT6y0akZ6csFNXheMKt2MFnEMDhvnO5Oxj
         1x9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=HcESE1FCoANLJRH2tfpBkk5s96E77M9A9Y/BCydk/Rc=;
        b=S2h722Xre+fZE5yLl25zX6xjNSFTUNuU8NPeaGwMvRAHLOUfJXmg6WAa/yHbp8fnQf
         N/LPAeSdxVoeQqNe1jCQltm2+BGYkwfyv3dKzEBFAX4OgmOI6sqxmqxoOrjxRAIOczRl
         gMC3MmSgzAIG6loy6RrhZgVCSkq5mZx7OBD097b97S5Nr2XTjH2yF63pul0sfpA4VfEy
         s4qdzeYmJ6K0OUC3on47QI7RgV7mE/0HZxrude/ObeVIg4GEYerh88SJXkhkd1fIrlV+
         edMTtqu6Tqc3MJiUAW2gp49VIzXnmzHUcD68tsSfW8ZqgKGd40skiq3Rqb6OIB0PrwT1
         55vg==
X-Gm-Message-State: AOAM531C+V30G76hbRxIdIibdgOf87OWzSQDf6P6LVeOfSW5OiWet1rW
        vCcZdraXfdU5/j8N2PKT6gKjL3+AncQ=
X-Google-Smtp-Source: ABdhPJwGWNS+DmGohZslyrDXs6ff8meXCL/GtQlwCSWOg2ugJPy0s4UC0KiRJNk9riRJEhBG8GA1OQ==
X-Received: by 2002:a17:906:f90c:: with SMTP id lc12mr6188010ejb.104.1599921704457;
        Sat, 12 Sep 2020 07:41:44 -0700 (PDT)
Received: from ogabbay-VM.habana-labs.com ([213.57.90.10])
        by smtp.gmail.com with ESMTPSA id y25sm4842938edv.15.2020.09.12.07.41.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 12 Sep 2020 07:41:43 -0700 (PDT)
From:   Oded Gabbay <oded.gabbay@gmail.com>
To:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Cc:     SW_Drivers@habana.ai, gregkh@linuxfoundation.org,
        davem@davemloft.net, kuba@kernel.org, andrew@lunn.ch,
        f.fainelli@gmail.com, Omer Shpigelman <oshpigelman@habana.ai>
Subject: [PATCH v2 13/14] habanalabs/gaudi: support DCB protocol
Date:   Sat, 12 Sep 2020 17:41:05 +0300
Message-Id: <20200912144106.11799-14-oded.gabbay@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200912144106.11799-1-oded.gabbay@gmail.com>
References: <20200912144106.11799-1-oded.gabbay@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Omer Shpigelman <oshpigelman@habana.ai>

Add DCB support to configure the NIC's Priority Flow Control (PFC).
The added support is minimal because a full support is not
currently required.

A summary of the supported callbacks:

- ieee_getpfc: get the current PFC configuration. PFC is enabled by
               default.
- ieee_setpfc: set PFC configuration. Only 0 or all 4 priorities can be
               enabled, no subset is allowed.
- getdcbx: get DCBX capability.
- setdcbx: set DCBX capability. Only host LLDP agent and IEEE protocol
           flavors are supported.

Signed-off-by: Omer Shpigelman <oshpigelman@habana.ai>
Reviewed-by: Oded Gabbay <oded.gabbay@gmail.com>
Signed-off-by: Oded Gabbay <oded.gabbay@gmail.com>
---
Changes in v2:
  - Fix all instances of reverse Christmas tree

 drivers/misc/habanalabs/gaudi/Makefile        |   2 +-
 drivers/misc/habanalabs/gaudi/gaudi_nic.c     |   3 +
 .../misc/habanalabs/gaudi/gaudi_nic_dcbnl.c   | 108 ++++++++++++++++++
 3 files changed, 112 insertions(+), 1 deletion(-)
 create mode 100644 drivers/misc/habanalabs/gaudi/gaudi_nic_dcbnl.c

diff --git a/drivers/misc/habanalabs/gaudi/Makefile b/drivers/misc/habanalabs/gaudi/Makefile
index df674c5973e0..0345c91c40f8 100644
--- a/drivers/misc/habanalabs/gaudi/Makefile
+++ b/drivers/misc/habanalabs/gaudi/Makefile
@@ -3,4 +3,4 @@ HL_GAUDI_FILES := gaudi/gaudi.o gaudi/gaudi_hwmgr.o gaudi/gaudi_security.o \
 	gaudi/gaudi_coresight.o
 
 HL_GAUDI_FILES += gaudi/gaudi_nic.o gaudi/gaudi_phy.o \
-	gaudi/gaudi_nic_ethtool.o
+	gaudi/gaudi_nic_ethtool.o gaudi/gaudi_nic_dcbnl.o
diff --git a/drivers/misc/habanalabs/gaudi/gaudi_nic.c b/drivers/misc/habanalabs/gaudi/gaudi_nic.c
index c97e5f0e1c53..83d369ffbd89 100644
--- a/drivers/misc/habanalabs/gaudi/gaudi_nic.c
+++ b/drivers/misc/habanalabs/gaudi/gaudi_nic.c
@@ -2779,6 +2779,9 @@ static int port_register(struct hl_device *hdev, int port)
 
 	ndev->netdev_ops = &gaudi_nic_netdev_ops;
 	ndev->ethtool_ops = &gaudi_nic_ethtool_ops;
+#ifdef CONFIG_DCB
+	ndev->dcbnl_ops = &gaudi_nic_dcbnl_ops;
+#endif
 	ndev->watchdog_timeo = NIC_TX_TIMEOUT;
 	ndev->min_mtu = ETH_MIN_MTU;
 	ndev->max_mtu = NIC_MAX_MTU;
diff --git a/drivers/misc/habanalabs/gaudi/gaudi_nic_dcbnl.c b/drivers/misc/habanalabs/gaudi/gaudi_nic_dcbnl.c
new file mode 100644
index 000000000000..87394f50400a
--- /dev/null
+++ b/drivers/misc/habanalabs/gaudi/gaudi_nic_dcbnl.c
@@ -0,0 +1,108 @@
+// SPDX-License-Identifier: GPL-2.0
+
+/*
+ * Copyright 2018-2020 HabanaLabs, Ltd.
+ * All Rights Reserved.
+ */
+
+#include "gaudi_nic.h"
+
+#define PFC_PRIO_NUM		4
+#define PFC_PRIO_MASK_ALL	GENMASK(PFC_PRIO_NUM - 1, 0)
+#define PFC_PRIO_MASK_NONE	0
+#define PFC_STAT_TX_OFFSET	17
+#define PFC_STAT_RX_OFFSET	27
+
+#ifdef CONFIG_DCB
+static int gaudi_nic_dcbnl_ieee_getpfc(struct net_device *netdev,
+					struct ieee_pfc *pfc)
+{
+	struct gaudi_nic_device **ptr = netdev_priv(netdev);
+	struct gaudi_nic_device *gaudi_nic = *ptr;
+	struct hl_device *hdev = gaudi_nic->hdev;
+	int rc = 0, i, tx_idx, rx_idx;
+	u32 port = gaudi_nic->port;
+
+	if (disabled_or_in_reset(gaudi_nic)) {
+		dev_info_ratelimited(hdev->dev,
+				"port %d is in reset, can't get PFC", port);
+		return -EBUSY;
+	}
+
+	pfc->pfc_en = gaudi_nic->pfc_enable ? PFC_PRIO_MASK_ALL :
+							PFC_PRIO_MASK_NONE;
+	pfc->pfc_cap = PFC_PRIO_NUM;
+
+	for (i = 0 ; i < PFC_PRIO_NUM ; i++) {
+		tx_idx = PFC_STAT_TX_OFFSET + i;
+		rx_idx = PFC_STAT_RX_OFFSET + i;
+
+		pfc->requests[i] = gaudi_nic_read_mac_stat_counter(hdev, port,
+								tx_idx, false);
+		pfc->indications[i] = gaudi_nic_read_mac_stat_counter(hdev,
+							port, rx_idx, true);
+	}
+
+	return rc;
+}
+
+static int gaudi_nic_dcbnl_ieee_setpfc(struct net_device *netdev,
+					struct ieee_pfc *pfc)
+{
+	struct gaudi_nic_device **ptr = netdev_priv(netdev);
+	struct gaudi_nic_device *gaudi_nic = *ptr;
+	struct hl_device *hdev = gaudi_nic->hdev;
+	u32 port = gaudi_nic->port;
+	u8 curr_pfc_en;
+
+	if (pfc->pfc_en & ~PFC_PRIO_MASK_ALL) {
+		dev_info_ratelimited(hdev->dev,
+					"PFC supports %d priorities only, port %d\n",
+					PFC_PRIO_NUM, port);
+		return -EINVAL;
+	}
+
+	if ((pfc->pfc_en != PFC_PRIO_MASK_NONE) &&
+			(pfc->pfc_en != PFC_PRIO_MASK_ALL)) {
+		dev_info_ratelimited(hdev->dev,
+					"PFC should be enabled/disabled on all priorities, port %d\n",
+					port);
+		return -EINVAL;
+	}
+
+	if (disabled_or_in_reset(gaudi_nic)) {
+		dev_info_ratelimited(hdev->dev,
+				"port %d is in reset, can't set PFC", port);
+		return -EBUSY;
+	}
+
+	curr_pfc_en = gaudi_nic->pfc_enable ? PFC_PRIO_MASK_ALL :
+							PFC_PRIO_MASK_NONE;
+
+	if (pfc->pfc_en == curr_pfc_en)
+		return 0;
+
+	gaudi_nic->pfc_enable = !gaudi_nic->pfc_enable;
+
+	gaudi_nic_set_pfc(gaudi_nic);
+
+	return 0;
+}
+
+static u8 gaudi_nic_dcbnl_getdcbx(struct net_device *netdev)
+{
+	return DCB_CAP_DCBX_HOST | DCB_CAP_DCBX_VER_IEEE;
+}
+
+static u8 gaudi_nic_dcbnl_setdcbx(struct net_device *netdev, u8 mode)
+{
+	return !(mode == (DCB_CAP_DCBX_HOST | DCB_CAP_DCBX_VER_IEEE));
+}
+
+const struct dcbnl_rtnl_ops gaudi_nic_dcbnl_ops = {
+	.ieee_getpfc	= gaudi_nic_dcbnl_ieee_getpfc,
+	.ieee_setpfc	= gaudi_nic_dcbnl_ieee_setpfc,
+	.getdcbx	= gaudi_nic_dcbnl_getdcbx,
+	.setdcbx	= gaudi_nic_dcbnl_setdcbx
+};
+#endif
-- 
2.17.1

