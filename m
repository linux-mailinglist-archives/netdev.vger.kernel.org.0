Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7917F28FBA1
	for <lists+netdev@lfdr.de>; Fri, 16 Oct 2020 01:20:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388293AbgJOXTy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Oct 2020 19:19:54 -0400
Received: from fllv0016.ext.ti.com ([198.47.19.142]:44736 "EHLO
        fllv0016.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388229AbgJOXTt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Oct 2020 19:19:49 -0400
Received: from fllv0035.itg.ti.com ([10.64.41.0])
        by fllv0016.ext.ti.com (8.15.2/8.15.2) with ESMTP id 09FNJkeb079951;
        Thu, 15 Oct 2020 18:19:46 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1602803986;
        bh=IcFQiQZum5hWGGwxpKSprsiXp3l5KT0+hNGM5dt8iro=;
        h=From:To:CC:Subject:Date:In-Reply-To:References;
        b=FgFO8FTFgBQgSaNHqcUgH8yiWxBMF7JonepWCT1gRc2wiFMZ64nmIUHpavO8Q+XnR
         r7iSNlgB8ZoRWa8CmGjMFOgrKrZvc5NjDMwTYu7+RbJv204DjoACRuGiaQK4lnqw44
         OCPVf8dE7XigELJlD/7uvt76K5g88MTVO0NkoRsQ=
Received: from DFLE113.ent.ti.com (dfle113.ent.ti.com [10.64.6.34])
        by fllv0035.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 09FNJkrV127420
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 15 Oct 2020 18:19:46 -0500
Received: from DFLE105.ent.ti.com (10.64.6.26) by DFLE113.ent.ti.com
 (10.64.6.34) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3; Thu, 15
 Oct 2020 18:19:45 -0500
Received: from lelv0326.itg.ti.com (10.180.67.84) by DFLE105.ent.ti.com
 (10.64.6.26) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3 via
 Frontend Transport; Thu, 15 Oct 2020 18:19:45 -0500
Received: from localhost (ileax41-snat.itg.ti.com [10.172.224.153])
        by lelv0326.itg.ti.com (8.15.2/8.15.2) with ESMTP id 09FNJiiZ093329;
        Thu, 15 Oct 2020 18:19:45 -0500
From:   Grygorii Strashko <grygorii.strashko@ti.com>
To:     "David S. Miller" <davem@davemloft.net>, <netdev@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Vignesh Raghavendra <vigneshr@ti.com>
CC:     Sekhar Nori <nsekhar@ti.com>, <linux-kernel@vger.kernel.org>,
        <linux-omap@vger.kernel.org>,
        Murali Karicheri <m-karicheri2@ti.com>,
        Grygorii Strashko <grygorii.strashko@ti.com>
Subject: [PATCH net-next v2 3/9] net: ethernet: ti: am65-cpsw: use cppi5_desc_is_tdcm()
Date:   Fri, 16 Oct 2020 02:19:07 +0300
Message-ID: <20201015231913.30280-4-grygorii.strashko@ti.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20201015231913.30280-1-grygorii.strashko@ti.com>
References: <20201015231913.30280-1-grygorii.strashko@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use cppi5_desc_is_tdcm() helper for teardown indicator detection instead of
hard-coded value.

Signed-off-by: Grygorii Strashko <grygorii.strashko@ti.com>
---
 drivers/net/ethernet/ti/am65-cpsw-nuss.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/ti/am65-cpsw-nuss.c b/drivers/net/ethernet/ti/am65-cpsw-nuss.c
index 6cea338df7ad..65c5446e324e 100644
--- a/drivers/net/ethernet/ti/am65-cpsw-nuss.c
+++ b/drivers/net/ethernet/ti/am65-cpsw-nuss.c
@@ -767,7 +767,7 @@ static int am65_cpsw_nuss_rx_packets(struct am65_cpsw_common *common,
 		return ret;
 	}
 
-	if (desc_dma & 0x1) {
+	if (cppi5_desc_is_tdcm(desc_dma)) {
 		dev_dbg(dev, "%s RX tdown flow: %u\n", __func__, flow_idx);
 		return 0;
 	}
@@ -935,7 +935,7 @@ static int am65_cpsw_nuss_tx_compl_packets(struct am65_cpsw_common *common,
 		if (res == -ENODATA)
 			break;
 
-		if (desc_dma & 0x1) {
+		if (cppi5_desc_is_tdcm(desc_dma)) {
 			if (atomic_dec_and_test(&common->tdown_cnt))
 				complete(&common->tdown_complete);
 			break;
-- 
2.17.1

