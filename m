Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 65564B1618
	for <lists+netdev@lfdr.de>; Fri, 13 Sep 2019 00:09:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726778AbfILWJL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Sep 2019 18:09:11 -0400
Received: from smtp-fw-4101.amazon.com ([72.21.198.25]:42695 "EHLO
        smtp-fw-4101.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725775AbfILWJK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Sep 2019 18:09:10 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1568326150; x=1599862150;
  h=from:to:cc:subject:date:message-id:mime-version;
  bh=/uJ2sHAdYxkjNsGNAUZQT5z58nBTfo7osl07VSAm+XI=;
  b=d+qgBAnTAhTSJZs9XQoS0ONnSNYrKfv75N5qAyS+2H/aDJgTeXuTMwji
   GGQ9K+NFoCjiMWYLgrWf26Fz4t2y8Q9uBZeBhi5xkTVHYV3uwVJH6FTTN
   8UruMnnnPR0YtqNtOEn7pZ75MH7LGXnTp/g72nrr0wLyo86ihGwXmtoH/
   k=;
X-IronPort-AV: E=Sophos;i="5.64,498,1559520000"; 
   d="scan'208";a="784692721"
Received: from iad6-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-1d-98acfc19.us-east-1.amazon.com) ([10.124.125.6])
  by smtp-border-fw-out-4101.iad4.amazon.com with ESMTP; 12 Sep 2019 22:09:08 +0000
Received: from EX13MTAUWA001.ant.amazon.com (iad55-ws-svc-p15-lb9-vlan3.iad.amazon.com [10.40.159.166])
        by email-inbound-relay-1d-98acfc19.us-east-1.amazon.com (Postfix) with ESMTPS id EDA53A1840;
        Thu, 12 Sep 2019 22:09:07 +0000 (UTC)
Received: from EX13D21UWA003.ant.amazon.com (10.43.160.184) by
 EX13MTAUWA001.ant.amazon.com (10.43.160.118) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Thu, 12 Sep 2019 22:09:07 +0000
Received: from EX13MTAUWA001.ant.amazon.com (10.43.160.58) by
 EX13D21UWA003.ant.amazon.com (10.43.160.184) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Thu, 12 Sep 2019 22:09:06 +0000
Received: from HFA15-G63729NC.amazon.com (10.95.77.90) by
 mail-relay.amazon.com (10.43.160.118) with Microsoft SMTP Server id
 15.0.1367.3 via Frontend Transport; Thu, 12 Sep 2019 22:08:58 +0000
From:   <akiyano@amazon.com>
To:     <davem@davemloft.net>, <netdev@vger.kernel.org>
CC:     Arthur Kiyanovski <akiyano@amazon.com>, <dwmw@amazon.com>,
        <zorik@amazon.com>, <matua@amazon.com>, <saeedb@amazon.com>,
        <msw@amazon.com>, <aliguori@amazon.com>, <nafea@amazon.com>,
        <gtzalik@amazon.com>, <netanel@amazon.com>, <alisaidi@amazon.com>,
        <benh@amazon.com>, <sameehj@amazon.com>, <ndagan@amazon.com>
Subject: [PATCH V1 net-next 00/11] net: ena: implement adaptive interrupt moderation using dim
Date:   Fri, 13 Sep 2019 01:08:37 +0300
Message-ID: <1568326128-4057-1-git-send-email-akiyano@amazon.com>
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
 drivers/net/ethernet/amazon/ena/ena_netdev.c  |  86 +++++----
 drivers/net/ethernet/amazon/ena/ena_netdev.h  |   8 +-
 6 files changed, 129 insertions(+), 388 deletions(-)

-- 
2.17.2

