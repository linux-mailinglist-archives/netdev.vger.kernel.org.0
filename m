Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3E0F01DD6B5
	for <lists+netdev@lfdr.de>; Thu, 21 May 2020 21:10:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730346AbgEUTJX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 May 2020 15:09:23 -0400
Received: from smtp-fw-9101.amazon.com ([207.171.184.25]:20071 "EHLO
        smtp-fw-9101.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729593AbgEUTJW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 May 2020 15:09:22 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1590088162; x=1621624162;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version;
  bh=FeEx/eDCCLJIvFGgqpmLm33OOAmZetszIIvXRfUAI+c=;
  b=f17hd9Mqq/jYlm8I0dCMR4WHCjtx5YZUykgi9ykR1UY1qXIlWIwS0Dsy
   uqp0Ovi/VzVUb8vMbg4YkvWXEo+vDbnyq3UbGgj/ekYEA6CVdaAOszjm5
   2olbZ7HXTaEtkm8mZtwmoD5wY1S+FnWNwWe+B1OsTkK1+c6zwSXumO9Nu
   M=;
IronPort-SDR: ihQ5cQnEjJsA7b7gibxsY19QIyHEQzdzp6BexMXq/p/+8wukFEVhRSajbTmgbcGrq4ma/Wva+q
 ZBHTHiDBg6mg==
X-IronPort-AV: E=Sophos;i="5.73,418,1583193600"; 
   d="scan'208";a="36851065"
Received: from sea32-co-svc-lb4-vlan3.sea.corp.amazon.com (HELO email-inbound-relay-1e-a70de69e.us-east-1.amazon.com) ([10.47.23.38])
  by smtp-border-fw-out-9101.sea19.amazon.com with ESMTP; 21 May 2020 19:09:21 +0000
Received: from EX13MTAUEB002.ant.amazon.com (iad55-ws-svc-p15-lb9-vlan2.iad.amazon.com [10.40.159.162])
        by email-inbound-relay-1e-a70de69e.us-east-1.amazon.com (Postfix) with ESMTPS id 2C02BA1DA3;
        Thu, 21 May 2020 19:09:20 +0000 (UTC)
Received: from EX13D08UEB003.ant.amazon.com (10.43.60.11) by
 EX13MTAUEB002.ant.amazon.com (10.43.60.12) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Thu, 21 May 2020 19:08:51 +0000
Received: from EX13MTAUEA001.ant.amazon.com (10.43.61.82) by
 EX13D08UEB003.ant.amazon.com (10.43.60.11) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Thu, 21 May 2020 19:08:51 +0000
Received: from HFA15-G63729NC.amazon.com (10.1.212.27) by
 mail-relay.amazon.com (10.43.61.243) with Microsoft SMTP Server id
 15.0.1497.2 via Frontend Transport; Thu, 21 May 2020 19:08:48 +0000
From:   <akiyano@amazon.com>
To:     <davem@davemloft.net>, <netdev@vger.kernel.org>
CC:     Arthur Kiyanovski <akiyano@amazon.com>, <dwmw@amazon.com>,
        <zorik@amazon.com>, <matua@amazon.com>, <saeedb@amazon.com>,
        <msw@amazon.com>, <aliguori@amazon.com>, <nafea@amazon.com>,
        <gtzalik@amazon.com>, <netanel@amazon.com>, <alisaidi@amazon.com>,
        <benh@amazon.com>, <ndagan@amazon.com>, <shayagr@amazon.com>,
        <sameehj@amazon.com>
Subject: [PATCH V1 net-next 04/15] net: ena: fix ena_com_comp_status_to_errno() return value
Date:   Thu, 21 May 2020 22:08:23 +0300
Message-ID: <1590088114-381-5-git-send-email-akiyano@amazon.com>
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

