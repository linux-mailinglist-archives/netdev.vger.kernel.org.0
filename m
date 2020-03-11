Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4C673180E97
	for <lists+netdev@lfdr.de>; Wed, 11 Mar 2020 04:36:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728116AbgCKDgW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Mar 2020 23:36:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:60600 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727659AbgCKDgW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 10 Mar 2020 23:36:22 -0400
Received: from kicinski-fedora-PC1C0HJN.thefacebook.com (unknown [163.114.132.128])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9BE1220578;
        Wed, 11 Mar 2020 03:36:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583897781;
        bh=kOUIHG6Oz9r0NrA8v3LizmsCu3jRRcrgg1f4BG3kjgo=;
        h=From:To:Cc:Subject:Date:From;
        b=IA1YAHfe4ZFzpOpipAuOe9jRYvH+Co77s9NbY1RiNH8zSLahgveV9fUmVo33auiqn
         whQgzlqhmnAEj0yUXG9X6U/r5XGZVJGvSOrIKsEl4gXvMotJ1SsfALUnwqwdXhWbbF
         cKPm2vZ9coLx1r1xIpRGCCFX/ocAzco7h3t97qVs=
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, fugang.duan@nxp.com, frank.li@nxp.com,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net] net: fec: validate the new settings in fec_enet_set_coalesce()
Date:   Tue, 10 Mar 2020 20:36:16 -0700
Message-Id: <20200311033616.2103499-1-kuba@kernel.org>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

fec_enet_set_coalesce() validates the previously set params
and if they are within range proceeds to apply the new ones.
The new ones, however, are not validated. This seems backwards,
probably a copy-paste error?

Compile tested only.

Fixes: d851b47b22fc ("net: fec: add interrupt coalescence feature support")
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 drivers/net/ethernet/freescale/fec_main.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/freescale/fec_main.c b/drivers/net/ethernet/freescale/fec_main.c
index 4432a59904c7..23c5fef2f1ad 100644
--- a/drivers/net/ethernet/freescale/fec_main.c
+++ b/drivers/net/ethernet/freescale/fec_main.c
@@ -2529,15 +2529,15 @@ fec_enet_set_coalesce(struct net_device *ndev, struct ethtool_coalesce *ec)
 		return -EINVAL;
 	}
 
-	cycle = fec_enet_us_to_itr_clock(ndev, fep->rx_time_itr);
+	cycle = fec_enet_us_to_itr_clock(ndev, ec->rx_coalesce_usecs);
 	if (cycle > 0xFFFF) {
 		dev_err(dev, "Rx coalesced usec exceed hardware limitation\n");
 		return -EINVAL;
 	}
 
-	cycle = fec_enet_us_to_itr_clock(ndev, fep->tx_time_itr);
+	cycle = fec_enet_us_to_itr_clock(ndev, ec->tx_coalesce_usecs);
 	if (cycle > 0xFFFF) {
-		dev_err(dev, "Rx coalesced usec exceed hardware limitation\n");
+		dev_err(dev, "Tx coalesced usec exceed hardware limitation\n");
 		return -EINVAL;
 	}
 
-- 
2.24.1

