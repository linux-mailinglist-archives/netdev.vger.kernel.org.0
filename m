Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 12F213F3F2F
	for <lists+netdev@lfdr.de>; Sun, 22 Aug 2021 14:03:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233404AbhHVMDm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 22 Aug 2021 08:03:42 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:43032 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232204AbhHVMDj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 22 Aug 2021 08:03:39 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.1.2/8.16.0.43) with SMTP id 17MB0KTd005798;
        Sun, 22 Aug 2021 05:02:56 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0220; bh=I5P3vu8YnZDt+COy+/Nunc+oa5752Znatvl6jFbBJoo=;
 b=DhuE4wEXDl3Zyn8LoTfEUv7T0L2pkAEBFshBLddLtuHQd1va2qakKkTcxPHxfjQwB8a+
 9jX0xR8/X5GFIfQKXwhQJWO3VK3yTsH1CN2XuPbqGBQOsYGzgIh7UM24k9WGpwHOEnF7
 ZJHd5fPLMLjuQ7MjXADcTEbcOWx6NmDOEaRAiswhyaCqBn137xEM0SYwsm7q1RHFSnKb
 R0DLAwHYD8+BgjIfRDYSIlRoXARqiZ0tTSyg+P+2sZM8lYNsu7ySjZLhBBms9sMYSIIM
 s2x1phz/ydbvmdmkFe0Vtvp3iCrQCsJhmISONgQUKwZlaeKKYB5/YsFmkMA65yAE3DZ2 eA== 
Received: from dc5-exch02.marvell.com ([199.233.59.182])
        by mx0b-0016f401.pphosted.com with ESMTP id 3ak10mtr6f-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Sun, 22 Aug 2021 05:02:56 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.23; Sun, 22 Aug
 2021 05:02:54 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.23 via Frontend
 Transport; Sun, 22 Aug 2021 05:02:54 -0700
Received: from machine421.marvell.com (unknown [10.29.37.2])
        by maili.marvell.com (Postfix) with ESMTP id D15A33F7060;
        Sun, 22 Aug 2021 05:02:52 -0700 (PDT)
From:   Sunil Goutham <sgoutham@marvell.com>
To:     <netdev@vger.kernel.org>, <davem@davemloft.net>, <kuba@kernel.org>
CC:     Geetha sowjanya <gakula@marvell.com>,
        Sunil Goutham <sgoutham@marvell.com>
Subject: [net PATCH 07/10] octeontx2-af: Check capability flag while freeing ipolicer memory
Date:   Sun, 22 Aug 2021 17:32:24 +0530
Message-ID: <1629633747-22061-8-git-send-email-sgoutham@marvell.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1629633747-22061-1-git-send-email-sgoutham@marvell.com>
References: <1629633747-22061-1-git-send-email-sgoutham@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-GUID: -KkQGXWTXiQylYsvZm-2M05XRG1l9yQl
X-Proofpoint-ORIG-GUID: -KkQGXWTXiQylYsvZm-2M05XRG1l9yQl
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.391,FMLib:17.0.607.475
 definitions=2021-08-21_11,2021-08-20_03,2020-04-07_01
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Geetha sowjanya <gakula@marvell.com>

Bandwidth profiles (ipolicer structure)is implemented only on CN10K
platform. But current code try to free the ipolicer memory without
checking the capibility flag leading to driver crash on OCTEONTX2
platform. This patch fixes the issue by add capability flag check.

Fixes: e8e095b3b3700 ("octeontx2-af: cn10k: Bandwidth profiles config support")
Signed-off-by: Geetha sowjanya <gakula@marvell.com>
Signed-off-by: Sunil Goutham <sgoutham@marvell.com>
---
 drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c
index 4bfbbdf..c321950 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c
@@ -25,7 +25,7 @@ static int nix_update_mce_rule(struct rvu *rvu, u16 pcifunc,
 			       int type, bool add);
 static int nix_setup_ipolicers(struct rvu *rvu,
 			       struct nix_hw *nix_hw, int blkaddr);
-static void nix_ipolicer_freemem(struct nix_hw *nix_hw);
+static void nix_ipolicer_freemem(struct rvu *rvu, struct nix_hw *nix_hw);
 static int nix_verify_bandprof(struct nix_cn10k_aq_enq_req *req,
 			       struct nix_hw *nix_hw, u16 pcifunc);
 static int nix_free_all_bandprof(struct rvu *rvu, u16 pcifunc);
@@ -3849,7 +3849,7 @@ static void rvu_nix_block_freemem(struct rvu *rvu, int blkaddr,
 			kfree(txsch->schq.bmap);
 		}
 
-		nix_ipolicer_freemem(nix_hw);
+		nix_ipolicer_freemem(rvu, nix_hw);
 
 		vlan = &nix_hw->txvlan;
 		kfree(vlan->rsrc.bmap);
@@ -4225,11 +4225,14 @@ static int nix_setup_ipolicers(struct rvu *rvu,
 	return 0;
 }
 
-static void nix_ipolicer_freemem(struct nix_hw *nix_hw)
+static void nix_ipolicer_freemem(struct rvu *rvu, struct nix_hw *nix_hw)
 {
 	struct nix_ipolicer *ipolicer;
 	int layer;
 
+	if (!rvu->hw->cap.ipolicer)
+		return;
+
 	for (layer = 0; layer < BAND_PROF_NUM_LAYERS; layer++) {
 		ipolicer = &nix_hw->ipolicer[layer];
 
-- 
2.7.4

