Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D41642D97A
	for <lists+netdev@lfdr.de>; Wed, 29 May 2019 11:51:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726670AbfE2JvM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 May 2019 05:51:12 -0400
Received: from smtp-fw-2101.amazon.com ([72.21.196.25]:36236 "EHLO
        smtp-fw-2101.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725861AbfE2JvM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 May 2019 05:51:12 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1559123470; x=1590659470;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version;
  bh=2XjXn2ZJmMFsh0vIDholrSiOSRE7JnKXbLHE0foK1bc=;
  b=soXs8XbCST/bMpkcr+L25IEtsqM1JK0l0etLVQtsKusTnvgC7quyYmd9
   9b2roOdoypKjKWJow16JcUruYbJ1Ij1u0Lg21eeWomghFJiIQJRsOPYJa
   kc4s9SbPxCLmNfk91INXTdCaYb22VSlD3ldt5u/YfMPvCF75nGxTDkrpe
   E=;
X-IronPort-AV: E=Sophos;i="5.60,526,1549929600"; 
   d="scan'208";a="735189377"
Received: from iad6-co-svc-p1-lb1-vlan2.amazon.com (HELO email-inbound-relay-1e-27fb8269.us-east-1.amazon.com) ([10.124.125.2])
  by smtp-border-fw-out-2101.iad2.amazon.com with ESMTP; 29 May 2019 09:51:09 +0000
Received: from EX13MTAUWB001.ant.amazon.com (iad55-ws-svc-p15-lb9-vlan3.iad.amazon.com [10.40.159.166])
        by email-inbound-relay-1e-27fb8269.us-east-1.amazon.com (Postfix) with ESMTPS id D1F7CA1E8E;
        Wed, 29 May 2019 09:51:08 +0000 (UTC)
Received: from EX13D10UWB003.ant.amazon.com (10.43.161.106) by
 EX13MTAUWB001.ant.amazon.com (10.43.161.249) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Wed, 29 May 2019 09:50:47 +0000
Received: from EX13MTAUWB001.ant.amazon.com (10.43.161.207) by
 EX13D10UWB003.ant.amazon.com (10.43.161.106) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Wed, 29 May 2019 09:50:46 +0000
Received: from HFA16-8226Y22.hfa16.amazon.com (10.218.60.55) by
 mail-relay.amazon.com (10.43.161.249) with Microsoft SMTP Server id
 15.0.1367.3 via Frontend Transport; Wed, 29 May 2019 09:50:42 +0000
From:   <sameehj@amazon.com>
To:     <davem@davemloft.net>, <netdev@vger.kernel.org>
CC:     Sameeh Jubran <sameehj@amazon.com>, <dwmw@amazon.com>,
        <zorik@amazon.com>, <matua@amazon.com>, <saeedb@amazon.com>,
        <msw@amazon.com>, <aliguori@amazon.com>, <nafea@amazon.com>,
        <gtzalik@amazon.com>, <netanel@amazon.com>, <alisaidi@amazon.com>,
        <benh@amazon.com>, <akiyano@amazon.com>
Subject: [PATCH V1 net-next 08/11] net: ena: add support for changing max_header_size in LLQ mode
Date:   Wed, 29 May 2019 12:50:01 +0300
Message-ID: <20190529095004.13341-9-sameehj@amazon.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190529095004.13341-1-sameehj@amazon.com>
References: <20190529095004.13341-1-sameehj@amazon.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Sameeh Jubran <sameehj@amazon.com>

Up until now the driver always used a single setting for the sizes
of the different parts of the llq entry - 128 for entry size, 2 for
descriptors before header and 96 for maximum header size.

The current code makes sure that the parts of the llq entry are
compatible with each other and with the initial llq entry size given
by the device.

This commit changes this code to support any llq entry size

Signed-off-by: Arthur Kiyanovski <akiyano@amazon.com>
Signed-off-by: Sameeh Jubran <sameehj@amazon.com>
---
 drivers/net/ethernet/amazon/ena/ena_com.c | 10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/amazon/ena/ena_com.c b/drivers/net/ethernet/amazon/ena/ena_com.c
index 5e2abdda7..dbc12e383 100644
--- a/drivers/net/ethernet/amazon/ena/ena_com.c
+++ b/drivers/net/ethernet/amazon/ena/ena_com.c
@@ -2992,8 +2992,8 @@ int ena_com_config_dev_mode(struct ena_com_dev *ena_dev,
 			    struct ena_admin_feature_llq_desc *llq_features,
 			    struct ena_llq_configurations *llq_default_cfg)
 {
+	struct ena_com_llq_info *llq_info = &ena_dev->llq_info;
 	int rc;
-	int size;
 
 	if (!llq_features->max_llq_num) {
 		ena_dev->tx_mem_queue_type = ENA_ADMIN_PLACEMENT_POLICY_HOST;
@@ -3004,12 +3004,10 @@ int ena_com_config_dev_mode(struct ena_com_dev *ena_dev,
 	if (rc)
 		return rc;
 
-	/* Validate the descriptor is not too big */
-	size = ena_dev->tx_max_header_size;
-	size += ena_dev->llq_info.descs_num_before_header *
-		sizeof(struct ena_eth_io_tx_desc);
+	ena_dev->tx_max_header_size = llq_info->desc_list_entry_size -
+		(llq_info->descs_num_before_header * sizeof(struct ena_eth_io_tx_desc));
 
-	if (unlikely(ena_dev->llq_info.desc_list_entry_size < size)) {
+	if (unlikely(ena_dev->tx_max_header_size == 0)) {
 		pr_err("the size of the LLQ entry is smaller than needed\n");
 		return -EINVAL;
 	}
-- 
2.17.1

