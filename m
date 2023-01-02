Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 08B1565B1C3
	for <lists+netdev@lfdr.de>; Mon,  2 Jan 2023 13:07:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232471AbjABMHq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Jan 2023 07:07:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39774 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230196AbjABMHp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 Jan 2023 07:07:45 -0500
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D748F5FFB;
        Mon,  2 Jan 2023 04:07:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1672661264; x=1704197264;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=oKV7nJa9FoGLOtU9V1hKIe38BFhTsWvOW7No+LXT7tQ=;
  b=ROaUk1zPxsCBGzczcWLoneWYCEkMi+1dGac2UuMsEVNCYDlyfv40SB7s
   gdsz6awHmYEy93+Srvdb7KoNgZdV+59gq7+wMwqInkmDvLEXF2b3Emo/F
   18pN97rXm/iaW3XLCZxcsj1G/7XBG8VVUdhEtV/MU5YGa0WW9e5G7mz5m
   37mDByV0duV8Tj2EZKwIOw375pvIaDqPRFBouUHRheqELMLhnS1gWiCDs
   9z5bdNdWU3K/75w9Ais1U2T0gJ/Y2K5dKtKSQJ/XL5m88T3ehPZNBup6v
   DfkAsMuymCI+FXEKhQou2xAyMMRCviAfoDVFX/DPvaB9XGbNEfK2jmOR9
   g==;
X-IronPort-AV: E=Sophos;i="5.96,294,1665471600"; 
   d="scan'208";a="130430292"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa6.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 02 Jan 2023 05:07:43 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Mon, 2 Jan 2023 05:07:41 -0700
Received: from soft-dev3-1.microsemi.net (10.10.115.15) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server id
 15.1.2507.16 via Frontend Transport; Mon, 2 Jan 2023 05:07:38 -0700
From:   Horatiu Vultur <horatiu.vultur@microchip.com>
To:     <netdev@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>
CC:     <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <lars.povlsen@microchip.com>,
        <Steen.Hegelund@microchip.com>, <daniel.machon@microchip.com>,
        <UNGLinuxDriver@microchip.com>, <casper.casan@gmail.com>,
        <rmk+kernel@armlinux.org.uk>, <linqiheng@huawei.com>,
        <nathan@kernel.org>, Horatiu Vultur <horatiu.vultur@microchip.com>
Subject: [PATCH net] net: sparx5: Fix reading of the MAC address
Date:   Mon, 2 Jan 2023 13:12:15 +0100
Message-ID: <20230102121215.2697179-1-horatiu.vultur@microchip.com>
X-Mailer: git-send-email 2.38.0
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

There is an issue with the checking of the return value of
'of_get_mac_address', which returns 0 on success and negative value on
failure. The driver interpretated the result the opposite way. Therefore
if there was a MAC address defined in the DT, then the driver was
generating a random MAC address otherwise it would use address 0.
Fix this by checking correctly the return value of 'of_get_mac_address'

Fixes: b74ef9f9cb91 ("net: sparx5: Do not use mac_addr uninitialized in mchp_sparx5_probe()")
Signed-off-by: Horatiu Vultur <horatiu.vultur@microchip.com>
---
 drivers/net/ethernet/microchip/sparx5/sparx5_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/microchip/sparx5/sparx5_main.c b/drivers/net/ethernet/microchip/sparx5/sparx5_main.c
index d25f4f09faa06..3c5d4fe993737 100644
--- a/drivers/net/ethernet/microchip/sparx5/sparx5_main.c
+++ b/drivers/net/ethernet/microchip/sparx5/sparx5_main.c
@@ -834,7 +834,7 @@ static int mchp_sparx5_probe(struct platform_device *pdev)
 	if (err)
 		goto cleanup_config;
 
-	if (!of_get_mac_address(np, sparx5->base_mac)) {
+	if (of_get_mac_address(np, sparx5->base_mac)) {
 		dev_info(sparx5->dev, "MAC addr was not set, use random MAC\n");
 		eth_random_addr(sparx5->base_mac);
 		sparx5->base_mac[5] = 0;
-- 
2.38.0

