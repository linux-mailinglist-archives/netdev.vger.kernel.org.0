Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 601FD55DCCC
	for <lists+netdev@lfdr.de>; Tue, 28 Jun 2022 15:26:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240595AbiF0UJw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Jun 2022 16:09:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54444 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238117AbiF0UJw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Jun 2022 16:09:52 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8796E1EEEF;
        Mon, 27 Jun 2022 13:09:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1656360591; x=1687896591;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=9Y+WRv+3bNc+qxaeVc48eNX/Xc1VlLk0PtZO4CV4sAs=;
  b=t7PaHcTd0EiaAQ8cJ7bksYRzJ1nMefwMs5pCvIlKgl1VRHLfioJqxZm2
   a9ew6GzR34QW9etABvFpXE9BFW+4lByi0UJa6kZXMz0Tfj8CjiQRxyA12
   GQ8e9EqGHd+K/3R94DNk8HauGAz6HtR/Ie7JTMDN7vONiLgeEVzq8CL6B
   mIv9NqZF7L3+SBbWUFgU8Tr7rwunVTU6WGra+nGvGN6oJH8/6IsuXimRA
   zLcLIR2qbacAuBDNmqW8vclCbQAEIOuFIy0h9+y/xjZPAtkiUiOG/dsjC
   GOkc+qNqnw0xHpAFmtv2F0eY50FC4f42LeMx2fTZKtfmCBY4uH1oRL+nT
   Q==;
X-IronPort-AV: E=Sophos;i="5.92,227,1650956400"; 
   d="scan'208";a="162277514"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa4.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 27 Jun 2022 13:09:50 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.85.144) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Mon, 27 Jun 2022 13:09:47 -0700
Received: from soft-dev3-1.microsemi.net (10.10.115.15) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server id
 15.1.2375.17 via Frontend Transport; Mon, 27 Jun 2022 13:09:44 -0700
From:   Horatiu Vultur <horatiu.vultur@microchip.com>
To:     <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>
CC:     <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <vladimir.oltean@nxp.com>,
        Horatiu Vultur <horatiu.vultur@microchip.com>
Subject: [PATCH net-next v2 0/7] net: lan966x: Add lag support
Date:   Mon, 27 Jun 2022 22:13:23 +0200
Message-ID: <20220627201330.45219-1-horatiu.vultur@microchip.com>
X-Mailer: git-send-email 2.33.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Spam-Status: No, score=-4.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add lag support for lan966x.
First 4 patches don't do any changes to the current behaviour, they
just prepare for lag support. While the rest is to add the lag support.

v1->v2:
- fix the LAG PGIDs when ports go down, in this way is not
  needed anymore the last patch of the series.

Horatiu Vultur (7):
  net: lan966x: Add reqisters used to configure lag interfaces
  net: lan966x: Split lan966x_fdb_event_work
  net: lan966x: Expose lan966x_switchdev_nb and
    lan966x_switchdev_blocking_nb
  net: lan966x: Extend lan966x_foreign_bridging_check
  net: lan966x: Add lag support for lan966x.
  net: lan966x: Extend FDB to support also lag
  net: lan966x: Extend MAC to support also lag interfaces.

 .../net/ethernet/microchip/lan966x/Makefile   |   2 +-
 .../ethernet/microchip/lan966x/lan966x_fdb.c  | 153 ++++++---
 .../ethernet/microchip/lan966x/lan966x_lag.c  | 322 ++++++++++++++++++
 .../ethernet/microchip/lan966x/lan966x_mac.c  |  66 +++-
 .../ethernet/microchip/lan966x/lan966x_main.h |  41 +++
 .../ethernet/microchip/lan966x/lan966x_regs.h |  45 +++
 .../microchip/lan966x/lan966x_switchdev.c     | 115 +++++--
 7 files changed, 654 insertions(+), 90 deletions(-)
 create mode 100644 drivers/net/ethernet/microchip/lan966x/lan966x_lag.c

-- 
2.33.0

