Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A34866048BD
	for <lists+netdev@lfdr.de>; Wed, 19 Oct 2022 16:07:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233057AbiJSOHX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Oct 2022 10:07:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58488 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231728AbiJSOHG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Oct 2022 10:07:06 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 06C1AEB77F;
        Wed, 19 Oct 2022 06:49:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1666187355; x=1697723355;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=iFbJC0d3BwxOCXZ4J40099u99jnVBiYqWnM7oSlh7rQ=;
  b=TN2PKZEQCteazZBfd50pj4Kd8bSQQ1z959jDegWP2a9DBXJBFxMcRiLD
   Xt0ypdNwZS5xoMciPuRtK1Q2MG/yyecCI5pBD6dXRoqyRtsCpOt14W1Qa
   Nr+RKMQZKGvlTcGZEcw7f+SHbVVxYjY67geyr8dofWz6xkMI05jzW1aIS
   9Nh5wajyEIPfMYJe8wd3jO2eJFMaMmB2kgfZdrYqaFQN7u7FB5BfC/f/U
   MpnJqgvag8KsBitbenzRcozCWkL0dw6OEJ7mdtYsnDnx7stum1lGOmma5
   CuHOmnowq69Mbu4Sme4YCmInS+cI0R7j0JU8APZ71dbyacCBJJfhXjn/r
   Q==;
X-IronPort-AV: E=Sophos;i="5.95,196,1661842800"; 
   d="scan'208";a="196129545"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa1.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 19 Oct 2022 06:46:36 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.12; Wed, 19 Oct 2022 06:46:35 -0700
Received: from soft-dev3-1.microsemi.net (10.10.115.15) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server id
 15.1.2507.12 via Frontend Transport; Wed, 19 Oct 2022 06:46:33 -0700
From:   Horatiu Vultur <horatiu.vultur@microchip.com>
To:     <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        <bpf@vger.kernel.org>
CC:     <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <ast@kernel.org>, <daniel@iogearbox.net>,
        <hawk@kernel.org>, <john.fastabend@gmail.com>,
        <linux@armlinux.org.uk>, <UNGLinuxDriver@microchip.com>,
        Horatiu Vultur <horatiu.vultur@microchip.com>
Subject: [PATCH net-next 0/5] net: lan966x: Add xdp support
Date:   Wed, 19 Oct 2022 15:50:03 +0200
Message-ID: <20221019135008.3281743-1-horatiu.vultur@microchip.com>
X-Mailer: git-send-email 2.38.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Spam-Status: No, score=-4.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add support for xdp in lan966x driver. Currently on XDP_PASS and
XDP_DROP are supported.

The first 3 patches are just moving things around just to simplify
the code for when the xdp is added.
Patch 4 actually adds the xdp. Currently the only supported actions
are XDP_PASS and XDP_DROP. In the future this will be extended with
XDP_TX and XDP_REDIRECT.
Patch 5 changes to use page pool API, because the handling of the
pages is similar with what already lan966x driver is doing. In this
way is possible to remove some of the code.

All these changes give a small improvement on the RX side:
Before:
iperf3 -c 10.96.10.1 -R
[  5]   0.00-10.01  sec   514 MBytes   430 Mbits/sec    0         sender
[  5]   0.00-10.00  sec   509 MBytes   427 Mbits/sec              receiver

After:
iperf3 -c 10.96.10.1 -R
[  5]   0.00-10.02  sec   540 MBytes   452 Mbits/sec    0         sender
[  5]   0.00-10.01  sec   537 MBytes   450 Mbits/sec              receiver


Horatiu Vultur (5):
  net: lan966x: Add define IFH_LEN_BYTES
  net: lan966x: Rename lan966x_fdma_get_max_mtu
  net: lan966x: Split function lan966x_fdma_rx_get_frame
  net: lan966x: Add basic XDP support
  net: lan96x: Use page_pool API

 .../net/ethernet/microchip/lan966x/Kconfig    |   1 +
 .../net/ethernet/microchip/lan966x/Makefile   |   3 +-
 .../ethernet/microchip/lan966x/lan966x_fdma.c | 194 +++++++++++-------
 .../ethernet/microchip/lan966x/lan966x_ifh.h  |   1 +
 .../ethernet/microchip/lan966x/lan966x_main.c |  26 ++-
 .../ethernet/microchip/lan966x/lan966x_main.h |  28 +++
 .../ethernet/microchip/lan966x/lan966x_xdp.c  | 100 +++++++++
 7 files changed, 275 insertions(+), 78 deletions(-)
 create mode 100644 drivers/net/ethernet/microchip/lan966x/lan966x_xdp.c

-- 
2.38.0

