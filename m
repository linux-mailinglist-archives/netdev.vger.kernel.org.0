Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F038E102577
	for <lists+netdev@lfdr.de>; Tue, 19 Nov 2019 14:34:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727505AbfKSNeg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Nov 2019 08:34:36 -0500
Received: from smtp-fw-4101.amazon.com ([72.21.198.25]:49955 "EHLO
        smtp-fw-4101.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725280AbfKSNeg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Nov 2019 08:34:36 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1574170476; x=1605706476;
  h=from:to:cc:subject:date:message-id:mime-version;
  bh=O+V9is7PRywZvn0X6rlcWv0NgpDTo1iLwEpH9zV/HGA=;
  b=Avq7wULwtNvWFxbyrn3gRbr8F5jdfLXZv8O8G2LoJM7V2+qHBOSKq0M1
   8upKsuDF6Xp1EzSOM7fBIXzrrFOEkvlCLwb1W/5MrkrW/6OB12CEhTsy5
   rLMXuJRjxVq4a0HtxkDihGG5GDsWC3ggc8v3rTgdyJhAo+itdgJHqxj0h
   g=;
IronPort-SDR: 3tMJcwcs3U1ogeVNcJ8NcJkohIEHggT4SSVEG95gImF7bve9Al7s1tl4Xcpa3HfDYFHVm2/VId
 ANDj9mk9OCPw==
X-IronPort-AV: E=Sophos;i="5.68,324,1569283200"; 
   d="scan'208";a="4697741"
Received: from iad6-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-2c-87a10be6.us-west-2.amazon.com) ([10.124.125.6])
  by smtp-border-fw-out-4101.iad4.amazon.com with ESMTP; 19 Nov 2019 13:34:35 +0000
Received: from EX13MTAUEB001.ant.amazon.com (pdx4-ws-svc-p6-lb7-vlan2.pdx.amazon.com [10.170.41.162])
        by email-inbound-relay-2c-87a10be6.us-west-2.amazon.com (Postfix) with ESMTPS id 8D532A1D12;
        Tue, 19 Nov 2019 13:34:33 +0000 (UTC)
Received: from EX13D08UEB004.ant.amazon.com (10.43.60.142) by
 EX13MTAUEB001.ant.amazon.com (10.43.60.129) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Tue, 19 Nov 2019 13:34:33 +0000
Received: from EX13MTAUEB001.ant.amazon.com (10.43.60.96) by
 EX13D08UEB004.ant.amazon.com (10.43.60.142) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Tue, 19 Nov 2019 13:34:32 +0000
Received: from HFA16-8226Y22.hfa16.amazon.com (10.218.52.96) by
 mail-relay.amazon.com (10.43.60.129) with Microsoft SMTP Server id
 15.0.1367.3 via Frontend Transport; Tue, 19 Nov 2019 13:34:30 +0000
From:   <sameehj@amazon.com>
To:     <davem@davemloft.net>, <netdev@vger.kernel.org>
CC:     Sameeh Jubran <sameehj@amazon.com>, <dwmw@amazon.com>,
        <zorik@amazon.com>, <matua@amazon.com>, <saeedb@amazon.com>,
        <msw@amazon.com>, <aliguori@amazon.com>, <nafea@amazon.com>,
        <gtzalik@amazon.com>, <netanel@amazon.com>, <alisaidi@amazon.com>,
        <benh@amazon.com>, <akiyano@amazon.com>
Subject: [PATCH V2 net-next v2 0/3] Introduce XDP to ena
Date:   Tue, 19 Nov 2019 15:34:16 +0200
Message-ID: <20191119133419.9734-1-sameehj@amazon.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Sameeh Jubran <sameehj@amazon.com>

This patchset includes 3 patches:
* XDP_DROP implementation
* XDP_TX implementation
* A fix for an issue which might occur due to the XDP_TX patch. I see fit
  to place it as a standalone patch for clarity.

Difference from RFC v1 (XDP_DROP patch):
* Initialized xdp.rxq pointer
* Updated max_mtu on attachment of xdp and removed the check from
  ena_change_mtu()
* Moved the xdp execution from ena_rx_skb() to ena_clean_rx_irq()
* Moved xdp buff (struct xdp_buff) from rx_ring to the local stack
* Started using netlink's extack mechanism to deliver error messages to
  the user

Sameeh Jubran (3):
  net: ena: implement XDP drop support
  net: ena: Implement XDP_TX action
  net: ena: Add first_interrupt field to napi struct

 drivers/net/ethernet/amazon/ena/ena_ethtool.c |   4 +-
 drivers/net/ethernet/amazon/ena/ena_netdev.c  | 930 +++++++++++++++---
 drivers/net/ethernet/amazon/ena/ena_netdev.h  |  72 ++
 3 files changed, 867 insertions(+), 139 deletions(-)

-- 
2.17.1

