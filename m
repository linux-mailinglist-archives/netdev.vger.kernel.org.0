Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6FADC1DD6B1
	for <lists+netdev@lfdr.de>; Thu, 21 May 2020 21:10:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730316AbgEUTJD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 May 2020 15:09:03 -0400
Received: from smtp-fw-33001.amazon.com ([207.171.190.10]:65468 "EHLO
        smtp-fw-33001.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730286AbgEUTJB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 May 2020 15:09:01 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1590088142; x=1621624142;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version;
  bh=mTwCcc52l4D0iGkoexIfjv4X56Wktg+XcvjOvLjR8Lo=;
  b=ckd+pJhQqtNoRjiHiCp4nUbaYuqOG7hUP27Yc2l8gVTJVKIFRqfJ6WQL
   DZ8x/oAQskK39q4p9w9Q2asXJUY5jQenEWKxSjZpnSkXahlXXZWl1MKpx
   35uKRNtGwkWvkI0y9GDxUQZZhGmrh1V5U8qpPJRwCiKQw2GEduA9ebn5Q
   4=;
IronPort-SDR: nplvOfwQLkiq9V/O0NQ1BhlP8H+VjrGRwKz6mBXRmXuChKIZpvesyrYRGchJgQqBg+loNs5PtS
 6Ox35nk64kKg==
X-IronPort-AV: E=Sophos;i="5.73,418,1583193600"; 
   d="scan'208";a="46582184"
Received: from sea32-co-svc-lb4-vlan2.sea.corp.amazon.com (HELO email-inbound-relay-2a-538b0bfb.us-west-2.amazon.com) ([10.47.23.34])
  by smtp-border-fw-out-33001.sea14.amazon.com with ESMTP; 21 May 2020 19:09:00 +0000
Received: from EX13MTAUEE002.ant.amazon.com (pdx4-ws-svc-p6-lb7-vlan3.pdx.amazon.com [10.170.41.166])
        by email-inbound-relay-2a-538b0bfb.us-west-2.amazon.com (Postfix) with ESMTPS id 32B3AA2105;
        Thu, 21 May 2020 19:08:59 +0000 (UTC)
Received: from EX13D08UEE003.ant.amazon.com (10.43.62.118) by
 EX13MTAUEE002.ant.amazon.com (10.43.62.24) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Thu, 21 May 2020 19:08:58 +0000
Received: from EX13MTAUEA001.ant.amazon.com (10.43.61.82) by
 EX13D08UEE003.ant.amazon.com (10.43.62.118) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Thu, 21 May 2020 19:08:57 +0000
Received: from HFA15-G63729NC.amazon.com (10.1.212.27) by
 mail-relay.amazon.com (10.43.61.243) with Microsoft SMTP Server id
 15.0.1497.2 via Frontend Transport; Thu, 21 May 2020 19:08:55 +0000
From:   <akiyano@amazon.com>
To:     <davem@davemloft.net>, <netdev@vger.kernel.org>
CC:     Arthur Kiyanovski <akiyano@amazon.com>, <dwmw@amazon.com>,
        <zorik@amazon.com>, <matua@amazon.com>, <saeedb@amazon.com>,
        <msw@amazon.com>, <aliguori@amazon.com>, <nafea@amazon.com>,
        <gtzalik@amazon.com>, <netanel@amazon.com>, <alisaidi@amazon.com>,
        <benh@amazon.com>, <ndagan@amazon.com>, <shayagr@amazon.com>,
        <sameehj@amazon.com>
Subject: [PATCH V1 net-next 06/15] net: ena: simplify ena_com_update_intr_delay_resolution()
Date:   Thu, 21 May 2020 22:08:25 +0300
Message-ID: <1590088114-381-7-git-send-email-akiyano@amazon.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1590088114-381-1-git-send-email-akiyano@amazon.com>
References: <1590088114-381-1-git-send-email-akiyano@amazon.com>
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

