Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9A101148924
	for <lists+netdev@lfdr.de>; Fri, 24 Jan 2020 15:33:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389011AbgAXOdH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Jan 2020 09:33:07 -0500
Received: from mail.kernel.org ([198.145.29.99]:40644 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404223AbgAXOT4 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 24 Jan 2020 09:19:56 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 93BB420838;
        Fri, 24 Jan 2020 14:19:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579875596;
        bh=8AnTwY5ONooWX0+t+5YCGRCt2ET2oAdWrM/aRE2qLxM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zhMVyPr1hWRQ4WTZ6vbbz+vyBD50oMZqa+p6/APDi4005ZXYE7HDlwrfjjGGs5iC1
         yYd6JjDmnwaqiXEs/reYO+YPANOCprdAYsi3BWXAmktPU46TAkMMMoNfh239i1jPck
         f+uqWlWl40yp4y6DtW2BON7N/MuR+Kqxlscsv0fY=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jose Abreu <Jose.Abreu@synopsys.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 085/107] net: stmmac: selftests: Mark as fail when received VLAN ID != expected
Date:   Fri, 24 Jan 2020 09:17:55 -0500
Message-Id: <20200124141817.28793-85-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200124141817.28793-1-sashal@kernel.org>
References: <20200124141817.28793-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jose Abreu <Jose.Abreu@synopsys.com>

[ Upstream commit d39b68e5a736afa67d2e9cfb158efdd237d99dbd ]

When the VLAN ID does not match the expected one it means filter failed
in HW. Fix it.

Fixes: 94e18382003c ("net: stmmac: selftests: Add selftest for VLAN TX Offload")
Signed-off-by: Jose Abreu <Jose.Abreu@synopsys.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/stmicro/stmmac/stmmac_selftests.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_selftests.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_selftests.c
index 36ef8bee5fcfd..ba03a2d774344 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_selftests.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_selftests.c
@@ -853,8 +853,12 @@ static int stmmac_test_vlan_validate(struct sk_buff *skb,
 	if (tpriv->vlan_id) {
 		if (skb->vlan_proto != htons(proto))
 			goto out;
-		if (skb->vlan_tci != tpriv->vlan_id)
+		if (skb->vlan_tci != tpriv->vlan_id) {
+			/* Means filter did not work. */
+			tpriv->ok = false;
+			complete(&tpriv->comp);
 			goto out;
+		}
 	}
 
 	ehdr = (struct ethhdr *)skb_mac_header(skb);
-- 
2.20.1

