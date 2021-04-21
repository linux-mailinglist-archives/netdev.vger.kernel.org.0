Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BACAB366D1C
	for <lists+netdev@lfdr.de>; Wed, 21 Apr 2021 15:47:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242768AbhDUNs2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Apr 2021 09:48:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:56474 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241066AbhDUNs1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 21 Apr 2021 09:48:27 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4766D60C3E;
        Wed, 21 Apr 2021 13:47:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1619012874;
        bh=KTVLWVJq8vwl6vTzOgA9P5+hpcqgLU/xnyvuwWytlYE=;
        h=From:To:Cc:Subject:Date:From;
        b=nhD24SoAze3qpdTO9xcGGlp+5fd7qGoArYtTzCjyKkgaklPGTEYVGcbeK7XKfXLe2
         kn6F8MrroDr8Swusb2ybIXRpbRt/NHdRPbGan00G6hZMRWIQNPSFAriEJPKBqcH2Qw
         B0oCHNxakFJDXWRTyDUyWxAIsBNCdJDfgxZn8OI9jdfViZut1nlrVp8mEMsMfJVBJ1
         0/EA5WUqa+uY/w81+QR+1UU7NoPdCuO8usoXdsfuM3p06iarE+2yea+DSspBrd4yVe
         bcOFUMbnA08QNPYapoPBNBoZfgthhIhR4BXWQlEcbFnyZiSPqYr5fPWaaqcIV+59db
         /yIHpNdhKPECg==
From:   Arnd Bergmann <arnd@kernel.org>
To:     Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Arnd Bergmann <arnd@arndb.de>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Ong Boon Leong <boon.leong.ong@intel.com>,
        Voon Weifeng <weifeng.voon@intel.com>,
        Joakim Zhang <qiangqing.zhang@nxp.com>,
        Fugang Duan <fugang.duan@nxp.com>,
        Thierry Reding <treding@nvidia.com>,
        "Song, Yoong Siang" <yoong.siang.song@intel.com>,
        netdev@vger.kernel.org, linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH] [net-next] net: stmmac: fix gcc-10 -Wrestrict warning
Date:   Wed, 21 Apr 2021 15:47:29 +0200
Message-Id: <20210421134743.3260921-1-arnd@kernel.org>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

gcc-10 and later warn about a theoretical array overrun when
accessing priv->int_name_rx_irq[i] with an out of bounds value
of 'i':

drivers/net/ethernet/stmicro/stmmac/stmmac_main.c: In function 'stmmac_request_irq_multi_msi':
drivers/net/ethernet/stmicro/stmmac/stmmac_main.c:3528:17: error: 'snprintf' argument 4 may overlap destination object 'dev' [-Werror=restrict]
 3528 |                 snprintf(int_name, int_name_len, "%s:%s-%d", dev->name, "tx", i);
      |                 ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
drivers/net/ethernet/stmicro/stmmac/stmmac_main.c:3404:60: note: destination object referenced by 'restrict'-qualified argument 1 was declared here
 3404 | static int stmmac_request_irq_multi_msi(struct net_device *dev)
      |                                         ~~~~~~~~~~~~~~~~~~~^~~

The warning is a bit strange since it's not actually about the array
bounds but rather about possible string operations with overlapping
arguments, but it's not technically wrong.

Avoid the warning by adding an extra bounds check.

Fixes: 8532f613bc78 ("net: stmmac: introduce MSI Interrupt routines for mac, safety, RX & TX")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
index d1ca07c846e6..aadac783687b 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -3498,6 +3498,8 @@ static int stmmac_request_irq_multi_msi(struct net_device *dev)
 
 	/* Request Rx MSI irq */
 	for (i = 0; i < priv->plat->rx_queues_to_use; i++) {
+		if (i > MTL_MAX_RX_QUEUES)
+			break;
 		if (priv->rx_irq[i] == 0)
 			continue;
 
@@ -3521,6 +3523,8 @@ static int stmmac_request_irq_multi_msi(struct net_device *dev)
 
 	/* Request Tx MSI irq */
 	for (i = 0; i < priv->plat->tx_queues_to_use; i++) {
+		if (i > MTL_MAX_TX_QUEUES)
+			break;
 		if (priv->tx_irq[i] == 0)
 			continue;
 
-- 
2.29.2

