Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 35E0531B51
	for <lists+netdev@lfdr.de>; Sat,  1 Jun 2019 12:46:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727192AbfFAKqE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 1 Jun 2019 06:46:04 -0400
Received: from lelv0143.ext.ti.com ([198.47.23.248]:43796 "EHLO
        lelv0143.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726089AbfFAKqD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 1 Jun 2019 06:46:03 -0400
Received: from lelv0266.itg.ti.com ([10.180.67.225])
        by lelv0143.ext.ti.com (8.15.2/8.15.2) with ESMTP id x51AjxK0017225;
        Sat, 1 Jun 2019 05:45:59 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1559385959;
        bh=L7uklZmMbV0m9TN5brUsgpv6/7OEksAfjjG7mTgS2po=;
        h=From:To:CC:Subject:Date:In-Reply-To:References;
        b=zUlLODtlwrtkBzEg1UaoQcBZkx1PSOlplIMd92dinK+oFyttTDAESpgBnPHFimpBn
         9wjDPfpSMdqhEwyxVXIuPOapty7euJdaJ8SW9yVNDvOPpoJmNyKb5aCS4oS5gHnjns
         19X8ga1D0laiY53jnEZk1paKpC9urIkpDVper4N0=
Received: from DLEE113.ent.ti.com (dlee113.ent.ti.com [157.170.170.24])
        by lelv0266.itg.ti.com (8.15.2/8.15.2) with ESMTPS id x51Ajwwt022721
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Sat, 1 Jun 2019 05:45:59 -0500
Received: from DLEE101.ent.ti.com (157.170.170.31) by DLEE113.ent.ti.com
 (157.170.170.24) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1713.5; Sat, 1 Jun
 2019 05:45:58 -0500
Received: from fllv0040.itg.ti.com (10.64.41.20) by DLEE101.ent.ti.com
 (157.170.170.31) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1713.5 via
 Frontend Transport; Sat, 1 Jun 2019 05:45:58 -0500
Received: from localhost (ileax41-snat.itg.ti.com [10.172.224.153])
        by fllv0040.itg.ti.com (8.15.2/8.15.2) with ESMTP id x51AjvrX127852;
        Sat, 1 Jun 2019 05:45:58 -0500
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
Subject: [PATCH net-next 02/10] net: ethernet: ti: cpts: use devm_get_clk_from_child
Date:   Sat, 1 Jun 2019 13:45:26 +0300
Message-ID: <20190601104534.25790-3-grygorii.strashko@ti.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190601104534.25790-1-grygorii.strashko@ti.com>
References: <20190601104534.25790-1-grygorii.strashko@ti.com>
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

