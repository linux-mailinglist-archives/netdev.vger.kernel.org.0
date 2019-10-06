Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 63755CD18C
	for <lists+netdev@lfdr.de>; Sun,  6 Oct 2019 13:09:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726591AbfJFLJI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 6 Oct 2019 07:09:08 -0400
Received: from us03-smtprelay2.synopsys.com ([149.117.87.133]:46792 "EHLO
        smtprelay-out1.synopsys.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726291AbfJFLJI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 6 Oct 2019 07:09:08 -0400
Received: from mailhost.synopsys.com (mdc-mailhost2.synopsys.com [10.225.0.210])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by smtprelay-out1.synopsys.com (Postfix) with ESMTPS id 04C28C04C4;
        Sun,  6 Oct 2019 11:09:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
        t=1570360147; bh=yJGh0PmYaQMDXz233hMJBanbA6dyu3TtFD0qfFGaroo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:In-Reply-To:
         References:From;
        b=FPCqjj6+4G9rvmQzSnovrxABBMdndyKfp7QJpAyP3yJzX/6i7HYMUWu9g9yHRrAuk
         dKRhAtDKmOz66saLdYFoYUlpLDa/APIRgNIp7kX9WhPh34YDANCFS4g/89+8z3vSI4
         jmDKAvTrb36w+fonwr1ssYwx/KpF6oA3ejFOSOTmNS8O2xGZyvSJCHdLY5YC0GwMrL
         gUXtt7XV00yFfgYmZMWF2K5m/i6UdiHnS6uzddg6/YBvoHSD9FqusV34PQeJbCyM7l
         Jh+jV4fAaLzELM2/tNjkO8kRv/hUP+g6dCT1MvKbQmFWRQXoFj9X0MH2ALiv2/xyN0
         dPC6Hb6Z4VKBQ==
Received: from de02dwia024.internal.synopsys.com (de02dwia024.internal.synopsys.com [10.225.19.81])
        by mailhost.synopsys.com (Postfix) with ESMTP id 812F6A005D;
        Sun,  6 Oct 2019 11:09:04 +0000 (UTC)
From:   Jose Abreu <Jose.Abreu@synopsys.com>
To:     netdev@vger.kernel.org
Cc:     Joao Pinto <Joao.Pinto@synopsys.com>,
        Jose Abreu <Jose.Abreu@synopsys.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Jose Abreu <Jose.Abreu@synopsys.com>,
        "David S. Miller" <davem@davemloft.net>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH net 1/3] net: stmmac: selftests: Check if filtering is available before running
Date:   Sun,  6 Oct 2019 13:08:55 +0200
Message-Id: <959930fe0423010540ae9e615449df5cb26da674.1570359800.git.Jose.Abreu@synopsys.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <cover.1570359800.git.Jose.Abreu@synopsys.com>
References: <cover.1570359800.git.Jose.Abreu@synopsys.com>
In-Reply-To: <cover.1570359800.git.Jose.Abreu@synopsys.com>
References: <cover.1570359800.git.Jose.Abreu@synopsys.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We need to check if the number of available Hash Filters is enough to
run the test, otherwise we will get false failures.

Fixes: 091810dbded9 ("net: stmmac: Introduce selftests support")
Signed-off-by: Jose Abreu <Jose.Abreu@synopsys.com>

---
Cc: Giuseppe Cavallaro <peppe.cavallaro@st.com>
Cc: Alexandre Torgue <alexandre.torgue@st.com>
Cc: Jose Abreu <joabreu@synopsys.com>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Maxime Coquelin <mcoquelin.stm32@gmail.com>
Cc: netdev@vger.kernel.org
Cc: linux-stm32@st-md-mailman.stormreply.com
Cc: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org
---
 drivers/net/ethernet/stmicro/stmmac/stmmac_selftests.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_selftests.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_selftests.c
index cc76a42c7466..ed3926d4471d 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_selftests.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_selftests.c
@@ -496,6 +496,9 @@ static int stmmac_test_hfilt(struct stmmac_priv *priv)
 	if (ret)
 		return ret;
 
+	if (netdev_mc_count(priv->dev) >= priv->hw->multicast_filter_bins)
+		return -EOPNOTSUPP;
+
 	ret = dev_mc_add(priv->dev, gd_addr);
 	if (ret)
 		return ret;
@@ -573,6 +576,8 @@ static int stmmac_test_mcfilt(struct stmmac_priv *priv)
 
 	if (stmmac_filter_check(priv))
 		return -EOPNOTSUPP;
+	if (!priv->hw->multicast_filter_bins)
+		return -EOPNOTSUPP;
 
 	/* Remove all MC addresses */
 	__dev_mc_unsync(priv->dev, NULL);
@@ -611,6 +616,8 @@ static int stmmac_test_ucfilt(struct stmmac_priv *priv)
 
 	if (stmmac_filter_check(priv))
 		return -EOPNOTSUPP;
+	if (!priv->hw->multicast_filter_bins)
+		return -EOPNOTSUPP;
 
 	/* Remove all UC addresses */
 	__dev_uc_unsync(priv->dev, NULL);
-- 
2.7.4

