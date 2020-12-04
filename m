Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 466B92CEDCE
	for <lists+netdev@lfdr.de>; Fri,  4 Dec 2020 13:13:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730175AbgLDMMN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Dec 2020 07:12:13 -0500
Received: from smtp-fw-9102.amazon.com ([207.171.184.29]:32878 "EHLO
        smtp-fw-9102.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726618AbgLDMMN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Dec 2020 07:12:13 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1607083932; x=1638619932;
  h=from:to:cc:subject:date:message-id:mime-version;
  bh=U5CehGSpdaZ7YFSyKw2e1MWkd/eSxR8K6P6BZCJpesM=;
  b=sZWXfg6LWuMfl7np7OGKoIkSdusdzwGI7M9avcNx+DKhbHe6NQu0Hh7q
   fJRd4tvPfM+q/kQ+Qo3EpFhMfkzbRrIFVQVbIB2GljQdvCiZSfLCmafn/
   9Bb59zjB/J06RbSM3JcJXuUTfgb+uf1OpMvmOsxgk492rO/WmjMWii+5c
   o=;
X-IronPort-AV: E=Sophos;i="5.78,392,1599523200"; 
   d="scan'208";a="101752522"
Received: from sea32-co-svc-lb4-vlan3.sea.corp.amazon.com (HELO email-inbound-relay-2a-c5104f52.us-west-2.amazon.com) ([10.47.23.38])
  by smtp-border-fw-out-9102.sea19.amazon.com with ESMTP; 04 Dec 2020 12:11:23 +0000
Received: from EX13MTAUWC002.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan3.pdx.amazon.com [10.236.137.198])
        by email-inbound-relay-2a-c5104f52.us-west-2.amazon.com (Postfix) with ESMTPS id B1585A1BD9;
        Fri,  4 Dec 2020 12:11:22 +0000 (UTC)
Received: from EX13D02UWC003.ant.amazon.com (10.43.162.199) by
 EX13MTAUWC002.ant.amazon.com (10.43.162.240) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Fri, 4 Dec 2020 12:11:21 +0000
Received: from EX13MTAUWC001.ant.amazon.com (10.43.162.135) by
 EX13D02UWC003.ant.amazon.com (10.43.162.199) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Fri, 4 Dec 2020 12:11:21 +0000
Received: from HFA15-G63729NC.amazon.com (10.1.212.14) by
 mail-relay.amazon.com (10.43.162.232) with Microsoft SMTP Server id
 15.0.1497.2 via Frontend Transport; Fri, 4 Dec 2020 12:11:16 +0000
From:   <akiyano@amazon.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <netdev@vger.kernel.org>
CC:     Arthur Kiyanovski <akiyano@amazon.com>, <dwmw@amazon.com>,
        <zorik@amazon.com>, <matua@amazon.com>, <saeedb@amazon.com>,
        <msw@amazon.com>, <aliguori@amazon.com>, <nafea@amazon.com>,
        <gtzalik@amazon.com>, <netanel@amazon.com>, <alisaidi@amazon.com>,
        <benh@amazon.com>, <ndagan@amazon.com>, <shayagr@amazon.com>,
        <sameehj@amazon.com>
Subject: [PATCH V4 net-next 0/9] XDP Redirect implementation for ENA driver
Date:   Fri, 4 Dec 2020 14:11:06 +0200
Message-ID: <1607083875-32134-1-git-send-email-akiyano@amazon.com>
X-Mailer: git-send-email 2.7.4
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Arthur Kiyanovski <akiyano@amazon.com>

V4 Changes:
-----------
Added an explanation to the decision of using netdev_* prints
in functions that are also called before netdev is registered.


V3 Changes:
-----------
1. Removed RFC, the commits that this patchset relies on where
merged from net already so no more conflicts are expected.

2. Fixed checkpatch errors.


V2 Changes:
---------------
1. Changed this to RFC, since we are waiting for the recently merged
net patches to be merged so there will be no merge conflicts. But
still would like to get review comments beforehand.

2. Removed the word "atomic" from the name of
ena_increase_stat_atomic(), as it is indeed not atomic.


V1 Cover Letter:
----------------
Hi all,
ENA is adding XDP Redirect support for its driver and some other
small tweaks.

This series adds the following:

- Make log messages in the driver have a uniform format using
  netdev_* function
- Improve code readability and add explicit masking
- Add support for XDP Redirect

Arthur Kiyanovski (9):
  net: ena: use constant value for net_device allocation
  net: ena: add device distinct log prefix to files
  net: ena: add explicit casting to variables
  net: ena: fix coding style nits
  net: ena: aggregate stats increase into a function
  net: ena: use xdp_frame in XDP TX flow
  net: ena: introduce XDP redirect implementation
  net: ena: use xdp_return_frame() to free xdp frames
  net: ena: introduce ndo_xdp_xmit() function for XDP_REDIRECT

 drivers/net/ethernet/amazon/ena/ena_com.c     | 394 ++++++++++-------
 drivers/net/ethernet/amazon/ena/ena_com.h     |  21 +
 drivers/net/ethernet/amazon/ena/ena_eth_com.c |  71 ++--
 drivers/net/ethernet/amazon/ena/ena_eth_com.h |  23 +-
 drivers/net/ethernet/amazon/ena/ena_ethtool.c |   3 +-
 drivers/net/ethernet/amazon/ena/ena_netdev.c  | 395 ++++++++++--------
 drivers/net/ethernet/amazon/ena/ena_netdev.h  |  12 +-
 7 files changed, 544 insertions(+), 375 deletions(-)

-- 
2.23.3

