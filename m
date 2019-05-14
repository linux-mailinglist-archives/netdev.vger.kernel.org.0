Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 93BC01CC2B
	for <lists+netdev@lfdr.de>; Tue, 14 May 2019 17:47:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726774AbfENPqk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 May 2019 11:46:40 -0400
Received: from smtprelay-out1.synopsys.com ([198.182.61.142]:35788 "EHLO
        smtprelay-out1.synopsys.com" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726098AbfENPpm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 May 2019 11:45:42 -0400
Received: from mailhost.synopsys.com (dc2-mailhost2.synopsys.com [10.12.135.162])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by smtprelay-out1.synopsys.com (Postfix) with ESMTPS id 0C450C0A66;
        Tue, 14 May 2019 15:45:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
        t=1557848732; bh=ZYym18C8x+JQ+SAYaeL2uns7Wn+ncATx0eYmYdtfb0w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:In-Reply-To:
         References:From;
        b=Vv9F2oXDQ94/v7JcXZCes98VxLpA9wd+2nS+prUMUL+zAEcSrYTW4IcQchKeSohOE
         EzPDD/xXfXwdgHGgjkVtKlBa90P3/Kg2iAg0GuaZv9Y+38H0nfpvk1RmU0EGuUj4IX
         jmuCK0YkTuycy5fbZjnMF6EZHh4fdo8JRM/NHaa5bFRdpT4OETCcOANiPGXFxZXaae
         /D5C+DuyLf6AE2zVOHetHr6ry4m86o+vMkrd0Mxiya5VOm1nwhOePMvlVivmlcUSjZ
         JYwZn/oKwrEx2dLboi1Hwk3t7fagn+p0SyaGWV6tNrxkstI2UmDzkzJM1f7QSxhPrv
         57/84uvl/WU/A==
Received: from de02.synopsys.com (de02.internal.synopsys.com [10.225.17.21])
        by mailhost.synopsys.com (Postfix) with ESMTP id 37035A0241;
        Tue, 14 May 2019 15:45:41 +0000 (UTC)
Received: from de02dwia024.internal.synopsys.com (de02dwia024.internal.synopsys.com [10.225.19.81])
        by de02.synopsys.com (Postfix) with ESMTP id A1E0F3EA2B;
        Tue, 14 May 2019 17:45:39 +0200 (CEST)
From:   Jose Abreu <Jose.Abreu@synopsys.com>
To:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Jose Abreu <Jose.Abreu@synopsys.com>,
        Joao Pinto <Joao.Pinto@synopsys.com>,
        "David S . Miller" <davem@davemloft.net>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Corentin Labbe <clabbe.montjoie@gmail.com>
Subject: [RFC net-next v2 08/14] net: stmmac: dwmac1000: Also pass control frames while in promisc mode
Date:   Tue, 14 May 2019 17:45:30 +0200
Message-Id: <61a44d1f91134574defb7bf597ac327a0d8d66a1.1557848472.git.joabreu@synopsys.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <cover.1557848472.git.joabreu@synopsys.com>
References: <cover.1557848472.git.joabreu@synopsys.com>
In-Reply-To: <cover.1557848472.git.joabreu@synopsys.com>
References: <cover.1557848472.git.joabreu@synopsys.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In order for the selftests to run the Flow Control selftest we need to
also pass pause frames to the stack.

Pass this type of frames while in promiscuous mode.

Signed-off-by: Jose Abreu <joabreu@synopsys.com>
Cc: Joao Pinto <jpinto@synopsys.com>
Cc: David S. Miller <davem@davemloft.net>
Cc: Giuseppe Cavallaro <peppe.cavallaro@st.com>
Cc: Alexandre Torgue <alexandre.torgue@st.com>
Cc: Corentin Labbe <clabbe.montjoie@gmail.com>
---
 drivers/net/ethernet/stmicro/stmmac/dwmac1000.h      | 1 +
 drivers/net/ethernet/stmicro/stmmac/dwmac1000_core.c | 2 +-
 2 files changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac1000.h b/drivers/net/ethernet/stmicro/stmmac/dwmac1000.h
index 184ca13c8f79..56a69fb6f0b9 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac1000.h
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac1000.h
@@ -146,6 +146,7 @@ enum inter_frame_gap {
 #define GMAC_FRAME_FILTER_DAIF	0x00000008	/* DA Inverse Filtering */
 #define GMAC_FRAME_FILTER_PM	0x00000010	/* Pass all multicast */
 #define GMAC_FRAME_FILTER_DBF	0x00000020	/* Disable Broadcast frames */
+#define GMAC_FRAME_FILTER_PCF	0x00000080	/* Pass Control frames */
 #define GMAC_FRAME_FILTER_SAIF	0x00000100	/* Inverse Filtering */
 #define GMAC_FRAME_FILTER_SAF	0x00000200	/* Source Address Filter */
 #define GMAC_FRAME_FILTER_HPF	0x00000400	/* Hash or perfect Filter */
diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac1000_core.c b/drivers/net/ethernet/stmicro/stmmac/dwmac1000_core.c
index 398303c783f4..8ca73bd15e07 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac1000_core.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac1000_core.c
@@ -172,7 +172,7 @@ static void dwmac1000_set_filter(struct mac_device_info *hw,
 	memset(mc_filter, 0, sizeof(mc_filter));
 
 	if (dev->flags & IFF_PROMISC) {
-		value = GMAC_FRAME_FILTER_PR;
+		value = GMAC_FRAME_FILTER_PR | GMAC_FRAME_FILTER_PCF;
 	} else if (dev->flags & IFF_ALLMULTI) {
 		value = GMAC_FRAME_FILTER_PM;	/* pass all multi */
 	} else if (!netdev_mc_empty(dev)) {
-- 
2.7.4

