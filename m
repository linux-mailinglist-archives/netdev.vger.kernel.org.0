Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E2642B1623
	for <lists+netdev@lfdr.de>; Fri, 13 Sep 2019 00:10:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729340AbfILWKO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Sep 2019 18:10:14 -0400
Received: from smtp-fw-9102.amazon.com ([207.171.184.29]:12301 "EHLO
        smtp-fw-9102.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726937AbfILWKO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Sep 2019 18:10:14 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1568326213; x=1599862213;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version;
  bh=IFxRopRyj+2Bnhl5+sHfrifwjD9OF0GqSU6BY1iNqlw=;
  b=hJFZYSIg2oO+MrYgYpaTCbOdFC2h3OZz3FGb5lRSLqOAcs+ravt8pngs
   R8I6Kh3hHrvB1iOcNSDC5e4iItu4O3EN0k58L5xNO7sTOlaRu9nykoQfX
   YpI1DzwE+swir2VWPLAVlwD1BLyCw8gvV7B91YVWWCLRLWT1hgetjpP9A
   w=;
X-IronPort-AV: E=Sophos;i="5.64,498,1559520000"; 
   d="scan'208";a="702221890"
Received: from sea3-co-svc-lb6-vlan3.sea.amazon.com (HELO email-inbound-relay-1e-97fdccfd.us-east-1.amazon.com) ([10.47.22.38])
  by smtp-border-fw-out-9102.sea19.amazon.com with ESMTP; 12 Sep 2019 22:10:03 +0000
Received: from EX13MTAUWA001.ant.amazon.com (iad55-ws-svc-p15-lb9-vlan3.iad.amazon.com [10.40.159.166])
        by email-inbound-relay-1e-97fdccfd.us-east-1.amazon.com (Postfix) with ESMTPS id A4B5EA1FB8;
        Thu, 12 Sep 2019 22:09:58 +0000 (UTC)
Received: from EX13D10UWA004.ant.amazon.com (10.43.160.64) by
 EX13MTAUWA001.ant.amazon.com (10.43.160.58) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Thu, 12 Sep 2019 22:09:40 +0000
Received: from EX13MTAUWA001.ant.amazon.com (10.43.160.58) by
 EX13D10UWA004.ant.amazon.com (10.43.160.64) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Thu, 12 Sep 2019 22:09:39 +0000
Received: from HFA15-G63729NC.amazon.com (10.95.77.90) by
 mail-relay.amazon.com (10.43.160.118) with Microsoft SMTP Server id
 15.0.1367.3 via Frontend Transport; Thu, 12 Sep 2019 22:09:32 +0000
From:   <akiyano@amazon.com>
To:     <davem@davemloft.net>, <netdev@vger.kernel.org>
CC:     Arthur Kiyanovski <akiyano@amazon.com>, <dwmw@amazon.com>,
        <zorik@amazon.com>, <matua@amazon.com>, <saeedb@amazon.com>,
        <msw@amazon.com>, <aliguori@amazon.com>, <nafea@amazon.com>,
        <gtzalik@amazon.com>, <netanel@amazon.com>, <alisaidi@amazon.com>,
        <benh@amazon.com>, <sameehj@amazon.com>, <ndagan@amazon.com>
Subject: [PATCH V1 net-next 04/11] net: ena: enable the interrupt_moderation in driver_supported_features
Date:   Fri, 13 Sep 2019 01:08:41 +0300
Message-ID: <1568326128-4057-5-git-send-email-akiyano@amazon.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1568326128-4057-1-git-send-email-akiyano@amazon.com>
References: <1568326128-4057-1-git-send-email-akiyano@amazon.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Arthur Kiyanovski <akiyano@amazon.com>

Add driver_supported_features to host_host info which is a new API used to
communicate to the device which features are supported by the driver.

Add the interrupt_moderation bit to host_info->driver_supported_features
and enable it to signal the device that this driver supports interrupt
moderation properly.

Reserved bits are for features implemented in the future

Signed-off-by: Arthur Kiyanovski <akiyano@amazon.com>
---
 drivers/net/ethernet/amazon/ena/ena_admin_defs.h | 8 ++++++++
 drivers/net/ethernet/amazon/ena/ena_netdev.c     | 3 +++
 2 files changed, 11 insertions(+)

diff --git a/drivers/net/ethernet/amazon/ena/ena_admin_defs.h b/drivers/net/ethernet/amazon/ena/ena_admin_defs.h
index d19f2ecf8e84..8baf847e8622 100644
--- a/drivers/net/ethernet/amazon/ena/ena_admin_defs.h
+++ b/drivers/net/ethernet/amazon/ena/ena_admin_defs.h
@@ -808,6 +808,12 @@ struct ena_admin_host_info {
 	u16 num_cpus;
 
 	u16 reserved;
+
+	/* 1 :0 : reserved
+	 * 2 : interrupt_moderation
+	 * 31:3 : reserved
+	 */
+	u32 driver_supported_features;
 };
 
 struct ena_admin_rss_ind_table_entry {
@@ -1110,6 +1116,8 @@ struct ena_admin_ena_mmio_req_read_less_resp {
 #define ENA_ADMIN_HOST_INFO_DEVICE_MASK                     GENMASK(7, 3)
 #define ENA_ADMIN_HOST_INFO_BUS_SHIFT                       8
 #define ENA_ADMIN_HOST_INFO_BUS_MASK                        GENMASK(15, 8)
+#define ENA_ADMIN_HOST_INFO_INTERRUPT_MODERATION_SHIFT      2
+#define ENA_ADMIN_HOST_INFO_INTERRUPT_MODERATION_MASK       BIT(2)
 
 /* aenq_common_desc */
 #define ENA_ADMIN_AENQ_COMMON_DESC_PHASE_MASK               BIT(0)
diff --git a/drivers/net/ethernet/amazon/ena/ena_netdev.c b/drivers/net/ethernet/amazon/ena/ena_netdev.c
index cdcc169b87fa..f19736493c01 100644
--- a/drivers/net/ethernet/amazon/ena/ena_netdev.c
+++ b/drivers/net/ethernet/amazon/ena/ena_netdev.c
@@ -2438,6 +2438,9 @@ static void ena_config_host_info(struct ena_com_dev *ena_dev,
 		("K"[0] << ENA_ADMIN_HOST_INFO_MODULE_TYPE_SHIFT);
 	host_info->num_cpus = num_online_cpus();
 
+	host_info->driver_supported_features =
+		ENA_ADMIN_HOST_INFO_INTERRUPT_MODERATION_MASK;
+
 	rc = ena_com_set_host_attributes(ena_dev);
 	if (rc) {
 		if (rc == -EOPNOTSUPP)
-- 
2.17.2

