Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D05C151C6D5
	for <lists+netdev@lfdr.de>; Thu,  5 May 2022 20:13:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1383034AbiEESRC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 May 2022 14:17:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33942 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357569AbiEESRA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 May 2022 14:17:00 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DBF865C373
        for <netdev@vger.kernel.org>; Thu,  5 May 2022 11:13:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1651774400; x=1683310400;
  h=from:to:subject:date:message-id:in-reply-to:references:
   mime-version;
  bh=HRFKh4yCV0iN8oEKMum17HvkxuTG19GsA2t0NR14SF8=;
  b=OG2BcpBvqP5rY97HcFNlpvNteS38JQ0aIHqrdHp0Jz6Maecpw4lNX3VS
   velqEUDvo2KFRUzhjSaEl4dZN6mkA6FqhjbSY7CbeQqqH9Z5RZ7HVm3eh
   aLy9HfvFqwK5SnM/4FONV8LJQgebfo2YzVmBwxvlZ1DK1LjoKI3mPIm+F
   BbSLy+MAA7l2RikIaAKTkHR+l+ZOShaJw7b9K3FRmFT07PlzLI87LdMot
   5U88VUcS4aWrA7pcAnDwBmIX9lDyqdqm71Aj8Dr0rog3OWmNqg0QJDWgc
   DnOWyCP/NL+H7bwhNAkoSxHj0wOar6ifs4C9bgDyqX+OYX4K2jNzeqB/y
   w==;
X-IronPort-AV: E=Sophos;i="5.91,202,1647327600"; 
   d="scan'208";a="94702632"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa6.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 05 May 2022 11:13:18 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Thu, 5 May 2022 11:13:08 -0700
Received: from chn-vm-ungapp01.mchp-main.com (10.10.115.15) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server id
 15.1.2375.17 via Frontend Transport; Thu, 5 May 2022 11:13:08 -0700
From:   Yuiko Oshino <yuiko.oshino@microchip.com>
To:     <woojung.huh@microchip.com>, <yuiko.oshino@microchip.com>,
        <davem@davemloft.net>, <netdev@vger.kernel.org>, <andrew@lunn.ch>,
        <ravi.hegde@microchip.com>, <UNGLinuxDriver@microchip.com>,
        <kuba@kernel.org>
Subject: [PATCH v4 net-next 2/2] net: phy: smsc: add LAN8742 phy support.
Date:   Thu, 5 May 2022 11:12:52 -0700
Message-ID: <20220505181252.32196-3-yuiko.oshino@microchip.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20220505181252.32196-1-yuiko.oshino@microchip.com>
References: <20220505181252.32196-1-yuiko.oshino@microchip.com>
MIME-Version: 1.0
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

The current phy IDs on the available hardware.
        LAN8742 0x0007C130, 0x0007C131

Signed-off-by: Yuiko Oshino <yuiko.oshino@microchip.com>
---
 drivers/net/phy/smsc.c | 27 +++++++++++++++++++++++++++
 1 file changed, 27 insertions(+)

diff --git a/drivers/net/phy/smsc.c b/drivers/net/phy/smsc.c
index d8cac02a79b9..44fa9e00cc50 100644
--- a/drivers/net/phy/smsc.c
+++ b/drivers/net/phy/smsc.c
@@ -481,6 +481,32 @@ static struct phy_driver smsc_phy_driver[] = {
 	.get_strings	= smsc_get_strings,
 	.get_stats	= smsc_get_stats,
 
+	.suspend	= genphy_suspend,
+	.resume		= genphy_resume,
+}, {
+	.phy_id	= 0x0007c130,	/* 0x0007c130 and 0x0007c131 */
+	.phy_id_mask	= 0xfffffff2,
+	.name		= "Microchip LAN8742",
+
+	/* PHY_BASIC_FEATURES */
+	.flags		= PHY_RST_AFTER_CLK_EN,
+
+	.probe		= smsc_phy_probe,
+
+	/* basic functions */
+	.read_status	= lan87xx_read_status,
+	.config_init	= smsc_phy_config_init,
+	.soft_reset	= smsc_phy_reset,
+
+	/* IRQ related */
+	.config_intr	= smsc_phy_config_intr,
+	.handle_interrupt = smsc_phy_handle_interrupt,
+
+	/* Statistics */
+	.get_sset_count = smsc_get_sset_count,
+	.get_strings	= smsc_get_strings,
+	.get_stats	= smsc_get_stats,
+
 	.suspend	= genphy_suspend,
 	.resume		= genphy_resume,
 } };
@@ -498,6 +524,7 @@ static struct mdio_device_id __maybe_unused smsc_tbl[] = {
 	{ 0x0007c0d0, 0xfffffff0 },
 	{ 0x0007c0f0, 0xfffffff0 },
 	{ 0x0007c110, 0xfffffff0 },
+	{ 0x0007c130, 0xfffffff2 },
 	{ }
 };
 
-- 
2.25.1

