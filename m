Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 649683BD047
	for <lists+netdev@lfdr.de>; Tue,  6 Jul 2021 13:34:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232710AbhGFLd0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Jul 2021 07:33:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:42668 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235413AbhGFLaC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 6 Jul 2021 07:30:02 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5779161D92;
        Tue,  6 Jul 2021 11:20:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625570460;
        bh=QMZEI62nhCdbNul2Cz9sgO1rwB/vHYVKqfZ+XxwfKW8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=arQn3IzDZ79EP6cyfRc0nIOW4mCdJo+2frpjR7S+hg/iH3135h9rupPnagPNQfSOD
         Gp7jPv9XIodUNHKZjtrq6ksFtaMcjjVm68lbTAmQ2uvXCSxswGNfiEehlF6vtD8PpR
         f8hX6jxgpztNMUl3T4cxdgLEFp/8tPfbtffHUoh/IcmU0FQVDHmuQb+waPuDqJLS98
         Bdak+nfpzowVVyx4nN+spcIE1fxRJp+aHLuRbkOiekklA8Xq9U3MTwNkdS27Gzpjtg
         yJ+vlzDj0qKOFMtk0YHz82soBmOuVXgo7TlXf9dxdcnjeTIdp+CcnKwV4hmMzHlzGR
         Td5vCMpPaA+Tg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Joakim Zhang <qiangqing.zhang@nxp.com>,
        Frieder Schrempf <frieder.schrempf@kontron.de>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.12 114/160] net: fec: add FEC_QUIRK_HAS_MULTI_QUEUES represents i.MX6SX ENET IP
Date:   Tue,  6 Jul 2021 07:17:40 -0400
Message-Id: <20210706111827.2060499-114-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210706111827.2060499-1-sashal@kernel.org>
References: <20210706111827.2060499-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Joakim Zhang <qiangqing.zhang@nxp.com>

[ Upstream commit 471ff4455d61c9929ae912328859921708e1eafc ]

Frieder Schrempf reported a TX throuthput issue [1], it happens quite often
that the measured bandwidth in TX direction drops from its expected/nominal
value to something like ~50% (for 100M) or ~67% (for 1G) connections.

[1] https://lore.kernel.org/linux-arm-kernel/421cc86c-b66f-b372-32f7-21e59f9a98bc@kontron.de/

The issue becomes clear after digging into it, Net core would select
queues when transmitting packets. Since FEC have not impletemented
ndo_select_queue callback yet, so it will call netdev_pick_tx to select
queues randomly.

For i.MX6SX ENET IP with AVB support, driver default enables this
feature. According to the setting of QOS/RCMRn/DMAnCFG registers, AVB
configured to Credit-based scheme, 50% bandwidth of each queue 1&2.

With below tests let me think more:
1) With FEC_QUIRK_HAS_AVB quirk, can reproduce TX bandwidth fluctuations issue.
2) Without FEC_QUIRK_HAS_AVB quirk, can't reproduce TX bandwidth fluctuations issue.

The related difference with or w/o FEC_QUIRK_HAS_AVB quirk is that, whether we
program FTYPE field of TxBD or not. As I describe above, AVB feature is
enabled by default. With FEC_QUIRK_HAS_AVB quirk, frames in queue 0
marked as non-AVB, and frames in queue 1&2 marked as AVB Class A&B. It's
unreasonable if frames in queue 1&2 are not required to be time-sensitive.
So when Net core select tx queues ramdomly, Credit-based scheme would work
and lead to TX bandwidth fluctuated. On the other hand, w/o
FEC_QUIRK_HAS_AVB quirk, frames in queue 1&2 are all marked as non-AVB, so
Credit-based scheme would not work.

Till now, how can we fix this TX throughput issue? Yes, please remove
FEC_QUIRK_HAS_AVB quirk if you suffer it from time-nonsensitive networking.
However, this quirk is used to indicate i.MX6SX, other setting depends
on it. So this patch adds a new quirk FEC_QUIRK_HAS_MULTI_QUEUES to
represent i.MX6SX, it is safe for us remove FEC_QUIRK_HAS_AVB quirk
now.

FEC_QUIRK_HAS_AVB quirk is set by default in the driver, and users may
not know much about driver details, they would waste effort to find the
root cause, that is not we want. The following patch is a implementation
to fix it and users don't need to modify the driver.

Tested-by: Frieder Schrempf <frieder.schrempf@kontron.de>
Reported-by: Frieder Schrempf <frieder.schrempf@kontron.de>
Signed-off-by: Joakim Zhang <qiangqing.zhang@nxp.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/freescale/fec.h      |  5 +++++
 drivers/net/ethernet/freescale/fec_main.c | 11 ++++++-----
 2 files changed, 11 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/freescale/fec.h b/drivers/net/ethernet/freescale/fec.h
index 0602d5d5d2ee..2e002e4b4b4a 100644
--- a/drivers/net/ethernet/freescale/fec.h
+++ b/drivers/net/ethernet/freescale/fec.h
@@ -467,6 +467,11 @@ struct bufdesc_ex {
  */
 #define FEC_QUIRK_NO_HARD_RESET		(1 << 18)
 
+/* i.MX6SX ENET IP supports multiple queues (3 queues), use this quirk to
+ * represents this ENET IP.
+ */
+#define FEC_QUIRK_HAS_MULTI_QUEUES	(1 << 19)
+
 struct bufdesc_prop {
 	int qid;
 	/* Address of Rx and Tx buffers */
diff --git a/drivers/net/ethernet/freescale/fec_main.c b/drivers/net/ethernet/freescale/fec_main.c
index 89393fbc726f..15c9cffa8735 100644
--- a/drivers/net/ethernet/freescale/fec_main.c
+++ b/drivers/net/ethernet/freescale/fec_main.c
@@ -121,7 +121,7 @@ static const struct fec_devinfo fec_imx6x_info = {
 		  FEC_QUIRK_HAS_VLAN | FEC_QUIRK_HAS_AVB |
 		  FEC_QUIRK_ERR007885 | FEC_QUIRK_BUG_CAPTURE |
 		  FEC_QUIRK_HAS_RACC | FEC_QUIRK_HAS_COALESCE |
-		  FEC_QUIRK_CLEAR_SETUP_MII,
+		  FEC_QUIRK_CLEAR_SETUP_MII | FEC_QUIRK_HAS_MULTI_QUEUES,
 };
 
 static const struct fec_devinfo fec_imx6ul_info = {
@@ -420,6 +420,7 @@ fec_enet_txq_submit_frag_skb(struct fec_enet_priv_tx_q *txq,
 				estatus |= FEC_TX_BD_FTYPE(txq->bd.qid);
 			if (skb->ip_summed == CHECKSUM_PARTIAL)
 				estatus |= BD_ENET_TX_PINS | BD_ENET_TX_IINS;
+
 			ebdp->cbd_bdu = 0;
 			ebdp->cbd_esc = cpu_to_fec32(estatus);
 		}
@@ -953,7 +954,7 @@ fec_restart(struct net_device *ndev)
 	 * For i.MX6SX SOC, enet use AXI bus, we use disable MAC
 	 * instead of reset MAC itself.
 	 */
-	if (fep->quirks & FEC_QUIRK_HAS_AVB ||
+	if (fep->quirks & FEC_QUIRK_HAS_MULTI_QUEUES ||
 	    ((fep->quirks & FEC_QUIRK_NO_HARD_RESET) && fep->link)) {
 		writel(0, fep->hwp + FEC_ECNTRL);
 	} else {
@@ -1164,7 +1165,7 @@ fec_stop(struct net_device *ndev)
 	 * instead of reset MAC itself.
 	 */
 	if (!(fep->wol_flag & FEC_WOL_FLAG_SLEEP_ON)) {
-		if (fep->quirks & FEC_QUIRK_HAS_AVB) {
+		if (fep->quirks & FEC_QUIRK_HAS_MULTI_QUEUES) {
 			writel(0, fep->hwp + FEC_ECNTRL);
 		} else {
 			writel(1, fep->hwp + FEC_ECNTRL);
@@ -2559,7 +2560,7 @@ static void fec_enet_itr_coal_set(struct net_device *ndev)
 
 	writel(tx_itr, fep->hwp + FEC_TXIC0);
 	writel(rx_itr, fep->hwp + FEC_RXIC0);
-	if (fep->quirks & FEC_QUIRK_HAS_AVB) {
+	if (fep->quirks & FEC_QUIRK_HAS_MULTI_QUEUES) {
 		writel(tx_itr, fep->hwp + FEC_TXIC1);
 		writel(rx_itr, fep->hwp + FEC_RXIC1);
 		writel(tx_itr, fep->hwp + FEC_TXIC2);
@@ -3356,7 +3357,7 @@ static int fec_enet_init(struct net_device *ndev)
 		fep->csum_flags |= FLAG_RX_CSUM_ENABLED;
 	}
 
-	if (fep->quirks & FEC_QUIRK_HAS_AVB) {
+	if (fep->quirks & FEC_QUIRK_HAS_MULTI_QUEUES) {
 		fep->tx_align = 0;
 		fep->rx_align = 0x3f;
 	}
-- 
2.30.2

