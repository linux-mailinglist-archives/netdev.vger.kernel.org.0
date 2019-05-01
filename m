Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 66EF410871
	for <lists+netdev@lfdr.de>; Wed,  1 May 2019 15:48:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726491AbfEANsL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 May 2019 09:48:11 -0400
Received: from smtp-fw-9102.amazon.com ([207.171.184.29]:29493 "EHLO
        smtp-fw-9102.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726436AbfEANsL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 May 2019 09:48:11 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1556718490; x=1588254490;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version;
  bh=XKxfx3v5CPtrk8hbJNzKoFzutCPUwlqFyMynRigVUBc=;
  b=hvWd1rO1NQM/z3rpTxAnxaPeMEDzlBD7KJoUpzPhtAHdNfpsnxQzX/ME
   xTe8+oHDGfvjRGXJb+WGRRqgZuWOIf9f97iJyP2gXh2GOSwk1IdD2zaJs
   6nXZzieX4czkCd7RFkMFgsHuR/aY/veEgjmPCjq66Arz2mGwzovsGNnVm
   I=;
X-IronPort-AV: E=Sophos;i="5.60,417,1549929600"; 
   d="scan'208";a="672061717"
Received: from sea3-co-svc-lb6-vlan3.sea.amazon.com (HELO email-inbound-relay-1a-16acd5e0.us-east-1.amazon.com) ([10.47.22.38])
  by smtp-border-fw-out-9102.sea19.amazon.com with ESMTP/TLS/DHE-RSA-AES256-SHA; 01 May 2019 13:48:09 +0000
Received: from EX13MTAUWC001.ant.amazon.com (iad55-ws-svc-p15-lb9-vlan2.iad.amazon.com [10.40.159.162])
        by email-inbound-relay-1a-16acd5e0.us-east-1.amazon.com (8.14.7/8.14.7) with ESMTP id x41Dm48o010169
        (version=TLSv1/SSLv3 cipher=AES256-SHA bits=256 verify=FAIL);
        Wed, 1 May 2019 13:48:08 GMT
Received: from EX13d09UWC003.ant.amazon.com (10.43.162.113) by
 EX13MTAUWC001.ant.amazon.com (10.43.162.135) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Wed, 1 May 2019 13:47:51 +0000
Received: from EX13MTAUWC001.ant.amazon.com (10.43.162.135) by
 EX13d09UWC003.ant.amazon.com (10.43.162.113) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Wed, 1 May 2019 13:47:51 +0000
Received: from HFA16-8226Y22.hfa16.amazon.com (10.218.60.55) by
 mail-relay.amazon.com (10.43.162.232) with Microsoft SMTP Server id
 15.0.1367.3 via Frontend Transport; Wed, 1 May 2019 13:47:47 +0000
From:   <sameehj@amazon.com>
To:     <davem@davemloft.net>, <netdev@vger.kernel.org>
CC:     Sameeh Jubran <sameehj@amazon.com>, <dwmw@amazon.com>,
        <zorik@amazon.com>, <matua@amazon.com>, <saeedb@amazon.com>,
        <msw@amazon.com>, <aliguori@amazon.com>, <nafea@amazon.com>,
        <gtzalik@amazon.com>, <netanel@amazon.com>, <alisaidi@amazon.com>,
        <benh@amazon.com>, <akiyano@amazon.com>
Subject: [PATCH V1 net 8/8] net: ena: gcc 8: fix compilation warning
Date:   Wed, 1 May 2019 16:47:10 +0300
Message-ID: <20190501134710.8938-9-sameehj@amazon.com>
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

GCC 8 contains a number of new warnings as well as enhancements to existing
checkers. The warning - Wstringop-truncation - warns for calls to bounded
string manipulation functions such as strncat, strncpy, and stpncpy that
may either truncate the copied string or leave the destination unchanged.

In our case the destination string length (32 bytes) is much shorter than
the source string (64 bytes) which causes this warning to show up. In
general the destination has to be at least a byte larger than the length
of the source string with strncpy for this warning not to showup.

This can be easily fixed by using strlcpy instead which already does the
truncation to the string. Documentation for this function can be
found here:

https://elixir.bootlin.com/linux/latest/source/lib/string.c#L141

Fixes: 1738cd3ed342 ("net: ena: Add a driver for Amazon Elastic Network Adapters (ENA)")

Signed-off-by: Sameeh Jubran <sameehj@amazon.com>
---
 drivers/net/ethernet/amazon/ena/ena_netdev.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/amazon/ena/ena_netdev.c b/drivers/net/ethernet/amazon/ena/ena_netdev.c
index 03244155f74c..bc5997a5f809 100644
--- a/drivers/net/ethernet/amazon/ena/ena_netdev.c
+++ b/drivers/net/ethernet/amazon/ena/ena_netdev.c
@@ -2298,7 +2298,7 @@ static void ena_config_host_info(struct ena_com_dev *ena_dev,
 	host_info->bdf = (pdev->bus->number << 8) | pdev->devfn;
 	host_info->os_type = ENA_ADMIN_OS_LINUX;
 	host_info->kernel_ver = LINUX_VERSION_CODE;
-	strncpy(host_info->kernel_ver_str, utsname()->version,
+	strlcpy(host_info->kernel_ver_str, utsname()->version,
 		sizeof(host_info->kernel_ver_str) - 1);
 	host_info->os_dist = 0;
 	strncpy(host_info->os_dist_str, utsname()->release,
-- 
2.17.1

