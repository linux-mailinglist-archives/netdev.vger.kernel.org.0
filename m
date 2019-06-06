Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BCA9C3799B
	for <lists+netdev@lfdr.de>; Thu,  6 Jun 2019 18:31:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729726AbfFFQbW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Jun 2019 12:31:22 -0400
Received: from fllv0015.ext.ti.com ([198.47.19.141]:50170 "EHLO
        fllv0015.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726719AbfFFQbW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Jun 2019 12:31:22 -0400
Received: from lelv0265.itg.ti.com ([10.180.67.224])
        by fllv0015.ext.ti.com (8.15.2/8.15.2) with ESMTP id x56GVCGC108085;
        Thu, 6 Jun 2019 11:31:12 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1559838672;
        bh=PTDnNRZC/L29QrENOY3N0wHK7ufCtG4xEHtYz7D28GU=;
        h=From:To:CC:Subject:Date:In-Reply-To:References;
        b=dy3uhPNutNtocFNc+XovZubyTFV0Oe0+Gxcej6/pkXaRGa10nJDGjqoVCX8+YQHKW
         5g1qVB3HV7YmiGYrzbg9/z2rLUi+IGAItNNzGDb+dZI8TGC8LqbEDYXRe/LpMGPP6+
         hV6MFjdIQT8Y/yFwVJAuwuLvGRpqbNxPw/8BSPlM=
Received: from DFLE112.ent.ti.com (dfle112.ent.ti.com [10.64.6.33])
        by lelv0265.itg.ti.com (8.15.2/8.15.2) with ESMTPS id x56GVCFW006661
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 6 Jun 2019 11:31:12 -0500
Received: from DFLE109.ent.ti.com (10.64.6.30) by DFLE112.ent.ti.com
 (10.64.6.33) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1713.5; Thu, 6 Jun
 2019 11:31:12 -0500
Received: from lelv0326.itg.ti.com (10.180.67.84) by DFLE109.ent.ti.com
 (10.64.6.30) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1713.5 via
 Frontend Transport; Thu, 6 Jun 2019 11:31:12 -0500
Received: from localhost (ileax41-snat.itg.ti.com [10.172.224.153])
        by lelv0326.itg.ti.com (8.15.2/8.15.2) with ESMTP id x56GVB1g052560;
        Thu, 6 Jun 2019 11:31:12 -0500
From:   Grygorii Strashko <grygorii.strashko@ti.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Santosh Shilimkar <ssantosh@kernel.org>,
        Richard Cochran <richardcochran@gmail.com>,
        Rob Herring <robh+dt@kernel.org>
CC:     Sekhar Nori <nsekhar@ti.com>,
        Murali Karicheri <m-karicheri2@ti.com>,
        Wingman Kwok <w-kwok2@ti.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        Grygorii Strashko <grygorii.strashko@ti.com>
Subject: [PATCH net-next v2 02/10] net: ethernet: ti: cpts: use devm_get_clk_from_child
Date:   Thu, 6 Jun 2019 19:30:39 +0300
Message-ID: <20190606163047.31199-3-grygorii.strashko@ti.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190606163047.31199-1-grygorii.strashko@ti.com>
References: <20190606163047.31199-1-grygorii.strashko@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use devm_get_clk_from_child() instead of devm_clk_get() and this way allow
to group CPTS DT properties in sub-node for better code readability and
maintenance. Roll-back to devm_clk_get() if devm_get_clk_from_child()
fails for backward compatibility.

Signed-off-by: Grygorii Strashko <grygorii.strashko@ti.com>
Acked-by: Richard Cochran <richardcochran@gmail.com>
---
 drivers/net/ethernet/ti/cpts.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/ti/cpts.c b/drivers/net/ethernet/ti/cpts.c
index e257018ada71..0e79f9743c19 100644
--- a/drivers/net/ethernet/ti/cpts.c
+++ b/drivers/net/ethernet/ti/cpts.c
@@ -572,9 +572,14 @@ struct cpts *cpts_create(struct device *dev, void __iomem *regs,
 	if (ret)
 		return ERR_PTR(ret);
 
-	cpts->refclk = devm_clk_get(dev, "cpts");
+	cpts->refclk = devm_get_clk_from_child(dev, node, "cpts");
+	if (IS_ERR(cpts->refclk))
+		/* try get clk from dev node for compatibility */
+		cpts->refclk = devm_clk_get(dev, "cpts");
+
 	if (IS_ERR(cpts->refclk)) {
-		dev_err(dev, "Failed to get cpts refclk\n");
+		dev_err(dev, "Failed to get cpts refclk %ld\n",
+			PTR_ERR(cpts->refclk));
 		return ERR_CAST(cpts->refclk);
 	}
 
-- 
2.17.1

