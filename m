Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AE70042FC48
	for <lists+netdev@lfdr.de>; Fri, 15 Oct 2021 21:39:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242759AbhJOTlG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Oct 2021 15:41:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:45220 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242741AbhJOTlE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 15 Oct 2021 15:41:04 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 873F8611EE;
        Fri, 15 Oct 2021 19:38:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1634326737;
        bh=8nRHnhzbv2k4PgXvGVhDy/sBz9JcVynAd3gYKKnwk5E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XiAzB1kkJwvtBThtCQJdo87by8KYj5o/sDyNSJs4dmnXrbCfYLDxPsBwvt9fhs5mx
         DEZ1pRcpdEbw41RobX1Xu96Aji+RvREW7iGHL3uio3LSxsp0Ptcab5g+5zf6SJBnOz
         7FwT+YsR31d7E7qIUlhzRUUE2toPsuEd6kiXqUEoBk8cLN5+quobvUi0Xn8mTGtFZF
         DKvgCnVvSm70DLFFKPCcG0mIFcQQxSVFt/PIcFmgiFs2VZ11toGCN7st0k5O8UMelX
         SOSrOo45mtfbHAgqze3QOZkfwlBPOrQUnqfpEFLXq/OVEThF8Rfx7Jh5IbTTQFURzq
         przYMdssLyc+w==
From:   Jakub Kicinski <kuba@kernel.org>
To:     netdev@vger.kernel.org
Cc:     olteanv@gmail.com, andrew@lunn.ch, idosch@idosch.org,
        f.fainelli@gmail.com, Jakub Kicinski <kuba@kernel.org>,
        qiangqing.zhang@nxp.com
Subject: [RFC net-next 4/6] ethernet: fec: use eth_hw_addr_set_port()
Date:   Fri, 15 Oct 2021 12:38:46 -0700
Message-Id: <20211015193848.779420-5-kuba@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211015193848.779420-1-kuba@kernel.org>
References: <20211015193848.779420-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Commit 406f42fa0d3c ("net-next: When a bond have a massive amount
of VLANs...") introduced a rbtree for faster Ethernet address look
up. To maintain netdev->dev_addr in this tree we need to make all
the writes to it got through appropriate helpers.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
CC: qiangqing.zhang@nxp.com
---
 drivers/net/ethernet/freescale/fec_main.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/freescale/fec_main.c b/drivers/net/ethernet/freescale/fec_main.c
index 47a6fc702ac7..bc5a1a4a34a9 100644
--- a/drivers/net/ethernet/freescale/fec_main.c
+++ b/drivers/net/ethernet/freescale/fec_main.c
@@ -1768,11 +1768,8 @@ static int fec_get_mac(struct net_device *ndev)
 		return 0;
 	}
 
-	eth_hw_addr_set(ndev, iap);
-
 	/* Adjust MAC if using macaddr */
-	if (iap == macaddr)
-		 ndev->dev_addr[ETH_ALEN-1] = macaddr[ETH_ALEN-1] + fep->dev_id;
+	eth_hw_addr_set_port(ndev, iap, iap == macaddr ? fep->dev_id : 0);
 
 	return 0;
 }
-- 
2.31.1

