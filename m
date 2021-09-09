Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D4CE9404CD0
	for <lists+netdev@lfdr.de>; Thu,  9 Sep 2021 14:01:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245117AbhIIL56 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Sep 2021 07:57:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:34210 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242942AbhIILzz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 9 Sep 2021 07:55:55 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 83933613D3;
        Thu,  9 Sep 2021 11:45:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631187912;
        bh=MNLpn/2d3tHWUsZC33jZV7R7KdgQEy148rGTCp/5GTg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MNRc8QLiivGOwKM9Mbrp6l2PMfpnc9UB+nJRiIhojJ8PmI9qmuz+LEGqmeGJm+2dn
         znjr3Svw/IU9FbeaLyJTAIs15Fr4/WkcOPRG+ZTpXYCU3X2fJFdZ1HRsVBOtmG+uk5
         Js1+URzFBVZyPe+9+dCo28YeixONEhv/yCeNZCsQve3AS3HvvPV6FlAImBeTJzMEOB
         OZhRk3ot4bTGWlNXoF6CSVsh6Q6WtQlJkMhHRAAs2W5zMJRocVlEU4L43VtUA2jImO
         Qhg78q0mr0j3Vv/7A+wQGBkSI7eKI0NTCeL321olYlqKgWhlfbA4Piln5YhZSTpBCz
         v23jRKZ88THLg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Subbaraya Sundeep <sbhatta@marvell.com>,
        Hariprasad Kelam <hkelam@marvell.com>,
        Sunil Goutham <sgoutham@marvell.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.14 188/252] octeontx2-pf: Fix NIX1_RX interface backpressure
Date:   Thu,  9 Sep 2021 07:40:02 -0400
Message-Id: <20210909114106.141462-188-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210909114106.141462-1-sashal@kernel.org>
References: <20210909114106.141462-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Subbaraya Sundeep <sbhatta@marvell.com>

[ Upstream commit e8fb4df1f5d84bc08dd4f4827821a851d2eab241 ]

'bp_ena' in Aura context is NIX block index, setting it
zero will always backpressure NIX0 block, even if NIXLF
belongs to NIX1. Hence fix this by setting it appropriately
based on NIX block address.

Signed-off-by: Subbaraya Sundeep <sbhatta@marvell.com>
Signed-off-by: Hariprasad Kelam <hkelam@marvell.com>
Signed-off-by: Sunil Goutham <sgoutham@marvell.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../ethernet/marvell/octeontx2/nic/otx2_common.c  | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c
index 70fcc1fd962f..211200879b3e 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c
@@ -1190,7 +1190,22 @@ static int otx2_aura_init(struct otx2_nic *pfvf, int aura_id,
 	/* Enable backpressure for RQ aura */
 	if (aura_id < pfvf->hw.rqpool_cnt && !is_otx2_lbkvf(pfvf->pdev)) {
 		aq->aura.bp_ena = 0;
+		/* If NIX1 LF is attached then specify NIX1_RX.
+		 *
+		 * Below NPA_AURA_S[BP_ENA] is set according to the
+		 * NPA_BPINTF_E enumeration given as:
+		 * 0x0 + a*0x1 where 'a' is 0 for NIX0_RX and 1 for NIX1_RX so
+		 * NIX0_RX is 0x0 + 0*0x1 = 0
+		 * NIX1_RX is 0x0 + 1*0x1 = 1
+		 * But in HRM it is given that
+		 * "NPA_AURA_S[BP_ENA](w1[33:32]) - Enable aura backpressure to
+		 * NIX-RX based on [BP] level. One bit per NIX-RX; index
+		 * enumerated by NPA_BPINTF_E."
+		 */
+		if (pfvf->nix_blkaddr == BLKADDR_NIX1)
+			aq->aura.bp_ena = 1;
 		aq->aura.nix0_bpid = pfvf->bpid[0];
+
 		/* Set backpressure level for RQ's Aura */
 		aq->aura.bp = RQ_BP_LVL_AURA;
 	}
-- 
2.30.2

