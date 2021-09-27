Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B69994191F0
	for <lists+netdev@lfdr.de>; Mon, 27 Sep 2021 12:03:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233773AbhI0KFW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Sep 2021 06:05:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:56918 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233703AbhI0KFV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 27 Sep 2021 06:05:21 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3C5A560F6C;
        Mon, 27 Sep 2021 10:03:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1632737021;
        bh=rdXEK8Ftq/XptLnhBL3SXrY8D4WMnjNMPHUHRwbRgVY=;
        h=From:To:Cc:Subject:Date:From;
        b=lRoH0ZoBzJ+dFVQrfB+JzPVFwMBUuxUbjt9Ws5BWiRAAHSlQIqwV36x2NyaH1uOQr
         3VS28YFgaFOugTBeM9bR8I2dXzFhuEBi4KbEfVhzh1U0SpTVRCqqGQQ7xvGoC1z6tA
         fyDq/m8eohx7JtqGN6G5OnHM52e1ecNsQopFexcqFUULQEsQ/+qxOkDISnB5qN2a4y
         +iH8uBehRs5HnZ2C+dZlwkQcYwr/k3OzLP84PGKqpKxjze1Mr0VyK0DzWOO7q4cGfv
         XtmuQCDwBQpGnr/gbD9vy+WoOZ10TlZw4HoE1M3Uc6OOQiupHFMVLYSohLCtHJQHmU
         givK5WhsYGcbQ==
From:   Arnd Bergmann <arnd@kernel.org>
To:     Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Voon Weifeng <weifeng.voon@intel.com>,
        Ong Boon Leong <boon.leong.ong@intel.com>
Cc:     Arnd Bergmann <arnd@arndb.de>, kernel test robot <lkp@intel.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] [RESEND] net: stmmac: fix gcc-10 -Wrestrict warning
Date:   Mon, 27 Sep 2021 12:02:44 +0200
Message-Id: <20210927100336.1334028-1-arnd@kernel.org>
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
Link: https://lore.kernel.org/all/20210421134743.3260921-1-arnd@kernel.org/
Reported-by: kernel test robot <lkp@intel.com>
Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
index 553c4403258a..640c0ffdff3d 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -3502,6 +3502,8 @@ static int stmmac_request_irq_multi_msi(struct net_device *dev)
 
 	/* Request Rx MSI irq */
 	for (i = 0; i < priv->plat->rx_queues_to_use; i++) {
+		if (i > MTL_MAX_RX_QUEUES)
+			break;
 		if (priv->rx_irq[i] == 0)
 			continue;
 
@@ -3525,6 +3527,8 @@ static int stmmac_request_irq_multi_msi(struct net_device *dev)
 
 	/* Request Tx MSI irq */
 	for (i = 0; i < priv->plat->tx_queues_to_use; i++) {
+		if (i > MTL_MAX_TX_QUEUES)
+			break;
 		if (priv->tx_irq[i] == 0)
 			continue;
 
-- 
2.29.2

