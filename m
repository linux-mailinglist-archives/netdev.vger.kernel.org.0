Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8E9476D5897
	for <lists+netdev@lfdr.de>; Tue,  4 Apr 2023 08:16:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233482AbjDDGQR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Apr 2023 02:16:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35800 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233735AbjDDGQF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Apr 2023 02:16:05 -0400
Received: from lelv0143.ext.ti.com (lelv0143.ext.ti.com [198.47.23.248])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ECA9D2D43;
        Mon,  3 Apr 2023 23:15:43 -0700 (PDT)
Received: from fllv0034.itg.ti.com ([10.64.40.246])
        by lelv0143.ext.ti.com (8.15.2/8.15.2) with ESMTP id 3346F4YT053366;
        Tue, 4 Apr 2023 01:15:04 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1680588904;
        bh=2D4Vq09VFa0ia0sRhbvIZipMNHoEXdzM1YvHgrunZao=;
        h=From:To:CC:Subject:Date;
        b=ik3bgffts0kcvCORSi6vOf1apNM9Dh4LWCTmVWCVlgDLurvysZ2r0WuMOiEmq9wYt
         m7+v87URgym9k1ScyacpgSQA4D5hXpo+Da9GMmYKeNUkmcIaBUdaaZroEES26I2RHR
         7nfq+SjWUj5uAiFUrnT5XAFH4o929MsMnQi6N2II=
Received: from DFLE104.ent.ti.com (dfle104.ent.ti.com [10.64.6.25])
        by fllv0034.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 3346F3fA099811
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 4 Apr 2023 01:15:04 -0500
Received: from DFLE106.ent.ti.com (10.64.6.27) by DFLE104.ent.ti.com
 (10.64.6.25) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2507.16; Tue, 4
 Apr 2023 01:15:03 -0500
Received: from lelv0327.itg.ti.com (10.180.67.183) by DFLE106.ent.ti.com
 (10.64.6.27) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2507.16 via
 Frontend Transport; Tue, 4 Apr 2023 01:15:03 -0500
Received: from uda0492258.dhcp.ti.com (ileaxei01-snat.itg.ti.com [10.180.69.5])
        by lelv0327.itg.ti.com (8.15.2/8.15.2) with ESMTP id 3346ExN7087499;
        Tue, 4 Apr 2023 01:15:00 -0500
From:   Siddharth Vadapalli <s-vadapalli@ti.com>
To:     <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <linux@armlinux.org.uk>, <pabeni@redhat.com>, <rogerq@kernel.org>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <srk@ti.com>,
        <s-vadapalli@ti.com>
Subject: [PATCH net-next v3 0/3] Add support for J784S4 CPSW9G
Date:   Tue, 4 Apr 2023 11:44:56 +0530
Message-ID: <20230404061459.1100519-1-s-vadapalli@ti.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_PASS,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

This series adds a new compatible to am65-cpsw driver for the CPSW9G
instance of the CPSW Ethernet Switch on TI's J784S4 SoC which has 8
external ports and 1 internal host port.

The CPSW9G instance supports QSGMII and USXGMII modes for which driver
support is added.

Additionally, the interface mode specific configurations are moved to the
am65_cpsw_nuss_mac_config() callback. Also, a TODO comment is added for
verifying whether in-band mode is necessary for 10 Mbps RGMII mode.

NOTE:
I have verified that the mac_config() operations are preserved across
link up and link down events for SGMII and USXGMII mode with the new
implementation in this series, as suggested by:
Russell King <linux@armlinux.org.uk>

For patches 1 and 3 of this series, I believe that the following tag:
Suggested-by: Russell King <linux@armlinux.org.uk>
should be added. However, I did not add it since I did not yet get
the permission to do so. I will be happy if the tags are added, since
the new implementation is almost entirely based on Russell's suggestion,
with minor changes made by me.

Changes from v2:
1. In am65_cpsw_nuss_mac_config(), set the CPSW_SL_CTL_EXT_EN bit in the
   MAC control register if the mode is SGMII. Else, clear that bit.
2. In am65_cpsw_nuss_mac_link_down(), instead of resetting the entire MAC
   control register, only clear those bits that can possibly be set in the
   am65_cpsw_nuss_mac_link_up() function. Resetting the entire MAC control
   register will result in loss of the configuration performed by the
   am65_cpsw_nuss_mac_config() function.
3. In am65_cpsw_nuss_mac_link_down(), since the MAC control register
   will not be reset, the CPSW_SL_CTL_CMD_IDLE bit which was previously
   cleared as a part of the reset, needs to be cleared in the
   am65_cpsw_nuss_mac_link_up() function. This is the correct approach,
   since the MAC should remain IDLE until the link is detected.
4. In am65_cpsw_nuss_mac_config(), set the CPSW_SL_CTL_XGIG and the
   CPSW_SL_CTL_XGMII_EN bits in the MAC control register if the mode is
   USXGMII. Else, clear those bits.

Changes from v1:
1. Add a patch to move interface mode specific configuration from the
   mac_link_up() callback to the mac_config() callback of the am65-cpsw
   driver. Also, add a TODO comment for 10 Mbps RGMII in-band mode.
2. Add MAC_5000FD to the list of mac_capabilities member unconditionally,
   since the CPSW MAC supports it.
3. Add USXGMII mode specific configuration in the mac_config() callback
   along with the SGMII mode specific configuration, instead of the
   mac_link_up() callback which was incorrectly done in the v1 series.

v2:
https://lore.kernel.org/r/20230403110106.983994-1-s-vadapalli@ti.com/
v1:
https://lore.kernel.org/r/20230331065110.604516-1-s-vadapalli@ti.com/

Regards,
Siddharth.

Siddharth Vadapalli (3):
  net: ethernet: ti: am65-cpsw: Move mode specific config to
    mac_config()
  net: ethernet: ti: am65-cpsw: Enable QSGMII for J784S4 CPSW9G
  net: ethernet: ti: am65-cpsw: Enable USXGMII mode for J784S4 CPSW9G

 drivers/net/ethernet/ti/am65-cpsw-nuss.c | 42 +++++++++++++++++++++---
 1 file changed, 37 insertions(+), 5 deletions(-)

-- 
2.25.1

