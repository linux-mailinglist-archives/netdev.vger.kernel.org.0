Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A9FBD6095AF
	for <lists+netdev@lfdr.de>; Sun, 23 Oct 2022 20:45:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230486AbiJWSpp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 23 Oct 2022 14:45:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42298 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230461AbiJWSpj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 23 Oct 2022 14:45:39 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F313B5019D;
        Sun, 23 Oct 2022 11:45:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1666550729; x=1698086729;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=x+y0fsp13Gl2YPgCrqcNr8nfXGlOeCeZf5yU1ZGg25Q=;
  b=YzxLGgh0L6SArNZoikXemlHtXu+w+qL0lpJA4XHTVtlVjdLKRGRzu/mT
   X2UCAKz9LPCoDec8cPism5aQ6OH9njRVfbFsVWuv60ir6FY5x40zDf/Ds
   ZIgxjNOVcxeSGSLz+CK6wwurGct3UUZwaiMRo97MrP3GKfwCJJ6hpB4h5
   +lt6jv7QzvQD6B9V9hveKrLPltSTXOfbqZAywItcVIAM8ue2rUG2q6cem
   qjkkBHK3uKWeA20nJYcxFsO1Zg9ADapV81WL2Z/goV2RB+DvSBGdNCLUE
   QC6IKOng25jD3H3nm+TG/O/BNY0NYIY0pGl1bgR0NbwzIKH8hfcubPVZQ
   w==;
X-IronPort-AV: E=Sophos;i="5.95,207,1661842800"; 
   d="scan'208";a="196672024"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa1.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 23 Oct 2022 11:45:12 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.12; Sun, 23 Oct 2022 11:45:12 -0700
Received: from soft-dev3-1.microsemi.net (10.10.115.15) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server id
 15.1.2507.12 via Frontend Transport; Sun, 23 Oct 2022 11:45:10 -0700
From:   Horatiu Vultur <horatiu.vultur@microchip.com>
To:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC:     <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <UNGLinuxDriver@microchip.com>,
        Horatiu Vultur <horatiu.vultur@microchip.com>
Subject: [PATCH net 0/3] net: lan966x: Fixes for when MTU is changed
Date:   Sun, 23 Oct 2022 20:48:35 +0200
Message-ID: <20221023184838.4128061-1-horatiu.vultur@microchip.com>
X-Mailer: git-send-email 2.38.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Spam-Status: No, score=-4.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There were multiple problems in different parts of the driver when
the MTU was changed.
The first problem was that the HW was missing to configure the correct
value, it was missing ETH_HLEN and ETH_FCS_LEN. The second problem was
when vlan filtering was enabled/disabled, the MRU was not adjusted
corretly. While the last issue was that the FDMA was calculated wrongly
the correct maximum MTU.

Horatiu Vultur (3):
  net: lan966x: Fix the MTU calculation
  net: lan966x: Adjust maximum frame size when vlan is enabled/disabled
  net: lan966x: Fix FDMA when MTU is changed

 .../net/ethernet/microchip/lan966x/lan966x_fdma.c |  7 +++++--
 .../net/ethernet/microchip/lan966x/lan966x_main.c |  4 ++--
 .../net/ethernet/microchip/lan966x/lan966x_main.h |  2 ++
 .../net/ethernet/microchip/lan966x/lan966x_regs.h | 15 +++++++++++++++
 .../net/ethernet/microchip/lan966x/lan966x_vlan.c |  6 ++++++
 5 files changed, 30 insertions(+), 4 deletions(-)

-- 
2.38.0

