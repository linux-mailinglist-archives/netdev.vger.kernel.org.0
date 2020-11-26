Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4389B2C5D73
	for <lists+netdev@lfdr.de>; Thu, 26 Nov 2020 22:20:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732543AbgKZVUb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Nov 2020 16:20:31 -0500
Received: from smtp-fw-9102.amazon.com ([207.171.184.29]:6324 "EHLO
        smtp-fw-9102.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726178AbgKZVUb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Nov 2020 16:20:31 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1606425631; x=1637961631;
  h=from:to:cc:subject:date:message-id:mime-version;
  bh=9ZAaNYorPZD9LK7xerF1xKtNSExGpNfYRfXtIzSD884=;
  b=GetdyF47+ciKY5zD+kl7fDeQKl6PygOiB8tX/C2AKjl4RwKpAVXKW1Le
   tIMo25R3qtLzTUooSBfmAzQjTeCy5Rhd1vHbj66k/b45YUAH8pqm9sBip
   Fgd50GFr2b/sO7ZPKOFUJNO4qmBABJpWH5JwWkzD7b5QD6BgjP6iCA2mZ
   4=;
X-IronPort-AV: E=Sophos;i="5.78,373,1599523200"; 
   d="scan'208";a="99555464"
Received: from sea32-co-svc-lb4-vlan3.sea.corp.amazon.com (HELO email-inbound-relay-2b-c300ac87.us-west-2.amazon.com) ([10.47.23.38])
  by smtp-border-fw-out-9102.sea19.amazon.com with ESMTP; 26 Nov 2020 21:20:25 +0000
Received: from EX13MTAUEB001.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan2.pdx.amazon.com [10.236.137.194])
        by email-inbound-relay-2b-c300ac87.us-west-2.amazon.com (Postfix) with ESMTPS id 8888AA2683;
        Thu, 26 Nov 2020 21:20:24 +0000 (UTC)
Received: from EX13D08UEB003.ant.amazon.com (10.43.60.11) by
 EX13MTAUEB001.ant.amazon.com (10.43.60.129) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Thu, 26 Nov 2020 21:20:24 +0000
Received: from EX13MTAUEA001.ant.amazon.com (10.43.61.82) by
 EX13D08UEB003.ant.amazon.com (10.43.60.11) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Thu, 26 Nov 2020 21:20:23 +0000
Received: from HFA15-G63729NC.amazon.com (10.1.213.20) by
 mail-relay.amazon.com (10.43.61.243) with Microsoft SMTP Server id
 15.0.1497.2 via Frontend Transport; Thu, 26 Nov 2020 21:20:20 +0000
From:   <akiyano@amazon.com>
To:     <kuba@kernel.org>, <netdev@vger.kernel.org>
CC:     Arthur Kiyanovski <akiyano@amazon.com>, <dwmw@amazon.com>,
        <zorik@amazon.com>, <matua@amazon.com>, <saeedb@amazon.com>,
        <msw@amazon.com>, <aliguori@amazon.com>, <nafea@amazon.com>,
        <gtzalik@amazon.com>, <netanel@amazon.com>, <alisaidi@amazon.com>,
        <benh@amazon.com>, <ndagan@amazon.com>, <shayagr@amazon.com>,
        <sameehj@amazon.com>
Subject: [RFC PATCH V2 net-next 0/9] XDP Redirect implementation for ENA driver
Date:   Thu, 26 Nov 2020 23:20:08 +0200
Message-ID: <1606425617-13112-1-git-send-email-akiyano@amazon.com>
X-Mailer: git-send-email 2.7.4
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Arthur Kiyanovski <akiyano@amazon.com>

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
 drivers/net/ethernet/amazon/ena/ena_netdev.c  | 395 ++++++++++--------
 drivers/net/ethernet/amazon/ena/ena_netdev.h  |  12 +-
 7 files changed, 544 insertions(+), 375 deletions(-)

-- 
2.23.3

