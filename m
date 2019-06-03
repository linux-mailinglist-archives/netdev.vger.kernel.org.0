Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5C05B33276
	for <lists+netdev@lfdr.de>; Mon,  3 Jun 2019 16:43:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729170AbfFCOnl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Jun 2019 10:43:41 -0400
Received: from smtp-fw-9101.amazon.com ([207.171.184.25]:59159 "EHLO
        smtp-fw-9101.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728882AbfFCOnl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Jun 2019 10:43:41 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1559573019; x=1591109019;
  h=from:to:cc:subject:date:message-id:mime-version;
  bh=0/IedhPF8FhfQFpgj/2xFgyAOF7nUh6CTL2DYUKnqR4=;
  b=n0j+QbJMYstg4v2T+43b8caXR5A2JJG7YC2eFYOww0HuaMMf9gdPBbVN
   5Fbjg1Q3whSq/M0RWjikgMaOgaIac0gNQWHWebrfwL9gjyMzrZzaViLmg
   Njt1WUseJvt2X5yB4MkeYSt61ARsv98N56HAi8znEG2oBENwGX2Zo4UsF
   g=;
X-IronPort-AV: E=Sophos;i="5.60,547,1549929600"; 
   d="scan'208";a="808243029"
Received: from sea3-co-svc-lb6-vlan3.sea.amazon.com (HELO email-inbound-relay-1d-9ec21598.us-east-1.amazon.com) ([10.47.22.38])
  by smtp-border-fw-out-9101.sea19.amazon.com with ESMTP; 03 Jun 2019 14:43:37 +0000
Received: from EX13MTAUEA001.ant.amazon.com (iad55-ws-svc-p15-lb9-vlan3.iad.amazon.com [10.40.159.166])
        by email-inbound-relay-1d-9ec21598.us-east-1.amazon.com (Postfix) with ESMTPS id 37625A1B7D;
        Mon,  3 Jun 2019 14:43:36 +0000 (UTC)
Received: from EX13D08UEE003.ant.amazon.com (10.43.62.118) by
 EX13MTAUEA001.ant.amazon.com (10.43.61.82) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Mon, 3 Jun 2019 14:43:36 +0000
Received: from EX13MTAUEE001.ant.amazon.com (10.43.62.200) by
 EX13D08UEE003.ant.amazon.com (10.43.62.118) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Mon, 3 Jun 2019 14:43:36 +0000
Received: from HFA16-8226Y22.hfa16.amazon.com (10.218.60.55) by
 mail-relay.amazon.com (10.43.62.226) with Microsoft SMTP Server id
 15.0.1367.3 via Frontend Transport; Mon, 3 Jun 2019 14:43:33 +0000
From:   <sameehj@amazon.com>
To:     <davem@davemloft.net>, <netdev@vger.kernel.org>
CC:     Sameeh Jubran <sameehj@amazon.com>, <dwmw@amazon.com>,
        <zorik@amazon.com>, <matua@amazon.com>, <saeedb@amazon.com>,
        <msw@amazon.com>, <aliguori@amazon.com>, <nafea@amazon.com>,
        <gtzalik@amazon.com>, <netanel@amazon.com>, <alisaidi@amazon.com>,
        <benh@amazon.com>, <akiyano@amazon.com>
Subject: [PATCH V2 net 00/11] Extending the ena driver to support new features and enhance performance
Date:   Mon, 3 Jun 2019 17:43:18 +0300
Message-ID: <20190603144329.16366-1-sameehj@amazon.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Sameeh Jubran <sameehj@amazon.com>

This patchset introduces the following:

* add support for changing the inline header size (max_header_size) for applications
  with overlay and nested headers
* enable automatic fallback to polling mode for admin queue when interrupt is not
  available or missed
* add good checksum counter for Rx ethtool statistics
* update ena.txt
* some minor code clean-up
* some performance enhancements with doorbell calculations

Differences from V1:

* net: ena: add handling of llq max tx burst size (1/11):
 * fixed christmas tree issue

* net: ena: ethtool: add extra properties retrieval via get_priv_flags (2/11):
 * replaced snprintf with strlcpy
 * dropped confusing error message
 * added more details to  the commit message

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
 drivers/net/ethernet/amazon/ena/ena_ethtool.c |  78 +++++++++--
 drivers/net/ethernet/amazon/ena/ena_netdev.c  |  86 +++++++-----
 drivers/net/ethernet/amazon/ena/ena_netdev.h  |  16 +--
 9 files changed, 376 insertions(+), 102 deletions(-)

-- 
2.17.1

