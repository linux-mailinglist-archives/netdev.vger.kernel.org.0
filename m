Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2215A2C4B12
	for <lists+netdev@lfdr.de>; Wed, 25 Nov 2020 23:53:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727865AbgKYWwO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Nov 2020 17:52:14 -0500
Received: from smtp-fw-33001.amazon.com ([207.171.190.10]:16515 "EHLO
        smtp-fw-33001.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725776AbgKYWwO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Nov 2020 17:52:14 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1606344734; x=1637880734;
  h=from:to:cc:subject:date:message-id:mime-version;
  bh=KCzBfvVltGH6LWQm0Zhsd8q/NF+eYYa1Rr4IT2DBSYs=;
  b=YE5NHvBcnBSjiRdXIdVo5FzRO37kUkPy8DKXPKy8uX9xEQdxIpHYs6NJ
   nfjSeCGNLkRzvecNpDSsjxIT4Edr0p4cfWaf8UgDdKlxMwV8KKl/oD2cU
   Hu5jQBFaTEdyVOHI/XaBdvXeNnfSq+d0GHktcXoDNsMUNp3d4Rnywi5JJ
   U=;
X-IronPort-AV: E=Sophos;i="5.78,370,1599523200"; 
   d="scan'208";a="98017158"
Received: from sea32-co-svc-lb4-vlan3.sea.corp.amazon.com (HELO email-inbound-relay-2b-baacba05.us-west-2.amazon.com) ([10.47.23.38])
  by smtp-border-fw-out-33001.sea14.amazon.com with ESMTP; 25 Nov 2020 22:51:56 +0000
Received: from EX13MTAUWA001.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan2.pdx.amazon.com [10.236.137.194])
        by email-inbound-relay-2b-baacba05.us-west-2.amazon.com (Postfix) with ESMTPS id E3F1BA1BFF;
        Wed, 25 Nov 2020 22:51:55 +0000 (UTC)
Received: from EX13D10UWA004.ant.amazon.com (10.43.160.64) by
 EX13MTAUWA001.ant.amazon.com (10.43.160.118) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Wed, 25 Nov 2020 22:51:55 +0000
Received: from EX13MTAUWA001.ant.amazon.com (10.43.160.58) by
 EX13D10UWA004.ant.amazon.com (10.43.160.64) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Wed, 25 Nov 2020 22:51:54 +0000
Received: from HFA15-G63729NC.amazon.com (10.1.213.33) by
 mail-relay.amazon.com (10.43.160.118) with Microsoft SMTP Server id
 15.0.1497.2 via Frontend Transport; Wed, 25 Nov 2020 22:51:50 +0000
From:   <akiyano@amazon.com>
To:     <kuba@kernel.org>, <netdev@vger.kernel.org>
CC:     Arthur Kiyanovski <akiyano@amazon.com>, <dwmw@amazon.com>,
        <zorik@amazon.com>, <matua@amazon.com>, <saeedb@amazon.com>,
        <msw@amazon.com>, <aliguori@amazon.com>, <nafea@amazon.com>,
        <gtzalik@amazon.com>, <netanel@amazon.com>, <alisaidi@amazon.com>,
        <benh@amazon.com>, <ndagan@amazon.com>, <shayagr@amazon.com>,
        <sameehj@amazon.com>
Subject: [PATCH V1 net-next 0/9] XDP Redirect implementation for ENA driver 
Date:   Thu, 26 Nov 2020 00:51:39 +0200
Message-ID: <1606344708-11100-1-git-send-email-akiyano@amazon.com>
X-Mailer: git-send-email 2.7.4
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Arthur Kiyanovski <akiyano@amazon.com>

Hi all,
ENA is adding XDP Redirect support for its driver and some other small tweaks.

This series adds the following:

- Make log messages in the driver have a uniform format using netdev_* function
- Improve code readability and add explicit masking
- Add support for XDP Redirect

This series requires the patchset sent to 'net' to be applied cleanly. Decided
to send this one up front to reduce the risk of not getting XDP Redirect in next
version.

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
 drivers/net/ethernet/amazon/ena/ena_netdev.c  | 399 ++++++++++--------
 drivers/net/ethernet/amazon/ena/ena_netdev.h  |  12 +-
 7 files changed, 548 insertions(+), 375 deletions(-)

-- 
2.23.3

