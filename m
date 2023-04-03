Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1AA1A6D42C8
	for <lists+netdev@lfdr.de>; Mon,  3 Apr 2023 13:01:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231646AbjDCLBd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Apr 2023 07:01:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50306 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230246AbjDCLBc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Apr 2023 07:01:32 -0400
Received: from lelv0142.ext.ti.com (lelv0142.ext.ti.com [198.47.23.249])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D56CEB7C;
        Mon,  3 Apr 2023 04:01:29 -0700 (PDT)
Received: from lelv0265.itg.ti.com ([10.180.67.224])
        by lelv0142.ext.ti.com (8.15.2/8.15.2) with ESMTP id 333B1BP3029129;
        Mon, 3 Apr 2023 06:01:11 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1680519671;
        bh=idW9AcVj8hK9ICfIz5MOhL13u9zDtfT1NjkGhLisFS0=;
        h=From:To:CC:Subject:Date;
        b=jdNKbTSmso/wMX2u0nM9fHMl/HXqy+qclPNK3yNh+AcJFjg/FvmbnKZIBGcYcuMNs
         2qoymB+yvHj9jHj9hP+LOvdqiEE2GKORwH+zLo0RFdhTLai+bfN1tZ0TUi0TbLMBmh
         YrAO4EuGXs8sI6LBVa+N3mNgmfjvTrfOwBwtRO5Y=
Received: from DFLE113.ent.ti.com (dfle113.ent.ti.com [10.64.6.34])
        by lelv0265.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 333B1BIo013259
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Mon, 3 Apr 2023 06:01:11 -0500
Received: from DFLE104.ent.ti.com (10.64.6.25) by DFLE113.ent.ti.com
 (10.64.6.34) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2507.16; Mon, 3
 Apr 2023 06:01:10 -0500
Received: from lelv0327.itg.ti.com (10.180.67.183) by DFLE104.ent.ti.com
 (10.64.6.25) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2507.16 via
 Frontend Transport; Mon, 3 Apr 2023 06:01:10 -0500
Received: from uda0492258.dhcp.ti.com (ileaxei01-snat2.itg.ti.com [10.180.69.6])
        by lelv0327.itg.ti.com (8.15.2/8.15.2) with ESMTP id 333B17wo101591;
        Mon, 3 Apr 2023 06:01:07 -0500
From:   Siddharth Vadapalli <s-vadapalli@ti.com>
To:     <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <linux@armlinux.org.uk>, <pabeni@redhat.com>, <rogerq@kernel.org>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <srk@ti.com>,
        <s-vadapalli@ti.com>
Subject: [PATCH net-next v2 0/3] Add support for J784S4 CPSW9G
Date:   Mon, 3 Apr 2023 16:31:03 +0530
Message-ID: <20230403110106.983994-1-s-vadapalli@ti.com>
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

Changes from v1:
1. Add a patch to move interface mode specific configuration from the
   mac_link_up() callback to the mac_config() callback of the am65-cpsw
   driver. Also, add a TODO comment for 10 Mbps RGMII in-band mode.
2. Add MAC_5000FD to the list of mac_capabilities member unconditionally,
   since the CPSW MAC supports it.
3. Add USXGMII mode specific configuration in the mac_config() callback
   along with the SGMII mode specific configuration, instead of the
   mac_link_up() callback which was incorrectly done in the v1 series.

v1:
https://lore.kernel.org/r/20230331065110.604516-1-s-vadapalli@ti.com/

Regards,
Siddharth.

Siddharth Vadapalli (3):
  net: ethernet: ti: am65-cpsw: Move mode specific config to
    mac_config()
  net: ethernet: ti: am65-cpsw: Enable QSGMII for J784S4 CPSW9G
  net: ethernet: ti: am65-cpsw: Enable USXGMII mode for J784S4 CPSW9G

 drivers/net/ethernet/ti/am65-cpsw-nuss.c | 32 +++++++++++++++++++++---
 1 file changed, 28 insertions(+), 4 deletions(-)

-- 
2.25.1

