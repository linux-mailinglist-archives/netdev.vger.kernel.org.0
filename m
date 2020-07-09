Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 81D8221A782
	for <lists+netdev@lfdr.de>; Thu,  9 Jul 2020 21:06:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726659AbgGITGP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Jul 2020 15:06:15 -0400
Received: from smtp-fw-6002.amazon.com ([52.95.49.90]:36876 "EHLO
        smtp-fw-6002.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726116AbgGITGN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Jul 2020 15:06:13 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1594321573; x=1625857573;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version;
  bh=vDmyu9ZfCqGQ6c63yZbjgIh4LteNyiCb9CdnhZR4K3Y=;
  b=FLunReeDrFxtjlWqh2YEpjtwG0xAfm2JJcQ8kwj8FSVLCxKTbqj2KifJ
   xMjj0SAUV+ex6ocAjo1QTElmoEsQgKo2NGxP4JCmcAM35CbMb/zh8be9p
   m9r/CepGdLa2ANdTv2rKjwA2NF2zVggzFxjrYAbG7xzpxWhVa6nPYS3LW
   0=;
IronPort-SDR: FUnwQvqj9Yngo3Y6E5avEvvbttY0oLVcBfkQ58AHoBPGRyERlVOmbcs2++xNS5R4SCIPvF8GbU
 mmqT8Ge6k5tw==
X-IronPort-AV: E=Sophos;i="5.75,332,1589241600"; 
   d="scan'208";a="41020905"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-1a-67b371d8.us-east-1.amazon.com) ([10.43.8.6])
  by smtp-border-fw-out-6002.iad6.amazon.com with ESMTP; 09 Jul 2020 19:06:04 +0000
Received: from EX13MTAUWC001.ant.amazon.com (iad55-ws-svc-p15-lb9-vlan3.iad.amazon.com [10.40.159.166])
        by email-inbound-relay-1a-67b371d8.us-east-1.amazon.com (Postfix) with ESMTPS id A1B48A231D;
        Thu,  9 Jul 2020 19:06:03 +0000 (UTC)
Received: from EX13d09UWC004.ant.amazon.com (10.43.162.114) by
 EX13MTAUWC001.ant.amazon.com (10.43.162.135) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Thu, 9 Jul 2020 19:05:43 +0000
Received: from EX13MTAUWC001.ant.amazon.com (10.43.162.135) by
 EX13d09UWC004.ant.amazon.com (10.43.162.114) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Thu, 9 Jul 2020 19:05:42 +0000
Received: from HFA15-G63729NC.amazon.com (10.1.213.15) by
 mail-relay.amazon.com (10.43.162.232) with Microsoft SMTP Server id
 15.0.1497.2 via Frontend Transport; Thu, 9 Jul 2020 19:05:38 +0000
From:   <akiyano@amazon.com>
To:     <davem@davemloft.net>, <netdev@vger.kernel.org>
CC:     Arthur Kiyanovski <akiyano@amazon.com>, <dwmw@amazon.com>,
        <zorik@amazon.com>, <matua@amazon.com>, <saeedb@amazon.com>,
        <msw@amazon.com>, <aliguori@amazon.com>, <nafea@amazon.com>,
        <gtzalik@amazon.com>, <netanel@amazon.com>, <alisaidi@amazon.com>,
        <benh@amazon.com>, <ndagan@amazon.com>, <shayagr@amazon.com>,
        <sameehj@amazon.com>
Subject: [PATCH V1 net-next 6/8] net: ena: enable support of rss hash key and function changes
Date:   Thu, 9 Jul 2020 22:05:01 +0300
Message-ID: <1594321503-12256-7-git-send-email-akiyano@amazon.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1594321503-12256-1-git-send-email-akiyano@amazon.com>
References: <1594321503-12256-1-git-send-email-akiyano@amazon.com>
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
index fd5f0d87cc59..b3dd9abfedd1 100644
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
2.23.1

