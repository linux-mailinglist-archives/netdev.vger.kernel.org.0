Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C61462A0F4E
	for <lists+netdev@lfdr.de>; Fri, 30 Oct 2020 21:17:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727778AbgJ3UHh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Oct 2020 16:07:37 -0400
Received: from fllv0016.ext.ti.com ([198.47.19.142]:37820 "EHLO
        fllv0016.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727763AbgJ3UHe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Oct 2020 16:07:34 -0400
Received: from fllv0035.itg.ti.com ([10.64.41.0])
        by fllv0016.ext.ti.com (8.15.2/8.15.2) with ESMTP id 09UK7Ugt104238;
        Fri, 30 Oct 2020 15:07:30 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1604088450;
        bh=NhYrkrAAVfnUAvUpx3N5r5YYyG6HdbCgjonL1dI5jO0=;
        h=From:To:CC:Subject:Date:In-Reply-To:References;
        b=WTVjZzmE367lDb44dEQoCFBuEKPvWzXYZl2EAFmIWbdrmzrBUwA+/EivdgeNWwbO3
         tpd8dzD+tAmubVmlx+1rE4HcnG8UKtlxQMsowI9IRf/9UtgPPYwQvTmaa5qlBMyOoW
         YuiromoDaYlzR4koQ6eeUH9ubeSYfSHMdAnNei1I=
Received: from DFLE112.ent.ti.com (dfle112.ent.ti.com [10.64.6.33])
        by fllv0035.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 09UK7Ufe028567
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Fri, 30 Oct 2020 15:07:30 -0500
Received: from DFLE108.ent.ti.com (10.64.6.29) by DFLE112.ent.ti.com
 (10.64.6.33) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3; Fri, 30
 Oct 2020 15:07:29 -0500
Received: from fllv0039.itg.ti.com (10.64.41.19) by DFLE108.ent.ti.com
 (10.64.6.29) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3 via
 Frontend Transport; Fri, 30 Oct 2020 15:07:29 -0500
Received: from localhost (ileax41-snat.itg.ti.com [10.172.224.153])
        by fllv0039.itg.ti.com (8.15.2/8.15.2) with ESMTP id 09UK7SGR028929;
        Fri, 30 Oct 2020 15:07:29 -0500
From:   Grygorii Strashko <grygorii.strashko@ti.com>
To:     "David S. Miller" <davem@davemloft.net>, <netdev@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Vignesh Raghavendra <vigneshr@ti.com>
CC:     Sekhar Nori <nsekhar@ti.com>, <linux-kernel@vger.kernel.org>,
        <linux-omap@vger.kernel.org>,
        "Reviewed-by : Jesse Brandeburg" <jesse.brandeburg@intel.com>,
        Grygorii Strashko <grygorii.strashko@ti.com>
Subject: [PATCH net-next v3 06/10] net: ethernet: ti: am65-cpsw: keep active if cpts enabled
Date:   Fri, 30 Oct 2020 22:07:03 +0200
Message-ID: <20201030200707.24294-7-grygorii.strashko@ti.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20201030200707.24294-1-grygorii.strashko@ti.com>
References: <20201030200707.24294-1-grygorii.strashko@ti.com>
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
Reviewed-by: Jesse Brandeburg <jesse.brandeburg@intel.com>
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

