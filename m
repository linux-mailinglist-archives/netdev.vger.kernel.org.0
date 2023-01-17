Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8001666E0C7
	for <lists+netdev@lfdr.de>; Tue, 17 Jan 2023 15:33:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231614AbjAQOdX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Jan 2023 09:33:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53686 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231969AbjAQOdK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Jan 2023 09:33:10 -0500
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0160013D43;
        Tue, 17 Jan 2023 06:33:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1673965986; x=1705501986;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=7Yy9z2eopuNvLQei9fbFhi1riVoJfniZrk4wzro23HM=;
  b=0ousSEgSsgtGvwHOVGzRDeKpbKxXw9RW0J2O69bbA3nUOCfZmlzGTWFe
   AyCjs/5HzJai1chSmWXF3dRTTqMiAHzp+TjIRBqN2LadW5nZRUMdPtFcJ
   hRjDdDCYdBOQ1Yf7IO37NAxhK9x1N6jvjDarhCJkjd7NqOEr9N++ludUA
   qpT3IDLu3u4sKN1WblQdsYrcHSl/ZL++dSaIo6b/6iTqNjcOPIFCLM6px
   z+MjF6OK6AIjujKv+uJrRBzi3ITCKivkUzikRaExEbhNJ5GU9vjaXReEq
   owYKHd6gOeS+BqY7EQpPThxBn6kbk/FfBq0p18m7AuTyRvYqcrvOx17TN
   g==;
X-IronPort-AV: E=Sophos;i="5.97,224,1669100400"; 
   d="scan'208";a="197001875"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa3.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 17 Jan 2023 07:33:06 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.85.144) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Tue, 17 Jan 2023 07:33:05 -0700
Received: from CHE-LT-I17769U.microchip.com (10.10.115.15) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server id
 15.1.2507.16 via Frontend Transport; Tue, 17 Jan 2023 07:33:00 -0700
From:   Arun Ramadoss <arun.ramadoss@microchip.com>
To:     <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>
CC:     <woojung.huh@microchip.com>, <UNGLinuxDriver@microchip.com>,
        <andrew@lunn.ch>, <vivien.didelot@gmail.com>,
        <f.fainelli@gmail.com>, <olteanv@gmail.com>, <davem@davemloft.net>,
        <edumazet@google.com>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <linux@armlinux.org.uk>, <Tristram.Ha@microchip.com>
Subject: [Patch net-next 0/2] net: dsa: microchip: add support for credit based shaper
Date:   Tue, 17 Jan 2023 20:02:50 +0530
Message-ID: <20230117143252.8339-1-arun.ramadoss@microchip.com>
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

RFC -> Patch v1
- Rebased to latest net-next

Arun Ramadoss (2):
  net: dsa: microchip: enable port queues for tc mqprio
  net: dsa: microchip: add support for credit based shaper

 drivers/net/dsa/microchip/ksz9477.c      |  11 ++
 drivers/net/dsa/microchip/ksz9477.h      |   1 +
 drivers/net/dsa/microchip/ksz9477_reg.h  |  32 ++----
 drivers/net/dsa/microchip/ksz_common.c   | 123 +++++++++++++++++++++++
 drivers/net/dsa/microchip/ksz_common.h   |  21 ++++
 drivers/net/dsa/microchip/lan937x.h      |   1 +
 drivers/net/dsa/microchip/lan937x_main.c |   9 ++
 drivers/net/dsa/microchip/lan937x_reg.h  |   9 +-
 net/dsa/tag_ksz.c                        |  15 +++
 9 files changed, 195 insertions(+), 27 deletions(-)


base-commit: 0349b8779cc949ad9e6aced32672ee48cf79b497
-- 
2.36.1

