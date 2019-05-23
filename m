Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 76D9D2774C
	for <lists+netdev@lfdr.de>; Thu, 23 May 2019 09:39:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730666AbfEWHjJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 May 2019 03:39:09 -0400
Received: from dc8-smtprelay2.synopsys.com ([198.182.47.102]:43580 "EHLO
        smtprelay-out1.synopsys.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1730108AbfEWHha (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 May 2019 03:37:30 -0400
Received: from mailhost.synopsys.com (dc2-mailhost2.synopsys.com [10.12.135.162])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by smtprelay-out1.synopsys.com (Postfix) with ESMTPS id 8E7E4C0182;
        Thu, 23 May 2019 07:37:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
        t=1558597057; bh=E1emIEjNANwRmKEZ+e4MSk3z+x2kjCmt/dMPP59ND8o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:In-Reply-To:
         References:From;
        b=SmbaWVsvvcDJ5u0GdEkZJe+Fyz8iaLmH0yvAxXHKQkPvleVr4KY+woB5kKJEOm1ai
         HIg4oidj7bjHdHqZImwuFxz8cghixuRNvDmekz5+Wg6goiLHBEB+CMcbQQz21BeOoa
         soQls6OvVpcIOTNrQu/0/ycI/4r+UEK9MSP7+g63Q7To6Ssthl73SKTMUvVxJvwHSK
         ESffT7tzez2vnkx1ZgUPIB1ERgnjbwNigsl/7/PbG2Oi8ewCEZrO6yke/dzP94D1HB
         o8lqTWlMUvMLFmw/5ScE9g5Yc2Qh/vL/bdWk8m8waGGGX9R1Pa8A6x0f4CA2srY2ig
         3I+5h5JWFQ/aw==
Received: from de02.synopsys.com (germany.internal.synopsys.com [10.225.17.21])
        by mailhost.synopsys.com (Postfix) with ESMTP id F1937A00A8;
        Thu, 23 May 2019 07:37:29 +0000 (UTC)
Received: from de02dwia024.internal.synopsys.com (de02dwia024.internal.synopsys.com [10.225.19.81])
        by de02.synopsys.com (Postfix) with ESMTP id 870D73D94E;
        Thu, 23 May 2019 09:37:28 +0200 (CEST)
From:   Jose Abreu <Jose.Abreu@synopsys.com>
To:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Cc:     Jose Abreu <Jose.Abreu@synopsys.com>,
        Joao Pinto <Joao.Pinto@synopsys.com>,
        "David S . Miller" <davem@davemloft.net>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>
Subject: [PATCH net-next 09/18] net: stmmac: dwmac4/5: Also pass control frames while in promisc mode
Date:   Thu, 23 May 2019 09:36:59 +0200
Message-Id: <82851e6360d4d032f6cfd47af3cb5572109afc84.1558596600.git.joabreu@synopsys.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <cover.1558596599.git.joabreu@synopsys.com>
References: <cover.1558596599.git.joabreu@synopsys.com>
In-Reply-To: <cover.1558596599.git.joabreu@synopsys.com>
References: <cover.1558596599.git.joabreu@synopsys.com>
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
---
 drivers/net/ethernet/stmicro/stmmac/dwmac4.h      | 1 +
 drivers/net/ethernet/stmicro/stmmac/dwmac4_core.c | 2 +-
 2 files changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac4.h b/drivers/net/ethernet/stmicro/stmmac/dwmac4.h
index 3dddd7902b0f..c3cbca804bcd 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac4.h
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac4.h
@@ -64,6 +64,7 @@
 #define GMAC_PACKET_FILTER_PR		BIT(0)
 #define GMAC_PACKET_FILTER_HMC		BIT(2)
 #define GMAC_PACKET_FILTER_PM		BIT(4)
+#define GMAC_PACKET_FILTER_PCF		BIT(7)
 
 #define GMAC_MAX_PERFECT_ADDRESSES	128
 
diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac4_core.c b/drivers/net/ethernet/stmicro/stmmac/dwmac4_core.c
index 2f1a2a6f9b33..02a3a7e2db6e 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac4_core.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac4_core.c
@@ -404,7 +404,7 @@ static void dwmac4_set_filter(struct mac_device_info *hw,
 	unsigned int value = 0;
 
 	if (dev->flags & IFF_PROMISC) {
-		value = GMAC_PACKET_FILTER_PR;
+		value = GMAC_PACKET_FILTER_PR | GMAC_PACKET_FILTER_PCF;
 	} else if ((dev->flags & IFF_ALLMULTI) ||
 			(netdev_mc_count(dev) > HASH_TABLE_SIZE)) {
 		/* Pass all multi */
-- 
2.7.4

