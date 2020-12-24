Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 542972E2810
	for <lists+netdev@lfdr.de>; Thu, 24 Dec 2020 17:26:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728463AbgLXQZ4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Dec 2020 11:25:56 -0500
Received: from fllv0015.ext.ti.com ([198.47.19.141]:38056 "EHLO
        fllv0015.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727081AbgLXQZ4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Dec 2020 11:25:56 -0500
Received: from fllv0035.itg.ti.com ([10.64.41.0])
        by fllv0015.ext.ti.com (8.15.2/8.15.2) with ESMTP id 0BOGOFew041071;
        Thu, 24 Dec 2020 10:24:15 -0600
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1608827055;
        bh=WMEUYGFV0NV6CnOTlVaGE190P40OrfNJJimbiz0eDZ0=;
        h=From:To:CC:Subject:Date;
        b=wJxrAGXZnl6XX+i4NYFZeYOHAu7jXcMC7fe2Fhglp7EcFDqPBbs9f6HDkFONXk0jH
         Qr30JSFw+Jl0KDrzJ9Cf/Op/h90SANNrSn6q5HGedA+g7ssW8+uCXN54rSd4GTB/m+
         XT0VlVG1F31ySoN/EhR9/cmxl9y9EGUzA66m27rA=
Received: from DFLE113.ent.ti.com (dfle113.ent.ti.com [10.64.6.34])
        by fllv0035.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 0BOGOFZc106349
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 24 Dec 2020 10:24:15 -0600
Received: from DFLE106.ent.ti.com (10.64.6.27) by DFLE113.ent.ti.com
 (10.64.6.34) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3; Thu, 24
 Dec 2020 10:24:14 -0600
Received: from fllv0040.itg.ti.com (10.64.41.20) by DFLE106.ent.ti.com
 (10.64.6.27) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3 via
 Frontend Transport; Thu, 24 Dec 2020 10:24:14 -0600
Received: from localhost (ileax41-snat.itg.ti.com [10.172.224.153])
        by fllv0040.itg.ti.com (8.15.2/8.15.2) with ESMTP id 0BOGOE1m107382;
        Thu, 24 Dec 2020 10:24:14 -0600
From:   Grygorii Strashko <grygorii.strashko@ti.com>
To:     "David S. Miller" <davem@davemloft.net>, <netdev@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Richard Cochran <richardcochran@gmail.com>
CC:     <linux-kernel@vger.kernel.org>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        Lokesh Vutla <lokeshvutla@ti.com>,
        Grygorii Strashko <grygorii.strashko@ti.com>
Subject: [PATCH net] net: ethernet: ti: cpts: fix ethtool output when no ptp_clock registered
Date:   Thu, 24 Dec 2020 18:24:05 +0200
Message-ID: <20201224162405.28032-1-grygorii.strashko@ti.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The CPTS driver registers PTP PHC clock when first netif is going up and
unregister it when all netif are down. Now ethtool will show:
 - PTP PHC clock index 0 after boot until first netif is up;
 - the last assigned PTP PHC clock index even if PTP PHC clock is not
registered any more after all netifs are down.

This patch ensures that -1 is returned by ethtool when PTP PHC clock is not
registered any more.

Fixes: 8a2c9a5ab4b9 ("net: ethernet: ti: cpts: rework initialization/deinitialization")
Signed-off-by: Grygorii Strashko <grygorii.strashko@ti.com>
---
 drivers/net/ethernet/ti/cpts.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/ethernet/ti/cpts.c b/drivers/net/ethernet/ti/cpts.c
index d1fc7955d422..43222a34cba0 100644
--- a/drivers/net/ethernet/ti/cpts.c
+++ b/drivers/net/ethernet/ti/cpts.c
@@ -599,6 +599,7 @@ void cpts_unregister(struct cpts *cpts)
 
 	ptp_clock_unregister(cpts->clock);
 	cpts->clock = NULL;
+	cpts->phc_index = -1;
 
 	cpts_write32(cpts, 0, int_enable);
 	cpts_write32(cpts, 0, control);
@@ -784,6 +785,7 @@ struct cpts *cpts_create(struct device *dev, void __iomem *regs,
 	cpts->cc.read = cpts_systim_read;
 	cpts->cc.mask = CLOCKSOURCE_MASK(32);
 	cpts->info = cpts_info;
+	cpts->phc_index = -1;
 
 	if (n_ext_ts)
 		cpts->info.n_ext_ts = n_ext_ts;
-- 
2.17.1

