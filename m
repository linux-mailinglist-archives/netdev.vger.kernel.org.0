Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1B65121A778
	for <lists+netdev@lfdr.de>; Thu,  9 Jul 2020 21:05:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726272AbgGITFR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Jul 2020 15:05:17 -0400
Received: from smtp-fw-4101.amazon.com ([72.21.198.25]:50325 "EHLO
        smtp-fw-4101.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726116AbgGITFQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Jul 2020 15:05:16 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1594321516; x=1625857516;
  h=from:to:cc:subject:date:message-id:mime-version;
  bh=gZCTesQxesVx6+Q4kwP+0JDe7blsdbO8LNyAkSnuTU0=;
  b=WuSKzveTtnmRqdT4gQDHmVrh+icT9zjUYgGUhD1pTxPX8lqRuMNUX8gY
   ZzPJfEcCcCnJSe52JAMXgRzz70Z0EIpqOX3P0ftxMn/T3IBUVzEWayJai
   NGHtfxVi3Ho7/c185snazBT0izGS+WyrIc83swk3CO+PCyNDfMBBrH4He
   E=;
IronPort-SDR: 3J4A+KrLyWaRh7In5j1T5zV92UsnHs0vu77XhRGsmVqCz0oDj7m57l133P2T/1azUv3pFN7l2/
 oFKe1FOC25uw==
X-IronPort-AV: E=Sophos;i="5.75,332,1589241600"; 
   d="scan'208";a="41136497"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-1d-74cf8b49.us-east-1.amazon.com) ([10.43.8.6])
  by smtp-border-fw-out-4101.iad4.amazon.com with ESMTP; 09 Jul 2020 19:05:13 +0000
Received: from EX13MTAUWC001.ant.amazon.com (iad55-ws-svc-p15-lb9-vlan2.iad.amazon.com [10.40.159.162])
        by email-inbound-relay-1d-74cf8b49.us-east-1.amazon.com (Postfix) with ESMTPS id 57638C08E3;
        Thu,  9 Jul 2020 19:05:12 +0000 (UTC)
Received: from EX13d09UWC003.ant.amazon.com (10.43.162.113) by
 EX13MTAUWC001.ant.amazon.com (10.43.162.135) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Thu, 9 Jul 2020 19:05:11 +0000
Received: from EX13MTAUWC001.ant.amazon.com (10.43.162.135) by
 EX13d09UWC003.ant.amazon.com (10.43.162.113) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Thu, 9 Jul 2020 19:05:10 +0000
Received: from HFA15-G63729NC.amazon.com (10.1.213.15) by
 mail-relay.amazon.com (10.43.162.232) with Microsoft SMTP Server id
 15.0.1497.2 via Frontend Transport; Thu, 9 Jul 2020 19:05:06 +0000
From:   <akiyano@amazon.com>
To:     <davem@davemloft.net>, <netdev@vger.kernel.org>
CC:     Arthur Kiyanovski <akiyano@amazon.com>, <dwmw@amazon.com>,
        <zorik@amazon.com>, <matua@amazon.com>, <saeedb@amazon.com>,
        <msw@amazon.com>, <aliguori@amazon.com>, <nafea@amazon.com>,
        <gtzalik@amazon.com>, <netanel@amazon.com>, <alisaidi@amazon.com>,
        <benh@amazon.com>, <ndagan@amazon.com>, <shayagr@amazon.com>,
        <sameehj@amazon.com>
Subject: [PATCH V1 net-next 0/8] ENA driver new features
Date:   Thu, 9 Jul 2020 22:04:55 +0300
Message-ID: <1594321503-12256-1-git-send-email-akiyano@amazon.com>
X-Mailer: git-send-email 2.7.4
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Arthur Kiyanovski <akiyano@amazon.com>

This patchset contains performance improvements, support for new devices
and functionality:

1. Support for upcoming ENA devices
2. Avoid unnecessary IRQ unmasking in busy poll to reduce interrupt rate
3. Enabling device support for RSS function and key manipulation
4. Support for NIC-based traffic mirroring (SPAN port)
5. Additional PCI device ID 
6. Cosmetic changes

Arthur Kiyanovski (8):
  net: ena: avoid unnecessary rearming of interrupt vector when
    busy-polling
  net: ena: add reserved PCI device ID
  net: ena: cosmetic: satisfy gcc warning
  net: ena: cosmetic: change ena_com_stats_admin stats to u64
  net: ena: add support for traffic mirroring
  net: ena: enable support of rss hash key and function changes
  net: ena: move llq configuration from ena_probe to ena_device_init()
  net: ena: support new LLQ acceleration mode

 .../net/ethernet/amazon/ena/ena_admin_defs.h  |  47 ++++-
 drivers/net/ethernet/amazon/ena/ena_com.c     |  19 +-
 drivers/net/ethernet/amazon/ena/ena_com.h     |  13 +-
 drivers/net/ethernet/amazon/ena/ena_eth_com.c |  51 +++--
 drivers/net/ethernet/amazon/ena/ena_eth_com.h |   3 +-
 drivers/net/ethernet/amazon/ena/ena_ethtool.c |   4 +-
 drivers/net/ethernet/amazon/ena/ena_netdev.c  | 177 ++++++++++--------
 drivers/net/ethernet/amazon/ena/ena_netdev.h  |   3 +
 .../net/ethernet/amazon/ena/ena_pci_id_tbl.h  |   5 +
 9 files changed, 219 insertions(+), 103 deletions(-)

-- 
2.23.1

