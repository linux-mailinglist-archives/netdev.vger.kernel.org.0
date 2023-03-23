Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CD5696C716E
	for <lists+netdev@lfdr.de>; Thu, 23 Mar 2023 21:00:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231243AbjCWUAI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Mar 2023 16:00:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38434 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229508AbjCWUAH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Mar 2023 16:00:07 -0400
Received: from smtp-fw-9103.amazon.com (smtp-fw-9103.amazon.com [207.171.188.200])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E6F0E2595D
        for <netdev@vger.kernel.org>; Thu, 23 Mar 2023 13:00:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1679601605; x=1711137605;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=UROUHeCUyQP/4P9EvZtcybJoz2zWq8/eXGMpYdg/keo=;
  b=rkaOZ8YVfw39D7kFhVYWHEjywVTHVGjOG00wRpr7myaq6fk5jESbzXNi
   7Ns4c6xXEneRDlyYMI7xzl2ej6nDYLeIpzn/mbcW+rb0i4wGd6qc19FOw
   6/GkO9Hh2LhxyKk7Ht5elaKUcsr5uMLfvsNo6scDdJGx0jYlg/gVEscfV
   g=;
X-IronPort-AV: E=Sophos;i="5.98,285,1673913600"; 
   d="scan'208";a="1115774274"
Received: from pdx4-co-svc-p1-lb2-vlan3.amazon.com (HELO email-inbound-relay-iad-1a-m6i4x-54a853e6.us-east-1.amazon.com) ([10.25.36.214])
  by smtp-border-fw-9103.sea19.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Mar 2023 19:59:56 +0000
Received: from EX19D009EUA004.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan3.iad.amazon.com [10.40.163.38])
        by email-inbound-relay-iad-1a-m6i4x-54a853e6.us-east-1.amazon.com (Postfix) with ESMTPS id C5568445A3;
        Thu, 23 Mar 2023 19:59:53 +0000 (UTC)
Received: from EX19D028EUB003.ant.amazon.com (10.252.61.31) by
 EX19D009EUA004.ant.amazon.com (10.252.50.97) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.26; Thu, 23 Mar 2023 19:59:52 +0000
Received: from u570694869fb251.ant.amazon.com (10.85.143.174) by
 EX19D028EUB003.ant.amazon.com (10.252.61.31) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.24; Thu, 23 Mar 2023 19:59:42 +0000
From:   Shay Agroskin <shayagr@amazon.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, <netdev@vger.kernel.org>
CC:     Shay Agroskin <shayagr@amazon.com>,
        "Woodhouse, David" <dwmw@amazon.com>,
        "Machulsky, Zorik" <zorik@amazon.com>,
        "Matushevsky, Alexander" <matua@amazon.com>,
        Saeed Bshara <saeedb@amazon.com>,
        "Wilson, Matt" <msw@amazon.com>,
        "Liguori, Anthony" <aliguori@amazon.com>,
        "Bshara, Nafea" <nafea@amazon.com>,
        "Belgazal, Netanel" <netanel@amazon.com>,
        "Saidi, Ali" <alisaidi@amazon.com>,
        "Herrenschmidt, Benjamin" <benh@amazon.com>,
        "Kiyanovski, Arthur" <akiyano@amazon.com>,
        "Dagan, Noam" <ndagan@amazon.com>,
        "Arinzon, David" <darinzon@amazon.com>,
        "Itzko, Shahar" <itzko@amazon.com>,
        "Abboud, Osama" <osamaabb@amazon.com>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Johannes Berg <johannes@sipsolutions.net>,
        Edward Cree <ecree.xilinx@gmail.com>,
        Florian Westphal <fw@strlen.de>
Subject: [PATCH v8 net-next 0/7] Add tx push buf len param to ethtool
Date:   Thu, 23 Mar 2023 21:59:16 +0200
Message-ID: <20230323195923.1731790-1-shayagr@amazon.com>
X-Mailer: git-send-email 2.30.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.85.143.174]
X-ClientProxiedBy: EX19D038UWC001.ant.amazon.com (10.13.139.213) To
 EX19D028EUB003.ant.amazon.com (10.252.61.31)
X-Spam-Status: No, score=-10.0 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_SPF_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Changes since v7:
- Changed netlink policy macro to a more elegant solution.

Changes since v6:
- Modify netlink policy macro to avoid evaluating the macro
  argument more than once.

Changes since v5:
- Added a print of the maximum tx-push-buf-len when user tries to
  configure a value which exceeds it.

Changes since v4:
- Added advertisement for tx-push-mode in ENA driver
- Modified the documentation to make the distinction from
  tx-copybreak clearer

Changes since v3:
- Removed RFC tag and added a Jakub's signoff on one of the first patch

Changes since v2:
- Added a check that the driver advertises support for TX push buffer
  instead of defaulting the response to 0.
- Moved cosmetic changes to their own commits
- Removed usage of gotos which goes against Linux coding style
- Make ENA driver reject an attempt to configure TX push buffer when
  it's not supported (no LLQ is used)

Changes since v1:
- Added the new ethtool param to generic netlink specs
- Dropped dynamic advertisement of tx push buff support in ENA.
  The driver will advertise it for all platforms

This patchset adds a new sub-configuration to ethtool get/set queue
params (ethtool -g) called 'tx-push-buf-len'.

This configuration specifies the maximum number of bytes of a
transmitted packet a driver can push directly to the underlying
device ('push' mode). The motivation for pushing some of the bytes to
the device has the advantages of

- Allowing a smart device to take fast actions based on the packet's
  header
- Reducing latency for small packets that can be copied completely into
  the device

This new param is practically similar to tx-copybreak value that can be
set using ethtool's tunable but conceptually serves a different purpose.
While tx-copybreak is used to reduce the overhead of DMA mapping and
makes no sense to use if less than the whole segment gets copied,
tx-push-buf-len allows to improve performance by analyzing the packet's
data (usually headers) before performing the DMA operation.

The configuration can be queried and set using the commands:

    $ ethtool -g [interface]

    # ethtool -G [interface] tx-push-buf-len [number of bytes]

This patchset also adds support for the new configuration in ENA driver
for which this parameter ensures efficient resources management on the
device side.

David Arinzon (1):
  net: ena: Add an option to configure large LLQ headers

Shay Agroskin (6):
  netlink: Add a macro to set policy message with format string
  ethtool: Add support for configuring tx_push_buf_len
  net: ena: Make few cosmetic preparations to support large LLQ
  net: ena: Recalculate TX state variables every device reset
  net: ena: Add support to changing tx_push_buf_len
  net: ena: Advertise TX push support

 Documentation/netlink/specs/ethtool.yaml      |   8 +
 Documentation/networking/ethtool-netlink.rst  |  47 ++--
 drivers/net/ethernet/amazon/ena/ena_eth_com.h |   4 +
 drivers/net/ethernet/amazon/ena/ena_ethtool.c |  66 ++++-
 drivers/net/ethernet/amazon/ena/ena_netdev.c  | 259 +++++++++++-------
 drivers/net/ethernet/amazon/ena/ena_netdev.h  |  15 +-
 include/linux/ethtool.h                       |  14 +-
 include/linux/netlink.h                       |  13 +
 include/uapi/linux/ethtool_netlink.h          |   2 +
 net/ethtool/netlink.h                         |   2 +-
 net/ethtool/rings.c                           |  34 ++-
 11 files changed, 340 insertions(+), 124 deletions(-)

-- 
2.25.1

