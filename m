Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 69A87264DBB
	for <lists+netdev@lfdr.de>; Thu, 10 Sep 2020 20:49:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726728AbgIJStV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Sep 2020 14:49:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43894 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726722AbgIJQMn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Sep 2020 12:12:43 -0400
Received: from mail-ej1-x643.google.com (mail-ej1-x643.google.com [IPv6:2a00:1450:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C4B20C0617B1;
        Thu, 10 Sep 2020 09:12:23 -0700 (PDT)
Received: by mail-ej1-x643.google.com with SMTP id o8so9522442ejb.10;
        Thu, 10 Sep 2020 09:12:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=3UPlh3Kyd3Y4TY4RZl2rxdxtBbfraaBRvID8Rle5+Mg=;
        b=lO1VWBQFmH6VbAkxjDb2ACXNSiPX+dHed6wE3ZYfJr4XS+bsNTjLsh1JadXJWQjo97
         ezKKVRjyorByCxs0EJR///Z/AG9qHjwHmdxyhDwTrprz1oLzWENWRZQDh6U6hZWjs9gx
         u7rb+oiIWdynm21MstjSZIRPW5LRXGfbWE6xTV/eeVl94zA0ZsmRUMfRcDmmPGo/UqVc
         u7X7cT7Y9/zesxbdMBysvW9q2rybKJSn3sIwf0Ejgo2cJQS9tYIv85D8NCXjzEjxOAJ1
         zCQkShSr2MtvlOqHGJvPua1AyIYFPb7iDC4QEvpN/KSg95+Xdga1+B+2rZ8qJA1RFbuu
         oezw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=3UPlh3Kyd3Y4TY4RZl2rxdxtBbfraaBRvID8Rle5+Mg=;
        b=ZiZOKIF5OQc335QVFBTe/HkZCDHqA3brukBup/592tFn0MeWgH1uGD3FO1h4+le55x
         s8Z6tedvI43m0srCJ7anYiSowtxvZ/TYu2lkUTOSRyiRfulSgt0gekKIm/EOvOYObfUR
         kTVn7EeLCja6TRFMMPSsb/y6XmILRnGAD6+fMfb8y9PKjK2/Q51BUv0/0EKMWfF2Jt+F
         umvFCw0m8MM3507kHUEysrumVeSNvQm/o4MEykICOu2ZfqEH3zBB7GyUel9NVvsdH2vx
         AR9ZUB7Ue/EVMM4Fkr1GXYpdxIz6HZ2665KPfRJ9/RFrqIrjpemcoKj62krSSmK4KvIB
         At2A==
X-Gm-Message-State: AOAM5316/hdlhzHZdtWrZqv+etFdjSHHNZpu0UJqTighPx52VvgdFx0v
        RMkfKajohNn6I68m8h4o8qFhOagH7AI=
X-Google-Smtp-Source: ABdhPJwuPFVkddrm9qgD0Me87o7ek6S63oGuv2UvRGFK5ilTr/vcltRTOb35DXF9pe6B2rAzYrYNOQ==
X-Received: by 2002:a17:906:cf82:: with SMTP id um2mr9523837ejb.49.1599754341751;
        Thu, 10 Sep 2020 09:12:21 -0700 (PDT)
Received: from ogabbay-VM.habana-labs.com ([213.57.90.10])
        by smtp.gmail.com with ESMTPSA id k8sm7282911ejz.60.2020.09.10.09.12.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Sep 2020 09:12:20 -0700 (PDT)
From:   Oded Gabbay <oded.gabbay@gmail.com>
To:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Cc:     SW_Drivers@habana.ai, gregkh@linuxfoundation.org,
        davem@davemloft.net, kuba@kernel.org,
        Omer Shpigelman <oshpigelman@habana.ai>
Subject: [PATCH 14/15] habanalabs/gaudi: support DCB protocol
Date:   Thu, 10 Sep 2020 19:11:25 +0300
Message-Id: <20200910161126.30948-15-oded.gabbay@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200910161126.30948-1-oded.gabbay@gmail.com>
References: <20200910161126.30948-1-oded.gabbay@gmail.com>
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
 drivers/misc/habanalabs/gaudi/Makefile        |   2 +-
 drivers/misc/habanalabs/gaudi/gaudi_nic.c     |   3 +
 .../misc/habanalabs/gaudi/gaudi_nic_dcbnl.c   | 108 ++++++++++++++++++
 3 files changed, 112 insertions(+), 1 deletion(-)
 create mode 100644 drivers/misc/habanalabs/gaudi/gaudi_nic_dcbnl.c

diff --git a/drivers/misc/habanalabs/gaudi/Makefile b/drivers/misc/habanalabs/gaudi/Makefile
index e3002dc34a74..9757c8ba1cb0 100644
--- a/drivers/misc/habanalabs/gaudi/Makefile
+++ b/drivers/misc/habanalabs/gaudi/Makefile
@@ -3,5 +3,5 @@ HL_GAUDI_FILES := gaudi/gaudi.o gaudi/gaudi_hwmgr.o gaudi/gaudi_security.o \
 	gaudi/gaudi_coresight.o
 
 HL_GAUDI_FILES += gaudi/gaudi_nic.o gaudi/gaudi_phy.o \
-	gaudi/gaudi_nic_ethtool.o \
+	gaudi/gaudi_nic_ethtool.o gaudi/gaudi_nic_dcbnl.o \
 	gaudi/gaudi_nic_debugfs.o
diff --git a/drivers/misc/habanalabs/gaudi/gaudi_nic.c b/drivers/misc/habanalabs/gaudi/gaudi_nic.c
index 108db990efa8..1ea410cdafdf 100644
--- a/drivers/misc/habanalabs/gaudi/gaudi_nic.c
+++ b/drivers/misc/habanalabs/gaudi/gaudi_nic.c
@@ -2745,6 +2745,9 @@ static int port_register(struct hl_device *hdev, int port)
 
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
index 000000000000..b8f37fd0d3cf
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
+	u32 port = gaudi_nic->port;
+	int rc = 0, i, tx_idx, rx_idx;
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

