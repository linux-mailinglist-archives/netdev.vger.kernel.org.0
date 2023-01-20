Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 841BD674C3E
	for <lists+netdev@lfdr.de>; Fri, 20 Jan 2023 06:27:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231360AbjATF1p (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Jan 2023 00:27:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59808 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231277AbjATF1b (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Jan 2023 00:27:31 -0500
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E8EA27EF5;
        Thu, 19 Jan 2023 21:21:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1674192109; x=1705728109;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=KXgeu6rhqlqZNEm6RGXYsNzvZPVxHe8VOsfAgVGBMwE=;
  b=cI0XUyUp5j5MKDoOJo+Nr7L7ptUqbZaXA7a2O7W0NpsZ8AJsA9VCb8ug
   II8vRcgFl7G4Ggz6AK8uN30UrpkA8dHw0qV6LbVezvxS5c4zbkHRDCD+l
   p47P6p+3PCX+Id86/1TVWwy+70FxhjsRDwrzAl59QSmdueuLPqd1zjy9i
   OAcH8UeTKQMOBvIKK8WGdlczqDbFNtxyA2iQLSI/LkZK7We39FDFOlQiO
   i+rPdsDCujVD7oRGhRV3Q4pCUQvODhXH8FrVt00cP8JK7ezF46MlYrUao
   osHGBO87Gql+d+sFFmSDmkVF5QkLZzTusWi/Xf5okszsrwWHCfFHAtH+4
   A==;
X-IronPort-AV: E=Sophos;i="5.97,231,1669100400"; 
   d="scan'208";a="197578551"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa5.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 19 Jan 2023 22:21:49 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.85.144) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Thu, 19 Jan 2023 22:21:48 -0700
Received: from CHE-LT-I17769U.microchip.com (10.10.115.15) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server id
 15.1.2507.16 via Frontend Transport; Thu, 19 Jan 2023 22:21:43 -0700
From:   Arun Ramadoss <arun.ramadoss@microchip.com>
To:     <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>
CC:     <woojung.huh@microchip.com>, <UNGLinuxDriver@microchip.com>,
        <andrew@lunn.ch>, <vivien.didelot@gmail.com>,
        <f.fainelli@gmail.com>, <olteanv@gmail.com>, <davem@davemloft.net>,
        <edumazet@google.com>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <linux@armlinux.org.uk>, <Tristram.Ha@microchip.com>
Subject: [Patch net-next v2 0/2] net: dsa: microchip: add support for credit based shaper
Date:   Fri, 20 Jan 2023 10:51:33 +0530
Message-ID: <20230120052135.32120-1-arun.ramadoss@microchip.com>
X-Mailer: git-send-email 2.36.1
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

LAN937x switch family, KSZ9477, KSZ9567, KSZ9563 and KSZ8563 supports
the credit based shaper. But there were few difference between LAN937x and KSZ
switch like
- number of queues for LAN937x is 8 and for others it is 4.
- size of credit increment register for LAN937x is 24 and for other is 16-bit.
This patch series add the credit based shaper with common implementation for
LAN937x and KSZ swithes.

v1 -> v2
- Added the check for divide by zero in cinc_cal()
- Port queue is splitted based on dev->info->tc_num_queues

RFC -> Patch v1
- Rebased to latest net-next

Arun Ramadoss (2):
  net: dsa: microchip: enable port queues for tc mqprio
  net: dsa: microchip: add support for credit based shaper

 drivers/net/dsa/microchip/ksz9477.c      |  25 +++++
 drivers/net/dsa/microchip/ksz9477.h      |   2 +
 drivers/net/dsa/microchip/ksz9477_reg.h  |  33 ++----
 drivers/net/dsa/microchip/ksz_common.c   | 130 +++++++++++++++++++++++
 drivers/net/dsa/microchip/ksz_common.h   |  21 ++++
 drivers/net/dsa/microchip/lan937x.h      |   1 +
 drivers/net/dsa/microchip/lan937x_main.c |   9 ++
 drivers/net/dsa/microchip/lan937x_reg.h  |   3 +
 net/dsa/tag_ksz.c                        |  15 +++
 9 files changed, 213 insertions(+), 26 deletions(-)


base-commit: 1038bfb23649faf47fc0714dea42f472cdcf1784
-- 
2.36.1

