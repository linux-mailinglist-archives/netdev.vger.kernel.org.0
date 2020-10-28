Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 967CC29D8E7
	for <lists+netdev@lfdr.de>; Wed, 28 Oct 2020 23:40:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389090AbgJ1Wkq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Oct 2020 18:40:46 -0400
Received: from inva021.nxp.com ([92.121.34.21]:38778 "EHLO inva021.nxp.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389070AbgJ1Wko (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 28 Oct 2020 18:40:44 -0400
Received: from inva021.nxp.com (localhost [127.0.0.1])
        by inva021.eu-rdc02.nxp.com (Postfix) with ESMTP id B5FC62001D0;
        Wed, 28 Oct 2020 17:41:10 +0100 (CET)
Received: from inva024.eu-rdc02.nxp.com (inva024.eu-rdc02.nxp.com [134.27.226.22])
        by inva021.eu-rdc02.nxp.com (Postfix) with ESMTP id A95772001B9;
        Wed, 28 Oct 2020 17:41:10 +0100 (CET)
Received: from fsr-ub1464-019.ea.freescale.net (fsr-ub1464-019.ea.freescale.net [10.171.81.207])
        by inva024.eu-rdc02.nxp.com (Postfix) with ESMTP id 659B32030E;
        Wed, 28 Oct 2020 17:41:10 +0100 (CET)
From:   Camelia Groza <camelia.groza@nxp.com>
To:     willemdebruijn.kernel@gmail.com, madalin.bucur@oss.nxp.com,
        davem@davemloft.net, kuba@kernel.org
Cc:     netdev@vger.kernel.org, Camelia Groza <camelia.groza@nxp.com>
Subject: [PATCH net v2 1/2] dpaa_eth: update the buffer layout for non-A050385 erratum scenarios
Date:   Wed, 28 Oct 2020 18:40:59 +0200
Message-Id: <505ebfdd659456e04eba067839eccf14e485005d.1603899392.git.camelia.groza@nxp.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <cover.1603899392.git.camelia.groza@nxp.com>
References: <cover.1603899392.git.camelia.groza@nxp.com>
In-Reply-To: <cover.1603899392.git.camelia.groza@nxp.com>
References: <cover.1603899392.git.camelia.groza@nxp.com>
X-Virus-Scanned: ClamAV using ClamSMTP
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Impose a large RX private data area only when the A050385 erratum is
present on the hardware. A smaller buffer size is sufficient in all
other scenarios. This enables a wider range of linear frame sizes
in non-erratum scenarios

Fixes: 3c68b8fffb48 ("dpaa_eth: FMan erratum A050385 workaround")
Signed-off-by: Camelia Groza <camelia.groza@nxp.com>
---
 drivers/net/ethernet/freescale/dpaa/dpaa_eth.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c b/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c
index 06cc863..1aac0b6 100644
--- a/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c
+++ b/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c
@@ -175,8 +175,10 @@
 #define DPAA_TIME_STAMP_SIZE 8
 #define DPAA_HASH_RESULTS_SIZE 8
 #ifdef CONFIG_DPAA_ERRATUM_A050385
-#define DPAA_RX_PRIV_DATA_SIZE (DPAA_A050385_ALIGN - (DPAA_PARSE_RESULTS_SIZE\
-	 + DPAA_TIME_STAMP_SIZE + DPAA_HASH_RESULTS_SIZE))
+#define DPAA_RX_PRIV_DATA_SIZE (fman_has_errata_a050385() ? \
+			(DPAA_A050385_ALIGN - (DPAA_PARSE_RESULTS_SIZE\
+			 + DPAA_TIME_STAMP_SIZE + DPAA_HASH_RESULTS_SIZE)) : \
+			(DPAA_TX_PRIV_DATA_SIZE + dpaa_rx_extra_headroom))
 #else
 #define DPAA_RX_PRIV_DATA_SIZE	(u16)(DPAA_TX_PRIV_DATA_SIZE + \
 					dpaa_rx_extra_headroom)
-- 
1.9.1

