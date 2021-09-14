Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 075D040BA21
	for <lists+netdev@lfdr.de>; Tue, 14 Sep 2021 23:21:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234802AbhINVWh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Sep 2021 17:22:37 -0400
Received: from mx3.wp.pl ([212.77.101.9]:16944 "EHLO mx3.wp.pl"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234376AbhINVWf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 14 Sep 2021 17:22:35 -0400
Received: (wp-smtpd smtp.wp.pl 9876 invoked from network); 14 Sep 2021 23:21:15 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=wp.pl; s=1024a;
          t=1631654475; bh=W/NPuoEczw/1+slCOS8Gu5B0QOgyM1rf9FWm8bZsl6Q=;
          h=From:To:Subject;
          b=r5vvkhpL++H3Pe/B8r48RDJ0oMI31s8xK2Ikj9ljq7arIoLwF4jYpQEf57mNKQEc2
           q8Qeo7wx3CVdOTiKijJduDxW7dgbnSQIpKG3bdp/qzuMPMaboshw+aGWKmyI3EHCNQ
           fAgXpAB8QhSyVWncvvInxKtPQ0mkhwGKMRWiXtKU=
Received: from 46.204.52.243.nat.umts.dynamic.t-mobile.pl (HELO LAPTOP-OLEK.Free) (olek2@wp.pl@[46.204.52.243])
          (envelope-sender <olek2@wp.pl>)
          by smtp.wp.pl (WP-SMTPD) with ECDHE-RSA-AES256-GCM-SHA384 encrypted SMTP
          for <john@phrozen.org>; 14 Sep 2021 23:21:15 +0200
From:   Aleksander Jan Bajkowski <olek2@wp.pl>
To:     john@phrozen.org, tsbogend@alpha.franken.de, olek2@wp.pl,
        maz@kernel.org, ralf@linux-mips.org, ralph.hempel@lantiq.com,
        davem@davemloft.net, kuba@kernel.org, robh+dt@kernel.org,
        hauke@hauke-m.de, dev@kresin.me, arnd@arndb.de, jgg@ziepe.ca,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-mips@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next 3/8] MIPS: lantiq: dma: fix burst length for DEU
Date:   Tue, 14 Sep 2021 23:21:00 +0200
Message-Id: <20210914212105.76186-3-olek2@wp.pl>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210914212105.76186-1-olek2@wp.pl>
References: <20210914212105.76186-1-olek2@wp.pl>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-WP-MailID: 6de83637f0ab21c13dc811727efd7217
X-WP-AV: skaner antywirusowy Poczty Wirtualnej Polski
X-WP-SPAM: NO 0000000 [cYNU]                               
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The current definition of 2W burst length is invalid.
This patch fixes it. Current downstream DEU driver doesn't
use DMA. An incorrect burst length value doesn't cause any
errors. This patch also adds other burst length values.

Fixes: dfec1a827d2b ("MIPS: Lantiq: Add DMA support")
Signed-off-by: Aleksander Jan Bajkowski <olek2@wp.pl>
---
 arch/mips/lantiq/xway/dma.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/arch/mips/lantiq/xway/dma.c b/arch/mips/lantiq/xway/dma.c
index 364ab39eb8a4..53fcc672a294 100644
--- a/arch/mips/lantiq/xway/dma.c
+++ b/arch/mips/lantiq/xway/dma.c
@@ -41,7 +41,11 @@
 #define DMA_IRQ_ACK		0x7e		/* IRQ status register */
 #define DMA_POLL		BIT(31)		/* turn on channel polling */
 #define DMA_CLK_DIV4		BIT(6)		/* polling clock divider */
-#define DMA_2W_BURST		BIT(1)		/* 2 word burst length */
+#define DMA_PCTRL_2W_BURST	0x1		/* 2 word burst length */
+#define DMA_PCTRL_4W_BURST	0x2		/* 4 word burst length */
+#define DMA_PCTRL_8W_BURST	0x3		/* 8 word burst length */
+#define DMA_TX_BURST_SHIFT	4		/* tx burst shift */
+#define DMA_RX_BURST_SHIFT	2		/* rx burst shift */
 #define DMA_ETOP_ENDIANNESS	(0xf << 8) /* endianness swap etop channels */
 #define DMA_WEIGHT	(BIT(17) | BIT(16))	/* default channel wheight */
 
@@ -192,7 +196,8 @@ ltq_dma_init_port(int p)
 		break;
 
 	case DMA_PORT_DEU:
-		ltq_dma_w32((DMA_2W_BURST << 4) | (DMA_2W_BURST << 2),
+		ltq_dma_w32((DMA_PCTRL_2W_BURST << DMA_TX_BURST_SHIFT) |
+			(DMA_PCTRL_2W_BURST << DMA_RX_BURST_SHIFT),
 			LTQ_DMA_PCTRL);
 		break;
 
-- 
2.30.2

