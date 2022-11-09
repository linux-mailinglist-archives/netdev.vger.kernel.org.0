Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E26616234BD
	for <lists+netdev@lfdr.de>; Wed,  9 Nov 2022 21:41:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231445AbiKIUlo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Nov 2022 15:41:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42094 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229561AbiKIUln (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Nov 2022 15:41:43 -0500
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C23B217050;
        Wed,  9 Nov 2022 12:41:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1668026500; x=1699562500;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=+O/GefFOW6jxFk/nJ/+JlQXGvg7uqtqqmPjyGOaK5B0=;
  b=XN4IiU0Unq0aMJymV9WnlRzbXaohPuFMBv9HTaM0jC0e5RAZrXoHsWFX
   zPE8rJ/0vcyrVRLl3UadDmWsfHmQQ3fYq0gjGvLDaMUIx4SehOJfUihRb
   YRgu9M/VCzs2YdFqC1Tl9GtQL+IVQGLdGpvdVK66BKo9WtjCAx8/2Hg+a
   D80rc6wVIgYHR6IiWbzT71AnEQhJpoccc1zvzs7e5RMfd9GGf2lrdQSMV
   LBA+TD64pz7pYW+uiv3IbTtfA41B6K6DMZM85c2eQRhI/1S8QssnKTrre
   b32FgqGuc0W/7yqiMwPTdGDFItMFQooahrcqw988jsf2UH/CXa0FMGs64
   g==;
X-IronPort-AV: E=Sophos;i="5.96,151,1665471600"; 
   d="scan'208";a="122642737"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa6.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 09 Nov 2022 13:41:39 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.12; Wed, 9 Nov 2022 13:41:39 -0700
Received: from soft-dev3-1.microsemi.net (10.10.115.15) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server id
 15.1.2507.12 via Frontend Transport; Wed, 9 Nov 2022 13:41:36 -0700
From:   Horatiu Vultur <horatiu.vultur@microchip.com>
To:     <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        <bpf@vger.kernel.org>
CC:     <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <ast@kernel.org>, <daniel@iogearbox.net>,
        <hawk@kernel.org>, <john.fastabend@gmail.co>,
        <linux@armlinux.org.uk>, <alexandr.lobakin@intel.com>,
        <UNGLinuxDriver@microchip.com>,
        Horatiu Vultur <horatiu.vultur@microchip.com>
Subject: [PATCH net-next v3 0/4] net: lan966x: Add xdp support
Date:   Wed, 9 Nov 2022 21:46:09 +0100
Message-ID: <20221109204613.3669905-1-horatiu.vultur@microchip.com>
X-Mailer: git-send-email 2.38.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add support for xdp in lan966x driver. Currently only XDP_PASS and
XDP_DROP are supported.

The first 2 patches are just moving things around just to simplify
the code for when the xdp is added.
Patch 3 actually adds the xdp. Currently the only supported actions
are XDP_PASS and XDP_DROP. In the future this will be extended with
XDP_TX and XDP_REDIRECT.
Patch 4 changes to use page pool API, because the handling of the
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

---
v2->v3:
- inline lan966x_xdp_port_present
- update max_len of page_pool_params not to be the page size anymore but
  actually be rx->max_mtu.

v1->v2:
- rebase on net-next, once the fixes for FDMA and MTU were accepted
- drop patch 2, which changes the MTU as is not needed anymore
- allow to run xdp programs on frames bigger than 4KB

Horatiu Vultur (4):
  net: lan966x: Add define IFH_LEN_BYTES
  net: lan966x: Split function lan966x_fdma_rx_get_frame
  net: lan966x: Add basic XDP support
  net: lan96x: Use page_pool API

 .../net/ethernet/microchip/lan966x/Kconfig    |   1 +
 .../net/ethernet/microchip/lan966x/Makefile   |   3 +-
 .../ethernet/microchip/lan966x/lan966x_fdma.c | 181 +++++++++++-------
 .../ethernet/microchip/lan966x/lan966x_ifh.h  |   1 +
 .../ethernet/microchip/lan966x/lan966x_main.c |   7 +-
 .../ethernet/microchip/lan966x/lan966x_main.h |  33 ++++
 .../ethernet/microchip/lan966x/lan966x_xdp.c  |  76 ++++++++
 7 files changed, 236 insertions(+), 66 deletions(-)
 create mode 100644 drivers/net/ethernet/microchip/lan966x/lan966x_xdp.c

-- 
2.38.0

