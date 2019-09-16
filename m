Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9A5B6B3975
	for <lists+netdev@lfdr.de>; Mon, 16 Sep 2019 13:34:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731435AbfIPLeW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Sep 2019 07:34:22 -0400
Received: from smtp-fw-33001.amazon.com ([207.171.190.10]:37970 "EHLO
        smtp-fw-33001.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729535AbfIPLeW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Sep 2019 07:34:22 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1568633661; x=1600169661;
  h=from:to:cc:subject:date:message-id:mime-version;
  bh=NTZI9CjnY+JlPzFdV8Oh4+ku9RnslBRkvlbOXtSDRq0=;
  b=uNx0ubgMCrAORsBLCqM9UrN++E6+XNJYGsOv1jZ22y7220WxzQv3Y2Gh
   DvLg87836sugRp9QKlX4zfZc/MI4CObZqjqLXZFfhsjy0QfGrLWdc3dlV
   Q+9LqW6kpCY7rwctE62C84bDdLgRyGfjCiqZE5pA3mgm5uckmadKVFuVm
   c=;
X-IronPort-AV: E=Sophos;i="5.64,512,1559520000"; 
   d="scan'208";a="832628813"
Received: from sea3-co-svc-lb6-vlan2.sea.amazon.com (HELO email-inbound-relay-1d-9ec21598.us-east-1.amazon.com) ([10.47.22.34])
  by smtp-border-fw-out-33001.sea14.amazon.com with ESMTP; 16 Sep 2019 11:31:43 +0000
Received: from EX13MTAUEA001.ant.amazon.com (iad55-ws-svc-p15-lb9-vlan3.iad.amazon.com [10.40.159.166])
        by email-inbound-relay-1d-9ec21598.us-east-1.amazon.com (Postfix) with ESMTPS id 95042A1BCD;
        Mon, 16 Sep 2019 11:31:42 +0000 (UTC)
Received: from EX13D08UEE004.ant.amazon.com (10.43.62.182) by
 EX13MTAUEA001.ant.amazon.com (10.43.61.82) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Mon, 16 Sep 2019 11:31:41 +0000
Received: from EX13MTAUEE001.ant.amazon.com (10.43.62.200) by
 EX13D08UEE004.ant.amazon.com (10.43.62.182) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Mon, 16 Sep 2019 11:31:41 +0000
Received: from HFA15-G63729NC.hfa16.amazon.com (10.218.52.89) by
 mail-relay.amazon.com (10.43.62.226) with Microsoft SMTP Server id
 15.0.1367.3 via Frontend Transport; Mon, 16 Sep 2019 11:31:38 +0000
From:   <akiyano@amazon.com>
To:     <davem@davemloft.net>, <netdev@vger.kernel.org>
CC:     Arthur Kiyanovski <akiyano@amazon.com>, <dwmw@amazon.com>,
        <zorik@amazon.com>, <matua@amazon.com>, <saeedb@amazon.com>,
        <msw@amazon.com>, <aliguori@amazon.com>, <nafea@amazon.com>,
        <gtzalik@amazon.com>, <netanel@amazon.com>, <alisaidi@amazon.com>,
        <benh@amazon.com>, <sameehj@amazon.com>, <ndagan@amazon.com>
Subject: [PATCH V2 net-next 00/11] net: ena: implement adaptive interrupt moderation using dim
Date:   Mon, 16 Sep 2019 14:31:25 +0300
Message-ID: <1568633496-4143-1-git-send-email-akiyano@amazon.com>
X-Mailer: git-send-email 2.7.4
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Arthur Kiyanovski <akiyano@amazon.com>

In this patchset we replace our adaptive interrupt moderation
implementation with the dim library implementation.
The dim library showed great improvement in throughput, latency
and CPU usage in different scenarios on ARM CPUs.
This patchset also includes a few bug fixes to the parts of the
old implementation of adaptive interrupt moderation that were left.

Changes from V1 patchset: 
Removed stray empty lines from patches 01/11, 09/11.

Arthur Kiyanovski (11):
  net: ena: add intr_moder_rx_interval to struct ena_com_dev and use it
  net: ena: switch to dim algorithm for rx adaptive interrupt moderation
  net: ena: reimplement set/get_coalesce()
  net: ena: enable the interrupt_moderation in driver_supported_features
  net: ena: remove code duplication in
    ena_com_update_nonadaptive_moderation_interval _*()
  net: ena: remove old adaptive interrupt moderation code from
    ena_netdev
  net: ena: remove ena_restore_ethtool_params() and relevant fields
  net: ena: remove all old adaptive rx interrupt moderation code from
    ena_com
  net: ena: fix update of interrupt moderation register
  net: ena: fix retrieval of nonadaptive interrupt moderation intervals
  net: ena: fix incorrect update of intr_delay_resolution

 .../net/ethernet/amazon/ena/ena_admin_defs.h  |   8 +
 drivers/net/ethernet/amazon/ena/ena_com.c     | 175 ++++--------------
 drivers/net/ethernet/amazon/ena/ena_com.h     | 151 +--------------
 drivers/net/ethernet/amazon/ena/ena_ethtool.c |  89 +++------
 drivers/net/ethernet/amazon/ena/ena_netdev.c  |  85 +++++----
 drivers/net/ethernet/amazon/ena/ena_netdev.h  |   8 +-
 6 files changed, 128 insertions(+), 388 deletions(-)

-- 
2.17.2

