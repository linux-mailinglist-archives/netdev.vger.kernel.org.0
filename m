Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BBFDC6A738E
	for <lists+netdev@lfdr.de>; Wed,  1 Mar 2023 19:37:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229572AbjCAShY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Mar 2023 13:37:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43804 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229928AbjCAShU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Mar 2023 13:37:20 -0500
Received: from smtp-fw-80007.amazon.com (smtp-fw-80007.amazon.com [99.78.197.218])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9452A4BE91
        for <netdev@vger.kernel.org>; Wed,  1 Mar 2023 10:37:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1677695833; x=1709231833;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=vTMV53mrzWdcBDI8OwbCiZ81GLwZ0C2YtQHryaZlLY4=;
  b=TC4RUx6qVjPm8Ov3cyZYmEq+IdN3fk31OyhavVhOs+3Msen6muYQJ0lV
   ERTOsxVt3FpUaQvlVuT/ye9a3BDkLVglHkbyFfpz0TujnPf4mKLLGueTu
   KEXblduPMDrsH3DIk4nDQLjyDwQ/bGOGWQxawNo0nf2GaTh2P5IL1cr+z
   A=;
X-IronPort-AV: E=Sophos;i="5.98,225,1673913600"; 
   d="scan'208";a="188363612"
Received: from pdx4-co-svc-p1-lb2-vlan3.amazon.com (HELO email-inbound-relay-pdx-2b-m6i4x-32fb4f1a.us-west-2.amazon.com) ([10.25.36.214])
  by smtp-border-fw-80007.pdx80.corp.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Mar 2023 17:59:47 +0000
Received: from EX19D019EUA003.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan2.pdx.amazon.com [10.236.137.194])
        by email-inbound-relay-pdx-2b-m6i4x-32fb4f1a.us-west-2.amazon.com (Postfix) with ESMTPS id 7E326C015E;
        Wed,  1 Mar 2023 17:59:46 +0000 (UTC)
Received: from EX19D028EUB003.ant.amazon.com (10.252.61.31) by
 EX19D019EUA003.ant.amazon.com (10.252.50.35) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.24; Wed, 1 Mar 2023 17:59:44 +0000
Received: from u570694869fb251.ant.amazon.com (10.85.143.174) by
 EX19D028EUB003.ant.amazon.com (10.252.61.31) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.24; Wed, 1 Mar 2023 17:59:36 +0000
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
        "Abboud, Osama" <osamaabb@amazon.com>
Subject: [PATCH RFC v1 net-next 0/5] Add tx push buf len param to ethtool
Date:   Wed, 1 Mar 2023 19:59:11 +0200
Message-ID: <20230301175916.1819491-1-shayagr@amazon.com>
X-Mailer: git-send-email 2.30.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.85.143.174]
X-ClientProxiedBy: EX19D033UWC001.ant.amazon.com (10.13.139.218) To
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

Shay Agroskin (4):
  ethtool: Add support for configuring tx_push_buf_len
  net: ena: Recalculate TX state variables every device reset
  net: ena: Add support to changing tx_push_buf_len
  net: ena: Advertise ETHTOOL_RING_USE_TX_PUSH_BUF_LEN support

 Documentation/networking/ethtool-netlink.rst  |  43 ++++--
 drivers/net/ethernet/amazon/ena/ena_eth_com.h |   4 +
 drivers/net/ethernet/amazon/ena/ena_ethtool.c |  64 +++++++-
 drivers/net/ethernet/amazon/ena/ena_netdev.c  | 145 ++++++++++++++----
 drivers/net/ethernet/amazon/ena/ena_netdev.h  |  17 +-
 include/linux/ethtool.h                       |  14 +-
 include/uapi/linux/ethtool_netlink.h          |   2 +
 net/ethtool/netlink.h                         |   2 +-
 net/ethtool/rings.c                           |  29 +++-
 9 files changed, 256 insertions(+), 64 deletions(-)

-- 
2.25.1

