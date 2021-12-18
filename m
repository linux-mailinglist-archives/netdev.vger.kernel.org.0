Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ABCC3479E5B
	for <lists+netdev@lfdr.de>; Sun, 19 Dec 2021 00:56:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235209AbhLRXyu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 18 Dec 2021 18:54:50 -0500
Received: from o1.ptr2625.egauge.net ([167.89.112.53]:25742 "EHLO
        o1.ptr2625.egauge.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234970AbhLRXy0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 18 Dec 2021 18:54:26 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=egauge.net;
        h=from:subject:in-reply-to:references:mime-version:to:cc:
        content-transfer-encoding:content-type;
        s=sgd; bh=jRNhAennxhSOZdi9qsIRPJJ4YYwbnqaPLGNJtjqVSho=;
        b=uvgzfNW/cHH+zlnbyfof8acKjkqPEySKkSdHlxbm5FTSDMUpodiFhwgkT4O7CDKrH6nI
        pWf2ph3QvPV593hi8G4SaqBwjbai5uW2C45v2YSaBMhJYtxSQxrilZoJitiUxX7+J1B6rG
        Uidm0J8lXj3WpTtAy8MAmA17C87ZJWzOsGZNFsZ929HCywalkXbopv8iWvckPKFyIr+xuw
        sBADbwclF3cVuU+wzAbHrklqNq5VFijViUPXJEAFDLU+/RdJtwF/rOqM0NH5+hFeRNtZiF
        vzq4E6ASWhl98ke6r89Ni5MbhUmYY93R9BaPMAGAo/B+o2GZ/TaVSBcHF0qwqdgw==
Received: by filterdrecv-656998cfdd-5st9z with SMTP id filterdrecv-656998cfdd-5st9z-1-61BE74A9-8
        2021-12-18 23:54:17.245944614 +0000 UTC m=+7604801.208387376
Received: from pearl.egauge.net (unknown)
        by geopod-ismtpd-6-0 (SG)
        with ESMTP
        id DVHNYCnNSJKWCPObHJ9w1Q
        Sat, 18 Dec 2021 23:54:17.085 +0000 (UTC)
Received: by pearl.egauge.net (Postfix, from userid 1000)
        id D290970144A; Sat, 18 Dec 2021 16:54:15 -0700 (MST)
From:   David Mosberger-Tang <davidm@egauge.net>
Subject: [PATCH 20/23] wilc1000: eliminate "max_size_over" variable in
 fill_vmm_table
Date:   Sat, 18 Dec 2021 23:54:17 +0000 (UTC)
Message-Id: <20211218235404.3963475-21-davidm@egauge.net>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211218235404.3963475-1-davidm@egauge.net>
References: <20211218235404.3963475-1-davidm@egauge.net>
MIME-Version: 1.0
X-SG-EID: =?us-ascii?Q?+kMxBqj35EdRUKoy8diX1j4AXmPtd302oan+iXZuF8m2Nw4HRW2irNspffT=2Fkh?=
 =?us-ascii?Q?ET6RJF6+Prbl0h=2FEtF1rRLvP5YoI1SZSYpzAPoR?=
 =?us-ascii?Q?7eME5H12K8x8BE2v0SzM9CHFoNuHjXtQfe0MZ7r?=
 =?us-ascii?Q?nuDn4joPDIcXw5mMeMKPXpUrEczzJfUNK4XEV25?=
 =?us-ascii?Q?XWIpeCkrP0mo4sMjaxuzUkp7oCPqbA1qGvimWwV?=
 =?us-ascii?Q?O4H+8u8DR0oOPz5nbdIgjbdASGcAuTMEw5PARb?=
To:     Ajay Singh <ajay.kathat@microchip.com>
Cc:     Claudiu Beznea <claudiu.beznea@microchip.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        David Mosberger-Tang <davidm@egauge.net>
X-Entity-ID: Xg4JGAcGrJFIz2kDG9eoaQ==
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=us-ascii
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This makes the code tighter and easier to understand.

Signed-off-by: David Mosberger-Tang <davidm@egauge.net>
---
 drivers/net/wireless/microchip/wilc1000/wlan.c | 18 +++++++-----------
 1 file changed, 7 insertions(+), 11 deletions(-)

diff --git a/drivers/net/wireless/microchip/wilc1000/wlan.c b/drivers/net/wireless/microchip/wilc1000/wlan.c
index 8652ec9f6d9c8..88a981b00bda2 100644
--- a/drivers/net/wireless/microchip/wilc1000/wlan.c
+++ b/drivers/net/wireless/microchip/wilc1000/wlan.c
@@ -635,7 +635,7 @@ static int fill_vmm_table(const struct wilc *wilc,
 	u32 sum;
 	u8 ac_preserve_ratio[NQUEUES] = {1, 1, 1, 1};
 	u8 *num_pkts_to_add;
-	bool max_size_over = 0, ac_exist = 0;
+	bool ac_exist = 0;
 	int vmm_sz = 0;
 	struct sk_buff *tqe_q[NQUEUES];
 	struct wilc_skb_tx_cb *tx_cb;
@@ -645,20 +645,17 @@ static int fill_vmm_table(const struct wilc *wilc,
 
 	i = 0;
 	sum = 0;
-	max_size_over = 0;
 	num_pkts_to_add = ac_desired_ratio;
 	do {
 		ac_exist = 0;
-		for (ac = 0; (ac < NQUEUES) && (!max_size_over); ac++) {
+		for (ac = 0; ac < NQUEUES; ac++) {
 			if (!tqe_q[ac])
 				continue;
 
 			ac_exist = 1;
-			for (k = 0; (k < num_pkts_to_add[ac]) &&
-			     (!max_size_over) && tqe_q[ac]; k++) {
+			for (k = 0; (k < num_pkts_to_add[ac]) && tqe_q[ac]; k++) {
 				if (i >= (WILC_VMM_TBL_SIZE - 1)) {
-					max_size_over = 1;
-					break;
+					goto out;
 				}
 
 				tx_cb = WILC_SKB_TX_CB(tqe_q[ac]);
@@ -673,8 +670,7 @@ static int fill_vmm_table(const struct wilc *wilc,
 				vmm_sz = ALIGN(vmm_sz, 4);
 
 				if ((sum + vmm_sz) > WILC_TX_BUFF_SIZE) {
-					max_size_over = 1;
-					break;
+					goto out;
 				}
 				vmm_table[i] = vmm_sz / 4;
 				if (tx_cb->type == WILC_CFG_PKT)
@@ -690,8 +686,8 @@ static int fill_vmm_table(const struct wilc *wilc,
 			}
 		}
 		num_pkts_to_add = ac_preserve_ratio;
-	} while (!max_size_over && ac_exist);
-
+	} while (ac_exist);
+out:
 	vmm_table[i] = 0x0;
 	return i;
 }
-- 
2.25.1

