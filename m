Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7A97C263AD1
	for <lists+netdev@lfdr.de>; Thu, 10 Sep 2020 04:46:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730568AbgIJCqn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Sep 2020 22:46:43 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:11329 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1730500AbgIJCpb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 9 Sep 2020 22:45:31 -0400
Received: from DGGEMS407-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id F250F7A3B6D568484089;
        Thu, 10 Sep 2020 10:45:12 +0800 (CST)
Received: from huawei.com (10.69.192.56) by DGGEMS407-HUB.china.huawei.com
 (10.3.19.207) with Microsoft SMTP Server id 14.3.487.0; Thu, 10 Sep 2020
 10:45:03 +0800
From:   Luo Jiaxing <luojiaxing@huawei.com>
To:     <peppe.cavallaro@st.com>, <alexandre.torgue@st.com>,
        <joabreu@synopsys.com>, <davem@davemloft.net>, <kuba@kernel.org>,
        <mcoquelin.stm32@gmail.com>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linuxarm@huawei.com>
Subject: [PATCH net-next] net: stmmac: Remove unused variable 'ret' at stmmac_rx_buf1_len()
Date:   Thu, 10 Sep 2020 10:42:45 +0800
Message-ID: <1599705765-15562-1-git-send-email-luojiaxing@huawei.com>
X-Mailer: git-send-email 2.7.4
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.69.192.56]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fixes the following warning when using W=1 to build kernel:

drivers/net/ethernet/stmicro/stmmac/stmmac_main.c:3634:6: warning: variable ‘ret’ set but not used [-Wunused-but-set-variable]
int ret, coe = priv->hw->rx_csum;

When digging stmmac_get_rx_header_len(), dwmac4_get_rx_header_len() and
dwxgmac2_get_rx_header_len() return 0 by default. Therefore, ret do not
need to check the error value and can be directly deleted.

Signed-off-by: Luo Jiaxing <luojiaxing@huawei.com>
---
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
index 89b2b34..7e95412 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -3631,15 +3631,15 @@ static unsigned int stmmac_rx_buf1_len(struct stmmac_priv *priv,
 				       struct dma_desc *p,
 				       int status, unsigned int len)
 {
-	int ret, coe = priv->hw->rx_csum;
 	unsigned int plen = 0, hlen = 0;
+	int coe = priv->hw->rx_csum;
 
 	/* Not first descriptor, buffer is always zero */
 	if (priv->sph && len)
 		return 0;
 
 	/* First descriptor, get split header length */
-	ret = stmmac_get_rx_header_len(priv, p, &hlen);
+	stmmac_get_rx_header_len(priv, p, &hlen);
 	if (priv->sph && hlen) {
 		priv->xstats.rx_split_hdr_pkt_n++;
 		return hlen;
-- 
2.7.4

