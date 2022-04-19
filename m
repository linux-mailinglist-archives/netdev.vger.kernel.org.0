Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8A3E4506705
	for <lists+netdev@lfdr.de>; Tue, 19 Apr 2022 10:35:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350052AbiDSIgx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Apr 2022 04:36:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36596 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343562AbiDSIgu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Apr 2022 04:36:50 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 09C8527176;
        Tue, 19 Apr 2022 01:34:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1650357246; x=1681893246;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=QTLFAZQGS9gBErlnU1jhBbYY59VWbLlwSuM1/kJZrDc=;
  b=cz2CjDDNvHThdt6X1mJ5I+8Mwdm/upqs9+IMjdSprUGRbSIf6mHDXcNo
   jOmsjYrXOkaV4IbcKfhHHpXGrrM+w2FfewBYYqI6qUZdfJgat1ClasSW/
   nRsj5HI8B9w0ao61fJDjGciXLd0g060N3pk0HaiUN7G3wkKbhAL3BNorX
   jwIqspsDYbYJkF+jqDHVv+RGky15Y1fVZYgUNK2cLt7d3RCj9tVuAz0Dt
   Fzwe9AH0J91EVHOCebvfJC6bUd3hTwFmAYH14+3Fp8gTQXv+UOV5wciRj
   35fHJsMnUKzP12qFMnqIsCsZoE0ZZ82ljVTmcx1Sgcj4XVoIrz8IE4EHt
   A==;
X-IronPort-AV: E=Sophos;i="5.90,272,1643698800"; 
   d="scan'208";a="92772073"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa6.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 19 Apr 2022 01:34:04 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Tue, 19 Apr 2022 01:34:03 -0700
Received: from soft-dev3-1.microsemi.net (10.10.115.15) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server id
 15.1.2375.17 via Frontend Transport; Tue, 19 Apr 2022 01:34:00 -0700
From:   Horatiu Vultur <horatiu.vultur@microchip.com>
To:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC:     <andrew@lunn.ch>, <hkallweit1@gmail.com>, <linux@armlinux.org.uk>,
        <davem@davemloft.net>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <UNGLinuxDriver@microchip.com>, <richardcochran@gmail.com>,
        Horatiu Vultur <horatiu.vultur@microchip.com>
Subject: [RFC PATCH net-next 0/2] net: phy: Extend sysfs to adjust PHY latency.
Date:   Tue, 19 Apr 2022 10:37:02 +0200
Message-ID: <20220419083704.48573-1-horatiu.vultur@microchip.com>
X-Mailer: git-send-email 2.33.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The previous try of setting the PHY latency was here[1]. But this approach
could not work for multiple reasons:
- the interface was not generic enough so it would be hard to be extended
  in the future
- if there were multiple time stamper in the system then it was not clear
  to which one should adjust these values.

So the next try is to extend sysfs and configure exactly the desired PHY.
Therefore add a new entry in sysfs for the PHY('adjust_latency') which
will be shown only if the PHY implements the set/get_adj_latency.

[1] https://lore.kernel.org/netdev/20220401093909.3341836-1-horatiu.vultur@microchip.com/

Horatiu Vultur (2):
  net: phy: Add phy latency adjustment support in phy framework.
  net: phy: micrel: Implement set/get_adj_latency for lan8814

 .../ABI/testing/sysfs-class-net-phydev        | 10 +++
 drivers/net/phy/micrel.c                      | 87 +++++++++++++++++++
 drivers/net/phy/phy_device.c                  | 58 +++++++++++++
 include/linux/phy.h                           |  9 ++
 4 files changed, 164 insertions(+)

-- 
2.33.0

