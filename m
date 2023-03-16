Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7B2786BCB88
	for <lists+netdev@lfdr.de>; Thu, 16 Mar 2023 10:53:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230365AbjCPJxz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Mar 2023 05:53:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58330 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230261AbjCPJxy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Mar 2023 05:53:54 -0400
Received: from lelv0143.ext.ti.com (lelv0143.ext.ti.com [198.47.23.248])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 306E675A5F;
        Thu, 16 Mar 2023 02:53:34 -0700 (PDT)
Received: from lelv0265.itg.ti.com ([10.180.67.224])
        by lelv0143.ext.ti.com (8.15.2/8.15.2) with ESMTP id 32G9qbdP053093;
        Thu, 16 Mar 2023 04:52:37 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1678960357;
        bh=I9rSahEVT2ct0XOCO8UbPzMDG6ZtzGFPIo7DVpj8w88=;
        h=From:To:CC:Subject:Date;
        b=clLw5U724F266KMc07irObynVoVvG9nZOKn5JbnG1qa5E1NhELVI9zdZWCExJNVjW
         OiBf5pdFJFLYT+yTy3+dZTpKiP3ZgNgaR+bOkgcZWT7Pq1s6dIhMT7RpWigiNEk8se
         uTSxggfRApLtvoIN3O1X3peOao1gqf6Ce92bmn+Q=
Received: from DFLE107.ent.ti.com (dfle107.ent.ti.com [10.64.6.28])
        by lelv0265.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 32G9qa7R017613
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 16 Mar 2023 04:52:36 -0500
Received: from DFLE112.ent.ti.com (10.64.6.33) by DFLE107.ent.ti.com
 (10.64.6.28) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2507.16; Thu, 16
 Mar 2023 04:52:36 -0500
Received: from fllv0039.itg.ti.com (10.64.41.19) by DFLE112.ent.ti.com
 (10.64.6.33) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2507.16 via
 Frontend Transport; Thu, 16 Mar 2023 04:52:36 -0500
Received: from uda0492258.dhcp.ti.com (ileaxei01-snat2.itg.ti.com [10.180.69.6])
        by fllv0039.itg.ti.com (8.15.2/8.15.2) with ESMTP id 32G9qWp3024896;
        Thu, 16 Mar 2023 04:52:33 -0500
From:   Siddharth Vadapalli <s-vadapalli@ti.com>
To:     <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <rogerq@kernel.org>,
        <jacob.e.keller@intel.com>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <srk@ti.com>,
        <s-vadapalli@ti.com>
Subject: [PATCH net-next] net: ethernet: ti: am65-cpts: reset pps genf adj settings on enable
Date:   Thu, 16 Mar 2023 15:22:32 +0530
Message-ID: <20230316095232.2002680-1-s-vadapalli@ti.com>
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

From: Grygorii Strashko <grygorii.strashko@ti.com>

The CPTS PPS GENf adjustment settings are invalid after it has been
disabled for a while, so reset them.

Fixes: eb9233ce6751 ("net: ethernet: ti: am65-cpts: adjust pps following ptp changes")
Signed-off-by: Grygorii Strashko <grygorii.strashko@ti.com>
Signed-off-by: Siddharth Vadapalli <s-vadapalli@ti.com>
---
 drivers/net/ethernet/ti/am65-cpts.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/ethernet/ti/am65-cpts.c b/drivers/net/ethernet/ti/am65-cpts.c
index 16ee9c29cb35..8caf85acbb6a 100644
--- a/drivers/net/ethernet/ti/am65-cpts.c
+++ b/drivers/net/ethernet/ti/am65-cpts.c
@@ -636,6 +636,10 @@ static void am65_cpts_perout_enable_hw(struct am65_cpts *cpts,
 		val = lower_32_bits(cycles);
 		am65_cpts_write32(cpts, val, genf[req->index].length);
 
+		am65_cpts_write32(cpts, 0, genf[req->index].control);
+		am65_cpts_write32(cpts, 0, genf[req->index].ppm_hi);
+		am65_cpts_write32(cpts, 0, genf[req->index].ppm_low);
+
 		cpts->genf_enable |= BIT(req->index);
 	} else {
 		am65_cpts_write32(cpts, 0, genf[req->index].length);
-- 
2.25.1

