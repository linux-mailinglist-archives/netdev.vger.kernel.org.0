Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DE6F83CA92
	for <lists+netdev@lfdr.de>; Tue, 11 Jun 2019 13:58:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404248AbfFKL6W (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Jun 2019 07:58:22 -0400
Received: from smtp-fw-33001.amazon.com ([207.171.190.10]:39961 "EHLO
        smtp-fw-33001.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2403877AbfFKL6W (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Jun 2019 07:58:22 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1560254301; x=1591790301;
  h=from:to:cc:subject:date:message-id:mime-version;
  bh=GmjJlUFqUbEULJG8ZnfLQMXCtx6HEb+MpiqrR2WVT0Q=;
  b=VS96hhSqJEL5/cCm62g3PCHwlvt7dXCPDzyFmh4d04DEJ9vps9Tnp6N0
   a/BOE79bjT9pLrl3JctP5cN/5KU5AfvjPyZDy2lRaHcfUG4K8MQCP9h0G
   l0Tylqv/3igJuHJhGO1D5CsPcd2yHkEC9LqLPoTRyXo63yg9PQ0DGIhbz
   k=;
X-IronPort-AV: E=Sophos;i="5.60,579,1549929600"; 
   d="scan'208";a="804742785"
Received: from sea3-co-svc-lb6-vlan2.sea.amazon.com (HELO email-inbound-relay-1d-474bcd9f.us-east-1.amazon.com) ([10.47.22.34])
  by smtp-border-fw-out-33001.sea14.amazon.com with ESMTP; 11 Jun 2019 11:58:19 +0000
Received: from EX13MTAUWC001.ant.amazon.com (iad55-ws-svc-p15-lb9-vlan2.iad.amazon.com [10.40.159.162])
        by email-inbound-relay-1d-474bcd9f.us-east-1.amazon.com (Postfix) with ESMTPS id 10CAFA2184;
        Tue, 11 Jun 2019 11:58:18 +0000 (UTC)
Received: from EX13d09UWC004.ant.amazon.com (10.43.162.114) by
 EX13MTAUWC001.ant.amazon.com (10.43.162.135) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Tue, 11 Jun 2019 11:58:18 +0000
Received: from EX13MTAUWC001.ant.amazon.com (10.43.162.135) by
 EX13d09UWC004.ant.amazon.com (10.43.162.114) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Tue, 11 Jun 2019 11:58:17 +0000
Received: from HFA16-8226Y22.hfa16.amazon.com (10.218.52.81) by
 mail-relay.amazon.com (10.43.162.232) with Microsoft SMTP Server id
 15.0.1367.3 via Frontend Transport; Tue, 11 Jun 2019 11:58:14 +0000
From:   <sameehj@amazon.com>
To:     <davem@davemloft.net>, <netdev@vger.kernel.org>
CC:     Sameeh Jubran <sameehj@amazon.com>, <dwmw@amazon.com>,
        <zorik@amazon.com>, <matua@amazon.com>, <saeedb@amazon.com>,
        <msw@amazon.com>, <aliguori@amazon.com>, <nafea@amazon.com>,
        <gtzalik@amazon.com>, <netanel@amazon.com>, <alisaidi@amazon.com>,
        <benh@amazon.com>, <akiyano@amazon.com>
Subject: [PATCH V3 net 0/7] Support for dynamic queue size changes
Date:   Tue, 11 Jun 2019 14:58:04 +0300
Message-ID: <20190611115811.2819-1-sameehj@amazon.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Sameeh Jubran <sameehj@amazon.com>

This patchset introduces the following:
* add new admin command for supporting different queue size for Tx/Rx
* add support for Tx/Rx queues size modification through ethtool
* allow queues allocation backoff when low on memory
* update driver version

Difference from v2:
* Dropped superfluous range checks which are already done in ethtool. [patch 5/7]
* Dropped inline keyword from function. [patch 4/7]
* Added a new patch which drops inline keyword all *.c files. [patch 6/7]

Difference from v1:
* Changed ena_update_queue_sizes() signature to use u32 instead of int
  type for the size arguments. [patch 5/7]

Arthur Kiyanovski (1):
  net: ena: add MAX_QUEUES_EXT get feature admin command

Sameeh Jubran (6):
  net: ena: enable negotiating larger Rx ring size
  net: ena: make ethtool show correct current and max queue sizes
  net: ena: allow queue allocation backoff when low on memory
  net: ena: add ethtool function for changing io queue sizes
  net: ena: remove inline keyword from functions in *.c
  net: ena: update driver version from 2.0.3 to 2.1.0

 .../net/ethernet/amazon/ena/ena_admin_defs.h  |  56 ++-
 drivers/net/ethernet/amazon/ena/ena_com.c     |  82 +++--
 drivers/net/ethernet/amazon/ena/ena_com.h     |   3 +
 drivers/net/ethernet/amazon/ena/ena_eth_com.c |  26 +-
 drivers/net/ethernet/amazon/ena/ena_ethtool.c |  32 +-
 drivers/net/ethernet/amazon/ena/ena_netdev.c  | 319 +++++++++++++-----
 drivers/net/ethernet/amazon/ena/ena_netdev.h  |  28 +-
 7 files changed, 403 insertions(+), 143 deletions(-)

-- 
2.17.1

