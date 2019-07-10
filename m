Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5C50564040
	for <lists+netdev@lfdr.de>; Wed, 10 Jul 2019 07:05:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726760AbfGJFEx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Jul 2019 01:04:53 -0400
Received: from smtprelay0195.hostedemail.com ([216.40.44.195]:56954 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726392AbfGJFEv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Jul 2019 01:04:51 -0400
Received: from filter.hostedemail.com (clb03-v110.bra.tucows.net [216.40.38.60])
        by smtprelay05.hostedemail.com (Postfix) with ESMTP id CB52F1803A16D;
        Wed, 10 Jul 2019 05:04:49 +0000 (UTC)
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::::::::::::,RULES_HIT:41:355:379:541:800:960:973:982:988:989:1260:1345:1359:1437:1534:1541:1711:1730:1747:1777:1792:2194:2198:2199:2200:2393:2559:2562:3138:3139:3140:3141:3142:3352:3867:3870:4321:4605:5007:6261:8784:9121:10004:10848:11026:11233:11473:11657:11658:11914:12043:12048:12296:12297:12438:12555:12895:13069:13311:13357:14096:14181:14384:14394:14721:21080:21451:21627:30054,0,RBL:23.242.196.136:@perches.com:.lbl8.mailshell.net-62.8.0.180 64.201.201.201,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:neutral,Custom_rules:0:0:0,LFtime:1,LUA_SUMMARY:none
X-HE-Tag: coal43_ccb02173980f
X-Filterd-Recvd-Size: 2914
Received: from joe-laptop.perches.com (cpe-23-242-196-136.socal.res.rr.com [23.242.196.136])
        (Authenticated sender: joe@perches.com)
        by omf06.hostedemail.com (Postfix) with ESMTPA;
        Wed, 10 Jul 2019 05:04:47 +0000 (UTC)
From:   Joe Perches <joe@perches.com>
To:     Andrew Morton <akpm@linux-foundation.org>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Maxime Ripard <maxime.ripard@bootlin.com>,
        Chen-Yu Tsai <wens@csie.org>
Cc:     "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH 08/12] net: stmmac: Fix misuses of GENMASK macro
Date:   Tue,  9 Jul 2019 22:04:21 -0700
Message-Id: <b38b0b67e724cd026709194b68c2be5ee1058c57.1562734889.git.joe@perches.com>
X-Mailer: git-send-email 2.15.0
In-Reply-To: <cover.1562734889.git.joe@perches.com>
References: <cover.1562734889.git.joe@perches.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Arguments are supposed to be ordered high then low.

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/net/ethernet/stmicro/stmmac/descs.h       | 2 +-
 drivers/net/ethernet/stmicro/stmmac/dwmac-sun8i.c | 4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/descs.h b/drivers/net/ethernet/stmicro/stmmac/descs.h
index 10429b05f932..9f0b9a9e63b3 100644
--- a/drivers/net/ethernet/stmicro/stmmac/descs.h
+++ b/drivers/net/ethernet/stmicro/stmmac/descs.h
@@ -123,7 +123,7 @@
 #define	ETDES1_BUFFER2_SIZE_SHIFT	16
 
 /* Extended Receive descriptor definitions */
-#define	ERDES4_IP_PAYLOAD_TYPE_MASK	GENMASK(2, 6)
+#define	ERDES4_IP_PAYLOAD_TYPE_MASK	GENMASK(6, 2)
 #define	ERDES4_IP_HDR_ERR		BIT(3)
 #define	ERDES4_IP_PAYLOAD_ERR		BIT(4)
 #define	ERDES4_IP_CSUM_BYPASSED		BIT(5)
diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac-sun8i.c b/drivers/net/ethernet/stmicro/stmmac/dwmac-sun8i.c
index 6d5cba4075eb..4c5db00c1d18 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac-sun8i.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac-sun8i.c
@@ -192,7 +192,7 @@ static const struct emac_variant emac_variant_h6 = {
 
 /* Used in RX_CTL1*/
 #define EMAC_RX_MD              BIT(1)
-#define EMAC_RX_TH_MASK		GENMASK(4, 5)
+#define EMAC_RX_TH_MASK		GENMASK(5, 4)
 #define EMAC_RX_TH_32		0
 #define EMAC_RX_TH_64		(0x1 << 4)
 #define EMAC_RX_TH_96		(0x2 << 4)
@@ -203,7 +203,7 @@ static const struct emac_variant emac_variant_h6 = {
 /* Used in TX_CTL1*/
 #define EMAC_TX_MD              BIT(1)
 #define EMAC_TX_NEXT_FRM        BIT(2)
-#define EMAC_TX_TH_MASK		GENMASK(8, 10)
+#define EMAC_TX_TH_MASK		GENMASK(10, 8)
 #define EMAC_TX_TH_64		0
 #define EMAC_TX_TH_128		(0x1 << 8)
 #define EMAC_TX_TH_192		(0x2 << 8)
-- 
2.15.0

