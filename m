Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E2E6147DF95
	for <lists+netdev@lfdr.de>; Thu, 23 Dec 2021 08:28:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346865AbhLWH2N (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Dec 2021 02:28:13 -0500
Received: from inva020.nxp.com ([92.121.34.13]:53638 "EHLO inva020.nxp.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1346850AbhLWH2K (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 23 Dec 2021 02:28:10 -0500
Received: from inva020.nxp.com (localhost [127.0.0.1])
        by inva020.eu-rdc02.nxp.com (Postfix) with ESMTP id 665601A0425;
        Thu, 23 Dec 2021 08:28:09 +0100 (CET)
Received: from aprdc01srsp001v.ap-rdc01.nxp.com (aprdc01srsp001v.ap-rdc01.nxp.com [165.114.16.16])
        by inva020.eu-rdc02.nxp.com (Postfix) with ESMTP id 2FB831A0410;
        Thu, 23 Dec 2021 08:28:09 +0100 (CET)
Received: from localhost.localdomain (mega.ap.freescale.net [10.192.208.232])
        by aprdc01srsp001v.ap-rdc01.nxp.com (Postfix) with ESMTP id 78937183AD05;
        Thu, 23 Dec 2021 15:28:07 +0800 (+08)
From:   Xiaoliang Yang <xiaoliang.yang_1@nxp.com>
To:     davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     kuba@kernel.org, peppe.cavallaro@st.com,
        alexandre.torgue@foss.st.com, joabreu@synopsys.com,
        Jose.Abreu@synopsys.com, mst@redhat.com, Joao.Pinto@synopsys.com,
        xiaoliang.yang_1@nxp.com
Subject: [PATCH net] net: stmmac: ptp: fix potentially overflowing expression
Date:   Thu, 23 Dec 2021 15:39:28 +0800
Message-Id: <20211223073928.37371-1-xiaoliang.yang_1@nxp.com>
X-Mailer: git-send-email 2.17.1
X-Virus-Scanned: ClamAV using ClamSMTP
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Convert the u32 variable to type u64 in a context where expression of
type u64 is required to avoid potential overflow.

Fixes: e9e3720002f6 ("net: stmmac: ptp: update tas basetime after ptp adjust")
Signed-off-by: Xiaoliang Yang <xiaoliang.yang_1@nxp.com>
---
 drivers/net/ethernet/stmicro/stmmac/stmmac_ptp.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_ptp.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_ptp.c
index 580cc035536b..be9b58b2abf9 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_ptp.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_ptp.c
@@ -102,7 +102,7 @@ static int stmmac_adjust_time(struct ptp_clock_info *ptp, s64 delta)
 		time.tv_nsec = priv->plat->est->btr_reserve[0];
 		time.tv_sec = priv->plat->est->btr_reserve[1];
 		basetime = timespec64_to_ktime(time);
-		cycle_time = priv->plat->est->ctr[1] * NSEC_PER_SEC +
+		cycle_time = (u64)priv->plat->est->ctr[1] * NSEC_PER_SEC +
 			     priv->plat->est->ctr[0];
 		time = stmmac_calc_tas_basetime(basetime,
 						current_time_ns,
-- 
2.17.1

