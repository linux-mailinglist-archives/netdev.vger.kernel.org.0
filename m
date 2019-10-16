Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 41A1AD9366
	for <lists+netdev@lfdr.de>; Wed, 16 Oct 2019 16:11:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393849AbfJPOLW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Oct 2019 10:11:22 -0400
Received: from smtp-fw-6002.amazon.com ([52.95.49.90]:45001 "EHLO
        smtp-fw-6002.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731923AbfJPOLW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Oct 2019 10:11:22 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1571235081; x=1602771081;
  h=from:to:cc:subject:date:message-id:mime-version;
  bh=iQsYuDE/WGepX+TVSdloxNqaod/bxm7v8hCbrMStVU0=;
  b=ak0GL1reZGvfrek+7Oigm2VF4BvHn+StXb8R5RdwLzQwX0u8G6nM+jPG
   X2j9txsB+LF6vRpEOMlko3+DHZzQjOuFb1hJH7k0SV1PjzRpdaQLtWVDp
   QX8E9OLqESyXBJCnKjOvxIMxwzQP54l4Ewp1LZMff8FoZc77DCV6XNZYl
   Q=;
X-IronPort-AV: E=Sophos;i="5.67,304,1566864000"; 
   d="scan'208";a="429741077"
Received: from iad6-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-2b-4e24fd92.us-west-2.amazon.com) ([10.124.125.6])
  by smtp-border-fw-out-6002.iad6.amazon.com with ESMTP; 16 Oct 2019 14:11:18 +0000
Received: from EX13MTAUWC001.ant.amazon.com (pdx4-ws-svc-p6-lb7-vlan2.pdx.amazon.com [10.170.41.162])
        by email-inbound-relay-2b-4e24fd92.us-west-2.amazon.com (Postfix) with ESMTPS id 75935A2283;
        Wed, 16 Oct 2019 14:11:18 +0000 (UTC)
Received: from EX13D02UWC001.ant.amazon.com (10.43.162.243) by
 EX13MTAUWC001.ant.amazon.com (10.43.162.135) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Wed, 16 Oct 2019 14:11:17 +0000
Received: from EX13MTAUWC001.ant.amazon.com (10.43.162.135) by
 EX13D02UWC001.ant.amazon.com (10.43.162.243) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Wed, 16 Oct 2019 14:11:17 +0000
Received: from HFA16-8226Y22.hfa16.amazon.com (10.218.52.96) by
 mail-relay.amazon.com (10.43.162.232) with Microsoft SMTP Server id
 15.0.1367.3 via Frontend Transport; Wed, 16 Oct 2019 14:11:14 +0000
From:   <sameehj@amazon.com>
To:     <davem@davemloft.net>, <netdev@vger.kernel.org>
CC:     Sameeh Jubran <sameehj@amazon.com>, <dwmw@amazon.com>,
        <zorik@amazon.com>, <matua@amazon.com>, <saeedb@amazon.com>,
        <msw@amazon.com>, <aliguori@amazon.com>, <nafea@amazon.com>,
        <gtzalik@amazon.com>, <netanel@amazon.com>, <alisaidi@amazon.com>,
        <benh@amazon.com>, <akiyano@amazon.com>
Subject: [RFC V2 net-next v2 0/3] Introduce XDP to ena
Date:   Wed, 16 Oct 2019 17:11:08 +0300
Message-ID: <20191016141111.5895-1-sameehj@amazon.com>
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
 drivers/net/ethernet/amazon/ena/ena_netdev.c  | 839 ++++++++++++++++--
 drivers/net/ethernet/amazon/ena/ena_netdev.h  |  70 ++
 3 files changed, 815 insertions(+), 98 deletions(-)

-- 
2.17.1

