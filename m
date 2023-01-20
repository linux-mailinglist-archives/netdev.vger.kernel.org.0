Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 79A91674DC6
	for <lists+netdev@lfdr.de>; Fri, 20 Jan 2023 08:08:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229916AbjATHID (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Jan 2023 02:08:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50744 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229445AbjATHIB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Jan 2023 02:08:01 -0500
Received: from lelv0142.ext.ti.com (lelv0142.ext.ti.com [198.47.23.249])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C42014B4AE;
        Thu, 19 Jan 2023 23:08:00 -0800 (PST)
Received: from lelv0266.itg.ti.com ([10.180.67.225])
        by lelv0142.ext.ti.com (8.15.2/8.15.2) with ESMTP id 30K77e6x077617;
        Fri, 20 Jan 2023 01:07:40 -0600
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1674198460;
        bh=OOzT1Mp3XNFiQ42/GA8TLVDZzspYURWWdGE280SVUCY=;
        h=From:To:CC:Subject:Date:In-Reply-To:References;
        b=oFou69RRhzs99UCNzE7e1I8+3+FwOQTPbf6iGDkbUQiXG5PHHNz+GgcdL1R7d7sbV
         IXqvh0o2PCIdwre82oWh6rly9Z2CFRqMwbhV1wMssXOeAKiwNg4a4V/VkagecaheUV
         cKeB2+TS43OX46Bh5dLzKP2XkgkKAFsdfpzm1r4I=
Received: from DFLE112.ent.ti.com (dfle112.ent.ti.com [10.64.6.33])
        by lelv0266.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 30K77ev5042357
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Fri, 20 Jan 2023 01:07:40 -0600
Received: from DFLE106.ent.ti.com (10.64.6.27) by DFLE112.ent.ti.com
 (10.64.6.33) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2507.16; Fri, 20
 Jan 2023 01:07:40 -0600
Received: from fllv0040.itg.ti.com (10.64.41.20) by DFLE106.ent.ti.com
 (10.64.6.27) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2507.16 via
 Frontend Transport; Fri, 20 Jan 2023 01:07:40 -0600
Received: from uda0492258.dhcp.ti.com (ileaxei01-snat.itg.ti.com [10.180.69.5])
        by fllv0040.itg.ti.com (8.15.2/8.15.2) with ESMTP id 30K77VSq074203;
        Fri, 20 Jan 2023 01:07:36 -0600
From:   Siddharth Vadapalli <s-vadapalli@ti.com>
To:     <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <linux@armlinux.org.uk>, <pabeni@redhat.com>, <rogerq@kernel.org>,
        <leon@kernel.org>
CC:     <leonro@nvidia.com>, <anthony.l.nguyen@intel.com>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <vigneshr@ti.com>,
        <srk@ti.com>, <s-vadapalli@ti.com>
Subject: [PATCH net-next v5 1/2] net: ethernet: ti: am65-cpsw: Delete unreachable error handling code
Date:   Fri, 20 Jan 2023 12:37:30 +0530
Message-ID: <20230120070731.383729-2-s-vadapalli@ti.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230120070731.383729-1-s-vadapalli@ti.com>
References: <20230120070731.383729-1-s-vadapalli@ti.com>
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

The am65_cpts_create() function returns -EOPNOTSUPP only when the config
"CONFIG_TI_K3_AM65_CPTS" is disabled. Also, in the am65_cpsw_init_cpts()
function, am65_cpts_create() can only be invoked if the config
"CONFIG_TI_K3_AM65_CPTS" is enabled. Thus, the error handling code for the
case in which the return value of am65_cpts_create() is -EOPNOTSUPP, is
unreachable. Hence delete it.

Reported-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Siddharth Vadapalli <s-vadapalli@ti.com>
Reviewed-by: Leon Romanovsky <leonro@nvidia.com>
Reviewed-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Reviewed-by: Roger Quadros <rogerq@kernel.org>
---
 drivers/net/ethernet/ti/am65-cpsw-nuss.c | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/drivers/net/ethernet/ti/am65-cpsw-nuss.c b/drivers/net/ethernet/ti/am65-cpsw-nuss.c
index c696da89962f..fde4800cf81a 100644
--- a/drivers/net/ethernet/ti/am65-cpsw-nuss.c
+++ b/drivers/net/ethernet/ti/am65-cpsw-nuss.c
@@ -1937,11 +1937,6 @@ static int am65_cpsw_init_cpts(struct am65_cpsw_common *common)
 		int ret = PTR_ERR(cpts);
 
 		of_node_put(node);
-		if (ret == -EOPNOTSUPP) {
-			dev_info(dev, "cpts disabled\n");
-			return 0;
-		}
-
 		dev_err(dev, "cpts create err %d\n", ret);
 		return ret;
 	}
-- 
2.25.1

