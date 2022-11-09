Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F09A7622FA6
	for <lists+netdev@lfdr.de>; Wed,  9 Nov 2022 17:08:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230239AbiKIQIW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Nov 2022 11:08:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53642 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229564AbiKIQIV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Nov 2022 11:08:21 -0500
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8046921E19;
        Wed,  9 Nov 2022 08:08:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1668010097; x=1699546097;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=La3eW8LpeiMGGygGEgS4OzFiJHOQTD7gyaK/eU+Gb3g=;
  b=U0kUK/n+k2yldW1FaME9buWBWKCzJ41+eYcJuotOf6p4QI2N+smOoC0O
   jEXCb+2Yi2vChghFCeD/qy28yPW8XakCXq3E6W5NfP1OXYcc1UH9FCMxF
   JGLzBnqOCWQ8D7RLlMR4hpQP6DXNFnx/UNmV+IUXzfMySNsCnB6HAOu7V
   So6pnGPzpHMpCQj/4Q3Kue/yw/5dkFmgRefvWF6WUvVCNx80vQd9X/7Pq
   wdVmsjDdUQBd92+ag8w/XJI6j20eEeNU3Itmhy11A23urCOpon75OXanG
   PNk4kkNurmLE+O8GH9j+t1vqHOj+//RKdzJcKLafCqUShxdxv8rlc3Oj4
   A==;
X-IronPort-AV: E=Sophos;i="5.96,151,1665471600"; 
   d="scan'208";a="186153673"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa2.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 09 Nov 2022 09:08:16 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.12; Wed, 9 Nov 2022 09:08:16 -0700
Received: from CHE-LT-I17769U.microchip.com (10.10.115.15) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server id
 15.1.2507.12 via Frontend Transport; Wed, 9 Nov 2022 09:08:11 -0700
From:   Arun Ramadoss <arun.ramadoss@microchip.com>
To:     <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>
CC:     <woojung.huh@microchip.com>, <UNGLinuxDriver@microchip.com>,
        <andrew@lunn.ch>, <vivien.didelot@gmail.com>,
        <f.fainelli@gmail.com>, <olteanv@gmail.com>, <davem@davemloft.net>,
        <edumazet@google.com>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <linux@armlinux.org.uk>, <Tristram.Ha@microchip.com>
Subject: [RFC Patch net-next 0/2] net: dsa: microchip: add support for Credit based shaper
Date:   Wed, 9 Nov 2022 21:37:55 +0530
Message-ID: <20221109160757.27902-1-arun.ramadoss@microchip.com>
X-Mailer: git-send-email 2.36.1
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

LAN937x switch family, KSZ9477, KSZ9567, KSZ8567, KSZ9563 and KSZ8563 supports
the credit based shaper. But there were few difference between LAN937x and KSZ
switch like
- number of queue for LAN937x is 8 and for others it is 4.
- Size of credit increment register for LAN937x is 24 and for other is 16-bit.
This patch series add the credit based shaper with common implementation for
LAN937x and KSZ swithes.

Arun Ramadoss (2):
  net: dsa: microchip: enable port queues for tc mqprio
  net: dsa: microchip: add support for credit based shaper

 drivers/net/dsa/microchip/ksz9477.c      |  11 +++
 drivers/net/dsa/microchip/ksz9477.h      |   1 +
 drivers/net/dsa/microchip/ksz9477_reg.h  |  32 ++----
 drivers/net/dsa/microchip/ksz_common.c   | 121 +++++++++++++++++++++++
 drivers/net/dsa/microchip/ksz_common.h   |  21 ++++
 drivers/net/dsa/microchip/lan937x.h      |   1 +
 drivers/net/dsa/microchip/lan937x_main.c |   9 ++
 drivers/net/dsa/microchip/lan937x_reg.h  |   9 +-
 net/dsa/tag_ksz.c                        |  15 +++
 9 files changed, 193 insertions(+), 27 deletions(-)

-- 
2.36.1

