Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C873562E6F3
	for <lists+netdev@lfdr.de>; Thu, 17 Nov 2022 22:31:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240814AbiKQVbZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Nov 2022 16:31:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48062 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240741AbiKQVbY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Nov 2022 16:31:24 -0500
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1CB885A6F0;
        Thu, 17 Nov 2022 13:31:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1668720683; x=1700256683;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=zn2ANb9KGFGPelKTi4LkAAqG+JeEdH9yPs/Mesdexvs=;
  b=JGWiwDwfMKrkWeK2OgI7hR6sXClM3LX+0uH5pVt0BFMgLfzReAOVW4al
   yE4VJ8e8z4zGe+d4WsLccdwMNcrJsth7FJ5asL4YYFybwvykKnDcE8ag0
   GK/4RZAGUHtgetYZnLoyqijbvVFomh+UK2nlKkXyVDjL8Fx5IG0EGfRLp
   MmbDTTP/dbFQCNpicBIvufy4b0uoOaN9ZacyRKyEHusm0VV98UUr1wwfA
   vmKjqFzWNSgtJgrqAS5o6bVvHwEKkvtgXgJnIc9qrrkeLzfo0vQcaJfbt
   24F852/O3uV5zYMnKOeadesS2rIRRKzaMZLtISzK4hC8EhnsDq5/h2d8N
   Q==;
X-IronPort-AV: E=Sophos;i="5.96,172,1665471600"; 
   d="scan'208";a="123980016"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa6.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 17 Nov 2022 14:31:22 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.87.72) by
 chn-vm-ex02.mchp-main.com (10.10.87.72) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.12; Thu, 17 Nov 2022 14:31:21 -0700
Received: from den-dk-m31857.microchip.com (10.10.115.15) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server id
 15.1.2507.12 via Frontend Transport; Thu, 17 Nov 2022 14:31:18 -0700
From:   Steen Hegelund <steen.hegelund@microchip.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
CC:     Steen Hegelund <steen.hegelund@microchip.com>,
        <UNGLinuxDriver@microchip.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        "Casper Andersson" <casper.casan@gmail.com>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        Wan Jiabing <wanjiabing@vivo.com>,
        "Nathan Huckleberry" <nhuck@google.com>,
        <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        "Steen Hegelund" <Steen.Hegelund@microchip.com>,
        Daniel Machon <daniel.machon@microchip.com>,
        Horatiu Vultur <horatiu.vultur@microchip.com>,
        Lars Povlsen <lars.povlsen@microchip.com>
Subject: [PATCH net-next v2 0/8] Add support for VCAP debugFS in Sparx5
Date:   Thu, 17 Nov 2022 22:31:06 +0100
Message-ID: <20221117213114.699375-1-steen.hegelund@microchip.com>
X-Mailer: git-send-email 2.38.1
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

This provides support for getting VCAP instance, VCAP rule and VCAP port
keyset configuration information via the debug file system.

It builds on top of the initial IS2 VCAP support found in these series:

https://lore.kernel.org/all/20221020130904.1215072-1-steen.hegelund@microchip.com/
https://lore.kernel.org/all/20221109114116.3612477-1-steen.hegelund@microchip.com/
https://lore.kernel.org/all/20221111130519.1459549-1-steen.hegelund@microchip.com/

Functionality:
==============

The VCAP API exposes a /sys/kernel/debug/sparx5/vcaps folder containing
the following entries:

- raw_<vcap>_<instance>
    This is a raw dump of the VCAP instance with a line for each available
    VCAP rule.  This information is limited to the VCAP rule address, the
    rule size and the rule keyset name as this requires very little
    information from the VCAP cache.

    This can be used to detect if a valid rule is stored at the correct
    address.

- <vcap>_<instance>
    This dumps the VCAP instance configuration: address ranges, chain id
    ranges, word size of keys and actions etc, and for each VCAP rule the
    details of keys (values and masks) and actions are shown.

    This is useful when discovering if the expected rule is present and in
    which order it will be matched.

- <interface>
    This shows the keyset configuration per lookup and traffic type and the
    set of sticky bits (common for all interfaces). This is cleared when
    shown, so it is possible to sample over a period of time.

    It also shows if this port/lookup is enabled for matching in the VCAP.

    This can be used to find out which keyset the traffic being sent to a
    port, will be matched against, and if such traffic has been seen by one
    of the ports.

Delivery:
=========

This is current plan for delivering the full VCAP feature set of Sparx5:

- TC protocol all support for IS2 VCAP
- Sparx5 IS0 VCAP support
- TC policer and drop action support (depends on the Sparx5 QoS support
  upstreamed separately)
- Sparx5 ES0 VCAP support
- TC flower template support
- TC matchall filter support for mirroring and policing ports
- TC flower filter mirror action support
- Sparx5 ES2 VCAP support

Version History:
================
v2      Removed a 'support' folder (used for integration testing) that had
        been added in patch 6/8 by a mistake.
        Wrapped long lines.

v1      Initial version

Steen Hegelund (8):
  net: microchip: sparx5: Ensure L3 protocol has a default value
  net: microchip: sparx5: Ensure VCAP last_used_addr is set back to
    default
  net: microchip: sparx5: Add VCAP debugFS support
  net: microchip: sparx5: Add raw VCAP debugFS support for the VCAP API
  net: microchip: sparx5: Add VCAP rule debugFS support for the VCAP API
  net: microchip: sparx5: Add VCAP debugFS key/action support for the
    VCAP API
  net: microchip: sparx5: Add VCAP locking to protect rules
  net: microchip: sparx5: Add VCAP debugfs KUNIT test

 .../net/ethernet/microchip/sparx5/Makefile    |   1 +
 .../ethernet/microchip/sparx5/sparx5_main.c   |   3 +
 .../ethernet/microchip/sparx5/sparx5_main.h   |   3 +
 .../microchip/sparx5/sparx5_tc_flower.c       |   6 +-
 .../microchip/sparx5/sparx5_vcap_debugfs.c    | 200 +++++
 .../microchip/sparx5/sparx5_vcap_debugfs.h    |  33 +
 .../microchip/sparx5/sparx5_vcap_impl.c       |  67 +-
 .../microchip/sparx5/sparx5_vcap_impl.h       |  48 ++
 drivers/net/ethernet/microchip/vcap/Kconfig   |   1 +
 drivers/net/ethernet/microchip/vcap/Makefile  |   1 +
 .../net/ethernet/microchip/vcap/vcap_api.c    | 106 ++-
 .../net/ethernet/microchip/vcap/vcap_api.h    |  14 +-
 .../microchip/vcap/vcap_api_debugfs.c         | 782 ++++++++++++++++++
 .../microchip/vcap/vcap_api_debugfs.h         |  41 +
 .../microchip/vcap/vcap_api_debugfs_kunit.c   | 545 ++++++++++++
 .../ethernet/microchip/vcap/vcap_api_kunit.c  |  12 +-
 .../microchip/vcap/vcap_api_private.h         | 103 +++
 17 files changed, 1838 insertions(+), 128 deletions(-)
 create mode 100644 drivers/net/ethernet/microchip/sparx5/sparx5_vcap_debugfs.c
 create mode 100644 drivers/net/ethernet/microchip/sparx5/sparx5_vcap_debugfs.h
 create mode 100644 drivers/net/ethernet/microchip/vcap/vcap_api_debugfs.c
 create mode 100644 drivers/net/ethernet/microchip/vcap/vcap_api_debugfs.h
 create mode 100644 drivers/net/ethernet/microchip/vcap/vcap_api_debugfs_kunit.c
 create mode 100644 drivers/net/ethernet/microchip/vcap/vcap_api_private.h

-- 
2.38.1

