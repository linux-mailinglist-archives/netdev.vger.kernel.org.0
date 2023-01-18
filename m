Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D4EBD6719A3
	for <lists+netdev@lfdr.de>; Wed, 18 Jan 2023 11:51:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230476AbjARKvD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Jan 2023 05:51:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43344 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230146AbjARKse (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Jan 2023 05:48:34 -0500
Received: from fllv0016.ext.ti.com (fllv0016.ext.ti.com [198.47.19.142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DEDA130B09;
        Wed, 18 Jan 2023 01:55:03 -0800 (PST)
Received: from lelv0266.itg.ti.com ([10.180.67.225])
        by fllv0016.ext.ti.com (8.15.2/8.15.2) with ESMTP id 30I9smjW007317;
        Wed, 18 Jan 2023 03:54:48 -0600
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1674035688;
        bh=tOu3X/Y5UqLfqUKfSCarygyAI2ez5qOQZgljlzsN2dM=;
        h=From:To:CC:Subject:Date:In-Reply-To:References;
        b=jpzYhU+MBBKgesP0A+UNyQycaJHVCWcz18zPkwhDIXYFMT+UwboMk9EiND0ReEDGk
         Ky3cJIpJBu0d1grmlmfETUwLbUcxOr06bEDlTJToLoB6S5WKSxensWGFph9ivDYh+T
         zVLRhOt8itllTGw8stZicyAMiypCKgXgTj+3dlcE=
Received: from DLEE113.ent.ti.com (dlee113.ent.ti.com [157.170.170.24])
        by lelv0266.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 30I9sm5u061660
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 18 Jan 2023 03:54:48 -0600
Received: from DLEE112.ent.ti.com (157.170.170.23) by DLEE113.ent.ti.com
 (157.170.170.24) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2507.16; Wed, 18
 Jan 2023 03:54:47 -0600
Received: from lelv0327.itg.ti.com (10.180.67.183) by DLEE112.ent.ti.com
 (157.170.170.23) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2507.16 via
 Frontend Transport; Wed, 18 Jan 2023 03:54:47 -0600
Received: from uda0492258.dhcp.ti.com (ileaxei01-snat.itg.ti.com [10.180.69.5])
        by lelv0327.itg.ti.com (8.15.2/8.15.2) with ESMTP id 30I9se8g107670;
        Wed, 18 Jan 2023 03:54:44 -0600
From:   Siddharth Vadapalli <s-vadapalli@ti.com>
To:     <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <linux@armlinux.org.uk>, <pabeni@redhat.com>, <rogerq@kernel.org>,
        <leon@kernel.org>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <vigneshr@ti.com>,
        <srk@ti.com>, <s-vadapalli@ti.com>
Subject: [PATCH net-next v3 1/2] net: ethernet: ti: am65-cpsw: Delete unreachable error handling code
Date:   Wed, 18 Jan 2023 15:24:38 +0530
Message-ID: <20230118095439.114222-2-s-vadapalli@ti.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230118095439.114222-1-s-vadapalli@ti.com>
References: <20230118095439.114222-1-s-vadapalli@ti.com>
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
---
 drivers/net/ethernet/ti/am65-cpsw-nuss.c | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/drivers/net/ethernet/ti/am65-cpsw-nuss.c b/drivers/net/ethernet/ti/am65-cpsw-nuss.c
index 5cac98284184..7363e01e7579 100644
--- a/drivers/net/ethernet/ti/am65-cpsw-nuss.c
+++ b/drivers/net/ethernet/ti/am65-cpsw-nuss.c
@@ -1935,11 +1935,6 @@ static int am65_cpsw_init_cpts(struct am65_cpsw_common *common)
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

