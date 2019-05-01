Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 853831086C
	for <lists+netdev@lfdr.de>; Wed,  1 May 2019 15:47:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726558AbfEANrv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 May 2019 09:47:51 -0400
Received: from smtp-fw-4101.amazon.com ([72.21.198.25]:13057 "EHLO
        smtp-fw-4101.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726497AbfEANru (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 May 2019 09:47:50 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1556718469; x=1588254469;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version;
  bh=q+EFCzU5DO9ANd3BDE/CuQNGM2b8Q2gO4hmXtjD0evs=;
  b=esasoY5wmcPDI4HBRZZtQldHjYZe7t4gVQVk/SyH0qXgGSHBE8fFZBv6
   YyOweqZ1iEUa9Q+VBEU/ggHDOolc36cXeeiHsC5l6f+rkdqEm5d+eR9Qi
   DHODHjtNs+EH+gFf8932Z4+djM0/t8UNkxLPEbKnV/ebhP2KPPgHc5ldj
   E=;
X-IronPort-AV: E=Sophos;i="5.60,417,1549929600"; 
   d="scan'208";a="764332284"
Received: from iad6-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-1e-57e1d233.us-east-1.amazon.com) ([10.124.125.6])
  by smtp-border-fw-out-4101.iad4.amazon.com with ESMTP/TLS/DHE-RSA-AES256-SHA; 01 May 2019 13:47:42 +0000
Received: from EX13MTAUWC001.ant.amazon.com (iad55-ws-svc-p15-lb9-vlan3.iad.amazon.com [10.40.159.166])
        by email-inbound-relay-1e-57e1d233.us-east-1.amazon.com (8.14.7/8.14.7) with ESMTP id x41DlYWw109760
        (version=TLSv1/SSLv3 cipher=AES256-SHA bits=256 verify=FAIL);
        Wed, 1 May 2019 13:47:42 GMT
Received: from EX13d09UWC001.ant.amazon.com (10.43.162.60) by
 EX13MTAUWC001.ant.amazon.com (10.43.162.135) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Wed, 1 May 2019 13:47:30 +0000
Received: from EX13MTAUWC001.ant.amazon.com (10.43.162.135) by
 EX13d09UWC001.ant.amazon.com (10.43.162.60) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Wed, 1 May 2019 13:47:30 +0000
Received: from HFA16-8226Y22.hfa16.amazon.com (10.218.60.55) by
 mail-relay.amazon.com (10.43.162.232) with Microsoft SMTP Server id
 15.0.1367.3 via Frontend Transport; Wed, 1 May 2019 13:47:26 +0000
From:   <sameehj@amazon.com>
To:     <davem@davemloft.net>, <netdev@vger.kernel.org>
CC:     Sameeh Jubran <sameehj@amazon.com>, <dwmw@amazon.com>,
        <zorik@amazon.com>, <matua@amazon.com>, <saeedb@amazon.com>,
        <msw@amazon.com>, <aliguori@amazon.com>, <nafea@amazon.com>,
        <gtzalik@amazon.com>, <netanel@amazon.com>, <alisaidi@amazon.com>,
        <benh@amazon.com>, <akiyano@amazon.com>
Subject: [PATCH V1 net 3/8] net: ena: fix: Free napi resources when ena_up() fails
Date:   Wed, 1 May 2019 16:47:05 +0300
Message-ID: <20190501134710.8938-4-sameehj@amazon.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190501134710.8938-1-sameehj@amazon.com>
References: <20190501134710.8938-1-sameehj@amazon.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Sameeh Jubran <sameehj@amazon.com>

ena_up() calls ena_init_napi() but does not call ena_del_napi() in
case of failure. This causes a segmentation fault upon rmmod when
netif_napi_del() is called. Fix this bug by calling ena_del_napi()
before returning error from ena_up().

Fixes: 1738cd3ed342 ("net: ena: Add a driver for Amazon Elastic Network Adapters (ENA)")

Signed-off-by: Arthur Kiyanovski <akiyano@amazon.com>
Signed-off-by: Sameeh Jubran <sameehj@amazon.com>
---
 drivers/net/ethernet/amazon/ena/ena_netdev.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/amazon/ena/ena_netdev.c b/drivers/net/ethernet/amazon/ena/ena_netdev.c
index dbcd58ebd0a9..03244155f74c 100644
--- a/drivers/net/ethernet/amazon/ena/ena_netdev.c
+++ b/drivers/net/ethernet/amazon/ena/ena_netdev.c
@@ -1825,6 +1825,7 @@ static int ena_up(struct ena_adapter *adapter)
 err_setup_tx:
 	ena_free_io_irq(adapter);
 err_req_irq:
+	ena_del_napi(adapter);
 
 	return rc;
 }
-- 
2.17.1

