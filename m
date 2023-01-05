Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CE92965E67C
	for <lists+netdev@lfdr.de>; Thu,  5 Jan 2023 09:13:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231530AbjAEINv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Jan 2023 03:13:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53988 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231391AbjAEINs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Jan 2023 03:13:48 -0500
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B780258318;
        Thu,  5 Jan 2023 00:13:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1672906424; x=1704442424;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=9OBG3ndMcB4Yh+Zf7d0uJm/I1/nGZ85J8AhipMgp+MM=;
  b=rIJMrn8Ld6zZCARL31guixmJ1aUK+ha7IqsUZIInTyXigFOsDJNff2J/
   shyPsY0WT+c7XbrQdty834lweaDN4VW0Maw0+jKQMMcv51gMV1YrKMjlJ
   BLBDyR9WvBUrhwnFfK/ygKT90yfmVeG1C3SnV5NKFaiZlOoR3mNHsz9PS
   NjG5OyQnJpu/ASuQK/sXAXagLAosNP78iCWvqViEcWp0MDExSbNyI+x2m
   n1utjFLMcJTzPeyBEtlz6eRpAHZ5WsXt7amvqY0UTm6UUXroZC50ksRGK
   Wy2NuWvGXVlAUCgU7IE3FtFFdFuQ3/kogpV9lO17GetJo9BMt9SLEIuAX
   A==;
X-IronPort-AV: E=Sophos;i="5.96,302,1665471600"; 
   d="scan'208";a="194363228"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa2.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 05 Jan 2023 01:13:43 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Thu, 5 Jan 2023 01:13:42 -0700
Received: from den-dk-m31857.microchip.com (10.10.115.15) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server id
 15.1.2507.16 via Frontend Transport; Thu, 5 Jan 2023 01:13:38 -0700
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
        Dan Carpenter <error27@gmail.com>
Subject: [PATCH net-next 0/8] Add support for two classes of VCAP rules
Date:   Thu, 5 Jan 2023 09:13:27 +0100
Message-ID: <20230105081335.1261636-1-steen.hegelund@microchip.com>
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
 .../microchip/lan966x/lan966x_vcap_impl.c     |  24 +-
 .../microchip/sparx5/sparx5_tc_flower.c       |  28 +-
 .../microchip/sparx5/sparx5_tc_matchall.c     |  16 +-
 .../microchip/sparx5/sparx5_vcap_debugfs.c    |   2 +-
 .../microchip/sparx5/sparx5_vcap_impl.c       |  29 +-
 .../net/ethernet/microchip/vcap/vcap_api.c    | 752 +++++++++++++-----
 .../net/ethernet/microchip/vcap/vcap_api.h    |   5 -
 .../ethernet/microchip/vcap/vcap_api_client.h |   8 +-
 .../microchip/vcap/vcap_api_debugfs.c         |  57 +-
 .../microchip/vcap/vcap_api_debugfs_kunit.c   |  10 +-
 .../ethernet/microchip/vcap/vcap_api_kunit.c  |  32 +-
 .../microchip/vcap/vcap_api_private.h         |  12 +-
 16 files changed, 685 insertions(+), 349 deletions(-)

-- 
2.39.0

