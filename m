Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5C38027739
	for <lists+netdev@lfdr.de>; Thu, 23 May 2019 09:38:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730461AbfEWHiM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 May 2019 03:38:12 -0400
Received: from dc8-smtprelay2.synopsys.com ([198.182.47.102]:43622 "EHLO
        smtprelay-out1.synopsys.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730196AbfEWHhb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 May 2019 03:37:31 -0400
Received: from mailhost.synopsys.com (dc2-mailhost2.synopsys.com [10.12.135.162])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by smtprelay-out1.synopsys.com (Postfix) with ESMTPS id 5F8ECC019A;
        Thu, 23 May 2019 07:37:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
        t=1558597058; bh=8ckx/1E0aeUvuEZVuhOKqivMFtxHIShxMND0slJzIg0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:In-Reply-To:
         References:From;
        b=KFUek1Lh8/7VOgs1ZTcst7qif86Lr/jGaqiuwB/buYBNhBvGCSJuMc/j5ZZULRE7o
         xyN4fQDYw1Lk9htXH+S4RAwLGpqZCEVgqVU1oU5NHeqbtnXg9Ct1lEO7GAsaNdEu1n
         CJ/0DkS1/cnbfuWMspmlSfD7Qjpupn/ku6sViVkK4nKu7vwbzxa0B+0A0vUqJ+x/uA
         BRb706VE1t2BLAZJ0weIcT7scJrHHfO+J4OnMXn4vLX497nFVmtYlxFIyzcryqXNX7
         TWA/DqChLPAUiEYkiSIPzJFFzX7to8my1uni7/bx9/11m3dFuwJzd4667Cw1EY7jXV
         oMSbkD1ZmaKRA==
Received: from de02.synopsys.com (germany.internal.synopsys.com [10.225.17.21])
        by mailhost.synopsys.com (Postfix) with ESMTP id E0563A0245;
        Thu, 23 May 2019 07:37:30 +0000 (UTC)
Received: from de02dwia024.internal.synopsys.com (de02dwia024.internal.synopsys.com [10.225.19.81])
        by de02.synopsys.com (Postfix) with ESMTP id EB3D73D964;
        Thu, 23 May 2019 09:37:28 +0200 (CEST)
From:   Jose Abreu <Jose.Abreu@synopsys.com>
To:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Cc:     Jose Abreu <Jose.Abreu@synopsys.com>,
        Joao Pinto <Joao.Pinto@synopsys.com>,
        "David S . Miller" <davem@davemloft.net>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>
Subject: [PATCH net-next 14/18] net: stmmac: dwmac4/5: Fix Hash Filter
Date:   Thu, 23 May 2019 09:37:04 +0200
Message-Id: <f3aafd26301dbb6015dc65ca255798ee1ad87816.1558596600.git.joabreu@synopsys.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <cover.1558596599.git.joabreu@synopsys.com>
References: <cover.1558596599.git.joabreu@synopsys.com>
In-Reply-To: <cover.1558596599.git.joabreu@synopsys.com>
References: <cover.1558596599.git.joabreu@synopsys.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In order for hash filter to work we need to set the HPF bit.

Fout out while running stmmac selftests

Signed-off-by: Jose Abreu <joabreu@synopsys.com>
Cc: Joao Pinto <jpinto@synopsys.com>
Cc: David S. Miller <davem@davemloft.net>
Cc: Giuseppe Cavallaro <peppe.cavallaro@st.com>
Cc: Alexandre Torgue <alexandre.torgue@st.com>
---
 drivers/net/ethernet/stmicro/stmmac/dwmac4.h      | 1 +
 drivers/net/ethernet/stmicro/stmmac/dwmac4_core.c | 2 ++
 2 files changed, 3 insertions(+)

diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac4.h b/drivers/net/ethernet/stmicro/stmmac/dwmac4.h
index c3cbca804bcd..01c10893b7a5 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac4.h
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac4.h
@@ -65,6 +65,7 @@
 #define GMAC_PACKET_FILTER_HMC		BIT(2)
 #define GMAC_PACKET_FILTER_PM		BIT(4)
 #define GMAC_PACKET_FILTER_PCF		BIT(7)
+#define GMAC_PACKET_FILTER_HPF		BIT(10)
 
 #define GMAC_MAX_PERFECT_ADDRESSES	128
 
diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac4_core.c b/drivers/net/ethernet/stmicro/stmmac/dwmac4_core.c
index 02a3a7e2db6e..094bd069c093 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac4_core.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac4_core.c
@@ -438,6 +438,8 @@ static void dwmac4_set_filter(struct mac_device_info *hw,
 		writel(mc_filter[1], ioaddr + GMAC_HASH_TAB_32_63);
 	}
 
+	value |= GMAC_PACKET_FILTER_HPF;
+
 	/* Handle multiple unicast addresses */
 	if (netdev_uc_count(dev) > GMAC_MAX_PERFECT_ADDRESSES) {
 		/* Switch to promiscuous mode if more than 128 addrs
-- 
2.7.4

