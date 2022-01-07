Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 945BC487DA7
	for <lists+netdev@lfdr.de>; Fri,  7 Jan 2022 21:24:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232004AbiAGUYP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Jan 2022 15:24:15 -0500
Received: from smtp-fw-80007.amazon.com ([99.78.197.218]:64474 "EHLO
        smtp-fw-80007.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231768AbiAGUYM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 Jan 2022 15:24:12 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1641587052; x=1673123052;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=e8Yfpadsq7cE43YxN+B35wGf6KwogATbBFfM1BD0lC0=;
  b=oPllqHjVfnk3Zp4CLwYn59+GwN6VSHi3MMeCqHsAEIKuEAv9JpfktkaT
   NigU4+L64gF4rVXe1RmFoRZew8Ou2NawCrlIobBT4wx3HOKGQcK/scTa2
   zNRGWCHVmLjk0OQP6wBnmnXep04+PuQLHPbDFcqbdCxInLYj6ac4om4OC
   8=;
X-IronPort-AV: E=Sophos;i="5.88,270,1635206400"; 
   d="scan'208";a="53547270"
Received: from pdx4-co-svc-p1-lb2-vlan2.amazon.com (HELO email-inbound-relay-iad-1d-5a6d5c37.us-east-1.amazon.com) ([10.25.36.210])
  by smtp-border-fw-80007.pdx80.corp.amazon.com with ESMTP; 07 Jan 2022 20:24:05 +0000
Received: from EX13MTAUEE002.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan2.iad.amazon.com [10.40.163.34])
        by email-inbound-relay-iad-1d-5a6d5c37.us-east-1.amazon.com (Postfix) with ESMTPS id 6B6FFC090C;
        Fri,  7 Jan 2022 20:24:04 +0000 (UTC)
Received: from EX13D08UEE003.ant.amazon.com (10.43.62.118) by
 EX13MTAUEE002.ant.amazon.com (10.43.62.24) with Microsoft SMTP Server (TLS)
 id 15.0.1497.26; Fri, 7 Jan 2022 20:23:56 +0000
Received: from EX13MTAUEE002.ant.amazon.com (10.43.62.24) by
 EX13D08UEE003.ant.amazon.com (10.43.62.118) with Microsoft SMTP Server (TLS)
 id 15.0.1497.26; Fri, 7 Jan 2022 20:23:56 +0000
Received: from dev-dsk-akiyano-1c-2138b29d.eu-west-1.amazon.com (172.19.83.6)
 by mail-relay.amazon.com (10.43.62.224) with Microsoft SMTP Server id
 15.0.1497.26 via Frontend Transport; Fri, 7 Jan 2022 20:23:54 +0000
From:   Arthur Kiyanovski <akiyano@amazon.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, <netdev@vger.kernel.org>
CC:     Arthur Kiyanovski <akiyano@amazon.com>,
        "Woodhouse, David" <dwmw@amazon.com>,
        "Machulsky, Zorik" <zorik@amazon.com>,
        "Matushevsky, Alexander" <matua@amazon.com>,
        Saeed Bshara <saeedb@amazon.com>,
        "Wilson, Matt" <msw@amazon.com>,
        "Liguori, Anthony" <aliguori@amazon.com>,
        "Bshara, Nafea" <nafea@amazon.com>,
        "Belgazal, Netanel" <netanel@amazon.com>,
        "Saidi, Ali" <alisaidi@amazon.com>,
        "Herrenschmidt, Benjamin" <benh@amazon.com>,
        "Dagan, Noam" <ndagan@amazon.com>,
        "Agroskin, Shay" <shayagr@amazon.com>,
        "Arinzon, David" <darinzon@amazon.com>
Subject: [PATCH V2 net-next 02/10] net: ena: Add capabilities field with support for ENI stats capability
Date:   Fri, 7 Jan 2022 20:23:38 +0000
Message-ID: <20220107202346.3522-3-akiyano@amazon.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20220107202346.3522-1-akiyano@amazon.com>
References: <20220107202346.3522-1-akiyano@amazon.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This bitmask field indicates what capabilities are supported by the
device.

The capabilities field differs from the 'supported_features' field which
indicates what sub-commands for the set/get feature commands are
supported. The sub-commands are specified in the 'feature_id' field of
the 'ena_admin_set_feat_cmd' struct in the following way:

        struct ena_admin_set_feat_cmd cmd;

        cmd.aq_common_descriptor.opcode = ENA_ADMIN_SET_FEATURE;
        cmd.feat_common.feature_

The 'capabilities' field, on the other hand, specifies different
capabilities of the device. For example, whether the device supports
querying of ENI stats.

Also add an enumerator which contains all the capabilities. The
first added capability macro is for ENI stats feature.

Capabilities are queried along with the other device attributes (in
ena_com_get_dev_attr_feat()) during device initialization and are stored
in the ena_com_dev struct. They can be later queried using the
ena_com_get_cap() helper function.

Signed-off-by: Shay Agroskin <shayagr@amazon.com>
Signed-off-by: Arthur Kiyanovski <akiyano@amazon.com>
---
 drivers/net/ethernet/amazon/ena/ena_admin_defs.h | 10 +++++++++-
 drivers/net/ethernet/amazon/ena/ena_com.c        |  8 ++++++++
 drivers/net/ethernet/amazon/ena/ena_com.h        | 13 +++++++++++++
 3 files changed, 30 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/amazon/ena/ena_admin_defs.h b/drivers/net/ethernet/amazon/ena/ena_admin_defs.h
index f5ec35fa4c63..466ad9470d1f 100644
--- a/drivers/net/ethernet/amazon/ena/ena_admin_defs.h
+++ b/drivers/net/ethernet/amazon/ena/ena_admin_defs.h
@@ -48,6 +48,11 @@ enum ena_admin_aq_feature_id {
 	ENA_ADMIN_FEATURES_OPCODE_NUM               = 32,
 };
 
+/* device capabilities */
+enum ena_admin_aq_caps_id {
+	ENA_ADMIN_ENI_STATS                         = 0,
+};
+
 enum ena_admin_placement_policy_type {
 	/* descriptors and headers are in host memory */
 	ENA_ADMIN_PLACEMENT_POLICY_HOST             = 1,
@@ -455,7 +460,10 @@ struct ena_admin_device_attr_feature_desc {
 	 */
 	u32 supported_features;
 
-	u32 reserved3;
+	/* bitmap of ena_admin_aq_caps_id, which represents device
+	 * capabilities.
+	 */
+	u32 capabilities;
 
 	/* Indicates how many bits are used physical address access. */
 	u32 phys_addr_width;
diff --git a/drivers/net/ethernet/amazon/ena/ena_com.c b/drivers/net/ethernet/amazon/ena/ena_com.c
index ab413fc1f68e..8c8b4c88c7de 100644
--- a/drivers/net/ethernet/amazon/ena/ena_com.c
+++ b/drivers/net/ethernet/amazon/ena/ena_com.c
@@ -1971,6 +1971,7 @@ int ena_com_get_dev_attr_feat(struct ena_com_dev *ena_dev,
 	       sizeof(get_resp.u.dev_attr));
 
 	ena_dev->supported_features = get_resp.u.dev_attr.supported_features;
+	ena_dev->capabilities = get_resp.u.dev_attr.capabilities;
 
 	if (ena_dev->supported_features & BIT(ENA_ADMIN_MAX_QUEUES_EXT)) {
 		rc = ena_com_get_feature(ena_dev, &get_resp,
@@ -2223,6 +2224,13 @@ int ena_com_get_eni_stats(struct ena_com_dev *ena_dev,
 	struct ena_com_stats_ctx ctx;
 	int ret;
 
+	if (!ena_com_get_cap(ena_dev, ENA_ADMIN_ENI_STATS)) {
+		netdev_err(ena_dev->net_device,
+			   "Capability %d isn't supported\n",
+			   ENA_ADMIN_ENI_STATS);
+		return -EOPNOTSUPP;
+	}
+
 	memset(&ctx, 0x0, sizeof(ctx));
 	ret = ena_get_dev_stats(ena_dev, &ctx, ENA_ADMIN_GET_STATS_TYPE_ENI);
 	if (likely(ret == 0))
diff --git a/drivers/net/ethernet/amazon/ena/ena_com.h b/drivers/net/ethernet/amazon/ena/ena_com.h
index 73b03ce59412..3c5081d9d25d 100644
--- a/drivers/net/ethernet/amazon/ena/ena_com.h
+++ b/drivers/net/ethernet/amazon/ena/ena_com.h
@@ -314,6 +314,7 @@ struct ena_com_dev {
 
 	struct ena_rss rss;
 	u32 supported_features;
+	u32 capabilities;
 	u32 dma_addr_bits;
 
 	struct ena_host_attribute host_attr;
@@ -967,6 +968,18 @@ static inline void ena_com_disable_adaptive_moderation(struct ena_com_dev *ena_d
 	ena_dev->adaptive_coalescing = false;
 }
 
+/* ena_com_get_cap - query whether device supports a capability.
+ * @ena_dev: ENA communication layer struct
+ * @cap_id: enum value representing the capability
+ *
+ * @return - true if capability is supported or false otherwise
+ */
+static inline bool ena_com_get_cap(struct ena_com_dev *ena_dev,
+				   enum ena_admin_aq_caps_id cap_id)
+{
+	return !!(ena_dev->capabilities & BIT(cap_id));
+}
+
 /* ena_com_update_intr_reg - Prepare interrupt register
  * @intr_reg: interrupt register to update.
  * @rx_delay_interval: Rx interval in usecs
-- 
2.32.0

