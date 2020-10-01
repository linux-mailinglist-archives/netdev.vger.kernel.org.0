Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 62A9E27FDD1
	for <lists+netdev@lfdr.de>; Thu,  1 Oct 2020 12:54:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732299AbgJAKyD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Oct 2020 06:54:03 -0400
Received: from fllv0016.ext.ti.com ([198.47.19.142]:34148 "EHLO
        fllv0016.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731131AbgJAKxo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Oct 2020 06:53:44 -0400
Received: from fllv0034.itg.ti.com ([10.64.40.246])
        by fllv0016.ext.ti.com (8.15.2/8.15.2) with ESMTP id 091ArfJE098013;
        Thu, 1 Oct 2020 05:53:41 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1601549621;
        bh=idzDZS3t19L8wRQZKa6Vh6pC95NRUb0c9lKcadtfYiI=;
        h=From:To:CC:Subject:Date:In-Reply-To:References;
        b=QlBMJAg2BpzzS8ZobF6HUul6iL4geeFKkrHT5xNn2EjZyXo83zoBwaIy2jMLMUSIM
         d7aX3bQ6pIlIm8hJflyUxaSG5Iwz0BOAA2IZKNsmmk5J16KmJ/HeNNyjthnkKeHahV
         BNWMX3uvyNWFbAfRCY+XrbOEba510pWjRkmPWv5k=
Received: from DLEE109.ent.ti.com (dlee109.ent.ti.com [157.170.170.41])
        by fllv0034.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 091Arf0Y049910
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 1 Oct 2020 05:53:41 -0500
Received: from DLEE114.ent.ti.com (157.170.170.25) by DLEE109.ent.ti.com
 (157.170.170.41) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3; Thu, 1 Oct
 2020 05:53:40 -0500
Received: from fllv0040.itg.ti.com (10.64.41.20) by DLEE114.ent.ti.com
 (157.170.170.25) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3 via
 Frontend Transport; Thu, 1 Oct 2020 05:53:40 -0500
Received: from localhost (ileax41-snat.itg.ti.com [10.172.224.153])
        by fllv0040.itg.ti.com (8.15.2/8.15.2) with ESMTP id 091ArdwG072524;
        Thu, 1 Oct 2020 05:53:40 -0500
From:   Grygorii Strashko <grygorii.strashko@ti.com>
To:     "David S. Miller" <davem@davemloft.net>, <netdev@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Vignesh Raghavendra <vigneshr@ti.com>
CC:     Sekhar Nori <nsekhar@ti.com>, <linux-kernel@vger.kernel.org>,
        <linux-omap@vger.kernel.org>,
        Murali Karicheri <m-karicheri2@ti.com>,
        Grygorii Strashko <grygorii.strashko@ti.com>
Subject: [PATCH net-next 6/8] net: ethernet: ti: am65-cpsw: keep active if cpts enabled
Date:   Thu, 1 Oct 2020 13:52:56 +0300
Message-ID: <20201001105258.2139-7-grygorii.strashko@ti.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20201001105258.2139-1-grygorii.strashko@ti.com>
References: <20201001105258.2139-1-grygorii.strashko@ti.com>
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

