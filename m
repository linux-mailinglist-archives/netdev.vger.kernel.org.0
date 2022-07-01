Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DBF97563B88
	for <lists+netdev@lfdr.de>; Fri,  1 Jul 2022 23:15:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231139AbiGAUti (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Jul 2022 16:49:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48118 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229570AbiGAUth (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Jul 2022 16:49:37 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 939C25C9D9;
        Fri,  1 Jul 2022 13:49:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1656708575; x=1688244575;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=UENqUwouIsclLvCQ67m4nuHbj/IlPm2/wXFF8ffxSyU=;
  b=qqQf7B7JJtl3mlBrhWoWZpTldmDEvb6lykHn5xlNVEWl8JaZDwXX7tE8
   WttEcr9OqRsJFYnF8caYugGiQktuPB2sMmxa4UESLZHSaHeVcGYS3700F
   SMF4gHPFxBgEyDYl8ZiTQbo8zbIa3HF/QTw5xvAn+kRCBCKOP4nZTBm0r
   IF15LbGaDZFrLp5Oq7agzyEtGuo2Ddr6+rm3XaRpYcPMw3PProc3skEun
   k4+gK7wZGh4U+qNnYZ3K4e6d/atXlRtCjvodH+UPjRUy7Wmmnltr9sGCV
   Eioz4tOdmzeBon9T4aZWSYuePymJd5FGSevFz64LB/TFDUisvSxWKAZ9B
   Q==;
X-IronPort-AV: E=Sophos;i="5.92,238,1650956400"; 
   d="scan'208";a="170745578"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa3.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 01 Jul 2022 13:49:34 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Fri, 1 Jul 2022 13:49:34 -0700
Received: from soft-dev3-1.microsemi.net (10.10.115.15) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server id
 15.1.2375.17 via Frontend Transport; Fri, 1 Jul 2022 13:49:32 -0700
From:   Horatiu Vultur <horatiu.vultur@microchip.com>
To:     <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>
CC:     <UNGLinuxDriver@microchip.com>, <davem@davemloft.net>,
        <edumazet@google.com>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <vladimir.oltean@nxp.com>,
        Horatiu Vultur <horatiu.vultur@microchip.com>
Subject: [PATCH net-next v3 0/7] net: lan966x: Add lag support
Date:   Fri, 1 Jul 2022 22:52:20 +0200
Message-ID: <20220701205227.1337160-1-horatiu.vultur@microchip.com>
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

v2->v3:
- return error code from 'switchdev_bridge_port_offload()'
- fix lan966x_foreign_dev_check(), it was missing lag support
- remove lan966x_lag_mac_add_entry and lan966x_mac_del_entry as
  they are not needed
- fix race conditions when accessing port->bond
- move FDB entries when a new port joins the lag if it has a lower

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
 .../ethernet/microchip/lan966x/lan966x_fdb.c  | 155 +++++---
 .../ethernet/microchip/lan966x/lan966x_lag.c  | 335 ++++++++++++++++++
 .../ethernet/microchip/lan966x/lan966x_mac.c  |  66 +++-
 .../ethernet/microchip/lan966x/lan966x_main.h |  38 ++
 .../ethernet/microchip/lan966x/lan966x_regs.h |  45 +++
 .../microchip/lan966x/lan966x_switchdev.c     | 137 +++++--
 7 files changed, 680 insertions(+), 98 deletions(-)
 create mode 100644 drivers/net/ethernet/microchip/lan966x/lan966x_lag.c

-- 
2.33.0

