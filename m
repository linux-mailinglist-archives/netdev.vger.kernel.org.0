Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 414F71CC1B
	for <lists+netdev@lfdr.de>; Tue, 14 May 2019 17:46:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726599AbfENPpn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 May 2019 11:45:43 -0400
Received: from smtprelay-out1.synopsys.com ([198.182.61.142]:35836 "EHLO
        smtprelay-out1.synopsys.com" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726467AbfENPpm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 May 2019 11:45:42 -0400
Received: from mailhost.synopsys.com (dc2-mailhost2.synopsys.com [10.12.135.162])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by smtprelay-out1.synopsys.com (Postfix) with ESMTPS id 6ED6BC01BF;
        Tue, 14 May 2019 15:45:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
        t=1557848732; bh=cWCfFRRT85g4HpsA7Tx1dUIhm7cKnK5Zaiec1rLJZsk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:In-Reply-To:
         References:From;
        b=LfhBMaLS52tLy7CY7u944844ffvIDEusvxg7xzxi//hYLKDlZgpMihPVHpV4LG/dJ
         J6QosUCS5973faj32T1BJcozdbhdHBXyldireOjyLUJFe4UfwRjWECsKugrZMh1/AZ
         rAB2tULoSo0MRNcXEwnozFnFlscWs0pdMh5+f7gZjFR5sqh9KirEnLU4BGMEU+kuya
         9Owd1l+d3yL1zqv/slIImD8wE3LUxRLqz8WVvpZlBWzXKKpYRoV17oppJE8kPPHtj1
         4wOiIxS1U0yRDZ6HMCRBKwDDze17S1zQBXTF8Z5OZmvRxWzqKOgR52YU3ksDziTTM0
         /hGlEECwM3Ouw==
Received: from de02.synopsys.com (de02.internal.synopsys.com [10.225.17.21])
        by mailhost.synopsys.com (Postfix) with ESMTP id 99E44A00AB;
        Tue, 14 May 2019 15:45:41 +0000 (UTC)
Received: from de02dwia024.internal.synopsys.com (de02dwia024.internal.synopsys.com [10.225.19.81])
        by de02.synopsys.com (Postfix) with ESMTP id 13B523EA3D;
        Tue, 14 May 2019 17:45:40 +0200 (CEST)
From:   Jose Abreu <Jose.Abreu@synopsys.com>
To:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Jose Abreu <Jose.Abreu@synopsys.com>,
        Joao Pinto <Joao.Pinto@synopsys.com>,
        "David S . Miller" <davem@davemloft.net>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Corentin Labbe <clabbe.montjoie@gmail.com>
Subject: [RFC net-next v2 13/14] net: stmmac: dwmac1000: Clear unused address entries
Date:   Tue, 14 May 2019 17:45:35 +0200
Message-Id: <2f3b629b1f41997f804441f90d8a25f5d5e9f797.1557848472.git.joabreu@synopsys.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <cover.1557848472.git.joabreu@synopsys.com>
References: <cover.1557848472.git.joabreu@synopsys.com>
In-Reply-To: <cover.1557848472.git.joabreu@synopsys.com>
References: <cover.1557848472.git.joabreu@synopsys.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In case we don't use a given address entry we need to clear it because
it could contain previous values that are no longer valid.

Found out while running stmmac selftests.

Signed-off-by: Jose Abreu <joabreu@synopsys.com>
Cc: Joao Pinto <jpinto@synopsys.com>
Cc: David S. Miller <davem@davemloft.net>
Cc: Giuseppe Cavallaro <peppe.cavallaro@st.com>
Cc: Alexandre Torgue <alexandre.torgue@st.com>
Cc: Corentin Labbe <clabbe.montjoie@gmail.com>
---
 drivers/net/ethernet/stmicro/stmmac/dwmac1000_core.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac1000_core.c b/drivers/net/ethernet/stmicro/stmmac/dwmac1000_core.c
index bc91af6c01b6..ebe41dd09bab 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac1000_core.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac1000_core.c
@@ -217,6 +217,12 @@ static void dwmac1000_set_filter(struct mac_device_info *hw,
 					    GMAC_ADDR_LOW(reg));
 			reg++;
 		}
+
+		while (reg <= perfect_addr_number) {
+			writel(0, ioaddr + GMAC_ADDR_HIGH(reg));
+			writel(0, ioaddr + GMAC_ADDR_LOW(reg));
+			reg++;
+		}
 	}
 
 #ifdef FRAME_FILTER_DEBUG
-- 
2.7.4

