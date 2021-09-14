Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6186C40BA1D
	for <lists+netdev@lfdr.de>; Tue, 14 Sep 2021 23:21:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234496AbhINVWe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Sep 2021 17:22:34 -0400
Received: from mx3.wp.pl ([212.77.101.10]:11351 "EHLO mx3.wp.pl"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232047AbhINVWa (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 14 Sep 2021 17:22:30 -0400
Received: (wp-smtpd smtp.wp.pl 5375 invoked from network); 14 Sep 2021 23:21:07 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=wp.pl; s=1024a;
          t=1631654468; bh=tAPSHYLfJCfHanCPetkA371bKGzel09qbwJJnHLD89E=;
          h=From:To:Subject;
          b=kNSmpwIKQBuL5uP3J961AIFtCQZmZMcaemQD9pjMSkQ4ffQg8b05AUfEA2mJ13shm
           0Xrxn/F28GhH22gMt8ThfN2j6Gki/R5voEro/DqU2FAj/tiCnu/zhekH1ytxekdCM7
           KQWBs+6ud5Td4zFYJirOP6j5xyvHmzHtfeZsYqIQ=
Received: from 46.204.52.243.nat.umts.dynamic.t-mobile.pl (HELO LAPTOP-OLEK.Free) (olek2@wp.pl@[46.204.52.243])
          (envelope-sender <olek2@wp.pl>)
          by smtp.wp.pl (WP-SMTPD) with ECDHE-RSA-AES256-GCM-SHA384 encrypted SMTP
          for <john@phrozen.org>; 14 Sep 2021 23:21:07 +0200
From:   Aleksander Jan Bajkowski <olek2@wp.pl>
To:     john@phrozen.org, tsbogend@alpha.franken.de, olek2@wp.pl,
        maz@kernel.org, ralf@linux-mips.org, ralph.hempel@lantiq.com,
        davem@davemloft.net, kuba@kernel.org, robh+dt@kernel.org,
        hauke@hauke-m.de, dev@kresin.me, arnd@arndb.de, jgg@ziepe.ca,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-mips@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next 1/8] MIPS: lantiq: dma: add small delay after reset
Date:   Tue, 14 Sep 2021 23:20:58 +0200
Message-Id: <20210914212105.76186-1-olek2@wp.pl>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-WP-MailID: 9c083a352a31c4ae3946ffbe1e95c549
X-WP-AV: skaner antywirusowy Poczty Wirtualnej Polski
X-WP-SPAM: NO 0000000 [cXMk]                               
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Reading the DMA registers immediately after the reset causes
Data Bus Error. Adding a small delay fixes this issue.

Signed-off-by: Aleksander Jan Bajkowski <olek2@wp.pl>
---
 arch/mips/lantiq/xway/dma.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/mips/lantiq/xway/dma.c b/arch/mips/lantiq/xway/dma.c
index 63dccb2ed08b..2784715933d1 100644
--- a/arch/mips/lantiq/xway/dma.c
+++ b/arch/mips/lantiq/xway/dma.c
@@ -11,6 +11,7 @@
 #include <linux/export.h>
 #include <linux/spinlock.h>
 #include <linux/clk.h>
+#include <linux/delay.h>
 #include <linux/err.h>
 #include <linux/of.h>
 
@@ -222,6 +223,8 @@ ltq_dma_init(struct platform_device *pdev)
 	clk_enable(clk);
 	ltq_dma_w32_mask(0, DMA_RESET, LTQ_DMA_CTRL);
 
+	usleep_range(1, 10);
+
 	/* disable all interrupts */
 	ltq_dma_w32(0, LTQ_DMA_IRNEN);
 
-- 
2.30.2

