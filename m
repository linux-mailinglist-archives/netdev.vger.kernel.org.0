Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BAFFE1F83C3
	for <lists+netdev@lfdr.de>; Sat, 13 Jun 2020 16:53:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726455AbgFMOxQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 13 Jun 2020 10:53:16 -0400
Received: from lelv0143.ext.ti.com ([198.47.23.248]:46418 "EHLO
        lelv0143.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726258AbgFMOxP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 13 Jun 2020 10:53:15 -0400
Received: from fllv0034.itg.ti.com ([10.64.40.246])
        by lelv0143.ext.ti.com (8.15.2/8.15.2) with ESMTP id 05DErCMF069643;
        Sat, 13 Jun 2020 09:53:12 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1592059992;
        bh=8De/AOe/EMoDc+bfjvKtDPFHMj8PcrduA+Vt49AOtzs=;
        h=From:To:CC:Subject:Date;
        b=ikFcrtcWIXoH4iLc1VGrho4FbZjeF4K2G8RLquAzj7DhbonL8UZThv9jOOxojrpl/
         VOyHTwNqZRp+ep7/DGHikgKfjLP0ojQIa1hiabZ2a9ns9z5J8QHZNJqvaljEejTZlq
         Kg7s+ECRiXVA54hasPLeFCaKD4qSFXkuYEmJixsQ=
Received: from DLEE109.ent.ti.com (dlee109.ent.ti.com [157.170.170.41])
        by fllv0034.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 05DErB6f087975
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Sat, 13 Jun 2020 09:53:11 -0500
Received: from DLEE100.ent.ti.com (157.170.170.30) by DLEE109.ent.ti.com
 (157.170.170.41) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3; Sat, 13
 Jun 2020 09:53:11 -0500
Received: from lelv0326.itg.ti.com (10.180.67.84) by DLEE100.ent.ti.com
 (157.170.170.30) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3 via
 Frontend Transport; Sat, 13 Jun 2020 09:53:11 -0500
Received: from localhost (ileax41-snat.itg.ti.com [10.172.224.153])
        by lelv0326.itg.ti.com (8.15.2/8.15.2) with ESMTP id 05DErAZg008051;
        Sat, 13 Jun 2020 09:53:11 -0500
From:   Grygorii Strashko <grygorii.strashko@ti.com>
To:     "David S. Miller" <davem@davemloft.net>, <netdev@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>
CC:     Sekhar Nori <nsekhar@ti.com>, <linux-kernel@vger.kernel.org>,
        <linux-omap@vger.kernel.org>,
        Grygorii Strashko <grygorii.strashko@ti.com>
Subject: [PATCH] net: ethernet: ti: am65-cpsw-nuss: fix ale parameters init
Date:   Sat, 13 Jun 2020 17:52:59 +0300
Message-ID: <20200613145259.17044-1-grygorii.strashko@ti.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The ALE parameters structure is created on stack, so it has to be reset
before passing to cpsw_ale_create() to avoid garbage values.

Fixes: 93a76530316a ("net: ethernet: ti: introduce am65x/j721e gigabit eth subsystem driver")
Signed-off-by: Grygorii Strashko <grygorii.strashko@ti.com>
---
 drivers/net/ethernet/ti/am65-cpsw-nuss.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/ti/am65-cpsw-nuss.c b/drivers/net/ethernet/ti/am65-cpsw-nuss.c
index 87a4775ed53a..1492648247d9 100644
--- a/drivers/net/ethernet/ti/am65-cpsw-nuss.c
+++ b/drivers/net/ethernet/ti/am65-cpsw-nuss.c
@@ -1981,7 +1981,7 @@ MODULE_DEVICE_TABLE(of, am65_cpsw_nuss_of_mtable);
 
 static int am65_cpsw_nuss_probe(struct platform_device *pdev)
 {
-	struct cpsw_ale_params ale_params;
+	struct cpsw_ale_params ale_params = { 0 };
 	const struct of_device_id *of_id;
 	struct device *dev = &pdev->dev;
 	struct am65_cpsw_common *common;
-- 
2.17.1

