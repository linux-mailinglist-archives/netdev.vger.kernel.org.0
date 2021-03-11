Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2BDCE3368FA
	for <lists+netdev@lfdr.de>; Thu, 11 Mar 2021 01:37:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231187AbhCKAg6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Mar 2021 19:36:58 -0500
Received: from correo.us.es ([193.147.175.20]:50222 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230144AbhCKAgb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 10 Mar 2021 19:36:31 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id B483012E83B
        for <netdev@vger.kernel.org>; Thu, 11 Mar 2021 01:36:30 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id A14CFDA796
        for <netdev@vger.kernel.org>; Thu, 11 Mar 2021 01:36:30 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 960E1DA73F; Thu, 11 Mar 2021 01:36:30 +0100 (CET)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,URIBL_BLOCKED,USER_IN_WELCOMELIST,USER_IN_WHITELIST
        autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 69138DA73D;
        Thu, 11 Mar 2021 01:36:28 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Thu, 11 Mar 2021 01:36:28 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from localhost.localdomain (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPSA id 336CB42DC6E2;
        Thu, 11 Mar 2021 01:36:28 +0100 (CET)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org,
        Felix Fietkau <nbd@nbd.name>
Subject: [PATCH net-next 23/23] net: ethernet: mtk_eth_soc: fix parsing packets in GDM
Date:   Thu, 11 Mar 2021 01:36:04 +0100
Message-Id: <20210311003604.22199-24-pablo@netfilter.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20210311003604.22199-1-pablo@netfilter.org>
References: <20210311003604.22199-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Virus-Scanned: ClamAV using ClamSMTP
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Felix Fietkau <nbd@nbd.name>

When using DSA, set the special tag in GDM ingress control to allow the MAC
to parse packets properly earlier. This affects rx DMA source port reporting.

Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 drivers/net/ethernet/mediatek/mtk_eth_soc.c | 15 +++++++++------
 drivers/net/ethernet/mediatek/mtk_eth_soc.h |  2 ++
 2 files changed, 11 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/mediatek/mtk_eth_soc.c b/drivers/net/ethernet/mediatek/mtk_eth_soc.c
index 2e6d79b2ff24..0396f0db855f 100644
--- a/drivers/net/ethernet/mediatek/mtk_eth_soc.c
+++ b/drivers/net/ethernet/mediatek/mtk_eth_soc.c
@@ -19,6 +19,7 @@
 #include <linux/interrupt.h>
 #include <linux/pinctrl/devinfo.h>
 #include <linux/phylink.h>
+#include <net/dsa.h>
 
 #include "mtk_eth_soc.h"
 
@@ -1264,13 +1265,12 @@ static int mtk_poll_rx(struct napi_struct *napi, int budget,
 			break;
 
 		/* find out which mac the packet come from. values start at 1 */
-		if (MTK_HAS_CAPS(eth->soc->caps, MTK_SOC_MT7628)) {
+		if (MTK_HAS_CAPS(eth->soc->caps, MTK_SOC_MT7628) ||
+		    (trxd.rxd4 & RX_DMA_SPECIAL_TAG))
 			mac = 0;
-		} else {
-			mac = (trxd.rxd4 >> RX_DMA_FPORT_SHIFT) &
-				RX_DMA_FPORT_MASK;
-			mac--;
-		}
+		else
+			mac = ((trxd.rxd4 >> RX_DMA_FPORT_SHIFT) &
+			       RX_DMA_FPORT_MASK) - 1;
 
 		if (unlikely(mac < 0 || mac >= MTK_MAC_COUNT ||
 			     !eth->netdev[mac]))
@@ -2233,6 +2233,9 @@ static void mtk_gdm_config(struct mtk_eth *eth, u32 config)
 
 		val |= config;
 
+		if (!i && eth->netdev[0] && netdev_uses_dsa(eth->netdev[0]))
+			val |= MTK_GDMA_SPECIAL_TAG;
+
 		mtk_w32(eth, val, MTK_GDMA_FWD_CFG(i));
 	}
 	/* Reset and enable PSE */
diff --git a/drivers/net/ethernet/mediatek/mtk_eth_soc.h b/drivers/net/ethernet/mediatek/mtk_eth_soc.h
index 72757977ccfb..1a6750c08bb9 100644
--- a/drivers/net/ethernet/mediatek/mtk_eth_soc.h
+++ b/drivers/net/ethernet/mediatek/mtk_eth_soc.h
@@ -85,6 +85,7 @@
 
 /* GDM Exgress Control Register */
 #define MTK_GDMA_FWD_CFG(x)	(0x500 + (x * 0x1000))
+#define MTK_GDMA_SPECIAL_TAG	BIT(24)
 #define MTK_GDMA_ICS_EN		BIT(22)
 #define MTK_GDMA_TCS_EN		BIT(21)
 #define MTK_GDMA_UCS_EN		BIT(20)
@@ -315,6 +316,7 @@
 #define RX_DMA_L4_VALID_PDMA	BIT(30)		/* when PDMA is used */
 #define RX_DMA_FPORT_SHIFT	19
 #define RX_DMA_FPORT_MASK	0x7
+#define RX_DMA_SPECIAL_TAG	BIT(22)
 
 /* PHY Indirect Access Control registers */
 #define MTK_PHY_IAC		0x10004
-- 
2.20.1

