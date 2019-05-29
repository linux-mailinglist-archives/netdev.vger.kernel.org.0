Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 91FEE2D96F
	for <lists+netdev@lfdr.de>; Wed, 29 May 2019 11:50:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725948AbfE2JuR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 May 2019 05:50:17 -0400
Received: from smtp-fw-6002.amazon.com ([52.95.49.90]:13093 "EHLO
        smtp-fw-6002.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725861AbfE2JuR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 May 2019 05:50:17 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1559123416; x=1590659416;
  h=from:to:cc:subject:date:message-id:mime-version;
  bh=rMhn9k8ydI8ggSvPRwtD49BoZCtw6NegaMgK8/CMsFs=;
  b=YIAjZWBbJn+zoVxxKr+Weq11FUpiJK7HAz70lG/M6mdEYuBdZq1MasaJ
   5Fpr/Wp9hZMu43RalQ520oIrYisq1giCWkzQM0t709RX4oI/PAQ4iyhnx
   zVhovHKcsqUBWNshGKNLwudrsu2uhYB2HMFLR7l4nQbL0EqPmW9pqPQFM
   o=;
X-IronPort-AV: E=Sophos;i="5.60,526,1549929600"; 
   d="scan'208";a="404152370"
Received: from iad6-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-1e-97fdccfd.us-east-1.amazon.com) ([10.124.125.6])
  by smtp-border-fw-out-6002.iad6.amazon.com with ESMTP; 29 May 2019 09:50:14 +0000
Received: from EX13MTAUWB001.ant.amazon.com (iad55-ws-svc-p15-lb9-vlan3.iad.amazon.com [10.40.159.166])
        by email-inbound-relay-1e-97fdccfd.us-east-1.amazon.com (Postfix) with ESMTPS id 85123A1C9C;
        Wed, 29 May 2019 09:50:14 +0000 (UTC)
Received: from EX13D21UWB002.ant.amazon.com (10.43.161.177) by
 EX13MTAUWB001.ant.amazon.com (10.43.161.207) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Wed, 29 May 2019 09:50:13 +0000
Received: from EX13MTAUWB001.ant.amazon.com (10.43.161.207) by
 EX13D21UWB002.ant.amazon.com (10.43.161.177) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Wed, 29 May 2019 09:50:13 +0000
Received: from HFA16-8226Y22.hfa16.amazon.com (10.218.60.55) by
 mail-relay.amazon.com (10.43.161.249) with Microsoft SMTP Server id
 15.0.1367.3 via Frontend Transport; Wed, 29 May 2019 09:50:09 +0000
From:   <sameehj@amazon.com>
To:     <davem@davemloft.net>, <netdev@vger.kernel.org>
CC:     Sameeh Jubran <sameehj@amazon.com>, <dwmw@amazon.com>,
        <zorik@amazon.com>, <matua@amazon.com>, <saeedb@amazon.com>,
        <msw@amazon.com>, <aliguori@amazon.com>, <nafea@amazon.com>,
        <gtzalik@amazon.com>, <netanel@amazon.com>, <alisaidi@amazon.com>,
        <benh@amazon.com>, <akiyano@amazon.com>
Subject: [PATCH V1 net-next 00/11] Extending the ena driver to support new features and enhance performance
Date:   Wed, 29 May 2019 12:49:53 +0300
Message-ID: <20190529095004.13341-1-sameehj@amazon.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Sameeh Jubran <sameehj@amazon.com>

This patchset introduces the following:
* add support for changing the inline header size (max_header_size) for applications with overlay and nested headers
* enable automatic fallback to polling mode for admin queue when interrupt is not available or missed
* add good checksum counter for Rx ethtool statistics
* update ena.txt
* some minor code clean-up
* some performance enhancements with doorbell calculations

Arthur Kiyanovski (1):
  net: ena: ethtool: add extra properties retrieval via get_priv_flags

Sameeh Jubran (10):
  net: ena: add handling of llq max tx burst size
  net: ena: replace free_tx/rx_ids union with single free_ids field in
    ena_ring
  net: ena: arrange ena_probe() function variables in reverse christmas
    tree
  net: ena: add newline at the end of pr_err prints
  net: ena: documentation: update ena.txt
  net: ena: allow automatic fallback to polling mode
  net: ena: add support for changing max_header_size in LLQ mode
  net: ena: optimise calculations for CQ doorbell
  net: ena: add good checksum counter
  net: ena: use dev_info_once instead of static variable

 .../networking/device_drivers/amazon/ena.txt  |   5 +-
 .../net/ethernet/amazon/ena/ena_admin_defs.h  |  21 +++
 drivers/net/ethernet/amazon/ena/ena_com.c     | 123 ++++++++++++++----
 drivers/net/ethernet/amazon/ena/ena_com.h     |  48 +++++++
 drivers/net/ethernet/amazon/ena/ena_eth_com.c |  28 ++--
 drivers/net/ethernet/amazon/ena/ena_eth_com.h |  73 +++++++++--
 drivers/net/ethernet/amazon/ena/ena_ethtool.c |  80 ++++++++++--
 drivers/net/ethernet/amazon/ena/ena_netdev.c  |  86 +++++++-----
 drivers/net/ethernet/amazon/ena/ena_netdev.h  |  16 +--
 9 files changed, 378 insertions(+), 102 deletions(-)

-- 
2.17.1

