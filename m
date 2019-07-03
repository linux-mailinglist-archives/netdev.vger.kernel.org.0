Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C1E345E066
	for <lists+netdev@lfdr.de>; Wed,  3 Jul 2019 10:59:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727241AbfGCI7L (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Jul 2019 04:59:11 -0400
Received: from mga01.intel.com ([192.55.52.88]:31283 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727045AbfGCI7L (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 3 Jul 2019 04:59:11 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga101.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 03 Jul 2019 01:59:11 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.63,446,1557212400"; 
   d="scan'208";a="184692476"
Received: from wvoon-ilbpg2.png.intel.com ([10.88.227.88])
  by fmsmga001.fm.intel.com with ESMTP; 03 Jul 2019 01:59:09 -0700
From:   Voon Weifeng <weifeng.voon@intel.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jose Abreu <joabreu@synopsys.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Ong Boon Leong <boon.leong.ong@intel.com>,
        Voon Weifeng <weifeng.voon@intel.com>
Subject: [PATCH v1 net-next] net: stmmac: Enable dwmac4 jumbo frame more than 8KiB
Date:   Thu,  4 Jul 2019 00:59:10 +0800
Message-Id: <1562173150-808-1-git-send-email-weifeng.voon@intel.com>
X-Mailer: git-send-email 1.9.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Weifeng Voon <weifeng.voon@intel.com>

Enable GMAC v4.xx and beyond to support 16KiB buffer.

Signed-off-by: Weifeng Voon <weifeng.voon@intel.com>
Signed-off-by: Ong Boon Leong <boon.leong.ong@intel.com>

diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac4_descs.c b/drivers/net/ethernet/stmicro/stmmac/dwmac4_descs.c
index cf6436d3d6c7..dbde23e7e169 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac4_descs.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac4_descs.c
@@ -443,6 +443,15 @@ static void dwmac4_clear(struct dma_desc *p)
 	p->des3 = 0;
 }
 
+static int set_16kib_bfsize(int mtu)
+{
+	int ret = 0;
+
+	if (unlikely(mtu >= BUF_SIZE_8KiB))
+		ret = BUF_SIZE_16KiB;
+	return ret;
+}
+
 const struct stmmac_desc_ops dwmac4_desc_ops = {
 	.tx_status = dwmac4_wrback_get_tx_status,
 	.rx_status = dwmac4_wrback_get_rx_status,
@@ -469,4 +478,6 @@ static void dwmac4_clear(struct dma_desc *p)
 	.clear = dwmac4_clear,
 };
 
-const struct stmmac_mode_ops dwmac4_ring_mode_ops = { };
+const struct stmmac_mode_ops dwmac4_ring_mode_ops = {
+	.set_16kib_bfsize = set_16kib_bfsize,
+};
-- 
1.9.1

