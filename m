Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5E18E10CC61
	for <lists+netdev@lfdr.de>; Thu, 28 Nov 2019 17:02:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726608AbfK1QCF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Nov 2019 11:02:05 -0500
Received: from smtp-fw-9101.amazon.com ([207.171.184.25]:41092 "EHLO
        smtp-fw-9101.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726582AbfK1QCF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Nov 2019 11:02:05 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1574956924; x=1606492924;
  h=from:to:cc:subject:date:message-id:mime-version;
  bh=VNRTtZUSVofL6NJtTPX6451AUy2ncTXSaVZM8prf838=;
  b=uAcc+ByWkbyiVN3D18Yj9CbBXDlyzUfz3cXURMfg2xeNSEAGMyOPBF4/
   NOr+93pOOExi4tPl+kuQApdjm2r8lOE3xg+FFrCcq4Ow4wDml486cNfFI
   q+kJaMBZi6sxNI6e+4iFO5ps80MxkEwagTB78NyJrjVToXAxsOlH788U8
   c=;
IronPort-SDR: 5iw1MmDYictGcpMyEeo0+08zDHlydKGRGaru7QH21Bd4WjElWQBvDcVXrDznzu1a0pF5yXyP9O
 SxTVGqyio0lw==
X-IronPort-AV: E=Sophos;i="5.69,253,1571702400"; 
   d="scan'208";a="2033576"
Received: from sea32-co-svc-lb4-vlan3.sea.corp.amazon.com (HELO email-inbound-relay-1d-74cf8b49.us-east-1.amazon.com) ([10.47.23.38])
  by smtp-border-fw-out-9101.sea19.amazon.com with ESMTP; 28 Nov 2019 16:01:54 +0000
Received: from EX13MTAUWB001.ant.amazon.com (iad55-ws-svc-p15-lb9-vlan2.iad.amazon.com [10.40.159.162])
        by email-inbound-relay-1d-74cf8b49.us-east-1.amazon.com (Postfix) with ESMTPS id 77497C06F0;
        Thu, 28 Nov 2019 16:01:53 +0000 (UTC)
Received: from EX13D02UWB002.ant.amazon.com (10.43.161.160) by
 EX13MTAUWB001.ant.amazon.com (10.43.161.207) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Thu, 28 Nov 2019 16:01:52 +0000
Received: from EX13MTAUWB001.ant.amazon.com (10.43.161.207) by
 EX13D02UWB002.ant.amazon.com (10.43.161.160) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Thu, 28 Nov 2019 16:01:52 +0000
Received: from HFA16-8226Y22.hfa16.amazon.com (10.218.52.96) by
 mail-relay.amazon.com (10.43.161.249) with Microsoft SMTP Server id
 15.0.1367.3 via Frontend Transport; Thu, 28 Nov 2019 16:01:48 +0000
From:   <sameehj@amazon.com>
To:     <davem@davemloft.net>, <netdev@vger.kernel.org>
CC:     Sameeh Jubran <sameehj@amazon.com>, <dwmw@amazon.com>,
        <zorik@amazon.com>, <matua@amazon.com>, <saeedb@amazon.com>,
        <msw@amazon.com>, <aliguori@amazon.com>, <nafea@amazon.com>,
        <gtzalik@amazon.com>, <netanel@amazon.com>, <alisaidi@amazon.com>,
        <benh@amazon.com>, <akiyano@amazon.com>
Subject: [PATCH V3 net-next v3 0/3] Introduce XDP to ena
Date:   Thu, 28 Nov 2019 18:01:43 +0200
Message-ID: <20191128160146.16109-1-sameehj@amazon.com>
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
 drivers/net/ethernet/amazon/ena/ena_netdev.c  | 964 +++++++++++++++---
 drivers/net/ethernet/amazon/ena/ena_netdev.h  |  73 ++
 3 files changed, 893 insertions(+), 148 deletions(-)

-- 
2.17.1

