Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DCB4A6AF844
	for <lists+netdev@lfdr.de>; Tue,  7 Mar 2023 23:09:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229994AbjCGWJr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Mar 2023 17:09:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58430 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230030AbjCGWJq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Mar 2023 17:09:46 -0500
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA57A8E3C2;
        Tue,  7 Mar 2023 14:09:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1678226982; x=1709762982;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=XUDBH90Ywy2lvsQPZLArMoZSilL67u+aRGzBmB/ErqA=;
  b=YDyOv9Q43Is7Cmf1GrBygLo7cU4HcNH6em5X42zvjhS5zDg9k2/MZ3xK
   NwesmXghvskKQ82MjcYT2s0fW3qZ+Dk7h7ICxIdp87nQlQfhw26MuF+wB
   yd4U5d6Ab86tOgykvw6R1Y1fne6V+FSBqHb0J6FCesQEIUmX6UVy34dIe
   9Vc2xR5F8bAE5nc3cgLXbG65pHpPKGKSNe+PKTEKooamFI4dOO7CH0oOa
   4relXx6EXN0nN/cjUXmogdW/18ctho4BkyiuOYBTcdzyr9jPnbz5Y8Oxp
   ei+7CNa87mqupfq1Cc+3EuphowJ/YDF5kfm8JQIgAOk0dHxXNQhbpgJ+d
   g==;
X-IronPort-AV: E=Sophos;i="5.98,242,1673938800"; 
   d="scan'208";a="215245446"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa1.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 07 Mar 2023 15:09:41 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Tue, 7 Mar 2023 15:09:41 -0700
Received: from soft-dev3-1.microsemi.net (10.10.115.15) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server id
 15.1.2507.16 via Frontend Transport; Tue, 7 Mar 2023 15:09:39 -0700
From:   Horatiu Vultur <horatiu.vultur@microchip.com>
To:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>
CC:     <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <lars.povlsen@microchip.com>,
        <Steen.Hegelund@microchip.com>, <daniel.machon@microchip.com>,
        <UNGLinuxDriver@microchip.com>,
        Horatiu Vultur <horatiu.vultur@microchip.com>
Subject: [PATCH net-next 0/5] net: lan966x: Add support for IS1 VCAP
Date:   Tue, 7 Mar 2023 23:09:24 +0100
Message-ID: <20230307220929.834219-1-horatiu.vultur@microchip.com>
X-Mailer: git-send-email 2.38.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Provide the Ingress Stage 1 (IS1) VCAP (Versatile Content-Aware
Processor) support for the Lan966x platform.

The IS1 VCAP has 3 lookups and they are accessible with a TC chain id:
- chain 1000000: IS1 Lookup 0
- chain 1100000: IS1 Lookup 1
- chain 1200000: IS1 Lookup 2

The IS1 is capable of different actions like rewrite VLAN tags, change
priority of the frames, police the traffic, etc. These features will be
added at a later point.

The IS1 currently implements the action that allows setting the value
of a PAG (Policy Association Group) key field in the frame metadata and
this can be used for matching in an IS2 VCAP rule. In this way a rule in
IS0 VCAP can be linked to rules in the IS2 VCAP. The linking is exposed
by using the TC "goto chain" action with an offset from the IS2 chain ids.
For example "goto chain 8000001" will use a PAG value of 1 to chain to a
rule in IS2 lookup 0.

Horatiu Vultur (5):
  net: lan966x: Add IS1 VCAP model
  net: lan966x: Add IS1 VCAP keyset configuration for lan966x
  net: lan966x: Add TC support for IS1 VCAP
  net: lan966x: Add TC filter chaining support for IS1 and IS2 VCAPs
  net: lan966x: Add support for IS1 VCAP ethernet protocol types

 .../ethernet/microchip/lan966x/lan966x_main.h |   38 +
 .../ethernet/microchip/lan966x/lan966x_regs.h |   36 +
 .../microchip/lan966x/lan966x_tc_flower.c     |  221 ++-
 .../microchip/lan966x/lan966x_vcap_ag_api.c   | 1402 ++++++++++++++++-
 .../microchip/lan966x/lan966x_vcap_debugfs.c  |  133 +-
 .../microchip/lan966x/lan966x_vcap_impl.c     |  192 ++-
 .../net/ethernet/microchip/vcap/vcap_ag_api.h |  217 ++-
 .../microchip/vcap/vcap_api_debugfs_kunit.c   |    4 +-
 8 files changed, 2156 insertions(+), 87 deletions(-)

-- 
2.38.0

