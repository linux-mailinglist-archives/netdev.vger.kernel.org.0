Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 914CB671B74
	for <lists+netdev@lfdr.de>; Wed, 18 Jan 2023 13:06:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230096AbjARMG3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Jan 2023 07:06:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40536 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230377AbjARMF6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Jan 2023 07:05:58 -0500
Received: from lelv0142.ext.ti.com (lelv0142.ext.ti.com [198.47.23.249])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D24277E4B0;
        Wed, 18 Jan 2023 03:22:07 -0800 (PST)
Received: from lelv0265.itg.ti.com ([10.180.67.224])
        by lelv0142.ext.ti.com (8.15.2/8.15.2) with ESMTP id 30IBLfFA056612;
        Wed, 18 Jan 2023 05:21:41 -0600
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1674040901;
        bh=OAdIBFrrzccwy+esEDLCSN7tQoc5jz5kJ2Q3YeYHXm8=;
        h=From:To:CC:Subject:Date;
        b=Rxd3393nnE72F/PHxYTxWbygdyH8Ly8Up2QckHbJWSahTDO4kAkVowC7NyfMioFbB
         0OFPUa3bpsg8euDS8Y+jWRQ+EL+f1xL2wGfx0oldUgL9jkJogNQvEdx6pXUUshLE7y
         o4z2mVDM3S7PE68uacoQH0xi6NCiGTElPAKsZyow=
Received: from DFLE114.ent.ti.com (dfle114.ent.ti.com [10.64.6.35])
        by lelv0265.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 30IBLf1e032518
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 18 Jan 2023 05:21:41 -0600
Received: from DFLE108.ent.ti.com (10.64.6.29) by DFLE114.ent.ti.com
 (10.64.6.35) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2507.16; Wed, 18
 Jan 2023 05:21:41 -0600
Received: from fllv0039.itg.ti.com (10.64.41.19) by DFLE108.ent.ti.com
 (10.64.6.29) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2507.16 via
 Frontend Transport; Wed, 18 Jan 2023 05:21:41 -0600
Received: from uda0492258.dhcp.ti.com (ileaxei01-snat2.itg.ti.com [10.180.69.6])
        by fllv0039.itg.ti.com (8.15.2/8.15.2) with ESMTP id 30IBLbt9032879;
        Wed, 18 Jan 2023 05:21:38 -0600
From:   Siddharth Vadapalli <s-vadapalli@ti.com>
To:     <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <linux@armlinux.org.uk>, <pabeni@redhat.com>, <rogerq@kernel.org>,
        <geert@linux-m68k.org>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <srk@ti.com>,
        <s-vadapalli@ti.com>
Subject: [PATCH net-next] net: ethernet: ti: am65-cpsw: Handle -EPROBE_DEFER for Serdes PHY
Date:   Wed, 18 Jan 2023 16:51:36 +0530
Message-ID: <20230118112136.213061-1-s-vadapalli@ti.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In the am65_cpsw_init_serdes_phy() function, the error handling for the
call to the devm_of_phy_get() function misses the case where the return
value of devm_of_phy_get() is ERR_PTR(-EPROBE_DEFER). Proceeding without
handling this case will result in a crash when the "phy" pointer with
this value is dereferenced by phy_init() in am65_cpsw_enable_phy().

Fix this by adding appropriate error handling code.

Reported-by: Geert Uytterhoeven <geert@linux-m68k.org>
Fixes: dab2b265dd23 ("net: ethernet: ti: am65-cpsw: Add support for SERDES configuration")
Suggested-by: Geert Uytterhoeven <geert@linux-m68k.org>
Signed-off-by: Siddharth Vadapalli <s-vadapalli@ti.com>
---
This issue has been reported at:
Link: https://lore.kernel.org/r/CAMuHMdWiXu9OJxH4mRnneC3jhqTEcYXek3kbr7svhJ3cnPPwcw@mail.gmail.com/

 drivers/net/ethernet/ti/am65-cpsw-nuss.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/ethernet/ti/am65-cpsw-nuss.c b/drivers/net/ethernet/ti/am65-cpsw-nuss.c
index 5cac98284184..c696da89962f 100644
--- a/drivers/net/ethernet/ti/am65-cpsw-nuss.c
+++ b/drivers/net/ethernet/ti/am65-cpsw-nuss.c
@@ -1463,6 +1463,8 @@ static int am65_cpsw_init_serdes_phy(struct device *dev, struct device_node *por
 	phy = devm_of_phy_get(dev, port_np, name);
 	if (PTR_ERR(phy) == -ENODEV)
 		return 0;
+	if (IS_ERR(phy))
+		return PTR_ERR(phy);
 
 	/* Serdes PHY exists. Store it. */
 	port->slave.serdes_phy = phy;
-- 
2.25.1

