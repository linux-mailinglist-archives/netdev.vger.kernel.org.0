Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0BD6459767D
	for <lists+netdev@lfdr.de>; Wed, 17 Aug 2022 21:31:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240302AbiHQTav (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Aug 2022 15:30:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51060 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238432AbiHQTau (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Aug 2022 15:30:50 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3FFC35B042;
        Wed, 17 Aug 2022 12:30:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1660764648; x=1692300648;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=tyTSNq5F9hK0d+h8MFDvRwJmttjYl2ZU/nazL7KLnpw=;
  b=twHEcr3ZwpUmwVuqFDnAZmhUbeH6HfEqhm7ld+LebaOaMHRQGPkYmkwJ
   +L59dHFuBw3cCfpH6xSkuLhQmFJrSX4mznxR2hLJCVJi9xAbMloikeJFI
   TdF6BDOUl7y9yqiQIu0NcThP6r6hje81dS7KfhAZvPAjVsxbWZfw4Tue7
   CHmhEYX/KPo3q9YcpdlXJJIWH8il2Y7ZCuVO7VOTjkmEsItUSQGoOA8ri
   4JlOKRzYVzPgrG71euBC4TznqZRdEXsxc/rM6u3QISrGCezTT1zDVEyud
   90YrgttDozgtNOYAZpY8xi8Enj0LCl8ZKZze4X6+aZIbW01hhTO7eWyY1
   A==;
X-IronPort-AV: E=Sophos;i="5.93,244,1654585200"; 
   d="scan'208";a="176816539"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa3.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 17 Aug 2022 12:30:46 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.12; Wed, 17 Aug 2022 12:30:46 -0700
Received: from soft-dev3-1.microsemi.net (10.10.115.15) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server id
 15.1.2507.12 via Frontend Transport; Wed, 17 Aug 2022 12:30:43 -0700
From:   Horatiu Vultur <horatiu.vultur@microchip.com>
To:     <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>
CC:     <UNGLinuxDriver@microchip.com>, <davem@davemloft.net>,
        <edumazet@google.com>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <linux@armlinux.org.uk>, <vladimir.oltean@nxp.com>,
        Horatiu Vultur <horatiu.vultur@microchip.com>
Subject: [PATCH net-next v4 0/8] net: lan966x: Add lag support
Date:   Wed, 17 Aug 2022 21:34:41 +0200
Message-ID: <20220817193449.1673002-1-horatiu.vultur@microchip.com>
X-Mailer: git-send-email 2.33.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add lag support for lan966x.
First 4 patches don't do any changes to the current behaviour, they
just prepare for lag support. While the rest is to add the lag support.

v3->v4:
- aggregation configuration is global for all bonds, so make sure that
  there can't be enabled multiple configurations at the same time
- return error faster from lan966x_foreign_bridging_check, don't
  continue the search if the error is seen already
- flush fdb workqueue when a port leaves a bridge or lag.

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

Horatiu Vultur (8):
  net: lan966x: Add registers used to configure lag interfaces
  net: lan966x: Split lan966x_fdb_event_work
  net: lan966x: Flush fdb workqueue when port is leaving a bridge.
  net: lan966x: Expose lan966x_switchdev_nb and
    lan966x_switchdev_blocking_nb
  net: lan966x: Extend lan966x_foreign_bridging_check
  net: lan966x: Add lag support for lan966x
  net: lan966x: Extend FDB to support also lag
  net: lan966x: Extend MAC to support also lag interfaces.

 .../net/ethernet/microchip/lan966x/Kconfig    |   1 +
 .../net/ethernet/microchip/lan966x/Makefile   |   2 +-
 .../ethernet/microchip/lan966x/lan966x_fdb.c  | 155 +++++---
 .../ethernet/microchip/lan966x/lan966x_lag.c  | 363 ++++++++++++++++++
 .../ethernet/microchip/lan966x/lan966x_mac.c  | 104 ++++-
 .../ethernet/microchip/lan966x/lan966x_main.h |  39 ++
 .../ethernet/microchip/lan966x/lan966x_regs.h |  45 +++
 .../microchip/lan966x/lan966x_switchdev.c     | 138 +++++--
 8 files changed, 741 insertions(+), 106 deletions(-)
 create mode 100644 drivers/net/ethernet/microchip/lan966x/lan966x_lag.c

-- 
2.33.0

