Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 837AB28FBB3
	for <lists+netdev@lfdr.de>; Fri, 16 Oct 2020 01:21:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389513AbgJOXUt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Oct 2020 19:20:49 -0400
Received: from fllv0015.ext.ti.com ([198.47.19.141]:58720 "EHLO
        fllv0015.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388601AbgJOXUF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Oct 2020 19:20:05 -0400
Received: from lelv0265.itg.ti.com ([10.180.67.224])
        by fllv0015.ext.ti.com (8.15.2/8.15.2) with ESMTP id 09FNK2eS066305;
        Thu, 15 Oct 2020 18:20:02 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1602804002;
        bh=idzDZS3t19L8wRQZKa6Vh6pC95NRUb0c9lKcadtfYiI=;
        h=From:To:CC:Subject:Date:In-Reply-To:References;
        b=JM3vw2PWm+Gyigg23VxTQQBJ2vK/s1bCi0SyuVOjnxSJO2Ees82z1vZuftHEbK9UF
         Jcc7E4XGDjJXjkJdA7/Wt6iGOesXuRlYi64unZ8tID9WD95IT3Eb6azxZO/6PZbSCs
         j27X/d1ClPyDLewg621KCEJYpOXfaCgP3+BLykaw=
Received: from DLEE113.ent.ti.com (dlee113.ent.ti.com [157.170.170.24])
        by lelv0265.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 09FNK2Pd128232
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 15 Oct 2020 18:20:02 -0500
Received: from DLEE102.ent.ti.com (157.170.170.32) by DLEE113.ent.ti.com
 (157.170.170.24) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3; Thu, 15
 Oct 2020 18:20:02 -0500
Received: from lelv0326.itg.ti.com (10.180.67.84) by DLEE102.ent.ti.com
 (157.170.170.32) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3 via
 Frontend Transport; Thu, 15 Oct 2020 18:20:02 -0500
Received: from localhost (ileax41-snat.itg.ti.com [10.172.224.153])
        by lelv0326.itg.ti.com (8.15.2/8.15.2) with ESMTP id 09FNK0MI093496;
        Thu, 15 Oct 2020 18:20:01 -0500
From:   Grygorii Strashko <grygorii.strashko@ti.com>
To:     "David S. Miller" <davem@davemloft.net>, <netdev@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Vignesh Raghavendra <vigneshr@ti.com>
CC:     Sekhar Nori <nsekhar@ti.com>, <linux-kernel@vger.kernel.org>,
        <linux-omap@vger.kernel.org>,
        Murali Karicheri <m-karicheri2@ti.com>,
        Grygorii Strashko <grygorii.strashko@ti.com>
Subject: [PATCH net-next v2 6/9] net: ethernet: ti: am65-cpsw: keep active if cpts enabled
Date:   Fri, 16 Oct 2020 02:19:10 +0300
Message-ID: <20201015231913.30280-7-grygorii.strashko@ti.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20201015231913.30280-1-grygorii.strashko@ti.com>
References: <20201015231913.30280-1-grygorii.strashko@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Some K3 CPSW NUSS instances can lose context after PM runtime ON->OFF->ON
transition depending on integration (including all submodules: CPTS, MDIO,
etc), like J721E Main CPSW (CPSW9G).

In case CPTS is enabled it's initialized during probe and does not expect
to be reset. Hence, keep K3 CPSW active by forbidding PM runtime if CPTS is
enabled.

Signed-off-by: Grygorii Strashko <grygorii.strashko@ti.com>
---
 drivers/net/ethernet/ti/am65-cpsw-nuss.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/net/ethernet/ti/am65-cpsw-nuss.c b/drivers/net/ethernet/ti/am65-cpsw-nuss.c
index fecaf6b8270f..0bc0eec46709 100644
--- a/drivers/net/ethernet/ti/am65-cpsw-nuss.c
+++ b/drivers/net/ethernet/ti/am65-cpsw-nuss.c
@@ -1727,6 +1727,13 @@ static int am65_cpsw_init_cpts(struct am65_cpsw_common *common)
 		return ret;
 	}
 	common->cpts = cpts;
+	/* Forbid PM runtime if CPTS is running.
+	 * K3 CPSWxG modules may completely lose context during ON->OFF
+	 * transitions depending on integration.
+	 * AM65x/J721E MCU CPSW2G: false
+	 * J721E MAIN_CPSW9G: true
+	 */
+	pm_runtime_forbid(dev);
 
 	return 0;
 }
-- 
2.17.1

