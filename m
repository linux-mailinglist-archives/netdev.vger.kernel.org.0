Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 44D6B33280
	for <lists+netdev@lfdr.de>; Mon,  3 Jun 2019 16:44:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729220AbfFCOoQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Jun 2019 10:44:16 -0400
Received: from smtp-fw-6001.amazon.com ([52.95.48.154]:65194 "EHLO
        smtp-fw-6001.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729240AbfFCOoP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Jun 2019 10:44:15 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1559573054; x=1591109054;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version;
  bh=2XjXn2ZJmMFsh0vIDholrSiOSRE7JnKXbLHE0foK1bc=;
  b=mRvUHv0EC77ubELxq4iiwSupqwLlg4qLU7wB+B4lJZa+OKvM7diDlOsT
   aeck01KGhn8AJIDtMdfSwEgaGoqWyeQA8CkQY82OyfyfsmMaT1eb/8a4o
   dwqDlMH8kyKasmP1fooaDgSys0EFc3Wm67h1gjjfDwUvKcHn1gBaTPvFN
   Y=;
X-IronPort-AV: E=Sophos;i="5.60,547,1549929600"; 
   d="scan'208";a="399132328"
Received: from iad6-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-1d-2c665b5d.us-east-1.amazon.com) ([10.124.125.6])
  by smtp-border-fw-out-6001.iad6.amazon.com with ESMTP; 03 Jun 2019 14:44:14 +0000
Received: from EX13MTAUEA001.ant.amazon.com (iad55-ws-svc-p15-lb9-vlan3.iad.amazon.com [10.40.159.166])
        by email-inbound-relay-1d-2c665b5d.us-east-1.amazon.com (Postfix) with ESMTPS id 1AD4DA1F70;
        Mon,  3 Jun 2019 14:44:13 +0000 (UTC)
Received: from EX13D08UEE001.ant.amazon.com (10.43.62.126) by
 EX13MTAUEA001.ant.amazon.com (10.43.61.243) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Mon, 3 Jun 2019 14:44:00 +0000
Received: from EX13MTAUEE001.ant.amazon.com (10.43.62.200) by
 EX13D08UEE001.ant.amazon.com (10.43.62.126) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Mon, 3 Jun 2019 14:44:00 +0000
Received: from HFA16-8226Y22.hfa16.amazon.com (10.218.60.55) by
 mail-relay.amazon.com (10.43.62.226) with Microsoft SMTP Server id
 15.0.1367.3 via Frontend Transport; Mon, 3 Jun 2019 14:43:57 +0000
From:   <sameehj@amazon.com>
To:     <davem@davemloft.net>, <netdev@vger.kernel.org>
CC:     Sameeh Jubran <sameehj@amazon.com>, <dwmw@amazon.com>,
        <zorik@amazon.com>, <matua@amazon.com>, <saeedb@amazon.com>,
        <msw@amazon.com>, <aliguori@amazon.com>, <nafea@amazon.com>,
        <gtzalik@amazon.com>, <netanel@amazon.com>, <alisaidi@amazon.com>,
        <benh@amazon.com>, <akiyano@amazon.com>
Subject: [PATCH V2 net 08/11] net: ena: add support for changing max_header_size in LLQ mode
Date:   Mon, 3 Jun 2019 17:43:26 +0300
Message-ID: <20190603144329.16366-9-sameehj@amazon.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190603144329.16366-1-sameehj@amazon.com>
References: <20190603144329.16366-1-sameehj@amazon.com>
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

