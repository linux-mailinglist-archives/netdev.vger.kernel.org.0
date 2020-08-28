Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 248A025620B
	for <lists+netdev@lfdr.de>; Fri, 28 Aug 2020 22:33:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726436AbgH1Udm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Aug 2020 16:33:42 -0400
Received: from fllv0015.ext.ti.com ([198.47.19.141]:39144 "EHLO
        fllv0015.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726033AbgH1Udl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Aug 2020 16:33:41 -0400
Received: from fllv0035.itg.ti.com ([10.64.41.0])
        by fllv0015.ext.ti.com (8.15.2/8.15.2) with ESMTP id 07SKXXP4029943;
        Fri, 28 Aug 2020 15:33:34 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1598646814;
        bh=EV957dVqXwgi4Qk6sYNVR1mRHi86YzzOiCLQ3wQfmGk=;
        h=From:To:CC:Subject:Date;
        b=anwXKXlczXZPKKsHA3SQ8baan66Be5woMdSG7ZS63I8hXHa3WmlD32e3lsmhrRrXT
         +ZNARGwVq3aizuf9fM1pG0ckgArR7YSMcQxk57IPH6G2jIoOEdEp8761QU1AA0prdA
         rW1qFErenthRq6asQqN/mgogrhSe8bK0dKEwFLNc=
Received: from DFLE115.ent.ti.com (dfle115.ent.ti.com [10.64.6.36])
        by fllv0035.itg.ti.com (8.15.2/8.15.2) with ESMTP id 07SKXXu9096410;
        Fri, 28 Aug 2020 15:33:33 -0500
Received: from DFLE104.ent.ti.com (10.64.6.25) by DFLE115.ent.ti.com
 (10.64.6.36) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3; Fri, 28
 Aug 2020 15:33:33 -0500
Received: from lelv0327.itg.ti.com (10.180.67.183) by DFLE104.ent.ti.com
 (10.64.6.25) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3 via
 Frontend Transport; Fri, 28 Aug 2020 15:33:33 -0500
Received: from localhost (ileax41-snat.itg.ti.com [10.172.224.153])
        by lelv0327.itg.ti.com (8.15.2/8.15.2) with ESMTP id 07SKXWE7008196;
        Fri, 28 Aug 2020 15:33:33 -0500
From:   Grygorii Strashko <grygorii.strashko@ti.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, <netdev@vger.kernel.org>
CC:     Sekhar Nori <nsekhar@ti.com>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        Grygorii Strashko <grygorii.strashko@ti.com>
Subject: [PATCH net-next] net: ethernet: ti: am65-cpts: fix i2083 genf (and estf) Reconfiguration Issue
Date:   Fri, 28 Aug 2020 23:33:25 +0300
Message-ID: <20200828203325.29588-1-grygorii.strashko@ti.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The new bit TX_GENF_CLR_EN has been added in AM65x SR2.0 to fix i2083
errata, which can be just set unconditionally for all SoCs.

Signed-off-by: Grygorii Strashko <grygorii.strashko@ti.com>
---
 drivers/net/ethernet/ti/am65-cpts.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/ti/am65-cpts.c b/drivers/net/ethernet/ti/am65-cpts.c
index 365b5b9c6897..75056c14b161 100644
--- a/drivers/net/ethernet/ti/am65-cpts.c
+++ b/drivers/net/ethernet/ti/am65-cpts.c
@@ -83,6 +83,8 @@ struct am65_cpts_regs {
 #define AM65_CPTS_CONTROL_HW8_TS_PUSH_EN	BIT(15)
 #define AM65_CPTS_CONTROL_HW1_TS_PUSH_OFFSET	(8)
 
+#define AM65_CPTS_CONTROL_TX_GENF_CLR_EN	BIT(17)
+
 #define AM65_CPTS_CONTROL_TS_SYNC_SEL_MASK	(0xF)
 #define AM65_CPTS_CONTROL_TS_SYNC_SEL_SHIFT	(28)
 
@@ -986,7 +988,9 @@ struct am65_cpts *am65_cpts_create(struct device *dev, void __iomem *regs,
 
 	am65_cpts_set_add_val(cpts);
 
-	am65_cpts_write32(cpts, AM65_CPTS_CONTROL_EN | AM65_CPTS_CONTROL_64MODE,
+	am65_cpts_write32(cpts, AM65_CPTS_CONTROL_EN |
+			  AM65_CPTS_CONTROL_64MODE |
+			  AM65_CPTS_CONTROL_TX_GENF_CLR_EN,
 			  control);
 	am65_cpts_write32(cpts, AM65_CPTS_INT_ENABLE_TS_PEND_EN, int_enable);
 
-- 
2.17.1

