Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 49B7B1DE2AA
	for <lists+netdev@lfdr.de>; Fri, 22 May 2020 11:12:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729604AbgEVJME (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 May 2020 05:12:04 -0400
Received: from smtp-fw-4101.amazon.com ([72.21.198.25]:37658 "EHLO
        smtp-fw-4101.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729322AbgEVJME (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 May 2020 05:12:04 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1590138723; x=1621674723;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version;
  bh=FeEx/eDCCLJIvFGgqpmLm33OOAmZetszIIvXRfUAI+c=;
  b=T2XPqFl7t4dG6vn76PaIws5SKPN7MjATjqDtUCrTEcRUr/rvrA+qHGzq
   xJ4TkQldXfD600tkA2tqRDpPfCo+hhN/ahrsaNsrrvci8dHc/YdW//Q+m
   0f+TIKTt9DMLPTDWYW+eWtTQLD/AAOj95obsqyNDfUIfoBGrDvHdvJNRw
   8=;
IronPort-SDR: W1KK483JASPIHcaIkWwbwSm63GbJCbpRVHOcV+tQRKRv61Xk3He+K2QnMf4fJrgsU2gjqpp4xh
 Y8dsCmJInNKg==
X-IronPort-AV: E=Sophos;i="5.73,421,1583193600"; 
   d="scan'208";a="31733513"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-1e-17c49630.us-east-1.amazon.com) ([10.43.8.6])
  by smtp-border-fw-out-4101.iad4.amazon.com with ESMTP; 22 May 2020 09:11:52 +0000
Received: from EX13MTAUWB001.ant.amazon.com (iad55-ws-svc-p15-lb9-vlan3.iad.amazon.com [10.40.159.166])
        by email-inbound-relay-1e-17c49630.us-east-1.amazon.com (Postfix) with ESMTPS id E565DA060D;
        Fri, 22 May 2020 09:11:50 +0000 (UTC)
Received: from EX13D21UWB003.ant.amazon.com (10.43.161.212) by
 EX13MTAUWB001.ant.amazon.com (10.43.161.249) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Fri, 22 May 2020 09:11:31 +0000
Received: from EX13MTAUWB001.ant.amazon.com (10.43.161.207) by
 EX13D21UWB003.ant.amazon.com (10.43.161.212) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Fri, 22 May 2020 09:11:31 +0000
Received: from HFA15-G63729NC.amazon.com (10.1.213.6) by mail-relay.amazon.com
 (10.43.161.249) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Fri, 22 May 2020 09:11:26 +0000
From:   <akiyano@amazon.com>
To:     <davem@davemloft.net>, <netdev@vger.kernel.org>
CC:     Arthur Kiyanovski <akiyano@amazon.com>, <dwmw@amazon.com>,
        <zorik@amazon.com>, <matua@amazon.com>, <saeedb@amazon.com>,
        <msw@amazon.com>, <aliguori@amazon.com>, <nafea@amazon.com>,
        <gtzalik@amazon.com>, <netanel@amazon.com>, <alisaidi@amazon.com>,
        <benh@amazon.com>, <ndagan@amazon.com>, <shayagr@amazon.com>,
        <sameehj@amazon.com>
Subject: [PATCH V2 net-next 04/14] net: ena: fix ena_com_comp_status_to_errno() return value
Date:   Fri, 22 May 2020 12:08:55 +0300
Message-ID: <1590138545-501-5-git-send-email-akiyano@amazon.com>
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

Default return value should be -EINVAL since the input
in this case was unexpected.
Also remove the now redundant check in the beginning
of the function.

Signed-off-by: Sameeh Jubran <sameehj@amazon.com>
Signed-off-by: Arthur Kiyanovski <akiyano@amazon.com>
---
 drivers/net/ethernet/amazon/ena/ena_com.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/amazon/ena/ena_com.c b/drivers/net/ethernet/amazon/ena/ena_com.c
index 02780f9fa586..921945dace22 100644
--- a/drivers/net/ethernet/amazon/ena/ena_com.c
+++ b/drivers/net/ethernet/amazon/ena/ena_com.c
@@ -523,9 +523,6 @@ static int ena_com_comp_status_to_errno(u8 comp_status)
 	if (unlikely(comp_status != 0))
 		pr_err("admin command failed[%u]\n", comp_status);
 
-	if (unlikely(comp_status > ENA_ADMIN_UNKNOWN_ERROR))
-		return -EINVAL;
-
 	switch (comp_status) {
 	case ENA_ADMIN_SUCCESS:
 		return 0;
@@ -540,7 +537,7 @@ static int ena_com_comp_status_to_errno(u8 comp_status)
 		return -EINVAL;
 	}
 
-	return 0;
+	return -EINVAL;
 }
 
 static int ena_com_wait_and_process_admin_cq_polling(struct ena_comp_ctx *comp_ctx,
-- 
2.23.1

