Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3FFFA636370
	for <lists+netdev@lfdr.de>; Wed, 23 Nov 2022 16:26:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238692AbiKWP0T (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Nov 2022 10:26:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36068 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238244AbiKWPZ6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Nov 2022 10:25:58 -0500
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E51F598244;
        Wed, 23 Nov 2022 07:25:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1669217152; x=1700753152;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=bKG2HOj9nnlSS7G6luWwtI1OPs62ZJxGmE/IN3HYTWI=;
  b=KHyvW/WbNqdrqrPOi98yfBqtSIyDCbSqzQyEes3Ir9MPyGcEDH58UWEE
   xdKrvlY3zLhNI3sjibrSXHyMiPGPbZE8n45meQGGno/uwQAS2tAzgcb1L
   iRMEglXd2fXIrDrqVUIwOFTGxSmFBO/4BcYf7+J0FfqCabp3mJ1oOW+B2
   e85xLnMIB4ZOH/8a997F2HSvYmB4LkYAjYN0ba0Rc0tqMFPfXfHnh/olD
   Edh8pjVhj0o/CrEJRNLFpO68Mf979MhIL6cSXbU40H1P+Oh24jylgKuXO
   FuGM4QG8ejLm6WTSYdGYR6b0PNdeQx0yIIU3xxk2Fm/pCMtnimKwVux2r
   Q==;
X-IronPort-AV: E=Sophos;i="5.96,187,1665471600"; 
   d="scan'208";a="201127180"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa1.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 23 Nov 2022 08:25:51 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.85.144) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.12; Wed, 23 Nov 2022 08:25:51 -0700
Received: from den-dk-m31857.microchip.com (10.10.115.15) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server id
 15.1.2507.12 via Frontend Transport; Wed, 23 Nov 2022 08:25:48 -0700
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
Subject: [PATCH net-next v2 0/4] TC protocol all support in Sparx5 IS2 VCAP
Date:   Wed, 23 Nov 2022 16:25:41 +0100
Message-ID: <20221123152545.1997266-1-steen.hegelund@microchip.com>
X-Mailer: git-send-email 2.38.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,T_SPF_TEMPERROR autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This provides support for the TC flower filters 'protocol all' clause in
the Sparx5 IS2 VCAP.

It builds on top of the initial IS2 VCAP support found in these series:

https://lore.kernel.org/all/20221020130904.1215072-1-steen.hegelund@microchip.com/
https://lore.kernel.org/all/20221109114116.3612477-1-steen.hegelund@microchip.com/
https://lore.kernel.org/all/20221111130519.1459549-1-steen.hegelund@microchip.com/
https://lore.kernel.org/all/20221117213114.699375-1-steen.hegelund@microchip.com/

Functionality:
==============

As the configuration for the Sparx5 IS2 VCAP consists of one (or more)
keyset(s) for each lookup/port per traffic classification, it is not
always possible to cover all protocols with just one ordinary VCAP rule.

To improve this situation the driver will try to find out what keysets a
rule will need to cover a TC flower "protocol all" filter and then compare
this set of keysets to what the hardware is currently configured for.

In case multiple keysets are needed then the driver can create a rule per
rule size (e.g. X6 and X12) and use a mask on the keyset type field to
allow the VCAP to match more than one keyset with just one rule.

This is possible because the keysets that have the same size typically has
many keys in common, so the VCAP rule keys can make a common match.

The result is that one TC filter command may create multiple IS2 VCAP rules
of different sizes that have a type field with a masked type id.

Delivery:
=========

This is current plan for delivering the full VCAP feature set of Sparx5:

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
v2      Fixed a NULL return value compiler warning.
        Moved the new vcap_find_actionfield function a bit up in the file.

v1      Initial version


Steen Hegelund (4):
  net: microchip: sparx5: Support for copying and modifying rules in the
    API
  net: microchip: sparx5: Support for TC protocol all
  net: microchip: sparx5: Support for displaying a list of keysets
  net: microchip: sparx5: Add VCAP filter keys KUNIT test

 .../microchip/sparx5/sparx5_tc_flower.c       | 209 +++++++++++++++++-
 .../microchip/sparx5/sparx5_vcap_impl.c       |  18 +-
 .../microchip/sparx5/sparx5_vcap_impl.h       |  13 ++
 .../net/ethernet/microchip/vcap/vcap_api.c    | 185 +++++++++++++++-
 .../ethernet/microchip/vcap/vcap_api_client.h |  22 +-
 .../microchip/vcap/vcap_api_debugfs.c         |  98 ++++----
 .../microchip/vcap/vcap_api_debugfs_kunit.c   |  20 +-
 .../ethernet/microchip/vcap/vcap_api_kunit.c  | 200 ++++++++++++++++-
 .../microchip/vcap/vcap_api_private.h         |   4 -
 9 files changed, 708 insertions(+), 61 deletions(-)

-- 
2.38.1

