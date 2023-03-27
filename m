Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AFEC26C9F3A
	for <lists+netdev@lfdr.de>; Mon, 27 Mar 2023 11:21:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232680AbjC0JVY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Mar 2023 05:21:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35566 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232587AbjC0JVX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Mar 2023 05:21:23 -0400
Received: from lelv0142.ext.ti.com (lelv0142.ext.ti.com [198.47.23.249])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 98533210D;
        Mon, 27 Mar 2023 02:21:21 -0700 (PDT)
Received: from fllv0035.itg.ti.com ([10.64.41.0])
        by lelv0142.ext.ti.com (8.15.2/8.15.2) with ESMTP id 32R9L7wr076969;
        Mon, 27 Mar 2023 04:21:07 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1679908867;
        bh=sdvdlmSiC/Nqt3Kti2m1Eh1Z5e+JngJyHQGtiDEFhOk=;
        h=From:To:CC:Subject:Date;
        b=mxqkDJ7yjJN5Z9VnEyW6ixilyPBy5Z3Uy4xLEKkFvjRGQjqSdoDX6w8awY0Fy7eaj
         u+McX9EZ9T8xkWmLmKaTwgSgOARABJCBZ5H6nYRWC4TOJBflybmgCyjKYCGm9unL2T
         A4QlF7BDFvZO4Wpsywo4ldObnFV0tBV4ufKnFFlc=
Received: from DLEE115.ent.ti.com (dlee115.ent.ti.com [157.170.170.26])
        by fllv0035.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 32R9L7Ui014557
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Mon, 27 Mar 2023 04:21:07 -0500
Received: from DLEE112.ent.ti.com (157.170.170.23) by DLEE115.ent.ti.com
 (157.170.170.26) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2507.16; Mon, 27
 Mar 2023 04:21:07 -0500
Received: from lelv0326.itg.ti.com (10.180.67.84) by DLEE112.ent.ti.com
 (157.170.170.23) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2507.16 via
 Frontend Transport; Mon, 27 Mar 2023 04:21:07 -0500
Received: from uda0492258.dhcp.ti.com (ileaxei01-snat2.itg.ti.com [10.180.69.6])
        by lelv0326.itg.ti.com (8.15.2/8.15.2) with ESMTP id 32R9L3HY008480;
        Mon, 27 Mar 2023 04:21:04 -0500
From:   Siddharth Vadapalli <s-vadapalli@ti.com>
To:     <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <rogerq@kernel.org>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <srk@ti.com>,
        <s-vadapalli@ti.com>
Subject: [PATCH net-next] net: ethernet: ti: am65-cpsw: enable p0 host port rx_vlan_remap
Date:   Mon, 27 Mar 2023 14:51:03 +0530
Message-ID: <20230327092103.3256118-1-s-vadapalli@ti.com>
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

From: Grygorii Strashko <grygorii.strashko@ti.com>

By default, the tagged ingress packets to the switch from the host port
P0 get internal switch priority assigned equal to the DMA CPPI channel
number they came from, unless CPSW_P0_CONTROL_REG.RX_REMAP_VLAN is enabled.
This causes issues with applying QoS policies and mapping packets on
external port fifos, because the default configuration is vlan_aware and
DMA CPPI channels are shared between all external ports.

Hence enable CPSW_P0_CONTROL_REG.RX_REMAP_VLAN so packet will preserve
internal switch priority assigned following the VLAN(priority) tag no
matter through which DMA CPPI Channels packets enter the switch.

Signed-off-by: Grygorii Strashko <grygorii.strashko@ti.com>
Signed-off-by: Siddharth Vadapalli <s-vadapalli@ti.com>
---
 drivers/net/ethernet/ti/am65-cpsw-nuss.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/ti/am65-cpsw-nuss.c b/drivers/net/ethernet/ti/am65-cpsw-nuss.c
index 9ddb79776c88..907aab7dc89a 100644
--- a/drivers/net/ethernet/ti/am65-cpsw-nuss.c
+++ b/drivers/net/ethernet/ti/am65-cpsw-nuss.c
@@ -86,6 +86,7 @@
 
 /* AM65_CPSW_P0_REG_CTL */
 #define AM65_CPSW_P0_REG_CTL_RX_CHECKSUM_EN	BIT(0)
+#define AM65_CPSW_P0_REG_CTL_RX_REMAP_VLAN	BIT(16)
 
 /* AM65_CPSW_PORT_REG_PRI_CTL */
 #define AM65_CPSW_PORT_REG_PRI_CTL_RX_PTYPE_RROBIN	BIT(8)
@@ -385,8 +386,8 @@ static int am65_cpsw_nuss_common_open(struct am65_cpsw_common *common)
 	/* set base flow_id */
 	writel(common->rx_flow_id_base,
 	       host_p->port_base + AM65_CPSW_PORT0_REG_FLOW_ID_OFFSET);
-	/* en tx crc offload */
-	writel(AM65_CPSW_P0_REG_CTL_RX_CHECKSUM_EN, host_p->port_base + AM65_CPSW_P0_REG_CTL);
+	writel(AM65_CPSW_P0_REG_CTL_RX_CHECKSUM_EN | AM65_CPSW_P0_REG_CTL_RX_REMAP_VLAN,
+	       host_p->port_base + AM65_CPSW_P0_REG_CTL);
 
 	am65_cpsw_nuss_set_p0_ptype(common);
 
-- 
2.25.1

