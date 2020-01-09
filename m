Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3C720135D25
	for <lists+netdev@lfdr.de>; Thu,  9 Jan 2020 16:46:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732627AbgAIPpz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Jan 2020 10:45:55 -0500
Received: from dispatch1-us1.ppe-hosted.com ([67.231.154.164]:51322 "EHLO
        dispatch1-us1.ppe-hosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728293AbgAIPpz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Jan 2020 10:45:55 -0500
X-Virus-Scanned: Proofpoint Essentials engine
Received: from webmail.solarflare.com (uk.solarflare.com [193.34.186.16])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1-us4.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id A3776B40064;
        Thu,  9 Jan 2020 15:45:53 +0000 (UTC)
Received: from amm-opti7060.uk.solarflarecom.com (10.17.20.147) by
 ukex01.SolarFlarecom.com (10.17.10.4) with Microsoft SMTP Server (TLS) id
 15.0.1395.4; Thu, 9 Jan 2020 15:45:48 +0000
From:   "Alex Maftei (amaftei)" <amaftei@solarflare.com>
Subject: [PATCH net-next 9/9] sfc: move MCDI logging device attribute
To:     <netdev@vger.kernel.org>, <davem@davemloft.net>
CC:     <linux-net-drivers@solarflare.com>, <scrum-linux@solarflare.com>
References: <4d915542-3699-e864-5558-bef616b2fe66@solarflare.com>
Message-ID: <4a37492c-a0b0-a8c6-8694-025736764ed5@solarflare.com>
Date:   Thu, 9 Jan 2020 15:45:45 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <4d915542-3699-e864-5558-bef616b2fe66@solarflare.com>
Content-Type: text/plain; charset="windows-1252"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.17.20.147]
X-ClientProxiedBy: ocex03.SolarFlarecom.com (10.20.40.36) To
 ukex01.SolarFlarecom.com (10.17.10.4)
X-TM-AS-Product-Ver: SMEX-12.5.0.1300-8.5.1010-25156.003
X-TM-AS-Result: No-7.611700-8.000000-10
X-TMASE-MatchedRID: OSnJHwiFPR+7MyWVQJ6Bl6iUivh0j2Pv6VTG9cZxEjJwGpdgNQ0JrHIo
        zGa69omdrdoLblq9S5qnJ7eS8LcE2dQ2aCZEo62uD3uYMxd01bfUrdux7cWNO+bnFWpNX1DB33p
        XY2CsQeJT/Tz7ESixEodSu47z6ASJrjwZVDJcDJ8SEYfcJF0pRTxWJr0lgcJAAOHc9Ujlhb056G
        dZxUF9VvZxvfF2IHFpU7bluV/02rDLua/qdYfP7J4CIKY/Hg3AtOt1ofVlaoLdOt3I7hra7foLR
        4+zsDTtD12T7q2dIUvyZXaei49Kd4ZjqcTaurkRjEK3X+ykl420lN6BOkzXrQ==
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
X-TMASE-Result: 10--7.611700-8.000000
X-TMASE-Version: SMEX-12.5.0.1300-8.5.1010-25156.003
X-MDID: 1578584754-0l4mHQsWEAcA
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

A few bits were extracted from other functions.

Signed-off-by: Alexandru-Mihai Maftei <amaftei@solarflare.com>
---
 drivers/net/ethernet/sfc/efx.c        | 40 ++-------------------------
 drivers/net/ethernet/sfc/efx_common.c | 39 ++++++++++++++++++++++++++
 drivers/net/ethernet/sfc/efx_common.h |  8 ++++++
 3 files changed, 50 insertions(+), 37 deletions(-)

diff --git a/drivers/net/ethernet/sfc/efx.c b/drivers/net/ethernet/sfc/efx.c
index 33b6ed03b3ea..4affae76b03c 100644
--- a/drivers/net/ethernet/sfc/efx.c
+++ b/drivers/net/ethernet/sfc/efx.c
@@ -1036,28 +1036,6 @@ show_phy_type(struct device *dev, struct device_attribute *attr, char *buf)
 }
 static DEVICE_ATTR(phy_type, 0444, show_phy_type, NULL);
 
-#ifdef CONFIG_SFC_MCDI_LOGGING
-static ssize_t show_mcdi_log(struct device *dev, struct device_attribute *attr,
-			     char *buf)
-{
-	struct efx_nic *efx = dev_get_drvdata(dev);
-	struct efx_mcdi_iface *mcdi = efx_mcdi(efx);
-
-	return scnprintf(buf, PAGE_SIZE, "%d\n", mcdi->logging_enabled);
-}
-static ssize_t set_mcdi_log(struct device *dev, struct device_attribute *attr,
-			    const char *buf, size_t count)
-{
-	struct efx_nic *efx = dev_get_drvdata(dev);
-	struct efx_mcdi_iface *mcdi = efx_mcdi(efx);
-	bool enable = count > 0 && *buf != '0';
-
-	mcdi->logging_enabled = enable;
-	return count;
-}
-static DEVICE_ATTR(mcdi_logging, 0644, show_mcdi_log, set_mcdi_log);
-#endif
-
 static int efx_register_netdev(struct efx_nic *efx)
 {
 	struct net_device *net_dev = efx->net_dev;
@@ -1117,21 +1095,11 @@ static int efx_register_netdev(struct efx_nic *efx)
 			  "failed to init net dev attributes\n");
 		goto fail_registered;
 	}
-#ifdef CONFIG_SFC_MCDI_LOGGING
-	rc = device_create_file(&efx->pci_dev->dev, &dev_attr_mcdi_logging);
-	if (rc) {
-		netif_err(efx, drv, efx->net_dev,
-			  "failed to init net dev attributes\n");
-		goto fail_attr_mcdi_logging;
-	}
-#endif
+
+	efx_init_mcdi_logging(efx);
 
 	return 0;
 
-#ifdef CONFIG_SFC_MCDI_LOGGING
-fail_attr_mcdi_logging:
-	device_remove_file(&efx->pci_dev->dev, &dev_attr_phy_type);
-#endif
 fail_registered:
 	rtnl_lock();
 	efx_dissociate(efx);
@@ -1152,9 +1120,7 @@ static void efx_unregister_netdev(struct efx_nic *efx)
 
 	if (efx_dev_registered(efx)) {
 		strlcpy(efx->name, pci_name(efx->pci_dev), sizeof(efx->name));
-#ifdef CONFIG_SFC_MCDI_LOGGING
-		device_remove_file(&efx->pci_dev->dev, &dev_attr_mcdi_logging);
-#endif
+		efx_fini_mcdi_logging(efx);
 		device_remove_file(&efx->pci_dev->dev, &dev_attr_phy_type);
 		unregister_netdev(efx->net_dev);
 	}
diff --git a/drivers/net/ethernet/sfc/efx_common.c b/drivers/net/ethernet/sfc/efx_common.c
index 3add2b577503..9cd7c1550c08 100644
--- a/drivers/net/ethernet/sfc/efx_common.c
+++ b/drivers/net/ethernet/sfc/efx_common.c
@@ -1006,3 +1006,42 @@ void efx_fini_io(struct efx_nic *efx, int bar)
 	if (!pci_vfs_assigned(efx->pci_dev))
 		pci_disable_device(efx->pci_dev);
 }
+
+#ifdef CONFIG_SFC_MCDI_LOGGING
+static ssize_t show_mcdi_log(struct device *dev, struct device_attribute *attr,
+			     char *buf)
+{
+	struct efx_nic *efx = dev_get_drvdata(dev);
+	struct efx_mcdi_iface *mcdi = efx_mcdi(efx);
+
+	return scnprintf(buf, PAGE_SIZE, "%d\n", mcdi->logging_enabled);
+}
+
+static ssize_t set_mcdi_log(struct device *dev, struct device_attribute *attr,
+			    const char *buf, size_t count)
+{
+	struct efx_nic *efx = dev_get_drvdata(dev);
+	struct efx_mcdi_iface *mcdi = efx_mcdi(efx);
+	bool enable = count > 0 && *buf != '0';
+
+	mcdi->logging_enabled = enable;
+	return count;
+}
+
+static DEVICE_ATTR(mcdi_logging, 0644, show_mcdi_log, set_mcdi_log);
+
+void efx_init_mcdi_logging(struct efx_nic *efx)
+{
+	int rc = device_create_file(&efx->pci_dev->dev, &dev_attr_mcdi_logging);
+
+	if (rc) {
+		netif_warn(efx, drv, efx->net_dev,
+			   "failed to init net dev attributes\n");
+	}
+}
+
+void efx_fini_mcdi_logging(struct efx_nic *efx)
+{
+	device_remove_file(&efx->pci_dev->dev, &dev_attr_mcdi_logging);
+}
+#endif
diff --git a/drivers/net/ethernet/sfc/efx_common.h b/drivers/net/ethernet/sfc/efx_common.h
index c602e5257088..e03404d1dc0a 100644
--- a/drivers/net/ethernet/sfc/efx_common.h
+++ b/drivers/net/ethernet/sfc/efx_common.h
@@ -55,6 +55,14 @@ static inline int efx_check_disabled(struct efx_nic *efx)
 	return 0;
 }
 
+#ifdef CONFIG_SFC_MCDI_LOGGING
+void efx_init_mcdi_logging(struct efx_nic *efx);
+void efx_fini_mcdi_logging(struct efx_nic *efx);
+#else
+static inline void efx_init_mcdi_logging(struct efx_nic *efx) {}
+static inline void efx_fini_mcdi_logging(struct efx_nic *efx) {}
+#endif
+
 void efx_mac_reconfigure(struct efx_nic *efx);
 void efx_link_status_changed(struct efx_nic *efx);
 
-- 
2.20.1

