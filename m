Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C053A11895B
	for <lists+netdev@lfdr.de>; Tue, 10 Dec 2019 14:12:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727431AbfLJNMv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Dec 2019 08:12:51 -0500
Received: from smtp-fw-9102.amazon.com ([207.171.184.29]:65376 "EHLO
        smtp-fw-9102.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727334AbfLJNMu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Dec 2019 08:12:50 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1575983570; x=1607519570;
  h=from:to:cc:subject:date:message-id:mime-version;
  bh=UD3vaFmTrMOwG337t3Ds3LT3ub4jilU3i4ommYzkaVs=;
  b=wEa4GMjHS9J/nQKsjFTKaez/3Ino2PTxxKNCJBdUgUai/iKC4uvgmnps
   kvz4Q4UDKhdTE3TZLOiCZeOqXZtfOMNov8TIdgZla/j1zoOVULvPQyd0J
   EiZ3typj+1ClNq+YQkSlHKReeQvOVnaWvJAca0cFleA7DiEtQ6zVOGjsR
   M=;
IronPort-SDR: fFtPiEp3uoyOoMewyT7o/nnTKjkps3jNy3z35cXfkWbqMICzj3XPyviiweDU01AUwQo+aPB9Xf
 gegykWBH3Zvg==
X-IronPort-AV: E=Sophos;i="5.69,299,1571702400"; 
   d="scan'208";a="12652449"
Received: from sea32-co-svc-lb4-vlan3.sea.corp.amazon.com (HELO email-inbound-relay-2a-8549039f.us-west-2.amazon.com) ([10.47.23.38])
  by smtp-border-fw-out-9102.sea19.amazon.com with ESMTP; 10 Dec 2019 13:12:36 +0000
Received: from EX13MTAUEA001.ant.amazon.com (pdx4-ws-svc-p6-lb7-vlan2.pdx.amazon.com [10.170.41.162])
        by email-inbound-relay-2a-8549039f.us-west-2.amazon.com (Postfix) with ESMTPS id 41775A1E5B;
        Tue, 10 Dec 2019 13:12:35 +0000 (UTC)
Received: from EX13D08UEB003.ant.amazon.com (10.43.60.11) by
 EX13MTAUEA001.ant.amazon.com (10.43.61.243) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Tue, 10 Dec 2019 13:12:34 +0000
Received: from EX13MTAUEA001.ant.amazon.com (10.43.61.82) by
 EX13D08UEB003.ant.amazon.com (10.43.60.11) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Tue, 10 Dec 2019 13:12:33 +0000
Received: from HFA16-8226Y22.hfa16.amazon.com (10.218.52.96) by
 mail-relay.amazon.com (10.43.61.243) with Microsoft SMTP Server id
 15.0.1367.3 via Frontend Transport; Tue, 10 Dec 2019 13:12:30 +0000
From:   <sameehj@amazon.com>
To:     <davem@davemloft.net>, <netdev@vger.kernel.org>
CC:     Sameeh Jubran <sameehj@amazon.com>, <brouer@redhat.com>,
        <ilias.apalodimas@linaro.org>, <dwmw@amazon.com>,
        <zorik@amazon.com>, <matua@amazon.com>, <saeedb@amazon.com>,
        <msw@amazon.com>, <aliguori@amazon.com>, <nafea@amazon.com>,
        <gtzalik@amazon.com>, <netanel@amazon.com>, <alisaidi@amazon.com>,
        <benh@amazon.com>, <akiyano@amazon.com>
Subject: [PATCH V3 net-next v3 0/3] Introduce XDP to ena
Date:   Tue, 10 Dec 2019 15:12:11 +0200
Message-ID: <20191210131214.3887-1-sameehj@amazon.com>
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

Difference from v2:
* Fixed the usage of rx headroom (XDP_PACKET_HEADROOM)
* Aligned the page_offset of the packet when passing it to the stack
* Switched to using xdp_frame in xdp xmit queue
* Dropped the print for unsupported commands
* Cosmetic changes

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
 drivers/net/ethernet/amazon/ena/ena_netdev.c  | 960 +++++++++++++++---
 drivers/net/ethernet/amazon/ena/ena_netdev.h  |  73 ++
 3 files changed, 889 insertions(+), 148 deletions(-)

-- 
2.17.1

