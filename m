Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 85F4F2A3315
	for <lists+netdev@lfdr.de>; Mon,  2 Nov 2020 19:35:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726579AbgKBSep (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Nov 2020 13:34:45 -0500
Received: from inva021.nxp.com ([92.121.34.21]:43044 "EHLO inva021.nxp.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725801AbgKBSen (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 2 Nov 2020 13:34:43 -0500
Received: from inva021.nxp.com (localhost [127.0.0.1])
        by inva021.eu-rdc02.nxp.com (Postfix) with ESMTP id 391B420022A;
        Mon,  2 Nov 2020 19:34:41 +0100 (CET)
Received: from inva024.eu-rdc02.nxp.com (inva024.eu-rdc02.nxp.com [134.27.226.22])
        by inva021.eu-rdc02.nxp.com (Postfix) with ESMTP id 2CEF2200222;
        Mon,  2 Nov 2020 19:34:41 +0100 (CET)
Received: from fsr-ub1464-019.ea.freescale.net (fsr-ub1464-019.ea.freescale.net [10.171.81.207])
        by inva024.eu-rdc02.nxp.com (Postfix) with ESMTP id D333620306;
        Mon,  2 Nov 2020 19:34:40 +0100 (CET)
From:   Camelia Groza <camelia.groza@nxp.com>
To:     willemdebruijn.kernel@gmail.com, madalin.bucur@oss.nxp.com,
        davem@davemloft.net, kuba@kernel.org
Cc:     netdev@vger.kernel.org, Camelia Groza <camelia.groza@nxp.com>
Subject: [PATCH net v3 1/2] dpaa_eth: update the buffer layout for non-A050385 erratum scenarios
Date:   Mon,  2 Nov 2020 20:34:35 +0200
Message-Id: <e32d12d2149ac97990027a90d1d8faea6d1e26b6.1604339942.git.camelia.groza@nxp.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <cover.1604339942.git.camelia.groza@nxp.com>
References: <cover.1604339942.git.camelia.groza@nxp.com>
In-Reply-To: <cover.1604339942.git.camelia.groza@nxp.com>
References: <cover.1604339942.git.camelia.groza@nxp.com>
X-Virus-Scanned: ClamAV using ClamSMTP
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Impose a larger RX private data area only when the A050385 erratum is
present on the hardware. A smaller buffer size is sufficient in all
other scenarios. This enables a wider range of linear Jumbo frame
sizes in non-erratum scenarios, instead of turning to multi
buffer Scatter/Gather frames. The maximum linear frame size is
increased by 128 bytes for non-erratum arm64 platforms.

Cleanup the hardware annotations header defines in the process.

Fixes: 3c68b8fffb48 ("dpaa_eth: FMan erratum A050385 workaround")
Signed-off-by: Camelia Groza <camelia.groza@nxp.com>
---
Changes in v3:
- refactor defines for clarity
- add more details on the user impact

 drivers/net/ethernet/freescale/dpaa/dpaa_eth.c | 16 ++++++++++------
 1 file changed, 10 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c b/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c
index 06cc863..3eaa5f2 100644
--- a/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c
+++ b/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c
@@ -174,12 +174,17 @@
 #define DPAA_PARSE_RESULTS_SIZE sizeof(struct fman_prs_result)
 #define DPAA_TIME_STAMP_SIZE 8
 #define DPAA_HASH_RESULTS_SIZE 8
+#define DPAA_HWA_SIZE (DPAA_PARSE_RESULTS_SIZE + DPAA_TIME_STAMP_SIZE \
+		       + DPAA_HASH_RESULTS_SIZE)
+#define DPAA_RX_PRIV_DATA_DEFAULT_SIZE (DPAA_TX_PRIV_DATA_SIZE + \
+					dpaa_rx_extra_headroom)
 #ifdef CONFIG_DPAA_ERRATUM_A050385
-#define DPAA_RX_PRIV_DATA_SIZE (DPAA_A050385_ALIGN - (DPAA_PARSE_RESULTS_SIZE\
-	 + DPAA_TIME_STAMP_SIZE + DPAA_HASH_RESULTS_SIZE))
+#define DPAA_RX_PRIV_DATA_A050385_SIZE (DPAA_A050385_ALIGN - DPAA_HWA_SIZE)
+#define DPAA_RX_PRIV_DATA_SIZE (fman_has_errata_a050385() ? \
+				DPAA_RX_PRIV_DATA_A050385_SIZE : \
+				DPAA_RX_PRIV_DATA_DEFAULT_SIZE)
 #else
-#define DPAA_RX_PRIV_DATA_SIZE	(u16)(DPAA_TX_PRIV_DATA_SIZE + \
-					dpaa_rx_extra_headroom)
+#define DPAA_RX_PRIV_DATA_SIZE DPAA_RX_PRIV_DATA_DEFAULT_SIZE
 #endif

 #define DPAA_ETH_PCD_RXQ_NUM	128
@@ -2854,8 +2859,7 @@ static inline u16 dpaa_get_headroom(struct dpaa_buffer_layout *bl)
 	 *
 	 * Also make sure the headroom is a multiple of data_align bytes
 	 */
-	headroom = (u16)(bl->priv_data_size + DPAA_PARSE_RESULTS_SIZE +
-		DPAA_TIME_STAMP_SIZE + DPAA_HASH_RESULTS_SIZE);
+	headroom = (u16)(bl->priv_data_size + DPAA_HWA_SIZE);

 	return ALIGN(headroom, DPAA_FD_DATA_ALIGNMENT);
 }
--
1.9.1

