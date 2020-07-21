Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 04D6922811F
	for <lists+netdev@lfdr.de>; Tue, 21 Jul 2020 15:39:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728461AbgGUNjX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Jul 2020 09:39:23 -0400
Received: from smtp-fw-2101.amazon.com ([72.21.196.25]:48328 "EHLO
        smtp-fw-2101.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726654AbgGUNjW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Jul 2020 09:39:22 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1595338762; x=1626874762;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version;
  bh=oeH0hoPJ0+k7iwriWkaDswnJY3tHHRurSF/fOJok06k=;
  b=oqDg+UQ2ZFyj6DHcSpEvoEESwkZtbB3utHhwsGD3W/Z9EVfaDTVe42sg
   Pp046bS+uOdTK6FRIkbnypa1vQjnFKQUigsZ0C8QMMfhH4UHzsB9cg6zc
   4yQumI58x7sUSzRfobAEAli10sT60nYNx8HUYtf2AO8x91ZZg4+5yXQ+b
   c=;
IronPort-SDR: +4zlJSNh3A45xLHoyXMma5v2bURXjQuCd1lFa6WJGygc+RB63p95Sc3e0WsCA8AKVjv0OJlxO3
 QEJjYQD3F4qQ==
X-IronPort-AV: E=Sophos;i="5.75,379,1589241600"; 
   d="scan'208";a="43139184"
Received: from iad12-co-svc-p1-lb1-vlan2.amazon.com (HELO email-inbound-relay-1a-807d4a99.us-east-1.amazon.com) ([10.43.8.2])
  by smtp-border-fw-out-2101.iad2.amazon.com with ESMTP; 21 Jul 2020 13:39:19 +0000
Received: from EX13MTAUWA001.ant.amazon.com (iad55-ws-svc-p15-lb9-vlan3.iad.amazon.com [10.40.159.166])
        by email-inbound-relay-1a-807d4a99.us-east-1.amazon.com (Postfix) with ESMTPS id AC495A2283;
        Tue, 21 Jul 2020 13:39:18 +0000 (UTC)
Received: from EX13D21UWA001.ant.amazon.com (10.43.160.154) by
 EX13MTAUWA001.ant.amazon.com (10.43.160.58) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Tue, 21 Jul 2020 13:38:59 +0000
Received: from EX13MTAUWA001.ant.amazon.com (10.43.160.58) by
 EX13D21UWA001.ant.amazon.com (10.43.160.154) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Tue, 21 Jul 2020 13:38:59 +0000
Received: from HFA15-G63729NC.amazon.com (10.1.213.6) by mail-relay.amazon.com
 (10.43.160.118) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Tue, 21 Jul 2020 13:38:54 +0000
From:   <akiyano@amazon.com>
To:     <davem@davemloft.net>, <netdev@vger.kernel.org>
CC:     Arthur Kiyanovski <akiyano@amazon.com>, <dwmw@amazon.com>,
        <zorik@amazon.com>, <matua@amazon.com>, <saeedb@amazon.com>,
        <msw@amazon.com>, <aliguori@amazon.com>, <nafea@amazon.com>,
        <gtzalik@amazon.com>, <netanel@amazon.com>, <alisaidi@amazon.com>,
        <benh@amazon.com>, <ndagan@amazon.com>, <shayagr@amazon.com>,
        <sameehj@amazon.com>
Subject: [PATCH V3 net-next 6/8] net: ena: enable support of rss hash key and function changes
Date:   Tue, 21 Jul 2020 16:38:09 +0300
Message-ID: <1595338691-3130-7-git-send-email-akiyano@amazon.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1595338691-3130-1-git-send-email-akiyano@amazon.com>
References: <1595338691-3130-1-git-send-email-akiyano@amazon.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Arthur Kiyanovski <akiyano@amazon.com>

Add the rss_configurable_function_key bit to driver_supported_feature.

This bit tells the device that the driver in question supports the
retrieving and updating of RSS function and hash key, and therefore
the device should allow RSS function and key manipulation.

This commit turns on  device support for hash key and RSS function
management. Without this commit this feature is turned off at the
device and appears to the user as unsupported.

This commit concludes the following series of already merged commits:
commit 0af3c4e2eab8 ("net: ena: changes to RSS hash key allocation")
commit c1bd17e51c71 ("net: ena: change default RSS hash function to Toeplitz")
commit f66c2ea3b18a ("net: ena: allow setting the hash function without changing the key")
commit e9a1de378dd4 ("net: ena: fix error returning in ena_com_get_hash_function()")
commit 80f8443fcdaa ("net: ena: avoid unnecessary admin command when RSS function set fails")
commit 6a4f7dc82d1e ("net: ena: rss: do not allocate key when not supported")
commit 0d1c3de7b8c7 ("net: ena: fix incorrect default RSS key")

The above commits represent the last part of the implementation of
this feature, and with them merged the feature can be enabled
in the device.

Signed-off-by: Arthur Kiyanovski <akiyano@amazon.com>
---
 drivers/net/ethernet/amazon/ena/ena_admin_defs.h | 5 ++++-
 drivers/net/ethernet/amazon/ena/ena_netdev.c     | 3 ++-
 2 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/amazon/ena/ena_admin_defs.h b/drivers/net/ethernet/amazon/ena/ena_admin_defs.h
index afe87ff09b20..7f7978b135a9 100644
--- a/drivers/net/ethernet/amazon/ena/ena_admin_defs.h
+++ b/drivers/net/ethernet/amazon/ena/ena_admin_defs.h
@@ -817,7 +817,8 @@ struct ena_admin_host_info {
 	 * 1 : rx_offset
 	 * 2 : interrupt_moderation
 	 * 3 : rx_buf_mirroring
-	 * 31:4 : reserved
+	 * 4 : rss_configurable_function_key
+	 * 31:5 : reserved
 	 */
 	u32 driver_supported_features;
 };
@@ -1132,6 +1133,8 @@ struct ena_admin_ena_mmio_req_read_less_resp {
 #define ENA_ADMIN_HOST_INFO_INTERRUPT_MODERATION_MASK       BIT(2)
 #define ENA_ADMIN_HOST_INFO_RX_BUF_MIRRORING_SHIFT          3
 #define ENA_ADMIN_HOST_INFO_RX_BUF_MIRRORING_MASK           BIT(3)
+#define ENA_ADMIN_HOST_INFO_RSS_CONFIGURABLE_FUNCTION_KEY_SHIFT 4
+#define ENA_ADMIN_HOST_INFO_RSS_CONFIGURABLE_FUNCTION_KEY_MASK BIT(4)
 
 /* aenq_common_desc */
 #define ENA_ADMIN_AENQ_COMMON_DESC_PHASE_MASK               BIT(0)
diff --git a/drivers/net/ethernet/amazon/ena/ena_netdev.c b/drivers/net/ethernet/amazon/ena/ena_netdev.c
index 0563cb3125db..491ea013868b 100644
--- a/drivers/net/ethernet/amazon/ena/ena_netdev.c
+++ b/drivers/net/ethernet/amazon/ena/ena_netdev.c
@@ -3126,7 +3126,8 @@ static void ena_config_host_info(struct ena_com_dev *ena_dev, struct pci_dev *pd
 	host_info->driver_supported_features =
 		ENA_ADMIN_HOST_INFO_RX_OFFSET_MASK |
 		ENA_ADMIN_HOST_INFO_INTERRUPT_MODERATION_MASK |
-		ENA_ADMIN_HOST_INFO_RX_BUF_MIRRORING_MASK;
+		ENA_ADMIN_HOST_INFO_RX_BUF_MIRRORING_MASK |
+		ENA_ADMIN_HOST_INFO_RSS_CONFIGURABLE_FUNCTION_KEY_MASK;
 
 	rc = ena_com_set_host_attributes(ena_dev);
 	if (rc) {
-- 
2.23.3

