Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D3D811DE2A9
	for <lists+netdev@lfdr.de>; Fri, 22 May 2020 11:11:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729595AbgEVJL4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 May 2020 05:11:56 -0400
Received: from smtp-fw-9101.amazon.com ([207.171.184.25]:64039 "EHLO
        smtp-fw-9101.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729589AbgEVJLz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 May 2020 05:11:55 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1590138714; x=1621674714;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version;
  bh=mTwCcc52l4D0iGkoexIfjv4X56Wktg+XcvjOvLjR8Lo=;
  b=lU7Y6Fz3w/7IL5NKi2oViZPCH/dRKKN61o8s03Vknj06HUS7K1R8FTSK
   Fwq3BbwdyIwLYf+4l2168E5DB1cUjLfoOzipzWD3GnErwjZ1gLImaTA5R
   DH5dDYErQoSzcI3/1U95Es+QBpUpwXzG9kcbI+MlAWbmZHX8V1PNNKyCA
   M=;
IronPort-SDR: WEd4IN2/Ta0ecfdaa4nZ5r69Q2wP5KEKVQ2R84x9dCre4YlB8vLRD/pJmzc4YBSTaTIC5BB9KK
 cDC4A7gAH4nQ==
X-IronPort-AV: E=Sophos;i="5.73,421,1583193600"; 
   d="scan'208";a="36968878"
Received: from sea32-co-svc-lb4-vlan3.sea.corp.amazon.com (HELO email-inbound-relay-1e-57e1d233.us-east-1.amazon.com) ([10.47.23.38])
  by smtp-border-fw-out-9101.sea19.amazon.com with ESMTP; 22 May 2020 09:11:53 +0000
Received: from EX13MTAUWB001.ant.amazon.com (iad55-ws-svc-p15-lb9-vlan3.iad.amazon.com [10.40.159.166])
        by email-inbound-relay-1e-57e1d233.us-east-1.amazon.com (Postfix) with ESMTPS id 23FDA14181F;
        Fri, 22 May 2020 09:11:52 +0000 (UTC)
Received: from EX13D10UWB001.ant.amazon.com (10.43.161.111) by
 EX13MTAUWB001.ant.amazon.com (10.43.161.207) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Fri, 22 May 2020 09:11:36 +0000
Received: from EX13MTAUWB001.ant.amazon.com (10.43.161.207) by
 EX13D10UWB001.ant.amazon.com (10.43.161.111) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Fri, 22 May 2020 09:11:35 +0000
Received: from HFA15-G63729NC.amazon.com (10.1.213.6) by mail-relay.amazon.com
 (10.43.161.249) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Fri, 22 May 2020 09:11:31 +0000
From:   <akiyano@amazon.com>
To:     <davem@davemloft.net>, <netdev@vger.kernel.org>
CC:     Arthur Kiyanovski <akiyano@amazon.com>, <dwmw@amazon.com>,
        <zorik@amazon.com>, <matua@amazon.com>, <saeedb@amazon.com>,
        <msw@amazon.com>, <aliguori@amazon.com>, <nafea@amazon.com>,
        <gtzalik@amazon.com>, <netanel@amazon.com>, <alisaidi@amazon.com>,
        <benh@amazon.com>, <ndagan@amazon.com>, <shayagr@amazon.com>,
        <sameehj@amazon.com>
Subject: [PATCH V2 net-next 05/14] net: ena: simplify ena_com_update_intr_delay_resolution()
Date:   Fri, 22 May 2020 12:08:56 +0300
Message-ID: <1590138545-501-6-git-send-email-akiyano@amazon.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1590138545-501-1-git-send-email-akiyano@amazon.com>
References: <1590138545-501-1-git-send-email-akiyano@amazon.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Arthur Kiyanovski <akiyano@amazon.com>

Initialize prev_intr_delay_resolution with ena_dev->intr_delay_resolution
unconditionally, since it is initialized with
ENA_DEFAULT_INTR_DELAY_RESOLUTION in ena_probe(). This approach makes much
more sense than handling errors of not initializing it.

Also added unlikely to if condition.

Signed-off-by: Arthur Kiyanovski <akiyano@amazon.com>
---
 drivers/net/ethernet/amazon/ena/ena_com.c | 8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/amazon/ena/ena_com.c b/drivers/net/ethernet/amazon/ena/ena_com.c
index 921945dace22..e2025eb86984 100644
--- a/drivers/net/ethernet/amazon/ena/ena_com.c
+++ b/drivers/net/ethernet/amazon/ena/ena_com.c
@@ -1281,13 +1281,9 @@ static int ena_com_ind_tbl_convert_to_device(struct ena_com_dev *ena_dev)
 static void ena_com_update_intr_delay_resolution(struct ena_com_dev *ena_dev,
 						 u16 intr_delay_resolution)
 {
-	/* Initial value of intr_delay_resolution might be 0 */
-	u16 prev_intr_delay_resolution =
-		ena_dev->intr_delay_resolution ?
-		ena_dev->intr_delay_resolution :
-		ENA_DEFAULT_INTR_DELAY_RESOLUTION;
+	u16 prev_intr_delay_resolution = ena_dev->intr_delay_resolution;
 
-	if (!intr_delay_resolution) {
+	if (unlikely(!intr_delay_resolution)) {
 		pr_err("Illegal intr_delay_resolution provided. Going to use default 1 usec resolution\n");
 		intr_delay_resolution = ENA_DEFAULT_INTR_DELAY_RESOLUTION;
 	}
-- 
2.23.1

