Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A2DACB3959
	for <lists+netdev@lfdr.de>; Mon, 16 Sep 2019 13:32:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731514AbfIPLcM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Sep 2019 07:32:12 -0400
Received: from smtp-fw-6001.amazon.com ([52.95.48.154]:58084 "EHLO
        smtp-fw-6001.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731431AbfIPLcL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Sep 2019 07:32:11 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1568633530; x=1600169530;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version;
  bh=IFxRopRyj+2Bnhl5+sHfrifwjD9OF0GqSU6BY1iNqlw=;
  b=EYfc5Zc++m5+HRBFV2E+RD0/+8WDgWfass1HhXJFPmgb0tDhWBiR6Mid
   kZ/IUJdvLQiYHnCnf9rjHII5/9tZ68uiU5xPUyGQO9HFpsT2tnMwVV8fD
   hwQWWuttN/J3MUnof8me8yJq826O/W7V3/X4Z4LQJ8AEk0/x5lSQWlaDS
   Y=;
X-IronPort-AV: E=Sophos;i="5.64,512,1559520000"; 
   d="scan'208";a="415450156"
Received: from iad6-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-1d-2c665b5d.us-east-1.amazon.com) ([10.124.125.6])
  by smtp-border-fw-out-6001.iad6.amazon.com with ESMTP; 16 Sep 2019 11:32:08 +0000
Received: from EX13MTAUEA001.ant.amazon.com (iad55-ws-svc-p15-lb9-vlan3.iad.amazon.com [10.40.159.166])
        by email-inbound-relay-1d-2c665b5d.us-east-1.amazon.com (Postfix) with ESMTPS id 8C17FA2365;
        Mon, 16 Sep 2019 11:32:08 +0000 (UTC)
Received: from EX13D08UEE003.ant.amazon.com (10.43.62.118) by
 EX13MTAUEA001.ant.amazon.com (10.43.61.82) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Mon, 16 Sep 2019 11:31:55 +0000
Received: from EX13MTAUEE001.ant.amazon.com (10.43.62.200) by
 EX13D08UEE003.ant.amazon.com (10.43.62.118) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Mon, 16 Sep 2019 11:31:54 +0000
Received: from HFA15-G63729NC.hfa16.amazon.com (10.218.52.89) by
 mail-relay.amazon.com (10.43.62.226) with Microsoft SMTP Server id
 15.0.1367.3 via Frontend Transport; Mon, 16 Sep 2019 11:31:52 +0000
From:   <akiyano@amazon.com>
To:     <davem@davemloft.net>, <netdev@vger.kernel.org>
CC:     Arthur Kiyanovski <akiyano@amazon.com>, <dwmw@amazon.com>,
        <zorik@amazon.com>, <matua@amazon.com>, <saeedb@amazon.com>,
        <msw@amazon.com>, <aliguori@amazon.com>, <nafea@amazon.com>,
        <gtzalik@amazon.com>, <netanel@amazon.com>, <alisaidi@amazon.com>,
        <benh@amazon.com>, <sameehj@amazon.com>, <ndagan@amazon.com>
Subject: [PATCH V2 net-next 04/11] net: ena: enable the interrupt_moderation in driver_supported_features
Date:   Mon, 16 Sep 2019 14:31:29 +0300
Message-ID: <1568633496-4143-5-git-send-email-akiyano@amazon.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1568633496-4143-1-git-send-email-akiyano@amazon.com>
References: <1568633496-4143-1-git-send-email-akiyano@amazon.com>
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

