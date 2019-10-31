Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1149CEB4C4
	for <lists+netdev@lfdr.de>; Thu, 31 Oct 2019 17:35:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727856AbfJaQfs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 31 Oct 2019 12:35:48 -0400
Received: from smtp-fw-6002.amazon.com ([52.95.49.90]:12741 "EHLO
        smtp-fw-6002.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726540AbfJaQfs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 31 Oct 2019 12:35:48 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1572539748; x=1604075748;
  h=from:to:cc:subject:date:message-id:mime-version;
  bh=iQsYuDE/WGepX+TVSdloxNqaod/bxm7v8hCbrMStVU0=;
  b=eE5yNgArrJXipeLp9s1yiOH07hfZKyjhAZJYP08WBB5WQf9SzIwoMMYi
   FOPz2Hsi1bd1SgK0JvlnqSIIX/E8f8snf+oeMSTMcWFj0nqofACChWpWe
   bch4X2iIZy5pVKE3rez9IZy79fNlD0HeLmb5jN60Gv60DKaftwJtvvwH9
   Y=;
IronPort-SDR: DZicOhZGJxsFcUR34RTh9Yr4INmD8wgjef92IxptHFnlaibnKXLERhEh5GOKtwIwjcntgMYJft
 M91jaKgsgcKA==
Received: from iad6-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-1d-474bcd9f.us-east-1.amazon.com) ([10.124.125.6])
  by smtp-border-fw-out-6002.iad6.amazon.com with ESMTP; 31 Oct 2019 16:35:47 +0000
Received: from EX13MTAUEA001.ant.amazon.com (iad55-ws-svc-p15-lb9-vlan3.iad.amazon.com [10.40.159.166])
        by email-inbound-relay-1d-474bcd9f.us-east-1.amazon.com (Postfix) with ESMTPS id 326E9A2213;
        Thu, 31 Oct 2019 16:35:45 +0000 (UTC)
Received: from EX13D08UEE002.ant.amazon.com (10.43.62.92) by
 EX13MTAUEA001.ant.amazon.com (10.43.61.82) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Thu, 31 Oct 2019 16:35:45 +0000
Received: from EX13MTAUEE001.ant.amazon.com (10.43.62.200) by
 EX13D08UEE002.ant.amazon.com (10.43.62.92) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Thu, 31 Oct 2019 16:35:45 +0000
Received: from HFA16-8226Y22.hfa16.amazon.com (10.218.52.96) by
 mail-relay.amazon.com (10.43.62.226) with Microsoft SMTP Server id
 15.0.1367.3 via Frontend Transport; Thu, 31 Oct 2019 16:35:42 +0000
From:   <sameehj@amazon.com>
To:     <davem@davemloft.net>, <netdev@vger.kernel.org>
CC:     Sameeh Jubran <sameehj@amazon.com>, <dwmw@amazon.com>,
        <zorik@amazon.com>, <matua@amazon.com>, <saeedb@amazon.com>,
        <msw@amazon.com>, <aliguori@amazon.com>, <nafea@amazon.com>,
        <gtzalik@amazon.com>, <netanel@amazon.com>, <alisaidi@amazon.com>,
        <benh@amazon.com>, <akiyano@amazon.com>
Subject: [RFC V2 net-next v2 0/3] Introduce XDP to ena
Date:   Thu, 31 Oct 2019 18:35:36 +0200
Message-ID: <20191031163539.12539-1-sameehj@amazon.com>
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

