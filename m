Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 798296C1337
	for <lists+netdev@lfdr.de>; Mon, 20 Mar 2023 14:26:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229993AbjCTN0e (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Mar 2023 09:26:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54478 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231767AbjCTN01 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Mar 2023 09:26:27 -0400
Received: from smtp-fw-80006.amazon.com (smtp-fw-80006.amazon.com [99.78.197.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D3F762471D
        for <netdev@vger.kernel.org>; Mon, 20 Mar 2023 06:26:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1679318780; x=1710854780;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=haFHrFgPLkCaawdb7TrA1APDyEB25wYETfGqOnVQX/0=;
  b=KMtAbbIqONeGESvME4foyWwHCJIe37QTQOVDBWejgrk0/f75LqRcmB2b
   rU9bbYVyieo0STrivsID5EfXgGdxgjYBVAdwjywkZxQskwAPIJKtvuM1t
   I/LOjnLQK6T0wNSDm8TbWbJExm1ftnhho7/cof7570YJ6HT69HX/Q+gmO
   E=;
X-IronPort-AV: E=Sophos;i="5.98,274,1673913600"; 
   d="scan'208";a="195166746"
Received: from pdx4-co-svc-p1-lb2-vlan2.amazon.com (HELO email-inbound-relay-iad-1e-m6i4x-6e7a78d7.us-east-1.amazon.com) ([10.25.36.210])
  by smtp-border-fw-80006.pdx80.corp.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Mar 2023 13:26:03 +0000
Received: from EX19D001EUA001.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan2.iad.amazon.com [10.40.163.34])
        by email-inbound-relay-iad-1e-m6i4x-6e7a78d7.us-east-1.amazon.com (Postfix) with ESMTPS id B27C082A67;
        Mon, 20 Mar 2023 13:25:59 +0000 (UTC)
Received: from EX19D028EUB003.ant.amazon.com (10.252.61.31) by
 EX19D001EUA001.ant.amazon.com (10.252.50.59) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.24; Mon, 20 Mar 2023 13:25:58 +0000
Received: from u570694869fb251.ant.amazon.com (10.85.143.172) by
 EX19D028EUB003.ant.amazon.com (10.252.61.31) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.24; Mon, 20 Mar 2023 13:25:47 +0000
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
        Guangbin Huang <huangguangbin2@huawei.com>,
        "Jie Wang" <wangjie125@huawei.com>,
        Johannes Berg <johannes@sipsolutions.net>,
        Edward Cree <ecree.xilinx@gmail.com>,
        Florian Westphal <fw@strlen.de>
Subject: [PATCH v6 net-next 0/7] Add tx push buf len param to ethtool
Date:   Mon, 20 Mar 2023 15:25:16 +0200
Message-ID: <20230320132523.3203254-1-shayagr@amazon.com>
X-Mailer: git-send-email 2.30.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.85.143.172]
X-ClientProxiedBy: EX19D038UWC003.ant.amazon.com (10.13.139.209) To
 EX19D028EUB003.ant.amazon.com (10.252.61.31)
X-Spam-Status: No, score=-11.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Changed since v5:
- Added a print of the maximum tx-push-buf-len when user tries to
  configure a value which exceeds it.

Changed since v4:
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

