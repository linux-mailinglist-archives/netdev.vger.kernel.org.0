Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 35C172CC82D
	for <lists+netdev@lfdr.de>; Wed,  2 Dec 2020 21:46:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389466AbgLBUnS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Dec 2020 15:43:18 -0500
Received: from smtp-fw-6001.amazon.com ([52.95.48.154]:23143 "EHLO
        smtp-fw-6001.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388527AbgLBUnQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Dec 2020 15:43:16 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1606941796; x=1638477796;
  h=from:to:cc:subject:date:message-id:mime-version;
  bh=DW4NeFVC4M+iF1cdhe385gJv1BS7mD7/VyrschPXag8=;
  b=X7KF/vIV6YORu/g+zIWzr7NPUm/HHEXG5IeOPhqgn1uAxXbZ4+/eHGP9
   lSN/Pto2AmE80c1Snl/Ot4XQTIV8brH8VlSdxqGmHoiuqZytOexahmER3
   mKX346ZgZTN3cwzZxcqzq0jSggapuiImvAK89+4JRjxc0lT3OwJho1r8Q
   w=;
X-IronPort-AV: E=Sophos;i="5.78,387,1599523200"; 
   d="scan'208";a="70182129"
Received: from iad12-co-svc-p1-lb1-vlan2.amazon.com (HELO email-inbound-relay-1d-e69428c4.us-east-1.amazon.com) ([10.43.8.2])
  by smtp-border-fw-out-6001.iad6.amazon.com with ESMTP; 02 Dec 2020 20:04:09 +0000
Received: from EX13MTAUEB001.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan2.iad.amazon.com [10.40.163.34])
        by email-inbound-relay-1d-e69428c4.us-east-1.amazon.com (Postfix) with ESMTPS id A234EC1FC7;
        Wed,  2 Dec 2020 20:03:38 +0000 (UTC)
Received: from EX13D08UEB003.ant.amazon.com (10.43.60.11) by
 EX13MTAUEB001.ant.amazon.com (10.43.60.129) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Wed, 2 Dec 2020 20:03:37 +0000
Received: from EX13MTAUEA001.ant.amazon.com (10.43.61.82) by
 EX13D08UEB003.ant.amazon.com (10.43.60.11) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Wed, 2 Dec 2020 20:03:36 +0000
Received: from HFA15-G63729NC.amazon.com (10.1.212.23) by
 mail-relay.amazon.com (10.43.61.243) with Microsoft SMTP Server id
 15.0.1497.2 via Frontend Transport; Wed, 2 Dec 2020 20:03:34 +0000
From:   <akiyano@amazon.com>
To:     <kuba@kernel.org>, <netdev@vger.kernel.org>
CC:     Arthur Kiyanovski <akiyano@amazon.com>, <dwmw@amazon.com>,
        <zorik@amazon.com>, <matua@amazon.com>, <saeedb@amazon.com>,
        <msw@amazon.com>, <aliguori@amazon.com>, <nafea@amazon.com>,
        <gtzalik@amazon.com>, <netanel@amazon.com>, <alisaidi@amazon.com>,
        <benh@amazon.com>, <ndagan@amazon.com>, <shayagr@amazon.com>,
        <sameehj@amazon.com>
Subject: [PATCH V3 net-next 0/9] XDP Redirect implementation for ENA driver
Date:   Wed, 2 Dec 2020 22:03:21 +0200
Message-ID: <1606939410-26718-1-git-send-email-akiyano@amazon.com>
X-Mailer: git-send-email 2.7.4
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Arthur Kiyanovski <akiyano@amazon.com>


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

