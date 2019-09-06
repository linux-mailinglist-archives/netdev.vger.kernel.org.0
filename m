Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 59B24AB364
	for <lists+netdev@lfdr.de>; Fri,  6 Sep 2019 09:42:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404542AbfIFHla (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Sep 2019 03:41:30 -0400
Received: from dc8-smtprelay2.synopsys.com ([198.182.47.102]:33366 "EHLO
        smtprelay-out1.synopsys.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2392555AbfIFHl3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Sep 2019 03:41:29 -0400
Received: from mailhost.synopsys.com (mdc-mailhost1.synopsys.com [10.225.0.209])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by smtprelay-out1.synopsys.com (Postfix) with ESMTPS id 23683C0E03;
        Fri,  6 Sep 2019 07:41:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
        t=1567755688; bh=1i/geIHgBQLLy7LPimv2MIzVFeg/Cl2TeuERvfMsPYk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:In-Reply-To:
         References:From;
        b=UKDD5M3QsYIJSRZ7L9o99VGsWgvjEfmNmPwUfpdbQebZ8qBBDEJY4wRUNpNkuTO7v
         R3FngN05ExpqQxQWK/icr3lKvhAY0ywtmn5/8r/PqTuIsg4ydYiO5Cl3boXasgE2E1
         ZBhMsqDhvK405Rng3quH4TxJhW6j1zrVtFK7j/OgQEMgEsip9DpF1zKdV85M5cwbk/
         9Urvg/z/EQ+Wi1K1i8RF2Tu89qxCxwVO1+5f8j9PrzaUVeCAA4l+c/b9s3P79xPQvG
         Ij8OoXdWTGC/xipH4+25Qj+IkdTl35l43Ax/SERJpxFqYUXnOcrslIoNG2o1KpVRHz
         xzGrdurzMs3PA==
Received: from de02dwia024.internal.synopsys.com (de02dwia024.internal.synopsys.com [10.225.19.81])
        by mailhost.synopsys.com (Postfix) with ESMTP id A5E9BA005D;
        Fri,  6 Sep 2019 07:41:26 +0000 (UTC)
From:   Jose Abreu <Jose.Abreu@synopsys.com>
To:     netdev@vger.kernel.org
Cc:     Joao Pinto <Joao.Pinto@synopsys.com>,
        Jose Abreu <Jose.Abreu@synopsys.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        "David S. Miller" <davem@davemloft.net>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next 1/5] net: stmmac: selftests: Add missing checks for support of SA
Date:   Fri,  6 Sep 2019 09:41:13 +0200
Message-Id: <3b38421ddf3d8c4e40400f990999d548b8c459b5.1567755423.git.joabreu@synopsys.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <cover.1567755423.git.joabreu@synopsys.com>
References: <cover.1567755423.git.joabreu@synopsys.com>
In-Reply-To: <cover.1567755423.git.joabreu@synopsys.com>
References: <cover.1567755423.git.joabreu@synopsys.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add checks for support of Source Address Insertion/Replacement before
running the test.

Signed-off-by: Jose Abreu <joabreu@synopsys.com>

---
Cc: Giuseppe Cavallaro <peppe.cavallaro@st.com>
Cc: Alexandre Torgue <alexandre.torgue@st.com>
Cc: Jose Abreu <joabreu@synopsys.com>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Maxime Coquelin <mcoquelin.stm32@gmail.com>
Cc: netdev@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org
---
 drivers/net/ethernet/stmicro/stmmac/stmmac_selftests.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_selftests.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_selftests.c
index 305d24935cf4..dce34c081a1e 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_selftests.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_selftests.c
@@ -1057,6 +1057,9 @@ static int stmmac_test_desc_sai(struct stmmac_priv *priv)
 	struct stmmac_packet_attrs attr = { };
 	int ret;
 
+	if (!priv->dma_cap.vlins)
+		return -EOPNOTSUPP;
+
 	attr.remove_sa = true;
 	attr.sarc = true;
 	attr.src = src;
@@ -1076,6 +1079,9 @@ static int stmmac_test_desc_sar(struct stmmac_priv *priv)
 	struct stmmac_packet_attrs attr = { };
 	int ret;
 
+	if (!priv->dma_cap.vlins)
+		return -EOPNOTSUPP;
+
 	attr.sarc = true;
 	attr.src = src;
 	attr.dst = priv->dev->dev_addr;
@@ -1094,6 +1100,9 @@ static int stmmac_test_reg_sai(struct stmmac_priv *priv)
 	struct stmmac_packet_attrs attr = { };
 	int ret;
 
+	if (!priv->dma_cap.vlins)
+		return -EOPNOTSUPP;
+
 	attr.remove_sa = true;
 	attr.sarc = true;
 	attr.src = src;
@@ -1114,6 +1123,9 @@ static int stmmac_test_reg_sar(struct stmmac_priv *priv)
 	struct stmmac_packet_attrs attr = { };
 	int ret;
 
+	if (!priv->dma_cap.vlins)
+		return -EOPNOTSUPP;
+
 	attr.sarc = true;
 	attr.src = src;
 	attr.dst = priv->dev->dev_addr;
-- 
2.7.4

