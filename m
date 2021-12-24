Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A4C8647F0BA
	for <lists+netdev@lfdr.de>; Fri, 24 Dec 2021 20:28:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353609AbhLXT1J (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Dec 2021 14:27:09 -0500
Received: from relmlor1.renesas.com ([210.160.252.171]:13679 "EHLO
        relmlie5.idc.renesas.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1353465AbhLXT0w (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Dec 2021 14:26:52 -0500
X-IronPort-AV: E=Sophos;i="5.88,233,1635174000"; 
   d="scan'208";a="104635860"
Received: from unknown (HELO relmlir6.idc.renesas.com) ([10.200.68.152])
  by relmlie5.idc.renesas.com with ESMTP; 25 Dec 2021 04:26:51 +0900
Received: from localhost.localdomain (unknown [10.226.36.204])
        by relmlir6.idc.renesas.com (Postfix) with ESMTP id 7665F40F5214;
        Sat, 25 Dec 2021 04:26:49 +0900 (JST)
From:   Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
To:     netdev@vger.kernel.org, Kalle Valo <kvalo@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Rob Herring <robh+dt@kernel.org>, linux-kernel@vger.kernel.org,
        Prabhakar <prabhakar.csengg@gmail.com>,
        Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>,
        ath10k@lists.infradead.org, linux-wireless@vger.kernel.org
Subject: [PATCH 7/8] ath10k: Use platform_get_irq() to get the interrupt
Date:   Fri, 24 Dec 2021 19:26:25 +0000
Message-Id: <20211224192626.15843-8-prabhakar.mahadev-lad.rj@bp.renesas.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20211224192626.15843-1-prabhakar.mahadev-lad.rj@bp.renesas.com>
References: <20211224192626.15843-1-prabhakar.mahadev-lad.rj@bp.renesas.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

platform_get_resource(pdev, IORESOURCE_IRQ, ..) relies on static
allocation of IRQ resources in DT core code, this causes an issue
when using hierarchical interrupt domains using "interrupts" property
in the node as this bypasses the hierarchical setup and messes up the
irq chaining.

In preparation for removal of static setup of IRQ resource from DT core
code use platform_get_irq().

Signed-off-by: Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
---
 drivers/net/wireless/ath/ath10k/snoc.c | 15 +++++----------
 1 file changed, 5 insertions(+), 10 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/snoc.c b/drivers/net/wireless/ath/ath10k/snoc.c
index 9513ab696fff..681e1abe7440 100644
--- a/drivers/net/wireless/ath/ath10k/snoc.c
+++ b/drivers/net/wireless/ath/ath10k/snoc.c
@@ -1306,13 +1306,10 @@ static int ath10k_snoc_resource_init(struct ath10k *ar)
 	}
 
 	for (i = 0; i < CE_COUNT; i++) {
-		res = platform_get_resource(ar_snoc->dev, IORESOURCE_IRQ, i);
-		if (!res) {
-			ath10k_err(ar, "failed to get IRQ%d\n", i);
-			ret = -ENODEV;
-			goto out;
-		}
-		ar_snoc->ce_irqs[i].irq_line = res->start;
+		ret = platform_get_irq(ar_snoc->dev, i);
+		if (ret < 0)
+			return ret;
+		ar_snoc->ce_irqs[i].irq_line = ret;
 	}
 
 	ret = device_property_read_u32(&pdev->dev, "qcom,xo-cal-data",
@@ -1323,10 +1320,8 @@ static int ath10k_snoc_resource_init(struct ath10k *ar)
 		ath10k_dbg(ar, ATH10K_DBG_SNOC, "xo cal data %x\n",
 			   ar_snoc->xo_cal_data);
 	}
-	ret = 0;
 
-out:
-	return ret;
+	return 0;
 }
 
 static void ath10k_snoc_quirks_init(struct ath10k *ar)
-- 
2.17.1

