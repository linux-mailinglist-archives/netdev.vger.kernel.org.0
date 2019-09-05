Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4EEE1AA710
	for <lists+netdev@lfdr.de>; Thu,  5 Sep 2019 17:11:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388563AbfIEPLj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Sep 2019 11:11:39 -0400
Received: from kirsty.vergenet.net ([202.4.237.240]:49004 "EHLO
        kirsty.vergenet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388524AbfIEPLh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Sep 2019 11:11:37 -0400
Received: from reginn.horms.nl (watermunt.horms.nl [80.127.179.77])
        by kirsty.vergenet.net (Postfix) with ESMTPA id 546FA25B830;
        Fri,  6 Sep 2019 01:11:28 +1000 (AEST)
Received: by reginn.horms.nl (Postfix, from userid 7100)
        id ECEC3940E38; Thu,  5 Sep 2019 17:11:25 +0200 (CEST)
From:   Simon Horman <horms+renesas@verge.net.au>
To:     David Miller <davem@davemloft.net>,
        Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Cc:     Magnus Damm <magnus.damm@gmail.com>, netdev@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org,
        Simon Horman <horms+renesas@verge.net.au>
Subject: [PATCH net-next v2 3/4] ravb: remove undocumented endianness selection
Date:   Thu,  5 Sep 2019 17:10:58 +0200
Message-Id: <20190905151059.26794-4-horms+renesas@verge.net.au>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20190905151059.26794-1-horms+renesas@verge.net.au>
References: <20190905151059.26794-1-horms+renesas@verge.net.au>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch removes the use of the undocumented BOC bit of the CCC register.

Current documentation for EtherAVB (ravb) describes the offset of what the
driver uses as the BOC bit as reserved and that only a value of 0 should be
written. After some internal investigation with Renesas it remains unclear
why this driver accesses these fields but regardless of what the historical
reasons are the current code is considered incorrect.

Based on work by Kazuya Mizuguchi <kazuya.mizuguchi.ks@renesas.com>

Signed-off-by: Simon Horman <horms+renesas@verge.net.au>
---
v2
* New patch broken out of larger patch
---
 drivers/net/ethernet/renesas/ravb.h      | 1 -
 drivers/net/ethernet/renesas/ravb_main.c | 6 ------
 2 files changed, 7 deletions(-)

diff --git a/drivers/net/ethernet/renesas/ravb.h b/drivers/net/ethernet/renesas/ravb.h
index 70eeceb7f8ae..bdb051f04b0c 100644
--- a/drivers/net/ethernet/renesas/ravb.h
+++ b/drivers/net/ethernet/renesas/ravb.h
@@ -216,7 +216,6 @@ enum CCC_BIT {
 	CCC_CSEL_HPB	= 0x00010000,
 	CCC_CSEL_ETH_TX	= 0x00020000,
 	CCC_CSEL_GMII_REF = 0x00030000,
-	CCC_BOC		= 0x00100000,	/* Undocumented? */
 	CCC_LBME	= 0x01000000,
 };
 
diff --git a/drivers/net/ethernet/renesas/ravb_main.c b/drivers/net/ethernet/renesas/ravb_main.c
index 4d1f274cded0..b538cc6fdbb7 100644
--- a/drivers/net/ethernet/renesas/ravb_main.c
+++ b/drivers/net/ethernet/renesas/ravb_main.c
@@ -447,12 +447,6 @@ static int ravb_dmac_init(struct net_device *ndev)
 	ravb_ring_format(ndev, RAVB_BE);
 	ravb_ring_format(ndev, RAVB_NC);
 
-#if defined(__LITTLE_ENDIAN)
-	ravb_modify(ndev, CCC, CCC_BOC, 0);
-#else
-	ravb_modify(ndev, CCC, CCC_BOC, CCC_BOC);
-#endif
-
 	/* Set AVB RX */
 	ravb_write(ndev,
 		   RCR_EFFS | RCR_ENCF | RCR_ETS0 | RCR_ESF | 0x18000000, RCR);
-- 
2.11.0

