Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D5789292E3
	for <lists+netdev@lfdr.de>; Fri, 24 May 2019 10:22:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389708AbfEXIVT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 May 2019 04:21:19 -0400
Received: from smtprelay-out1.synopsys.com ([198.182.47.102]:35532 "EHLO
        smtprelay-out1.synopsys.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2389463AbfEXIUi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 May 2019 04:20:38 -0400
Received: from mailhost.synopsys.com (dc2-mailhost2.synopsys.com [10.12.135.162])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by smtprelay-out1.synopsys.com (Postfix) with ESMTPS id B7FCDC012A;
        Fri, 24 May 2019 08:20:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
        t=1558686045; bh=Ov6NfcG97VTah4g4GGXOMfkMTg12mw14VW62NwwkFuQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:In-Reply-To:
         References:From;
        b=b/30Of5bgtUzKS6ifumTOeKQvdAnOXH9v13creIbj4SKPuHAWNVpPxAfxCq++omAZ
         ffylQ5i6lN2CXrq1M2HFThdjal+eFeo/xmaEq4SwiWX0STIEglj2LHT71u9ZJwea6+
         kYk6d4s1mVLmv2ndfOnTmd7+nvviLh4WTLb0Ug3MNHIyTCcNoBnzUu50B3ABN8/Kwa
         R+DsVbKFNwAPcjHq7/hXe8kDRQ/Y0pzTjhAISQiPOtimysKVylb7Z1WgViz7gsLXxm
         Le12seWbWpaAF8Q8v0oksjpBDcXxNVxjfPzt3gLKhtthSydRgDRpiyIt9VUUs5QzKY
         UbeStxJN3jcqw==
Received: from de02.synopsys.com (germany.internal.synopsys.com [10.225.17.21])
        by mailhost.synopsys.com (Postfix) with ESMTP id D7A76A0245;
        Fri, 24 May 2019 08:20:37 +0000 (UTC)
Received: from de02dwia024.internal.synopsys.com (de02dwia024.internal.synopsys.com [10.225.19.81])
        by de02.synopsys.com (Postfix) with ESMTP id 532473FB18;
        Fri, 24 May 2019 10:20:36 +0200 (CEST)
From:   Jose Abreu <Jose.Abreu@synopsys.com>
To:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Cc:     Jose Abreu <Jose.Abreu@synopsys.com>,
        Joao Pinto <Joao.Pinto@synopsys.com>,
        "David S . Miller" <davem@davemloft.net>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>
Subject: [PATCH net-next v2 13/18] net: stmmac: dwmac1000: Clear unused address entries
Date:   Fri, 24 May 2019 10:20:21 +0200
Message-Id: <aa5f934e1958e8b7b9f137c7dbc8c33ac2fcf789.1558685828.git.joabreu@synopsys.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <cover.1558685827.git.joabreu@synopsys.com>
References: <cover.1558685827.git.joabreu@synopsys.com>
In-Reply-To: <cover.1558685827.git.joabreu@synopsys.com>
References: <cover.1558685827.git.joabreu@synopsys.com>
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

