Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 61BDE66906A
	for <lists+netdev@lfdr.de>; Fri, 13 Jan 2023 09:16:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240902AbjAMIQO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Jan 2023 03:16:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58130 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240904AbjAMIPn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Jan 2023 03:15:43 -0500
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B4ECE41000;
        Fri, 13 Jan 2023 00:14:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1673597677; x=1705133677;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=Y7FOxYVwp7hywXJrSy2gC+GFo0iJ/WSBlTtbFipUyvY=;
  b=C8uaCtsc/X+fzsVrTOvd8pVHudkzLQ5er7hOm7zb0rbVm0oL/iBZx7HP
   g2sWtE7VAlYfLNIP1eW10i04TtZJLtBvDo4hoKMRICPculi0dTI80O/5c
   hY8VOo8lyAHgHAPyUVGTepiWXvfa0k0IBQ4IpSD+r9hwRZSWrXsa1CYnl
   pAF94ig9V8xDeChYaKAc/GHpCYfZInNDUww3exP7SHb8aSHWbajX5oE4I
   T8fQRDdbDYiunjcMyV0FdNJAKU70jhMF2urK4KqasHQ4JaWHMCsi4tzp4
   hyMHjIoPtX1gs5GOnxgI44GTAc3rSVUSg91Rt7tfAOoPmLpMgrmf79oyL
   w==;
X-IronPort-AV: E=Sophos;i="5.97,213,1669100400"; 
   d="scan'208";a="195616545"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa2.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 13 Jan 2023 01:14:36 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Fri, 13 Jan 2023 01:14:33 -0700
Received: from den-dk-m31857.microchip.com (10.10.115.15) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server id
 15.1.2507.16 via Frontend Transport; Fri, 13 Jan 2023 01:14:27 -0700
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
        Lars Povlsen <lars.povlsen@microchip.com>,
        Dan Carpenter <error27@gmail.com>,
        Michael Walle <michael@walle.cc>
Subject: [PATCH net-next v3 0/8] Add support for two classes of VCAP rules
Date:   Fri, 13 Jan 2023 09:14:16 +0100
Message-ID: <20230113081424.3505035-1-steen.hegelund@microchip.com>
X-Mailer: git-send-email 2.39.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This adds support for two classes of VCAP rules:

- Permanent rules (added e.g. for PTP support)
- TC user rules (added by the TC userspace tool)

For this to work the VCAP Loopups must be enabled from boot, so that the
"internal" clients like PTP can add rules that are always active.

When the TC tool add a flower filter the VCAP rule corresponding to this
filter will be disabled (kept in memory) until a TC matchall filter creates
a link from chain 0 to the chain (lookup) where the flower filter was
added.

When the flower filter is enabled it will be written to the appropriate
VCAP lookup and become active in HW.

Likewise the flower filter will be disabled if there is no link from chain
0 to the chain of the filter (lookup), and when that happens the
corresponding VCAP rule will be read from the VCAP instance and stored in
memory until it is deleted or enabled again.

Version History:
================
v3      Removed the change that allowed rules to always be added in the
        LAN996x even though the lookups are not enabled (Horatiu Vultur).

        Added a check for validity of the chain source when enabling a
        lookup.

v2      Adding a missing goto exit in vcap_add_rule (Dan Carpenter).
        Added missing checks for error returns in vcap_enable_rule.

v1      Initial version


Steen Hegelund (8):
  net: microchip: vcap api: Erase VCAP cache before encoding rule
  net: microchip: sparx5: Reset VCAP counter for new rules
  net: microchip: vcap api: Always enable VCAP lookups
  net: microchip: vcap api: Convert multi-word keys/actions when
    encoding
  net: microchip: vcap api: Use src and dst chain id to chain VCAP
    lookups
  net: microchip: vcap api: Check chains when adding a tc flower filter
  net: microchip: vcap api: Add a storage state to a VCAP rule
  net: microchip: vcap api: Enable/Disable rules via chains in VCAP HW

 .../ethernet/microchip/lan966x/lan966x_goto.c |  10 +-
 .../ethernet/microchip/lan966x/lan966x_main.h |   3 +-
 .../microchip/lan966x/lan966x_tc_flower.c     |  30 +-
 .../microchip/lan966x/lan966x_tc_matchall.c   |  16 +-
 .../microchip/lan966x/lan966x_vcap_impl.c     |  21 +-
 .../microchip/sparx5/sparx5_tc_flower.c       |  28 +-
 .../microchip/sparx5/sparx5_tc_matchall.c     |  16 +-
 .../microchip/sparx5/sparx5_vcap_debugfs.c    |   2 +-
 .../microchip/sparx5/sparx5_vcap_impl.c       |  29 +-
 .../net/ethernet/microchip/vcap/vcap_api.c    | 767 +++++++++++++-----
 .../net/ethernet/microchip/vcap/vcap_api.h    |   5 -
 .../ethernet/microchip/vcap/vcap_api_client.h |   8 +-
 .../microchip/vcap/vcap_api_debugfs.c         |  57 +-
 .../microchip/vcap/vcap_api_debugfs_kunit.c   |  10 +-
 .../ethernet/microchip/vcap/vcap_api_kunit.c  |  32 +-
 .../microchip/vcap/vcap_api_private.h         |  12 +-
 16 files changed, 699 insertions(+), 347 deletions(-)

-- 
2.39.0

